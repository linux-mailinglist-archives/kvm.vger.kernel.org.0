Return-Path: <kvm+bounces-46138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7462BAB303C
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 09:08:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D2FD87A4746
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 07:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3EB82561DD;
	Mon, 12 May 2025 07:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xc9fv2vg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D526C2AD11
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 07:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747033679; cv=none; b=QH4fJT7+eQQDtUJILMN/4Hx5HHwL9hzHDarFVi77JGV9HNXTkDecDGbpOi9WeeZLqUZQBcN8T7KtaoYFEubXvoApOQyqHDxmfO9uvhRGlczlfGo7vRUmjydiJzK3w0w7l/iKWj0SZRzB4+z02GWP0f9D8eGKktW9FRR1Cy9pRNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747033679; c=relaxed/simple;
	bh=RQhH0DvJQr2/Xkb69JkRm0/lJs8VL11ZzAJsdwGrUjY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N38r2v2/yluDg2F4MobzGyD+jPgXJz2Ki9Y565UbeSlXTvAodlQaJ18x6xXrMI0OxczLYoW0UOCRjIJQGO0y871bGgM9wP0M9d7SCnnAa3tvnHxX+ggPtTzEJrvdGnATawJ8UfzHx9KGAV+EJ+LgjAM+VcnUkUH07Ii+lcjmAiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xc9fv2vg; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-47666573242so533271cf.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 00:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747033676; x=1747638476; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GMe4Rb7KuUZZeR9pc39r+DDWYOFPqj4dlC9wEB9NSpc=;
        b=xc9fv2vg6vVzPZGaoSGFJ42RopnuErraN/LgGd9rE+6QzPcK/mq3BqoSAdPYaCX0kt
         5MvE2idqFr0BVyAjuoyZ+5Obm1hBTHT3s+fhRPVPQCUrRbEi/u+HeJXN1BeBpGnQWXNn
         2UqNK8q2+0jJEKdBNL0mwktogQmE/o1JKDsNSRul2sFCXOkosPARm4c2lq1tGz6Nwawq
         PTi+c2Z+0m8zpof8BOseehtUY41feeGRXvQwg2u25853/CKV+UQHXQbqeCk3sRqGaHQE
         ChFdt0m7oJ2Sj60im97eEl6+cD0Z1Gt3GwodchEqmJRkcAIOTDf15vYhq3LAfbZsSPwC
         PqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747033676; x=1747638476;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GMe4Rb7KuUZZeR9pc39r+DDWYOFPqj4dlC9wEB9NSpc=;
        b=XqvEZEH7Re2d61BWIAt5FovHt1qLfmgjzczehDN5Z++VQuYl2ug8+xZjorfA9i12H0
         BXN2qj9h0tuMO85FqCYebG+IKS3cxV9i5SSvnfoMjQWo5br64AiGNlyKSYYklmTSO4aj
         i6Pj74+Mod7cvZKXodpinW9CmpCEwE4DeS+tzW96LfBoA+b+tBbZAIjZAp1lEr665LUY
         oka2lV3IPaQJgN95lFcfsCOGqEH3IIQsOAb7rHNc3zqXsGINRokRc3/KfUEAUgXX+sF7
         div7gFu8xoFVTGDl4lnUEyvbC/4gJhVEo0ztG5lBX+3f6Q0Hr9m6Uv0ok0meVl4acoGd
         Fy7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXt7gXcNHjPDV68Vq1Oyt1K8yBiXxaS5zeMf2uJQPdVNVJunXEElX1ahAJ9f5uwcREAD8g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCZYW+MIPa83OmZsKaWaRrrA8plRt1RrN4YL2hCjcBx0iLbU+G
	YfE0+XwwC+0FilDlfS+I/i2cVL35pCv8gl78fLkN503mcKMZ2xP2GPXszIX1ghEx744+1QxH6t7
	sHkAJk42NWUDrXt67foUlhjsWuWi5IE+s6+dP
X-Gm-Gg: ASbGncsLAfPH/gtsHnzbv3j6EBk/Ffv2foa8m1t6MktQLcyiMf8PXvXMjkKxrt38clj
	7kn6ETk0J1smcyrugOnZroyVVeyf1+E9rsXpiZNXKVYxLGF51JUj8BH0MR5kKoiMMY+3b1xc+Zv
	VWz60JgHK6DQcDzC7FdaOL8XckMeTtKODqrF2gIJoHAQ1h
X-Google-Smtp-Source: AGHT+IElESA490+bF3OtjDhtRquySU8jcTkUQvKunDc+O2Bt/7EWHfiFGF6gTUQRhYsPAV4Smez8Y/7iGJWnCU9flPM=
X-Received: by 2002:a05:622a:1:b0:47d:9e7:91a4 with SMTP id
 d75a77b69052e-49462f90c09mr7358751cf.27.1747033675379; Mon, 12 May 2025
 00:07:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430165655.605595-11-tabba@google.com> <20250509201529.3160064-1-jthoughton@google.com>
In-Reply-To: <20250509201529.3160064-1-jthoughton@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 12 May 2025 08:07:18 +0100
X-Gm-Features: AX0GCFsk8lXLnVBUv0n9S7VCr9FBPXBdzxJtrN6DcXKUUBGZbkJrTZSD4COP3Rs
Message-ID: <CA+EHjTy5yBa1J4d0X5Rb=fOc_nQWwEaWyqPOxpNo1kD+Z=oi1w@mail.gmail.com>
Subject: Re: [PATCH v8 10/13] KVM: arm64: Handle guest_memfd()-backed guest
 page faults
To: James Houghton <jthoughton@google.com>
Cc: ackerleytng@google.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anup@brainfault.org, aou@eecs.berkeley.edu, brauner@kernel.org, 
	catalin.marinas@arm.com, chao.p.peng@linux.intel.com, chenhuacai@kernel.org, 
	david@redhat.com, dmatlack@google.com, fvdl@google.com, hch@infradead.org, 
	hughd@google.com, isaku.yamahata@gmail.com, isaku.yamahata@intel.com, 
	james.morse@arm.com, jarkko@kernel.org, jgg@nvidia.com, jhubbard@nvidia.com, 
	keirf@google.com, kirill.shutemov@linux.intel.com, kvm@vger.kernel.org, 
	liam.merwick@oracle.com, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	mail@maciej.szmigiero.name, maz@kernel.org, mic@digikod.net, 
	michael.roth@amd.com, mpe@ellerman.id.au, oliver.upton@linux.dev, 
	palmer@dabbelt.com, pankaj.gupta@amd.com, paul.walmsley@sifive.com, 
	pbonzini@redhat.com, peterx@redhat.com, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, rientjes@google.com, 
	roypat@amazon.co.uk, seanjc@google.com, shuah@kernel.org, 
	steven.price@arm.com, suzuki.poulose@arm.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, wei.w.wang@intel.com, 
	will@kernel.org, willy@infradead.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi James,


On Fri, 9 May 2025 at 21:15, James Houghton <jthoughton@google.com> wrote:
>
> On Wed, Apr 30, 2025 at 9:57=E2=80=AFAM Fuad Tabba <tabba@google.com> wro=
te:
> >
> > Add arm64 support for handling guest page faults on guest_memfd
> > backed memslots.
> >
> > For now, the fault granule is restricted to PAGE_SIZE.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c     | 65 +++++++++++++++++++++++++++-------------
> >  include/linux/kvm_host.h |  5 ++++
> >  virt/kvm/kvm_main.c      |  5 ----
> >  3 files changed, 50 insertions(+), 25 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 148a97c129de..d1044c7f78bb 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1466,6 +1466,30 @@ static bool kvm_vma_mte_allowed(struct vm_area_s=
truct *vma)
> >         return vma->vm_flags & VM_MTE_ALLOWED;
> >  }
> >
> > +static kvm_pfn_t faultin_pfn(struct kvm *kvm, struct kvm_memory_slot *=
slot,
> > +                            gfn_t gfn, bool write_fault, bool *writabl=
e,
> > +                            struct page **page, bool is_gmem)
> > +{
> > +       kvm_pfn_t pfn;
> > +       int ret;
> > +
> > +       if (!is_gmem)
> > +               return __kvm_faultin_pfn(slot, gfn, write_fault ? FOLL_=
WRITE : 0, writable, page);
> > +
> > +       *writable =3D false;
> > +
> > +       ret =3D kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, page, NULL);
> > +       if (!ret) {
> > +               *writable =3D !memslot_is_readonly(slot);
> > +               return pfn;
> > +       }
> > +
> > +       if (ret =3D=3D -EHWPOISON)
> > +               return KVM_PFN_ERR_HWPOISON;
> > +
> > +       return KVM_PFN_ERR_NOSLOT_MASK;
> > +}
> > +
> >  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa=
,
> >                           struct kvm_s2_trans *nested,
> >                           struct kvm_memory_slot *memslot, unsigned lon=
g hva,
> > @@ -1473,19 +1497,20 @@ static int user_mem_abort(struct kvm_vcpu *vcpu=
, phys_addr_t fault_ipa,
> >  {
> >         int ret =3D 0;
> >         bool write_fault, writable;
> > -       bool exec_fault, mte_allowed;
> > +       bool exec_fault, mte_allowed =3D false;
> >         bool device =3D false, vfio_allow_any_uc =3D false;
> >         unsigned long mmu_seq;
> >         phys_addr_t ipa =3D fault_ipa;
> >         struct kvm *kvm =3D vcpu->kvm;
> > -       struct vm_area_struct *vma;
> > +       struct vm_area_struct *vma =3D NULL;
> >         short vma_shift;
> >         void *memcache;
> > -       gfn_t gfn;
> > +       gfn_t gfn =3D ipa >> PAGE_SHIFT;
> >         kvm_pfn_t pfn;
> >         bool logging_active =3D memslot_is_logging(memslot);
> > -       bool force_pte =3D logging_active || is_protected_kvm_enabled()=
;
> > -       long vma_pagesize, fault_granule;
> > +       bool is_gmem =3D kvm_slot_has_gmem(memslot) && kvm_mem_from_gme=
m(kvm, gfn);
> > +       bool force_pte =3D logging_active || is_gmem || is_protected_kv=
m_enabled();
> > +       long vma_pagesize, fault_granule =3D PAGE_SIZE;
> >         enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PROT_R;
> >         struct kvm_pgtable *pgt;
> >         struct page *page;
> > @@ -1522,16 +1547,22 @@ static int user_mem_abort(struct kvm_vcpu *vcpu=
, phys_addr_t fault_ipa,
> >                         return ret;
> >         }
> >
> > +       mmap_read_lock(current->mm);
>
> We don't have to take the mmap_lock for gmem faults, right?
>
> I think we should reorganize user_mem_abort() a bit (and I think vma_page=
size
> and maybe vma_shift should be renamed) given the changes we're making her=
e.

Good point.

> Below is a diff that I think might be a little cleaner. Let me know what =
you
> think.
>
> > +
> >         /*
> >          * Let's check if we will get back a huge page backed by hugetl=
bfs, or
> >          * get block mapping for device MMIO region.
> >          */
> > -       mmap_read_lock(current->mm);
> > -       vma =3D vma_lookup(current->mm, hva);
> > -       if (unlikely(!vma)) {
> > -               kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
> > -               mmap_read_unlock(current->mm);
> > -               return -EFAULT;
> > +       if (!is_gmem) {
> > +               vma =3D vma_lookup(current->mm, hva);
> > +               if (unlikely(!vma)) {
> > +                       kvm_err("Failed to find VMA for hva 0x%lx\n", h=
va);
> > +                       mmap_read_unlock(current->mm);
> > +                       return -EFAULT;
> > +               }
> > +
> > +               vfio_allow_any_uc =3D vma->vm_flags & VM_ALLOW_ANY_UNCA=
CHED;
> > +               mte_allowed =3D kvm_vma_mte_allowed(vma);
> >         }
> >
> >         if (force_pte)
> > @@ -1602,18 +1633,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu=
, phys_addr_t fault_ipa,
> >                 ipa &=3D ~(vma_pagesize - 1);
> >         }
> >
> > -       gfn =3D ipa >> PAGE_SHIFT;
> > -       mte_allowed =3D kvm_vma_mte_allowed(vma);
> > -
> > -       vfio_allow_any_uc =3D vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> > -
> >         /* Don't use the VMA after the unlock -- it may have vanished *=
/
> >         vma =3D NULL;
> >
> >         /*
> >          * Read mmu_invalidate_seq so that KVM can detect if the result=
s of
> > -        * vma_lookup() or __kvm_faultin_pfn() become stale prior to
> > -        * acquiring kvm->mmu_lock.
> > +        * vma_lookup() or faultin_pfn() become stale prior to acquirin=
g
> > +        * kvm->mmu_lock.
> >          *
> >          * Rely on mmap_read_unlock() for an implicit smp_rmb(), which =
pairs
> >          * with the smp_wmb() in kvm_mmu_invalidate_end().
> > @@ -1621,8 +1647,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
> >         mmu_seq =3D vcpu->kvm->mmu_invalidate_seq;
> >         mmap_read_unlock(current->mm);
> >
> > -       pfn =3D __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRIT=
E : 0,
> > -                               &writable, &page);
> > +       pfn =3D faultin_pfn(kvm, memslot, gfn, write_fault, &writable, =
&page, is_gmem);
> >         if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
>
> I think we need to take care to handle HWPOISON properly. I know that it =
is
> (or will most likely be) the case that GUP(hva) --> pfn, but with gmem,
> it *might* not be the case. So the following line isn't right.
>
> I think we need to handle HWPOISON for gmem using memory fault exits inst=
ead of
> sending a SIGBUS to userspace. This would be consistent with how KVM/x86
> today handles getting a HWPOISON page back from kvm_gmem_get_pfn(). I'm n=
ot
> entirely sure how KVM/x86 is meant to handle HWPOISON on shared gmem page=
s yet;
> I need to keep reading your series.

You're right. In the next respin (coming soon), Ackerley has added a
patch that performs a best-effort check to ensure that hva matches the
gfn.

> The reorganization diff below leaves this unfixed.
>
> >                 kvm_send_hwpoison_signal(hva, vma_shift);
> >                 return 0;
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index f3af6bff3232..1b2e4e9a7802 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1882,6 +1882,11 @@ static inline int memslot_id(struct kvm *kvm, gf=
n_t gfn)
> >         return gfn_to_memslot(kvm, gfn)->id;
> >  }
> >
> > +static inline bool memslot_is_readonly(const struct kvm_memory_slot *s=
lot)
> > +{
> > +       return slot->flags & KVM_MEM_READONLY;
> > +}
> > +
> >  static inline gfn_t
> >  hva_to_gfn_memslot(unsigned long hva, struct kvm_memory_slot *slot)
> >  {
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index c75d8e188eb7..d9bca5ba19dc 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2640,11 +2640,6 @@ unsigned long kvm_host_page_size(struct kvm_vcpu=
 *vcpu, gfn_t gfn)
> >         return size;
> >  }
> >
> > -static bool memslot_is_readonly(const struct kvm_memory_slot *slot)
> > -{
> > -       return slot->flags & KVM_MEM_READONLY;
> > -}
> > -
> >  static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *s=
lot, gfn_t gfn,
> >                                        gfn_t *nr_pages, bool write)
> >  {
> > --
> > 2.49.0.901.g37484f566f-goog
>
> Thanks, Fuad! Here's the reorganization/rename diff:

Thank you James. This is very helpful.

Cheers,
/fuad

>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d1044c7f78bba..c9eb72fe9013b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1502,7 +1502,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
>         unsigned long mmu_seq;
>         phys_addr_t ipa =3D fault_ipa;
>         struct kvm *kvm =3D vcpu->kvm;
> -       struct vm_area_struct *vma =3D NULL;
>         short vma_shift;
>         void *memcache;
>         gfn_t gfn =3D ipa >> PAGE_SHIFT;
> @@ -1510,7 +1509,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
>         bool logging_active =3D memslot_is_logging(memslot);
>         bool is_gmem =3D kvm_slot_has_gmem(memslot) && kvm_mem_from_gmem(=
kvm, gfn);
>         bool force_pte =3D logging_active || is_gmem || is_protected_kvm_=
enabled();
> -       long vma_pagesize, fault_granule =3D PAGE_SIZE;
> +       long target_size =3D PAGE_SIZE, fault_granule =3D PAGE_SIZE;
>         enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PROT_R;
>         struct kvm_pgtable *pgt;
>         struct page *page;
> @@ -1547,13 +1546,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
>                         return ret;
>         }
>
> -       mmap_read_lock(current->mm);
> -
>         /*
>          * Let's check if we will get back a huge page backed by hugetlbf=
s, or
>          * get block mapping for device MMIO region.
>          */
>         if (!is_gmem) {
> +               struct vm_area_struct *vma =3D NULL;
> +
> +               mmap_read_lock(current->mm);
> +
>                 vma =3D vma_lookup(current->mm, hva);
>                 if (unlikely(!vma)) {
>                         kvm_err("Failed to find VMA for hva 0x%lx\n", hva=
);
> @@ -1563,38 +1564,45 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
>
>                 vfio_allow_any_uc =3D vma->vm_flags & VM_ALLOW_ANY_UNCACH=
ED;
>                 mte_allowed =3D kvm_vma_mte_allowed(vma);
> -       }
> -
> -       if (force_pte)
> -               vma_shift =3D PAGE_SHIFT;
> -       else
> -               vma_shift =3D get_vma_page_shift(vma, hva);
> +               vma_shift =3D force_pte ? get_vma_page_shift(vma, hva) : =
PAGE_SHIFT;
>
> -       switch (vma_shift) {
> +               switch (vma_shift) {
>  #ifndef __PAGETABLE_PMD_FOLDED
> -       case PUD_SHIFT:
> -               if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_=
SIZE))
> -                       break;
> -               fallthrough;
> +               case PUD_SHIFT:
> +                       if (fault_supports_stage2_huge_mapping(memslot, h=
va, PUD_SIZE))
> +                               break;
> +                       fallthrough;
>  #endif
> -       case CONT_PMD_SHIFT:
> -               vma_shift =3D PMD_SHIFT;
> -               fallthrough;
> -       case PMD_SHIFT:
> -               if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_=
SIZE))
> +               case CONT_PMD_SHIFT:
> +                       vma_shift =3D PMD_SHIFT;
> +                       fallthrough;
> +               case PMD_SHIFT:
> +                       if (fault_supports_stage2_huge_mapping(memslot, h=
va, PMD_SIZE))
> +                               break;
> +                       fallthrough;
> +               case CONT_PTE_SHIFT:
> +                       vma_shift =3D PAGE_SHIFT;
> +                       force_pte =3D true;
> +                       fallthrough;
> +               case PAGE_SHIFT:
>                         break;
> -               fallthrough;
> -       case CONT_PTE_SHIFT:
> -               vma_shift =3D PAGE_SHIFT;
> -               force_pte =3D true;
> -               fallthrough;
> -       case PAGE_SHIFT:
> -               break;
> -       default:
> -               WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
> -       }
> +               default:
> +                       WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
> +               }
>
> -       vma_pagesize =3D 1UL << vma_shift;
> +               /*
> +                * Read mmu_invalidate_seq so that KVM can detect if the =
results of
> +                * vma_lookup() or faultin_pfn() become stale prior to ac=
quiring
> +                * kvm->mmu_lock.
> +                *
> +                * Rely on mmap_read_unlock() for an implicit smp_rmb(), =
which pairs
> +                * with the smp_wmb() in kvm_mmu_invalidate_end().
> +                */
> +               mmu_seq =3D vcpu->kvm->mmu_invalidate_seq;
> +               mmap_read_unlock(current->mm);
> +
> +               target_size =3D 1UL << vma_shift;
> +       }
>
>         if (nested) {
>                 unsigned long max_map_size;
> @@ -1620,7 +1628,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
>                         max_map_size =3D PAGE_SIZE;
>
>                 force_pte =3D (max_map_size =3D=3D PAGE_SIZE);
> -               vma_pagesize =3D min(vma_pagesize, (long)max_map_size);
> +               target_size =3D min(target_size, (long)max_map_size);
>         }
>
>         /*
> @@ -1628,27 +1636,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
>          * ensure we find the right PFN and lay down the mapping in the r=
ight
>          * place.
>          */
> -       if (vma_pagesize =3D=3D PMD_SIZE || vma_pagesize =3D=3D PUD_SIZE)=
 {
> -               fault_ipa &=3D ~(vma_pagesize - 1);
> -               ipa &=3D ~(vma_pagesize - 1);
> +       if (target_size =3D=3D PMD_SIZE || target_size =3D=3D PUD_SIZE) {
> +               fault_ipa &=3D ~(target_size - 1);
> +               ipa &=3D ~(target_size - 1);
>         }
>
> -       /* Don't use the VMA after the unlock -- it may have vanished */
> -       vma =3D NULL;
> -
> -       /*
> -        * Read mmu_invalidate_seq so that KVM can detect if the results =
of
> -        * vma_lookup() or faultin_pfn() become stale prior to acquiring
> -        * kvm->mmu_lock.
> -        *
> -        * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pa=
irs
> -        * with the smp_wmb() in kvm_mmu_invalidate_end().
> -        */
> -       mmu_seq =3D vcpu->kvm->mmu_invalidate_seq;
> -       mmap_read_unlock(current->mm);
> -
>         pfn =3D faultin_pfn(kvm, memslot, gfn, write_fault, &writable, &p=
age, is_gmem);
>         if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
> +               // TODO: Handle gmem properly. vma_shift
> +               // intentionally left uninitialized.
>                 kvm_send_hwpoison_signal(hva, vma_shift);
>                 return 0;
>         }
> @@ -1658,9 +1654,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
>         if (kvm_is_device_pfn(pfn)) {
>                 /*
>                  * If the page was identified as device early by looking =
at
> -                * the VMA flags, vma_pagesize is already representing th=
e
> +                * the VMA flags, target_size is already representing the
>                  * largest quantity we can map.  If instead it was mapped
> -                * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_S=
IZE
> +                * via __kvm_faultin_pfn(), target_size is set to PAGE_SI=
ZE
>                  * and must not be upgraded.
>                  *
>                  * In both cases, we don't let transparent_hugepage_adjus=
t()
> @@ -1699,7 +1695,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
>
>         kvm_fault_lock(kvm);
>         pgt =3D vcpu->arch.hw_mmu->pgt;
> -       if (mmu_invalidate_retry(kvm, mmu_seq)) {
> +       if (!is_gmem && mmu_invalidate_retry(kvm, mmu_seq)) {
>                 ret =3D -EAGAIN;
>                 goto out_unlock;
>         }
> @@ -1708,16 +1704,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
>          * If we are not forced to use page mapping, check if we are
>          * backed by a THP and thus use block mapping if possible.
>          */
> -       if (vma_pagesize =3D=3D PAGE_SIZE && !(force_pte || device)) {
> +       if (target_size =3D=3D PAGE_SIZE && !(force_pte || device)) {
>                 if (fault_is_perm && fault_granule > PAGE_SIZE)
> -                       vma_pagesize =3D fault_granule;
> -               else
> -                       vma_pagesize =3D transparent_hugepage_adjust(kvm,=
 memslot,
> +                       target_size =3D fault_granule;
> +               else if (!is_gmem)
> +                       target_size =3D transparent_hugepage_adjust(kvm, =
memslot,
>                                                                    hva, &=
pfn,
>                                                                    &fault=
_ipa);
>
> -               if (vma_pagesize < 0) {
> -                       ret =3D vma_pagesize;
> +               if (target_size < 0) {
> +                       ret =3D target_size;
>                         goto out_unlock;
>                 }
>         }
> @@ -1725,7 +1721,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
>         if (!fault_is_perm && !device && kvm_has_mte(kvm)) {
>                 /* Check the VMM hasn't introduced a new disallowed VMA *=
/
>                 if (mte_allowed) {
> -                       sanitise_mte_tags(kvm, pfn, vma_pagesize);
> +                       sanitise_mte_tags(kvm, pfn, target_size);
>                 } else {
>                         ret =3D -EFAULT;
>                         goto out_unlock;
> @@ -1750,10 +1746,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
>
>         /*
>          * Under the premise of getting a FSC_PERM fault, we just need to=
 relax
> -        * permissions only if vma_pagesize equals fault_granule. Otherwi=
se,
> +        * permissions only if target_size equals fault_granule. Otherwis=
e,
>          * kvm_pgtable_stage2_map() should be called to change block size=
.
>          */
> -       if (fault_is_perm && vma_pagesize =3D=3D fault_granule) {
> +       if (fault_is_perm && target_size =3D=3D fault_granule) {
>                 /*
>                  * Drop the SW bits in favour of those stored in the
>                  * PTE, which will be preserved.
> @@ -1761,7 +1757,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
>                 prot &=3D ~KVM_NV_GUEST_MAP_SZ;
>                 ret =3D KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, f=
ault_ipa, prot, flags);
>         } else {
> -               ret =3D KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa=
, vma_pagesize,
> +               ret =3D KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa=
, target_size,
>                                              __pfn_to_phys(pfn), prot,
>                                              memcache, flags);
>         }

