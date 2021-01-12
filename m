Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6152F383C
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405435AbhALSOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406109AbhALSMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:12:24 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00298C061386
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:10 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id hg11so2039585pjb.2
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=LgySdp/viTtAKHo75ouLisNlmtdMi+1tlQE1KRf+Jq4=;
        b=QTLYlhbfBvSUHnGRceHvgJsqjpQ9pkIiNIbG72H1icms1k+Y1ZQZrB+4TZbNkcQWX0
         aZui+zyFZenRerdYpbrS909IS/1jB8vK04IFzG706Q1zHsGjNqhwvg4MA3X89SgfyngI
         fryd1Pl+7BDoh4fAS+H/z9HsrdnRqlB697+gF3+QVW/GTnt7qyx14MbdPGZ2IKn1ubE9
         PZDsNLA2cFKUZkR/+k6NkkSJhBIWSHghq+1YYq2RVjKJI59ymfxIzTtMMcIGduXxEtIg
         iEeGKPr3OKt5wZLtd++93vx3qs3FiLnNc8p+kcUSSClEgieBQxDmJyfTIlRgZpsrzHjg
         N0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LgySdp/viTtAKHo75ouLisNlmtdMi+1tlQE1KRf+Jq4=;
        b=Y58iSa6sY4F+wqViDuImPY1E6IhIR4HatR8nvq9TUdIz1y4n3c7aWKnmcv4A82eTSz
         4M2mMSIc5IOiKkUNYjUCLdEAX3FPWbyHFGH9oHdFw4DzQAkGCLhQZCDVW5Jb1IG6010q
         stS5LaBmkeVlH9P780ylIBIPcM3n3P1yGz4MJl1zlcRfS/7iHer7fmdurT9WtHiXnnvY
         ATZN+1MVG2PLougBckFRnZB9XQzZKrE6TlZPzD1ihPHLnv8FVcrmq9UU6juHKi8oooyD
         xXb2+cOfvc93HSNDM0Qy1l0lktTvTDCTBiDRP9OKmrDMQKbydDs+n0ZlGgfB25cnGCYs
         wqcA==
X-Gm-Message-State: AOAM533KvVP/LPupSM4fytNg222wE/Yz9pbe53H5fhTYvc8aLwfFDCPk
        4Ol7rBnb0ilbI3jyLhx6SpGfEvHPv4yW
X-Google-Smtp-Source: ABdhPJzI5cQkD7HnsDIExEpsPued8FVcuF8LikUPCjLBUmwsTUTavYpHAwQZc0N5LYB5M+kfE1u2RRRisIm1
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a62:19cb:0:b029:19e:75c2:61ec with SMTP id
 194-20020a6219cb0000b029019e75c261ecmr190157pfz.19.1610475070498; Tue, 12 Jan
 2021 10:11:10 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:31 -0800
In-Reply-To: <20210112181041.356734-1-bgardon@google.com>
Message-Id: <20210112181041.356734-15-bgardon@google.com>
Mime-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 14/24] kvm: mmu: Wrap mmu_lock lock / unlock in a function
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wrap locking and unlocking the mmu_lock in a function. This will
facilitate future logging and stat collection for the lock and more
immediately support a refactoring to move the lock into the struct
kvm_arch(s) so that x86 can change the spinlock to a rwlock without
affecting the performance of other archs.

No functional change intended.

Signed-off-by: Peter Feiner <pfeiner@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/arm64/kvm/mmu.c                   | 36 ++++++-------
 arch/mips/kvm/mips.c                   |  8 +--
 arch/mips/kvm/mmu.c                    | 14 ++---
 arch/powerpc/kvm/book3s_64_mmu_host.c  |  4 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    | 12 ++---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 22 ++++----
 arch/powerpc/kvm/book3s_hv.c           |  8 +--
 arch/powerpc/kvm/book3s_hv_nested.c    | 52 +++++++++---------
 arch/powerpc/kvm/book3s_mmu_hpte.c     | 10 ++--
 arch/powerpc/kvm/e500_mmu_host.c       |  4 +-
 arch/x86/kvm/mmu/mmu.c                 | 74 +++++++++++++-------------
 arch/x86/kvm/mmu/page_track.c          |  8 +--
 arch/x86/kvm/mmu/paging_tmpl.h         |  8 +--
 arch/x86/kvm/mmu/tdp_mmu.c             |  6 +--
 arch/x86/kvm/x86.c                     |  4 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c       | 12 ++---
 include/linux/kvm_host.h               |  3 ++
 virt/kvm/dirty_ring.c                  |  4 +-
 virt/kvm/kvm_main.c                    | 42 +++++++++------
 19 files changed, 172 insertions(+), 159 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7d2257cc5438..402b1642c944 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -164,13 +164,13 @@ static void stage2_flush_vm(struct kvm *kvm)
 	int idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 
 	slots = kvm_memslots(kvm);
 	kvm_for_each_memslot(memslot, slots)
 		stage2_flush_memslot(kvm, memslot);
 
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
@@ -456,13 +456,13 @@ void stage2_unmap_vm(struct kvm *kvm)
 
 	idx = srcu_read_lock(&kvm->srcu);
 	mmap_read_lock(current->mm);
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 
 	slots = kvm_memslots(kvm);
 	kvm_for_each_memslot(memslot, slots)
 		stage2_unmap_memslot(kvm, memslot);
 
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	mmap_read_unlock(current->mm);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
@@ -472,14 +472,14 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	struct kvm *kvm = mmu->kvm;
 	struct kvm_pgtable *pgt = NULL;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	pgt = mmu->pgt;
 	if (pgt) {
 		mmu->pgd_phys = 0;
 		mmu->pgt = NULL;
 		free_percpu(mmu->last_vcpu_ran);
 	}
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 
 	if (pgt) {
 		kvm_pgtable_stage2_destroy(pgt);
@@ -516,10 +516,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 		if (ret)
 			break;
 
-		spin_lock(&kvm->mmu_lock);
+		kvm_mmu_lock(kvm);
 		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
 					     &cache);
-		spin_unlock(&kvm->mmu_lock);
+		kvm_mmu_unlock(kvm);
 		if (ret)
 			break;
 
@@ -567,9 +567,9 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	start = memslot->base_gfn << PAGE_SHIFT;
 	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	stage2_wp_range(&kvm->arch.mmu, start, end);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	kvm_flush_remote_tlbs(kvm);
 }
 
@@ -867,7 +867,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && device)
 		return -ENOEXEC;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	pgt = vcpu->arch.hw_mmu->pgt;
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
@@ -912,7 +912,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 out_unlock:
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	kvm_set_pfn_accessed(pfn);
 	kvm_release_pfn_clean(pfn);
 	return ret;
@@ -927,10 +927,10 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 
 	trace_kvm_access_fault(fault_ipa);
 
-	spin_lock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_lock(vcpu->kvm);
 	mmu = vcpu->arch.hw_mmu;
 	kpte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_unlock(vcpu->kvm);
 
 	pte = __pte(kpte);
 	if (pte_valid(pte))
@@ -1365,12 +1365,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if (change == KVM_MR_FLAGS_ONLY)
 		goto out;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	if (ret)
 		unmap_stage2_range(&kvm->arch.mmu, mem->guest_phys_addr, mem->memory_size);
 	else if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
 		stage2_flush_memslot(kvm, memslot);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 out:
 	mmap_read_unlock(current->mm);
 	return ret;
@@ -1395,9 +1395,9 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	gpa_t gpa = slot->base_gfn << PAGE_SHIFT;
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 }
 
 /*
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 3d6a7f5827b1..4e393d93c1aa 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -217,13 +217,13 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	 * need to ensure that it can no longer be accessed by any guest VCPUs.
 	 */
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	/* Flush slot from GPA */
 	kvm_mips_flush_gpa_pt(kvm, slot->base_gfn,
 			      slot->base_gfn + slot->npages - 1);
 	/* Let implementation do the rest */
 	kvm_mips_callbacks->flush_shadow_memslot(kvm, slot);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
@@ -258,14 +258,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	if (change == KVM_MR_FLAGS_ONLY &&
 	    (!(old->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
 	     new->flags & KVM_MEM_LOG_DIRTY_PAGES)) {
-		spin_lock(&kvm->mmu_lock);
+		kvm_mmu_lock(kvm);
 		/* Write protect GPA page table entries */
 		needs_flush = kvm_mips_mkclean_gpa_pt(kvm, new->base_gfn,
 					new->base_gfn + new->npages - 1);
 		/* Let implementation do the rest */
 		if (needs_flush)
 			kvm_mips_callbacks->flush_shadow_memslot(kvm, new);
-		spin_unlock(&kvm->mmu_lock);
+		kvm_mmu_unlock(kvm);
 	}
 }
 
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 3dabeda82458..449663152b3c 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -593,7 +593,7 @@ static int _kvm_mips_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa,
 	bool pfn_valid = false;
 	int ret = 0;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 
 	/* Fast path - just check GPA page table for an existing entry */
 	ptep = kvm_mips_pte_for_gpa(kvm, NULL, gpa);
@@ -628,7 +628,7 @@ static int _kvm_mips_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa,
 		*out_buddy = *ptep_buddy(ptep);
 
 out:
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	if (pfn_valid)
 		kvm_set_pfn_accessed(pfn);
 	return ret;
@@ -710,7 +710,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 		goto out;
 	}
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	/* Check if an invalidation has taken place since we got pfn */
 	if (mmu_notifier_retry(kvm, mmu_seq)) {
 		/*
@@ -718,7 +718,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 		 * also synchronously if a COW is triggered by
 		 * gfn_to_pfn_prot().
 		 */
-		spin_unlock(&kvm->mmu_lock);
+		kvm_mmu_unlock(kvm);
 		kvm_release_pfn_clean(pfn);
 		goto retry;
 	}
@@ -748,7 +748,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 	if (out_buddy)
 		*out_buddy = *ptep_buddy(ptep);
 
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	kvm_release_pfn_clean(pfn);
 	kvm_set_pfn_accessed(pfn);
 out:
@@ -1041,12 +1041,12 @@ int kvm_mips_handle_mapped_seg_tlb_fault(struct kvm_vcpu *vcpu,
 	/* And its GVA buddy's GPA page table entry if it also exists */
 	pte_gpa[!idx] = pfn_pte(0, __pgprot(0));
 	if (tlb_lo[!idx] & ENTRYLO_V) {
-		spin_lock(&kvm->mmu_lock);
+		kvm_mmu_lock(kvm);
 		ptep_buddy = kvm_mips_pte_for_gpa(kvm, NULL,
 					mips3_tlbpfn_to_paddr(tlb_lo[!idx]));
 		if (ptep_buddy)
 			pte_gpa[!idx] = *ptep_buddy;
-		spin_unlock(&kvm->mmu_lock);
+		kvm_mmu_unlock(kvm);
 	}
 
 	/* Get the GVA page table entry pair */
diff --git a/arch/powerpc/kvm/book3s_64_mmu_host.c b/arch/powerpc/kvm/book3s_64_mmu_host.c
index e452158a18d7..4039a90c250c 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_host.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_host.c
@@ -148,7 +148,7 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte,
 
 	cpte = kvmppc_mmu_hpte_cache_next(vcpu);
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	if (!cpte || mmu_notifier_retry(kvm, mmu_seq)) {
 		r = -EAGAIN;
 		goto out_unlock;
@@ -200,7 +200,7 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte,
 	}
 
 out_unlock:
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	kvm_release_pfn_clean(pfn);
 	if (cpte)
 		kvmppc_mmu_hpte_cache_free(cpte);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 38ea396a23d6..b1300a18efa7 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -605,12 +605,12 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 	 * Read the PTE from the process' radix tree and use that
 	 * so we get the shift and attribute bits.
 	 */
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	ptep = find_kvm_host_pte(kvm, mmu_seq, hva, &shift);
 	pte = __pte(0);
 	if (ptep)
 		pte = READ_ONCE(*ptep);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	/*
 	 * If the PTE disappeared temporarily due to a THP
 	 * collapse, just return and let the guest try again.
@@ -739,14 +739,14 @@ void kvmppc_rmap_reset(struct kvm *kvm)
 	slots = kvm_memslots(kvm);
 	kvm_for_each_memslot(memslot, slots) {
 		/* Mutual exclusion with kvm_unmap_hva_range etc. */
-		spin_lock(&kvm->mmu_lock);
+		kvm_mmu_lock(kvm);
 		/*
 		 * This assumes it is acceptable to lose reference and
 		 * change bits across a reset.
 		 */
 		memset(memslot->arch.rmap, 0,
 		       memslot->npages * sizeof(*memslot->arch.rmap));
-		spin_unlock(&kvm->mmu_lock);
+		kvm_mmu_unlock(kvm);
 	}
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 }
@@ -1405,14 +1405,14 @@ static void resize_hpt_pivot(struct kvm_resize_hpt *resize)
 
 	resize_hpt_debug(resize, "resize_hpt_pivot()\n");
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	asm volatile("ptesync" : : : "memory");
 
 	hpt_tmp = kvm->arch.hpt;
 	kvmppc_set_hpt(kvm, &resize->hpt);
 	resize->hpt = hpt_tmp;
 
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 
 	synchronize_srcu_expedited(&kvm->srcu);
 
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index bb35490400e9..b628980c871b 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -613,7 +613,7 @@ int kvmppc_create_pte(struct kvm *kvm, pgd_t *pgtable, pte_t pte,
 		new_ptep = kvmppc_pte_alloc();
 
 	/* Check if we might have been invalidated; let the guest retry if so */
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	ret = -EAGAIN;
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
@@ -749,7 +749,7 @@ int kvmppc_create_pte(struct kvm *kvm, pgd_t *pgtable, pte_t pte,
 	ret = 0;
 
  out_unlock:
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	if (new_pud)
 		pud_free(kvm->mm, new_pud);
 	if (new_pmd)
@@ -837,12 +837,12 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 	 * Read the PTE from the process' radix tree and use that
 	 * so we get the shift and attribute bits.
 	 */
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	ptep = find_kvm_host_pte(kvm, mmu_seq, hva, &shift);
 	pte = __pte(0);
 	if (ptep)
 		pte = READ_ONCE(*ptep);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	/*
 	 * If the PTE disappeared temporarily due to a THP
 	 * collapse, just return and let the guest try again.
@@ -972,11 +972,11 @@ int kvmppc_book3s_radix_page_fault(struct kvm_vcpu *vcpu,
 
 	/* Failed to set the reference/change bits */
 	if (dsisr & DSISR_SET_RC) {
-		spin_lock(&kvm->mmu_lock);
+		kvm_mmu_lock(kvm);
 		if (kvmppc_hv_handle_set_rc(kvm, false, writing,
 					    gpa, kvm->arch.lpid))
 			dsisr &= ~DSISR_SET_RC;
-		spin_unlock(&kvm->mmu_lock);
+		kvm_mmu_unlock(kvm);
 
 		if (!(dsisr & (DSISR_BAD_FAULT_64S | DSISR_NOHPTE |
 			       DSISR_PROTFAULT | DSISR_SET_RC)))
@@ -1082,7 +1082,7 @@ static int kvm_radix_test_clear_dirty(struct kvm *kvm,
 
 	pte = READ_ONCE(*ptep);
 	if (pte_present(pte) && pte_dirty(pte)) {
-		spin_lock(&kvm->mmu_lock);
+		kvm_mmu_lock(kvm);
 		/*
 		 * Recheck the pte again
 		 */
@@ -1094,7 +1094,7 @@ static int kvm_radix_test_clear_dirty(struct kvm *kvm,
 			 * walk.
 			 */
 			if (!pte_present(*ptep) || !pte_dirty(*ptep)) {
-				spin_unlock(&kvm->mmu_lock);
+				kvm_mmu_unlock(kvm);
 				return 0;
 			}
 		}
@@ -1109,7 +1109,7 @@ static int kvm_radix_test_clear_dirty(struct kvm *kvm,
 		kvmhv_update_nest_rmap_rc_list(kvm, rmapp, _PAGE_DIRTY, 0,
 					       old & PTE_RPN_MASK,
 					       1UL << shift);
-		spin_unlock(&kvm->mmu_lock);
+		kvm_mmu_unlock(kvm);
 	}
 	return ret;
 }
@@ -1154,7 +1154,7 @@ void kvmppc_radix_flush_memslot(struct kvm *kvm,
 		return;
 
 	gpa = memslot->base_gfn << PAGE_SHIFT;
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	for (n = memslot->npages; n; --n) {
 		ptep = find_kvm_secondary_pte(kvm, gpa, &shift);
 		if (ptep && pte_present(*ptep))
@@ -1167,7 +1167,7 @@ void kvmppc_radix_flush_memslot(struct kvm *kvm,
 	 * fault that read the memslot earlier from writing a PTE.
 	 */
 	kvm->mmu_notifier_seq++;
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 }
 
 static void add_rmmu_ap_encoding(struct kvm_ppc_rmmu_info *info,
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6f612d240392..ec08abd532f1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4753,9 +4753,9 @@ int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
 	kvmppc_rmap_reset(kvm);
 	kvm->arch.process_table = 0;
 	/* Mutual exclusion with kvm_unmap_hva_range etc. */
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	kvm->arch.radix = 0;
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	kvmppc_free_radix(kvm);
 	kvmppc_update_lpcr(kvm, LPCR_VPM1,
 			   LPCR_VPM1 | LPCR_UPRT | LPCR_GTSE | LPCR_HR);
@@ -4775,9 +4775,9 @@ int kvmppc_switch_mmu_to_radix(struct kvm *kvm)
 		return err;
 	kvmppc_rmap_reset(kvm);
 	/* Mutual exclusion with kvm_unmap_hva_range etc. */
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	kvm->arch.radix = 1;
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	kvmppc_free_hpt(&kvm->arch.hpt);
 	kvmppc_update_lpcr(kvm, LPCR_UPRT | LPCR_GTSE | LPCR_HR,
 			   LPCR_VPM1 | LPCR_UPRT | LPCR_GTSE | LPCR_HR);
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 33b58549a9aa..18890dca9476 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -628,7 +628,7 @@ static void kvmhv_remove_nested(struct kvm_nested_guest *gp)
 	int lpid = gp->l1_lpid;
 	long ref;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	if (gp == kvm->arch.nested_guests[lpid]) {
 		kvm->arch.nested_guests[lpid] = NULL;
 		if (lpid == kvm->arch.max_nested_lpid) {
@@ -639,7 +639,7 @@ static void kvmhv_remove_nested(struct kvm_nested_guest *gp)
 		--gp->refcnt;
 	}
 	ref = gp->refcnt;
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	if (ref == 0)
 		kvmhv_release_nested(gp);
 }
@@ -658,7 +658,7 @@ void kvmhv_release_all_nested(struct kvm *kvm)
 	struct kvm_memory_slot *memslot;
 	int srcu_idx;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	for (i = 0; i <= kvm->arch.max_nested_lpid; i++) {
 		gp = kvm->arch.nested_guests[i];
 		if (!gp)
@@ -670,7 +670,7 @@ void kvmhv_release_all_nested(struct kvm *kvm)
 		}
 	}
 	kvm->arch.max_nested_lpid = -1;
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	while ((gp = freelist) != NULL) {
 		freelist = gp->next;
 		kvmhv_release_nested(gp);
@@ -687,9 +687,9 @@ static void kvmhv_flush_nested(struct kvm_nested_guest *gp)
 {
 	struct kvm *kvm = gp->l1_host;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	kvmppc_free_pgtable_radix(kvm, gp->shadow_pgtable, gp->shadow_lpid);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	kvmhv_flush_lpid(gp->shadow_lpid);
 	kvmhv_update_ptbl_cache(gp);
 	if (gp->l1_gr_to_hr == 0)
@@ -705,11 +705,11 @@ struct kvm_nested_guest *kvmhv_get_nested(struct kvm *kvm, int l1_lpid,
 	    l1_lpid >= (1ul << ((kvm->arch.l1_ptcr & PRTS_MASK) + 12 - 4)))
 		return NULL;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	gp = kvm->arch.nested_guests[l1_lpid];
 	if (gp)
 		++gp->refcnt;
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 
 	if (gp || !create)
 		return gp;
@@ -717,7 +717,7 @@ struct kvm_nested_guest *kvmhv_get_nested(struct kvm *kvm, int l1_lpid,
 	newgp = kvmhv_alloc_nested(kvm, l1_lpid);
 	if (!newgp)
 		return NULL;
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	if (kvm->arch.nested_guests[l1_lpid]) {
 		/* someone else beat us to it */
 		gp = kvm->arch.nested_guests[l1_lpid];
@@ -730,7 +730,7 @@ struct kvm_nested_guest *kvmhv_get_nested(struct kvm *kvm, int l1_lpid,
 			kvm->arch.max_nested_lpid = l1_lpid;
 	}
 	++gp->refcnt;
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 
 	if (newgp)
 		kvmhv_release_nested(newgp);
@@ -743,9 +743,9 @@ void kvmhv_put_nested(struct kvm_nested_guest *gp)
 	struct kvm *kvm = gp->l1_host;
 	long ref;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	ref = --gp->refcnt;
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	if (ref == 0)
 		kvmhv_release_nested(gp);
 }
@@ -940,7 +940,7 @@ static bool kvmhv_invalidate_shadow_pte(struct kvm_vcpu *vcpu,
 	pte_t *ptep;
 	int shift;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	ptep = find_kvm_nested_guest_pte(kvm, gp->l1_lpid, gpa, &shift);
 	if (!shift)
 		shift = PAGE_SHIFT;
@@ -948,7 +948,7 @@ static bool kvmhv_invalidate_shadow_pte(struct kvm_vcpu *vcpu,
 		kvmppc_unmap_pte(kvm, ptep, gpa, shift, NULL, gp->shadow_lpid);
 		ret = true;
 	}
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 
 	if (shift_ret)
 		*shift_ret = shift;
@@ -1035,11 +1035,11 @@ static void kvmhv_emulate_tlbie_lpid(struct kvm_vcpu *vcpu,
 	switch (ric) {
 	case 0:
 		/* Invalidate TLB */
-		spin_lock(&kvm->mmu_lock);
+		kvm_mmu_lock(kvm);
 		kvmppc_free_pgtable_radix(kvm, gp->shadow_pgtable,
 					  gp->shadow_lpid);
 		kvmhv_flush_lpid(gp->shadow_lpid);
-		spin_unlock(&kvm->mmu_lock);
+		kvm_mmu_unlock(kvm);
 		break;
 	case 1:
 		/*
@@ -1063,16 +1063,16 @@ static void kvmhv_emulate_tlbie_all_lpid(struct kvm_vcpu *vcpu, int ric)
 	struct kvm_nested_guest *gp;
 	int i;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	for (i = 0; i <= kvm->arch.max_nested_lpid; i++) {
 		gp = kvm->arch.nested_guests[i];
 		if (gp) {
-			spin_unlock(&kvm->mmu_lock);
+			kvm_mmu_unlock(kvm);
 			kvmhv_emulate_tlbie_lpid(vcpu, gp, ric);
-			spin_lock(&kvm->mmu_lock);
+			kvm_mmu_lock(kvm);
 		}
 	}
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 }
 
 static int kvmhv_emulate_priv_tlbie(struct kvm_vcpu *vcpu, unsigned int instr,
@@ -1230,7 +1230,7 @@ static long kvmhv_handle_nested_set_rc(struct kvm_vcpu *vcpu,
 	if (pgflags & ~gpte.rc)
 		return RESUME_HOST;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	/* Set the rc bit in the pte of our (L0) pgtable for the L1 guest */
 	ret = kvmppc_hv_handle_set_rc(kvm, false, writing,
 				      gpte.raddr, kvm->arch.lpid);
@@ -1248,7 +1248,7 @@ static long kvmhv_handle_nested_set_rc(struct kvm_vcpu *vcpu,
 		ret = 0;
 
 out_unlock:
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	return ret;
 }
 
@@ -1380,13 +1380,13 @@ static long int __kvmhv_nested_page_fault(struct kvm_vcpu *vcpu,
 
 	/* See if can find translation in our partition scoped tables for L1 */
 	pte = __pte(0);
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	pte_p = find_kvm_secondary_pte(kvm, gpa, &shift);
 	if (!shift)
 		shift = PAGE_SHIFT;
 	if (pte_p)
 		pte = *pte_p;
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 
 	if (!pte_present(pte) || (writing && !(pte_val(pte) & _PAGE_WRITE))) {
 		/* No suitable pte found -> try to insert a mapping */
@@ -1461,13 +1461,13 @@ int kvmhv_nested_next_lpid(struct kvm *kvm, int lpid)
 {
 	int ret = -1;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	while (++lpid <= kvm->arch.max_nested_lpid) {
 		if (kvm->arch.nested_guests[lpid]) {
 			ret = lpid;
 			break;
 		}
 	}
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	return ret;
 }
diff --git a/arch/powerpc/kvm/book3s_mmu_hpte.c b/arch/powerpc/kvm/book3s_mmu_hpte.c
index ce79ac33e8d3..ec1b5a6dfee1 100644
--- a/arch/powerpc/kvm/book3s_mmu_hpte.c
+++ b/arch/powerpc/kvm/book3s_mmu_hpte.c
@@ -60,7 +60,7 @@ void kvmppc_mmu_hpte_cache_map(struct kvm_vcpu *vcpu, struct hpte_cache *pte)
 
 	trace_kvm_book3s_mmu_map(pte);
 
-	spin_lock(&vcpu3s->mmu_lock);
+	kvm_mmu_lock(vcpu3s);
 
 	/* Add to ePTE list */
 	index = kvmppc_mmu_hash_pte(pte->pte.eaddr);
@@ -89,7 +89,7 @@ void kvmppc_mmu_hpte_cache_map(struct kvm_vcpu *vcpu, struct hpte_cache *pte)
 
 	vcpu3s->hpte_cache_count++;
 
-	spin_unlock(&vcpu3s->mmu_lock);
+	kvm_mmu_unlock(vcpu3s);
 }
 
 static void free_pte_rcu(struct rcu_head *head)
@@ -107,11 +107,11 @@ static void invalidate_pte(struct kvm_vcpu *vcpu, struct hpte_cache *pte)
 	/* Different for 32 and 64 bit */
 	kvmppc_mmu_invalidate_pte(vcpu, pte);
 
-	spin_lock(&vcpu3s->mmu_lock);
+	kvm_mmu_lock(vcpu3s);
 
 	/* pte already invalidated in between? */
 	if (hlist_unhashed(&pte->list_pte)) {
-		spin_unlock(&vcpu3s->mmu_lock);
+		kvm_mmu_unlock(vcpu3s);
 		return;
 	}
 
@@ -124,7 +124,7 @@ static void invalidate_pte(struct kvm_vcpu *vcpu, struct hpte_cache *pte)
 #endif
 	vcpu3s->hpte_cache_count--;
 
-	spin_unlock(&vcpu3s->mmu_lock);
+	kvm_mmu_unlock(vcpu3s);
 
 	call_rcu(&pte->rcu_head, free_pte_rcu);
 }
diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index ed0c9c43d0cf..633ae418ba0e 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -459,7 +459,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 		gvaddr &= ~((tsize_pages << PAGE_SHIFT) - 1);
 	}
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	if (mmu_notifier_retry(kvm, mmu_seq)) {
 		ret = -EAGAIN;
 		goto out;
@@ -499,7 +499,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	kvmppc_mmu_flush_icache(pfn);
 
 out:
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 
 	/* Drop refcount on page, so that mmu notifiers can clear it */
 	kvm_release_pfn_clean(pfn);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481aa29d..5a4577830606 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2470,7 +2470,7 @@ static int make_mmu_pages_available(struct kvm_vcpu *vcpu)
  */
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long goal_nr_mmu_pages)
 {
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 
 	if (kvm->arch.n_used_mmu_pages > goal_nr_mmu_pages) {
 		kvm_mmu_zap_oldest_mmu_pages(kvm, kvm->arch.n_used_mmu_pages -
@@ -2481,7 +2481,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long goal_nr_mmu_pages)
 
 	kvm->arch.n_max_mmu_pages = goal_nr_mmu_pages;
 
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 }
 
 int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
@@ -2492,7 +2492,7 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 
 	pgprintk("%s: looking for gfn %llx\n", __func__, gfn);
 	r = 0;
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
 		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
 			 sp->role.word);
@@ -2500,7 +2500,7 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 	}
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 
 	return r;
 }
@@ -3192,7 +3192,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			return;
 	}
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		if (roots_to_free & KVM_MMU_ROOT_PREVIOUS(i))
@@ -3215,7 +3215,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	}
 
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_free_roots);
 
@@ -3236,16 +3236,16 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
 {
 	struct kvm_mmu_page *sp;
 
-	spin_lock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_lock(vcpu->kvm);
 
 	if (make_mmu_pages_available(vcpu)) {
-		spin_unlock(&vcpu->kvm->mmu_lock);
+		kvm_mmu_unlock(vcpu->kvm);
 		return INVALID_PAGE;
 	}
 	sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
 	++sp->root_count;
 
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_unlock(vcpu->kvm);
 	return __pa(sp->spt);
 }
 
@@ -3416,17 +3416,17 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 		    !smp_load_acquire(&sp->unsync_children))
 			return;
 
-		spin_lock(&vcpu->kvm->mmu_lock);
+		kvm_mmu_lock(vcpu->kvm);
 		kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
 
 		mmu_sync_children(vcpu, sp);
 
 		kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
-		spin_unlock(&vcpu->kvm->mmu_lock);
+		kvm_mmu_unlock(vcpu->kvm);
 		return;
 	}
 
-	spin_lock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_lock(vcpu->kvm);
 	kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
 
 	for (i = 0; i < 4; ++i) {
@@ -3440,7 +3440,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	}
 
 	kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_unlock(vcpu->kvm);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_sync_roots);
 
@@ -3724,7 +3724,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		return r;
 
 	r = RET_PF_RETRY;
-	spin_lock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_lock(vcpu->kvm);
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
 	r = make_mmu_pages_available(vcpu);
@@ -3739,7 +3739,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 				 prefault, is_tdp);
 
 out_unlock:
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_unlock(vcpu->kvm);
 	kvm_release_pfn_clean(pfn);
 	return r;
 }
@@ -4999,7 +4999,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	 */
 	mmu_topup_memory_caches(vcpu, true);
 
-	spin_lock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_lock(vcpu->kvm);
 
 	gentry = mmu_pte_write_fetch_gpte(vcpu, &gpa, &bytes);
 
@@ -5035,7 +5035,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	}
 	kvm_mmu_flush_or_zap(vcpu, &invalid_list, remote_flush, local_flush);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PTE_WRITE);
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_unlock(vcpu->kvm);
 }
 
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
@@ -5423,7 +5423,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 {
 	lockdep_assert_held(&kvm->slots_lock);
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	trace_kvm_mmu_zap_all_fast(kvm);
 
 	/*
@@ -5450,7 +5450,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	if (kvm->arch.tdp_mmu_enabled)
 		kvm_tdp_mmu_zap_all(kvm);
 
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 }
 
 static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
@@ -5492,7 +5492,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	int i;
 	bool flush;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		slots = __kvm_memslots(kvm, i);
 		kvm_for_each_memslot(memslot, slots) {
@@ -5516,7 +5516,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 			kvm_flush_remote_tlbs(kvm);
 	}
 
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 }
 
 static bool slot_rmap_write_protect(struct kvm *kvm,
@@ -5531,12 +5531,12 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 {
 	bool flush;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
 				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
 	if (kvm->arch.tdp_mmu_enabled)
 		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_4K);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 
 	/*
 	 * We can flush all the TLBs out of the mmu lock without TLB
@@ -5596,13 +5596,13 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot)
 {
 	/* FIXME: const-ify all uses of struct kvm_memory_slot.  */
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	slot_handle_leaf(kvm, (struct kvm_memory_slot *)memslot,
 			 kvm_mmu_zap_collapsible_spte, true);
 
 	if (kvm->arch.tdp_mmu_enabled)
 		kvm_tdp_mmu_zap_collapsible_sptes(kvm, memslot);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 }
 
 void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
@@ -5625,11 +5625,11 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 {
 	bool flush;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty, false);
 	if (kvm->arch.tdp_mmu_enabled)
 		flush |= kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 
 	/*
 	 * It's also safe to flush TLBs out of mmu lock here as currently this
@@ -5647,12 +5647,12 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 {
 	bool flush;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	flush = slot_handle_large_level(kvm, memslot, slot_rmap_write_protect,
 					false);
 	if (kvm->arch.tdp_mmu_enabled)
 		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_2M);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
@@ -5664,11 +5664,11 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 {
 	bool flush;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	flush = slot_handle_all_level(kvm, memslot, __rmap_set_dirty, false);
 	if (kvm->arch.tdp_mmu_enabled)
 		flush |= kvm_tdp_mmu_slot_set_dirty(kvm, memslot);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
@@ -5681,7 +5681,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	LIST_HEAD(invalid_list);
 	int ign;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 restart:
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
 		if (WARN_ON(sp->role.invalid))
@@ -5697,7 +5697,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	if (kvm->arch.tdp_mmu_enabled)
 		kvm_tdp_mmu_zap_all(kvm);
 
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 }
 
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
@@ -5757,7 +5757,7 @@ mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 			continue;
 
 		idx = srcu_read_lock(&kvm->srcu);
-		spin_lock(&kvm->mmu_lock);
+		kvm_mmu_lock(kvm);
 
 		if (kvm_has_zapped_obsolete_pages(kvm)) {
 			kvm_mmu_commit_zap_page(kvm,
@@ -5768,7 +5768,7 @@ mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		freed = kvm_mmu_zap_oldest_mmu_pages(kvm, sc->nr_to_scan);
 
 unlock:
-		spin_unlock(&kvm->mmu_lock);
+		kvm_mmu_unlock(kvm);
 		srcu_read_unlock(&kvm->srcu, idx);
 
 		/*
@@ -5988,7 +5988,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 	ulong to_zap;
 
 	rcu_idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 
 	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
 	to_zap = ratio ? DIV_ROUND_UP(kvm->stat.nx_lpage_splits, ratio) : 0;
@@ -6020,7 +6020,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 	}
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
 }
 
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 8443a675715b..7ae4567c58bf 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -184,9 +184,9 @@ kvm_page_track_register_notifier(struct kvm *kvm,
 
 	head = &kvm->arch.track_notifier_head;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	hlist_add_head_rcu(&n->node, &head->track_notifier_list);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 }
 EXPORT_SYMBOL_GPL(kvm_page_track_register_notifier);
 
@@ -202,9 +202,9 @@ kvm_page_track_unregister_notifier(struct kvm *kvm,
 
 	head = &kvm->arch.track_notifier_head;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	hlist_del_rcu(&n->node);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	synchronize_srcu(&head->track_srcu);
 }
 EXPORT_SYMBOL_GPL(kvm_page_track_unregister_notifier);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 50e268eb8e1a..a7a29bf6c683 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -868,7 +868,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	}
 
 	r = RET_PF_RETRY;
-	spin_lock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_lock(vcpu->kvm);
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
 
@@ -881,7 +881,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
 out_unlock:
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_unlock(vcpu->kvm);
 	kvm_release_pfn_clean(pfn);
 	return r;
 }
@@ -919,7 +919,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 		return;
 	}
 
-	spin_lock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_lock(vcpu->kvm);
 	for_each_shadow_entry_using_root(vcpu, root_hpa, gva, iterator) {
 		level = iterator.level;
 		sptep = iterator.sptep;
@@ -954,7 +954,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 		if (!is_shadow_present_pte(*sptep) || !sp->unsync_children)
 			break;
 	}
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_unlock(vcpu->kvm);
 }
 
 /* Note, @addr is a GPA when gva_to_gpa() translates an L2 GPA to an L1 GPA. */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index dc5b4bf34ca2..90807f2d928f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -170,13 +170,13 @@ static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
 
 	role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level);
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 
 	/* Check for an existing root before allocating a new one. */
 	for_each_tdp_mmu_root(kvm, root) {
 		if (root->role.word == role.word) {
 			kvm_mmu_get_root(kvm, root);
-			spin_unlock(&kvm->mmu_lock);
+			kvm_mmu_unlock(kvm);
 			return root;
 		}
 	}
@@ -186,7 +186,7 @@ static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
 
 	list_add(&root->link, &kvm->arch.tdp_mmu_roots);
 
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 
 	return root;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a8969a6dd06..302042af87ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7088,9 +7088,9 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (vcpu->arch.mmu->direct_map) {
 		unsigned int indirect_shadow_pages;
 
-		spin_lock(&vcpu->kvm->mmu_lock);
+		kvm_mmu_lock(vcpu->kvm);
 		indirect_shadow_pages = vcpu->kvm->arch.indirect_shadow_pages;
-		spin_unlock(&vcpu->kvm->mmu_lock);
+		kvm_mmu_unlock(vcpu->kvm);
 
 		if (indirect_shadow_pages)
 			kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 60f1a386dd06..069e189961ff 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1703,7 +1703,7 @@ static int kvmgt_page_track_add(unsigned long handle, u64 gfn)
 		return -EINVAL;
 	}
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 
 	if (kvmgt_gfn_is_write_protected(info, gfn))
 		goto out;
@@ -1712,7 +1712,7 @@ static int kvmgt_page_track_add(unsigned long handle, u64 gfn)
 	kvmgt_protect_table_add(info, gfn);
 
 out:
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 	return 0;
 }
@@ -1737,7 +1737,7 @@ static int kvmgt_page_track_remove(unsigned long handle, u64 gfn)
 		return -EINVAL;
 	}
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 
 	if (!kvmgt_gfn_is_write_protected(info, gfn))
 		goto out;
@@ -1746,7 +1746,7 @@ static int kvmgt_page_track_remove(unsigned long handle, u64 gfn)
 	kvmgt_protect_table_del(info, gfn);
 
 out:
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 	return 0;
 }
@@ -1772,7 +1772,7 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
 	struct kvmgt_guest_info *info = container_of(node,
 					struct kvmgt_guest_info, track_node);
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	for (i = 0; i < slot->npages; i++) {
 		gfn = slot->base_gfn + i;
 		if (kvmgt_gfn_is_write_protected(info, gfn)) {
@@ -1781,7 +1781,7 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
 			kvmgt_protect_table_del(info, gfn);
 		}
 	}
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 }
 
 static bool __kvmgt_vgpu_exist(struct intel_vgpu *vgpu, struct kvm *kvm)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f3b1013fb22c..433d14fdae30 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1495,4 +1495,7 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+void kvm_mmu_lock(struct kvm *kvm);
+void kvm_mmu_unlock(struct kvm *kvm);
+
 #endif
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 9d01299563ee..e1c1538f59a6 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -60,9 +60,9 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
 	if (!memslot || (offset + __fls(mask)) >= memslot->npages)
 		return;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot, offset, mask);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 }
 
 int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fa9e3614d30e..32f97ed1188d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -432,6 +432,16 @@ void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_destroy);
 
+void kvm_mmu_lock(struct kvm *kvm)
+{
+	spin_lock(&kvm->mmu_lock);
+}
+
+void kvm_mmu_unlock(struct kvm *kvm)
+{
+	spin_unlock(&kvm->mmu_lock);
+}
+
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
 {
@@ -459,13 +469,13 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 	int idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	kvm->mmu_notifier_seq++;
 
 	if (kvm_set_spte_hva(kvm, address, pte))
 		kvm_flush_remote_tlbs(kvm);
 
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
@@ -476,7 +486,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	int need_tlb_flush = 0, idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	/*
 	 * The count increase must become visible at unlock time as no
 	 * spte can be established without taking the mmu_lock and
@@ -489,7 +499,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	if (need_tlb_flush || kvm->tlbs_dirty)
 		kvm_flush_remote_tlbs(kvm);
 
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return 0;
@@ -500,7 +510,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	/*
 	 * This sequence increase will notify the kvm page fault that
 	 * the page that is going to be mapped in the spte could have
@@ -514,7 +524,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 	 * in conjunction with the smp_rmb in mmu_notifier_retry().
 	 */
 	kvm->mmu_notifier_count--;
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 
 	BUG_ON(kvm->mmu_notifier_count < 0);
 }
@@ -528,13 +538,13 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 	int young, idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 
 	young = kvm_age_hva(kvm, start, end);
 	if (young)
 		kvm_flush_remote_tlbs(kvm);
 
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return young;
@@ -549,7 +559,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	int young, idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	/*
 	 * Even though we do not flush TLB, this will still adversely
 	 * affect performance on pre-Haswell Intel EPT, where there is
@@ -564,7 +574,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * more sophisticated heuristic later.
 	 */
 	young = kvm_age_hva(kvm, start, end);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return young;
@@ -578,9 +588,9 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 	int young, idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	young = kvm_test_age_hva(kvm, address);
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return young;
@@ -1524,7 +1534,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 		dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
 		memset(dirty_bitmap_buffer, 0, n);
 
-		spin_lock(&kvm->mmu_lock);
+		kvm_mmu_lock(kvm);
 		for (i = 0; i < n / sizeof(long); i++) {
 			unsigned long mask;
 			gfn_t offset;
@@ -1540,7 +1550,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
 								offset, mask);
 		}
-		spin_unlock(&kvm->mmu_lock);
+		kvm_mmu_unlock(kvm);
 	}
 
 	if (flush)
@@ -1635,7 +1645,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
 		return -EFAULT;
 
-	spin_lock(&kvm->mmu_lock);
+	kvm_mmu_lock(kvm);
 	for (offset = log->first_page, i = offset / BITS_PER_LONG,
 		 n = DIV_ROUND_UP(log->num_pages, BITS_PER_LONG); n--;
 	     i++, offset += BITS_PER_LONG) {
@@ -1658,7 +1668,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 								offset, mask);
 		}
 	}
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_unlock(kvm);
 
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
-- 
2.30.0.284.gd98b1dd5eaa7-goog

