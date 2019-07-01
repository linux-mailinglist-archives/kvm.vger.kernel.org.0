Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817DC3770D
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 16:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbfFFOob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 10:44:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58034 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727309AbfFFOob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 10:44:31 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 30D877CB95;
        Thu,  6 Jun 2019 14:44:31 +0000 (UTC)
Received: from localhost (dhcp-192-191.str.redhat.com [10.33.192.191])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B6D285F7DE;
        Thu,  6 Jun 2019 14:44:26 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, libvir-list@redhat.com,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH RFC 1/1] allow to specify additional config data
Date:   Thu,  6 Jun 2019 16:44:17 +0200
Message-Id: <20190606144417.1824-2-cohuck@redhat.com>
In-Reply-To: <20190606144417.1824-1-cohuck@redhat.com>
References: <20190606144417.1824-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 06 Jun 2019 14:44:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a rough implementation for vfio-ap.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 mdevctl.libexec | 25 ++++++++++++++++++++++
 mdevctl.sbin    | 56 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/mdevctl.libexec b/mdevctl.libexec
index 804166b5086d..cc0546142924 100755
--- a/mdevctl.libexec
+++ b/mdevctl.libexec
@@ -54,6 +54,19 @@ wait_for_supported_types () {
     fi
 }
 
+# configure vfio-ap devices <config entry> <matrix attribute>
+configure_ap_devices() {
+    list="`echo "${config[$1]}" | sed 's/,/ /'`"
+    [ -z "$list" ] && return
+    for a in $list; do
+        echo "$a" > "$supported_types/${config[mdev_type]}/devices/$uuid/$2"
+        if [ $? -ne 0 ]; then
+            echo "Error writing '$a' to '$uuid/$2'" >&2
+            exit 1
+        fi
+    done
+}
+
 case ${1} in
     start-mdev|stop-mdev)
         if [ $# -ne 2 ]; then
@@ -148,6 +161,18 @@ case ${cmd} in
             echo "Error creating mdev type ${config[mdev_type]} on $parent" >&2
             exit 1
         fi
+
+        # some types may specify additional config data
+        case ${config[mdev_type]} in
+            vfio_ap-passthrough)
+                configure_ap_devices ap_adapters assign_adapter
+                configure_ap_devices ap_domains assign_domain
+                configure_ap_devices ap_control_domains assign_control_domain
+                # TODO: is assigning idempotent? Should we unwind on error?
+                ;;
+            *)
+                ;;
+        esac
         ;;
 
     add-mdev)
diff --git a/mdevctl.sbin b/mdevctl.sbin
index 276cf6ddc817..eb5ee0091879 100755
--- a/mdevctl.sbin
+++ b/mdevctl.sbin
@@ -33,6 +33,8 @@ usage() {
     echo "set-start <mdev UUID>: change mdev start policy, if no option specified," >&2
     echo "                       system default policy is used" >&2
     echo "                       options: [--auto] [--manual]" >&2
+    echo "set-additional-config <mdev UUID> {fmt...}: supply additional configuration" >&2
+    echo "show-additional-config-format <mdev UUiD>:  prints the format expected by the device" >&2
     echo "list-all: list all possible mdev types supported in the system" >&2
     echo "list-available: list all mdev types currently available" >&2
     echo "list-mdevs: list currently configured mdevs" >&2
@@ -48,7 +50,7 @@ while (($# > 0)); do
         --manual)
             config[start]=manual
             ;;
-        start-mdev|stop-mdev|remove-mdev|set-start)
+        start-mdev|stop-mdev|remove-mdev|set-start|show-additional-config-format)
             [ $# -ne 2 ] && usage
             cmd=$1
             uuid=$2
@@ -67,6 +69,14 @@ while (($# > 0)); do
             cmd=$1
             break
             ;;
+        set-additional-config)
+            [ $# -le 2 ] && usage
+            cmd=$1
+            uuid=$2
+            shift 2
+            addtl_config="$*"
+            break
+            ;;
         *)
             usage
             ;;
@@ -114,6 +124,50 @@ case ${cmd} in
         fi
         ;;
 
+    set-additional-config)
+        file=$(find $persist_base -name $uuid -type f)
+        if [ -w "$file" ]; then
+            read_config "$file"
+            if [ ${config[start]} == "auto" ]; then
+                systemctl stop mdev@$uuid.service
+            fi
+            # FIXME: validate input!
+            for i in $addtl_config; do
+                key="`echo "$i" | cut -d '=' -f 1`"
+                value="`echo "$i" | cut -d '=' -f 2-`"
+                if grep -q ^$key $file; then
+                    if [ -z "$value" ]; then
+                        sed -i "s/^$key=.*//g" $file
+                    else
+                        sed -i "s/^$key=.*/$key=$value/g" $file
+                    fi
+                else
+                    echo "$i" >> "$file"
+                fi
+            done
+            if [ ${config[start]} == "auto" ]; then
+                systemctl start mdev@$uuid.service
+            fi
+        else
+            exit 1
+        fi
+        ;;
+
+    show-additional-config-format)
+        file=$(find $persist_base -name $uuid -type f)
+        read_config "$file"
+        case ${config[mdev_type]} in
+            vfio_ap-passthrough)
+                echo "ap_adapters=<comma-separated list of adapters>"
+                echo "ap_domains=<comma-separated list of domains>"
+                echo "ap_control_domains=<comma-separated list of control domains>"
+                ;;
+            *)
+                echo "no additional configuration defined"
+                ;;
+        esac
+        ;;
+
     list-mdevs)
         for mdev in $(find $mdev_base/ -maxdepth 1 -mindepth 1 -type l); do
             uuid=$(basename $mdev)
-- 
2.20.1

