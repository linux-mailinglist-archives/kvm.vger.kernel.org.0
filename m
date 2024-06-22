Return-Path: <kvm+bounces-20319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46B0A91321F
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 07:21:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76B151C2115E
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 05:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18F6E14A0A9;
	Sat, 22 Jun 2024 05:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GZVFZ9Xi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABB18BFD;
	Sat, 22 Jun 2024 05:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719033687; cv=none; b=CrY+QA/lu3rIniN2pAkn/0C6/LIoiS/obRzMU55dyIIUWO7/sYWawf2kX0IgxV/0NoivYXisfIEUEKeq/9dh0MXF2v7n//EUJ8yP2FWlRkOB4Fl2JMCKdNND4Y3RKo2/g0kwgyRY6j9wolQvpqCCTiy9cCC4UNmLHR0HxS7MzWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719033687; c=relaxed/simple;
	bh=Q0VuO5tTOKXDKNo7+IgH2wC09h14zRKOZ2+TsHaNCgw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ex1STxqZpzawIegZdAormAzd/Nf71KOEu/3+5LttHhUTU5p1TdWnvop4f/IblvOS2Y7i4kZsF2fvpJSJIh9AttNcAC/2axXc8w7Raj6h2JT75eHnhcRIJUoJ1S1lsnhFuUDQiID2qKY1eujX1CJtRKSgidqtxbT5eUtj6fi/NIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GZVFZ9Xi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4898C32786;
	Sat, 22 Jun 2024 05:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719033686;
	bh=Q0VuO5tTOKXDKNo7+IgH2wC09h14zRKOZ2+TsHaNCgw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GZVFZ9XikXhuxltJOPDtH0vO/L/IVyKOGrYCkT+WhcICGqaPn/3COH7Tx4scQqQQo
	 BR1YfeiX62uMRUroHxS9dnjjV7L5Jq7KmsRXYMJJX3Hep73bMcjvS3umnVrfVBmcL/
	 /io4Djo8YCaB5Gv891WQHimCPvZq8uqral/TXDcpZrSfsCXU55rB15RjXZ3M3b0fVY
	 0TOKnJ5LLmxP4J/wrKCaATs0Pa5TIKdc165QNUDxQkxEjP9/R26NmoKePx3B8UuM3E
	 fGoQSfFcYiBo5U6b3gaoK5wD6VDgsgw8zelDnAExOEJBKCc7VfAvQMLkxIOFdp47eL
	 E1P21VT6AhHEw==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a6fb341a7f2so327057466b.1;
        Fri, 21 Jun 2024 22:21:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWQEkXkj/8b/WDTR2SetZMnNwGK8H/yFe0W/nGRuLcvyyKQel8L3GmBTLKB3unVUXyPflgj+kf4ILGgFE2UJD+gxEf/ScWDd+HRpudVJDX15vv3XYYih/7mraA3rK8RDgu9
X-Gm-Message-State: AOJu0YwCpeIV0NBgnFkNGvpoKqrEgZtWAy1vNVHR/gU+1GHnnzStI9u1
	YzMuCP3/9+yNNIOeceW03vJ2k+kkBB27wp4K/DJrkX3ib/hDpL9xXVjWyBM2jMVa3aJchXzUm1V
	s/AUJ1lIYn8aD53sy6oTrSIVfg0c=
X-Google-Smtp-Source: AGHT+IGt5KwkvmQpsoKCZE3/q/74MmGnFYUWXDgjhLBZ2ap7A6QpoRFr6yrlvgHStb7oErMA8RTUb8o39/GuhQIL9zM=
X-Received: by 2002:a17:907:a0d5:b0:a6f:4ba4:c389 with SMTP id
 a640c23a62f3a-a6fab609e3cmr917747966b.16.1719033685412; Fri, 21 Jun 2024
 22:21:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240619080940.2690756-1-maobibo@loongson.cn> <20240619080940.2690756-7-maobibo@loongson.cn>
In-Reply-To: <20240619080940.2690756-7-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 22 Jun 2024 13:21:13 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4YHBMG=YYatmmUKBm==53czOdrOoze3a_+CTNXF52N2g@mail.gmail.com>
Message-ID: <CAAhV-H4YHBMG=YYatmmUKBm==53czOdrOoze3a_+CTNXF52N2g@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] LoongArch: KVM: Mark page accessed and dirty with
 page ref added
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, 
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

What is the relationship between this patch and the below one?
https://lore.kernel.org/loongarch/20240611034609.3442344-1-maobibo@loongson=
.cn/T/#u


Huacai

On Wed, Jun 19, 2024 at 4:09=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Function kvm_map_page_fast() is fast path of secondary mmu page fault
> flow, pfn is parsed from secondary mmu page table walker. However
> the corresponding page reference is not added, it is dangerious to
> access page out of mmu_lock.
>
> Here page ref is added inside mmu_lock, function kvm_set_pfn_accessed()
> and kvm_set_pfn_dirty() is called with page ref added, so that the
> page will not be freed by others.
>
> Also kvm_set_pfn_accessed() is removed here since it is called in
> the following function kvm_release_pfn_clean().
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/kvm/mmu.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> index 3b862f3a72cb..5a820a81fd97 100644
> --- a/arch/loongarch/kvm/mmu.c
> +++ b/arch/loongarch/kvm/mmu.c
> @@ -557,6 +557,7 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, u=
nsigned long gpa, bool writ
>         gfn_t gfn =3D gpa >> PAGE_SHIFT;
>         struct kvm *kvm =3D vcpu->kvm;
>         struct kvm_memory_slot *slot;
> +       struct page *page;
>
>         spin_lock(&kvm->mmu_lock);
>
> @@ -599,19 +600,22 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu,=
 unsigned long gpa, bool writ
>         if (changed) {
>                 kvm_set_pte(ptep, new);
>                 pfn =3D kvm_pte_pfn(new);
> +               page =3D kvm_pfn_to_refcounted_page(pfn);
> +               if (page)
> +                       get_page(page);
>         }
>         spin_unlock(&kvm->mmu_lock);
>
> -       /*
> -        * Fixme: pfn may be freed after mmu_lock
> -        * kvm_try_get_pfn(pfn)/kvm_release_pfn pair to prevent this?
> -        */
> -       if (kvm_pte_young(changed))
> -               kvm_set_pfn_accessed(pfn);
> +       if (changed) {
> +               if (kvm_pte_young(changed))
> +                       kvm_set_pfn_accessed(pfn);
>
> -       if (kvm_pte_dirty(changed)) {
> -               mark_page_dirty(kvm, gfn);
> -               kvm_set_pfn_dirty(pfn);
> +               if (kvm_pte_dirty(changed)) {
> +                       mark_page_dirty(kvm, gfn);
> +                       kvm_set_pfn_dirty(pfn);
> +               }
> +               if (page)
> +                       put_page(page);
>         }
>         return ret;
>  out:
> @@ -920,7 +924,6 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsign=
ed long gpa, bool write)
>                 kvm_set_pfn_dirty(pfn);
>         }
>
> -       kvm_set_pfn_accessed(pfn);
>         kvm_release_pfn_clean(pfn);
>  out:
>         srcu_read_unlock(&kvm->srcu, srcu_idx);
> --
> 2.39.3
>

