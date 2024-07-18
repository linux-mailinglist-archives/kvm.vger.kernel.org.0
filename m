Return-Path: <kvm+bounces-21889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 87C319352FD
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:14:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6C791F2224D
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 961CE145B28;
	Thu, 18 Jul 2024 21:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RuLlm8vM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57DC146D57;
	Thu, 18 Jul 2024 21:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337170; cv=none; b=szpAKAg1h7BNjw+qGjJDJY9HUDgUP5J7niBI53zF43l6VAIaM7KJCDCHcUCgmrH4e0g90E7w/byWq+DPGWG1FQT5WCts+EQKSSWYtq95hQip8fW/RP34TqPyOwA9YRShUkzsUJBxVC7bYK+4OeVn3iWIJqFpoGyIctpKN3YjZHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337170; c=relaxed/simple;
	bh=S1jdBkVX26Qb8P58jyvOE2m5JDwxRTsp1tNMU3hN0+M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YJmsW5rAJ4GWWbjg0XQCckYKuVK1f1IRcSRIZaU5qxvjLhS4KqGtiUTUFblQappbsNdiEhZO1xsNB4+lG/PpOfCyVcDimNWGi0hEm6L1PPZ0ADmTOcR91ruJUgTP994213WavdBTrysba+hl40wo7v5+6tx4WICjd5BWYrXQi8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RuLlm8vM; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337169; x=1752873169;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S1jdBkVX26Qb8P58jyvOE2m5JDwxRTsp1tNMU3hN0+M=;
  b=RuLlm8vMz6d5n09kc25/yipuUCcfoELDXiWi/rvRf3HOONmWDk+p+iYy
   mUMEaJ4RBy2KF6O9h+V4xX3JoWVzC7dC5lIIf7V9gUI1PkThxFk0IPqzd
   qPa0YnUYz8+SSqrd1CQphXuU9RnEt/WcXyDojNnJG1one6uic0W0qVgny
   v2qpWqOy8SJIy1m2KzyjpGzd7DHEzz+IO0gIwnZDZY5AnsE/PHjb/gneC
   vpE/T+0pzwIYy1+cgGMbEQ4XcdczO0QBr5RuVuPHP8TpylSqYsywLu5iF
   J4JNwIerCAtezlMiN3WB1UB5OkXmP2VhjPdSaVbje61+SBx3gPxo98DqE
   w==;
X-CSE-ConnectionGUID: 4O/3R5C2RKO5576hrQ0beQ==
X-CSE-MsgGUID: bOFCu4j5SMeVNSEZ2/ubxQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22697420"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22697420"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:45 -0700
X-CSE-ConnectionGUID: wRoggmP5R9WV2wVMHrW5yA==
X-CSE-MsgGUID: fiv5/ysDSzmG+4+ajDpl+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55760390"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.76])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:45 -0700
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
Subject: [PATCH v4 07/18] KVM: x86/tdp_mmu: Take struct kvm in iter loops
Date: Thu, 18 Jul 2024 14:12:19 -0700
Message-Id: <20240718211230.1492011-8-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
References: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
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
v3:
 - Split from "KVM: x86/mmu: Support GFN direct mask" (Paolo)
---
 arch/x86/kvm/mmu/tdp_iter.h |  6 +++---
 arch/x86/kvm/mmu/tdp_mmu.c  | 36 ++++++++++++++++++------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 2880fd392e0c..d8f2884e3c66 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -122,13 +122,13 @@ struct tdp_iter {
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
index f4df20b91817..89b8a8eed116 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -675,18 +675,18 @@ static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
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
@@ -752,7 +752,7 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	gfn_t end = tdp_mmu_max_gfn_exclusive();
 	gfn_t start = 0;
 
-	for_each_tdp_pte_min_level(iter, root, zap_level, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, zap_level, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
@@ -856,7 +856,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_4K, start, end) {
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
 			flush = false;
@@ -1123,7 +1123,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	rcu_read_lock();
 
-	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
+	tdp_mmu_for_each_pte(iter, kvm, mmu, fault->gfn, fault->gfn + 1) {
 		int r;
 
 		if (fault->nx_huge_page_workaround_enabled)
@@ -1221,7 +1221,7 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
 		rcu_read_lock();
 
-		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
+		tdp_root_for_each_leaf_pte(iter, kvm, root, range->start, range->end)
 			ret |= handler(kvm, &iter, range);
 
 		rcu_read_unlock();
@@ -1304,7 +1304,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
 
-	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, min_level, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
@@ -1467,7 +1467,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 	 * level above the target level (e.g. splitting a 1GB to 512 2MB pages,
 	 * and then splitting each of those to 512 4KB pages).
 	 */
-	for_each_tdp_pte_min_level(iter, root, target_level + 1, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, target_level + 1, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
@@ -1552,7 +1552,7 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	tdp_root_for_each_pte(iter, root, start, end) {
+	tdp_root_for_each_pte(iter, kvm, root, start, end) {
 retry:
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
@@ -1607,7 +1607,7 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	tdp_root_for_each_leaf_pte(iter, root, gfn + __ffs(mask),
+	tdp_root_for_each_leaf_pte(iter, kvm, root, gfn + __ffs(mask),
 				    gfn + BITS_PER_LONG) {
 		if (!mask)
 			break;
@@ -1664,7 +1664,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_2M, start, end) {
+	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_2M, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
@@ -1734,7 +1734,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, min_level, gfn, gfn + 1) {
+	for_each_tdp_pte_min_level(iter, kvm, root, min_level, gfn, gfn + 1) {
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
@@ -1789,7 +1789,7 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 
 	*root_level = vcpu->arch.mmu->root_role.level;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, vcpu->kvm, mmu, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
 	}
@@ -1815,7 +1815,7 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	tdp_ptep_t sptep = NULL;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, vcpu->kvm, mmu, gfn, gfn + 1) {
 		*spte = iter.old_spte;
 		sptep = iter.sptep;
 	}
-- 
2.34.1


