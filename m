Return-Path: <kvm+bounces-20023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7DC290F91C
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 00:38:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 313741F228A8
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 22:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71AE1607A0;
	Wed, 19 Jun 2024 22:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fCv108SC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC1715DBA0;
	Wed, 19 Jun 2024 22:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718836590; cv=none; b=BwSnrOIna6i5gSoxUMBZmCsiMhHCMZiNnU96RaljSDzwKmV+Hd/D/1kfINuJeMLFYozbr8L5CQ4LCnaecG1ODxQskyvL3HU+xzFWPQPieAUYx84fGBti7A1VTm/hLuVvqmyGw0l+4pluEVzZ8oB5yy84R0sE6tTHoGIgkv38KDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718836590; c=relaxed/simple;
	bh=92m+Voz3z6kepmMdLV38q7GL9Wt4BzZ/Z323D4cPPTs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OPz/p0cqJcKyQ+jI5sXbDsB5wf84UW3F2Ylb5JBTCMxmvL/O2GXsOhQF5ZykiJz4yZOr61wAO9Obg6jsNHCgUYpAVtacKAnzzGSZENf/q1RvvvVM3JxeeHo+h7BbD3mLo+AQUse45hqVsu+0mW/hO4zExWzkvd9chQdpTEQ615g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fCv108SC; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718836588; x=1750372588;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=92m+Voz3z6kepmMdLV38q7GL9Wt4BzZ/Z323D4cPPTs=;
  b=fCv108SCjv+yr+J9gjAEZJKP1aIYaaGofz1aJ2OQV1i+NKY+qjAUIpjC
   m5856nT5KpjCXHOS6KqXIZY98av7ExVcihO7Vq/yLK77nkQbcdG6WSs/2
   Pnx7Ip/9U7Y50B+mATFQkaScB98+cV5SVSaWMVRRICRPBRHVJ0gE/t2T9
   cvGi+GuqMKHBQ0vemhDbizYlDSiVOZi1v4LXGfx0HitBSyi0r5Llz7Y4D
   Pz+huYNtepiQjJb1BPPzxAEwoXXJwvcMzyx5BX7REU8Tm3A2aw/GuIh6D
   9/czhAM9Btcd2RWeTID2JAdmUjxABBJ9FDqAkvFStQedI43MwbYcetoYh
   A==;
X-CSE-ConnectionGUID: UYd083ueTzabfZce+6F82g==
X-CSE-MsgGUID: tqlng3OiQWakOiJHp7ie0w==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15931956"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15931956"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:21 -0700
X-CSE-ConnectionGUID: C67sK6FoT3a7maXTmq17nw==
X-CSE-MsgGUID: huhr7nNbSDSU2otYUS6pvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="72793339"
Received: from ivsilic-mobl2.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.54.39])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:21 -0700
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
Subject: [PATCH v3 07/17] KVM: x86/tdp_mmu: Take struct kvm in iter loops
Date: Wed, 19 Jun 2024 15:36:04 -0700
Message-Id: <20240619223614.290657-8-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a struct kvm argument to the TDP MMU iterators.

Future changes will want to change how the iterator behaves based on a
member of struct kvm. Change the signature and callers of the iterator
loop helpers in a separate patch to make the future one easier to review.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep v3:
 - Split from "KVM: x86/mmu: Support GFN direct mask" (Paolo)
---
 arch/x86/kvm/mmu/tdp_iter.h |  6 +++---
 arch/x86/kvm/mmu/tdp_mmu.c  | 36 ++++++++++++++++++------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index fae559559a80..62c9ca32d922 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -120,13 +120,13 @@ struct tdp_iter {
  * Iterates over every SPTE mapping the GFN range [start, end) in a
  * preorder traversal.
  */
-#define for_each_tdp_pte_min_level(iter, root, min_level, start, end) \
+#define for_each_tdp_pte_min_level(iter, kvm, root, min_level, start, end)		  \
 	for (tdp_iter_start(&iter, root, min_level, start); \
 	     iter.valid && iter.gfn < end;		     \
 	     tdp_iter_next(&iter))
 
-#define for_each_tdp_pte(iter, root, start, end) \
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end)
+#define for_each_tdp_pte(iter, kvm, root, start, end)				\
+	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_4K, start, end)
 
 tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 07b0b884e246..4a7518c9ba7e 100644
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
+#define tdp_mmu_for_each_pte(_iter, _kvm, _mmu, _start, _end)		\
+	for_each_tdp_pte(_iter, _kvm, root_to_sp(_mmu->root.hpa), _start, _end)
 
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
@@ -1116,7 +1116,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	rcu_read_lock();
 
-	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
+	tdp_mmu_for_each_pte(iter, kvm, mmu, fault->gfn, fault->gfn + 1) {
 		int r;
 
 		if (fault->nx_huge_page_workaround_enabled)
@@ -1214,7 +1214,7 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
 		rcu_read_lock();
 
-		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
+		tdp_root_for_each_leaf_pte(iter, kvm, root, range->start, range->end)
 			ret |= handler(kvm, &iter, range);
 
 		rcu_read_unlock();
@@ -1297,7 +1297,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
 
-	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, min_level, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
@@ -1460,7 +1460,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 	 * level above the target level (e.g. splitting a 1GB to 512 2MB pages,
 	 * and then splitting each of those to 512 4KB pages).
 	 */
-	for_each_tdp_pte_min_level(iter, root, target_level + 1, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, target_level + 1, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
@@ -1545,7 +1545,7 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	tdp_root_for_each_pte(iter, root, start, end) {
+	tdp_root_for_each_pte(iter, kvm, root, start, end) {
 retry:
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
@@ -1600,7 +1600,7 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	tdp_root_for_each_leaf_pte(iter, root, gfn + __ffs(mask),
+	tdp_root_for_each_leaf_pte(iter, kvm, root, gfn + __ffs(mask),
 				    gfn + BITS_PER_LONG) {
 		if (!mask)
 			break;
@@ -1657,7 +1657,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_2M, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_2M, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
@@ -1727,7 +1727,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, min_level, gfn, gfn + 1) {
+	for_each_tdp_pte_min_level(iter, kvm, root, min_level, gfn, gfn + 1) {
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
@@ -1782,7 +1782,7 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 
 	*root_level = vcpu->arch.mmu->root_role.level;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, vcpu->kvm, mmu, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
 	}
@@ -1809,7 +1809,7 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	tdp_ptep_t sptep = NULL;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, vcpu->kvm, mmu, gfn, gfn + 1) {
 		*spte = iter.old_spte;
 		sptep = iter.sptep;
 	}
-- 
2.34.1


