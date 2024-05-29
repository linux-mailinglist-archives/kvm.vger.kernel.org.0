Return-Path: <kvm+bounces-18324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 559508D3B2E
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 17:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7936F1C226F5
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 15:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F1B181CEB;
	Wed, 29 May 2024 15:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="ccF3iL6Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD13D181B83
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 15:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716997306; cv=none; b=ieLIhFOMvea6+zeXlu0JmgvKS0M9K9ygk2jo1Nmoe1qHUK2yEamfnqlZQATY2nJ3jG7oK/9I8WE//f6Yq/xeUxZ8KBQCii1vQQftvnpUfGUWje7kSucA6q5MxV+NT/eRLaR20DyzDNu8f9H5OhS3oazV8Z9B7K/poBDliOFgMIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716997306; c=relaxed/simple;
	bh=/pECas1J5FK1LFhvMWMwB94EMMQOyLKKgMuwAV+hWg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c+8cirYK0zFG+JvJW0O9G7LmgkA8U0zeEBirkvHWQ/VCLADKfiSmFEscb0LZcisdWKxhVsq9h/MWctVCDY0UvNKsBMThDAsGK3SbEnXLeVbFuCP5xBS4jX7CohC+J0aodN7BMZRigDW0C4/ZcomeFP62hqGncVh+H21+wDnxJJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=ccF3iL6Z; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5b97a9a9b4bso1295486eaf.0
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 08:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1716997304; x=1717602104; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m9TiXKsknYHXf5QsRGRKcyOIZejMBzFG3PPVnqh0wNM=;
        b=ccF3iL6ZHlh2xI3SQGFcJjAbL4bGeKQ72iR+ljIMDpmBD6ECiDD2jt4/LYfpCD2Hy/
         ansd08yqCYMYUKvnK7hlcs7m40n1MFT2cMJutOfTbgmPyaGh70OZjKxSaVaB6BXpZQjv
         xQzRcxTJ/n/PV5J2BopHHaJm9YuAftr/VeNvGhkWzT2Kaw8hhBhFzB9f3jmfps2NA5d+
         NRZFHCZ+F6isSbk64pcZ1U+wry7LiMva7Gb4c9WjRMKMZRaPek+2Ro+6lwCXNvhjcax7
         PLFkQkBno+QV20VpZcejdzG1i7VMBRhoTQv9dgfnf1K4E730F+jPWXQdkFZbt1Bnivpa
         6Hfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716997304; x=1717602104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m9TiXKsknYHXf5QsRGRKcyOIZejMBzFG3PPVnqh0wNM=;
        b=pPayeFGXe8yx0iVeKnn2t72hxKA5bBwQzxlMX9RkmzOGNBjQU5Vfb5UbrCdob2RcFD
         spFHV/o+xWptMLJnC8MoInqzvDwvd7A48tvTEmYYWEs+ajdUO74FNx+PCenhh1EtGX3G
         Wb88WogG9IVVkqCNZdvOpszKa/3oAgq3VyFiXQlBWsRAeSd4cJJNV/ANgPvRVhr2HzQj
         GaXivD6i3mQh4v8o/3R02uO9CW77m688mfKKUszihMmJCtTO/GRCrr7Zpx760nRvQ75T
         0Hafr9Z7URuF6Gq307DuxxVIeaGG1RZKcbIIDmdOP2PwmCMeXAuEWzeixRwigVcUNlK/
         +g3A==
X-Forwarded-Encrypted: i=1; AJvYcCVwKHJn/gWvlqGIlZqwGF0hBIkbh14c/burEhUEQYp62Dos/DlxtjCaAXSDxoxqHq+sgK7pf9LW6N5HFucFuP5IJ4k7
X-Gm-Message-State: AOJu0YzQJ2Gbr8c3lrSxdgB4CXPsIRkkXy8pv4y7mMS9/87KZi4Bg9A8
	FxaRHqDTE4efb4813EMDThFmf0xKGpwoOFMGh6xzwYjwaRzCAeG3sYfy9nEhgG8udAFUefvM1H5
	b7UkCtJuzjoeBQP/tAAdxKOZp5SLrof83jsPn+g==
X-Google-Smtp-Source: AGHT+IGIANn+TkqLuc9AZKYmSOXX1IsRDiTVw2d6PHKuIShROX1VzVJ0uz1t5blLZNTI3MD26TOTbaEYujG54jREvoo=
X-Received: by 2002:a05:6820:515:b0:5b5:3d56:287b with SMTP id
 006d021491bc7-5b96196061amr16857245eaf.4.1716997303721; Wed, 29 May 2024
 08:41:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240524103307.2684-1-yongxuan.wang@sifive.com>
 <20240524103307.2684-5-yongxuan.wang@sifive.com> <40da6797-faab-41f3-b4bd-766e6a117468@rivosinc.com>
In-Reply-To: <40da6797-faab-41f3-b4bd-766e6a117468@rivosinc.com>
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Date: Wed, 29 May 2024 23:41:32 +0800
Message-ID: <CAMWQL2g6sjWPghTSqyPj0HS3cS79=uMX1YnCkmwow7gqyVZ1nA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 4/5] RISC-V: KVM: add support for SBI_FWFT_PTE_AD_HW_UPDATING
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, greentime.hu@sifive.com, vincent.chen@sifive.com, 
	alex@ghiti.fr, Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2024 at 6:15=E2=80=AFPM Cl=C3=A9ment L=C3=A9ger <cleger@riv=
osinc.com> wrote:
>
>
>
> On 24/05/2024 12:33, Yong-Xuan Wang wrote:
> > Add support for SBI_FWFT_PTE_AD_HW_UPDATING to set the PTE A/D bits
> > updating behavior for Guest/VM.
> >
> > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > ---
> >  arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h |  2 +-
> >  arch/riscv/kvm/vcpu_sbi_fwft.c             | 38 +++++++++++++++++++++-
> >  2 files changed, 38 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h b/arch/riscv/in=
clude/asm/kvm_vcpu_sbi_fwft.h
> > index 7b7bcc5c8fee..3614a44e0a4a 100644
> > --- a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
> > +++ b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
> > @@ -11,7 +11,7 @@
> >
> >  #include <asm/sbi.h>
> >
> > -#define KVM_SBI_FWFT_FEATURE_COUNT   1
> > +#define KVM_SBI_FWFT_FEATURE_COUNT   2
> >
> >  struct kvm_sbi_fwft_config;
> >  struct kvm_vcpu;
> > diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_f=
wft.c
> > index 89ec263c250d..14ef74023340 100644
> > --- a/arch/riscv/kvm/vcpu_sbi_fwft.c
> > +++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
> > @@ -71,6 +71,36 @@ static int kvm_sbi_fwft_get_misaligned_delegation(st=
ruct kvm_vcpu *vcpu,
> >       return SBI_SUCCESS;
> >  }
> >
> > +static int kvm_sbi_fwft_adue_supported(struct kvm_vcpu *vcpu)
> > +{
> > +     if (!riscv_isa_extension_available(vcpu->arch.isa, SVADU))
> > +             return SBI_ERR_NOT_SUPPORTED;
> > +
> > +     return 0;
> > +}
> > +
> > +static int kvm_sbi_fwft_set_adue(struct kvm_vcpu *vcpu, struct kvm_sbi=
_fwft_config *conf,
> > +                              unsigned long value)
> > +{
> > +     if (value)
> > +             vcpu->arch.cfg.henvcfg |=3D ENVCFG_ADUE;
> > +     else
> > +             vcpu->arch.cfg.henvcfg &=3D ~ENVCFG_ADUE;
> > +
> > +     return SBI_SUCCESS;
> > +}
> > +
> > +static int kvm_sbi_fwft_get_adue(struct kvm_vcpu *vcpu, struct kvm_sbi=
_fwft_config *conf,
> > +                              unsigned long *value)
> > +{
> > +     if (!riscv_isa_extension_available(vcpu->arch.isa, SVADU))
> > +             return SBI_ERR_NOT_SUPPORTED;
> > +
> > +     *value =3D !!(vcpu->arch.cfg.henvcfg & ENVCFG_ADUE);
> > +
> > +     return SBI_SUCCESS;
> > +}
>
> Hi Yong-Xuan,
>
> vcpu->arch.cfg.henvcfg seems to be used to update the HENVCFG CSR  only
> during vcpu_load()/vcpu_put(). So if this extension updates it there and
> stays in the execution loop (kvm_arch_vcpu_ioctl_run()) then, it seems
> like the HENVCFG CSR won't be updated immediately but on the next
> vcpu_load(). Is there something I'm missing ?
>
> Thanks,
>
> Cl=C3=A9ment L=C3=A9ger
>

Hi Cl=C3=A9ment,

That's right. I will fix it in the next version. Thank you!

Regards,
Yong-Xuan

> > +
> >  static struct kvm_sbi_fwft_config *
> >  kvm_sbi_fwft_get_config(struct kvm_vcpu *vcpu, enum sbi_fwft_feature_t=
 feature)
> >  {
> > @@ -177,7 +207,13 @@ static const struct kvm_sbi_fwft_feature features[=
] =3D {
> >               .supported =3D kvm_sbi_fwft_misaligned_delegation_support=
ed,
> >               .set =3D kvm_sbi_fwft_set_misaligned_delegation,
> >               .get =3D kvm_sbi_fwft_get_misaligned_delegation,
> > -     }
> > +     },
> > +     {
> > +             .id =3D SBI_FWFT_PTE_AD_HW_UPDATING,
> > +             .supported =3D kvm_sbi_fwft_adue_supported,
> > +             .set =3D kvm_sbi_fwft_set_adue,
> > +             .get =3D kvm_sbi_fwft_get_adue,
> > +     },
> >  };
> >
> >  static_assert(ARRAY_SIZE(features) =3D=3D KVM_SBI_FWFT_FEATURE_COUNT);

