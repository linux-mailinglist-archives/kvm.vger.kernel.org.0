Return-Path: <kvm+bounces-42806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E119A7D6CB
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:52:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 431F51673C5
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E346D1A8F93;
	Mon,  7 Apr 2025 07:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KyRNALE8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D7F225407
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 07:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744012216; cv=none; b=AgeFK6VywP828t4zvzcWAJppACxBa4COGq13AdTyFHPNw7j9CK8ofJQy4jR8dJuYzs4lEvjX5n/CS1gOAi2CcN4QvU7jyaCMZz+L7ZypVsLE+JE3/MpLqA1PkPjbLk4hyFeseQJR1zc0k+D1Lkz5jRa6+A4gFaBD5x5juyYslTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744012216; c=relaxed/simple;
	bh=w6HCJqHaMptWnO0iH0yxSN1OpJkMWZIZHCGCASw6PYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBeAiGGPWDPcwYiiLiFKW7eDDR0FNZsI+RJyR19IXWs5twlYqihQk8B0awvfPvJED3+ThYNBnwZpk+XnBD1nie/V6LWhB5koGj9LpMmizsBoP8yVWcmATFGzC/0MHOIlmZc/WRw20dYtQSBxVQ7tczoHywsqBFY8jYYl2Fqlvrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KyRNALE8; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744012215; x=1775548215;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w6HCJqHaMptWnO0iH0yxSN1OpJkMWZIZHCGCASw6PYM=;
  b=KyRNALE8exmwVDGCyUwJMHMDJKXHnt31Gd6GfkLvrXZ1aeOTJrWzdcJh
   Q+4WzQvFX0kJ/YNfR/C560gwXu3mOrgB+Ak9J4ka5ttwdg9q0/vuaEUt6
   NYzqyktwdCq1V79BOI1mOnbsKJDphzWDUSN6MEuYDqRMkZV4cJ8kOq7ZB
   E62uimSsh66RyBF9/tRZqZObVaETYnqQvzwRLs7kPPg7WY0PIIkyM9Yfp
   d8Yk2Pilku4TezOcktcTmU0sAsZFYNGyxWuxJjsZZnlZExsvDM4A/yzXg
   2JiHjpPoyyyVrc6nr4SZRlQPfeRuYpGpu0yHAcXLRGT9vV3F7QsCyU8FE
   Q==;
X-CSE-ConnectionGUID: KculSSsKSPmdrPI+6bBOoA==
X-CSE-MsgGUID: njKqaxUdQ2GBVWtcpYez1Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="67857557"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="67857557"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:14 -0700
X-CSE-ConnectionGUID: 3aX8Z7t2Q+ug3acnzQY8zQ==
X-CSE-MsgGUID: Myyi4eYPToOY0AHfkrcZyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="128405639"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:11 -0700
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
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v4 07/13] ram-block-attribute: Introduce RamBlockAttribute to manage RAMBLock with guest_memfd
Date: Mon,  7 Apr 2025 15:49:27 +0800
Message-ID: <20250407074939.18657-8-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250407074939.18657-1-chenyi.qiang@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
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
confidential VMs via shared memory. To address this, it is crucial to
ensure systems like VFIO refresh its IOMMU mappings.

PrivateSharedManager is introduced to manage private and shared states in
confidential VMs, similar to RamDiscardManager, which supports
coordinated RAM discard in VFIO. Integrating PrivateSharedManager with
guest_memfd can facilitate the adjustment of VFIO mappings in response
to page conversion events.

Since guest_memfd is not an object, it cannot directly implement the
PrivateSharedManager interface. Implementing it in HostMemoryBackend is
not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
have a memory backend while others do not. Notably, virtual BIOS
RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
backend.

To manage RAMBlocks with guest_memfd, define a new object named
RamBlockAttribute to implement the RamDiscardManager interface. This
object stores guest_memfd information such as shared_bitmap, and handles
page conversion notification. The memory state is tracked at the host
page size granularity, as the minimum memory conversion size can be one
page per request. Additionally, VFIO expects the DMA mapping for a
specific iova to be mapped and unmapped with the same granularity.
Confidential VMs may perform partial conversions, such as conversions on
small regions within larger regions. To prevent invalid cases and until
cut_mapping operation support is available, all operations are performed
with 4K granularity.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
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
 include/exec/ramblock.h      |  24 +++
 system/meson.build           |   1 +
 system/ram-block-attribute.c | 282 +++++++++++++++++++++++++++++++++++
 3 files changed, 307 insertions(+)
 create mode 100644 system/ram-block-attribute.c

diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
index 0babd105c0..b8b5469db9 100644
--- a/include/exec/ramblock.h
+++ b/include/exec/ramblock.h
@@ -23,6 +23,10 @@
 #include "cpu-common.h"
 #include "qemu/rcu.h"
 #include "exec/ramlist.h"
+#include "system/hostmem.h"
+
+#define TYPE_RAM_BLOCK_ATTRIBUTE "ram-block-attribute"
+OBJECT_DECLARE_TYPE(RamBlockAttribute, RamBlockAttributeClass, RAM_BLOCK_ATTRIBUTE)
 
 struct RAMBlock {
     struct rcu_head rcu;
@@ -90,5 +94,25 @@ struct RAMBlock {
      */
     ram_addr_t postcopy_length;
 };
+
+struct RamBlockAttribute {
+    Object parent;
+
+    MemoryRegion *mr;
+
+    /* 1-setting of the bit represents the memory is populated (shared) */
+    unsigned shared_bitmap_size;
+    unsigned long *shared_bitmap;
+
+    QLIST_HEAD(, PrivateSharedListener) psl_list;
+};
+
+struct RamBlockAttributeClass {
+    ObjectClass parent_class;
+};
+
+int ram_block_attribute_realize(RamBlockAttribute *attr, MemoryRegion *mr);
+void ram_block_attribute_unrealize(RamBlockAttribute *attr);
+
 #endif
 #endif
diff --git a/system/meson.build b/system/meson.build
index 4952f4b2c7..50a5a64f1c 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -15,6 +15,7 @@ system_ss.add(files(
   'dirtylimit.c',
   'dma-helpers.c',
   'globals.c',
+  'ram-block-attribute.c',
   'memory_mapping.c',
   'qdev-monitor.c',
   'qtest.c',
diff --git a/system/ram-block-attribute.c b/system/ram-block-attribute.c
new file mode 100644
index 0000000000..283c03b354
--- /dev/null
+++ b/system/ram-block-attribute.c
@@ -0,0 +1,282 @@
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
+#include "exec/ramblock.h"
+
+OBJECT_DEFINE_TYPE_WITH_INTERFACES(RamBlockAttribute,
+                                   ram_block_attribute,
+                                   RAM_BLOCK_ATTRIBUTE,
+                                   OBJECT,
+                                   { TYPE_PRIVATE_SHARED_MANAGER },
+                                   { })
+
+static size_t ram_block_attribute_get_block_size(const RamBlockAttribute *attr)
+{
+    /*
+     * Because page conversion could be manipulated in the size of at least 4K or 4K aligned,
+     * Use the host page size as the granularity to track the memory attribute.
+     */
+    g_assert(attr && attr->mr && attr->mr->ram_block);
+    g_assert(attr->mr->ram_block->page_size == qemu_real_host_page_size());
+    return attr->mr->ram_block->page_size;
+}
+
+
+static bool ram_block_attribute_psm_is_shared(const GenericStateManager *gsm,
+                                              const MemoryRegionSection *section)
+{
+    const RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
+    const int block_size = ram_block_attribute_get_block_size(attr);
+    uint64_t first_bit = section->offset_within_region / block_size;
+    uint64_t last_bit = first_bit + int128_get64(section->size) / block_size - 1;
+    unsigned long first_discard_bit;
+
+    first_discard_bit = find_next_zero_bit(attr->shared_bitmap, last_bit + 1, first_bit);
+    return first_discard_bit > last_bit;
+}
+
+typedef int (*ram_block_attribute_section_cb)(MemoryRegionSection *s, void *arg);
+
+static int ram_block_attribute_notify_shared_cb(MemoryRegionSection *section, void *arg)
+{
+    StateChangeListener *scl = arg;
+
+    return scl->notify_to_state_set(scl, section);
+}
+
+static int ram_block_attribute_notify_private_cb(MemoryRegionSection *section, void *arg)
+{
+    StateChangeListener *scl = arg;
+
+    scl->notify_to_state_clear(scl, section);
+    return 0;
+}
+
+static int ram_block_attribute_for_each_shared_section(const RamBlockAttribute *attr,
+                                                       MemoryRegionSection *section,
+                                                       void *arg,
+                                                       ram_block_attribute_section_cb cb)
+{
+    unsigned long first_bit, last_bit;
+    uint64_t offset, size;
+    const int block_size = ram_block_attribute_get_block_size(attr);
+    int ret = 0;
+
+    first_bit = section->offset_within_region / block_size;
+    first_bit = find_next_bit(attr->shared_bitmap, attr->shared_bitmap_size, first_bit);
+
+    while (first_bit < attr->shared_bitmap_size) {
+        MemoryRegionSection tmp = *section;
+
+        offset = first_bit * block_size;
+        last_bit = find_next_zero_bit(attr->shared_bitmap, attr->shared_bitmap_size,
+                                      first_bit + 1) - 1;
+        size = (last_bit - first_bit + 1) * block_size;
+
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            break;
+        }
+
+        ret = cb(&tmp, arg);
+        if (ret) {
+            error_report("%s: Failed to notify RAM discard listener: %s", __func__,
+                         strerror(-ret));
+            break;
+        }
+
+        first_bit = find_next_bit(attr->shared_bitmap, attr->shared_bitmap_size,
+                                  last_bit + 2);
+    }
+
+    return ret;
+}
+
+static int ram_block_attribute_for_each_private_section(const RamBlockAttribute *attr,
+                                                        MemoryRegionSection *section,
+                                                        void *arg,
+                                                        ram_block_attribute_section_cb cb)
+{
+    unsigned long first_bit, last_bit;
+    uint64_t offset, size;
+    const int block_size = ram_block_attribute_get_block_size(attr);
+    int ret = 0;
+
+    first_bit = section->offset_within_region / block_size;
+    first_bit = find_next_zero_bit(attr->shared_bitmap, attr->shared_bitmap_size,
+                                   first_bit);
+
+    while (first_bit < attr->shared_bitmap_size) {
+        MemoryRegionSection tmp = *section;
+
+        offset = first_bit * block_size;
+        last_bit = find_next_bit(attr->shared_bitmap, attr->shared_bitmap_size,
+                                      first_bit + 1) - 1;
+        size = (last_bit - first_bit + 1) * block_size;
+
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            break;
+        }
+
+        ret = cb(&tmp, arg);
+        if (ret) {
+            error_report("%s: Failed to notify RAM discard listener: %s", __func__,
+                         strerror(-ret));
+            break;
+        }
+
+        first_bit = find_next_zero_bit(attr->shared_bitmap, attr->shared_bitmap_size,
+                                       last_bit + 2);
+    }
+
+    return ret;
+}
+
+static uint64_t ram_block_attribute_psm_get_min_granularity(const GenericStateManager *gsm,
+                                                            const MemoryRegion *mr)
+{
+    const RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
+
+    g_assert(mr == attr->mr);
+    return ram_block_attribute_get_block_size(attr);
+}
+
+static void ram_block_attribute_psm_register_listener(GenericStateManager *gsm,
+                                                      StateChangeListener *scl,
+                                                      MemoryRegionSection *section)
+{
+    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
+    PrivateSharedListener *psl = container_of(scl, PrivateSharedListener, scl);
+    int ret;
+
+    g_assert(section->mr == attr->mr);
+    scl->section = memory_region_section_new_copy(section);
+
+    QLIST_INSERT_HEAD(&attr->psl_list, psl, next);
+
+    ret = ram_block_attribute_for_each_shared_section(attr, section, scl,
+                                                      ram_block_attribute_notify_shared_cb);
+    if (ret) {
+        error_report("%s: Failed to register RAM discard listener: %s", __func__,
+                     strerror(-ret));
+    }
+}
+
+static void ram_block_attribute_psm_unregister_listener(GenericStateManager *gsm,
+                                                        StateChangeListener *scl)
+{
+    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
+    PrivateSharedListener *psl = container_of(scl, PrivateSharedListener, scl);
+    int ret;
+
+    g_assert(scl->section);
+    g_assert(scl->section->mr == attr->mr);
+
+    ret = ram_block_attribute_for_each_shared_section(attr, scl->section, scl,
+                                                      ram_block_attribute_notify_private_cb);
+    if (ret) {
+        error_report("%s: Failed to unregister RAM discard listener: %s", __func__,
+                     strerror(-ret));
+    }
+
+    memory_region_section_free_copy(scl->section);
+    scl->section = NULL;
+    QLIST_REMOVE(psl, next);
+}
+
+typedef struct RamBlockAttributeReplayData {
+    ReplayStateChange fn;
+    void *opaque;
+} RamBlockAttributeReplayData;
+
+static int ram_block_attribute_psm_replay_cb(MemoryRegionSection *section, void *arg)
+{
+    RamBlockAttributeReplayData *data = arg;
+
+    return data->fn(section, data->opaque);
+}
+
+static int ram_block_attribute_psm_replay_on_shared(const GenericStateManager *gsm,
+                                                    MemoryRegionSection *section,
+                                                    ReplayStateChange replay_fn,
+                                                    void *opaque)
+{
+    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
+    RamBlockAttributeReplayData data = { .fn = replay_fn, .opaque = opaque };
+
+    g_assert(section->mr == attr->mr);
+    return ram_block_attribute_for_each_shared_section(attr, section, &data,
+                                                       ram_block_attribute_psm_replay_cb);
+}
+
+static int ram_block_attribute_psm_replay_on_private(const GenericStateManager *gsm,
+                                                     MemoryRegionSection *section,
+                                                     ReplayStateChange replay_fn,
+                                                     void *opaque)
+{
+    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
+    RamBlockAttributeReplayData data = { .fn = replay_fn, .opaque = opaque };
+
+    g_assert(section->mr == attr->mr);
+    return ram_block_attribute_for_each_private_section(attr, section, &data,
+                                                        ram_block_attribute_psm_replay_cb);
+}
+
+int ram_block_attribute_realize(RamBlockAttribute *attr, MemoryRegion *mr)
+{
+    uint64_t shared_bitmap_size;
+    const int block_size  = qemu_real_host_page_size();
+    int ret;
+
+    shared_bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
+
+    attr->mr = mr;
+    ret = memory_region_set_generic_state_manager(mr, GENERIC_STATE_MANAGER(attr));
+    if (ret) {
+        return ret;
+    }
+    attr->shared_bitmap_size = shared_bitmap_size;
+    attr->shared_bitmap = bitmap_new(shared_bitmap_size);
+
+    return ret;
+}
+
+void ram_block_attribute_unrealize(RamBlockAttribute *attr)
+{
+    g_free(attr->shared_bitmap);
+    memory_region_set_generic_state_manager(attr->mr, NULL);
+}
+
+static void ram_block_attribute_init(Object *obj)
+{
+    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(obj);
+
+    QLIST_INIT(&attr->psl_list);
+}
+
+static void ram_block_attribute_finalize(Object *obj)
+{
+}
+
+static void ram_block_attribute_class_init(ObjectClass *oc, void *data)
+{
+    GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_CLASS(oc);
+
+    gsmc->get_min_granularity = ram_block_attribute_psm_get_min_granularity;
+    gsmc->register_listener = ram_block_attribute_psm_register_listener;
+    gsmc->unregister_listener = ram_block_attribute_psm_unregister_listener;
+    gsmc->is_state_set = ram_block_attribute_psm_is_shared;
+    gsmc->replay_on_state_set = ram_block_attribute_psm_replay_on_shared;
+    gsmc->replay_on_state_clear = ram_block_attribute_psm_replay_on_private;
+}
-- 
2.43.5


