Return-Path: <kvm+bounces-46674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 905EAAB8293
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 11:28:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 743F31BA192C
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 09:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0C29297A57;
	Thu, 15 May 2025 09:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uTEToiTa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AC4297A46
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 09:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747301262; cv=none; b=jdonPKEXN8h8Tu+RsK5keYzjR4Z5xgHwADqDKm0jPTmn5fMJn/bXFNaZPRzvk8bNy9YT4dhomGvYoa9vkjqlkcVqyPvnupschCkjDEkuIlIlC1+CWX974E3xIbPgCHRDGwGpoMuG/NRinqYzpJ+bWQzvSmawkCkRhLlBQgQLpGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747301262; c=relaxed/simple;
	bh=VrP32xg2Du2kc1boSBnqnBfn7U1rh2NfrZijQ/lFDdU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gDxgCQrFfNzSpjCRd8ssmh4YcD2YayJ/g4SsGYTlFjjFrJP/CZZzMOaQH4qxGLJdoulo/WOTeFzi6NUi8JZGUms32VleYwEzZJroPupnH9v5plxcyyJi5nNaBnPMDJZV85DkjUNL39ryt2PRvWK8HwqkAEuzFsZbOo0+dJL+Xoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uTEToiTa; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-47e9fea29easo244931cf.1
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 02:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747301259; x=1747906059; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vLVWrpXHwyZFM5AS7GCsykQ+QWDj2ywEXacPF0HLVGE=;
        b=uTEToiTa/+ZZbzvYL4Fp/bLuZTJjJQiCT5bnMhaAXnQmxKluAUhU6FtDv2aTekJA17
         rnKS89a0Lncj1at6PrOap8hXs30JfZo/9QJ5Eh9vsbCavbJLGgWDhGewaJTPcZYUel62
         6d3PbAvHC5o2z6GNdrGUn3H81p9v76JmIG3LHH6OQsAfCuQfrb9+Z7UbqvsLoVWGe2xJ
         RDLhYlGHIt2WD4FMMXrHss0Pg8ExJeYlECyxh3TDXxjntqu4x1g5ZGaVVoUk8l7UQV+y
         ibtkOcGB0cW6eE5LccA6ZuFP8+1yeLzxD0/AC2dm0f4Qu9I50WOCI8jT7gU4ovcbAWeq
         mfMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747301259; x=1747906059;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vLVWrpXHwyZFM5AS7GCsykQ+QWDj2ywEXacPF0HLVGE=;
        b=Cnkv1PfbxWL8j08P2eJJtQa/rByzLOf9cZRfHYONu8kKPfg2yEzYLosgx1P/Y9G0zm
         vh/eDx19zWOeBDbXglpeanubtrOMQdtC0RHQ8MpENn5wmcHHKMFjy584kdI5r4gszMj6
         lp9T6gPNILyxoe90QGqT06Knqry8ddTSTEQD86BrbPoFKy3ZWEjpsJQt760ZY+k/CkLw
         etdTlDqCsObGd0tXlSTipdUpK1xVTku6bEQ5GeP61b4dLsMIMTXiUhW7xXVIkQJvZUn/
         c1s+HWSdGgzNuyvKHZafWWQEsSnLsKulZ+51FYoh90MI8cqBZUmeiWcWdq+bea6shxJC
         Mezw==
X-Forwarded-Encrypted: i=1; AJvYcCWd1fIu+CnBGKWGu2K1HZxziFvgZYMrKn8uj/3p9VgQx72mIWUGqMRJ4OOTY6nfgYB7Lrs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnsOwni0t9CQKA4HmMTx0gNJuOhKzOSfdjCgg7la+4aaAKQrvN
	CQp8vg3B/bDsxrDVrevFS6F7U6RQdyzJDtBMF1+3OalF88rAh6hn5C80unZsJCzdR59RZ6DLOx8
	M6dkJEN+MbFyotyWCDWIRKc32ISNlSiAY3lhODwdnmBRPLmZ5ssNYj9QSxNvp7w==
X-Gm-Gg: ASbGnct4PddVxj7PCAJi3fj4DyyG414F98R8jdr4K9bCMMqAx1TQHhqR63vD5kTaOlm
	BjGWzpypxbltaKNTws9bzuh6XpGVHGJKmQ1Ct70acgSDJl86uUnHS0nCyxyWyniGRItbhqrgc6V
	LDrZJSTNSq1MvObkfzlcUk9OFBOXC0NKoWkjauqjjisHtyi+Z/4SBu5XcKG24G
X-Google-Smtp-Source: AGHT+IEY3Xzc7fr4+j+8c7Xmzn1ASJ0g0PGM20FPE+6j6dnC/T4ZD4yfgoiNZfuCxktxFtJP7fxNgol2XsmKPY/V9Ak=
X-Received: by 2002:ac8:5a0f:0:b0:494:763e:d971 with SMTP id
 d75a77b69052e-494a339efa1mr2170171cf.23.1747301259016; Thu, 15 May 2025
 02:27:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513163438.3942405-14-tabba@google.com> <20250514212653.1011484-1-jthoughton@google.com>
In-Reply-To: <20250514212653.1011484-1-jthoughton@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 15 May 2025 11:27:02 +0200
X-Gm-Features: AX0GCFtxdi9w1pFV0otXB7lxTAtPlqLdBKg0KJODZ4v7UKNCvRCSP9F597nrSVg
Message-ID: <CA+EHjTy1UoOXDKbH-9DgE_ULGBp9OtWb5R8aK1DWvgu8ECrMsA@mail.gmail.com>
Subject: Re: [PATCH v9 13/17] KVM: arm64: Handle guest_memfd()-backed guest
 page faults
To: James Houghton <jthoughton@google.com>
Cc: ackerleytng@google.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anup@brainfault.org, aou@eecs.berkeley.edu, brauner@kernel.org, 
	catalin.marinas@arm.com, chao.p.peng@linux.intel.com, chenhuacai@kernel.org, 
	david@redhat.com, dmatlack@google.com, fvdl@google.com, hch@infradead.org, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@gmail.com, 
	isaku.yamahata@intel.com, james.morse@arm.com, jarkko@kernel.org, 
	jgg@nvidia.com, jhubbard@nvidia.com, keirf@google.com, 
	kirill.shutemov@linux.intel.com, kvm@vger.kernel.org, liam.merwick@oracle.com, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, mail@maciej.szmigiero.name, 
	maz@kernel.org, mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	qperret@google.com, quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
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

On Wed, 14 May 2025 at 23:26, James Houghton <jthoughton@google.com> wrote:
>
> On Tue, May 13, 2025 at 9:35=E2=80=AFAM Fuad Tabba <tabba@google.com> wro=
te:
> >
> > Add arm64 support for handling guest page faults on guest_memfd
> > backed memslots.
> >
> > For now, the fault granule is restricted to PAGE_SIZE.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c     | 94 +++++++++++++++++++++++++---------------
> >  include/linux/kvm_host.h |  5 +++
> >  virt/kvm/kvm_main.c      |  5 ---
> >  3 files changed, 64 insertions(+), 40 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index d756c2b5913f..9a48ef08491d 100644
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
>
> I don't think the above handling for the `ret !=3D 0` case is correct. I =
think
> we should just be returning `ret` out to userspace.

Ack.

>
> The diff I have below is closer to what I think we must do.
>
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
> > -       short page_shift;
> > +       struct vm_area_struct *vma =3D NULL;
> > +       short page_shift =3D PAGE_SHIFT;
> >         void *memcache;
> > -       gfn_t gfn;
> > +       gfn_t gfn =3D ipa >> PAGE_SHIFT;
> >         kvm_pfn_t pfn;
> >         bool logging_active =3D memslot_is_logging(memslot);
> > -       bool force_pte =3D logging_active || is_protected_kvm_enabled()=
;
> > -       long page_size, fault_granule;
> > +       bool is_gmem =3D kvm_slot_has_gmem(memslot);
> > +       bool force_pte =3D logging_active || is_gmem || is_protected_kv=
m_enabled();
> > +       long page_size, fault_granule =3D PAGE_SIZE;
> >         enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PROT_R;
> >         struct kvm_pgtable *pgt;
> >         struct page *page;
> > @@ -1529,17 +1554,20 @@ static int user_mem_abort(struct kvm_vcpu *vcpu=
, phys_addr_t fault_ipa,
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
> > +               mmap_read_lock(current->mm);
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
> > -       if (force_pte)
> > -               page_shift =3D PAGE_SHIFT;
> > -       else
> > +       if (!force_pte)
> >                 page_shift =3D get_vma_page_shift(vma, hva);
> >
> >         switch (page_shift) {
> > @@ -1605,27 +1633,23 @@ static int user_mem_abort(struct kvm_vcpu *vcpu=
, phys_addr_t fault_ipa,
> >                 ipa &=3D ~(page_size - 1);
> >         }
> >
> > -       gfn =3D ipa >> PAGE_SHIFT;
> > -       mte_allowed =3D kvm_vma_mte_allowed(vma);
> > -
> > -       vfio_allow_any_uc =3D vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> > -
> > -       /* Don't use the VMA after the unlock -- it may have vanished *=
/
> > -       vma =3D NULL;
> > +       if (!is_gmem) {
> > +               /* Don't use the VMA after the unlock -- it may have va=
nished */
> > +               vma =3D NULL;
>
> I think we can just move the vma declaration inside the earlier `if (is_g=
mem)`
> bit above. It should be really hard to accidentally attempt to use `vma` =
or
> `hva` in the is_gmem case. `vma` we can easily make it impossible; `hva` =
is
> harder.

To be honest, I think we need to refactor user_mem_abort(). It's
already a bit messy, and with the guest_memfd code, and in the
(hopefully) soon, pkvm code, it's going to get messier. Some of the
things things to keep in mind are, like you suggest, ensuring that vma
and hva aren't in scope where they're not needed.

>
> See below for what I think this should look like.
>
> >
> > -       /*
> > -        * Read mmu_invalidate_seq so that KVM can detect if the result=
s of
> > -        * vma_lookup() or __kvm_faultin_pfn() become stale prior to
> > -        * acquiring kvm->mmu_lock.
> > -        *
> > -        * Rely on mmap_read_unlock() for an implicit smp_rmb(), which =
pairs
> > -        * with the smp_wmb() in kvm_mmu_invalidate_end().
> > -        */
> > -       mmu_seq =3D vcpu->kvm->mmu_invalidate_seq;
> > -       mmap_read_unlock(current->mm);
> > +               /*
> > +                * Read mmu_invalidate_seq so that KVM can detect if th=
e results
> > +                * of vma_lookup() or faultin_pfn() become stale prior =
to
> > +                * acquiring kvm->mmu_lock.
> > +                *
> > +                * Rely on mmap_read_unlock() for an implicit smp_rmb()=
, which
> > +                * pairs with the smp_wmb() in kvm_mmu_invalidate_end()=
.
> > +                */
> > +               mmu_seq =3D vcpu->kvm->mmu_invalidate_seq;
> > +               mmap_read_unlock(current->mm);
> > +       }
> >
> > -       pfn =3D __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRIT=
E : 0,
> > -                               &writable, &page);
> > +       pfn =3D faultin_pfn(kvm, memslot, gfn, write_fault, &writable, =
&page, is_gmem);
> >         if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
> >                 kvm_send_hwpoison_signal(hva, page_shift);
>
> `hva` is used here even for the is_gmem case, and that should be slightly
> concerning. And indeed it is, this is not the appropriate way to handle
> hwpoison for gmem (and it is different than the behavior you have for x86=
). x86
> handles this by returning a KVM_MEMORY_FAULT_EXIT to userspace; we should=
 do
> the same.

You're right. My initial thought was that by having a best-effort
check that that would be enough, and not change the arm64 behavior all
that much. Exiting to userspace is cleaner.

> I've put what I think is more appropriate in the diff below.
>
> And just to be clear, IMO, we *cannot* do what you have written now, espe=
cially
> given that we are getting rid of the userspace_addr sanity check (but tha=
t
> check was best-effort anyway).
>
> >                 return 0;
> > @@ -1677,7 +1701,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
> >
> >         kvm_fault_lock(kvm);
> >         pgt =3D vcpu->arch.hw_mmu->pgt;
> > -       if (mmu_invalidate_retry(kvm, mmu_seq)) {
> > +       if (!is_gmem && mmu_invalidate_retry(kvm, mmu_seq)) {
> >                 ret =3D -EAGAIN;
> >                 goto out_unlock;
> >         }
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index f9bb025327c3..b317392453a5 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1884,6 +1884,11 @@ static inline int memslot_id(struct kvm *kvm, gf=
n_t gfn)
> >         return gfn_to_memslot(kvm, gfn)->id;
> >  }
> >
> > +static inline bool memslot_is_readonly(const struct kvm_memory_slot *s=
lot)
> > +{
> > +       return slot->flags & KVM_MEM_READONLY;
> > +}
>
> I think if you're going to move this helper to include/linux/kvm_host.h, =
you
> might want to do so in its own patch and change all of the existing place=
s
> where we check KVM_MEM_READONLY directly. *shrug*

It's a tough job, but someone's gotta do it :)

>
> > +
> >  static inline gfn_t
> >  hva_to_gfn_memslot(unsigned long hva, struct kvm_memory_slot *slot)
> >  {
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 6289ea1685dd..6261d8638cd2 100644
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
> > 2.49.0.1045.g170613ef41-goog
> >
>
> Alright, here's the diff I have in mind:

Thank you James.

Cheers,
/fuad


>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9a48ef08491db..74eae19792373 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1466,28 +1466,30 @@ static bool kvm_vma_mte_allowed(struct vm_area_st=
ruct *vma)
>         return vma->vm_flags & VM_MTE_ALLOWED;
>  }
>
> -static kvm_pfn_t faultin_pfn(struct kvm *kvm, struct kvm_memory_slot *sl=
ot,
> -                            gfn_t gfn, bool write_fault, bool *writable,
> -                            struct page **page, bool is_gmem)
> +static kvm_pfn_t faultin_pfn(struct kvm *kvm, struct kvm_vcpu *vcpu,
> +                            struct kvm_memory_slot *slot, gfn_t gfn,
> +                            bool exec_fault, bool write_fault, bool *wri=
table,
> +                            struct page **page, bool is_gmem, kvm_pfn_t =
*pfn)
>  {
> -       kvm_pfn_t pfn;
>         int ret;
>
> -       if (!is_gmem)
> -               return __kvm_faultin_pfn(slot, gfn, write_fault ? FOLL_WR=
ITE : 0, writable, page);
> +       if (!is_gmem) {
> +               *pfn =3D __kvm_faultin_pfn(slot, gfn, write_fault ? FOLL_=
WRITE : 0, writable, page);
> +               return 0;
> +       }
>
>         *writable =3D false;
>
> -       ret =3D kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, page, NULL);
> -       if (!ret) {
> -               *writable =3D !memslot_is_readonly(slot);
> -               return pfn;
> +       ret =3D kvm_gmem_get_pfn(kvm, slot, gfn, pfn, page, NULL);
> +       if (ret) {
> +               kvm_prepare_memory_fault_exit(vcpu, gfn << PAGE_SHIFT,
> +                                             PAGE_SIZE, write_fault,
> +                                             exec_fault, false);
> +               return ret;
>         }
>
> -       if (ret =3D=3D -EHWPOISON)
> -               return KVM_PFN_ERR_HWPOISON;
> -
> -       return KVM_PFN_ERR_NOSLOT_MASK;
> +       *writable =3D !memslot_is_readonly(slot);
> +       return 0;
>  }
>
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> @@ -1502,7 +1504,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
>         unsigned long mmu_seq;
>         phys_addr_t ipa =3D fault_ipa;
>         struct kvm *kvm =3D vcpu->kvm;
> -       struct vm_area_struct *vma =3D NULL;
>         short page_shift =3D PAGE_SHIFT;
>         void *memcache;
>         gfn_t gfn =3D ipa >> PAGE_SHIFT;
> @@ -1555,6 +1556,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, ph=
ys_addr_t fault_ipa,
>          * get block mapping for device MMIO region.
>          */
>         if (!is_gmem) {
> +               struct vm_area_struct *vma =3D NULL;
> +
>                 mmap_read_lock(current->mm);
>                 vma =3D vma_lookup(current->mm, hva);
>                 if (unlikely(!vma)) {
> @@ -1565,33 +1568,44 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
>
>                 vfio_allow_any_uc =3D vma->vm_flags & VM_ALLOW_ANY_UNCACH=
ED;
>                 mte_allowed =3D kvm_vma_mte_allowed(vma);
> -       }
>
> -       if (!force_pte)
> -               page_shift =3D get_vma_page_shift(vma, hva);
> +               if (!force_pte)
> +                       page_shift =3D get_vma_page_shift(vma, hva);
> +
> +               /*
> +                * Read mmu_invalidate_seq so that KVM can detect if the =
results
> +                * of vma_lookup() or faultin_pfn() become stale prior to
> +                * acquiring kvm->mmu_lock.
> +                *
> +                * Rely on mmap_read_unlock() for an implicit smp_rmb(), =
which
> +                * pairs with the smp_wmb() in kvm_mmu_invalidate_end().
> +                */
> +               mmu_seq =3D vcpu->kvm->mmu_invalidate_seq;
> +               mmap_read_unlock(current->mm);
>
> -       switch (page_shift) {
> +               switch (page_shift) {
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
> -               page_shift =3D PMD_SHIFT;
> -               fallthrough;
> -       case PMD_SHIFT:
> -               if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_=
SIZE))
> +               case CONT_PMD_SHIFT:
> +                       page_shift =3D PMD_SHIFT;
> +                       fallthrough;
> +               case PMD_SHIFT:
> +                       if (fault_supports_stage2_huge_mapping(memslot, h=
va, PMD_SIZE))
> +                               break;
> +                       fallthrough;
> +               case CONT_PTE_SHIFT:
> +                       page_shift =3D PAGE_SHIFT;
> +                       force_pte =3D true;
> +                       fallthrough;
> +               case PAGE_SHIFT:
>                         break;
> -               fallthrough;
> -       case CONT_PTE_SHIFT:
> -               page_shift =3D PAGE_SHIFT;
> -               force_pte =3D true;
> -               fallthrough;
> -       case PAGE_SHIFT:
> -               break;
> -       default:
> -               WARN_ONCE(1, "Unknown page_shift %d", page_shift);
> +               default:
> +                       WARN_ONCE(1, "Unknown page_shift %d", page_shift)=
;
> +               }
>         }
>
>         page_size =3D 1UL << page_shift;
> @@ -1633,24 +1647,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
>                 ipa &=3D ~(page_size - 1);
>         }
>
> -       if (!is_gmem) {
> -               /* Don't use the VMA after the unlock -- it may have vani=
shed */
> -               vma =3D NULL;
> -
> +       ret =3D faultin_pfn(kvm, vcpu, memslot, gfn, exec_fault, write_fa=
ult,
> +                         &writable, &page, is_gmem, &pfn);
> +       if (ret)
> +               return ret;
> +       if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
>                 /*
> -                * Read mmu_invalidate_seq so that KVM can detect if the =
results
> -                * of vma_lookup() or faultin_pfn() become stale prior to
> -                * acquiring kvm->mmu_lock.
> -                *
> -                * Rely on mmap_read_unlock() for an implicit smp_rmb(), =
which
> -                * pairs with the smp_wmb() in kvm_mmu_invalidate_end().
> +                * For gmem, hwpoison should be communicated via a memory=
 fault
> +                * exit, not via a SIGBUS.
>                  */
> -               mmu_seq =3D vcpu->kvm->mmu_invalidate_seq;
> -               mmap_read_unlock(current->mm);
> -       }
> -
> -       pfn =3D faultin_pfn(kvm, memslot, gfn, write_fault, &writable, &p=
age, is_gmem);
> -       if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
> +               WARN_ON_ONCE(is_gmem);
>                 kvm_send_hwpoison_signal(hva, page_shift);
>                 return 0;
>         }

