Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C6B6797C5
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbjAXMVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbjAXMVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:21:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011AC457C9
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zrHFqdxaJ1FukC6o9R9vrW4WYB4OCLf5Uvb1NNS51kc=;
        b=bKuhE2a3qcgETGl5Adj4rRTbW1x107B3pSA/SnUfJxSk6LFaCMG/J0DDIjW6gcMvXI2bYK
        itxsayhRLzTv3llXUhzHr0eTAgF6u3UGYFeKf2oHnGkq817iTatlg/SvbA1VvLaaf+Da64
        KXKbQaGwhGFZA9QJglAp/XAYQycoXi4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-zD5x3SLpNKyvTaByLDFxgw-1; Tue, 24 Jan 2023 07:19:51 -0500
X-MC-Unique: zD5x3SLpNKyvTaByLDFxgw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3629180D0F8;
        Tue, 24 Jan 2023 12:19:51 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A382C140EBF6;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id C67B021E6925; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 23/32] stats: Move HMP commands from monitor/ to stats/
Date:   Tue, 24 Jan 2023 13:19:37 +0100
Message-Id: <20230124121946.1139465-24-armbru@redhat.com>
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
Monitor (HMP)" to section "Stats".

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 monitor/hmp-cmds.c     | 234 --------------------------------------
 stats/stats-hmp-cmds.c | 247 +++++++++++++++++++++++++++++++++++++++++
 stats/meson.build      |   2 +-
 3 files changed, 248 insertions(+), 235 deletions(-)
 create mode 100644 stats/stats-hmp-cmds.c

diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
index 34e98b0e0b..8a3d56bcde 100644
--- a/monitor/hmp-cmds.c
+++ b/monitor/hmp-cmds.c
@@ -20,11 +20,9 @@
 #include "qapi/error.h"
 #include "qapi/qapi-commands-control.h"
 #include "qapi/qapi-commands-misc.h"
-#include "qapi/qapi-commands-stats.h"
 #include "qapi/qmp/qdict.h"
 #include "qapi/qmp/qerror.h"
 #include "qemu/cutils.h"
-#include "hw/core/cpu.h"
 #include "hw/intc/intc.h"
 
 bool hmp_handle_error(Monitor *mon, Error *err)
@@ -226,235 +224,3 @@ void hmp_info_iothreads(Monitor *mon, const QDict *qdict)
 
     qapi_free_IOThreadInfoList(info_list);
 }
-
-static void print_stats_schema_value(Monitor *mon, StatsSchemaValue *value)
-{
-    const char *unit = NULL;
-    monitor_printf(mon, "    %s (%s%s", value->name, StatsType_str(value->type),
-                   value->has_unit || value->exponent ? ", " : "");
-
-    if (value->has_unit) {
-        if (value->unit == STATS_UNIT_SECONDS) {
-            unit = "s";
-        } else if (value->unit == STATS_UNIT_BYTES) {
-            unit = "B";
-        }
-    }
-
-    if (unit && value->base == 10 &&
-        value->exponent >= -18 && value->exponent <= 18 &&
-        value->exponent % 3 == 0) {
-        monitor_puts(mon, si_prefix(value->exponent));
-    } else if (unit && value->base == 2 &&
-               value->exponent >= 0 && value->exponent <= 60 &&
-               value->exponent % 10 == 0) {
-
-        monitor_puts(mon, iec_binary_prefix(value->exponent));
-    } else if (value->exponent) {
-        /* Use exponential notation and write the unit's English name */
-        monitor_printf(mon, "* %d^%d%s",
-                       value->base, value->exponent,
-                       value->has_unit ? " " : "");
-        unit = NULL;
-    }
-
-    if (value->has_unit) {
-        monitor_puts(mon, unit ? unit : StatsUnit_str(value->unit));
-    }
-
-    /* Print bucket size for linear histograms */
-    if (value->type == STATS_TYPE_LINEAR_HISTOGRAM && value->has_bucket_size) {
-        monitor_printf(mon, ", bucket size=%d", value->bucket_size);
-    }
-    monitor_printf(mon, ")");
-}
-
-static StatsSchemaValueList *find_schema_value_list(
-    StatsSchemaList *list, StatsProvider provider,
-    StatsTarget target)
-{
-    StatsSchemaList *node;
-
-    for (node = list; node; node = node->next) {
-        if (node->value->provider == provider &&
-            node->value->target == target) {
-            return node->value->stats;
-        }
-    }
-    return NULL;
-}
-
-static void print_stats_results(Monitor *mon, StatsTarget target,
-                                bool show_provider,
-                                StatsResult *result,
-                                StatsSchemaList *schema)
-{
-    /* Find provider schema */
-    StatsSchemaValueList *schema_value_list =
-        find_schema_value_list(schema, result->provider, target);
-    StatsList *stats_list;
-
-    if (!schema_value_list) {
-        monitor_printf(mon, "failed to find schema list for %s\n",
-                       StatsProvider_str(result->provider));
-        return;
-    }
-
-    if (show_provider) {
-        monitor_printf(mon, "provider: %s\n",
-                       StatsProvider_str(result->provider));
-    }
-
-    for (stats_list = result->stats; stats_list;
-             stats_list = stats_list->next,
-             schema_value_list = schema_value_list->next) {
-
-        Stats *stats = stats_list->value;
-        StatsValue *stats_value = stats->value;
-        StatsSchemaValue *schema_value = schema_value_list->value;
-
-        /* Find schema entry */
-        while (!g_str_equal(stats->name, schema_value->name)) {
-            if (!schema_value_list->next) {
-                monitor_printf(mon, "failed to find schema entry for %s\n",
-                               stats->name);
-                return;
-            }
-            schema_value_list = schema_value_list->next;
-            schema_value = schema_value_list->value;
-        }
-
-        print_stats_schema_value(mon, schema_value);
-
-        if (stats_value->type == QTYPE_QNUM) {
-            monitor_printf(mon, ": %" PRId64 "\n", stats_value->u.scalar);
-        } else if (stats_value->type == QTYPE_QBOOL) {
-            monitor_printf(mon, ": %s\n", stats_value->u.boolean ? "yes" : "no");
-        } else if (stats_value->type == QTYPE_QLIST) {
-            uint64List *list;
-            int i;
-
-            monitor_printf(mon, ": ");
-            for (list = stats_value->u.list, i = 1;
-                 list;
-                 list = list->next, i++) {
-                monitor_printf(mon, "[%d]=%" PRId64 " ", i, list->value);
-            }
-            monitor_printf(mon, "\n");
-        }
-    }
-}
-
-/* Create the StatsFilter that is needed for an "info stats" invocation.  */
-static StatsFilter *stats_filter(StatsTarget target, const char *names,
-                                 int cpu_index, StatsProvider provider)
-{
-    StatsFilter *filter = g_malloc0(sizeof(*filter));
-    StatsProvider provider_idx;
-    StatsRequestList *request_list = NULL;
-
-    filter->target = target;
-    switch (target) {
-    case STATS_TARGET_VM:
-        break;
-    case STATS_TARGET_VCPU:
-    {
-        strList *vcpu_list = NULL;
-        CPUState *cpu = qemu_get_cpu(cpu_index);
-        char *canonical_path = object_get_canonical_path(OBJECT(cpu));
-
-        QAPI_LIST_PREPEND(vcpu_list, canonical_path);
-        filter->u.vcpu.has_vcpus = true;
-        filter->u.vcpu.vcpus = vcpu_list;
-        break;
-    }
-    default:
-        break;
-    }
-
-    if (!names && provider == STATS_PROVIDER__MAX) {
-        return filter;
-    }
-
-    /*
-     * "info stats" can only query either one or all the providers.  Querying
-     * by name, but not by provider, requires the creation of one filter per
-     * provider.
-     */
-    for (provider_idx = 0; provider_idx < STATS_PROVIDER__MAX; provider_idx++) {
-        if (provider == STATS_PROVIDER__MAX || provider == provider_idx) {
-            StatsRequest *request = g_new0(StatsRequest, 1);
-            request->provider = provider_idx;
-            if (names && !g_str_equal(names, "*")) {
-                request->has_names = true;
-                request->names = hmp_split_at_comma(names);
-            }
-            QAPI_LIST_PREPEND(request_list, request);
-        }
-    }
-
-    filter->has_providers = true;
-    filter->providers = request_list;
-    return filter;
-}
-
-void hmp_info_stats(Monitor *mon, const QDict *qdict)
-{
-    const char *target_str = qdict_get_str(qdict, "target");
-    const char *provider_str = qdict_get_try_str(qdict, "provider");
-    const char *names = qdict_get_try_str(qdict, "names");
-
-    StatsProvider provider = STATS_PROVIDER__MAX;
-    StatsTarget target;
-    Error *err = NULL;
-    g_autoptr(StatsSchemaList) schema = NULL;
-    g_autoptr(StatsResultList) stats = NULL;
-    g_autoptr(StatsFilter) filter = NULL;
-    StatsResultList *entry;
-
-    target = qapi_enum_parse(&StatsTarget_lookup, target_str, -1, &err);
-    if (err) {
-        monitor_printf(mon, "invalid stats target %s\n", target_str);
-        goto exit_no_print;
-    }
-    if (provider_str) {
-        provider = qapi_enum_parse(&StatsProvider_lookup, provider_str, -1, &err);
-        if (err) {
-            monitor_printf(mon, "invalid stats provider %s\n", provider_str);
-            goto exit_no_print;
-        }
-    }
-
-    schema = qmp_query_stats_schemas(provider_str ? true : false,
-                                     provider, &err);
-    if (err) {
-        goto exit;
-    }
-
-    switch (target) {
-    case STATS_TARGET_VM:
-        filter = stats_filter(target, names, -1, provider);
-        break;
-    case STATS_TARGET_VCPU: {}
-        int cpu_index = monitor_get_cpu_index(mon);
-        filter = stats_filter(target, names, cpu_index, provider);
-        break;
-    default:
-        abort();
-    }
-
-    stats = qmp_query_stats(filter, &err);
-    if (err) {
-        goto exit;
-    }
-    for (entry = stats; entry; entry = entry->next) {
-        print_stats_results(mon, target, provider_str == NULL, entry->value, schema);
-    }
-
-exit:
-    if (err) {
-        monitor_printf(mon, "%s\n", error_get_pretty(err));
-    }
-exit_no_print:
-    error_free(err);
-}
diff --git a/stats/stats-hmp-cmds.c b/stats/stats-hmp-cmds.c
new file mode 100644
index 0000000000..531e35d128
--- /dev/null
+++ b/stats/stats-hmp-cmds.c
@@ -0,0 +1,247 @@
+/*
+ * HMP commands related to stats
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * (at your option) any later version.
+ */
+
+#include "qemu/osdep.h"
+#include "qapi/qapi-commands-stats.h"
+#include "monitor/hmp.h"
+#include "monitor/monitor.h"
+#include "qemu/cutils.h"
+#include "hw/core/cpu.h"
+#include "qapi/qmp/qdict.h"
+#include "qapi/error.h"
+
+static void print_stats_schema_value(Monitor *mon, StatsSchemaValue *value)
+{
+    const char *unit = NULL;
+    monitor_printf(mon, "    %s (%s%s", value->name, StatsType_str(value->type),
+                   value->has_unit || value->exponent ? ", " : "");
+
+    if (value->has_unit) {
+        if (value->unit == STATS_UNIT_SECONDS) {
+            unit = "s";
+        } else if (value->unit == STATS_UNIT_BYTES) {
+            unit = "B";
+        }
+    }
+
+    if (unit && value->base == 10 &&
+        value->exponent >= -18 && value->exponent <= 18 &&
+        value->exponent % 3 == 0) {
+        monitor_puts(mon, si_prefix(value->exponent));
+    } else if (unit && value->base == 2 &&
+               value->exponent >= 0 && value->exponent <= 60 &&
+               value->exponent % 10 == 0) {
+
+        monitor_puts(mon, iec_binary_prefix(value->exponent));
+    } else if (value->exponent) {
+        /* Use exponential notation and write the unit's English name */
+        monitor_printf(mon, "* %d^%d%s",
+                       value->base, value->exponent,
+                       value->has_unit ? " " : "");
+        unit = NULL;
+    }
+
+    if (value->has_unit) {
+        monitor_puts(mon, unit ? unit : StatsUnit_str(value->unit));
+    }
+
+    /* Print bucket size for linear histograms */
+    if (value->type == STATS_TYPE_LINEAR_HISTOGRAM && value->has_bucket_size) {
+        monitor_printf(mon, ", bucket size=%d", value->bucket_size);
+    }
+    monitor_printf(mon, ")");
+}
+
+static StatsSchemaValueList *find_schema_value_list(
+    StatsSchemaList *list, StatsProvider provider,
+    StatsTarget target)
+{
+    StatsSchemaList *node;
+
+    for (node = list; node; node = node->next) {
+        if (node->value->provider == provider &&
+            node->value->target == target) {
+            return node->value->stats;
+        }
+    }
+    return NULL;
+}
+
+static void print_stats_results(Monitor *mon, StatsTarget target,
+                                bool show_provider,
+                                StatsResult *result,
+                                StatsSchemaList *schema)
+{
+    /* Find provider schema */
+    StatsSchemaValueList *schema_value_list =
+        find_schema_value_list(schema, result->provider, target);
+    StatsList *stats_list;
+
+    if (!schema_value_list) {
+        monitor_printf(mon, "failed to find schema list for %s\n",
+                       StatsProvider_str(result->provider));
+        return;
+    }
+
+    if (show_provider) {
+        monitor_printf(mon, "provider: %s\n",
+                       StatsProvider_str(result->provider));
+    }
+
+    for (stats_list = result->stats; stats_list;
+             stats_list = stats_list->next,
+             schema_value_list = schema_value_list->next) {
+
+        Stats *stats = stats_list->value;
+        StatsValue *stats_value = stats->value;
+        StatsSchemaValue *schema_value = schema_value_list->value;
+
+        /* Find schema entry */
+        while (!g_str_equal(stats->name, schema_value->name)) {
+            if (!schema_value_list->next) {
+                monitor_printf(mon, "failed to find schema entry for %s\n",
+                               stats->name);
+                return;
+            }
+            schema_value_list = schema_value_list->next;
+            schema_value = schema_value_list->value;
+        }
+
+        print_stats_schema_value(mon, schema_value);
+
+        if (stats_value->type == QTYPE_QNUM) {
+            monitor_printf(mon, ": %" PRId64 "\n", stats_value->u.scalar);
+        } else if (stats_value->type == QTYPE_QBOOL) {
+            monitor_printf(mon, ": %s\n", stats_value->u.boolean ? "yes" : "no");
+        } else if (stats_value->type == QTYPE_QLIST) {
+            uint64List *list;
+            int i;
+
+            monitor_printf(mon, ": ");
+            for (list = stats_value->u.list, i = 1;
+                 list;
+                 list = list->next, i++) {
+                monitor_printf(mon, "[%d]=%" PRId64 " ", i, list->value);
+            }
+            monitor_printf(mon, "\n");
+        }
+    }
+}
+
+/* Create the StatsFilter that is needed for an "info stats" invocation.  */
+static StatsFilter *stats_filter(StatsTarget target, const char *names,
+                                 int cpu_index, StatsProvider provider)
+{
+    StatsFilter *filter = g_malloc0(sizeof(*filter));
+    StatsProvider provider_idx;
+    StatsRequestList *request_list = NULL;
+
+    filter->target = target;
+    switch (target) {
+    case STATS_TARGET_VM:
+        break;
+    case STATS_TARGET_VCPU:
+    {
+        strList *vcpu_list = NULL;
+        CPUState *cpu = qemu_get_cpu(cpu_index);
+        char *canonical_path = object_get_canonical_path(OBJECT(cpu));
+
+        QAPI_LIST_PREPEND(vcpu_list, canonical_path);
+        filter->u.vcpu.has_vcpus = true;
+        filter->u.vcpu.vcpus = vcpu_list;
+        break;
+    }
+    default:
+        break;
+    }
+
+    if (!names && provider == STATS_PROVIDER__MAX) {
+        return filter;
+    }
+
+    /*
+     * "info stats" can only query either one or all the providers.  Querying
+     * by name, but not by provider, requires the creation of one filter per
+     * provider.
+     */
+    for (provider_idx = 0; provider_idx < STATS_PROVIDER__MAX; provider_idx++) {
+        if (provider == STATS_PROVIDER__MAX || provider == provider_idx) {
+            StatsRequest *request = g_new0(StatsRequest, 1);
+            request->provider = provider_idx;
+            if (names && !g_str_equal(names, "*")) {
+                request->has_names = true;
+                request->names = hmp_split_at_comma(names);
+            }
+            QAPI_LIST_PREPEND(request_list, request);
+        }
+    }
+
+    filter->has_providers = true;
+    filter->providers = request_list;
+    return filter;
+}
+
+void hmp_info_stats(Monitor *mon, const QDict *qdict)
+{
+    const char *target_str = qdict_get_str(qdict, "target");
+    const char *provider_str = qdict_get_try_str(qdict, "provider");
+    const char *names = qdict_get_try_str(qdict, "names");
+
+    StatsProvider provider = STATS_PROVIDER__MAX;
+    StatsTarget target;
+    Error *err = NULL;
+    g_autoptr(StatsSchemaList) schema = NULL;
+    g_autoptr(StatsResultList) stats = NULL;
+    g_autoptr(StatsFilter) filter = NULL;
+    StatsResultList *entry;
+
+    target = qapi_enum_parse(&StatsTarget_lookup, target_str, -1, &err);
+    if (err) {
+        monitor_printf(mon, "invalid stats target %s\n", target_str);
+        goto exit_no_print;
+    }
+    if (provider_str) {
+        provider = qapi_enum_parse(&StatsProvider_lookup, provider_str, -1, &err);
+        if (err) {
+            monitor_printf(mon, "invalid stats provider %s\n", provider_str);
+            goto exit_no_print;
+        }
+    }
+
+    schema = qmp_query_stats_schemas(provider_str ? true : false,
+                                     provider, &err);
+    if (err) {
+        goto exit;
+    }
+
+    switch (target) {
+    case STATS_TARGET_VM:
+        filter = stats_filter(target, names, -1, provider);
+        break;
+    case STATS_TARGET_VCPU: {}
+        int cpu_index = monitor_get_cpu_index(mon);
+        filter = stats_filter(target, names, cpu_index, provider);
+        break;
+    default:
+        abort();
+    }
+
+    stats = qmp_query_stats(filter, &err);
+    if (err) {
+        goto exit;
+    }
+    for (entry = stats; entry; entry = entry->next) {
+        print_stats_results(mon, target, provider_str == NULL, entry->value, schema);
+    }
+
+exit:
+    if (err) {
+        monitor_printf(mon, "%s\n", error_get_pretty(err));
+    }
+exit_no_print:
+    error_free(err);
+}
diff --git a/stats/meson.build b/stats/meson.build
index 4ddb4d096b..c4153f979e 100644
--- a/stats/meson.build
+++ b/stats/meson.build
@@ -1 +1 @@
-softmmu_ss.add(files('stats-qmp-cmds.c'))
+softmmu_ss.add(files('stats-hmp-cmds.c', 'stats-qmp-cmds.c'))
-- 
2.39.0

