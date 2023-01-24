Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2323D6797B1
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbjAXMU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbjAXMUz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:20:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF954457ED
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=STKqELgE9Pm/wxor87wq2R+GZNqsbZdCiaFx2/7ViQE=;
        b=iVx2wsBEaMHP/G8hE9uz2ttTVJEY1WMul4HfOVjgrm/P/XWpOxoRnFuZ8WDcAfz4G4Pdd4
        jbLG1/Q0ofz+gz+J8Tqt9yClSNvB2Ef8N5rv1A/0vHZf28v54Tf6MNG46L6YACAT6SrqKa
        Xts9WlMCabtpOgPL5uQEqsoCwXgSYbU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-99y5xSZLPvWgUPJyPOEkJg-1; Tue, 24 Jan 2023 07:19:51 -0500
X-MC-Unique: 99y5xSZLPvWgUPJyPOEkJg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A33F8030D0;
        Tue, 24 Jan 2023 12:19:51 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C11C4492B02;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id DC0DF21E6883; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 30/32] monitor: Move remaining QMP stuff from misc.c to qmp-cmds.c
Date:   Tue, 24 Jan 2023 13:19:44 +0100
Message-Id: <20230124121946.1139465-31-armbru@redhat.com>
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

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 monitor/misc.c     | 51 --------------------------------------------
 monitor/qmp-cmds.c | 53 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/monitor/misc.c b/monitor/misc.c
index 52a7d7686e..9ddf32da97 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -27,14 +27,12 @@
 #include "monitor/qdev.h"
 #include "net/slirp.h"
 #include "sysemu/device_tree.h"
-#include "qapi/qmp/qerror.h"
 #include "monitor/hmp-target.h"
 #include "monitor/hmp.h"
 #include "block/block-hmp-cmds.h"
 #include "qapi/qapi-commands-control.h"
 #include "qapi/qapi-commands-misc.h"
 #include "qapi/qapi-commands-machine.h"
-#include "qapi/qapi-init-commands.h"
 #include "qapi/error.h"
 #include "qemu/cutils.h"
 
@@ -48,34 +46,6 @@
 
 static HMPCommand hmp_info_cmds[];
 
-char *qmp_human_monitor_command(const char *command_line, bool has_cpu_index,
-                                int64_t cpu_index, Error **errp)
-{
-    char *output = NULL;
-    MonitorHMP hmp = {};
-
-    monitor_data_init(&hmp.common, false, true, false);
-
-    if (has_cpu_index) {
-        int ret = monitor_set_cpu(&hmp.common, cpu_index);
-        if (ret < 0) {
-            error_setg(errp, QERR_INVALID_PARAMETER_VALUE, "cpu-index",
-                       "a CPU number");
-            goto out;
-        }
-    }
-
-    handle_hmp_command(&hmp, command_line);
-
-    WITH_QEMU_LOCK_GUARD(&hmp.common.mon_lock) {
-        output = g_strdup(hmp.common.outbuf->str);
-    }
-
-out:
-    monitor_data_destroy(&hmp.common);
-    return output;
-}
-
 /**
  * Is @name in the '|' separated list of names @list?
  */
@@ -99,26 +69,6 @@ int hmp_compare_cmd(const char *name, const char *list)
     return 0;
 }
 
-static void monitor_init_qmp_commands(void)
-{
-    /*
-     * Two command lists:
-     * - qmp_commands contains all QMP commands
-     * - qmp_cap_negotiation_commands contains just
-     *   "qmp_capabilities", to enforce capability negotiation
-     */
-
-    qmp_init_marshal(&qmp_commands);
-
-    qmp_register_command(&qmp_commands, "device_add",
-                         qmp_device_add, 0, 0);
-
-    QTAILQ_INIT(&qmp_cap_negotiation_commands);
-    qmp_register_command(&qmp_cap_negotiation_commands, "qmp_capabilities",
-                         qmp_marshal_qmp_capabilities,
-                         QCO_ALLOW_PRECONFIG, 0);
-}
-
 /* Please update hmp-commands.hx when adding or changing commands */
 static HMPCommand hmp_info_cmds[] = {
 #include "hmp-commands-info.h"
@@ -230,6 +180,5 @@ void monitor_register_hmp_info_hrt(const char *name,
 void monitor_init_globals(void)
 {
     monitor_init_globals_core();
-    monitor_init_qmp_commands();
     sortcmdlist();
 }
diff --git a/monitor/qmp-cmds.c b/monitor/qmp-cmds.c
index cc22f3fcc7..859012aef4 100644
--- a/monitor/qmp-cmds.c
+++ b/monitor/qmp-cmds.c
@@ -14,7 +14,8 @@
  */
 
 #include "qemu/osdep.h"
-#include "monitor/monitor.h"
+#include "monitor-internal.h"
+#include "monitor/qdev.h"
 #include "monitor/qmp-helpers.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/kvm.h"
@@ -22,8 +23,10 @@
 #include "sysemu/runstate-action.h"
 #include "sysemu/block-backend.h"
 #include "qapi/error.h"
+#include "qapi/qapi-init-commands.h"
 #include "qapi/qapi-commands-control.h"
 #include "qapi/qapi-commands-misc.h"
+#include "qapi/qmp/qerror.h"
 #include "qapi/type-helpers.h"
 #include "hw/mem/memory-device.h"
 #include "hw/intc/intc.h"
@@ -151,3 +154,51 @@ void qmp_add_client(const char *protocol, const char *fdname,
         close(fd);
     }
 }
+
+char *qmp_human_monitor_command(const char *command_line, bool has_cpu_index,
+                                int64_t cpu_index, Error **errp)
+{
+    char *output = NULL;
+    MonitorHMP hmp = {};
+
+    monitor_data_init(&hmp.common, false, true, false);
+
+    if (has_cpu_index) {
+        int ret = monitor_set_cpu(&hmp.common, cpu_index);
+        if (ret < 0) {
+            error_setg(errp, QERR_INVALID_PARAMETER_VALUE, "cpu-index",
+                       "a CPU number");
+            goto out;
+        }
+    }
+
+    handle_hmp_command(&hmp, command_line);
+
+    WITH_QEMU_LOCK_GUARD(&hmp.common.mon_lock) {
+        output = g_strdup(hmp.common.outbuf->str);
+    }
+
+out:
+    monitor_data_destroy(&hmp.common);
+    return output;
+}
+
+static void __attribute__((__constructor__)) monitor_init_qmp_commands(void)
+{
+    /*
+     * Two command lists:
+     * - qmp_commands contains all QMP commands
+     * - qmp_cap_negotiation_commands contains just
+     *   "qmp_capabilities", to enforce capability negotiation
+     */
+
+    qmp_init_marshal(&qmp_commands);
+
+    qmp_register_command(&qmp_commands, "device_add",
+                         qmp_device_add, 0, 0);
+
+    QTAILQ_INIT(&qmp_cap_negotiation_commands);
+    qmp_register_command(&qmp_cap_negotiation_commands, "qmp_capabilities",
+                         qmp_marshal_qmp_capabilities,
+                         QCO_ALLOW_PRECONFIG, 0);
+}
-- 
2.39.0

