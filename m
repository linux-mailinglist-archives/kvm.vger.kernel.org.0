Return-Path: <kvm+bounces-52609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EFE01B07339
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 12:21:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6AF261882F18
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 10:21:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90752F4320;
	Wed, 16 Jul 2025 10:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GfuLaJ/+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A4E2F4316;
	Wed, 16 Jul 2025 10:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752661195; cv=none; b=h2MOdVljB/5115FYhfOHNSlLWbx8P+i7V3t1FRjUMbppUOixA78PTRGM16Zb4BreMnyv1JuXKpzYO89jcbWZHGTMmChl0U01w0mPskABCX7SFDSmlJR9zwFXr0R8fUBgthEgOf2LVcNgTBxLcN7LVciZ39Rf6kjEvHo6g+qYO0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752661195; c=relaxed/simple;
	bh=8kJXGogC+xtdCvbe6QsC3MjM2fHwl2vl79nSR9/Gos8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Swi1xD5/shmSS37ArjfIqGGUvNUGjBhfOaT2GLX8yGPM+wPdxoyfksxmBAMWFmKrePdS07o8moAda+O2+X64iFB8r6dOBmCGc46/z0hUGoSXS/TPTknTav6kqOkfGEUkFU8fSlbhYnBoju6PvQnmRkOCVcGtZh+t94AExsl5lGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GfuLaJ/+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC24C4CEF8;
	Wed, 16 Jul 2025 10:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752661194;
	bh=8kJXGogC+xtdCvbe6QsC3MjM2fHwl2vl79nSR9/Gos8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GfuLaJ/+AOvSNpOsqhDdfXD+K8c2pJd6/CpflJsmMGXmwFT0+C5SW9vvcKSfkqf2Z
	 gG4cXCHWpmn2UwZhQ+JzgH7N9Xu8tAciCrSYhCtxLGF4LDmCnJY4aXoJPWyGgxWsud
	 EJ+O5XiYpl2/TDvGKVKtz4HsGEa0HiagZjmH0LBfC1yNyES3X+w743LPLL2J2q8h/q
	 A+eS2c7nC17dFMisVww5y6YrhuP9cDJKLr9PDxaQdI5XFFWlH4Q9gxQZoVbhMfZ1iJ
	 pqbVuwRtkaiIaPEpFq3m1cxa5lFID22T6Of4dLH0/3cuBpRs+1waStPQcCURHjjaNL
	 29Ckx8rACeA2g==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6099d89a19cso11665496a12.2;
        Wed, 16 Jul 2025 03:19:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWher+HcwQ55NGogmFZrVQgWir2EluqUTi3kaMTMucYMLZJe1ckyQMbwDAHzzsxP8RHKGwTzX/u+iY+P4m2@vger.kernel.org, AJvYcCWt65UL6ywBsuWoP8rUGlDCGmm1a0b37ZgXJIqvjcCTNDmtz0kDmlQ+CYp6i4q0OTnsRJI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQLPT444nAhk0bOFmZ6sOgA7Sne08vJrUWdAu0DPhD0K1eosmY
	YmhWuw7nJHNQF2uZigVtjAaG+Fe6/rJT1BOyLxhqH+y/qAYSa4g1rcUZWrkg5bGz4f6YULZhbwu
	z3OKIb6Wjc2M+W2V+xPa+pxKnnoys6WU=
X-Google-Smtp-Source: AGHT+IGLf5F9ZG/NbE6Kve8ltdtbhY1XiBDXCOYdVJpmYYdvFJQIqMrlvYIypc/8SJSdFnawU6v27XpLcqd5fjLTl9c=
X-Received: by 2002:a05:6402:348a:b0:606:df70:7aa2 with SMTP id
 4fb4d7f45d1cf-61285bf41c5mr1880418a12.31.1752661193141; Wed, 16 Jul 2025
 03:19:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709080233.3948503-1-maobibo@loongson.cn>
In-Reply-To: <20250709080233.3948503-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 16 Jul 2025 18:19:41 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5x_V8CjX=Keb0k5+5zFtqh01MBWEo_hTFwwge-01jT9Q@mail.gmail.com>
X-Gm-Features: Ac12FXwd2qxljM80M1yo635HrTRXipUsmKiKsDP_pvPFX0beAQYXth9PLs0uqjU
Message-ID: <CAAhV-H5x_V8CjX=Keb0k5+5zFtqh01MBWEo_hTFwwge-01jT9Q@mail.gmail.com>
Subject: Re: [PATCH v6 0/8] LoongArch: KVM: Enhancement with eiointc emulation
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied with some modifications. E.g., Patch6 removes offset, and
Patch8 adds it back, so I combine these two.

Since the code is a little different, it is better to test it again [1].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongs=
on.git/log/?h=3Dloongarch-kvm



Huacai

On Wed, Jul 9, 2025 at 4:02=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrote=
:
>
> This series add generic eiointc 8 bytes access interface, so that 1/2/4/8
> bytes access can use the generic 8 bytes access interface. It reduce
> about 500 lines redundant code and make eiointc emulation driver
> simpler than ever.
>
> ---
> v5 ... v6:
>   1. Merge previous patch 5 & 6 into one, patch 7 & 10 into into one and
>      patch 12 and patch 13 into one.
>   2. Use sign extension with destination register for IOCSRRD.{B/H/W}
>      kernel emulation.
>
> v4 ... v5
>   1. Rebase patch on latest kernel where bugfix of eiointc has been
>      merged.
>   2. Add generic eiointc 8 bytes access interface, 1/2/4/8 bytes access
>      uses generic 8 bytes access interface.
>
> v3 ... v4:
>   1. Remove patch about enhancement and only keep bugfix relative
>      patches.
>   2. Remove INTC indication in the patch title.
>   3. With access size, keep default case unchanged besides 1/2/4/8 since
>      here all patches are bugfix
>   4. Firstly check return value of copy_from_user() with error path,
>      keep the same order with old patch in patch 4.
>
> v2 ... v3:
>   1. Add prefix INTC: in title of every patch.
>   2. Fix array index overflow when emulate register EIOINTC_ENABLE
>      writing operation.
>   3. Add address alignment check with eiointc register access operation.
>
> v1 ... v2:
>   1. Add extra fix in patch 3 and patch 4, add num_cpu validation check
>   2. Name of stat information keeps unchanged, only move it from VM stat
>      to vCPU stat.
> ---
> Bibo Mao (8):
>   LoongArch: KVM: Use standard bitops API with eiointc
>   LoongArch: KVM: Remove unused parameter len
>   LoongArch: KVM: Add stat information with kernel irqchip
>   LoongArch: KVM: Remove never called default case statement
>   LoongArch: KVM: Use generic function loongarch_eiointc_read()
>   LoongArch: KVM: Remove some unnecessary local variables
>   LoongArch: KVM: Replace eiointc_enable_irq() with eiointc_update_irq()
>   LoongArch: KVM: Add generic function loongarch_eiointc_write()
>
>  arch/loongarch/include/asm/kvm_host.h |  12 +-
>  arch/loongarch/kvm/intc/eiointc.c     | 558 ++++----------------------
>  arch/loongarch/kvm/intc/ipi.c         |  28 +-
>  arch/loongarch/kvm/intc/pch_pic.c     |   4 +-
>  arch/loongarch/kvm/vcpu.c             |   8 +-
>  5 files changed, 102 insertions(+), 508 deletions(-)
>
>
> base-commit: 733923397fd95405a48f165c9b1fbc8c4b0a4681
> --
> 2.39.3
>

