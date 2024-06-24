Return-Path: <kvm+bounces-20351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3511A91403F
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 03:56:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66AAA1C218F2
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 01:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D48F34C96;
	Mon, 24 Jun 2024 01:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AtphicwR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39731FB4;
	Mon, 24 Jun 2024 01:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719194199; cv=none; b=qF5GxSsFmyqyC89/KBvpfRL9ZtNOTmB5BdMa/Y7BfzDRv3tU4+MMYG37Z0JxFW0dsuR67GDvyyKFIU8UVnffMVOiM3zTNCOOuGfzdRNJ5mpWeRu69xY93WQDyf124tzm1LezJ5PLmWBhIc4RNfjtKdz6+VJ+bf4m+aFQ95wc36I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719194199; c=relaxed/simple;
	bh=XJdYGezAnnfzkLza5p0gH2/hu7L/r81OIYinAKph/eA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EKM9RnpaAZ0LZ7ID7mRykiWneIO8lm2AxmZ5SZ8Wo8q5m6jZL40SKCgyMayb05DQhVApuVv4/ZbDoGd4wUq1Jta4gXin9lEDCc/B5tMWxs8WHD9lJB8VO21u+JKwieJQToTdTIY34cNhhH160Ovc1V9ruCxpEa7Jh35KkIU+B08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AtphicwR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97098C4AF09;
	Mon, 24 Jun 2024 01:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719194198;
	bh=XJdYGezAnnfzkLza5p0gH2/hu7L/r81OIYinAKph/eA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AtphicwRqhYvDDxsGef2KsP3dETTTt4oo/DXzoHdS0g7N00M1zu/xIZ7wWW0OZy4D
	 DbLIfnkEYhOsg+aH2JcYGUvbvL1Ho1za41PgJ7RvpuwEFdfzWvyGV6qT+OGqw9Y1T8
	 PuXh/zvQx3/j7/c8zKQcBx61Xn109dPAwa+uP3ye90vtcxTDaJNzmnoyff9ShqxksE
	 0nKSwkAF5jnWuQIW62ZHGCvUMVloAJkF9HqEDs4Mt1QaNmN8liiOw5c4zqR7IOUraM
	 8W4Y8g4sX64ba3E77HRiy5rsEiUq1Xb0EAZCJwtgDbN0yADf6RhQVcFlVHBs2RpnVC
	 lsDD6b+plEqaA==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-57d203d4682so4436508a12.0;
        Sun, 23 Jun 2024 18:56:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX6xS9lU3JCpnNzlhxPq1PtSZzYkKac4CTvxk3s5mfyO4M8gpp++KEaR5RmslCbuCr/UZaZMC2j+tRaDwshw4hmNU/LPUb0hBHxUmBny5eX1scnypYF+BqDgII0jBZmWBw8
X-Gm-Message-State: AOJu0Ywd9pHP2qCJILs80B7HoFLZF7+StDv1FQiAsGsNzUfsmu7EJqLq
	EIKoG0tUyQR+QO4WucZRokI6duUgA/hltugzmqf5b1sA/IKCX6gdckyKRZoah5o4IOFgseWahjA
	CmVZlrBdBPz6VywXr/GWShYeCoNM=
X-Google-Smtp-Source: AGHT+IFHLJ81fdL6BQd3+HcxSDlhwR7+scIGYCbMSRFSy8DkmMqe/sJLPPYN1IMD8YKDubZqERsgpJGdPoxmPBuTMps=
X-Received: by 2002:a50:bb45:0:b0:57c:bf3b:76f5 with SMTP id
 4fb4d7f45d1cf-57d45809d0dmr2503658a12.35.1719194197193; Sun, 23 Jun 2024
 18:56:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240619080940.2690756-1-maobibo@loongson.cn> <20240619080940.2690756-5-maobibo@loongson.cn>
 <CAAhV-H74raJ9eEWEHr=aN6LhVvNUyP6TLEDH006M6AnoE8tkPg@mail.gmail.com> <58d34b7d-eaad-8aa8-46c3-9212664431be@loongson.cn>
In-Reply-To: <58d34b7d-eaad-8aa8-46c3-9212664431be@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 24 Jun 2024 09:56:24 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6CzPAxwymk16NfjPGO=oi+iBZJYsdSMiyp2N2cDsw54g@mail.gmail.com>
Message-ID: <CAAhV-H6CzPAxwymk16NfjPGO=oi+iBZJYsdSMiyp2N2cDsw54g@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] LoongArch: KVM: Add memory barrier before update
 pmd entry
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, 
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 24, 2024 at 9:37=E2=80=AFAM maobibo <maobibo@loongson.cn> wrote=
:
>
>
>
> On 2024/6/23 =E4=B8=8B=E5=8D=886:18, Huacai Chen wrote:
> > Hi, Bibo,
> >
> > On Wed, Jun 19, 2024 at 4:09=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> =
wrote:
> >>
> >> When updating pmd entry such as allocating new pmd page or splitting
> >> huge page into normal page, it is necessary to firstly update all pte
> >> entries, and then update pmd entry.
> >>
> >> It is weak order with LoongArch system, there will be problem if other
> >> vcpus sees pmd update firstly however pte is not updated. Here smp_wmb=
()
> >> is added to assure this.
> > Memory barriers should be in pairs in most cases. That means you may
> > lose smp_rmb() in another place.
> The idea adding smp_wmb() comes from function __split_huge_pmd_locked()
> in file mm/huge_memory.c, and the explanation is reasonable.
>
>                  ...
>                  set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);
>          }
>          ...
>          smp_wmb(); /* make pte visible before pmd */
>          pmd_populate(mm, pmd, pgtable);
>
> It is strange that why smp_rmb() should be in pairs with smp_wmb(),
> I never hear this rule -:(
https://docs.kernel.org/core-api/wrappers/memory-barriers.html

SMP BARRIER PAIRING
-------------------

When dealing with CPU-CPU interactions, certain types of memory barrier sho=
uld
always be paired.  A lack of appropriate pairing is almost certainly an err=
or.


Huacai

>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   arch/loongarch/kvm/mmu.c | 2 ++
> >>   1 file changed, 2 insertions(+)
> >>
> >> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> >> index 1690828bd44b..7f04edfbe428 100644
> >> --- a/arch/loongarch/kvm/mmu.c
> >> +++ b/arch/loongarch/kvm/mmu.c
> >> @@ -163,6 +163,7 @@ static kvm_pte_t *kvm_populate_gpa(struct kvm *kvm=
,
> >>
> >>                          child =3D kvm_mmu_memory_cache_alloc(cache);
> >>                          _kvm_pte_init(child, ctx.invalid_ptes[ctx.lev=
el - 1]);
> >> +                       smp_wmb(); /* make pte visible before pmd */
> >>                          kvm_set_pte(entry, __pa(child));
> >>                  } else if (kvm_pte_huge(*entry)) {
> >>                          return entry;
> >> @@ -746,6 +747,7 @@ static kvm_pte_t *kvm_split_huge(struct kvm_vcpu *=
vcpu, kvm_pte_t *ptep, gfn_t g
> >>                  val +=3D PAGE_SIZE;
> >>          }
> >>
> >> +       smp_wmb();
> >>          /* The later kvm_flush_tlb_gpa() will flush hugepage tlb */
> >>          kvm_set_pte(ptep, __pa(child));
> >>
> >> --
> >> 2.39.3
> >>
>
>

