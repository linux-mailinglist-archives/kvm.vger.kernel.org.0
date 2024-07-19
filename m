Return-Path: <kvm+bounces-21915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEDAA937409
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 08:32:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7326B281853
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 06:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897E242076;
	Fri, 19 Jul 2024 06:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="HJS3hmtD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F399F2E859
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 06:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721370753; cv=none; b=dm+lr4Dn4sCopluNNPcUanup/KtYcukO2WKV/rKcME4EqIuUl/eLhg6FJQ6M8e7Odkz5S1K6tOlRP48XLCImzRko9HcHFIb7wXM0xpofR1dp3a00dCduukgdMkbdxfqLovsDU5fIfTERnza1hAxPuca3W1wOujmTRW1TdVUCV7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721370753; c=relaxed/simple;
	bh=a8B/qIi1keFg4IECrISQZreLGCfDFAgluJSce0KQQDU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AqOn3VEoRgCs6pwk5S3hB7dzc/SpcDqC4Ld8e3Ex08AyiDzvBd4qY+aQ1CD8eTA4I3PcEVIZmYrpHXbMv2544F2iElzjgvEgj7lVwpUXvrA6akUJI6zG5u3T+xKf0bRX7A/flU1nAcOuWgkQuDva9qUHv3FLoJXrBHI3y6NGr44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=HJS3hmtD; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3c9cc681ee4so883519b6e.0
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 23:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1721370751; x=1721975551; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jqc7n4s24eVCVx6vruIK+n2XdS/27Yc8wic8xgQ9jc4=;
        b=HJS3hmtDcqxPldXnAXXOwp1dNEG8xZaoevkoEL2nLO54rTsOM/ag/TZA2IW7/NKu0S
         3uFYfMYwFTQrjSzBggMzqzn41s+Z90ZHQWgZxV1ibBi+DjADV/N/LsnBp/iuwSmGEkt6
         oKJoVqEMSAvwI9fL6LnIQ1VHAjmrOssQ2/Tp2xoe7z65ppotlkDNyTdSBjK+vBVa4LlB
         /MYhkjza5RGuqPDu0qC707K7LyfMvsTeJvuOEZOPoA+6wiNmat5F5L93IgnH5CSfFw+Z
         LCOk6KsOnqpTFUkM8F/IJ4FzVU7sgXdf4Oo/zGx7qKMy1GEDkYeYsHKtnlbf9zDIDKz1
         Z/sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721370751; x=1721975551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jqc7n4s24eVCVx6vruIK+n2XdS/27Yc8wic8xgQ9jc4=;
        b=kbAVdupJHmvqDngLSX5BZa4JKac6Z4Pz+/O4MCGD3A0Wu3vbeCce27cXEnV8ahz5jr
         yfwBpm3ECNeWDNsum97FeOMgpf4M8yLk8h+tS8PgaOxRM+icuS9L4+JtXPVfmJYlwe/F
         iAv7+wdVWX41E9ThTKvjc5lewZVb2HslS9g6WaV2Shus/wycQ1Hb2vi+4aSlK+gFvjW8
         gp5vVuk2bZVk6UD9YY6H3N+ZmDcgon35x2qNplT9Jwe+7f2sBRSpLxMgDOJxr5xsogMC
         Rbe97zaTzvLICpRFmMcoBK+PM19bh1LFGz9n4WcokColAbJqbJNWmT/oxJYdnUtgjLOD
         Edgw==
X-Forwarded-Encrypted: i=1; AJvYcCXjvAjcRGYc5BAT2rYHe23OxU3NE1zUVmPgMTqVI13f7AZnmb7VyQAkvO9PCsWJVY3GtnoCwJP3gmhvqZiKilDQYxox
X-Gm-Message-State: AOJu0YzDSJOOaH1j7xF4Dlz2Bwd3/lS7DrET8yS9bAN2Gv0DFaqfrygm
	RT2a9ZD9xyNl8GP4Cl9CJpIjbe1kV/eMWaAQvBRxaAHz4SjnAFgE/HKlwsSuBvAIsVT26u/FBpQ
	0DzSJisMquX2w1RWQ2Unb0r7bImai3NjY7WCv7Q==
X-Google-Smtp-Source: AGHT+IGGkb8iNGYQdyxYAL2KXC9yyie9JA3AkXn7UhIEF/8Maycf76QjzPYbvjeYUm3wkcPnvIa0BTwQ+g0NfKER86w=
X-Received: by 2002:a05:6808:2211:b0:3da:a5fa:9932 with SMTP id
 5614622812f47-3dad1fa3409mr9118917b6e.53.1721370750964; Thu, 18 Jul 2024
 23:32:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240712083850.4242-1-yongxuan.wang@sifive.com>
 <20240712083850.4242-2-yongxuan.wang@sifive.com> <c403de1d-cda8-45bc-a6a2-a92170ad8575@sifive.com>
In-Reply-To: <c403de1d-cda8-45bc-a6a2-a92170ad8575@sifive.com>
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Date: Fri, 19 Jul 2024 14:32:19 +0800
Message-ID: <CAMWQL2hKWkBfV6SgRBQUF9rPAGLyW69oMm9j8RWQv7iGgz9kgQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] RISC-V: Add Svade and Svadu Extensions Support
To: Samuel Holland <samuel.holland@sifive.com>
Cc: greentime.hu@sifive.com, vincent.chen@sifive.com, 
	Jinyu Tang <tjytimi@163.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>, Samuel Ortiz <sameo@rivosinc.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, 
	Evan Green <evan@rivosinc.com>, Xiao Wang <xiao.w.wang@intel.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, "Mike Rapoport (IBM)" <rppt@kernel.org>, 
	Leonardo Bras <leobras@redhat.com>, Charlie Jenkins <charlie@rivosinc.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jisheng Zhang <jszhang@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

On Fri, Jul 19, 2024 at 7:35=E2=80=AFAM Samuel Holland
<samuel.holland@sifive.com> wrote:
>
> Hi Yong-Xuan,
>
> Two trivial comments below for if you send another version of the series.
>
> On 2024-07-12 3:38 AM, Yong-Xuan Wang wrote:
> > Svade and Svadu extensions represent two schemes for managing the PTE A=
/D
> > bits. When the PTE A/D bits need to be set, Svade extension intdicates
> > that a related page fault will be raised. In contrast, the Svadu extens=
ion
> > supports hardware updating of PTE A/D bits. Since the Svade extension i=
s
> > mandatory and the Svadu extension is optional in RVA23 profile, by defa=
ult
> > the M-mode firmware will enable the Svadu extension in the menvcfg CSR
> > when only Svadu is present in DT.
> >
> > This patch detects Svade and Svadu extensions from DT and adds
> > arch_has_hw_pte_young() to enable optimization in MGLRU and
> > __wp_page_copy_user() when we have the PTE A/D bits hardware updating
> > support.
> >
> > Co-developed-by: Jinyu Tang <tjytimi@163.com>
> > Signed-off-by: Jinyu Tang <tjytimi@163.com>
> > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> >  arch/riscv/Kconfig               |  1 +
> >  arch/riscv/include/asm/csr.h     |  1 +
> >  arch/riscv/include/asm/hwcap.h   |  2 ++
> >  arch/riscv/include/asm/pgtable.h | 13 ++++++++++++-
> >  arch/riscv/kernel/cpufeature.c   | 32 ++++++++++++++++++++++++++++++++
> >  5 files changed, 48 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > index 0525ee2d63c7..3d705e28ff85 100644
> > --- a/arch/riscv/Kconfig
> > +++ b/arch/riscv/Kconfig
> > @@ -36,6 +36,7 @@ config RISCV
> >       select ARCH_HAS_PMEM_API
> >       select ARCH_HAS_PREPARE_SYNC_CORE_CMD
> >       select ARCH_HAS_PTE_SPECIAL
> > +     select ARCH_HAS_HW_PTE_YOUNG
>
> These lines should be sorted alphabetically.
>
> >       select ARCH_HAS_SET_DIRECT_MAP if MMU
> >       select ARCH_HAS_SET_MEMORY if MMU
> >       select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
> > diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.=
h
> > index 25966995da04..524cd4131c71 100644
> > --- a/arch/riscv/include/asm/csr.h
> > +++ b/arch/riscv/include/asm/csr.h
> > @@ -195,6 +195,7 @@
> >  /* xENVCFG flags */
> >  #define ENVCFG_STCE                  (_AC(1, ULL) << 63)
> >  #define ENVCFG_PBMTE                 (_AC(1, ULL) << 62)
> > +#define ENVCFG_ADUE                  (_AC(1, ULL) << 61)
> >  #define ENVCFG_CBZE                  (_AC(1, UL) << 7)
> >  #define ENVCFG_CBCFE                 (_AC(1, UL) << 6)
> >  #define ENVCFG_CBIE_SHIFT            4
> > diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hw=
cap.h
> > index e17d0078a651..35d7aa49785d 100644
> > --- a/arch/riscv/include/asm/hwcap.h
> > +++ b/arch/riscv/include/asm/hwcap.h
> > @@ -81,6 +81,8 @@
> >  #define RISCV_ISA_EXT_ZTSO           72
> >  #define RISCV_ISA_EXT_ZACAS          73
> >  #define RISCV_ISA_EXT_XANDESPMU              74
> > +#define RISCV_ISA_EXT_SVADE             75
>
> The number here should be aligned with tabs, like the surrounding lines.
>
> Regards,
> Samuel
>

I will fix them in the next version. Thank you!

Regards,
Yong-Xuan

> > +#define RISCV_ISA_EXT_SVADU          76
> >
> >  #define RISCV_ISA_EXT_XLINUXENVCFG   127
> >
> > diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/=
pgtable.h
> > index aad8b8ca51f1..ec0cdacd7da0 100644
> > --- a/arch/riscv/include/asm/pgtable.h
> > +++ b/arch/riscv/include/asm/pgtable.h
> > @@ -120,6 +120,7 @@
> >  #include <asm/tlbflush.h>
> >  #include <linux/mm_types.h>
> >  #include <asm/compat.h>
> > +#include <asm/cpufeature.h>
> >
> >  #define __page_val_to_pfn(_val)  (((_val) & _PAGE_PFN_MASK) >> _PAGE_P=
FN_SHIFT)
> >
> > @@ -288,7 +289,6 @@ static inline pte_t pud_pte(pud_t pud)
> >  }
> >
> >  #ifdef CONFIG_RISCV_ISA_SVNAPOT
> > -#include <asm/cpufeature.h>
> >
> >  static __always_inline bool has_svnapot(void)
> >  {
> > @@ -624,6 +624,17 @@ static inline pgprot_t pgprot_writecombine(pgprot_=
t _prot)
> >       return __pgprot(prot);
> >  }
> >
> > +/*
> > + * Both Svade and Svadu control the hardware behavior when the PTE A/D=
 bits need to be set. By
> > + * default the M-mode firmware enables the hardware updating scheme wh=
en only Svadu is present in
> > + * DT.
> > + */
> > +#define arch_has_hw_pte_young arch_has_hw_pte_young
> > +static inline bool arch_has_hw_pte_young(void)
> > +{
> > +     return riscv_has_extension_unlikely(RISCV_ISA_EXT_SVADU);
> > +}
> > +
> >  /*
> >   * THP functions
> >   */
> > diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeat=
ure.c
> > index 5ef48cb20ee1..b2c3fe945e89 100644
> > --- a/arch/riscv/kernel/cpufeature.c
> > +++ b/arch/riscv/kernel/cpufeature.c
> > @@ -301,6 +301,8 @@ const struct riscv_isa_ext_data riscv_isa_ext[] =3D=
 {
> >       __RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
> >       __RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
> >       __RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
> > +     __RISCV_ISA_EXT_DATA(svade, RISCV_ISA_EXT_SVADE),
> > +     __RISCV_ISA_EXT_DATA(svadu, RISCV_ISA_EXT_SVADU),
> >       __RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
> >       __RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
> >       __RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
> > @@ -554,6 +556,21 @@ static void __init riscv_fill_hwcap_from_isa_strin=
g(unsigned long *isa2hwcap)
> >                       clear_bit(RISCV_ISA_EXT_v, isainfo->isa);
> >               }
> >
> > +             /*
> > +              * When neither Svade nor Svadu present in DT, it is tech=
nically
> > +              * unknown whether the platform uses Svade or Svadu. Supe=
rvisor may
> > +              * assume Svade to be present and enabled or it can disco=
ver based
> > +              * on mvendorid, marchid, and mimpid. When both Svade and=
 Svadu present
> > +              * in DT, supervisor must assume Svadu turned-off at boot=
 time. To use
> > +              * Svadu, supervisor must explicitly enable it using the =
SBI FWFT extension.
> > +              */
> > +             if (!test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
> > +                 !test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
> > +                     set_bit(RISCV_ISA_EXT_SVADE, isainfo->isa);
> > +             else if (test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
> > +                      test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
> > +                     clear_bit(RISCV_ISA_EXT_SVADU, isainfo->isa);
> > +
> >               /*
> >                * All "okay" hart should have same isa. Set HWCAP based =
on
> >                * common capabilities of every "okay" hart, in case they=
 don't
> > @@ -619,6 +636,21 @@ static int __init riscv_fill_hwcap_from_ext_list(u=
nsigned long *isa2hwcap)
> >
> >               of_node_put(cpu_node);
> >
> > +             /*
> > +              * When neither Svade nor Svadu present in DT, it is tech=
nically
> > +              * unknown whether the platform uses Svade or Svadu. Supe=
rvisor may
> > +              * assume Svade to be present and enabled or it can disco=
ver based
> > +              * on mvendorid, marchid, and mimpid. When both Svade and=
 Svadu present
> > +              * in DT, supervisor must assume Svadu turned-off at boot=
 time. To use
> > +              * Svadu, supervisor must explicitly enable it using the =
SBI FWFT extension.
> > +              */
> > +             if (!test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
> > +                 !test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
> > +                     set_bit(RISCV_ISA_EXT_SVADE, isainfo->isa);
> > +             else if (test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
> > +                      test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
> > +                     clear_bit(RISCV_ISA_EXT_SVADU, isainfo->isa);
> > +
> >               /*
> >                * All "okay" harts should have same isa. Set HWCAP based=
 on
> >                * common capabilities of every "okay" hart, in case they=
 don't.
>

