Return-Path: <kvm+bounces-31701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E27F9C679D
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 04:13:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 97CA4B24010
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 03:13:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 903571632C9;
	Wed, 13 Nov 2024 03:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLiJyBYE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D3216190C
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 03:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731467579; cv=none; b=HWmDwusf+S5BkAzGN2GEa2uuDKxBwN0gY57oOnwHflg5WwKijOPZYpEXvpLpbsWMA1wP8f4s0EZn0KUJOz2yXh2mkgNoLcqGCnZZJchxtvENRzA8GU08w9YVJzKhdQ1aT+3HSHmniFlteEP63263ffjCvTXv/sAdou+qeAnZ3fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731467579; c=relaxed/simple;
	bh=aGDEPDsF+Q8EyDgP5RZSD4WuzW+6IkJfG/aIFBd5lFE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dUrJpWMSDvYJ3pEaKVvloCIVfBi+kefc4N3KAFZa8SlF8cnluYoaKp8ots+4cU3da3ktEKxBbOhvCTnOJ/BATCBvBgQnd29Tu/prQDd5JCsLCGWLmVrXHSBFzd4H59lR+yTBXWgGsK9FQzYejqv9rX3Hxwp9tpcziiEDemQOl8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLiJyBYE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B6DC4AF09
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 03:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731467579;
	bh=aGDEPDsF+Q8EyDgP5RZSD4WuzW+6IkJfG/aIFBd5lFE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BLiJyBYEJRpTjkVtCCWSblUch2sTiexyWIOPgikJ23CEogS6ViDLuU7UCJOnnLLPu
	 03MgqI7T2ZQWGIBxtvsFmQ114XG/QK+yTIfaHGmxmgkJONVcosclQQRgEcL/jx/r2h
	 QY5QPQ08T85ssQf7/yI6iPnPTCYXya1V93A2uv4DmUrrSH87bK28CuSI/B5xCoBvXP
	 OwMimYfurjumoBgOqEhZeRPqwqcwK7P6Q71FpiSkxSCvHABDrbKjDm4VCnT8jklZiq
	 AYGr5E+PeVZ8Q0WvJOqSyeGLF/3aT/iy2+ueazppPsLdX3OZ8JT9lzFX+QRDBYgEkx
	 dmeWjBn5s9R9w==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5cf04f75e1aso7667182a12.1
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 19:12:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXIuh7FJo1VpXw0c8Cz8k5hU7U5v02H7H7yMluI1mx7JRFvhhzuhTUren0VOJLYzWLfzZk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL4d8ghgdUPSLmyqOkkSiIUeb57CDLJl41vmoYOteBx762rqJ2
	Mmhy+Ne4GJ2aTYSI4lT1cPlGO6VCfN1VeAkpLBxnULssb5xIs8d+agESGZwt20SsdEvdjwVITzX
	g59Jc0JWK75MuOsMXelsNF9HHHY4=
X-Google-Smtp-Source: AGHT+IFBL4MFKWJ2gLMX0Nr5x8TFoj/k14rM6zCbF60i169syTOCZtRjYj9uG4d+KOypD4ObRoxyS5hP/fYn0kHCOTI=
X-Received: by 2002:a17:907:7dab:b0:a99:f283:8147 with SMTP id
 a640c23a62f3a-a9eeff25cb5mr1714039466b.27.1731467577782; Tue, 12 Nov 2024
 19:12:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241112-loongarch-kvm-eiointc-fix-sometimes-uninitialized-v1-1-7d881f728d67@kernel.org>
In-Reply-To: <20241112-loongarch-kvm-eiointc-fix-sometimes-uninitialized-v1-1-7d881f728d67@kernel.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 13 Nov 2024 11:12:47 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7dfLLD6wjpVFBvfH3ZZO2-jDRQt6sA6FUL3pXfj2JnZA@mail.gmail.com>
Message-ID: <CAAhV-H7dfLLD6wjpVFBvfH3ZZO2-jDRQt6sA6FUL3pXfj2JnZA@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Ensure ret is always initialized in kvm_eiointc_{read,write}()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	WANG Xuerui <kernel@xen0n.name>, Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Nathan,

Thank you for your patch, but I think it is better to initialize it at
declaration, and I will squash the change to the original patch since
it hasn't been upstream.

On Wed, Nov 13, 2024 at 1:02=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Clang warns (or errors with CONFIG_WERROR=3Dy):
>
>   arch/loongarch/kvm/intc/eiointc.c:323:2: error: variable 'ret' is used =
uninitialized whenever switch default is taken [-Werror,-Wsometimes-uniniti=
alized]
>     323 |         default:
>         |         ^~~~~~~
>   arch/loongarch/kvm/intc/eiointc.c:697:2: error: variable 'ret' is used =
uninitialized whenever switch default is taken [-Werror,-Wsometimes-uniniti=
alized]
>     697 |         default:
>         |         ^~~~~~~
>
> Set ret to -EINVAL in the default case to resolve the warning, as len
> was not a valid value for the functions to handle.
>
> Fixes: e24e9e0c1da4 ("LoongArch: KVM: Add EIOINTC read and write function=
s")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> It appears that my previous version of this change did not get
> incorporated in the new revision. I did not mark this as a v2 since it
> has been some time.
>
> https://lore.kernel.org/r/20240916-loongarch-kvm-eiointc-fix-sometimes-un=
initialized-v1-1-85142dcb2274@kernel.org
I'm very sorry that I have ignored this and didn't signal Xianglai.

Huacai

> ---
>  arch/loongarch/kvm/intc/eiointc.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/=
eiointc.c
> index 0084839f41506eb3b99c2c38f9721f3c0101e384..6af3ecbe29caaaef1582b1fbb=
941c01638e721cf 100644
> --- a/arch/loongarch/kvm/intc/eiointc.c
> +++ b/arch/loongarch/kvm/intc/eiointc.c
> @@ -323,6 +323,7 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
>         default:
>                 WARN_ONCE(1, "%s: Abnormal address access: addr 0x%llx, s=
ize %d\n",
>                                                 __func__, addr, len);
> +               ret =3D -EINVAL;
>         }
>         spin_unlock_irqrestore(&eiointc->lock, flags);
>
> @@ -697,6 +698,7 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
>         default:
>                 WARN_ONCE(1, "%s: Abnormal address access: addr 0x%llx, s=
ize %d\n",
>                                                 __func__, addr, len);
> +               ret =3D -EINVAL;
>         }
>         spin_unlock_irqrestore(&eiointc->lock, flags);
>
>
> ---
> base-commit: f7cc7a98fb7124abc269ebf162fcb3a8893b660a
> change-id: 20241112-loongarch-kvm-eiointc-fix-sometimes-uninitialized-1d9=
f543db2d2
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>

