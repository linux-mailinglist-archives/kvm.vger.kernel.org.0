Return-Path: <kvm+bounces-9764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10773866DD8
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:14:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 414F21C23A72
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79C101350CB;
	Mon, 26 Feb 2024 08:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LvseQIsL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6252C869;
	Mon, 26 Feb 2024 08:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936193; cv=none; b=HQcbV6G+XCUqXuBVf+nbcfaJZs5LSC3zg30aWyQYm6Z8DbL1nfqmmojfjOxRetZMbMRoTbl2FfsM9+3ySk/qFKxIPjsJYoF/O68Ha6S8XZS1Letmz73E1LrkFMpegUqFmktvOePLy/ocixaWrzq7cPUScOLVElAODE3visjl2LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936193; c=relaxed/simple;
	bh=GFnsETiyt8aTwReB6nymWxtwd83xZREOfV3VdIkGX1o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ejCR9iL6JettLRk+34A+unPpn5/BoSwCwGH6BZdfg4hROAy9qmo5NtVmKZsiruo10Tz7wW1SQqPgrVIrhvmPPMsnLJvR5WXdDpFGK4Z6oI153J9FlZ0ICr9Q0oYQqKEw5VYfJo+kADgFA4tuAEiGv9tm4QDYK/7pg2URLjBdJxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LvseQIsL; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936191; x=1740472191;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GFnsETiyt8aTwReB6nymWxtwd83xZREOfV3VdIkGX1o=;
  b=LvseQIsLYZpxaD+f0I8wYIOZFWOShfE27jHlyEnm1mZpXsiNsZD+nLU1
   GotXaCp6ZcrOYp6JEvKKEwgWiLcjj22Ts2ExQzceVHEggE0UR8dMDnAPg
   aSvDBjplpcReo9eATt7gswytpWBBCfXPt2rZ7LTbTakUn6BEzTRcoHYkj
   80FSmGiw6oIwWzFzU9w+8o6YAQCnvlu+Z3ogNax8BO1Y0QpoiWLbxoGcW
   wMljCkb8Yf4o+eUV8OgZpC4xF/72gZ0yhk8zzt84vXFsDVUAmcDoXh6Yl
   HWDMPJh6nGpa4Mc02tEbIGAfBb2R3pBK0RZQDEJERWpUweHJVPZ5FQBNv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="14623317"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="14623317"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6519414"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:33 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v8 09/14] KVM: x86/tdp_mmu: Split the large page when zap leaf
Date: Mon, 26 Feb 2024 00:29:23 -0800
Message-Id: <c656573ccc68e212416d323d35f884bff25e6e2d.1708933624.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933624.git.isaku.yamahata@intel.com>
References: <cover.1708933624.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

When TDX enabled, a large page cannot be zapped if it contains mixed
pages. In this case, it has to split the large page.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
v7:
- remote unnecessary tlb shoot down in tdp_mmu_zap_leafs() to free unused
  split_sp.
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c          |  6 ++--
 arch/x86/kvm/mmu/mmu_internal.h |  9 +++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 60 ++++++++++++++++++++++++++++++---
 3 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 081df7855065..fa7fabc410c4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7473,8 +7473,8 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	return kvm_unmap_gfn_range(kvm, range);
 }
 
-static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
-				int level)
+bool kvm_hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
+			     int level)
 {
 	return lpage_info_slot(gfn, slot, level)->disallow_lpage & KVM_LPAGE_MIXED_FLAG;
 }
@@ -7501,7 +7501,7 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
 		return kvm_range_has_memory_attributes(kvm, start, end, attrs);
 
 	for (gfn = start; gfn < end; gfn += KVM_PAGES_PER_HPAGE(level - 1)) {
-		if (hugepage_test_mixed(slot, gfn, level - 1) ||
+		if (kvm_hugepage_test_mixed(slot, gfn, level - 1) ||
 		    attrs != kvm_get_memory_attributes(kvm, gfn))
 			return false;
 	}
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 9aa4c6ffa207..315c123affaf 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -430,4 +430,13 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+bool kvm_hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn, int level);
+#else
+static inline bool kvm_hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn, int level)
+{
+	return false;
+}
+#endif
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 66de875d3de1..e3682794adda 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -953,6 +953,14 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	return true;
 }
 
+
+static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
+						       struct tdp_iter *iter,
+						       bool shared);
+
+static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
+				   struct kvm_mmu_page *sp, bool shared);
+
 /*
  * If can_yield is true, will release the MMU lock and reschedule if the
  * scheduler needs the CPU or there is contention on the MMU lock. If this
@@ -964,14 +972,16 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 			      gfn_t start, gfn_t end, bool can_yield, bool flush,
 			      bool zap_private)
 {
+	bool is_private = is_private_sp(root);
+	struct kvm_mmu_page *split_sp = NULL;
 	struct tdp_iter iter;
 
 	end = min(end, tdp_mmu_max_gfn_exclusive());
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	WARN_ON_ONCE(zap_private && !is_private_sp(root));
-	if (!zap_private && is_private_sp(root))
+	WARN_ON_ONCE(zap_private && !is_private);
+	if (!zap_private && is_private)
 		return false;
 
 	/*
@@ -995,12 +1005,56 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
+		if (is_private && kvm_gfn_shared_mask(kvm) &&
+		    is_large_pte(iter.old_spte)) {
+			gfn_t gfn = iter.gfn & ~kvm_gfn_shared_mask(kvm);
+			gfn_t mask = KVM_PAGES_PER_HPAGE(iter.level) - 1;
+			struct kvm_memory_slot *slot;
+			struct kvm_mmu_page *sp;
+
+			slot = gfn_to_memslot(kvm, gfn);
+			if (kvm_hugepage_test_mixed(slot, gfn, iter.level) ||
+			    (gfn & mask) < start ||
+			    end < (gfn & mask) + KVM_PAGES_PER_HPAGE(iter.level)) {
+				WARN_ON_ONCE(!can_yield);
+				if (split_sp) {
+					sp = split_sp;
+					split_sp = NULL;
+					sp->role = tdp_iter_child_role(&iter);
+				} else {
+					WARN_ON(iter.yielded);
+					if (flush && can_yield) {
+						kvm_flush_remote_tlbs(kvm);
+						flush = false;
+					}
+					sp = tdp_mmu_alloc_sp_for_split(kvm, &iter, false);
+					if (iter.yielded) {
+						split_sp = sp;
+						continue;
+					}
+				}
+				KVM_BUG_ON(!sp, kvm);
+
+				tdp_mmu_init_sp(sp, iter.sptep, iter.gfn);
+				if (tdp_mmu_split_huge_page(kvm, &iter, sp, false)) {
+					/* force retry on this gfn. */
+					iter.yielded = true;
+					split_sp = sp;
+				} else
+					flush = true;
+				continue;
+			}
+		}
+
 		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
 		flush = true;
 	}
 
 	rcu_read_unlock();
 
+	if (split_sp)
+		tdp_mmu_free_sp(split_sp);
+
 	/*
 	 * Because this flow zaps _only_ leaf SPTEs, the caller doesn't need
 	 * to provide RCU protection as no 'struct kvm_mmu_page' will be freed.
@@ -1617,8 +1671,6 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 	KVM_BUG_ON(kvm_mmu_page_role_is_private(role) !=
 		   is_private_sptep(iter->sptep), kvm);
-	/* TODO: Large page isn't supported for private SPTE yet. */
-	KVM_BUG_ON(kvm_mmu_page_role_is_private(role), kvm);
 
 	/*
 	 * Since we are allocating while under the MMU lock we have to be
-- 
2.25.1


