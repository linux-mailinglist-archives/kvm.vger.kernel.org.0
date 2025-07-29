Return-Path: <kvm+bounces-53697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D491B15598
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 01:01:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35FAF5614FF
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 23:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDA4A285CAD;
	Tue, 29 Jul 2025 22:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dvT2kZAq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFCA2D0C7D
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 22:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829763; cv=none; b=RjVI2xal/sc058nTubMaL1geFfMPSFTRlZ9INiqt+JHuFBITCwJXVSqkkmbN/3RcYqiuf4SM1UDoFwicHuoFzWys8Fqr/hHf5srxFo10S09WmInV4ewuCuyHduiIOedUcj7aPGH8pw+htVmZGG8VUhaplTNcNJTqOihZz/cD5S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829763; c=relaxed/simple;
	bh=kMDmA+FG6ConD8UhQV5WOQHI9aTXrPVBhfPBTnguW5g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PIpr9f4U7QlN3bMe864nUTWgd2ehmc/v/JE4v3x7w1DKOxf5okydv3GUTjaj58dXMi03xWnJIPLZv2X1XDkQrNcFCFDEujKSjravwNwrbfvq8FvNw4BMHjmtxpdjoDycciz43zgM3yBMP0h5bpniZuW51YwBjIFX6C4MdIjwzKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dvT2kZAq; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31f030b1cb9so3516711a91.2
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829761; x=1754434561; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9E18DKY/G18mWPE1Fxb2wsnRqrbifqrGkcC2nrnl8ek=;
        b=dvT2kZAqClmTk1ouQvLUBqri6/N5TYKRMmn1olNRE/LNwO8O8sMIQQw2nqUyll0g70
         OMHBk5qqKuN52tkWma+njWLXDzUowqSTqrdQqFtkP7eMajfQPIThDgW23KaS3xzwIZSQ
         dTi2fV8mI38VxMgTA/+GIldifs/RUccjugUmFakx2IeQpyQcVkBuS8+ObMisq+364NPN
         idWFleOEnZCfz/Nie9AYPR5xtF4zBEeMotSEnwE0X/7gJf+K6b8rTtr2qzH7b+6lNUzE
         nOhW3kimpCd1c4E96d39D49jw4PE0CxUqpQfNgUO8AKU9cl5mTRM7H2pNZ6m4z5ext0/
         Ry1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829761; x=1754434561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9E18DKY/G18mWPE1Fxb2wsnRqrbifqrGkcC2nrnl8ek=;
        b=Nqof6/kDHn0nmdyVY2sKwXkruKkEkY1yEiueYQnfX1nsP0CmikD45QF77rju7KvY02
         jKKuz45WKyVtlPkB/cHXveN5NMPSgBGIzOz9fqK+8NBokq9nCFtr79IjSO38rxFYjSHX
         gG0ljkoYZ8rdTwQsvmoymeaZTO9GxNT/EXC6Ik3wLM9uhQKKKOylGBy/abInPH8QtJau
         IBSYjm66CmPWAmv38KNuAS/C8/2K2opoxHEjZA+ebSBbSOpsru94LYe3KWQ3n0kcqSD3
         mDBRBBHuU+GQpJ6ZFlvJCkgVB3CaJj0OGao2uIFKm3mIbMZpzxezaJISa4/nyiXw3JVF
         m5qw==
X-Gm-Message-State: AOJu0YzGe7Qtd5++8/NFHhcLJWdT8BxA1mkZivTMPLM27ZONvU4VFVV7
	7wjV1T14AOjQF5PhVkskwrKi5kePpGzj1c4LbIRLi/ybQ7CZDDV08r/44s6ZQX0G/FOqM5XrtVL
	vlmm43A==
X-Google-Smtp-Source: AGHT+IE4O+5r1Bj4imyiC5NVlC5VwKdSM9hzQfIhpz6ILXXSPMHlU6GLNlEXApn3rj14vHhFjYMBynqj0Zo=
X-Received: from pjnx20.prod.google.com ([2002:a17:90a:8a94:b0:31e:e0b7:befe])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:380a:b0:31e:f3b7:49d2
 with SMTP id 98e67ed59e1d1-31f5dca3b8dmr1883753a91.0.1753829760838; Tue, 29
 Jul 2025 15:56:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:48 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-18-seanjc@google.com>
Subject: [PATCH v17 17/24] KVM: arm64: Refactor user_mem_abort()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Fuad Tabba <tabba@google.com>

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
Reviewed-by: Tao Chan <chentao@kylinos.cn>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
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
2.50.1.552.g942d659e1b-goog


