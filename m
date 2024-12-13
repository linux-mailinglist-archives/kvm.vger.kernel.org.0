Return-Path: <kvm+bounces-33693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 584489F0533
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 08:09:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D8F51889FC9
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 07:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58EE118F2D4;
	Fri, 13 Dec 2024 07:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jgFOmK9H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AA718FC8C
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 07:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734073767; cv=none; b=nywbkiBSpMuzpvvu8XWUL8gDs/lcpjwHLdyFo1llzmZNAYqyZ2j2V03yqg0k9l80a9YpZUIIym9H2TOF7rEV+D4/Tg05CgRdTek2msrg6GX7lE7VxrmNA950lGTBjR4aTL0L0mNYBClG+NeVS2bmJEYicZqCM5ZaUzEWdsMEvfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734073767; c=relaxed/simple;
	bh=clDYu4irPfldg6nv/XSDBXCk/lCoW+l/KtnHIqDPmow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iotkDdrqquv2F+Qmz7QuQdug3+Xzex4iuyM8gx8IuAurxbOHIXuVVGQDO0BSbHwS2oWnjQKIIkdDfZCbcd0d5OL17x1K2VZlVQ/c5g6pThQ4BsIcJA4eG1GFhBxaKPOKFDUCynBPbmOBQ6MXhKlq3T85Jx3bccRB+aTU9Pyvfuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jgFOmK9H; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734073766; x=1765609766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=clDYu4irPfldg6nv/XSDBXCk/lCoW+l/KtnHIqDPmow=;
  b=jgFOmK9H49F8OUmXAomC97WrnTE7ClXeYm3dKosV7XevV3yDObAjSjeo
   CQan/28s/kOAyIvN9HS3/aqBREc6sQU98VWE5rUBKUjMmNxMCQAyav3GH
   /4gWXCgI2N1uMWua0O1C9gl5NCmmgx2E5NgwHwzXuk/zvoByH9o4ImqgJ
   Vx9hjJcOiDHVo9rS0DrPZFX3uOzDCyRmrQBk3/1Pm8W8yUCmEhlUglBmA
   H66GhVXZbs7I6tbGS74MzO3jzqZWCNmfOpTWqTharl3ck1Lkyx1r9vQrC
   zWbm9TrnyKzneAMHPh+UF/6Kb/lJthlpSkJG8pllRpz26W4EN1m1jiYji
   g==;
X-CSE-ConnectionGUID: gb3buA+iTfm1Q9jHcngUeQ==
X-CSE-MsgGUID: YZzTDSH/Q3umkjFl6X5TaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="51937083"
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="51937083"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 23:09:26 -0800
X-CSE-ConnectionGUID: /kKuGrECQ462TJEg+6+ouA==
X-CSE-MsgGUID: TZBRwFL4T86Wddo0G1L9Jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="96365557"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 23:09:22 -0800
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: [PATCH 3/7] guest_memfd: Introduce a callback to notify the shared/private state change
Date: Fri, 13 Dec 2024 15:08:45 +0800
Message-ID: <20241213070852.106092-4-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241213070852.106092-1-chenyi.qiang@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new state_change() callback in GuestMemfdManagerClass to
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

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 include/sysemu/guest-memfd-manager.h |   3 +
 system/guest-memfd-manager.c         | 144 +++++++++++++++++++++++++++
 2 files changed, 147 insertions(+)

diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/guest-memfd-manager.h
index ba4a99b614..f4b175529b 100644
--- a/include/sysemu/guest-memfd-manager.h
+++ b/include/sysemu/guest-memfd-manager.h
@@ -41,6 +41,9 @@ struct GuestMemfdManager {
 
 struct GuestMemfdManagerClass {
     ObjectClass parent_class;
+
+    int (*state_change)(GuestMemfdManager *gmm, uint64_t offset, uint64_t size,
+                        bool shared_to_private);
 };
 
 #endif
diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-manager.c
index d7e105fead..6601df5f3f 100644
--- a/system/guest-memfd-manager.c
+++ b/system/guest-memfd-manager.c
@@ -225,6 +225,147 @@ static void guest_memfd_rdm_replay_discarded(const RamDiscardManager *rdm,
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
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            continue;
+        }
+
+        guest_memfd_for_each_populated_section(gmm, &tmp, rdl,
+                                               guest_memfd_notify_discard_cb);
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
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            continue;
+        }
+
+        ret = guest_memfd_for_each_discarded_section(gmm, &tmp, rdl,
+                                                     guest_memfd_notify_populate_cb);
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
+            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+                continue;
+            }
+
+            guest_memfd_for_each_discarded_section(gmm, &tmp, rdl2,
+                                                   guest_memfd_notify_discard_cb);
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
+    found_bit = find_next_zero_bit(gmm->bitmap, last_bit + 1, first_bit);
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
+    found_bit = find_next_bit(gmm->bitmap, last_bit + 1, first_bit);
+    return found_bit > last_bit;
+}
+
+static int guest_memfd_state_change(GuestMemfdManager *gmm, uint64_t offset,
+                                    uint64_t size, bool shared_to_private)
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
+        g_assert((first_bit + nbits) <= gmm->bitmap_size);
+
+        if (shared_to_private) {
+            bitmap_clear(gmm->bitmap, first_bit, nbits);
+        } else {
+            bitmap_set(gmm->bitmap, first_bit, nbits);
+        }
+
+        return 0;
+    }
+
+    return ret;
+}
+
 static void guest_memfd_manager_init(Object *obj)
 {
     GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
@@ -239,8 +380,11 @@ static void guest_memfd_manager_finalize(Object *obj)
 
 static void guest_memfd_manager_class_init(ObjectClass *oc, void *data)
 {
+    GuestMemfdManagerClass *gmmc = GUEST_MEMFD_MANAGER_CLASS(oc);
     RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
 
+    gmmc->state_change = guest_memfd_state_change;
+
     rdmc->get_min_granularity = guest_memfd_rdm_get_min_granularity;
     rdmc->register_listener = guest_memfd_rdm_register_listener;
     rdmc->unregister_listener = guest_memfd_rdm_unregister_listener;
-- 
2.43.5


