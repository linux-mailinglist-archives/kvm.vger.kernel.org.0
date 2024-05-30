Return-Path: <kvm+bounces-18443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECA9A8D5436
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:09:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2EA3287ABA
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B52218735A;
	Thu, 30 May 2024 21:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AwjVhUl3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0BB183077;
	Thu, 30 May 2024 21:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103257; cv=none; b=bl+0aJF05RNkn8pKzU9W+rSAomsAyPc3OAaBCofrOQWmreNDPbrCeI6UkfigYa09xatU34hLHTzymqz1gZOSwQmVtfxnqndpPrk+gMYeTxg/DdhjZsNml8hGuW5B+Rx7oIqU41AITtFqpclHcE4PgtO8RdKSxBNMNj/lURbl234=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103257; c=relaxed/simple;
	bh=2iYctK+jKy7F5BahSG24GF1pMxCt/5NdpXYUdNpjo/8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UNqTJEe1KF5BFjp724qOT+7s2ptbiy+DRFr1zz7dNJbMMk63R3/5cQu6wScVAwJ6yiFe15oBFX+Agok+QQ4xqL0tOsZ/sVg1QXbOJA1bQx9udJuG7PJMgPbdSkk0YetUItZsWVLaYncV7TOAkPTlc9ziZJ0RWCDILFNUnuq2RQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AwjVhUl3; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717103256; x=1748639256;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2iYctK+jKy7F5BahSG24GF1pMxCt/5NdpXYUdNpjo/8=;
  b=AwjVhUl3AO8k5Xx2Pzb83+sQeqYVW1Y2Ez9uyp6QTuB1ysvTcWCNyXE8
   gmqgpk2Sser2xBxMJgnXaqyxpizZj73htbwleEX8mIPCHyDtVGIKNZBtg
   7KB/KYzMwjmRdEF7A/5wh2T2fB5OZfEsz6jjc9e10echEnwqZ37PUXrz/
   U/8NP9Fgxm9myZ9Ry2KBE/krK1NCayKtcBs53gMld0+alLyPnaCBcZu0n
   aCp/IYEzWvq8hGojx2U9T5dF6GI0ETuWZUAcGRHSFhwblrTRu7Xgh7lKd
   mUbdHFCsaMImbYjkxlibDiINnhjn6eHjuTuIlyGWWDPgNBvYMc7dhdLNW
   A==;
X-CSE-ConnectionGUID: RdJuqp1fRniJAhzd3pQYhA==
X-CSE-MsgGUID: XLcOkzhLRMCFu2zolNaKSg==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="31117107"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="31117107"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:35 -0700
X-CSE-ConnectionGUID: snDJPm/TQGG1IyYD1iJxIA==
X-CSE-MsgGUID: aqbCMl6NTICZwxchRwW/nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35874431"
Received: from hding1-mobl.ccr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.19.65])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:33 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	erdemaktas@google.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	sagis@google.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v2 06/15] KVM: x86/mmu: Support GFN direct mask
Date: Thu, 30 May 2024 14:07:05 -0700
Message-Id: <20240530210714.364118-7-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Teach the MMU to map guest GFNs at a massaged position on the TDP, to aid
in implementing TDX shared memory.

Like other Coco technologies, TDX has the concept of private and shared
memory. For TDX the private and shared mappings are managed on separate
EPT roots. The private half is managed indirectly though calls into a
protected runtime environment called the TDX module, where the shared half
is managed within KVM in normal page tables.

For TDX, the shared half will be mapped in the higher alias, with a "shared
bit" set in the GPA. However, KVM will still manage it with the same
memslots as the private half. This means memslot looks ups and zapping
operations will be provided with a GFN without the shared bit set.

So KVM will either need to apply or strip the shared bit before mapping or
zapping the shared EPT. Having GFN's sometimes have the shared bit and
sometimes not would make the code confusing.

So instead arrange the code such that GFNs never have shared bit set.
Create a concept of a "direct mask", that is stripped from the fault
address when setting fault->gfn, and applied within the TDP MMU iterator.
Calling code will behave as if is operating on the PTE mapping the GFN
(without shared bits) but within the iterator, the actual mappings will be
shifted using a mask specific for the root. Sp's will have the gfn set
without the shared bit. In the end the TDP MMU will behave like it is
mapping things at the GFN without the shared bit but with a strange page
table format where everything is offset by the shared bit.

Since TDX only needs to shift the mapping like this for the shared bit,
which is mapped as the normal TDP root, add a "gfn_direct_mask" field to
the kvm_arch structure for each VM with a default value of 0. It will be
set to the position of the GPA shared bit in GFN through TD specific
initialization code. Keep TDX specific concepts out of the MMU code by not
naming it "shared".

Ranged TLB flushes (i.e. flush_remote_tlbs_range()) target specific GFN
ranges. In convention established above, these would need to target the
shifted GFN range. It won't matter functionally, since the actual
implementation will always result in a full flush for the only planned
user (TDX). But for code clarity, explicitly do the full flush when a
gfn_direct_mask is present.

This leaves one drawback. Some operations use a concept of max gfn (i.e.
kvm_mmu_max_gfn()), to iterate over the whole TDP range. These would then
exceed the range actually covered by each root. It should only result in a
bit of extra iterating, and not cause functional problems. This will be
addressed in a future change.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep v2:
 - Rename from "KVM: x86/mmu: Add address conversion functions for TDX shared bit of GPA"
 - Dropped Binbin's reviewed-by tag because of the extend of the changes
 - Rename gfn_shared_mask to gfn_direct_mask.
 - Don't include shared bits in GFNs, hide the existence in the TDP MMU
   iterator.
 - Don't do range flushes if a gfn_direct_mask is present.
---
 arch/x86/include/asm/kvm_host.h | 11 +++------
 arch/x86/kvm/mmu.h              |  5 ++++
 arch/x86/kvm/mmu/mmu_internal.h | 16 +++++++++++-
 arch/x86/kvm/mmu/tdp_iter.c     |  5 ++--
 arch/x86/kvm/mmu/tdp_iter.h     | 16 ++++++------
 arch/x86/kvm/mmu/tdp_mmu.c      | 43 ++++++++++++++++-----------------
 arch/x86/kvm/x86.c              | 10 ++++++++
 7 files changed, 66 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 084f4708aff1..c9af963ab897 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1535,6 +1535,8 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+	gfn_t gfn_direct_mask;
 };
 
 struct kvm_vm_stat {
@@ -1908,14 +1910,7 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 }
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
-static inline int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn,
-						   u64 nr_pages)
-{
-	if (!kvm_x86_ops.flush_remote_tlbs_range)
-		return -EOPNOTSUPP;
-
-	return static_call(kvm_x86_flush_remote_tlbs_range)(kvm, gfn, nr_pages);
-}
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages);
 #endif /* CONFIG_HYPERV */
 
 enum kvm_intr_type {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 0c3bf89cf7db..f0713b6e4ee5 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -323,4 +323,9 @@ static inline bool kvm_has_mirrored_tdp(const struct kvm *kvm)
 {
 	return kvm->arch.vm_type == KVM_X86_TDX_VM;
 }
+
+static inline gfn_t kvm_gfn_direct_mask(const struct kvm *kvm)
+{
+	return kvm->arch.gfn_direct_mask;
+}
 #endif
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 6d82e389cd65..076871c9e694 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -6,6 +6,8 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_host.h>
 
+#include "mmu.h"
+
 #ifdef CONFIG_KVM_PROVE_MMU
 #define KVM_MMU_WARN_ON(x) WARN_ON_ONCE(x)
 #else
@@ -189,6 +191,13 @@ static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, struct kvm_m
 	sp->mirrored_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_mirrored_spt_cache);
 }
 
+static inline gfn_t kvm_gfn_root_mask(const struct kvm *kvm, const struct kvm_mmu_page *root)
+{
+	if (is_mirror_sp(root))
+		return 0;
+	return kvm_gfn_direct_mask(kvm);
+}
+
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
@@ -359,7 +368,12 @@ static inline int __kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gp
 	int r;
 
 	if (vcpu->arch.mmu->root_role.direct) {
-		fault.gfn = fault.addr >> PAGE_SHIFT;
+		/*
+		 * Things like memslots don't understand the concept of a shared
+		 * bit. Strip it so that the GFN can be used like normal, and the
+		 * fault.addr can be used when the shared bit is needed.
+		 */
+		fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_direct_mask(vcpu->kvm);
 		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
 	}
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 04c247bfe318..a3bfe7fe473a 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -12,7 +12,7 @@
 static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
 {
 	iter->sptep = iter->pt_path[iter->level - 1] +
-		SPTE_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
+		SPTE_INDEX((iter->gfn | iter->gfn_mask) << PAGE_SHIFT, iter->level);
 	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
 }
 
@@ -37,7 +37,7 @@ void tdp_iter_restart(struct tdp_iter *iter)
  * rooted at root_pt, starting with the walk to translate next_last_level_gfn.
  */
 void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
-		    int min_level, gfn_t next_last_level_gfn)
+		    int min_level, gfn_t next_last_level_gfn, gfn_t gfn_mask)
 {
 	if (WARN_ON_ONCE(!root || (root->role.level < 1) ||
 			 (root->role.level > PT64_ROOT_MAX_LEVEL))) {
@@ -46,6 +46,7 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 	}
 
 	iter->next_last_level_gfn = next_last_level_gfn;
+	iter->gfn_mask = gfn_mask;
 	iter->root_level = root->role.level;
 	iter->min_level = min_level;
 	iter->pt_path[iter->root_level - 1] = (tdp_ptep_t)root->spt;
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index fae559559a80..6864d21edb4e 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -91,8 +91,10 @@ struct tdp_iter {
 	tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
 	/* A pointer to the current SPTE */
 	tdp_ptep_t sptep;
-	/* The lowest GFN mapped by the current SPTE */
+	/* The lowest GFN (mask bits excluded) mapped by the current SPTE */
 	gfn_t gfn;
+	/* Mask applied to convert the GFN to the mapping GPA */
+	gfn_t gfn_mask;
 	/* The level of the root page given to the iterator */
 	int root_level;
 	/* The lowest level the iterator should traverse to */
@@ -120,18 +122,18 @@ struct tdp_iter {
  * Iterates over every SPTE mapping the GFN range [start, end) in a
  * preorder traversal.
  */
-#define for_each_tdp_pte_min_level(iter, root, min_level, start, end) \
-	for (tdp_iter_start(&iter, root, min_level, start); \
-	     iter.valid && iter.gfn < end;		     \
+#define for_each_tdp_pte_min_level(iter, kvm, root, min_level, start, end)		  \
+	for (tdp_iter_start(&iter, root, min_level, start, kvm_gfn_root_mask(kvm, root)); \
+	     iter.valid && iter.gfn < end;						  \
 	     tdp_iter_next(&iter))
 
-#define for_each_tdp_pte(iter, root, start, end) \
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end)
+#define for_each_tdp_pte(iter, kvm, root, start, end)				\
+	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_4K, start, end)
 
 tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 
 void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
-		    int min_level, gfn_t next_last_level_gfn);
+		    int min_level, gfn_t next_last_level_gfn, gfn_t gfn_mask);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2770230a5636..ed93bba76483 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -674,18 +674,18 @@ static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 					  iter->gfn, iter->level);
 }
 
-#define tdp_root_for_each_pte(_iter, _root, _start, _end) \
-	for_each_tdp_pte(_iter, _root, _start, _end)
+#define tdp_root_for_each_pte(_iter, _kvm, _root, _start, _end)	\
+	for_each_tdp_pte(_iter, _kvm, _root, _start, _end)
 
-#define tdp_root_for_each_leaf_pte(_iter, _root, _start, _end)	\
-	tdp_root_for_each_pte(_iter, _root, _start, _end)		\
+#define tdp_root_for_each_leaf_pte(_iter, _kvm, _root, _start, _end)	\
+	tdp_root_for_each_pte(_iter, _kvm, _root, _start, _end)		\
 		if (!is_shadow_present_pte(_iter.old_spte) ||		\
 		    !is_last_spte(_iter.old_spte, _iter.level))		\
 			continue;					\
 		else
 
-#define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
-	for_each_tdp_pte(_iter, root_to_sp(_mmu->root.hpa), _start, _end)
+#define tdp_mmu_for_each_pte(_iter, _kvm, _root, _start, _end)	\
+	for_each_tdp_pte(_iter, _kvm, _root, _start, _end)
 
 /*
  * Yield if the MMU lock is contended or this thread needs to return control
@@ -751,7 +751,7 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	gfn_t end = tdp_mmu_max_gfn_exclusive();
 	gfn_t start = 0;
 
-	for_each_tdp_pte_min_level(iter, root, zap_level, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, zap_level, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
@@ -855,7 +855,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_4K, start, end) {
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
 			flush = false;
@@ -1104,8 +1104,8 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
  */
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct kvm *kvm = vcpu->kvm;
+	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_RETRY;
@@ -1115,8 +1115,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	trace_kvm_mmu_spte_requested(fault);
 
 	rcu_read_lock();
-
-	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
+	tdp_mmu_for_each_pte(iter, vcpu->kvm, root, fault->gfn, fault->gfn + 1) {
 		int r;
 
 		if (fault->nx_huge_page_workaround_enabled)
@@ -1214,7 +1213,7 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
 		rcu_read_lock();
 
-		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
+		tdp_root_for_each_leaf_pte(iter, kvm, root, range->start, range->end)
 			ret |= handler(kvm, &iter, range);
 
 		rcu_read_unlock();
@@ -1297,7 +1296,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
 
-	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, min_level, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
@@ -1460,7 +1459,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 	 * level above the target level (e.g. splitting a 1GB to 512 2MB pages,
 	 * and then splitting each of those to 512 4KB pages).
 	 */
-	for_each_tdp_pte_min_level(iter, root, target_level + 1, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, target_level + 1, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
@@ -1545,7 +1544,7 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	tdp_root_for_each_pte(iter, root, start, end) {
+	tdp_root_for_each_pte(iter, kvm, root, start, end) {
 retry:
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
@@ -1600,7 +1599,7 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	tdp_root_for_each_leaf_pte(iter, root, gfn + __ffs(mask),
+	tdp_root_for_each_leaf_pte(iter, kvm, root, gfn + __ffs(mask),
 				    gfn + BITS_PER_LONG) {
 		if (!mask)
 			break;
@@ -1657,7 +1656,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_2M, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_2M, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
@@ -1727,7 +1726,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, min_level, gfn, gfn + 1) {
+	for_each_tdp_pte_min_level(iter, kvm, root, min_level, gfn, gfn + 1) {
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
@@ -1775,14 +1774,14 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			 int *root_level)
 {
+	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
 	*root_level = vcpu->arch.mmu->root_role.level;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
 	}
@@ -1804,12 +1803,12 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
 					u64 *spte)
 {
+	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	tdp_ptep_t sptep = NULL;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
 		*spte = iter.old_spte;
 		sptep = iter.sptep;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7c593a081eba..0e6325b5f5e7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13987,6 +13987,16 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
+#ifdef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages)
+{
+	if (!kvm_x86_ops.flush_remote_tlbs_range || kvm_gfn_direct_mask(kvm))
+		return -EOPNOTSUPP;
+
+	return static_call(kvm_x86_flush_remote_tlbs_range)(kvm, gfn, nr_pages);
+}
+#endif
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
-- 
2.34.1


