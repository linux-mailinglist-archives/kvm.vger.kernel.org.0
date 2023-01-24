Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30C06797B4
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbjAXMVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233521AbjAXMU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:20:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9832D442FE
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Jb3dKEav+1mlfYEEyL0PbcnyU3TOmcCIwr69K/KJN0=;
        b=WupqLWl62YNnmCM6dv3vk5ELWfI2kc19DDGBG/+LBy+n7lIoRfRig6M37nlukL4N5z+nSb
        2Q3fIc8R3aaTXzDBSHO4su4b8VnSNaqC8RJWM0DGGgiRBhYJ55pPQehGdPjwJq+Bqs6DyQ
        yWrh8JYa2cFXppdLmbz1Dil27i/p5p4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-6YzgnrFqOpeL1q1jlUGaWA-1; Tue, 24 Jan 2023 07:19:50 -0500
X-MC-Unique: 6YzgnrFqOpeL1q1jlUGaWA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD7A218A6476;
        Tue, 24 Jan 2023 12:19:49 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 440C21121330;
        Tue, 24 Jan 2023 12:19:49 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 9F90F21E6901; Tue, 24 Jan 2023 13:19:46 +0100 (CET)
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
Subject: [PATCH 10/32] machine: Move HMP commands from monitor/ to hw/core/
Date:   Tue, 24 Jan 2023 13:19:24 +0100
Message-Id: <20230124121946.1139465-11-armbru@redhat.com>
In-Reply-To: <20230124121946.1139465-1-armbru@redhat.com>
References: <20230124121946.1139465-1-armbru@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
Monitor (HMP)" to "Machine core".

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 hw/core/machine-hmp-cmds.c | 208 ++++++++++++++++++++++++++++++++++++
 monitor/hmp-cmds.c         | 209 -------------------------------------
 2 files changed, 208 insertions(+), 209 deletions(-)

diff --git a/hw/core/machine-hmp-cmds.c b/hw/core/machine-hmp-cmds.c
index a1a51e9778..c3e55ef9e9 100644
--- a/hw/core/machine-hmp-cmds.c
+++ b/hw/core/machine-hmp-cmds.c
@@ -134,3 +134,211 @@ void hmp_info_memdev(Monitor *mon, const QDict *qdict)
     qapi_free_MemdevList(memdev_list);
     hmp_handle_error(mon, err);
 }
+
+void hmp_info_kvm(Monitor *mon, const QDict *qdict)
+{
+    KvmInfo *info;
+
+    info = qmp_query_kvm(NULL);
+    monitor_printf(mon, "kvm support: ");
+    if (info->present) {
+        monitor_printf(mon, "%s\n", info->enabled ? "enabled" : "disabled");
+    } else {
+        monitor_printf(mon, "not compiled\n");
+    }
+
+    qapi_free_KvmInfo(info);
+}
+
+void hmp_info_uuid(Monitor *mon, const QDict *qdict)
+{
+    UuidInfo *info;
+
+    info = qmp_query_uuid(NULL);
+    monitor_printf(mon, "%s\n", info->UUID);
+    qapi_free_UuidInfo(info);
+}
+
+void hmp_info_balloon(Monitor *mon, const QDict *qdict)
+{
+    BalloonInfo *info;
+    Error *err = NULL;
+
+    info = qmp_query_balloon(&err);
+    if (hmp_handle_error(mon, err)) {
+        return;
+    }
+
+    monitor_printf(mon, "balloon: actual=%" PRId64 "\n", info->actual >> 20);
+
+    qapi_free_BalloonInfo(info);
+}
+
+void hmp_system_reset(Monitor *mon, const QDict *qdict)
+{
+    qmp_system_reset(NULL);
+}
+
+void hmp_system_powerdown(Monitor *mon, const QDict *qdict)
+{
+    qmp_system_powerdown(NULL);
+}
+
+void hmp_memsave(Monitor *mon, const QDict *qdict)
+{
+    uint32_t size = qdict_get_int(qdict, "size");
+    const char *filename = qdict_get_str(qdict, "filename");
+    uint64_t addr = qdict_get_int(qdict, "val");
+    Error *err = NULL;
+    int cpu_index = monitor_get_cpu_index(mon);
+
+    if (cpu_index < 0) {
+        monitor_printf(mon, "No CPU available\n");
+        return;
+    }
+
+    qmp_memsave(addr, size, filename, true, cpu_index, &err);
+    hmp_handle_error(mon, err);
+}
+
+void hmp_pmemsave(Monitor *mon, const QDict *qdict)
+{
+    uint32_t size = qdict_get_int(qdict, "size");
+    const char *filename = qdict_get_str(qdict, "filename");
+    uint64_t addr = qdict_get_int(qdict, "val");
+    Error *err = NULL;
+
+    qmp_pmemsave(addr, size, filename, &err);
+    hmp_handle_error(mon, err);
+}
+
+void hmp_system_wakeup(Monitor *mon, const QDict *qdict)
+{
+    Error *err = NULL;
+
+    qmp_system_wakeup(&err);
+    hmp_handle_error(mon, err);
+}
+
+void hmp_nmi(Monitor *mon, const QDict *qdict)
+{
+    Error *err = NULL;
+
+    qmp_inject_nmi(&err);
+    hmp_handle_error(mon, err);
+}
+
+void hmp_balloon(Monitor *mon, const QDict *qdict)
+{
+    int64_t value = qdict_get_int(qdict, "value");
+    Error *err = NULL;
+
+    qmp_balloon(value, &err);
+    hmp_handle_error(mon, err);
+}
+
+void hmp_info_memory_devices(Monitor *mon, const QDict *qdict)
+{
+    Error *err = NULL;
+    MemoryDeviceInfoList *info_list = qmp_query_memory_devices(&err);
+    MemoryDeviceInfoList *info;
+    VirtioPMEMDeviceInfo *vpi;
+    VirtioMEMDeviceInfo *vmi;
+    MemoryDeviceInfo *value;
+    PCDIMMDeviceInfo *di;
+    SgxEPCDeviceInfo *se;
+
+    for (info = info_list; info; info = info->next) {
+        value = info->value;
+
+        if (value) {
+            switch (value->type) {
+            case MEMORY_DEVICE_INFO_KIND_DIMM:
+            case MEMORY_DEVICE_INFO_KIND_NVDIMM:
+                di = value->type == MEMORY_DEVICE_INFO_KIND_DIMM ?
+                     value->u.dimm.data : value->u.nvdimm.data;
+                monitor_printf(mon, "Memory device [%s]: \"%s\"\n",
+                               MemoryDeviceInfoKind_str(value->type),
+                               di->id ? di->id : "");
+                monitor_printf(mon, "  addr: 0x%" PRIx64 "\n", di->addr);
+                monitor_printf(mon, "  slot: %" PRId64 "\n", di->slot);
+                monitor_printf(mon, "  node: %" PRId64 "\n", di->node);
+                monitor_printf(mon, "  size: %" PRIu64 "\n", di->size);
+                monitor_printf(mon, "  memdev: %s\n", di->memdev);
+                monitor_printf(mon, "  hotplugged: %s\n",
+                               di->hotplugged ? "true" : "false");
+                monitor_printf(mon, "  hotpluggable: %s\n",
+                               di->hotpluggable ? "true" : "false");
+                break;
+            case MEMORY_DEVICE_INFO_KIND_VIRTIO_PMEM:
+                vpi = value->u.virtio_pmem.data;
+                monitor_printf(mon, "Memory device [%s]: \"%s\"\n",
+                               MemoryDeviceInfoKind_str(value->type),
+                               vpi->id ? vpi->id : "");
+                monitor_printf(mon, "  memaddr: 0x%" PRIx64 "\n", vpi->memaddr);
+                monitor_printf(mon, "  size: %" PRIu64 "\n", vpi->size);
+                monitor_printf(mon, "  memdev: %s\n", vpi->memdev);
+                break;
+            case MEMORY_DEVICE_INFO_KIND_VIRTIO_MEM:
+                vmi = value->u.virtio_mem.data;
+                monitor_printf(mon, "Memory device [%s]: \"%s\"\n",
+                               MemoryDeviceInfoKind_str(value->type),
+                               vmi->id ? vmi->id : "");
+                monitor_printf(mon, "  memaddr: 0x%" PRIx64 "\n", vmi->memaddr);
+                monitor_printf(mon, "  node: %" PRId64 "\n", vmi->node);
+                monitor_printf(mon, "  requested-size: %" PRIu64 "\n",
+                               vmi->requested_size);
+                monitor_printf(mon, "  size: %" PRIu64 "\n", vmi->size);
+                monitor_printf(mon, "  max-size: %" PRIu64 "\n", vmi->max_size);
+                monitor_printf(mon, "  block-size: %" PRIu64 "\n",
+                               vmi->block_size);
+                monitor_printf(mon, "  memdev: %s\n", vmi->memdev);
+                break;
+            case MEMORY_DEVICE_INFO_KIND_SGX_EPC:
+                se = value->u.sgx_epc.data;
+                monitor_printf(mon, "Memory device [%s]: \"%s\"\n",
+                               MemoryDeviceInfoKind_str(value->type),
+                               se->id ? se->id : "");
+                monitor_printf(mon, "  memaddr: 0x%" PRIx64 "\n", se->memaddr);
+                monitor_printf(mon, "  size: %" PRIu64 "\n", se->size);
+                monitor_printf(mon, "  node: %" PRId64 "\n", se->node);
+                monitor_printf(mon, "  memdev: %s\n", se->memdev);
+                break;
+            default:
+                g_assert_not_reached();
+            }
+        }
+    }
+
+    qapi_free_MemoryDeviceInfoList(info_list);
+    hmp_handle_error(mon, err);
+}
+
+void hmp_info_vm_generation_id(Monitor *mon, const QDict *qdict)
+{
+    Error *err = NULL;
+    GuidInfo *info = qmp_query_vm_generation_id(&err);
+    if (info) {
+        monitor_printf(mon, "%s\n", info->guid);
+    }
+    hmp_handle_error(mon, err);
+    qapi_free_GuidInfo(info);
+}
+
+void hmp_info_memory_size_summary(Monitor *mon, const QDict *qdict)
+{
+    Error *err = NULL;
+    MemoryInfo *info = qmp_query_memory_size_summary(&err);
+    if (info) {
+        monitor_printf(mon, "base memory: %" PRIu64 "\n",
+                       info->base_memory);
+
+        if (info->has_plugged_memory) {
+            monitor_printf(mon, "plugged memory: %" PRIu64 "\n",
+                           info->plugged_memory);
+        }
+
+        qapi_free_MemoryInfo(info);
+    }
+    hmp_handle_error(mon, err);
+}
diff --git a/monitor/hmp-cmds.c b/monitor/hmp-cmds.c
index c8ed59c281..1e41381e77 100644
--- a/monitor/hmp-cmds.c
+++ b/monitor/hmp-cmds.c
@@ -26,7 +26,6 @@
 #include "qapi/qapi-builtin-visit.h"
 #include "qapi/qapi-commands-block.h"
 #include "qapi/qapi-commands-control.h"
-#include "qapi/qapi-commands-machine.h"
 #include "qapi/qapi-commands-migration.h"
 #include "qapi/qapi-commands-misc.h"
 #include "qapi/qapi-commands-net.h"
@@ -108,21 +107,6 @@ void hmp_info_version(Monitor *mon, const QDict *qdict)
     qapi_free_VersionInfo(info);
 }
 
-void hmp_info_kvm(Monitor *mon, const QDict *qdict)
-{
-    KvmInfo *info;
-
-    info = qmp_query_kvm(NULL);
-    monitor_printf(mon, "kvm support: ");
-    if (info->present) {
-        monitor_printf(mon, "%s\n", info->enabled ? "enabled" : "disabled");
-    } else {
-        monitor_printf(mon, "not compiled\n");
-    }
-
-    qapi_free_KvmInfo(info);
-}
-
 void hmp_info_status(Monitor *mon, const QDict *qdict)
 {
     StatusInfo *info;
@@ -142,15 +126,6 @@ void hmp_info_status(Monitor *mon, const QDict *qdict)
     qapi_free_StatusInfo(info);
 }
 
-void hmp_info_uuid(Monitor *mon, const QDict *qdict)
-{
-    UuidInfo *info;
-
-    info = qmp_query_uuid(NULL);
-    monitor_printf(mon, "%s\n", info->UUID);
-    qapi_free_UuidInfo(info);
-}
-
 void hmp_info_migrate(Monitor *mon, const QDict *qdict)
 {
     MigrationInfo *info;
@@ -469,21 +444,6 @@ void hmp_info_migrate_parameters(Monitor *mon, const QDict *qdict)
     qapi_free_MigrationParameters(params);
 }
 
-void hmp_info_balloon(Monitor *mon, const QDict *qdict)
-{
-    BalloonInfo *info;
-    Error *err = NULL;
-
-    info = qmp_query_balloon(&err);
-    if (hmp_handle_error(mon, err)) {
-        return;
-    }
-
-    monitor_printf(mon, "balloon: actual=%" PRId64 "\n", info->actual >> 20);
-
-    qapi_free_BalloonInfo(info);
-}
-
 static int hmp_info_pic_foreach(Object *obj, void *opaque)
 {
     InterruptStatsProvider *intc;
@@ -598,16 +558,6 @@ void hmp_sync_profile(Monitor *mon, const QDict *qdict)
     }
 }
 
-void hmp_system_reset(Monitor *mon, const QDict *qdict)
-{
-    qmp_system_reset(NULL);
-}
-
-void hmp_system_powerdown(Monitor *mon, const QDict *qdict)
-{
-    qmp_system_powerdown(NULL);
-}
-
 void hmp_exit_preconfig(Monitor *mon, const QDict *qdict)
 {
     Error *err = NULL;
@@ -628,34 +578,6 @@ void hmp_cpu(Monitor *mon, const QDict *qdict)
     }
 }
 
-void hmp_memsave(Monitor *mon, const QDict *qdict)
-{
-    uint32_t size = qdict_get_int(qdict, "size");
-    const char *filename = qdict_get_str(qdict, "filename");
-    uint64_t addr = qdict_get_int(qdict, "val");
-    Error *err = NULL;
-    int cpu_index = monitor_get_cpu_index(mon);
-
-    if (cpu_index < 0) {
-        monitor_printf(mon, "No CPU available\n");
-        return;
-    }
-
-    qmp_memsave(addr, size, filename, true, cpu_index, &err);
-    hmp_handle_error(mon, err);
-}
-
-void hmp_pmemsave(Monitor *mon, const QDict *qdict)
-{
-    uint32_t size = qdict_get_int(qdict, "size");
-    const char *filename = qdict_get_str(qdict, "filename");
-    uint64_t addr = qdict_get_int(qdict, "val");
-    Error *err = NULL;
-
-    qmp_pmemsave(addr, size, filename, &err);
-    hmp_handle_error(mon, err);
-}
-
 void hmp_cont(Monitor *mon, const QDict *qdict)
 {
     Error *err = NULL;
@@ -664,22 +586,6 @@ void hmp_cont(Monitor *mon, const QDict *qdict)
     hmp_handle_error(mon, err);
 }
 
-void hmp_system_wakeup(Monitor *mon, const QDict *qdict)
-{
-    Error *err = NULL;
-
-    qmp_system_wakeup(&err);
-    hmp_handle_error(mon, err);
-}
-
-void hmp_nmi(Monitor *mon, const QDict *qdict)
-{
-    Error *err = NULL;
-
-    qmp_inject_nmi(&err);
-    hmp_handle_error(mon, err);
-}
-
 void hmp_set_link(Monitor *mon, const QDict *qdict)
 {
     const char *name = qdict_get_str(qdict, "name");
@@ -690,15 +596,6 @@ void hmp_set_link(Monitor *mon, const QDict *qdict)
     hmp_handle_error(mon, err);
 }
 
-void hmp_balloon(Monitor *mon, const QDict *qdict)
-{
-    int64_t value = qdict_get_int(qdict, "value");
-    Error *err = NULL;
-
-    qmp_balloon(value, &err);
-    hmp_handle_error(mon, err);
-}
-
 void hmp_loadvm(Monitor *mon, const QDict *qdict)
 {
     int saved_vm_running  = runstate_is_running();
@@ -1193,83 +1090,6 @@ void hmp_object_del(Monitor *mon, const QDict *qdict)
     hmp_handle_error(mon, err);
 }
 
-void hmp_info_memory_devices(Monitor *mon, const QDict *qdict)
-{
-    Error *err = NULL;
-    MemoryDeviceInfoList *info_list = qmp_query_memory_devices(&err);
-    MemoryDeviceInfoList *info;
-    VirtioPMEMDeviceInfo *vpi;
-    VirtioMEMDeviceInfo *vmi;
-    MemoryDeviceInfo *value;
-    PCDIMMDeviceInfo *di;
-    SgxEPCDeviceInfo *se;
-
-    for (info = info_list; info; info = info->next) {
-        value = info->value;
-
-        if (value) {
-            switch (value->type) {
-            case MEMORY_DEVICE_INFO_KIND_DIMM:
-            case MEMORY_DEVICE_INFO_KIND_NVDIMM:
-                di = value->type == MEMORY_DEVICE_INFO_KIND_DIMM ?
-                     value->u.dimm.data : value->u.nvdimm.data;
-                monitor_printf(mon, "Memory device [%s]: \"%s\"\n",
-                               MemoryDeviceInfoKind_str(value->type),
-                               di->id ? di->id : "");
-                monitor_printf(mon, "  addr: 0x%" PRIx64 "\n", di->addr);
-                monitor_printf(mon, "  slot: %" PRId64 "\n", di->slot);
-                monitor_printf(mon, "  node: %" PRId64 "\n", di->node);
-                monitor_printf(mon, "  size: %" PRIu64 "\n", di->size);
-                monitor_printf(mon, "  memdev: %s\n", di->memdev);
-                monitor_printf(mon, "  hotplugged: %s\n",
-                               di->hotplugged ? "true" : "false");
-                monitor_printf(mon, "  hotpluggable: %s\n",
-                               di->hotpluggable ? "true" : "false");
-                break;
-            case MEMORY_DEVICE_INFO_KIND_VIRTIO_PMEM:
-                vpi = value->u.virtio_pmem.data;
-                monitor_printf(mon, "Memory device [%s]: \"%s\"\n",
-                               MemoryDeviceInfoKind_str(value->type),
-                               vpi->id ? vpi->id : "");
-                monitor_printf(mon, "  memaddr: 0x%" PRIx64 "\n", vpi->memaddr);
-                monitor_printf(mon, "  size: %" PRIu64 "\n", vpi->size);
-                monitor_printf(mon, "  memdev: %s\n", vpi->memdev);
-                break;
-            case MEMORY_DEVICE_INFO_KIND_VIRTIO_MEM:
-                vmi = value->u.virtio_mem.data;
-                monitor_printf(mon, "Memory device [%s]: \"%s\"\n",
-                               MemoryDeviceInfoKind_str(value->type),
-                               vmi->id ? vmi->id : "");
-                monitor_printf(mon, "  memaddr: 0x%" PRIx64 "\n", vmi->memaddr);
-                monitor_printf(mon, "  node: %" PRId64 "\n", vmi->node);
-                monitor_printf(mon, "  requested-size: %" PRIu64 "\n",
-                               vmi->requested_size);
-                monitor_printf(mon, "  size: %" PRIu64 "\n", vmi->size);
-                monitor_printf(mon, "  max-size: %" PRIu64 "\n", vmi->max_size);
-                monitor_printf(mon, "  block-size: %" PRIu64 "\n",
-                               vmi->block_size);
-                monitor_printf(mon, "  memdev: %s\n", vmi->memdev);
-                break;
-            case MEMORY_DEVICE_INFO_KIND_SGX_EPC:
-                se = value->u.sgx_epc.data;
-                monitor_printf(mon, "Memory device [%s]: \"%s\"\n",
-                               MemoryDeviceInfoKind_str(value->type),
-                               se->id ? se->id : "");
-                monitor_printf(mon, "  memaddr: 0x%" PRIx64 "\n", se->memaddr);
-                monitor_printf(mon, "  size: %" PRIu64 "\n", se->size);
-                monitor_printf(mon, "  node: %" PRId64 "\n", se->node);
-                monitor_printf(mon, "  memdev: %s\n", se->memdev);
-                break;
-            default:
-                g_assert_not_reached();
-            }
-        }
-    }
-
-    qapi_free_MemoryDeviceInfoList(info_list);
-    hmp_handle_error(mon, err);
-}
-
 void hmp_info_iothreads(Monitor *mon, const QDict *qdict)
 {
     IOThreadInfoList *info_list = qmp_query_iothreads(NULL);
@@ -1585,35 +1405,6 @@ void hmp_rocker_of_dpa_groups(Monitor *mon, const QDict *qdict)
     qapi_free_RockerOfDpaGroupList(list);
 }
 
-void hmp_info_vm_generation_id(Monitor *mon, const QDict *qdict)
-{
-    Error *err = NULL;
-    GuidInfo *info = qmp_query_vm_generation_id(&err);
-    if (info) {
-        monitor_printf(mon, "%s\n", info->guid);
-    }
-    hmp_handle_error(mon, err);
-    qapi_free_GuidInfo(info);
-}
-
-void hmp_info_memory_size_summary(Monitor *mon, const QDict *qdict)
-{
-    Error *err = NULL;
-    MemoryInfo *info = qmp_query_memory_size_summary(&err);
-    if (info) {
-        monitor_printf(mon, "base memory: %" PRIu64 "\n",
-                       info->base_memory);
-
-        if (info->has_plugged_memory) {
-            monitor_printf(mon, "plugged memory: %" PRIu64 "\n",
-                           info->plugged_memory);
-        }
-
-        qapi_free_MemoryInfo(info);
-    }
-    hmp_handle_error(mon, err);
-}
-
 static void print_stats_schema_value(Monitor *mon, StatsSchemaValue *value)
 {
     const char *unit = NULL;
-- 
2.39.0

