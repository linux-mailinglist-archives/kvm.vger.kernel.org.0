Return-Path: <kvm+bounces-46367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71939AB5A20
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 18:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9548172EBB
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 16:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 554562C0847;
	Tue, 13 May 2025 16:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VeNnfsKh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7EF2C032F
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 16:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747154110; cv=none; b=Ao3PnV+g5ItyGmUzW74bFtGMGlweSakKCYZPHQzRprCY6iGdbXrMCYfqOtTiifogEgtX71G4hqYDM6IuZf6EKFPO7bGBeY5nq3zv4n0+NXG5r41JglYDfVSsZv6lEfRTsjHiIMZfYLHJV6LoVRbmioTB+BmS74GOtN9pl/4aTsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747154110; c=relaxed/simple;
	bh=MbDGTurddBrN8KJrNyuUpxF5IoxP5LGeg+N7SFaEsKg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gfo2P7As6BFSBDkU/bVkjqkiZQON6Uosz5tDZ9kUX4OaE5PVM09LKRFad4oQxh9ht7t1rdmkvEyla+FowhYOI9b1k1dMh13Qa3G/+7bIFbxI7tTpqkwdECxq2e1TwDDmgA1UflnPrUCEAfX2qCtisdPD6ZBuk1u3qeT8nqOR+ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VeNnfsKh; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-442dc6f0138so16259315e9.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747154107; x=1747758907; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=coGP02xhdF4QsTZqgpjGtEC02QuEoL67kyEmXDEzHl0=;
        b=VeNnfsKhcy/SmMF9uJ2lDHPKUQB+rDov3PINTggAEz27nFoZ3QadcTKFtG6TPZ3Pl+
         NQln5Sbesjka0o72Gewrtk+TuO3Oh8NnBjJoHPYkK24rXDJKn2dN4LCmEpPDLI7SMDjW
         ky3H2Pb5teA45vhLsJLf2cIOoqMPWXKcsIPyB15vzjy7W08iuvTLP7KnaXPjzhsUuIVd
         y/4JxTE4VF86MCwHm5yfr8xdCzUxHH1fq9eZdJnqvxFAETe+I1mhaTq2SB+gIKFs0qHY
         EDijBcyzc94bzjSlZBXQQGNEj773isCNDVrhr/QgT/3YdpAU8TvX3MVjz/AMyZPhFskI
         tmXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747154107; x=1747758907;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=coGP02xhdF4QsTZqgpjGtEC02QuEoL67kyEmXDEzHl0=;
        b=nvdBxeuCRhrHv5hXk1MtV/KDrvJCAo0YE4L4beyCqlKtm5j0Pihz1Ud1doful+6QxU
         kIm4QPzua33EHo5KoggJIhpIwQYAWSUqDZbJ2ddnAuQvuhX50DIFvNrwRBkOCTxonCC7
         h4KRDsHwWvad1i0n65mcloKxbo7zQsx8yC05u597wezl/eAdWHMvqqgPG7IK2v+kQ8Ng
         qP6oVtosLggz2tp2WtCkyQQV/r689bNg99lzJ/WII0qgp5i44ScdNJ976e13bPs0tEcv
         hT4k0el24HunGNZ1G36Js4UQ20nkUOzOWPs9wv7e7ytCWS7ntgDMUOw8+kS/WfY2VYTq
         1jcg==
X-Gm-Message-State: AOJu0YwkMxEtZlUMNEiYFR68RmbsyVGCnaJOaLUUO6mjjliWXcXsWhh5
	YWLiBveM5Rj5W+PSTnaZd4o/BhPUPxcz2qgU8oIvQvIxud3wShK2ZFIdm+p6ysv4RctgK0QV+s1
	br37gK2gSn4uJAO0OVEw1Q+TniQpl0viVELByYXgLseGf48wKfzgRXcPI4SMCxZssF6UQfwwFQT
	9DV6zWftgtc/OUzzA/LXUx6mY=
X-Google-Smtp-Source: AGHT+IEjjYEXEYlvWFF5OLq9cklfBFuKA7pxlcIDeCLfcHXQdKGj5SSIieh7nJvEEf5f7+rXBSzijM2YeA==
X-Received: from wmsd3.prod.google.com ([2002:a05:600c:3ac3:b0:442:dc9b:b569])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5118:b0:43d:cc9:b09d
 with SMTP id 5b1f17b1804b1-442d6dc539cmr116558185e9.20.1747154106776; Tue, 13
 May 2025 09:35:06 -0700 (PDT)
Date: Tue, 13 May 2025 17:34:34 +0100
In-Reply-To: <20250513163438.3942405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <20250513163438.3942405-14-tabba@google.com>
Subject: [PATCH v9 13/17] KVM: arm64: Handle guest_memfd()-backed guest page faults
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
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Add arm64 support for handling guest page faults on guest_memfd
backed memslots.

For now, the fault granule is restricted to PAGE_SIZE.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c     | 94 +++++++++++++++++++++++++---------------
 include/linux/kvm_host.h |  5 +++
 virt/kvm/kvm_main.c      |  5 ---
 3 files changed, 64 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d756c2b5913f..9a48ef08491d 100644
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
-	short page_shift;
+	struct vm_area_struct *vma = NULL;
+	short page_shift = PAGE_SHIFT;
 	void *memcache;
-	gfn_t gfn;
+	gfn_t gfn = ipa >> PAGE_SHIFT;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
-	bool force_pte = logging_active || is_protected_kvm_enabled();
-	long page_size, fault_granule;
+	bool is_gmem = kvm_slot_has_gmem(memslot);
+	bool force_pte = logging_active || is_gmem || is_protected_kvm_enabled();
+	long page_size, fault_granule = PAGE_SIZE;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 	struct page *page;
@@ -1529,17 +1554,20 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
+		mmap_read_lock(current->mm);
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
 
-	if (force_pte)
-		page_shift = PAGE_SHIFT;
-	else
+	if (!force_pte)
 		page_shift = get_vma_page_shift(vma, hva);
 
 	switch (page_shift) {
@@ -1605,27 +1633,23 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		ipa &= ~(page_size - 1);
 	}
 
-	gfn = ipa >> PAGE_SHIFT;
-	mte_allowed = kvm_vma_mte_allowed(vma);
-
-	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
-
-	/* Don't use the VMA after the unlock -- it may have vanished */
-	vma = NULL;
+	if (!is_gmem) {
+		/* Don't use the VMA after the unlock -- it may have vanished */
+		vma = NULL;
 
-	/*
-	 * Read mmu_invalidate_seq so that KVM can detect if the results of
-	 * vma_lookup() or __kvm_faultin_pfn() become stale prior to
-	 * acquiring kvm->mmu_lock.
-	 *
-	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
-	 * with the smp_wmb() in kvm_mmu_invalidate_end().
-	 */
-	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
-	mmap_read_unlock(current->mm);
+		/*
+		 * Read mmu_invalidate_seq so that KVM can detect if the results
+		 * of vma_lookup() or faultin_pfn() become stale prior to
+		 * acquiring kvm->mmu_lock.
+		 *
+		 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which
+		 * pairs with the smp_wmb() in kvm_mmu_invalidate_end().
+		 */
+		mmu_seq = vcpu->kvm->mmu_invalidate_seq;
+		mmap_read_unlock(current->mm);
+	}
 
-	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
-				&writable, &page);
+	pfn = faultin_pfn(kvm, memslot, gfn, write_fault, &writable, &page, is_gmem);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, page_shift);
 		return 0;
@@ -1677,7 +1701,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	kvm_fault_lock(kvm);
 	pgt = vcpu->arch.hw_mmu->pgt;
-	if (mmu_invalidate_retry(kvm, mmu_seq)) {
+	if (!is_gmem && mmu_invalidate_retry(kvm, mmu_seq)) {
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f9bb025327c3..b317392453a5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1884,6 +1884,11 @@ static inline int memslot_id(struct kvm *kvm, gfn_t gfn)
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
index 6289ea1685dd..6261d8638cd2 100644
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
2.49.0.1045.g170613ef41-goog


