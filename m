Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591486797BA
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbjAXMVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbjAXMU7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:20:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3C5457FA
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=peJDGCE5Li8WZPkCEfSc5J09unht87UUPPXXYzMpbYs=;
        b=Kmx7HdsYl+y03J/n7+vl4NRR5fOo8jSQ4WcT0eWpTJycnMeDSt9ALZ5Iz/jMkMRDQOWzis
        0YD0PvGQiwbf9LOIiju1jbhYIbHtwKBIECkL2qP2xgOpifsLfxHy3PCKwz9t5a6OWHguLe
        luObchXkPs5LIWiYHYlAsoM2JifAchI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-lsJTD9gtOsyPgV4eUN7h4Q-1; Tue, 24 Jan 2023 07:19:51 -0500
X-MC-Unique: lsJTD9gtOsyPgV4eUN7h4Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05DBE8533EB;
        Tue, 24 Jan 2023 12:19:51 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C46F2026D2A;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id C372721E6923; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 22/32] stats: Move QMP commands from monitor/ to stats/
Date:   Tue, 24 Jan 2023 13:19:36 +0100
Message-Id: <20230124121946.1139465-23-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This moves these commands from MAINTAINERS section "QMP" to new
section "Stats".  Status is Orphan.  Volunteers welcome!

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 MAINTAINERS                         |   5 +
 meson.build                         |   1 +
 include/{monitor => sysemu}/stats.h |   0
 accel/kvm/kvm-all.c                 |   2 +-
 monitor/qmp-cmds.c                  | 152 --------------------------
 stats/stats-qmp-cmds.c              | 162 ++++++++++++++++++++++++++++
 stats/meson.build                   |   1 +
 7 files changed, 170 insertions(+), 153 deletions(-)
 rename include/{monitor => sysemu}/stats.h (100%)
 create mode 100644 stats/stats-qmp-cmds.c
 create mode 100644 stats/meson.build

diff --git a/MAINTAINERS b/MAINTAINERS
index b2f1d2518b..b377ac1476 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3038,6 +3038,11 @@ F: net/slirp.c
 F: include/net/slirp.h
 T: git https://people.debian.org/~sthibault/qemu.git slirp
 
+Stats
+S: Orphan
+F: include/sysemu/stats.h
+F: stats/
+
 Streams
 M: Edgar E. Iglesias <edgar.iglesias@gmail.com>
 S: Maintained
diff --git a/meson.build b/meson.build
index 6d3b665629..57b35d721e 100644
--- a/meson.build
+++ b/meson.build
@@ -3132,6 +3132,7 @@ subdir('monitor')
 subdir('net')
 subdir('replay')
 subdir('semihosting')
+subdir('stats')
 subdir('tcg')
 subdir('fpu')
 subdir('accel')
diff --git a/include/monitor/stats.h b/include/sysemu/stats.h
similarity index 100%
rename from include/monitor/stats.h
rename to include/sysemu/stats.h
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 7e6a6076b1..9b26582655 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -50,7 +50,7 @@
 #include "qemu/range.h"
 
 #include "hw/boards.h"
-#include "monitor/stats.h"
+#include "sysemu/stats.h"
 
 /* This check must be after config-host.h is included */
 #ifdef CONFIG_EVENTFD
diff --git a/monitor/qmp-cmds.c b/monitor/qmp-cmds.c
index 4a8d1e9a15..ab23e52f97 100644
--- a/monitor/qmp-cmds.c
+++ b/monitor/qmp-cmds.c
@@ -25,13 +25,11 @@
 #include "qapi/qapi-commands-acpi.h"
 #include "qapi/qapi-commands-control.h"
 #include "qapi/qapi-commands-misc.h"
-#include "qapi/qapi-commands-stats.h"
 #include "qapi/type-helpers.h"
 #include "hw/mem/memory-device.h"
 #include "hw/acpi/acpi_dev_interface.h"
 #include "hw/intc/intc.h"
 #include "hw/rdma/rdma.h"
-#include "monitor/stats.h"
 
 NameInfo *qmp_query_name(Error **errp)
 {
@@ -174,153 +172,3 @@ ACPIOSTInfoList *qmp_query_acpi_ospm_status(Error **errp)
 
     return head;
 }
-
-typedef struct StatsCallbacks {
-    StatsProvider provider;
-    StatRetrieveFunc *stats_cb;
-    SchemaRetrieveFunc *schemas_cb;
-    QTAILQ_ENTRY(StatsCallbacks) next;
-} StatsCallbacks;
-
-static QTAILQ_HEAD(, StatsCallbacks) stats_callbacks =
-    QTAILQ_HEAD_INITIALIZER(stats_callbacks);
-
-void add_stats_callbacks(StatsProvider provider,
-                         StatRetrieveFunc *stats_fn,
-                         SchemaRetrieveFunc *schemas_fn)
-{
-    StatsCallbacks *entry = g_new(StatsCallbacks, 1);
-    entry->provider = provider;
-    entry->stats_cb = stats_fn;
-    entry->schemas_cb = schemas_fn;
-
-    QTAILQ_INSERT_TAIL(&stats_callbacks, entry, next);
-}
-
-static bool invoke_stats_cb(StatsCallbacks *entry,
-                            StatsResultList **stats_results,
-                            StatsFilter *filter, StatsRequest *request,
-                            Error **errp)
-{
-    ERRP_GUARD();
-    strList *targets = NULL;
-    strList *names = NULL;
-
-    if (request) {
-        if (request->provider != entry->provider) {
-            return true;
-        }
-        if (request->has_names && !request->names) {
-            return true;
-        }
-        names = request->has_names ? request->names : NULL;
-    }
-
-    switch (filter->target) {
-    case STATS_TARGET_VM:
-        break;
-    case STATS_TARGET_VCPU:
-        if (filter->u.vcpu.has_vcpus) {
-            if (!filter->u.vcpu.vcpus) {
-                /* No targets allowed?  Return no statistics.  */
-                return true;
-            }
-            targets = filter->u.vcpu.vcpus;
-        }
-        break;
-    default:
-        abort();
-    }
-
-    entry->stats_cb(stats_results, filter->target, names, targets, errp);
-    if (*errp) {
-        qapi_free_StatsResultList(*stats_results);
-        *stats_results = NULL;
-        return false;
-    }
-    return true;
-}
-
-StatsResultList *qmp_query_stats(StatsFilter *filter, Error **errp)
-{
-    StatsResultList *stats_results = NULL;
-    StatsCallbacks *entry;
-    StatsRequestList *request;
-
-    QTAILQ_FOREACH(entry, &stats_callbacks, next) {
-        if (filter->has_providers) {
-            for (request = filter->providers; request; request = request->next) {
-                if (!invoke_stats_cb(entry, &stats_results, filter,
-                                     request->value, errp)) {
-                    break;
-                }
-            }
-        } else {
-            if (!invoke_stats_cb(entry, &stats_results, filter, NULL, errp)) {
-                break;
-            }
-        }
-    }
-
-    return stats_results;
-}
-
-StatsSchemaList *qmp_query_stats_schemas(bool has_provider,
-                                         StatsProvider provider,
-                                         Error **errp)
-{
-    ERRP_GUARD();
-    StatsSchemaList *stats_results = NULL;
-    StatsCallbacks *entry;
-
-    QTAILQ_FOREACH(entry, &stats_callbacks, next) {
-        if (!has_provider || provider == entry->provider) {
-            entry->schemas_cb(&stats_results, errp);
-            if (*errp) {
-                qapi_free_StatsSchemaList(stats_results);
-                return NULL;
-            }
-        }
-    }
-
-    return stats_results;
-}
-
-void add_stats_entry(StatsResultList **stats_results, StatsProvider provider,
-                     const char *qom_path, StatsList *stats_list)
-{
-    StatsResult *entry = g_new0(StatsResult, 1);
-
-    entry->provider = provider;
-    entry->qom_path = g_strdup(qom_path);
-    entry->stats = stats_list;
-
-    QAPI_LIST_PREPEND(*stats_results, entry);
-}
-
-void add_stats_schema(StatsSchemaList **schema_results,
-                      StatsProvider provider, StatsTarget target,
-                      StatsSchemaValueList *stats_list)
-{
-    StatsSchema *entry = g_new0(StatsSchema, 1);
-
-    entry->provider = provider;
-    entry->target = target;
-    entry->stats = stats_list;
-    QAPI_LIST_PREPEND(*schema_results, entry);
-}
-
-bool apply_str_list_filter(const char *string, strList *list)
-{
-    strList *str_list = NULL;
-
-    if (!list) {
-        return true;
-    }
-    for (str_list = list; str_list; str_list = str_list->next) {
-        if (g_str_equal(string, str_list->value)) {
-            return true;
-        }
-    }
-    return false;
-}
diff --git a/stats/stats-qmp-cmds.c b/stats/stats-qmp-cmds.c
new file mode 100644
index 0000000000..bc973747fb
--- /dev/null
+++ b/stats/stats-qmp-cmds.c
@@ -0,0 +1,162 @@
+/*
+ * QMP commands related to stats
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * (at your option) any later version.
+ */
+
+#include "qemu/osdep.h"
+#include "sysemu/stats.h"
+#include "qapi/qapi-commands-stats.h"
+#include "qemu/queue.h"
+#include "qapi/error.h"
+
+typedef struct StatsCallbacks {
+    StatsProvider provider;
+    StatRetrieveFunc *stats_cb;
+    SchemaRetrieveFunc *schemas_cb;
+    QTAILQ_ENTRY(StatsCallbacks) next;
+} StatsCallbacks;
+
+static QTAILQ_HEAD(, StatsCallbacks) stats_callbacks =
+    QTAILQ_HEAD_INITIALIZER(stats_callbacks);
+
+void add_stats_callbacks(StatsProvider provider,
+                         StatRetrieveFunc *stats_fn,
+                         SchemaRetrieveFunc *schemas_fn)
+{
+    StatsCallbacks *entry = g_new(StatsCallbacks, 1);
+    entry->provider = provider;
+    entry->stats_cb = stats_fn;
+    entry->schemas_cb = schemas_fn;
+
+    QTAILQ_INSERT_TAIL(&stats_callbacks, entry, next);
+}
+
+static bool invoke_stats_cb(StatsCallbacks *entry,
+                            StatsResultList **stats_results,
+                            StatsFilter *filter, StatsRequest *request,
+                            Error **errp)
+{
+    ERRP_GUARD();
+    strList *targets = NULL;
+    strList *names = NULL;
+
+    if (request) {
+        if (request->provider != entry->provider) {
+            return true;
+        }
+        if (request->has_names && !request->names) {
+            return true;
+        }
+        names = request->has_names ? request->names : NULL;
+    }
+
+    switch (filter->target) {
+    case STATS_TARGET_VM:
+        break;
+    case STATS_TARGET_VCPU:
+        if (filter->u.vcpu.has_vcpus) {
+            if (!filter->u.vcpu.vcpus) {
+                /* No targets allowed?  Return no statistics.  */
+                return true;
+            }
+            targets = filter->u.vcpu.vcpus;
+        }
+        break;
+    default:
+        abort();
+    }
+
+    entry->stats_cb(stats_results, filter->target, names, targets, errp);
+    if (*errp) {
+        qapi_free_StatsResultList(*stats_results);
+        *stats_results = NULL;
+        return false;
+    }
+    return true;
+}
+
+StatsResultList *qmp_query_stats(StatsFilter *filter, Error **errp)
+{
+    StatsResultList *stats_results = NULL;
+    StatsCallbacks *entry;
+    StatsRequestList *request;
+
+    QTAILQ_FOREACH(entry, &stats_callbacks, next) {
+        if (filter->has_providers) {
+            for (request = filter->providers; request; request = request->next) {
+                if (!invoke_stats_cb(entry, &stats_results, filter,
+                                     request->value, errp)) {
+                    break;
+                }
+            }
+        } else {
+            if (!invoke_stats_cb(entry, &stats_results, filter, NULL, errp)) {
+                break;
+            }
+        }
+    }
+
+    return stats_results;
+}
+
+StatsSchemaList *qmp_query_stats_schemas(bool has_provider,
+                                         StatsProvider provider,
+                                         Error **errp)
+{
+    ERRP_GUARD();
+    StatsSchemaList *stats_results = NULL;
+    StatsCallbacks *entry;
+
+    QTAILQ_FOREACH(entry, &stats_callbacks, next) {
+        if (!has_provider || provider == entry->provider) {
+            entry->schemas_cb(&stats_results, errp);
+            if (*errp) {
+                qapi_free_StatsSchemaList(stats_results);
+                return NULL;
+            }
+        }
+    }
+
+    return stats_results;
+}
+
+void add_stats_entry(StatsResultList **stats_results, StatsProvider provider,
+                     const char *qom_path, StatsList *stats_list)
+{
+    StatsResult *entry = g_new0(StatsResult, 1);
+
+    entry->provider = provider;
+    entry->qom_path = g_strdup(qom_path);
+    entry->stats = stats_list;
+
+    QAPI_LIST_PREPEND(*stats_results, entry);
+}
+
+void add_stats_schema(StatsSchemaList **schema_results,
+                      StatsProvider provider, StatsTarget target,
+                      StatsSchemaValueList *stats_list)
+{
+    StatsSchema *entry = g_new0(StatsSchema, 1);
+
+    entry->provider = provider;
+    entry->target = target;
+    entry->stats = stats_list;
+    QAPI_LIST_PREPEND(*schema_results, entry);
+}
+
+bool apply_str_list_filter(const char *string, strList *list)
+{
+    strList *str_list = NULL;
+
+    if (!list) {
+        return true;
+    }
+    for (str_list = list; str_list; str_list = str_list->next) {
+        if (g_str_equal(string, str_list->value)) {
+            return true;
+        }
+    }
+    return false;
+}
diff --git a/stats/meson.build b/stats/meson.build
new file mode 100644
index 0000000000..4ddb4d096b
--- /dev/null
+++ b/stats/meson.build
@@ -0,0 +1 @@
+softmmu_ss.add(files('stats-qmp-cmds.c'))
-- 
2.39.0

