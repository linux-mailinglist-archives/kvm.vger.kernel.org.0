Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4318843C9F6
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 14:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241993AbhJ0Msp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 08:48:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24921 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242004AbhJ0Mse (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 08:48:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635338769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Jg/b6nvIHSM/B2S2cdIl1E9LXRFcI99q0x3sJS0Zmk=;
        b=NM4ktTRdiIXb7T63Sf01C5zuvexWmlgEIDZVne5/s0FVru0zShVLi74OLFH5fYpuD+qS5O
        7ekG8RcS1h8U7rnM2jvRH6qm0lSQotIfc9UJLA42S/+XIjke0R77cyjvWA3xq/xM8sldW9
        tyj9Iy1+F4PjgyqAUOTD/tuIIzaQQbk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-J4Y1EJ_kMh24ZGfTLkBP9w-1; Wed, 27 Oct 2021 08:46:05 -0400
X-MC-Unique: J4Y1EJ_kMh24ZGfTLkBP9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9949A10A8E01;
        Wed, 27 Oct 2021 12:46:04 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.193.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 283CF19D9F;
        Wed, 27 Oct 2021 12:46:00 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Hui Zhu <teawater@gmail.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        kvm@vger.kernel.org
Subject: [PATCH v1 07/12] memory-device: Support memory devices that dynamically consume multiple memslots
Date:   Wed, 27 Oct 2021 14:45:26 +0200
Message-Id: <20211027124531.57561-8-david@redhat.com>
In-Reply-To: <20211027124531.57561-1-david@redhat.com>
References: <20211027124531.57561-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want to support memory devices that have a container as device memory
region, and (dynamically) map individual chunks into that container
resulting in multiple memslots getting consumed by such a device. So we
want to support memory devices that require a) multiple memslots and
b) dynamically make use of these memslots.

We already have one device that uses a container as device memory region:
NVDIMM. However, an NVDIMM also end up consuming exactly one memslot.

The target use case will be virtio-mem, which will dynamically map
parts of a source RAM memory region into the container device region
using aliases, consuming one memslot per alias.

We need a way to query from a memory device:
* The currently used number memslots.
* The total number of memslots that might get used across device
  lifetime.

Expose one helper functions -- memory_devices_get_reserved_memslots() --
that will be used by vhost code to respect the current memslot reservation
when realizing vhost device.

Limit the number of memslots usable by memory devices to something sane
-- for now 2048 -- we really don't want to create tens of thousands of
memslots that can degrade performance when traversing an address space,
just because it would be possible (for example, without KVM and without
vhost there is no real limit ...). This does not affect existing setups
(for example more than 256 DIMMs+NVDIMMs is not supported).

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/mem/memory-device.c         | 84 ++++++++++++++++++++++++++++++----
 include/hw/mem/memory-device.h | 33 +++++++++++++
 stubs/qmp_memory_device.c      |  5 ++
 3 files changed, 113 insertions(+), 9 deletions(-)

diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
index a915894819..bb02eb410a 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -18,6 +18,8 @@
 #include "sysemu/kvm.h"
 #include "trace.h"
 
+#define MEMORY_DEVICES_MAX_MEMSLOTS     2048
+
 static gint memory_device_addr_sort(gconstpointer a, gconstpointer b)
 {
     const MemoryDeviceState *md_a = MEMORY_DEVICE(a);
@@ -50,8 +52,28 @@ static int memory_device_build_list(Object *obj, void *opaque)
     return 0;
 }
 
+static unsigned int memory_device_get_used_memslots(const MemoryDeviceState *md)
+{
+    const MemoryDeviceClass *mdc = MEMORY_DEVICE_GET_CLASS(md);
+
+    if (!mdc->get_used_memslots)
+        return 1;
+    return mdc->get_used_memslots(md, &error_abort);
+}
+
+static unsigned int memory_device_get_memslots(const MemoryDeviceState *md)
+{
+    const MemoryDeviceClass *mdc = MEMORY_DEVICE_GET_CLASS(md);
+
+    if (!mdc->get_memslots)
+        return 1;
+    return mdc->get_memslots(md, &error_abort);
+}
+
 struct memory_devices_info {
     uint64_t region_size;
+    unsigned int used_memslots;
+    unsigned int reserved_memslots;
 };
 
 static int memory_devices_collect_info(Object *obj, void *opaque)
@@ -61,9 +83,15 @@ static int memory_devices_collect_info(Object *obj, void *opaque)
     if (object_dynamic_cast(obj, TYPE_MEMORY_DEVICE)) {
         const DeviceState *dev = DEVICE(obj);
         const MemoryDeviceState *md = MEMORY_DEVICE(obj);
+        unsigned int used, total;
 
         if (dev->realized) {
             i->region_size += memory_device_get_region_size(md, &error_abort);
+
+            used = memory_device_get_used_memslots(md);
+            total = memory_device_get_memslots(md);
+            i->used_memslots += used;
+            i->reserved_memslots += total - used;
         }
     }
 
@@ -71,24 +99,62 @@ static int memory_devices_collect_info(Object *obj, void *opaque)
     return 0;
 }
 
-static void memory_device_check_addable(MachineState *ms, MemoryRegion *mr,
-                                        Error **errp)
+/*
+ * Get the number of memslots that are reserved (not used yet but will get used
+ * dynamically in the future without further checks) by all memory devices.
+ */
+unsigned int memory_devices_get_reserved_memslots(void)
+{
+    struct memory_devices_info info = {};
+
+    memory_devices_collect_info(qdev_get_machine(), &info);
+    return info.reserved_memslots;
+}
+
+static void memory_device_check_addable(MachineState *ms, MemoryDeviceState *md,
+                                        MemoryRegion *mr, Error **errp)
 {
     const uint64_t size = memory_region_size(mr);
     struct memory_devices_info info = {};
+    unsigned int required, reserved;
+
+    memory_devices_collect_info(OBJECT(ms), &info);
+    reserved = info.reserved_memslots;
+    required = memory_device_get_memslots(md);
 
-    /* we will need a new memory slot for kvm and vhost */
-    if (kvm_enabled() && !kvm_get_free_memslots()) {
-        error_setg(errp, "hypervisor has no free memory slots left");
+    /*
+     * Limit the maximum number of memslot used by memory devices to something
+     * sane.
+     */
+    if (info.used_memslots + reserved + required >
+        MEMORY_DEVICES_MAX_MEMSLOTS) {
+        error_setg(errp, "The maximum number of memory slots to be consumed by"
+                   " memory devices (%u) would be exceeded. Used: %u,"
+                   " Reserved: %u, Required: %u",
+                   MEMORY_DEVICES_MAX_MEMSLOTS, info.used_memslots,
+                   reserved, required);
         return;
     }
-    if (!vhost_get_free_memslots()) {
-        error_setg(errp, "a used vhost backend has no free memory slots left");
+
+    /*
+     * All memslots used by memory devices are already subtracted from
+     * the free memslots as reported by kvm and vhost.
+     */
+    if (kvm_enabled() && kvm_get_free_memslots() < reserved + required) {
+        error_setg(errp, "KVM does not have enough free, unreserved memory"
+                   "slots left. Free: %u, Reserved: %u, Required: %u",
+                   kvm_get_free_memslots(), reserved, required);
+        return;
+    }
+    if (vhost_get_free_memslots() < reserved + required) {
+        error_setg(errp, "a used vhost backend does not have enough free,"
+                   " unreserved memory slots left. Free: %u, Reserved: %u,"
+                   " Required: %u", vhost_get_free_memslots(), reserved,
+                   required);
         return;
     }
 
     /* will we exceed the total amount of memory specified */
-    memory_devices_collect_info(OBJECT(ms), &info);
     if (info.region_size + size < info.region_size ||
         info.region_size + size > ms->maxram_size - ms->ram_size) {
         error_setg(errp, "not enough space, currently 0x%" PRIx64
@@ -257,7 +323,7 @@ void memory_device_pre_plug(MemoryDeviceState *md, MachineState *ms,
         goto out;
     }
 
-    memory_device_check_addable(ms, mr, &local_err);
+    memory_device_check_addable(ms, md, mr, &local_err);
     if (local_err) {
         goto out;
     }
diff --git a/include/hw/mem/memory-device.h b/include/hw/mem/memory-device.h
index 48d2611fc5..c811415ce6 100644
--- a/include/hw/mem/memory-device.h
+++ b/include/hw/mem/memory-device.h
@@ -98,6 +98,38 @@ struct MemoryDeviceClass {
      */
     uint64_t (*get_min_alignment)(const MemoryDeviceState *md);
 
+    /*
+     * Optional: Return the number of used individual memslots (i.e.,
+     * individual RAM mappings) the device has created in the memory region of
+     * the device. The device has to make sure that memslots won't get merged
+     * internally (e.g,, by disabling merging of memory region aliases) if the
+     * memory region layout could allow for that.
+     *
+     * If this function is not implemented, we assume the device memory region
+     * is not a container and that there is exactly one memslot getting used
+     * after realizing and plugging the device.
+     *
+     * Called when plugging the memory device or when iterating over
+     * all realized memory devices to calculate used/reserved/available
+     * memslots.
+     */
+    unsigned int (*get_used_memslots)(const MemoryDeviceState *md, Error **errp);
+
+    /*
+     * Optional: Return the total number of individual memslots
+     * (i.e., individual RAM mappings) the device may create in the the memory
+     * region of the device over its lifetime. The result must never change.
+     *
+     * If this function is not implemented, we assume the device memory region
+     * is not a container and that there will be exactly one memslot getting
+     * used after realizing and plugging the device.
+     *
+     * Called when plugging the memory device or when iterating over
+     * all realized memory devices to calculate used/reserved/available
+     * memslots.
+     */
+    unsigned int (*get_memslots)(const MemoryDeviceState *md, Error **errp);
+
     /*
      * Translate the memory device into #MemoryDeviceInfo.
      */
@@ -113,5 +145,6 @@ void memory_device_plug(MemoryDeviceState *md, MachineState *ms);
 void memory_device_unplug(MemoryDeviceState *md, MachineState *ms);
 uint64_t memory_device_get_region_size(const MemoryDeviceState *md,
                                        Error **errp);
+unsigned int memory_devices_get_reserved_memslots(void);
 
 #endif
diff --git a/stubs/qmp_memory_device.c b/stubs/qmp_memory_device.c
index e75cac62dc..318a5d4187 100644
--- a/stubs/qmp_memory_device.c
+++ b/stubs/qmp_memory_device.c
@@ -10,3 +10,8 @@ uint64_t get_plugged_memory_size(void)
 {
     return (uint64_t)-1;
 }
+
+unsigned int memory_devices_get_reserved_memslots(void)
+{
+    return 0;
+}
-- 
2.31.1

