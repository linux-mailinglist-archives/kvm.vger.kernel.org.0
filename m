Return-Path: <kvm+bounces-52595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C97E6B07103
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 10:58:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D82203BA5C1
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 08:57:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D8C2EFD93;
	Wed, 16 Jul 2025 08:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SiTLv81Z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE302EFDB1;
	Wed, 16 Jul 2025 08:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752656266; cv=none; b=KegoIscfE1sb2gV9RWGBSKHxGHREnKYdi1IXiYqNLGYKJ0jcrXMY288mcWa3NsCj2vat9l3Fr7HI2kvMc7PFIguloBaagKPE90YUX4x0pWTMGS555hkhFkwGaSB0x4fbSsWowlfHSgs8H2cS2DqGCdtzDoTTFqWrEAM43imj3rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752656266; c=relaxed/simple;
	bh=ss9ytgABqvIO7uIc0QB+LcbK25WEv1HnHJSz+VCrvy4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mqpycyHbbRDaBKeGZ84uqq9OBcLgJ0jkepLSqb42s982mhaAi0dsXMkSA11ChIT0XXqENKeuas/OosCs0eZhaMf4SMzuMd+OSboyaLZoEtKvkgFNWqeQ/ZCXSKYPfKA5gvhPS2EntzR9FYXUFj1+hbu0vT9wmANZGrfEt+C+BEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SiTLv81Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D773CC4CEF6;
	Wed, 16 Jul 2025 08:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752656265;
	bh=ss9ytgABqvIO7uIc0QB+LcbK25WEv1HnHJSz+VCrvy4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SiTLv81ZbUmDR6wIqx4AXgje/DwLimTT93ii0QTEV14SFXdrqoXF7txB7vbCg//M3
	 YCz4g+5myiG4Ypgv1zxPcASHstEocMWMm+dPVOeU4nkb7DhzCWqE6edeN6GEtsyRX7
	 sco5DVYMw68qauGLt1PJcZPZTcpUYI6edvJozFAsHpKBHFfXaXD3ZS2h4Sue6+f52o
	 hrOe1SoK1DEoU5O0t0dAqEJp3P9fOMD6rDLRNLeR/N9EHTMWc/TIZyzRbSSlQ7uhJS
	 WTcwdT1+WSmeO7p+nVkCY5f8OmHwn66fKQQ+xaQo7kTHcGOdYE5Q3lyvEz8AqZfHF6
	 QmyynrLjRlw2A==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-60c01b983b6so1507442a12.0;
        Wed, 16 Jul 2025 01:57:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUCfgU6ypf5Ny4xLLy3kcm3KEQGc1CqvWRbocrMdJGeSrf7ceqHdVhGEViqpGovgsZGgxU=@vger.kernel.org, AJvYcCW9hSDl0MknbLGxu/acP4Hnbpoe1HysyzUlludxnmrtPXRKz2T1WezD/bIOSudHpCwRO7O/NQMRkYEqhklx@vger.kernel.org
X-Gm-Message-State: AOJu0YycIaxnChrAKT2kZnZD/62W6ECms6FypFcjExkTX9/Fmq5unJ9d
	rOC/Xxey9/jnnymg/KcFmkFOiX5JZJHXXdpJB9RX/zyosOgL6TsypPbeB5ggQadFWnvfpCtL8B/
	uBvyEuqYZteLxqA7eKKYn7athkMlD7YM=
X-Google-Smtp-Source: AGHT+IHnz0DJ5lFEpyUFVufwXtaxypvq0tJzp9YTuXoEpi5e67tSPansyYgeDX0eNnXISqx++wflGuCEiGLkOrfmRdg=
X-Received: by 2002:a05:6402:2343:b0:601:a16e:4827 with SMTP id
 4fb4d7f45d1cf-612664871d1mr5736066a12.3.1752656264384; Wed, 16 Jul 2025
 01:57:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250616073539.129365-1-maobibo@loongson.cn> <20250616073539.129365-2-maobibo@loongson.cn>
In-Reply-To: <20250616073539.129365-2-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 16 Jul 2025 16:57:33 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5qjr9GM6E-p43WBoCWNM8+Ag1=fCLw0+dP9_VPKjjp4A@mail.gmail.com>
X-Gm-Features: Ac12FXyImEmfEZrJTAgiJwnh9QndPRmWv93QXR8Mql7fclQAJREnSJ0UzqR_sus
Message-ID: <CAAhV-H5qjr9GM6E-p43WBoCWNM8+Ag1=fCLw0+dP9_VPKjjp4A@mail.gmail.com>
Subject: Re: [PATCH 1/2] LoongArch: KVM: INTC: Remove local variable device1
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied, thanks.


Huacai

On Mon, Jun 16, 2025 at 3:35=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Local variable device1 can be replaced with existing variable device,
> it makes code concise.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/kvm/intc/eiointc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/=
eiointc.c
> index f39929d7bf8a..d9c4fe93405d 100644
> --- a/arch/loongarch/kvm/intc/eiointc.c
> +++ b/arch/loongarch/kvm/intc/eiointc.c
> @@ -956,7 +956,7 @@ static int kvm_eiointc_create(struct kvm_device *dev,=
 u32 type)
>  {
>         int ret;
>         struct loongarch_eiointc *s;
> -       struct kvm_io_device *device, *device1;
> +       struct kvm_io_device *device;
>         struct kvm *kvm =3D dev->kvm;
>
>         /* eiointc has been created */
> @@ -984,10 +984,10 @@ static int kvm_eiointc_create(struct kvm_device *de=
v, u32 type)
>                 return ret;
>         }
>
> -       device1 =3D &s->device_vext;
> -       kvm_iodevice_init(device1, &kvm_eiointc_virt_ops);
> +       device =3D &s->device_vext;
> +       kvm_iodevice_init(device, &kvm_eiointc_virt_ops);
>         ret =3D kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS,
> -                       EIOINTC_VIRT_BASE, EIOINTC_VIRT_SIZE, device1);
> +                       EIOINTC_VIRT_BASE, EIOINTC_VIRT_SIZE, device);
>         if (ret < 0) {
>                 kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &s->device)=
;
>                 kfree(s);
> --
> 2.39.3
>

