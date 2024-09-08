Return-Path: <kvm+bounces-26072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B049704E1
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 04:41:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE1F22822A3
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 02:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7EF724B2F;
	Sun,  8 Sep 2024 02:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VjscTXMo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC20D272;
	Sun,  8 Sep 2024 02:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725763260; cv=none; b=SshKbZBODCnWjQyHmxUTJPZ16CcD2w7DZYplY4omKgfuOLv5eHqJULb9P4HpWdold++Em9iGK3p7Bqi1oqbYQ0zYcyow4UAA8PeMmNJfp7w2Pn/tml5bDNOremTLhj6hUaK+/2uK0bbFAYKKPRJXNSvM2ocWLsV72g4p81wIIn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725763260; c=relaxed/simple;
	bh=5yBf3P0dSFge8zUoOWsK+QCozjauF+zs2WTj4pouJaw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c6V33rNajft1CCvvq6W33AUQv8eaq8tBF4PpC/6RgmzUENFScR18Fh2GKBwy2OTwqj6kuvGP2bASpIsO/MRJg/vJV9jU0o54VR6nzeVUWKswZUBIWJa5jckCDCGZtUzirv5YtLtt0HhaUt9VXOlav+GTTrLKJffMsRhL5dfUB68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VjscTXMo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7947EC4AF09;
	Sun,  8 Sep 2024 02:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725763259;
	bh=5yBf3P0dSFge8zUoOWsK+QCozjauF+zs2WTj4pouJaw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VjscTXMoucJlbj8kNtnN57wDZdI7OyMn4haFStIVDoQuJn0Dz6fhPQTvg5q6HyGXZ
	 m0Au1syXz8e7aqa9FBTNe0rye1+M3moC+FvX/auA1KjeDcRqUW45/zcEHltOjafcDe
	 x02p0Sajx3UmOPoLgB2TbL2jm+DAPUyXYG529yisn9qe90DsX8cbrOhi4s9eVcy9DD
	 uJeayRFlljaWspnZypvQRXBROD41B3H6Jmpz/Yw0di5L4qDK7mu63yCb8xHFQpYaU9
	 tGaf1UPKqL4Nk41l9wmO1HgkimSKV7E8NWeNclVXJMDcnIciydAIT/8gICggKVKuEr
	 j1OyRx1BPXS5A==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2f75c56f16aso11186691fa.0;
        Sat, 07 Sep 2024 19:40:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVPLljAFDALhl562NGF/MFqcWOzcyD1iYnsoolkI/GTUGAWPuw2rIovUS3iqDdz5LHlxdg=@vger.kernel.org, AJvYcCVPzZe4kA1p1K7/ykQ9fa6u45o8QPTh062fSbS7Xbqyflk1mNagkI8xLEJ8WW07L3TznpqgSk50AZVAmWxD@vger.kernel.org, AJvYcCW+HrcIqnvH3QvyeIbIkFhN8/F6zTHH+QoJWF6dmf6K2XjJcbWgduH4O1/DmGhayxklmgz1kQzdMoctDA==@vger.kernel.org, AJvYcCW3FHHvF8SoEUkt5GOu4/A/qjy9tOC1tNYv30hMwlNIliBX9RvcMTAQ7I5uSEJuMNrid9dpQ7oEytE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy206pWXhtGMk4dyqrK/I154jjNsdJdzawCZEukzX9QVNJhEs0j
	tG1nJQHPcIakRWrwfYWUw8d2pczFHBsT7Js42/AMa+NTlweTKnREH+NFdOsKh710fl2bSkPf8BK
	tKV+Urw9WVbTJRLRWtJsVSjPmdvU=
X-Google-Smtp-Source: AGHT+IFBhtpwKNxTp7iZ3GwOsA0OLDoMib+tZBANDrIJ3CV1VN598IEmU3BI2NkBNy3Pv+Hc1qkFk5vMO0dpsoVQoVg=
X-Received: by 2002:a2e:5109:0:b0:2f6:6d6d:63cd with SMTP id
 38308e7fff4ca-2f751f11e9amr38216391fa.26.1725763257790; Sat, 07 Sep 2024
 19:40:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240907-iocsr-v1-0-0c99b3334444@flygoat.com> <20240907-iocsr-v1-2-0c99b3334444@flygoat.com>
In-Reply-To: <20240907-iocsr-v1-2-0c99b3334444@flygoat.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 8 Sep 2024 10:40:51 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4B19+pybM_PeSNEnSmWaLLi6W15t2scbKhEOGLyCtEWw@mail.gmail.com>
Message-ID: <CAAhV-H4B19+pybM_PeSNEnSmWaLLi6W15t2scbKhEOGLyCtEWw@mail.gmail.com>
Subject: Re: [PATCH 2/5] LoongArch: Probe more CPU features from CPUCFG
To: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: WANG Xuerui <kernel@xen0n.name>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Jiaxun,

On Sat, Sep 7, 2024 at 6:17=E2=80=AFPM Jiaxun Yang <jiaxun.yang@flygoat.com=
> wrote:
>
> Probe ISA level, TLB, IOCSR information from CPUCFG to
> improve kernel resilience to different core implementations.
>
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  arch/loongarch/include/asm/cpu.h  |  2 +-
>  arch/loongarch/kernel/cpu-probe.c | 47 ++++++++++++++++++++++++++-------=
------
>  2 files changed, 32 insertions(+), 17 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/cpu.h b/arch/loongarch/include/as=
m/cpu.h
> index 7c44f4ede3a2..31a2de821236 100644
> --- a/arch/loongarch/include/asm/cpu.h
> +++ b/arch/loongarch/include/asm/cpu.h
> @@ -86,7 +86,7 @@ enum cpu_type_enum {
>  #define CPU_FEATURE_LBT_ARM            11      /* CPU has ARM Binary Tra=
nslation */
>  #define CPU_FEATURE_LBT_MIPS           12      /* CPU has MIPS Binary Tr=
anslation */
>  #define CPU_FEATURE_TLB                        13      /* CPU has TLB */
> -#define CPU_FEATURE_CSR                        14      /* CPU has CSR */
> +#define CPU_FEATURE_IOCSR              14      /* CPU has IOCSR */
>  #define CPU_FEATURE_WATCH              15      /* CPU has watchpoint reg=
isters */
>  #define CPU_FEATURE_VINT               16      /* CPU has vectored inter=
rupts */
>  #define CPU_FEATURE_CSRIPI             17      /* CPU has CSR-IPI */
> diff --git a/arch/loongarch/kernel/cpu-probe.c b/arch/loongarch/kernel/cp=
u-probe.c
> index 4446616d497c..6a82ceb6e321 100644
> --- a/arch/loongarch/kernel/cpu-probe.c
> +++ b/arch/loongarch/kernel/cpu-probe.c
> @@ -91,12 +91,23 @@ static void cpu_probe_common(struct cpuinfo_loongarch=
 *c)
>         unsigned int config;
>         unsigned long asid_mask;
>
> -       c->options =3D LOONGARCH_CPU_CPUCFG | LOONGARCH_CPU_IOCSR |
> -                    LOONGARCH_CPU_TLB | LOONGARCH_CPU_VINT | LOONGARCH_C=
PU_WATCH;
> +       c->options =3D LOONGARCH_CPU_CPUCFG | LOONGARCH_CPU_VINT |
> +                    LOONGARCH_CPU_WATCH;
>
>         elf_hwcap =3D HWCAP_LOONGARCH_CPUCFG;
>
>         config =3D read_cpucfg(LOONGARCH_CPUCFG1);
> +
> +       if (config & CPUCFG1_ISGR64)
> +               set_isa(c, LOONGARCH_CPU_ISA_LA64);
> +       else if (config & CPUCFG1_ISGR32)
> +               set_isa(c, LOONGARCH_CPU_ISA_LA32S);
> +       else
> +               set_isa(c, LOONGARCH_CPU_ISA_LA32R);
Switch-case is better than if-else here.

> +       if (config & CPUCFG1_PAGING)
> +               c->options |=3D LOONGARCH_CPU_TLB;
> +       if (config & CPUCFG1_IOCSR)
> +               c->options |=3D LOONGARCH_CPU_IOCSR;
>         if (config & CPUCFG1_UAL) {
>                 c->options |=3D LOONGARCH_CPU_UAL;
>                 elf_hwcap |=3D HWCAP_LOONGARCH_UAL;
> @@ -222,6 +233,7 @@ static inline void cpu_probe_loongson(struct cpuinfo_=
loongarch *c, unsigned int
>  {
>         uint64_t *vendor =3D (void *)(&cpu_full_name[VENDOR_OFFSET]);
>         uint64_t *cpuname =3D (void *)(&cpu_full_name[CPUNAME_OFFSET]);
> +       const char *core_name =3D "Unknown";
>
>         if (!__cpu_full_name[cpu])
>                 __cpu_full_name[cpu] =3D cpu_full_name;
> @@ -232,40 +244,43 @@ static inline void cpu_probe_loongson(struct cpuinf=
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
Change the name to "Loongson-32bit Standard".

Huacai
> +               } else if (c->isa_level & LOONGARCH_CPU_ISA_LA32R) {
> +                       c->cputype =3D CPU_LOONGSON32;
> +                       __cpu_family[cpu] =3D "Loongson-32bit Reduced";
> +               }
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

