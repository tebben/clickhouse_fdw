FROM postgis/postgis:12-3.0-alpine as build

ENV VERSION 0.2.1

RUN apk --no-cache add curl python3 gcc g++ make musl-dev openssl-dev cmake curl-dev util-linux-dev;\
    chmod a+rwx /usr/local/lib/postgresql && \
    chmod a+rwx /usr/local/share/postgresql/extension && \
    mkdir -p /usr/local/share/doc/postgresql/contrib && \
    chmod a+rwx /usr/local/share/doc/postgresql/contrib

RUN wget -O fdw.zip -c https://github.com/tebben/clickhouse_fdw/archive/v$VERSION.zip && \
    unzip fdw.zip && \
    cd clickhouse_fdw-$VERSION && mkdir build && cd build && cmake .. && make && DESTDIR=/tmp/data make install

FROM postgis/postgis:12-3.0-alpine as install
RUN apk --no-cache add libcurl 
COPY --from=build /tmp/data/ /
