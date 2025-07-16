Return-Path: <kvm+bounces-52624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 64689B074C4
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 13:28:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B02F61C2630B
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D74112F49F6;
	Wed, 16 Jul 2025 11:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O1SNgBkR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E564F2F49F0
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 11:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752665214; cv=none; b=b0Q7cMfJ4nu9uCcGPL0W0msC+cdxty8vBOW6qne7YOWod63WluHF5ieka0tkLG9F4AEzyUtlIpwo0fqY0X1XYpcyDwhphJxoiETs5f0lisB+f2kFBRDUroniu/9+NgIyAFin6bcxeUpoflpX8CTynjCMTCZ70F+TJf1ZSWEinW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752665214; c=relaxed/simple;
	bh=mr+dFXLc7EQJb50d41UfRH1OK6wdQGe/ptcoS9odC9I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IVcU1/Y96YuFh+d6quvLiRrfua/5/4IhahKQ17BpevhYHlfwR4lDaQcg3RX1/KR8VZaPDcz+jksPjCNT2yxXjTfp+BYTjrteymyuwcMZ87TJrNf3ycwbhzEkw2xt/Y/2EwcRIxP810Ush90EzAbC+hqEliNUhyHDxM+H7I1XwkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O1SNgBkR; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso420561cf.0
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 04:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752665211; x=1753270011; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=t5R7kWnWuNP4kHs3y3gQRpYRuK0llaSxBMJsJPZN3qQ=;
        b=O1SNgBkRbNw8rp+HScNXfWLOgN4e/GkH+t6fdZjs4AmUxf+1YyLB0kdjpDLDJGbecE
         Pw42nm+kOEmJ+x8hTd7zsM0oU5WFcEvvDZ04qLh6IF9ajzVyZoJbUWOSUowLB8KKGKLr
         cxV1Pj4KHfwO0ClgdxxelxfhRPraufvDj5ZqOfHm2aHaCvQvoZrBnCUywV60K2juPwiY
         mCl8ACpoaJnCYLIO1ldp6sNpNgLSekg3PybRZVZ8cZEEC78mxo13u/WWppCblYkRWI+r
         pAlj02FKz+ezidQbkKSwL4Ds07I3i+egD4LewoGQNWBYA5Db4YzbzuD2R5Zk9+yUxv9p
         Dw/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752665211; x=1753270011;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t5R7kWnWuNP4kHs3y3gQRpYRuK0llaSxBMJsJPZN3qQ=;
        b=Ii7boAb/hkNTmvvZ358hJ7/93KV9fKDY/Jd7TUWEcTMX6FPKxbwVz7r0i0IZF0DOSs
         Mzoi56jQiHKiLqqOdQH4C9vhxjKSlHzQdZZNqhA6HE0PC5okcic/8EcnW98V1TPWASGP
         960xaybypGZBe5/qqdXEXMKqMxD2dtCj8/7c5f9FIUGnQENe2fCc962bAmaibF/lK9hk
         kDVv5Iz3aOtaB5Dq4zVothZanD+SYyGszlnALJI1nQAkqYUEn16yXWy5ZGecu0ZlEaaO
         6Tah//Mzj4tqgvQkrzIzPl8W0R8Bmw6n+BJsJa7sPn9yjgi0G/WRAZMnr69eK8UaKyh+
         tS3w==
X-Gm-Message-State: AOJu0YxmjSHae5Yy43vQkNCI8cAHCq/76HjKdHW9Dh8oJNQNlqQ1fKBI
	7ua7GC5/WIcFm1YY/qWS0+HacTg36BKCYQGcW0l0smWicS0Bv/QQRg0D3yJo7qws0pO54UuYSeq
	N8AJf3U8QbOb2AXQLxJjtqKQe9CyQ/KEDfQM0sQ4f
X-Gm-Gg: ASbGncv4LmA8EhuUbm9FOsgjEYlIPQEhsLWrI+ZfONXXRAk7tZrLHaoLiP09eaL/NXB
	qwK7vcfVASbsUhmMsYOvG5kc4ehfqutyG59dwlMzcsTnDnm7hDA/DB1EA5ApyKPPF4yBOovJR47
	rS+poecy1X0b7Ak/kgH9m0U2tga+2wa8cHNx92kF/tMC1rN16NCt9heAeJTEQxYxBzqYRLCNcCg
	n1pcCfidAYZsytZF6DDZgn1ucj26nF1Jfge
X-Google-Smtp-Source: AGHT+IHaGYFlj+5UQCP3ycOWBKRQbIDwdhMKRPNIGN5Zyy7RYQr7ya7fA0vyRBNNF6bOnwvE+TY/1VOezg6wIMY0dnM=
X-Received: by 2002:a05:622a:a28d:b0:4a7:26d2:5a38 with SMTP id
 d75a77b69052e-4ab97e14cb6mr1763881cf.19.1752665210038; Wed, 16 Jul 2025
 04:26:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com> <20250715093350.2584932-16-tabba@google.com>
 <39a217c1-29a9-4497-b3b6-bc0459e75a91@redhat.com>
In-Reply-To: <39a217c1-29a9-4497-b3b6-bc0459e75a91@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 16 Jul 2025 12:26:13 +0100
X-Gm-Features: Ac12FXyf7dM4gwpjCXZKsFe03i-IhUXKmydFOHr4OJpO94k0Jnlho20N3Z_JVzU
Message-ID: <CA+EHjTz=4PbF9yVQPO-ucjSq=n4fC+-QP_HGpWO4Wa1273fXtw@mail.gmail.com>
Subject: Re: [PATCH v14 15/21] KVM: arm64: Refactor user_mem_abort()
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
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
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 16 Jul 2025 at 11:36, David Hildenbrand <david@redhat.com> wrote:
>
> On 15.07.25 11:33, Fuad Tabba wrote:
> > Refactor user_mem_abort() to improve code clarity and simplify
> > assumptions within the function.
> >
> > Key changes include:
> >
> > * Immediately set force_pte to true at the beginning of the function if
> >    logging_active is true. This simplifies the flow and makes the
> >    condition for forcing a PTE more explicit.
> >
> > * Remove the misleading comment stating that logging_active is
> >    guaranteed to never be true for VM_PFNMAP memslots, as this assertion
> >    is not entirely correct.
> >
> > * Extract reusable code blocks into new helper functions:
> >    * prepare_mmu_memcache(): Encapsulates the logic for preparing and
> >      topping up the MMU page cache.
> >    * adjust_nested_fault_perms(): Isolates the adjustments to shadow S2
> >      permissions and the encoding of nested translation levels.
> >
> > * Update min(a, (long)b) to min_t(long, a, b) for better type safety and
> >    consistency.
> >
> > * Perform other minor tidying up of the code.
> >
> > These changes primarily aim to simplify user_mem_abort() and make its
> > logic easier to understand and maintain, setting the stage for future
> > modifications.
> >
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Reviewed-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   arch/arm64/kvm/mmu.c | 110 +++++++++++++++++++++++--------------------
> >   1 file changed, 59 insertions(+), 51 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 2942ec92c5a4..b3eacb400fab 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1470,13 +1470,56 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
> >       return vma->vm_flags & VM_MTE_ALLOWED;
> >   }
> >
> > +static int prepare_mmu_memcache(struct kvm_vcpu *vcpu, bool topup_memcache,
> > +                             void **memcache)
> > +{
> > +     int min_pages;
> > +
> > +     if (!is_protected_kvm_enabled())
> > +             *memcache = &vcpu->arch.mmu_page_cache;
> > +     else
> > +             *memcache = &vcpu->arch.pkvm_memcache;
> > +
> > +     if (!topup_memcache)
> > +             return 0;
> > +
> > +     min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
> > +
> > +     if (!is_protected_kvm_enabled())
> > +             return kvm_mmu_topup_memory_cache(*memcache, min_pages);
> > +
> > +     return topup_hyp_memcache(*memcache, min_pages);
> > +}
> > +
> > +/*
> > + * Potentially reduce shadow S2 permissions to match the guest's own S2. For
> > + * exec faults, we'd only reach this point if the guest actually allowed it (see
> > + * kvm_s2_handle_perm_fault).
> > + *
> > + * Also encode the level of the original translation in the SW bits of the leaf
> > + * entry as a proxy for the span of that translation. This will be retrieved on
> > + * TLB invalidation from the guest and used to limit the invalidation scope if a
> > + * TTL hint or a range isn't provided.
> > + */
> > +static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
> > +                                   enum kvm_pgtable_prot *prot,
> > +                                   bool *writable)
> > +{
> > +     *writable &= kvm_s2_trans_writable(nested);
> > +     if (!kvm_s2_trans_readable(nested))
> > +             *prot &= ~KVM_PGTABLE_PROT_R;
> > +
> > +     *prot |= kvm_encode_nested_level(nested);
> > +}
> > +
> >   static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >                         struct kvm_s2_trans *nested,
> >                         struct kvm_memory_slot *memslot, unsigned long hva,
> >                         bool fault_is_perm)
> >   {
> >       int ret = 0;
> > -     bool write_fault, writable, force_pte = false;
> > +     bool topup_memcache;
> > +     bool write_fault, writable;
> >       bool exec_fault, mte_allowed;
> >       bool device = false, vfio_allow_any_uc = false;
> >       unsigned long mmu_seq;
> > @@ -1488,6 +1531,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >       gfn_t gfn;
> >       kvm_pfn_t pfn;
> >       bool logging_active = memslot_is_logging(memslot);
> > +     bool force_pte = logging_active;
> >       long vma_pagesize, fault_granule;
> >       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> >       struct kvm_pgtable *pgt;
> > @@ -1498,17 +1542,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >               fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
> >       write_fault = kvm_is_write_fault(vcpu);
> >       exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> > -     VM_BUG_ON(write_fault && exec_fault);
> > -
> > -     if (fault_is_perm && !write_fault && !exec_fault) {
> > -             kvm_err("Unexpected L2 read permission error\n");
> > -             return -EFAULT;
> > -     }
> > -
> > -     if (!is_protected_kvm_enabled())
> > -             memcache = &vcpu->arch.mmu_page_cache;
> > -     else
> > -             memcache = &vcpu->arch.pkvm_memcache;
> > +     VM_WARN_ON_ONCE(write_fault && exec_fault);
> >
> >       /*
> >        * Permission faults just need to update the existing leaf entry,
> > @@ -1516,17 +1550,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >        * only exception to this is when dirty logging is enabled at runtime
> >        * and a write fault needs to collapse a block entry into a table.
> >        */
> > -     if (!fault_is_perm || (logging_active && write_fault)) {
> > -             int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
> > -
> > -             if (!is_protected_kvm_enabled())
> > -                     ret = kvm_mmu_topup_memory_cache(memcache, min_pages);
> > -             else
> > -                     ret = topup_hyp_memcache(memcache, min_pages);
> > -
> > -             if (ret)
> > -                     return ret;
> > -     }
> > +     topup_memcache = !fault_is_perm || (logging_active && write_fault);
> > +     ret = prepare_mmu_memcache(vcpu, topup_memcache, &memcache);
> > +     if (ret)
> > +             return ret;
> >
> >       /*
> >        * Let's check if we will get back a huge page backed by hugetlbfs, or
> > @@ -1540,16 +1567,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >               return -EFAULT;
> >       }
> >
> > -     /*
> > -      * logging_active is guaranteed to never be true for VM_PFNMAP
> > -      * memslots.
> > -      */
> > -     if (logging_active) {
> > -             force_pte = true;
> > +     if (force_pte)
> >               vma_shift = PAGE_SHIFT;
> > -     } else {
> > +     else
> >               vma_shift = get_vma_page_shift(vma, hva);
> > -     }
> >
> >       switch (vma_shift) {
> >   #ifndef __PAGETABLE_PMD_FOLDED
> > @@ -1601,7 +1622,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >                       max_map_size = PAGE_SIZE;
> >
> >               force_pte = (max_map_size == PAGE_SIZE);
> > -             vma_pagesize = min(vma_pagesize, (long)max_map_size);
> > +             vma_pagesize = min_t(long, vma_pagesize, max_map_size);
> >       }
> >
> >       /*
> > @@ -1630,7 +1651,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >        * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
> >        * with the smp_wmb() in kvm_mmu_invalidate_end().
> >        */
> > -     mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> > +     mmu_seq = kvm->mmu_invalidate_seq;
> >       mmap_read_unlock(current->mm);
> >
> >       pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
> > @@ -1665,24 +1686,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >       if (exec_fault && device)
> >               return -ENOEXEC;
> >
> > -     /*
> > -      * Potentially reduce shadow S2 permissions to match the guest's own
> > -      * S2. For exec faults, we'd only reach this point if the guest
> > -      * actually allowed it (see kvm_s2_handle_perm_fault).
> > -      *
> > -      * Also encode the level of the original translation in the SW bits
> > -      * of the leaf entry as a proxy for the span of that translation.
> > -      * This will be retrieved on TLB invalidation from the guest and
> > -      * used to limit the invalidation scope if a TTL hint or a range
> > -      * isn't provided.
> > -      */
> > -     if (nested) {
> > -             writable &= kvm_s2_trans_writable(nested);
> > -             if (!kvm_s2_trans_readable(nested))
> > -                     prot &= ~KVM_PGTABLE_PROT_R;
> > -
> > -             prot |= kvm_encode_nested_level(nested);
> > -     }
> > +     if (nested)
> > +             adjust_nested_fault_perms(nested, &prot, &writable);
> >
> >       kvm_fault_lock(kvm);
> >       pgt = vcpu->arch.hw_mmu->pgt;
> > @@ -1953,6 +1958,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> >               goto out_unlock;
> >       }
> >
> > +     VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
> > +                     !write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
> > +
> >       ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> >                            esr_fsc_is_permission_fault(esr));
> >       if (ret == 0)
>
>
> A note that on the KVM arm next tree
>
> https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/log/?h=next
>
> there are some user_mem_abort() changes. IIUC, only smaller conflicts.

Thanks for the heads up. I can work with Marc and Oliver to resolve
any conflicts once we get there.

Cheers,
/fuad


> --
> Cheers,
>
> David / dhildenb
>

