Return-Path: <kvm+bounces-26073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 373C79704E5
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 04:47:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E359B282618
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 02:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2F872A8D7;
	Sun,  8 Sep 2024 02:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n4Ybu1ag"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E0228FC;
	Sun,  8 Sep 2024 02:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725763645; cv=none; b=t4r/q0vSjsXLrnOv+pMo6V34pEHd9r0YnUizKY9neyGYii1dnFn3GOlyPHjiNdqUlzeZLWbq6OZjz7uPdtrjUri1Yv8RJhI3nY+R78vXlH1Gj+yDYbsWcWUnTfuZRq9N2LQsWSvMYiBPI3YRiwY+n4/WuNdBQXY22S++Vw/o/iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725763645; c=relaxed/simple;
	bh=ver2NE+e9eI6LoOeCL+BOGorY43Bf8AghqCQbR0/sdE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X9Mc5Yqx3bp9/+Xtk+lDptM/qD2PjjvxErZWgVTAGJhua0nu/5oyvGJYhtEjaYTtHdt9rbJy97umDT/yntTS39twyJF+Fva2Hfv0UoqSbe6i1qPa7v2quzjk5tv8H76BEjsu0mKCKLzsstUbeWT3WkYZqvQjFr8H0y6WA+3Y3Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n4Ybu1ag; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70365C4CEC8;
	Sun,  8 Sep 2024 02:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725763645;
	bh=ver2NE+e9eI6LoOeCL+BOGorY43Bf8AghqCQbR0/sdE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=n4Ybu1agCSOtR50BSus8iCt5pgA46FjR5PIOlwkJiHv6vxq00UlVygcp+V3C6wlq8
	 ggf4hYWSd+zO2skuAiJ48Orjv0XwaGqZDuFHGZbeJUwIBUjf9aD40Oj+AmdnCjl+Ru
	 G7KXNb8QBJq7K5rEnTQ1ntwJovY5JBwWk33pMLGj0UzAK7csQ1wx4Vd26GyMpJ3fmv
	 c1TaAHWq3jOrV8y1Pxslc3ZudBZGJ2MFyBPALG2gYbSitFrfy5RRQpnzOo2gA01eyZ
	 ZVbqhzeWI7YofdhSO0CxsW0vSgs6G8eF+bOpTdKhhmEQMmC6vroSokcZb+NyGWtOxq
	 /4T/Ur/BuTuuw==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5c26b5f1ea6so3927207a12.0;
        Sat, 07 Sep 2024 19:47:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU9NiOmD8LTTkJt+jQ2RXmMgIwnw8dT+Z0ctCcbmc2xsTvd4SJbvVLzvnVf5bx9ugq0i8dxkVlQF/tajg==@vger.kernel.org, AJvYcCUdgGbXolY7oNwYUeA/IoRuUfvnpL6vK/DThACG9XPWphKXhB5SZvq8qlKy1LCp+5avPjs=@vger.kernel.org, AJvYcCWn886DBpnKeSPm+6hpr8bGOqVkiF1FRN+jQSFyoj+XTmah8oLFw9NMZH9aqpo/VRP5wieiW8hkLFqRIiXr@vger.kernel.org, AJvYcCXv+vVmUx4vPEZACRPswTstHkGnDcInjIRuTF6xaczGd6s+R4gGjnaw+y1RkYKwVibalzZN5Hkf/6I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeYB7QiRGQb0ZuNjkEWC5t4RB8/P8eJxlOY3QcDevpGAq/4cVk
	HjO5qlKcON9mWMgw7mxZMyqt57tlmYJhpnfzWm81JPrxhWXA8CfciqJYuxRTGfvMODvoYLWCzUQ
	X3aLXohI1ajgxj7PkiiU7LNFL3t0=
X-Google-Smtp-Source: AGHT+IEwyc9T81QqXwiwQXiluNuC2/jX/VJDZJOpvJhv+lUAMex8mDzLjDzkw6HhavOfhcSICl+nah3h8ZRmzyL45PI=
X-Received: by 2002:a05:6402:35c9:b0:5a1:24fc:9a47 with SMTP id
 4fb4d7f45d1cf-5c3dc7baee7mr5537083a12.27.1725763643967; Sat, 07 Sep 2024
 19:47:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240907-iocsr-v1-0-0c99b3334444@flygoat.com> <20240907-iocsr-v1-3-0c99b3334444@flygoat.com>
In-Reply-To: <20240907-iocsr-v1-3-0c99b3334444@flygoat.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 8 Sep 2024 10:47:18 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5xejfimHedCpLfh2CRheHJmAXpvcmWpLacyrg5m4EPJA@mail.gmail.com>
Message-ID: <CAAhV-H5xejfimHedCpLfh2CRheHJmAXpvcmWpLacyrg5m4EPJA@mail.gmail.com>
Subject: Re: [PATCH 3/5] LoongArch: cpu-probe: Move IOCSR probing out of cpu_probe_common
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
> IOCSR register definition appears to be a platform specific
> spec instead of architecture spec, even for Loongson CPUs
> there is no guarantee that IOCSR will always present.
>
> Thus it's dangerous to perform IOCSR probing without checking
> CPU type and instruction availability.
I don't think this is necessary. Loongson's Chip engineers confirm
that IOCSR is always present in Loongson processors. If other
LoongArch (not Loongson) processors have no IOCSR, they should
implement their own cpu_probe_abc() instead of cpu_probe_loongson().

Huacai

>
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  arch/loongarch/kernel/cpu-probe.c | 63 ++++++++++++++++++++++++---------=
------
>  1 file changed, 39 insertions(+), 24 deletions(-)
>
> diff --git a/arch/loongarch/kernel/cpu-probe.c b/arch/loongarch/kernel/cp=
u-probe.c
> index 6a82ceb6e321..968b5a35a0d2 100644
> --- a/arch/loongarch/kernel/cpu-probe.c
> +++ b/arch/loongarch/kernel/cpu-probe.c
> @@ -173,22 +173,6 @@ static void cpu_probe_common(struct cpuinfo_loongarc=
h *c)
>         if (config & CPUCFG6_PMP)
>                 c->options |=3D LOONGARCH_CPU_PMP;
>
> -       config =3D iocsr_read32(LOONGARCH_IOCSR_FEATURES);
> -       if (config & IOCSRF_CSRIPI)
> -               c->options |=3D LOONGARCH_CPU_CSRIPI;
> -       if (config & IOCSRF_EXTIOI)
> -               c->options |=3D LOONGARCH_CPU_EXTIOI;
> -       if (config & IOCSRF_FREQSCALE)
> -               c->options |=3D LOONGARCH_CPU_SCALEFREQ;
> -       if (config & IOCSRF_FLATMODE)
> -               c->options |=3D LOONGARCH_CPU_FLATMODE;
> -       if (config & IOCSRF_EIODECODE)
> -               c->options |=3D LOONGARCH_CPU_EIODECODE;
> -       if (config & IOCSRF_AVEC)
> -               c->options |=3D LOONGARCH_CPU_AVECINT;
> -       if (config & IOCSRF_VM)
> -               c->options |=3D LOONGARCH_CPU_HYPERVISOR;
> -
>         config =3D csr_read32(LOONGARCH_CSR_ASID);
>         config =3D (config & CSR_ASID_BIT) >> CSR_ASID_BIT_SHIFT;
>         asid_mask =3D GENMASK(config - 1, 0);
> @@ -231,16 +215,8 @@ static char cpu_full_name[MAX_NAME_LEN] =3D "       =
 -        ";
>
>  static inline void cpu_probe_loongson(struct cpuinfo_loongarch *c, unsig=
ned int cpu)
>  {
> -       uint64_t *vendor =3D (void *)(&cpu_full_name[VENDOR_OFFSET]);
> -       uint64_t *cpuname =3D (void *)(&cpu_full_name[CPUNAME_OFFSET]);
>         const char *core_name =3D "Unknown";
>
> -       if (!__cpu_full_name[cpu])
> -               __cpu_full_name[cpu] =3D cpu_full_name;
> -
> -       *vendor =3D iocsr_read64(LOONGARCH_IOCSR_VENDOR);
> -       *cpuname =3D iocsr_read64(LOONGARCH_IOCSR_CPUNAME);
> -
>         switch (c->processor_id & PRID_SERIES_MASK) {
>         case PRID_SERIES_LA132:
>                 c->cputype =3D CPU_LOONGSON32;
> @@ -283,6 +259,36 @@ static inline void cpu_probe_loongson(struct cpuinfo=
_loongarch *c, unsigned int
>         pr_info("%s Processor probed (%s Core)\n", __cpu_family[cpu], cor=
e_name);
>  }
>
> +static inline void iocsr_probe_loongson(struct cpuinfo_loongarch *c, uns=
igned int cpu)
> +{
> +       uint64_t *vendor =3D (void *)(&cpu_full_name[VENDOR_OFFSET]);
> +       uint64_t *cpuname =3D (void *)(&cpu_full_name[CPUNAME_OFFSET]);
> +       unsigned int config;
> +
> +       *vendor =3D iocsr_read64(LOONGARCH_IOCSR_VENDOR);
> +       *cpuname =3D iocsr_read64(LOONGARCH_IOCSR_CPUNAME);
> +
> +       if (!__cpu_full_name[cpu])
> +               __cpu_full_name[cpu] =3D cpu_full_name;
> +
> +       config =3D iocsr_read32(LOONGARCH_IOCSR_FEATURES);
> +       if (config & IOCSRF_CSRIPI)
> +               c->options |=3D LOONGARCH_CPU_CSRIPI;
> +       if (config & IOCSRF_EXTIOI)
> +               c->options |=3D LOONGARCH_CPU_EXTIOI;
> +       if (config & IOCSRF_FREQSCALE)
> +               c->options |=3D LOONGARCH_CPU_SCALEFREQ;
> +       if (config & IOCSRF_FLATMODE)
> +               c->options |=3D LOONGARCH_CPU_FLATMODE;
> +       if (config & IOCSRF_EIODECODE)
> +               c->options |=3D LOONGARCH_CPU_EIODECODE;
> +       if (config & IOCSRF_AVEC)
> +               c->options |=3D LOONGARCH_CPU_AVECINT;
> +       if (config & IOCSRF_VM)
> +               c->options |=3D LOONGARCH_CPU_HYPERVISOR;
> +
> +}
> +
>  #ifdef CONFIG_64BIT
>  /* For use by uaccess.h */
>  u64 __ua_limit;
> @@ -331,6 +337,15 @@ void cpu_probe(void)
>                 break;
>         }
>
> +       if (c->options & LOONGARCH_CPU_IOCSR) {
> +               switch (c->cputype) {
> +               case CPU_LOONGSON32:
> +               case CPU_LOONGSON64:
> +                       iocsr_probe_loongson(c, cpu);
> +                       break;
> +               }
> +       }
> +
>         BUG_ON(!__cpu_family[cpu]);
>         BUG_ON(c->cputype =3D=3D CPU_UNKNOWN);
>
>
> --
> 2.46.0
>

