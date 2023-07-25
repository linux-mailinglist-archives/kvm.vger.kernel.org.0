Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12EE87626E8
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbjGYWgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbjGYWf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:35:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DDB83DC;
        Tue, 25 Jul 2023 15:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690324165; x=1721860165;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G0JoBZ4xKYjxEQPxFxKweGgBYSy2Nno5rgPqadkBTMA=;
  b=SofhxE/HqR6AeDXe/09WcTEVRSutLbD95V0e150SA8M1s2icFTE4QFm5
   O+AmsMT1Cd3VFVOV/oD91JKJGsyT7dGE3vkmshNrILhzcYO+0BO60QaSb
   C+NNrVXPBp1C6mM1VhggI5VgObnK2SRiGde8/Zan0FF36jOhV5FYjV/Qf
   pZKKlG+5Wsut1zLWWkpOcV/hp+ZLizG/AieuyXLIKV4iBXEuuYoLzbUMl
   t+54jWnC7ZNStDuzndyUcm1pafYcX8c4DJZyBDzAcSJj3V4ZR6LgfS+UA
   DP4BHabyo5N57VomumRn8x6sBphbvZb3pzOzW4KesithDPD+i37dV2meP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="371467160"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="371467160"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:24:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="972855836"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="972855836"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:24:13 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [RFC PATCH v4 13/16] KVM: x86/tdp_mmu: Try to merge pages into a large page
Date:   Tue, 25 Jul 2023 15:23:59 -0700
Message-Id: <d649f4294d95803a46aaaf3ddd87c7e2f8ff501d.1690323516.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690323516.git.isaku.yamahata@intel.com>
References: <cover.1690323516.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

When a large page is passed to the KVM page fault handler and some of sub
pages are already populated, try to merge sub pages into a large page.
This situation can happen when the guest converts small pages into shared
and convert it back into private.

When a large page is passed to KVM mmu page fault handler and the spte
corresponding to the page is non-leaf (one or more of sub pages are already
populated at lower page level), the current kvm mmu zaps non-leaf spte at a
large page level, and populate a leaf spte at that level.  Thus small pages
are converted into a large page.  However, it doesn't work for TDX because
zapping and re-populating results in zeroing page content.  Instead,
populate all small pages and merge them into a large page.

Merging pages into a large page can fail when some sub pages are accepted
and some are not.  In such case, with the assumption that guest tries to
accept at large page size for performance when possible, don't try to be
smart to identify which page is still pending, map all pages at lower page
level, and let vcpu re-execute.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |   2 +
 arch/x86/include/asm/kvm_host.h    |   4 +
 arch/x86/kvm/mmu/tdp_iter.c        |  37 +++++--
 arch/x86/kvm/mmu/tdp_iter.h        |   2 +
 arch/x86/kvm/mmu/tdp_mmu.c         | 163 ++++++++++++++++++++++++++++-
 5 files changed, 198 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 5989503112c6..378f15a4a1e9 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -103,9 +103,11 @@ KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP_OPTIONAL(link_private_spt)
 KVM_X86_OP_OPTIONAL(free_private_spt)
 KVM_X86_OP_OPTIONAL(split_private_spt)
+KVM_X86_OP_OPTIONAL(merge_private_spt)
 KVM_X86_OP_OPTIONAL(set_private_spte)
 KVM_X86_OP_OPTIONAL(remove_private_spte)
 KVM_X86_OP_OPTIONAL(zap_private_spte)
+KVM_X86_OP_OPTIONAL(unzap_private_spte)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7fe85b2d9a38..fc4c0b75d496 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -138,6 +138,7 @@
 #define KVM_MAX_HUGEPAGE_LEVEL	PG_LEVEL_1G
 #define KVM_NR_PAGE_SIZES	(KVM_MAX_HUGEPAGE_LEVEL - PG_LEVEL_4K + 1)
 #define KVM_HPAGE_GFN_SHIFT(x)	(((x) - 1) * 9)
+#define KVM_HPAGE_GFN_MASK(x)	(~((1UL << KVM_HPAGE_GFN_SHIFT(x)) - 1))
 #define KVM_HPAGE_SHIFT(x)	(PAGE_SHIFT + KVM_HPAGE_GFN_SHIFT(x))
 #define KVM_HPAGE_SIZE(x)	(1UL << KVM_HPAGE_SHIFT(x))
 #define KVM_HPAGE_MASK(x)	(~(KVM_HPAGE_SIZE(x) - 1))
@@ -1717,11 +1718,14 @@ struct kvm_x86_ops {
 				void *private_spt);
 	int (*split_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				  void *private_spt);
+	int (*merge_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				 void *private_spt);
 	int (*set_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				 kvm_pfn_t pfn);
 	int (*remove_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				    kvm_pfn_t pfn);
 	int (*zap_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level);
+	int (*unzap_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index d2eb0d4f8710..736508833260 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -70,6 +70,14 @@ tdp_ptep_t spte_to_child_pt(u64 spte, int level)
 	return (tdp_ptep_t)__va(spte_to_pfn(spte) << PAGE_SHIFT);
 }
 
+static void step_down(struct tdp_iter *iter, tdp_ptep_t child_pt)
+{
+	iter->level--;
+	iter->pt_path[iter->level - 1] = child_pt;
+	iter->gfn = gfn_round_for_level(iter->next_last_level_gfn, iter->level);
+	tdp_iter_refresh_sptep(iter);
+}
+
 /*
  * Steps down one level in the paging structure towards the goal GFN. Returns
  * true if the iterator was able to step down a level, false otherwise.
@@ -91,14 +99,28 @@ static bool try_step_down(struct tdp_iter *iter)
 	if (!child_pt)
 		return false;
 
-	iter->level--;
-	iter->pt_path[iter->level - 1] = child_pt;
-	iter->gfn = gfn_round_for_level(iter->next_last_level_gfn, iter->level);
-	tdp_iter_refresh_sptep(iter);
-
+	step_down(iter, child_pt);
 	return true;
 }
 
+/* Steps down for freezed spte.  Don't re-read sptep because it was freezed. */
+void tdp_iter_step_down(struct tdp_iter *iter, tdp_ptep_t child_pt)
+{
+	WARN_ON_ONCE(!child_pt);
+	WARN_ON_ONCE(iter->yielded);
+	WARN_ON_ONCE(iter->level == iter->min_level);
+
+	step_down(iter, child_pt);
+}
+
+void tdp_iter_step_side(struct tdp_iter *iter)
+{
+	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
+	iter->next_last_level_gfn = iter->gfn;
+	iter->sptep++;
+	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
+}
+
 /*
  * Steps to the next entry in the current page table, at the current page table
  * level. The next entry could point to a page backing guest memory or another
@@ -116,10 +138,7 @@ static bool try_step_side(struct tdp_iter *iter)
 	    (SPTE_ENT_PER_PAGE - 1))
 		return false;
 
-	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
-	iter->next_last_level_gfn = iter->gfn;
-	iter->sptep++;
-	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
+	tdp_iter_step_side(iter);
 
 	return true;
 }
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index a9c9cd0db20a..ca00db799a50 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -134,6 +134,8 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 		    int min_level, gfn_t next_last_level_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
+void tdp_iter_step_side(struct tdp_iter *iter);
+void tdp_iter_step_down(struct tdp_iter *iter, tdp_ptep_t child_pt);
 
 static inline union kvm_mmu_page_role tdp_iter_child_role(struct tdp_iter *iter)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c3963002722c..612fcaac600d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1242,6 +1242,167 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm, bool skip_private)
 	rcu_read_unlock();
 }
 
+static void tdp_mmu_iter_step_side(int i, struct tdp_iter *iter)
+{
+	/*
+	 * if i = SPTE_ENT_PER_PAGE - 1, tdp_iter_step_side() results
+	 * in reading the entry beyond the last entry.
+	 */
+	if (i < SPTE_ENT_PER_PAGE)
+		tdp_iter_step_side(iter);
+}
+
+static int tdp_mmu_merge_private_spt(struct kvm_vcpu *vcpu,
+				     struct kvm_page_fault *fault,
+				     struct tdp_iter *iter, u64 new_spte)
+{
+	u64 *sptep = rcu_dereference(iter->sptep);
+	struct kvm_mmu_page *child_sp;
+	struct kvm *kvm = vcpu->kvm;
+	struct tdp_iter child_iter;
+	bool ret_pf_retry = false;
+	int level = iter->level;
+	gfn_t gfn = iter->gfn;
+	u64 old_spte = *sptep;
+	tdp_ptep_t child_pt;
+	u64 child_spte;
+	int ret = 0;
+	int i;
+
+	/*
+	 * TDX KVM supports only 2MB large page.  It's not supported to merge
+	 * 2MB pages into 1GB page at the moment.
+	 */
+	WARN_ON_ONCE(fault->goal_level != PG_LEVEL_2M);
+	WARN_ON_ONCE(iter->level != PG_LEVEL_2M);
+	WARN_ON_ONCE(!is_large_pte(new_spte));
+
+	/* Freeze the spte to prevent other threads from working spte. */
+	if (!try_cmpxchg64(sptep, &iter->old_spte, REMOVED_SPTE))
+		return -EBUSY;
+
+	/*
+	 * Step down to the child spte.  Because tdp_iter_next() assumes the
+	 * parent spte isn't freezed, do it manually.
+	 */
+	child_pt = spte_to_child_pt(iter->old_spte, iter->level);
+	child_sp = sptep_to_sp(child_pt);
+	WARN_ON_ONCE(child_sp->role.level != PG_LEVEL_4K);
+	WARN_ON_ONCE(!kvm_mmu_page_role_is_private(child_sp->role));
+
+	/* Don't modify iter as the caller will use iter after this function. */
+	child_iter = *iter;
+	/* Adjust the target gfn to the head gfn of the large page. */
+	child_iter.next_last_level_gfn &= -KVM_PAGES_PER_HPAGE(level);
+	tdp_iter_step_down(&child_iter, child_pt);
+
+	/*
+	 * All child pages are required to be populated for merging them into a
+	 * large page.  Populate all child spte.
+	 */
+	for (i = 0; i < SPTE_ENT_PER_PAGE; i++, tdp_mmu_iter_step_side(i, &child_iter)) {
+		WARN_ON_ONCE(child_iter.level != PG_LEVEL_4K);
+		if (is_shadow_present_pte(child_iter.old_spte)) {
+			/* TODO: relocate page for huge page. */
+			if (WARN_ON_ONCE(spte_to_pfn(child_iter.old_spte) !=
+					 spte_to_pfn(new_spte) + i)) {
+				ret = -EAGAIN;
+				ret_pf_retry = true;
+			}
+			/*
+			 * When SEPT_VE_DISABLE=true and the page state is
+			 * pending, this case can happen.  Just resume the vcpu
+			 * again with the expectation for other vcpu to accept
+			 * this page.
+			 */
+			if (child_iter.gfn == fault->gfn) {
+				ret = -EAGAIN;
+				ret_pf_retry = true;
+				break;
+			}
+			continue;
+		}
+
+		WARN_ON_ONCE(spte_to_pfn(child_iter.old_spte) != spte_to_pfn(new_spte) + i);
+		child_spte = make_huge_page_split_spte(kvm, new_spte, child_sp->role, i);
+		/*
+		 * Because other thread may have started to operate on this spte
+		 * before freezing the parent spte,  Use atomic version to
+		 * prevent race.
+		 */
+		ret = tdp_mmu_set_spte_atomic(vcpu->kvm, &child_iter, child_spte);
+		if (ret == -EBUSY || ret == -EAGAIN)
+			/*
+			 * There was a race condition.  Populate remaining 4K
+			 * spte to resolve fault->gfn to guarantee the forward
+			 * progress.
+			 */
+			ret_pf_retry = true;
+		else if (ret)
+			goto out;
+
+	}
+	if (ret_pf_retry)
+		goto out;
+
+	/* Prevent the Secure-EPT entry from being used. */
+	ret = static_call(kvm_x86_zap_private_spte)(kvm, gfn, level);
+	if (ret)
+		goto out;
+	kvm_flush_remote_tlbs_range(kvm, gfn & KVM_HPAGE_GFN_MASK(level),
+				    KVM_PAGES_PER_HPAGE(level));
+
+	/* Merge pages into a large page. */
+	ret = static_call(kvm_x86_merge_private_spt)(kvm, gfn, level,
+						     kvm_mmu_private_spt(child_sp));
+	/*
+	 * Failed to merge pages because some pages are accepted and some are
+	 * pending.  Since the child page was mapped above, let vcpu run.
+	 */
+	if (ret) {
+		if (static_call(kvm_x86_unzap_private_spte)(kvm, gfn, level))
+			old_spte = SHADOW_NONPRESENT_VALUE |
+				(spte_to_pfn(old_spte) << PAGE_SHIFT) |
+				PT_PAGE_SIZE_MASK;
+		goto out;
+	}
+
+	/* Unfreeze spte. */
+	__kvm_tdp_mmu_write_spte(sptep, new_spte);
+
+	/*
+	 * Free unused child sp.  Secure-EPT page was already freed at TDX level
+	 * by kvm_x86_merge_private_spt().
+	 */
+	tdp_unaccount_mmu_page(kvm, child_sp);
+	tdp_mmu_free_sp(child_sp);
+	return -EAGAIN;
+
+out:
+	__kvm_tdp_mmu_write_spte(sptep, old_spte);
+	return ret;
+}
+
+static int __tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
+					     struct kvm_page_fault *fault,
+					     struct tdp_iter *iter, u64 new_spte)
+{
+	/*
+	 * The private page has smaller-size pages.  For example, the child
+	 * pages was converted from shared to page, and now it can be mapped as
+	 * a large page.  Try to merge small pages into a large page.
+	 */
+	if (fault->slot &&
+	    kvm_gfn_shared_mask(vcpu->kvm) &&
+	    iter->level > PG_LEVEL_4K &&
+	    kvm_is_private_gpa(vcpu->kvm, fault->addr) &&
+	    is_shadow_present_pte(iter->old_spte) &&
+	    !is_large_pte(iter->old_spte))
+		return tdp_mmu_merge_private_spt(vcpu, fault, iter, new_spte);
+
+	return tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte);
+}
+
 /*
  * Installs a last-level SPTE to handle a TDP page fault.
  * (NPT/EPT violation/misconfiguration)
@@ -1276,7 +1437,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
-	else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
+	else if (__tdp_mmu_map_handle_target_level(vcpu, fault, iter, new_spte))
 		return RET_PF_RETRY;
 	else if (is_shadow_present_pte(iter->old_spte) &&
 		 !is_last_spte(iter->old_spte, iter->level))
-- 
2.25.1

