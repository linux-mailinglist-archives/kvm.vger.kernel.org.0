Return-Path: <kvm+bounces-22907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F09594475A
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:02:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 90551B23E18
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E2B5170A3C;
	Thu,  1 Aug 2024 09:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j6YfgY+O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A18170A31
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 09:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722502903; cv=none; b=mvplCL7QN9pa2Suei2GQelTVSzn4aoBkM9pqQdpntbA9AfpZsFHmiAR9XzgApha1CIHzvZ8PvgggTyPvtT0ASlns2Leq4lQIn9OGCEPxC1WrYGOYnyPQxG4McOHvBaO7nz7n42O0+RmMlCa44qItUlp1k+8Gs09I43aSaBR65Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722502903; c=relaxed/simple;
	bh=LiD8hVelwBpdklQy0FqdcvS85HI+0CpJq5EuMCPJOtQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ux+Q2kZ4HEemqaHNfuOYJH2dKCNAaehGmtKhKx7dbGLpFKrEdimwgqKhpOfGDu8J0ucez72cMTEvZKEiBPZIiaTNx3rjt/zpPzzQltBHqR1BoRSQerj8dAowz+KM5INHbAukG1UCKjoQYVUZix05xLsXPNCXVqFpYS0L2acB1GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j6YfgY+O; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e08bc29c584so9096445276.0
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 02:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722502901; x=1723107701; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hPkdSkcYKbc3+kSJZ/g9JVRtvGOqbhaBzYnzj0kRbFw=;
        b=j6YfgY+ObWuS6S0rH3S0aytYCYSmvRvbOUKasKxWpq+Z6nMgwyhMpU3sLPf+eahHTh
         dM7ukWqj5iHLDKnkWK17QLw6xukTwXEbSEIZrOhgQAVq4vPkFEHtpQLvhOuWxxVd6yiB
         0upjBUXY9+nZGX4a6FJNcqXtjuPpZetk5UHtRfEnnOmLBtpKNtYBv7Qj22mJBA1cwZFY
         CZm/4nw+5FLPiN/3qip+fU9Re3bbUVGFq3rStx/T8encc57BoZpDqMEChjh0DkSlc/KT
         eRGcXBGLyJSxhvnNZxLmqr2by0s2TLHghgAh/OT16mfG1UUPEd3tynVcBiXbRDVVQakv
         L79g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722502901; x=1723107701;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hPkdSkcYKbc3+kSJZ/g9JVRtvGOqbhaBzYnzj0kRbFw=;
        b=HkS45rcJ15bHJk5hZIzHZR/RfKpvceoee/EmaJp0m76J9ktqEDEg0UCGTGZ8MXNri6
         r+X7Whf9pN+FADMtW6PF/YYlaLebXraKQm1e1+6Afree3JKb3Yabqcq3xKHBlI7AwCxU
         IbmJnAXW1KRFwcILurIz6D+QDFqXAPE6o8ZrxEol5fJP+5T4J3MrGJBKd8lJfBEA+L8v
         xa5vbHDeCc/an0l22dhzgmEXsPLbvIyH3n0bbxw53hUxVAlCpvEODV+uQ2I+TNrb4xBG
         ZVEzk2pRk9K6OtS3LGOfq/jVH037tH0srKQIbMUbQNRKIbyRwDf6AWZY+1Xaah+5gjHg
         y1Fg==
X-Gm-Message-State: AOJu0YygWHi12hSrdVy8iA8okV0CBG21lcbSdW4y5MheU+UmAIRXxbE+
	q1veNbmlcZ9YJCzpzyYz8tRjR6P3jY9Ao0k6SX/Vf2AYkaZwOq5wuhM97vYEStLcdP8NtCjXq3s
	6vdqXyJLH+Vn1edrP27ssLujUK9IeF13loxXyNJGMPYYXl2UbjTpl+Fc5jGNjOQFun6cyxLyCxC
	rk6CmLr72yJHDgzH2bbAFEZFo=
X-Google-Smtp-Source: AGHT+IFLHM91ijuDJHLUo5+kzuJ4Oi83XUPKih8V/PqPhJPQ78pJ2Ei/0euF1MyM7UCy8SAtSIgxDnFcYw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:2190:b0:e05:f565:6bd3 with SMTP id
 3f1490d57ef6-e0bcd490586mr2277276.12.1722502900177; Thu, 01 Aug 2024 02:01:40
 -0700 (PDT)
Date: Thu,  1 Aug 2024 10:01:15 +0100
In-Reply-To: <20240801090117.3841080-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801090117.3841080-1-tabba@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801090117.3841080-9-tabba@google.com>
Subject: [RFC PATCH v2 08/10] KVM: arm64: Handle guest_memfd()-backed guest
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
	tabba@google.com
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
 arch/arm64/kvm/mmu.c | 127 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 125 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b1fc636fb670..e15167865cab 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1378,6 +1378,123 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
+static int guest_memfd_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+			     struct kvm_memory_slot *memslot, bool fault_is_perm)
+{
+	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
+	bool exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
+	bool logging_active = memslot_is_logging(memslot);
+	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
+	bool write_fault = kvm_is_write_fault(vcpu);
+	struct mm_struct *mm = current->mm;
+	gfn_t gfn = gpa_to_gfn(fault_ipa);
+	struct kvm *kvm = vcpu->kvm;
+	unsigned long mmu_seq;
+	struct page *page;
+	kvm_pfn_t pfn;
+	int ret;
+
+	/* For now, guest_memfd() only supports PAGE_SIZE granules. */
+	if (WARN_ON_ONCE(fault_is_perm &&
+			 kvm_vcpu_trap_get_perm_fault_granule(vcpu) != PAGE_SIZE)) {
+		return -EFAULT;
+	}
+
+	VM_BUG_ON(write_fault && exec_fault);
+
+	if (fault_is_perm && !write_fault && !exec_fault) {
+		kvm_err("Unexpected L2 read permission error\n");
+		return -EFAULT;
+	}
+
+	/*
+	 * Permission faults just need to update the existing leaf entry,
+	 * and so normally don't require allocations from the memcache. The
+	 * only exception to this is when dirty logging is enabled at runtime
+	 * and a write fault needs to collapse a block entry into a table.
+	 */
+	if (!fault_is_perm || (logging_active && write_fault)) {
+		ret = kvm_mmu_topup_memory_cache(memcache,
+						 kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * Read mmu_invalidate_seq so that KVM can detect if the results of
+	 * kvm_gmem_get_pfn_locked() become stale prior to acquiring
+	 * kvm->mmu_lock.
+	 */
+	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
+
+	/* To pair with the smp_wmb() in kvm_mmu_invalidate_end(). */
+	smp_rmb();
+
+	ret = kvm_gmem_get_pfn_locked(kvm, memslot, gfn, &pfn, NULL);
+	if (ret)
+		return ret;
+
+	page = pfn_to_page(pfn);
+
+	if (!kvm_gmem_is_mappable(kvm, gfn, gfn + 1) &&
+	    (page_mapped(page) || page_maybe_dma_pinned(page))) {
+		return -EPERM;
+	}
+
+	/*
+	 * Once it's faulted in, a guest_memfd() page will stay in memory.
+	 * Therefore, count it as locked.
+	 */
+	if (!fault_is_perm) {
+		ret = account_locked_vm(mm, 1, true);
+		if (ret)
+			goto unlock_page;
+	}
+
+	read_lock(&kvm->mmu_lock);
+	if (mmu_invalidate_retry(kvm, mmu_seq))
+		goto unlock_mmu;
+
+	if (write_fault)
+		prot |= KVM_PGTABLE_PROT_W;
+
+	if (exec_fault)
+		prot |= KVM_PGTABLE_PROT_X;
+
+	if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
+		prot |= KVM_PGTABLE_PROT_X;
+
+	/*
+	 * Under the premise of getting a FSC_PERM fault, we just need to relax
+	 * permissions.
+	 */
+	if (fault_is_perm)
+		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
+	else
+		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, PAGE_SIZE,
+					__pfn_to_phys(pfn), prot,
+					memcache,
+					KVM_PGTABLE_WALK_HANDLE_FAULT |
+					KVM_PGTABLE_WALK_SHARED);
+
+	/* Mark the page dirty only if the fault is handled successfully */
+	if (write_fault && !ret) {
+		kvm_set_pfn_dirty(pfn);
+		mark_page_dirty_in_slot(kvm, memslot, gfn);
+	}
+
+unlock_mmu:
+	read_unlock(&kvm->mmu_lock);
+
+	if (ret && !fault_is_perm)
+		account_locked_vm(mm, 1, false);
+unlock_page:
+	unlock_page(page);
+	put_page(page);
+	return ret != -EAGAIN ? ret : 0;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  bool fault_is_perm)
@@ -1748,8 +1865,14 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
-	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva,
-			     esr_fsc_is_permission_fault(esr));
+	if (kvm_slot_can_be_private(memslot)) {
+		ret = guest_memfd_abort(vcpu, fault_ipa, memslot,
+					esr_fsc_is_permission_fault(esr));
+	} else {
+		ret = user_mem_abort(vcpu, fault_ipa, memslot, hva,
+				     esr_fsc_is_permission_fault(esr));
+	}
+
 	if (ret == 0)
 		ret = 1;
 out:
-- 
2.46.0.rc1.232.g9752f9e123-goog


