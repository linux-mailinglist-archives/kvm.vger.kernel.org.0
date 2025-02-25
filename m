Return-Path: <kvm+bounces-39190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A883A44F53
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:56:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E05CE19C1501
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A468212D7B;
	Tue, 25 Feb 2025 21:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HVJ1aWd+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03DC198A32;
	Tue, 25 Feb 2025 21:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740520560; cv=none; b=u7Xgy10eLo7saNvKqBKtsCGCCyTpBxLGgmv0OBaA2FFxdjPiigo14b6bH3fJizNZP8XAseY06k/fZVLXzcyJjz0+CjydIHnSrqSPJ/WHWP4No+jRSbptilOvVF3CBTpVrujIsCxRYU0UztN45H2uZPG2XaSDkaPLIug9C1Nf7d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740520560; c=relaxed/simple;
	bh=DINa8jIv0eOK7RVTVe5/lWlYEoUGUUZx8qWN8FG+jw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FzTPeVhEcY02ht37I6ZnChftkka9iW/XFWXHS8rxR9XoFWZR4GVx3ok+h6VtMQbKOceRd2RSA/gmK6K/Zb3LTgN4wG1iXKWGdDEzPzVf5U5YMBT/ZBqoLbdG/Ym4NkeZ/+oAerQqdKq8ZkTpzcxoAV0jRhi22yZcoz9Ps0X+vyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HVJ1aWd+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62BDC4CEDD;
	Tue, 25 Feb 2025 21:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740520560;
	bh=DINa8jIv0eOK7RVTVe5/lWlYEoUGUUZx8qWN8FG+jw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HVJ1aWd+l0yDawmuh8u6agP/lCjrGmMbGNls7icWLdUjaM83gOBaR5shaFNOTb0vk
	 1iWxhmgIpm+nQJzVwnsAURJUYGBCSZJ+BSKlUC0geR8XtWTjy3CoaPMw9mR0ejAJor
	 3BdDqRqX1FqRGVOVmPUAMIxa+IszZey/Qt5Hch340kypQzCHZIky/1vAhS7MYfxA6c
	 gjk8NgRYuGjCwBfcNU22hcx3IjYAtlOGN1bnEec+2rCB3jczJP0+1C1MLfJR5ypFTx
	 gRCNVqnVNTVqoyq5XnNC3QV3DuEFBQxS1V3OnSvODPffWP6PKzHix7PMQQR1MMY6XJ
	 Pdb5m8KDUTglw==
Date: Tue, 25 Feb 2025 22:55:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jinyu Tang <tjytimi@163.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
	Will Deacon <will@kernel.org>, Anup Patel <apatel@ventanamicro.com>,
	Julien Thierry <julien.thierry.kdev@gmail.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] x86: avoid one cpu limit for kvm
Message-ID: <Z748ZaNc9IclOUPi@gmail.com>
References: <20241224130952.112584-1-tjytimi@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241224130952.112584-1-tjytimi@163.com>


* Jinyu Tang <tjytimi@163.com> wrote:

> I run kernel by kvmtool but only one cpu can start in guset now, 
> because kvm use virt-ioapic and kvmtool set noapic cmdline for 
> x86 to disable ioapic route in kernel, and the latest cpu topo 
> code below makes cpu limitted just to one.
> 
> For x86 kvm, noapic cmdline is reasonable, virt-ioapic don't
> need to init hardware ioapic, so change it for x86 kvm guest to
> avoid one num limit.
> 
> Signed-off-by: Jinyu Tang <tjytimi@163.com>
> ---
>  arch/x86/kernel/cpu/topology.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
> index 621a151ccf7d..a73847b1a841 100644
> --- a/arch/x86/kernel/cpu/topology.c
> +++ b/arch/x86/kernel/cpu/topology.c
> @@ -429,7 +429,9 @@ void __init topology_apply_cmdline_limits_early(void)
>  	unsigned int possible = nr_cpu_ids;
>  
>  	/* 'maxcpus=0' 'nosmp' 'nolapic' 'disableapic' 'noapic' */
> -	if (!setup_max_cpus || ioapic_is_disabled || apic_is_disabled)
> +	if (!setup_max_cpus ||
> +		(ioapic_is_disabled && (x86_hyper_type != X86_HYPER_KVM)) ||
> +		apic_is_disabled)
>  		possible = 1;
>  
>  	/* 'possible_cpus=N' */
> @@ -443,8 +445,10 @@ void __init topology_apply_cmdline_limits_early(void)
>  
>  static __init bool restrict_to_up(void)
>  {
> -	if (!smp_found_config || ioapic_is_disabled)
> +	if (!smp_found_config ||
> +		(ioapic_is_disabled && (x86_hyper_type != X86_HYPER_KVM)))
>  		return true;
> +
>  	/*
>  	 * XEN PV is special as it does not advertise the local APIC
>  	 * properly, but provides a fake topology for it so that the

Just to confirm that this bug got fixed, current kvmtool boots fine 
with multiple CPUs, correct?

Thanks,

	Ingo

