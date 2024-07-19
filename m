Return-Path: <kvm+bounces-21916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8254393741F
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 08:52:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 110381F22E12
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 06:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BAC34A9B0;
	Fri, 19 Jul 2024 06:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="U7/v25jE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81DC3EA6C
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 06:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721371919; cv=none; b=ThLdpPFz5H6AnAM1fMEziEBfCRSmJKrFcVf39yY3bfNwiQo/Rq0hS0DlUCaGJURkK/KZcffn4LN4YqXbTlpm9hV/7lI5Yu6bhXJUtukVTA+FAyBRVYyelyOjd82OfIvid8/tlY322ynFBt0pgX0Ju+/7J03EcjJfiQG7chaQPTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721371919; c=relaxed/simple;
	bh=X8aR3NZARekWwvqLtr0gf1GfRURNkTJpTQz/Gq9Rk7k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cES7REtvnxbrs3S6N24lxiYnb0fNhVuuixMR80/42uygNeleZp6mVXIUKUz4QT7ZIeHcnSp/Up2a4rXpBzUyKJz+QNn7SyDmnggt5bI4EDwXAOdRYZcrP8c4FhttvRViJw9UM9Zd99JgiLVCnM6H2rCp8/2IEXk4Lxxj+tKcRX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=U7/v25jE; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3dae221e42dso94353b6e.0
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 23:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1721371917; x=1721976717; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zOrnXxWvbVRsS08Q5SrQnWsHda2iVamAcSxg6GkGdcw=;
        b=U7/v25jEaR/k3EKnpkTCi02Xm1IHFmnGrrKr44y2IvWNe7NU3tpovIGKpQRpPiOS8t
         2bGZRIoGKJvVOt1fYODfebAznH2rrHstsJycKHIqesgmy8LpcQROH1meC0LnMe9QT90v
         yVNS4boIZ6N2iLeKfMyH/oIAH+6MvRYJHEsEjePw6ntxdhe2XZFiBTUomnhPqgXvYO56
         Zt+PdGO3wg8wMrnENcZEOkcYfUpjkz7wl2g1Wxs5aeXeVOXR94jfISRpxAAjpK5KgY62
         TnBz6XRJXoq0tA617ZZyv4nWvCyt4/7YgmkrD+JeM7mRxfLI4XA3R4JGjhygb/8KB1tc
         nEfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721371917; x=1721976717;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zOrnXxWvbVRsS08Q5SrQnWsHda2iVamAcSxg6GkGdcw=;
        b=m8n37NejSBTCrPIZl1XadQLyOOApFl0GvPNVZvPfAMmXTVJHE/0wSVRXfesxwmH4GH
         rWE2dKHzS6xU6cIGKw4t0qJKAagKUr+pXojehfQxTzM+SfUUHMJR5vje9JlDSLHIJd/5
         fBo8dQPt8YVs55ynFjzABNvA9jqlDzZhkShPyL/dtNTEMDeVToBzhmbBgtDT8pckKgzl
         sAZFf3Nrpc+2yXy1MoKQgNR4galbFDaOQHuIIWnW51qkJOKow4muud+E//OGWlhtEZQz
         lKbAepUjByO60k6LgH5njHTkB0Rjyrafnif/Jp+wv3/HR1BXyQpBOTE6F2KlNuw7cbsN
         2vkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWB62KLpzIzc33boHDBEs1usjdYEWOXExM0/dZ4MRaW8M0d+q9MJiq+8qXMFsYYwVHYDHODVl50bMe7RXR8W1QcHdfI
X-Gm-Message-State: AOJu0YzBz7pfF2j8P0qji75b/IQye1TvTc0Td4iFwELnsZgjk78H7Zdl
	/KmGAMQZJiiD6NVIp3IORmmOH+lX+mi7FFLLe24aeSgspAhuyBlSeEa6qveo6FU6z/P/XArgnxx
	njpOFBYJmMEnW+BlYZyKI9QEY77hIsU+OAfgv/w==
X-Google-Smtp-Source: AGHT+IHbQam/E7zhkcddpAOBTeSvSJMP46EYDtweZ41PTxcwvfNsqz0vSMmC/XB0/o5+90ZNsqHlqdZ0Awb+viDokRc=
X-Received: by 2002:a05:6808:1301:b0:3d9:3a3e:48b9 with SMTP id
 5614622812f47-3dad7792029mr6306813b6e.45.1721371916843; Thu, 18 Jul 2024
 23:51:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240712083850.4242-1-yongxuan.wang@sifive.com>
 <20240712083850.4242-4-yongxuan.wang@sifive.com> <60555952-7307-41ed-bd6f-17a179089596@sifive.com>
In-Reply-To: <60555952-7307-41ed-bd6f-17a179089596@sifive.com>
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Date: Fri, 19 Jul 2024 14:51:46 +0800
Message-ID: <CAMWQL2hCkEeTOqk5tHhhmsxKNknzGfLq=UOQ3Xx94L59YyA_WQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] RISC-V: KVM: Add Svade and Svadu Extensions
 Support for Guest/VM
To: Samuel Holland <samuel.holland@sifive.com>
Cc: greentime.hu@sifive.com, vincent.chen@sifive.com, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

On Fri, Jul 19, 2024 at 8:22=E2=80=AFAM Samuel Holland
<samuel.holland@sifive.com> wrote:
>
> Hi Yong-Xuan,
>
> On 2024-07-12 3:38 AM, Yong-Xuan Wang wrote:
> > We extend the KVM ISA extension ONE_REG interface to allow VMM tools to
> > detect and enable Svade and Svadu extensions for Guest/VM. Since the
> > henvcfg.ADUE is read-only zero if the menvcfg.ADUE is zero, the Svadu
> > extension is available for Guest/VM and the Svade extension is allowed
> > to disabledonly when arch_has_hw_pte_young() is true.
> >
> > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> >  arch/riscv/include/uapi/asm/kvm.h |  2 ++
> >  arch/riscv/kvm/vcpu.c             |  3 +++
> >  arch/riscv/kvm/vcpu_onereg.c      | 15 +++++++++++++++
> >  3 files changed, 20 insertions(+)
> >
> > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uap=
i/asm/kvm.h
> > index e878e7cc3978..a5e0c35d7e9a 100644
> > --- a/arch/riscv/include/uapi/asm/kvm.h
> > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > @@ -168,6 +168,8 @@ enum KVM_RISCV_ISA_EXT_ID {
> >       KVM_RISCV_ISA_EXT_ZTSO,
> >       KVM_RISCV_ISA_EXT_ZACAS,
> >       KVM_RISCV_ISA_EXT_SSCOFPMF,
> > +     KVM_RISCV_ISA_EXT_SVADE,
> > +     KVM_RISCV_ISA_EXT_SVADU,
> >       KVM_RISCV_ISA_EXT_MAX,
> >  };
> >
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 17e21df36cc1..64a15af459e0 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -540,6 +540,9 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_=
vcpu *vcpu)
> >       if (riscv_isa_extension_available(isa, ZICBOZ))
> >               cfg->henvcfg |=3D ENVCFG_CBZE;
> >
> > +     if (riscv_isa_extension_available(isa, SVADU))
> > +             cfg->henvcfg |=3D ENVCFG_ADUE;
>
> This is correct for now because patch 1 ensures the host (and therefore a=
lso the
> guest) never has both Svade and Svadu available. When that changes, this =
check
> will need to add an "&& !riscv_isa_extension_available(isa, SVADE)" condi=
tion so
> it matches the behavior described in the DT binding. There's no need to r=
esend
> to make this addition, but if you do, it wouldn't hurt to include it so i=
t's not
> forgotten later. (It looks maybe like v6 only partially implemented Andre=
w's
> suggestion?)
>
> Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
>

Yeah, since the PATCH1 can ensure that only Svade or Svadu will be used, so=
 I
removed the Svade checking there. I will add it back in the next version. T=
hank
you!

Regards,
Yong-Xuan

> > +
> >       if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN)) {
> >               cfg->hstateen0 |=3D SMSTATEEN0_HSENVCFG;
> >               if (riscv_isa_extension_available(isa, SSAIA))
> > diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.=
c
> > index 62874fbca29f..474fdeafe9fe 100644
> > --- a/arch/riscv/kvm/vcpu_onereg.c
> > +++ b/arch/riscv/kvm/vcpu_onereg.c
> > @@ -15,6 +15,7 @@
> >  #include <asm/cacheflush.h>
> >  #include <asm/cpufeature.h>
> >  #include <asm/kvm_vcpu_vector.h>
> > +#include <asm/pgtable.h>
> >  #include <asm/vector.h>
> >
> >  #define KVM_RISCV_BASE_ISA_MASK              GENMASK(25, 0)
> > @@ -38,6 +39,8 @@ static const unsigned long kvm_isa_ext_arr[] =3D {
> >       KVM_ISA_EXT_ARR(SSAIA),
> >       KVM_ISA_EXT_ARR(SSCOFPMF),
> >       KVM_ISA_EXT_ARR(SSTC),
> > +     KVM_ISA_EXT_ARR(SVADE),
> > +     KVM_ISA_EXT_ARR(SVADU),
> >       KVM_ISA_EXT_ARR(SVINVAL),
> >       KVM_ISA_EXT_ARR(SVNAPOT),
> >       KVM_ISA_EXT_ARR(SVPBMT),
> > @@ -105,6 +108,12 @@ static bool kvm_riscv_vcpu_isa_enable_allowed(unsi=
gned long ext)
> >               return __riscv_isa_extension_available(NULL, RISCV_ISA_EX=
T_SSAIA);
> >       case KVM_RISCV_ISA_EXT_V:
> >               return riscv_v_vstate_ctrl_user_allowed();
> > +     case KVM_RISCV_ISA_EXT_SVADU:
> > +             /*
> > +              * The henvcfg.ADUE is read-only zero if menvcfg.ADUE is =
zero.
> > +              * Guest OS can use Svadu only when host os enable Svadu.
> > +              */
> > +             return arch_has_hw_pte_young();
> >       default:
> >               break;
> >       }
> > @@ -167,6 +176,12 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(uns=
igned long ext)
> >       /* Extensions which can be disabled using Smstateen */
> >       case KVM_RISCV_ISA_EXT_SSAIA:
> >               return riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATE=
EN);
> > +     case KVM_RISCV_ISA_EXT_SVADE:
> > +             /*
> > +              * The henvcfg.ADUE is read-only zero if menvcfg.ADUE is =
zero.
> > +              * Svade is not allowed to disable when the platform use =
Svade.
> > +              */
> > +             return arch_has_hw_pte_young();
> >       default:
> >               break;
> >       }
>

