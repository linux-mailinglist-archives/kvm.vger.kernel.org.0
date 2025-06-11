Return-Path: <kvm+bounces-49089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9A51AD5BF5
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 18:20:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7AB31BC4121
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 16:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 340FB1FCFE2;
	Wed, 11 Jun 2025 16:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RvVoc3U2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED861DED53
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 16:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749658661; cv=none; b=u7r6YvX2084H4zr0HgEJKzfWq5yqft9Si9ATDG7LqXwDPnagSQSQIFEy4I8EQuzPstO9pCF1BwvMdgCBpHj0aHXa1Sb6xOgseQ4e7CTpV/ZdRin8or0sIvoswLjKGbbBHpxtgpkWw4vyzG93clshKpIYz8/VcvpBUjT9w4dvrvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749658661; c=relaxed/simple;
	bh=S3+uEEYLr6VL9a8/grSjLxnD1Xr+huVMQep5ccpceWA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pn9cZzSf+cZtPCwm3ASkIx4RCj9oiu12oY+krRZySo12uskMt6RqyvRSVyHBusANQP56RcxCKT7OAMA7MjGDwbOwNKfD2jVZKBssnxq3peVaJMkcmdjW30dOP+cfACZODBQdsVyKircgHCm0fmgGYlXuQoHaPAliKrUJNQwf+74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RvVoc3U2; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26cdc70befso4613678a12.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 09:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749658658; x=1750263458; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MpJGUeTesz/l8nAhHXfIm/2EbAPorpB1pTyUq3Oc96I=;
        b=RvVoc3U2Y8JB10dl5jKwfIkPRXLne4F8GHmV96lTzXoje0+DuYWnt28Uko4wlXaipf
         ZoEe9wmexNv9WYv1HU5vHlsagJAHz8AA+ii8813IWBbyG/aiVUyCch9STT53/pt6xckt
         z7XoANQaRMVhZgeXR1XHbiXEML8jAU67C5Y0UQJ7c0czoR9181sJX0qzyW73vVuQVBYu
         GV1aTQLpqE5bksvFC3PDa0LdoEFgi/7kVB+vnaRggp+XGBtqORJzPlTpvnt8AJnzLOdX
         dOgeeP21HaiJG7r72ZUyIlx/4gx0anm5mCsLj990YTDXcy6eiICa6NP1YfJnkgJ3rato
         MZIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749658658; x=1750263458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MpJGUeTesz/l8nAhHXfIm/2EbAPorpB1pTyUq3Oc96I=;
        b=TJgaw3QbyNhdq3IxASFJH0M6UxVIutB4cOtFrc6w9gqVVHZVBmux0j6bn3QSF/4uFz
         7l6w4qluuFpl/hueRY3AKgaqwy6n1QPrVySDWBSBRiNwoHyvDk4W3Au1Q1GxabFnYHC7
         tGn2mPmH0bRywzfb6zRTbFw9rlCcmQIfs9YzKNxen/ETyl5uh/xQm+bh7yHCwXSSk3Sq
         DTNhdz9E5cpf12Rwu/oztLojBpoLq3coBqppuq87gGbWd495QE++SWbBSoMYHEP4in9F
         2BLEvzN7gCb4GX0lDUfp70bTQxaxz6vZSwn2Ig3MBzo20rlTM1eYbG9z3i4pqTBoMgl9
         fjzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQ2gYjYRvTDxFZUxDcjGdsIHcFhO5PqdRiksylJRBdhi9f39NLwo2biSCgq4gA4tsumQg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmviCUF5sNJNvuVcuEL5nTNEbng3Wh5HEzvSbXxyLAvg1HsOl4
	SoBwWO//gt9u2rNDFT8J3lJXlzto35RgCwsuNqaFqCnZgULloRcrsY0ltQBv6uz5zxK1lTaY8Od
	LEKotsg==
X-Google-Smtp-Source: AGHT+IEE1WF66pnelIfSWLSMIyF7MtrTE54yB8mYQCiFsPGAZljIgFV7YexNu7FxtzcN7V0+Una/H9ks4tg=
X-Received: from pfkq5.prod.google.com ([2002:a05:6a00:845:b0:739:8cd6:c16c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d8a:b0:216:1476:f71
 with SMTP id adf61e73a8af0-21f86746b8fmr5941037637.39.1749658657728; Wed, 11
 Jun 2025 09:17:37 -0700 (PDT)
Date: Wed, 11 Jun 2025 09:17:36 -0700
In-Reply-To: <20250611-352bef23df9a4ec55fe5cb68@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <50989f0a02790f9d7dc804c2ade6387c4e7fbdbc.1749634392.git.zhouquan@iscas.ac.cn>
 <20250611-352bef23df9a4ec55fe5cb68@orel>
Message-ID: <aEmsIOuz3bLwjBW_@google.com>
Subject: Re: [PATCH] RISC-V: KVM: Avoid re-acquiring memslot in kvm_riscv_gstage_map()
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: zhouquan@iscas.ac.cn, anup@brainfault.org, atishp@atishpatra.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 11, 2025, Andrew Jones wrote:
> On Wed, Jun 11, 2025 at 05:51:40PM +0800, zhouquan@iscas.ac.cn wrote:
> > From: Quan Zhou <zhouquan@iscas.ac.cn>
> > 
> > The caller has already passed in the memslot, and there are
> > two instances `{kvm_faultin_pfn/mark_page_dirty}` of retrieving
> > the memslot again in `kvm_riscv_gstage_map`, we can replace them
> > with `{__kvm_faultin_pfn/mark_page_dirty_in_slot}`.
> > 
> > Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> > ---
> >  arch/riscv/kvm/mmu.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> > index 1087ea74567b..f9059dac3ba3 100644
> > --- a/arch/riscv/kvm/mmu.c
> > +++ b/arch/riscv/kvm/mmu.c
> > @@ -648,7 +648,8 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
> >  		return -EFAULT;
> >  	}
> >  
> > -	hfn = kvm_faultin_pfn(vcpu, gfn, is_write, &writable, &page);
> > +	hfn = __kvm_faultin_pfn(memslot, gfn, is_write ? FOLL_WRITE : 0,
> > +				&writable, &page);
> 
> I think introducing another function with the following diff would be
> better than duplicating the is_write to foll translation.

NAK, I don't want an explosion of wrapper APIs (especially with boolean params).

I 100% agree that it's mildly annoying to force arch code to do convert "write"
to FOLL_WRITE, but that's a symptom of KVM not providing a common structure for
passing page fault information.

What I want to get to is a set of APIs that look something the below (very off
the cuff), not add more wrappers and put KVM back in a situation where there are
a bajillion ways to do the same basic thing.

struct kvm_page_fault {
	const gpa_t addr;
	const bool exec;
	const bool write;
	const bool present;

	gfn_t gfn;

	/* The memslot containing gfn. May be NULL. */
	struct kvm_memory_slot *slot;

	/* Outputs */
	unsigned long mmu_seq;
	kvm_pfn_t pfn;
	struct page *refcounted_page;
	bool map_writable;
};

kvm_pfn_t __kvm_faultin_pfn(struct kvm_page_fault *fault, unsigned int flags)
{
	struct kvm_follow_pfn kfp = {
		.slot = fault->slot,
		.gfn = fault->gfn,
		.flags = flags | fault->write ? FOLL_WRITE : 0,
		.map_writable = &fault->writable,
		.refcounted_page = &fault->refcounted_page,
	};

	fault->writable = false;
	fault->refcounted_page = NULL;

	return kvm_follow_pfn(&kfp);
}
EXPORT_SYMBOL_GPL(__kvm_faultin_pfn);

kvm_pfn_t kvm_faultin_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, bool write,
			  bool *writable, struct page **refcounted_page)
{
	struct kvm_follow_pfn kfp = {
		.slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn),,
		.gfn = gfn,
		.flags = write ? FOLL_WRITE : 0,
		.map_writable = writable,
		.refcounted_page = refcounted_page,
	};

	if (WARN_ON_ONCE(!writable || !refcounted_page))
		return KVM_PFN_ERR_FAULT;

	*writable = false;
	*refcounted_page = NULL;

	return kvm_follow_pfn(&kfp);
}
EXPORT_SYMBOL_GPL(__kvm_faultin_pfn);


To get things started, I proposed moving "struct kvm_page_fault" to common code
so that it can be shared by x86 and arm64 as part of the KVM userfault series.
But I'd be more than happy to acclerate the standardization of "struct kvm_page_fault"
if we want to get there sooner than later.

[*] https://lore.kernel.org/all/aBqlkz1bqhu-9toV@google.com

In the meantime, RISC-V can start preparing for that future, and clean up its
code in the process.

E.g. "fault_addr" should be "gpa_t", not "unsigned long".  If 32-bit RISC-V
is strictly limited to 32-bit _physical_ addresses in the *architecture*, then
gpa_t should probably be tweaked accordingly.

And vma_pageshift should be "unsigned int", not "short".

Looks like y'all also have a bug where an -EEXIST will be returned to userspace,
and will generate what's probably a spurious kvm_err() message.

E.g. in the short term:

---
 arch/riscv/include/asm/kvm_host.h |  5 ++--
 arch/riscv/kvm/mmu.c              | 49 +++++++++++++++++++++----------
 arch/riscv/kvm/vcpu_exit.c        | 40 +------------------------
 3 files changed, 36 insertions(+), 58 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 85cfebc32e4c..84c5db715ba5 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -361,9 +361,8 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
 			     bool writable, bool in_atomic);
 void kvm_riscv_gstage_iounmap(struct kvm *kvm, gpa_t gpa,
 			      unsigned long size);
-int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
-			 struct kvm_memory_slot *memslot,
-			 gpa_t gpa, unsigned long hva, bool is_write);
+int kvm_riscv_gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				struct kvm_cpu_trap *trap);
 int kvm_riscv_gstage_alloc_pgd(struct kvm *kvm);
 void kvm_riscv_gstage_free_pgd(struct kvm *kvm);
 void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu);
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 1087ea74567b..3b0afc1c0832 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -586,22 +586,37 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	return pte_young(ptep_get(ptep));
 }
 
-int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
-			 struct kvm_memory_slot *memslot,
-			 gpa_t gpa, unsigned long hva, bool is_write)
+int kvm_riscv_gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				struct kvm_cpu_trap *trap)
 {
-	int ret;
-	kvm_pfn_t hfn;
-	bool writable;
-	short vma_pageshift;
+
+	struct kvm_mmu_memory_cache *pcache = &vcpu->arch.mmu_page_cache;
+	gpa_t gpa = (trap->htval << 2) | (trap->stval & 0x3);
 	gfn_t gfn = gpa >> PAGE_SHIFT;
-	struct vm_area_struct *vma;
+	struct kvm_memory_slot *memslot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	bool logging = memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
+	bool write = trap->scause == EXC_STORE_GUEST_PAGE_FAULT;
+	bool read =  trap->scause == EXC_LOAD_GUEST_PAGE_FAULT;
+	unsigned int flags = write ? FOLL_WRITE : 0;
+	unsigned long hva, vma_pagesize, mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_mmu_memory_cache *pcache = &vcpu->arch.mmu_page_cache;
-	bool logging = (memslot->dirty_bitmap &&
-			!(memslot->flags & KVM_MEM_READONLY)) ? true : false;
-	unsigned long vma_pagesize, mmu_seq;
+	unsigned int vma_pageshift;
+	struct vm_area_struct *vma;
 	struct page *page;
+	kvm_pfn_t hfn;
+	bool writable;
+	int ret;
+
+	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
+	if (kvm_is_error_hva(hva) || (write && !writable)) {
+		if (read)
+			return kvm_riscv_vcpu_mmio_load(vcpu, run, gpa,
+							trap->htinst);
+		if (write)
+			return kvm_riscv_vcpu_mmio_store(vcpu, run, gpa,
+							 trap->htinst);
+		return -EOPNOTSUPP;
+	}
 
 	/* We need minimum second+third level pages */
 	ret = kvm_mmu_topup_memory_cache(pcache, gstage_pgd_levels);
@@ -648,7 +663,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 		return -EFAULT;
 	}
 
-	hfn = kvm_faultin_pfn(vcpu, gfn, is_write, &writable, &page);
+	hfn = __kvm_faultin_pfn(memslot, gfn, flags, &writable, &page);
 	if (hfn == KVM_PFN_ERR_HWPOISON) {
 		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
 				vma_pageshift, current);
@@ -661,7 +676,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 	 * If logging is active then we allow writable pages only
 	 * for write faults.
 	 */
-	if (logging && !is_write)
+	if (logging && !write)
 		writable = false;
 
 	spin_lock(&kvm->mmu_lock);
@@ -677,14 +692,16 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 		ret = gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
 				      vma_pagesize, true, true);
 	}
+	if (ret == -EEXIST)
+		ret = 0;
 
 	if (ret)
 		kvm_err("Failed to map in G-stage\n");
 
 out_unlock:
-	kvm_release_faultin_page(kvm, page, ret && ret != -EEXIST, writable);
+	kvm_release_faultin_page(kvm, page, ret, writable);
 	spin_unlock(&kvm->mmu_lock);
-	return ret;
+	return ret ? ret : 1;
 }
 
 int kvm_riscv_gstage_alloc_pgd(struct kvm *kvm)
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 6e0c18412795..6f07077068f6 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -10,44 +10,6 @@
 #include <asm/csr.h>
 #include <asm/insn-def.h>
 
-static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
-			     struct kvm_cpu_trap *trap)
-{
-	struct kvm_memory_slot *memslot;
-	unsigned long hva, fault_addr;
-	bool writable;
-	gfn_t gfn;
-	int ret;
-
-	fault_addr = (trap->htval << 2) | (trap->stval & 0x3);
-	gfn = fault_addr >> PAGE_SHIFT;
-	memslot = gfn_to_memslot(vcpu->kvm, gfn);
-	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
-
-	if (kvm_is_error_hva(hva) ||
-	    (trap->scause == EXC_STORE_GUEST_PAGE_FAULT && !writable)) {
-		switch (trap->scause) {
-		case EXC_LOAD_GUEST_PAGE_FAULT:
-			return kvm_riscv_vcpu_mmio_load(vcpu, run,
-							fault_addr,
-							trap->htinst);
-		case EXC_STORE_GUEST_PAGE_FAULT:
-			return kvm_riscv_vcpu_mmio_store(vcpu, run,
-							 fault_addr,
-							 trap->htinst);
-		default:
-			return -EOPNOTSUPP;
-		};
-	}
-
-	ret = kvm_riscv_gstage_map(vcpu, memslot, fault_addr, hva,
-		(trap->scause == EXC_STORE_GUEST_PAGE_FAULT) ? true : false);
-	if (ret < 0)
-		return ret;
-
-	return 1;
-}
-
 /**
  * kvm_riscv_vcpu_unpriv_read -- Read machine word from Guest memory
  *
@@ -229,7 +191,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case EXC_LOAD_GUEST_PAGE_FAULT:
 	case EXC_STORE_GUEST_PAGE_FAULT:
 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
-			ret = gstage_page_fault(vcpu, run, trap);
+			ret = kvm_riscv_gstage_page_fault(vcpu, run, trap);
 		break;
 	case EXC_SUPERVISOR_SYSCALL:
 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)

base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
-- 

