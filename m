Return-Path: <kvm+bounces-57729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03BCBB59997
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:24:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9D8C47A6115
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 14:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 373B934DCFD;
	Tue, 16 Sep 2025 14:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ACzDMlAX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBCE33EB10
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 14:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032506; cv=none; b=HllWgaVyqvjJ/grHUmQHnNOrFRndrgp8SwHL6n8rejznKiSpx4wRyWEn2s2sbivt7UrB/X2GJUBoueY9pMp5W5ueYZR1H8tUX62kQzLkO9AUwFHL6o/GFjVJonntFkY96/pye8PWbntmTla2hjBF6veb0drBmf5Mvm/JY/HlaPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032506; c=relaxed/simple;
	bh=ray1UKiyPbgXvTNDicyLGBP9nDXkwfraFKcSiCu0wws=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MzjmbyHUREjs4zWkl2WEq8Dw09YTdlG9deevpKlbgFLV+Nv0QU6J+73MdfnXM1JpMZCmyGa7ttI+tl+ttdIWO4WNCeyeK5cu0bMUV3IPE8jdvLiBTrB5r0++e2udAo7wIG232Usre/ygcZ511e0igie7ArvXGNJHKwkg/nVUq1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ACzDMlAX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B20C4CEEB
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 14:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758032505;
	bh=ray1UKiyPbgXvTNDicyLGBP9nDXkwfraFKcSiCu0wws=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ACzDMlAX/I/GbBxi4nvvMPoP+KlRCkTCm9oG0IEdVxGHd0sx1CAI4DsRmxwv+dATE
	 SNc20ol05gB3adf7HtdpiDRifmDKsHsUJ/RIkCbHnkXUmTNUFLTXtDDNZ0U1N8pg9E
	 vXT8aH9yeFw08mkd4j+huwdU9U1gp77ZaHtZIqkuigxBcWm7uMkwW6kcXgf2wOLTTM
	 vUqFCcjg8VwO7cp/FAi0tcxc3TIVA1Ec0gCTAYeLgRv02Z/TCKVoJZjpbLKZMaPXgq
	 5AggehCs9gzTexvL7w4NCThEOOwuSU/11WBptfUOhN5ZmMxjNScKIhNTF4/boyVFtY
	 ZJRgoSkMOB/9g==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b07dac96d1eso547473066b.1
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 07:21:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU7ve1YHeHEQSZwUB3CHJtYmwtv55p4Wq69grqRybIJEVWAiK2MVxQdG0b2AKmYOaof+fg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyVk3jHpbkUzyMk8Kgv7HNMgRmYzNqPknjaAre+u7sZVN2Jcqi
	8J2IZphZYOm5T01tleudhizrDa63Z4Y5vIQs5KfvpbU5vfFnuMP5JzGGBkVMIDMoYwt5FbovpQY
	98oKLNRR2GrUuD9TPHOhFHpp4znDDZSU=
X-Google-Smtp-Source: AGHT+IGHpR5vO10txzr9xVjlPtN6C+dRi4b6nQcxkADnj7HI6xGL9E0zy87frj9XIKcjrQGmNmmCQDRqD82GTOoJ+5Y=
X-Received: by 2002:a17:907:3ea6:b0:b04:3b97:f972 with SMTP id
 a640c23a62f3a-b167ea60331mr320215866b.3.1758032504338; Tue, 16 Sep 2025
 07:21:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250910071429.3925025-1-maobibo@loongson.cn> <CAAhV-H65H_iREuETGU_v9oZdaPFoQj1VZV46XSNTC8ppENXzuQ@mail.gmail.com>
 <3d3a72c2-7c91-7640-5f0b-7b95bd5f0d2e@loongson.cn>
In-Reply-To: <3d3a72c2-7c91-7640-5f0b-7b95bd5f0d2e@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 16 Sep 2025 22:21:32 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4bEyeV7WkfSNBJnicMhhnSwj3PEr9K4ZpXwto1=JyWUw@mail.gmail.com>
X-Gm-Features: AS18NWDS6Z8ZKdQIHmkKOLMlp3UpIhCas_PJFqvylvCCDT6rtDdFsFNHDfj4z88
Message-ID: <CAAhV-H4bEyeV7WkfSNBJnicMhhnSwj3PEr9K4ZpXwto1=JyWUw@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Fix VM migration failure with PTW enabled
To: Bibo Mao <maobibo@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2025 at 9:22=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/9/14 =E4=B8=8A=E5=8D=889:57, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Wed, Sep 10, 2025 at 3:14=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> With PTW disabled system, bit Dirty is HW bit for page writing, howeve=
r
> >> with PTW enabled system, bit Write is HW bit for page writing. Previou=
sly
> >> bit Write is treated as SW bit to record page writable attribute for f=
ast
> >> page fault handling in the secondary MMU, however with PTW enabled mac=
hine,
> >> this bit is used by HW already.
> >>
> >> Here define KVM_PAGE_SOFT_WRITE with SW bit _PAGE_MODIFIED, so that it=
 can
> >> work on both PTW disabled and enabled machines. And with HW write bit,=
 both
> >> bit Dirty and Write is set or clear.
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/include/asm/kvm_mmu.h | 20 ++++++++++++++++----
> >>   arch/loongarch/kvm/mmu.c             |  8 ++++----
> >>   2 files changed, 20 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/arch/loongarch/include/asm/kvm_mmu.h b/arch/loongarch/inc=
lude/asm/kvm_mmu.h
> >> index 099bafc6f797..efcd593c42b1 100644
> >> --- a/arch/loongarch/include/asm/kvm_mmu.h
> >> +++ b/arch/loongarch/include/asm/kvm_mmu.h
> >> @@ -16,6 +16,13 @@
> >>    */
> >>   #define KVM_MMU_CACHE_MIN_PAGES        (CONFIG_PGTABLE_LEVELS - 1)
> >>
> >> +/*
> >> + * _PAGE_MODIFIED is SW pte bit, it records page ever written on host
> >> + * kernel, on secondary MMU it records page writable in order to fast
> >> + * path handling
> >> + */
> >> +#define KVM_PAGE_SOFT_WRITE    _PAGE_MODIFIED
> > KVM_PAGE_WRITEABLE is more suitable.
> both are ok for me.
> >
> >> +
> >>   #define _KVM_FLUSH_PGTABLE     0x1
> >>   #define _KVM_HAS_PGMASK                0x2
> >>   #define kvm_pfn_pte(pfn, prot) (((pfn) << PFN_PTE_SHIFT) | pgprot_va=
l(prot))
> >> @@ -52,11 +59,16 @@ static inline void kvm_set_pte(kvm_pte_t *ptep, kv=
m_pte_t val)
> >>          WRITE_ONCE(*ptep, val);
> >>   }
> >>
> >> -static inline int kvm_pte_write(kvm_pte_t pte) { return pte & _PAGE_W=
RITE; }
> >> -static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte & _PAGE_D=
IRTY; }
> >> +static inline int kvm_pte_soft_write(kvm_pte_t pte) { return pte & KV=
M_PAGE_SOFT_WRITE; }
> > The same, kvm_pte_mkwriteable() is more suitable.
> kvm_pte_writable()  here ?  and kvm_pte_mkwriteable() for the bellowing
> sentense.
>
> If so, that is ok, both are ok for me.
Yes.

> >
> >> +static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte & __WRITE=
ABLE; }
> > _PAGE_DIRTY and _PAGE_WRITE are always set/cleared at the same time,
> > so the old version still works.
> Although it is workable, I still want to remove single bit _PAGE_DIRTY
> checking here.
I want to check a single bit because "kvm_pte_write() return
_PAGE_WRITE and kvm_pte_dirty() return _PAGE_DIRTY" looks more
natural.

You may argue that kvm_pte_mkdirty() set both _PAGE_WRITE and
_PAGE_DIRTY so kvm_pte_dirty() should also return both. But I think
kvm_pte_mkdirty() in this patch is just a "reasonable optimization".
Because strictly speaking, we need both kvm_pte_mkdirty() and
kvm_pte_mkwrite() and call the pair when needed.

Huacai

>
> Regards
> Bibo Mao
> >
> >>   static inline int kvm_pte_young(kvm_pte_t pte) { return pte & _PAGE_=
ACCESSED; }
> >>   static inline int kvm_pte_huge(kvm_pte_t pte) { return pte & _PAGE_H=
UGE; }
> >>
> >> +static inline kvm_pte_t kvm_pte_mksoft_write(kvm_pte_t pte)
> >> +{
> >> +       return pte | KVM_PAGE_SOFT_WRITE;
> >> +}
> >> +
> >>   static inline kvm_pte_t kvm_pte_mkyoung(kvm_pte_t pte)
> >>   {
> >>          return pte | _PAGE_ACCESSED;
> >> @@ -69,12 +81,12 @@ static inline kvm_pte_t kvm_pte_mkold(kvm_pte_t pt=
e)
> >>
> >>   static inline kvm_pte_t kvm_pte_mkdirty(kvm_pte_t pte)
> >>   {
> >> -       return pte | _PAGE_DIRTY;
> >> +       return pte | __WRITEABLE;
> >>   }
> >>
> >>   static inline kvm_pte_t kvm_pte_mkclean(kvm_pte_t pte)
> >>   {
> >> -       return pte & ~_PAGE_DIRTY;
> >> +       return pte & ~__WRITEABLE;
> >>   }
> >>
> >>   static inline kvm_pte_t kvm_pte_mkhuge(kvm_pte_t pte)
> >> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> >> index ed956c5cf2cc..68749069290f 100644
> >> --- a/arch/loongarch/kvm/mmu.c
> >> +++ b/arch/loongarch/kvm/mmu.c
> >> @@ -569,7 +569,7 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu=
, unsigned long gpa, bool writ
> >>          /* Track access to pages marked old */
> >>          new =3D kvm_pte_mkyoung(*ptep);
> >>          if (write && !kvm_pte_dirty(new)) {
> >> -               if (!kvm_pte_write(new)) {
> >> +               if (!kvm_pte_soft_write(new)) {
> >>                          ret =3D -EFAULT;
> >>                          goto out;
> >>                  }
> >> @@ -856,9 +856,9 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, uns=
igned long gpa, bool write)
> >>                  prot_bits |=3D _CACHE_SUC;
> >>
> >>          if (writeable) {
> >> -               prot_bits |=3D _PAGE_WRITE;
> >> +               prot_bits =3D kvm_pte_mksoft_write(prot_bits);
> >>                  if (write)
> >> -                       prot_bits |=3D __WRITEABLE;
> >> +                       prot_bits =3D kvm_pte_mkdirty(prot_bits);
> >>          }
> >>
> >>          /* Disable dirty logging on HugePages */
> >> @@ -904,7 +904,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, uns=
igned long gpa, bool write)
> >>          kvm_release_faultin_page(kvm, page, false, writeable);
> >>          spin_unlock(&kvm->mmu_lock);
> >>
> >> -       if (prot_bits & _PAGE_DIRTY)
> >> +       if (kvm_pte_dirty(prot_bits))
> >>                  mark_page_dirty_in_slot(kvm, memslot, gfn);
> >>
> >>   out:
> > To save time, I just change the whole patch like this, you can confirm
> > whether it woks:
> >
> > diff --git a/arch/loongarch/include/asm/kvm_mmu.h
> > b/arch/loongarch/include/asm/kvm_mmu.h
> > index 099bafc6f797..882f60c72b46 100644
> > --- a/arch/loongarch/include/asm/kvm_mmu.h
> > +++ b/arch/loongarch/include/asm/kvm_mmu.h
> > @@ -16,6 +16,13 @@
> >    */
> >   #define KVM_MMU_CACHE_MIN_PAGES        (CONFIG_PGTABLE_LEVELS - 1)
> >
> > +/*
> > + * _PAGE_MODIFIED is SW pte bit, it records page ever written on host
> > + * kernel, on secondary MMU it records page writable in order to fast
> > + * path handling
> > + */
> > +#define KVM_PAGE_WRITEABLE     _PAGE_MODIFIED
> > +
> >   #define _KVM_FLUSH_PGTABLE     0x1
> >   #define _KVM_HAS_PGMASK                0x2
> >   #define kvm_pfn_pte(pfn, prot) (((pfn) << PFN_PTE_SHIFT) |
> > pgprot_val(prot))
> > @@ -56,6 +63,7 @@ static inline int kvm_pte_write(kvm_pte_t pte) {
> > return pte & _PAGE_WRITE; }
> >   static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte &
> > _PAGE_DIRTY; }
> >   static inline int kvm_pte_young(kvm_pte_t pte) { return pte &
> > _PAGE_ACCESSED; }
> >   static inline int kvm_pte_huge(kvm_pte_t pte) { return pte &
> > _PAGE_HUGE; }
> > +static inline int kvm_pte_writeable(kvm_pte_t pte) { return pte &
> > KVM_PAGE_WRITEABLE; }
> >
> >   static inline kvm_pte_t kvm_pte_mkyoung(kvm_pte_t pte)
> >   {
> > @@ -69,12 +77,12 @@ static inline kvm_pte_t kvm_pte_mkold(kvm_pte_t
> > pte)
> >
> >   static inline kvm_pte_t kvm_pte_mkdirty(kvm_pte_t pte)
> >   {
> > -       return pte | _PAGE_DIRTY;
> > +       return pte | __WRITEABLE;
> >   }
> >
> >   static inline kvm_pte_t kvm_pte_mkclean(kvm_pte_t pte)
> >   {
> > -       return pte & ~_PAGE_DIRTY;
> > +       return pte & ~__WRITEABLE;
> >   }
> >
> >   static inline kvm_pte_t kvm_pte_mkhuge(kvm_pte_t pte)
> > @@ -87,6 +95,11 @@ static inline kvm_pte_t kvm_pte_mksmall(kvm_pte_t
> > pte)
> >          return pte & ~_PAGE_HUGE;
> >   }
> >
> > +static inline kvm_pte_t kvm_pte_mkwriteable(kvm_pte_t pte)
> > +{
> > +       return pte | KVM_PAGE_WRITEABLE;
> > +}
> > +
> >   static inline int kvm_need_flush(kvm_ptw_ctx *ctx)
> >   {
> >          return ctx->flag & _KVM_FLUSH_PGTABLE;
> > diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> > index ed956c5cf2cc..7c8143e79c12 100644
> > --- a/arch/loongarch/kvm/mmu.c
> > +++ b/arch/loongarch/kvm/mmu.c
> > @@ -569,7 +569,7 @@ static int kvm_map_page_fast(struct kvm_vcpu
> > *vcpu, unsigned long gpa, bool writ
> >          /* Track access to pages marked old */
> >          new =3D kvm_pte_mkyoung(*ptep);
> >          if (write && !kvm_pte_dirty(new)) {
> > -               if (!kvm_pte_write(new)) {
> > +               if (!kvm_pte_writeable(new)) {
> >                          ret =3D -EFAULT;
> >                          goto out;
> >                  }
> > @@ -856,9 +856,9 @@ static int kvm_map_page(struct kvm_vcpu *vcpu,
> > unsigned long gpa, bool write)
> >                  prot_bits |=3D _CACHE_SUC;
> >
> >          if (writeable) {
> > -               prot_bits |=3D _PAGE_WRITE;
> > +               prot_bits =3D kvm_pte_mkwriteable(prot_bits);
> >                  if (write)
> > -                       prot_bits |=3D __WRITEABLE;
> > +                       prot_bits =3D kvm_pte_mkdirty(prot_bits);
> >          }
> >
> >          /* Disable dirty logging on HugePages */
> > @@ -904,7 +904,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu,
> > unsigned long gpa, bool write)
> >          kvm_release_faultin_page(kvm, page, false, writeable);
> >          spin_unlock(&kvm->mmu_lock);
> >
> > -       if (prot_bits & _PAGE_DIRTY)
> > +       if (kvm_pte_dirty(prot_bits))
> >                  mark_page_dirty_in_slot(kvm, memslot, gfn);
> >
> >   out:
> >
> > Huacai
> >
> >>
> >> base-commit: 9dd1835ecda5b96ac88c166f4a87386f3e727bd9
> >> --
> >> 2.39.3
> >>
> >>
>

