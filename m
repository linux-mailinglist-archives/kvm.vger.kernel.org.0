Return-Path: <kvm+bounces-20356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4E38914102
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 06:19:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F3F51F2295A
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 04:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6799E1094E;
	Mon, 24 Jun 2024 04:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uK/ch/sc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F97DE567;
	Mon, 24 Jun 2024 04:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719202723; cv=none; b=rMGNNIVrCeNMNtVyj9XWscBASq3UJwxlxRnuZKtZVzlZAffPrjfu9xfzFtW3tAf5HUkrTpa462gvtIzBe1oA3Tw6/HpR5RzGruUYNGHuOHS6yVQE0WJ4BPwsWULIQk1eY77J3OWQRyM6qmUCtS76QYP6bc0VGaWjc3mcZVCbYIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719202723; c=relaxed/simple;
	bh=5rXzE8ih5BA7NWoCgOpp0uj7Iq8n+pzj/uDSZFRNswo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J+yl3HKrDag5hMSHbRE+6gmwvwvGl4ln6KEn5oTeqmoR3F9jDljUOS4C5tzb6MK2BnCdqTNZzEPRv8dUS/Xp2mpYB7zblt8MbjD+4i92f4BRx3+idtip7UyR6mmO6ditXIpc0pp6wNNTXu7neqX4GCbtwHkD6qB7C0k1psSjie4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uK/ch/sc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F388C4AF0D;
	Mon, 24 Jun 2024 04:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719202723;
	bh=5rXzE8ih5BA7NWoCgOpp0uj7Iq8n+pzj/uDSZFRNswo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uK/ch/scz9GSiBmU53r1ZNSJpgNXv2pwqj4LX5OlLQOinbtOD2q4sWq7DsHv0UoPb
	 G3pkMs/r6edipR+duY+lOfUqhJJ/sqto57IXuLi9ELlFX1FUdLOzHnAC4xWAIkoa4H
	 NgBp/3+s4V2/HY05ZTsVUTiuoh7D/3PpnOJaomP7mSP2XTPCoivJHU+eXloI/zlgN/
	 LG7zIJ4VitbYGcaxvPu+Iobog4iSCCj/VXdPrJzaLhtBSLQfBFOvZNrShMvQRJZvPg
	 0rtuZ/l0d5k/JgubWkj7cwDzuqo7qbESnr6dmIhuMSTdwOuNXQmTLzP2rYEs8HnDqd
	 qjSKA2rxVnJVA==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a724cd0e9c2so73403566b.3;
        Sun, 23 Jun 2024 21:18:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXxTz4HhICs0cY5AeR2odj2mZc71mytvZYRbEbJJiaVhjBsWODmF33CZEbvP7IzJOhF2GwMHQvEUpapGJxsN5zl5BClM7s4wqlUY+dVtjL4OxGpV3mRO4huJIYkqMh7+k2A
X-Gm-Message-State: AOJu0YzxIllLONBakW4jbUbi7M1psedNso4qFnwYq9F4V5m2jfMG7ggd
	IWBC3mXWQqCmz9mK2j71wm6gUUTR4GdGVUoZ7hfEqOk35il7wUi8gcLBOOk4D2diNycbdzv3nMI
	l10aVHwtUmcWn0qRGYdSIGAahsZU=
X-Google-Smtp-Source: AGHT+IHOYd9vVz4URvPOIF6LmQYV/+/OcNmrlh+9T34LxUCw4pN755B5CO++mGlud2aikWtJEn01ZJqR4IH+EJUGKwQ=
X-Received: by 2002:a17:907:c815:b0:a72:5226:3307 with SMTP id
 a640c23a62f3a-a7252263ff9mr121771866b.57.1719202721607; Sun, 23 Jun 2024
 21:18:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240619080940.2690756-1-maobibo@loongson.cn> <20240619080940.2690756-5-maobibo@loongson.cn>
 <CAAhV-H74raJ9eEWEHr=aN6LhVvNUyP6TLEDH006M6AnoE8tkPg@mail.gmail.com>
 <58d34b7d-eaad-8aa8-46c3-9212664431be@loongson.cn> <CAAhV-H6CzPAxwymk16NfjPGO=oi+iBZJYsdSMiyp2N2cDsw54g@mail.gmail.com>
 <379d63cc-375f-3e97-006c-edf7edb4b202@loongson.cn>
In-Reply-To: <379d63cc-375f-3e97-006c-edf7edb4b202@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 24 Jun 2024 12:18:29 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6vXMr5bviGoE1pojVswOkUWBkv9hOS4Jd-6Exb+G+1+g@mail.gmail.com>
Message-ID: <CAAhV-H6vXMr5bviGoE1pojVswOkUWBkv9hOS4Jd-6Exb+G+1+g@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] LoongArch: KVM: Add memory barrier before update
 pmd entry
To: maobibo <maobibo@loongson.cn>, Rui Wang <wangrui@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, 
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 24, 2024 at 10:21=E2=80=AFAM maobibo <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2024/6/24 =E4=B8=8A=E5=8D=889:56, Huacai Chen wrote:
> > On Mon, Jun 24, 2024 at 9:37=E2=80=AFAM maobibo <maobibo@loongson.cn> w=
rote:
> >>
> >>
> >>
> >> On 2024/6/23 =E4=B8=8B=E5=8D=886:18, Huacai Chen wrote:
> >>> Hi, Bibo,
> >>>
> >>> On Wed, Jun 19, 2024 at 4:09=E2=80=AFPM Bibo Mao <maobibo@loongson.cn=
> wrote:
> >>>>
> >>>> When updating pmd entry such as allocating new pmd page or splitting
> >>>> huge page into normal page, it is necessary to firstly update all pt=
e
> >>>> entries, and then update pmd entry.
> >>>>
> >>>> It is weak order with LoongArch system, there will be problem if oth=
er
> >>>> vcpus sees pmd update firstly however pte is not updated. Here smp_w=
mb()
> >>>> is added to assure this.
> >>> Memory barriers should be in pairs in most cases. That means you may
> >>> lose smp_rmb() in another place.
> >> The idea adding smp_wmb() comes from function __split_huge_pmd_locked(=
)
> >> in file mm/huge_memory.c, and the explanation is reasonable.
> >>
> >>                   ...
> >>                   set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);
> >>           }
> >>           ...
> >>           smp_wmb(); /* make pte visible before pmd */
> >>           pmd_populate(mm, pmd, pgtable);
> >>
> >> It is strange that why smp_rmb() should be in pairs with smp_wmb(),
> >> I never hear this rule -:(
> > https://docs.kernel.org/core-api/wrappers/memory-barriers.html
> >
> > SMP BARRIER PAIRING
> > -------------------
> >
> > When dealing with CPU-CPU interactions, certain types of memory barrier=
 should
> > always be paired.  A lack of appropriate pairing is almost certainly an=
 error.
>     CPU 1                 CPU 2
>          =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D       =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>          WRITE_ONCE(a, 1);
>          <write barrier>
>          WRITE_ONCE(b, 2);     x =3D READ_ONCE(b);
>                                <read barrier>
>                                y =3D READ_ONCE(a);
>
> With split_huge scenery to update pte/pmd entry, there is no strong
> relationship between address ptex and pmd.
> CPU1
>       WRITE_ONCE(pte0, 1);
>       WRITE_ONCE(pte511, 1);
>       <write barrier>
>       WRITE_ONCE(pmd, 2);
>
> However with page table walk scenery, address ptep depends on the
> contents of pmd, so it is not necessary to add smp_rmb().
>          ptep =3D pte_offset_map_lock(mm, pmd, address, &ptl);
>          if (!ptep)
>                  return no_page_table(vma, flags, address);
>          pte =3D ptep_get(ptep);
>          if (!pte_present(pte))
>
> It is just my option, or do you think where smp_rmb() barrier should be
> added in page table reader path?
There are some possibilities:
1. Read barrier is missing in some places;
2. Write barrier is also unnecessary here;
3. Read barrier is really unnecessary, but there is a better API to
replace the write barrier;
4. Read barrier is really unnecessary, and write barrier is really the
best API here.

Maybe Rui Wang knows better here.

Huacai

>
> Regards
> Bibo Mao
> >
> >
> > Huacai
> >
> >>
> >> Regards
> >> Bibo Mao
> >>>
> >>> Huacai
> >>>
> >>>>
> >>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>> ---
> >>>>    arch/loongarch/kvm/mmu.c | 2 ++
> >>>>    1 file changed, 2 insertions(+)
> >>>>
> >>>> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> >>>> index 1690828bd44b..7f04edfbe428 100644
> >>>> --- a/arch/loongarch/kvm/mmu.c
> >>>> +++ b/arch/loongarch/kvm/mmu.c
> >>>> @@ -163,6 +163,7 @@ static kvm_pte_t *kvm_populate_gpa(struct kvm *k=
vm,
> >>>>
> >>>>                           child =3D kvm_mmu_memory_cache_alloc(cache=
);
> >>>>                           _kvm_pte_init(child, ctx.invalid_ptes[ctx.=
level - 1]);
> >>>> +                       smp_wmb(); /* make pte visible before pmd */
> >>>>                           kvm_set_pte(entry, __pa(child));
> >>>>                   } else if (kvm_pte_huge(*entry)) {
> >>>>                           return entry;
> >>>> @@ -746,6 +747,7 @@ static kvm_pte_t *kvm_split_huge(struct kvm_vcpu=
 *vcpu, kvm_pte_t *ptep, gfn_t g
> >>>>                   val +=3D PAGE_SIZE;
> >>>>           }
> >>>>
> >>>> +       smp_wmb();
> >>>>           /* The later kvm_flush_tlb_gpa() will flush hugepage tlb *=
/
> >>>>           kvm_set_pte(ptep, __pa(child));
> >>>>
> >>>> --
> >>>> 2.39.3
> >>>>
> >>
> >>
>
>

