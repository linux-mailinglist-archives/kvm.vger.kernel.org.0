Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B386797B5
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbjAXMVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbjAXMU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:20:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AD044BDF
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NercqxZOik8RMti2xIskx9aNKJJIFwHwrj9NM06kurE=;
        b=gYvCB8MQztjDGVih6UEiNBFEiHJC9960gEfNABqRHs9GYNWIx4S5JBkUzNALSazgfag64m
        R7+hL0BqYJ6DCeE6Sbnz5JhVbaeCG+l8aCQSQVmLViENeALi+PZ8+AAep44wklrbOtKZ8H
        eeHrQhz9A4/7DiSmv5eGvCIZR4MNEKU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-eTLqeNbwNLCUNng6KOBbmQ-1; Tue, 24 Jan 2023 07:19:50 -0500
X-MC-Unique: eTLqeNbwNLCUNng6KOBbmQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A654738123A5;
        Tue, 24 Jan 2023 12:19:49 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32083140EBF6;
        Tue, 24 Jan 2023 12:19:49 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 9301D21E6A25; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 06/32] readline: Extract readline_add_completion_of() from monitor
Date:   Tue, 24 Jan 2023 13:19:20 +0100
Message-Id: <20230124121946.1139465-7-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

monitor/misc.h has static add_completion_option().  It's useful
elsewhere in the monitor.  Since it's not monitor-specific, move it to
util/readline.c renamed to readline_add_completion_of(), and put it to
use.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 include/qemu/readline.h |  2 +
 monitor/hmp.c           | 12 +++---
 monitor/misc.c          | 85 +++++++++++++----------------------------
 util/readline.c         |  8 ++++
 4 files changed, 41 insertions(+), 66 deletions(-)

diff --git a/include/qemu/readline.h b/include/qemu/readline.h
index 622aa4564f..b05e4782da 100644
--- a/include/qemu/readline.h
+++ b/include/qemu/readline.h
@@ -44,6 +44,8 @@ typedef struct ReadLineState {
 } ReadLineState;
 
 void readline_add_completion(ReadLineState *rs, const char *str);
+void readline_add_completion_of(ReadLineState *rs,
+                                const char *pfx, const char *str);
 void readline_set_completion_index(ReadLineState *rs, int completion_index);
 
 const char *readline_get_history(ReadLineState *rs, unsigned int index);
diff --git a/monitor/hmp.c b/monitor/hmp.c
index 65641a6e56..893e100581 100644
--- a/monitor/hmp.c
+++ b/monitor/hmp.c
@@ -1188,8 +1188,8 @@ static void cmd_completion(MonitorHMP *mon, const char *name, const char *list)
         }
         memcpy(cmd, pstart, len);
         cmd[len] = '\0';
-        if (name[0] == '\0' || !strncmp(name, cmd, strlen(name))) {
-            readline_add_completion(mon->rs, cmd);
+        if (name[0] == '\0') {
+            readline_add_completion_of(mon->rs, name, cmd);
         }
         if (*p == '\0') {
             break;
@@ -1269,7 +1269,7 @@ static void monitor_find_completion_by_table(MonitorHMP *mon,
 {
     const char *cmdname;
     int i;
-    const char *ptype, *old_ptype, *str, *name;
+    const char *ptype, *old_ptype, *str;
     const HMPCommand *cmd;
     BlockBackend *blk = NULL;
 
@@ -1334,10 +1334,8 @@ static void monitor_find_completion_by_table(MonitorHMP *mon,
             /* block device name completion */
             readline_set_completion_index(mon->rs, strlen(str));
             while ((blk = blk_next(blk)) != NULL) {
-                name = blk_name(blk);
-                if (str[0] == '\0' ||
-                    !strncmp(name, str, strlen(str))) {
-                    readline_add_completion(mon->rs, name);
+                if (str[0] == '\0') {
+                    readline_add_completion_of(mon->rs, str, blk_name(blk));
                 }
             }
             break;
diff --git a/monitor/misc.c b/monitor/misc.c
index d58a81c452..9da52939b2 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -1350,14 +1350,6 @@ int get_monitor_def(Monitor *mon, int64_t *pval, const char *name)
     return ret;
 }
 
-static void add_completion_option(ReadLineState *rs, const char *str,
-                                  const char *option)
-{
-    if (!strncmp(option, str, strlen(str))) {
-        readline_add_completion(rs, option);
-    }
-}
-
 void netdev_add_completion(ReadLineState *rs, int nb_args, const char *str)
 {
     size_t len;
@@ -1369,7 +1361,7 @@ void netdev_add_completion(ReadLineState *rs, int nb_args, const char *str)
     len = strlen(str);
     readline_set_completion_index(rs, len);
     for (i = 0; i < NET_CLIENT_DRIVER__MAX; i++) {
-        add_completion_option(rs, str, NetClientDriver_str(i));
+        readline_add_completion_of(rs, str, NetClientDriver_str(i));
     }
 }
 
@@ -1386,14 +1378,12 @@ void device_add_completion(ReadLineState *rs, int nb_args, const char *str)
     readline_set_completion_index(rs, len);
     list = elt = object_class_get_list(TYPE_DEVICE, false);
     while (elt) {
-        const char *name;
         DeviceClass *dc = OBJECT_CLASS_CHECK(DeviceClass, elt->data,
                                              TYPE_DEVICE);
-        name = object_class_get_name(OBJECT_CLASS(dc));
 
-        if (dc->user_creatable
-            && !strncmp(name, str, len)) {
-            readline_add_completion(rs, name);
+        if (dc->user_creatable) {
+            readline_add_completion_of(rs, str,
+                                object_class_get_name(OBJECT_CLASS(dc)));
         }
         elt = elt->next;
     }
@@ -1416,8 +1406,8 @@ void object_add_completion(ReadLineState *rs, int nb_args, const char *str)
         const char *name;
 
         name = object_class_get_name(OBJECT_CLASS(elt->data));
-        if (!strncmp(name, str, len) && strcmp(name, TYPE_USER_CREATABLE)) {
-            readline_add_completion(rs, name);
+        if (strcmp(name, TYPE_USER_CREATABLE)) {
+            readline_add_completion_of(rs, str, name);
         }
         elt = elt->next;
     }
@@ -1450,7 +1440,7 @@ static GSList *qdev_build_hotpluggable_device_list(Object *peripheral)
 }
 
 static void peripheral_device_del_completion(ReadLineState *rs,
-                                             const char *str, size_t len)
+                                             const char *str)
 {
     Object *peripheral = container_get(qdev_get_machine(), "/peripheral");
     GSList *list, *item;
@@ -1463,8 +1453,8 @@ static void peripheral_device_del_completion(ReadLineState *rs,
     for (item = list; item; item = g_slist_next(item)) {
         DeviceState *dev = item->data;
 
-        if (dev->id && !strncmp(str, dev->id, len)) {
-            readline_add_completion(rs, dev->id);
+        if (dev->id) {
+            readline_add_completion_of(rs, str, dev->id);
         }
     }
 
@@ -1473,15 +1463,12 @@ static void peripheral_device_del_completion(ReadLineState *rs,
 
 void device_del_completion(ReadLineState *rs, int nb_args, const char *str)
 {
-    size_t len;
-
     if (nb_args != 2) {
         return;
     }
 
-    len = strlen(str);
-    readline_set_completion_index(rs, len);
-    peripheral_device_del_completion(rs, str, len);
+    readline_set_completion_index(rs, strlen(str));
+    peripheral_device_del_completion(rs, str);
 }
 
 void object_del_completion(ReadLineState *rs, int nb_args, const char *str)
@@ -1499,9 +1486,8 @@ void object_del_completion(ReadLineState *rs, int nb_args, const char *str)
     while (list) {
         ObjectPropertyInfo *info = list->value;
 
-        if (!strncmp(info->type, "child<", 5)
-            && !strncmp(info->name, str, len)) {
-            readline_add_completion(rs, info->name);
+        if (!strncmp(info->type, "child<", 5)) {
+            readline_add_completion_of(rs, str, info->name);
         }
         list = list->next;
     }
@@ -1521,14 +1507,11 @@ void set_link_completion(ReadLineState *rs, int nb_args, const char *str)
                                              NET_CLIENT_DRIVER_NONE,
                                              MAX_QUEUE_NUM);
         for (i = 0; i < MIN(count, MAX_QUEUE_NUM); i++) {
-            const char *name = ncs[i]->name;
-            if (!strncmp(str, name, len)) {
-                readline_add_completion(rs, name);
-            }
+            readline_add_completion_of(rs, str, ncs[i]->name);
         }
     } else if (nb_args == 3) {
-        add_completion_option(rs, str, "on");
-        add_completion_option(rs, str, "off");
+        readline_add_completion_of(rs, str, "on");
+        readline_add_completion_of(rs, str, "off");
     }
 }
 
@@ -1546,12 +1529,8 @@ void netdev_del_completion(ReadLineState *rs, int nb_args, const char *str)
     count = qemu_find_net_clients_except(NULL, ncs, NET_CLIENT_DRIVER_NIC,
                                          MAX_QUEUE_NUM);
     for (i = 0; i < MIN(count, MAX_QUEUE_NUM); i++) {
-        const char *name = ncs[i]->name;
-        if (strncmp(str, name, len)) {
-            continue;
-        }
         if (ncs[i]->is_netdev) {
-            readline_add_completion(rs, name);
+            readline_add_completion_of(rs, str, ncs[i]->name);
         }
     }
 }
@@ -1590,8 +1569,8 @@ void trace_event_completion(ReadLineState *rs, int nb_args, const char *str)
         }
         g_free(pattern);
     } else if (nb_args == 3) {
-        add_completion_option(rs, str, "on");
-        add_completion_option(rs, str, "off");
+        readline_add_completion_of(rs, str, "on");
+        readline_add_completion_of(rs, str, "off");
     }
 }
 
@@ -1604,7 +1583,7 @@ void watchdog_action_completion(ReadLineState *rs, int nb_args, const char *str)
     }
     readline_set_completion_index(rs, strlen(str));
     for (i = 0; i < WATCHDOG_ACTION__MAX; i++) {
-        add_completion_option(rs, str, WatchdogAction_str(i));
+        readline_add_completion_of(rs, str, WatchdogAction_str(i));
     }
 }
 
@@ -1618,14 +1597,11 @@ void migrate_set_capability_completion(ReadLineState *rs, int nb_args,
     if (nb_args == 2) {
         int i;
         for (i = 0; i < MIGRATION_CAPABILITY__MAX; i++) {
-            const char *name = MigrationCapability_str(i);
-            if (!strncmp(str, name, len)) {
-                readline_add_completion(rs, name);
-            }
+            readline_add_completion_of(rs, str, MigrationCapability_str(i));
         }
     } else if (nb_args == 3) {
-        add_completion_option(rs, str, "on");
-        add_completion_option(rs, str, "off");
+        readline_add_completion_of(rs, str, "on");
+        readline_add_completion_of(rs, str, "off");
     }
 }
 
@@ -1639,10 +1615,7 @@ void migrate_set_parameter_completion(ReadLineState *rs, int nb_args,
     if (nb_args == 2) {
         int i;
         for (i = 0; i < MIGRATION_PARAMETER__MAX; i++) {
-            const char *name = MigrationParameter_str(i);
-            if (!strncmp(str, name, len)) {
-                readline_add_completion(rs, name);
-            }
+            readline_add_completion_of(rs, str, MigrationParameter_str(i));
         }
     }
 }
@@ -1672,14 +1645,8 @@ static void vm_completion(ReadLineState *rs, const char *str)
 
         snapshot = snapshots;
         while (snapshot) {
-            char *completion = snapshot->value->name;
-            if (!strncmp(str, completion, len)) {
-                readline_add_completion(rs, completion);
-            }
-            completion = snapshot->value->id;
-            if (!strncmp(str, completion, len)) {
-                readline_add_completion(rs, completion);
-            }
+            readline_add_completion_of(rs, str, snapshot->value->name);
+            readline_add_completion_of(rs, str, snapshot->value->id);
             snapshot = snapshot->next;
         }
         qapi_free_SnapshotInfoList(snapshots);
diff --git a/util/readline.c b/util/readline.c
index f1ac6e4769..494a3d924e 100644
--- a/util/readline.c
+++ b/util/readline.c
@@ -286,6 +286,14 @@ void readline_add_completion(ReadLineState *rs, const char *str)
     }
 }
 
+void readline_add_completion_of(ReadLineState *rs,
+                                const char *pfx, const char *str)
+{
+    if (!strncmp(str, pfx, strlen(pfx))) {
+        readline_add_completion(rs, str);
+    }
+}
+
 void readline_set_completion_index(ReadLineState *rs, int index)
 {
     rs->completion_index = index;
-- 
2.39.0

