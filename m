Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435D9595C85
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 14:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbiHPM6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 08:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbiHPM6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 08:58:30 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926507C320;
        Tue, 16 Aug 2022 05:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660654704; x=1692190704;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=enwAqQsyGjMmATKs5SPciLumlUD/2XW7D2MgHa49cEI=;
  b=i7rk4y1lSyqXMkP+/IGeH2ZBR93SoPk4sQfKiCzcoLLhRnI+tIHyAq8y
   fdHbLH1l4xC4m7bNaQD/6ZHxjP5Q0VK47tiePKT8VuyhRLUqCve27/CVS
   C3BkZIS9aTCWr4bYC736FFvsJeXjItLFdCSdj2mxadY7DXCDwBvSWkqkx
   6hAxSwHNq8IN6DVMRgH8CkHl/EoKJtBZoIdmbgJVZwbVGsyC04ni2SX+Z
   oA7mBeCYNBuupE4XJJb3+EpngORw3phiz6lHmK+OIaDLMveien6PPmuKq
   DKOC7B1YIVWVHI5yJMF/HE0CZLoDsjFUmguqH8ffhzPcAglH1NztIIYNe
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="279170188"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="279170188"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 05:58:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="667099404"
Received: from chaop.bj.intel.com ([10.240.193.75])
  by fmsmga008.fm.intel.com with ESMTP; 16 Aug 2022 05:58:09 -0700
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: Rename mmu_notifier_* to mmu_invalidate_*
Date:   Tue, 16 Aug 2022 20:53:22 +0800
Message-Id: <20220816125322.1110439-3-chao.p.peng@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220816125322.1110439-1-chao.p.peng@linux.intel.com>
References: <20220816125322.1110439-1-chao.p.peng@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The motivation of this renaming is to make these variables and related
helper functions less mmu_notifier bound and can also be used for non
mmu_notifier based page invalidation. mmu_invalidate_* was chosen to
better describe the purpose of 'invalidating' a page that those
variables are used for.

  - mmu_notifier_seq/range_start/range_end are renamed to
    mmu_invalidate_seq/range_start/range_end.

  - mmu_notifier_retry{_hva} helper functions are renamed to
    mmu_invalidate_retry{_hva}.

  - mmu_notifier_count is renamed to mmu_invalidate_in_progress to
    avoid confusion with mn_active_invalidate_count.

  - While here, also update kvm_inc/dec_notifier_count() to
    kvm_mmu_invalidate_begin/end() to match the change for
    mmu_notifier_count.

No functional change intended.

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
---
 arch/arm64/kvm/mmu.c                     |  8 ++--
 arch/mips/kvm/mmu.c                      | 12 ++---
 arch/powerpc/include/asm/kvm_book3s_64.h |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_host.c    |  4 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c      |  4 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c   |  6 +--
 arch/powerpc/kvm/book3s_hv_nested.c      |  2 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c      |  8 ++--
 arch/powerpc/kvm/e500_mmu_host.c         |  4 +-
 arch/riscv/kvm/mmu.c                     |  4 +-
 arch/x86/kvm/mmu/mmu.c                   | 14 +++---
 arch/x86/kvm/mmu/paging_tmpl.h           |  4 +-
 include/linux/kvm_host.h                 | 60 ++++++++++++------------
 virt/kvm/kvm_main.c                      | 52 ++++++++++----------
 virt/kvm/pfncache.c                      | 17 +++----
 15 files changed, 103 insertions(+), 98 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 87f1cd0df36e..c9a13e487187 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -993,7 +993,7 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		 * THP doesn't start to split while we are adjusting the
 		 * refcounts.
 		 *
-		 * We are sure this doesn't happen, because mmu_notifier_retry
+		 * We are sure this doesn't happen, because mmu_invalidate_retry
 		 * was successful and we are holding the mmu_lock, so if this
 		 * THP is trying to split, it will be blocked in the mmu
 		 * notifier before touching any of the pages, specifically
@@ -1188,9 +1188,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			return ret;
 	}
 
-	mmu_seq = vcpu->kvm->mmu_notifier_seq;
+	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	/*
-	 * Ensure the read of mmu_notifier_seq happens before we call
+	 * Ensure the read of mmu_invalidate_seq happens before we call
 	 * gfn_to_pfn_prot (which calls get_user_pages), so that we don't risk
 	 * the page we just got a reference to gets unmapped before we have a
 	 * chance to grab the mmu_lock, which ensure that if the page gets
@@ -1246,7 +1246,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	else
 		write_lock(&kvm->mmu_lock);
 	pgt = vcpu->arch.hw_mmu->pgt;
-	if (mmu_notifier_retry(kvm, mmu_seq))
+	if (mmu_invalidate_retry(kvm, mmu_seq))
 		goto out_unlock;
 
 	/*
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 1bfd1b501d82..881075a24b29 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -615,17 +615,17 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 	 * Used to check for invalidations in progress, of the pfn that is
 	 * returned by pfn_to_pfn_prot below.
 	 */
-	mmu_seq = kvm->mmu_notifier_seq;
+	mmu_seq = kvm->mmu_invalidate_seq;
 	/*
-	 * Ensure the read of mmu_notifier_seq isn't reordered with PTE reads in
-	 * gfn_to_pfn_prot() (which calls get_user_pages()), so that we don't
+	 * Ensure the read of mmu_invalidate_seq isn't reordered with PTE reads
+	 * in gfn_to_pfn_prot() (which calls get_user_pages()), so that we don't
 	 * risk the page we get a reference to getting unmapped before we have a
-	 * chance to grab the mmu_lock without mmu_notifier_retry() noticing.
+	 * chance to grab the mmu_lock without mmu_invalidate_retry() noticing.
 	 *
 	 * This smp_rmb() pairs with the effective smp_wmb() of the combination
 	 * of the pte_unmap_unlock() after the PTE is zapped, and the
 	 * spin_lock() in kvm_mmu_notifier_invalidate_<page|range_end>() before
-	 * mmu_notifier_seq is incremented.
+	 * mmu_invalidate_seq is incremented.
 	 */
 	smp_rmb();
 
@@ -638,7 +638,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 
 	spin_lock(&kvm->mmu_lock);
 	/* Check if an invalidation has taken place since we got pfn */
-	if (mmu_notifier_retry(kvm, mmu_seq)) {
+	if (mmu_invalidate_retry(kvm, mmu_seq)) {
 		/*
 		 * This can happen when mappings are changed asynchronously, but
 		 * also synchronously if a COW is triggered by
diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index 4def2bd17b9b..d49065af08e9 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -666,7 +666,7 @@ static inline pte_t *find_kvm_host_pte(struct kvm *kvm, unsigned long mmu_seq,
 	VM_WARN(!spin_is_locked(&kvm->mmu_lock),
 		"%s called with kvm mmu_lock not held \n", __func__);
 
-	if (mmu_notifier_retry(kvm, mmu_seq))
+	if (mmu_invalidate_retry(kvm, mmu_seq))
 		return NULL;
 
 	pte = __find_linux_pte(kvm->mm->pgd, ea, NULL, hshift);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_host.c b/arch/powerpc/kvm/book3s_64_mmu_host.c
index 1ae09992c9ea..bc6a381b5346 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_host.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_host.c
@@ -90,7 +90,7 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte,
 	unsigned long pfn;
 
 	/* used to check for invalidations in progress */
-	mmu_seq = kvm->mmu_notifier_seq;
+	mmu_seq = kvm->mmu_invalidate_seq;
 	smp_rmb();
 
 	/* Get host physical address for gpa */
@@ -151,7 +151,7 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte,
 	cpte = kvmppc_mmu_hpte_cache_next(vcpu);
 
 	spin_lock(&kvm->mmu_lock);
-	if (!cpte || mmu_notifier_retry(kvm, mmu_seq)) {
+	if (!cpte || mmu_invalidate_retry(kvm, mmu_seq)) {
 		r = -EAGAIN;
 		goto out_unlock;
 	}
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 514fd45c1994..e9744b41a226 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -578,7 +578,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 		return -EFAULT;
 
 	/* used to check for invalidations in progress */
-	mmu_seq = kvm->mmu_notifier_seq;
+	mmu_seq = kvm->mmu_invalidate_seq;
 	smp_rmb();
 
 	ret = -EFAULT;
@@ -693,7 +693,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 
 	/* Check if we might have been invalidated; let the guest retry if so */
 	ret = RESUME_GUEST;
-	if (mmu_notifier_retry(vcpu->kvm, mmu_seq)) {
+	if (mmu_invalidate_retry(vcpu->kvm, mmu_seq)) {
 		unlock_rmap(rmap);
 		goto out_unlock;
 	}
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 42851c32ff3b..05f8d707c5c4 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -639,7 +639,7 @@ int kvmppc_create_pte(struct kvm *kvm, pgd_t *pgtable, pte_t pte,
 	/* Check if we might have been invalidated; let the guest retry if so */
 	spin_lock(&kvm->mmu_lock);
 	ret = -EAGAIN;
-	if (mmu_notifier_retry(kvm, mmu_seq))
+	if (mmu_invalidate_retry(kvm, mmu_seq))
 		goto out_unlock;
 
 	/* Now traverse again under the lock and change the tree */
@@ -829,7 +829,7 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 	bool large_enable;
 
 	/* used to check for invalidations in progress */
-	mmu_seq = kvm->mmu_notifier_seq;
+	mmu_seq = kvm->mmu_invalidate_seq;
 	smp_rmb();
 
 	/*
@@ -1190,7 +1190,7 @@ void kvmppc_radix_flush_memslot(struct kvm *kvm,
 	 * Increase the mmu notifier sequence number to prevent any page
 	 * fault that read the memslot earlier from writing a PTE.
 	 */
-	kvm->mmu_notifier_seq++;
+	kvm->mmu_invalidate_seq++;
 	spin_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 0644732d1a25..daaa9c40923a 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -1579,7 +1579,7 @@ static long int __kvmhv_nested_page_fault(struct kvm_vcpu *vcpu,
 	/* 2. Find the host pte for this L1 guest real address */
 
 	/* Used to check for invalidations in progress */
-	mmu_seq = kvm->mmu_notifier_seq;
+	mmu_seq = kvm->mmu_invalidate_seq;
 	smp_rmb();
 
 	/* See if can find translation in our partition scoped tables for L1 */
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 2257fb18cb72..5a05953ae13f 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -219,7 +219,7 @@ long kvmppc_do_h_enter(struct kvm *kvm, unsigned long flags,
 	g_ptel = ptel;
 
 	/* used later to detect if we might have been invalidated */
-	mmu_seq = kvm->mmu_notifier_seq;
+	mmu_seq = kvm->mmu_invalidate_seq;
 	smp_rmb();
 
 	/* Find the memslot (if any) for this address */
@@ -366,7 +366,7 @@ long kvmppc_do_h_enter(struct kvm *kvm, unsigned long flags,
 			rmap = real_vmalloc_addr(rmap);
 		lock_rmap(rmap);
 		/* Check for pending invalidations under the rmap chain lock */
-		if (mmu_notifier_retry(kvm, mmu_seq)) {
+		if (mmu_invalidate_retry(kvm, mmu_seq)) {
 			/* inval in progress, write a non-present HPTE */
 			pteh |= HPTE_V_ABSENT;
 			pteh &= ~HPTE_V_VALID;
@@ -932,7 +932,7 @@ static long kvmppc_do_h_page_init_zero(struct kvm_vcpu *vcpu,
 	int i;
 
 	/* Used later to detect if we might have been invalidated */
-	mmu_seq = kvm->mmu_notifier_seq;
+	mmu_seq = kvm->mmu_invalidate_seq;
 	smp_rmb();
 
 	arch_spin_lock(&kvm->mmu_lock.rlock.raw_lock);
@@ -960,7 +960,7 @@ static long kvmppc_do_h_page_init_copy(struct kvm_vcpu *vcpu,
 	long ret = H_SUCCESS;
 
 	/* Used later to detect if we might have been invalidated */
-	mmu_seq = kvm->mmu_notifier_seq;
+	mmu_seq = kvm->mmu_invalidate_seq;
 	smp_rmb();
 
 	arch_spin_lock(&kvm->mmu_lock.rlock.raw_lock);
diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 7f16afc331ef..05668e964140 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -339,7 +339,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	unsigned long flags;
 
 	/* used to check for invalidations in progress */
-	mmu_seq = kvm->mmu_notifier_seq;
+	mmu_seq = kvm->mmu_invalidate_seq;
 	smp_rmb();
 
 	/*
@@ -460,7 +460,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	}
 
 	spin_lock(&kvm->mmu_lock);
-	if (mmu_notifier_retry(kvm, mmu_seq)) {
+	if (mmu_invalidate_retry(kvm, mmu_seq)) {
 		ret = -EAGAIN;
 		goto out;
 	}
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index f9edfe31656c..ae59a581b0c6 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -666,7 +666,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 		return ret;
 	}
 
-	mmu_seq = kvm->mmu_notifier_seq;
+	mmu_seq = kvm->mmu_invalidate_seq;
 
 	hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writable);
 	if (hfn == KVM_PFN_ERR_HWPOISON) {
@@ -686,7 +686,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 
 	spin_lock(&kvm->mmu_lock);
 
-	if (mmu_notifier_retry(kvm, mmu_seq))
+	if (mmu_invalidate_retry(kvm, mmu_seq))
 		goto out_unlock;
 
 	if (writable) {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3e1317325e1f..b6c892022176 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2914,7 +2914,7 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 	 * If addresses are being invalidated, skip prefetching to avoid
 	 * accidentally prefetching those addresses.
 	 */
-	if (unlikely(vcpu->kvm->mmu_notifier_count))
+	if (unlikely(vcpu->kvm->mmu_invalidate_in_progress))
 		return;
 
 	__direct_pte_prefetch(vcpu, sp, sptep);
@@ -2928,7 +2928,7 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
  *
  * There are several ways to safely use this helper:
  *
- * - Check mmu_notifier_retry_hva() after grabbing the mapping level, before
+ * - Check mmu_invalidate_retry_hva() after grabbing the mapping level, before
  *   consuming it.  In this case, mmu_lock doesn't need to be held during the
  *   lookup, but it does need to be held while checking the MMU notifier.
  *
@@ -3056,7 +3056,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		return;
 
 	/*
-	 * mmu_notifier_retry() was successful and mmu_lock is held, so
+	 * mmu_invalidate_retry() was successful and mmu_lock is held, so
 	 * the pmd can't be split from under us.
 	 */
 	fault->goal_level = fault->req_level;
@@ -4203,7 +4203,7 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 		return true;
 
 	return fault->slot &&
-	       mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva);
+	       mmu_invalidate_retry_hva(vcpu->kvm, mmu_seq, fault->hva);
 }
 
 static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
@@ -4227,7 +4227,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		return r;
 
-	mmu_seq = vcpu->kvm->mmu_notifier_seq;
+	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
 	r = kvm_faultin_pfn(vcpu, fault);
@@ -6055,7 +6055,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	write_lock(&kvm->mmu_lock);
 
-	kvm_inc_notifier_count(kvm, gfn_start, gfn_end);
+	kvm_mmu_invalidate_begin(kvm, gfn_start, gfn_end);
 
 	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
 
@@ -6069,7 +6069,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 		kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
 						   gfn_end - gfn_start);
 
-	kvm_dec_notifier_count(kvm, gfn_start, gfn_end);
+	kvm_mmu_invalidate_end(kvm, gfn_start, gfn_end);
 
 	write_unlock(&kvm->mmu_lock);
 }
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f5958071220c..39e0205e7300 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -589,7 +589,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 	 * If addresses are being invalidated, skip prefetching to avoid
 	 * accidentally prefetching those addresses.
 	 */
-	if (unlikely(vcpu->kvm->mmu_notifier_count))
+	if (unlikely(vcpu->kvm->mmu_invalidate_in_progress))
 		return;
 
 	if (sp->role.direct)
@@ -838,7 +838,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	else
 		fault->max_level = walker.level;
 
-	mmu_seq = vcpu->kvm->mmu_notifier_seq;
+	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
 	r = kvm_faultin_pfn(vcpu, fault);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fd5c3b4715f8..f4519d3689e1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -765,10 +765,10 @@ struct kvm {
 
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 	struct mmu_notifier mmu_notifier;
-	unsigned long mmu_notifier_seq;
-	long mmu_notifier_count;
-	unsigned long mmu_notifier_range_start;
-	unsigned long mmu_notifier_range_end;
+	unsigned long mmu_invalidate_seq;
+	long mmu_invalidate_in_progress;
+	unsigned long mmu_invalidate_range_start;
+	unsigned long mmu_invalidate_range_end;
 #endif
 	struct list_head devices;
 	u64 manual_dirty_log_protect;
@@ -1357,10 +1357,10 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
 void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 #endif
 
-void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
-				   unsigned long end);
-void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
-				   unsigned long end);
+void kvm_mmu_invalidate_begin(struct kvm *kvm, unsigned long start,
+			      unsigned long end);
+void kvm_mmu_invalidate_end(struct kvm *kvm, unsigned long start,
+			    unsigned long end);
 
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
@@ -1907,42 +1907,44 @@ extern const struct kvm_stats_header kvm_vcpu_stats_header;
 extern const struct _kvm_stats_desc kvm_vcpu_stats_desc[];
 
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
-static inline int mmu_notifier_retry(struct kvm *kvm, unsigned long mmu_seq)
+static inline int mmu_invalidate_retry(struct kvm *kvm, unsigned long mmu_seq)
 {
-	if (unlikely(kvm->mmu_notifier_count))
+	if (unlikely(kvm->mmu_invalidate_in_progress))
 		return 1;
 	/*
-	 * Ensure the read of mmu_notifier_count happens before the read
-	 * of mmu_notifier_seq.  This interacts with the smp_wmb() in
-	 * mmu_notifier_invalidate_range_end to make sure that the caller
-	 * either sees the old (non-zero) value of mmu_notifier_count or
-	 * the new (incremented) value of mmu_notifier_seq.
-	 * PowerPC Book3s HV KVM calls this under a per-page lock
-	 * rather than under kvm->mmu_lock, for scalability, so
-	 * can't rely on kvm->mmu_lock to keep things ordered.
+	 * Ensure the read of mmu_invalidate_in_progress happens before
+	 * the read of mmu_invalidate_seq.  This interacts with the
+	 * smp_wmb() in mmu_notifier_invalidate_range_end to make sure
+	 * that the caller either sees the old (non-zero) value of
+	 * mmu_invalidate_in_progress or the new (incremented) value of
+	 * mmu_invalidate_seq.
+	 *
+	 * PowerPC Book3s HV KVM calls this under a per-page lock rather
+	 * than under kvm->mmu_lock, for scalability, so can't rely on
+	 * kvm->mmu_lock to keep things ordered.
 	 */
 	smp_rmb();
-	if (kvm->mmu_notifier_seq != mmu_seq)
+	if (kvm->mmu_invalidate_seq != mmu_seq)
 		return 1;
 	return 0;
 }
 
-static inline int mmu_notifier_retry_hva(struct kvm *kvm,
-					 unsigned long mmu_seq,
-					 unsigned long hva)
+static inline int mmu_invalidate_retry_hva(struct kvm *kvm,
+					   unsigned long mmu_seq,
+					   unsigned long hva)
 {
 	lockdep_assert_held(&kvm->mmu_lock);
 	/*
-	 * If mmu_notifier_count is non-zero, then the range maintained by
-	 * kvm_mmu_notifier_invalidate_range_start contains all addresses that
-	 * might be being invalidated. Note that it may include some false
+	 * If mmu_invalidate_in_progress is non-zero, then the range maintained
+	 * by kvm_mmu_notifier_invalidate_range_start contains all addresses
+	 * that might be being invalidated. Note that it may include some false
 	 * positives, due to shortcuts when handing concurrent invalidations.
 	 */
-	if (unlikely(kvm->mmu_notifier_count) &&
-	    hva >= kvm->mmu_notifier_range_start &&
-	    hva < kvm->mmu_notifier_range_end)
+	if (unlikely(kvm->mmu_invalidate_in_progress) &&
+	    hva >= kvm->mmu_invalidate_range_start &&
+	    hva < kvm->mmu_invalidate_range_end)
 		return 1;
-	if (kvm->mmu_notifier_seq != mmu_seq)
+	if (kvm->mmu_invalidate_seq != mmu_seq)
 		return 1;
 	return 0;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 32896c845ffe..2a6c8ddaeb4d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -698,30 +698,31 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 
 	/*
 	 * .change_pte() must be surrounded by .invalidate_range_{start,end}().
-	 * If mmu_notifier_count is zero, then no in-progress invalidations,
-	 * including this one, found a relevant memslot at start(); rechecking
-	 * memslots here is unnecessary.  Note, a false positive (count elevated
-	 * by a different invalidation) is sub-optimal but functionally ok.
+	 * If mmu_invalidate_in_progress is zero, then no in-progress
+	 * invalidations, including this one, found a relevant memslot at
+	 * start(); rechecking memslots here is unnecessary.  Note, a false
+	 * positive (count elevated by a different invalidation) is sub-optimal
+	 * but functionally ok.
 	 */
 	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
-	if (!READ_ONCE(kvm->mmu_notifier_count))
+	if (!READ_ONCE(kvm->mmu_invalidate_in_progress))
 		return;
 
 	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
 }
 
-void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
-				   unsigned long end)
+void kvm_mmu_invalidate_begin(struct kvm *kvm, unsigned long start,
+			      unsigned long end)
 {
 	/*
 	 * The count increase must become visible at unlock time as no
 	 * spte can be established without taking the mmu_lock and
 	 * count is also read inside the mmu_lock critical section.
 	 */
-	kvm->mmu_notifier_count++;
-	if (likely(kvm->mmu_notifier_count == 1)) {
-		kvm->mmu_notifier_range_start = start;
-		kvm->mmu_notifier_range_end = end;
+	kvm->mmu_invalidate_in_progress++;
+	if (likely(kvm->mmu_invalidate_in_progress == 1)) {
+		kvm->mmu_invalidate_range_start = start;
+		kvm->mmu_invalidate_range_end = end;
 	} else {
 		/*
 		 * Fully tracking multiple concurrent ranges has diminishing
@@ -732,10 +733,10 @@ void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
 		 * accumulate and persist until all outstanding invalidates
 		 * complete.
 		 */
-		kvm->mmu_notifier_range_start =
-			min(kvm->mmu_notifier_range_start, start);
-		kvm->mmu_notifier_range_end =
-			max(kvm->mmu_notifier_range_end, end);
+		kvm->mmu_invalidate_range_start =
+			min(kvm->mmu_invalidate_range_start, start);
+		kvm->mmu_invalidate_range_end =
+			max(kvm->mmu_invalidate_range_end, end);
 	}
 }
 
@@ -748,7 +749,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		.end		= range->end,
 		.pte		= __pte(0),
 		.handler	= kvm_unmap_gfn_range,
-		.on_lock	= kvm_inc_notifier_count,
+		.on_lock	= kvm_mmu_invalidate_begin,
 		.on_unlock	= kvm_arch_guest_memory_reclaimed,
 		.flush_on_ret	= true,
 		.may_block	= mmu_notifier_range_blockable(range),
@@ -759,7 +760,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	/*
 	 * Prevent memslot modification between range_start() and range_end()
 	 * so that conditionally locking provides the same result in both
-	 * functions.  Without that guarantee, the mmu_notifier_count
+	 * functions.  Without that guarantee, the mmu_invalidate_in_progress
 	 * adjustments will be imbalanced.
 	 *
 	 * Pairs with the decrement in range_end().
@@ -775,7 +776,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 * any given time, and the caches themselves can check for hva overlap,
 	 * i.e. don't need to rely on memslot overlap checks for performance.
 	 * Because this runs without holding mmu_lock, the pfn caches must use
-	 * mn_active_invalidate_count (see above) instead of mmu_notifier_count.
+	 * mn_active_invalidate_count (see above) instead of
+	 * mmu_invalidate_in_progress.
 	 */
 	gfn_to_pfn_cache_invalidate_start(kvm, range->start, range->end,
 					  hva_range.may_block);
@@ -785,22 +787,22 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	return 0;
 }
 
-void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
-				   unsigned long end)
+void kvm_mmu_invalidate_end(struct kvm *kvm, unsigned long start,
+			    unsigned long end)
 {
 	/*
 	 * This sequence increase will notify the kvm page fault that
 	 * the page that is going to be mapped in the spte could have
 	 * been freed.
 	 */
-	kvm->mmu_notifier_seq++;
+	kvm->mmu_invalidate_seq++;
 	smp_wmb();
 	/*
 	 * The above sequence increase must be visible before the
 	 * below count decrease, which is ensured by the smp_wmb above
-	 * in conjunction with the smp_rmb in mmu_notifier_retry().
+	 * in conjunction with the smp_rmb in mmu_invalidate_retry().
 	 */
-	kvm->mmu_notifier_count--;
+	kvm->mmu_invalidate_in_progress--;
 }
 
 static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
@@ -812,7 +814,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 		.end		= range->end,
 		.pte		= __pte(0),
 		.handler	= (void *)kvm_null_fn,
-		.on_lock	= kvm_dec_notifier_count,
+		.on_lock	= kvm_mmu_invalidate_end,
 		.on_unlock	= (void *)kvm_null_fn,
 		.flush_on_ret	= false,
 		.may_block	= mmu_notifier_range_blockable(range),
@@ -833,7 +835,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 	if (wake)
 		rcuwait_wake_up(&kvm->mn_memslots_update_rcuwait);
 
-	BUG_ON(kvm->mmu_notifier_count < 0);
+	BUG_ON(kvm->mmu_invalidate_in_progress < 0);
 }
 
 static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index ab519f72f2cd..68ff41d39545 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -112,27 +112,28 @@ static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_s
 {
 	/*
 	 * mn_active_invalidate_count acts for all intents and purposes
-	 * like mmu_notifier_count here; but the latter cannot be used
-	 * here because the invalidation of caches in the mmu_notifier
-	 * event occurs _before_ mmu_notifier_count is elevated.
+	 * like mmu_invalidate_in_progress here; but the latter cannot
+	 * be used here because the invalidation of caches in the
+	 * mmu_notifier event occurs _before_ mmu_invalidate_in_progress
+	 * is elevated.
 	 *
 	 * Note, it does not matter that mn_active_invalidate_count
 	 * is not protected by gpc->lock.  It is guaranteed to
 	 * be elevated before the mmu_notifier acquires gpc->lock, and
-	 * isn't dropped until after mmu_notifier_seq is updated.
+	 * isn't dropped until after mmu_invalidate_seq is updated.
 	 */
 	if (kvm->mn_active_invalidate_count)
 		return true;
 
 	/*
 	 * Ensure mn_active_invalidate_count is read before
-	 * mmu_notifier_seq.  This pairs with the smp_wmb() in
+	 * mmu_invalidate_seq.  This pairs with the smp_wmb() in
 	 * mmu_notifier_invalidate_range_end() to guarantee either the
 	 * old (non-zero) value of mn_active_invalidate_count or the
-	 * new (incremented) value of mmu_notifier_seq is observed.
+	 * new (incremented) value of mmu_invalidate_seq is observed.
 	 */
 	smp_rmb();
-	return kvm->mmu_notifier_seq != mmu_seq;
+	return kvm->mmu_invalidate_seq != mmu_seq;
 }
 
 static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
@@ -155,7 +156,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 	gpc->valid = false;
 
 	do {
-		mmu_seq = kvm->mmu_notifier_seq;
+		mmu_seq = kvm->mmu_invalidate_seq;
 		smp_rmb();
 
 		write_unlock_irq(&gpc->lock);
-- 
2.25.1

