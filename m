Return-Path: <kvm+bounces-18661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EB558D84D2
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:22:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1DA29B23335
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8247412E1FF;
	Mon,  3 Jun 2024 14:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mH/bb9ig"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92D012E1DC;
	Mon,  3 Jun 2024 14:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717424545; cv=none; b=jsPTu8E9OiKroHudOpDJJrSmxBqefbKTAFdZezcfCM4YRbJAFL3+x9ODYh77CyJKRn5A2UnJmgJQEJC/pX2BJZubvJSlNo0QndqfRReFIWn/YGvjp/qtUO47YQ98NN5nXDHT2JvrgRQ3mN8qcXWDGOjr2owRl0xL+nH4NtJvQLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717424545; c=relaxed/simple;
	bh=rNTx7AsFjOKV7d+MKpBR6n2Udl3BibGEh30vSmw5BL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IiY6CbdOmohU2R3TzU+N7NJ9bIg99S2QeutE2TURchGn8SRozOFZ2kZ/J4GzKmXBTItfDPSdmmng9+N+jMOAftI4bkGcbzlD6pST6elxhjUDmc3WA8scu4eStP3x2SnPJ6jvZ6iJpgRPz9T4DCRQzWMVu0Ih0u2i3ENMxOsQUhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mH/bb9ig; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A85C2BD10;
	Mon,  3 Jun 2024 14:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717424545;
	bh=rNTx7AsFjOKV7d+MKpBR6n2Udl3BibGEh30vSmw5BL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mH/bb9igXinsiXKQwHP1kb+scyiVgWxfxQG1RbYcRvsH3E/Fwe/IRvxPqk9D9WbJk
	 NQIN0YFDZv/nSnEtscGAaDzAMSHN+cqKv1yqZz5PA3q5qZo+bxRjnAqP35Et1zQK+Z
	 XtfRVeXdotx9Hb6inshd2A3KtKr5sgrapzzaVtSr0OzM48NwCbsCltTahyed8ZKqYu
	 aTJeFS1gkalo/UKuxZWpN4GJa5Ba+/9gLiDOqOQ4ISL+vRgQpG92vyldov5oNOlyKV
	 k228ImzRGNu0PqT6NNq+L6stHm/4G/yRA7fOdW4GjOCfMU73Lxx8hSk2a8Nb2dMaFJ
	 sZy4kWDJ5h0Zg==
Date: Mon, 3 Jun 2024 15:22:20 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 02/13] KVM: arm64: Fix __pkvm_init_switch_pgd call ABI
Message-ID: <20240603142220.GC19151@willie-the-truck>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-3-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240529121251.1993135-3-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 29, 2024 at 01:12:08PM +0100, Pierre-Clément Tosi wrote:
> Fix the mismatch between the (incorrect) C signature, C call site, and
> asm implementation by aligning all three on an API passing the
> parameters (pgd and SP) separately, instead of as a bundled struct.
> 
> Remove the now unnecessary memory accesses while the MMU is off from the
> asm, which simplifies the C caller (as it does not need to convert a VA
> struct pointer to PA) and makes the code slightly more robust by
> offsetting the struct fields from C and properly expressing the call to
> the C compiler (e.g. type checker and kCFI).
> 
> Fixes: f320bc742bc2 ("KVM: arm64: Prepare the creation of s1 mappings at EL2")
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/include/asm/kvm_hyp.h   |  3 +--
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S | 17 +++++++++--------
>  arch/arm64/kvm/hyp/nvhe/setup.c    |  4 ++--
>  3 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 3e80464f8953..58b5a2b14d88 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -123,8 +123,7 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
>  #endif
>  
>  #ifdef __KVM_NVHE_HYPERVISOR__
> -void __pkvm_init_switch_pgd(phys_addr_t phys, unsigned long size,
> -			    phys_addr_t pgd, void *sp, void *cont_fn);
> +void __pkvm_init_switch_pgd(phys_addr_t pgd, void *sp, void (*fn)(void));
>  int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
>  		unsigned long *per_cpu_base, u32 hyp_va_bits);
>  void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> index 2994878d68ea..d859c4de06b6 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> @@ -265,33 +265,34 @@ alternative_else_nop_endif
>  
>  SYM_CODE_END(__kvm_handle_stub_hvc)
>  
> +/*
> + * void __pkvm_init_switch_pgd(phys_addr_t pgd, void *sp, void (*fn)(void));
> + */
>  SYM_FUNC_START(__pkvm_init_switch_pgd)
>  	/* Turn the MMU off */
>  	pre_disable_mmu_workaround
> -	mrs	x2, sctlr_el2
> -	bic	x3, x2, #SCTLR_ELx_M
> +	mrs	x9, sctlr_el2
> +	bic	x3, x9, #SCTLR_ELx_M

This is fine, but there's no need to jump all the way to x9 for the
register allocation. I think it would be neatest to re-jig the function
so it uses x4 here for the sctlr and then uses x5 later for the ttbr.

> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index 859f22f754d3..1cbd2c78f7a1 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -316,7 +316,7 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
>  {
>  	struct kvm_nvhe_init_params *params;
>  	void *virt = hyp_phys_to_virt(phys);
> -	void (*fn)(phys_addr_t params_pa, void *finalize_fn_va);
> +	typeof(__pkvm_init_switch_pgd) *fn;
>  	int ret;
>  
>  	BUG_ON(kvm_check_pvm_sysreg_table());
> @@ -340,7 +340,7 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
>  	/* Jump in the idmap page to switch to the new page-tables */
>  	params = this_cpu_ptr(&kvm_init_params);
>  	fn = (typeof(fn))__hyp_pa(__pkvm_init_switch_pgd);
> -	fn(__hyp_pa(params), __pkvm_init_finalise);
> +	fn(params->pgd_pa, (void *)params->stack_hyp_va, __pkvm_init_finalise);

Why not have the prototype of __pkvm_init_switch_pgd() take the SP as
an 'unsigned long' so that you can avoid this cast altogether?

Will

