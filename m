Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFEA20ACFD
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 09:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgFZHYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 03:24:17 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27400 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728665AbgFZHYR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Jun 2020 03:24:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593156254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m8RmQmmdnSxazze2gT6w1okcvobr8YJgVtHN7Suct1s=;
        b=KLOON0EK+3y28SHOw/XpkTUuqrwy7KyHygk5mJQD4uzWejVqHJeG06IRT6Y3K3NizoWzzA
        ElR7RHf8NHuOEybVVRVM7yrG0okx5vFKYhCAxi1neT6nftvr8GzGlrG2kZ8zw8vxEZCajc
        W6fEVD5HzCJJtm7QrQ/x2ZkCs7O2uzE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-AYC2miKVP3ey5BjtALLjrw-1; Fri, 26 Jun 2020 03:24:12 -0400
X-MC-Unique: AYC2miKVP3ey5BjtALLjrw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF18E464;
        Fri, 26 Jun 2020 07:24:10 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-35.ams2.redhat.com [10.36.113.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 765B41C8;
        Fri, 26 Jun 2020 07:24:08 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Subject: [PATCH v5 10/21] virtio-mem: Paravirtualized memory hot(un)plug
Date:   Fri, 26 Jun 2020 09:22:37 +0200
Message-Id: <20200626072248.78761-11-david@redhat.com>
In-Reply-To: <20200626072248.78761-1-david@redhat.com>
References: <20200626072248.78761-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the very basic/initial version of virtio-mem. An introduction to
virtio-mem can be found in the Linux kernel driver [1]. While it can be
used in the current state for hotplug of a smaller amount of memory, it
will heavily benefit from resizeable memory regions in the future.

Each virtio-mem device manages a memory region (provided via a memory
backend). After requested by the hypervisor ("requested-size"), the
guest can try to plug/unplug blocks of memory within that region, in order
to reach the requested size. Initially, and after a reboot, all memory is
unplugged (except in special cases - reboot during postcopy).

The guest may only try to plug/unplug blocks of memory within the usable
region size. The usable region size is a little bigger than the
requested size, to give the device driver some flexibility. The usable
region size will only grow, except on reboots or when all memory is
requested to get unplugged. The guest can never plug more memory than
requested. Unplugged memory will get zapped/discarded, similar to in a
balloon device.

The block size is variable, however, it is always chosen in a way such that
THP splits are avoided (e.g., 2MB). The state of each block
(plugged/unplugged) is tracked in a bitmap.

As virtio-mem devices (e.g., virtio-mem-pci) will be memory devices, we now
expose "VirtioMEMDeviceInfo" via "query-memory-devices".

--------------------------------------------------------------------------

There are two important follow-up items that are in the works:
1. Resizeable memory regions: Use resizeable allocations/RAM blocks to
   grow/shrink along with the usable region size. This avoids creating
   initially very big VMAs, RAM blocks, and KVM slots.
2. Protection of unplugged memory: Make sure the gust cannot actually
   make use of unplugged memory.

Other follow-up items that are in the works:
1. Exclude unplugged memory during migration (via precopy notifier).
2. Handle remapping of memory.
3. Support for other architectures.

--------------------------------------------------------------------------

Example usage (virtio-mem-pci is introduced in follow-up patches):

Start QEMU with two virtio-mem devices (one per NUMA node):
 $ qemu-system-x86_64 -m 4G,maxmem=20G \
  -smp sockets=2,cores=2 \
  -numa node,nodeid=0,cpus=0-1 -numa node,nodeid=1,cpus=2-3 \
  [...]
  -object memory-backend-ram,id=mem0,size=8G \
  -device virtio-mem-pci,id=vm0,memdev=mem0,node=0,requested-size=0M \
  -object memory-backend-ram,id=mem1,size=8G \
  -device virtio-mem-pci,id=vm1,memdev=mem1,node=1,requested-size=1G

Query the configuration:
 (qemu) info memory-devices
 Memory device [virtio-mem]: "vm0"
   memaddr: 0x140000000
   node: 0
   requested-size: 0
   size: 0
   max-size: 8589934592
   block-size: 2097152
   memdev: /objects/mem0
 Memory device [virtio-mem]: "vm1"
   memaddr: 0x340000000
   node: 1
   requested-size: 1073741824
   size: 1073741824
   max-size: 8589934592
   block-size: 2097152
   memdev: /objects/mem1

Add some memory to node 0:
 (qemu) qom-set vm0 requested-size 500M

Remove some memory from node 1:
 (qemu) qom-set vm1 requested-size 200M

Query the configuration again:
 (qemu) info memory-devices
 Memory device [virtio-mem]: "vm0"
   memaddr: 0x140000000
   node: 0
   requested-size: 524288000
   size: 524288000
   max-size: 8589934592
   block-size: 2097152
   memdev: /objects/mem0
 Memory device [virtio-mem]: "vm1"
   memaddr: 0x340000000
   node: 1
   requested-size: 209715200
   size: 209715200
   max-size: 8589934592
   block-size: 2097152
   memdev: /objects/mem1

[1] https://lkml.kernel.org/r/20200311171422.10484-1-david@redhat.com

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Eric Blake <eblake@redhat.com>
Cc: Markus Armbruster <armbru@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/Kconfig              |  11 +
 hw/virtio/Makefile.objs        |   1 +
 hw/virtio/virtio-mem.c         | 724 +++++++++++++++++++++++++++++++++
 include/hw/virtio/virtio-mem.h |  78 ++++
 qapi/misc.json                 |  39 +-
 5 files changed, 852 insertions(+), 1 deletion(-)
 create mode 100644 hw/virtio/virtio-mem.c
 create mode 100644 include/hw/virtio/virtio-mem.h

diff --git a/hw/virtio/Kconfig b/hw/virtio/Kconfig
index 83122424fa..0eda25c4e1 100644
--- a/hw/virtio/Kconfig
+++ b/hw/virtio/Kconfig
@@ -47,3 +47,14 @@ config VIRTIO_PMEM
     depends on VIRTIO
     depends on VIRTIO_PMEM_SUPPORTED
     select MEM_DEVICE
+
+config VIRTIO_MEM_SUPPORTED
+    bool
+
+config VIRTIO_MEM
+    bool
+    default y
+    depends on VIRTIO
+    depends on LINUX
+    depends on VIRTIO_MEM_SUPPORTED
+    select MEM_DEVICE
diff --git a/hw/virtio/Makefile.objs b/hw/virtio/Makefile.objs
index 13e75f171f..f3a65e01b7 100644
--- a/hw/virtio/Makefile.objs
+++ b/hw/virtio/Makefile.objs
@@ -19,6 +19,7 @@ obj-$(call land,$(CONFIG_VHOST_USER_FS),$(CONFIG_VIRTIO_PCI)) += vhost-user-fs-p
 obj-$(CONFIG_VIRTIO_IOMMU) += virtio-iommu.o
 obj-$(CONFIG_VHOST_VSOCK) += vhost-vsock-common.o vhost-vsock.o
 obj-$(CONFIG_VHOST_USER_VSOCK) += vhost-vsock-common.o vhost-user-vsock.o
+obj-$(CONFIG_VIRTIO_MEM) += virtio-mem.o
 
 ifeq ($(CONFIG_VIRTIO_PCI),y)
 obj-$(CONFIG_VHOST_VSOCK) += vhost-vsock-pci.o
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
new file mode 100644
index 0000000000..d8a0c974d3
--- /dev/null
+++ b/hw/virtio/virtio-mem.c
@@ -0,0 +1,724 @@
+/*
+ * Virtio MEM device
+ *
+ * Copyright (C) 2020 Red Hat, Inc.
+ *
+ * Authors:
+ *  David Hildenbrand <david@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ * See the COPYING file in the top-level directory.
+ */
+
+#include "qemu/osdep.h"
+#include "qemu-common.h"
+#include "qemu/iov.h"
+#include "qemu/cutils.h"
+#include "qemu/error-report.h"
+#include "qemu/units.h"
+#include "sysemu/numa.h"
+#include "sysemu/sysemu.h"
+#include "sysemu/reset.h"
+#include "hw/virtio/virtio.h"
+#include "hw/virtio/virtio-bus.h"
+#include "hw/virtio/virtio-access.h"
+#include "hw/virtio/virtio-mem.h"
+#include "qapi/error.h"
+#include "qapi/visitor.h"
+#include "exec/ram_addr.h"
+#include "migration/misc.h"
+#include "hw/boards.h"
+#include "hw/qdev-properties.h"
+#include "config-devices.h"
+
+/*
+ * Use QEMU_VMALLOC_ALIGN, so no THP will have to be split when unplugging
+ * memory (e.g., 2MB on x86_64).
+ */
+#define VIRTIO_MEM_MIN_BLOCK_SIZE QEMU_VMALLOC_ALIGN
+/*
+ * Size the usable region bigger than the requested size if possible. Esp.
+ * Linux guests will only add (aligned) memory blocks in case they fully
+ * fit into the usable region, but plug+online only a subset of the pages.
+ * The memory block size corresponds mostly to the section size.
+ *
+ * This allows e.g., to add 20MB with a section size of 128MB on x86_64, and
+ * a section size of 1GB on arm64 (as long as the start address is properly
+ * aligned, similar to ordinary DIMMs).
+ *
+ * We can change this at any time and maybe even make it configurable if
+ * necessary (as the section size can change). But it's more likely that the
+ * section size will rather get smaller and not bigger over time.
+ */
+#if defined(__x86_64__)
+#define VIRTIO_MEM_USABLE_EXTENT (2 * (128 * MiB))
+#else
+#error VIRTIO_MEM_USABLE_EXTENT not defined
+#endif
+
+static bool virtio_mem_is_busy(void)
+{
+    /*
+     * Postcopy cannot handle concurrent discards and we don't want to migrate
+     * pages on-demand with stale content when plugging new blocks.
+     */
+    return migration_in_incoming_postcopy();
+}
+
+static bool virtio_mem_test_bitmap(VirtIOMEM *vmem, uint64_t start_gpa,
+                                   uint64_t size, bool plugged)
+{
+    const unsigned long first_bit = (start_gpa - vmem->addr) / vmem->block_size;
+    const unsigned long last_bit = first_bit + (size / vmem->block_size) - 1;
+    unsigned long found_bit;
+
+    /* We fake a shorter bitmap to avoid searching too far. */
+    if (plugged) {
+        found_bit = find_next_zero_bit(vmem->bitmap, last_bit + 1, first_bit);
+    } else {
+        found_bit = find_next_bit(vmem->bitmap, last_bit + 1, first_bit);
+    }
+    return found_bit > last_bit;
+}
+
+static void virtio_mem_set_bitmap(VirtIOMEM *vmem, uint64_t start_gpa,
+                                  uint64_t size, bool plugged)
+{
+    const unsigned long bit = (start_gpa - vmem->addr) / vmem->block_size;
+    const unsigned long nbits = size / vmem->block_size;
+
+    if (plugged) {
+        bitmap_set(vmem->bitmap, bit, nbits);
+    } else {
+        bitmap_clear(vmem->bitmap, bit, nbits);
+    }
+}
+
+static void virtio_mem_send_response(VirtIOMEM *vmem, VirtQueueElement *elem,
+                                     struct virtio_mem_resp *resp)
+{
+    VirtIODevice *vdev = VIRTIO_DEVICE(vmem);
+    VirtQueue *vq = vmem->vq;
+
+    iov_from_buf(elem->in_sg, elem->in_num, 0, resp, sizeof(*resp));
+
+    virtqueue_push(vq, elem, sizeof(*resp));
+    virtio_notify(vdev, vq);
+}
+
+static void virtio_mem_send_response_simple(VirtIOMEM *vmem,
+                                            VirtQueueElement *elem,
+                                            uint16_t type)
+{
+    struct virtio_mem_resp resp = {
+        .type = cpu_to_le16(type),
+    };
+
+    virtio_mem_send_response(vmem, elem, &resp);
+}
+
+static bool virtio_mem_valid_range(VirtIOMEM *vmem, uint64_t gpa, uint64_t size)
+{
+    if (!QEMU_IS_ALIGNED(gpa, vmem->block_size)) {
+        return false;
+    }
+    if (gpa + size < gpa || !size) {
+        return false;
+    }
+    if (gpa < vmem->addr || gpa >= vmem->addr + vmem->usable_region_size) {
+        return false;
+    }
+    if (gpa + size > vmem->addr + vmem->usable_region_size) {
+        return false;
+    }
+    return true;
+}
+
+static int virtio_mem_set_block_state(VirtIOMEM *vmem, uint64_t start_gpa,
+                                      uint64_t size, bool plug)
+{
+    const uint64_t offset = start_gpa - vmem->addr;
+    int ret;
+
+    if (virtio_mem_is_busy()) {
+        return -EBUSY;
+    }
+
+    if (!plug) {
+        ret = ram_block_discard_range(vmem->memdev->mr.ram_block, offset, size);
+        if (ret) {
+            error_report("Unexpected error discarding RAM: %s",
+                         strerror(-ret));
+            return -EBUSY;
+        }
+    }
+    virtio_mem_set_bitmap(vmem, start_gpa, size, plug);
+    return 0;
+}
+
+static int virtio_mem_state_change_request(VirtIOMEM *vmem, uint64_t gpa,
+                                           uint16_t nb_blocks, bool plug)
+{
+    const uint64_t size = nb_blocks * vmem->block_size;
+    int ret;
+
+    if (!virtio_mem_valid_range(vmem, gpa, size)) {
+        return VIRTIO_MEM_RESP_ERROR;
+    }
+
+    if (plug && (vmem->size + size > vmem->requested_size)) {
+        return VIRTIO_MEM_RESP_NACK;
+    }
+
+    /* test if really all blocks are in the opposite state */
+    if (!virtio_mem_test_bitmap(vmem, gpa, size, !plug)) {
+        return VIRTIO_MEM_RESP_ERROR;
+    }
+
+    ret = virtio_mem_set_block_state(vmem, gpa, size, plug);
+    if (ret) {
+        return VIRTIO_MEM_RESP_BUSY;
+    }
+    if (plug) {
+        vmem->size += size;
+    } else {
+        vmem->size -= size;
+    }
+    return VIRTIO_MEM_RESP_ACK;
+}
+
+static void virtio_mem_plug_request(VirtIOMEM *vmem, VirtQueueElement *elem,
+                                    struct virtio_mem_req *req)
+{
+    const uint64_t gpa = le64_to_cpu(req->u.plug.addr);
+    const uint16_t nb_blocks = le16_to_cpu(req->u.plug.nb_blocks);
+    uint16_t type;
+
+    type = virtio_mem_state_change_request(vmem, gpa, nb_blocks, true);
+    virtio_mem_send_response_simple(vmem, elem, type);
+}
+
+static void virtio_mem_unplug_request(VirtIOMEM *vmem, VirtQueueElement *elem,
+                                      struct virtio_mem_req *req)
+{
+    const uint64_t gpa = le64_to_cpu(req->u.unplug.addr);
+    const uint16_t nb_blocks = le16_to_cpu(req->u.unplug.nb_blocks);
+    uint16_t type;
+
+    type = virtio_mem_state_change_request(vmem, gpa, nb_blocks, false);
+    virtio_mem_send_response_simple(vmem, elem, type);
+}
+
+static void virtio_mem_resize_usable_region(VirtIOMEM *vmem,
+                                            uint64_t requested_size,
+                                            bool can_shrink)
+{
+    uint64_t newsize = MIN(memory_region_size(&vmem->memdev->mr),
+                           requested_size + VIRTIO_MEM_USABLE_EXTENT);
+
+    if (!requested_size) {
+        newsize = 0;
+    }
+
+    if (newsize < vmem->usable_region_size && !can_shrink) {
+        return;
+    }
+
+    vmem->usable_region_size = newsize;
+}
+
+static int virtio_mem_unplug_all(VirtIOMEM *vmem)
+{
+    RAMBlock *rb = vmem->memdev->mr.ram_block;
+    int ret;
+
+    if (virtio_mem_is_busy()) {
+        return -EBUSY;
+    }
+
+    ret = ram_block_discard_range(rb, 0, qemu_ram_get_used_length(rb));
+    if (ret) {
+        error_report("Unexpected error discarding RAM: %s", strerror(-ret));
+        return -EBUSY;
+    }
+    bitmap_clear(vmem->bitmap, 0, vmem->bitmap_size);
+    vmem->size = 0;
+
+    virtio_mem_resize_usable_region(vmem, vmem->requested_size, true);
+    return 0;
+}
+
+static void virtio_mem_unplug_all_request(VirtIOMEM *vmem,
+                                          VirtQueueElement *elem)
+{
+    if (virtio_mem_unplug_all(vmem)) {
+        virtio_mem_send_response_simple(vmem, elem, VIRTIO_MEM_RESP_BUSY);
+    } else {
+        virtio_mem_send_response_simple(vmem, elem, VIRTIO_MEM_RESP_ACK);
+    }
+}
+
+static void virtio_mem_state_request(VirtIOMEM *vmem, VirtQueueElement *elem,
+                                     struct virtio_mem_req *req)
+{
+    const uint16_t nb_blocks = le16_to_cpu(req->u.state.nb_blocks);
+    const uint64_t gpa = le64_to_cpu(req->u.state.addr);
+    const uint64_t size = nb_blocks * vmem->block_size;
+    struct virtio_mem_resp resp = {
+        .type = cpu_to_le16(VIRTIO_MEM_RESP_ACK),
+    };
+
+    if (!virtio_mem_valid_range(vmem, gpa, size)) {
+        virtio_mem_send_response_simple(vmem, elem, VIRTIO_MEM_RESP_ERROR);
+        return;
+    }
+
+    if (virtio_mem_test_bitmap(vmem, gpa, size, true)) {
+        resp.u.state.state = cpu_to_le16(VIRTIO_MEM_STATE_PLUGGED);
+    } else if (virtio_mem_test_bitmap(vmem, gpa, size, false)) {
+        resp.u.state.state = cpu_to_le16(VIRTIO_MEM_STATE_UNPLUGGED);
+    } else {
+        resp.u.state.state = cpu_to_le16(VIRTIO_MEM_STATE_MIXED);
+    }
+    virtio_mem_send_response(vmem, elem, &resp);
+}
+
+static void virtio_mem_handle_request(VirtIODevice *vdev, VirtQueue *vq)
+{
+    const int len = sizeof(struct virtio_mem_req);
+    VirtIOMEM *vmem = VIRTIO_MEM(vdev);
+    VirtQueueElement *elem;
+    struct virtio_mem_req req;
+    uint16_t type;
+
+    while (true) {
+        elem = virtqueue_pop(vq, sizeof(VirtQueueElement));
+        if (!elem) {
+            return;
+        }
+
+        if (iov_to_buf(elem->out_sg, elem->out_num, 0, &req, len) < len) {
+            virtio_error(vdev, "virtio-mem protocol violation: invalid request"
+                         " size: %d", len);
+            g_free(elem);
+            return;
+        }
+
+        if (iov_size(elem->in_sg, elem->in_num) <
+            sizeof(struct virtio_mem_resp)) {
+            virtio_error(vdev, "virtio-mem protocol violation: not enough space"
+                         " for response: %zu",
+                         iov_size(elem->in_sg, elem->in_num));
+            g_free(elem);
+            return;
+        }
+
+        type = le16_to_cpu(req.type);
+        switch (type) {
+        case VIRTIO_MEM_REQ_PLUG:
+            virtio_mem_plug_request(vmem, elem, &req);
+            break;
+        case VIRTIO_MEM_REQ_UNPLUG:
+            virtio_mem_unplug_request(vmem, elem, &req);
+            break;
+        case VIRTIO_MEM_REQ_UNPLUG_ALL:
+            virtio_mem_unplug_all_request(vmem, elem);
+            break;
+        case VIRTIO_MEM_REQ_STATE:
+            virtio_mem_state_request(vmem, elem, &req);
+            break;
+        default:
+            virtio_error(vdev, "virtio-mem protocol violation: unknown request"
+                         " type: %d", type);
+            g_free(elem);
+            return;
+        }
+
+        g_free(elem);
+    }
+}
+
+static void virtio_mem_get_config(VirtIODevice *vdev, uint8_t *config_data)
+{
+    VirtIOMEM *vmem = VIRTIO_MEM(vdev);
+    struct virtio_mem_config *config = (void *) config_data;
+
+    config->block_size = cpu_to_le64(vmem->block_size);
+    config->node_id = cpu_to_le16(vmem->node);
+    config->requested_size = cpu_to_le64(vmem->requested_size);
+    config->plugged_size = cpu_to_le64(vmem->size);
+    config->addr = cpu_to_le64(vmem->addr);
+    config->region_size = cpu_to_le64(memory_region_size(&vmem->memdev->mr));
+    config->usable_region_size = cpu_to_le64(vmem->usable_region_size);
+}
+
+static uint64_t virtio_mem_get_features(VirtIODevice *vdev, uint64_t features,
+                                        Error **errp)
+{
+    MachineState *ms = MACHINE(qdev_get_machine());
+
+    if (ms->numa_state) {
+#if defined(CONFIG_ACPI)
+        virtio_add_feature(&features, VIRTIO_MEM_F_ACPI_PXM);
+#endif
+    }
+    return features;
+}
+
+static void virtio_mem_system_reset(void *opaque)
+{
+    VirtIOMEM *vmem = VIRTIO_MEM(opaque);
+
+    /*
+     * During usual resets, we will unplug all memory and shrink the usable
+     * region size. This is, however, not possible in all scenarios. Then,
+     * the guest has to deal with this manually (VIRTIO_MEM_REQ_UNPLUG_ALL).
+     */
+    virtio_mem_unplug_all(vmem);
+}
+
+static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
+{
+    MachineState *ms = MACHINE(qdev_get_machine());
+    int nb_numa_nodes = ms->numa_state ? ms->numa_state->num_nodes : 0;
+    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
+    VirtIOMEM *vmem = VIRTIO_MEM(dev);
+    uint64_t page_size;
+    RAMBlock *rb;
+    int ret;
+
+    if (!vmem->memdev) {
+        error_setg(errp, "'%s' property is not set", VIRTIO_MEM_MEMDEV_PROP);
+        return;
+    } else if (host_memory_backend_is_mapped(vmem->memdev)) {
+        char *path = object_get_canonical_path_component(OBJECT(vmem->memdev));
+
+        error_setg(errp, "'%s' property specifies a busy memdev: %s",
+                   VIRTIO_MEM_MEMDEV_PROP, path);
+        g_free(path);
+        return;
+    } else if (!memory_region_is_ram(&vmem->memdev->mr) ||
+        memory_region_is_rom(&vmem->memdev->mr) ||
+        !vmem->memdev->mr.ram_block) {
+        error_setg(errp, "'%s' property specifies an unsupported memdev",
+                   VIRTIO_MEM_MEMDEV_PROP);
+        return;
+    }
+
+    if ((nb_numa_nodes && vmem->node >= nb_numa_nodes) ||
+        (!nb_numa_nodes && vmem->node)) {
+        error_setg(errp, "'%s' property has value '%" PRIu32 "', which exceeds"
+                   "the number of numa nodes: %d", VIRTIO_MEM_NODE_PROP,
+                   vmem->node, nb_numa_nodes ? nb_numa_nodes : 1);
+        return;
+    }
+
+    if (enable_mlock) {
+        error_setg(errp, "Incompatible with mlock");
+        return;
+    }
+
+    rb = vmem->memdev->mr.ram_block;
+    page_size = qemu_ram_pagesize(rb);
+
+    if (vmem->block_size < page_size) {
+        error_setg(errp, "'%s' property has to be at least the page size (0x%"
+                   PRIx64 ")", VIRTIO_MEM_BLOCK_SIZE_PROP, page_size);
+        return;
+    } else if (!QEMU_IS_ALIGNED(vmem->requested_size, vmem->block_size)) {
+        error_setg(errp, "'%s' property has to be multiples of '%s' (0x%" PRIx64
+                   ")", VIRTIO_MEM_REQUESTED_SIZE_PROP,
+                   VIRTIO_MEM_BLOCK_SIZE_PROP, vmem->block_size);
+        return;
+    } else if (!QEMU_IS_ALIGNED(memory_region_size(&vmem->memdev->mr),
+                                vmem->block_size)) {
+        error_setg(errp, "'%s' property memdev size has to be multiples of"
+                   "'%s' (0x%" PRIx64 ")", VIRTIO_MEM_MEMDEV_PROP,
+                   VIRTIO_MEM_BLOCK_SIZE_PROP, vmem->block_size);
+        return;
+    }
+
+    if (ram_block_discard_require(true)) {
+        error_setg(errp, "Discarding RAM is disabled");
+        return;
+    }
+
+    ret = ram_block_discard_range(rb, 0, qemu_ram_get_used_length(rb));
+    if (ret) {
+        error_setg_errno(errp, -ret, "Unexpected error discarding RAM");
+        ram_block_discard_require(false);
+        return;
+    }
+
+    virtio_mem_resize_usable_region(vmem, vmem->requested_size, true);
+
+    vmem->bitmap_size = memory_region_size(&vmem->memdev->mr) /
+                        vmem->block_size;
+    vmem->bitmap = bitmap_new(vmem->bitmap_size);
+
+    virtio_init(vdev, TYPE_VIRTIO_MEM, VIRTIO_ID_MEM,
+                sizeof(struct virtio_mem_config));
+    vmem->vq = virtio_add_queue(vdev, 128, virtio_mem_handle_request);
+
+    host_memory_backend_set_mapped(vmem->memdev, true);
+    vmstate_register_ram(&vmem->memdev->mr, DEVICE(vmem));
+    qemu_register_reset(virtio_mem_system_reset, vmem);
+}
+
+static void virtio_mem_device_unrealize(DeviceState *dev)
+{
+    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
+    VirtIOMEM *vmem = VIRTIO_MEM(dev);
+
+    qemu_unregister_reset(virtio_mem_system_reset, vmem);
+    vmstate_unregister_ram(&vmem->memdev->mr, DEVICE(vmem));
+    host_memory_backend_set_mapped(vmem->memdev, false);
+    virtio_del_queue(vdev, 0);
+    virtio_cleanup(vdev);
+    g_free(vmem->bitmap);
+    ram_block_discard_require(false);
+}
+
+static int virtio_mem_restore_unplugged(VirtIOMEM *vmem)
+{
+    RAMBlock *rb = vmem->memdev->mr.ram_block;
+    unsigned long first_zero_bit, last_zero_bit;
+    uint64_t offset, length;
+    int ret;
+
+    /* Find consecutive unplugged blocks and discard the consecutive range. */
+    first_zero_bit = find_first_zero_bit(vmem->bitmap, vmem->bitmap_size);
+    while (first_zero_bit < vmem->bitmap_size) {
+        offset = first_zero_bit * vmem->block_size;
+        last_zero_bit = find_next_bit(vmem->bitmap, vmem->bitmap_size,
+                                      first_zero_bit + 1) - 1;
+        length = (last_zero_bit - first_zero_bit + 1) * vmem->block_size;
+
+        ret = ram_block_discard_range(rb, offset, length);
+        if (ret) {
+            error_report("Unexpected error discarding RAM: %s",
+                         strerror(-ret));
+            return -EINVAL;
+        }
+        first_zero_bit = find_next_zero_bit(vmem->bitmap, vmem->bitmap_size,
+                                            last_zero_bit + 2);
+    }
+    return 0;
+}
+
+static int virtio_mem_post_load(void *opaque, int version_id)
+{
+    if (migration_in_incoming_postcopy()) {
+        return 0;
+    }
+
+    return virtio_mem_restore_unplugged(VIRTIO_MEM(opaque));
+}
+
+static const VMStateDescription vmstate_virtio_mem_device = {
+    .name = "virtio-mem-device",
+    .minimum_version_id = 1,
+    .version_id = 1,
+    .post_load = virtio_mem_post_load,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(usable_region_size, VirtIOMEM),
+        VMSTATE_UINT64(size, VirtIOMEM),
+        VMSTATE_UINT64(requested_size, VirtIOMEM),
+        VMSTATE_BITMAP(bitmap, VirtIOMEM, 0, bitmap_size),
+        VMSTATE_END_OF_LIST()
+    },
+};
+
+static const VMStateDescription vmstate_virtio_mem = {
+    .name = "virtio-mem",
+    .minimum_version_id = 1,
+    .version_id = 1,
+    .fields = (VMStateField[]) {
+        VMSTATE_VIRTIO_DEVICE,
+        VMSTATE_END_OF_LIST()
+    },
+};
+
+static void virtio_mem_fill_device_info(const VirtIOMEM *vmem,
+                                        VirtioMEMDeviceInfo *vi)
+{
+    vi->memaddr = vmem->addr;
+    vi->node = vmem->node;
+    vi->requested_size = vmem->requested_size;
+    vi->size = vmem->size;
+    vi->max_size = memory_region_size(&vmem->memdev->mr);
+    vi->block_size = vmem->block_size;
+    vi->memdev = object_get_canonical_path(OBJECT(vmem->memdev));
+}
+
+static MemoryRegion *virtio_mem_get_memory_region(VirtIOMEM *vmem, Error **errp)
+{
+    if (!vmem->memdev) {
+        error_setg(errp, "'%s' property must be set", VIRTIO_MEM_MEMDEV_PROP);
+        return NULL;
+    }
+
+    return &vmem->memdev->mr;
+}
+
+static void virtio_mem_get_size(Object *obj, Visitor *v, const char *name,
+                                void *opaque, Error **errp)
+{
+    const VirtIOMEM *vmem = VIRTIO_MEM(obj);
+    uint64_t value = vmem->size;
+
+    visit_type_size(v, name, &value, errp);
+}
+
+static void virtio_mem_get_requested_size(Object *obj, Visitor *v,
+                                          const char *name, void *opaque,
+                                          Error **errp)
+{
+    const VirtIOMEM *vmem = VIRTIO_MEM(obj);
+    uint64_t value = vmem->requested_size;
+
+    visit_type_size(v, name, &value, errp);
+}
+
+static void virtio_mem_set_requested_size(Object *obj, Visitor *v,
+                                          const char *name, void *opaque,
+                                          Error **errp)
+{
+    VirtIOMEM *vmem = VIRTIO_MEM(obj);
+    Error *err = NULL;
+    uint64_t value;
+
+    visit_type_size(v, name, &value, &err);
+    if (err) {
+        error_propagate(errp, err);
+        return;
+    }
+
+    /*
+     * The block size and memory backend are not fixed until the device was
+     * realized. realize() will verify these properties then.
+     */
+    if (DEVICE(obj)->realized) {
+        if (!QEMU_IS_ALIGNED(value, vmem->block_size)) {
+            error_setg(errp, "'%s' has to be multiples of '%s' (0x%" PRIx64
+                       ")", name, VIRTIO_MEM_BLOCK_SIZE_PROP,
+                       vmem->block_size);
+            return;
+        } else if (value > memory_region_size(&vmem->memdev->mr)) {
+            error_setg(errp, "'%s' cannot exceed the memory backend size"
+                       "(0x%" PRIx64 ")", name,
+                       memory_region_size(&vmem->memdev->mr));
+            return;
+        }
+
+        if (value != vmem->requested_size) {
+            virtio_mem_resize_usable_region(vmem, value, false);
+            vmem->requested_size = value;
+        }
+        /*
+         * Trigger a config update so the guest gets notified. We trigger
+         * even if the size didn't change (especially helpful for debugging).
+         */
+        virtio_notify_config(VIRTIO_DEVICE(vmem));
+    } else {
+        vmem->requested_size = value;
+    }
+}
+
+static void virtio_mem_get_block_size(Object *obj, Visitor *v, const char *name,
+                                      void *opaque, Error **errp)
+{
+    const VirtIOMEM *vmem = VIRTIO_MEM(obj);
+    uint64_t value = vmem->block_size;
+
+    visit_type_size(v, name, &value, errp);
+}
+
+static void virtio_mem_set_block_size(Object *obj, Visitor *v, const char *name,
+                                      void *opaque, Error **errp)
+{
+    VirtIOMEM *vmem = VIRTIO_MEM(obj);
+    Error *err = NULL;
+    uint64_t value;
+
+    if (DEVICE(obj)->realized) {
+        error_setg(errp, "'%s' cannot be changed", name);
+        return;
+    }
+
+    visit_type_size(v, name, &value, &err);
+    if (err) {
+        error_propagate(errp, err);
+        return;
+    }
+
+    if (value < VIRTIO_MEM_MIN_BLOCK_SIZE) {
+        error_setg(errp, "'%s' property has to be at least 0x%" PRIx32, name,
+                   VIRTIO_MEM_MIN_BLOCK_SIZE);
+        return;
+    } else if (!is_power_of_2(value)) {
+        error_setg(errp, "'%s' property has to be a power of two", name);
+        return;
+    }
+    vmem->block_size = value;
+}
+
+static void virtio_mem_instance_init(Object *obj)
+{
+    VirtIOMEM *vmem = VIRTIO_MEM(obj);
+
+    vmem->block_size = VIRTIO_MEM_MIN_BLOCK_SIZE;
+
+    object_property_add(obj, VIRTIO_MEM_SIZE_PROP, "size", virtio_mem_get_size,
+                        NULL, NULL, NULL);
+    object_property_add(obj, VIRTIO_MEM_REQUESTED_SIZE_PROP, "size",
+                        virtio_mem_get_requested_size,
+                        virtio_mem_set_requested_size, NULL, NULL);
+    object_property_add(obj, VIRTIO_MEM_BLOCK_SIZE_PROP, "size",
+                        virtio_mem_get_block_size, virtio_mem_set_block_size,
+                        NULL, NULL);
+}
+
+static Property virtio_mem_properties[] = {
+    DEFINE_PROP_UINT64(VIRTIO_MEM_ADDR_PROP, VirtIOMEM, addr, 0),
+    DEFINE_PROP_UINT32(VIRTIO_MEM_NODE_PROP, VirtIOMEM, node, 0),
+    DEFINE_PROP_LINK(VIRTIO_MEM_MEMDEV_PROP, VirtIOMEM, memdev,
+                     TYPE_MEMORY_BACKEND, HostMemoryBackend *),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static void virtio_mem_class_init(ObjectClass *klass, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(klass);
+    VirtioDeviceClass *vdc = VIRTIO_DEVICE_CLASS(klass);
+    VirtIOMEMClass *vmc = VIRTIO_MEM_CLASS(klass);
+
+    device_class_set_props(dc, virtio_mem_properties);
+    dc->vmsd = &vmstate_virtio_mem;
+
+    set_bit(DEVICE_CATEGORY_MISC, dc->categories);
+    vdc->realize = virtio_mem_device_realize;
+    vdc->unrealize = virtio_mem_device_unrealize;
+    vdc->get_config = virtio_mem_get_config;
+    vdc->get_features = virtio_mem_get_features;
+    vdc->vmsd = &vmstate_virtio_mem_device;
+
+    vmc->fill_device_info = virtio_mem_fill_device_info;
+    vmc->get_memory_region = virtio_mem_get_memory_region;
+}
+
+static const TypeInfo virtio_mem_info = {
+    .name = TYPE_VIRTIO_MEM,
+    .parent = TYPE_VIRTIO_DEVICE,
+    .instance_size = sizeof(VirtIOMEM),
+    .instance_init = virtio_mem_instance_init,
+    .class_init = virtio_mem_class_init,
+    .class_size = sizeof(VirtIOMEMClass),
+};
+
+static void virtio_register_types(void)
+{
+    type_register_static(&virtio_mem_info);
+}
+
+type_init(virtio_register_types)
diff --git a/include/hw/virtio/virtio-mem.h b/include/hw/virtio/virtio-mem.h
new file mode 100644
index 0000000000..6981096f7c
--- /dev/null
+++ b/include/hw/virtio/virtio-mem.h
@@ -0,0 +1,78 @@
+/*
+ * Virtio MEM device
+ *
+ * Copyright (C) 2020 Red Hat, Inc.
+ *
+ * Authors:
+ *  David Hildenbrand <david@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ * See the COPYING file in the top-level directory.
+ */
+
+#ifndef HW_VIRTIO_MEM_H
+#define HW_VIRTIO_MEM_H
+
+#include "standard-headers/linux/virtio_mem.h"
+#include "hw/virtio/virtio.h"
+#include "qapi/qapi-types-misc.h"
+#include "sysemu/hostmem.h"
+
+#define TYPE_VIRTIO_MEM "virtio-mem"
+
+#define VIRTIO_MEM(obj) \
+        OBJECT_CHECK(VirtIOMEM, (obj), TYPE_VIRTIO_MEM)
+#define VIRTIO_MEM_CLASS(oc) \
+        OBJECT_CLASS_CHECK(VirtIOMEMClass, (oc), TYPE_VIRTIO_MEM)
+#define VIRTIO_MEM_GET_CLASS(obj) \
+        OBJECT_GET_CLASS(VirtIOMEMClass, (obj), TYPE_VIRTIO_MEM)
+
+#define VIRTIO_MEM_MEMDEV_PROP "memdev"
+#define VIRTIO_MEM_NODE_PROP "node"
+#define VIRTIO_MEM_SIZE_PROP "size"
+#define VIRTIO_MEM_REQUESTED_SIZE_PROP "requested-size"
+#define VIRTIO_MEM_BLOCK_SIZE_PROP "block-size"
+#define VIRTIO_MEM_ADDR_PROP "memaddr"
+
+typedef struct VirtIOMEM {
+    VirtIODevice parent_obj;
+
+    /* guest -> host request queue */
+    VirtQueue *vq;
+
+    /* bitmap used to track unplugged memory */
+    int32_t bitmap_size;
+    unsigned long *bitmap;
+
+    /* assigned memory backend and memory region */
+    HostMemoryBackend *memdev;
+
+    /* NUMA node */
+    uint32_t node;
+
+    /* assigned address of the region in guest physical memory */
+    uint64_t addr;
+
+    /* usable region size (<= region_size) */
+    uint64_t usable_region_size;
+
+    /* actual size (how much the guest plugged) */
+    uint64_t size;
+
+    /* requested size */
+    uint64_t requested_size;
+
+    /* block size and alignment */
+    uint64_t block_size;
+} VirtIOMEM;
+
+typedef struct VirtIOMEMClass {
+    /* private */
+    VirtIODevice parent;
+
+    /* public */
+    void (*fill_device_info)(const VirtIOMEM *vmen, VirtioMEMDeviceInfo *vi);
+    MemoryRegion *(*get_memory_region)(VirtIOMEM *vmem, Error **errp);
+} VirtIOMEMClass;
+
+#endif
diff --git a/qapi/misc.json b/qapi/misc.json
index a5a0beb902..65ca3edf32 100644
--- a/qapi/misc.json
+++ b/qapi/misc.json
@@ -1356,19 +1356,56 @@
           }
 }
 
+##
+# @VirtioMEMDeviceInfo:
+#
+# VirtioMEMDevice state information
+#
+# @id: device's ID
+#
+# @memaddr: physical address in memory, where device is mapped
+#
+# @requested-size: the user requested size of the device
+#
+# @size: the (current) size of memory that the device provides
+#
+# @max-size: the maximum size of memory that the device can provide
+#
+# @block-size: the block size of memory that the device provides
+#
+# @node: NUMA node number where device is assigned to
+#
+# @memdev: memory backend linked with the region
+#
+# Since: 5.1
+##
+{ 'struct': 'VirtioMEMDeviceInfo',
+  'data': { '*id': 'str',
+            'memaddr': 'size',
+            'requested-size': 'size',
+            'size': 'size',
+            'max-size': 'size',
+            'block-size': 'size',
+            'node': 'int',
+            'memdev': 'str'
+          }
+}
+
 ##
 # @MemoryDeviceInfo:
 #
 # Union containing information about a memory device
 #
 # nvdimm is included since 2.12. virtio-pmem is included since 4.1.
+# virtio-mem is included since 5.1.
 #
 # Since: 2.1
 ##
 { 'union': 'MemoryDeviceInfo',
   'data': { 'dimm': 'PCDIMMDeviceInfo',
             'nvdimm': 'PCDIMMDeviceInfo',
-            'virtio-pmem': 'VirtioPMEMDeviceInfo'
+            'virtio-pmem': 'VirtioPMEMDeviceInfo',
+            'virtio-mem': 'VirtioMEMDeviceInfo'
           }
 }
 
-- 
2.26.2

