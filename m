Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C019E11D349
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 18:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbfLLRM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 12:12:28 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53975 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730117AbfLLRMX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 12:12:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576170740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+E7qhT+i6NtAMcKCEDilM3wh3ySua9B4tL4St8OxDdE=;
        b=bh1wi6THH+wjCEHYT1BiRauTk/kvCULQchu4DF+LfvAEx+lU7mjJ00GBMc4PhViYQkPFc9
        SESg1/cApugvzBPuTd+TMhaEAwaaw1JktfIm2Sk1UgEAm6ZH2jrwoP2z6Rc4pgbR8YP9os
        v38SucROdOvgILXsZyiyU9Vqwjpx3vQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-HlxvOUl3MAO0iK1i6q6TFw-1; Thu, 12 Dec 2019 12:12:15 -0500
X-MC-Unique: HlxvOUl3MAO0iK1i6q6TFw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79ABB18A6EC0;
        Thu, 12 Dec 2019 17:12:13 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-117-65.ams2.redhat.com [10.36.117.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 201AB5C1C3;
        Thu, 12 Dec 2019 17:12:06 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Igor Mammedov <imammedo@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH RFC v4 02/13] virtio-mem: Paravirtualized memory hotplug
Date:   Thu, 12 Dec 2019 18:11:26 +0100
Message-Id: <20191212171137.13872-3-david@redhat.com>
In-Reply-To: <20191212171137.13872-1-david@redhat.com>
References: <20191212171137.13872-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Each virtio-mem device owns exactly one memory region. It is responsible
for adding/removing memory from that memory region on request.

When the device driver starts up, the requested amount of memory is
queried and then plugged to Linux. On request, further memory can be
plugged or unplugged. This patch only implements the plugging part.

On x86-64, memory can currently be plugged in 4MB ("subblock") granularit=
y.
When required, a new memory block will be added (e.g., usually 128MB on
x86-64) in order to plug more subblocks. Only x86-64 was tested for now.

The online_page callback is used to keep unplugged subblocks offline
when onlining memory - similar to the Hyper-V balloon driver. Unplugged
pages are marked PG_offline, to tell dump tools (e.g., makedumpfile) to
skip them.

User space is usually responsible for onlining the added memory. The
memory hotplug notifier is used to synchronize virtio-mem activity
against memory onlining/offlining.

Each virtio-mem device can belong to a NUMA node, which allows us to
easily add/remove small chunks of memory to/from a specific NUMA node by
using multiple virtio-mem devices. Something that works even when the
guest has no idea about the NUMA topology.

One way to view virtio-mem is as a "resizable DIMM" or a DIMM with many
"sub-DIMMS".

This patch directly introduces the basic infrastructure to implement memo=
ry
unplug. Especially the memory block states and subblock bitmaps will be
heavily used there.

Notes:
- Memory blocks that are partally unplugged must not be onlined to the
  MOVABLE_ZONE. They contain unmovable parts and might e.g., result
  in warnings when trying to offline them.
- In the kdump kernel, we don't want to load the driver, to not mess
  with memory to be dumped.
- In case memory is to be onlined by user space, we limit the amount of
  offline memory blocks, to not run out of memory.
- Suspend/Hibernate is not supported due to the way virtio-mem devices
  behave. Limited support might be possible in the future.
- Reloading the device driver is not supported.
- When unloading the driver, we have to remove partially plugged offline
  memory blocks. Otherwise they could get fully onlined later on, when
  we no longer have control over via the online_page callback.
- As the hypervisor might suddenly be busy (during reboot, in-between
  requests, when adding of memory fails), we have to take care of some
  corner cases - especially virtio_mem_unplug_pending_mb() and
  virtio_mem_send_unplug_all_request(). The hypervisor could for example
  be busy if it is currently migrating the guest.

Future work:
- Reduce the amount of memory resources if that turnes out to be an
  issue. Or try to speed up relevant code paths to deal with many
  resources.
- Allocate the vmemmap from the added memory. Makes hotplug more likely
  to succeed, the vmemmap is stored on the same NUMA node and that
  unmovable memory will later not hinder unplug.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/virtio/Kconfig          |   17 +
 drivers/virtio/Makefile         |    1 +
 drivers/virtio/virtio_mem.c     | 1569 +++++++++++++++++++++++++++++++
 include/uapi/linux/virtio_ids.h |    1 +
 include/uapi/linux/virtio_mem.h |  204 ++++
 5 files changed, 1792 insertions(+)
 create mode 100644 drivers/virtio/virtio_mem.c
 create mode 100644 include/uapi/linux/virtio_mem.h

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 078615cf2afc..294720d53057 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -64,6 +64,23 @@ config VIRTIO_BALLOON
=20
 	 If unsure, say M.
=20
+config VIRTIO_MEM
+	tristate "Virtio mem driver"
+	default m
+	depends on X86_64
+	depends on VIRTIO
+	depends on MEMORY_HOTPLUG_SPARSE
+	depends on MEMORY_HOTREMOVE
+	help
+	 This driver provides access to virtio-mem paravirtualized memory
+	 devices, allowing to hotplug and hotunplug memory.
+
+	 This driver is was only tested under x86-64, but should
+	 theoretically work on all architectures that support memory
+	 hotplug and hotremove.
+
+	 If unsure, say M.
+
 config VIRTIO_INPUT
 	tristate "Virtio input driver"
 	depends on VIRTIO
diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index 3a2b5c5dcf46..906d5a00ac85 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -6,3 +6,4 @@ virtio_pci-y :=3D virtio_pci_modern.o virtio_pci_common.o
 virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) +=3D virtio_pci_legacy.o
 obj-$(CONFIG_VIRTIO_BALLOON) +=3D virtio_balloon.o
 obj-$(CONFIG_VIRTIO_INPUT) +=3D virtio_input.o
+obj-$(CONFIG_VIRTIO_MEM) +=3D virtio_mem.o
diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
new file mode 100644
index 000000000000..8f4ceeab3d7c
--- /dev/null
+++ b/drivers/virtio/virtio_mem.c
@@ -0,0 +1,1569 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Virtio-mem device driver.
+ *
+ * Copyright Red Hat, Inc. 2019
+ *
+ * Author(s): David Hildenbrand <david@redhat.com>
+ */
+
+#include <linux/virtio.h>
+#include <linux/virtio_mem.h>
+#include <linux/workqueue.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/memory_hotplug.h>
+#include <linux/memory.h>
+#include <linux/hrtimer.h>
+#include <linux/crash_dump.h>
+#include <linux/mutex.h>
+#include <linux/bitmap.h>
+
+#include <acpi/acpi_numa.h>
+
+enum virtio_mem_mb_state {
+	/* Unplugged, not added to Linux. Can be reused later. */
+	VIRTIO_MEM_MB_STATE_UNUSED =3D 0,
+	/* (Partially) plugged, not added to Linux. Error on add_memory(). */
+	VIRTIO_MEM_MB_STATE_PLUGGED,
+	/* Fully plugged, fully added to Linux, offline. */
+	VIRTIO_MEM_MB_STATE_OFFLINE,
+	/* Paritally plugged, fully added to Linux, offline. */
+	VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL,
+	/* Fully plugged, fully added to Linux, online (!ZONE_MOVABLE). */
+	VIRTIO_MEM_MB_STATE_ONLINE,
+	/* Partially plugged, fully added to Linux, online (!ZONE_MOVABLE). */
+	VIRTIO_MEM_MB_STATE_ONLINE_PARTIAL,
+	/*
+	 * Fully plugged, fully added to Linux, online (ZONE_MOVABLE).
+	 * We are not allowed to allocate (unplug) parts of this block that
+	 * are not movable (similar to gigantic pages). We will never allow
+	 * to online OFFLINE_PARTIAL to ZONE_MOVABLE (as they would contain
+	 * unmovable parts).
+	 */
+	VIRTIO_MEM_MB_STATE_ONLINE_MOVABLE,
+	VIRTIO_MEM_MB_STATE_COUNT
+};
+
+struct virtio_mem {
+	struct virtio_device *vdev;
+
+	/* We might first have to unplug all memory when starting up. */
+	bool unplug_all_required;
+
+	/* Workqueue that processes the plug/unplug requests. */
+	struct work_struct wq;
+	atomic_t config_changed;
+
+	/* Virtqueue for guest->host requests. */
+	struct virtqueue *vq;
+
+	/* Wait for a host response to a guest request. */
+	wait_queue_head_t host_resp;
+
+	/* Space for one guest request and the host response. */
+	struct virtio_mem_req req;
+	struct virtio_mem_resp resp;
+
+	/* The current size of the device. */
+	uint64_t plugged_size;
+	/* The requested size of the device. */
+	uint64_t requested_size;
+
+	/* The device block size (for communicating with the device). */
+	uint32_t device_block_size;
+	/* The translated node id. NUMA_NO_NODE in case not specified. */
+	int nid;
+	/* Physical start address of the memory region. */
+	uint64_t addr;
+
+	/* The subblock size. */
+	uint32_t subblock_size;
+	/* The number of subblocks per memory block. */
+	uint32_t nb_sb_per_mb;
+
+	/* Id of the first memory block of this device. */
+	unsigned long first_mb_id;
+	/* Id of the last memory block of this device. */
+	unsigned long last_mb_id;
+	/* Id of the last usable memory block of this device. */
+	unsigned long last_usable_mb_id;
+	/* Id of the next memory bock to prepare when needed. */
+	unsigned long next_mb_id;
+
+	/* Summary of all memory block states. */
+	unsigned long nb_mb_state[VIRTIO_MEM_MB_STATE_COUNT];
+#define VIRTIO_MEM_NB_OFFLINE_THRESHOLD		10
+
+	/*
+	 * One byte state per memory block.
+	 *
+	 * Allocated via vmalloc(). When preparing new blocks, resized
+	 * (alloc+copy+free) when needed (crossing pages with the next mb).
+	 * (when crossing pages).
+	 *
+	 * With 128MB memory blocks, we have states for 512GB of memory in one
+	 * page.
+	 */
+	uint8_t *mb_state;
+
+	/*
+	 * $nb_sb_per_mb bit per memory block. Handled similar to mb_state.
+	 *
+	 * With 4MB subblocks, we manage 128GB of memory in one page.
+	 */
+	unsigned long *sb_bitmap;
+
+	/*
+	 * Mutex that protects the nb_mb_state, mb_state, and sb_bitmap.
+	 *
+	 * When this lock is held the pointers can't change, ONLINE and
+	 * OFFLINE blocks can't change the state and no subblocks will get
+	 * plugged.
+	 */
+	struct mutex hotplug_mutex;
+	bool hotplug_active;
+
+	/* An error ocurred we cannot handle - stop processing requests. */
+	bool broken;
+
+	/* The driver is being removed. */
+	spinlock_t removal_lock;
+	bool removing;
+
+	/* Timer for retrying to plug/unplug memory. */
+	struct hrtimer retry_timer;
+#define VIRTIO_MEM_RETRY_TIMER_MS		30000
+
+	/* Memory notifier (online/offline events). */
+	struct notifier_block memory_notifier;
+
+	/* Next device in the list of virtio-mem devices. */
+	struct list_head next;
+};
+
+/*
+ * We have to share a single online_page callback among all virtio-mem
+ * devices. We use RCU to iterate the list in the callback.
+ */
+static DEFINE_MUTEX(virtio_mem_mutex);
+static LIST_HEAD(virtio_mem_devices);
+
+static void virtio_mem_online_page_cb(struct page *page, unsigned int or=
der);
+
+/*
+ * Register a virtio-mem device so it will be considered for the online_=
page
+ * callback.
+ */
+static int register_virtio_mem_device(struct virtio_mem *vm)
+{
+	int rc =3D 0;
+
+	/* First device registers the callback. */
+	mutex_lock(&virtio_mem_mutex);
+	if (list_empty(&virtio_mem_devices))
+		rc =3D set_online_page_callback(&virtio_mem_online_page_cb);
+	if (!rc)
+		list_add_rcu(&vm->next, &virtio_mem_devices);
+	mutex_unlock(&virtio_mem_mutex);
+
+	return rc;
+}
+
+/*
+ * Unregister a virtio-mem device so it will no longer be considered for=
 the
+ * online_page callback.
+ */
+static void unregister_virtio_mem_device(struct virtio_mem *vm)
+{
+	/* Last device unregisters the callback. */
+	mutex_lock(&virtio_mem_mutex);
+	list_del_rcu(&vm->next);
+	if (list_empty(&virtio_mem_devices))
+		restore_online_page_callback(&virtio_mem_online_page_cb);
+	mutex_unlock(&virtio_mem_mutex);
+
+	synchronize_rcu();
+}
+
+/*
+ * Calculate the memory block id of a given address.
+ */
+static unsigned long virtio_mem_phys_to_mb_id(unsigned long addr)
+{
+	return addr / memory_block_size_bytes();
+}
+
+/*
+ * Calculate the physical start address of a given memory block id.
+ */
+static unsigned long virtio_mem_mb_id_to_phys(unsigned long mb_id)
+{
+	return mb_id * memory_block_size_bytes();
+}
+
+/*
+ * Calculate the subblock id of a given address.
+ */
+static unsigned long virtio_mem_phys_to_sb_id(struct virtio_mem *vm,
+					      unsigned long addr)
+{
+	const unsigned long mb_id =3D virtio_mem_phys_to_mb_id(addr);
+	const unsigned long mb_addr =3D virtio_mem_mb_id_to_phys(mb_id);
+
+	return (addr - mb_addr) / vm->subblock_size;
+}
+
+/*
+ * Set the state of a memory block, taking care of the state counter.
+ */
+static void virtio_mem_mb_set_state(struct virtio_mem *vm, unsigned long=
 mb_id,
+				    enum virtio_mem_mb_state state)
+{
+	const unsigned long idx =3D mb_id - vm->first_mb_id;
+	enum virtio_mem_mb_state old_state;
+
+	old_state =3D vm->mb_state[idx];
+	vm->mb_state[idx] =3D state;
+
+	BUG_ON(vm->nb_mb_state[old_state] =3D=3D 0);
+	vm->nb_mb_state[old_state]--;
+	vm->nb_mb_state[state]++;
+}
+
+/*
+ * Get the state of a memory block.
+ */
+static enum virtio_mem_mb_state virtio_mem_mb_get_state(struct virtio_me=
m *vm,
+							unsigned long mb_id)
+{
+	const unsigned long idx =3D mb_id - vm->first_mb_id;
+
+	return vm->mb_state[idx];
+}
+
+/*
+ * Prepare the state array for the next memory block.
+ */
+static int virtio_mem_mb_state_prepare_next_mb(struct virtio_mem *vm)
+{
+	unsigned long old_bytes =3D vm->next_mb_id - vm->first_mb_id + 1;
+	unsigned long new_bytes =3D vm->next_mb_id - vm->first_mb_id + 2;
+	int old_pages =3D PFN_UP(old_bytes);
+	int new_pages =3D PFN_UP(new_bytes);
+	uint8_t *new_mb_state;
+
+	if (vm->mb_state && old_pages =3D=3D new_pages)
+		return 0;
+
+	new_mb_state =3D vzalloc(new_pages * PAGE_SIZE);
+	if (!new_mb_state)
+		return -ENOMEM;
+
+	mutex_lock(&vm->hotplug_mutex);
+	if (vm->mb_state)
+		memcpy(new_mb_state, vm->mb_state, old_pages * PAGE_SIZE);
+	vfree(vm->mb_state);
+	vm->mb_state =3D new_mb_state;
+	mutex_unlock(&vm->hotplug_mutex);
+
+	return 0;
+}
+
+#define virtio_mem_for_each_mb_state(_vm, _mb_id, _state) \
+	for (_mb_id =3D _vm->first_mb_id; \
+	     _mb_id < _vm->next_mb_id && _vm->nb_mb_state[_state]; \
+	     _mb_id++) \
+		if (virtio_mem_mb_get_state(_vm, _mb_id) =3D=3D _state)
+
+/*
+ * Mark all selected subblocks plugged.
+ *
+ * Will not modify the state of the memory block.
+ */
+static void virtio_mem_mb_set_sb_plugged(struct virtio_mem *vm,
+					 unsigned long mb_id, int sb_id,
+					 int count)
+{
+	const int bit =3D (mb_id - vm->first_mb_id) * vm->nb_sb_per_mb + sb_id;
+
+	__bitmap_set(vm->sb_bitmap, bit, count);
+}
+
+/*
+ * Mark all selected subblocks unplugged.
+ *
+ * Will not modify the state of the memory block.
+ */
+static void virtio_mem_mb_set_sb_unplugged(struct virtio_mem *vm,
+					   unsigned long mb_id, int sb_id,
+					   int count)
+{
+	const int bit =3D (mb_id - vm->first_mb_id) * vm->nb_sb_per_mb + sb_id;
+
+	__bitmap_clear(vm->sb_bitmap, bit, count);
+}
+
+/*
+ * Test if all selected subblocks are plugged.
+ */
+static bool virtio_mem_mb_test_sb_plugged(struct virtio_mem *vm,
+					  unsigned long mb_id, int sb_id,
+					  int count)
+{
+	const int bit =3D (mb_id - vm->first_mb_id) * vm->nb_sb_per_mb + sb_id;
+
+	if (count =3D=3D 1)
+		return test_bit(bit, vm->sb_bitmap);
+
+	/* TODO: Helper similar to bitmap_set() */
+	return find_next_zero_bit(vm->sb_bitmap, bit + count, bit) >=3D
+	       bit + count;
+}
+
+/*
+ * Find the first plugged subblock. Returns vm->nb_sb_per_mb in case the=
re is
+ * none.
+ */
+static int virtio_mem_mb_first_plugged_sb(struct virtio_mem *vm,
+					  unsigned long mb_id)
+{
+	const int bit =3D (mb_id - vm->first_mb_id) * vm->nb_sb_per_mb;
+
+	return find_next_bit(vm->sb_bitmap, bit + vm->nb_sb_per_mb, bit) - bit;
+}
+
+/*
+ * Find the first unplugged subblock. Returns vm->nb_sb_per_mb in case t=
here is
+ * none.
+ */
+static int virtio_mem_mb_first_unplugged_sb(struct virtio_mem *vm,
+					    unsigned long mb_id)
+{
+	const int bit =3D (mb_id - vm->first_mb_id) * vm->nb_sb_per_mb;
+
+	return find_next_zero_bit(vm->sb_bitmap, bit + vm->nb_sb_per_mb, bit) -
+	       bit;
+}
+
+/*
+ * Prepare the subblock bitmap for the next memory block.
+ */
+static int virtio_mem_sb_bitmap_prepare_next_mb(struct virtio_mem *vm)
+{
+	const unsigned long old_nb_mb =3D vm->next_mb_id - vm->first_mb_id;
+	const unsigned long old_nb_bits =3D old_nb_mb * vm->nb_sb_per_mb;
+	const unsigned long new_nb_bits =3D (old_nb_mb + 1) * vm->nb_sb_per_mb;
+	int old_pages =3D PFN_UP(BITS_TO_LONGS(old_nb_bits) * sizeof(long));
+	int new_pages =3D PFN_UP(BITS_TO_LONGS(new_nb_bits) * sizeof(long));
+	unsigned long *new_sb_bitmap, *old_sb_bitmap;
+
+	if (vm->sb_bitmap && old_pages =3D=3D new_pages)
+		return 0;
+
+	new_sb_bitmap =3D vzalloc(new_pages * PAGE_SIZE);
+	if (!new_sb_bitmap)
+		return -ENOMEM;
+
+	mutex_lock(&vm->hotplug_mutex);
+	if (new_sb_bitmap)
+		memcpy(new_sb_bitmap, vm->sb_bitmap, old_pages * PAGE_SIZE);
+
+	old_sb_bitmap =3D vm->sb_bitmap;
+	vm->sb_bitmap =3D new_sb_bitmap;
+	mutex_unlock(&vm->hotplug_mutex);
+
+	vfree(old_sb_bitmap);
+	return 0;
+}
+
+/*
+ * Try to add a memory block to Linux. This will usually only fail
+ * if out of memory.
+ *
+ * Must not be called with the vm->hotplug_mutex held (possible deadlock=
 with
+ * onlining code).
+ *
+ * Will not modify the state of the memory block.
+ */
+static int virtio_mem_mb_add(struct virtio_mem *vm, unsigned long mb_id)
+{
+	const uint64_t addr =3D virtio_mem_mb_id_to_phys(mb_id);
+	int nid =3D vm->nid;
+
+	if (nid =3D=3D NUMA_NO_NODE)
+		nid =3D memory_add_physaddr_to_nid(addr);
+
+	dev_dbg(&vm->vdev->dev, "adding memory block: %lu\n", mb_id);
+	return add_memory(nid, addr, memory_block_size_bytes());
+}
+
+/*
+ * Try to remove a memory block from Linux. Will only fail if the memory=
 block
+ * is not offline.
+ *
+ * Must not be called with the vm->hotplug_mutex held (possible deadlock=
 with
+ * onlining code).
+ *
+ * Will not modify the state of the memory block.
+ */
+static int virtio_mem_mb_remove(struct virtio_mem *vm, unsigned long mb_=
id)
+{
+	const uint64_t addr =3D virtio_mem_mb_id_to_phys(mb_id);
+	int nid =3D vm->nid;
+
+	if (nid =3D=3D NUMA_NO_NODE)
+		nid =3D memory_add_physaddr_to_nid(addr);
+
+	dev_dbg(&vm->vdev->dev, "removing memory block: %lu\n", mb_id);
+	return remove_memory(nid, addr, memory_block_size_bytes());
+}
+
+/*
+ * Trigger the workqueue so the device can perform its magic.
+ */
+static void virtio_mem_retry(struct virtio_mem *vm)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&vm->removal_lock, flags);
+	if (!vm->removing)
+		queue_work(system_freezable_wq, &vm->wq);
+	spin_unlock_irqrestore(&vm->removal_lock, flags);
+}
+
+static int virtio_mem_translate_node_id(struct virtio_mem *vm, uint16_t =
node_id)
+{
+	int node =3D NUMA_NO_NODE;
+
+	if (IS_ENABLED(CONFIG_NUMA) && IS_ENABLED(CONFIG_ACPI_NUMA) &&
+	    virtio_has_feature(vm->vdev, VIRTIO_MEM_F_ACPI_PXM))
+		node =3D pxm_to_node(node_id);
+	return node;
+}
+
+/*
+ * Test if a virtio-mem device overlaps with the given range. Can be cal=
led
+ * from (notifier) callbacks lockless.
+ */
+static bool virtio_mem_overlaps_range(struct virtio_mem *vm,
+				      unsigned long start, unsigned long size)
+{
+	unsigned long dev_start =3D virtio_mem_mb_id_to_phys(vm->first_mb_id);
+	unsigned long dev_end =3D virtio_mem_mb_id_to_phys(vm->last_mb_id) +
+				memory_block_size_bytes();
+	unsigned long end =3D start + size;
+
+	return (start >=3D dev_start && start < dev_end) ||
+	       (end > dev_start && end <=3D dev_end) ||
+	       (start < dev_start && end > dev_end);
+}
+
+/*
+ * Test if a virtio-mem device owns a memory block. Can be called from
+ * (notifier) callbacks lockless.
+ */
+static bool virtio_mem_owned_mb(struct virtio_mem *vm, unsigned long mb_=
id)
+{
+	return mb_id >=3D vm->first_mb_id && mb_id <=3D vm->last_mb_id;
+}
+
+static int virtio_mem_notify_going_online(struct virtio_mem *vm,
+					  unsigned long mb_id,
+					  enum zone_type zone)
+{
+	switch (virtio_mem_mb_get_state(vm, mb_id)) {
+	case VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL:
+		/*
+		 * We won't allow to online a partially plugged memory block
+		 * to the MOVABLE zone - it would contain unmovable parts.
+		 */
+		if (zone =3D=3D ZONE_MOVABLE) {
+			dev_warn_ratelimited(&vm->vdev->dev,
+					     "memory block has holes, MOVABLE not supported\n");
+			return NOTIFY_BAD;
+		}
+		return NOTIFY_OK;
+	case VIRTIO_MEM_MB_STATE_OFFLINE:
+		return NOTIFY_OK;
+	default:
+		break;
+	}
+	dev_warn_ratelimited(&vm->vdev->dev,
+			     "memory block onlining denied\n");
+	return NOTIFY_BAD;
+}
+
+static void virtio_mem_notify_offline(struct virtio_mem *vm,
+				      unsigned long mb_id)
+{
+	switch (virtio_mem_mb_get_state(vm, mb_id)) {
+	case VIRTIO_MEM_MB_STATE_ONLINE_PARTIAL:
+		virtio_mem_mb_set_state(vm, mb_id,
+					VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL);
+		break;
+	case VIRTIO_MEM_MB_STATE_ONLINE:
+	case VIRTIO_MEM_MB_STATE_ONLINE_MOVABLE:
+		virtio_mem_mb_set_state(vm, mb_id,
+					VIRTIO_MEM_MB_STATE_OFFLINE);
+		break;
+	default:
+		BUG();
+		break;
+	}
+}
+
+static void virtio_mem_notify_online(struct virtio_mem *vm, unsigned lon=
g mb_id,
+				     enum zone_type zone)
+{
+	unsigned long nb_offline;
+
+	switch (virtio_mem_mb_get_state(vm, mb_id)) {
+	case VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL:
+		BUG_ON(zone =3D=3D ZONE_MOVABLE);
+		virtio_mem_mb_set_state(vm, mb_id,
+					VIRTIO_MEM_MB_STATE_ONLINE_PARTIAL);
+		break;
+	case VIRTIO_MEM_MB_STATE_OFFLINE:
+		if (zone =3D=3D ZONE_MOVABLE)
+			virtio_mem_mb_set_state(vm, mb_id,
+						VIRTIO_MEM_MB_STATE_ONLINE_MOVABLE);
+		else
+			virtio_mem_mb_set_state(vm, mb_id,
+						VIRTIO_MEM_MB_STATE_ONLINE);
+		break;
+	default:
+		BUG();
+		break;
+	}
+	nb_offline =3D vm->nb_mb_state[VIRTIO_MEM_MB_STATE_OFFLINE] +
+		     vm->nb_mb_state[VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL];
+
+	/* see if we can add new blocks now that we onlined one block */
+	if (nb_offline =3D=3D VIRTIO_MEM_NB_OFFLINE_THRESHOLD - 1)
+		virtio_mem_retry(vm);
+}
+
+/*
+ * This callback will either be called synchonously from add_memory() or
+ * asynchronously (e.g., triggered via user space). We have to be carefu=
l
+ * with locking when calling add_memory().
+ */
+static int virtio_mem_memory_notifier_cb(struct notifier_block *nb,
+					 unsigned long action, void *arg)
+{
+	struct virtio_mem *vm =3D container_of(nb, struct virtio_mem,
+					     memory_notifier);
+	struct memory_notify *mhp =3D arg;
+	const unsigned long start =3D PFN_PHYS(mhp->start_pfn);
+	const unsigned long size =3D PFN_PHYS(mhp->nr_pages);
+	const unsigned long mb_id =3D virtio_mem_phys_to_mb_id(start);
+	enum zone_type zone;
+	int rc =3D NOTIFY_OK;
+
+	/*
+	 * Memory is usually onlined/offlined in memory block granularity
+	 * (via device_online()/device_offline()). This means, we
+	 * cannot cross virtio-mem device boundaries and memory block
+	 * boundaries.
+	 *
+	 * Only obscure users (powernv/memtrace.c) play dirty games
+	 * manually with offline_pages() with multiple memory blocks -
+	 * let's NACK these requests in case virtio-mem is involved.
+	 */
+	if (size !=3D memory_block_size_bytes() ||
+	    !IS_ALIGNED(start, memory_block_size_bytes())) {
+		if (virtio_mem_overlaps_range(vm, start, size))
+			return NOTIFY_BAD;
+		return NOTIFY_DONE;
+	}
+
+	if (!virtio_mem_owned_mb(vm, mb_id))
+		return NOTIFY_DONE;
+
+	switch (action) {
+	case MEM_GOING_OFFLINE:
+		spin_lock_irq(&vm->removal_lock);
+		if (vm->removing)
+			rc =3D notifier_to_errno(-EBUSY);
+		spin_unlock_irq(&vm->removal_lock);
+		if (rc !=3D NOTIFY_OK)
+			break;
+		mutex_lock(&vm->hotplug_mutex);
+		vm->hotplug_active =3D true;
+		break;
+	case MEM_GOING_ONLINE:
+		spin_lock_irq(&vm->removal_lock);
+		if (vm->removing)
+			rc =3D notifier_to_errno(-EBUSY);
+		spin_unlock_irq(&vm->removal_lock);
+		if (rc !=3D NOTIFY_OK)
+			break;
+		mutex_lock(&vm->hotplug_mutex);
+		vm->hotplug_active =3D true;
+		zone =3D page_zonenum(pfn_to_page(mhp->start_pfn));
+		rc =3D virtio_mem_notify_going_online(vm, mb_id, zone);
+		break;
+	case MEM_OFFLINE:
+		virtio_mem_notify_offline(vm, mb_id);
+		vm->hotplug_active =3D false;
+		mutex_unlock(&vm->hotplug_mutex);
+		break;
+	case MEM_ONLINE:
+		zone =3D page_zonenum(pfn_to_page(mhp->start_pfn));
+		virtio_mem_notify_online(vm, mb_id, zone);
+		vm->hotplug_active =3D false;
+		mutex_unlock(&vm->hotplug_mutex);
+		break;
+	case MEM_CANCEL_OFFLINE:
+	case MEM_CANCEL_ONLINE:
+		if (!vm->hotplug_active)
+			break;
+		vm->hotplug_active =3D false;
+		mutex_unlock(&vm->hotplug_mutex);
+		break;
+	default:
+		break;
+	}
+
+	return rc;
+}
+
+/*
+ * Set a range of pages PG_offline.
+ */
+static void virtio_mem_set_fake_offline(unsigned long pfn,
+					unsigned int nr_pages)
+{
+	for (; nr_pages--; pfn++)
+		__SetPageOffline(pfn_to_page(pfn));
+}
+
+/*
+ * Clear PG_offline from a range of pages.
+ */
+static void virtio_mem_clear_fake_offline(unsigned long pfn,
+					  unsigned int nr_pages)
+{
+	for (; nr_pages--; pfn++)
+		__ClearPageOffline(pfn_to_page(pfn));
+}
+
+/*
+ * Release a range of fake-offline pages to the buddy, effectively
+ * fake-onlining them.
+ */
+static void virtio_mem_fake_online(unsigned long pfn, unsigned int nr_pa=
ges)
+{
+	const int order =3D MAX_ORDER - 1;
+	int i;
+
+	/*
+	 * We are always called with subblock granularity, which is at least
+	 * aligned to MAX_ORDER - 1.
+	 */
+	BUG_ON(!IS_ALIGNED(pfn, 1 << order));
+	BUG_ON(!IS_ALIGNED(nr_pages, 1 << order));
+
+	virtio_mem_clear_fake_offline(pfn, nr_pages);
+
+	for (i =3D 0; i < nr_pages; i +=3D 1 << order)
+		generic_online_page(pfn_to_page(pfn + i), order);
+}
+
+static void virtio_mem_online_page_cb(struct page *page, unsigned int or=
der)
+{
+	const unsigned long addr =3D page_to_phys(page);
+	const unsigned long mb_id =3D virtio_mem_phys_to_mb_id(addr);
+	struct virtio_mem *vm;
+	int sb_id;
+
+	/*
+	 * We exploit here that subblocks have at least MAX_ORDER - 1
+	 * size/alignment and that this callback is is called with such a
+	 * size/alignment. So we cannot cross subblocks and therefore
+	 * also not memory blocks.
+	 */
+	rcu_read_lock();
+	list_for_each_entry_rcu(vm, &virtio_mem_devices, next) {
+		if (!virtio_mem_owned_mb(vm, mb_id))
+			continue;
+
+		sb_id =3D virtio_mem_phys_to_sb_id(vm, addr);
+		/*
+		 * If plugged, online the pages, otherwise, set them fake
+		 * offline (PageOffline).
+		 */
+		if (virtio_mem_mb_test_sb_plugged(vm, mb_id, sb_id, 1))
+			generic_online_page(page, order);
+		else
+			virtio_mem_set_fake_offline(PFN_DOWN(addr), 1 << order);
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	/* not virtio-mem memory, but e.g., a DIMM. online it */
+	generic_online_page(page, order);
+}
+
+static uint64_t virtio_mem_send_request(struct virtio_mem *vm,
+					const struct virtio_mem_req *req)
+{
+	struct scatterlist *sgs[2], sg_req, sg_resp;
+	unsigned int len;
+	int rc;
+
+	/* don't use the request residing on the stack (vaddr) */
+	vm->req =3D *req;
+
+	/* out: buffer for request */
+	sg_init_one(&sg_req, &vm->req, sizeof(vm->req));
+	sgs[0] =3D &sg_req;
+
+	/* in: buffer for response */
+	sg_init_one(&sg_resp, &vm->resp, sizeof(vm->resp));
+	sgs[1] =3D &sg_resp;
+
+	rc =3D virtqueue_add_sgs(vm->vq, sgs, 1, 1, vm, GFP_KERNEL);
+	if (rc < 0)
+		return rc;
+
+	virtqueue_kick(vm->vq);
+
+	/* wait for a response */
+	wait_event(vm->host_resp, virtqueue_get_buf(vm->vq, &len));
+
+	return virtio16_to_cpu(vm->vdev, vm->resp.type);
+}
+
+static int virtio_mem_send_plug_request(struct virtio_mem *vm, uint64_t =
addr,
+					uint64_t size)
+{
+	const uint64_t nb_vm_blocks =3D size / vm->device_block_size;
+	const struct virtio_mem_req req =3D {
+		.type =3D cpu_to_virtio16(vm->vdev, VIRTIO_MEM_REQ_PLUG),
+		.u.plug.addr =3D cpu_to_virtio64(vm->vdev, addr),
+		.u.plug.nb_blocks =3D cpu_to_virtio16(vm->vdev, nb_vm_blocks),
+	};
+
+	if (atomic_read(&vm->config_changed))
+		return -EAGAIN;
+
+	switch (virtio_mem_send_request(vm, &req)) {
+	case VIRTIO_MEM_RESP_ACK:
+		vm->plugged_size +=3D size;
+		return 0;
+	case VIRTIO_MEM_RESP_NACK:
+		return -EAGAIN;
+	case VIRTIO_MEM_RESP_BUSY:
+		return -EBUSY;
+	case VIRTIO_MEM_RESP_ERROR:
+		return -EINVAL;
+	default:
+		return -ENOMEM;
+	}
+}
+
+static int virtio_mem_send_unplug_request(struct virtio_mem *vm, uint64_=
t addr,
+					  uint64_t size)
+{
+	const uint64_t nb_vm_blocks =3D size / vm->device_block_size;
+	const struct virtio_mem_req req =3D {
+		.type =3D cpu_to_virtio16(vm->vdev, VIRTIO_MEM_REQ_UNPLUG),
+		.u.unplug.addr =3D cpu_to_virtio64(vm->vdev, addr),
+		.u.unplug.nb_blocks =3D cpu_to_virtio16(vm->vdev, nb_vm_blocks),
+	};
+
+	if (atomic_read(&vm->config_changed))
+		return -EAGAIN;
+
+	switch (virtio_mem_send_request(vm, &req)) {
+	case VIRTIO_MEM_RESP_ACK:
+		vm->plugged_size -=3D size;
+		return 0;
+	case VIRTIO_MEM_RESP_BUSY:
+		return -EBUSY;
+	case VIRTIO_MEM_RESP_ERROR:
+		return -EINVAL;
+	default:
+		return -ENOMEM;
+	}
+}
+
+static int virtio_mem_send_unplug_all_request(struct virtio_mem *vm)
+{
+	const struct virtio_mem_req req =3D {
+		.type =3D cpu_to_virtio16(vm->vdev, VIRTIO_MEM_REQ_UNPLUG_ALL),
+	};
+
+	switch (virtio_mem_send_request(vm, &req)) {
+	case VIRTIO_MEM_RESP_ACK:
+		vm->unplug_all_required =3D false;
+		vm->plugged_size =3D 0;
+		/* usable region might have shrunk */
+		atomic_set(&vm->config_changed, 1);
+		return 0;
+	case VIRTIO_MEM_RESP_BUSY:
+		return -EBUSY;
+	default:
+		return -ENOMEM;
+	}
+}
+
+/*
+ * Plug selected subblocks. Updates the plugged state, but not the state
+ * of the memory block.
+ */
+static int virtio_mem_mb_plug_sb(struct virtio_mem *vm, unsigned long mb=
_id,
+				 int sb_id, int count)
+{
+	const uint64_t addr =3D virtio_mem_mb_id_to_phys(mb_id) +
+			      sb_id * vm->subblock_size;
+	const uint64_t size =3D count * vm->subblock_size;
+	int rc;
+
+	dev_dbg(&vm->vdev->dev, "plugging memory block: %lu : %i - %i\n", mb_id=
,
+		sb_id, sb_id + count - 1);
+
+	rc =3D virtio_mem_send_plug_request(vm, addr, size);
+	if (!rc)
+		virtio_mem_mb_set_sb_plugged(vm, mb_id, sb_id, count);
+	return rc;
+}
+
+/*
+ * Unplug selected subblocks. Updates the plugged state, but not the sta=
te
+ * of the memory block.
+ */
+static int virtio_mem_mb_unplug_sb(struct virtio_mem *vm, unsigned long =
mb_id,
+				   int sb_id, int count)
+{
+	const uint64_t addr =3D virtio_mem_mb_id_to_phys(mb_id) +
+			      sb_id * vm->subblock_size;
+	const uint64_t size =3D count * vm->subblock_size;
+	int rc;
+
+	dev_dbg(&vm->vdev->dev, "unplugging memory block: %lu : %i - %i\n",
+		mb_id, sb_id, sb_id + count - 1);
+
+	rc =3D virtio_mem_send_unplug_request(vm, addr, size);
+	if (!rc)
+		virtio_mem_mb_set_sb_unplugged(vm, mb_id, sb_id, count);
+	return rc;
+}
+
+/*
+ * Unplug the desired number of plugged subblocks of a offline or unadde=
d
+ * memory block. Will fail if any subblock cannot get unplugged (instead=
 of
+ * skipping it).
+ *
+ * Will not modify the state of the memory block.
+ *
+ * Note: can fail after some subblocks were unplugged.
+ */
+static int virtio_mem_mb_unplug_any_sb(struct virtio_mem *vm,
+				       unsigned long mb_id, uint64_t *nb_sb)
+{
+	int sb_id, count;
+	int rc;
+
+	while (*nb_sb) {
+		sb_id =3D virtio_mem_mb_first_plugged_sb(vm, mb_id);
+		if (sb_id >=3D vm->nb_sb_per_mb)
+			break;
+		count =3D 1;
+		while (count < *nb_sb &&
+		       sb_id + count  < vm->nb_sb_per_mb &&
+		       virtio_mem_mb_test_sb_plugged(vm, mb_id, sb_id + count,
+						     1))
+			count++;
+
+		rc =3D virtio_mem_mb_unplug_sb(vm, mb_id, sb_id, count);
+		if (rc)
+			return rc;
+		*nb_sb -=3D count;
+	}
+
+	return 0;
+}
+
+/*
+ * Unplug all plugged subblocks of an offline or unadded memory block.
+ *
+ * Will not modify the state of the memory block.
+ *
+ * Note: can fail after some subblocks were unplugged.
+ */
+static int virtio_mem_mb_unplug(struct virtio_mem *vm, unsigned long mb_=
id)
+{
+	uint64_t nb_sb =3D vm->nb_sb_per_mb;
+
+	return virtio_mem_mb_unplug_any_sb(vm, mb_id, &nb_sb);
+}
+
+/*
+ * Prepare tracking data for the next memory block.
+ */
+static int virtio_mem_prepare_next_mb(struct virtio_mem *vm,
+				      unsigned long *mb_id)
+{
+	int rc;
+
+	if (vm->next_mb_id > vm->last_usable_mb_id)
+		return -ENOSPC;
+
+	/* Resize the state array if required. */
+	rc =3D virtio_mem_mb_state_prepare_next_mb(vm);
+	if (rc)
+		return rc;
+
+	/* Resize the subblock bitmap if required. */
+	rc =3D virtio_mem_sb_bitmap_prepare_next_mb(vm);
+	if (rc)
+		return rc;
+
+	vm->nb_mb_state[VIRTIO_MEM_MB_STATE_UNUSED]++;
+	*mb_id =3D vm->next_mb_id++;
+	return 0;
+}
+
+/*
+ * Don't add too many blocks that are not onlined yet to avoid running O=
OM.
+ */
+static bool virtio_mem_too_many_mb_offline(struct virtio_mem *vm)
+{
+	unsigned long nb_offline;
+
+	nb_offline =3D vm->nb_mb_state[VIRTIO_MEM_MB_STATE_OFFLINE] +
+		     vm->nb_mb_state[VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL];
+	return nb_offline >=3D VIRTIO_MEM_NB_OFFLINE_THRESHOLD;
+}
+
+/*
+ * Try to plug the desired number of subblocks and add the memory block
+ * to Linux.
+ *
+ * Will modify the state of the memory block.
+ */
+static int virtio_mem_mb_plug_and_add(struct virtio_mem *vm,
+				      unsigned long mb_id,
+				      uint64_t *nb_sb)
+{
+	const int count =3D min_t(int, *nb_sb, vm->nb_sb_per_mb);
+	int rc, rc2;
+
+	if (WARN_ON_ONCE(!count))
+		return -EINVAL;
+
+	/*
+	 * Plug the requested number of subblocks before adding it to linux,
+	 * so that onlining will directly online all plugged subblocks.
+	 */
+	rc =3D virtio_mem_mb_plug_sb(vm, mb_id, 0, count);
+	if (rc)
+		return rc;
+
+	/*
+	 * Mark the block properly offline before adding it to Linux,
+	 * so the memory notifiers will find the block in the right state.
+	 */
+	if (count =3D=3D vm->nb_sb_per_mb)
+		virtio_mem_mb_set_state(vm, mb_id,
+					VIRTIO_MEM_MB_STATE_OFFLINE);
+	else
+		virtio_mem_mb_set_state(vm, mb_id,
+					VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL);
+
+	/* Add the memory block to linux - if that fails, try to unplug. */
+	rc =3D virtio_mem_mb_add(vm, mb_id);
+	if (rc) {
+		enum virtio_mem_mb_state new_state =3D VIRTIO_MEM_MB_STATE_UNUSED;
+
+		dev_err(&vm->vdev->dev,
+			"adding memory block %lu failed with %d\n", mb_id, rc);
+		rc2 =3D virtio_mem_mb_unplug_sb(vm, mb_id, 0, count);
+
+		/*
+		 * TODO: Linux MM does not properly clean up yet in all cases
+		 * where adding of memory failed - especially on -ENOMEM.
+		 */
+		if (rc2)
+			new_state =3D VIRTIO_MEM_MB_STATE_PLUGGED;
+		virtio_mem_mb_set_state(vm, mb_id, new_state);
+		return rc;
+	}
+
+	*nb_sb -=3D count;
+	return 0;
+}
+
+/*
+ * Try to plug the desired number of subblocks of a memory block that
+ * is already added to Linux.
+ *
+ * Will modify the state of the memory block.
+ *
+ * Note: Can fail after some subblocks were successfully plugged.
+ */
+static int virtio_mem_mb_plug_any_sb(struct virtio_mem *vm, unsigned lon=
g mb_id,
+				     uint64_t *nb_sb, bool online)
+{
+	unsigned long pfn, nr_pages;
+	int sb_id, count;
+	int rc;
+
+	if (WARN_ON_ONCE(!*nb_sb))
+		return -EINVAL;
+
+	while (*nb_sb) {
+		sb_id =3D virtio_mem_mb_first_unplugged_sb(vm, mb_id);
+		if (sb_id >=3D vm->nb_sb_per_mb)
+			break;
+		count =3D 1;
+		while (count < *nb_sb &&
+		       sb_id + count < vm->nb_sb_per_mb &&
+		       !virtio_mem_mb_test_sb_plugged(vm, mb_id, sb_id + count,
+						      1))
+			count++;
+
+		rc =3D virtio_mem_mb_plug_sb(vm, mb_id, sb_id, count);
+		if (rc)
+			return rc;
+		*nb_sb -=3D count;
+		if (!online)
+			continue;
+
+		/* fake-online the pages if the memory block is online */
+		pfn =3D PFN_DOWN(virtio_mem_mb_id_to_phys(mb_id) +
+			       sb_id * vm->subblock_size);
+		nr_pages =3D PFN_DOWN(count * vm->subblock_size);
+		virtio_mem_fake_online(pfn, nr_pages);
+	}
+
+	if (virtio_mem_mb_test_sb_plugged(vm, mb_id, 0, vm->nb_sb_per_mb)) {
+		if (online)
+			virtio_mem_mb_set_state(vm, mb_id,
+						VIRTIO_MEM_MB_STATE_ONLINE);
+		else
+			virtio_mem_mb_set_state(vm, mb_id,
+						VIRTIO_MEM_MB_STATE_OFFLINE);
+	}
+
+	return rc;
+}
+
+/*
+ * Try to plug the requested amount of memory.
+ */
+static int virtio_mem_plug_request(struct virtio_mem *vm, uint64_t diff)
+{
+	uint64_t nb_sb =3D diff / vm->subblock_size;
+	unsigned long mb_id;
+	int rc;
+
+	if (!nb_sb)
+		return 0;
+
+	/* Don't race with onlining/offlining */
+	mutex_lock(&vm->hotplug_mutex);
+
+	/* Try to plug subblocks of partially plugged online blocks. */
+	virtio_mem_for_each_mb_state(vm, mb_id,
+				     VIRTIO_MEM_MB_STATE_ONLINE_PARTIAL) {
+		rc =3D virtio_mem_mb_plug_any_sb(vm, mb_id, &nb_sb, true);
+		if (rc || !nb_sb)
+			goto out_unlock;
+		cond_resched();
+	}
+
+	/* Try to plug subblocks of partially plugged offline blocks. */
+	virtio_mem_for_each_mb_state(vm, mb_id,
+				     VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL) {
+		rc =3D virtio_mem_mb_plug_any_sb(vm, mb_id, &nb_sb, false);
+		if (rc || !nb_sb)
+			goto out_unlock;
+		cond_resched();
+	}
+
+	/*
+	 * We won't be working on online/offline memory blocks from this point,
+	 * so we can't race with memory onlining/offlining. Drop the mutex.
+	 */
+	mutex_unlock(&vm->hotplug_mutex);
+
+	/* Try to plug and add unused blocks */
+	virtio_mem_for_each_mb_state(vm, mb_id, VIRTIO_MEM_MB_STATE_UNUSED) {
+		if (virtio_mem_too_many_mb_offline(vm))
+			return -ENOSPC;
+
+		rc =3D virtio_mem_mb_plug_and_add(vm, mb_id, &nb_sb);
+		if (rc || !nb_sb)
+			return rc;
+		cond_resched();
+	}
+
+	/* Try to prepare, plug and add new blocks */
+	while (nb_sb) {
+		if (virtio_mem_too_many_mb_offline(vm))
+			return -ENOSPC;
+
+		rc =3D virtio_mem_prepare_next_mb(vm, &mb_id);
+		if (rc)
+			return rc;
+		rc =3D virtio_mem_mb_plug_and_add(vm, mb_id, &nb_sb);
+		if (rc)
+			return rc;
+		cond_resched();
+	}
+
+	return 0;
+out_unlock:
+	mutex_unlock(&vm->hotplug_mutex);
+	return rc;
+}
+
+/*
+ * Try to unplug all blocks that couldn't be unplugged before, for examp=
le,
+ * because the hypervisor was busy.
+ */
+static int virtio_mem_unplug_pending_mb(struct virtio_mem *vm)
+{
+	unsigned long mb_id;
+	int rc;
+
+	virtio_mem_for_each_mb_state(vm, mb_id, VIRTIO_MEM_MB_STATE_PLUGGED) {
+		rc =3D virtio_mem_mb_unplug(vm, mb_id);
+		if (rc)
+			return rc;
+		virtio_mem_mb_set_state(vm, mb_id, VIRTIO_MEM_MB_STATE_UNUSED);
+	}
+
+	return 0;
+}
+
+/*
+ * Update all parts of the config that could have changed.
+ */
+static void virtio_mem_refresh_config(struct virtio_mem *vm)
+{
+	const uint64_t phys_limit =3D 1UL << MAX_PHYSMEM_BITS;
+	uint64_t new_plugged_size, usable_region_size, end_addr;
+
+	/* the plugged_size is just a reflection of what _we_ did previously */
+	virtio_cread(vm->vdev, struct virtio_mem_config, plugged_size,
+		     &new_plugged_size);
+	if (WARN_ON_ONCE(new_plugged_size !=3D vm->plugged_size))
+		vm->plugged_size =3D new_plugged_size;
+
+	/* calculate the last usable memory block id */
+	virtio_cread(vm->vdev, struct virtio_mem_config,
+		     usable_region_size, &usable_region_size);
+	end_addr =3D vm->addr + usable_region_size;
+	end_addr =3D min(end_addr, phys_limit);
+	vm->last_usable_mb_id =3D virtio_mem_phys_to_mb_id(end_addr) - 1;
+
+	/* see if there is a request to change the size */
+	virtio_cread(vm->vdev, struct virtio_mem_config, requested_size,
+		     &vm->requested_size);
+
+	dev_info(&vm->vdev->dev, "plugged size: 0x%llx", vm->plugged_size);
+	dev_info(&vm->vdev->dev, "requested size: 0x%llx", vm->requested_size);
+}
+
+/*
+ * Workqueue function for handling plug/unplug requests and config updat=
es.
+ */
+static void virtio_mem_run_wq(struct work_struct *work)
+{
+	struct virtio_mem *vm =3D container_of(work, struct virtio_mem, wq);
+	uint64_t diff;
+	int rc =3D 0;
+
+	hrtimer_cancel(&vm->retry_timer);
+
+	if (vm->broken)
+		return;
+
+	/* Make sure we start with a clean state if there are leftovers. */
+	if (unlikely(vm->unplug_all_required))
+		rc =3D virtio_mem_send_unplug_all_request(vm);
+
+config_update:
+	if (atomic_read(&vm->config_changed)) {
+		atomic_set(&vm->config_changed, 0);
+		virtio_mem_refresh_config(vm);
+	}
+
+	/* Unplug any leftovers from previous runs */
+	if (!rc)
+		rc =3D virtio_mem_unplug_pending_mb(vm);
+
+	if (!rc && vm->requested_size !=3D vm->plugged_size) {
+		if (vm->requested_size > vm->plugged_size) {
+			diff =3D vm->requested_size - vm->plugged_size;
+			rc =3D virtio_mem_plug_request(vm, diff);
+		}
+		/* TODO: try to unplug memory */
+	}
+
+	switch (rc) {
+	case 0:
+		break;
+	case -ENOSPC:
+		/*
+		 * We cannot add any more memory (alignment, physical limit)
+		 * or we have too many offline memory blocks.
+		 */
+		break;
+	case -EBUSY:
+		/*
+		 * The hypervisor cannot process our request right now
+		 * (e.g., out of memory, migrating).
+		 */
+	case -ENOMEM:
+		/* Out of memory, try again later. */
+		hrtimer_start(&vm->retry_timer,
+			      ms_to_ktime(VIRTIO_MEM_RETRY_TIMER_MS),
+			      HRTIMER_MODE_REL);
+		break;
+	case -EAGAIN:
+		/* Retry immediately (e.g., the config changed). */
+		goto config_update;
+	default:
+		/* Unknown error, mark as broken */
+		dev_err(&vm->vdev->dev,
+			"unknown error, marking device broken: %d\n", rc);
+		vm->broken =3D true;
+	}
+}
+
+static enum hrtimer_restart virtio_mem_timer_expired(struct hrtimer *tim=
er)
+{
+	struct virtio_mem *vm =3D container_of(timer, struct virtio_mem,
+					     retry_timer);
+
+	virtio_mem_retry(vm);
+	return HRTIMER_NORESTART;
+}
+
+static void virtio_mem_handle_response(struct virtqueue *vq)
+{
+	struct virtio_mem *vm =3D vq->vdev->priv;
+
+	wake_up(&vm->host_resp);
+}
+
+static int virtio_mem_init_vq(struct virtio_mem *vm)
+{
+	struct virtqueue *vq;
+
+	vq =3D virtio_find_single_vq(vm->vdev, virtio_mem_handle_response,
+				   "guest-request");
+	if (IS_ERR(vq))
+		return PTR_ERR(vq);
+	vm->vq =3D vq;
+
+	return 0;
+}
+
+/*
+ * Test if any memory in the range is present in Linux.
+ */
+static bool virtio_mem_any_memory_present(unsigned long start,
+					  unsigned long size)
+{
+	const unsigned long start_pfn =3D PFN_DOWN(start);
+	const unsigned long end_pfn =3D PFN_UP(start + size);
+	unsigned long pfn;
+
+	for (pfn =3D start_pfn; pfn !=3D end_pfn; pfn++)
+		if (present_section_nr(pfn_to_section_nr(pfn)))
+			return true;
+
+	return false;
+}
+
+static int virtio_mem_init(struct virtio_mem *vm)
+{
+	const uint64_t phys_limit =3D 1UL << MAX_PHYSMEM_BITS;
+	uint64_t region_size;
+	uint16_t node_id;
+
+	if (!vm->vdev->config->get) {
+		dev_err(&vm->vdev->dev, "config access disabled\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * We don't want to (un)plug or reuse any memory when in kdump. The
+	 * memory is still accessible (but not mapped).
+	 */
+	if (is_kdump_kernel()) {
+		dev_warn(&vm->vdev->dev, "disabled in kdump kernel\n");
+		return -EBUSY;
+	}
+
+	/* Fetch all properties that can't change. */
+	virtio_cread(vm->vdev, struct virtio_mem_config, plugged_size,
+		     &vm->plugged_size);
+	virtio_cread(vm->vdev, struct virtio_mem_config, block_size,
+		     &vm->device_block_size);
+	virtio_cread(vm->vdev, struct virtio_mem_config, node_id,
+		     &node_id);
+	vm->nid =3D virtio_mem_translate_node_id(vm, node_id);
+	virtio_cread(vm->vdev, struct virtio_mem_config, addr, &vm->addr);
+	virtio_cread(vm->vdev, struct virtio_mem_config, region_size,
+		     &region_size);
+
+	/*
+	 * If we still have memory plugged, we might have to unplug all
+	 * memory first. However, if somebody simply unloaded the driver
+	 * we would have to reinitialize the old state - something we don't
+	 * support yet. Detect if we have any memory in the area present.
+	 */
+	if (vm->plugged_size) {
+		uint64_t usable_region_size;
+
+		virtio_cread(vm->vdev, struct virtio_mem_config,
+			     usable_region_size, &usable_region_size);
+
+		if (virtio_mem_any_memory_present(vm->addr,
+						  usable_region_size)) {
+			dev_err(&vm->vdev->dev,
+				"reloading the driver is not supported\n");
+			return -EINVAL;
+		}
+		/*
+		 * Note: it might happen that the device is busy and
+		 * unplugging all memory might take some time.
+		 */
+		dev_info(&vm->vdev->dev, "unplugging all memory required\n");
+		vm->unplug_all_required =3D 1;
+	}
+
+	/*
+	 * We always hotplug memory in memory block granularity. This way,
+	 * we have to wait for exactly one memory block to online.
+	 */
+	if (vm->device_block_size > memory_block_size_bytes()) {
+		dev_err(&vm->vdev->dev,
+			"The block size is not supported (too big).\n");
+		return -EINVAL;
+	}
+
+	/* bad device setup - warn only */
+	if (!IS_ALIGNED(vm->addr, memory_block_size_bytes()))
+		dev_warn(&vm->vdev->dev,
+			 "The alignment of the physical start address can make some memory un=
usable.\n");
+	if (!IS_ALIGNED(vm->addr + region_size, memory_block_size_bytes()))
+		dev_warn(&vm->vdev->dev,
+			 "The alignment of the physical end address can make some memory unus=
able.\n");
+	if (vm->addr + region_size > phys_limit)
+		dev_warn(&vm->vdev->dev,
+			 "Some memory is not addressable. This can make some memory unusable.=
\n");
+
+	/*
+	 * Calculate the subblock size:
+	 * - At least MAX_ORDER - 1 / pageblock_order.
+	 * - At least the device block size.
+	 * In the worst case, a single subblock per memory block.
+	 */
+	vm->subblock_size =3D PAGE_SIZE * 1u << max_t(uint32_t, MAX_ORDER - 1,
+						    pageblock_order);
+	vm->subblock_size =3D max_t(uint32_t, vm->device_block_size,
+				  vm->subblock_size);
+	vm->nb_sb_per_mb =3D memory_block_size_bytes() / vm->subblock_size;
+
+	/* Round up to the next full memory block */
+	vm->first_mb_id =3D virtio_mem_phys_to_mb_id(vm->addr - 1 +
+						   memory_block_size_bytes());
+	vm->next_mb_id =3D vm->first_mb_id;
+	vm->last_mb_id =3D virtio_mem_phys_to_mb_id(vm->addr + region_size) - 1=
;
+
+	dev_info(&vm->vdev->dev, "start address: 0x%llx", vm->addr);
+	dev_info(&vm->vdev->dev, "region size: 0x%llx", region_size);
+	dev_info(&vm->vdev->dev, "device block size: 0x%x",
+		 vm->device_block_size);
+	dev_info(&vm->vdev->dev, "memory block size: 0x%lx",
+		 memory_block_size_bytes());
+	dev_info(&vm->vdev->dev, "subblock size: 0x%x",
+		 vm->subblock_size);
+
+	return 0;
+}
+
+static int virtio_mem_probe(struct virtio_device *vdev)
+{
+	struct virtio_mem *vm;
+	int rc =3D -EINVAL;
+
+	vdev->priv =3D vm =3D kzalloc(sizeof(*vm), GFP_KERNEL);
+	if (!vm)
+		return -ENOMEM;
+
+	init_waitqueue_head(&vm->host_resp);
+	vm->vdev =3D vdev;
+	INIT_WORK(&vm->wq, virtio_mem_run_wq);
+	mutex_init(&vm->hotplug_mutex);
+	/*
+	 * Avoid circular locking lockdep warnings. We lock the mutex
+	 * e.g., in MEM_GOING_ONLINE and unlock it in MEM_ONLINE. The
+	 * blocking_notifier_call_chain() has it's own lock, which gets unlocke=
d
+	 * between both notifier calls.
+	 */
+	lockdep_set_novalidate_class(&vm->hotplug_mutex);
+	INIT_LIST_HEAD(&vm->next);
+	spin_lock_init(&vm->removal_lock);
+	hrtimer_init(&vm->retry_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	vm->retry_timer.function =3D virtio_mem_timer_expired;
+
+	/* register the virtqueue */
+	rc =3D virtio_mem_init_vq(vm);
+	if (rc)
+		goto out_free_vm;
+
+	/* initialize the device by querying the config */
+	rc =3D virtio_mem_init(vm);
+	if (rc)
+		goto out_del_vq;
+
+	/* register callbacks */
+	vm->memory_notifier.notifier_call =3D virtio_mem_memory_notifier_cb;
+	rc =3D register_memory_notifier(&vm->memory_notifier);
+	if (rc)
+		goto out_del_vq;
+	rc =3D register_virtio_mem_device(vm);
+	if (rc)
+		goto out_unreg_mem;
+
+	virtio_device_ready(vdev);
+
+	/* trigger a config update to start processing the requested_size */
+	atomic_set(&vm->config_changed, 1);
+	queue_work(system_freezable_wq, &vm->wq);
+
+	return 0;
+out_unreg_mem:
+	unregister_memory_notifier(&vm->memory_notifier);
+out_del_vq:
+	vdev->config->del_vqs(vdev);
+out_free_vm:
+	kfree(vm);
+	vdev->priv =3D NULL;
+
+	return rc;
+}
+
+static void virtio_mem_remove(struct virtio_device *vdev)
+{
+	struct virtio_mem *vm =3D vdev->priv;
+	unsigned long mb_id;
+	int rc;
+
+	/*
+	 * Make sure the workqueue won't be triggered anymore and no memory
+	 * blocks can be onlined/offlined until we're finished here.
+	 */
+	spin_lock_irq(&vm->removal_lock);
+	vm->removing =3D true;
+	spin_unlock_irq(&vm->removal_lock);
+
+	/* wait until the workqueue stopped */
+	cancel_work_sync(&vm->wq);
+	hrtimer_cancel(&vm->retry_timer);
+
+	/* make sure all callbacks saw vm->removing */
+	mutex_lock(&vm->hotplug_mutex);
+	mutex_unlock(&vm->hotplug_mutex);
+
+	/*
+	 * After we unregistered our callbacks, user space can online partially
+	 * plugged offline blocks. Make sure to remove them.
+	 */
+	virtio_mem_for_each_mb_state(vm, mb_id,
+				     VIRTIO_MEM_MB_STATE_OFFLINE_PARTIAL) {
+		rc =3D virtio_mem_mb_remove(vm, mb_id);
+		BUG_ON(rc);
+	}
+
+	/* unregister callbacks */
+	unregister_virtio_mem_device(vm);
+	unregister_memory_notifier(&vm->memory_notifier);
+
+	/*
+	 * There is no way we could deterministically remove all memory we have
+	 * added to the system. And there is no way to stop the driver/device
+	 * from going away.
+	 */
+	if (vm->plugged_size)
+		dev_warn(&vdev->dev, "device still has memory plugged\n");
+
+	/* remove all tracking data - no locking needed */
+	vfree(vm->mb_state);
+	vfree(vm->sb_bitmap);
+
+	/* reset the device and cleanup the queues */
+	vdev->config->reset(vdev);
+	vdev->config->del_vqs(vdev);
+
+	kfree(vm);
+	vdev->priv =3D NULL;
+}
+
+static void virtio_mem_config_changed(struct virtio_device *vdev)
+{
+	struct virtio_mem *vm =3D vdev->priv;
+
+	atomic_set(&vm->config_changed, 1);
+	virtio_mem_retry(vm);
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int virtio_mem_freeze(struct virtio_device *vdev)
+{
+	/*
+	 * When restarting the VM, all memory is usually unplugged. Don't
+	 * allow to suspend/hibernate.
+	 */
+	dev_err(&vdev->dev, "save/restore not supported.\n");
+	return -EPERM;
+}
+
+static int virtio_mem_restore(struct virtio_device *vdev)
+{
+	return -EPERM;
+}
+#endif
+
+static unsigned int virtio_mem_features[] =3D {
+#if defined(CONFIG_NUMA) && defined(CONFIG_ACPI_NUMA)
+	VIRTIO_MEM_F_ACPI_PXM,
+#endif
+};
+
+static struct virtio_device_id virtio_mem_id_table[] =3D {
+	{ VIRTIO_ID_MEM, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+static struct virtio_driver virtio_mem_driver =3D {
+	.feature_table =3D virtio_mem_features,
+	.feature_table_size =3D ARRAY_SIZE(virtio_mem_features),
+	.driver.name =3D KBUILD_MODNAME,
+	.driver.owner =3D THIS_MODULE,
+	.id_table =3D virtio_mem_id_table,
+	.probe =3D virtio_mem_probe,
+	.remove =3D virtio_mem_remove,
+	.config_changed =3D virtio_mem_config_changed,
+#ifdef CONFIG_PM_SLEEP
+	.freeze	=3D	virtio_mem_freeze,
+	.restore =3D	virtio_mem_restore,
+#endif
+};
+
+module_virtio_driver(virtio_mem_driver);
+MODULE_DEVICE_TABLE(virtio, virtio_mem_id_table);
+MODULE_AUTHOR("David Hildenbrand <david@redhat.com>");
+MODULE_DESCRIPTION("Virtio-mem driver");
+MODULE_LICENSE("GPL");
diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_=
ids.h
index 585e07b27333..934e0b444454 100644
--- a/include/uapi/linux/virtio_ids.h
+++ b/include/uapi/linux/virtio_ids.h
@@ -44,6 +44,7 @@
 #define VIRTIO_ID_VSOCK        19 /* virtio vsock transport */
 #define VIRTIO_ID_CRYPTO       20 /* virtio crypto */
 #define VIRTIO_ID_IOMMU        23 /* virtio IOMMU */
+#define VIRTIO_ID_MEM          24 /* virtio mem */
 #define VIRTIO_ID_FS           26 /* virtio filesystem */
 #define VIRTIO_ID_PMEM         27 /* virtio pmem */
=20
diff --git a/include/uapi/linux/virtio_mem.h b/include/uapi/linux/virtio_=
mem.h
new file mode 100644
index 000000000000..bac73fca6c0e
--- /dev/null
+++ b/include/uapi/linux/virtio_mem.h
@@ -0,0 +1,204 @@
+/* SPDX-License-Identifier: BSD-3-Clause */
+/*
+ * Virtio Mem Device
+ *
+ * Copyright Red Hat, Inc. 2019
+ *
+ * Authors:
+ *     David Hildenbrand <david@redhat.com>
+ *
+ * This header is BSD licensed so anyone can use the definitions
+ * to implement compatible drivers/servers:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in th=
e
+ *    documentation and/or other materials provided with the distributio=
n.
+ * 3. Neither the name of IBM nor the names of its contributors
+ *    may be used to endorse or promote products derived from this softw=
are
+ *    without specific prior written permission.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR
+ * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
+ * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
+ * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
+ * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#ifndef _LINUX_VIRTIO_MEM_H
+#define _LINUX_VIRTIO_MEM_H
+
+#include <linux/types.h>
+#include <linux/virtio_types.h>
+#include <linux/virtio_ids.h>
+#include <linux/virtio_config.h>
+
+/*
+ * Each virtio-mem device manages a dedicated region in physical address
+ * space. Each device can belong to a single NUMA node, multiple devices
+ * for a single NUMA node are possible. A virtio-mem device is like a
+ * "resizable DIMM" consisting of small memory blocks that can be plugge=
d
+ * or unplugged. The device driver is responsible for (un)plugging memor=
y
+ * blocks on demand.
+ *
+ * Virtio-mem devices can only operate on their assigned memory region i=
n
+ * order to (un)plug memory. A device cannot (un)plug memory belonging t=
o
+ * other devices.
+ *
+ * The "region_size" corresponds to the maximum amount of memory that ca=
n
+ * be provided by a device. The "size" corresponds to the amount of memo=
ry
+ * that is currently plugged. "requested_size" corresponds to a request
+ * from the device to the device driver to (un)plug blocks. The
+ * device driver should try to (un)plug blocks in order to reach the
+ * "requested_size". It is impossible to plug more memory than requested=
.
+ *
+ * The "usable_region_size" represents the memory region that can actual=
ly
+ * be used to (un)plug memory. It is always at least as big as the
+ * "requested_size" and will grow dynamically. It will only shrink when
+ * explicitly triggered (VIRTIO_MEM_REQ_UNPLUG).
+ *
+ * Memory in the usable region can usually be read, however, there are n=
o
+ * guarantees. It can happen that the device cannot process a request,
+ * because it is busy. The device driver has to retry later.
+ *
+ * Usually, during system resets all memory will get unplugged, so the
+ * device driver can start with a clean state. However, in specific
+ * scenarios (if the device is busy) it can happen that the device still
+ * has memory plugged. The device driver can request to unplug all memor=
y
+ * (VIRTIO_MEM_REQ_UNPLUG) - which might take a while to succeed if the
+ * device is busy.
+ */
+
+/* --- virtio-mem: feature bits --- */
+
+/* node_id is an ACPI PXM and is valid */
+#define VIRTIO_MEM_F_ACPI_PXM		0
+
+
+/* --- virtio-mem: guest -> host requests --- */
+
+/* request to plug memory blocks */
+#define VIRTIO_MEM_REQ_PLUG			0
+/* request to unplug memory blocks */
+#define VIRTIO_MEM_REQ_UNPLUG			1
+/* request to unplug all blocks and shrink the usable size */
+#define VIRTIO_MEM_REQ_UNPLUG_ALL		2
+/* request information about the plugged state of memory blocks */
+#define VIRTIO_MEM_REQ_STATE			3
+
+struct virtio_mem_req_plug {
+	__virtio64 addr;
+	__virtio16 nb_blocks;
+};
+
+struct virtio_mem_req_unplug {
+	__virtio64 addr;
+	__virtio16 nb_blocks;
+};
+
+struct virtio_mem_req_state {
+	__virtio64 addr;
+	__virtio16 nb_blocks;
+};
+
+struct virtio_mem_req {
+	__virtio16 type;
+	__virtio16 padding[3];
+
+	union {
+		struct virtio_mem_req_plug plug;
+		struct virtio_mem_req_unplug unplug;
+		struct virtio_mem_req_state state;
+	} u;
+};
+
+
+/* --- virtio-mem: host -> guest response --- */
+
+/*
+ * Request processed successfully, applicable for
+ * - VIRTIO_MEM_REQ_PLUG
+ * - VIRTIO_MEM_REQ_UNPLUG
+ * - VIRTIO_MEM_REQ_UNPLUG_ALL
+ * - VIRTIO_MEM_REQ_STATE
+ */
+#define VIRTIO_MEM_RESP_ACK			0
+/*
+ * Request denied - e.g. trying to plug more than requested, applicable =
for
+ * - VIRTIO_MEM_REQ_PLUG
+ */
+#define VIRTIO_MEM_RESP_NACK			1
+/*
+ * Request cannot be processed right now, try again later, applicable fo=
r
+ * - VIRTIO_MEM_REQ_PLUG
+ * - VIRTIO_MEM_REQ_UNPLUG
+ * - VIRTIO_MEM_REQ_UNPLUG_ALL
+ */
+#define VIRTIO_MEM_RESP_BUSY			2
+/*
+ * Error in request (e.g. addresses/alignemnt), applicable for
+ * - VIRTIO_MEM_REQ_PLUG
+ * - VIRTIO_MEM_REQ_UNPLUG
+ * - VIRTIO_MEM_REQ_STATE
+ */
+#define VIRTIO_MEM_RESP_ERROR			3
+
+
+/* State of memory blocks is "plugged" */
+#define VIRTIO_MEM_STATE_PLUGGED		0
+/* State of memory blocks is "unplugged" */
+#define VIRTIO_MEM_STATE_UNPLUGGED		1
+/* State of memory blocks is "mixed" */
+#define VIRTIO_MEM_STATE_MIXED			2
+
+struct virtio_mem_resp_state {
+	__virtio16 state;
+};
+
+struct virtio_mem_resp {
+	__virtio16 type;
+	__virtio16 padding[3];
+
+	union {
+		struct virtio_mem_resp_state state;
+	} u;
+};
+
+/* --- virtio-mem: configuration --- */
+
+struct virtio_mem_config {
+	/* Block size and alignment. Cannot change. */
+	uint32_t block_size;
+	/* Valid with VIRTIO_MEM_F_ACPI_PXM. Cannot change. */
+	uint16_t node_id;
+	uint16_t padding;
+	/* Start address of the memory region. Cannot change. */
+	uint64_t addr;
+	/* Region size (maximum). Cannot change. */
+	uint64_t region_size;
+	/*
+	 * Currently usable region size. Can grow up to region_size. Can
+	 * shrink due to VIRTIO_MEM_REQ_UNPLUG_ALL (in which case no config
+	 * update will be sent).
+	 */
+	uint64_t usable_region_size;
+	/*
+	 * Currently used size. Changes due to plug/unplug requests, but no
+	 * config updates will be sent.
+	 */
+	uint64_t plugged_size;
+	/* Requested size. New plug requests cannot exceed it. Can change. */
+	uint64_t requested_size;
+};
+
+#endif /* _LINUX_VIRTIO_MEM_H */
--=20
2.23.0

