Return-Path: <kvm+bounces-17322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 421118C430A
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 16:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBF701F21B33
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 14:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53BA4153BC1;
	Mon, 13 May 2024 14:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q2zssrFC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A31C153835;
	Mon, 13 May 2024 14:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715609847; cv=none; b=REwAmx4S+8au3M+UcaiBlYMCq9VHldS3Td2r7f9V7Ss70w1MnjcqzVrNNVJuEAwvKYaUeGrbXzqeblvHxHLCPJa3UIGDLew4m7UIsHQhe/GKoJd4faL+BgzNvge2dbsCWwRNooxmPPfvm7NSrFVxDPDRiEJMPljl8Ed8/kvappY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715609847; c=relaxed/simple;
	bh=T5fem1/X0SKYUnwohi4fsRk8kuO5KdWTrb8pWSTa7IY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TSvkAkrGVfzYzjJedoZzyefsNuQIAHZZv0dE7NO1B9ozn4QUnPQXPhtGyOnAf6i3cSz2FXzG0Rp64DYFTgKKdMTzLWFDzQI9/+6YccM8HTyFK/q3B0mNczcvOAvlWi0WGRPgXiaBbgcFV7NBwVBjQJlkWbk+62XU/KVAiefjx3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q2zssrFC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE98C4AF12;
	Mon, 13 May 2024 14:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715609847;
	bh=T5fem1/X0SKYUnwohi4fsRk8kuO5KdWTrb8pWSTa7IY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q2zssrFCNxQaY4ajMUrIS+DzXEyx5EEIs7lefs4SgOR0d9v9xsDFa5SRNn5jmxKh1
	 3dn+4kp6gsUQHXxiG1nm/GGeNUWHGLrvs31YPCCyfxa5nmEiXHxFZ/P/Ch9D0PKNKT
	 096OiL1d0B0vpkFMXvRnsav019G9EUcJes13G5xsJr11HKHmxMYeDQ5V9aT6R9vJpk
	 1ZS2V0wGrsD/agW5VmLaa8Qwxakr5ZAQTdbmDtr3sAJOQHfI1Jx00V6zSpmgWC534z
	 uz04u0OqGSnbHKt+6pDwlsXE7nsUQAeOBwAgrXidrbo33Cd9jPsP0/wIbRzQINhYSf
	 SPSTOz+HAbOPA==
Date: Mon, 13 May 2024 15:17:22 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v3 03/12] KVM: arm64: Pass pointer to
 __pkvm_init_switch_pgd
Message-ID: <20240513141721.GC28749@willie-the-truck>
References: <20240510112645.3625702-1-ptosi@google.com>
 <20240510112645.3625702-4-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240510112645.3625702-4-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 10, 2024 at 12:26:32PM +0100, Pierre-Clément Tosi wrote:
> Make the function take a VA pointer, instead of a phys_addr_t, to fully
> take advantage of the high-level C language and its type checker.
> 
> Perform all accesses to the kvm_nvhe_init_params before disabling the
> MMU, removing the need to access it using physical addresses, which was
> the reason for taking a phys_addr_t.
> 
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/include/asm/kvm_hyp.h   |  3 ++-
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S | 12 +++++++++---
>  arch/arm64/kvm/hyp/nvhe/setup.c    |  4 +---
>  3 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 96daf7cf6802..c195e71d0746 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -123,7 +123,8 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
>  #endif
>  
>  #ifdef __KVM_NVHE_HYPERVISOR__
> -void __pkvm_init_switch_pgd(phys_addr_t params, void (*finalize_fn)(void));
> +void __pkvm_init_switch_pgd(struct kvm_nvhe_init_params *params,
> +			    void (*finalize_fn)(void));
>  int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
>  		unsigned long *per_cpu_base, u32 hyp_va_bits);
>  void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> index 2994878d68ea..5a15737b4233 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> @@ -265,7 +265,15 @@ alternative_else_nop_endif
>  
>  SYM_CODE_END(__kvm_handle_stub_hvc)
>  
> +/*
> + * void __pkvm_init_switch_pgd(struct kvm_nvhe_init_params *params,
> + *                             void (*finalize_fn)(void));
> + */
>  SYM_FUNC_START(__pkvm_init_switch_pgd)
> +	/* Load the inputs from the VA pointer before turning the MMU off */
> +	ldr	x5, [x0, #NVHE_INIT_PGD_PA]
> +	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
> +
>  	/* Turn the MMU off */
>  	pre_disable_mmu_workaround
>  	mrs	x2, sctlr_el2
> @@ -276,15 +284,13 @@ SYM_FUNC_START(__pkvm_init_switch_pgd)
>  	tlbi	alle2
>  
>  	/* Install the new pgtables */
> -	ldr	x3, [x0, #NVHE_INIT_PGD_PA]
> -	phys_to_ttbr x4, x3
> +	phys_to_ttbr x4, x5
>  alternative_if ARM64_HAS_CNP
>  	orr	x4, x4, #TTBR_CNP_BIT
>  alternative_else_nop_endif
>  	msr	ttbr0_el2, x4
>  
>  	/* Set the new stack pointer */
> -	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
>  	mov	sp, x0
>  
>  	/* And turn the MMU back on! */

Hmm, if we can hoist the memory accesses all the way like this, then
couldn't we just move them into the caller's C code? Maybe that's what
we planned to do in the first place, which would explain why the
prototype of __pkvm_init_switch_pgd() is out-of-sync.

In other words, drop the previous patch and pass in the pgd and SP as
arguments to the asm.

Will

