FROM frolvlad/alpine-oraclejdk8

MAINTAINER tuojin@chunmi.com

RUN apk add --update bash

# Set environment
ENV TOMCAT_MAJOR=8 \
    TOMCAT_VERSION=8.5.20 \
    TOMCAT_HOME=/opt/tomcat \
    CATALINA_HOME=/opt/tomcat \
    CATALINA_OUT=/dev/null

ENV PATH $PATH:$CATALINA_HOME/bin

RUN mkdir -p "${TOMCAT_HOME}"

#RUN apk add bash-completion
RUN cd /tmp
RUN apk upgrade --update && \
    apk add --update curl && \
    curl -jksSL -o apache-tomcat.tar.gz http://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar  -zxvf apache-tomcat.tar.gz && \
    cp -r  apache-tomcat-${TOMCAT_VERSION}/* /opt/tomcat/ && \
    rm -rf ${TOMCAT_HOME}/webapps/* && \
    apk del curl && \
    rm -rf /tmp/* /var/cache/apk/*

#webapps Root
RUN mkdir -p ${TOMCAT_HOME}/webapps/ROOT

#upgrade server.xml
COPY server.xml ${TOMCAT_HOME}/conf/server.xml

RUN chmod +x ${TOMCAT_HOME}/bin/*.sh

# Launch Tomcat on startup
EXPOSE 8080
CMD ["catalina.sh", "run"]
