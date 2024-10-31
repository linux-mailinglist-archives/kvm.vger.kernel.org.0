Return-Path: <kvm+bounces-30238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 87F459B83DA
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:57:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FEEB1F22941
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 19:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FF701CCEF8;
	Thu, 31 Oct 2024 19:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h0t050Bk"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED17F1CBEA2
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 19:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404607; cv=none; b=aiQ5nD7LhpEqNtxx41rFZKqaU3woUgWPs3hfJM9WPusoY4pCnu2itLsx9XIrDFjVmRymKd+Y4wKJDdMSIovOp25F4jPvvjK/2R3nxgKPF/vrmSjzw6LgYB+TvPd7qO5z6OdINSX/HF88s2lb691r8ySoudCl4DDfnYnsjWFhZfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404607; c=relaxed/simple;
	bh=n42bIm0EJKSGiSdPBDn9xkTrd4XZQCY/ki0lBaAt+Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PB43wt9ML/fZtmdHeG6sknHRoo58raP7JKnwXPpdGzXa1+8gx3eNvtCqf7p3nlXi7pGC8EsFvJsuK6flP7QqG+c+MMBSTeLWGhc1FEyZnz7gtjBK++q6pKumXcZGsaPswrRFtEhke3q4OccoRx8xON2hxZ8Dbv+b1dN/x1D2zhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h0t050Bk; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730404601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ETPLCcFOzsbm2EUKzHQHpjrgkvcCKJmMREUbmAxMcBE=;
	b=h0t050BkX3ihCZkm0W74a9hiZ/GkSTBi0EHcfzhpLzK/YJ1qkNFIaHnidJggXPZ2y98CAz
	+QQQDV/z0K/cRFxB7iB9bC6zDRytorf1X/deRUGQClrGZKcG0MYC3n8M5EgSFI74RzFDRA
	pJ2n8dZlCe24+bCRU88+I4G0KVC9jJs=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	stable@vger.kernel.org,
	kvm@vger.kernel.org,
	syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH v2] KVM: arm64: Get rid of userspace_irqchip_in_use
Date: Thu, 31 Oct 2024 19:56:28 +0000
Message-ID: <173040458509.3411583.4399376120814266828.b4-ty@linux.dev>
In-Reply-To: <20241028234533.942542-1-rananta@google.com>
References: <20241028234533.942542-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 28 Oct 2024 23:45:33 +0000, Raghavendra Rao Ananta wrote:
> Improper use of userspace_irqchip_in_use led to syzbot hitting the
> following WARN_ON() in kvm_timer_update_irq():
> 
> WARNING: CPU: 0 PID: 3281 at arch/arm64/kvm/arch_timer.c:459
> kvm_timer_update_irq+0x21c/0x394
> Call trace:
>   kvm_timer_update_irq+0x21c/0x394 arch/arm64/kvm/arch_timer.c:459
>   kvm_timer_vcpu_reset+0x158/0x684 arch/arm64/kvm/arch_timer.c:968
>   kvm_reset_vcpu+0x3b4/0x560 arch/arm64/kvm/reset.c:264
>   kvm_vcpu_set_target arch/arm64/kvm/arm.c:1553 [inline]
>   kvm_arch_vcpu_ioctl_vcpu_init arch/arm64/kvm/arm.c:1573 [inline]
>   kvm_arch_vcpu_ioctl+0x112c/0x1b3c arch/arm64/kvm/arm.c:1695
>   kvm_vcpu_ioctl+0x4ec/0xf74 virt/kvm/kvm_main.c:4658
>   vfs_ioctl fs/ioctl.c:51 [inline]
>   __do_sys_ioctl fs/ioctl.c:907 [inline]
>   __se_sys_ioctl fs/ioctl.c:893 [inline]
>   __arm64_sys_ioctl+0x108/0x184 fs/ioctl.c:893
>   __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>   invoke_syscall+0x78/0x1b8 arch/arm64/kernel/syscall.c:49
>   el0_svc_common+0xe8/0x1b0 arch/arm64/kernel/syscall.c:132
>   do_el0_svc+0x40/0x50 arch/arm64/kernel/syscall.c:151
>   el0_svc+0x54/0x14c arch/arm64/kernel/entry-common.c:712
>   el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
>   el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Get rid of userspace_irqchip_in_use
      https://git.kernel.org/kvmarm/kvmarm/c/e571ebcff926

--
Best,
Oliver

