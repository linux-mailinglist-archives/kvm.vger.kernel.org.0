Return-Path: <kvm+bounces-38335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7B23A37CFC
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 09:19:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8FEF3B178C
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 08:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CE761A2564;
	Mon, 17 Feb 2025 08:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PEM1kJt7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B988019EED2
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 08:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739780343; cv=none; b=Ta+y4R4snQ6Ik0L1xlmyTtn8qLQE8ntVNVkTmMOR4qdD1p9oQ7vTz3g0fYoh/cwqk2js1EudGK2RN8XPE2upXRweHDpZXTpc23pb89OL8vgOHcZIGTqap465ZnRvxuQ1RYCgdaVD/vnS8VKelNBmUzfpLSMjTRFiy23Ygx9Wf2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739780343; c=relaxed/simple;
	bh=fgikP9pCs5jC0lyoad1drlNUfTByGFH9gXJjN5Ul2t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcWz9epMutacqRyXtcqWiIPYJlSA/iJZOuf7gL2godlHT+e36s7RF03z3UeOuYUNvvKVp90GFet50E1FAIhImi28a7sL3ssUr3jQzTuIESKSe/Q01ofn6DWr4ko9EB9v3k8BvSAcpnRIwiSa0Kq2D7SFlpbNW6Y2ONKax6irxtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PEM1kJt7; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739780341; x=1771316341;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fgikP9pCs5jC0lyoad1drlNUfTByGFH9gXJjN5Ul2t0=;
  b=PEM1kJt7Nj4Wr0iAVsQSJZvchDJMzFv4YDaBg8mQBiTpwrOwPPw62d3L
   Eo6jAXsA8Nunf1aco4ZKJ2R39dqeDP6NBceRnQ1f3PJkWw0ZRnsimffCI
   k/shqy7tnvjGeQA//gbSs8oL3ERbTruavy7lUX+Ad/pODvBSsF3o6H9Bt
   hQLlmjwwsHIe0iT1CyLJs2eWIc7DaixkjyUYbQCg2DUG5wG7zuD471liY
   SyuB8Vna8FX85mbDqttxNsjcyDZb7U2Z8ZF0lEWOsP7GH7qk+4Y3dLGAz
   EC2t65ntdJRJSAhFv9aaNf6juQVcHZd9xfsJMsU9A3TBN1KQo9IlRzrP6
   A==;
X-CSE-ConnectionGUID: iFIiAP+tRFC5Wq0dMT/oBw==
X-CSE-MsgGUID: 0lJTy72CQRCH5j5bdgajyg==
X-IronPort-AV: E=McAfee;i="6700,10204,11347"; a="50668992"
X-IronPort-AV: E=Sophos;i="6.13,292,1732608000"; 
   d="scan'208";a="50668992"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 00:19:01 -0800
X-CSE-ConnectionGUID: 4++vfEfLQc+TGqj/kWLFbw==
X-CSE-MsgGUID: nF3NBRcjRM+gJeJNBwQ0gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118690233"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 00:18:58 -0800
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>,
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
Subject: [PATCH v2 4/6] memory-attribute-manager: Introduce a callback to notify the shared/private state change
Date: Mon, 17 Feb 2025 16:18:23 +0800
Message-ID: <20250217081833.21568-5-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250217081833.21568-1-chenyi.qiang@intel.com>
References: <20250217081833.21568-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new state_change() callback in MemoryAttributeManagerClass to
efficiently notify all registered RamDiscardListeners, including VFIO
listeners about the memory conversion events in guest_memfd. The
existing VFIO listener can dynamically DMA map/unmap the shared pages
based on conversion types:
- For conversions from shared to private, the VFIO system ensures the
  discarding of shared mapping from the IOMMU.
- For conversions from private to shared, it triggers the population of
  the shared mapping into the IOMMU.

Additionally, there could be some special conversion requests:
- When a conversion request is made for a page already in the desired
  state, the helper simply returns success.
- For requests involving a range partially in the desired state, only
  the necessary segments are converted, ensuring the entire range
  complies with the request efficiently.
- In scenarios where a conversion request is declined by other systems,
  such as a failure from VFIO during notify_populate(), the helper will
  roll back the request, maintaining consistency.

Opportunistically introduce a helper to trigger the state_change()
callback of the class.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v2:
    - Do the alignment changes due to the rename to MemoryAttributeManager
    - Move the state_change() helper definition in this patch.
---
 include/system/memory-attribute-manager.h |  20 +++
 system/memory-attribute-manager.c         | 148 ++++++++++++++++++++++
 2 files changed, 168 insertions(+)

diff --git a/include/system/memory-attribute-manager.h b/include/system/memory-attribute-manager.h
index 72adc0028e..c3dab4e47b 100644
--- a/include/system/memory-attribute-manager.h
+++ b/include/system/memory-attribute-manager.h
@@ -34,8 +34,28 @@ struct MemoryAttributeManager {
 
 struct MemoryAttributeManagerClass {
     ObjectClass parent_class;
+
+    int (*state_change)(MemoryAttributeManager *mgr, uint64_t offset, uint64_t size,
+                        bool shared_to_private);
 };
 
+static inline int memory_attribute_manager_state_change(MemoryAttributeManager *mgr, uint64_t offset,
+                                                        uint64_t size, bool shared_to_private)
+{
+    MemoryAttributeManagerClass *klass;
+
+    if (mgr == NULL) {
+        return 0;
+    }
+
+    klass = MEMORY_ATTRIBUTE_MANAGER_GET_CLASS(mgr);
+    if (klass->state_change) {
+        return klass->state_change(mgr, offset, size, shared_to_private);
+    }
+
+    return 0;
+}
+
 int memory_attribute_manager_realize(MemoryAttributeManager *mgr, MemoryRegion *mr);
 void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr);
 
diff --git a/system/memory-attribute-manager.c b/system/memory-attribute-manager.c
index ed97e43dd0..17c70cf677 100644
--- a/system/memory-attribute-manager.c
+++ b/system/memory-attribute-manager.c
@@ -241,6 +241,151 @@ static void memory_attribute_rdm_replay_discarded(const RamDiscardManager *rdm,
                                                 memory_attribute_rdm_replay_discarded_cb);
 }
 
+static bool memory_attribute_is_valid_range(MemoryAttributeManager *mgr,
+                                            uint64_t offset, uint64_t size)
+{
+    MemoryRegion *mr = mgr->mr;
+
+    g_assert(mr);
+
+    uint64_t region_size = memory_region_size(mr);
+    int block_size = memory_attribute_manager_get_block_size(mgr);
+
+    if (!QEMU_IS_ALIGNED(offset, block_size)) {
+        return false;
+    }
+    if (offset + size < offset || !size) {
+        return false;
+    }
+    if (offset >= region_size || offset + size > region_size) {
+        return false;
+    }
+    return true;
+}
+
+static void memory_attribute_notify_discard(MemoryAttributeManager *mgr,
+                                            uint64_t offset, uint64_t size)
+{
+    RamDiscardListener *rdl;
+
+    QLIST_FOREACH(rdl, &mgr->rdl_list, next) {
+        MemoryRegionSection tmp = *rdl->section;
+
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            continue;
+        }
+
+        memory_attribute_for_each_populated_section(mgr, &tmp, rdl,
+                                                    memory_attribute_notify_discard_cb);
+    }
+}
+
+static int memory_attribute_notify_populate(MemoryAttributeManager *mgr,
+                                            uint64_t offset, uint64_t size)
+{
+    RamDiscardListener *rdl, *rdl2;
+    int ret = 0;
+
+    QLIST_FOREACH(rdl, &mgr->rdl_list, next) {
+        MemoryRegionSection tmp = *rdl->section;
+
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            continue;
+        }
+
+        ret = memory_attribute_for_each_discarded_section(mgr, &tmp, rdl,
+                                                          memory_attribute_notify_populate_cb);
+        if (ret) {
+            break;
+        }
+    }
+
+    if (ret) {
+        /* Notify all already-notified listeners. */
+        QLIST_FOREACH(rdl2, &mgr->rdl_list, next) {
+            MemoryRegionSection tmp = *rdl2->section;
+
+            if (rdl2 == rdl) {
+                break;
+            }
+            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+                continue;
+            }
+
+            memory_attribute_for_each_discarded_section(mgr, &tmp, rdl2,
+                                                        memory_attribute_notify_discard_cb);
+        }
+    }
+    return ret;
+}
+
+static bool memory_attribute_is_range_populated(MemoryAttributeManager *mgr,
+                                                uint64_t offset, uint64_t size)
+{
+    int block_size = memory_attribute_manager_get_block_size(mgr);
+    const unsigned long first_bit = offset / block_size;
+    const unsigned long last_bit = first_bit + (size / block_size) - 1;
+    unsigned long found_bit;
+
+    /* We fake a shorter bitmap to avoid searching too far. */
+    found_bit = find_next_zero_bit(mgr->shared_bitmap, last_bit + 1, first_bit);
+    return found_bit > last_bit;
+}
+
+static bool memory_attribute_is_range_discarded(MemoryAttributeManager *mgr,
+                                                uint64_t offset, uint64_t size)
+{
+    int block_size = memory_attribute_manager_get_block_size(mgr);
+    const unsigned long first_bit = offset / block_size;
+    const unsigned long last_bit = first_bit + (size / block_size) - 1;
+    unsigned long found_bit;
+
+    /* We fake a shorter bitmap to avoid searching too far. */
+    found_bit = find_next_bit(mgr->shared_bitmap, last_bit + 1, first_bit);
+    return found_bit > last_bit;
+}
+
+static int memory_attribute_state_change(MemoryAttributeManager *mgr, uint64_t offset,
+                                         uint64_t size, bool shared_to_private)
+{
+    int block_size = memory_attribute_manager_get_block_size(mgr);
+    int ret = 0;
+
+    if (!memory_attribute_is_valid_range(mgr, offset, size)) {
+        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
+                     __func__, offset, size);
+        return -1;
+    }
+
+    if ((shared_to_private && memory_attribute_is_range_discarded(mgr, offset, size)) ||
+        (!shared_to_private && memory_attribute_is_range_populated(mgr, offset, size))) {
+        return 0;
+    }
+
+    if (shared_to_private) {
+        memory_attribute_notify_discard(mgr, offset, size);
+    } else {
+        ret = memory_attribute_notify_populate(mgr, offset, size);
+    }
+
+    if (!ret) {
+        unsigned long first_bit = offset / block_size;
+        unsigned long nbits = size / block_size;
+
+        g_assert((first_bit + nbits) <= mgr->bitmap_size);
+
+        if (shared_to_private) {
+            bitmap_clear(mgr->shared_bitmap, first_bit, nbits);
+        } else {
+            bitmap_set(mgr->shared_bitmap, first_bit, nbits);
+        }
+
+        return 0;
+    }
+
+    return ret;
+}
+
 int memory_attribute_manager_realize(MemoryAttributeManager *mgr, MemoryRegion *mr)
 {
     uint64_t bitmap_size;
@@ -281,8 +426,11 @@ static void memory_attribute_manager_finalize(Object *obj)
 
 static void memory_attribute_manager_class_init(ObjectClass *oc, void *data)
 {
+    MemoryAttributeManagerClass *mamc = MEMORY_ATTRIBUTE_MANAGER_CLASS(oc);
     RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
 
+    mamc->state_change = memory_attribute_state_change;
+
     rdmc->get_min_granularity = memory_attribute_rdm_get_min_granularity;
     rdmc->register_listener = memory_attribute_rdm_register_listener;
     rdmc->unregister_listener = memory_attribute_rdm_unregister_listener;
-- 
2.43.5


