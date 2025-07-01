Return-Path: <kvm+bounces-51183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 043F1AEF583
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 12:48:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F05117C106
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 10:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21FF11DED52;
	Tue,  1 Jul 2025 10:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dx1wFUlc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5292701A3;
	Tue,  1 Jul 2025 10:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751366928; cv=none; b=aYBU+hs3ZpUTrzouqeMOZQbRSaJvP3+UyZOO/FDD4kc25oK65tQ1XZuTUhytbqvwqFvl9GPNDsQ3V5MDmIgl2hClL0g8Kf4zjk0NRdwIETIrD3Uk6CUUb3Q1Aliz2+JpfkeOLvOdDksuf78DKb88WUmAbfyFiGxCwF/eL5XMd1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751366928; c=relaxed/simple;
	bh=wWnhQlgqRFcsI0tUGKX5OnHqDSBfhTR+33mzJ5nYftg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YlAMzNsr0xeCmzKviUpmWm07oBnyVJ9H6+yKReOa32nYRGo9tmm8/bERzLbf/fYm+86IvqtRX7Tr9uucs3CQLAmeDxxH7t0KSDX7a00Im4oqmfy6ZSb3qUQDR9TUEn/8/V5CS+479baqofmgJgR5Ic/fwq/c2eR9mwqo9Aw+q2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dx1wFUlc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3C8C4CEEE;
	Tue,  1 Jul 2025 10:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751366927;
	bh=wWnhQlgqRFcsI0tUGKX5OnHqDSBfhTR+33mzJ5nYftg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Dx1wFUlcTjJWf4FP2Ou2wYJxA8S76uOKBF1jt1AsAZBPrGET7x31WzXwxFwoOBcIM
	 gXT1w5mYBcP6EZxbvqDqL7Bd+BrtRXgCEUsZs9xjxjUiM4IT9exa5uPj/NEk1ELY2e
	 XJzmtoB6rBujheGlJBN40TNeJMv8SuEw2SkvlQzhh56nVrp0Oe2xa8tYhco4k15ZUs
	 Txq5bjfW1X0GknRhEAQ+mnsoq7EVhSGg801XU/xDV+IfWovIVJXrs5cWJBZ7lslqJ+
	 cisMRgtkHWYCWja8EGyGz93KrrNdQ3cijt1U2mSsHINZRt9MT8D0669SZY10HLWOV8
	 IFDLSTKg5Qigw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ade5a0442dfso1052437766b.1;
        Tue, 01 Jul 2025 03:48:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVzNkida2W9p8+c/Jlu5496gR5fAAXIKU2oURTROnibPEp3buu9nFVIK6t1BNPNa6KDRU4=@vger.kernel.org, AJvYcCW2QUhwkKPpDaEpKKXL/fLNHwdPysLB1pSEf3GDmv2C6HX3F5OvW/opw4nhJG15H9vyFWQN87FWQeR9S7Km@vger.kernel.org
X-Gm-Message-State: AOJu0YxKyK2baVDNNebA+TsTtJv9RP0akHi0VWW5C9FVLSr7PsqbVNRk
	wUBfp7/fu672mlryr+EYnONHGd8NR+HjVIHrPUbfOoBp7RTvz7H2vhfo9wzOo3KeHnJkicXyMPC
	qTsD58CivvYwPoSsjnEqMqCot3/YTvM0=
X-Google-Smtp-Source: AGHT+IGqvzLgOVq+bSq8v3Ag9CnbkMRooSZl3rhSTQn7AarVuHFnGXtfWWpqlu2upcK8/sObIC8F7yz1RluBs0yBhAM=
X-Received: by 2002:a17:907:e2e0:b0:ae0:cf28:6ec2 with SMTP id
 a640c23a62f3a-ae350220e87mr1484731566b.61.1751366926309; Tue, 01 Jul 2025
 03:48:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250701030842.1136519-1-maobibo@loongson.cn>
In-Reply-To: <20250701030842.1136519-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 1 Jul 2025 18:48:34 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6pt74LDg0idJ=71RG9MDh2KkMxE-Fao-qCFexyd8fz4A@mail.gmail.com>
X-Gm-Features: Ac12FXwGe-7mJS1-ZNuGmocQDey2sv7QUJ9UE-dTxWIsbFOiEKHfnUk7exY7_io
Message-ID: <CAAhV-H6pt74LDg0idJ=71RG9MDh2KkMxE-Fao-qCFexyd8fz4A@mail.gmail.com>
Subject: Re: [PATCH v5 00/13] LoongArch: KVM: Enhancement with eiointc emulation
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Tue, Jul 1, 2025 at 11:08=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> This series add generic eiointc 8 bytes access interface, so that 1/2/4/8
> bytes access can use the generic 8 bytes access interface. It reduce
> about 300 lines redundant code and make eiointc emulation driver simple
> than ever.
>
> ---
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
> Bibo Mao (13):
>   LoongArch: KVM: Use standard bitops API with eiointc
>   LoongArch: KVM: Remove unused parameter len
>   LoongArch: KVM: Add stat information with kernel irqchip
>   LoongArch: KVM: Remove never called default case statement
>   LoongArch: KVM: Rename loongarch_eiointc_readq with
>     loongarch_eiointc_read
>   LoongArch: KVM: Use generic read function loongarch_eiointc_read
>   LoongArch: KVM: Remove some unnecessary local variables
>   LoongArch: KVM: Use concise api __ffs()
>   LoongArch: KVM: Replace eiointc_enable_irq() with eiointc_update_irq()
>   LoongArch: KVM: Remove local variable offset
>   LoongArch: KVM: Rename old_data with old
>   LoongArch: KVM: Add generic function loongarch_eiointc_write()
>   LoongArch: KVM: Use generic interface loongarch_eiointc_write()
Patch5 and Patch6 can be squashed, Patch7 and Patch10 can be squashed,
Patch8 and Patch9 can be squshed, Patch12 and Patch13 can be squashed,
Patch11 is useless so can be removed.


Huacai

>
>  arch/loongarch/include/asm/kvm_host.h |  12 +-
>  arch/loongarch/kvm/intc/eiointc.c     | 557 ++++----------------------
>  arch/loongarch/kvm/intc/ipi.c         |  28 +-
>  arch/loongarch/kvm/intc/pch_pic.c     |   4 +-
>  arch/loongarch/kvm/vcpu.c             |   8 +-
>  5 files changed, 102 insertions(+), 507 deletions(-)
>
>
> base-commit: d0b3b7b22dfa1f4b515fd3a295b3fd958f9e81af
> --
> 2.39.3
>

