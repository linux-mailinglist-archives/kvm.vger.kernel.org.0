Return-Path: <kvm+bounces-39806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D922A4AB4D
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 14:42:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 229F216F1DC
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 13:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A86E1DF96C;
	Sat,  1 Mar 2025 13:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sMJtyjVe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819E61DE4F6;
	Sat,  1 Mar 2025 13:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740836563; cv=none; b=uYy+tm96kJVzW5YikTEhCCjjP1848u2rBG5knbcVR0C+ZOpsyh7aCSeYZd6mJz10qbgdLGngvwgw4ews/m6POXPr/4luEkD51CbSk2lZDdxFZgMuhs9YCYYTG5qRwrz04RqvaHBtgdTZeXneOPP/RI0EKzgcbJ/4J8oUIdJsRbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740836563; c=relaxed/simple;
	bh=Z8zMDv8qu6ou+xGr30VuTjYQJcFwmoaHVYRNEYOu2vc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J3Og4Ib3UnnXoTZSja+QqRKQJuTEYaY6U0HNV0Y2GhkErvTU1VRsva1jo1MnocxgEpp+cm6EAeSiz0HzE8TQwJd7BsLESSWoGmyDUISsB5Mj0WyLR06uacAsoDfqD18PPQaa2OtVz8wr0b+E3gT/JCn7uMXSOsOtVmSEs7U6BsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sMJtyjVe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEFBC4CEE8;
	Sat,  1 Mar 2025 13:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740836563;
	bh=Z8zMDv8qu6ou+xGr30VuTjYQJcFwmoaHVYRNEYOu2vc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sMJtyjVefVJ0p745U4YRi7oWxAKQKqUrhOFD8mDN+xI/jOITNX3KsF751sbK31p6M
	 CaDqHlkYeivGms0P8dyENyJcCN4Us+4E/AJeWddOZW7CDG/n3vPJmM3WZGKut/OPw4
	 v7xxG0Qwkb2ztEs/WkcE2LZgq+0fvoOy6K/nEvTOFzHwdzVJCWBEyfHiQugkzlIUsX
	 d9BAiXjecBWITaab6Nc7ATquxjF+mRxdCPdDH/h7S0oMR0P6Nx28ZwdN7EFWeorGVf
	 zAJLb06KEFtHaO5sUMzw5mSMhZcjilDdA9RIlokBq0D645SILM2zgtOrQi4Kv2VPEs
	 zXrOYOhjN1L0g==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-abbdf897503so734022666b.0;
        Sat, 01 Mar 2025 05:42:43 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU/raasvFGXU0MEQq52FitoZAwMHa1bem3/lMBZm9GV9OpdFNByubhJcB6OVqq3gUryQw0=@vger.kernel.org, AJvYcCXPrFZk4Lec49mRQbNynowJav5kN0JN01K78KZGoFHfjrt46t+mPFdGG1FEBn83dXayq+0W7ZtWEc7Un/2o@vger.kernel.org
X-Gm-Message-State: AOJu0YzI3Yxd/gUE4My+UxZ3TMODIe0i9HA5Sp9/ibjdZYJJfcFv/bxN
	CVmwn9AnGfZ/EZkpoAjtTuJmI9C87PfbrjhB2c1jPaoi1Zpe9wjOXKom9fWrlYdyHnyXI8CP2ST
	RtBFhZ17ws+N6zzpSOSpV5iEMVH0=
X-Google-Smtp-Source: AGHT+IHkD42HcgB4QdeErm9poJ52wRi8uH5oIkeYW51wGmz4NjwRjrF+ta71gyju8BDJuA/X2m5a8sburuR9oC9INRE=
X-Received: by 2002:a17:906:a0d2:b0:abf:6e9:3732 with SMTP id
 a640c23a62f3a-abf06e93d0fmr951847566b.3.1740836561700; Sat, 01 Mar 2025
 05:42:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250219033823.215630-1-maobibo@loongson.cn>
In-Reply-To: <20250219033823.215630-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 1 Mar 2025 21:42:30 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7-wGUjmWvRRV+zHMXXnc3ERzHp1DvQSFaQYx-SzPHiNg@mail.gmail.com>
X-Gm-Features: AQ5f1JpFCT3S5Cjl7iryurY5z7wzeO_pCujXZiheTScxli0VZ7VREdksCLKfUFc
Message-ID: <CAAhV-H7-wGUjmWvRRV+zHMXXnc3ERzHp1DvQSFaQYx-SzPHiNg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] LoongArch: KVM: Enhancement about PGD saving
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Series applied, thanks.

Huacai

On Wed, Feb 19, 2025 at 11:38=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> There is enhancement about PGD saving about KVM hypervisor. Register
> LOONGARCH_CSR_PGDL is shared between host kernel and KVM hypervisor.
> For host kernel it is for user space pgd of VMM threads, secondary mmu
> for KVM hypervisor. Both are not changed after VM is created, so it
> can be saved as host_pgd and kvm_pgd in advanced.
>
> Also it fixes GPA size typo issue, it should cpu_vabits rather than
> cpu_vabits - 1. And inject data abort error to VM if it exceeds maximum.
> GPA size. For example there will be data abort when executing command:
>  # busybox devmem 0xc00000100008
>   Bus error (core dumped)
> Previous it is treated as MMIO address and let VMM handle this.
>
> ---
>   v1 ... v2:
>     1. Use name kvm_pgd rather than host_second_pgd for PGD of
>        hypervisor.
>     2. Fix GPA size typo issue and add page fault address checking.
>
> ---
> Bibo Mao (2):
>   LoongArch: KVM: Remove PGD saving during VM context switch
>   LoongArch: KVM: Fix GPA size issue about VM
>
>  arch/loongarch/include/asm/kvm_host.h |  2 ++
>  arch/loongarch/kernel/asm-offsets.c   |  4 +---
>  arch/loongarch/kvm/exit.c             |  6 ++++++
>  arch/loongarch/kvm/switch.S           | 12 ++----------
>  arch/loongarch/kvm/vcpu.c             |  8 ++++++++
>  arch/loongarch/kvm/vm.c               |  7 ++++++-
>  6 files changed, 25 insertions(+), 14 deletions(-)
>
>
> base-commit: 2408a807bfc3f738850ef5ad5e3fd59d66168996
> --
> 2.39.3
>

