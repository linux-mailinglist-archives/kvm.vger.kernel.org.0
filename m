Return-Path: <kvm+bounces-25221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 736CC961BD7
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 04:08:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58D6B1C23248
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 02:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E97CC481CD;
	Wed, 28 Aug 2024 02:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IFYDvnZl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC7F3CF74;
	Wed, 28 Aug 2024 02:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724810925; cv=none; b=dLeHGNpR/P2lAneZKvmcVdJmjfQp0ORIaTvi7FrU4GMUPXNhWICMYCnbENTy3pU1KfZ2N6Rhl/2WAoB8djYvnRpc9kB6viK9vdDWyJ6V6nh3ZuRKwzrf/jr4jva6rnixIm3/ZOhlm6azM1u2EBLUCY1GE0i+/+9209Vg5zcNXzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724810925; c=relaxed/simple;
	bh=PyXAgK3hCiX7g/AOrmr8UOJ62EPFkWTDqV8Km9Rnf+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NgDo7+WgOlbt+11LCBDcyN1ja8zvrQkAa9HVQ3znJZzfLbTEPN2KI7CGmcbHaWqpFzUjvzpgCS1/h8qgQMGPq0B4vIPfFyyahchC22uFxhoD3hn0/ekvMHsH0X2GBvBLP/CkRIekNlY8yJ4t4UzZI4mLWBSbFj15v5dq2bnnF0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IFYDvnZl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53DBC32786;
	Wed, 28 Aug 2024 02:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724810924;
	bh=PyXAgK3hCiX7g/AOrmr8UOJ62EPFkWTDqV8Km9Rnf+o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IFYDvnZl8QfL0eYewOPH9pAFZg928JTAGdsKSLjzsAi017dZgL4t+JBn/VmLFJrvu
	 Lgm0rCjVQj1Lfy3chePtDNPsSK9SVlCCHfgvEeQ5yimynRaQdgPY4uVRUtSr0QDDMu
	 Kl+YDOicjyAGC9RebteQwf3ruHa/drLwEl4bZ301oNvrkM/05SQyGdTMSmzInOvacr
	 wj14ZCr9JQRQy2x/1IPtXA2v0djX9T4eBov6MBJGwOCJhiPZtfvnn/5Qo5BFA02kx4
	 /juiP5Mv7Rwi95lYDzRRvOyAhUcNvddBU4ZE/reBai7fa53Jbfb4+oMXPNnvIYWRiG
	 uGv/otRB6z+2g==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5bec4e00978so5932515a12.0;
        Tue, 27 Aug 2024 19:08:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWguaJ3nkFhoiR3wMdBuKokUY3W2fd6ct6PN2oPvLvZQtkd9pDyx7V3UzVeLI7QUYvISUhhH9faUUi1StHZ@vger.kernel.org, AJvYcCX5oimhbs/z2amajsTdmhOuzhFXRJU2alYIJmw2YLKuEDBFvamNLIGMoFeD7z7QxPEhKAo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw66+cS3EgHHNDuVjrWwASPCHPlH5OAzweaWyCEJL8ulm+8J8V1
	2wcW8sCgUAv6hrzzkdy2SR7FCqz1cNhQ+wF9GzY8dZCpWRVO5+3k56nJXwevoLJcH6ZjEzAS0xN
	NO82U8CBoaLUcI+MzZE4Oe4i+w1g=
X-Google-Smtp-Source: AGHT+IH7Jrq69vMjEx8udMHOd9V1G865e3s2FI6Xp4dfpGdJMTTiwR4c6hfXXHPr/VEf5xug5BLkyMppDjkJPlSn4ew=
X-Received: by 2002:a05:6402:d06:b0:5bf:2577:32b8 with SMTP id
 4fb4d7f45d1cf-5c089163827mr10647025a12.9.1724810923248; Tue, 27 Aug 2024
 19:08:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240730075744.1215856-1-maobibo@loongson.cn>
In-Reply-To: <20240730075744.1215856-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 28 Aug 2024 10:08:30 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6dFBJ+dQE7qzK8aiTjx8NFJtzPWzEGpJ8dm7v4ExD8Ow@mail.gmail.com>
Message-ID: <CAAhV-H6dFBJ+dQE7qzK8aiTjx8NFJtzPWzEGpJ8dm7v4ExD8Ow@mail.gmail.com>
Subject: Re: [PATCH v6 0/3] LoongArch: KVM: Add Binary Translation extension support
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

I have consulted with Jiaxun offline, and he has tried his best to
propose a "scratch vcpu" solution. But unfortunately that solution is
too difficult to implement and he has nearly given up.

So the solution in this series seems the best one, and I will queue it
for loongarch-kvm now.

Huacai

On Tue, Jul 30, 2024 at 3:57=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Loongson Binary Translation (LBT) is used to accelerate binary
> translation, which contains 4 scratch registers (scr0 to scr3), x86/ARM
> eflags (eflags) and x87 fpu stack pointer (ftop).
>
> Like FPU extension, here lately enabling method is used for LBT. LBT
> context is saved/restored during vcpu context switch path.
>
> Also this patch set LBT capability detection, and LBT register get and se=
t
> interface for userspace vmm, so that vm supports migration with BT
> extension.
>
> ---
> v5 ... v6:
>   1. Solve compiling issue with function kvm_get_one_reg() and
>      kvm_set_one_reg().
>
> v4 ... v5:
>   1. Add feature detection for LSX/LASX from vm side, previously
>      LSX/LASX feature is detected from vcpu ioctl command, now both
>      methods are supported.
>
> v3 ... v4:
>   1. Merge LBT feature detection for VM and VCPU into one patch.
>   2. Move function declaration such as kvm_lose_lbt()/kvm_check_fcsr()/
>      kvm_enable_lbt_fpu() from header file to c file, since it is only
>      used in one c file.
>
> v2 ... v3:
>   1. Split KVM_LOONGARCH_VM_FEAT_LBT capability checking into three
>      sub-features, KVM_LOONGARCH_VM_FEAT_X86BT/KVM_LOONGARCH_VM_FEAT_ARMB=
T
>      and KVM_LOONGARCH_VM_FEAT_MIPSBT. Return success only if host
>      supports the sub-feature.
>
> v1 ... v2:
>   1. With LBT register read or write interface to userpace, replace
>      device attr method with KVM_GET_ONE_REG method, since lbt register i=
s
>      vcpu register and can be added in kvm_reg_list in future.
>   2. Add vm device attr ctrl marcro KVM_LOONGARCH_VM_FEAT_CTRL, it is
>      used to get supported LBT feature before vm or vcpu is created.
> ---
> Bibo Mao (3):
>   LoongArch: KVM: Add HW Binary Translation extension support
>   LoongArch: KVM: Add LBT feature detection function
>   LoongArch: KVM: Add vm migration support for LBT registers
>
>  arch/loongarch/include/asm/kvm_host.h |   8 ++
>  arch/loongarch/include/asm/kvm_vcpu.h |   6 ++
>  arch/loongarch/include/uapi/asm/kvm.h |  17 ++++
>  arch/loongarch/kvm/exit.c             |   9 ++
>  arch/loongarch/kvm/vcpu.c             | 128 +++++++++++++++++++++++++-
>  arch/loongarch/kvm/vm.c               |  52 ++++++++++-
>  6 files changed, 218 insertions(+), 2 deletions(-)
>
>
> base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
> --
> 2.39.3
>
>

