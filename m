Return-Path: <kvm+bounces-26787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F851977B8D
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 10:48:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BC4C28B133
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 08:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99C0C1D6DD1;
	Fri, 13 Sep 2024 08:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ibhShwqN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30111BD507;
	Fri, 13 Sep 2024 08:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726217206; cv=none; b=AZetuNPUtN1AzAZgw76Bs7bG57icyWIdnl1qy/4zaryUTfVv7rbFZehT2CwhUfpAj9bnETNPSeD2PUo8gLRPq95rMnB9Y7Cmhp2Wtd74dJzPpwPpOD2YfYEezrEfIT+m8wcHknkynpfkQ+yne4iSE80lVt3oaGIjKIKkXkbbWd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726217206; c=relaxed/simple;
	bh=fHBdOkgM55iaY/S8npbPQsIUufU7yCfyV/mVvkbgAjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dzYpJAdBcKr3pf6pmB9iNujdw217xrDg5mJmrrEx+eDNVHSQlDAwjKHSL2NKomdHc1WqXxD4CvsmznSmhSvbugb+TiG/yekqEgP6sUMOuqzdf5xZNP0Srn6wHV/fAYNve5CM5dpLZAab0qG2BmnpD9SY1j6tiAIjC5tNsd+f86I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ibhShwqN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3395AC4CECC;
	Fri, 13 Sep 2024 08:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726217206;
	bh=fHBdOkgM55iaY/S8npbPQsIUufU7yCfyV/mVvkbgAjs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ibhShwqNJb1ftehLkoydRozvCRJOBLHMb+QiHcrcqUfdGnaPqFIQFivp/mry26DGt
	 yI/X+Do9dafmONqxJ1Os7EIeRlqGJLP1tr3Q/6lcnzBNlKQo9XBni7rpFAkMxTPfs+
	 ZBDUC9FF8ZTxySMu+xe2VvW9CjVgR5IObsWoVhnlexmEdmwbXcSQIS6Gvuoq7CJ57z
	 MugNM506sgPoA76NYsg1CMWWIIlTBQSzFsMtvvs+WmaCX84n5Hp384OdpJo8ZbtAIX
	 NkhH9b/DvOQm/1mKkGzC91ateqbrGLNU+hK0jIJ2sInVWlBHCeZv3GwvpB//nXbtvg
	 seAUm4+9VwA6w==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c3ca32974fso2047166a12.3;
        Fri, 13 Sep 2024 01:46:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVGxwFbLYwqsrsOZPcwv3PhhWKPwT0DiV5pGmYJiiJcQqOf5uAgV4XqH/yTDD47t3zbQ6k=@vger.kernel.org, AJvYcCVHM4f5BgjnFDi2zp/vJIPHqno50Ng6yBSSlDqeNKemNjc+lTlg/S9t0wxaE65qSXdxvLFwLvAUkGeD/Q==@vger.kernel.org, AJvYcCVubQjyeRsAc9wme46JYnGESN3g5FcrpFK2IUHdnzlP/eGuOyPSrNPEHXhRkvCb+qMK4+JmBqHqWLzCW6NO@vger.kernel.org, AJvYcCXMKL5UJhUcYbLDoTkqpB2KNPxrTvKoLi+OrI4iwGISPNhTk4TYZA5rT6zHsKQgtVPn0Dm015TLCN8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRwkZMkawSk1L7O3S8oupZ1T/bELa8yIL3Qn0boRceL3qh/iYN
	TJqoC5URrMy4zuGNuZuaPQ2ao9YUa4yKnnKalJU0KTIK13R48ecKiXNi43SrGRjGB2NXFmIerPB
	r5lQjiZnVbqilM+Z4ydlA0865tx0=
X-Google-Smtp-Source: AGHT+IGNp027nTbHlTE2+lVVIpSFUbo7vKhoxeMzMWbqcS/ESl6nYt1xkz8sfPFDEnqnBHbrCVG69gj/E32o+XIqrAc=
X-Received: by 2002:a05:6402:35d6:b0:5c3:c51b:9bdd with SMTP id
 4fb4d7f45d1cf-5c413e1ff03mr3574240a12.18.1726217204696; Fri, 13 Sep 2024
 01:46:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912-iocsr-v2-0-e88f75b37da4@flygoat.com> <20240912-iocsr-v2-1-e88f75b37da4@flygoat.com>
In-Reply-To: <20240912-iocsr-v2-1-e88f75b37da4@flygoat.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 13 Sep 2024 16:46:30 +0800
X-Gmail-Original-Message-ID: <CAAhV-H74OCxnRQjHXtu-CuVaEb5bsMQ4vR4wCOvztZdV-HWEVg@mail.gmail.com>
Message-ID: <CAAhV-H74OCxnRQjHXtu-CuVaEb5bsMQ4vR4wCOvztZdV-HWEVg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] LoongArch: Probe more CPU features from CPUCFG
To: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: WANG Xuerui <kernel@xen0n.name>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Jiaxun,

On Fri, Sep 13, 2024 at 4:56=E2=80=AFAM Jiaxun Yang <jiaxun.yang@flygoat.co=
m> wrote:
>
> Probe ISA level, TLB, IOCSR information from CPUCFG to
> improve kernel resilience to different core implementations.
>
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  arch/loongarch/include/asm/cpu.h       |  4 +++
>  arch/loongarch/include/asm/loongarch.h |  3 +-
>  arch/loongarch/kernel/cpu-probe.c      | 54 ++++++++++++++++++++++++----=
------
>  3 files changed, 44 insertions(+), 17 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/cpu.h b/arch/loongarch/include/as=
m/cpu.h
> index 843f9c4ec980..251a15439cff 100644
> --- a/arch/loongarch/include/asm/cpu.h
> +++ b/arch/loongarch/include/asm/cpu.h
> @@ -100,6 +100,8 @@ enum cpu_type_enum {
>  #define CPU_FEATURE_HYPERVISOR         25      /* CPU has hypervisor (ru=
nning in VM) */
>  #define CPU_FEATURE_PTW                        26      /* CPU has hardwa=
re page table walker */
>  #define CPU_FEATURE_AVECINT            27      /* CPU has avec interrupt=
 */
> +#define CPU_FEATURE_IOCSR              28      /* CPU has IOCSR */
> +#define CPU_FEATURE_LSPW               29      /* CPU has LSPW */
I don't see LSPW being used, so just remove it now?

>
>  #define LOONGARCH_CPU_CPUCFG           BIT_ULL(CPU_FEATURE_CPUCFG)
>  #define LOONGARCH_CPU_LAM              BIT_ULL(CPU_FEATURE_LAM)
> @@ -129,5 +131,7 @@ enum cpu_type_enum {
>  #define LOONGARCH_CPU_HYPERVISOR       BIT_ULL(CPU_FEATURE_HYPERVISOR)
>  #define LOONGARCH_CPU_PTW              BIT_ULL(CPU_FEATURE_PTW)
>  #define LOONGARCH_CPU_AVECINT          BIT_ULL(CPU_FEATURE_AVECINT)
> +#define LOONGARCH_CPU_IOCSR            BIT_ULL(CPU_FEATURE_IOCSR)
> +#define LOONGARCH_CPU_LSPW             BIT_ULL(CPU_FEATURE_LSPW)
>
>  #endif /* _ASM_CPU_H */
> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/incl=
ude/asm/loongarch.h
> index 631d249b3ef2..23af28f00c3c 100644
> --- a/arch/loongarch/include/asm/loongarch.h
> +++ b/arch/loongarch/include/asm/loongarch.h
> @@ -60,8 +60,7 @@
>  #define  CPUCFG0_PRID                  GENMASK(31, 0)
>
>  #define LOONGARCH_CPUCFG1              0x1
> -#define  CPUCFG1_ISGR32                        BIT(0)
> -#define  CPUCFG1_ISGR64                        BIT(1)
> +#define  CPUCFG1_ISA                   GENMASK(1, 0)
>  #define  CPUCFG1_PAGING                        BIT(2)
>  #define  CPUCFG1_IOCSR                 BIT(3)
>  #define  CPUCFG1_PABITS                        GENMASK(11, 4)
> diff --git a/arch/loongarch/kernel/cpu-probe.c b/arch/loongarch/kernel/cp=
u-probe.c
> index 14f0449f5452..5dc8ca3c4387 100644
> --- a/arch/loongarch/kernel/cpu-probe.c
> +++ b/arch/loongarch/kernel/cpu-probe.c
> @@ -92,11 +92,29 @@ static void cpu_probe_common(struct cpuinfo_loongarch=
 *c)
>         unsigned long asid_mask;
>
>         c->options =3D LOONGARCH_CPU_CPUCFG | LOONGARCH_CPU_CSR |
> -                    LOONGARCH_CPU_TLB | LOONGARCH_CPU_VINT | LOONGARCH_C=
PU_WATCH;
> +                    LOONGARCH_CPU_VINT | LOONGARCH_CPU_WATCH;
>
>         elf_hwcap =3D HWCAP_LOONGARCH_CPUCFG;
>
>         config =3D read_cpucfg(LOONGARCH_CPUCFG1);
> +
> +       switch (config & CPUCFG1_ISA) {
> +       case 0:
> +               set_isa(c, LOONGARCH_CPU_ISA_LA32R);
> +               break;
> +       case 1:
> +               set_isa(c, LOONGARCH_CPU_ISA_LA32S);
> +               break;
> +       case 2:
> +               set_isa(c, LOONGARCH_CPU_ISA_LA64);
> +               break;
> +       default:
> +               pr_warn("Warning: unknown ISA level\n");
> +       }
> +       if (config & CPUCFG1_PAGING)
> +               c->options |=3D LOONGARCH_CPU_TLB;
> +       if (config & CPUCFG1_IOCSR)
> +               c->options |=3D LOONGARCH_CPU_IOCSR;
>         if (config & CPUCFG1_UAL) {
>                 c->options |=3D LOONGARCH_CPU_UAL;
>                 elf_hwcap |=3D HWCAP_LOONGARCH_UAL;
> @@ -157,6 +175,8 @@ static void cpu_probe_common(struct cpuinfo_loongarch=
 *c)
>                 elf_hwcap |=3D HWCAP_LOONGARCH_LBT_MIPS;
>         }
>  #endif
> +       if (config & CPUCFG2_LSPW)
> +               c->options |=3D LOONGARCH_CPU_LSPW;
>
>         config =3D read_cpucfg(LOONGARCH_CPUCFG6);
>         if (config & CPUCFG6_PMP)
> @@ -222,6 +242,7 @@ static inline void cpu_probe_loongson(struct cpuinfo_=
loongarch *c, unsigned int
>  {
>         uint64_t *vendor =3D (void *)(&cpu_full_name[VENDOR_OFFSET]);
>         uint64_t *cpuname =3D (void *)(&cpu_full_name[CPUNAME_OFFSET]);
> +       const char *core_name =3D "Unknown";
>
>         if (!__cpu_full_name[cpu])
>                 __cpu_full_name[cpu] =3D cpu_full_name;
> @@ -232,40 +253,43 @@ static inline void cpu_probe_loongson(struct cpuinf=
o_loongarch *c, unsigned int
>         switch (c->processor_id & PRID_SERIES_MASK) {
>         case PRID_SERIES_LA132:
>                 c->cputype =3D CPU_LOONGSON32;
> -               set_isa(c, LOONGARCH_CPU_ISA_LA32S);
>                 __cpu_family[cpu] =3D "Loongson-32bit";
> -               pr_info("32-bit Loongson Processor probed (LA132 Core)\n"=
);
> +               core_name =3D "LA132";
>                 break;
>         case PRID_SERIES_LA264:
>                 c->cputype =3D CPU_LOONGSON64;
> -               set_isa(c, LOONGARCH_CPU_ISA_LA64);
>                 __cpu_family[cpu] =3D "Loongson-64bit";
> -               pr_info("64-bit Loongson Processor probed (LA264 Core)\n"=
);
> +               core_name =3D "LA264";
>                 break;
>         case PRID_SERIES_LA364:
>                 c->cputype =3D CPU_LOONGSON64;
> -               set_isa(c, LOONGARCH_CPU_ISA_LA64);
>                 __cpu_family[cpu] =3D "Loongson-64bit";
> -               pr_info("64-bit Loongson Processor probed (LA364 Core)\n"=
);
> +               core_name =3D "LA364";
>                 break;
>         case PRID_SERIES_LA464:
>                 c->cputype =3D CPU_LOONGSON64;
> -               set_isa(c, LOONGARCH_CPU_ISA_LA64);
>                 __cpu_family[cpu] =3D "Loongson-64bit";
> -               pr_info("64-bit Loongson Processor probed (LA464 Core)\n"=
);
> +               core_name =3D "LA464";
>                 break;
>         case PRID_SERIES_LA664:
>                 c->cputype =3D CPU_LOONGSON64;
> -               set_isa(c, LOONGARCH_CPU_ISA_LA64);
>                 __cpu_family[cpu] =3D "Loongson-64bit";
> -               pr_info("64-bit Loongson Processor probed (LA664 Core)\n"=
);
> +               core_name =3D "LA664";
>                 break;
>         default: /* Default to 64 bit */
> -               c->cputype =3D CPU_LOONGSON64;
> -               set_isa(c, LOONGARCH_CPU_ISA_LA64);
> -               __cpu_family[cpu] =3D "Loongson-64bit";
> -               pr_info("64-bit Loongson Processor probed (Unknown Core)\=
n");
> +               if (c->isa_level & LOONGARCH_CPU_ISA_LA64) {
> +                       c->cputype =3D CPU_LOONGSON64;
> +                       __cpu_family[cpu] =3D "Loongson-64bit";
> +               } else if (c->isa_level & LOONGARCH_CPU_ISA_LA32S) {
> +                       c->cputype =3D CPU_LOONGSON32;
> +                       __cpu_family[cpu] =3D "Loongson-32bit";
> +               } else if (c->isa_level & LOONGARCH_CPU_ISA_LA32R) {
> +                       c->cputype =3D CPU_LOONGSON32;
> +                       __cpu_family[cpu] =3D "Loongson-32bit Reduced";
> +               }
I prefer to move this part before the switch-case of PRID (and it is
better to convert to a switch-case too), then the switch-case of PRID
can be only used for probing core-name.

Huacai

>         }
> +
> +       pr_info("%s Processor probed (%s Core)\n", __cpu_family[cpu], cor=
e_name);
>  }
>
>  #ifdef CONFIG_64BIT
>
> --
> 2.46.0
>

