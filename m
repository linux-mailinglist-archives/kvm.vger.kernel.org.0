Return-Path: <kvm+bounces-18323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E13618D3B1D
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 17:38:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69B0D1F257EE
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 15:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ADBC181B8B;
	Wed, 29 May 2024 15:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="FFnfvxU0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D4612E6D
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 15:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716997077; cv=none; b=BEKLKLYK6rqFkEUyU+3DfaWc9XDYtYK7YaKe5KQdCymuT+7owsJaAotUpYTEStqu+OVj7f3Cyy5QzBxwST1CUFkFi6MgB0ey5vvceZQI4lJdLe4C612Yyf88K8SwVwNO02gaXdDO9FlXHtAiNOqGPykQ59n8nX9j7pdhv7s89MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716997077; c=relaxed/simple;
	bh=0tQvwTQHYBoDEuqQBUPm9eADdKeI20pfFfyJbqRPj8U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ihGOVaEz9qTpNJ1BKPZ0gTrK82ohz3HUqs6ey4N+kEms46YUd6K70pNEfElPCqhVMHAzp//AfiP4v8CtBJ0Y+RuTxBitb2l4RmynfOwLr8+tcY3cHnLoCRP/oC/h7seFwyfaQy3hyTFxRyftiPP3hlZn6KGpi/nGPDuznObf0FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=FFnfvxU0; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5b997b8a7efso853811eaf.0
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 08:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1716997075; x=1717601875; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ov2D+2oeWLpaCt/DoBPVldLq4Kd7iArWem0f5cVDUbY=;
        b=FFnfvxU0G7LkLla2VV+IhOjQ7fBaY2F97dY+3YQcuNrUOLXxIF0luz58G2m0vZA5H6
         d2XXEIxCAHErO0xufYawO2cNUnXFIIZwHMYsRQoObj0SqILO/MF0sFLgYZKSHMVc0zf1
         ZBQNrtQRftBuJqtG/MdO0dEEe0Xl/su+dQrGUMDleIN/m5TvkZB6AFPcebhq2+UHDWhu
         bRIWegkhD3klrPAXcaNFouYeVWUh47Bb8sSriRvCsaaqcby0FlHwNthYGreEbdJ2MX+l
         cw+le2W7pk+a5SLZnD8qIjC9HNQ+y3o8s8XbFHJMKTKIhopQZgZKGxF/ZcKKz97EBrcN
         WGJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716997075; x=1717601875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ov2D+2oeWLpaCt/DoBPVldLq4Kd7iArWem0f5cVDUbY=;
        b=dQf5EbRAalgZOt+8cx32sUG6elj1nRFylCXPkEZycOf0D1fcARv0AXBWUbnZnlG4aL
         wltayuP8sOj1ovzbJcq9u8zb5V/30HoubxIWZcjaZvgrvogpVfhVx1kp4/RK6/wyKbCB
         iaLuO0+L2djavVAQRR1h3Cvxt6s4eNGmoL5RMuCeekuMttcXbn99FuyxtDW+xfvjHI0p
         b6vAZqk3L/qwQ4BHBxRZGmohqxqfUDqILlvLQokRiuuOOOIvuiJBHPkwc69yqpknNJQO
         ekpQjBHXUP/2z57qfzga/r37LPrHjEsAFWpMN6hCevUrLjsWWfBucqpXhjp9oErPDsH3
         qT3g==
X-Forwarded-Encrypted: i=1; AJvYcCU/Z/REuVJI8KxbZ24SISCoVrrGcXw5jkMHArbTkiPjEd3dIwFUIQOmGOLhqaNbHSzYT++BHJfKikuXIdgp3vIUlP+h
X-Gm-Message-State: AOJu0YzNBSbj5pXgtKdl7QV6xImvdXOJz/SqYakcttoDLnZfYfln2cO1
	ED4JgXd/hOfaNjd43GZxDCA6SciZRwzNBRuhFyltvvfQhr6bgJx6l9if+SmSF6diulJpAxFrRee
	mquiihROim9+Un72QTBKhH2hFS5xRKtiQ6RqxXA==
X-Google-Smtp-Source: AGHT+IGS7W148PMF8J8TUAXvOdM8fKSQLm9b76VbH7+E9Q81U1pf2I4K4Hql5K8R89EuENV+uk3qfP8BUCLdH0RZV7k=
X-Received: by 2002:a05:6820:d89:b0:5b9:89d9:c5ee with SMTP id
 006d021491bc7-5b989d9c7a9mr9559064eaf.1.1716997075096; Wed, 29 May 2024
 08:37:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240524103307.2684-1-yongxuan.wang@sifive.com>
 <20240524103307.2684-2-yongxuan.wang@sifive.com> <20240527-41b376a2bfedb3b9cf7e9c7b@orel>
In-Reply-To: <20240527-41b376a2bfedb3b9cf7e9c7b@orel>
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Date: Wed, 29 May 2024 23:37:43 +0800
Message-ID: <CAMWQL2iwH_hiwXD7QtzvioQsjfrU=o7jd0hWF6K-Kd=XM3w7Ng@mail.gmail.com>
Subject: Re: [RFC PATCH v4 1/5] RISC-V: Detect and Enable Svadu Extension Support
To: Andrew Jones <ajones@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, greentime.hu@sifive.com, vincent.chen@sifive.com, 
	cleger@rivosinc.com, alex@ghiti.fr, Jinyu Tang <tjytimi@163.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	Samuel Holland <samuel.holland@sifive.com>, Samuel Ortiz <sameo@rivosinc.com>, 
	Evan Green <evan@rivosinc.com>, Xiao Wang <xiao.w.wang@intel.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, "Mike Rapoport (IBM)" <rppt@kernel.org>, 
	Jisheng Zhang <jszhang@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Charlie Jenkins <charlie@rivosinc.com>, Leonardo Bras <leobras@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, May 28, 2024 at 12:25=E2=80=AFAM Andrew Jones <ajones@ventanamicro.=
com> wrote:
>
> On Fri, May 24, 2024 at 06:33:01PM GMT, Yong-Xuan Wang wrote:
> > Svadu is a RISC-V extension for hardware updating of PTE A/D bits.
> >
> > In this patch we detect Svadu extension support from DTB and enable it
> > with SBI FWFT extension. Also we add arch_has_hw_pte_young() to enable
> > optimization in MGLRU and __wp_page_copy_user() if Svadu extension is
> > available.
> >
> > Co-developed-by: Jinyu Tang <tjytimi@163.com>
> > Signed-off-by: Jinyu Tang <tjytimi@163.com>
> > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>
> I think this patch changed too much to keep r-b's. We didn't have the
> FWFT part before.
>

ok, I will remove them.

> > ---
> >  arch/riscv/Kconfig               |  1 +
> >  arch/riscv/include/asm/csr.h     |  1 +
> >  arch/riscv/include/asm/hwcap.h   |  1 +
> >  arch/riscv/include/asm/pgtable.h |  8 +++++++-
> >  arch/riscv/kernel/cpufeature.c   | 11 +++++++++++
> >  5 files changed, 21 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > index be09c8836d56..30fa558ee284 100644
> > --- a/arch/riscv/Kconfig
> > +++ b/arch/riscv/Kconfig
> > @@ -34,6 +34,7 @@ config RISCV
> >       select ARCH_HAS_PMEM_API
> >       select ARCH_HAS_PREPARE_SYNC_CORE_CMD
> >       select ARCH_HAS_PTE_SPECIAL
> > +     select ARCH_HAS_HW_PTE_YOUNG
> >       select ARCH_HAS_SET_DIRECT_MAP if MMU
> >       select ARCH_HAS_SET_MEMORY if MMU
> >       select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
> > diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.=
h
> > index 2468c55933cd..2ac270ad4acd 100644
> > --- a/arch/riscv/include/asm/csr.h
> > +++ b/arch/riscv/include/asm/csr.h
> > @@ -194,6 +194,7 @@
> >  /* xENVCFG flags */
> >  #define ENVCFG_STCE                  (_AC(1, ULL) << 63)
> >  #define ENVCFG_PBMTE                 (_AC(1, ULL) << 62)
> > +#define ENVCFG_ADUE                  (_AC(1, ULL) << 61)
> >  #define ENVCFG_CBZE                  (_AC(1, UL) << 7)
> >  #define ENVCFG_CBCFE                 (_AC(1, UL) << 6)
> >  #define ENVCFG_CBIE_SHIFT            4
> > diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hw=
cap.h
> > index e17d0078a651..8d539e3f4e11 100644
> > --- a/arch/riscv/include/asm/hwcap.h
> > +++ b/arch/riscv/include/asm/hwcap.h
> > @@ -81,6 +81,7 @@
> >  #define RISCV_ISA_EXT_ZTSO           72
> >  #define RISCV_ISA_EXT_ZACAS          73
> >  #define RISCV_ISA_EXT_XANDESPMU              74
> > +#define RISCV_ISA_EXT_SVADU          75
> >
> >  #define RISCV_ISA_EXT_XLINUXENVCFG   127
> >
> > diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/=
pgtable.h
> > index 9f8ea0e33eb1..1f1b326ccf63 100644
> > --- a/arch/riscv/include/asm/pgtable.h
> > +++ b/arch/riscv/include/asm/pgtable.h
> > @@ -117,6 +117,7 @@
> >  #include <asm/tlbflush.h>
> >  #include <linux/mm_types.h>
> >  #include <asm/compat.h>
> > +#include <asm/cpufeature.h>
> >
> >  #define __page_val_to_pfn(_val)  (((_val) & _PAGE_PFN_MASK) >> _PAGE_P=
FN_SHIFT)
> >
> > @@ -285,7 +286,6 @@ static inline pte_t pud_pte(pud_t pud)
> >  }
> >
> >  #ifdef CONFIG_RISCV_ISA_SVNAPOT
> > -#include <asm/cpufeature.h>
> >
> >  static __always_inline bool has_svnapot(void)
> >  {
> > @@ -621,6 +621,12 @@ static inline pgprot_t pgprot_writecombine(pgprot_=
t _prot)
> >       return __pgprot(prot);
> >  }
> >
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
> > index 3ed2359eae35..b023908c5932 100644
> > --- a/arch/riscv/kernel/cpufeature.c
> > +++ b/arch/riscv/kernel/cpufeature.c
> > @@ -93,6 +93,16 @@ static bool riscv_isa_extension_check(int id)
> >                       return false;
> >               }
> >               return true;
> > +     case RISCV_ISA_EXT_SVADU:
> > +             if (sbi_probe_extension(SBI_EXT_FWFT) > 0) {
>
> I think we've decided the appropriate way to prove for SBI extensions is
> to first ensure the SBI version and then do the probe, like we do for STA
> in has_pv_steal_clock()
>

ok, I will add the SBI version check.

> > +                     struct sbiret ret;
> > +
> > +                     ret =3D sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,=
 SBI_FWFT_PTE_AD_HW_UPDATING,
> > +                                     1, 0, 0, 0, 0);
> > +
> > +                     return ret.error =3D=3D SBI_SUCCESS;
> > +             }
> > +             return false;
> >       case RISCV_ISA_EXT_INVALID:
> >               return false;
> >       }
> > @@ -301,6 +311,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] =3D=
 {
> >       __RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
> >       __RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
> >       __RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
> > +     __RISCV_ISA_EXT_SUPERSET(svadu, RISCV_ISA_EXT_SVADU, riscv_xlinux=
envcfg_exts),
>
> We do we need XLINUXENVCFG?
>

Sorry, I misunderstood the comments of riscv_xlinuxenvcfg_exts, I will
remove it in the next version.

Regards,
Yong-Xuan


> Thanks,
> drew
>
> >       __RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
> >       __RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
> >       __RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
> > --
> > 2.17.1
> >

