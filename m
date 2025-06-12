Return-Path: <kvm+bounces-49245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28C67AD6ABB
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 10:29:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCE27168956
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 08:29:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5244522B8B6;
	Thu, 12 Jun 2025 08:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DaufSXDA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC432236F4
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 08:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749716896; cv=none; b=icekMMgZ4wvwAIM9UC4X2zylKfzJNjW7aj1uzgnZhFigHTyAsKPqSJ7CeaTF4d1MI0Tv+kBSi7PIiOBSGHqGZ3y/y2jajw1ZjrzgnxvWi/s8/1L8uCeaqVkASaL7VAXQOtvB4aZOkXZOD5vf1MqgeWQ5jrxIA5Mq/E5yITkm3r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749716896; c=relaxed/simple;
	bh=DifGOdnO77+Dr41Cci6/a574tJUna+hwNOTdT224L8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mV/0PZ6WYb+mDTXyiOnXtAMdH+taMAiNXuZqXsJUSTgH0v2HPRV55jKqzhzHoriN68hZU4piE1AGryfQcDN/09e9JYkjt6waX/leucV8KOnmrtf682uo7Mh6zBuxFSuLLcxqSdnmswRXPcZ1wJDta6dZERLue0CxYD/KXddWIzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DaufSXDA; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749716894; x=1781252894;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DifGOdnO77+Dr41Cci6/a574tJUna+hwNOTdT224L8E=;
  b=DaufSXDA637C9fugSEA/PwlEBjtpCp59j8MBXii+G6Joy8BT7bjtV8aP
   RY4o8zb8ytTZrOGoe/C9QT7mKZcVrf/3S0L/qbB+07VKYgDpJsK1wN+9X
   ZhS3V97HdoOanjX2FoP4WipCCfp1RdKK6701ZV+LU1uHyRvHSubr/Z4S4
   uGgTZq9W+UR+E1jZydWYNJDHGN9qeC0eGCV3fvbBzqxWnlxg37ZqcoMNd
   u93XD6r7M8gwi5Fq1B3RST0HJSCzeGe/BcO5BjkEymq9RIa4rGY4U4UPR
   6C+fOTV3qOiAD/wXytPAuxCvy/VtYUqrsXRb3tuuSO+Hcp23PciaTXEY9
   w==;
X-CSE-ConnectionGUID: 7A4Q2Sf7QeOQcoDaqaVOpw==
X-CSE-MsgGUID: 2toGcaNAQZaP6rk7xgmJVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="69453451"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="69453451"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:28:14 -0700
X-CSE-ConnectionGUID: DlFFdq/rQAeFzjOjHhMTVw==
X-CSE-MsgGUID: 8l7l4u8qQI6kTqGJzYJmMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="152442049"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:28:10 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>,
	Gupta Pankaj <pankaj.gupta@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v7 4/5] ram-block-attributes: Introduce RamBlockAttributes to manage RAMBlock with guest_memfd
Date: Thu, 12 Jun 2025 16:27:45 +0800
Message-ID: <20250612082747.51539-5-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250612082747.51539-1-chenyi.qiang@intel.com>
References: <20250612082747.51539-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
discard") highlighted that subsystems like VFIO may disable RAM block
discard. However, guest_memfd relies on discard operations for page
conversion between private and shared memory, potentially leading to
the stale IOMMU mapping issue when assigning hardware devices to
confidential VMs via shared memory. To address this and allow shared
device assignement, it is crucial to ensure the VFIO system refreshes
its IOMMU mappings.

RamDiscardManager is an existing interface (used by virtio-mem) to
adjust VFIO mappings in relation to VM page assignment. Effectively page
conversion is similar to hot-removing a page in one mode and adding it
back in the other. Therefore, similar actions are required for page
conversion events. Introduce the RamDiscardManager to guest_memfd to
facilitate this process.

Since guest_memfd is not an object, it cannot directly implement the
RamDiscardManager interface. Implementing it in HostMemoryBackend is
not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
have a memory backend while others do not. Notably, virtual BIOS
RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
backend.

To manage RAMBlocks with guest_memfd, define a new object named
RamBlockAttributes to implement the RamDiscardManager interface. This
object can store the guest_memfd information such as the bitmap for
shared memory and the registered listeners for event notifications. A
new state_change() helper function is provided to notify listeners, such
as VFIO, allowing VFIO to do dynamically DMA map and unmap for the shared
memory according to conversion events. Note that in the current context
of RamDiscardManager for guest_memfd, the shared state is analogous to
being populated, while the private state can be considered discarded for
simplicity. In the future, it would be more complicated if considering
more states like private/shared/discarded at the same time.

In current implementation, memory state tracking is performed at the
host page size granularity, as the minimum conversion size can be one
page per request. Additionally, VFIO expected the DMA mapping for a
specific IOVA to be mapped and unmapped with the same granularity.
Confidential VMs may perform partial conversions, such as conversions on
small regions within a larger one. To prevent such invalid cases and
until support for DMA mapping cut operations is available, all
operations are performed with 4K granularity.

In addition, memory conversion failures cause QEMU to quit rather than
resuming the guest or retrying the operation at present. It would be
future work to add more error handling or rollback mechanisms once
conversion failures are allowed. For example, in-place conversion of
guest_memfd could retry the unmap operation during the conversion from
shared to private. For now, keep the complex error handling out of the
picture as it is not required.

Tested-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v7:
    - Unwrap the two helpers(is_range_populated() and is
      is_range_discarded()). (Alexey)
    - Use bit to do the iteration instead of offset without additional
      variables of "cur" and "end" (Alexey)
    - Add Reviewed-by from Pankaj and Alexey.

Changes in v6:
    - Change the object type name from RamBlockAttribute to
      RamBlockAttributes. (David)
    - Save the associated RAMBlock instead MemoryRegion in
      RamBlockAttributes. (David)
    - Squash the state_change() helper introduction in this commit as
      well as the mixture conversion case handling. (David)
    - Change the block_size type from int to size_t and some cleanup in
      validation check. (Alexey)
    - Add a tracepoint to track the state changes. (Alexey)

Changes in v5:
    - Revert to use RamDiscardManager interface instead of introducing
      new hierarchy of class to manage private/shared state, and keep
      using the new name of RamBlockAttribute compared with the
      MemoryAttributeManager in v3.
    - Use *simple* version of object_define and object_declare since the
      state_change() function is changed as an exported function instead
      of a virtual function in later patch.
    - Move the introduction of RamBlockAttribute field to this patch and
      rename it to ram_shared. (Alexey)
    - call the exit() when register/unregister failed. (Zhao)
    - Add the ram-block-attribute.c to Memory API related part in
      MAINTAINERS.

Changes in v4:
    - Change the name from memory-attribute-manager to
      ram-block-attribute.
    - Implement the newly-introduced PrivateSharedManager instead of
      RamDiscardManager and change related commit message.
    - Define the new object in ramblock.h instead of adding a new file.
---
 MAINTAINERS                   |   1 +
 include/system/ramblock.h     |  21 ++
 system/meson.build            |   1 +
 system/ram-block-attributes.c | 442 ++++++++++++++++++++++++++++++++++
 system/trace-events           |   3 +
 5 files changed, 468 insertions(+)
 create mode 100644 system/ram-block-attributes.c

diff --git a/MAINTAINERS b/MAINTAINERS
index aa6763077e..6a86cee73a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3172,6 +3172,7 @@ F: system/memory.c
 F: system/memory_mapping.c
 F: system/physmem.c
 F: system/memory-internal.h
+F: system/ram-block-attributes.c
 F: scripts/coccinelle/memory-region-housekeeping.cocci
 
 Memory devices
diff --git a/include/system/ramblock.h b/include/system/ramblock.h
index d8a116ba99..1bab9e2dac 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -22,6 +22,10 @@
 #include "exec/cpu-common.h"
 #include "qemu/rcu.h"
 #include "exec/ramlist.h"
+#include "system/hostmem.h"
+
+#define TYPE_RAM_BLOCK_ATTRIBUTES "ram-block-attributes"
+OBJECT_DECLARE_SIMPLE_TYPE(RamBlockAttributes, RAM_BLOCK_ATTRIBUTES)
 
 struct RAMBlock {
     struct rcu_head rcu;
@@ -91,4 +95,21 @@ struct RAMBlock {
     ram_addr_t postcopy_length;
 };
 
+struct RamBlockAttributes {
+    Object parent;
+
+    RAMBlock *ram_block;
+
+    /* 1-setting of the bitmap represents ram is populated (shared) */
+    unsigned bitmap_size;
+    unsigned long *bitmap;
+
+    QLIST_HEAD(, RamDiscardListener) rdl_list;
+};
+
+RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block);
+void ram_block_attributes_destroy(RamBlockAttributes *attr);
+int ram_block_attributes_state_change(RamBlockAttributes *attr, uint64_t offset,
+                                      uint64_t size, bool to_discard);
+
 #endif
diff --git a/system/meson.build b/system/meson.build
index 7514bf3455..6d21ff9faa 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -17,6 +17,7 @@ system_ss.add(files(
   'dma-helpers.c',
   'globals.c',
   'ioport.c',
+  'ram-block-attributes.c',
   'memory_mapping.c',
   'memory.c',
   'physmem.c',
diff --git a/system/ram-block-attributes.c b/system/ram-block-attributes.c
new file mode 100644
index 0000000000..dbb8c9675b
--- /dev/null
+++ b/system/ram-block-attributes.c
@@ -0,0 +1,442 @@
+/*
+ * QEMU ram block attributes
+ *
+ * Copyright Intel
+ *
+ * Author:
+ *      Chenyi Qiang <chenyi.qiang@intel.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "qemu/error-report.h"
+#include "system/ramblock.h"
+#include "trace.h"
+
+OBJECT_DEFINE_SIMPLE_TYPE_WITH_INTERFACES(RamBlockAttributes,
+                                          ram_block_attributes,
+                                          RAM_BLOCK_ATTRIBUTES,
+                                          OBJECT,
+                                          { TYPE_RAM_DISCARD_MANAGER },
+                                          { })
+
+static size_t
+ram_block_attributes_get_block_size(const RamBlockAttributes *attr)
+{
+    /*
+     * Because page conversion could be manipulated in the size of at least 4K
+     * or 4K aligned, Use the host page size as the granularity to track the
+     * memory attribute.
+     */
+    g_assert(attr && attr->ram_block);
+    g_assert(attr->ram_block->page_size == qemu_real_host_page_size());
+    return attr->ram_block->page_size;
+}
+
+
+static bool
+ram_block_attributes_rdm_is_populated(const RamDiscardManager *rdm,
+                                      const MemoryRegionSection *section)
+{
+    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
+    const size_t block_size = ram_block_attributes_get_block_size(attr);
+    const uint64_t first_bit = section->offset_within_region / block_size;
+    const uint64_t last_bit = first_bit + int128_get64(section->size) / block_size - 1;
+    unsigned long first_discarded_bit;
+
+    first_discarded_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
+                                           first_bit);
+    return first_discarded_bit > last_bit;
+}
+
+typedef int (*ram_block_attributes_section_cb)(MemoryRegionSection *s,
+                                               void *arg);
+
+static int
+ram_block_attributes_notify_populate_cb(MemoryRegionSection *section,
+                                        void *arg)
+{
+    RamDiscardListener *rdl = arg;
+
+    return rdl->notify_populate(rdl, section);
+}
+
+static int
+ram_block_attributes_notify_discard_cb(MemoryRegionSection *section,
+                                       void *arg)
+{
+    RamDiscardListener *rdl = arg;
+
+    rdl->notify_discard(rdl, section);
+    return 0;
+}
+
+static int
+ram_block_attributes_for_each_populated_section(const RamBlockAttributes *attr,
+                                                MemoryRegionSection *section,
+                                                void *arg,
+                                                ram_block_attributes_section_cb cb)
+{
+    unsigned long first_bit, last_bit;
+    uint64_t offset, size;
+    const size_t block_size = ram_block_attributes_get_block_size(attr);
+    int ret = 0;
+
+    first_bit = section->offset_within_region / block_size;
+    first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
+                              first_bit);
+
+    while (first_bit < attr->bitmap_size) {
+        MemoryRegionSection tmp = *section;
+
+        offset = first_bit * block_size;
+        last_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
+                                      first_bit + 1) - 1;
+        size = (last_bit - first_bit + 1) * block_size;
+
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            break;
+        }
+
+        ret = cb(&tmp, arg);
+        if (ret) {
+            error_report("%s: Failed to notify RAM discard listener: %s",
+                         __func__, strerror(-ret));
+            break;
+        }
+
+        first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
+                                  last_bit + 2);
+    }
+
+    return ret;
+}
+
+static int
+ram_block_attributes_for_each_discarded_section(const RamBlockAttributes *attr,
+                                                MemoryRegionSection *section,
+                                                void *arg,
+                                                ram_block_attributes_section_cb cb)
+{
+    unsigned long first_bit, last_bit;
+    uint64_t offset, size;
+    const size_t block_size = ram_block_attributes_get_block_size(attr);
+    int ret = 0;
+
+    first_bit = section->offset_within_region / block_size;
+    first_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
+                                   first_bit);
+
+    while (first_bit < attr->bitmap_size) {
+        MemoryRegionSection tmp = *section;
+
+        offset = first_bit * block_size;
+        last_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
+                                 first_bit + 1) - 1;
+        size = (last_bit - first_bit + 1) * block_size;
+
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            break;
+        }
+
+        ret = cb(&tmp, arg);
+        if (ret) {
+            error_report("%s: Failed to notify RAM discard listener: %s",
+                         __func__, strerror(-ret));
+            break;
+        }
+
+        first_bit = find_next_zero_bit(attr->bitmap,
+                                       attr->bitmap_size,
+                                       last_bit + 2);
+    }
+
+    return ret;
+}
+
+static uint64_t
+ram_block_attributes_rdm_get_min_granularity(const RamDiscardManager *rdm,
+                                             const MemoryRegion *mr)
+{
+    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
+
+    g_assert(mr == attr->ram_block->mr);
+    return ram_block_attributes_get_block_size(attr);
+}
+
+static void
+ram_block_attributes_rdm_register_listener(RamDiscardManager *rdm,
+                                           RamDiscardListener *rdl,
+                                           MemoryRegionSection *section)
+{
+    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
+    int ret;
+
+    g_assert(section->mr == attr->ram_block->mr);
+    rdl->section = memory_region_section_new_copy(section);
+
+    QLIST_INSERT_HEAD(&attr->rdl_list, rdl, next);
+
+    ret = ram_block_attributes_for_each_populated_section(attr, section, rdl,
+                                    ram_block_attributes_notify_populate_cb);
+    if (ret) {
+        error_report("%s: Failed to register RAM discard listener: %s",
+                     __func__, strerror(-ret));
+        exit(1);
+    }
+}
+
+static void
+ram_block_attributes_rdm_unregister_listener(RamDiscardManager *rdm,
+                                             RamDiscardListener *rdl)
+{
+    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
+    int ret;
+
+    g_assert(rdl->section);
+    g_assert(rdl->section->mr == attr->ram_block->mr);
+
+    if (rdl->double_discard_supported) {
+        rdl->notify_discard(rdl, rdl->section);
+    } else {
+        ret = ram_block_attributes_for_each_populated_section(attr,
+                rdl->section, rdl, ram_block_attributes_notify_discard_cb);
+        if (ret) {
+            error_report("%s: Failed to unregister RAM discard listener: %s",
+                         __func__, strerror(-ret));
+            exit(1);
+        }
+    }
+
+    memory_region_section_free_copy(rdl->section);
+    rdl->section = NULL;
+    QLIST_REMOVE(rdl, next);
+}
+
+typedef struct RamBlockAttributesReplayData {
+    ReplayRamDiscardState fn;
+    void *opaque;
+} RamBlockAttributesReplayData;
+
+static int ram_block_attributes_rdm_replay_cb(MemoryRegionSection *section,
+                                              void *arg)
+{
+    RamBlockAttributesReplayData *data = arg;
+
+    return data->fn(section, data->opaque);
+}
+
+static int
+ram_block_attributes_rdm_replay_populated(const RamDiscardManager *rdm,
+                                          MemoryRegionSection *section,
+                                          ReplayRamDiscardState replay_fn,
+                                          void *opaque)
+{
+    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
+    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque = opaque };
+
+    g_assert(section->mr == attr->ram_block->mr);
+    return ram_block_attributes_for_each_populated_section(attr, section, &data,
+                                            ram_block_attributes_rdm_replay_cb);
+}
+
+static int
+ram_block_attributes_rdm_replay_discarded(const RamDiscardManager *rdm,
+                                          MemoryRegionSection *section,
+                                          ReplayRamDiscardState replay_fn,
+                                          void *opaque)
+{
+    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
+    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque = opaque };
+
+    g_assert(section->mr == attr->ram_block->mr);
+    return ram_block_attributes_for_each_discarded_section(attr, section, &data,
+                                            ram_block_attributes_rdm_replay_cb);
+}
+
+static bool
+ram_block_attributes_is_valid_range(RamBlockAttributes *attr, uint64_t offset,
+                                    uint64_t size)
+{
+    MemoryRegion *mr = attr->ram_block->mr;
+
+    g_assert(mr);
+
+    uint64_t region_size = memory_region_size(mr);
+    const size_t block_size = ram_block_attributes_get_block_size(attr);
+
+    if (!QEMU_IS_ALIGNED(offset, block_size) ||
+        !QEMU_IS_ALIGNED(size, block_size)) {
+        return false;
+    }
+    if (offset + size <= offset) {
+        return false;
+    }
+    if (offset + size > region_size) {
+        return false;
+    }
+    return true;
+}
+
+static void ram_block_attributes_notify_discard(RamBlockAttributes *attr,
+                                                uint64_t offset,
+                                                uint64_t size)
+{
+    RamDiscardListener *rdl;
+
+    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
+        MemoryRegionSection tmp = *rdl->section;
+
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            continue;
+        }
+        rdl->notify_discard(rdl, &tmp);
+    }
+}
+
+static int
+ram_block_attributes_notify_populate(RamBlockAttributes *attr,
+                                     uint64_t offset, uint64_t size)
+{
+    RamDiscardListener *rdl;
+    int ret = 0;
+
+    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
+        MemoryRegionSection tmp = *rdl->section;
+
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            continue;
+        }
+        ret = rdl->notify_populate(rdl, &tmp);
+        if (ret) {
+            break;
+        }
+    }
+
+    return ret;
+}
+
+int ram_block_attributes_state_change(RamBlockAttributes *attr,
+                                      uint64_t offset, uint64_t size,
+                                      bool to_discard)
+{
+    const size_t block_size = ram_block_attributes_get_block_size(attr);
+    const unsigned long first_bit = offset / block_size;
+    const unsigned long nbits = size / block_size;
+    const unsigned long last_bit = first_bit + nbits - 1;
+    const bool is_discarded = find_next_bit(attr->bitmap, attr->bitmap_size,
+                                            first_bit) > last_bit;
+    const bool is_populated = find_next_zero_bit(attr->bitmap,
+                                attr->bitmap_size, first_bit) > last_bit;
+    unsigned long bit;
+    int ret = 0;
+
+    if (!ram_block_attributes_is_valid_range(attr, offset, size)) {
+        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
+                     __func__, offset, size);
+        return -EINVAL;
+    }
+
+    trace_ram_block_attributes_state_change(offset, size,
+                                            is_discarded ? "discarded" :
+                                            is_populated ? "populated" :
+                                            "mixture",
+                                            to_discard ? "discarded" :
+                                            "populated");
+    if (to_discard) {
+        if (is_discarded) {
+            /* Already private */
+        } else if (is_populated) {
+            /* Completely shared */
+            bitmap_clear(attr->bitmap, first_bit, nbits);
+            ram_block_attributes_notify_discard(attr, offset, size);
+        } else {
+            /* Unexpected mixture: process individual blocks */
+            for (bit = first_bit; bit < first_bit + nbits; bit++) {
+                if (!test_bit(bit, attr->bitmap)) {
+                    continue;
+                }
+                clear_bit(bit, attr->bitmap);
+                ram_block_attributes_notify_discard(attr, bit * block_size,
+                                                    block_size);
+            }
+        }
+    } else {
+        if (is_populated) {
+            /* Already shared */
+        } else if (is_discarded) {
+            /* Completely private */
+            bitmap_set(attr->bitmap, first_bit, nbits);
+            ret = ram_block_attributes_notify_populate(attr, offset, size);
+        } else {
+            /* Unexpected mixture: process individual blocks */
+            for (bit = first_bit; bit < first_bit + nbits; bit++) {
+                if (test_bit(bit, attr->bitmap)) {
+                    continue;
+                }
+                set_bit(bit, attr->bitmap);
+                ret = ram_block_attributes_notify_populate(attr,
+                                                           bit * block_size,
+                                                           block_size);
+                if (ret) {
+                    break;
+                }
+            }
+        }
+    }
+
+    return ret;
+}
+
+RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block)
+{
+    const int block_size  = qemu_real_host_page_size();
+    RamBlockAttributes *attr;
+    MemoryRegion *mr = ram_block->mr;
+
+    attr = RAM_BLOCK_ATTRIBUTES(object_new(TYPE_RAM_BLOCK_ATTRIBUTES));
+
+    attr->ram_block = ram_block;
+    if (memory_region_set_ram_discard_manager(mr, RAM_DISCARD_MANAGER(attr))) {
+        object_unref(OBJECT(attr));
+        return NULL;
+    }
+    attr->bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
+    attr->bitmap = bitmap_new(attr->bitmap_size);
+
+    return attr;
+}
+
+void ram_block_attributes_destroy(RamBlockAttributes *attr)
+{
+    g_assert(attr);
+
+    g_free(attr->bitmap);
+    memory_region_set_ram_discard_manager(attr->ram_block->mr, NULL);
+    object_unref(OBJECT(attr));
+}
+
+static void ram_block_attributes_init(Object *obj)
+{
+    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(obj);
+
+    QLIST_INIT(&attr->rdl_list);
+}
+
+static void ram_block_attributes_finalize(Object *obj)
+{
+}
+
+static void ram_block_attributes_class_init(ObjectClass *klass,
+                                            const void *data)
+{
+    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(klass);
+
+    rdmc->get_min_granularity = ram_block_attributes_rdm_get_min_granularity;
+    rdmc->register_listener = ram_block_attributes_rdm_register_listener;
+    rdmc->unregister_listener = ram_block_attributes_rdm_unregister_listener;
+    rdmc->is_populated = ram_block_attributes_rdm_is_populated;
+    rdmc->replay_populated = ram_block_attributes_rdm_replay_populated;
+    rdmc->replay_discarded = ram_block_attributes_rdm_replay_discarded;
+}
diff --git a/system/trace-events b/system/trace-events
index be12ebfb41..82856e44f2 100644
--- a/system/trace-events
+++ b/system/trace-events
@@ -52,3 +52,6 @@ dirtylimit_state_finalize(void)
 dirtylimit_throttle_pct(int cpu_index, uint64_t pct, int64_t time_us) "CPU[%d] throttle percent: %" PRIu64 ", throttle adjust time %"PRIi64 " us"
 dirtylimit_set_vcpu(int cpu_index, uint64_t quota) "CPU[%d] set dirty page rate limit %"PRIu64
 dirtylimit_vcpu_execute(int cpu_index, int64_t sleep_time_us) "CPU[%d] sleep %"PRIi64 " us"
+
+# ram-block-attributes.c
+ram_block_attributes_state_change(uint64_t offset, uint64_t size, const char *from, const char *to) "offset 0x%"PRIx64" size 0x%"PRIx64" from '%s' to '%s'"
-- 
2.43.5


