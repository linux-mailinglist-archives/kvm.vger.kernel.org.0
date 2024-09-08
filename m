Return-Path: <kvm+bounces-26071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 83CA79704DB
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 04:38:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF5791C210B3
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 02:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23AB028DCB;
	Sun,  8 Sep 2024 02:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pfw+5l2G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265EBD272;
	Sun,  8 Sep 2024 02:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725763095; cv=none; b=J1B4XnTLRI1QaeUJFBdG+l2MN2s5FX1HWw7Tzdt1A6W6v8evO98jVx7tcC6gGRnGWyD4s+qDuw11h8Lbp2IrlUv6+Rz+f2phu1kGFQ6Dx6qyDRBKNb8g7ClgaQS+/57FRdKxUxo4pyPijO5INBaxGFSPl9fhjsnxtm0uM1SYjVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725763095; c=relaxed/simple;
	bh=QRLowZOK063HZ8aCZ32C9grtYQV6cWDgqk9akduwUjM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t9aCuWhxlH3sXXXFruvj8lEfBTsURpdl1O+k5tZShAQAhh7uhQYqZNHW0nVALO0q5UFZ72YlJa6MgTILsf/CU9grXtTKZLRevCoftjU+v9TUwO1IBfliubzWtmSKf6L4TTQkvp0xv7NgnJTM0U5ESA8UiFplsEE+HaVsDobGoYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pfw+5l2G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9025DC4CEC4;
	Sun,  8 Sep 2024 02:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725763094;
	bh=QRLowZOK063HZ8aCZ32C9grtYQV6cWDgqk9akduwUjM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Pfw+5l2GeOPPyWuqs9BNFXOTTj16lFZ+PFrQ7ZYtTaKeFaG6WOxJVE41svVzhXrsb
	 Kb7OJYTghOJhm3QNvduiPXCV8EwtBRMdUMtBuuNI2MwGo7afpIO0DPxR8zgpOIiIro
	 PjyQ+sNJJXYoce07yxsvDnsn0bxispffHGywP3unKsCVYH+a3Y4nkPFHwzV0talOa9
	 I/9P30awNAU5XSN5a18O3OQ2wBAeAcvUkyuAxAUvnzz6YuUWsWfyD1c6RGAAY6fxvH
	 WKZHWo/tJqUHHb2QRh6E1LHqjyZBRW54zLARr5V3j6TxZ2//YDzMoPH7v4eSRnJFmw
	 CKFzqP2TvWVSg==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5c3d209da98so4954048a12.1;
        Sat, 07 Sep 2024 19:38:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUyNEjgKoaKPvDM/b1VRtDmAs7dVLQ4I4205k1GNa3X3XDVgSCgDWDyEkojxzQwSXSznQc=@vger.kernel.org, AJvYcCV1qnh6Mcw3+drUk0c+Y5vNzlBMY/VnNWaPvG1sGRmXQKbqsk+ZoxcSPtEZVWQi6l53G5dNmhqAEps=@vger.kernel.org, AJvYcCWdfjrp8MS9PVbePg38q/HXWBRDl5MO31Hy5Lhg7ziMOF8AtnGK7/lQnQWuumN443by02PYBPJSvBDvYDa9@vger.kernel.org, AJvYcCXyNE0ISy70+MepMk+asXopEJ9OOOl1q1mRzoYGZ+AdjzWTqMCcszMcaE8z2FrNe49nHCFO407ccWY3yw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwV31/OHLNHA6R9R5xY0UxVmNw4fU9Ma7h7UzxprFHBBc52U7g5
	3OM+YqUCCIu+l35qpCCJGfi/C71dx1ZmLoaKHeNoAeZR+2a+Jaw5HUJ0fNM+UuwOoRA2ZDxncHZ
	RXFjH6qxhgwCNVwW0boPUrP+eckU=
X-Google-Smtp-Source: AGHT+IGrmEb6wjce45DDeIXQI62sW6ehBa4TumudW+Xqf5CX2GvNkX+QBM4cqNClCBuXL95+M0TaZ+7xljM4dw9T+wE=
X-Received: by 2002:a05:6402:3549:b0:5c2:5f31:8888 with SMTP id
 4fb4d7f45d1cf-5c3c1f9cbd4mr13982347a12.15.1725763093152; Sat, 07 Sep 2024
 19:38:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240907-iocsr-v1-0-0c99b3334444@flygoat.com> <20240907-iocsr-v1-1-0c99b3334444@flygoat.com>
In-Reply-To: <20240907-iocsr-v1-1-0c99b3334444@flygoat.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 8 Sep 2024 10:38:07 +0800
X-Gmail-Original-Message-ID: <CAAhV-H64tf8=XekeBKwR3w65ofjUrbgeqPngNxiT-11EHMKwdA@mail.gmail.com>
Message-ID: <CAAhV-H64tf8=XekeBKwR3w65ofjUrbgeqPngNxiT-11EHMKwdA@mail.gmail.com>
Subject: Re: [PATCH 1/5] LoongArch: Rename cpu_has_csr as cpu_has_iocsr
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
> It meant to be IOCSR as CSR is not optional for LoongArch.
Keep the CSR definition and add IOCSR definition after it, OK? This
also means the 1st patch can be dropped.

And it is just OK to change the values after CPU_FEATURE_CSR, because
they are only for internal use.

Huacai
>
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  arch/loongarch/include/asm/cpu-features.h | 2 +-
>  arch/loongarch/include/asm/cpu.h          | 2 +-
>  arch/loongarch/kernel/cpu-probe.c         | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/cpu-features.h b/arch/loongarch/i=
nclude/asm/cpu-features.h
> index 16a716f88a5c..0190ed28a647 100644
> --- a/arch/loongarch/include/asm/cpu-features.h
> +++ b/arch/loongarch/include/asm/cpu-features.h
> @@ -50,7 +50,7 @@
>  #define cpu_has_lbt_arm                cpu_opt(LOONGARCH_CPU_LBT_ARM)
>  #define cpu_has_lbt_mips       cpu_opt(LOONGARCH_CPU_LBT_MIPS)
>  #define cpu_has_lbt            (cpu_has_lbt_x86|cpu_has_lbt_arm|cpu_has_=
lbt_mips)
> -#define cpu_has_csr            cpu_opt(LOONGARCH_CPU_CSR)
> +#define cpu_has_iocsr          cpu_opt(LOONGARCH_CPU_IOCSR)
>  #define cpu_has_tlb            cpu_opt(LOONGARCH_CPU_TLB)
>  #define cpu_has_watch          cpu_opt(LOONGARCH_CPU_WATCH)
>  #define cpu_has_vint           cpu_opt(LOONGARCH_CPU_VINT)
> diff --git a/arch/loongarch/include/asm/cpu.h b/arch/loongarch/include/as=
m/cpu.h
> index 843f9c4ec980..7c44f4ede3a2 100644
> --- a/arch/loongarch/include/asm/cpu.h
> +++ b/arch/loongarch/include/asm/cpu.h
> @@ -115,7 +115,7 @@ enum cpu_type_enum {
>  #define LOONGARCH_CPU_LBT_ARM          BIT_ULL(CPU_FEATURE_LBT_ARM)
>  #define LOONGARCH_CPU_LBT_MIPS         BIT_ULL(CPU_FEATURE_LBT_MIPS)
>  #define LOONGARCH_CPU_TLB              BIT_ULL(CPU_FEATURE_TLB)
> -#define LOONGARCH_CPU_CSR              BIT_ULL(CPU_FEATURE_CSR)
> +#define LOONGARCH_CPU_IOCSR            BIT_ULL(CPU_FEATURE_IOCSR)
>  #define LOONGARCH_CPU_WATCH            BIT_ULL(CPU_FEATURE_WATCH)
>  #define LOONGARCH_CPU_VINT             BIT_ULL(CPU_FEATURE_VINT)
>  #define LOONGARCH_CPU_CSRIPI           BIT_ULL(CPU_FEATURE_CSRIPI)
> diff --git a/arch/loongarch/kernel/cpu-probe.c b/arch/loongarch/kernel/cp=
u-probe.c
> index 14f0449f5452..4446616d497c 100644
> --- a/arch/loongarch/kernel/cpu-probe.c
> +++ b/arch/loongarch/kernel/cpu-probe.c
> @@ -91,7 +91,7 @@ static void cpu_probe_common(struct cpuinfo_loongarch *=
c)
>         unsigned int config;
>         unsigned long asid_mask;
>
> -       c->options =3D LOONGARCH_CPU_CPUCFG | LOONGARCH_CPU_CSR |
> +       c->options =3D LOONGARCH_CPU_CPUCFG | LOONGARCH_CPU_IOCSR |
>                      LOONGARCH_CPU_TLB | LOONGARCH_CPU_VINT | LOONGARCH_C=
PU_WATCH;
>
>         elf_hwcap =3D HWCAP_LOONGARCH_CPUCFG;
>
> --
> 2.46.0
>

