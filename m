Return-Path: <kvm+bounces-26069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 88EB79701B2
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 12:25:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32D531F23254
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 10:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C143415855E;
	Sat,  7 Sep 2024 10:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VpwZxgXv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8BF1B85DC;
	Sat,  7 Sep 2024 10:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725704716; cv=none; b=dj451r3/bmb4DhD/ipNtaWXKxxutCaom0wXdfv9Ynku8QLCsTn5Znqp2GgcClhCwOle/Xp8HAnEpvmEuoPv1r6zKCO59yMXo/LsDJ9aDmX0AlPH2U1viSnrGSORUBrosMV8UCWRLmbZpwc/P6sa9oSe2lLVREBfSAuEwFK8Z05s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725704716; c=relaxed/simple;
	bh=ZOiBC4rw7rIWO+otusVVv6/+6fAyiwV8MUgpz+CZHI0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e4oXl6uf/14bIwixdJByQgJ+KEG8Hh4+T4QuZor3XBSTve+FlBGbe77yppLVpGARCCg18pVjw1ORg8uIcguZsh2BVoL+pRkwy1VNphFbYwOBLMW7lEF4asqo4B4UBUouTc9u9ARBgfskt4peiVmcklJ+oS76ZqXEfAx8evidlag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VpwZxgXv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477F3C4CECC;
	Sat,  7 Sep 2024 10:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725704715;
	bh=ZOiBC4rw7rIWO+otusVVv6/+6fAyiwV8MUgpz+CZHI0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VpwZxgXvA07XEpUo7eE5oUFnUrsYDAvnO3xFpU7yIW7buESD/V3moqEdgge30TTTK
	 DGDEf0AlxJ8IhT+vt3v4HFj+BJBWS5SOROAnFaZHB89Lr8yQqdD+syRjUOWKCnlCwd
	 gKNWUMPxrNpUdbs6iF6Y1rMfPo9NVj5/aPogBrtNNnU2YgJxxngmwRAnNZ8XbZKZqD
	 kgehV6ws1t/gad+9m+EcC040XCES7lMLdh8dypSbApu764ULiu82CqJRq9Jy48oPs9
	 uQ2IEw37QafsKY8SkA68uqWpaKQAtQaXkb7hpINxf5hSTMlqj+ErqxUlJVRCWfa0sT
	 5DPVc3YY5CEFg==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5c245c62362so3701678a12.0;
        Sat, 07 Sep 2024 03:25:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWbndEXLLzsnDf+MZmoIC0boWRLp4IhwTX2Z/FFVS5y4b3sFlaOpqcA/uyPknI9bal7KH4IcdX2mgfUHw==@vger.kernel.org, AJvYcCXTt1AAUtXYdEqHlT5IRji6TRQKns1GdoCL02Hv7s07n3tVGslX3BVdVcQ24oqqbNuGHdY=@vger.kernel.org, AJvYcCXUpDvL4bJ73nz13cPQBYiuId+kBM4d0BQHmaOaQa43gmZX8ESDQ9cdsWLl+SO4WpbPeTe1uA9eO7k=@vger.kernel.org, AJvYcCXoQaiTlDEaf0Azh02D5unyGoBvBoFzrmN98g0TZ7fFQEzlJSWh1JtSZJgRKqR64HrBSbL9btHJngOuasA/@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5Q/k7G5yhb5LtP8KtTI9ZyBkecPtpE0Z3vsj0uozZotKv0fTH
	CYqhFfHWF0rFqiWKhLwfB65KbdzKkJmt3N7wPZGT1uwMvTGYQ6kSajUmxJqaJgiYlGVkR8jUya5
	CyZO0mF7zBT+4kjGBOnk8IC5CqTM=
X-Google-Smtp-Source: AGHT+IF8gDSC2GgNG2uVaXUQhdcpbo41b6uqGtyA4cNTr9plIk60bkOTAnAU7uTyrLqBdsM7rP7CbJbwQQgpHzY6uyU=
X-Received: by 2002:a17:906:db0a:b0:a86:843e:b3dc with SMTP id
 a640c23a62f3a-a8a888ef4e0mr523837766b.62.1725704713795; Sat, 07 Sep 2024
 03:25:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240907-iocsr-v1-0-0c99b3334444@flygoat.com>
In-Reply-To: <20240907-iocsr-v1-0-0c99b3334444@flygoat.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 7 Sep 2024 18:25:01 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7W06a8cyPtSTPibJw5jOsv9Oees-hJ+-jZgaiU31Ki-g@mail.gmail.com>
Message-ID: <CAAhV-H7W06a8cyPtSTPibJw5jOsv9Oees-hJ+-jZgaiU31Ki-g@mail.gmail.com>
Subject: Re: [PATCH 0/5] LoongArch, MIPS: Unify Loongson IOCSR handling
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
> Hi folks,
>
> This series unfied LoongArch and MIPS's IOCSR functions and
> macros so they will expose same interface to arch-indenpendent
> drivers.
>
> This can reduce code deuplication, and also help my unifed IPI driver
> and MIPS extio driver effort.
>
> This is touching many sub-systems in once so might be hard to merge.
>
> Huacai, can you apply first three patch via loongarch-next tree.
> For last two patch maybe better merge them via a second PR after
> all subsystem PRs merged.
The problem is I'm not sure whether IOCSR registers are compatible in
all Loongson processors.

Huacai

>
> Please review.
> Thanks
>
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
> Jiaxun Yang (5):
>       LoongArch: Rename cpu_has_csr as cpu_has_iocsr
>       LoongArch: Probe more CPU features from CPUCFG
>       LoongArch: cpu-probe: Move IOCSR probing out of cpu_probe_common
>       LoongArch: Extract IOCSR definitions to standalone header
>       MIPS: Loongson64: Use shared IOCSR header
>
>  MAINTAINERS                                        |   1 +
>  arch/loongarch/include/asm/cpu-features.h          |   2 +-
>  arch/loongarch/include/asm/cpu.h                   |   4 +-
>  arch/loongarch/include/asm/loongarch.h             |  90 ---------------=
-
>  arch/loongarch/kernel/cpu-probe.c                  | 111 ++++++++++++---=
-----
>  arch/loongarch/kernel/relocate_kernel.S            |   5 +-
>  arch/loongarch/kernel/smp.c                        |  23 +++--
>  .../include/asm/mach-loongson64/loongson_regs.h    |  58 +++--------
>  arch/mips/kvm/vz.c                                 |   2 +-
>  arch/mips/loongson64/smp.c                         |  44 ++++----
>  drivers/cpufreq/loongson3_cpufreq.c                |  10 +-
>  drivers/irqchip/irq-loongarch-avec.c               |   5 +-
>  drivers/irqchip/irq-loongson-eiointc.c             |   5 +-
>  drivers/platform/mips/cpu_hwmon.c                  |   7 +-
>  include/linux/loongson/iocsr.h                     | 113 +++++++++++++++=
++++++
>  15 files changed, 256 insertions(+), 224 deletions(-)
> ---
> base-commit: 9aaeb87ce1e966169a57f53a02ba05b30880ffb8
> change-id: 20240906-iocsr-829075458511
>
> Best regards,
> --
> Jiaxun Yang <jiaxun.yang@flygoat.com>
>

