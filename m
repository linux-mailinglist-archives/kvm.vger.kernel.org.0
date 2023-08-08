Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF53773BE1
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 17:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjHHP5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 11:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjHHPzc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 11:55:32 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CAE59F7;
        Tue,  8 Aug 2023 08:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691509422; x=1723045422;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=pmZXGyJEB0xcWfjq3eEUAtgF2VdcZivjssmuDMcHZFA=;
  b=AnKnMHJM8up9w2qaU0wdkoMWgNg5egukGRP4RGmxZh2nYdoyURRmC6vt
   TW5KCfpIN7399FxjAAEyTvD7/9ZGWk+mzvUkaSoNz4ZQVmO61OuaKwdvL
   QUmph86uzEtyr4eFNCZ71LpK9FQoBRYiYq8x2MKQq7XrHaA0Y3qqD/KSg
   gMw/0oCGjZtgyaa8PC4gN5gtfbHR40aCXaS0GUQlhK74kxFFjQISSn6eN
   uRIOeO4ei/ZQkAQY0TnzvGDtaCOGzkh2vJESD4EInJ+wmygZ4f273WuGk
   6bSsRcJvI5kBNuePAWLhQ5e5XyKknSnS7P+B5RZyNvZGS+rJsgkeZMF4s
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="457152947"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="457152947"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 02:21:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="734448724"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="734448724"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 02:21:21 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 2/2] KVM: x86/mmu: prefetch SPTE directly in x86 TDP MMU's change_pte() handler
Date:   Tue,  8 Aug 2023 16:54:31 +0800
Message-Id: <20230808085431.14814-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230808085056.14644-1-yan.y.zhao@intel.com>
References: <20230808085056.14644-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Optimize TDP MMU's .change_pte() handler to prefetch SPTEs in the handler
directly with PFN info contained in .change_pte() to avoid that each vCPU
write that triggers .change_pte() must undergo twice VMExits and TDP page
faults.

When there's a running vCPU on current pCPU, .change_pte() is probably
caused by a vCPU write to a guest page previously faulted in with a vCPU
read.

Detailed sequence as below:
1. vCPU reads to a guest page. Though the page is in RW memslot, both
   primary MMU and KVM's secondary MMU are mapped with read-only PTEs
   during page fault.
2. vCPU writes to this guest page.
3. VMExit and kvm_tdp_mmu_page_fault() calls GUP and COW are triggered, so
   .invalidate_range_start(), .change_pte() and .invalidate_range_end()
   are call successively.
4. kvm_tdp_mmu_page_fault() returns retry because it will always find
   current page fault is stale because of the increased mmu_invalidate_seq
   in .invalidate_range_end().
5. VMExit and page fault again.
6. Writable SPTE is mapped successfully.

That is, each guest write to a COW page must trigger VMExit and KVM TDP
page fault twice though .change_pte() has notified KVM the new PTE to be
mapped.

Since .change_pte() is called in a point that's ensured to succeed in
primary MMU, prefetch the new PFN directly in .change_pte() handler on
secondary MMU (KVM MMU) can save KVM the second VMExit and TDP page fault.

During tests on my environment with 8 vCPUs and 16G memory with no assigned
devices, there're around 8000+ (with OVMF) and 17000+ (with Seabios) TDP
page faults saved during each VM boot-up; around 44000+ TDP page faults
saved during booting a L2 VM with 2G memory.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 69 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 89a1f222e823..672a1e333c92 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1243,10 +1243,77 @@ bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
  */
 bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
+	struct kvm_mmu_page *root;
+	struct kvm_mmu_page *sp;
+	bool wrprot, writable;
+	struct kvm_vcpu *vcpu;
+	struct tdp_iter iter;
+	bool flush = false;
+	kvm_pfn_t pfn;
+	u64 new_spte;
+
 	/* Huge pages aren't expected to be modified */
 	WARN_ON(pte_huge(range->arg.pte) || range->start + 1 != range->end);
 
-	return false;
+	/*
+	 * Get current running vCPU to be used in below prefetch in make_spte().
+	 * If no running vCPU, .change_pte() is probably not triggered by vCPU
+	 * writes, drop prefetching SPTEs in that case.
+	 * Also only prefetch for L1 vCPUs.
+	 * If later the vCPU is scheduled out, it's still all right to prefetch
+	 * with the same vCPU except the prefetched SPTE may not be accessed
+	 * immediately.
+	 */
+	vcpu = kvm_get_running_vcpu();
+	if (!vcpu || vcpu->kvm != kvm || is_guest_mode(vcpu))
+		return flush;
+
+	writable = !(range->slot->flags & KVM_MEM_READONLY) && pte_write(range->arg.pte);
+	pfn = pte_pfn(range->arg.pte);
+
+	/* Do not allow rescheduling just as kvm_tdp_mmu_handle_gfn() */
+	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
+		rcu_read_lock();
+
+		tdp_root_for_each_pte(iter, root, range->start, range->end) {
+			if (iter.level > PG_LEVEL_4K)
+				continue;
+
+			sp = sptep_to_sp(rcu_dereference(iter.sptep));
+
+			/* make the SPTE as prefetch */
+			wrprot = make_spte(vcpu, sp, range->slot, ACC_ALL, iter.gfn,
+					  pfn, iter.old_spte, true, true, writable,
+					  &new_spte);
+			/*
+			 * Do not prefetch new PFN for page tracked GFN
+			 * as we want page fault handler to be triggered later
+			 */
+			if (wrprot)
+				continue;
+
+			/*
+			 * Warn if an existing SPTE is found becasuse it must not happen:
+			 * .change_pte() must be surrounded by .invalidate_range_{start,end}(),
+			 * so (1) kvm_unmap_gfn_range() should have zapped the old SPTE,
+			 * (2) page fault handler should not be able to install new SPTE until
+			 * .invalidate_range_end() completes.
+			 *
+			 * Even if the warn is hit and flush is true,
+			 * (which indicates bugs in mmu notifier handler),
+			 * there's no need to handle the remote TLB flush under RCU protection,
+			 * target SPTE _must_ be a leaf SPTE, i.e. cannot result in freeing a
+			 * shadow page.
+			 */
+			flush = WARN_ON(is_shadow_present_pte(iter.old_spte));
+			tdp_mmu_iter_set_spte(kvm, &iter, new_spte);
+
+		}
+
+		rcu_read_unlock();
+	}
+
+	return flush;
 }
 
 /*
-- 
2.17.1

