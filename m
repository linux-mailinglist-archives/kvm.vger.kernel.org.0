Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6609647A23
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 00:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiLHXgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 18:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiLHXgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 18:36:05 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341386FF32;
        Thu,  8 Dec 2022 15:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670542561; x=1702078561;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vc7FVWd44aFBz55cz2TC2iZlc7y40fTjQ4VzQwXZurc=;
  b=h70Duv976HgJGsJhqMJ6XYOVt4OT6T+ZpTtQY4mMxs+wSi2cJd27PvcC
   0H8tibXaTJYOb0TTTxb29fdzNmGvrz737+4dH7eKD/KgEWwic3rDdK50J
   A9fKZFfVZeFIFRRALKy6hx5+GQEtOzm4yGO/EHJV/HkdOXa0KCJScc/oD
   KQJJe2noQFZUSoFEwYBcdV6mIl4hyX4OUb5rdWafqHiG1vW/Q30rD2os2
   XBVuTXTruOTt4iVazgWn7jGTmBKVvpQki3jO9IQD/yaqm0n2jSYroVKUe
   Aamw13sEwQN5b7XtyznIqcBBvapSZik50+RXRa3/2TfA7zb/Aw2nWZgSs
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="403586555"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="403586555"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:36:00 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="677951011"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="677951011"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:59 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [RFC PATCH v2 12/15] KVM: x86/tdp_mmu: Try to merge pages into a large page
Date:   Thu,  8 Dec 2022 15:35:47 -0800
Message-Id: <559a026e54bc66eef65d76e8472bbff18e07a04d.1670541736.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1670541736.git.isaku.yamahata@intel.com>
References: <cover.1670541736.git.isaku.yamahata@intel.com>
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
 arch/x86/kvm/mmu/tdp_mmu.c         | 127 ++++++++++++++++++++++++++++-
 3 files changed, 131 insertions(+), 1 deletion(-)

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
index 282b083f9b6a..5d728fd294e0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1689,11 +1689,14 @@ struct kvm_x86_ops {
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
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6fd982e3701e..766795005a39 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1309,6 +1309,131 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 	}
 }
 
+static int tdp_mmu_merge_private_spt(struct kvm_vcpu *vcpu,
+				     struct kvm_page_fault *fault,
+				     struct tdp_iter *iter, u64 new_spte)
+{
+	u64 *sptep = rcu_dereference(iter->sptep);
+	struct kvm_mmu_page *child_sp;
+	struct kvm *kvm = vcpu->kvm;
+	bool unzap_retry = false;
+	int level = iter->level;
+	gfn_t gfn = iter->gfn;
+	u64 old_spte = *sptep;
+	tdp_ptep_t child_pt;
+	u64 child_spte;
+	int ret;
+	int i;
+
+	/*
+	 * TDX KVM supports only 2MB large page.  It's not supported to merge
+	 * 2MB pages into 1GB page at the moment.
+	 */
+	WARN_ON_ONCE(fault->goal_level != PG_LEVEL_2M);
+	WARN_ON_ONCE(iter->level != PG_LEVEL_2M);
+
+	/* Freeze the spte to prevent other threads from working spte. */
+	if (!try_cmpxchg64(sptep, &iter->old_spte, REMOVED_SPTE))
+		return -EBUSY;
+
+	/* Prevent the Secure-EPT entry from being used. */
+	ret = static_call(kvm_x86_zap_private_spte)(kvm, gfn, level);
+	if (ret)
+		goto out;
+	kvm_flush_remote_tlbs_with_address(kvm, gfn, KVM_PAGES_PER_HPAGE(level));
+
+	/*
+	 * All child pages are required to be populated for merging them into a
+	 * large page.  Populate all child spte.
+	 */
+	child_pt = spte_to_child_pt(iter->old_spte, iter->level);
+	child_sp = sptep_to_sp(child_pt);
+	unzap_retry = false;
+	/* Step down to spte. */
+	tdp_iter_next(iter);
+	for (i = 0; i < SPTE_ENT_PER_PAGE; i++, tdp_iter_next(iter)) {
+		WARN_ON_ONCE(iter->level != PG_LEVEL_4K);
+		if (is_shadow_present_pte(iter->old_spte)) {
+			/* TODO: relocate page for huge page. */
+			WARN_ON_ONCE(spte_to_pfn(iter->old_spte) != spte_to_pfn(new_spte) + i);
+			continue;
+		}
+
+		WARN_ON_ONCE(spte_to_pfn(iter->old_spte) != spte_to_pfn(new_spte) + i);
+		child_spte = make_huge_page_split_spte(kvm, new_spte, child_sp->role, i);
+		/*
+		 * Because other thread may have started to operate on this spte
+		 * before freezing parent spte,  Use atomic version to prevent
+		 * race.
+		 */
+		ret = tdp_mmu_set_spte_atomic(vcpu->kvm, iter, child_spte);
+		if (ret == -EBUSY || ret == -EAGAIN)
+			/*
+			 * There was a race condition.  Populate remaining 4K
+			 * spte to resolve fault->gfn to guarantee the forward
+			 * progress.
+			 */
+			unzap_retry = true;
+		else if (ret)
+			goto unzap;
+	}
+	if (unzap_retry) {
+		ret = RET_PF_RETRY;
+		goto unzap;
+	}
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
@@ -1341,7 +1466,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
-	else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
+	else if (__tdp_mmu_map_handle_target_level(vcpu, fault, iter, new_spte))
 		return RET_PF_RETRY;
 	else if (is_shadow_present_pte(iter->old_spte) &&
 		 !is_last_spte(iter->old_spte, iter->level))
-- 
2.25.1

