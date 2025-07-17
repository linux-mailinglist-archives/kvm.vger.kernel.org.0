Return-Path: <kvm+bounces-52768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAEF8B091CF
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 18:29:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8FF516F716
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 16:29:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 492E32FF46B;
	Thu, 17 Jul 2025 16:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tLmfTfMY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B242FCE34
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 16:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769671; cv=none; b=Ub1Tx/HLyP7/qF4PBVocKIwk82yTgbtlieBlAKMvXtOwSmodga49si1XJ+Pdps7+e4ozkq6G4xdTw87RK7rxJTdSygid1BX4CxKfXTzk4nOTJS4wQYQaoL3Hb9LzjNA9yENdE8Qjpa8VP5Yy8Av+nO4IGh/p8ltpEjNFnMyCp/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769671; c=relaxed/simple;
	bh=JyP2SYIGgJjBVzP+usBFRfDyLfJWSnH5eMhf6SDfTFk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iSNkD3+3eho5KARTcJ4jvvB9/siebgbp4Z31nbZjNawCRct5IadWkmoNhQ1dM/trEHWK9Z8bjSm2QKSvh2gzLPxaapaJk7MOr2hBF1NQg3NY8QCinspIEOpH82iDRT654NCpi3jE311i8junc17t4RJsx6khsdz5qnuAKCQGEOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tLmfTfMY; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4561bc2f477so7413185e9.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 09:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769668; x=1753374468; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0x5SEsp+wQeAofoXD9kRa6NgpqrTyhovX0ubFwE0gGE=;
        b=tLmfTfMY+DBpLkV1XL9sumpd5MW7TiYGZxNCvHkSC1MGda4Kxed/B/psgpk461BZ5J
         /aY5TC34xlbterhPM1kOaeSqyuzqW7uYyvLGrOu2yegbpyMrx2Gqxx3B1U9RmRXSyexp
         a4wrgmfNSmyFIneHLHytiIFIonZl5QNZd+1HeYDDR+aRN7ynW42T8TssMcDz7lqmxQic
         zDYJURp9Ai6I0DcrwLRwhPYqCv+ntK4UFd3Jewthd9DVwl1aD0eyvnuYOOMcStbDzb4H
         lhGvEDTTAzXTDkkWjVwcnqoXlxHoVSLsMF2YF1O9cChWl/E4U2i4ttblXqoUhW7mstwT
         qV/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769668; x=1753374468;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0x5SEsp+wQeAofoXD9kRa6NgpqrTyhovX0ubFwE0gGE=;
        b=P2dy0xIrER/9QqpXqhF6YCoevzwmJtMwF2m3jM7LnFcRyi47Hg1CdgdPO9ZREIo7Vp
         lVtys5zw2RZ75gVGQ5/Fq2xrY0qzg8RzaUgs5Oefks/Uyd1OL6wqneF3nC6e0uppXuHE
         Gz3XJCeA2Fng3H7XDjgASwEmZ+jByRlT/E5zmzcHw5P6+QYGEGwsRz92AMChIWvuVUMF
         12+O85vLp0o9tOnk+nBSHX07xZcGNWjzFANtRII+7Fc9t+InChIv8yqsoa5p0E1HWvXu
         f5BXw5L+scjJ8M/+19Bx8CBHzJ2y3EXzKlUMbq8fuDK/TagQjdH0ZwKYI0pkBCxrh9OH
         jIuw==
X-Gm-Message-State: AOJu0Yy/6Aki21aRPggh/5+GW62Xgg+mTsxc0VQlpJcSDn3wWtf9kPA8
	CEZ9MFUjymBh1PjybjB2vnngpEXzM6kRIwcW24w9MrLRpttA3Rr7oj4W/mfoccGB+hzN+fOb2B2
	hpgUMGpED58jPJiFKeGJZnXrPQVHUXzr1tsF8FH5tw7R+/K3/e6TQ4Feet+hYD+6wVuCWhJP86d
	jDyvHBJHWl84WZl5uy5r7L+fHp15c=
X-Google-Smtp-Source: AGHT+IFEQMKlxKburE51y6GhQarWMnzICIinMsy7I+cfQuk/XM9cfoW4n7svU1NRfYeSI+HbNpHGVG3xCA==
X-Received: from wmsr5.prod.google.com ([2002:a05:600c:8b05:b0:456:15bd:a297])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:64ce:b0:453:5a04:b60e
 with SMTP id 5b1f17b1804b1-4562e37c11fmr60337995e9.26.1752769667737; Thu, 17
 Jul 2025 09:27:47 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:25 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-16-tabba@google.com>
Subject: [PATCH v15 15/21] KVM: arm64: Refactor user_mem_abort()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Refactor user_mem_abort() to improve code clarity and simplify
assumptions within the function.

Key changes include:

* Immediately set force_pte to true at the beginning of the function if
  logging_active is true. This simplifies the flow and makes the
  condition for forcing a PTE more explicit.

* Remove the misleading comment stating that logging_active is
  guaranteed to never be true for VM_PFNMAP memslots, as this assertion
  is not entirely correct.

* Extract reusable code blocks into new helper functions:
  * prepare_mmu_memcache(): Encapsulates the logic for preparing and
    topping up the MMU page cache.
  * adjust_nested_fault_perms(): Isolates the adjustments to shadow S2
    permissions and the encoding of nested translation levels.

* Update min(a, (long)b) to min_t(long, a, b) for better type safety and
  consistency.

* Perform other minor tidying up of the code.

These changes primarily aim to simplify user_mem_abort() and make its
logic easier to understand and maintain, setting the stage for future
modifications.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 110 +++++++++++++++++++++++--------------------
 1 file changed, 59 insertions(+), 51 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2942ec92c5a4..b3eacb400fab 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1470,13 +1470,56 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
+static int prepare_mmu_memcache(struct kvm_vcpu *vcpu, bool topup_memcache,
+				void **memcache)
+{
+	int min_pages;
+
+	if (!is_protected_kvm_enabled())
+		*memcache = &vcpu->arch.mmu_page_cache;
+	else
+		*memcache = &vcpu->arch.pkvm_memcache;
+
+	if (!topup_memcache)
+		return 0;
+
+	min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
+
+	if (!is_protected_kvm_enabled())
+		return kvm_mmu_topup_memory_cache(*memcache, min_pages);
+
+	return topup_hyp_memcache(*memcache, min_pages);
+}
+
+/*
+ * Potentially reduce shadow S2 permissions to match the guest's own S2. For
+ * exec faults, we'd only reach this point if the guest actually allowed it (see
+ * kvm_s2_handle_perm_fault).
+ *
+ * Also encode the level of the original translation in the SW bits of the leaf
+ * entry as a proxy for the span of that translation. This will be retrieved on
+ * TLB invalidation from the guest and used to limit the invalidation scope if a
+ * TTL hint or a range isn't provided.
+ */
+static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
+				      enum kvm_pgtable_prot *prot,
+				      bool *writable)
+{
+	*writable &= kvm_s2_trans_writable(nested);
+	if (!kvm_s2_trans_readable(nested))
+		*prot &= ~KVM_PGTABLE_PROT_R;
+
+	*prot |= kvm_encode_nested_level(nested);
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  bool fault_is_perm)
 {
 	int ret = 0;
-	bool write_fault, writable, force_pte = false;
+	bool topup_memcache;
+	bool write_fault, writable;
 	bool exec_fault, mte_allowed;
 	bool device = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
@@ -1488,6 +1531,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
+	bool force_pte = logging_active;
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
@@ -1498,17 +1542,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
 	write_fault = kvm_is_write_fault(vcpu);
 	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
-	VM_BUG_ON(write_fault && exec_fault);
-
-	if (fault_is_perm && !write_fault && !exec_fault) {
-		kvm_err("Unexpected L2 read permission error\n");
-		return -EFAULT;
-	}
-
-	if (!is_protected_kvm_enabled())
-		memcache = &vcpu->arch.mmu_page_cache;
-	else
-		memcache = &vcpu->arch.pkvm_memcache;
+	VM_WARN_ON_ONCE(write_fault && exec_fault);
 
 	/*
 	 * Permission faults just need to update the existing leaf entry,
@@ -1516,17 +1550,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * only exception to this is when dirty logging is enabled at runtime
 	 * and a write fault needs to collapse a block entry into a table.
 	 */
-	if (!fault_is_perm || (logging_active && write_fault)) {
-		int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
-
-		if (!is_protected_kvm_enabled())
-			ret = kvm_mmu_topup_memory_cache(memcache, min_pages);
-		else
-			ret = topup_hyp_memcache(memcache, min_pages);
-
-		if (ret)
-			return ret;
-	}
+	topup_memcache = !fault_is_perm || (logging_active && write_fault);
+	ret = prepare_mmu_memcache(vcpu, topup_memcache, &memcache);
+	if (ret)
+		return ret;
 
 	/*
 	 * Let's check if we will get back a huge page backed by hugetlbfs, or
@@ -1540,16 +1567,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	/*
-	 * logging_active is guaranteed to never be true for VM_PFNMAP
-	 * memslots.
-	 */
-	if (logging_active) {
-		force_pte = true;
+	if (force_pte)
 		vma_shift = PAGE_SHIFT;
-	} else {
+	else
 		vma_shift = get_vma_page_shift(vma, hva);
-	}
 
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
@@ -1601,7 +1622,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			max_map_size = PAGE_SIZE;
 
 		force_pte = (max_map_size == PAGE_SIZE);
-		vma_pagesize = min(vma_pagesize, (long)max_map_size);
+		vma_pagesize = min_t(long, vma_pagesize, max_map_size);
 	}
 
 	/*
@@ -1630,7 +1651,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
 	 * with the smp_wmb() in kvm_mmu_invalidate_end().
 	 */
-	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
+	mmu_seq = kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
 	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
@@ -1665,24 +1686,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && device)
 		return -ENOEXEC;
 
-	/*
-	 * Potentially reduce shadow S2 permissions to match the guest's own
-	 * S2. For exec faults, we'd only reach this point if the guest
-	 * actually allowed it (see kvm_s2_handle_perm_fault).
-	 *
-	 * Also encode the level of the original translation in the SW bits
-	 * of the leaf entry as a proxy for the span of that translation.
-	 * This will be retrieved on TLB invalidation from the guest and
-	 * used to limit the invalidation scope if a TTL hint or a range
-	 * isn't provided.
-	 */
-	if (nested) {
-		writable &= kvm_s2_trans_writable(nested);
-		if (!kvm_s2_trans_readable(nested))
-			prot &= ~KVM_PGTABLE_PROT_R;
-
-		prot |= kvm_encode_nested_level(nested);
-	}
+	if (nested)
+		adjust_nested_fault_perms(nested, &prot, &writable);
 
 	kvm_fault_lock(kvm);
 	pgt = vcpu->arch.hw_mmu->pgt;
@@ -1953,6 +1958,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
+	VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
+			!write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
+
 	ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
 			     esr_fsc_is_permission_fault(esr));
 	if (ret == 0)
-- 
2.50.0.727.gbf7dc18ff4-goog


