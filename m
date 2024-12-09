Return-Path: <kvm+bounces-33283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EAA319E8D0E
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 09:10:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1F56188546C
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 08:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02A3F215188;
	Mon,  9 Dec 2024 08:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="PTjMWAR9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9304A215075
	for <kvm@vger.kernel.org>; Mon,  9 Dec 2024 08:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733731808; cv=none; b=DUKcRzHg8GC82tgiVeEOL4hN2W6ErnzvtKtBGtNWKDDImuF+Nvt3rvEWzgoekaBn4PFONa0np5O9XjyaRE2E7sFJtGj4rtupuV8fZd7KF2M13QYU5aRbwm0YPIHsjq6FnuHN8j0ObyVHgAknw3w2ChxZIv0jZqzMAxIaCbJ0R9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733731808; c=relaxed/simple;
	bh=e9T1tqdjsB2hx8LoVxJobchZWtItWdr11EkDA8I/jmk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hc8pjicWFvltAVnR6AeCuetsOPn7mIiuqOrTKMK8Wq2the5nYBeR4FmJlOgBLvcrUr4DVdj1ATg12VcvetxpidlpaoS80MsYWgUAGUNuYzdNKv2ms0J1J/7qC1m7Si19Ro89lVAFJdhj1m354qeKTauPJgy3VFCkqtN5l6baxKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=PTjMWAR9; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5cf6f367f97so5857706a12.0
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 00:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1733731804; x=1734336604; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WOdGE0llx04cHDIB0WcrC/Ji09jqKKAXDGd/eNwLnL0=;
        b=PTjMWAR9MSWkih4EngALJqbP7DguEmG0EXZ5lgpO6c+tk5P5xAPjnRmF0/4f/kW0fW
         Oee7kt3ZExZhPblbhivejZtnZ0LiMv3u8l3umyZsWUCBC4PPo1k1u8hW3y5nO5w7YT/h
         x5RbOiDliHvBjGOUvaO5sfB8ccuqKXCK96sFfDx5Tyb3XIAw4GydVCU6m408ag58hKtA
         b1Pho6ugXRa8jDB1MWb2lXb6Ud6G0PUrexDzuhRxAmAPhskH5ha+xOD+y2i1f6+OisZb
         NWa+jaB4DxLJGv0MQ2R9VXqZ+onbCPYMm2D+gNt3kj4zAzRj2R90ozoAL1foGviyQAT9
         aHbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733731804; x=1734336604;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WOdGE0llx04cHDIB0WcrC/Ji09jqKKAXDGd/eNwLnL0=;
        b=Rjg5IYfigIerGRRWMLdTEGnf9WHP5FInRcHasnbGVkRqi+uZNIkcJPJTERRuthyiVt
         UHewWEB3CS6gEvvdGjszGH8rDKE6N/HDUYmAjkYf0as3HsCWgyRw4IgRC8sCr3GnDvxC
         qhKuiDcb35z5VF2/0yfO+MwLm+UMWLI0PfVPG/LmvfSNc4iaePDtW8mvlQ0LVqjBaZAR
         HmSVbKX/CqtP+Lbpppiss6qPwkpR5mOTLuKcHH3lSC/srhk/C9bz6kZLsLtl8UdciN9U
         WEspIhLMKjm6tjIktaW+Q9RUU108va9FG2cZYueIJri5lmfhHZHWbkjLF5jxnLAWkM6B
         aeaA==
X-Forwarded-Encrypted: i=1; AJvYcCXqyrCj79tz5EeTxEMb7/wPVQ60vJ3SIIL9kqg91xg1XxL/n14hXk7bPhGYBvZx59W0ysk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPOtMmfCe/LSjDR3/Jawz1BW2FofD4hksybG4FJamygKFYtYWW
	IqWq5J5fKesIlMeGNI7f9UZ7Gk3iJMgUYgGHVrOh4kYyLubla4ymS4qNvj/+apL3hhQhtQ5AF9q
	QB8H95bR3TA0eUQRoNx9wEIMpgwTkIKLI5XP8RICLn4Pcl4zQ6jF/+w==
X-Gm-Gg: ASbGncvYPWCeuBrJlTJZxTOWY+LM+JFfTaOtqEx5MX1j3af61QoDQiTlf15fIHgbDaz
	fKKzXfztf1WavFm5KoWwQFzpZ/Xdn+0a1QVY7
X-Google-Smtp-Source: AGHT+IGNck5i4vPd2OxR76eBBx6zUGhGMnAu9BdeT9Vh0NpmJctj2kl8Ojqzeyx0WmJshY5K/xlMG+5FLizyFcfrOBI=
X-Received: by 2002:a05:6402:520d:b0:5d2:723c:a577 with SMTP id
 4fb4d7f45d1cf-5d3be6d07famr11938931a12.14.1733731803826; Mon, 09 Dec 2024
 00:10:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241120-dev-maxh-svukte-v3-v3-0-1e533d41ae15@sifive.com>
 <20241120-dev-maxh-svukte-v3-v3-3-1e533d41ae15@sifive.com> <20241125-7cfad4185ec1a66fa08ff0f0@orel>
In-Reply-To: <20241125-7cfad4185ec1a66fa08ff0f0@orel>
From: Max Hsu <max.hsu@sifive.com>
Date: Mon, 9 Dec 2024 16:09:51 +0800
Message-ID: <CAHibDyztkj3vFmZ7Gg=0QFoauO7pdm4+c16y8hQiaTkCQPc=LQ@mail.gmail.com>
Subject: Re: [PATCH RFC v3 3/3] riscv: KVM: Add Svukte extension support for Guest/VM
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, Samuel Holland <samuel.holland@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Okay, I understand it now, since the Guest OS may utilize the Svukte
extension simply by setting the senvcfg.UKTE without any trap.
In the view of VMM, the Svukte extension should be always presented.

I'll add the extra entry in the kvm_riscv_vcpu_isa_disable_allowed()
for the v4 patches.

Thanks, Anup, Paul, and Andrew for the patience and detailed
explanation.

Best,
Max Hsu

On Mon, Nov 25, 2024 at 8:08=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Wed, Nov 20, 2024 at 10:09:34PM +0800, Max Hsu wrote:
> > Add KVM_RISCV_ISA_EXT_SVUKTE for VMM to detect the enablement
> > or disablement the Svukte extension for Guest/VM
> >
> > Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
> > Signed-off-by: Max Hsu <max.hsu@sifive.com>
> > ---
> >  arch/riscv/include/uapi/asm/kvm.h | 1 +
> >  arch/riscv/kvm/vcpu_onereg.c      | 1 +
> >  2 files changed, 2 insertions(+)
> >
> > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uap=
i/asm/kvm.h
> > index 4f24201376b17215315cf1fb8888d0a562dc76ac..158f9253658c4c28a533b2b=
da179fb48bf41e1fc 100644
> > --- a/arch/riscv/include/uapi/asm/kvm.h
> > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > @@ -177,6 +177,7 @@ enum KVM_RISCV_ISA_EXT_ID {
> >       KVM_RISCV_ISA_EXT_ZAWRS,
> >       KVM_RISCV_ISA_EXT_SMNPM,
> >       KVM_RISCV_ISA_EXT_SSNPM,
> > +     KVM_RISCV_ISA_EXT_SVUKTE,
> >       KVM_RISCV_ISA_EXT_MAX,
> >  };
> >
> > diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.=
c
> > index 5b68490ad9b75fef6a18289d8c5cf9291594e01e..4c3a77cdeed0956e21e53d1=
ab4e948a170ac5c5c 100644
> > --- a/arch/riscv/kvm/vcpu_onereg.c
> > +++ b/arch/riscv/kvm/vcpu_onereg.c
> > @@ -43,6 +43,7 @@ static const unsigned long kvm_isa_ext_arr[] =3D {
> >       KVM_ISA_EXT_ARR(SVINVAL),
> >       KVM_ISA_EXT_ARR(SVNAPOT),
> >       KVM_ISA_EXT_ARR(SVPBMT),
> > +     KVM_ISA_EXT_ARR(SVUKTE),
> >       KVM_ISA_EXT_ARR(ZACAS),
> >       KVM_ISA_EXT_ARR(ZAWRS),
> >       KVM_ISA_EXT_ARR(ZBA),
> >
> > --
> > 2.43.2
>
> Anup raised the missing entry in kvm_riscv_vcpu_isa_disable_allowed() in
> the last review. An additional paragraph was added to the cover letter fo=
r
> this review, but I think there's still a misunderstanding. If the guest
> can always use the extension (whether it's advertised in its ISA string
> or not), then that means it cannot be disabled from the perspective of
> the VMM. The only ISA extensions which may be disabled are the ones that
> trap on their use, allowing KVM to emulate responses which a physical har=
t
> without the extension would produce.
>
> Thanks,
> drew

