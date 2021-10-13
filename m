Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DC842BD43
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 12:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhJMKmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 06:42:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38692 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229599AbhJMKmR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 06:42:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634121614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hfDP3762FkoZZG6FBVSMAS6iAUs3K6cNZa87Izprn0s=;
        b=AM4JRpCDHYdVwbzPovJ9Yybga/etnBSfrQv/WL1xNR/5hNVDRJm4v1NyEo3gQq4tEzvyrv
        BV0CpOJBcFz3GpFexUdjAs3XYozpYOS+Q+F4Qgf9hn11E96PJ1Js0AlTOEMCXWc8J4yiKj
        avMBGW6LwFmz5Tt4VUQ3gveJvYPBAZI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-tU6bOfqAPhOJWITFGO2yeA-1; Wed, 13 Oct 2021 06:40:13 -0400
X-MC-Unique: tU6bOfqAPhOJWITFGO2yeA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E91210A8E02;
        Wed, 13 Oct 2021 10:40:12 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBC2D5D9D5;
        Wed, 13 Oct 2021 10:39:38 +0000 (UTC)
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
        kvm@vger.kernel.org
Subject: [PATCH RFC 12/15] virtio-mem: Expose device memory via separate memslots
Date:   Wed, 13 Oct 2021 12:33:27 +0200
Message-Id: <20211013103330.26869-13-david@redhat.com>
In-Reply-To: <20211013103330.26869-1-david@redhat.com>
References: <20211013103330.26869-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM nowadays supports a lot of memslots. We want to exploit that in
virtio-mem, exposing device memory via separate memslots to the guest
on demand, essentially reducing the total size of KVM slots
significantly (and thereby metadata in KVM and in QEMU for KVM memory
slots) especially when exposing initially only a small amount of memory
via a virtio-mem device to the guest, to hotplug more later. Further,
not always exposing the full device memory region to the guest reduces
the attack surface in many setups without requiring other mechanisms
like uffd for protection of unplugged memory.

So split the original RAM region via memory region aliases into separate
chunks (ending up as individual memslots), and dynamically map the
required chunks (falling into the usable region) into the container.

For now, we always map the memslots covered by the usable region. In the
future, with VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE, we'll be able to map
memslots on actual demand and optimize further.

Users can specify via the "max-memslots" property how much memslots the
virtio-mem device is allowed to use at max. "0" translates to "auto, no
limit" and is determinded automatically using a heuristic. When a maximum
(> 1) is specified, that auto-determined value is capped. The parameter
doesn't have to be migrated and can differ between source and destination.
The only reason the parameter exists is not make some corner case setups
(multiple large virtio-mem devices assigned to a single virtual NUMA node
 with only very limited available memslots, hotplug of vhost devices) work.
The parameter will be set to be "0" as default soon, whereby it will remain
to be "1" for compat machines.

The properties "memslots" and "used-memslots" are read-only.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/virtio-mem-pci.c     |  22 +++++
 hw/virtio/virtio-mem.c         | 173 ++++++++++++++++++++++++++++++++-
 include/hw/virtio/virtio-mem.h |  29 +++++-
 3 files changed, 220 insertions(+), 4 deletions(-)

diff --git a/hw/virtio/virtio-mem-pci.c b/hw/virtio/virtio-mem-pci.c
index be2383b0c5..2c1be2afb7 100644
--- a/hw/virtio/virtio-mem-pci.c
+++ b/hw/virtio/virtio-mem-pci.c
@@ -82,6 +82,20 @@ static uint64_t virtio_mem_pci_get_min_alignment(const MemoryDeviceState *md)
                                     &error_abort);
 }
 
+static unsigned int virtio_mem_pci_get_used_memslots(const MemoryDeviceState *md,
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
@@ -115,6 +129,8 @@ static void virtio_mem_pci_class_init(ObjectClass *klass, void *data)
     mdc->get_memory_region = virtio_mem_pci_get_memory_region;
     mdc->fill_device_info = virtio_mem_pci_fill_device_info;
     mdc->get_min_alignment = virtio_mem_pci_get_min_alignment;
+    mdc->get_used_memslots = virtio_mem_pci_get_used_memslots;
+    mdc->get_memslots = virtio_mem_pci_get_memslots;
 }
 
 static void virtio_mem_pci_instance_init(Object *obj)
@@ -142,6 +158,12 @@ static void virtio_mem_pci_instance_init(Object *obj)
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
index 1e29706798..f7e8f1db83 100644
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
@@ -500,6 +501,7 @@ static void virtio_mem_resize_usable_region(VirtIOMEM *vmem,
 {
     uint64_t newsize = MIN(memory_region_size(&vmem->memdev->mr),
                            requested_size + VIRTIO_MEM_USABLE_EXTENT);
+    int i;
 
     /* The usable region size always has to be multiples of the block size. */
     newsize = QEMU_ALIGN_UP(newsize, vmem->block_size);
@@ -514,6 +516,25 @@ static void virtio_mem_resize_usable_region(VirtIOMEM *vmem,
 
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
@@ -674,6 +695,92 @@ static void virtio_mem_system_reset(void *opaque)
     virtio_mem_unplug_all(vmem);
 }
 
+static void virtio_mem_prepare_mr(VirtIOMEM *vmem)
+{
+    const uint64_t region_size = memory_region_size(&vmem->memdev->mr);
+
+    if (vmem->mr) {
+        return;
+    }
+
+    vmem->mr = g_malloc0(sizeof(*vmem->mr));
+    memory_region_init(vmem->mr, OBJECT(vmem), "virtio-mem-memslots",
+                       region_size);
+    vmem->mr->align = memory_region_get_alignment(&vmem->memdev->mr);
+}
+
+/*
+ * Calculate the number of memslots we'll use based on device properties and
+ * available + already used+reserved memslots for other devices.
+ *
+ * Must not get called after realizing the device.
+ */
+static unsigned int virtio_mem_calc_nb_memslots(uint64_t region_size,
+                                                uint64_t block_size,
+                                                unsigned int user_limit)
+{
+    unsigned int limit = memory_devices_calc_memslot_limit(region_size);
+    uint64_t memslot_size;
+
+    /*
+     * We never use more than 1024 memslots for a single device (relevant only
+     * for devices > 1 TiB).
+     */
+    limit = MIN(limit, 1024);
+
+    /*
+     * We'll never use memslots that are smaller than 1 GiB or smaller than
+     * the block size (and thereby the page size). memslots are always a power
+     * of two.
+     */
+    memslot_size = MAX(1 * GiB, block_size);
+    while (ROUND_UP(region_size, memslot_size) / memslot_size > limit) {
+        memslot_size *= 2;
+    }
+    limit = ROUND_UP(region_size, memslot_size) / memslot_size;
+
+    return !user_limit ? limit : MIN(user_limit, limit);
+}
+
+static void virtio_mem_prepare_memslots(VirtIOMEM *vmem)
+{
+    const uint64_t region_size = memory_region_size(&vmem->memdev->mr);
+    int i;
+
+    if (!vmem->nb_memslots) {
+        vmem->nb_memslots = virtio_mem_calc_nb_memslots(region_size,
+                                                        vmem->block_size,
+                                                        vmem->nb_max_memslots);
+    }
+    if (vmem->nb_memslots == 1) {
+        vmem->memslot_size = region_size;
+    } else {
+        vmem->memslot_size = 1 * GiB;
+        while (ROUND_UP(region_size, vmem->memslot_size) / vmem->memslot_size >
+               vmem->nb_memslots) {
+            vmem->memslot_size *= 2;
+        }
+    }
+
+    /* Create our memslots but don't map them yet -- we'll map dynamically. */
+    vmem->memslots = g_malloc0_n(vmem->nb_memslots, sizeof(*vmem->memslots));
+    for (i = 0; i < vmem->nb_memslots; i++) {
+        const uint64_t size = MIN(vmem->memslot_size,
+                                  region_size - i * vmem->memslot_size);
+        char name[80];
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
@@ -763,7 +870,7 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    virtio_mem_resize_usable_region(vmem, vmem->requested_size, true);
+    virtio_mem_prepare_mr(vmem);
 
     vmem->bitmap_size = memory_region_size(&vmem->memdev->mr) /
                         vmem->block_size;
@@ -780,9 +887,11 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
      */
     memory_region_set_ram_discard_manager(&vmem->memdev->mr,
                                           RAM_DISCARD_MANAGER(vmem));
+    virtio_mem_prepare_memslots(vmem);
 
-    host_memory_backend_set_mapped(vmem->memdev, true);
+    virtio_mem_resize_usable_region(vmem, vmem->requested_size, true);
     vmstate_register_ram(&vmem->memdev->mr, DEVICE(vmem));
+    host_memory_backend_set_mapped(vmem->memdev, true);
     qemu_register_reset(virtio_mem_system_reset, vmem);
 }
 
@@ -794,10 +903,14 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
     qemu_unregister_reset(virtio_mem_system_reset, vmem);
     vmstate_unregister_ram(&vmem->memdev->mr, DEVICE(vmem));
     host_memory_backend_set_mapped(vmem->memdev, false);
+    /* Unmap all memslots. */
+    virtio_mem_resize_usable_region(vmem, 0, true);
+    g_free(vmem->memslots);
     memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
     virtio_del_queue(vdev, 0);
     virtio_cleanup(vdev);
     g_free(vmem->bitmap);
+    g_free(vmem->mr);
     ram_block_coordinated_discard_require(false);
 }
 
@@ -955,7 +1068,8 @@ static MemoryRegion *virtio_mem_get_memory_region(VirtIOMEM *vmem, Error **errp)
         return NULL;
     }
 
-    return &vmem->memdev->mr;
+    virtio_mem_prepare_mr(vmem);
+    return vmem->mr;
 }
 
 static void virtio_mem_add_size_change_notifier(VirtIOMEM *vmem,
@@ -1084,6 +1198,53 @@ static void virtio_mem_set_block_size(Object *obj, Visitor *v, const char *name,
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
+    /* Determine the final value now, we don't want it to change later.  */
+    if (!vmem->nb_memslots) {
+        uint64_t block_size = vmem->block_size;
+        uint64_t region_size;
+        RAMBlock *rb;
+
+        if (!vmem->memdev || !memory_region_is_ram(&vmem->memdev->mr)) {
+            /* We'll fail realizing later ... */
+            vmem->nb_memslots = 1;
+            goto out;
+        }
+        region_size = memory_region_size(&vmem->memdev->mr);
+        rb = vmem->memdev->mr.ram_block;
+
+        if (!block_size) {
+            block_size = virtio_mem_default_block_size(rb);
+        } else if (block_size < qemu_ram_pagesize(rb)) {
+            /* We'll fail realizing later ... */
+            vmem->nb_memslots = 1;
+            goto out;
+        }
+
+        vmem->nb_memslots = virtio_mem_calc_nb_memslots(region_size,
+                                                        vmem->block_size,
+                                                        vmem->nb_max_memslots);
+    }
+out:
+    value = vmem->nb_memslots;
+    visit_type_uint16(v, name, &value, errp);
+}
+
 static void virtio_mem_instance_init(Object *obj)
 {
     VirtIOMEM *vmem = VIRTIO_MEM(obj);
@@ -1099,6 +1260,10 @@ static void virtio_mem_instance_init(Object *obj)
     object_property_add(obj, VIRTIO_MEM_BLOCK_SIZE_PROP, "size",
                         virtio_mem_get_block_size, virtio_mem_set_block_size,
                         NULL, NULL);
+    object_property_add(obj, VIRTIO_MEM_MEMSLOTS_PROP, "uint16",
+                        virtio_mem_get_memslots, NULL, NULL, NULL);
+    object_property_add(obj, VIRTIO_MEM_USED_MEMSLOTS_PROP, "uint16",
+                        virtio_mem_get_used_memslots, NULL, NULL, NULL);
 }
 
 static Property virtio_mem_properties[] = {
@@ -1106,6 +1271,8 @@ static Property virtio_mem_properties[] = {
     DEFINE_PROP_UINT32(VIRTIO_MEM_NODE_PROP, VirtIOMEM, node, 0),
     DEFINE_PROP_LINK(VIRTIO_MEM_MEMDEV_PROP, VirtIOMEM, memdev,
                      TYPE_MEMORY_BACKEND, HostMemoryBackend *),
+    DEFINE_PROP_UINT16(VIRTIO_MEM_MAX_MEMSLOTS_PROP, VirtIOMEM, nb_max_memslots,
+                       1),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/include/hw/virtio/virtio-mem.h b/include/hw/virtio/virtio-mem.h
index a5dd6a493b..3589865871 100644
--- a/include/hw/virtio/virtio-mem.h
+++ b/include/hw/virtio/virtio-mem.h
@@ -30,6 +30,9 @@ OBJECT_DECLARE_TYPE(VirtIOMEM, VirtIOMEMClass,
 #define VIRTIO_MEM_REQUESTED_SIZE_PROP "requested-size"
 #define VIRTIO_MEM_BLOCK_SIZE_PROP "block-size"
 #define VIRTIO_MEM_ADDR_PROP "memaddr"
+#define VIRTIO_MEM_MEMSLOTS_PROP "memslots"
+#define VIRTIO_MEM_USED_MEMSLOTS_PROP "used-memslots"
+#define VIRTIO_MEM_MAX_MEMSLOTS_PROP "max-memslots"
 
 struct VirtIOMEM {
     VirtIODevice parent_obj;
@@ -41,9 +44,33 @@ struct VirtIOMEM {
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
+    /* User defined maximum number of memslots we may ever use. */
+    uint16_t nb_max_memslots;
+
+    /* Total number of memslots we're going to use. */
+    uint16_t nb_memslots;
+
+    /* Current number of memslots we're using. */
+    uint16_t nb_used_memslots;
+
+    /* Size of one memslot (the last one might be smaller) */
+    uint64_t memslot_size;
+
     /* NUMA node */
     uint32_t node;
 
-- 
2.31.1

