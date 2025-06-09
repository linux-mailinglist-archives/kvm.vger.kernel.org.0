Return-Path: <kvm+bounces-48721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B679AAD18C6
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 09:02:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A14253A9A9D
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 07:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C5E280CC8;
	Mon,  9 Jun 2025 07:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QlqoIh7A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF70325C813
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 07:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749452519; cv=none; b=kHWYreNmoVBgSn2cQ7r577aiBfV+KV8bSKW8XOlo96kAGtmzhPAX35b5INwMLXShoweHoaRjLLtI/9LWHYZIeTjoJ5V9ZN9/wf4O6K00dXj1Bxcal8bIhOGOzSNvkSVsCJhi7WltNk0hUQ9yJHaexUnicWW6hIughr8K9cSzqec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749452519; c=relaxed/simple;
	bh=aRx90mh4DBsB382qZLbUgE6k75728wG4XEm7SKbHgaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G/IjsTi3M3iZz5V7r7IbO9f8IxIMS8DjjLr6em6xNWts+PRiK0a0x0Ch3MCBA3Hp7ZE28wrxDjw37U89V7QXKXSv/5Z1IamOzVIREykc8peiaTm69rfHtKONU39ltk2QEMheNOXZCUZ7i0da6SbCcQttg0aLG4CEN8CoOCQ91BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QlqoIh7A; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-47e9fea29easo507711cf.1
        for <kvm@vger.kernel.org>; Mon, 09 Jun 2025 00:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749452515; x=1750057315; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qd1ChU4RfLFVxxmL2KzsgjziSyYF1OUEgK3hVJNjklY=;
        b=QlqoIh7AsFd6n7NUeUpm/a2RtGIMAMhOkSiFwG/EqNprnthmDZzBvaQWimR9aFMhU0
         qs8o2K5qNNsXladpbka37cj0PixXLffJHVX95NIDFPWMK7KDeYu4NUVjxIxyGzEu7VSv
         5WClRMyGvEka7IkIm9rH6Ee8kffOy04can9kdYHI7iw/1DZh2ytqxTsIpokh0XklnfSw
         CZfrxrWSbIY58UganrS7sYtCrJXY/6CtXD5x6riw4QeOWnuSMAbIjB24xiq8A7bDdWyw
         erT0cwEA3PcFhNiMdTt4R1GptU8Zn364kFGeovOhRI+1VFGiPgj9vV8N5GIGdVIkt+st
         UI0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749452515; x=1750057315;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qd1ChU4RfLFVxxmL2KzsgjziSyYF1OUEgK3hVJNjklY=;
        b=AAq0L37i58nxUFpCTVuszOEGJEiV1CDFAitodFmz2jXjaiciHuouGKi4GSHRSTWJ28
         KTiTjdZ0SNpgsh9r5RIyNo1wtM3x7htH4I6Jp+f6mX/t5gcvXvl/O4JuA/ct7C0dQcyf
         55wR8YgPr3lFbuACT46XkiIKT8G8pkfhhYwAVrlLHdxIvzzbw5CBZOldg0ui8k7zP4yR
         r8fX/HbUmnB8m+fk7o6/F+x0QvEpKd2UtKu7ICJq/4rZt7HFCY0/j+hQ9BES0eNIkxwr
         VEotXASf1njXypZXJdhktNBxvNt3hbjbHmkYXHUiVDVvR0i7gS84z+5vxA4C/amroUsf
         aA5Q==
X-Gm-Message-State: AOJu0YwpYFM82X7GTH/i1QCwVRs+fwyZZfacSBzl2oa8JDBHoxnZOBbe
	R78UkXbrRqS9oQo3Z/tNg6CejVKKq4htMu8l0qKby3tisHiiA0UR9lFersGJHVADVJ5apJt6hc/
	zVOxKmYmLeLp9/zqmPyf9mNDz5B5svdCYMgZN+ux5
X-Gm-Gg: ASbGncsmV7j8d3qyujRacaC45TqpOvD8ngA7gimRq/w7Jvj2Hclv6nJqEmz4VmJqiWQ
	vVvq09PzmirogWhW6LZqpd/ByubR2QsJl49xPr55LmHPBluPAPsc7bVOHz0V4dnj7n9CBQkYrpn
	Z8wpgJDDUWucxXHG/ipmQLandmDy5CKZfwv5uusjc04kNeZeV8V/CNzQ==
X-Google-Smtp-Source: AGHT+IEYTjTPB44LdkojWXh1DgFtqgfjL8IG40gv9XwgF99n42jhj0tJV9OMy0pM+Kly1ld8fJ7D+mY65UKD6ViNkf0=
X-Received: by 2002:a05:622a:189a:b0:494:4aa0:ad5b with SMTP id
 d75a77b69052e-4a6ef9d0503mr6371521cf.2.1749452514924; Mon, 09 Jun 2025
 00:01:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-14-tabba@google.com>
 <a4e63374-8b4f-4800-a638-35ff343f78d2@redhat.com>
In-Reply-To: <a4e63374-8b4f-4800-a638-35ff343f78d2@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 Jun 2025 08:01:17 +0100
X-Gm-Features: AX0GCFtueCmazOgupVxtUqJ3eDLk0zaHqIaK1R7EMlVz70IKr0ZL8XxR8nJ_svw
Message-ID: <CA+EHjTzYSZSQxh+97SSU7kg+S59CFMisF437wfAxnFRkfgUeFg@mail.gmail.com>
Subject: Re: [PATCH v11 13/18] KVM: arm64: Refactor user_mem_abort()
To: Gavin Shan <gshan@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi Gavin,

On Mon, 9 Jun 2025 at 01:27, Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Fuad,
>
> On 6/6/25 1:37 AM, Fuad Tabba wrote:
> > To simplify the code and to make the assumptions clearer,
> > refactor user_mem_abort() by immediately setting force_pte to
> > true if the conditions are met.
> >
> > Remove the comment about logging_active being guaranteed to never be
> > true for VM_PFNMAP memslots, since it's not actually correct.
> >
> > Move code that will be reused in the following patch into separate
> > functions.
> >
> > Other small instances of tidying up.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   arch/arm64/kvm/mmu.c | 100 ++++++++++++++++++++++++-------------------
> >   1 file changed, 55 insertions(+), 45 deletions(-)
> >
>
> One nitpick below in case v12 is needed. In either way, it looks good to me:
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
>
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index eeda92330ade..ce80be116a30 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1466,13 +1466,56 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
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
>
> It's unnecessary to initialize 'memcache' when topup_memcache is false.

I thought about this before, and I _think_ you're right. However, I
couldn't completely convince myself that that's always the case for
the code to be functionally equivalent (looking at the condition for
kvm_pgtable_stage2_relax_perms() at the end of the function). Which is
why, if I were to do that, I'd do it as a separate patch.

Thanks,
/fuad

>         if (!topup_memcache)
>                 return 0;
>
>         min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
>         if (!is_protected_kvm_enabled())
>                 *memcache = &vcpu->arch.mmu_page_cache;
>         else
>                 *memcache = &vcpu->arch.pkvm_memcache;
>
> Thanks,
> Gavin
>
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
> > @@ -1484,6 +1527,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >       gfn_t gfn;
> >       kvm_pfn_t pfn;
> >       bool logging_active = memslot_is_logging(memslot);
> > +     bool force_pte = logging_active || is_protected_kvm_enabled();
> >       long vma_pagesize, fault_granule;
> >       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> >       struct kvm_pgtable *pgt;
> > @@ -1501,28 +1545,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >               return -EFAULT;
> >       }
> >
> > -     if (!is_protected_kvm_enabled())
> > -             memcache = &vcpu->arch.mmu_page_cache;
> > -     else
> > -             memcache = &vcpu->arch.pkvm_memcache;
> > -
> >       /*
> >        * Permission faults just need to update the existing leaf entry,
> >        * and so normally don't require allocations from the memcache. The
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
> > @@ -1536,16 +1568,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >               return -EFAULT;
> >       }
> >
> > -     /*
> > -      * logging_active is guaranteed to never be true for VM_PFNMAP
> > -      * memslots.
> > -      */
> > -     if (logging_active || is_protected_kvm_enabled()) {
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
> > @@ -1597,7 +1623,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >                       max_map_size = PAGE_SIZE;
> >
> >               force_pte = (max_map_size == PAGE_SIZE);
> > -             vma_pagesize = min(vma_pagesize, (long)max_map_size);
> > +             vma_pagesize = min_t(long, vma_pagesize, max_map_size);
> >       }
> >
> >       /*
> > @@ -1626,7 +1652,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >        * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
> >        * with the smp_wmb() in kvm_mmu_invalidate_end().
> >        */
> > -     mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> > +     mmu_seq = kvm->mmu_invalidate_seq;
> >       mmap_read_unlock(current->mm);
> >
> >       pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
> > @@ -1661,24 +1687,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
>

