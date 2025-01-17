Return-Path: <kvm+bounces-35821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B416BA1545C
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:31:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB0AD167412
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2EBD1A3035;
	Fri, 17 Jan 2025 16:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KNv8+ITt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D841A2630
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737131436; cv=none; b=BMp2YQaKAK8MbeBwKeZz6IvwsEiqtSk+gjs1AOH24iemlHOY+cb2NaFR0KloHN1/vRJ+CViozh0a/6W9Vx1yg6jZLXkm98WTqf/Wz6EIG9E1l7MTFq+hVUqi4IwGhaayoDSJFa0FGXimHriBAzRKtYWBNFbdy2FjK3szvh0M6RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737131436; c=relaxed/simple;
	bh=9ScwQd0bP161opBWqaR/+8J29MPrYsFVLQs2y0zPW3c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=isQNueCsWmzn6PxP0+Ds8YGn4mgD6JqjiaEaGD5kZBknXjDSMt0Xn2pRnCbqFRvKsdBZ2FdJHEbuxz2tm9MovEy79mg3WJZ2TpNSF65+Wa+zZXJAQ9MwbLu6ShAAP87vLA256PYVER9ga9IE96aciEcs8z5ABvL9bd1n+rsBAyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KNv8+ITt; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43624b08181so12024655e9.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 08:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737131433; x=1737736233; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XhTbcufgZ8AmBiYfbJkpLsBTfzEQgi+lO4KPsoUjlS0=;
        b=KNv8+ITtIlnro+/qkrkeRQ+8Z4TVuqE8vNqlk3R1HgM5pBusbyUmYKl9re+mNZHc99
         a9QMihRTlVkHr74r8O3jVCi3eP8+4dbUh7eFjpKBhEc9b9s5ivCdl4zUiZQlNtC5dhWk
         eZiGTqdQUE9jZCX0jCRvpCNrAYphf2TTXGWj+Wz3JdxWcpsjWW0PfzY162S+8x5TZriR
         jcldm/H2SFubQ6G0Yvb/1H7ujElKn6/O8FFICI8dM2wZVJVdQU/3cFSi9l0PEEHJRWql
         n521uUmuhBuFcLNjWVwZfa6CDX1Kz7CpyKK2wdc14MxzXkeX7cZQsz0TLpwWB9Q1UsfQ
         xwog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737131433; x=1737736233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XhTbcufgZ8AmBiYfbJkpLsBTfzEQgi+lO4KPsoUjlS0=;
        b=dRfCL18TyGcog0pS8iJP/Grdy6OiWbyh7RxNrgokSPdGMF1N0oeGf+/OLbZApHTaK4
         Dv4vxIzZFhzOHvvENrG/ws05MNiELdqqvIbupK0mgZu9kurOzqP9Iudt6COZQir7GiB2
         GtqiQ92n4tgho4XDeQR/LQpDFiJYKM2lPV/0TfLocjMGYlTrugo38b180iqzy/jy01gE
         LuhSlgDN+DIM9e/Az1gnka6MB6mtnjzwLdQPEH4HUn/Sxj42btjPPZ3/0MuVTrckI+qh
         9WvFd53WFSL3gEVV2GKHpoN0rqrNpfrXIPnqKtJhhA/SgNFRB3HHm8yyY9FDeuoVh0iH
         UqPg==
X-Gm-Message-State: AOJu0YxhNTISAmOsZcW/mO/W2DvzWEHcOZHo7NdMyWXwHVBw9Usd7hlD
	Bw/1ExmYaLIZRfZs1/uVPWSzhQY0JEQMxAlUhZ/fdSLJHYu9Flh4DSsfdMgLU+2w4WvW4cRD987
	EB1HyFfF9mTtMGSDCC7zAFqJ27VAUlVb4iwEPL4Y+wyQkEzm2HjK/cuxlj0s0hW7wush1oqVa7T
	ZPjjy39awmRXn5yNfauJXn4NI=
X-Google-Smtp-Source: AGHT+IFPdHeUQIAQ3HgrviyPTwLb4E9cZejUsbEzIa0xJyMDU0HG5sEo7q/ik0GAG7K45x/YUf7mmw9Knw==
X-Received: from wmgg9.prod.google.com ([2002:a05:600d:9:b0:434:feb1:add1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:698c:b0:434:f9ad:7222
 with SMTP id 5b1f17b1804b1-438918d3bdcmr32291175e9.7.1737131433509; Fri, 17
 Jan 2025 08:30:33 -0800 (PST)
Date: Fri, 17 Jan 2025 16:30:00 +0000
In-Reply-To: <20250117163001.2326672-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117163001.2326672-1-tabba@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117163001.2326672-15-tabba@google.com>
Subject: [RFC PATCH v5 14/15] KVM: arm64: Handle guest_memfd()-backed guest
 page faults
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Add arm64 support for resolving guest page faults on
guest_memfd() backed memslots. This support is not contingent on
pKVM, or other confidential computing support, and works in both
VHE and nVHE modes.

Without confidential computing, this support is useful for
testing and debugging. In the future, it might also be useful
should a user want to use guest_memfd() for all code, whether
it's for a protected guest or not.

For now, the fault granule is restricted to PAGE_SIZE.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c     | 86 ++++++++++++++++++++++++++++------------
 include/linux/kvm_host.h |  5 +++
 virt/kvm/kvm_main.c      |  5 ---
 3 files changed, 66 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9b1921c1a1a0..adf23618e2a0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1434,6 +1434,39 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
+static kvm_pfn_t faultin_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+			     gfn_t gfn, bool write_fault, bool *writable,
+			     struct page **page, bool is_private)
+{
+	kvm_pfn_t pfn;
+	int ret;
+
+	if (!is_private)
+		return __kvm_faultin_pfn(slot, gfn, write_fault ? FOLL_WRITE : 0, writable, page);
+
+	*writable = false;
+
+	if (WARN_ON_ONCE(write_fault && memslot_is_readonly(slot)))
+		return KVM_PFN_ERR_NOSLOT_MASK;
+
+	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, page, NULL);
+	if (!ret) {
+		*writable = write_fault;
+		return pfn;
+	}
+
+	if (ret == -EHWPOISON)
+		return KVM_PFN_ERR_HWPOISON;
+
+	return KVM_PFN_ERR_NOSLOT_MASK;
+}
+
+static bool is_private_mem(struct kvm *kvm, struct kvm_memory_slot *memslot, phys_addr_t ipa)
+{
+	return kvm_arch_has_private_mem(kvm) && kvm_slot_can_be_private(memslot) &&
+	       (kvm_mem_is_private(kvm, ipa >> PAGE_SHIFT) || !memslot->userspace_addr);
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1441,24 +1474,25 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 {
 	int ret = 0;
 	bool write_fault, writable;
-	bool exec_fault, mte_allowed;
+	bool exec_fault, mte_allowed = false;
 	bool device = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
 	phys_addr_t ipa = fault_ipa;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma = NULL;
 	short vma_shift;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
-	bool force_pte = logging_active;
-	long vma_pagesize, fault_granule;
+	bool is_private = is_private_mem(kvm, memslot, fault_ipa);
+	bool force_pte = logging_active || is_private;
+	long vma_pagesize, fault_granule = PAGE_SIZE;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 	struct page *page;
 
-	if (fault_is_perm)
+	if (fault_is_perm && !is_private)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
 	write_fault = kvm_is_write_fault(vcpu);
 	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
@@ -1482,24 +1516,30 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			return ret;
 	}
 
+	mmap_read_lock(current->mm);
+
 	/*
 	 * Let's check if we will get back a huge page backed by hugetlbfs, or
 	 * get block mapping for device MMIO region.
 	 */
-	mmap_read_lock(current->mm);
-	vma = vma_lookup(current->mm, hva);
-	if (unlikely(!vma)) {
-		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
-		mmap_read_unlock(current->mm);
-		return -EFAULT;
-	}
+	if (!is_private) {
+		vma = vma_lookup(current->mm, hva);
+		if (unlikely(!vma)) {
+			kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
+			mmap_read_unlock(current->mm);
+			return -EFAULT;
+		}
 
-	/*
-	 * logging_active is guaranteed to never be true for VM_PFNMAP
-	 * memslots.
-	 */
-	if (WARN_ON_ONCE(logging_active && (vma->vm_flags & VM_PFNMAP)))
-		return -EFAULT;
+		/*
+		 * logging_active is guaranteed to never be true for VM_PFNMAP
+		 * memslots.
+		 */
+		if (WARN_ON_ONCE(logging_active && (vma->vm_flags & VM_PFNMAP)))
+			return -EFAULT;
+
+		vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
+		mte_allowed = kvm_vma_mte_allowed(vma);
+	}
 
 	if (force_pte)
 		vma_shift = PAGE_SHIFT;
@@ -1570,17 +1610,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	gfn = ipa >> PAGE_SHIFT;
-	mte_allowed = kvm_vma_mte_allowed(vma);
-
-	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
 
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
 
 	/*
 	 * Read mmu_invalidate_seq so that KVM can detect if the results of
-	 * vma_lookup() or __kvm_faultin_pfn() become stale prior to
-	 * acquiring kvm->mmu_lock.
+	 * vma_lookup() or faultin_pfn() become stale prior to acquiring
+	 * kvm->mmu_lock.
 	 *
 	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
 	 * with the smp_wmb() in kvm_mmu_invalidate_end().
@@ -1588,8 +1625,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
-	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
-				&writable, &page);
+	pfn = faultin_pfn(kvm, memslot, gfn, write_fault, &writable, &page, is_private);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 63e6d6dd98b3..76ebd496feda 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1853,6 +1853,11 @@ static inline int memslot_id(struct kvm *kvm, gfn_t gfn)
 	return gfn_to_memslot(kvm, gfn)->id;
 }
 
+static inline bool memslot_is_readonly(const struct kvm_memory_slot *slot)
+{
+	return slot->flags & KVM_MEM_READONLY;
+}
+
 static inline gfn_t
 hva_to_gfn_memslot(unsigned long hva, struct kvm_memory_slot *slot)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0d1c2e95e771..1fdfa8c89c04 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2622,11 +2622,6 @@ unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
 	return size;
 }
 
-static bool memslot_is_readonly(const struct kvm_memory_slot *slot)
-{
-	return slot->flags & KVM_MEM_READONLY;
-}
-
 static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slot, gfn_t gfn,
 				       gfn_t *nr_pages, bool write)
 {
-- 
2.48.0.rc2.279.g1de40edade-goog


