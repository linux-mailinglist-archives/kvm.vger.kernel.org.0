Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6126797AF
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbjAXMU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbjAXMUw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:20:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E904522C
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ax6lznNIc9851/0eevMLC7z6+mVrD+w2yWYkAGGf6Zs=;
        b=PIJ4KD+erUuzDpWH+ZbVyaat9kssV0pihlsGL+JPSU6kdeCjh8E2GiouVWTx56u2RrMiqI
        XzBubgAGqlsqGcE0//b8WcwGKSbLyW9I8RIPIxOGrlhxlIaO2JTBtZ5amS19G9vbuH5HuL
        iokS/th+0c7cIxrAJ4etosQUHvVqML4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-lPwcBDrKP8ykKO3LOszyMw-1; Tue, 24 Jan 2023 07:19:50 -0500
X-MC-Unique: lPwcBDrKP8ykKO3LOszyMw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B635938123AC;
        Tue, 24 Jan 2023 12:19:49 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3507D492C14;
        Tue, 24 Jan 2023 12:19:49 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 9927421E6A28; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 08/32] trace: Move HMP commands from monitor/ to trace/
Date:   Tue, 24 Jan 2023 13:19:22 +0100
Message-Id: <20230124121946.1139465-9-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
Monitor (HMP)" and "QMP" to "Tracing".

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 include/monitor/hmp.h  |   3 +
 monitor/misc.c         | 119 ---------------------------------
 trace/trace-hmp-cmds.c | 148 +++++++++++++++++++++++++++++++++++++++++
 trace/meson.build      |   1 +
 4 files changed, 152 insertions(+), 119 deletions(-)
 create mode 100644 trace/trace-hmp-cmds.c

diff --git a/include/monitor/hmp.h b/include/monitor/hmp.h
index 5a75f4659c..58ed1bec62 100644
--- a/include/monitor/hmp.h
+++ b/include/monitor/hmp.h
@@ -155,5 +155,8 @@ void hmp_pcie_aer_inject_error(Monitor *mon, const QDict *qdict);
 void hmp_info_capture(Monitor *mon, const QDict *qdict);
 void hmp_stopcapture(Monitor *mon, const QDict *qdict);
 void hmp_wavcapture(Monitor *mon, const QDict *qdict);
+void hmp_trace_event(Monitor *mon, const QDict *qdict);
+void hmp_trace_file(Monitor *mon, const QDict *qdict);
+void hmp_info_trace_events(Monitor *mon, const QDict *qdict);
 
 #endif
diff --git a/monitor/misc.c b/monitor/misc.c
index 240d137327..2a6bc13e7f 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -39,12 +39,8 @@
 #include "qapi/qmp/qdict.h"
 #include "qapi/qmp/qerror.h"
 #include "qom/object_interfaces.h"
-#include "trace/control.h"
 #include "monitor/hmp-target.h"
 #include "monitor/hmp.h"
-#ifdef CONFIG_TRACE_SIMPLE
-#include "trace/simple.h"
-#endif
 #include "exec/address-spaces.h"
 #include "exec/ioport.h"
 #include "block/qapi.h"
@@ -54,7 +50,6 @@
 #include "qapi/qapi-commands-misc.h"
 #include "qapi/qapi-commands-qom.h"
 #include "qapi/qapi-commands-run-state.h"
-#include "qapi/qapi-commands-trace.h"
 #include "qapi/qapi-commands-machine.h"
 #include "qapi/qapi-init-commands.h"
 #include "qapi/error.h"
@@ -156,50 +151,6 @@ static void do_help_cmd(Monitor *mon, const QDict *qdict)
     hmp_help_cmd(mon, qdict_get_try_str(qdict, "name"));
 }
 
-static void hmp_trace_event(Monitor *mon, const QDict *qdict)
-{
-    const char *tp_name = qdict_get_str(qdict, "name");
-    bool new_state = qdict_get_bool(qdict, "option");
-    bool has_vcpu = qdict_haskey(qdict, "vcpu");
-    int vcpu = qdict_get_try_int(qdict, "vcpu", 0);
-    Error *local_err = NULL;
-
-    if (vcpu < 0) {
-        monitor_printf(mon, "argument vcpu must be positive");
-        return;
-    }
-
-    qmp_trace_event_set_state(tp_name, new_state, true, true, has_vcpu, vcpu, &local_err);
-    if (local_err) {
-        error_report_err(local_err);
-    }
-}
-
-#ifdef CONFIG_TRACE_SIMPLE
-static void hmp_trace_file(Monitor *mon, const QDict *qdict)
-{
-    const char *op = qdict_get_try_str(qdict, "op");
-    const char *arg = qdict_get_try_str(qdict, "arg");
-
-    if (!op) {
-        st_print_trace_file_status();
-    } else if (!strcmp(op, "on")) {
-        st_set_trace_file_enabled(true);
-    } else if (!strcmp(op, "off")) {
-        st_set_trace_file_enabled(false);
-    } else if (!strcmp(op, "flush")) {
-        st_flush_trace_buffer();
-    } else if (!strcmp(op, "set")) {
-        if (arg) {
-            st_set_trace_file(arg);
-        }
-    } else {
-        monitor_printf(mon, "unexpected argument \"%s\"\n", op);
-        hmp_help_cmd(mon, "trace-file");
-    }
-}
-#endif
-
 static void hmp_info_help(Monitor *mon, const QDict *qdict)
 {
     hmp_help_cmd(mon, "info");
@@ -344,37 +295,6 @@ static void hmp_info_history(Monitor *mon, const QDict *qdict)
     }
 }
 
-static void hmp_info_trace_events(Monitor *mon, const QDict *qdict)
-{
-    const char *name = qdict_get_try_str(qdict, "name");
-    bool has_vcpu = qdict_haskey(qdict, "vcpu");
-    int vcpu = qdict_get_try_int(qdict, "vcpu", 0);
-    TraceEventInfoList *events;
-    TraceEventInfoList *elem;
-    Error *local_err = NULL;
-
-    if (name == NULL) {
-        name = "*";
-    }
-    if (vcpu < 0) {
-        monitor_printf(mon, "argument vcpu must be positive");
-        return;
-    }
-
-    events = qmp_trace_event_get_state(name, has_vcpu, vcpu, &local_err);
-    if (local_err) {
-        error_report_err(local_err);
-        return;
-    }
-
-    for (elem = events; elem != NULL; elem = elem->next) {
-        monitor_printf(mon, "%s : state %u\n",
-                       elem->value->name,
-                       elem->value->state == TRACE_EVENT_STATE_ENABLED ? 1 : 0);
-    }
-    qapi_free_TraceEventInfoList(events);
-}
-
 void qmp_client_migrate_info(const char *protocol, const char *hostname,
                              bool has_port, int64_t port,
                              bool has_tls_port, int64_t tls_port,
@@ -1535,45 +1455,6 @@ void netdev_del_completion(ReadLineState *rs, int nb_args, const char *str)
     }
 }
 
-void info_trace_events_completion(ReadLineState *rs, int nb_args, const char *str)
-{
-    size_t len;
-
-    len = strlen(str);
-    readline_set_completion_index(rs, len);
-    if (nb_args == 2) {
-        TraceEventIter iter;
-        TraceEvent *ev;
-        char *pattern = g_strdup_printf("%s*", str);
-        trace_event_iter_init_pattern(&iter, pattern);
-        while ((ev = trace_event_iter_next(&iter)) != NULL) {
-            readline_add_completion(rs, trace_event_get_name(ev));
-        }
-        g_free(pattern);
-    }
-}
-
-void trace_event_completion(ReadLineState *rs, int nb_args, const char *str)
-{
-    size_t len;
-
-    len = strlen(str);
-    readline_set_completion_index(rs, len);
-    if (nb_args == 2) {
-        TraceEventIter iter;
-        TraceEvent *ev;
-        char *pattern = g_strdup_printf("%s*", str);
-        trace_event_iter_init_pattern(&iter, pattern);
-        while ((ev = trace_event_iter_next(&iter)) != NULL) {
-            readline_add_completion(rs, trace_event_get_name(ev));
-        }
-        g_free(pattern);
-    } else if (nb_args == 3) {
-        readline_add_completion_of(rs, str, "on");
-        readline_add_completion_of(rs, str, "off");
-    }
-}
-
 void watchdog_action_completion(ReadLineState *rs, int nb_args, const char *str)
 {
     int i;
diff --git a/trace/trace-hmp-cmds.c b/trace/trace-hmp-cmds.c
new file mode 100644
index 0000000000..792876c34a
--- /dev/null
+++ b/trace/trace-hmp-cmds.c
@@ -0,0 +1,148 @@
+/*
+ * HMP commands related to tracing
+ *
+ * Copyright (c) 2003-2004 Fabrice Bellard
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to deal
+ * in the Software without restriction, including without limitation the rights
+ * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
+ * copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
+ * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
+ * THE SOFTWARE.
+ */
+
+#include "qemu/osdep.h"
+#include "monitor/hmp.h"
+#include "monitor/monitor.h"
+#include "qapi/error.h"
+#include "qapi/qapi-commands-trace.h"
+#include "qapi/qmp/qdict.h"
+#include "trace/control.h"
+#ifdef CONFIG_TRACE_SIMPLE
+#include "trace/simple.h"
+#endif
+
+void hmp_trace_event(Monitor *mon, const QDict *qdict)
+{
+    const char *tp_name = qdict_get_str(qdict, "name");
+    bool new_state = qdict_get_bool(qdict, "option");
+    bool has_vcpu = qdict_haskey(qdict, "vcpu");
+    int vcpu = qdict_get_try_int(qdict, "vcpu", 0);
+    Error *local_err = NULL;
+
+    if (vcpu < 0) {
+        monitor_printf(mon, "argument vcpu must be positive");
+        return;
+    }
+
+    qmp_trace_event_set_state(tp_name, new_state, true, true, has_vcpu, vcpu, &local_err);
+    if (local_err) {
+        error_report_err(local_err);
+    }
+}
+
+#ifdef CONFIG_TRACE_SIMPLE
+void hmp_trace_file(Monitor *mon, const QDict *qdict)
+{
+    const char *op = qdict_get_try_str(qdict, "op");
+    const char *arg = qdict_get_try_str(qdict, "arg");
+
+    if (!op) {
+        st_print_trace_file_status();
+    } else if (!strcmp(op, "on")) {
+        st_set_trace_file_enabled(true);
+    } else if (!strcmp(op, "off")) {
+        st_set_trace_file_enabled(false);
+    } else if (!strcmp(op, "flush")) {
+        st_flush_trace_buffer();
+    } else if (!strcmp(op, "set")) {
+        if (arg) {
+            st_set_trace_file(arg);
+        }
+    } else {
+        monitor_printf(mon, "unexpected argument \"%s\"\n", op);
+        hmp_help_cmd(mon, "trace-file");
+    }
+}
+#endif
+
+void hmp_info_trace_events(Monitor *mon, const QDict *qdict)
+{
+    const char *name = qdict_get_try_str(qdict, "name");
+    bool has_vcpu = qdict_haskey(qdict, "vcpu");
+    int vcpu = qdict_get_try_int(qdict, "vcpu", 0);
+    TraceEventInfoList *events;
+    TraceEventInfoList *elem;
+    Error *local_err = NULL;
+
+    if (name == NULL) {
+        name = "*";
+    }
+    if (vcpu < 0) {
+        monitor_printf(mon, "argument vcpu must be positive");
+        return;
+    }
+
+    events = qmp_trace_event_get_state(name, has_vcpu, vcpu, &local_err);
+    if (local_err) {
+        error_report_err(local_err);
+        return;
+    }
+
+    for (elem = events; elem != NULL; elem = elem->next) {
+        monitor_printf(mon, "%s : state %u\n",
+                       elem->value->name,
+                       elem->value->state == TRACE_EVENT_STATE_ENABLED ? 1 : 0);
+    }
+    qapi_free_TraceEventInfoList(events);
+}
+
+void info_trace_events_completion(ReadLineState *rs, int nb_args, const char *str)
+{
+    size_t len;
+
+    len = strlen(str);
+    readline_set_completion_index(rs, len);
+    if (nb_args == 2) {
+        TraceEventIter iter;
+        TraceEvent *ev;
+        char *pattern = g_strdup_printf("%s*", str);
+        trace_event_iter_init_pattern(&iter, pattern);
+        while ((ev = trace_event_iter_next(&iter)) != NULL) {
+            readline_add_completion(rs, trace_event_get_name(ev));
+        }
+        g_free(pattern);
+    }
+}
+
+void trace_event_completion(ReadLineState *rs, int nb_args, const char *str)
+{
+    size_t len;
+
+    len = strlen(str);
+    readline_set_completion_index(rs, len);
+    if (nb_args == 2) {
+        TraceEventIter iter;
+        TraceEvent *ev;
+        char *pattern = g_strdup_printf("%s*", str);
+        trace_event_iter_init_pattern(&iter, pattern);
+        while ((ev = trace_event_iter_next(&iter)) != NULL) {
+            readline_add_completion(rs, trace_event_get_name(ev));
+        }
+        g_free(pattern);
+    } else if (nb_args == 3) {
+        readline_add_completion_of(rs, str, "on");
+        readline_add_completion_of(rs, str, "off");
+    }
+}
diff --git a/trace/meson.build b/trace/meson.build
index 26b54714d5..d565948b09 100644
--- a/trace/meson.build
+++ b/trace/meson.build
@@ -1,3 +1,4 @@
+softmmu_ss.add(files('trace-hmp-cmds.c'))
 
 specific_ss.add(files('control-target.c'))
 
-- 
2.39.0

