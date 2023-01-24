Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678CC6797AB
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbjAXMUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbjAXMUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:20:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B60F45238
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AlU/dS+EFbFlCUBnODvFmzawRRsWgYsKi/b9n8/rZvo=;
        b=K9exSobAaGsWvq/Ie+PTmCNVhMQOvGafEiUEFZ2ynNeQG2g6H1QyBi5e9Sc/rJyZe6HwX5
        aCQzZuy8R2T39j3XlZ59Dc09m1q1GPea9N0Cyn6hRRGFSUFsLAa+KuqQgqutsSVSWGGHYQ
        XmJZuQ2T07cmhP4cYhQvU6YF9UGPmdg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-NX5fJbwnOdOQQ4OTeWpcmA-1; Tue, 24 Jan 2023 07:19:49 -0500
X-MC-Unique: NX5fJbwnOdOQQ4OTeWpcmA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 385943C10224;
        Tue, 24 Jan 2023 12:19:48 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D25D40A3601;
        Tue, 24 Jan 2023 12:19:47 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 8929121E6A22; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, kraxel@redhat.com, kwolf@redhat.com,
        hreitz@redhat.com, marcandre.lureau@redhat.com,
        dgilbert@redhat.com, mst@redhat.com, imammedo@redhat.com,
        ani@anisinha.ca, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        philmd@linaro.org, wangyanan55@huawei.com, jasowang@redhat.com,
        jiri@resnulli.us, berrange@redhat.com, thuth@redhat.com,
        quintela@redhat.com, stefanb@linux.vnet.ibm.com,
        stefanha@redhat.com, kvm@vger.kernel.org, qemu-block@nongnu.org
Subject: [PATCH 03/32] char: Move HMP commands from monitor/ to chardev/
Date:   Tue, 24 Jan 2023 13:19:17 +0100
Message-Id: <20230124121946.1139465-4-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This moves these commands from MAINTAINERS sections "Human
Monitor (HMP)" and "QMP" to "Character device backends".

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 chardev/char-hmp-cmds.c | 220 ++++++++++++++++++++++++++++++++++++++++
 monitor/hmp-cmds.c      | 123 ----------------------
 monitor/misc.c          |  78 --------------
 chardev/meson.build     |   6 +-
 4 files changed, 225 insertions(+), 202 deletions(-)
 create mode 100644 chardev/char-hmp-cmds.c

diff --git a/chardev/char-hmp-cmds.c b/chardev/char-hmp-cmds.c
new file mode 100644
index 0000000000..287c2b1bcd
--- /dev/null
+++ b/chardev/char-hmp-cmds.c
@@ -0,0 +1,220 @@
+/*
+ * HMP commands related to character devices
+ *
+ * Copyright IBM, Corp. 2011
+ *
+ * Authors:
+ *  Anthony Liguori   <aliguori@us.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ * Contributions after 2012-01-13 are licensed under the terms of the
+ * GNU GPL, version 2 or (at your option) any later version.
+ */
+
+#include "qemu/osdep.h"
+#include "chardev/char.h"
+#include "monitor/hmp.h"
+#include "monitor/monitor.h"
+#include "qapi/error.h"
+#include "qapi/qapi-commands-char.h"
+#include "qapi/qmp/qdict.h"
+#include "qemu/config-file.h"
+#include "qemu/option.h"
+
+void hmp_info_chardev(Monitor *mon, const QDict *qdict)
+{
+    ChardevInfoList *char_info, *info;
+
+    char_info = qmp_query_chardev(NULL);
+    for (info = char_info; info; info = info->next) {
+        monitor_printf(mon, "%s: filename=%s\n", info->value->label,
+                                                 info->value->filename);
+    }
+
+    qapi_free_ChardevInfoList(char_info);
+}
+
+void hmp_ringbuf_write(Monitor *mon, const QDict *qdict)
+{
+    const char *chardev = qdict_get_str(qdict, "device");
+    const char *data = qdict_get_str(qdict, "data");
+    Error *err = NULL;
+
+    qmp_ringbuf_write(chardev, data, false, 0, &err);
+
+    hmp_handle_error(mon, err);
+}
+
+void hmp_ringbuf_read(Monitor *mon, const QDict *qdict)
+{
+    uint32_t size = qdict_get_int(qdict, "size");
+    const char *chardev = qdict_get_str(qdict, "device");
+    char *data;
+    Error *err = NULL;
+    int i;
+
+    data = qmp_ringbuf_read(chardev, size, false, 0, &err);
+    if (hmp_handle_error(mon, err)) {
+        return;
+    }
+
+    for (i = 0; data[i]; i++) {
+        unsigned char ch = data[i];
+
+        if (ch == '\\') {
+            monitor_printf(mon, "\\\\");
+        } else if ((ch < 0x20 && ch != '\n' && ch != '\t') || ch == 0x7F) {
+            monitor_printf(mon, "\\u%04X", ch);
+        } else {
+            monitor_printf(mon, "%c", ch);
+        }
+
+    }
+    monitor_printf(mon, "\n");
+    g_free(data);
+}
+
+void hmp_chardev_add(Monitor *mon, const QDict *qdict)
+{
+    const char *args = qdict_get_str(qdict, "args");
+    Error *err = NULL;
+    QemuOpts *opts;
+
+    opts = qemu_opts_parse_noisily(qemu_find_opts("chardev"), args, true);
+    if (opts == NULL) {
+        error_setg(&err, "Parsing chardev args failed");
+    } else {
+        qemu_chr_new_from_opts(opts, NULL, &err);
+        qemu_opts_del(opts);
+    }
+    hmp_handle_error(mon, err);
+}
+
+void hmp_chardev_change(Monitor *mon, const QDict *qdict)
+{
+    const char *args = qdict_get_str(qdict, "args");
+    const char *id;
+    Error *err = NULL;
+    ChardevBackend *backend = NULL;
+    ChardevReturn *ret = NULL;
+    QemuOpts *opts = qemu_opts_parse_noisily(qemu_find_opts("chardev"), args,
+                                             true);
+    if (!opts) {
+        error_setg(&err, "Parsing chardev args failed");
+        goto end;
+    }
+
+    id = qdict_get_str(qdict, "id");
+    if (qemu_opts_id(opts)) {
+        error_setg(&err, "Unexpected 'id' parameter");
+        goto end;
+    }
+
+    backend = qemu_chr_parse_opts(opts, &err);
+    if (!backend) {
+        goto end;
+    }
+
+    ret = qmp_chardev_change(id, backend, &err);
+
+end:
+    qapi_free_ChardevReturn(ret);
+    qapi_free_ChardevBackend(backend);
+    qemu_opts_del(opts);
+    hmp_handle_error(mon, err);
+}
+
+void hmp_chardev_remove(Monitor *mon, const QDict *qdict)
+{
+    Error *local_err = NULL;
+
+    qmp_chardev_remove(qdict_get_str(qdict, "id"), &local_err);
+    hmp_handle_error(mon, local_err);
+}
+
+void hmp_chardev_send_break(Monitor *mon, const QDict *qdict)
+{
+    Error *local_err = NULL;
+
+    qmp_chardev_send_break(qdict_get_str(qdict, "id"), &local_err);
+    hmp_handle_error(mon, local_err);
+}
+
+void chardev_add_completion(ReadLineState *rs, int nb_args, const char *str)
+{
+    size_t len;
+    ChardevBackendInfoList *list, *start;
+
+    if (nb_args != 2) {
+        return;
+    }
+    len = strlen(str);
+    readline_set_completion_index(rs, len);
+
+    start = list = qmp_query_chardev_backends(NULL);
+    while (list) {
+        const char *chr_name = list->value->name;
+
+        if (!strncmp(chr_name, str, len)) {
+            readline_add_completion(rs, chr_name);
+        }
+        list = list->next;
+    }
+    qapi_free_ChardevBackendInfoList(start);
+}
+
+void chardev_remove_completion(ReadLineState *rs, int nb_args, const char *str)
+{
+    size_t len;
+    ChardevInfoList *list, *start;
+
+    if (nb_args != 2) {
+        return;
+    }
+    len = strlen(str);
+    readline_set_completion_index(rs, len);
+
+    start = list = qmp_query_chardev(NULL);
+    while (list) {
+        ChardevInfo *chr = list->value;
+
+        if (!strncmp(chr->label, str, len)) {
+            readline_add_completion(rs, chr->label);
+        }
+        list = list->next;
+    }
+    qapi_free_ChardevInfoList(start);
+}
+
+static void ringbuf_completion(ReadLineState *rs, const char *str)
+{
+    size_t len;
+    ChardevInfoList *list, *start;
+
+    len = strlen(str);
+    readline_set_completion_index(rs, len);
+
+    start = list = qmp_query_chardev(NULL);
+    while (list) {
+        ChardevInfo *chr_info = list->value;
+
+        if (!strncmp(chr_info->label, str, len)) {
+            Chardev *chr = qemu_chr_find(chr_info->label);
+            if (chr && CHARDEV_IS_RINGBUF(chr)) {
+                readline_add_completion(rs, chr_info->label);
+            }
+        }
+        list = list->next;
+    }
+    qapi_free_ChardevInfoList(start);
+}
+
+void ringbuf_write_completion(ReadLineState *rs, int nb_args, const char *str)
+{
+    if (nb_args != 2) {
+        return;
+    }
+    ringbuf_completion(rs, str);
+}
diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
index de1a96d48c..c8ed59c281 100644
--- a/monitor/hmp-cmds.c
+++ b/monitor/hmp-cmds.c
@@ -17,10 +17,7 @@
 #include "monitor/hmp.h"
 #include "net/net.h"
 #include "net/eth.h"
-#include "chardev/char.h"
 #include "sysemu/runstate.h"
-#include "qemu/config-file.h"
-#include "qemu/option.h"
 #include "qemu/sockets.h"
 #include "qemu/help_option.h"
 #include "monitor/monitor.h"
@@ -28,7 +25,6 @@
 #include "qapi/clone-visitor.h"
 #include "qapi/qapi-builtin-visit.h"
 #include "qapi/qapi-commands-block.h"
-#include "qapi/qapi-commands-char.h"
 #include "qapi/qapi-commands-control.h"
 #include "qapi/qapi-commands-machine.h"
 #include "qapi/qapi-commands-migration.h"
@@ -155,19 +151,6 @@ void hmp_info_uuid(Monitor *mon, const QDict *qdict)
     qapi_free_UuidInfo(info);
 }
 
-void hmp_info_chardev(Monitor *mon, const QDict *qdict)
-{
-    ChardevInfoList *char_info, *info;
-
-    char_info = qmp_query_chardev(NULL);
-    for (info = char_info; info; info = info->next) {
-        monitor_printf(mon, "%s: filename=%s\n", info->value->label,
-                                                 info->value->filename);
-    }
-
-    qapi_free_ChardevInfoList(char_info);
-}
-
 void hmp_info_migrate(Monitor *mon, const QDict *qdict)
 {
     MigrationInfo *info;
@@ -673,46 +656,6 @@ void hmp_pmemsave(Monitor *mon, const QDict *qdict)
     hmp_handle_error(mon, err);
 }
 
-void hmp_ringbuf_write(Monitor *mon, const QDict *qdict)
-{
-    const char *chardev = qdict_get_str(qdict, "device");
-    const char *data = qdict_get_str(qdict, "data");
-    Error *err = NULL;
-
-    qmp_ringbuf_write(chardev, data, false, 0, &err);
-
-    hmp_handle_error(mon, err);
-}
-
-void hmp_ringbuf_read(Monitor *mon, const QDict *qdict)
-{
-    uint32_t size = qdict_get_int(qdict, "size");
-    const char *chardev = qdict_get_str(qdict, "device");
-    char *data;
-    Error *err = NULL;
-    int i;
-
-    data = qmp_ringbuf_read(chardev, size, false, 0, &err);
-    if (hmp_handle_error(mon, err)) {
-        return;
-    }
-
-    for (i = 0; data[i]; i++) {
-        unsigned char ch = data[i];
-
-        if (ch == '\\') {
-            monitor_printf(mon, "\\\\");
-        } else if ((ch < 0x20 && ch != '\n' && ch != '\t') || ch == 0x7F) {
-            monitor_printf(mon, "\\u%04X", ch);
-        } else {
-            monitor_printf(mon, "%c", ch);
-        }
-
-    }
-    monitor_printf(mon, "\n");
-    g_free(data);
-}
-
 void hmp_cont(Monitor *mon, const QDict *qdict)
 {
     Error *err = NULL;
@@ -1241,72 +1184,6 @@ void hmp_closefd(Monitor *mon, const QDict *qdict)
     hmp_handle_error(mon, err);
 }
 
-void hmp_chardev_add(Monitor *mon, const QDict *qdict)
-{
-    const char *args = qdict_get_str(qdict, "args");
-    Error *err = NULL;
-    QemuOpts *opts;
-
-    opts = qemu_opts_parse_noisily(qemu_find_opts("chardev"), args, true);
-    if (opts == NULL) {
-        error_setg(&err, "Parsing chardev args failed");
-    } else {
-        qemu_chr_new_from_opts(opts, NULL, &err);
-        qemu_opts_del(opts);
-    }
-    hmp_handle_error(mon, err);
-}
-
-void hmp_chardev_change(Monitor *mon, const QDict *qdict)
-{
-    const char *args = qdict_get_str(qdict, "args");
-    const char *id;
-    Error *err = NULL;
-    ChardevBackend *backend = NULL;
-    ChardevReturn *ret = NULL;
-    QemuOpts *opts = qemu_opts_parse_noisily(qemu_find_opts("chardev"), args,
-                                             true);
-    if (!opts) {
-        error_setg(&err, "Parsing chardev args failed");
-        goto end;
-    }
-
-    id = qdict_get_str(qdict, "id");
-    if (qemu_opts_id(opts)) {
-        error_setg(&err, "Unexpected 'id' parameter");
-        goto end;
-    }
-
-    backend = qemu_chr_parse_opts(opts, &err);
-    if (!backend) {
-        goto end;
-    }
-
-    ret = qmp_chardev_change(id, backend, &err);
-
-end:
-    qapi_free_ChardevReturn(ret);
-    qapi_free_ChardevBackend(backend);
-    qemu_opts_del(opts);
-    hmp_handle_error(mon, err);
-}
-
-void hmp_chardev_remove(Monitor *mon, const QDict *qdict)
-{
-    Error *local_err = NULL;
-
-    qmp_chardev_remove(qdict_get_str(qdict, "id"), &local_err);
-    hmp_handle_error(mon, local_err);
-}
-
-void hmp_chardev_send_break(Monitor *mon, const QDict *qdict)
-{
-    Error *local_err = NULL;
-
-    qmp_chardev_send_break(qdict_get_str(qdict, "id"), &local_err);
-    hmp_handle_error(mon, local_err);
-}
-
 void hmp_object_del(Monitor *mon, const QDict *qdict)
 {
     const char *id = qdict_get_str(qdict, "id");
diff --git a/monitor/misc.c b/monitor/misc.c
index 80d5527774..c18a713d9c 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -49,7 +49,6 @@
 #include "exec/ioport.h"
 #include "block/qapi.h"
 #include "block/block-hmp-cmds.h"
-#include "qapi/qapi-commands-char.h"
 #include "qapi/qapi-commands-control.h"
 #include "qapi/qapi-commands-migration.h"
 #include "qapi/qapi-commands-misc.h"
@@ -1362,29 +1361,6 @@ static void add_completion_option(ReadLineState *rs, const char *str,
     }
 }
 
-void chardev_add_completion(ReadLineState *rs, int nb_args, const char *str)
-{
-    size_t len;
-    ChardevBackendInfoList *list, *start;
-
-    if (nb_args != 2) {
-        return;
-    }
-    len = strlen(str);
-    readline_set_completion_index(rs, len);
-
-    start = list = qmp_query_chardev_backends(NULL);
-    while (list) {
-        const char *chr_name = list->value->name;
-
-        if (!strncmp(chr_name, str, len)) {
-            readline_add_completion(rs, chr_name);
-        }
-        list = list->next;
-    }
-    qapi_free_ChardevBackendInfoList(start);
-}
-
 void netdev_add_completion(ReadLineState *rs, int nb_args, const char *str)
 {
     size_t len;
@@ -1498,60 +1474,6 @@ static void peripheral_device_del_completion(ReadLineState *rs,
     g_slist_free(list);
 }
 
-void chardev_remove_completion(ReadLineState *rs, int nb_args, const char *str)
-{
-    size_t len;
-    ChardevInfoList *list, *start;
-
-    if (nb_args != 2) {
-        return;
-    }
-    len = strlen(str);
-    readline_set_completion_index(rs, len);
-
-    start = list = qmp_query_chardev(NULL);
-    while (list) {
-        ChardevInfo *chr = list->value;
-
-        if (!strncmp(chr->label, str, len)) {
-            readline_add_completion(rs, chr->label);
-        }
-        list = list->next;
-    }
-    qapi_free_ChardevInfoList(start);
-}
-
-static void ringbuf_completion(ReadLineState *rs, const char *str)
-{
-    size_t len;
-    ChardevInfoList *list, *start;
-
-    len = strlen(str);
-    readline_set_completion_index(rs, len);
-
-    start = list = qmp_query_chardev(NULL);
-    while (list) {
-        ChardevInfo *chr_info = list->value;
-
-        if (!strncmp(chr_info->label, str, len)) {
-            Chardev *chr = qemu_chr_find(chr_info->label);
-            if (chr && CHARDEV_IS_RINGBUF(chr)) {
-                readline_add_completion(rs, chr_info->label);
-            }
-        }
-        list = list->next;
-    }
-    qapi_free_ChardevInfoList(start);
-}
-
-void ringbuf_write_completion(ReadLineState *rs, int nb_args, const char *str)
-{
-    if (nb_args != 2) {
-        return;
-    }
-    ringbuf_completion(rs, str);
-}
-
 void device_del_completion(ReadLineState *rs, int nb_args, const char *str)
 {
     size_t len;
diff --git a/chardev/meson.build b/chardev/meson.build
index 789b50056a..7a3ba777ab 100644
--- a/chardev/meson.build
+++ b/chardev/meson.build
@@ -28,7 +28,11 @@ chardev_ss.add(when: 'CONFIG_WIN32', if_true: files(
 
 chardev_ss = chardev_ss.apply(config_host, strict: false)
 
-softmmu_ss.add(files('msmouse.c', 'wctablet.c', 'testdev.c'))
+softmmu_ss.add(files(
+    'char-hmp-cmds.c',
+    'msmouse.c',
+    'wctablet.c',
+    'testdev.c'))
 
 chardev_modules = {}
 
-- 
2.39.0

