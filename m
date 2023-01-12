Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60148667C58
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 18:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239515AbjALRPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 12:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjALROz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 12:14:55 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FDE80992;
        Thu, 12 Jan 2023 08:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673542166; x=1705078166;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5QI5NkbvG8pqYWneV7DVZAoNbztvBSfytrVl2ac3Vvo=;
  b=U/eCOuWrpONDfy3MZRNljXno9ZcEy0lgGHOkzjvBk9gQWzsX78HAKCJF
   yxmahms1I8NRcf80h+1Ojsu1aOwcQllUn4Z2f+S9UNfdUyaNICRXgrpXK
   yMa2crIKbp5Jch5jTBFfan9hE9CZCku/zvh5xnvWk43bfBmiD/oHewMuh
   MTSsDP58RjaJ/qejCo3xt+dnaJ0IRAk0I112Q4iNrdcXAkaKnGM3NVthn
   nQl7BPcRqAuu2sygM+en8x/ek6gF8HVkZ9ryqQSsodqQ7khJ/QcvZIChh
   xoiU96TtH17tCeq3A2iyaibiEKfnT3uZRk+MxYKAVmhBXTEktTwTrQTDm
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323816336"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323816336"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:18 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="986658361"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="986658361"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:18 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [RFC PATCH v3 13/16] KVM: x86/tdp_mmu: Try to merge pages into a large page
Date:   Thu, 12 Jan 2023 08:44:05 -0800
Message-Id: <dd73cf5ffa9750a0cc276a20deb4d7510181bebf.1673541292.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673541292.git.isaku.yamahata@intel.com>
References: <cover.1673541292.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/kvm_host.h    |   3 +
 arch/x86/kvm/mmu/tdp_iter.c        |  37 ++++++--
 arch/x86/kvm/mmu/tdp_iter.h        |   2 +
 arch/x86/kvm/mmu/tdp_mmu.c         | 140 ++++++++++++++++++++++++++++-
 5 files changed, 174 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 1e86542141f7..83f99a9fb3c2 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -98,9 +98,11 @@ KVM_X86_OP(load_mmu_pgd)
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
index 7c6f8380b7e8..9574d9907074 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1697,11 +1697,14 @@ struct kvm_x86_ops {
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
index e26e744df1d1..5b83967fbd82 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -75,6 +75,14 @@ tdp_ptep_t spte_to_child_pt(u64 spte, int level)
 	return (tdp_ptep_t)__va(spte_to_pfn(spte) << PAGE_SHIFT);
 }
 
+static void step_down(struct tdp_iter *iter, tdp_ptep_t child_pt)
+{
+	iter->level--;
+	iter->pt_path[iter->level - 1] = child_pt;
+	iter->gfn = round_gfn_for_level(iter->next_last_level_gfn, iter->level);
+	tdp_iter_refresh_sptep(iter);
+}
+
 /*
  * Steps down one level in the paging structure towards the goal GFN. Returns
  * true if the iterator was able to step down a level, false otherwise.
@@ -96,14 +104,28 @@ static bool try_step_down(struct tdp_iter *iter)
 	if (!child_pt)
 		return false;
 
-	iter->level--;
-	iter->pt_path[iter->level - 1] = child_pt;
-	iter->gfn = round_gfn_for_level(iter->next_last_level_gfn, iter->level);
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
+void tdp_iter_step_side(struct tdp_iter * iter)
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
@@ -121,10 +143,7 @@ static bool try_step_side(struct tdp_iter *iter)
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
index eab62baf8549..27460aa677a3 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -114,6 +114,8 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 		    int min_level, gfn_t next_last_level_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
+void tdp_iter_step_side(struct tdp_iter *iter);
+void tdp_iter_step_down(struct tdp_iter *iter, tdp_ptep_t child_pt);
 
 static inline union kvm_mmu_page_role tdp_iter_child_role(struct tdp_iter *iter)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2fa6ec89a0fd..fc8f457292b9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1332,6 +1332,144 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 	}
 }
 
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
+	for (i = 0; i < SPTE_ENT_PER_PAGE; i++, tdp_iter_step_side(&child_iter)) {
+		WARN_ON_ONCE(child_iter.level != PG_LEVEL_4K);
+		if (is_shadow_present_pte(child_iter.old_spte)) {
+			/* TODO: relocate page for huge page. */
+			WARN_ON_ONCE(spte_to_pfn(child_iter.old_spte) != spte_to_pfn(new_spte) + i);
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
+	}
+	if (ret_pf_retry) {
+		ret = RET_PF_RETRY;
+		goto out;
+	}
+
+	/* Prevent the Secure-EPT entry from being used. */
+	ret = static_call(kvm_x86_zap_private_spte)(kvm, gfn, level);
+	if (ret)
+		goto out;
+	kvm_flush_remote_tlbs_with_address(kvm, gfn, KVM_PAGES_PER_HPAGE(level));
+
+	/* Merge pages into a large page. */
+	ret = static_call(kvm_x86_merge_private_spt)(kvm, gfn, level,
+						     kvm_mmu_private_spt(child_sp));
+	/*
+	 * Failed to merge pages because some pages are accepted and some are
+	 * pending.  Since the child page was mapped above, let vcpu run.
+	 */
+	if (ret == -EAGAIN)
+		ret = RET_PF_RETRY;
+	if (ret)
+		goto unzap;
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
+	return RET_PF_RETRY;
+
+unzap:
+	if (static_call(kvm_x86_unzap_private_spte)(kvm, gfn, level))
+		old_spte = SHADOW_NONPRESENT_VALUE |
+			(spte_to_pfn(old_spte) << PAGE_SHIFT) |
+			PT_PAGE_SIZE_MASK;
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
+	    kvm_is_private_gpa(vcpu->kvm, gfn_to_gpa(fault->gfn)) &&
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
@@ -1366,7 +1504,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
-	else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
+	else if (__tdp_mmu_map_handle_target_level(vcpu, fault, iter, new_spte))
 		return RET_PF_RETRY;
 	else if (is_shadow_present_pte(iter->old_spte) &&
 		 !is_last_spte(iter->old_spte, iter->level))
-- 
2.25.1

