Return-Path: <kvm+bounces-36877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A0F8A222D3
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 18:24:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC1E51883B6A
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 17:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43E691E25FE;
	Wed, 29 Jan 2025 17:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GQUd2O2m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871291E231D
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 17:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738171423; cv=none; b=fszmHy/DUpwCXnqLcKSKqbA4ZaZ0T3OWVXFVSnzoytLySTHJpNsPNBsrRx3/ZaZRUxxSV1SapGmU8zkQ6hGS/AMWggZZgR94JwvanhI1FSbgjnr02b/KQG3oWVrFP7qrz8zHwI7IsicrZHh0cJ7nLsqhMTFkqfy/HUbZugvDRjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738171423; c=relaxed/simple;
	bh=n3JRGftdE7xuh9J8pm8BC9fK31LMHdkQa4vKMTD2NnU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kAk/YteV5pFSFd/uHiAtN74pTKXDVrHbUrBKLrA4wp5CYskHilEp/sue/hw9hxMaLaBUb1c0XVQZAT83zB7hsAk5Qzkgq7lIw+lTZvRpo9uLIWP6VjRXX/QAEiFnmfzOE4gp7deTYaHk4PVha/UxCvZHmU2OUgndRVmIRFenBxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GQUd2O2m; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-385ded5e92aso2932466f8f.3
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 09:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738171420; x=1738776220; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gJUlshLqVqxF/x1Q6yciZ2xZ0kPW08W616puHCRAMyA=;
        b=GQUd2O2mBsj+urYK+gCpaT1jKJM5ngBRQ08XV/8WNC1JXAdUUiukXD5j/u37FBRbVz
         fbSutEJR2beiQUF2rrQU0dYzH2GuvLJz0tLI26tpIfsK5ZkJGIC2M3Mabv/LOgj8usIc
         bkopMHd5OOQknJ8vE+oZAl1DT6N+V7OQi+9rJEO8tUXqxsIuUhISWB01MTECtvqWpPTz
         lmPsYR2hGX0iA8vszfpbTi3DJHqfEdFFjrHHscWpOAlDN7zPlFXhjwrOF5XjdOlVwUnu
         GCpTTo7ZHvk2XZIxvWECepoHx0K53Nqrvk09mjRe+cmS2Iah5xk7LMviWtxiQ6APniPF
         /4lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738171420; x=1738776220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gJUlshLqVqxF/x1Q6yciZ2xZ0kPW08W616puHCRAMyA=;
        b=qEI3j+KEYGnGuEI46op8Xbq6/vLnSSJFVoRjp8mKo3/sOs5vwSW7gsm8FBSLbPrXpL
         GP/0X2N2nhmV3MjDvBfV7cWIDPKWa5MvAwEKRFBbubxoMsBV4bjBXi9WuRvgUt2MJzQt
         m8cJHonOsy8IPTWOVaVHq0erWqEnteVXQT5NhZl/E3YcaF+IKg4Ceq9uX99OlODjBg2R
         xvsTU+Wb8ipKpbBmOZ55Yy8VV5HjVYDHFXsQ3JXAPmCqQ361XtjPsb1V6GCe/nUzsCNK
         5yMpG2GBXRfR8yDSrUqkhEBF/W4yv+QEWX3W1ZSq5VV5HtE+QkmziqmfOJpJmOoKprUe
         NntA==
X-Gm-Message-State: AOJu0YyeAS4Q8ZigBeJKsHyrD6H95DifYl+nPjLQFVlFaxWb+jIWZIAZ
	mqiu2q74CGRUsHp6m20abm9inlMfBsBUgtRz2Fu1yupqBh31Tl6PoVgOi7AFyihbNkpvuPWE9s+
	4PMD5s0JgP4a1bHL7IgqqKwGV4I1sv0cUJI78AX05KyBp/dOXYkg8UkJ0wY74PBGUYEiE5HFLy0
	JFwWbPTc2hJuiXEvKC6OwVELA=
X-Google-Smtp-Source: AGHT+IFusRcrVc4/78hZx6Io2rOdbnPNNEy+1FtewyjP5IWPByZvcuY2dAJE2DcSV4SFz55Z5sZ6LOwVmQ==
X-Received: from wmgg8.prod.google.com ([2002:a05:600d:8:b0:436:e67f:5b4c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:adf:fa11:0:b0:385:e8aa:2a4e
 with SMTP id ffacd0b85a97d-38c51b87e3fmr2896212f8f.31.1738171419742; Wed, 29
 Jan 2025 09:23:39 -0800 (PST)
Date: Wed, 29 Jan 2025 17:23:17 +0000
In-Reply-To: <20250129172320.950523-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250129172320.950523-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250129172320.950523-9-tabba@google.com>
Subject: [RFC PATCH v2 08/11] KVM: arm64: Handle guest_memfd()-backed guest
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

Add arm64 support for handling guest page faults on guest_memfd
backed memslots.

For now, the fault granule is restricted to PAGE_SIZE.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c     | 84 ++++++++++++++++++++++++++--------------
 include/linux/kvm_host.h |  5 +++
 virt/kvm/kvm_main.c      |  5 ---
 3 files changed, 61 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1ec362d0d093..c1f3ddb88cb9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1430,6 +1430,33 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
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
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1437,24 +1464,25 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
-	gfn_t gfn;
+	gfn_t gfn = ipa >> PAGE_SHIFT;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
-	bool force_pte = logging_active;
-	long vma_pagesize, fault_granule;
+	bool is_private = kvm_mem_is_private(kvm, gfn);
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
@@ -1478,24 +1506,30 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
@@ -1565,18 +1599,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		ipa &= ~(vma_pagesize - 1);
 	}
 
-	gfn = ipa >> PAGE_SHIFT;
-	mte_allowed = kvm_vma_mte_allowed(vma);
-
-	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
-
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
@@ -1584,8 +1613,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
-	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
-				&writable, &page);
+	pfn = faultin_pfn(kvm, memslot, gfn, write_fault, &writable, &page, is_private);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e57cdf4e3f3f..42397fc4a1fb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1864,6 +1864,11 @@ static inline int memslot_id(struct kvm *kvm, gfn_t gfn)
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
index 40e4ed512923..9f913a7fc44b 100644
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
2.48.1.262.g85cc9f2d1e-goog


