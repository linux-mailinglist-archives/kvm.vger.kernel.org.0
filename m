Return-Path: <kvm+bounces-47106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4524EABD519
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 12:34:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 603254C14F6
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A46427979B;
	Tue, 20 May 2025 10:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EaxejQba"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A990D26C398
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 10:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747736964; cv=none; b=fDLRhkB73my7UQoghDsmB0ohfxkxjfHbwkRAhu4k9OYba1G4aDtEKIbyzWc3Ou4tCBkDfNfZ1Z0oCI2zsvN1+UVCCz5Q/eiVFIs6hT6nk0ZAEc+wicSpfen1i4EUAkhPYkHvZxZ1ykcSbgsaFt47RXU1UgcjwSSAjk04e1HExUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747736964; c=relaxed/simple;
	bh=xjsSyyH/vKZhnfoKeplftZcDafjUAYrMzMyTUKLznE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efk64Sbs3FIpdaskOA9fd8PSUCs/EW81xGf6hKiUCzJC3zvrrQhswZUVDsggKIHXKE4+tt/Tjo1a+VRvl/mAuBbv1R62lfhk7FK3d+qufIVtChAy3+J8rPvNE904g4tqyubdmbrd4PCtDZBLbFx159T0FX6U0EQz/q4OCSHpWo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EaxejQba; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747736963; x=1779272963;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xjsSyyH/vKZhnfoKeplftZcDafjUAYrMzMyTUKLznE8=;
  b=EaxejQbaYw0DbpCC59qNSHPd2npE2Vj+5VLAX2KgXsSMwCuj0B15iAHI
   hgGvVouEaojXFt8cdJKM+q+aSrL4KFcx6kgm18asQr6fuFeeleHrN5OUT
   MlYj6+gv76uhEX06oVIiJBD9/CqfRjOEUWWbl34V1Xtgof0DSoeNOSqZv
   UaI64vDm60Ux5cHRum7zrW8tCBwbVZcAlhb0d3s66ZwIotSniaunjbsgQ
   QxGxvR4GRnjyk60n2v0kI/5T0BX13jMEmiYSUW0gIwn0vKJ5ix1tpDP0J
   DCpfF6edBdEK57KxdxAy4IcfRRLnMk2WUauwRyqLo8lefq5P5POKXglA4
   A==;
X-CSE-ConnectionGUID: 5mLsz3bKR4mzptfmOkX0qw==
X-CSE-MsgGUID: D6h+Y6IiT5O3k/3pPIOlGw==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49566660"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49566660"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:23 -0700
X-CSE-ConnectionGUID: Lph/xiMcRAauSxFu6majOw==
X-CSE-MsgGUID: gmuyuwicRxWHnua84DPXKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144905255"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:19 -0700
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
Subject: [PATCH v5 05/10] ram-block-attribute: Introduce a helper to notify shared/private state changes
Date: Tue, 20 May 2025 18:28:45 +0800
Message-ID: <20250520102856.132417-6-chenyi.qiang@intel.com>
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

A new state_change() helper is introduced for RamBlockAttribute
to efficiently notify all registered RamDiscardListeners, including
VFIO listeners, about memory conversion events in guest_memfd. The VFIO
listener can dynamically DMA map/unmap shared pages based on conversion
types:
- For conversions from shared to private, the VFIO system ensures the
  discarding of shared mapping from the IOMMU.
- For conversions from private to shared, it triggers the population of
  the shared mapping into the IOMMU.

Currently, memory conversion failures cause QEMU to quit instead of
resuming the guest or retrying the operation. It would be a future work
to add more error handling or rollback mechanisms once conversion
failures are allowed. For example, in-place conversion of guest_memfd
could retry the unmap operation during the conversion from shared to
private. However, for now, keep the complex error handling out of the
picture as it is not required:

- If a conversion request is made for a page already in the desired
  state, the helper simply returns success.
- For requests involving a range partially in the desired state, there
  is no such scenario in practice at present. Simply return error.
- If a conversion request is declined by other systems, such as a
  failure from VFIO during notify_to_populated(), the failure is
  returned directly. As for notify_to_discard(), VFIO cannot fail
  unmap/unpin, so no error is returned.

Note that the bitmap status is updated before callbacks, allowing
listeners to handle memory based on the latest status.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Change in v5:
    - Move the state_change() back to a helper instead of a callback of
      the class since there's no child for the RamBlockAttributeClass.
    - Remove the error handling and move them to an individual patch for
      simple management.

Changes in v4:
    - Add the state_change() callback in PrivateSharedManagerClass
      instead of the RamBlockAttribute.

Changes in v3:
    - Move the bitmap update before notifier callbacks.
    - Call the notifier callbacks directly in notify_discard/populate()
      with the expectation that the request memory range is in the
      desired attribute.
    - For the case that only partial range in the desire status, handle
      the range with block_size granularity for ease of rollback
      (https://lore.kernel.org/qemu-devel/812768d7-a02d-4b29-95f3-fb7a125cf54e@redhat.com/)

Changes in v2:
    - Do the alignment changes due to the rename to MemoryAttributeManager
    - Move the state_change() helper definition in this patch.
---
 include/system/ramblock.h    |   2 +
 system/ram-block-attribute.c | 134 +++++++++++++++++++++++++++++++++++
 2 files changed, 136 insertions(+)

diff --git a/include/system/ramblock.h b/include/system/ramblock.h
index 09255e8495..270dffb2f3 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -108,6 +108,8 @@ struct RamBlockAttribute {
     QLIST_HEAD(, RamDiscardListener) rdl_list;
 };
 
+int ram_block_attribute_state_change(RamBlockAttribute *attr, uint64_t offset,
+                                     uint64_t size, bool to_private);
 RamBlockAttribute *ram_block_attribute_create(MemoryRegion *mr);
 void ram_block_attribute_destroy(RamBlockAttribute *attr);
 
diff --git a/system/ram-block-attribute.c b/system/ram-block-attribute.c
index 8d4a24738c..f12dd4b881 100644
--- a/system/ram-block-attribute.c
+++ b/system/ram-block-attribute.c
@@ -253,6 +253,140 @@ ram_block_attribute_rdm_replay_discard(const RamDiscardManager *rdm,
                                             ram_block_attribute_rdm_replay_cb);
 }
 
+static bool ram_block_attribute_is_valid_range(RamBlockAttribute *attr,
+                                               uint64_t offset, uint64_t size)
+{
+    MemoryRegion *mr = attr->mr;
+
+    g_assert(mr);
+
+    uint64_t region_size = memory_region_size(mr);
+    int block_size = ram_block_attribute_get_block_size(attr);
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
+static void ram_block_attribute_notify_to_discard(RamBlockAttribute *attr,
+                                                  uint64_t offset,
+                                                  uint64_t size)
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
+ram_block_attribute_notify_to_populated(RamBlockAttribute *attr,
+                                        uint64_t offset, uint64_t size)
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
+static bool ram_block_attribute_is_range_populated(RamBlockAttribute *attr,
+                                                   uint64_t offset,
+                                                   uint64_t size)
+{
+    const int block_size = ram_block_attribute_get_block_size(attr);
+    const unsigned long first_bit = offset / block_size;
+    const unsigned long last_bit = first_bit + (size / block_size) - 1;
+    unsigned long found_bit;
+
+    /* We fake a shorter bitmap to avoid searching too far. */
+    found_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
+                                   first_bit);
+    return found_bit > last_bit;
+}
+
+static bool
+ram_block_attribute_is_range_discard(RamBlockAttribute *attr,
+                                     uint64_t offset, uint64_t size)
+{
+    const int block_size = ram_block_attribute_get_block_size(attr);
+    const unsigned long first_bit = offset / block_size;
+    const unsigned long last_bit = first_bit + (size / block_size) - 1;
+    unsigned long found_bit;
+
+    /* We fake a shorter bitmap to avoid searching too far. */
+    found_bit = find_next_bit(attr->bitmap, last_bit + 1, first_bit);
+    return found_bit > last_bit;
+}
+
+int ram_block_attribute_state_change(RamBlockAttribute *attr, uint64_t offset,
+                                     uint64_t size, bool to_private)
+{
+    const int block_size = ram_block_attribute_get_block_size(attr);
+    const unsigned long first_bit = offset / block_size;
+    const unsigned long nbits = size / block_size;
+    int ret = 0;
+
+    if (!ram_block_attribute_is_valid_range(attr, offset, size)) {
+        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
+                     __func__, offset, size);
+        return -1;
+    }
+
+    /* Already discard/populated */
+    if ((ram_block_attribute_is_range_discard(attr, offset, size) &&
+         to_private) ||
+        (ram_block_attribute_is_range_populated(attr, offset, size) &&
+         !to_private)) {
+        return 0;
+    }
+
+    /* Unexpected mixture */
+    if ((!ram_block_attribute_is_range_populated(attr, offset, size) &&
+         to_private) ||
+        (!ram_block_attribute_is_range_discard(attr, offset, size) &&
+         !to_private)) {
+        error_report("%s, the range is not all in the desired state: "
+                     "(offset 0x%lx, size 0x%lx), %s",
+                     __func__, offset, size,
+                     to_private ? "private" : "shared");
+        return -1;
+    }
+
+    if (to_private) {
+        bitmap_clear(attr->bitmap, first_bit, nbits);
+        ram_block_attribute_notify_to_discard(attr, offset, size);
+    } else {
+        bitmap_set(attr->bitmap, first_bit, nbits);
+        ret = ram_block_attribute_notify_to_populated(attr, offset, size);
+    }
+
+    return ret;
+}
+
 RamBlockAttribute *ram_block_attribute_create(MemoryRegion *mr)
 {
     uint64_t bitmap_size;
-- 
2.43.5


