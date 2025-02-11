Return-Path: <kvm+bounces-37893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 92EE0A311AA
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 17:35:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AAC118872BE
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 16:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87937256C8E;
	Tue, 11 Feb 2025 16:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s0yd24XS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C652724E4C3
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 16:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739291682; cv=none; b=Dwuh/t03I0vEDYSwOUqnSFXYt0lEwk+U0uirJCpQMrRIknHCclFr5Rw+8EzPjqNFFmDZ2L7JvSEseWQedbGJHaffkFE9l7qtp7FpxF8LeQKk9uJjWE/jlkSVdsZGJ8vOgQwxlSJO/HNCQYDzWsanOm6eHpMiqW2GqQ3W0e0Pj7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739291682; c=relaxed/simple;
	bh=pL52B4gunepUa7piVHA6WvA804vyPgLBn4s4+/Uzz2s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=olLVpFwJOQozrUmDu/FkTMF8kTy1B5amONeO4TpHoTpcrJwMgIj1xK8se+FRuhRkrdmrtYYCZ2vNj6aZHmvCukAGmnoQtIIQadT277m8sybGqmjaCrmTIVu7/aoA/uovMlqsTDM+zL3kLFRYIMJ6ZiW4V4hjhrMBn5+UhKIRmY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s0yd24XS; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-47190a013d4so255841cf.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 08:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739291679; x=1739896479; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qBfR0yM8m6KhutGWg4s9NJiKi6YZt6byJQys+JOsOJQ=;
        b=s0yd24XSEQFeBqS4qtkTWdu+HnH3agz6lbusPh80frvX5wtq56/X+daHVSQUDdXhql
         842jnkZ2ET+NTXdmwpcix02blsEK0l2KkQn16x2r6s7+55oIhKHkeY3a2l1YQb4O7HLT
         A0HFCc4I/VMwu2nweTpzrRD0UQEgcgE2Ty1A7Th+yj3y6pDNPLrGTNOyhVfWi58LB6Sn
         2DlgGo9icPygLvWn92HnYNmOMMz9+EHbBg/CuvXwuf4JygsPcRhuyRyDqGuDRlJrWfA9
         5jgJgSbPcEVPUqDaiMUjjJDBfpG2+qiJ96dkP4XAlnz8uvq04ccfYNYpTcin5y9LVkiS
         E+zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739291679; x=1739896479;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qBfR0yM8m6KhutGWg4s9NJiKi6YZt6byJQys+JOsOJQ=;
        b=X+7GcwgcswQF0u/c9yM2k3+ns4EptHA/jT5LOhiTRNaHQeDJ1rXf2j9XdtWvVysCSO
         5lbcUKFUADwgfPsx2EeNeXoHk17eex01tdbZ0iVR6O/p2LCR+htJPMk9HgesypgxW2uQ
         +HzJzL2liExM6zrbBsAAkqrui7WZGnAs/AG/5e5dHhSTbJz0R4b+f5hw+qsXu/mTzcrA
         rjL9kQ8T7f6I9cJpf+xq9amlNfC47Fxr2yBI+VvvnW5OZG02RHu9b/OUM2Mp65Cl2AY9
         tPnshv+A7yja3eGo8EzO6ERRW0eZYdp7qrmbFlEkd//12BbSYamrnCDg/dRFGnESM6TP
         4gWA==
X-Gm-Message-State: AOJu0YxcWm9qfpPsxz/pYOGHBXQS/R08Anx9JU+XxcuN/mMBXwcCpaLH
	s9SCHkNsmg2YsO2oCiS12YNiNaQ9x/jBXh6gvYA0qbVAsyXPTxeIkBx05z4w6lK+L/fIwMCBHh3
	ckMvHI4BNWTHadlstE+1/axuqtaAwyr82WEGmlvOumLvReD+1LrBQW2o=
X-Gm-Gg: ASbGncvy9/NvnHxlj6lD1ZF4D2b8Vpf5IsR+g8zmC6HKQBOvfU2IiMqBfg9YJLMoEeK
	N3ZvEl3lcttb3Gm0F12snHIWprqbqDAulaS6F5DcTt6VhmasI936aAK/AFj5HkGR+Aymxm20=
X-Google-Smtp-Source: AGHT+IGKRvYBfvDM/o/HoD9Y5zwhUvhHHPrgsNuE/tTmtP469y6rD4qgkNpj8MZ92d33tcmp6Ap5PJMafOrIJ2TWbjs=
X-Received: by 2002:ac8:5904:0:b0:467:8f1e:7304 with SMTP id
 d75a77b69052e-471a40fa96fmr3601721cf.13.1739291679139; Tue, 11 Feb 2025
 08:34:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211121128.703390-1-tabba@google.com> <20250211121128.703390-9-tabba@google.com>
 <Z6tzfMW0TdwdAWxT@google.com> <CA+EHjTy3dmpLGL1kXiqZXh4uA4xOJDeTwffj7u6XyaH3jBU26w@mail.gmail.com>
 <Z6t6FSNwREpyMrG3@google.com>
In-Reply-To: <Z6t6FSNwREpyMrG3@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 11 Feb 2025 16:34:02 +0000
X-Gm-Features: AWEUYZl853kvO0g1wM2KECxvfTYz_-gdGxjbCg3vJUovp4LBWwcfUDLfEpAC2S0
Message-ID: <CA+EHjTyU5K4Ro+gx1RcBcs2P2bjoVM24LO0AHSU+yjjQFCsw8Q@mail.gmail.com>
Subject: Re: [PATCH v3 08/11] KVM: arm64: Handle guest_memfd()-backed guest
 page faults
To: Quentin Perret <qperret@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
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
	maz@kernel.org, will@kernel.org, keirf@google.com, roypat@amazon.co.uk, 
	shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, 
	jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Quentin,

On Tue, 11 Feb 2025 at 16:26, Quentin Perret <qperret@google.com> wrote:
>
> On Tuesday 11 Feb 2025 at 16:13:27 (+0000), Fuad Tabba wrote:
> > Hi Quentin,
> >
> > On Tue, 11 Feb 2025 at 15:57, Quentin Perret <qperret@google.com> wrote:
> > >
> > > Hey Fuad,
> > >
> > > On Tuesday 11 Feb 2025 at 12:11:24 (+0000), Fuad Tabba wrote:
> > > > Add arm64 support for handling guest page faults on guest_memfd
> > > > backed memslots.
> > > >
> > > > For now, the fault granule is restricted to PAGE_SIZE.
> > > >
> > > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > > ---
> > > >  arch/arm64/kvm/mmu.c     | 84 ++++++++++++++++++++++++++--------------
> > > >  include/linux/kvm_host.h |  5 +++
> > > >  virt/kvm/kvm_main.c      |  5 ---
> > > >  3 files changed, 61 insertions(+), 33 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index b6c0acb2311c..305060518766 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -1454,6 +1454,33 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
> > > >       return vma->vm_flags & VM_MTE_ALLOWED;
> > > >  }
> > > >
> > > > +static kvm_pfn_t faultin_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > > +                          gfn_t gfn, bool write_fault, bool *writable,
> > > > +                          struct page **page, bool is_private)
> > > > +{
> > > > +     kvm_pfn_t pfn;
> > > > +     int ret;
> > > > +
> > > > +     if (!is_private)
> > > > +             return __kvm_faultin_pfn(slot, gfn, write_fault ? FOLL_WRITE : 0, writable, page);
> > > > +
> > > > +     *writable = false;
> > > > +
> > > > +     if (WARN_ON_ONCE(write_fault && memslot_is_readonly(slot)))
> > > > +             return KVM_PFN_ERR_NOSLOT_MASK;
> > >
> > > I believe this check is superfluous, we should decide to report an MMIO
> > > exit to userspace for write faults to RO memslots and not get anywhere
> > > near user_mem_abort(). And nit but the error code should probably be
> > > KVM_PFN_ERR_RO_FAULT or something instead?
> >
> > I tried to replicate the behavior of __kvm_faultin_pfn() here (but got
> > the wrong error!). I think you're right though that in the arm64 case,
> > this check isn't needed. Should I fix the return error and keep the
> > warning though?
>
> __kvm_faultin_pfn() will just set *writable to false if it find an RO
> memslot apparently, not return an error. So I'd vote for dropping that
> check so we align with that behaviour.

Ack.

> > > > +
> > > > +     ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, page, NULL);
> > > > +     if (!ret) {
> > > > +             *writable = write_fault;
> > >
> > > In normal KVM, if we're not dirty logging we'll actively map the page as
> > > writable if both the memslot and the userspace mappings are writable.
> > > With gmem, the latter doesn't make much sense, but essentially the
> > > underlying page should really be writable (e.g. no CoW getting in the
> > > way and such?). If so, then perhaps make this
> > >
> > >                 *writable = !memslot_is_readonly(slot);
> > >
> > > Wdyt?
> >
> > Ack.
> >
> > > > +             return pfn;
> > > > +     }
> > > > +
> > > > +     if (ret == -EHWPOISON)
> > > > +             return KVM_PFN_ERR_HWPOISON;
> > > > +
> > > > +     return KVM_PFN_ERR_NOSLOT_MASK;
> > > > +}
> > > > +
> > > >  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > > >                         struct kvm_s2_trans *nested,
> > > >                         struct kvm_memory_slot *memslot, unsigned long hva,
> > > > @@ -1461,25 +1488,26 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > > >  {
> > > >       int ret = 0;
> > > >       bool write_fault, writable;
> > > > -     bool exec_fault, mte_allowed;
> > > > +     bool exec_fault, mte_allowed = false;
> > > >       bool device = false, vfio_allow_any_uc = false;
> > > >       unsigned long mmu_seq;
> > > >       phys_addr_t ipa = fault_ipa;
> > > >       struct kvm *kvm = vcpu->kvm;
> > > > -     struct vm_area_struct *vma;
> > > > +     struct vm_area_struct *vma = NULL;
> > > >       short vma_shift;
> > > >       void *memcache;
> > > > -     gfn_t gfn;
> > > > +     gfn_t gfn = ipa >> PAGE_SHIFT;
> > > >       kvm_pfn_t pfn;
> > > >       bool logging_active = memslot_is_logging(memslot);
> > > > -     bool force_pte = logging_active || is_protected_kvm_enabled();
> > > > -     long vma_pagesize, fault_granule;
> > > > +     bool is_private = kvm_mem_is_private(kvm, gfn);
> > >
> > > Just trying to understand the locking rule for the xarray behind this.
> > > Is it kvm->srcu that protects it for reads here? Something else?
> >
> > I'm not sure I follow. Which xarray are you referring to?
>
> Sorry, yes, that wasn't clear. I meant that kvm_mem_is_private() calls
> kvm_get_memory_attributes() which indexes kvm->mem_attr_array. The
> comment in struct kvm indicates that this xarray is protected by RCU for
> readers, so I was just checking if we were relying on
> kvm_handle_guest_abort() to take srcu_read_lock(&kvm->srcu) for us, or
> if there was something else more subtle here.

I was kind of afraid that people would be confused by this, and I
commented on it in the commit message of the earlier patch:
https://lore.kernel.org/all/20250211121128.703390-6-tabba@google.com/

> Note that the word "private" in the name of the function
> kvm_mem_is_private() doesn't necessarily indicate that the memory
> isn't shared, but is due to the history and evolution of
> guest_memfd and the various names it has received. In effect,
> this function is used to multiplex between the path of a normal
> page fault and the path of a guest_memfd backed page fault.

kvm_mem_is_private() is property of the memslot itself. No xarrays
harmed in the process :)

Cheers,
/fuad

> Cheers,
> Quentin
>
> > >
> > > > +     bool force_pte = logging_active || is_private || is_protected_kvm_enabled();
> > > > +     long vma_pagesize, fault_granule = PAGE_SIZE;
> > > >       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > > >       struct kvm_pgtable *pgt;
> > > >       struct page *page;
> > > >       enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
> > > >
> > > > -     if (fault_is_perm)
> > > > +     if (fault_is_perm && !is_private)
> > >
> > > Nit: not strictly necessary I think.
> >
> > You're right.
> >
> > Thanks,
> > /fuad
> >
> > > >               fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
> > > >       write_fault = kvm_is_write_fault(vcpu);
> > > >       exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> > > > @@ -1510,24 +1538,30 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > > >                       return ret;
> > > >       }
> > > >
> > > > +     mmap_read_lock(current->mm);
> > > > +
> > > >       /*
> > > >        * Let's check if we will get back a huge page backed by hugetlbfs, or
> > > >        * get block mapping for device MMIO region.
> > > >        */
> > > > -     mmap_read_lock(current->mm);
> > > > -     vma = vma_lookup(current->mm, hva);
> > > > -     if (unlikely(!vma)) {
> > > > -             kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
> > > > -             mmap_read_unlock(current->mm);
> > > > -             return -EFAULT;
> > > > -     }
> > > > +     if (!is_private) {
> > > > +             vma = vma_lookup(current->mm, hva);
> > > > +             if (unlikely(!vma)) {
> > > > +                     kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
> > > > +                     mmap_read_unlock(current->mm);
> > > > +                     return -EFAULT;
> > > > +             }
> > > >
> > > > -     /*
> > > > -      * logging_active is guaranteed to never be true for VM_PFNMAP
> > > > -      * memslots.
> > > > -      */
> > > > -     if (WARN_ON_ONCE(logging_active && (vma->vm_flags & VM_PFNMAP)))
> > > > -             return -EFAULT;
> > > > +             /*
> > > > +              * logging_active is guaranteed to never be true for VM_PFNMAP
> > > > +              * memslots.
> > > > +              */
> > > > +             if (WARN_ON_ONCE(logging_active && (vma->vm_flags & VM_PFNMAP)))
> > > > +                     return -EFAULT;
> > > > +
> > > > +             vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> > > > +             mte_allowed = kvm_vma_mte_allowed(vma);
> > > > +     }
> > > >
> > > >       if (force_pte)
> > > >               vma_shift = PAGE_SHIFT;
> > > > @@ -1597,18 +1631,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > > >               ipa &= ~(vma_pagesize - 1);
> > > >       }
> > > >
> > > > -     gfn = ipa >> PAGE_SHIFT;
> > > > -     mte_allowed = kvm_vma_mte_allowed(vma);
> > > > -
> > > > -     vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> > > > -
> > > >       /* Don't use the VMA after the unlock -- it may have vanished */
> > > >       vma = NULL;
> > > >
> > > >       /*
> > > >        * Read mmu_invalidate_seq so that KVM can detect if the results of
> > > > -      * vma_lookup() or __kvm_faultin_pfn() become stale prior to
> > > > -      * acquiring kvm->mmu_lock.
> > > > +      * vma_lookup() or faultin_pfn() become stale prior to acquiring
> > > > +      * kvm->mmu_lock.
> > > >        *
> > > >        * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
> > > >        * with the smp_wmb() in kvm_mmu_invalidate_end().
> > > > @@ -1616,8 +1645,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > > >       mmu_seq = vcpu->kvm->mmu_invalidate_seq;
> > > >       mmap_read_unlock(current->mm);
> > > >
> > > > -     pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
> > > > -                             &writable, &page);
> > > > +     pfn = faultin_pfn(kvm, memslot, gfn, write_fault, &writable, &page, is_private);
> > > >       if (pfn == KVM_PFN_ERR_HWPOISON) {
> > > >               kvm_send_hwpoison_signal(hva, vma_shift);
> > > >               return 0;
> > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > index 39fd6e35c723..415c6274aede 100644
> > > > --- a/include/linux/kvm_host.h
> > > > +++ b/include/linux/kvm_host.h
> > > > @@ -1882,6 +1882,11 @@ static inline int memslot_id(struct kvm *kvm, gfn_t gfn)
> > > >       return gfn_to_memslot(kvm, gfn)->id;
> > > >  }
> > > >
> > > > +static inline bool memslot_is_readonly(const struct kvm_memory_slot *slot)
> > > > +{
> > > > +     return slot->flags & KVM_MEM_READONLY;
> > > > +}
> > > > +
> > > >  static inline gfn_t
> > > >  hva_to_gfn_memslot(unsigned long hva, struct kvm_memory_slot *slot)
> > > >  {
> > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > index 38f0f402ea46..3e40acb9f5c0 100644
> > > > --- a/virt/kvm/kvm_main.c
> > > > +++ b/virt/kvm/kvm_main.c
> > > > @@ -2624,11 +2624,6 @@ unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
> > > >       return size;
> > > >  }
> > > >
> > > > -static bool memslot_is_readonly(const struct kvm_memory_slot *slot)
> > > > -{
> > > > -     return slot->flags & KVM_MEM_READONLY;
> > > > -}
> > > > -
> > > >  static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slot, gfn_t gfn,
> > > >                                      gfn_t *nr_pages, bool write)
> > > >  {
> > > > --
> > > > 2.48.1.502.g6dc24dfdaf-goog
> > > >

