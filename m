Return-Path: <kvm+bounces-18377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 659528D4827
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:11:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAD4A1F219AD
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 09:11:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 663DE183980;
	Thu, 30 May 2024 09:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="dvddpCgC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B428C18396D
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 09:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717060278; cv=none; b=sl9IJjsng+VfKIGgEtnCRLlp+Cj4Y/FGqacKM3AfNA3C55roLWaaPE56ZiNK7KzaqT7aBDFcUsE6H3kg7GyCh81/HRX99+2Gt4vGXYJGAge8Vg7X/K8m5HASO1yXWejxtC0+/VsQbRwiDbO+E+X2g224rBqVfqiIw4sx4of40xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717060278; c=relaxed/simple;
	bh=OQUZqyiqRqw6MVyZNj7LqQLdWb6o8zx6lDarPSRDexw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F0cRugZ6vUV+dFhC+EnAtBIW04NBBzqJ+N49TPEKcNCVLQYvv9rMjYAHPYxsiAs2kqYhO3WaaYOYOVuR4uvbCAnA2igFSeSjpYJsjTtnSm0mq7nO+BNYZK74cA4B4BFcH2nPaHlK2fLpO2m63HEMS0sZaHdOFFKskttbuci/7zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=dvddpCgC; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2e6f33150bcso6382781fa.2
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 02:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1717060275; x=1717665075; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/DqQQ9Wbu+YPZbJaO7Fnc1iLlsp7PsxeQUPFS9+jrsA=;
        b=dvddpCgCkGmLQubqCHIHepkdkUwJ/H3w1SnMr6+1lY9nxMY6PglE/3/A07JUOmH7oF
         lPXfincAzX9SYJqDYVyacwaS4nijQBbs2uzKjm1j946caYC6rxrK0OMbmT3nBgYXvqni
         Bp0M4KizzMv+pa8hTU8x9ih4WnkkT2GKEpEFQ+c0xhK+KinH+cwThGRmWXfNtmdH9NGr
         sTfy9/ul835Cy/yTf99xGH8CXgE5+DOA8pilDkT5bdRE1qn2P9aMouV2+0ua4r88lW2m
         E/VUosSOBQi3zGJDVng7Tmo22paiacHkOx2zdSoCFyG0PdiRNku7zPtDqLpEWLqsdQYh
         NhiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717060275; x=1717665075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/DqQQ9Wbu+YPZbJaO7Fnc1iLlsp7PsxeQUPFS9+jrsA=;
        b=c0XHBeLFImAec9p7HgmNj3AVIC1/6kvI+3rG8DqehjfMbNtB/N2HXz0yPuM2/IkoF/
         wVndO/ZS//cEAz+t1AHAysFyHsYeIeaQbTxi1HpxuprdfxHlB+tgNULvx56F594DiIFF
         cGyoLUC40djyWg/SY/Pienrsw9itqg8xshXMRo2Ay2J/9nJzPVX06h+smgJBUyASfGAU
         c+B/GJGj7LTi0B1YJwOfRdP5gVJqAWwsc+Bb3qx2lSS7uUNuvkcDyf16RgXuuPOdbjDL
         p271yO4ePksSPiJ6w0MsKz7/pwPtWr7g5PV0JpXlmxajQRHf5YJJVxDKgd18zQQXzXFJ
         ZGCg==
X-Forwarded-Encrypted: i=1; AJvYcCXC22JwCAHt7F6AD4Drb3/N1Lhvxg9d52b1jn+gtJNHgYF50k9GnbcmNPCJERjzVQL4FNJw3REqn/wVSiQDxT9lZ55u
X-Gm-Message-State: AOJu0YypIYV836z7n88AHcyc8EziaSGNyD5gv6x1VMpzlqIBBX8kHVhp
	6TISIVvmXJuuMFnZA1TeSuInPosvkXVG8Odh8297Vpb98TzAzzqycK4SpFdr4F+juA9RksQFoYB
	4G3EEIkn7geXDGu0XQBITE8AnWhRegVcIfrajVg==
X-Google-Smtp-Source: AGHT+IE3UrbczeR98FAFrBGOG1YYfrpdBbgnEYLqXDsuG5eVVHriTJ4IqJsscdAXgMQEWruV/b0knhb+a4kC+NV4SXg=
X-Received: by 2002:a05:651c:90:b0:2ea:7726:4a77 with SMTP id
 38308e7fff4ca-2ea8482896fmr8496551fa.35.1717060274720; Thu, 30 May 2024
 02:11:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240524103307.2684-1-yongxuan.wang@sifive.com>
 <20240524103307.2684-2-yongxuan.wang@sifive.com> <20240527-41b376a2bfedb3b9cf7e9c7b@orel>
 <ec110587-d557-439b-ae50-f3472535ef3a@ghiti.fr> <20240530-3e5538b8e4dea932e2d3edc4@orel>
 <3b76c46f-c502-4245-ae58-be3bd3f8a41f@ghiti.fr>
In-Reply-To: <3b76c46f-c502-4245-ae58-be3bd3f8a41f@ghiti.fr>
From: Anup Patel <apatel@ventanamicro.com>
Date: Thu, 30 May 2024 14:41:02 +0530
Message-ID: <CAK9=C2XzAjnHxSt7Voyz5EiM2nDFXqjkAYWyaq-prKpCsHxcPw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 1/5] RISC-V: Detect and Enable Svadu Extension Support
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Jones <ajones@ventanamicro.com>, Yong-Xuan Wang <yongxuan.wang@sifive.com>, 
	linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, greentime.hu@sifive.com, vincent.chen@sifive.com, 
	cleger@rivosinc.com, Jinyu Tang <tjytimi@163.com>, 
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

On Thu, May 30, 2024 at 2:31=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> Hi Andrew,
>
> On 30/05/2024 10:47, Andrew Jones wrote:
> > On Thu, May 30, 2024 at 10:19:12AM GMT, Alexandre Ghiti wrote:
> >> Hi Yong-Xuan,
> >>
> >> On 27/05/2024 18:25, Andrew Jones wrote:
> >>> On Fri, May 24, 2024 at 06:33:01PM GMT, Yong-Xuan Wang wrote:
> >>>> Svadu is a RISC-V extension for hardware updating of PTE A/D bits.
> >>>>
> >>>> In this patch we detect Svadu extension support from DTB and enable =
it
> >>>> with SBI FWFT extension. Also we add arch_has_hw_pte_young() to enab=
le
> >>>> optimization in MGLRU and __wp_page_copy_user() if Svadu extension i=
s
> >>>> available.
> >>
> >> So we talked about this yesterday during the linux-riscv patchwork mee=
ting.
> >> We came to the conclusion that we should not wait for the SBI FWFT ext=
ension
> >> to enable Svadu but instead, it should be enabled by default by openSB=
I if
> >> the extension is present in the device tree. This is because we did no=
t find
> >> any backward compatibility issues, meaning that enabling Svadu should =
not
> >> break any S-mode software.
> > Unfortunately I joined yesterday's patchwork call late and missed this
> > discussion. I'm still not sure how we avoid concerns with S-mode softwa=
re
> > expecting exceptions by purposely not setting A/D bits, but then not
> > getting those exceptions.
>
>
> Most other architectures implement hardware A/D updates, so I don't see
> what's specific in riscv. In addition, if an OS really needs the
> exceptions, it can always play with the page table permissions to
> achieve such behaviour.
>
>
> >
> >> This is what you did in your previous versions of
> >> this patchset so the changes should be easy. This behaviour must be ad=
ded to
> >> the dtbinding description of the Svadu extension.
> >>
> >> Another thing that we discussed yesterday. There exist 2 schemes to ma=
nage
> >> the A/D bits updates, Svade and Svadu. If a platform supports both
> >> extensions and both are present in the device tree, it is M-mode firmw=
are's
> >> responsibility to provide a "sane" device tree to the S-mode software,
> >> meaning the device tree can not contain both extensions. And because o=
n such
> >> platforms, Svadu is more performant than Svade, Svadu should be enable=
d by
> >> the M-mode firmware and only Svadu should be present in the device tre=
e.
> > I'm not sure firmware will be able to choose svadu when it's available.
> > For example, platforms which want to conform to the upcoming "Server
> > Platform" specification must also conform to the RVA23 profile, which
> > mandates Svade and lists Svadu as an optional extension. This implies t=
o
> > me that S-mode should be boot with both svade and svadu in the DT and w=
ith
> > svade being the active one. Then, S-mode can choose to request switchin=
g
> > to svadu with FWFT.
>
>
> The problem is that FWFT is not there and won't be there for ~1y
> (according to Anup). So in the meantime, we prevent all uarchs that
> support Svadu to take advantage of this.

SBI v3.0 is expected to freeze by the end of this year so I don't
think we will have to wait for ~1yr.

Plus nothing stops a company to apply patches themselves to
test on their implementations. Quite a few companies have internal
forks of Linux where they track upstream patches until they are
merged.

Regards,
Anup

>
>
> >
> > Thanks,
> > drew
> >
> >> I hope that clearly explains what we discussed yesterday, let me know =
if you
> >> (or anyone else) need more explanations. If no one is opposed to this
> >> solution, do you think you can implement this behaviour? If not, I can=
 deal
> >> with it, just let me know.
> >>
> >> Thanks
> >>
> >>
> >>>> Co-developed-by: Jinyu Tang <tjytimi@163.com>
> >>>> Signed-off-by: Jinyu Tang <tjytimi@163.com>
> >>>> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> >>>> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> >>>> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> >>> I think this patch changed too much to keep r-b's. We didn't have the
> >>> FWFT part before.
> >>>
> >>>> ---
> >>>>    arch/riscv/Kconfig               |  1 +
> >>>>    arch/riscv/include/asm/csr.h     |  1 +
> >>>>    arch/riscv/include/asm/hwcap.h   |  1 +
> >>>>    arch/riscv/include/asm/pgtable.h |  8 +++++++-
> >>>>    arch/riscv/kernel/cpufeature.c   | 11 +++++++++++
> >>>>    5 files changed, 21 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> >>>> index be09c8836d56..30fa558ee284 100644
> >>>> --- a/arch/riscv/Kconfig
> >>>> +++ b/arch/riscv/Kconfig
> >>>> @@ -34,6 +34,7 @@ config RISCV
> >>>>            select ARCH_HAS_PMEM_API
> >>>>            select ARCH_HAS_PREPARE_SYNC_CORE_CMD
> >>>>            select ARCH_HAS_PTE_SPECIAL
> >>>> +  select ARCH_HAS_HW_PTE_YOUNG
> >>>>            select ARCH_HAS_SET_DIRECT_MAP if MMU
> >>>>            select ARCH_HAS_SET_MEMORY if MMU
> >>>>            select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
> >>>> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/c=
sr.h
> >>>> index 2468c55933cd..2ac270ad4acd 100644
> >>>> --- a/arch/riscv/include/asm/csr.h
> >>>> +++ b/arch/riscv/include/asm/csr.h
> >>>> @@ -194,6 +194,7 @@
> >>>>    /* xENVCFG flags */
> >>>>    #define ENVCFG_STCE                     (_AC(1, ULL) << 63)
> >>>>    #define ENVCFG_PBMTE                    (_AC(1, ULL) << 62)
> >>>> +#define ENVCFG_ADUE                       (_AC(1, ULL) << 61)
> >>>>    #define ENVCFG_CBZE                     (_AC(1, UL) << 7)
> >>>>    #define ENVCFG_CBCFE                    (_AC(1, UL) << 6)
> >>>>    #define ENVCFG_CBIE_SHIFT               4
> >>>> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm=
/hwcap.h
> >>>> index e17d0078a651..8d539e3f4e11 100644
> >>>> --- a/arch/riscv/include/asm/hwcap.h
> >>>> +++ b/arch/riscv/include/asm/hwcap.h
> >>>> @@ -81,6 +81,7 @@
> >>>>    #define RISCV_ISA_EXT_ZTSO              72
> >>>>    #define RISCV_ISA_EXT_ZACAS             73
> >>>>    #define RISCV_ISA_EXT_XANDESPMU         74
> >>>> +#define RISCV_ISA_EXT_SVADU               75
> >>>>    #define RISCV_ISA_EXT_XLINUXENVCFG      127
> >>>> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/a=
sm/pgtable.h
> >>>> index 9f8ea0e33eb1..1f1b326ccf63 100644
> >>>> --- a/arch/riscv/include/asm/pgtable.h
> >>>> +++ b/arch/riscv/include/asm/pgtable.h
> >>>> @@ -117,6 +117,7 @@
> >>>>    #include <asm/tlbflush.h>
> >>>>    #include <linux/mm_types.h>
> >>>>    #include <asm/compat.h>
> >>>> +#include <asm/cpufeature.h>
> >>>>    #define __page_val_to_pfn(_val)  (((_val) & _PAGE_PFN_MASK) >> _P=
AGE_PFN_SHIFT)
> >>>> @@ -285,7 +286,6 @@ static inline pte_t pud_pte(pud_t pud)
> >>>>    }
> >>>>    #ifdef CONFIG_RISCV_ISA_SVNAPOT
> >>>> -#include <asm/cpufeature.h>
> >>>>    static __always_inline bool has_svnapot(void)
> >>>>    {
> >>>> @@ -621,6 +621,12 @@ static inline pgprot_t pgprot_writecombine(pgpr=
ot_t _prot)
> >>>>            return __pgprot(prot);
> >>>>    }
> >>>> +#define arch_has_hw_pte_young arch_has_hw_pte_young
> >>>> +static inline bool arch_has_hw_pte_young(void)
> >>>> +{
> >>>> +  return riscv_has_extension_unlikely(RISCV_ISA_EXT_SVADU);
> >>>> +}
> >>>> +
> >>>>    /*
> >>>>     * THP functions
> >>>>     */
> >>>> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpuf=
eature.c
> >>>> index 3ed2359eae35..b023908c5932 100644
> >>>> --- a/arch/riscv/kernel/cpufeature.c
> >>>> +++ b/arch/riscv/kernel/cpufeature.c
> >>>> @@ -93,6 +93,16 @@ static bool riscv_isa_extension_check(int id)
> >>>>                            return false;
> >>>>                    }
> >>>>                    return true;
> >>>> +  case RISCV_ISA_EXT_SVADU:
> >>>> +          if (sbi_probe_extension(SBI_EXT_FWFT) > 0) {
> >>> I think we've decided the appropriate way to prove for SBI extensions=
 is
> >>> to first ensure the SBI version and then do the probe, like we do for=
 STA
> >>> in has_pv_steal_clock()
> >>>
> >>>> +                  struct sbiret ret;
> >>>> +
> >>>> +                  ret =3D sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,=
 SBI_FWFT_PTE_AD_HW_UPDATING,
> >>>> +                                  1, 0, 0, 0, 0);
> >>>> +
> >>>> +                  return ret.error =3D=3D SBI_SUCCESS;
> >>>> +          }
> >>>> +          return false;
> >>>>            case RISCV_ISA_EXT_INVALID:
> >>>>                    return false;
> >>>>            }
> >>>> @@ -301,6 +311,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] =
=3D {
> >>>>            __RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
> >>>>            __RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
> >>>>            __RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
> >>>> +  __RISCV_ISA_EXT_SUPERSET(svadu, RISCV_ISA_EXT_SVADU, riscv_xlinux=
envcfg_exts),
> >>> We do we need XLINUXENVCFG?
> >>>
> >>> Thanks,
> >>> drew
> >>>
> >>>>            __RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
> >>>>            __RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
> >>>>            __RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
> >>>> --
> >>>> 2.17.1
> >>>>
> >>> _______________________________________________
> >>> linux-riscv mailing list
> >>> linux-riscv@lists.infradead.org
> >>> http://lists.infradead.org/mailman/listinfo/linux-riscv
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

