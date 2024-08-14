Return-Path: <kvm+bounces-24198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E580F95244C
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 22:55:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B5BA28BF23
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 20:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4621C7B7B;
	Wed, 14 Aug 2024 20:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FOGGtiLC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5031C4615
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 20:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723668848; cv=none; b=O+86SS+texz33jVGf1OHnXOLVxphsD9XXZF9D/7Ul2hklk4AWVMMmiJ3TOilCg3NLNcGUVlaZUwigdlCk1jYaQcf7kVCRomavDZAO9qbuaQo5m81g2JhcZMZo8ZzvNbdpKQa2CiHaL1SmccLTRukewt6GK+POb2SjWgPo4ilXvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723668848; c=relaxed/simple;
	bh=mNIKKB/h6moRmhvtx6luZiRE7f4Hg39UPA9d8mgpcvY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OvIV1PSOD54SJNrXmI7brAv0ODTvGkkaHkTJk0M72wu/wIY/MTpHPboTs5YEAImXlvay6rtbTH1U9q0vEVkZaZ4OdbxU75TGMNXu6/aH55MvEVGOeJIi+lzXRhPQfQsLZd37HlVq61Qrw8nx8adWs4Zd2AdC/fy5xOiCuSlHo0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FOGGtiLC; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6c8f99fef10so326928a12.3
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 13:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723668846; x=1724273646; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mhTJCB88wWf2hWzTRLfKwH19eqX22VE73/Nsj7CbfoY=;
        b=FOGGtiLC7l8uVhWfRCmxwSbWbTtnlWBMdA7wyShOWAzf3cPaqYNZY67VYwjM12w1G/
         YQfFdOs36+qP/XXsFmRqGV+16Cq00M2mU9YzjnB1++Azk98ovwSsaKlu/MVQ8tQ2uJPU
         yJhnv5cSIoiweh1O2SkLbUT81LdcO5afBhF0a2E2hSOaH5AJWetg9HtIoK19C9RRXx1w
         GySEPnCGe8DiXFn1WfmNhpq1b9c1dKM5oy7KomC3d703Nx7aOC8Ui094cAEdZoyzCRTy
         iX2SNMV8Y/Uli28LVHYp0oH4flaSutLrnzfterCUNReipwPraadP6VkfBE3MVpUspFzJ
         D8oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723668846; x=1724273646;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mhTJCB88wWf2hWzTRLfKwH19eqX22VE73/Nsj7CbfoY=;
        b=F/5QE874dBCZH/B6CGC9gQg1ZV2x1Z5xTqMC5GP9F8cGEQhjBtBzxz7rwCnmGGexv9
         qITAT8kmpI0TVEEb0e69GeMKnJ+GqPg2D0lkD/9Bx8409CosfPDaGepHCyyhgSt3VWrE
         9UyiVfN/UxQAFG/dbQjzTjfIacewSobAiNtnSm7OS38ixt4BlRt9XYnGQltj6ddDBbqH
         NBWTO8Oj3ApDq/qvZP0tnnccBQObO7Svi8aLK1gYSQ/O3F5+P7Y0G9eCAyfuVHPVsKU5
         YOjBsCsO6VtWprwQvVrAICHw+7LG1ArbL7hqukYyf3E8/PcG3sKla6si0jFVrBLfVloK
         TF4A==
X-Forwarded-Encrypted: i=1; AJvYcCXxHa7hA16ISe30Ip+VmFPgLZNUSNoGGnCi9virduH3QyP1Vq9U9HkhJv4OPYfpQ2BAf1qsbZD4QIohRnjfctlHuk2y
X-Gm-Message-State: AOJu0Yxa+tOjwLrqC6rEIut+SDwD/Vkc5/C6c326C5ZRemMNP6vbjx9B
	XEo4OXNJkmEQPKMGsbr5TNCBlQ6iq/ZCM3/Q2LXHz+rck43CuZCF/y5Gw/dpQIh9oFlka3yPnBY
	9Zw==
X-Google-Smtp-Source: AGHT+IFMUxJIAoyyhoZrKWntJD+kuK2qDGRswSU7CbacvdcbuPYXZy7w26RkCFIriZQPyBhG6BFRhbitzIU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:40c7:0:b0:7c3:e3c7:95bf with SMTP id
 41be03b00d2f7-7c6a5868eb7mr6941a12.7.1723668845655; Wed, 14 Aug 2024 13:54:05
 -0700 (PDT)
Date: Wed, 14 Aug 2024 13:54:04 -0700
In-Reply-To: <20240814144307.GP2032816@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809160909.1023470-1-peterx@redhat.com> <20240814123715.GB2032816@nvidia.com>
 <ZrzAlchCZx0ptSfR@google.com> <20240814144307.GP2032816@nvidia.com>
Message-ID: <Zr0ZbPQHVNzmvwa6@google.com>
Subject: Re: [PATCH 00/19] mm: Support huge pfnmaps
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-arm-kernel@lists.infradead.org, x86@kernel.org, 
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, 
	Alistair Popple <apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>, David Hildenbrand <david@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"

+Marc and Oliver

On Wed, Aug 14, 2024, Jason Gunthorpe wrote:
> On Wed, Aug 14, 2024 at 07:35:01AM -0700, Sean Christopherson wrote:
> > On Wed, Aug 14, 2024, Jason Gunthorpe wrote:
> > > On Fri, Aug 09, 2024 at 12:08:50PM -0400, Peter Xu wrote:
> > > > Overview
> > > > ========
> > > > 
> > > > This series is based on mm-unstable, commit 98808d08fc0f of Aug 7th latest,
> > > > plus dax 1g fix [1].  Note that this series should also apply if without
> > > > the dax 1g fix series, but when without it, mprotect() will trigger similar
> > > > errors otherwise on PUD mappings.
> > > > 
> > > > This series implements huge pfnmaps support for mm in general.  Huge pfnmap
> > > > allows e.g. VM_PFNMAP vmas to map in either PMD or PUD levels, similar to
> > > > what we do with dax / thp / hugetlb so far to benefit from TLB hits.  Now
> > > > we extend that idea to PFN mappings, e.g. PCI MMIO bars where it can grow
> > > > as large as 8GB or even bigger.
> > > 
> > > FWIW, I've started to hear people talk about needing this in the VFIO
> > > context with VMs.
> > > 
> > > vfio/iommufd will reassemble the contiguous range from the 4k PFNs to
> > > setup the IOMMU, but KVM is not able to do it so reliably.
> > 
> > Heh, KVM should very reliably do the exact opposite, i.e. KVM should never create
> > a huge page unless the mapping is huge in the primary MMU.  And that's very much
> > by design, as KVM has no knowledge of what actually resides at a given PFN, and
> > thus can't determine whether or not its safe to create a huge page if KVM happens
> > to realize the VM has access to a contiguous range of memory.
> 
> Oh? Someone told me recently x86 kvm had code to reassemble contiguous
> ranges?

Nope.  KVM ARM does (see get_vma_page_shift()) but I strongly suspect that's only
a win in very select use cases, and is overall a non-trivial loss.  

> I don't quite understand your safety argument, if the VMA has 1G of
> contiguous physical memory described with 4K it is definitely safe for
> KVM to reassemble that same memory and represent it as 1G.

That would require taking mmap_lock to get the VMA, which would be a net negative,
especially for workloads that are latency sensitive.   E.g. if userspace is doing
mprotect(), madvise(), etc. on VMA that is NOT mapped into the guest, taking
mmap_lock in the guest page fault path means vCPUs block waiting for the unrelated
host operation to complete.  And vise versa, subsequent host operations can be
blocked waiting on vCPUs.

Which reminds me...

Marc/Oliver,

TL;DR: it's probably worth looking at mmu_stress_test (was: max_guest_memory_test)
on arm64, specifically the mprotect() testcase[1], as performance is significantly
worse compared to x86, and there might be bugs lurking the mmu_notifier flows.

When running mmu_stress_test the mprotect() phase that makes guest memory read-only
takes more than three times as long on arm64 versus x86.  The time to initially
popuplate memory (run1) is also notably higher on arm64, as is the time to
mprotect() back to RW protections.

The test doesn't go super far out of its way to control the environment, but it
should be a fairly reasonable apples-to-apples comparison.  

Ouch.  I take that back, it's not apples-to-apples, because the test does more
work for x86.  On x86, during mprotect(PROT_READ), the userspace side skips the
faulting instruction on -EFAULT and so vCPUs keep writing for the entire duration.
Other architectures stop running the vCPU after the first write -EFAULT and wait
for the mproptect() to complete.  If I comment out the x86-only logic and have
vCPUs stop on the first -EFAULT, the mprotect() goes way down.

/me fiddles with arm64

And if I have arm64 vCPUs keep faulting, the time goes up, as exptected.

With 128GiB of guest memory (aliased to a single 2GiB chunk of physical memory),
and 48 vCPUs (on systems with 64+ CPUs), stopping on the first fault:

 x86:
  run1 =  6.873408794s, reset = 0.000165898s, run2 = 0.035537803s, ro =  6.149083106s, rw = 7.713627355s

 arm64:
  run1 = 13.960144969s, reset = 0.000178596s, run2 = 0.018020005s, ro = 50.924434051s, rw = 14.712983786

and skipping on -EFAULT and thus writing throughout mprotect():

 x86:
  run1 =  6.923218747s, reset = 0.000167050s, run2 = 0.034676225s, ro = 14.599445790s, rw = 7.763152792s

 arm64:
  run1 = 13.543469513s, reset = 0.000018763s, run2 = 0.020533896s, ro = 81.063504438s, rw = 14.967504024s

I originally suspected at the main source of difference is that user_mem_abort()
takes mmap_lock for read.  But I doubt that's the case now that I realize arm64
vCPUs stop after the first -EFAULT, i.e. won't contend mmap_lock.

And it's shouldn't be the lack of support for mmu_invalidate_retry_gfn() (on arm64
vs. x86), because the mprotect() is relevant to guest memory (though range-based
retry is something that KVM ARM likely should support).  And again, arm64 is still
much slower when vCPUs stop on the first -EFAULT.

However, before I realized mmap_lock likely wasn't the main problem, I tried to
prove that taking mmap_lock is problematic, and that didn't end well.  When I
hacked user_mem_abort() to not take mmap_lock, the host reboots when the mprotect()
read-only phase kicks in.  AFAICT, there is no crash, e.g. no kdump and nothing
printed to the console, the host suddenly just starts executing firmware code.

To try and rule out a hidden dependency I'm missing, I tried trimming out pretty
much everything that runs under mmap_lock (and only running the selftest, which
doesn't do anything "odd", e.g. doesn't passthrough device memory).  I also forced
small pages, e.g. in case transparent_hugepage_adjust() is somehow reliant on
mmap_lock being taken, to no avail.  Just in case someone can spot an obvious
flaw in my hack, the final diff I tried is below.

Jumping back to mmap_lock, adding a lock, vma_lookup(), and unlock in x86's page
fault path for valid VMAs does introduce a performance regression, but only ~30%,
not the ~6x jump from x86 to arm64.  So that too makes it unlikely taking mmap_lock
is the main problem, though it's still good justification for avoid mmap_lock in
the page fault path.

[1] https://lore.kernel.org/all/20240809194335.1726916-9-seanjc@google.com

---
 arch/arm64/kvm/mmu.c | 167 +++----------------------------------------
 1 file changed, 9 insertions(+), 158 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6981b1bc0946..df551c19f626 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1424,14 +1424,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  bool fault_is_perm)
 {
 	int ret = 0;
-	bool write_fault, writable, force_pte = false;
-	bool exec_fault, mte_allowed;
-	bool device = false, vfio_allow_any_uc = false;
+	bool write_fault, writable;
+	bool exec_fault;
 	unsigned long mmu_seq;
 	phys_addr_t ipa = fault_ipa;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
-	struct vm_area_struct *vma;
 	short vma_shift;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
@@ -1451,6 +1449,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
+	if (WARN_ON_ONCE(nested) || WARN_ON_ONCE(kvm_has_mte(kvm)))
+		return -EIO;
+
 	/*
 	 * Permission faults just need to update the existing leaf entry,
 	 * and so normally don't require allocations from the memcache. The
@@ -1464,92 +1465,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			return ret;
 	}
 
-	/*
-	 * Let's check if we will get back a huge page backed by hugetlbfs, or
-	 * get block mapping for device MMIO region.
-	 */
-	mmap_read_lock(current->mm);
-	vma = vma_lookup(current->mm, hva);
-	if (unlikely(!vma)) {
-		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
-		mmap_read_unlock(current->mm);
-		return -EFAULT;
-	}
-
-	/*
-	 * logging_active is guaranteed to never be true for VM_PFNMAP
-	 * memslots.
-	 */
-	if (logging_active) {
-		force_pte = true;
-		vma_shift = PAGE_SHIFT;
-	} else {
-		vma_shift = get_vma_page_shift(vma, hva);
-	}
-
-	switch (vma_shift) {
-#ifndef __PAGETABLE_PMD_FOLDED
-	case PUD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
-			break;
-		fallthrough;
-#endif
-	case CONT_PMD_SHIFT:
-		vma_shift = PMD_SHIFT;
-		fallthrough;
-	case PMD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
-			break;
-		fallthrough;
-	case CONT_PTE_SHIFT:
-		vma_shift = PAGE_SHIFT;
-		force_pte = true;
-		fallthrough;
-	case PAGE_SHIFT:
-		break;
-	default:
-		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
-	}
-
+	vma_shift = PAGE_SHIFT;
 	vma_pagesize = 1UL << vma_shift;
-
-	if (nested) {
-		unsigned long max_map_size;
-
-		max_map_size = force_pte ? PAGE_SIZE : PUD_SIZE;
-
-		ipa = kvm_s2_trans_output(nested);
-
-		/*
-		 * If we're about to create a shadow stage 2 entry, then we
-		 * can only create a block mapping if the guest stage 2 page
-		 * table uses at least as big a mapping.
-		 */
-		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
-
-		/*
-		 * Be careful that if the mapping size falls between
-		 * two host sizes, take the smallest of the two.
-		 */
-		if (max_map_size >= PMD_SIZE && max_map_size < PUD_SIZE)
-			max_map_size = PMD_SIZE;
-		else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
-			max_map_size = PAGE_SIZE;
-
-		force_pte = (max_map_size == PAGE_SIZE);
-		vma_pagesize = min(vma_pagesize, (long)max_map_size);
-	}
-
-	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
-		fault_ipa &= ~(vma_pagesize - 1);
-
 	gfn = ipa >> PAGE_SHIFT;
-	mte_allowed = kvm_vma_mte_allowed(vma);
-
-	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
-
-	/* Don't use the VMA after the unlock -- it may have vanished */
-	vma = NULL;
 
 	/*
 	 * Read mmu_invalidate_seq so that KVM can detect if the results of
@@ -1560,7 +1478,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * with the smp_wmb() in kvm_mmu_invalidate_end().
 	 */
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
-	mmap_read_unlock(current->mm);
+	smp_rmb();
 
 	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
 				   write_fault, &writable, NULL);
@@ -1571,19 +1489,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (is_error_noslot_pfn(pfn))
 		return -EFAULT;
 
-	if (kvm_is_device_pfn(pfn)) {
-		/*
-		 * If the page was identified as device early by looking at
-		 * the VMA flags, vma_pagesize is already representing the
-		 * largest quantity we can map.  If instead it was mapped
-		 * via gfn_to_pfn_prot(), vma_pagesize is set to PAGE_SIZE
-		 * and must not be upgraded.
-		 *
-		 * In both cases, we don't let transparent_hugepage_adjust()
-		 * change things at the last minute.
-		 */
-		device = true;
-	} else if (logging_active && !write_fault) {
+	if (logging_active && !write_fault) {
 		/*
 		 * Only actually map the page as writable if this was a write
 		 * fault.
@@ -1591,28 +1497,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		writable = false;
 	}
 
-	if (exec_fault && device)
-		return -ENOEXEC;
-
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
-
 	read_lock(&kvm->mmu_lock);
 	pgt = vcpu->arch.hw_mmu->pgt;
 	if (mmu_invalidate_retry(kvm, mmu_seq)) {
@@ -1620,46 +1504,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		goto out_unlock;
 	}
 
-	/*
-	 * If we are not forced to use page mapping, check if we are
-	 * backed by a THP and thus use block mapping if possible.
-	 */
-	if (vma_pagesize == PAGE_SIZE && !(force_pte || device)) {
-		if (fault_is_perm && fault_granule > PAGE_SIZE)
-			vma_pagesize = fault_granule;
-		else
-			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
-								   hva, &pfn,
-								   &fault_ipa);
-
-		if (vma_pagesize < 0) {
-			ret = vma_pagesize;
-			goto out_unlock;
-		}
-	}
-
-	if (!fault_is_perm && !device && kvm_has_mte(kvm)) {
-		/* Check the VMM hasn't introduced a new disallowed VMA */
-		if (mte_allowed) {
-			sanitise_mte_tags(kvm, pfn, vma_pagesize);
-		} else {
-			ret = -EFAULT;
-			goto out_unlock;
-		}
-	}
-
 	if (writable)
 		prot |= KVM_PGTABLE_PROT_W;
 
 	if (exec_fault)
 		prot |= KVM_PGTABLE_PROT_X;
 
-	if (device) {
-		if (vfio_allow_any_uc)
-			prot |= KVM_PGTABLE_PROT_NORMAL_NC;
-		else
-			prot |= KVM_PGTABLE_PROT_DEVICE;
-	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
+	if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
 		   (!nested || kvm_s2_trans_executable(nested))) {
 		prot |= KVM_PGTABLE_PROT_X;
 	}

base-commit: 15e1c3d65975524c5c792fcd59f7d89f00402261
-- 

