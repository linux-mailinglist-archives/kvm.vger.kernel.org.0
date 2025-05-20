Return-Path: <kvm+bounces-47105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12ADCABD4F4
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 12:32:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1B823B21F2
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD65D277021;
	Tue, 20 May 2025 10:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XdFmaUx6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34F6274FC4
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 10:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747736961; cv=none; b=EyXJXu1BHh2u8mLZ1TpGiPI+t0Ag8/Qxsx43+aVfmdzmh4x4GV0LOXRa3YDw8zo96I3gvjfHJYuaUwLYaiCIDuLUAWaPmvDdT/6QuEknJGeJPNANmeMtLUkmnxdIMWvg2yfFw1Zt2DtEeFTfrC4ks892iXNGi3umlmz0BshrxwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747736961; c=relaxed/simple;
	bh=8c4TeopTLUWlOA2yHdqDsJj+x3XUBu597J4JC9hu9Wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kd5X4NS+MScc2YDsgsNE/RrR6GVvLfSfZ+Oi8rDHtGx44WgmtWURoMQjahmoNxdGelOrTOTPYTgV+bOuyWfAG1CtjwEguTtrbqjEUItK9JH3z1POoUklFil3hotHiVPFiMrLtH/UKASAitDDKUvQ9TTIk6YOW9T4D89l3LCQt2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XdFmaUx6; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747736959; x=1779272959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8c4TeopTLUWlOA2yHdqDsJj+x3XUBu597J4JC9hu9Wc=;
  b=XdFmaUx6dC8RMTXTr4CWRojnZgsiUrYDmL7HvFlz1D4m4oV5YWZXVuu0
   kM1yWuH77Rvl8SYano0f2SlYGLWsb/IPV0e4AGNU3i03wCoQ2nUFm/MNi
   ZD/SV2f8UiiEpc3HirUpAxt00/EosG8SVnajSwCxyw5d9WZkWXyJMwWBH
   EfBSi2C5UbWpQi+7gsQ5k3wGUURTNpTnMIYnHht1OADnXw1Uvu3L+OucQ
   5RAoS0alMRnKhNQXlWc8q6fOLxOmDv2IlaMdcbuXHpJvSWXlV1cC/Aztu
   x+HA4bTUYPecvq0Dlabt/p2VkPMBxWkmm+0PSHvTrQBII7ELaOlEd5l9S
   g==;
X-CSE-ConnectionGUID: lB4IFUbzQ2y9/EMg7yOuAQ==
X-CSE-MsgGUID: IUzkRu9rTJ2MRS2StO7T4g==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49566654"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49566654"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:19 -0700
X-CSE-ConnectionGUID: rd3D3QsJTMmOts5oDKPumw==
X-CSE-MsgGUID: rd/r1JwwQSW8T+ez4mF8rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144905246"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:15 -0700
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
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v5 04/10] ram-block-attribute: Introduce RamBlockAttribute to manage RAMBlock with guest_memfd
Date: Tue, 20 May 2025 18:28:44 +0800
Message-ID: <20250520102856.132417-5-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250520102856.132417-1-chenyi.qiang@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
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
stale IOMMU mapping issue when assigning hardware devices to
confidential VMs via shared memory. To address this and allow shared
device assignement, it is crucial to ensure VFIO system refresh its
IOMMU mappings.

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
RamBlockAttribute to implement the RamDiscardManager interface. This
object can store the guest_memfd information such as bitmap for shared
memory, and handles page conversion notification. In the context of
RamDiscardManager, shared state is analogous to populated and private
state is treated as discard. The memory state is tracked at the host
page size granularity, as minimum memory conversion size can be one page
per request. Additionally, VFIO expects the DMA mapping for a specific
iova to be mapped and unmapped with the same granularity. Confidential
VMs may perform partial conversions, such as conversions on small
regions within larger regions. To prevent such invalid cases and until
cut_mapping operation support is available, all operations are performed
with 4K granularity.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
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

Changes in v3:
    - Some rename (bitmap_size->shared_bitmap_size,
      first_one/zero_bit->first_bit, etc.)
    - Change shared_bitmap_size from uint32_t to unsigned
    - Return mgr->mr->ram_block->page_size in get_block_size()
    - Move set_ram_discard_manager() up to avoid a g_free() in failure
      case.
    - Add const for the memory_attribute_manager_get_block_size()
    - Unify the ReplayRamPopulate and ReplayRamDiscard and related
      callback.

Changes in v2:
    - Rename the object name to MemoryAttributeManager
    - Rename the bitmap to shared_bitmap to make it more clear.
    - Remove block_size field and get it from a helper. In future, we
      can get the page_size from RAMBlock if necessary.
    - Remove the unncessary "struct" before GuestMemfdReplayData
    - Remove the unncessary g_free() for the bitmap
    - Add some error report when the callback failure for
      populated/discarded section.
    - Move the realize()/unrealize() definition to this patch.
---
 MAINTAINERS                  |   1 +
 include/system/ramblock.h    |  20 +++
 system/meson.build           |   1 +
 system/ram-block-attribute.c | 311 +++++++++++++++++++++++++++++++++++
 4 files changed, 333 insertions(+)
 create mode 100644 system/ram-block-attribute.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dacd6d004..3b4947dc74 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3149,6 +3149,7 @@ F: system/memory.c
 F: system/memory_mapping.c
 F: system/physmem.c
 F: system/memory-internal.h
+F: system/ram-block-attribute.c
 F: scripts/coccinelle/memory-region-housekeeping.cocci
 
 Memory devices
diff --git a/include/system/ramblock.h b/include/system/ramblock.h
index d8a116ba99..09255e8495 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -22,6 +22,10 @@
 #include "exec/cpu-common.h"
 #include "qemu/rcu.h"
 #include "exec/ramlist.h"
+#include "system/hostmem.h"
+
+#define TYPE_RAM_BLOCK_ATTRIBUTE "ram-block-attribute"
+OBJECT_DECLARE_SIMPLE_TYPE(RamBlockAttribute, RAM_BLOCK_ATTRIBUTE)
 
 struct RAMBlock {
     struct rcu_head rcu;
@@ -42,6 +46,8 @@ struct RAMBlock {
     int fd;
     uint64_t fd_offset;
     int guest_memfd;
+    /* 1-setting of the bitmap in ram_shared represents ram is shared */
+    RamBlockAttribute *ram_shared;
     size_t page_size;
     /* dirty bitmap used during migration */
     unsigned long *bmap;
@@ -91,4 +97,18 @@ struct RAMBlock {
     ram_addr_t postcopy_length;
 };
 
+struct RamBlockAttribute {
+    Object parent;
+
+    MemoryRegion *mr;
+
+    unsigned bitmap_size;
+    unsigned long *bitmap;
+
+    QLIST_HEAD(, RamDiscardListener) rdl_list;
+};
+
+RamBlockAttribute *ram_block_attribute_create(MemoryRegion *mr);
+void ram_block_attribute_destroy(RamBlockAttribute *attr);
+
 #endif
diff --git a/system/meson.build b/system/meson.build
index c2f0082766..107596ce86 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -17,6 +17,7 @@ libsystem_ss.add(files(
   'dma-helpers.c',
   'globals.c',
   'ioport.c',
+  'ram-block-attribute.c',
   'memory_mapping.c',
   'memory.c',
   'physmem.c',
diff --git a/system/ram-block-attribute.c b/system/ram-block-attribute.c
new file mode 100644
index 0000000000..8d4a24738c
--- /dev/null
+++ b/system/ram-block-attribute.c
@@ -0,0 +1,311 @@
+/*
+ * QEMU ram block attribute
+ *
+ * Copyright Intel
+ *
+ * Author:
+ *      Chenyi Qiang <chenyi.qiang@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory
+ *
+ */
+
+#include "qemu/osdep.h"
+#include "qemu/error-report.h"
+#include "system/ramblock.h"
+
+OBJECT_DEFINE_SIMPLE_TYPE_WITH_INTERFACES(RamBlockAttribute,
+                                          ram_block_attribute,
+                                          RAM_BLOCK_ATTRIBUTE,
+                                          OBJECT,
+                                          { TYPE_RAM_DISCARD_MANAGER },
+                                          { })
+
+static size_t ram_block_attribute_get_block_size(const RamBlockAttribute *attr)
+{
+    /*
+     * Because page conversion could be manipulated in the size of at least 4K
+     * or 4K aligned, Use the host page size as the granularity to track the
+     * memory attribute.
+     */
+    g_assert(attr && attr->mr && attr->mr->ram_block);
+    g_assert(attr->mr->ram_block->page_size == qemu_real_host_page_size());
+    return attr->mr->ram_block->page_size;
+}
+
+
+static bool
+ram_block_attribute_rdm_is_populated(const RamDiscardManager *rdm,
+                                     const MemoryRegionSection *section)
+{
+    const RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(rdm);
+    const int block_size = ram_block_attribute_get_block_size(attr);
+    uint64_t first_bit = section->offset_within_region / block_size;
+    uint64_t last_bit = first_bit + int128_get64(section->size) / block_size - 1;
+    unsigned long first_discard_bit;
+
+    first_discard_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
+                                           first_bit);
+    return first_discard_bit > last_bit;
+}
+
+typedef int (*ram_block_attribute_section_cb)(MemoryRegionSection *s,
+                                              void *arg);
+
+static int ram_block_attribute_notify_populate_cb(MemoryRegionSection *section,
+                                                   void *arg)
+{
+    RamDiscardListener *rdl = arg;
+
+    return rdl->notify_populate(rdl, section);
+}
+
+static int ram_block_attribute_notify_discard_cb(MemoryRegionSection *section,
+                                                 void *arg)
+{
+    RamDiscardListener *rdl = arg;
+
+    rdl->notify_discard(rdl, section);
+    return 0;
+}
+
+static int
+ram_block_attribute_for_each_populated_section(const RamBlockAttribute *attr,
+                                               MemoryRegionSection *section,
+                                               void *arg,
+                                               ram_block_attribute_section_cb cb)
+{
+    unsigned long first_bit, last_bit;
+    uint64_t offset, size;
+    const int block_size = ram_block_attribute_get_block_size(attr);
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
+ram_block_attribute_for_each_discard_section(const RamBlockAttribute *attr,
+                                             MemoryRegionSection *section,
+                                             void *arg,
+                                             ram_block_attribute_section_cb cb)
+{
+    unsigned long first_bit, last_bit;
+    uint64_t offset, size;
+    const int block_size = ram_block_attribute_get_block_size(attr);
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
+ram_block_attribute_rdm_get_min_granularity(const RamDiscardManager *rdm,
+                                            const MemoryRegion *mr)
+{
+    const RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(rdm);
+
+    g_assert(mr == attr->mr);
+    return ram_block_attribute_get_block_size(attr);
+}
+
+static void
+ram_block_attribute_rdm_register_listener(RamDiscardManager *rdm,
+                                          RamDiscardListener *rdl,
+                                          MemoryRegionSection *section)
+{
+    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(rdm);
+    int ret;
+
+    g_assert(section->mr == attr->mr);
+    rdl->section = memory_region_section_new_copy(section);
+
+    QLIST_INSERT_HEAD(&attr->rdl_list, rdl, next);
+
+    ret = ram_block_attribute_for_each_populated_section(attr, section, rdl,
+                                    ram_block_attribute_notify_populate_cb);
+    if (ret) {
+        error_report("%s: Failed to register RAM discard listener: %s",
+                     __func__, strerror(-ret));
+        exit(1);
+    }
+}
+
+static void
+ram_block_attribute_rdm_unregister_listener(RamDiscardManager *rdm,
+                                            RamDiscardListener *rdl)
+{
+    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(rdm);
+    int ret;
+
+    g_assert(rdl->section);
+    g_assert(rdl->section->mr == attr->mr);
+
+    if (rdl->double_discard_supported) {
+        rdl->notify_discard(rdl, rdl->section);
+    } else {
+        ret = ram_block_attribute_for_each_populated_section(attr,
+                rdl->section, rdl, ram_block_attribute_notify_discard_cb);
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
+typedef struct RamBlockAttributeReplayData {
+    ReplayRamDiscardState fn;
+    void *opaque;
+} RamBlockAttributeReplayData;
+
+static int ram_block_attribute_rdm_replay_cb(MemoryRegionSection *section,
+                                             void *arg)
+{
+    RamBlockAttributeReplayData *data = arg;
+
+    return data->fn(section, data->opaque);
+}
+
+static int
+ram_block_attribute_rdm_replay_populated(const RamDiscardManager *rdm,
+                                         MemoryRegionSection *section,
+                                         ReplayRamDiscardState replay_fn,
+                                         void *opaque)
+{
+    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(rdm);
+    RamBlockAttributeReplayData data = { .fn = replay_fn, .opaque = opaque };
+
+    g_assert(section->mr == attr->mr);
+    return ram_block_attribute_for_each_populated_section(attr, section, &data,
+                                            ram_block_attribute_rdm_replay_cb);
+}
+
+static int
+ram_block_attribute_rdm_replay_discard(const RamDiscardManager *rdm,
+                                       MemoryRegionSection *section,
+                                       ReplayRamDiscardState replay_fn,
+                                       void *opaque)
+{
+    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(rdm);
+    RamBlockAttributeReplayData data = { .fn = replay_fn, .opaque = opaque };
+
+    g_assert(section->mr == attr->mr);
+    return ram_block_attribute_for_each_discard_section(attr, section, &data,
+                                            ram_block_attribute_rdm_replay_cb);
+}
+
+RamBlockAttribute *ram_block_attribute_create(MemoryRegion *mr)
+{
+    uint64_t bitmap_size;
+    const int block_size  = qemu_real_host_page_size();
+    RamBlockAttribute *attr;
+    int ret;
+
+    attr = RAM_BLOCK_ATTRIBUTE(object_new(TYPE_RAM_BLOCK_ATTRIBUTE));
+
+    attr->mr = mr;
+    ret = memory_region_set_ram_discard_manager(mr, RAM_DISCARD_MANAGER(attr));
+    if (ret) {
+        object_unref(OBJECT(attr));
+        return NULL;
+    }
+    bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
+    attr->bitmap_size = bitmap_size;
+    attr->bitmap = bitmap_new(bitmap_size);
+
+    return attr;
+}
+
+void ram_block_attribute_destroy(RamBlockAttribute *attr)
+{
+    if (!attr) {
+        return;
+    }
+
+    g_free(attr->bitmap);
+    memory_region_set_ram_discard_manager(attr->mr, NULL);
+    object_unref(OBJECT(attr));
+}
+
+static void ram_block_attribute_init(Object *obj)
+{
+    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(obj);
+
+    QLIST_INIT(&attr->rdl_list);
+}
+
+static void ram_block_attribute_finalize(Object *obj)
+{
+}
+
+static void ram_block_attribute_class_init(ObjectClass *klass,
+                                           const void *data)
+{
+    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(klass);
+
+    rdmc->get_min_granularity = ram_block_attribute_rdm_get_min_granularity;
+    rdmc->register_listener = ram_block_attribute_rdm_register_listener;
+    rdmc->unregister_listener = ram_block_attribute_rdm_unregister_listener;
+    rdmc->is_populated = ram_block_attribute_rdm_is_populated;
+    rdmc->replay_populated = ram_block_attribute_rdm_replay_populated;
+    rdmc->replay_discarded = ram_block_attribute_rdm_replay_discard;
+}
-- 
2.43.5


