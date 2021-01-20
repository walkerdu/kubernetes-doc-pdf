#!/bin/bash

set -x

PDF_DIR=PDFs

sed -i -e "s/’/\'/g" -e "s/–/-/g" -e "s/“/\"/g" -e "s/”/\"/g" $1.html

docker run -it --name weasy -d dohsimpson/weasyprint:51
docker cp codeblock_wrap.css weasy:/tmp/codeblock_wrap.css
docker cp msyh.ttf weasy:/usr/share/fonts/msyh.ttf
docker cp msyhbd.ttf weasy:/usr/share/fonts/msyhbd.ttf
docker exec -i weasy fc-cache -fv 
docker exec -i weasy fc-list
docker exec -i weasy weasyprint -v -f pdf -s /tmp/codeblock_wrap.css -e utf-8 '-' '-' >| "$PDF_DIR/$1.pdf" <$1.html
docker stop weasy
docker rm -f weasy
