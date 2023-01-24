Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8386797AD
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbjAXMUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233521AbjAXMUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:20:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E4444BE6
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7hqimSQSR83EexOoH+0Cr7wEcatAurXxpPSGnTBfxo4=;
        b=aVCVPNANbpG60JcBr6Z27kqM/dFt2VygO7OMFLLXHLJKf8wYq34LpOJqxLyRPrNBN9nehE
        CAoDT4FC+1E5xNLhapWpQhxEArMvHh4wxryd/qPDPgN6Zwwn1K7HMbNInrnR/A0ap4I4Jk
        6Vmb0dUUwEHJjTFEUqMWNyBB587ze/Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-FK3-J29GNgyOsOhFSm-G7g-1; Tue, 24 Jan 2023 07:19:50 -0500
X-MC-Unique: FK3-J29GNgyOsOhFSm-G7g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B50F93C10233;
        Tue, 24 Jan 2023 12:19:49 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 44878492B00;
        Tue, 24 Jan 2023 12:19:49 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id A28F221E690F; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 11/32] qom: Move HMP commands from monitor/ to qom/
Date:   Tue, 24 Jan 2023 13:19:25 +0100
Message-Id: <20230124121946.1139465-12-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
Monitor (HMP)" and "QMP" to "QOM".

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 monitor/hmp-cmds.c | 19 -------------
 monitor/misc.c     | 49 ---------------------------------
 qom/qom-hmp-cmds.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 68 deletions(-)

diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
index 1e41381e77..4fe2aaebcd 100644
--- a/monitor/hmp-cmds.c
+++ b/monitor/hmp-cmds.c
@@ -40,7 +40,6 @@
 #include "qapi/qmp/qerror.h"
 #include "qapi/string-input-visitor.h"
 #include "qapi/string-output-visitor.h"
-#include "qom/object_interfaces.h"
 #include "qemu/cutils.h"
 #include "qemu/error-report.h"
 #include "hw/core/cpu.h"
@@ -1054,15 +1053,6 @@ void hmp_netdev_del(Monitor *mon, const QDict *qdict)
     hmp_handle_error(mon, err);
 }
 
-void hmp_object_add(Monitor *mon, const QDict *qdict)
-{
-    const char *options = qdict_get_str(qdict, "object");
-    Error *err = NULL;
-
-    user_creatable_add_from_str(options, &err);
-    hmp_handle_error(mon, err);
-}
-
 void hmp_getfd(Monitor *mon, const QDict *qdict)
 {
     const char *fdname = qdict_get_str(qdict, "fdname");
@@ -1081,15 +1071,6 @@ void hmp_closefd(Monitor *mon, const QDict *qdict)
     hmp_handle_error(mon, err);
 }
 
-void hmp_object_del(Monitor *mon, const QDict *qdict)
-{
-    const char *id = qdict_get_str(qdict, "id");
-    Error *err = NULL;
-
-    user_creatable_del(id, &err);
-    hmp_handle_error(mon, err);
-}
-
 void hmp_info_iothreads(Monitor *mon, const QDict *qdict)
 {
     IOThreadInfoList *info_list = qmp_query_iothreads(NULL);
diff --git a/monitor/misc.c b/monitor/misc.c
index 2a6bc13e7f..0cf2518ce1 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -38,7 +38,6 @@
 #include "sysemu/device_tree.h"
 #include "qapi/qmp/qdict.h"
 #include "qapi/qmp/qerror.h"
-#include "qom/object_interfaces.h"
 #include "monitor/hmp-target.h"
 #include "monitor/hmp.h"
 #include "exec/address-spaces.h"
@@ -48,7 +47,6 @@
 #include "qapi/qapi-commands-control.h"
 #include "qapi/qapi-commands-migration.h"
 #include "qapi/qapi-commands-misc.h"
-#include "qapi/qapi-commands-qom.h"
 #include "qapi/qapi-commands-run-state.h"
 #include "qapi/qapi-commands-machine.h"
 #include "qapi/qapi-init-commands.h"
@@ -1310,30 +1308,6 @@ void device_add_completion(ReadLineState *rs, int nb_args, const char *str)
     g_slist_free(list);
 }
 
-void object_add_completion(ReadLineState *rs, int nb_args, const char *str)
-{
-    GSList *list, *elt;
-    size_t len;
-
-    if (nb_args != 2) {
-        return;
-    }
-
-    len = strlen(str);
-    readline_set_completion_index(rs, len);
-    list = elt = object_class_get_list(TYPE_USER_CREATABLE, false);
-    while (elt) {
-        const char *name;
-
-        name = object_class_get_name(OBJECT_CLASS(elt->data));
-        if (strcmp(name, TYPE_USER_CREATABLE)) {
-            readline_add_completion_of(rs, str, name);
-        }
-        elt = elt->next;
-    }
-    g_slist_free(list);
-}
-
 static int qdev_add_hotpluggable_device(Object *obj, void *opaque)
 {
     GSList **list = opaque;
@@ -1391,29 +1365,6 @@ void device_del_completion(ReadLineState *rs, int nb_args, const char *str)
     peripheral_device_del_completion(rs, str);
 }
 
-void object_del_completion(ReadLineState *rs, int nb_args, const char *str)
-{
-    ObjectPropertyInfoList *list, *start;
-    size_t len;
-
-    if (nb_args != 2) {
-        return;
-    }
-    len = strlen(str);
-    readline_set_completion_index(rs, len);
-
-    start = list = qmp_qom_list("/objects", NULL);
-    while (list) {
-        ObjectPropertyInfo *info = list->value;
-
-        if (!strncmp(info->type, "child<", 5)) {
-            readline_add_completion_of(rs, str, info->name);
-        }
-        list = list->next;
-    }
-    qapi_free_ObjectPropertyInfoList(start);
-}
-
 void set_link_completion(ReadLineState *rs, int nb_args, const char *str)
 {
     size_t len;
diff --git a/qom/qom-hmp-cmds.c b/qom/qom-hmp-cmds.c
index 453fbfeabc..6e3a2175a4 100644
--- a/qom/qom-hmp-cmds.c
+++ b/qom/qom-hmp-cmds.c
@@ -13,7 +13,9 @@
 #include "qapi/qapi-commands-qom.h"
 #include "qapi/qmp/qdict.h"
 #include "qapi/qmp/qjson.h"
+#include "qemu/readline.h"
 #include "qom/object.h"
+#include "qom/object_interfaces.h"
 
 void hmp_qom_list(Monitor *mon, const QDict *qdict)
 {
@@ -150,3 +152,68 @@ void hmp_info_qom_tree(Monitor *mon, const QDict *dict)
     }
     print_qom_composition(mon, obj, 0);
 }
+
+void hmp_object_add(Monitor *mon, const QDict *qdict)
+{
+    const char *options = qdict_get_str(qdict, "object");
+    Error *err = NULL;
+
+    user_creatable_add_from_str(options, &err);
+    hmp_handle_error(mon, err);
+}
+
+void hmp_object_del(Monitor *mon, const QDict *qdict)
+{
+    const char *id = qdict_get_str(qdict, "id");
+    Error *err = NULL;
+
+    user_creatable_del(id, &err);
+    hmp_handle_error(mon, err);
+}
+
+void object_add_completion(ReadLineState *rs, int nb_args, const char *str)
+{
+    GSList *list, *elt;
+    size_t len;
+
+    if (nb_args != 2) {
+        return;
+    }
+
+    len = strlen(str);
+    readline_set_completion_index(rs, len);
+    list = elt = object_class_get_list(TYPE_USER_CREATABLE, false);
+    while (elt) {
+        const char *name;
+
+        name = object_class_get_name(OBJECT_CLASS(elt->data));
+        if (strcmp(name, TYPE_USER_CREATABLE)) {
+            readline_add_completion_of(rs, str, name);
+        }
+        elt = elt->next;
+    }
+    g_slist_free(list);
+}
+
+void object_del_completion(ReadLineState *rs, int nb_args, const char *str)
+{
+    ObjectPropertyInfoList *list, *start;
+    size_t len;
+
+    if (nb_args != 2) {
+        return;
+    }
+    len = strlen(str);
+    readline_set_completion_index(rs, len);
+
+    start = list = qmp_qom_list("/objects", NULL);
+    while (list) {
+        ObjectPropertyInfo *info = list->value;
+
+        if (!strncmp(info->type, "child<", 5)) {
+            readline_add_completion_of(rs, str, info->name);
+        }
+        list = list->next;
+    }
+    qapi_free_ObjectPropertyInfoList(start);
+}
-- 
2.39.0

