Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF1A6797C1
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbjAXMVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbjAXMVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:21:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DE345883
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xbAvUS2dom5Mf9F/0e0kiTLWhM1JyaFYk8VBGRpyoKU=;
        b=RlWzfCxEFB2L34J/FSBFxCFgK/6FmhPlFBfTYMyadrEDIjXh1XnEFQyNBIe1SrMTEmAmFX
        NMDsCvFh+VFo4pV22dSw5uXK674Rf5OuODGhhWFSNF8iYCDlRxd1uwnfShTAtRIVI5/hC7
        22Kk6XNarWxioXMTTePoY/Q9N49emQI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-t9UZGMenM-C2_9FLwja0Fg-1; Tue, 24 Jan 2023 07:19:51 -0500
X-MC-Unique: t9UZGMenM-C2_9FLwja0Fg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F05E629DD991;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 91906140EBF5;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id C0A5021E6922; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 21/32] runstate: Move HMP commands from monitor/ to softmmu/
Date:   Tue, 24 Jan 2023 13:19:35 +0100
Message-Id: <20230124121946.1139465-22-armbru@redhat.com>
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

This moves these commands from MAINTAINERS section "Human
Monitor (HMP)" and "QMP" to "Main loop".

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 MAINTAINERS                 |  3 +-
 include/monitor/hmp.h       |  2 +
 monitor/hmp-cmds.c          | 20 ---------
 monitor/misc.c              | 42 -------------------
 softmmu/runstate-hmp-cmds.c | 82 +++++++++++++++++++++++++++++++++++++
 softmmu/meson.build         |  1 +
 6 files changed, 86 insertions(+), 64 deletions(-)
 create mode 100644 softmmu/runstate-hmp-cmds.c

diff --git a/MAINTAINERS b/MAINTAINERS
index dab4def753..b2f1d2518b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2804,8 +2804,7 @@ F: softmmu/cpus.c
 F: softmmu/cpu-throttle.c
 F: softmmu/cpu-timers.c
 F: softmmu/icount.c
-F: softmmu/runstate-action.c
-F: softmmu/runstate.c
+F: softmmu/runstate*
 F: qapi/run-state.json
 
 Read, Copy, Update (RCU)
diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
index a248ee9ed1..941da9fde6 100644
--- a/include/monitor/hmp.h
+++ b/include/monitor/hmp.h
@@ -156,6 +156,8 @@ void hmp_info_vcpu_dirty_limit(Monitor *mon, const QDict *qdict);
 void hmp_human_readable_text_helper(Monitor *mon,
                                     HumanReadableText *(*qmp_handler)(Error **));
 void hmp_info_stats(Monitor *mon, const QDict *qdict);
+void hmp_singlestep(Monitor *mon, const QDict *qdict);
+void hmp_watchdog_action(Monitor *mon, const QDict *qdict);
 void hmp_pcie_aer_inject_error(Monitor *mon, const QDict *qdict);
 void hmp_info_capture(Monitor *mon, const QDict *qdict);
 void hmp_stopcapture(Monitor *mon, const QDict *qdict);
diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
index 81f63fa8ec..34e98b0e0b 100644
--- a/monitor/hmp-cmds.c
+++ b/monitor/hmp-cmds.c
@@ -20,7 +20,6 @@
 #include "qapi/error.h"
 #include "qapi/qapi-commands-control.h"
 #include "qapi/qapi-commands-misc.h"
-#include "qapi/qapi-commands-run-state.h"
 #include "qapi/qapi-commands-stats.h"
 #include "qapi/qmp/qdict.h"
 #include "qapi/qmp/qerror.h"
@@ -80,25 +79,6 @@ void hmp_info_version(Monitor *mon, const QDict *qdict)
     qapi_free_VersionInfo(info);
 }
 
-void hmp_info_status(Monitor *mon, const QDict *qdict)
-{
-    StatusInfo *info;
-
-    info = qmp_query_status(NULL);
-
-    monitor_printf(mon, "VM status: %s%s",
-                   info->running ? "running" : "paused",
-                   info->singlestep ? " (single step mode)" : "");
-
-    if (!info->running && info->status != RUN_STATE_PAUSED) {
-        monitor_printf(mon, " (%s)", RunState_str(info->status));
-    }
-
-    monitor_printf(mon, "\n");
-
-    qapi_free_StatusInfo(info);
-}
-
 static int hmp_info_pic_foreach(Object *obj, void *opaque)
 {
     InterruptStatsProvider *intc;
diff --git a/monitor/misc.c b/monitor/misc.c
index ff3002a880..a2584df0ca 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -43,7 +43,6 @@
 #include "block/block-hmp-cmds.h"
 #include "qapi/qapi-commands-control.h"
 #include "qapi/qapi-commands-misc.h"
-#include "qapi/qapi-commands-run-state.h"
 #include "qapi/qapi-commands-machine.h"
 #include "qapi/qapi-init-commands.h"
 #include "qapi/error.h"
@@ -319,18 +318,6 @@ static void hmp_log(Monitor *mon, const QDict *qdict)
     }
 }
 
-static void hmp_singlestep(Monitor *mon, const QDict *qdict)
-{
-    const char *option = qdict_get_try_str(qdict, "option");
-    if (!option || !strcmp(option, "on")) {
-        singlestep = 1;
-    } else if (!strcmp(option, "off")) {
-        singlestep = 0;
-    } else {
-        monitor_printf(mon, "unexpected option %s\n", option);
-    }
-}
-
 static void hmp_gdbserver(Monitor *mon, const QDict *qdict)
 {
     const char *device = qdict_get_try_str(qdict, "device");
@@ -349,22 +336,6 @@ static void hmp_gdbserver(Monitor *mon, const QDict *qdict)
     }
 }
 
-static void hmp_watchdog_action(Monitor *mon, const QDict *qdict)
-{
-    Error *err = NULL;
-    WatchdogAction action;
-    char *qapi_value;
-
-    qapi_value = g_ascii_strdown(qdict_get_str(qdict, "action"), -1);
-    action = qapi_enum_parse(&WatchdogAction_lookup, qapi_value, -1, &err);
-    g_free(qapi_value);
-    if (err) {
-        hmp_handle_error(mon, err);
-        return;
-    }
-    qmp_watchdog_set_action(action, &error_abort);
-}
-
 static void monitor_printc(Monitor *mon, int c)
 {
     monitor_printf(mon, "'");
@@ -1317,19 +1288,6 @@ void device_del_completion(ReadLineState *rs, int nb_args, const char *str)
     peripheral_device_del_completion(rs, str);
 }
 
-void watchdog_action_completion(ReadLineState *rs, int nb_args, const char *str)
-{
-    int i;
-
-    if (nb_args != 2) {
-        return;
-    }
-    readline_set_completion_index(rs, strlen(str));
-    for (i = 0; i < WATCHDOG_ACTION__MAX; i++) {
-        readline_add_completion_of(rs, str, WatchdogAction_str(i));
-    }
-}
-
 static int
 compare_mon_cmd(const void *a, const void *b)
 {
diff --git a/softmmu/runstate-hmp-cmds.c b/softmmu/runstate-hmp-cmds.c
new file mode 100644
index 0000000000..d55a7d4db8
--- /dev/null
+++ b/softmmu/runstate-hmp-cmds.c
@@ -0,0 +1,82 @@
+/*
+ * HMP commands related to run state
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
+#include "exec/cpu-common.h"
+#include "monitor/hmp.h"
+#include "monitor/monitor.h"
+#include "qapi/error.h"
+#include "qapi/qapi-commands-run-state.h"
+#include "qapi/qmp/qdict.h"
+
+void hmp_info_status(Monitor *mon, const QDict *qdict)
+{
+    StatusInfo *info;
+
+    info = qmp_query_status(NULL);
+
+    monitor_printf(mon, "VM status: %s%s",
+                   info->running ? "running" : "paused",
+                   info->singlestep ? " (single step mode)" : "");
+
+    if (!info->running && info->status != RUN_STATE_PAUSED) {
+        monitor_printf(mon, " (%s)", RunState_str(info->status));
+    }
+
+    monitor_printf(mon, "\n");
+
+    qapi_free_StatusInfo(info);
+}
+
+void hmp_singlestep(Monitor *mon, const QDict *qdict)
+{
+    const char *option = qdict_get_try_str(qdict, "option");
+    if (!option || !strcmp(option, "on")) {
+        singlestep = 1;
+    } else if (!strcmp(option, "off")) {
+        singlestep = 0;
+    } else {
+        monitor_printf(mon, "unexpected option %s\n", option);
+    }
+}
+
+void hmp_watchdog_action(Monitor *mon, const QDict *qdict)
+{
+    Error *err = NULL;
+    WatchdogAction action;
+    char *qapi_value;
+
+    qapi_value = g_ascii_strdown(qdict_get_str(qdict, "action"), -1);
+    action = qapi_enum_parse(&WatchdogAction_lookup, qapi_value, -1, &err);
+    g_free(qapi_value);
+    if (err) {
+        hmp_handle_error(mon, err);
+        return;
+    }
+    qmp_watchdog_set_action(action, &error_abort);
+}
+
+void watchdog_action_completion(ReadLineState *rs, int nb_args, const char *str)
+{
+    int i;
+
+    if (nb_args != 2) {
+        return;
+    }
+    readline_set_completion_index(rs, strlen(str));
+    for (i = 0; i < WATCHDOG_ACTION__MAX; i++) {
+        readline_add_completion_of(rs, str, WatchdogAction_str(i));
+    }
+}
diff --git a/softmmu/meson.build b/softmmu/meson.build
index efbf4ec029..1828db149c 100644
--- a/softmmu/meson.build
+++ b/softmmu/meson.build
@@ -24,6 +24,7 @@ softmmu_ss.add(files(
   'qdev-monitor.c',
   'rtc.c',
   'runstate-action.c',
+  'runstate-hmp-cmds.c',
   'runstate.c',
   'tpm-hmp-cmds.c',
   'vl.c',
-- 
2.39.0

