Return-Path: <kvm+bounces-49950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EC3C0AE0055
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 10:48:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F03427B0A9C
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 08:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F76E264A9E;
	Thu, 19 Jun 2025 08:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r7z/UCTl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6CD264F9B;
	Thu, 19 Jun 2025 08:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750322854; cv=none; b=cjXe1hifjFx1WTbmuID//swWJA0awhZA3dtFzRonXXkMHTF6SskaI6xdy65t0huPiK2NlbZ8GwH3qIIbLxfZnAUgC4wuSC3OxUw+Cfq9Z4YG0FVY9uJqBpDSiSQkobhaHlhtKJD4wXk3W3KjJYLXeKxUQh7u1X1fEwDM53RJzQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750322854; c=relaxed/simple;
	bh=Muv3gqtcZ7hc62zIDmE1fQQ1ZoJ86CDm9SrW6sUcTZk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PWxI3cGAc2OjReZcP8NDRjkki4OlpoTrEGMqm58Gsig+wHsUXKhVbZejrVY55ZVTKK6iNJjZ6hKV2ITNU0XOM1x/IfXZURBL+1cWs8RO9ITX308C1VCW4BQTkOl45MN0Lhh0arSdtTtEBmPOuffAlDnLURHGHY6FvriMo0Tc35I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r7z/UCTl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5549FC4CEED;
	Thu, 19 Jun 2025 08:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750322854;
	bh=Muv3gqtcZ7hc62zIDmE1fQQ1ZoJ86CDm9SrW6sUcTZk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=r7z/UCTlF2kKrOJLPjcS28VaGPmNdHI0quGlaZX7AXDlkpOGTGgORxqixWevRwgb3
	 rp+jMSv8m4lYokNEpVLJ59nNNT2hV0ej3enTRwsCKk3kSq+O+280ZzMW2j5f50RVkq
	 c5N+vc83YkVj4ZM5fVVNX02cFBx9CVTvMQZqlQR54YgqjWaPAndccFF+U14uE8Odmh
	 63Zw/cUYxJYt6ypRX7rGFFXkG9Phqm/A0QeEcPW2SHecEt6DAR842CgtOBCqq7m32M
	 6ydKH0cBjyJhA2xb++Ial4uAkE6+G4vy17dqOCFN96V+IGWWjvDOoEVnsdiWTBkkvN
	 ClVHVCKRinLGQ==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-607cc1a2bd8so759419a12.2;
        Thu, 19 Jun 2025 01:47:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW2JJI5Yejf89+m7Gti21SFZkgZ9ce50QTORNEe5UkmldtYyguBWBAWYsBf9pzC46cq+xd0pPY6B8YVjJIg@vger.kernel.org, AJvYcCXsjgtaKfwIIx5ykHL0u/MRGwD6OG7JimpfV9K0BpHKj3BpuqYwIK7TluBSl45Y+6el6Ho=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyqVnVvyt7MGDF51pKoKKJvbDfmwWJADnL1eVlrYCZXBXa63FD
	eT8pNcjbRtZQbHw9RUrhMyD57nOJsY7NNMEgICTLFbWnklmNqYuysZXyLQSAtd9v83tCMCMvI3R
	w3nQ3gZpk95AVH//E1ShAXR+3PUS7lPU=
X-Google-Smtp-Source: AGHT+IGZWCNKwnyvE35SdXS5WBk9xN3oMka8jPWIYSnikYAanhsjcXod8utMB9LTgnkHZ/IPrs0CsRlIyZwXFTkTd2w=
X-Received: by 2002:a05:6402:2749:b0:5f7:f55a:e5e1 with SMTP id
 4fb4d7f45d1cf-608d0976322mr16486686a12.24.1750322852910; Thu, 19 Jun 2025
 01:47:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611014651.3042734-1-maobibo@loongson.cn> <20250611015145.3042884-1-maobibo@loongson.cn>
In-Reply-To: <20250611015145.3042884-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 19 Jun 2025 16:47:22 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6Eru5e6+_i+4DY9qwshibY43hjbS-QC-fhLD04-4mOGw@mail.gmail.com>
X-Gm-Features: AX0GCFs7PzCirFOY8JuegGHGWftfJ3eh_4ShbpIciCF89h9EWVdRzTfi6iSQ5OM
Message-ID: <CAAhV-H6Eru5e6+_i+4DY9qwshibY43hjbS-QC-fhLD04-4mOGw@mail.gmail.com>
Subject: Re: [PATCH v3 9/9] LoongArch: KVM: INTC: Add address alignment check
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Wed, Jun 11, 2025 at 9:51=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> IOCSR instruction supports 1/2/4/8 bytes access, the address should
> be naturally aligned with its access size. Here address alignment
> check is added in eiointc kernel emulation.
>
> At the same time len must be 1/2/4/8 bytes from iocsr exit emulation
> function kvm_emu_iocsr(), remove the default case in switch case
> statements.
Robust code doesn't depend its callers do things right, so I suggest
keeping the default case, which means we just add the alignment check
here.

And I think this patch should also Cc stable and add a Fixes tag.


Huacai

>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/kvm/intc/eiointc.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/=
eiointc.c
> index 8b0d9376eb54..4e9d12300cc4 100644
> --- a/arch/loongarch/kvm/intc/eiointc.c
> +++ b/arch/loongarch/kvm/intc/eiointc.c
> @@ -311,6 +311,12 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
>                 return -EINVAL;
>         }
>
> +       /* len must be 1/2/4/8 from function kvm_emu_iocsr() */
> +       if (addr & (len - 1)) {
> +               kvm_err("%s: eiointc not aligned addr %llx len %d\n", __f=
unc__, addr, len);
> +               return -EINVAL;
> +       }
> +
>         vcpu->stat.eiointc_read_exits++;
>         spin_lock_irqsave(&eiointc->lock, flags);
>         switch (len) {
> @@ -323,12 +329,9 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
>         case 4:
>                 ret =3D loongarch_eiointc_readl(vcpu, eiointc, addr, val)=
;
>                 break;
> -       case 8:
> +       default:
>                 ret =3D loongarch_eiointc_readq(vcpu, eiointc, addr, val)=
;
>                 break;
> -       default:
> -               WARN_ONCE(1, "%s: Abnormal address access: addr 0x%llx, s=
ize %d\n",
> -                                               __func__, addr, len);
>         }
>         spin_unlock_irqrestore(&eiointc->lock, flags);
>
> @@ -682,6 +685,11 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
>                 return -EINVAL;
>         }
>
> +       if (addr & (len - 1)) {
> +               kvm_err("%s: eiointc not aligned addr %llx len %d\n", __f=
unc__, addr, len);
> +               return -EINVAL;
> +       }
> +
>         vcpu->stat.eiointc_write_exits++;
>         spin_lock_irqsave(&eiointc->lock, flags);
>         switch (len) {
> @@ -694,12 +702,9 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
>         case 4:
>                 ret =3D loongarch_eiointc_writel(vcpu, eiointc, addr, val=
);
>                 break;
> -       case 8:
> +       default:
>                 ret =3D loongarch_eiointc_writeq(vcpu, eiointc, addr, val=
);
>                 break;
> -       default:
> -               WARN_ONCE(1, "%s: Abnormal address access: addr 0x%llx, s=
ize %d\n",
> -                                               __func__, addr, len);
>         }
>         spin_unlock_irqrestore(&eiointc->lock, flags);
>
> --
> 2.39.3
>

