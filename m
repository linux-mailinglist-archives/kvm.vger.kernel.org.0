Return-Path: <kvm+bounces-22031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5161593877E
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 04:16:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6ABCF1C20C27
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 02:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47F36101E6;
	Mon, 22 Jul 2024 02:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="T2i+5H6V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39DE8801
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 02:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721614552; cv=none; b=uYxiknXWb6hWtrwckLadTsorC6L7XMnB9DG/VkmtvAB+3x2lVJe/EgTLZqUggyoIwpmKsS6P6kG7sH9m7MwOhlJkSPmRqYINz4Lz98A3zCbj//XnSewfQlfGDZTxsiz2UQYsMExAuYUCz7BwhzuYYL3s4qia/dSLmGr12T+Bj00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721614552; c=relaxed/simple;
	bh=yphmX1TKQ9qi/ZyqAMA/8YTigiBJfzot0d5eSQTpugg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BgY3aqUc2TgJFWuutaH6tunHVsvCF6U9FQSmn32E2xhOR0m4117zRogcedV/7mVw+X1n3dR75KjCPKBiTMmS2X9LWI4k03smu/O3uxpY21EaSITrJF8ZseLmADj654iKFAyrc0t3NgKR6XlNHKQgKWwnGZgMEpnUJYDWcb+DEN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=T2i+5H6V; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-70388567d24so2150336a34.0
        for <kvm@vger.kernel.org>; Sun, 21 Jul 2024 19:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1721614550; x=1722219350; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0xvGmjmivgHb95fqKTA/RvEneQkiZLUnnuZegb5vAT8=;
        b=T2i+5H6V9zmaihCztwNm3tvHnSmIsrYwAHZY4XiCkDFHSJSCiSejQ8IwoUEM05wbV8
         ua/c3WoZav+yOUe5UYyvW/PjczEm+lEBAoZEy7D9u1YrAk2SDRcsV99egbtybWBQvvqd
         hw3QZJ27Q5j4GTCVDCPShVI8mWJcUkFdjD0BJqtgLOIWYWGA4VTI4uL+xFW46OTqXKup
         mmyyxGaQhp0Or7S/F4SY1oZ4Ut44RQmyrAGc6pf+AYQooM6WZ10c9Q+qKA/YhfUyqbEA
         EhaPdXgTR9xjKT6/7brIAnQ7F5Oh0BvjMHoPUwhW81o/BzBmA9/q5jEsHLusVeb9MaWq
         uCpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721614550; x=1722219350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0xvGmjmivgHb95fqKTA/RvEneQkiZLUnnuZegb5vAT8=;
        b=FY14xrbks2qa80r9DQqillgvaDkt8ka7nAohDdbh7Ia09SB6nPAAB0XPylsrC19vyS
         YH+9p7Tk8uhCfQ5vOkny0hOELympGQjCwi/LmZsUCfHW4QukApT6MoC/e3onCmh+MLQi
         TJioFy0zP6Cwo1h5gmYzGwMwKm6gh7I3Lim7KiqE3SjA+s0hvsso9uWCDYAvYbrYzFti
         j6q4/1i6rfKrcrj5PQoucjQSifSkah6lhnWP/LVqDUjrnEQGhOCSnsaIIwG/yqUh1Wkd
         GKwMeDEzq86Od18FrKn1oGwAG6ijArhQK1me6YhstR4qh6KDM+IQlMwt0wKIAgecyjuH
         4sIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIsYm4QfdtX+HDZ++Lz/KSJFvZwwYohuez6R9srGS/HOqml1aDOlr1xR8uEtdG3XtYafe+qvHT6lleb+HVToJz2exM
X-Gm-Message-State: AOJu0Yz32oieZkEeyJs+hjKFQ6ieMj72QxJbg69ruh9mJ8EZUGwAVn1f
	FGZwQeWjgprsmvYx7lrxpRwubcUzeH+LyeR30fYCg+6GvWChmQtiC9btw4+E1p9syFZu41QTeSS
	pMSppVCsNcU4WCCKqh8xkqJBPFTxXT79Oc04Wrw==
X-Google-Smtp-Source: AGHT+IGy8EGXhU/Y1aAR73X2BqKakPiS49me7AoWcRo43dyZ03I8ZqfZ6txxgWUCwzmo8e5D+pjLhwu5GRuFVklCRrQ=
X-Received: by 2002:a05:6870:fb8f:b0:254:f00e:56a2 with SMTP id
 586e51a60fabf-2612130e7efmr5576520fac.9.1721614549848; Sun, 21 Jul 2024
 19:15:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240712083850.4242-1-yongxuan.wang@sifive.com>
 <20240712083850.4242-2-yongxuan.wang@sifive.com> <6ad0c386-6777-4467-bab4-8fba149f3bfe@ghiti.fr>
 <2f1c7dff-168e-4ad0-b426-cfe99fc33fd0@rivosinc.com>
In-Reply-To: <2f1c7dff-168e-4ad0-b426-cfe99fc33fd0@rivosinc.com>
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Date: Mon, 22 Jul 2024 10:15:39 +0800
Message-ID: <CAMWQL2j++-11jQjFweoZWWxRDjqUYT9CR-motNUrTVibpSxFOQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] RISC-V: Add Svade and Svadu Extensions Support
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, greentime.hu@sifive.com, vincent.chen@sifive.com, 
	Jinyu Tang <tjytimi@163.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>, Samuel Ortiz <sameo@rivosinc.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Samuel Holland <samuel.holland@sifive.com>, 
	Evan Green <evan@rivosinc.com>, Xiao Wang <xiao.w.wang@intel.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, "Mike Rapoport (IBM)" <rppt@kernel.org>, 
	Leonardo Bras <leobras@redhat.com>, Charlie Jenkins <charlie@rivosinc.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jisheng Zhang <jszhang@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Cl=C3=A9ment,

On Fri, Jul 19, 2024 at 3:38=E2=80=AFPM Cl=C3=A9ment L=C3=A9ger <cleger@riv=
osinc.com> wrote:
>
>
>
> Hi Yong-Xuan,
>
>
> On 18/07/2024 18:43, Alexandre Ghiti wrote:
> > Hi Yong-Xuan,
> >
> > On 12/07/2024 10:38, Yong-Xuan Wang wrote:
> >> Svade and Svadu extensions represent two schemes for managing the PTE =
A/D
> >> bits. When the PTE A/D bits need to be set, Svade extension intdicates
> >> that a related page fault will be raised. In contrast, the Svadu
> >> extension
> >> supports hardware updating of PTE A/D bits. Since the Svade extension =
is
> >> mandatory and the Svadu extension is optional in RVA23 profile, by
> >> default
> >> the M-mode firmware will enable the Svadu extension in the menvcfg CSR
> >> when only Svadu is present in DT.
> >>
> >> This patch detects Svade and Svadu extensions from DT and adds
> >> arch_has_hw_pte_young() to enable optimization in MGLRU and
> >> __wp_page_copy_user() when we have the PTE A/D bits hardware updating
> >> support.
> >>
> >> Co-developed-by: Jinyu Tang <tjytimi@163.com>
> >> Signed-off-by: Jinyu Tang <tjytimi@163.com>
> >> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> >> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> >> ---
> >>   arch/riscv/Kconfig               |  1 +
> >>   arch/riscv/include/asm/csr.h     |  1 +
> >>   arch/riscv/include/asm/hwcap.h   |  2 ++
> >>   arch/riscv/include/asm/pgtable.h | 13 ++++++++++++-
> >>   arch/riscv/kernel/cpufeature.c   | 32 ++++++++++++++++++++++++++++++=
++
> >>   5 files changed, 48 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> >> index 0525ee2d63c7..3d705e28ff85 100644
> >> --- a/arch/riscv/Kconfig
> >> +++ b/arch/riscv/Kconfig
> >> @@ -36,6 +36,7 @@ config RISCV
> >>       select ARCH_HAS_PMEM_API
> >>       select ARCH_HAS_PREPARE_SYNC_CORE_CMD
> >>       select ARCH_HAS_PTE_SPECIAL
> >> +    select ARCH_HAS_HW_PTE_YOUNG
> >>       select ARCH_HAS_SET_DIRECT_MAP if MMU
> >>       select ARCH_HAS_SET_MEMORY if MMU
> >>       select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
> >> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr=
.h
> >> index 25966995da04..524cd4131c71 100644
> >> --- a/arch/riscv/include/asm/csr.h
> >> +++ b/arch/riscv/include/asm/csr.h
> >> @@ -195,6 +195,7 @@
> >>   /* xENVCFG flags */
> >>   #define ENVCFG_STCE            (_AC(1, ULL) << 63)
> >>   #define ENVCFG_PBMTE            (_AC(1, ULL) << 62)
> >> +#define ENVCFG_ADUE            (_AC(1, ULL) << 61)
> >>   #define ENVCFG_CBZE            (_AC(1, UL) << 7)
> >>   #define ENVCFG_CBCFE            (_AC(1, UL) << 6)
> >>   #define ENVCFG_CBIE_SHIFT        4
> >> diff --git a/arch/riscv/include/asm/hwcap.h
> >> b/arch/riscv/include/asm/hwcap.h
> >> index e17d0078a651..35d7aa49785d 100644
> >> --- a/arch/riscv/include/asm/hwcap.h
> >> +++ b/arch/riscv/include/asm/hwcap.h
> >> @@ -81,6 +81,8 @@
> >>   #define RISCV_ISA_EXT_ZTSO        72
> >>   #define RISCV_ISA_EXT_ZACAS        73
> >>   #define RISCV_ISA_EXT_XANDESPMU        74
> >> +#define RISCV_ISA_EXT_SVADE             75
> >> +#define RISCV_ISA_EXT_SVADU        76
> >>     #define RISCV_ISA_EXT_XLINUXENVCFG    127
> >>   diff --git a/arch/riscv/include/asm/pgtable.h
> >> b/arch/riscv/include/asm/pgtable.h
> >> index aad8b8ca51f1..ec0cdacd7da0 100644
> >> --- a/arch/riscv/include/asm/pgtable.h
> >> +++ b/arch/riscv/include/asm/pgtable.h
> >> @@ -120,6 +120,7 @@
> >>   #include <asm/tlbflush.h>
> >>   #include <linux/mm_types.h>
> >>   #include <asm/compat.h>
> >> +#include <asm/cpufeature.h>
> >>     #define __page_val_to_pfn(_val)  (((_val) & _PAGE_PFN_MASK) >>
> >> _PAGE_PFN_SHIFT)
> >>   @@ -288,7 +289,6 @@ static inline pte_t pud_pte(pud_t pud)
> >>   }
> >>     #ifdef CONFIG_RISCV_ISA_SVNAPOT
> >> -#include <asm/cpufeature.h>
> >>     static __always_inline bool has_svnapot(void)
> >>   {
> >> @@ -624,6 +624,17 @@ static inline pgprot_t
> >> pgprot_writecombine(pgprot_t _prot)
> >>       return __pgprot(prot);
> >>   }
> >>   +/*
> >> + * Both Svade and Svadu control the hardware behavior when the PTE
> >> A/D bits need to be set. By
> >> + * default the M-mode firmware enables the hardware updating scheme
> >> when only Svadu is present in
> >> + * DT.
> >> + */
> >> +#define arch_has_hw_pte_young arch_has_hw_pte_young
> >> +static inline bool arch_has_hw_pte_young(void)
> >> +{
> >> +    return riscv_has_extension_unlikely(RISCV_ISA_EXT_SVADU);
> >> +}
> >> +
> >>   /*
> >>    * THP functions
> >>    */
> >> diff --git a/arch/riscv/kernel/cpufeature.c
> >> b/arch/riscv/kernel/cpufeature.c
> >> index 5ef48cb20ee1..b2c3fe945e89 100644
> >> --- a/arch/riscv/kernel/cpufeature.c
> >> +++ b/arch/riscv/kernel/cpufeature.c
> >> @@ -301,6 +301,8 @@ const struct riscv_isa_ext_data riscv_isa_ext[] =
=3D {
> >>       __RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
> >>       __RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
> >>       __RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
> >> +    __RISCV_ISA_EXT_DATA(svade, RISCV_ISA_EXT_SVADE),
> >> +    __RISCV_ISA_EXT_DATA(svadu, RISCV_ISA_EXT_SVADU),
> >>       __RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
> >>       __RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
> >>       __RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
> >> @@ -554,6 +556,21 @@ static void __init
> >> riscv_fill_hwcap_from_isa_string(unsigned long *isa2hwcap)
> >>               clear_bit(RISCV_ISA_EXT_v, isainfo->isa);
> >>           }
> >>   +        /*
> >> +         * When neither Svade nor Svadu present in DT, it is technica=
lly
> >> +         * unknown whether the platform uses Svade or Svadu.
> >> Supervisor may
> >> +         * assume Svade to be present and enabled or it can discover
> >> based
> >> +         * on mvendorid, marchid, and mimpid. When both Svade and
> >> Svadu present
> >> +         * in DT, supervisor must assume Svadu turned-off at boot
> >> time. To use
> >> +         * Svadu, supervisor must explicitly enable it using the SBI
> >> FWFT extension.
> >> +         */
> >> +        if (!test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
> >> +            !test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
> >> +            set_bit(RISCV_ISA_EXT_SVADE, isainfo->isa);
> >> +        else if (test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
> >> +             test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
> >> +            clear_bit(RISCV_ISA_EXT_SVADU, isainfo->isa);
> >> +
> >>           /*
> >>            * All "okay" hart should have same isa. Set HWCAP based on
> >>            * common capabilities of every "okay" hart, in case they do=
n't
> >> @@ -619,6 +636,21 @@ static int __init
> >> riscv_fill_hwcap_from_ext_list(unsigned long *isa2hwcap)
> >>             of_node_put(cpu_node);
> >>   +        /*
> >> +         * When neither Svade nor Svadu present in DT, it is technica=
lly
> >> +         * unknown whether the platform uses Svade or Svadu.
> >> Supervisor may
> >> +         * assume Svade to be present and enabled or it can discover
> >> based
> >> +         * on mvendorid, marchid, and mimpid. When both Svade and
> >> Svadu present
> >> +         * in DT, supervisor must assume Svadu turned-off at boot
> >> time. To use
> >> +         * Svadu, supervisor must explicitly enable it using the SBI
> >> FWFT extension.
> >> +         */
> >> +        if (!test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
> >> +            !test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
> >> +            set_bit(RISCV_ISA_EXT_SVADE, isainfo->isa);
> >> +        else if (test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
> >> +             test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
> >> +            clear_bit(RISCV_ISA_EXT_SVADU, isainfo->isa);
> >> +
>
> This is a duplicate of the previous chunk of code. Moreover, now that we
> have a .validate callback for ISA extension (in for-next), I would
> prefer this to be based on that support rather that having duplicated
> extension specific handling code.
>
> I think this could be translated (almost) using the following
> .validate() callback for SVADU/SVADE extension:
>
> static int riscv_ext_svadu_validate(const struct riscv_isa_ext_data *data=
,
>                                   const unsigned long *isa_bitmap)
> {
>         /* SVADE has already been detected, use SVADE only */
>         if (__riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_SVA=
DE))
>                 return -ENOTSUPP;
>
>         return 0;
> }
>
> static int riscv_ext_svade_validate(const struct riscv_isa_ext_data *data=
,
>                                   const unsigned long *isa_bitmap)
> {
>         /* Clear SVADU, it will be enable using the FWFT extension if pre=
sent */
>         clear_bit(RISCV_ISA_EXT_SVADU, isa_bitmap);
>
>         return 0;
> }
>
> However, this will not enable SVADE if neither SVADU/SVADE are set (as
> done by your patch) but since SVADE does not seems to be used explicitly
> in your patch series, I think it is sane to keep it like that.
>
> Thanks,
>
> Cl=C3=A9ment
>
>

Got it. I will rebase to the for-next branch. Thank you!

Regards,
Yong-Xuan

>
> >>           /*
> >>            * All "okay" harts should have same isa. Set HWCAP based on
> >>            * common capabilities of every "okay" hart, in case they
> >> don't.
> >
> >
> > Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> >
> > Thanks,
> >
> > Alex
> >

