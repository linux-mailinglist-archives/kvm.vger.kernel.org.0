Return-Path: <kvm+bounces-54242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E60D5B1D52C
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:47:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAE6218C1C91
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81B8027281B;
	Thu,  7 Aug 2025 09:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GVK8Bjxb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDEC2248BA;
	Thu,  7 Aug 2025 09:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559944; cv=none; b=sZMqnazOTMtHqps5aPgxc+ePWoyVIqskXD3H2cuXUCO9tzlBPLiXn3SkxDL4YYk1EDGdbjqeFX+K5bBvZllEjkkzHkz56sHKYrNvrlfrCv0nswKew7BigI63aXC8YREnRVJz6em8KtgXwVYrB/CmYgsOyNUN+EeRcNFuUrlN1U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559944; c=relaxed/simple;
	bh=0gPnSW7kWlD3BG9ZgnbJ7c79UAuKKhUcXT4xJiEzzQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOqx3thQYPmv7c/JDC6Qv1cn6gKWjh+D9LNFfU0RNW+U17QS3zPTJkBkkN4kinwIxkahv1TyNphAFUgC3uxhoJ8bispczL5CJMbGnJHMc6v2HLghPhpgRREdFlWZGuo9je0ePBlOv+Q8U1B6IssdP2EOCgZSKEejsO4dSQBVWiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GVK8Bjxb; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559943; x=1786095943;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0gPnSW7kWlD3BG9ZgnbJ7c79UAuKKhUcXT4xJiEzzQQ=;
  b=GVK8BjxbzU+wLxi4Sn4vVEZYBWUnSzZedWyofO1R1BsL5F+x7+tYxh8s
   DU6b4QIzT26s2NTBSYtB29OFAUO2ctt6IWmgn/3ze3znxp5BpvtsYmUwL
   Q1mddsOqdG9woZEZXhHaBwq8Re1/7F/QZvuKV04N6SZqA7KRcZT7F7A9e
   L1rRbl3JI3kv3Mq8EkIPAQosinLEvSnoAdzJzIxpdmOZDXiLfZnFND6Hd
   A4mVmb/JI1jrVYpZ9f4eIXXHwuGz+fEnVafqvVfBRM3X5i9I8O/ImPDLs
   KxKQJaC3nBu+FtAtg2+i/Yid/+wJdVIz/I/TIVvaKpu+ymRmeiJwEyw74
   g==;
X-CSE-ConnectionGUID: VSXcA5MpToixWNd+QtLiQA==
X-CSE-MsgGUID: 9bjyJxdlSUykeyGoLsTA/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="56760307"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="56760307"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:45:40 -0700
X-CSE-ConnectionGUID: mpvVwxj9QhSF1KJ3sVmc/A==
X-CSE-MsgGUID: QdGFuQJwQYmNiACUrvBqzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="165382280"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:45:33 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kas@kernel.org,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	thomas.lendacky@amd.com,
	pgonda@google.com,
	zhiquan1.li@intel.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	yan.y.zhao@intel.com
Subject: [RFC PATCH v2 17/23] KVM: guest_memfd: Split for punch hole and private-to-shared conversion
Date: Thu,  7 Aug 2025 17:45:03 +0800
Message-ID: <20250807094503.4691-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250807093950.4395-1-yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In TDX, private page tables require precise zapping because faulting back
the zapped mappings necessitates the guest's re-acceptance. Therefore,
before performing a zap for hole punching and private-to-shared
conversions, huge leafs that cross the boundary of the zapping GFN range in
the mirror page table must be split.

Splitting may result in an error. If this happens, hole punching and
private-to-shared conversion should bail out early and return an error to
userspace.

Splitting is not necessary for kvm_gmem_release() since the entire page
table is being zapped, nor for kvm_gmem_error_folio() as an SPTE must not
map more than one physical folio.

Therefore, in this patch,
- break kvm_gmem_invalidate_begin_and_zap() into
  kvm_gmem_invalidate_begin() and kvm_gmem_zap() and have
  kvm_gmem_release() and kvm_gmem_error_folio() to invoke them.

- have kvm_gmem_punch_hole() to invoke kvm_gmem_invalidate_begin(),
  kvm_gmem_split_private(), and kvm_gmem_zap().
  Bail out if kvm_gmem_split_private() returns error.

- drop the old kvm_gmem_unmap_private() and have private-to-shared
  conversion to invoke kvm_gmem_split_private() and kvm_gmem_zap() instead.
  Bail out if kvm_gmem_split_private() returns error.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- Rebased to [1]. As changes in this patch are gmem specific, they may need
  to be updated if the implementation in [1] changes.
- Update kvm_split_boundary_leafs() to kvm_split_cross_boundary_leafs() and
  invoke it before kvm_gmem_punch_hole() and private-to-shared conversion.

[1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/

RFC v1:
- new patch.
---
 virt/kvm/guest_memfd.c | 142 ++++++++++++++++++++++++-----------------
 1 file changed, 84 insertions(+), 58 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 67aa2285aa49..9edf33c482d7 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -318,14 +318,14 @@ static bool kvm_gmem_has_safe_refcount(struct address_space *mapping, pgoff_t st
 	return refcount_safe;
 }
 
-static void kvm_gmem_unmap_private(struct kvm_gmem *gmem, pgoff_t start,
-				   pgoff_t end)
+static int kvm_gmem_split_private(struct kvm_gmem *gmem, pgoff_t start, pgoff_t end)
 {
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = gmem->kvm;
 	unsigned long index;
 	bool locked = false;
 	bool flush = false;
+	int ret = 0;
 
 	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
 		pgoff_t pgoff = slot->gmem.pgoff;
@@ -335,7 +335,6 @@ static void kvm_gmem_unmap_private(struct kvm_gmem *gmem, pgoff_t start,
 			.end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
 			.slot = slot,
 			.may_block = true,
-			/* This function is only concerned with private mappings. */
 			.attr_filter = KVM_FILTER_PRIVATE,
 		};
 
@@ -344,6 +343,47 @@ static void kvm_gmem_unmap_private(struct kvm_gmem *gmem, pgoff_t start,
 			locked = true;
 		}
 
+		ret = kvm_split_cross_boundary_leafs(kvm, &gfn_range, false);
+		if (ret < 0)
+			goto out;
+
+		flush |= ret;
+		ret = 0;
+	}
+out:
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+
+	if (locked)
+		KVM_MMU_UNLOCK(kvm);
+
+	return ret;
+}
+
+static void kvm_gmem_zap(struct kvm_gmem *gmem, pgoff_t start, pgoff_t end,
+			 enum kvm_gfn_range_filter filter)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm *kvm = gmem->kvm;
+	unsigned long index;
+	bool locked = false;
+	bool flush = false;
+
+	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
+		pgoff_t pgoff = slot->gmem.pgoff;
+		struct kvm_gfn_range gfn_range = {
+			.start = slot->base_gfn + max(pgoff, start) - pgoff,
+			.end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
+			.slot = slot,
+			.may_block = true,
+			.attr_filter = filter,
+		};
+
+		if (!locked) {
+			KVM_MMU_LOCK(kvm);
+			locked = true;
+		}
+
 		flush |= kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
 	}
 
@@ -514,6 +554,8 @@ static int kvm_gmem_convert_should_proceed(struct inode *inode,
 					   struct conversion_work *work,
 					   bool to_shared, pgoff_t *error_index)
 {
+	int ret = 0;
+
 	if (to_shared) {
 		struct list_head *gmem_list;
 		struct kvm_gmem *gmem;
@@ -522,19 +564,24 @@ static int kvm_gmem_convert_should_proceed(struct inode *inode,
 		work_end = work->start + work->nr_pages;
 
 		gmem_list = &inode->i_mapping->i_private_list;
+		list_for_each_entry(gmem, gmem_list, entry) {
+			ret = kvm_gmem_split_private(gmem, work->start, work_end);
+			if (ret)
+				return ret;
+		}
 		list_for_each_entry(gmem, gmem_list, entry)
-			kvm_gmem_unmap_private(gmem, work->start, work_end);
+			kvm_gmem_zap(gmem, work->start, work_end, KVM_FILTER_PRIVATE);
 	} else {
 		unmap_mapping_pages(inode->i_mapping, work->start,
 				    work->nr_pages, false);
 
 		if (!kvm_gmem_has_safe_refcount(inode->i_mapping, work->start,
 						work->nr_pages, error_index)) {
-			return -EAGAIN;
+			ret = -EAGAIN;
 		}
 	}
 
-	return 0;
+	return ret;
 }
 
 static int kvm_gmem_restructure_folios_in_range(struct inode *inode,
@@ -1187,54 +1234,6 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	return ERR_PTR(ret);
 }
 
-static void kvm_gmem_invalidate_begin_and_zap(struct kvm_gmem *gmem,
-					      pgoff_t start, pgoff_t end)
-{
-	bool flush = false, found_memslot = false;
-	struct kvm_memory_slot *slot;
-	struct kvm *kvm = gmem->kvm;
-	unsigned long index;
-
-	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
-		enum kvm_gfn_range_filter filter;
-		pgoff_t pgoff = slot->gmem.pgoff;
-
-		filter = KVM_FILTER_PRIVATE;
-		if (kvm_gmem_memslot_supports_shared(slot)) {
-			/*
-			 * Unmapping would also cause invalidation, but cannot
-			 * rely on mmu_notifiers to do invalidation via
-			 * unmapping, since memory may not be mapped to
-			 * userspace.
-			 */
-			filter |= KVM_FILTER_SHARED;
-		}
-
-		struct kvm_gfn_range gfn_range = {
-			.start = slot->base_gfn + max(pgoff, start) - pgoff,
-			.end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
-			.slot = slot,
-			.may_block = true,
-			.attr_filter = filter,
-		};
-
-		if (!found_memslot) {
-			found_memslot = true;
-
-			KVM_MMU_LOCK(kvm);
-			kvm_mmu_invalidate_begin(kvm);
-		}
-
-		flush |= kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
-	}
-
-	if (flush)
-		kvm_flush_remote_tlbs(kvm);
-
-	if (found_memslot)
-		KVM_MMU_UNLOCK(kvm);
-}
-
 static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
 				    pgoff_t end)
 {
@@ -1445,9 +1444,28 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	filemap_invalidate_lock(inode->i_mapping);
 
 	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_begin_and_zap(gmem, start, end);
+		kvm_gmem_invalidate_begin(gmem, start, end);
 
 	ret = 0;
+	list_for_each_entry(gmem, gmem_list, entry) {
+		ret = kvm_gmem_split_private(gmem, start, end);
+		if (ret)
+			goto out;
+	}
+	list_for_each_entry(gmem, gmem_list, entry) {
+		enum kvm_gfn_range_filter filter;
+
+		/*
+		 * kvm_gmem_invalidate_begin() would have unmapped shared
+		 * mappings via mmu notifiers, but only if those mappings were
+		 * actually set up. Since guest_memfd cannot assume that shared
+		 * mappings were set up, zap both private and shared mappings
+		 * here. If shared mappings were zapped, this should not be
+		 * expensive.
+		 */
+		filter = KVM_FILTER_PRIVATE | KVM_FILTER_SHARED;
+		kvm_gmem_zap(gmem, start, end, filter);
+	}
 	if (kvm_gmem_has_custom_allocator(inode)) {
 		ret = kvm_gmem_truncate_inode_range(inode, offset, offset + len);
 	} else {
@@ -1455,6 +1473,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
 	}
 
+out:
 	list_for_each_entry(gmem, gmem_list, entry)
 		kvm_gmem_invalidate_end(gmem, start, end);
 
@@ -1576,7 +1595,8 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	kvm_gmem_invalidate_begin_and_zap(gmem, 0, -1ul);
+	kvm_gmem_invalidate_begin(gmem, 0, -1ul);
+	kvm_gmem_zap(gmem, 0, -1ul, KVM_FILTER_PRIVATE | KVM_FILTER_SHARED);
 	kvm_gmem_invalidate_end(gmem, 0, -1ul);
 
 	list_del(&gmem->entry);
@@ -1906,8 +1926,14 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
 	start = folio->index;
 	end = start + folio_nr_pages(folio);
 
-	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_begin_and_zap(gmem, start, end);
+	/* The size of the SEPT will not exceed the size of the folio */
+	list_for_each_entry(gmem, gmem_list, entry) {
+		enum kvm_gfn_range_filter filter;
+
+		kvm_gmem_invalidate_begin(gmem, start, end);
+		filter = KVM_FILTER_PRIVATE | KVM_FILTER_SHARED;
+		kvm_gmem_zap(gmem, start, end, filter);
+	}
 
 	/*
 	 * Do not truncate the range, what action is taken in response to the
-- 
2.43.2


