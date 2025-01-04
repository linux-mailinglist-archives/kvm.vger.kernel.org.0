Return-Path: <kvm+bounces-34557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B287A01527
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 15:10:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA083163B09
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 14:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E170E1BBBE5;
	Sat,  4 Jan 2025 14:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PuAjSWAI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8943E49D;
	Sat,  4 Jan 2025 14:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735999811; cv=none; b=VHdyF9ApxBgtBkyRFaq/z7B8ZZkybI3PNnx+XQ1aXnlOMONJq0IGGWbgjjSu4f5sSEDfphfg2CpQr6d6Gn04MyLJtBIm7kqh3QBPx74e/wd0bdkY1ond6l/BOUGShmxlscgNidcV4GAyKtQr9zu+TuoBP249K4AUMpmtayVpg8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735999811; c=relaxed/simple;
	bh=fs3FvyWEIAFcio0I/rqtVktB2z6mJR2z4FXr5zEbDvE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pusi0H5fp4YBfKtjzj58baXEBc2RWPX9TDk5yGyf5fi7O+KPBy8cF4U9HaiTzvgBWk+2A+mCxfEUjMTmKRfePEZ5qEJgUlNadnj8JV+jzzFVEgFZS9Ifvjv06u1STUXfyjRpYjtg0w+t5FZRi1WS1AK69pNvY1lxEQMxpgFsad0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PuAjSWAI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB707C4CED2;
	Sat,  4 Jan 2025 14:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735999810;
	bh=fs3FvyWEIAFcio0I/rqtVktB2z6mJR2z4FXr5zEbDvE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PuAjSWAIo63JM17TQic7Ka4b8Uet8/EbAjLhgz0cMkmF1j8fXy60tDieOBlTCZOoP
	 YqS+Up/47IthGQiFipDXSJT6HTPC3OwyOphE7ciosEuwU/AlWWU02kjpYZ2ns5Fy7P
	 RtZfi0hgwf25ZdzLi6yrtakxXp4zOOdrwm+wwhb1Von11THnJhVhK8TkUs3p1t7DaF
	 LjHcji1TygbYFdpaD8BzLTsMKxtIQAVfdAAYV4Bky89kXndd4zdFeaj3jEPgmbP9zj
	 8it5HNEtKXk4rHZx1cZovBC3HAQRrVLc9t6zCk+eDA3QG4LsoSqPTFK6x31b0EEHMn
	 AVjW3+p+tZtaQ==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a9e44654ae3so2154290266b.1;
        Sat, 04 Jan 2025 06:10:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW0PxDOV3t4DbHsST80/F5Q8YYtkNAbOTvpIT0I1hyYNNx08QiFGCzFip21S8LRCnI8PGU=@vger.kernel.org, AJvYcCWPejhEM+vMdjPZM4Ow+EPaBRWar3WLCxud1+DJyp2tAlCnX7p52kLio951m17dyCjaesU1Mu2K+adsaeMN@vger.kernel.org
X-Gm-Message-State: AOJu0YzbHb7Wy9SkYCw4DO35FUeIBfFYZXV3pm7n3hlpQ1VNoYlYLKWI
	Y0r2PIpRYhjM4144bxhvzr0v4/3gonOpKzNTbNH+5KhcBuXr4BDAuzq+gtLMEQawxjvR9zprpLZ
	pXuwXF6QE6nLdGIp8B3G+GxE8v5Y=
X-Google-Smtp-Source: AGHT+IHEjE6qukOyUl9kRjLC/5p8LJL6zAhmw7b/Y6RtBW/u7JLrN+Z7jJ5jgS1D8cWty0yr1F6mOHguXbHU/fndcv8=
X-Received: by 2002:a17:907:2cc2:b0:aa6:b1b3:2b82 with SMTP id
 a640c23a62f3a-aac27038e0cmr4220332066b.3.1735999809301; Sat, 04 Jan 2025
 06:10:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241113031727.2815628-1-maobibo@loongson.cn>
In-Reply-To: <20241113031727.2815628-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 4 Jan 2025 22:09:56 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5VH0k6byAX4U0e4rv4tdjtzTSrokXt3tjqpSFRzpU7gg@mail.gmail.com>
X-Gm-Features: AbW1kvaN7VNips6Y6pyj8sUCqLC-DsRpv4v9W0qelWhp8vHSgfPNuDaxt1BeaVg
Message-ID: <CAAhV-H5VH0k6byAX4U0e4rv4tdjtzTSrokXt3tjqpSFRzpU7gg@mail.gmail.com>
Subject: Re: [RFC 0/5] LoongArch: KVM: Add separate vmid support
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

Any update on this?

Huacai

On Wed, Nov 13, 2024 at 11:17=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> LoongArch KVM hypervisor supports two-level MMU, vpid index is used
> for stage1 MMU and vmid index is used for stage2 MMU.
>
> On 3A5000, vmid must be the same with vpid. On 3A6000 platform vmid
> may separate from vpid. There are such advantages if separate vpid
> is supported.
>   1. One VM uses one vmid, vCPUs on the same VM can share the same vmid.
>   2. If one vCPU switch between different physical CPU, old vmid can be
>      still usefil if old vmid is not expired
>   3. For remote tlb flush, only vmid need update and vpid need not
> update.
>
> Here add separate vmid feature support, vmid feature detecting method
> is not implemented since it depends on HW implementation, detecting
> method will be added when HW is ready.
>
> ---
> Bibo Mao (5):
>   LoongArch: KVM: Add vmid support for stage2 MMU
>   LoongArch: KVM: Add separate vmid feature support
>   LoongArch: KVM: implement vmid updating logic
>   LoongArch: KVM: Add remote tlb flushing support
>   LoongArch: KVM: Enable separate vmid feature
>
>  arch/loongarch/include/asm/kvm_host.h  | 10 ++++
>  arch/loongarch/include/asm/loongarch.h |  2 +
>  arch/loongarch/kernel/asm-offsets.c    |  1 +
>  arch/loongarch/kvm/main.c              | 76 ++++++++++++++++++++++++--
>  arch/loongarch/kvm/mmu.c               | 17 ++++++
>  arch/loongarch/kvm/switch.S            |  5 +-
>  arch/loongarch/kvm/tlb.c               | 19 ++++++-
>  arch/loongarch/kvm/vcpu.c              |  7 ++-
>  8 files changed, 128 insertions(+), 9 deletions(-)
>
>
> base-commit: 2d5404caa8c7bb5c4e0435f94b28834ae5456623
> --
> 2.39.3
>

