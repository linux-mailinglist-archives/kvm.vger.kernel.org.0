Return-Path: <kvm+bounces-18379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D58EB8D48C7
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:41:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A63628229E
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 09:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65AF7152169;
	Thu, 30 May 2024 09:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="YTf+OeRz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB44218396C
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 09:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717062089; cv=none; b=pHTz3xP6AI3q1Wuy1784eR8O6Uxpe3P5l4YR+rEVqdsKf4a/pNMtcwsenYjg7SCMiCB+HSsuItAj2wej2IhCSEIQcoQ64HOAW1piHOF4Sgn3DcmiMSVnI1mrxOLkHsDkY0FeWLh5iFBAMQ+vwwQCrLzFRJ75Nv9PiJDEr+vwR40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717062089; c=relaxed/simple;
	bh=0Iqsq+M00t2+tehyQ70ELjWVv+y/7Jo4pD85rhygNH4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nz3ForHxP929OhNeHOMZrWX/o7JqiPADDb6cuvv6uQThjdOHZFNgGM3s8xqG2y8KzODB7INjwa4lfetD2ojGSWpPuOMqNKzGmqlDF8oNumYgpLLVo9bNCnK757T6JOq4xNB4+5IPZl97KUYynokixXWlLNCzPfxDPPCBYYZpmjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=YTf+OeRz; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5b2cc8c4b8aso340653eaf.1
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 02:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1717062086; x=1717666886; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Ap2dugGmP5WE2E5FcASCxui6sxizua7AcbrO2mdh8Y=;
        b=YTf+OeRzs0eo7M1pCgIZZzIb6bNZmi/m1uj7L95xMRqVyvNLm59JcHb1vZ0T7EeF1p
         CWeuQU+BC7HvBBoMeQV/XEnTBg8TWmIJiD6E2dxPRNi+mOUlaBzKfigEEorxZuwGaxx4
         ya2x+BkCDBTXySqratze/nmpoAOcVDLfEpeFfz1kHBItN9JBYjEwaVrkWqEPfp+00iio
         AnhQXApiPsKaKDpfijbxQf8yoU4+SzzXy5br2Ls5tRDGTSFy70WLJEuZBwO+s2ZvnYB1
         rifldwi+uZ4wyyDeZ6/tGK0Hyp3ddueH4If2n8PimV1eV2L3UzMIbEiwn5P9lM3FMcqq
         LCoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717062086; x=1717666886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Ap2dugGmP5WE2E5FcASCxui6sxizua7AcbrO2mdh8Y=;
        b=nZrswN71w9ef4I02/1eEqXZX7RwawjSfNEEBUp3hNIHtSU7QEHK5rDOhQXD/1QVG1T
         DpUlSIjbdSzvF+/ZZSwIwENuPJO4H5CLSKV1leHluHDb6bsxeW6juxSLMnCC6MEcoGOI
         w+ZpfWAfQmUpnFbnW3lA2XArD+GYwyX0Hy1roMABMqtv/OAy6yeZn/3+jGNWy0czhVaU
         L2PAjaTk3Z26dC6iqZUJsHDT3lJa/N2vBbSwIUU87T3btml6gttIxlhZbsmGJNfXz1ov
         uTYI9PgTbQEI5CDi6jyV9LtSfZuclNRGEnX85YUahMGrrYD44R+eXd2zfvI5kaIEnxdN
         Vz7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXSZpJP3XzHE42RpmDXmnzw2KjoLq14R1icYBwdHzlYhcymlY5/aOf5YiHcm4rYkG20+ReW4It0avybrWtZg5Z4mTIj
X-Gm-Message-State: AOJu0YyShpNu5dqDa8I8cvidVKXPGm2WN8rAI8e6ft/WRxNF+zyWbQlO
	IH7AVqL0aVPk0E7Vq1QWA8xwbCtBmgukFR050drkvfo8AywPx7sAK1ukAlKoCfatjD6ab9HhvVY
	ZudMnyl/NwucqQdUEuqX/x8HaI6nZSxjFV/6PpQ==
X-Google-Smtp-Source: AGHT+IGs8c+j/SX1TKRu2grSTFbKjYgLZf2leGT/SdcfsZ4CQqrfPAwFqljLFAvGYqp/iOrNutq7K/dJ1Cm5fQG1ADA=
X-Received: by 2002:a05:6820:2216:b0:5b9:8a06:4e84 with SMTP id
 006d021491bc7-5b9ec554fd3mr2313780eaf.2.1717062085690; Thu, 30 May 2024
 02:41:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240524103307.2684-1-yongxuan.wang@sifive.com>
 <20240524103307.2684-2-yongxuan.wang@sifive.com> <20240527-41b376a2bfedb3b9cf7e9c7b@orel>
 <ec110587-d557-439b-ae50-f3472535ef3a@ghiti.fr>
In-Reply-To: <ec110587-d557-439b-ae50-f3472535ef3a@ghiti.fr>
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Date: Thu, 30 May 2024 17:41:14 +0800
Message-ID: <CAMWQL2g7sgt9-_4YTbRg3SRrUJE_4HEsqEUO44oA4=vHZA4L9A@mail.gmail.com>
Subject: Re: [RFC PATCH v4 1/5] RISC-V: Detect and Enable Svadu Extension Support
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Jones <ajones@ventanamicro.com>, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, greentime.hu@sifive.com, 
	vincent.chen@sifive.com, cleger@rivosinc.com, Jinyu Tang <tjytimi@163.com>, 
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

Hi Alexandre,

On Thu, May 30, 2024 at 4:19=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> Hi Yong-Xuan,
>
> On 27/05/2024 18:25, Andrew Jones wrote:
> > On Fri, May 24, 2024 at 06:33:01PM GMT, Yong-Xuan Wang wrote:
> >> Svadu is a RISC-V extension for hardware updating of PTE A/D bits.
> >>
> >> In this patch we detect Svadu extension support from DTB and enable it
> >> with SBI FWFT extension. Also we add arch_has_hw_pte_young() to enable
> >> optimization in MGLRU and __wp_page_copy_user() if Svadu extension is
> >> available.
>
>
> So we talked about this yesterday during the linux-riscv patchwork
> meeting. We came to the conclusion that we should not wait for the SBI
> FWFT extension to enable Svadu but instead, it should be enabled by
> default by openSBI if the extension is present in the device tree. This
> is because we did not find any backward compatibility issues, meaning
> that enabling Svadu should not break any S-mode software. This is what
> you did in your previous versions of this patchset so the changes should
> be easy. This behaviour must be added to the dtbinding description of
> the Svadu extension.
>
> Another thing that we discussed yesterday. There exist 2 schemes to
> manage the A/D bits updates, Svade and Svadu. If a platform supports
> both extensions and both are present in the device tree, it is M-mode
> firmware's responsibility to provide a "sane" device tree to the S-mode
> software, meaning the device tree can not contain both extensions. And
> because on such platforms, Svadu is more performant than Svade, Svadu
> should be enabled by the M-mode firmware and only Svadu should be
> present in the device tree.
>
> I hope that clearly explains what we discussed yesterday, let me know if
> you (or anyone else) need more explanations. If no one is opposed to
> this solution, do you think you can implement this behaviour? If not, I
> can deal with it, just let me know.
>
> Thanks
>
>

Sure, I can do it. Just to confirm, which extension should be removed
when both Svade and Svadu are present in the DT?

Regards,
Yong-Xuan

> >>
> >> Co-developed-by: Jinyu Tang <tjytimi@163.com>
> >> Signed-off-by: Jinyu Tang <tjytimi@163.com>
> >> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> >> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> >> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > I think this patch changed too much to keep r-b's. We didn't have the
> > FWFT part before.
> >
> >> ---
> >>   arch/riscv/Kconfig               |  1 +
> >>   arch/riscv/include/asm/csr.h     |  1 +
> >>   arch/riscv/include/asm/hwcap.h   |  1 +
> >>   arch/riscv/include/asm/pgtable.h |  8 +++++++-
> >>   arch/riscv/kernel/cpufeature.c   | 11 +++++++++++
> >>   5 files changed, 21 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> >> index be09c8836d56..30fa558ee284 100644
> >> --- a/arch/riscv/Kconfig
> >> +++ b/arch/riscv/Kconfig
> >> @@ -34,6 +34,7 @@ config RISCV
> >>      select ARCH_HAS_PMEM_API
> >>      select ARCH_HAS_PREPARE_SYNC_CORE_CMD
> >>      select ARCH_HAS_PTE_SPECIAL
> >> +    select ARCH_HAS_HW_PTE_YOUNG
> >>      select ARCH_HAS_SET_DIRECT_MAP if MMU
> >>      select ARCH_HAS_SET_MEMORY if MMU
> >>      select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
> >> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr=
.h
> >> index 2468c55933cd..2ac270ad4acd 100644
> >> --- a/arch/riscv/include/asm/csr.h
> >> +++ b/arch/riscv/include/asm/csr.h
> >> @@ -194,6 +194,7 @@
> >>   /* xENVCFG flags */
> >>   #define ENVCFG_STCE                        (_AC(1, ULL) << 63)
> >>   #define ENVCFG_PBMTE                       (_AC(1, ULL) << 62)
> >> +#define ENVCFG_ADUE                 (_AC(1, ULL) << 61)
> >>   #define ENVCFG_CBZE                        (_AC(1, UL) << 7)
> >>   #define ENVCFG_CBCFE                       (_AC(1, UL) << 6)
> >>   #define ENVCFG_CBIE_SHIFT          4
> >> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/h=
wcap.h
> >> index e17d0078a651..8d539e3f4e11 100644
> >> --- a/arch/riscv/include/asm/hwcap.h
> >> +++ b/arch/riscv/include/asm/hwcap.h
> >> @@ -81,6 +81,7 @@
> >>   #define RISCV_ISA_EXT_ZTSO         72
> >>   #define RISCV_ISA_EXT_ZACAS                73
> >>   #define RISCV_ISA_EXT_XANDESPMU            74
> >> +#define RISCV_ISA_EXT_SVADU         75
> >>
> >>   #define RISCV_ISA_EXT_XLINUXENVCFG 127
> >>
> >> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm=
/pgtable.h
> >> index 9f8ea0e33eb1..1f1b326ccf63 100644
> >> --- a/arch/riscv/include/asm/pgtable.h
> >> +++ b/arch/riscv/include/asm/pgtable.h
> >> @@ -117,6 +117,7 @@
> >>   #include <asm/tlbflush.h>
> >>   #include <linux/mm_types.h>
> >>   #include <asm/compat.h>
> >> +#include <asm/cpufeature.h>
> >>
> >>   #define __page_val_to_pfn(_val)  (((_val) & _PAGE_PFN_MASK) >> _PAGE=
_PFN_SHIFT)
> >>
> >> @@ -285,7 +286,6 @@ static inline pte_t pud_pte(pud_t pud)
> >>   }
> >>
> >>   #ifdef CONFIG_RISCV_ISA_SVNAPOT
> >> -#include <asm/cpufeature.h>
> >>
> >>   static __always_inline bool has_svnapot(void)
> >>   {
> >> @@ -621,6 +621,12 @@ static inline pgprot_t pgprot_writecombine(pgprot=
_t _prot)
> >>      return __pgprot(prot);
> >>   }
> >>
> >> +#define arch_has_hw_pte_young arch_has_hw_pte_young
> >> +static inline bool arch_has_hw_pte_young(void)
> >> +{
> >> +    return riscv_has_extension_unlikely(RISCV_ISA_EXT_SVADU);
> >> +}
> >> +
> >>   /*
> >>    * THP functions
> >>    */
> >> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufea=
ture.c
> >> index 3ed2359eae35..b023908c5932 100644
> >> --- a/arch/riscv/kernel/cpufeature.c
> >> +++ b/arch/riscv/kernel/cpufeature.c
> >> @@ -93,6 +93,16 @@ static bool riscv_isa_extension_check(int id)
> >>                      return false;
> >>              }
> >>              return true;
> >> +    case RISCV_ISA_EXT_SVADU:
> >> +            if (sbi_probe_extension(SBI_EXT_FWFT) > 0) {
> > I think we've decided the appropriate way to prove for SBI extensions i=
s
> > to first ensure the SBI version and then do the probe, like we do for S=
TA
> > in has_pv_steal_clock()
> >
> >> +                    struct sbiret ret;
> >> +
> >> +                    ret =3D sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,=
 SBI_FWFT_PTE_AD_HW_UPDATING,
> >> +                                    1, 0, 0, 0, 0);
> >> +
> >> +                    return ret.error =3D=3D SBI_SUCCESS;
> >> +            }
> >> +            return false;
> >>      case RISCV_ISA_EXT_INVALID:
> >>              return false;
> >>      }
> >> @@ -301,6 +311,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] =
=3D {
> >>      __RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
> >>      __RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
> >>      __RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
> >> +    __RISCV_ISA_EXT_SUPERSET(svadu, RISCV_ISA_EXT_SVADU, riscv_xlinux=
envcfg_exts),
> > We do we need XLINUXENVCFG?
> >
> > Thanks,
> > drew
> >
> >>      __RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
> >>      __RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
> >>      __RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
> >> --
> >> 2.17.1
> >>
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv

