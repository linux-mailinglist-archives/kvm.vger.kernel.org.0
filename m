Return-Path: <kvm+bounces-44951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C4093AA524E
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:58:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0D1B1C04192
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:58:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6697B21930B;
	Wed, 30 Apr 2025 16:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wyrmPnMA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF27E26D4DC
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 16:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746032241; cv=none; b=PsOZ73S9tmkD7aginskbgAbdYGh9pJHML4PhzPyY+r8amKJFYQjPypFyLTdt3VuKy3zWByuT9pPT4pljW+4PV9hr0FgdwDQ6KFiaM+A2oDAyfT48reiWKPoHVExcCv0ePwwSevt5k7ByrSyjnotZ3dQvzP8p9b4h7RYAWKFHmbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746032241; c=relaxed/simple;
	bh=Vl8tBENFg+CssuZIfH6YSyfeiVsOwoaYIe7y9tn/wZc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gaa6IDzgndlR1Kliq8wY7ypcJ41wuC4HLaLUZjjvNLZyfSx4gipZ66UrxH/5qIjYVc5dNU8aGcu66J81d4VybqYQa5S0XEY9fwYKUYMnZQ6tkqZ+JBu/qTQwXf0tYOOXFd1Ye1Yeo2j8D0TdVLzls28e811szAdGFdRdDar3Ojs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wyrmPnMA; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43cf3168b87so56905e9.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 09:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746032238; x=1746637038; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lT+w+gixt11vac0AKgWaA63BjBPb8gwiS7Jbs6OQuxA=;
        b=wyrmPnMA520etlPl+yeWWxQsIwDce29nKcvsqS+wrGHkbt/Iih02SY/7tJrhzdH7hV
         v8v5CCBjcErOOEkshvtnAgVXKQs8QnPHA6pb919Qs2IUqStZt4sb2nDMTY9dm4VqdGXg
         2/YI4gw4yxwYT1V651M6HFNZ9BvEVJ4a3R1pdrCy//a9mpoOspS91zChrrlhTSqQcy1G
         NmwZjHU6GVGbCBjrEIBgvR7pZkJm2e41u8vA2isKGLBFDTsG3sV+XpXv3QUI7ZO+dyKn
         lko5P2ZBkaiEXdT6NqUjppofQ20tP5hip9U6c2eoOiY4z7EwPjApSgfO7MFAX8rplB3r
         NlQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746032238; x=1746637038;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lT+w+gixt11vac0AKgWaA63BjBPb8gwiS7Jbs6OQuxA=;
        b=ODSWd6RGMibgnmGkY9GX6KAo/y8Bh3vRv6QlTTvZLadADPDDyK2TfV1VnLqIhwEpKT
         /h0ceJfOlZYjhqw+lTqXuEvMXkX3DSbsZHGNZIQGU3F9o72oIdh2KHuRLkGvxz2No+4K
         9QkhWjNRuo0MGFu1zBBBjoQhO31G/NcZ/Fb/NAiWt1uZk+IFIN+KwCUffXN56ogS0ug7
         I5f7L7AGl227rhtsazD2BK79Sr3Mi7tVysnAm7ZbybdC2Tu7zcUy8+DZrAgGf7z9fEYR
         2zmwOMgyQYc3mURDuqn7K4GP+xb3an5++8T+YyqUaXrdsHDL9X2hMzw5nh7+vizAM1+Y
         CPIg==
X-Gm-Message-State: AOJu0YyCs7nJwl1qMcd4Ddj47B4afaKMN0rmqCtm12ZXAivzg4AwTWe/
	B/h6QXeBWDzaACmThKUm6CyotDwvrGP/fciL3NlfaUrjLBLWoPFn01bIejMC4osafbmb9Kl95+A
	mtsWKYVB+OQmv8sG+bNG1+0Z3lqN+BJGShb6f025vKttKRwTaAhN2dZTrQIqMTAzriG2coxkGKq
	5aLsXrwJeEThf6FCtwNQShA6Q=
X-Google-Smtp-Source: AGHT+IEL5W88VW0xyg+gDyttDCBzFVHxw1cpBOysUXjegnCll+1R7oG7QBLoFSGBHg0tx6z/jBMX0Qc8Aw==
X-Received: from wmqe11.prod.google.com ([2002:a05:600c:4e4b:b0:43c:ebbe:4bce])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5246:b0:43d:49eb:963f
 with SMTP id 5b1f17b1804b1-441b1f5bdb0mr30320305e9.24.1746032237765; Wed, 30
 Apr 2025 09:57:17 -0700 (PDT)
Date: Wed, 30 Apr 2025 17:56:52 +0100
In-Reply-To: <20250430165655.605595-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250430165655.605595-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250430165655.605595-11-tabba@google.com>
Subject: [PATCH v8 10/13] KVM: arm64: Handle guest_memfd()-backed guest page faults
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
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
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Add arm64 support for handling guest page faults on guest_memfd
backed memslots.

For now, the fault granule is restricted to PAGE_SIZE.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c     | 65 +++++++++++++++++++++++++++-------------
 include/linux/kvm_host.h |  5 ++++
 virt/kvm/kvm_main.c      |  5 ----
 3 files changed, 50 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 148a97c129de..d1044c7f78bb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1466,6 +1466,30 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
+static kvm_pfn_t faultin_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+			     gfn_t gfn, bool write_fault, bool *writable,
+			     struct page **page, bool is_gmem)
+{
+	kvm_pfn_t pfn;
+	int ret;
+
+	if (!is_gmem)
+		return __kvm_faultin_pfn(slot, gfn, write_fault ? FOLL_WRITE : 0, writable, page);
+
+	*writable = false;
+
+	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, page, NULL);
+	if (!ret) {
+		*writable = !memslot_is_readonly(slot);
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
@@ -1473,19 +1497,20 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 {
 	int ret = 0;
 	bool write_fault, writable;
-	bool exec_fault, mte_allowed;
+	bool exec_fault, mte_allowed = false;
 	bool device = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
 	phys_addr_t ipa = fault_ipa;
 	struct kvm *kvm = vcpu->kvm;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma = NULL;
 	short vma_shift;
 	void *memcache;
-	gfn_t gfn;
+	gfn_t gfn = ipa >> PAGE_SHIFT;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
-	bool force_pte = logging_active || is_protected_kvm_enabled();
-	long vma_pagesize, fault_granule;
+	bool is_gmem = kvm_slot_has_gmem(memslot) && kvm_mem_from_gmem(kvm, gfn);
+	bool force_pte = logging_active || is_gmem || is_protected_kvm_enabled();
+	long vma_pagesize, fault_granule = PAGE_SIZE;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 	struct page *page;
@@ -1522,16 +1547,22 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
+	if (!is_gmem) {
+		vma = vma_lookup(current->mm, hva);
+		if (unlikely(!vma)) {
+			kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
+			mmap_read_unlock(current->mm);
+			return -EFAULT;
+		}
+
+		vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
+		mte_allowed = kvm_vma_mte_allowed(vma);
 	}
 
 	if (force_pte)
@@ -1602,18 +1633,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
@@ -1621,8 +1647,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
-	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
-				&writable, &page);
+	pfn = faultin_pfn(kvm, memslot, gfn, write_fault, &writable, &page, is_gmem);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f3af6bff3232..1b2e4e9a7802 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1882,6 +1882,11 @@ static inline int memslot_id(struct kvm *kvm, gfn_t gfn)
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
index c75d8e188eb7..d9bca5ba19dc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2640,11 +2640,6 @@ unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
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
2.49.0.901.g37484f566f-goog


