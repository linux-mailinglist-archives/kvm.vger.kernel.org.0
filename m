Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C671943C9FC
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 14:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242004AbhJ0Msy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 08:48:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45086 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241986AbhJ0Msx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 08:48:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635338787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fr+TtYyCiz9ln+xKFrWOdzxZutxWwjiyy4MKuQ7lZOg=;
        b=Q+4cK4+L577DVP30SRTjlZdoTHArqHLDrMKI0imtOYPzllqp61FH+K2/OPKWTv1vDBugal
        LF96pmfjYTotgYAhxZ70IouAGuF0sh7gSdq3FbCqAER6VPn2/tn9c9x/bNN6V30GCTQM6Y
        ndPgTsGqfUc/i160Ee8uGWH9XDliw54=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-j48Uqr6JOj6Y1savY1WJNg-1; Wed, 27 Oct 2021 08:46:24 -0400
X-MC-Unique: j48Uqr6JOj6Y1savY1WJNg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 675F75075A;
        Wed, 27 Oct 2021 12:46:23 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.193.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAD4319D9F;
        Wed, 27 Oct 2021 12:46:19 +0000 (UTC)
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
Subject: [PATCH v1 12/12] virtio-mem: Expose device memory via multiple memslots
Date:   Wed, 27 Oct 2021 14:45:31 +0200
Message-Id: <20211027124531.57561-13-david@redhat.com>
In-Reply-To: <20211027124531.57561-1-david@redhat.com>
References: <20211027124531.57561-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want to expose virtio-mem device memory via multiple memslots to the
guest on demand, essentially reducing the total size of KVM slots
significantly (and thereby metadata in KVM and in QEMU for KVM memory
slots) especially when exposing initially only a small amount of memory via
a virtio-mem device to the guest, to hotplug more memory later. Further,
not always exposing the full device memory region to the guest reduces the
attack surface in many setups without requiring other mechanisms like
userfaultfd for protection of unplugged memory.

So split the original RAM region via memory region aliases into separate
memory slots, and dynamically map the required memory slots into the
container.

For now, we always map the memslots covered by the usable region. In the
future, with VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE, we'll be able to map
memslots on actual demand and optimize further.

The user is in charge of setting the number of memslots the device
should use. In the future, we might add an auto mode, specified via
"memslots=0" for user convenience.

There are two new properties:

1) "used-memslots" contains how many memslots are currently used
 and is read-only. Used internally, but can also be used for debugging/
 introspection purposes.

2) "memslots" specifies how many memslots the device is should use.
 * "1" is the default and corresponds mostly to the old behavior. The
   only exception is that with a usable region size of 0, the single
   memslot won't get used and nothing will get mapped.
 * "> 1" tells the device to use the given number of memslots. There are
   a couple of restrictions:
   * Cannot be bigger than 1024 or equal to 0.
   * Cannot be bigger than the number of device blocks.
   * Must not result in memslots that are smaller than the minimum
     memslot size
 This parameter doesn't have to be migrated and can differ between
 source and destination.

The minimum memslot size (and thereby the alignment of memslots in
guest physical address space) is currently defined to be 128 MiB --
a memory slot size we know works (due to x86-64 DIMMs) without confusing
devices that might not be able to handle crossing memory regions in
address spaces when performing I/O.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/virtio-mem-pci.c     |  23 +++++
 hw/virtio/virtio-mem.c         | 183 ++++++++++++++++++++++++++++++++-
 include/hw/virtio/virtio-mem.h |  25 ++++-
 3 files changed, 226 insertions(+), 5 deletions(-)

diff --git a/hw/virtio/virtio-mem-pci.c b/hw/virtio/virtio-mem-pci.c
index be2383b0c5..1dc4078941 100644
--- a/hw/virtio/virtio-mem-pci.c
+++ b/hw/virtio/virtio-mem-pci.c
@@ -82,6 +82,21 @@ static uint64_t virtio_mem_pci_get_min_alignment(const MemoryDeviceState *md)
                                     &error_abort);
 }
 
+static unsigned int virtio_mem_pci_get_used_memslots(
+                                                    const MemoryDeviceState *md,
+                                                     Error **errp)
+{
+    return object_property_get_uint(OBJECT(md), VIRTIO_MEM_USED_MEMSLOTS_PROP,
+                                    &error_abort);
+}
+
+static unsigned int virtio_mem_pci_get_memslots(const MemoryDeviceState *md,
+                                                Error **errp)
+{
+    return object_property_get_uint(OBJECT(md), VIRTIO_MEM_MEMSLOTS_PROP,
+                                    &error_abort);
+}
+
 static void virtio_mem_pci_size_change_notify(Notifier *notifier, void *data)
 {
     VirtIOMEMPCI *pci_mem = container_of(notifier, VirtIOMEMPCI,
@@ -115,6 +130,8 @@ static void virtio_mem_pci_class_init(ObjectClass *klass, void *data)
     mdc->get_memory_region = virtio_mem_pci_get_memory_region;
     mdc->fill_device_info = virtio_mem_pci_fill_device_info;
     mdc->get_min_alignment = virtio_mem_pci_get_min_alignment;
+    mdc->get_used_memslots = virtio_mem_pci_get_used_memslots;
+    mdc->get_memslots = virtio_mem_pci_get_memslots;
 }
 
 static void virtio_mem_pci_instance_init(Object *obj)
@@ -142,6 +159,12 @@ static void virtio_mem_pci_instance_init(Object *obj)
     object_property_add_alias(obj, VIRTIO_MEM_REQUESTED_SIZE_PROP,
                               OBJECT(&dev->vdev),
                               VIRTIO_MEM_REQUESTED_SIZE_PROP);
+    object_property_add_alias(obj, VIRTIO_MEM_MEMSLOTS_PROP,
+                              OBJECT(&dev->vdev),
+                              VIRTIO_MEM_MEMSLOTS_PROP);
+    object_property_add_alias(obj, VIRTIO_MEM_USED_MEMSLOTS_PROP,
+                              OBJECT(&dev->vdev),
+                              VIRTIO_MEM_USED_MEMSLOTS_PROP);
 }
 
 static const VirtioPCIDeviceTypeInfo virtio_mem_pci_info = {
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index 1e29706798..f0ad365b91 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -23,6 +23,7 @@
 #include "hw/virtio/virtio-bus.h"
 #include "hw/virtio/virtio-access.h"
 #include "hw/virtio/virtio-mem.h"
+#include "hw/mem/memory-device.h"
 #include "qapi/error.h"
 #include "qapi/visitor.h"
 #include "exec/ram_addr.h"
@@ -46,6 +47,13 @@
 #define VIRTIO_MEM_DEFAULT_THP_SIZE VIRTIO_MEM_MIN_BLOCK_SIZE
 #endif
 
+/*
+ * Let's not allow a crazy number of memslots for a single virtio-mem device
+ * and try to size memslots reasonably large.
+ */
+#define VIRTIO_MEM_MAX_MEMSLOTS 1024
+#define VIRTIO_MEM_MIN_MEMSLOT_SIZE (128 * MiB)
+
 /*
  * We want to have a reasonable default block size such that
  * 1. We avoid splitting THPs when unplugging memory, which degrades
@@ -500,6 +508,7 @@ static void virtio_mem_resize_usable_region(VirtIOMEM *vmem,
 {
     uint64_t newsize = MIN(memory_region_size(&vmem->memdev->mr),
                            requested_size + VIRTIO_MEM_USABLE_EXTENT);
+    int i;
 
     /* The usable region size always has to be multiples of the block size. */
     newsize = QEMU_ALIGN_UP(newsize, vmem->block_size);
@@ -514,6 +523,25 @@ static void virtio_mem_resize_usable_region(VirtIOMEM *vmem,
 
     trace_virtio_mem_resized_usable_region(vmem->usable_region_size, newsize);
     vmem->usable_region_size = newsize;
+
+    /*
+     * Map all unmapped memslots that cover the usable region and unmap all
+     * remaining mapped ones.
+     */
+    for (i = 0; i < vmem->nb_memslots; i++) {
+        if (vmem->memslot_size * i < vmem->usable_region_size) {
+            if (!memory_region_is_mapped(&vmem->memslots[i])) {
+                memory_region_add_subregion(vmem->mr, vmem->memslot_size * i,
+                                            &vmem->memslots[i]);
+                vmem->nb_used_memslots++;
+            }
+        } else {
+            if (memory_region_is_mapped(&vmem->memslots[i])) {
+                memory_region_del_subregion(vmem->mr, &vmem->memslots[i]);
+                vmem->nb_used_memslots--;
+            }
+        }
+    }
 }
 
 static int virtio_mem_unplug_all(VirtIOMEM *vmem)
@@ -674,6 +702,83 @@ static void virtio_mem_system_reset(void *opaque)
     virtio_mem_unplug_all(vmem);
 }
 
+static void virtio_mem_alloc_mr(VirtIOMEM *vmem)
+{
+    const uint64_t region_size = memory_region_size(&vmem->memdev->mr);
+
+    vmem->mr = g_new0(MemoryRegion, 1);
+    memory_region_init(vmem->mr, OBJECT(vmem), "virtio-mem-memslots",
+                       region_size);
+    vmem->mr->align = memory_region_get_alignment(&vmem->memdev->mr);
+}
+
+static int virtio_mem_prepare_memslots(VirtIOMEM *vmem, Error **errp)
+{
+    const uint64_t region_size = memory_region_size(&vmem->memdev->mr);
+    const uint64_t device_blocks = region_size / vmem->block_size;
+
+    if (vmem->nb_memslots == 1) {
+        vmem->memslot_size = region_size;
+        return 0;
+    }
+
+    /* We cannot have more memslots than device blocks. */
+    if (vmem->nb_memslots > device_blocks) {
+        error_setg(errp, "'%s' property exceeds the total number of device"
+                   " blocks (%" PRIu64 ")", VIRTIO_MEM_MEMSLOTS_PROP,
+                   device_blocks);
+        return -EINVAL;
+    }
+
+    /*
+     * We'll make sure the memslots are multiple of the minimum memslot size
+     * and multiple of the device block size; This can make the last memslot
+     * larger than the others.
+     */
+    vmem->memslot_size = QEMU_ALIGN_UP(region_size, vmem->nb_memslots) /
+                         vmem->nb_memslots;
+    vmem->memslot_size = QEMU_ALIGN_DOWN(vmem->memslot_size, vmem->block_size);
+    vmem->memslot_size = QEMU_ALIGN_DOWN(vmem->memslot_size,
+                                         VIRTIO_MEM_MIN_MEMSLOT_SIZE);
+    if (!vmem->memslot_size) {
+        error_setg(errp, "'%s' property would create memory slots smaller than"
+                   " the minimum supported memory slot size (%lu MiB)",
+                   VIRTIO_MEM_MEMSLOTS_PROP, VIRTIO_MEM_MIN_MEMSLOT_SIZE / MiB);
+        return -EINVAL;
+    }
+
+    return 0;
+}
+
+static void virtio_mem_alloc_memslots(VirtIOMEM *vmem)
+{
+    const uint64_t region_size = memory_region_size(&vmem->memdev->mr);
+    int i;
+
+    /* Create our memslots but don't map them yet -- we'll map dynamically. */
+    vmem->memslots = g_new0(MemoryRegion, vmem->nb_memslots);
+    for (i = 0; i < vmem->nb_memslots; i++) {
+        uint64_t size;
+        char name[80];
+
+        /* The size of the last memslot might differ. */
+        size = vmem->memslot_size;
+        if (i + 1 == vmem->nb_memslots) {
+            size = region_size - i * vmem->memslot_size;
+        }
+
+        snprintf(name, sizeof(name), "virtio-mem-memslot-%u", i);
+        memory_region_init_alias(&vmem->memslots[i], OBJECT(vmem), name,
+                                 &vmem->memdev->mr, vmem->memslot_size * i,
+                                 size);
+        /*
+         * We want our aliases to result in separate memory sections and thereby
+         * separate memslots.
+         */
+        memory_region_set_alias_unmergeable(&vmem->memslots[i], true);
+    }
+}
+
 static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
@@ -751,6 +856,10 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
+    if (virtio_mem_prepare_memslots(vmem, errp)) {
+        return;
+    }
+
     if (ram_block_coordinated_discard_require(true)) {
         error_setg(errp, "Discarding RAM is disabled");
         return;
@@ -763,12 +872,15 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    virtio_mem_resize_usable_region(vmem, vmem->requested_size, true);
-
     vmem->bitmap_size = memory_region_size(&vmem->memdev->mr) /
                         vmem->block_size;
     vmem->bitmap = bitmap_new(vmem->bitmap_size);
 
+    if (!vmem->mr) {
+        virtio_mem_alloc_mr(vmem);
+    }
+    virtio_mem_alloc_memslots(vmem);
+
     virtio_init(vdev, TYPE_VIRTIO_MEM, VIRTIO_ID_MEM,
                 sizeof(struct virtio_mem_config));
     vmem->vq = virtio_add_queue(vdev, 128, virtio_mem_handle_request);
@@ -780,7 +892,7 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
      */
     memory_region_set_ram_discard_manager(&vmem->memdev->mr,
                                           RAM_DISCARD_MANAGER(vmem));
-
+    virtio_mem_resize_usable_region(vmem, vmem->requested_size, true);
     host_memory_backend_set_mapped(vmem->memdev, true);
     vmstate_register_ram(&vmem->memdev->mr, DEVICE(vmem));
     qemu_register_reset(virtio_mem_system_reset, vmem);
@@ -794,9 +906,12 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
     qemu_unregister_reset(virtio_mem_system_reset, vmem);
     vmstate_unregister_ram(&vmem->memdev->mr, DEVICE(vmem));
     host_memory_backend_set_mapped(vmem->memdev, false);
+    virtio_mem_resize_usable_region(vmem, 0, true);
     memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
     virtio_del_queue(vdev, 0);
     virtio_cleanup(vdev);
+    g_free(vmem->memslots);
+    g_free(vmem->mr);
     g_free(vmem->bitmap);
     ram_block_coordinated_discard_require(false);
 }
@@ -955,7 +1070,10 @@ static MemoryRegion *virtio_mem_get_memory_region(VirtIOMEM *vmem, Error **errp)
         return NULL;
     }
 
-    return &vmem->memdev->mr;
+    if (!vmem->mr) {
+        virtio_mem_alloc_mr(vmem);
+    }
+    return vmem->mr;
 }
 
 static void virtio_mem_add_size_change_notifier(VirtIOMEM *vmem,
@@ -1084,10 +1202,62 @@ static void virtio_mem_set_block_size(Object *obj, Visitor *v, const char *name,
     vmem->block_size = value;
 }
 
+static void virtio_mem_get_used_memslots(Object *obj, Visitor *v,
+                                          const char *name,
+                                          void *opaque, Error **errp)
+{
+    const VirtIOMEM *vmem = VIRTIO_MEM(obj);
+    uint16_t value = vmem->nb_used_memslots;
+
+    visit_type_uint16(v, name, &value, errp);
+}
+
+static void virtio_mem_get_memslots(Object *obj, Visitor *v, const char *name,
+                                    void *opaque, Error **errp)
+{
+    VirtIOMEM *vmem = VIRTIO_MEM(obj);
+    uint16_t value = vmem->nb_memslots;
+
+    visit_type_uint16(v, name, &value, errp);
+}
+
+static void virtio_mem_set_memslots(Object *obj, Visitor *v, const char *name,
+                                    void *opaque, Error **errp)
+{
+    VirtIOMEM *vmem = VIRTIO_MEM(obj);
+    Error *err = NULL;
+    uint16_t value;
+
+    if (DEVICE(obj)->realized) {
+        error_setg(errp, "'%s' cannot be changed", name);
+        return;
+    }
+
+    visit_type_uint16(v, name, &value, &err);
+    if (err) {
+        error_propagate(errp, err);
+        return;
+    }
+    if (value > VIRTIO_MEM_MAX_MEMSLOTS) {
+        error_setg(errp, "'%s' property must not exceed '%d'", name,
+                   VIRTIO_MEM_MAX_MEMSLOTS);
+        return;
+    } else if (!value) {
+        error_setg(errp, "'%s' property must not be '0'", name);
+        return;
+    }
+    vmem->nb_memslots = value;
+}
+
 static void virtio_mem_instance_init(Object *obj)
 {
     VirtIOMEM *vmem = VIRTIO_MEM(obj);
 
+    /*
+     * Default to a single memslot, the old default; users have to opt in for
+     * more by setting the "memslots" property accordingly.
+     */
+    vmem->nb_memslots = 1;
     notifier_list_init(&vmem->size_change_notifiers);
     QLIST_INIT(&vmem->rdl_list);
 
@@ -1099,6 +1269,11 @@ static void virtio_mem_instance_init(Object *obj)
     object_property_add(obj, VIRTIO_MEM_BLOCK_SIZE_PROP, "size",
                         virtio_mem_get_block_size, virtio_mem_set_block_size,
                         NULL, NULL);
+    object_property_add(obj, VIRTIO_MEM_MEMSLOTS_PROP, "uint16",
+                        virtio_mem_get_memslots, virtio_mem_set_memslots, NULL,
+                        NULL);
+    object_property_add(obj, VIRTIO_MEM_USED_MEMSLOTS_PROP, "uint16",
+                        virtio_mem_get_used_memslots, NULL, NULL, NULL);
 }
 
 static Property virtio_mem_properties[] = {
diff --git a/include/hw/virtio/virtio-mem.h b/include/hw/virtio/virtio-mem.h
index a5dd6a493b..8d72427be2 100644
--- a/include/hw/virtio/virtio-mem.h
+++ b/include/hw/virtio/virtio-mem.h
@@ -30,6 +30,8 @@ OBJECT_DECLARE_TYPE(VirtIOMEM, VirtIOMEMClass,
 #define VIRTIO_MEM_REQUESTED_SIZE_PROP "requested-size"
 #define VIRTIO_MEM_BLOCK_SIZE_PROP "block-size"
 #define VIRTIO_MEM_ADDR_PROP "memaddr"
+#define VIRTIO_MEM_MEMSLOTS_PROP "memslots"
+#define VIRTIO_MEM_USED_MEMSLOTS_PROP "used-memslots"
 
 struct VirtIOMEM {
     VirtIODevice parent_obj;
@@ -41,9 +43,30 @@ struct VirtIOMEM {
     int32_t bitmap_size;
     unsigned long *bitmap;
 
-    /* assigned memory backend and memory region */
+    /* Device memory region in which we dynamically map memslots */
+    MemoryRegion *mr;
+
+    /*
+     * Assigned memory backend with the RAM memory region we will split
+     * into memslots to dynamically map them into the device memory region.
+     */
     HostMemoryBackend *memdev;
 
+    /*
+     * Individual memslots we dynamically map that are aliases to the
+     * assigned RAM memory region
+     */
+    MemoryRegion *memslots;
+
+    /* Total number of memslots we're going to use. */
+    uint16_t nb_memslots;
+
+    /* Current number of memslots we're using. */
+    uint16_t nb_used_memslots;
+
+    /* Size of one memslot (the last one can differ) */
+    uint64_t memslot_size;
+
     /* NUMA node */
     uint32_t node;
 
-- 
2.31.1

