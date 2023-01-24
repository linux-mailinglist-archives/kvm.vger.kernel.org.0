Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5255D6797B0
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbjAXMU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233731AbjAXMUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:20:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8E9457D7
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nSqloO/4ofYsndI9ayYexi+BdwEa0VZ+i5Yaxnwb9/o=;
        b=EtxWurxgrWnqF211ZCQ+ASZ9aXz2QB/FFIT2fp3xIYDHUIHd89gPeHUBsIU22rhrk/TOWt
        VrCjkz/DW1TVPgKWIStjGfm84p+DukI8clWhvVsgC3yxs8Ki35pjahq3a/O12kgOpIcp0J
        wa7+DmiJ5t1dHglgzuZ2kgnjpqsdESY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-4-bYEweqNayrD8Uwj7BP8w-1; Tue, 24 Jan 2023 07:19:51 -0500
X-MC-Unique: 4-bYEweqNayrD8Uwj7BP8w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 174F91C008D4;
        Tue, 24 Jan 2023 12:19:51 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F01D2166B26;
        Tue, 24 Jan 2023 12:19:50 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id BA58321E691F; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 19/32] virtio: Move HMP commands from monitor/ to hw/virtio/
Date:   Tue, 24 Jan 2023 13:19:33 +0100
Message-Id: <20230124121946.1139465-20-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
Monitor (HMP)" to "virtio".

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 hw/virtio/virtio-hmp-cmds.c | 321 ++++++++++++++++++++++++++++++++++++
 monitor/hmp-cmds.c          | 309 ----------------------------------
 hw/virtio/meson.build       |   1 +
 3 files changed, 322 insertions(+), 309 deletions(-)
 create mode 100644 hw/virtio/virtio-hmp-cmds.c

diff --git a/hw/virtio/virtio-hmp-cmds.c b/hw/virtio/virtio-hmp-cmds.c
new file mode 100644
index 0000000000..477c97dea2
--- /dev/null
+++ b/hw/virtio/virtio-hmp-cmds.c
@@ -0,0 +1,321 @@
+/*
+ * HMP commands related to virtio
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * (at your option) any later version.
+ */
+
+#include "qemu/osdep.h"
+#include "monitor/hmp.h"
+#include "monitor/monitor.h"
+#include "qapi/qapi-commands-virtio.h"
+#include "qapi/qmp/qdict.h"
+
+
+static void hmp_virtio_dump_protocols(Monitor *mon,
+                                      VhostDeviceProtocols *pcol)
+{
+    strList *pcol_list = pcol->protocols;
+    while (pcol_list) {
+        monitor_printf(mon, "\t%s", pcol_list->value);
+        pcol_list = pcol_list->next;
+        if (pcol_list != NULL) {
+            monitor_printf(mon, ",\n");
+        }
+    }
+    monitor_printf(mon, "\n");
+    if (pcol->has_unknown_protocols) {
+        monitor_printf(mon, "  unknown-protocols(0x%016"PRIx64")\n",
+                       pcol->unknown_protocols);
+    }
+}
+
+static void hmp_virtio_dump_status(Monitor *mon,
+                                   VirtioDeviceStatus *status)
+{
+    strList *status_list = status->statuses;
+    while (status_list) {
+        monitor_printf(mon, "\t%s", status_list->value);
+        status_list = status_list->next;
+        if (status_list != NULL) {
+            monitor_printf(mon, ",\n");
+        }
+    }
+    monitor_printf(mon, "\n");
+    if (status->has_unknown_statuses) {
+        monitor_printf(mon, "  unknown-statuses(0x%016"PRIx32")\n",
+                       status->unknown_statuses);
+    }
+}
+
+static void hmp_virtio_dump_features(Monitor *mon,
+                                     VirtioDeviceFeatures *features)
+{
+    strList *transport_list = features->transports;
+    while (transport_list) {
+        monitor_printf(mon, "\t%s", transport_list->value);
+        transport_list = transport_list->next;
+        if (transport_list != NULL) {
+            monitor_printf(mon, ",\n");
+        }
+    }
+
+    monitor_printf(mon, "\n");
+    strList *list = features->dev_features;
+    if (list) {
+        while (list) {
+            monitor_printf(mon, "\t%s", list->value);
+            list = list->next;
+            if (list != NULL) {
+                monitor_printf(mon, ",\n");
+            }
+        }
+        monitor_printf(mon, "\n");
+    }
+
+    if (features->has_unknown_dev_features) {
+        monitor_printf(mon, "  unknown-features(0x%016"PRIx64")\n",
+                       features->unknown_dev_features);
+    }
+}
+
+void hmp_virtio_query(Monitor *mon, const QDict *qdict)
+{
+    Error *err = NULL;
+    VirtioInfoList *list = qmp_x_query_virtio(&err);
+    VirtioInfoList *node;
+
+    if (err != NULL) {
+        hmp_handle_error(mon, err);
+        return;
+    }
+
+    if (list == NULL) {
+        monitor_printf(mon, "No VirtIO devices\n");
+        return;
+    }
+
+    node = list;
+    while (node) {
+        monitor_printf(mon, "%s [%s]\n", node->value->path,
+                       node->value->name);
+        node = node->next;
+    }
+    qapi_free_VirtioInfoList(list);
+}
+
+void hmp_virtio_status(Monitor *mon, const QDict *qdict)
+{
+    Error *err = NULL;
+    const char *path = qdict_get_try_str(qdict, "path");
+    VirtioStatus *s = qmp_x_query_virtio_status(path, &err);
+
+    if (err != NULL) {
+        hmp_handle_error(mon, err);
+        return;
+    }
+
+    monitor_printf(mon, "%s:\n", path);
+    monitor_printf(mon, "  device_name:             %s %s\n",
+                   s->name, s->vhost_dev ? "(vhost)" : "");
+    monitor_printf(mon, "  device_id:               %d\n", s->device_id);
+    monitor_printf(mon, "  vhost_started:           %s\n",
+                   s->vhost_started ? "true" : "false");
+    monitor_printf(mon, "  bus_name:                %s\n", s->bus_name);
+    monitor_printf(mon, "  broken:                  %s\n",
+                   s->broken ? "true" : "false");
+    monitor_printf(mon, "  disabled:                %s\n",
+                   s->disabled ? "true" : "false");
+    monitor_printf(mon, "  disable_legacy_check:    %s\n",
+                   s->disable_legacy_check ? "true" : "false");
+    monitor_printf(mon, "  started:                 %s\n",
+                   s->started ? "true" : "false");
+    monitor_printf(mon, "  use_started:             %s\n",
+                   s->use_started ? "true" : "false");
+    monitor_printf(mon, "  start_on_kick:           %s\n",
+                   s->start_on_kick ? "true" : "false");
+    monitor_printf(mon, "  use_guest_notifier_mask: %s\n",
+                   s->use_guest_notifier_mask ? "true" : "false");
+    monitor_printf(mon, "  vm_running:              %s\n",
+                   s->vm_running ? "true" : "false");
+    monitor_printf(mon, "  num_vqs:                 %"PRId64"\n", s->num_vqs);
+    monitor_printf(mon, "  queue_sel:               %d\n",
+                   s->queue_sel);
+    monitor_printf(mon, "  isr:                     %d\n", s->isr);
+    monitor_printf(mon, "  endianness:              %s\n",
+                   s->device_endian);
+    monitor_printf(mon, "  status:\n");
+    hmp_virtio_dump_status(mon, s->status);
+    monitor_printf(mon, "  Guest features:\n");
+    hmp_virtio_dump_features(mon, s->guest_features);
+    monitor_printf(mon, "  Host features:\n");
+    hmp_virtio_dump_features(mon, s->host_features);
+    monitor_printf(mon, "  Backend features:\n");
+    hmp_virtio_dump_features(mon, s->backend_features);
+
+    if (s->vhost_dev) {
+        monitor_printf(mon, "  VHost:\n");
+        monitor_printf(mon, "    nvqs:           %d\n",
+                       s->vhost_dev->nvqs);
+        monitor_printf(mon, "    vq_index:       %"PRId64"\n",
+                       s->vhost_dev->vq_index);
+        monitor_printf(mon, "    max_queues:     %"PRId64"\n",
+                       s->vhost_dev->max_queues);
+        monitor_printf(mon, "    n_mem_sections: %"PRId64"\n",
+                       s->vhost_dev->n_mem_sections);
+        monitor_printf(mon, "    n_tmp_sections: %"PRId64"\n",
+                       s->vhost_dev->n_tmp_sections);
+        monitor_printf(mon, "    backend_cap:    %"PRId64"\n",
+                       s->vhost_dev->backend_cap);
+        monitor_printf(mon, "    log_enabled:    %s\n",
+                       s->vhost_dev->log_enabled ? "true" : "false");
+        monitor_printf(mon, "    log_size:       %"PRId64"\n",
+                       s->vhost_dev->log_size);
+        monitor_printf(mon, "    Features:\n");
+        hmp_virtio_dump_features(mon, s->vhost_dev->features);
+        monitor_printf(mon, "    Acked features:\n");
+        hmp_virtio_dump_features(mon, s->vhost_dev->acked_features);
+        monitor_printf(mon, "    Backend features:\n");
+        hmp_virtio_dump_features(mon, s->vhost_dev->backend_features);
+        monitor_printf(mon, "    Protocol features:\n");
+        hmp_virtio_dump_protocols(mon, s->vhost_dev->protocol_features);
+    }
+
+    qapi_free_VirtioStatus(s);
+}
+
+void hmp_vhost_queue_status(Monitor *mon, const QDict *qdict)
+{
+    Error *err = NULL;
+    const char *path = qdict_get_try_str(qdict, "path");
+    int queue = qdict_get_int(qdict, "queue");
+    VirtVhostQueueStatus *s =
+        qmp_x_query_virtio_vhost_queue_status(path, queue, &err);
+
+    if (err != NULL) {
+        hmp_handle_error(mon, err);
+        return;
+    }
+
+    monitor_printf(mon, "%s:\n", path);
+    monitor_printf(mon, "  device_name:          %s (vhost)\n",
+                   s->name);
+    monitor_printf(mon, "  kick:                 %"PRId64"\n", s->kick);
+    monitor_printf(mon, "  call:                 %"PRId64"\n", s->call);
+    monitor_printf(mon, "  VRing:\n");
+    monitor_printf(mon, "    num:         %"PRId64"\n", s->num);
+    monitor_printf(mon, "    desc:        0x%016"PRIx64"\n", s->desc);
+    monitor_printf(mon, "    desc_phys:   0x%016"PRIx64"\n",
+                   s->desc_phys);
+    monitor_printf(mon, "    desc_size:   %"PRId32"\n", s->desc_size);
+    monitor_printf(mon, "    avail:       0x%016"PRIx64"\n", s->avail);
+    monitor_printf(mon, "    avail_phys:  0x%016"PRIx64"\n",
+                   s->avail_phys);
+    monitor_printf(mon, "    avail_size:  %"PRId32"\n", s->avail_size);
+    monitor_printf(mon, "    used:        0x%016"PRIx64"\n", s->used);
+    monitor_printf(mon, "    used_phys:   0x%016"PRIx64"\n",
+                   s->used_phys);
+    monitor_printf(mon, "    used_size:   %"PRId32"\n", s->used_size);
+
+    qapi_free_VirtVhostQueueStatus(s);
+}
+
+void hmp_virtio_queue_status(Monitor *mon, const QDict *qdict)
+{
+    Error *err = NULL;
+    const char *path = qdict_get_try_str(qdict, "path");
+    int queue = qdict_get_int(qdict, "queue");
+    VirtQueueStatus *s = qmp_x_query_virtio_queue_status(path, queue, &err);
+
+    if (err != NULL) {
+        hmp_handle_error(mon, err);
+        return;
+    }
+
+    monitor_printf(mon, "%s:\n", path);
+    monitor_printf(mon, "  device_name:          %s\n", s->name);
+    monitor_printf(mon, "  queue_index:          %d\n", s->queue_index);
+    monitor_printf(mon, "  inuse:                %d\n", s->inuse);
+    monitor_printf(mon, "  used_idx:             %d\n", s->used_idx);
+    monitor_printf(mon, "  signalled_used:       %d\n",
+                   s->signalled_used);
+    monitor_printf(mon, "  signalled_used_valid: %s\n",
+                   s->signalled_used_valid ? "true" : "false");
+    if (s->has_last_avail_idx) {
+        monitor_printf(mon, "  last_avail_idx:       %d\n",
+                       s->last_avail_idx);
+    }
+    if (s->has_shadow_avail_idx) {
+        monitor_printf(mon, "  shadow_avail_idx:     %d\n",
+                       s->shadow_avail_idx);
+    }
+    monitor_printf(mon, "  VRing:\n");
+    monitor_printf(mon, "    num:          %"PRId32"\n", s->vring_num);
+    monitor_printf(mon, "    num_default:  %"PRId32"\n",
+                   s->vring_num_default);
+    monitor_printf(mon, "    align:        %"PRId32"\n",
+                   s->vring_align);
+    monitor_printf(mon, "    desc:         0x%016"PRIx64"\n",
+                   s->vring_desc);
+    monitor_printf(mon, "    avail:        0x%016"PRIx64"\n",
+                   s->vring_avail);
+    monitor_printf(mon, "    used:         0x%016"PRIx64"\n",
+                   s->vring_used);
+
+    qapi_free_VirtQueueStatus(s);
+}
+
+void hmp_virtio_queue_element(Monitor *mon, const QDict *qdict)
+{
+    Error *err = NULL;
+    const char *path = qdict_get_try_str(qdict, "path");
+    int queue = qdict_get_int(qdict, "queue");
+    int index = qdict_get_try_int(qdict, "index", -1);
+    VirtioQueueElement *e;
+    VirtioRingDescList *list;
+
+    e = qmp_x_query_virtio_queue_element(path, queue, index != -1,
+                                         index, &err);
+    if (err != NULL) {
+        hmp_handle_error(mon, err);
+        return;
+    }
+
+    monitor_printf(mon, "%s:\n", path);
+    monitor_printf(mon, "  device_name: %s\n", e->name);
+    monitor_printf(mon, "  index:   %d\n", e->index);
+    monitor_printf(mon, "  desc:\n");
+    monitor_printf(mon, "    descs:\n");
+
+    list = e->descs;
+    while (list) {
+        monitor_printf(mon, "        addr 0x%"PRIx64" len %d",
+                       list->value->addr, list->value->len);
+        if (list->value->flags) {
+            strList *flag = list->value->flags;
+            monitor_printf(mon, " (");
+            while (flag) {
+                monitor_printf(mon, "%s", flag->value);
+                flag = flag->next;
+                if (flag) {
+                    monitor_printf(mon, ", ");
+                }
+            }
+            monitor_printf(mon, ")");
+        }
+        list = list->next;
+        if (list) {
+            monitor_printf(mon, ",\n");
+        }
+    }
+    monitor_printf(mon, "\n");
+    monitor_printf(mon, "  avail:\n");
+    monitor_printf(mon, "    flags: %d\n", e->avail->flags);
+    monitor_printf(mon, "    idx:   %d\n", e->avail->idx);
+    monitor_printf(mon, "    ring:  %d\n", e->avail->ring);
+    monitor_printf(mon, "  used:\n");
+    monitor_printf(mon, "    flags: %d\n", e->used->flags);
+    monitor_printf(mon, "    idx:   %d\n", e->used->idx);
+
+    qapi_free_VirtioQueueElement(e);
+}
diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
index 4da6b7cccc..6b1d5358f7 100644
--- a/monitor/hmp-cmds.c
+++ b/monitor/hmp-cmds.c
@@ -23,7 +23,6 @@
 #include "qapi/qapi-commands-run-state.h"
 #include "qapi/qapi-commands-stats.h"
 #include "qapi/qapi-commands-tpm.h"
-#include "qapi/qapi-commands-virtio.h"
 #include "qapi/qmp/qdict.h"
 #include "qapi/qmp/qerror.h"
 #include "qemu/cutils.h"
@@ -533,311 +532,3 @@ exit:
 exit_no_print:
     error_free(err);
 }
-
-static void hmp_virtio_dump_protocols(Monitor *mon,
-                                      VhostDeviceProtocols *pcol)
-{
-    strList *pcol_list = pcol->protocols;
-    while (pcol_list) {
-        monitor_printf(mon, "\t%s", pcol_list->value);
-        pcol_list = pcol_list->next;
-        if (pcol_list != NULL) {
-            monitor_printf(mon, ",\n");
-        }
-    }
-    monitor_printf(mon, "\n");
-    if (pcol->has_unknown_protocols) {
-        monitor_printf(mon, "  unknown-protocols(0x%016"PRIx64")\n",
-                       pcol->unknown_protocols);
-    }
-}
-
-static void hmp_virtio_dump_status(Monitor *mon,
-                                   VirtioDeviceStatus *status)
-{
-    strList *status_list = status->statuses;
-    while (status_list) {
-        monitor_printf(mon, "\t%s", status_list->value);
-        status_list = status_list->next;
-        if (status_list != NULL) {
-            monitor_printf(mon, ",\n");
-        }
-    }
-    monitor_printf(mon, "\n");
-    if (status->has_unknown_statuses) {
-        monitor_printf(mon, "  unknown-statuses(0x%016"PRIx32")\n",
-                       status->unknown_statuses);
-    }
-}
-
-static void hmp_virtio_dump_features(Monitor *mon,
-                                     VirtioDeviceFeatures *features)
-{
-    strList *transport_list = features->transports;
-    while (transport_list) {
-        monitor_printf(mon, "\t%s", transport_list->value);
-        transport_list = transport_list->next;
-        if (transport_list != NULL) {
-            monitor_printf(mon, ",\n");
-        }
-    }
-
-    monitor_printf(mon, "\n");
-    strList *list = features->dev_features;
-    if (list) {
-        while (list) {
-            monitor_printf(mon, "\t%s", list->value);
-            list = list->next;
-            if (list != NULL) {
-                monitor_printf(mon, ",\n");
-            }
-        }
-        monitor_printf(mon, "\n");
-    }
-
-    if (features->has_unknown_dev_features) {
-        monitor_printf(mon, "  unknown-features(0x%016"PRIx64")\n",
-                       features->unknown_dev_features);
-    }
-}
-
-void hmp_virtio_query(Monitor *mon, const QDict *qdict)
-{
-    Error *err = NULL;
-    VirtioInfoList *list = qmp_x_query_virtio(&err);
-    VirtioInfoList *node;
-
-    if (err != NULL) {
-        hmp_handle_error(mon, err);
-        return;
-    }
-
-    if (list == NULL) {
-        monitor_printf(mon, "No VirtIO devices\n");
-        return;
-    }
-
-    node = list;
-    while (node) {
-        monitor_printf(mon, "%s [%s]\n", node->value->path,
-                       node->value->name);
-        node = node->next;
-    }
-    qapi_free_VirtioInfoList(list);
-}
-
-void hmp_virtio_status(Monitor *mon, const QDict *qdict)
-{
-    Error *err = NULL;
-    const char *path = qdict_get_try_str(qdict, "path");
-    VirtioStatus *s = qmp_x_query_virtio_status(path, &err);
-
-    if (err != NULL) {
-        hmp_handle_error(mon, err);
-        return;
-    }
-
-    monitor_printf(mon, "%s:\n", path);
-    monitor_printf(mon, "  device_name:             %s %s\n",
-                   s->name, s->vhost_dev ? "(vhost)" : "");
-    monitor_printf(mon, "  device_id:               %d\n", s->device_id);
-    monitor_printf(mon, "  vhost_started:           %s\n",
-                   s->vhost_started ? "true" : "false");
-    monitor_printf(mon, "  bus_name:                %s\n", s->bus_name);
-    monitor_printf(mon, "  broken:                  %s\n",
-                   s->broken ? "true" : "false");
-    monitor_printf(mon, "  disabled:                %s\n",
-                   s->disabled ? "true" : "false");
-    monitor_printf(mon, "  disable_legacy_check:    %s\n",
-                   s->disable_legacy_check ? "true" : "false");
-    monitor_printf(mon, "  started:                 %s\n",
-                   s->started ? "true" : "false");
-    monitor_printf(mon, "  use_started:             %s\n",
-                   s->use_started ? "true" : "false");
-    monitor_printf(mon, "  start_on_kick:           %s\n",
-                   s->start_on_kick ? "true" : "false");
-    monitor_printf(mon, "  use_guest_notifier_mask: %s\n",
-                   s->use_guest_notifier_mask ? "true" : "false");
-    monitor_printf(mon, "  vm_running:              %s\n",
-                   s->vm_running ? "true" : "false");
-    monitor_printf(mon, "  num_vqs:                 %"PRId64"\n", s->num_vqs);
-    monitor_printf(mon, "  queue_sel:               %d\n",
-                   s->queue_sel);
-    monitor_printf(mon, "  isr:                     %d\n", s->isr);
-    monitor_printf(mon, "  endianness:              %s\n",
-                   s->device_endian);
-    monitor_printf(mon, "  status:\n");
-    hmp_virtio_dump_status(mon, s->status);
-    monitor_printf(mon, "  Guest features:\n");
-    hmp_virtio_dump_features(mon, s->guest_features);
-    monitor_printf(mon, "  Host features:\n");
-    hmp_virtio_dump_features(mon, s->host_features);
-    monitor_printf(mon, "  Backend features:\n");
-    hmp_virtio_dump_features(mon, s->backend_features);
-
-    if (s->vhost_dev) {
-        monitor_printf(mon, "  VHost:\n");
-        monitor_printf(mon, "    nvqs:           %d\n",
-                       s->vhost_dev->nvqs);
-        monitor_printf(mon, "    vq_index:       %"PRId64"\n",
-                       s->vhost_dev->vq_index);
-        monitor_printf(mon, "    max_queues:     %"PRId64"\n",
-                       s->vhost_dev->max_queues);
-        monitor_printf(mon, "    n_mem_sections: %"PRId64"\n",
-                       s->vhost_dev->n_mem_sections);
-        monitor_printf(mon, "    n_tmp_sections: %"PRId64"\n",
-                       s->vhost_dev->n_tmp_sections);
-        monitor_printf(mon, "    backend_cap:    %"PRId64"\n",
-                       s->vhost_dev->backend_cap);
-        monitor_printf(mon, "    log_enabled:    %s\n",
-                       s->vhost_dev->log_enabled ? "true" : "false");
-        monitor_printf(mon, "    log_size:       %"PRId64"\n",
-                       s->vhost_dev->log_size);
-        monitor_printf(mon, "    Features:\n");
-        hmp_virtio_dump_features(mon, s->vhost_dev->features);
-        monitor_printf(mon, "    Acked features:\n");
-        hmp_virtio_dump_features(mon, s->vhost_dev->acked_features);
-        monitor_printf(mon, "    Backend features:\n");
-        hmp_virtio_dump_features(mon, s->vhost_dev->backend_features);
-        monitor_printf(mon, "    Protocol features:\n");
-        hmp_virtio_dump_protocols(mon, s->vhost_dev->protocol_features);
-    }
-
-    qapi_free_VirtioStatus(s);
-}
-
-void hmp_vhost_queue_status(Monitor *mon, const QDict *qdict)
-{
-    Error *err = NULL;
-    const char *path = qdict_get_try_str(qdict, "path");
-    int queue = qdict_get_int(qdict, "queue");
-    VirtVhostQueueStatus *s =
-        qmp_x_query_virtio_vhost_queue_status(path, queue, &err);
-
-    if (err != NULL) {
-        hmp_handle_error(mon, err);
-        return;
-    }
-
-    monitor_printf(mon, "%s:\n", path);
-    monitor_printf(mon, "  device_name:          %s (vhost)\n",
-                   s->name);
-    monitor_printf(mon, "  kick:                 %"PRId64"\n", s->kick);
-    monitor_printf(mon, "  call:                 %"PRId64"\n", s->call);
-    monitor_printf(mon, "  VRing:\n");
-    monitor_printf(mon, "    num:         %"PRId64"\n", s->num);
-    monitor_printf(mon, "    desc:        0x%016"PRIx64"\n", s->desc);
-    monitor_printf(mon, "    desc_phys:   0x%016"PRIx64"\n",
-                   s->desc_phys);
-    monitor_printf(mon, "    desc_size:   %"PRId32"\n", s->desc_size);
-    monitor_printf(mon, "    avail:       0x%016"PRIx64"\n", s->avail);
-    monitor_printf(mon, "    avail_phys:  0x%016"PRIx64"\n",
-                   s->avail_phys);
-    monitor_printf(mon, "    avail_size:  %"PRId32"\n", s->avail_size);
-    monitor_printf(mon, "    used:        0x%016"PRIx64"\n", s->used);
-    monitor_printf(mon, "    used_phys:   0x%016"PRIx64"\n",
-                   s->used_phys);
-    monitor_printf(mon, "    used_size:   %"PRId32"\n", s->used_size);
-
-    qapi_free_VirtVhostQueueStatus(s);
-}
-
-void hmp_virtio_queue_status(Monitor *mon, const QDict *qdict)
-{
-    Error *err = NULL;
-    const char *path = qdict_get_try_str(qdict, "path");
-    int queue = qdict_get_int(qdict, "queue");
-    VirtQueueStatus *s = qmp_x_query_virtio_queue_status(path, queue, &err);
-
-    if (err != NULL) {
-        hmp_handle_error(mon, err);
-        return;
-    }
-
-    monitor_printf(mon, "%s:\n", path);
-    monitor_printf(mon, "  device_name:          %s\n", s->name);
-    monitor_printf(mon, "  queue_index:          %d\n", s->queue_index);
-    monitor_printf(mon, "  inuse:                %d\n", s->inuse);
-    monitor_printf(mon, "  used_idx:             %d\n", s->used_idx);
-    monitor_printf(mon, "  signalled_used:       %d\n",
-                   s->signalled_used);
-    monitor_printf(mon, "  signalled_used_valid: %s\n",
-                   s->signalled_used_valid ? "true" : "false");
-    if (s->has_last_avail_idx) {
-        monitor_printf(mon, "  last_avail_idx:       %d\n",
-                       s->last_avail_idx);
-    }
-    if (s->has_shadow_avail_idx) {
-        monitor_printf(mon, "  shadow_avail_idx:     %d\n",
-                       s->shadow_avail_idx);
-    }
-    monitor_printf(mon, "  VRing:\n");
-    monitor_printf(mon, "    num:          %"PRId32"\n", s->vring_num);
-    monitor_printf(mon, "    num_default:  %"PRId32"\n",
-                   s->vring_num_default);
-    monitor_printf(mon, "    align:        %"PRId32"\n",
-                   s->vring_align);
-    monitor_printf(mon, "    desc:         0x%016"PRIx64"\n",
-                   s->vring_desc);
-    monitor_printf(mon, "    avail:        0x%016"PRIx64"\n",
-                   s->vring_avail);
-    monitor_printf(mon, "    used:         0x%016"PRIx64"\n",
-                   s->vring_used);
-
-    qapi_free_VirtQueueStatus(s);
-}
-
-void hmp_virtio_queue_element(Monitor *mon, const QDict *qdict)
-{
-    Error *err = NULL;
-    const char *path = qdict_get_try_str(qdict, "path");
-    int queue = qdict_get_int(qdict, "queue");
-    int index = qdict_get_try_int(qdict, "index", -1);
-    VirtioQueueElement *e;
-    VirtioRingDescList *list;
-
-    e = qmp_x_query_virtio_queue_element(path, queue, index != -1,
-                                         index, &err);
-    if (err != NULL) {
-        hmp_handle_error(mon, err);
-        return;
-    }
-
-    monitor_printf(mon, "%s:\n", path);
-    monitor_printf(mon, "  device_name: %s\n", e->name);
-    monitor_printf(mon, "  index:   %d\n", e->index);
-    monitor_printf(mon, "  desc:\n");
-    monitor_printf(mon, "    descs:\n");
-
-    list = e->descs;
-    while (list) {
-        monitor_printf(mon, "        addr 0x%"PRIx64" len %d",
-                       list->value->addr, list->value->len);
-        if (list->value->flags) {
-            strList *flag = list->value->flags;
-            monitor_printf(mon, " (");
-            while (flag) {
-                monitor_printf(mon, "%s", flag->value);
-                flag = flag->next;
-                if (flag) {
-                    monitor_printf(mon, ", ");
-                }
-            }
-            monitor_printf(mon, ")");
-        }
-        list = list->next;
-        if (list) {
-            monitor_printf(mon, ",\n");
-        }
-    }
-    monitor_printf(mon, "\n");
-    monitor_printf(mon, "  avail:\n");
-    monitor_printf(mon, "    flags: %d\n", e->avail->flags);
-    monitor_printf(mon, "    idx:   %d\n", e->avail->idx);
-    monitor_printf(mon, "    ring:  %d\n", e->avail->ring);
-    monitor_printf(mon, "  used:\n");
-    monitor_printf(mon, "    flags: %d\n", e->used->flags);
-    monitor_printf(mon, "    idx:   %d\n", e->used->idx);
-
-    qapi_free_VirtioQueueElement(e);
-}
diff --git a/hw/virtio/meson.build b/hw/virtio/meson.build
index f93be2e137..bdec78bfc6 100644
--- a/hw/virtio/meson.build
+++ b/hw/virtio/meson.build
@@ -67,5 +67,6 @@ softmmu_ss.add(when: 'CONFIG_VIRTIO', if_false: files('vhost-stub.c'))
 softmmu_ss.add(when: 'CONFIG_VIRTIO', if_false: files('virtio-stub.c'))
 softmmu_ss.add(when: 'CONFIG_ALL', if_true: files('vhost-stub.c'))
 softmmu_ss.add(when: 'CONFIG_ALL', if_true: files('virtio-stub.c'))
+softmmu_ss.add(files('virtio-hmp-cmds.c'))
 
 specific_ss.add_all(when: 'CONFIG_VIRTIO', if_true: specific_virtio_ss)
-- 
2.39.0

