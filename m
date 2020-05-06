Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492D21C6D97
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 11:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbgEFJux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 05:50:53 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31807 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729236AbgEFJuw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 05:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588758648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Neb3XNqN8GnA6E+Qn0tinD/A0QhWu5ZHKEpLUQAT+yU=;
        b=aCl6/6fjpLVwmpa3ExZaiu38o+J24dSS0yuvtkzAUMt1HAZYmD+ckDhrrO+xGLCZM01qlA
        UwyUcKJ5Ch0Il1qMW+pNTrlCuKXSQdmOcjD54+PVMoW5BTNQuoMsm7IoP9ybTAShaKMKlE
        7L4N0pI6qOiL/p4FU/UBm2UeiqTdtJ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-v2VmSf4BNYeGMrlSAQM-dA-1; Wed, 06 May 2020 05:50:44 -0400
X-MC-Unique: v2VmSf4BNYeGMrlSAQM-dA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82A961800D4A;
        Wed,  6 May 2020 09:50:43 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-17.ams2.redhat.com [10.36.113.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0361C5C1BD;
        Wed,  6 May 2020 09:50:40 +0000 (UTC)
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
Subject: [PATCH v1 10/17] virtio-mem: Paravirtualized memory hot(un)plug
Date:   Wed,  6 May 2020 11:49:41 +0200
Message-Id: <20200506094948.76388-11-david@redhat.com>
In-Reply-To: <20200506094948.76388-1-david@redhat.com>
References: <20200506094948.76388-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
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
guest can try to plug/unplug blocks of memory within that region, in orde=
r
to reach the requested size. Initially, and after a reboot, all memory is
unplugged (except in special cases - reboot during postcopy).

The guest may only try to plug/unplug blocks of memory within the usable
region size. The usable region size is a little bigger than the
requested size, to give the device driver some flexibility. The usable
region size will only grow, except on reboots or when all memory is
requested to get unplugged. The guest can never plug more memory than
requested. Unplugged memory will get zapped/discarded, similar to in a
balloon device.

The block size is variable, however, it is always chosen in a way such th=
at
THP splits are avoided (e.g., 2MB). The state of each block
(plugged/unplugged) is tracked in a bitmap.

As virtio-mem devices (e.g., virtio-mem-pci) will be memory devices, we n=
ow
expose "VirtioMEMDeviceInfo" via "query-memory-devices".

-------------------------------------------------------------------------=
-

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

-------------------------------------------------------------------------=
-

Example usage (virtio-mem-pci is introduced in follow-up patches):

Start QEMU with two virtio-mem devices (one per NUMA node):
 $ qemu-system-x86_64 -m 4G,maxmem=3D20G \
  -smp sockets=3D2,cores=3D2 \
  -numa node,nodeid=3D0,cpus=3D0-1 -numa node,nodeid=3D1,cpus=3D2-3 \
  [...]
  -object memory-backend-ram,id=3Dmem0,size=3D8G \
  -device virtio-mem-pci,id=3Dvm0,memdev=3Dmem0,node=3D0,requested-size=3D=
0M \
  -object memory-backend-ram,id=3Dmem1,size=3D8G \
  -device virtio-mem-pci,id=3Dvm1,memdev=3Dmem1,node=3D1,requested-size=3D=
1G

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
 hw/virtio/virtio-mem.c         | 762 +++++++++++++++++++++++++++++++++
 include/hw/virtio/virtio-mem.h |  80 ++++
 qapi/misc.json                 |  39 +-
 5 files changed, 892 insertions(+), 1 deletion(-)
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
index 4e4d39a0a4..7df70e977e 100644
--- a/hw/virtio/Makefile.objs
+++ b/hw/virtio/Makefile.objs
@@ -18,6 +18,7 @@ common-obj-$(call land,$(CONFIG_VIRTIO_PMEM),$(CONFIG_V=
IRTIO_PCI)) +=3D virtio-pme
 obj-$(call land,$(CONFIG_VHOST_USER_FS),$(CONFIG_VIRTIO_PCI)) +=3D vhost=
-user-fs-pci.o
 obj-$(CONFIG_VIRTIO_IOMMU) +=3D virtio-iommu.o
 obj-$(CONFIG_VHOST_VSOCK) +=3D vhost-vsock.o
+obj-$(CONFIG_VIRTIO_MEM) +=3D virtio-mem.o
=20
 ifeq ($(CONFIG_VIRTIO_PCI),y)
 obj-$(CONFIG_VHOST_VSOCK) +=3D vhost-vsock-pci.o
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
new file mode 100644
index 0000000000..e25b2c74f2
--- /dev/null
+++ b/hw/virtio/virtio-mem.c
@@ -0,0 +1,762 @@
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
+#include "migration/postcopy-ram.h"
+#include "hw/boards.h"
+#include "hw/qdev-properties.h"
+#include "config-devices.h"
+
+/*
+ * Use QEMU_VMALLOC_ALIGN, so no THP will have to be split when unpluggi=
ng
+ * memory (e.g., 2MB on x86_64).
+ */
+#define VIRTIO_MEM_MIN_BLOCK_SIZE QEMU_VMALLOC_ALIGN
+/*
+ * Size the usable region bigger than the requested size if possible. Es=
p.
+ * Linux guests will only add (aligned) memory blocks in case they fully
+ * fit into the usable region, but plug+online only a subset of the page=
s.
+ * The memory block size corresponds mostly to the section size.
+ *
+ * This allows e.g., to add 20MB with a section size of 128MB on x86_64,=
 and
+ * a section size of 1GB on arm64 (as long as the start address is prope=
rly
+ * aligned, similar to ordinary DIMMs).
+ *
+ * We can change this at any time and maybe even make it configurable if
+ * necessary (as the section size can change). But it's more likely that=
 the
+ * section size will rather get smaller and not bigger over time.
+ */
+#if defined(__x86_64__)
+#define VIRTIO_MEM_USABLE_EXTENT (2 * (128 * MiB))
+#else
+#error VIRTIO_MEM_USABLE_EXTENT not defined
+#endif
+
+static bool virtio_mem_discard_inhibited(void)
+{
+    PostcopyState ps =3D postcopy_state_get();
+
+    /* Postcopy cannot deal with concurrent discards (yet), so it's spec=
ial. */
+    return ps >=3D POSTCOPY_INCOMING_DISCARD && ps < POSTCOPY_INCOMING_E=
ND;
+}
+
+static bool virtio_mem_test_bitmap(VirtIOMEM *vmem, uint64_t start_gpa,
+                                   uint64_t size, bool plug)
+{
+    uint64_t bit =3D (start_gpa - vmem->addr) / vmem->block_size;
+
+    g_assert(QEMU_IS_ALIGNED(start_gpa, vmem->block_size));
+    g_assert(QEMU_IS_ALIGNED(size, vmem->block_size));
+    g_assert(vmem->bitmap);
+
+    while (size) {
+        g_assert((bit / BITS_PER_BYTE) <=3D vmem->bitmap_size);
+
+        if (plug && !test_bit(bit, vmem->bitmap)) {
+            return false;
+        } else if (!plug && test_bit(bit, vmem->bitmap)) {
+            return false;
+        }
+        size -=3D vmem->block_size;
+        bit++;
+    }
+    return true;
+}
+
+static void virtio_mem_set_bitmap(VirtIOMEM *vmem, uint64_t start_gpa,
+                                  uint64_t size, bool plug)
+{
+    const uint64_t bit =3D (start_gpa - vmem->addr) / vmem->block_size;
+    const uint64_t nbits =3D size / vmem->block_size;
+
+    g_assert(QEMU_IS_ALIGNED(start_gpa, vmem->block_size));
+    g_assert(QEMU_IS_ALIGNED(size, vmem->block_size));
+    g_assert(vmem->bitmap);
+
+    if (plug) {
+        bitmap_set(vmem->bitmap, bit, nbits);
+    } else {
+        bitmap_clear(vmem->bitmap, bit, nbits);
+    }
+}
+
+static void virtio_mem_send_response(VirtIOMEM *vmem, VirtQueueElement *=
elem,
+                                     struct virtio_mem_resp *resp)
+{
+    VirtIODevice *vdev =3D VIRTIO_DEVICE(vmem);
+    VirtQueue *vq =3D vmem->vq;
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
+    VirtIODevice *vdev =3D VIRTIO_DEVICE(vmem);
+    struct virtio_mem_resp resp =3D {};
+
+    virtio_stw_p(vdev, &resp.type, type);
+    virtio_mem_send_response(vmem, elem, &resp);
+}
+
+static void virtio_mem_bad_request(VirtIOMEM *vmem, const char *msg)
+{
+    virtio_error(VIRTIO_DEVICE(vmem), "virtio-mem protocol violation: %s=
", msg);
+}
+
+static bool virtio_mem_valid_range(VirtIOMEM *vmem, uint64_t gpa, uint64=
_t size)
+{
+    if (!QEMU_IS_ALIGNED(gpa, vmem->block_size)) {
+            return false;
+    }
+    if (gpa + size < gpa || size =3D=3D 0) {
+        return false;
+    }
+    if (gpa < vmem->addr || gpa >=3D vmem->addr + vmem->usable_region_si=
ze) {
+        return false;
+    }
+    if (gpa + size > vmem->addr + vmem->usable_region_size) {
+        return false;
+    }
+    return true;
+}
+
+static int virtio_mem_set_block_state(VirtIOMEM *vmem, uint64_t start_gp=
a,
+                                      uint64_t size, bool plug)
+{
+    const uint64_t offset =3D start_gpa - vmem->addr;
+    int ret;
+
+    if (!plug) {
+        if (virtio_mem_discard_inhibited()) {
+            return -EBUSY;
+        }
+        /* Note: Discarding should never fail at this point. */
+        ret =3D ram_block_discard_range(vmem->memdev->mr.ram_block, offs=
et, size);
+        if (ret) {
+            return -EBUSY;
+        }
+    }
+    virtio_mem_set_bitmap(vmem, start_gpa, size, plug);
+    return 0;
+}
+
+static int virtio_mem_state_change_request(VirtIOMEM *vmem, uint64_t gpa=
,
+                                           uint16_t nb_blocks, bool plug=
)
+{
+    const uint64_t size =3D nb_blocks * vmem->block_size;
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
+    ret =3D virtio_mem_set_block_state(vmem, gpa, size, plug);
+    if (ret) {
+        return VIRTIO_MEM_RESP_BUSY;
+    }
+    if (plug) {
+        vmem->size +=3D size;
+    } else {
+        vmem->size -=3D size;
+    }
+    return VIRTIO_MEM_RESP_ACK;
+}
+
+static void virtio_mem_plug_request(VirtIOMEM *vmem, VirtQueueElement *e=
lem,
+                                    struct virtio_mem_req *req)
+{
+    const uint64_t gpa =3D le64_to_cpu(req->u.plug.addr);
+    const uint16_t nb_blocks =3D le16_to_cpu(req->u.plug.nb_blocks);
+    uint16_t type;
+
+    type =3D virtio_mem_state_change_request(vmem, gpa, nb_blocks, true)=
;
+    virtio_mem_send_response_simple(vmem, elem, type);
+}
+
+static void virtio_mem_unplug_request(VirtIOMEM *vmem, VirtQueueElement =
*elem,
+                                      struct virtio_mem_req *req)
+{
+    const uint64_t gpa =3D le64_to_cpu(req->u.unplug.addr);
+    const uint16_t nb_blocks =3D le16_to_cpu(req->u.unplug.nb_blocks);
+    uint16_t type;
+
+    type =3D virtio_mem_state_change_request(vmem, gpa, nb_blocks, false=
);
+    virtio_mem_send_response_simple(vmem, elem, type);
+}
+
+static void virtio_mem_resize_usable_region(VirtIOMEM *vmem,
+                                            uint64_t requested_size,
+                                            bool can_shrink)
+{
+    uint64_t newsize =3D MIN(memory_region_size(&vmem->memdev->mr),
+                           requested_size + VIRTIO_MEM_USABLE_EXTENT);
+
+    /* We must only grow while the guest is running. */
+    if (newsize < vmem->usable_region_size && !can_shrink) {
+        return;
+    }
+
+    vmem->usable_region_size =3D newsize;
+}
+
+static int virtio_mem_unplug_all(VirtIOMEM *vmem)
+{
+    RAMBlock *rb =3D vmem->memdev->mr.ram_block;
+    int ret;
+
+    if (virtio_mem_discard_inhibited()) {
+        return -EBUSY;
+    }
+
+    ret =3D ram_block_discard_range(rb, 0, qemu_ram_get_used_length(rb))=
;
+    if (ret) {
+        /* Note: Discarding should never fail at this point. */
+        return -EBUSY;
+    }
+    bitmap_clear(vmem->bitmap, 0, vmem->bitmap_size);
+    vmem->size =3D 0;
+
+    virtio_mem_resize_usable_region(vmem, vmem->requested_size, true);
+    return 0;
+}
+
+static void virtio_mem_unplug_all_request(VirtIOMEM *vmem,
+                                          VirtQueueElement *elem)
+{
+
+    if (virtio_mem_unplug_all(vmem)) {
+        virtio_mem_send_response_simple(vmem, elem, VIRTIO_MEM_RESP_BUSY=
);
+    } else {
+        virtio_mem_send_response_simple(vmem, elem, VIRTIO_MEM_RESP_ACK)=
;
+    }
+}
+
+static void virtio_mem_state_request(VirtIOMEM *vmem, VirtQueueElement *=
elem,
+                                     struct virtio_mem_req *req)
+{
+    const uint64_t gpa =3D le64_to_cpu(req->u.state.addr);
+    const uint16_t nb_blocks =3D le16_to_cpu(req->u.state.nb_blocks);
+    const uint64_t size =3D nb_blocks * vmem->block_size;
+    VirtIODevice *vdev =3D VIRTIO_DEVICE(vmem);
+    struct virtio_mem_resp resp =3D {};
+
+    if (!virtio_mem_valid_range(vmem, gpa, size)) {
+        virtio_mem_send_response_simple(vmem, elem, VIRTIO_MEM_RESP_ERRO=
R);
+        return;
+    }
+
+    virtio_stw_p(vdev, &resp.type, VIRTIO_MEM_RESP_ACK);
+    if (virtio_mem_test_bitmap(vmem, gpa, size, true)) {
+        virtio_stw_p(vdev, &resp.u.state.state, VIRTIO_MEM_STATE_PLUGGED=
);
+    } else if (virtio_mem_test_bitmap(vmem, gpa, size, false)) {
+        virtio_stw_p(vdev, &resp.u.state.state, VIRTIO_MEM_STATE_UNPLUGG=
ED);
+    } else {
+        virtio_stw_p(vdev, &resp.u.state.state, VIRTIO_MEM_STATE_MIXED);
+    }
+    virtio_mem_send_response(vmem, elem, &resp);
+}
+
+static void virtio_mem_handle_request(VirtIODevice *vdev, VirtQueue *vq)
+{
+    const int len =3D sizeof(struct virtio_mem_req);
+    VirtIOMEM *vmem =3D VIRTIO_MEM(vdev);
+    VirtQueueElement *elem;
+    struct virtio_mem_req req;
+    uint64_t type;
+
+    while (true) {
+        elem =3D virtqueue_pop(vq, sizeof(VirtQueueElement));
+        if (!elem) {
+            return;
+        }
+
+        if (iov_to_buf(elem->out_sg, elem->out_num, 0, &req, len) < len)=
 {
+            virtio_mem_bad_request(vmem, "invalid request size");
+            g_free(elem);
+            return;
+        }
+
+        if (iov_size(elem->in_sg, elem->in_num) <
+            sizeof(struct virtio_mem_resp)) {
+            virtio_mem_bad_request(vmem, "not enough space for response"=
);
+            g_free(elem);
+            return;
+        }
+
+        type =3D le16_to_cpu(req.type);
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
+            virtio_mem_bad_request(vmem, "unknown request type");
+            g_free(elem);
+            return;
+        }
+
+        g_free(elem);
+    }
+}
+
+static void virtio_mem_get_config(VirtIODevice *vdev, uint8_t *config_da=
ta)
+{
+    VirtIOMEM *vmem =3D VIRTIO_MEM(vdev);
+    struct virtio_mem_config *config =3D (void *) config_data;
+
+    config->block_size =3D cpu_to_le32(vmem->block_size);
+    config->node_id =3D cpu_to_le16(vmem->node);
+    config->requested_size =3D cpu_to_le64(vmem->requested_size);
+    config->plugged_size =3D cpu_to_le64(vmem->size);
+    config->addr =3D cpu_to_le64(vmem->addr);
+    config->region_size =3D cpu_to_le64(memory_region_size(&vmem->memdev=
->mr));
+    config->usable_region_size =3D cpu_to_le64(vmem->usable_region_size)=
;
+}
+
+static uint64_t virtio_mem_get_features(VirtIODevice *vdev, uint64_t fea=
tures,
+                                        Error **errp)
+{
+    MachineState *ms =3D MACHINE(qdev_get_machine());
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
+    VirtIOMEM *vmem =3D VIRTIO_MEM(opaque);
+
+    /*
+     * During usual resets, we will unplug all memory and shrink the usa=
ble
+     * region size. This is, however, not possible in all scenarios. The=
n,
+     * the guest has to deal with this manually (VIRTIO_MEM_REQ_UNPLUG_A=
LL).
+     */
+    virtio_mem_unplug_all(vmem);
+}
+
+static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
+{
+    MachineState *ms =3D MACHINE(qdev_get_machine());
+    int nb_numa_nodes =3D ms->numa_state ? ms->numa_state->num_nodes : 0=
;
+    VirtIODevice *vdev =3D VIRTIO_DEVICE(dev);
+    VirtIOMEM *vmem =3D VIRTIO_MEM(dev);
+    uint64_t page_size;
+    RAMBlock *rb;
+    int ret;
+
+    if (!vmem->memdev) {
+        error_setg(errp, "'%s' property must be set", VIRTIO_MEM_MEMDEV_=
PROP);
+        return;
+    } else if (host_memory_backend_is_mapped(vmem->memdev)) {
+        char *path =3D object_get_canonical_path_component(OBJECT(vmem->=
memdev));
+
+        error_setg(errp, "can't use already busy memdev: %s", path);
+        g_free(path);
+        return;
+    }
+
+    if ((nb_numa_nodes && vmem->node >=3D nb_numa_nodes) ||
+        (!nb_numa_nodes && vmem->node)) {
+        error_setg(errp, "Property '%s' has value '%" PRIu32
+                   "', which exceeds the number of numa nodes: %d",
+                   VIRTIO_MEM_NODE_PROP, vmem->node,
+                   nb_numa_nodes ? nb_numa_nodes : 1);
+        return;
+    }
+
+    if (enable_mlock) {
+        error_setg(errp, "not compatible with mlock yet");
+        return;
+    }
+
+    if (!memory_region_is_ram(&vmem->memdev->mr) ||
+        memory_region_is_rom(&vmem->memdev->mr) ||
+        !vmem->memdev->mr.ram_block) {
+        error_setg(errp, "unsupported memdev");
+        return;
+    }
+
+    rb =3D vmem->memdev->mr.ram_block;
+    page_size =3D qemu_ram_pagesize(rb);
+
+    if (vmem->block_size < page_size) {
+        error_setg(errp, "'%s' has to be at least the page size (0x%"
+                   PRIx64 ")", VIRTIO_MEM_BLOCK_SIZE_PROP, page_size);
+        return;
+    } else if (!QEMU_IS_ALIGNED(vmem->requested_size, vmem->block_size))=
 {
+        error_setg(errp, "'%s' has to be multiples of '%s' (0x%" PRIx32
+                   ")", VIRTIO_MEM_REQUESTED_SIZE_PROP,
+                   VIRTIO_MEM_BLOCK_SIZE_PROP, vmem->block_size);
+        return;
+    } else if (!QEMU_IS_ALIGNED(memory_region_size(&vmem->memdev->mr),
+                                vmem->block_size)) {
+        error_setg(errp, "'%s' backend size has to be multiples of '%s' =
(0x%"
+                   PRIx32 ")", VIRTIO_MEM_MEMDEV_PROP,
+                   VIRTIO_MEM_BLOCK_SIZE_PROP, vmem->block_size);
+        return;
+    }
+
+    if (ram_block_discard_set_required(true)) {
+        error_setg(errp, "Discarding RAM is marked broken.");
+        return;
+    }
+
+    ret =3D ram_block_discard_range(rb, 0, qemu_ram_get_used_length(rb))=
;
+    if (ret) {
+        /* Note: Discarding should never fail at this point. */
+        error_setg_errno(errp, -ret, "Discarding RAM failed.");
+        ram_block_discard_set_required(false);
+        return;
+    }
+
+    virtio_mem_resize_usable_region(vmem, vmem->requested_size, true);
+
+    vmem->bitmap_size =3D memory_region_size(&vmem->memdev->mr) /
+                        vmem->block_size;
+    vmem->bitmap =3D bitmap_new(vmem->bitmap_size);
+
+    virtio_init(vdev, TYPE_VIRTIO_MEM, VIRTIO_ID_MEM,
+                sizeof(struct virtio_mem_config));
+    vmem->vq =3D virtio_add_queue(vdev, 128, virtio_mem_handle_request);
+
+    host_memory_backend_set_mapped(vmem->memdev, true);
+    vmstate_register_ram(&vmem->memdev->mr, DEVICE(vmem));
+    qemu_register_reset(virtio_mem_system_reset, vmem);
+    return;
+}
+
+static void virtio_mem_device_unrealize(DeviceState *dev, Error **errp)
+{
+    VirtIODevice *vdev =3D VIRTIO_DEVICE(dev);
+    VirtIOMEM *vmem =3D VIRTIO_MEM(dev);
+
+    qemu_unregister_reset(virtio_mem_system_reset, vmem);
+    vmstate_unregister_ram(&vmem->memdev->mr, DEVICE(vmem));
+    host_memory_backend_set_mapped(vmem->memdev, false);
+    virtio_del_queue(vdev, 0);
+    virtio_cleanup(vdev);
+    g_free(vmem->bitmap);
+    ramblock_discard_set_required(false);
+}
+
+static int virtio_mem_pre_save(void *opaque)
+{
+    VirtIOMEM *vmem =3D VIRTIO_MEM(opaque);
+
+    vmem->migration_addr =3D vmem->addr;
+    vmem->migration_block_size =3D vmem->block_size;
+
+    return 0;
+}
+
+static int virtio_mem_restore_unplugged(VirtIOMEM *vmem)
+{
+    unsigned long bit;
+    uint64_t offset;
+    int ret;
+
+    /* TODO: Better postcopy handling - defer to postcopy end. */
+    if (virtio_mem_discard_inhibited()) {
+        return 0;
+    }
+
+    bit =3D find_first_zero_bit(vmem->bitmap, vmem->bitmap_size);
+    while (bit < vmem->bitmap_size) {
+        offset =3D bit * vmem->block_size;
+
+        if (offset + vmem->block_size >=3D
+            memory_region_size(&vmem->memdev->mr)) {
+            break;
+        }
+        /* Note: Discarding should never fail at this point. */
+        ret =3D ram_block_discard_range(vmem->memdev->mr.ram_block, offs=
et,
+                                      vmem->block_size);
+        if (ret) {
+            return -EINVAL;
+        }
+        bit =3D find_next_zero_bit(vmem->bitmap, vmem->bitmap_size, bit =
+ 1);
+    }
+    return 0;
+}
+
+static int virtio_mem_post_load(void *opaque, int version_id)
+{
+    VirtIOMEM *vmem =3D VIRTIO_MEM(opaque);
+
+    if (vmem->migration_block_size !=3D vmem->block_size) {
+        error_report("'%s' doesn't match", VIRTIO_MEM_BLOCK_SIZE_PROP);
+        return -EINVAL;
+    }
+    if (vmem->migration_addr !=3D vmem->addr) {
+        error_report("'%s' doesn't match", VIRTIO_MEM_ADDR_PROP);
+        return -EINVAL;
+    }
+    return virtio_mem_restore_unplugged(vmem);
+}
+
+static const VMStateDescription vmstate_virtio_mem_device =3D {
+    .name =3D "virtio-mem-device",
+    .minimum_version_id =3D 1,
+    .version_id =3D 1,
+    .pre_save =3D virtio_mem_pre_save,
+    .post_load =3D virtio_mem_post_load,
+    .fields =3D (VMStateField[]) {
+        VMSTATE_UINT64(usable_region_size, VirtIOMEM),
+        VMSTATE_UINT64(size, VirtIOMEM),
+        VMSTATE_UINT64(requested_size, VirtIOMEM),
+        VMSTATE_UINT64(migration_addr, VirtIOMEM),
+        VMSTATE_UINT32(migration_block_size, VirtIOMEM),
+        VMSTATE_BITMAP(bitmap, VirtIOMEM, 0, bitmap_size),
+        VMSTATE_END_OF_LIST()
+    },
+};
+
+static const VMStateDescription vmstate_virtio_mem =3D {
+    .name =3D "virtio-mem",
+    .minimum_version_id =3D 1,
+    .version_id =3D 1,
+    .fields =3D (VMStateField[]) {
+        VMSTATE_VIRTIO_DEVICE,
+        VMSTATE_END_OF_LIST()
+    },
+};
+
+static void virtio_mem_fill_device_info(const VirtIOMEM *vmem,
+                                        VirtioMEMDeviceInfo *vi)
+{
+    vi->memaddr =3D vmem->addr;
+    vi->node =3D vmem->node;
+    vi->requested_size =3D vmem->requested_size;
+    vi->size =3D vmem->size;
+    vi->max_size =3D memory_region_size(&vmem->memdev->mr);
+    vi->block_size =3D vmem->block_size;
+    vi->memdev =3D object_get_canonical_path(OBJECT(vmem->memdev));
+}
+
+static MemoryRegion *virtio_mem_get_memory_region(VirtIOMEM *vmem, Error=
 **errp)
+{
+    if (!vmem->memdev) {
+        error_setg(errp, "'%s' property must be set", VIRTIO_MEM_MEMDEV_=
PROP);
+        return NULL;
+    }
+
+    return &vmem->memdev->mr;
+}
+
+static void virtio_mem_get_size(Object *obj, Visitor *v, const char *nam=
e,
+                                void *opaque, Error **errp)
+{
+    const VirtIOMEM *vmem =3D VIRTIO_MEM(obj);
+    uint64_t value =3D vmem->size;
+
+    visit_type_size(v, name, &value, errp);
+}
+
+static void virtio_mem_get_requested_size(Object *obj, Visitor *v,
+                                          const char *name, void *opaque=
,
+                                          Error **errp)
+{
+    const VirtIOMEM *vmem =3D VIRTIO_MEM(obj);
+    uint64_t value =3D vmem->requested_size;
+
+    visit_type_size(v, name, &value, errp);
+}
+
+static void virtio_mem_set_requested_size(Object *obj, Visitor *v,
+                                          const char *name, void *opaque=
,
+                                          Error **errp)
+{
+    VirtIOMEM *vmem =3D VIRTIO_MEM(obj);
+    Error *err =3D NULL;
+    uint64_t value;
+
+    visit_type_size(v, name, &value, &err);
+    if (err) {
+        error_propagate(errp, err);
+        return;
+    }
+
+    /*
+     * The block size and memory backend are not fixed until the device =
was
+     * realized. realize() will verify these properties then.
+     */
+    if (DEVICE(obj)->realized) {
+        if (!QEMU_IS_ALIGNED(value, vmem->block_size)) {
+            error_setg(errp, "'%s' has to be multiples of '%s' (0x%" PRI=
x32
+                       ")", name, VIRTIO_MEM_BLOCK_SIZE_PROP,
+                       vmem->block_size);
+            return;
+        } else if (value > memory_region_size(&vmem->memdev->mr)) {
+            error_setg(errp, "'%s' cannot exceed the memory backend size=
"
+                       "(0x%" PRIx64 ")", name,
+                       memory_region_size(&vmem->memdev->mr));
+            return;
+        }
+
+        if (value !=3D vmem->requested_size) {
+            virtio_mem_resize_usable_region(vmem, value, false);
+            vmem->requested_size =3D value;
+        }
+        /*
+         * Trigger a config update so the guest gets notified. We trigge=
r
+         * even if the size didn't change (especially helpful for debugg=
ing).
+         */
+        virtio_notify_config(VIRTIO_DEVICE(vmem));
+    } else {
+        vmem->requested_size =3D value;
+    }
+}
+
+static void virtio_mem_get_block_size(Object *obj, Visitor *v, const cha=
r *name,
+                                      void *opaque, Error **errp)
+{
+    const VirtIOMEM *vmem =3D VIRTIO_MEM(obj);
+    uint64_t value =3D vmem->block_size;
+
+    visit_type_size(v, name, &value, errp);
+}
+
+static void virtio_mem_set_block_size(Object *obj, Visitor *v, const cha=
r *name,
+                                      void *opaque, Error **errp)
+{
+    VirtIOMEM *vmem =3D VIRTIO_MEM(obj);
+    Error *err =3D NULL;
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
+    if (value > UINT32_MAX) {
+        error_setg(errp, "'%s' has to be smaller than 0x%" PRIx32, name,
+                   UINT32_MAX);
+        return;
+    } else if (value < VIRTIO_MEM_MIN_BLOCK_SIZE) {
+        error_setg(errp, "'%s' has to be at least 0x%" PRIx32, name,
+                   VIRTIO_MEM_MIN_BLOCK_SIZE);
+        return;
+    } else if (!is_power_of_2(value)) {
+        error_setg(errp, "'%s' has to be a power of two", name);
+        return;
+    }
+    vmem->block_size =3D value;
+}
+
+static void virtio_mem_instance_init(Object *obj)
+{
+    VirtIOMEM *vmem =3D VIRTIO_MEM(obj);
+
+    vmem->block_size =3D VIRTIO_MEM_MIN_BLOCK_SIZE;
+
+    object_property_add(obj, VIRTIO_MEM_SIZE_PROP, "size", virtio_mem_ge=
t_size,
+                        NULL, NULL, NULL, &error_abort);
+    object_property_add(obj, VIRTIO_MEM_REQUESTED_SIZE_PROP, "size",
+                        virtio_mem_get_requested_size,
+                        virtio_mem_set_requested_size, NULL, NULL,
+                        &error_abort);
+    object_property_add(obj, VIRTIO_MEM_BLOCK_SIZE_PROP, "size",
+                        virtio_mem_get_block_size, virtio_mem_set_block_=
size,
+                        NULL, NULL, &error_abort);
+}
+
+static Property virtio_mem_properties[] =3D {
+    DEFINE_PROP_UINT64(VIRTIO_MEM_ADDR_PROP, VirtIOMEM, addr, 0),
+    DEFINE_PROP_UINT32(VIRTIO_MEM_NODE_PROP, VirtIOMEM, node, 0),
+    DEFINE_PROP_LINK(VIRTIO_MEM_MEMDEV_PROP, VirtIOMEM, memdev,
+                     TYPE_MEMORY_BACKEND, HostMemoryBackend *),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static void virtio_mem_class_init(ObjectClass *klass, void *data)
+{
+    DeviceClass *dc =3D DEVICE_CLASS(klass);
+    VirtioDeviceClass *vdc =3D VIRTIO_DEVICE_CLASS(klass);
+    VirtIOMEMClass *vmc =3D VIRTIO_MEM_CLASS(klass);
+
+    device_class_set_props(dc, virtio_mem_properties);
+    dc->vmsd =3D &vmstate_virtio_mem;
+
+    set_bit(DEVICE_CATEGORY_MISC, dc->categories);
+    vdc->realize =3D virtio_mem_device_realize;
+    vdc->unrealize =3D virtio_mem_device_unrealize;
+    vdc->get_config =3D virtio_mem_get_config;
+    vdc->get_features =3D virtio_mem_get_features;
+    vdc->vmsd =3D &vmstate_virtio_mem_device;
+
+    vmc->fill_device_info =3D virtio_mem_fill_device_info;
+    vmc->get_memory_region =3D virtio_mem_get_memory_region;
+}
+
+static const TypeInfo virtio_mem_info =3D {
+    .name =3D TYPE_VIRTIO_MEM,
+    .parent =3D TYPE_VIRTIO_DEVICE,
+    .instance_size =3D sizeof(VirtIOMEM),
+    .instance_init =3D virtio_mem_instance_init,
+    .class_init =3D virtio_mem_class_init,
+    .class_size =3D sizeof(VirtIOMEMClass),
+};
+
+static void virtio_register_types(void)
+{
+    type_register_static(&virtio_mem_info);
+}
+
+type_init(virtio_register_types)
diff --git a/include/hw/virtio/virtio-mem.h b/include/hw/virtio/virtio-me=
m.h
new file mode 100644
index 0000000000..27158cb611
--- /dev/null
+++ b/include/hw/virtio/virtio-mem.h
@@ -0,0 +1,80 @@
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
+    uint64_t migration_addr;
+
+    /* usable region size (<=3D region_size) */
+    uint64_t usable_region_size;
+
+    /* actual size (how much the guest plugged) */
+    uint64_t size;
+
+    /* requested size */
+    uint64_t requested_size;
+
+    /* block size and alignment */
+    uint32_t block_size;
+    uint32_t migration_block_size;
+} VirtIOMEM;
+
+typedef struct VirtIOMEMClass {
+    /* private */
+    VirtIODevice parent;
+
+    /* public */
+    void (*fill_device_info)(const VirtIOMEM *vmen, VirtioMEMDeviceInfo =
*vi);
+    MemoryRegion *(*get_memory_region)(VirtIOMEM *vmem, Error **errp);
+} VirtIOMEMClass;
+
+#endif
diff --git a/qapi/misc.json b/qapi/misc.json
index 99b90ac80b..feaeacec22 100644
--- a/qapi/misc.json
+++ b/qapi/misc.json
@@ -1354,19 +1354,56 @@
           }
 }
=20
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
+# virtio-mem is included since 5.2.
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
=20
--=20
2.25.3

