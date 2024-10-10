Return-Path: <kvm+bounces-28403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43A9E99816F
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 11:04:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88496B24A4E
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 09:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD98B1BD00B;
	Thu, 10 Oct 2024 09:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kgPD3mGj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348C91C7B64
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 09:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728550801; cv=none; b=gZcH0tUPdSRivNMuVFq9Q551TpAr+1/7wiqJ+MzOgDp/PAtfunBxezAjzGJbhHbA3Yd5H9NbqQCKqNMaKbtsk7jQflaadgV+CO1YuQZUbeU2S5nKdCdaDpoMwnrnPdn1Xlq7fCbuPofPwpJSXoWdstqPR8F5Hw53xDoKFbEFljw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728550801; c=relaxed/simple;
	bh=1gESkYZeE8gsJM6vDvXoaGAzOqHt08IYuPYjQygM1g0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n/4gJllXu4u2YMAe+XIl06Jd8m0vNi1gV2IR1/oir3qvHAXcmeqyIghvYd4ycWJvaZKr1Jk6/eek2cI9sxVjqn4JMIKiqtFp7FsqM+7+1YDS4hyY2XOAQJT1Co1qQs4BDxLEyMeP4pxQRB6w4qvMb0t+a5V1k0LzkdeFS6HTKlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kgPD3mGj; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-37d3878ddcdso249327f8f.3
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 01:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728550798; x=1729155598; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=exyGShkIuMmlgn/y2fH9jdue3XxSmqPMQZyWZJ9IIOc=;
        b=kgPD3mGjVy7Wqfk4v3Hj2vJH5+b7kXzkZ9yFIndNp9yhGyvOuyKlMkjBUkqq6h1QGd
         eND+2tbG+99eQcJWwyF8GRVLz3BzDnV517ImZRAzeN8U9+scVQwvMyuGpf+mW91X8NlF
         XK1Yn/YkYN4IxG/+YvN0lMBceI2PbfOR66h84ITOTkwclFBUeR/O3G/ssMGHkNV5b7vT
         6OY8uTSh5EVTi3PKjErBtScGA//Td/g2tYMhyrYA0kSClSm10C92XZfd0pVy1xtJg0qC
         +RkXjDQGQaWiVI9DpJZ+Ur1Vd5tr134qO40okZLCfGcNkY0kzeVJTgcs4vYSwE/SiwzP
         lirA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728550798; x=1729155598;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=exyGShkIuMmlgn/y2fH9jdue3XxSmqPMQZyWZJ9IIOc=;
        b=lYdZsKQryT1s1+meWjvgQOjn/yBb+QGdbvQZAsMMgHd/Gp4GhuL8k9psztU7piYA1k
         UXXt8EVNML4Zs/TDpSFNwBVyCvHK8GCXKWTCSwyzir5K3kT7ZzSkczNcfuPsrwjVSYr9
         JWyqhPPj+zAl0ON2L9CzAV8DIEezPw03Yncss9ieGegy9pb0S8hJ6Dzj01YSha90JKju
         A9WOl32xfIRtmLb9MCYWdBwBdOhsu9tpLsYolbyYPRpjfzYd4GHOU6GSCl4nfWm+r0iS
         OqVGKsGDWS5PtXVzFKzL5B9N/QBRmCbYEvlQTaxWXqa5B+hIraYEZjbI8c9GlMhpr1r9
         A3WA==
X-Gm-Message-State: AOJu0Yxzz+ZmsTfAZEl5+u4HQNl24nFnfIIyESlu7ksdgvUd5mu/kQi4
	5zBFVOA03ud6LssJ0ZnHItly1Rk/eWJCu81hDaTVTVMRp/0C3znfiV/x56XSN5Oq8QZhuRUuFUB
	BqhvPn4cHXDyOAk+yy59FZEV1+bR7ag+CPY0xZoDv3w2A5J98iPUxhyitzcs3Ek7RToA27AzcQx
	iZ13+bfxbiEEx7TcVEMyAZe+A=
X-Google-Smtp-Source: AGHT+IE3WukKHOq7Bmp4xhzc8OQfh5cP/L7vmCsDLrA8EMFDPkbOy1WECbzZ6HHl8nL5SydVZHebiozHSw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:1091:b0:37d:4d36:e178 with SMTP id
 ffacd0b85a97d-37d4d36e297mr456f8f.7.1728550798081; Thu, 10 Oct 2024 01:59:58
 -0700 (PDT)
Date: Thu, 10 Oct 2024 09:59:29 +0100
In-Reply-To: <20241010085930.1546800-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010085930.1546800-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241010085930.1546800-11-tabba@google.com>
Subject: [PATCH v3 10/11] KVM: arm64: Handle guest_memfd()-backed guest page faults
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
 arch/arm64/kvm/mmu.c | 112 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 110 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 71ceea661701..250c59f0ca5b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1422,6 +1422,108 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
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
+	 * Holds the folio lock until mapped in the guest and its refcount is
+	 * stable, to avoid races with paths that check if the folio is mapped
+	 * by the host.
+	 */
+	ret = kvm_gmem_get_pfn_locked(kvm, memslot, gfn, &pfn, NULL);
+	if (ret)
+		return ret;
+
+	page = pfn_to_page(pfn);
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
+	read_unlock(&kvm->mmu_lock);
+
+	if (ret && !fault_is_perm)
+		account_locked_vm(mm, 1, false);
+unlock_page:
+	put_page(page);
+	unlock_page(page);
+
+	return ret != -EAGAIN ? ret : 0;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1893,8 +1995,14 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
-	ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
-			     esr_fsc_is_permission_fault(esr));
+	if (kvm_slot_can_be_private(memslot)) {
+		ret = guest_memfd_abort(vcpu, fault_ipa, memslot,
+					esr_fsc_is_permission_fault(esr));
+	} else {
+		ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
+				     esr_fsc_is_permission_fault(esr));
+	}
+
 	if (ret == 0)
 		ret = 1;
 out:
-- 
2.47.0.rc0.187.ge670bccf7e-goog


