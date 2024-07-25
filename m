Return-Path: <kvm+bounces-22215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A363493BD04
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 09:22:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 591A8282E2B
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 07:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B22016F85A;
	Thu, 25 Jul 2024 07:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cmiJT+8t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E558E4428
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 07:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721892167; cv=none; b=RSqvgVTXsNTZ+k90tICzqGS3aGLkBV4AdGYaAQW57O1qUwrQMotrVVM1fNl+Vjke/1CZld2rtcGJyaQoLc+CJTT8gNKcbmk+1XJtd/qgmpW1dancFHbcLhqkG8OXEOVXDNF1Yk31dzRyDBgStX2k6yhUqOIFWDhMee3P7XPRlnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721892167; c=relaxed/simple;
	bh=w97J4M33cCw9TAhSRTajDSuiBoryiegLBL0geGMjfTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0yXZ48+0KXWMD1XqRBnbsRfVljUJM2ZHQnbVd3E90mc6x0y5ICdw5+dA+Q0I7Cl4JBGmBQhiGysBW0KJ+lLeEKlMD8V7ZKrOyuimy3aMoLRPFt3HT+0s2svoRuLs5HojmSmhszu/tzViD8XTiebekB7k1DgIoeW9yRvH5X+3cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cmiJT+8t; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721892166; x=1753428166;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w97J4M33cCw9TAhSRTajDSuiBoryiegLBL0geGMjfTo=;
  b=cmiJT+8tvPGwoaCXMsSWzdXOKM9D2Z7gHVn4ubyx/5DHYaUEBY0kRpXY
   hcMrnaVZJtJz2EL09YbPgD2pWWgiElwvz+GfCkdyPFW06OisyCc2o7uXN
   XBCzUZUmkSpoVEYPx0TObjSylpgi0mYTf7FOzCQDy9p38C6hCVO3r5I+r
   XXKYqSdXgJGnrBNn5KEdulQqSGP37FMfmmtAbf6s3lKWAKj87tcD/dIvS
   qby5SY/I1Pi8cFeucJFBAuY87Rc3SNLG0i14fBy6og9Z8c23KVLN+ZMAN
   f1P0hLK7XURbXt1OCkYVj8o9p3zEny4OMBQ+kQ6XbQGffN8NJyC6piEgG
   Q==;
X-CSE-ConnectionGUID: 4E5F2MM0SPGVPzfMFYBH7A==
X-CSE-MsgGUID: azadoBnpRKqADrR/TzwQUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="30753940"
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="30753940"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 00:22:46 -0700
X-CSE-ConnectionGUID: trBWNliyQSCF+mniCghpGg==
X-CSE-MsgGUID: Cj11aMxMTk2JVZHfE+JW4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="52858154"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 00:22:43 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Edgecombe Rick P <rick.p.edgecombe@intel.com>,
	Wang Wei W <wei.w.wang@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Wu Hao <hao.wu@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: [RFC PATCH 2/6] guest_memfd: Introduce a helper to notify the shared/private state change
Date: Thu, 25 Jul 2024 03:21:11 -0400
Message-ID: <20240725072118.358923-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240725072118.358923-1-chenyi.qiang@intel.com>
References: <20240725072118.358923-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a helper function within RamDiscardManager to efficiently
notify all registered RamDiscardListeners, including VFIO listeners
about the memory conversion events between shared and private in
guest_memfd. The existing VFIO listener can dynamically DMA map/unmap
the shared pages based on the conversion type:
- For conversions from shared to private, the VFIO system ensures the
  discarding of shared mapping from the IOMMU.
- For conversions from private to shared, it triggers the population of
  the shared mapping into the IOMMU.

Additionally, there could be some special conversion requests:
- When a conversion request is made for a page already in the desired
  state (either private or shared), the helper simply returns success.
- For requests involving a range partially in the desired state, only
  the necessary segments are converted, ensuring the entire range
  complies with the request efficiently.
- In scenarios where a conversion request is declined by other systems,
  such as a failure from VFIO during notify_populate(), the helper will
  roll back the request, maintaining consistency.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 include/sysemu/guest-memfd-manager.h |   3 +
 system/guest-memfd-manager.c         | 141 +++++++++++++++++++++++++++
 2 files changed, 144 insertions(+)

diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/guest-memfd-manager.h
index ab8c2ba362..1cce4cde43 100644
--- a/include/sysemu/guest-memfd-manager.h
+++ b/include/sysemu/guest-memfd-manager.h
@@ -43,4 +43,7 @@ struct GuestMemfdManagerClass {
     void (*realize)(Object *gmm, MemoryRegion *mr, uint64_t region_size);
 };
 
+int guest_memfd_state_change(GuestMemfdManager *gmm, uint64_t offset, uint64_t size,
+                             bool shared_to_private);
+
 #endif
diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-manager.c
index 7b90f26859..deb43db90b 100644
--- a/system/guest-memfd-manager.c
+++ b/system/guest-memfd-manager.c
@@ -243,6 +243,147 @@ static void guest_memfd_rdm_replay_discarded(const RamDiscardManager *rdm,
                                          guest_memfd_rdm_replay_discarded_cb);
 }
 
+static bool guest_memfd_is_valid_range(GuestMemfdManager *gmm,
+                                       uint64_t offset, uint64_t size)
+{
+    MemoryRegion *mr = gmm->mr;
+
+    g_assert(mr);
+
+    uint64_t region_size = memory_region_size(mr);
+    if (!QEMU_IS_ALIGNED(offset, gmm->block_size)) {
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
+static void guest_memfd_notify_discard(GuestMemfdManager *gmm,
+                                       uint64_t offset, uint64_t size)
+{
+    RamDiscardListener *rdl;
+
+    QLIST_FOREACH(rdl, &gmm->rdl_list, next) {
+        MemoryRegionSection tmp = *rdl->section;
+
+        if (!guest_memfd_rdm_intersect_memory_section(&tmp, offset, size)) {
+            continue;
+        }
+
+        guest_memfd_for_each_populated_range(gmm, &tmp, rdl,
+                                             guest_memfd_notify_discard_cb);
+    }
+}
+
+
+static int guest_memfd_notify_populate(GuestMemfdManager *gmm,
+                                       uint64_t offset, uint64_t size)
+{
+    RamDiscardListener *rdl, *rdl2;
+    int ret = 0;
+
+    QLIST_FOREACH(rdl, &gmm->rdl_list, next) {
+        MemoryRegionSection tmp = *rdl->section;
+
+        if (!guest_memfd_rdm_intersect_memory_section(&tmp, offset, size)) {
+            continue;
+        }
+
+        ret = guest_memfd_for_each_discarded_range(gmm, &tmp, rdl,
+                                                   guest_memfd_notify_populate_cb);
+        if (ret) {
+            break;
+        }
+    }
+
+    if (ret) {
+        /* Notify all already-notified listeners. */
+        QLIST_FOREACH(rdl2, &gmm->rdl_list, next) {
+            MemoryRegionSection tmp = *rdl2->section;
+
+            if (rdl2 == rdl) {
+                break;
+            }
+            if (!guest_memfd_rdm_intersect_memory_section(&tmp, offset, size)) {
+                continue;
+            }
+
+            guest_memfd_for_each_discarded_range(gmm, &tmp, rdl2,
+                                                 guest_memfd_notify_discard_cb);
+        }
+    }
+    return ret;
+}
+
+static bool guest_memfd_is_range_populated(GuestMemfdManager *gmm,
+                                           uint64_t offset, uint64_t size)
+{
+    const unsigned long first_bit = offset / gmm->block_size;
+    const unsigned long last_bit = first_bit + (size / gmm->block_size) - 1;
+    unsigned long found_bit;
+
+    /* We fake a shorter bitmap to avoid searching too far. */
+    found_bit = find_next_bit(gmm->discard_bitmap, last_bit + 1, first_bit);
+    return found_bit > last_bit;
+}
+
+static bool guest_memfd_is_range_discarded(GuestMemfdManager *gmm,
+                                           uint64_t offset, uint64_t size)
+{
+    const unsigned long first_bit = offset / gmm->block_size;
+    const unsigned long last_bit = first_bit + (size / gmm->block_size) - 1;
+    unsigned long found_bit;
+
+    /* We fake a shorter bitmap to avoid searching too far. */
+    found_bit = find_next_zero_bit(gmm->discard_bitmap, last_bit + 1, first_bit);
+    return found_bit > last_bit;
+}
+
+int guest_memfd_state_change(GuestMemfdManager *gmm, uint64_t offset, uint64_t size,
+                             bool shared_to_private)
+{
+    int ret = 0;
+
+    if (!guest_memfd_is_valid_range(gmm, offset, size)) {
+        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
+                     __func__, offset, size);
+        return -1;
+    }
+
+    if ((shared_to_private && guest_memfd_is_range_discarded(gmm, offset, size)) ||
+        (!shared_to_private && guest_memfd_is_range_populated(gmm, offset, size))) {
+        return 0;
+    }
+
+    if (shared_to_private) {
+        guest_memfd_notify_discard(gmm, offset, size);
+    } else {
+        ret = guest_memfd_notify_populate(gmm, offset, size);
+    }
+
+    if (!ret) {
+        unsigned long first_bit = offset / gmm->block_size;
+        unsigned long nbits = size / gmm->block_size;
+
+        g_assert((first_bit + nbits) <= gmm->discard_bitmap_size);
+
+        if (shared_to_private) {
+            bitmap_set(gmm->discard_bitmap, first_bit, nbits);
+        } else {
+            bitmap_clear(gmm->discard_bitmap, first_bit, nbits);
+        }
+
+        return 0;
+    }
+
+    return ret;
+}
+
 static void guest_memfd_manager_realize(Object *obj, MemoryRegion *mr,
                                         uint64_t region_size)
 {
-- 
2.43.5


