Return-Path: <kvm+bounces-8679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 76598854A08
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 14:06:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B0041F22916
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 13:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5628553393;
	Wed, 14 Feb 2024 13:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kRR7cFxK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770605337F;
	Wed, 14 Feb 2024 13:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707915971; cv=none; b=Z97X3ykmEWf3l4EAf37q2gDTulwgJiQW8QE5hsNx6DGJexihYvKU1MY4mGwUNZ2q5mBcS3t4RdyrEBdfgmvosMokrUA1XOH6CUlTXx38fvE1J5MJGFToFMoXLSlmCs1DBaP6wbjL/PB02c4emAG9k05/tivfJmrfL7WJohWEbMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707915971; c=relaxed/simple;
	bh=o4iopwK/5ULya9a8mXcuJSOlKxKZiTV1D6BHKKdOPGU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J6HD0etVZ0to0sBi1rhArbyLjuyUW/Gvdxnz2cXY7Lb7kMUQAsCkvhHc4ReP8SGrlp23NXnPbVtSK0rSpAQHA5Cietd7InYSqWLTjdlTAU9l/CZJbQxB/KSRZzSMS5lBbd8jdjat+SI/aSAXZHD8PRSJ6/gTNcFm0tlilOvPmGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kRR7cFxK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BF8C433C7;
	Wed, 14 Feb 2024 13:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707915971;
	bh=o4iopwK/5ULya9a8mXcuJSOlKxKZiTV1D6BHKKdOPGU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kRR7cFxKx3ZKqgOQtG+aHBwQL/5skbrDyaSa6i88BHzJLG/26xZnCJgGbYzX/SAov
	 N5fQKmJFQuaFmzuOumk5ZHl63iX3G+y1pf6SrJoRe9mWNeJsCS9VzEc5mbM1lW4Fyl
	 mdfK546qKTcdk6Ulv14LNLlm25sTlJQrmnMUMVk1bFzSWk+JSb2WS9bb+u3GraWDn1
	 dmuxwrCeVZ1VEjRyEeIRLS2OpIbKllD2jKze/x5I1k73HpVRfjnZShZpQ6F/p7mDV1
	 nM+97e8nfSGd9PkrutY8MN2oD6+eHRgjMuq8+L7u7q7MuzaulVHNzbWowY/QtLjYgW
	 Ze7U7N+7ivB8Q==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5638e05e27cso353890a12.0;
        Wed, 14 Feb 2024 05:06:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXoGERACVTb57QM5gxhXEEReuijRok8nqq/a7MY4Bi7QDlAI5RAlLDS1nyvyhfsVORX9fYNO5HFsGwNdnrcoSZwWSYKv9GdtbO1yCqEAWjv1EOD+/4GnF0/GCvl5yeAzhr9
X-Gm-Message-State: AOJu0YyINb0ypg+fsyeFNiyjWBIMViMgXsjuV9R/ZE0aO/UvvVrt2c3t
	vJL6Jztg6ns3haMteVitPuxT3AHSwvj/Iu3madg/oRkJkpzgw1Cady0tLZbzntwvoPkm3K5FebT
	Nmr8feTGTDVWYqZEGBuNwdPKWYi0=
X-Google-Smtp-Source: AGHT+IGwcchJhHo+k99G60kcy5767+i12fWx+5UMpKZg7T5GiHwpvMNQ+GtxeRKwsOBtkUp3TS8uN2xuvSK8sqT4hWw=
X-Received: by 2002:aa7:d8cd:0:b0:55f:ccec:ba51 with SMTP id
 k13-20020aa7d8cd000000b0055fccecba51mr2047998eds.22.1707915969469; Wed, 14
 Feb 2024 05:06:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240214101557.2900512-1-kernel@xen0n.name> <20240214101557.2900512-5-kernel@xen0n.name>
In-Reply-To: <20240214101557.2900512-5-kernel@xen0n.name>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 14 Feb 2024 21:06:06 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6htTqd3nHymcEpj2DDdeXU00OwtPJfYNpiSA7ac5JV7w@mail.gmail.com>
Message-ID: <CAAhV-H6htTqd3nHymcEpj2DDdeXU00OwtPJfYNpiSA7ac5JV7w@mail.gmail.com>
Subject: Re: [PATCH for-6.8 4/5] KVM: LoongArch: Streamline control flow of kvm_check_cpucfg
To: WANG Xuerui <kernel@xen0n.name>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, WANG Xuerui <git@xen0n.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Xuerui,

On Wed, Feb 14, 2024 at 6:16=E2=80=AFPM WANG Xuerui <kernel@xen0n.name> wro=
te:
>
> From: WANG Xuerui <git@xen0n.name>
>
> All the checks currently done in kvm_check_cpucfg can be realized with
> early returns, so just do that to avoid extra cognitive burden related
> to the return value handling.
>
> The default branch is unreachable because of the earlier validation by
> _kvm_get_cpucfg_mask, so mark it as such too to make things clearer.
>
> Signed-off-by: WANG Xuerui <git@xen0n.name>
> ---
>  arch/loongarch/kvm/vcpu.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
>
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index e973500611b4..9e108ffaba30 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -339,24 +339,23 @@ static int kvm_check_cpucfg(int id, u64 val)
>                 /* CPUCFG2 features checking */
>                 if (val & ~mask)
>                         /* The unsupported features should not be set */
> -                       ret =3D -EINVAL;
> -               else if (!(val & CPUCFG2_LLFTP))
> +                       return -EINVAL;
> +               if (!(val & CPUCFG2_LLFTP))
>                         /* The LLFTP must be set, as guest must has a con=
stant timer */
> -                       ret =3D -EINVAL;
> -               else if ((val & CPUCFG2_FP) && (!(val & CPUCFG2_FPSP) || =
!(val & CPUCFG2_FPDP)))
> +                       return -EINVAL;
> +               if ((val & CPUCFG2_FP) && (!(val & CPUCFG2_FPSP) || !(val=
 & CPUCFG2_FPDP)))
>                         /* Single and double float point must both be set=
 when enable FP */
> -                       ret =3D -EINVAL;
> -               else if ((val & CPUCFG2_LSX) && !(val & CPUCFG2_FP))
> +                       return -EINVAL;
> +               if ((val & CPUCFG2_LSX) && !(val & CPUCFG2_FP))
>                         /* FP should be set when enable LSX */
> -                       ret =3D -EINVAL;
> -               else if ((val & CPUCFG2_LASX) && !(val & CPUCFG2_LSX))
> +                       return -EINVAL;
> +               if ((val & CPUCFG2_LASX) && !(val & CPUCFG2_LSX))
>                         /* LSX, FP should be set when enable LASX, and FP=
 has been checked before. */
> -                       ret =3D -EINVAL;
> -               break;
> +                       return -EINVAL;
> +               return 0;
>         default:
> -               break;
> +               unreachable();
Maybe BUG() is better than unreachable()?

Huacai
>         }
> -       return ret;
>  }
>
>  static int kvm_get_one_reg(struct kvm_vcpu *vcpu,
> --
> 2.43.0
>

