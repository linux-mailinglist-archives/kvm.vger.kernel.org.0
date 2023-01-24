Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B236797AE
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbjAXMUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233681AbjAXMUw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:20:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F9A4523F
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iXiQrUr5XCSj5h5YNDSXqk0MGej/rqbBd9ZmLMzas/A=;
        b=J9Cd9836M1F1DRrnIn1yYwbWFk7L5eP/LV8IEOSpS8mjCtNPU9aOwt8RKYERxWzQk+O2/h
        H5tQdfQjdzmJgCm6vB3eG2xDKhW8v/HJl2fJVgMrnf7FNuGsP8+yujeObDyUBM8Ou3q9Uo
        P5JLzGr5gd6tI52/kDVjT6mehhiA0rI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-8ER3mH3xNvCk7OSNxUDPdA-1; Tue, 24 Jan 2023 07:19:51 -0500
X-MC-Unique: 8ER3mH3xNvCk7OSNxUDPdA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED63D8030A0;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 90E8AC15BAD;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id BD33421E6921; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 20/32] tpm: Move HMP commands from monitor/ to softmmu/
Date:   Tue, 24 Jan 2023 13:19:34 +0100
Message-Id: <20230124121946.1139465-21-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
Monitor (HMP)" to "TPM".

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 MAINTAINERS            |  2 +-
 monitor/hmp-cmds.c     | 54 -----------------------------------
 softmmu/tpm-hmp-cmds.c | 65 ++++++++++++++++++++++++++++++++++++++++++
 softmmu/meson.build    |  1 +
 4 files changed, 67 insertions(+), 55 deletions(-)
 create mode 100644 softmmu/tpm-hmp-cmds.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 3bd4d101d3..dab4def753 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3067,7 +3067,7 @@ T: git https://github.com/stefanha/qemu.git tracing
 TPM
 M: Stefan Berger <stefanb@linux.ibm.com>
 S: Maintained
-F: softmmu/tpm.c
+F: softmmu/tpm*
 F: hw/tpm/*
 F: include/hw/acpi/tpm.h
 F: include/sysemu/tpm*
diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
index 6b1d5358f7..81f63fa8ec 100644
--- a/monitor/hmp-cmds.c
+++ b/monitor/hmp-cmds.c
@@ -22,7 +22,6 @@
 #include "qapi/qapi-commands-misc.h"
 #include "qapi/qapi-commands-run-state.h"
 #include "qapi/qapi-commands-stats.h"
-#include "qapi/qapi-commands-tpm.h"
 #include "qapi/qmp/qdict.h"
 #include "qapi/qmp/qerror.h"
 #include "qemu/cutils.h"
@@ -126,59 +125,6 @@ void hmp_info_pic(Monitor *mon, const QDict *qdict)
                                    hmp_info_pic_foreach, mon);
 }
 
-void hmp_info_tpm(Monitor *mon, const QDict *qdict)
-{
-#ifdef CONFIG_TPM
-    TPMInfoList *info_list, *info;
-    Error *err = NULL;
-    unsigned int c = 0;
-    TPMPassthroughOptions *tpo;
-    TPMEmulatorOptions *teo;
-
-    info_list = qmp_query_tpm(&err);
-    if (err) {
-        monitor_printf(mon, "TPM device not supported\n");
-        error_free(err);
-        return;
-    }
-
-    if (info_list) {
-        monitor_printf(mon, "TPM device:\n");
-    }
-
-    for (info = info_list; info; info = info->next) {
-        TPMInfo *ti = info->value;
-        monitor_printf(mon, " tpm%d: model=%s\n",
-                       c, TpmModel_str(ti->model));
-
-        monitor_printf(mon, "  \\ %s: type=%s",
-                       ti->id, TpmType_str(ti->options->type));
-
-        switch (ti->options->type) {
-        case TPM_TYPE_PASSTHROUGH:
-            tpo = ti->options->u.passthrough.data;
-            monitor_printf(mon, "%s%s%s%s",
-                           tpo->path ? ",path=" : "",
-                           tpo->path ?: "",
-                           tpo->cancel_path ? ",cancel-path=" : "",
-                           tpo->cancel_path ?: "");
-            break;
-        case TPM_TYPE_EMULATOR:
-            teo = ti->options->u.emulator.data;
-            monitor_printf(mon, ",chardev=%s", teo->chardev);
-            break;
-        case TPM_TYPE__MAX:
-            break;
-        }
-        monitor_printf(mon, "\n");
-        c++;
-    }
-    qapi_free_TPMInfoList(info_list);
-#else
-    monitor_printf(mon, "TPM device not supported\n");
-#endif /* CONFIG_TPM */
-}
-
 void hmp_quit(Monitor *mon, const QDict *qdict)
 {
     monitor_suspend(mon);
diff --git a/softmmu/tpm-hmp-cmds.c b/softmmu/tpm-hmp-cmds.c
new file mode 100644
index 0000000000..9ed6ad6c4d
--- /dev/null
+++ b/softmmu/tpm-hmp-cmds.c
@@ -0,0 +1,65 @@
+/*
+ * HMP commands related to TPM
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * (at your option) any later version.
+ */
+
+#include "qemu/osdep.h"
+#include "qapi/qapi-commands-tpm.h"
+#include "monitor/monitor.h"
+#include "monitor/hmp.h"
+#include "qapi/error.h"
+
+void hmp_info_tpm(Monitor *mon, const QDict *qdict)
+{
+#ifdef CONFIG_TPM
+    TPMInfoList *info_list, *info;
+    Error *err = NULL;
+    unsigned int c = 0;
+    TPMPassthroughOptions *tpo;
+    TPMEmulatorOptions *teo;
+
+    info_list = qmp_query_tpm(&err);
+    if (err) {
+        monitor_printf(mon, "TPM device not supported\n");
+        error_free(err);
+        return;
+    }
+
+    if (info_list) {
+        monitor_printf(mon, "TPM device:\n");
+    }
+
+    for (info = info_list; info; info = info->next) {
+        TPMInfo *ti = info->value;
+        monitor_printf(mon, " tpm%d: model=%s\n",
+                       c, TpmModel_str(ti->model));
+
+        monitor_printf(mon, "  \\ %s: type=%s",
+                       ti->id, TpmType_str(ti->options->type));
+
+        switch (ti->options->type) {
+        case TPM_TYPE_PASSTHROUGH:
+            tpo = ti->options->u.passthrough.data;
+            monitor_printf(mon, "%s%s%s%s",
+                           tpo->path ? ",path=" : "",
+                           tpo->path ?: "",
+                           tpo->cancel_path ? ",cancel-path=" : "",
+                           tpo->cancel_path ?: "");
+            break;
+        case TPM_TYPE_EMULATOR:
+            teo = ti->options->u.emulator.data;
+            monitor_printf(mon, ",chardev=%s", teo->chardev);
+            break;
+        case TPM_TYPE__MAX:
+            break;
+        }
+        monitor_printf(mon, "\n");
+        c++;
+    }
+    qapi_free_TPMInfoList(info_list);
+#else
+    monitor_printf(mon, "TPM device not supported\n");
+#endif /* CONFIG_TPM */
+}
diff --git a/softmmu/meson.build b/softmmu/meson.build
index 3272af1f31..efbf4ec029 100644
--- a/softmmu/meson.build
+++ b/softmmu/meson.build
@@ -25,6 +25,7 @@ softmmu_ss.add(files(
   'rtc.c',
   'runstate-action.c',
   'runstate.c',
+  'tpm-hmp-cmds.c',
   'vl.c',
 ), sdl, libpmem, libdaxctl)
 
-- 
2.39.0

