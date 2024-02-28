Return-Path: <kvm+bounces-10284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F45D86B42F
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 17:08:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9A3E1F2C058
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 16:08:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A78315D5D3;
	Wed, 28 Feb 2024 16:08:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D579F15D5AE
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 16:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709136490; cv=none; b=YNJth18bsdM6jDf0711I00zPhQ4+463j5Kz/GYRX1GADv6esnZLv8kAhcdAc5sOcL8UNZnpEN1VgK74ZhQdlGX5tbYWpitClhzVoJe3RFj8Laz7TRN/A4bz4dBVBCCy5Q0tMCxT3xqN8PKpELKrRue9I7/94GojLnklgEfwssj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709136490; c=relaxed/simple;
	bh=Ici6SGl/O6VfHPgTIKijM8kxjG1VHFI+ROt9a9T32Fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M3rCeeO8MEERL6e7VWO28b5AT/XaD3tB/RTMtBMJHtoA8IbrHIIvTRkqMi9lLcKTp9Y1GjY3IE4FgPNHkskeOuwwHKfoAVo2reAJiYTiFG84i5bvVpjZMjr6Gw0CJKRESUQANCcqGcFvl07KOiav3jG/YJb9QTQhkgaubcZl60M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39FA9C15;
	Wed, 28 Feb 2024 08:08:45 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E57F63F762;
	Wed, 28 Feb 2024 08:08:04 -0800 (PST)
Date: Wed, 28 Feb 2024 16:08:00 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: nv: Fast-track 'InHost' exception
 returns
Message-ID: <20240228160800.GA3373815@e124191.cambridge.arm.com>
References: <20240226100601.2379693-1-maz@kernel.org>
 <20240226100601.2379693-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226100601.2379693-7-maz@kernel.org>

On Mon, Feb 26, 2024 at 10:05:54AM +0000, Marc Zyngier wrote:
> A significant part of the FEAT_NV extension is to trap ERET
> instructions so that the hypervisor gets a chance to switch
> from a vEL2 L1 guest to an EL1 L2 guest.
> 
> But this also has the unfortunate consequence of trapping ERET
> in unsuspecting circumstances, such as staying at vEL2 (interrupt
> handling while being in the guest hypervisor), or returning to host
> userspace in the case of a VHE guest.
> 
> Although we already make some effort to handle these ERET quicker
> by not doing the put/load dance, it is still way too far down the
> line for it to be efficient enough.
> 
> For these cases, it would ideal to ERET directly, no question asked.
> Of course, we can't do that. But the next best thing is to do it as
> early as possible, in fixup_guest_exit(), much as we would handle
> FPSIMD exceptions.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 29 +++-------------------
>  arch/arm64/kvm/hyp/vhe/switch.c | 44 +++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 2d80e81ae650..63a74c0330f1 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2172,8 +2172,7 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
>  
>  void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
>  {
> -	u64 spsr, elr, mode;
> -	bool direct_eret;
> +	u64 spsr, elr;
>  
>  	/*
>  	 * Forward this trap to the virtual EL2 if the virtual
> @@ -2182,33 +2181,11 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
>  	if (forward_traps(vcpu, HCR_NV))
>  		return;
>  
> -	/*
> -	 * Going through the whole put/load motions is a waste of time
> -	 * if this is a VHE guest hypervisor returning to its own
> -	 * userspace, or the hypervisor performing a local exception
> -	 * return. No need to save/restore registers, no need to
> -	 * switch S2 MMU. Just do the canonical ERET.
> -	 */
> -	spsr = vcpu_read_sys_reg(vcpu, SPSR_EL2);
> -	spsr = kvm_check_illegal_exception_return(vcpu, spsr);
> -
> -	mode = spsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
> -
> -	direct_eret  = (mode == PSR_MODE_EL0t &&
> -			vcpu_el2_e2h_is_set(vcpu) &&
> -			vcpu_el2_tge_is_set(vcpu));
> -	direct_eret |= (mode == PSR_MODE_EL2h || mode == PSR_MODE_EL2t);
> -
> -	if (direct_eret) {
> -		*vcpu_pc(vcpu) = vcpu_read_sys_reg(vcpu, ELR_EL2);
> -		*vcpu_cpsr(vcpu) = spsr;
> -		trace_kvm_nested_eret(vcpu, *vcpu_pc(vcpu), spsr);
> -		return;
> -	}
> -
>  	preempt_disable();
>  	kvm_arch_vcpu_put(vcpu);
>  
> +	spsr = __vcpu_sys_reg(vcpu, SPSR_EL2);
> +	spsr = kvm_check_illegal_exception_return(vcpu, spsr);
>  	elr = __vcpu_sys_reg(vcpu, ELR_EL2);
>  
>  	trace_kvm_nested_eret(vcpu, elr, spsr);
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index d5fdcea2b366..eaf242b8e0cf 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -206,6 +206,49 @@ void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
>  	__vcpu_put_switch_sysregs(vcpu);
>  }
>  
> +static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
> +{
> +	u64 spsr, mode;
> +
> +	/*
> +	 * Going through the whole put/load motions is a waste of time
> +	 * if this is a VHE guest hypervisor returning to its own
> +	 * userspace, or the hypervisor performing a local exception
> +	 * return. No need to save/restore registers, no need to
> +	 * switch S2 MMU. Just do the canonical ERET.
> +	 *
> +	 * Unless the trap has to be forwarded further down the line,
> +	 * of course...
> +	 */
> +	if (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV)
> +		return false;
> +
> +	spsr = read_sysreg_el1(SYS_SPSR);
> +	mode = spsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
> +
> +	switch (mode) {
> +	case PSR_MODE_EL0t:
> +		if (!(vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)))
> +			return false;
> +		break;
> +	case PSR_MODE_EL2t:
> +		mode = PSR_MODE_EL1t;
> +		break;
> +	case PSR_MODE_EL2h:
> +		mode = PSR_MODE_EL1h;
> +		break;
> +	default:
> +		return false;
> +	}

Thanks for pointing out to_hw_pstate() (off-list), I spent far too long trying
to understand how the original code converted PSTATE.M from (v)EL2 to EL1, and
missed that while browsing.

Seems hard to re-use to_hw_pstate() here, since we want the early returns.

> +
> +	spsr = (spsr & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;

I don't think we need to mask out PSR_MODE32_BIT here again, since if it was
set in `mode`, it wouldn't have matched in the switch statement. It's possibly
out of 'defensiveness' though. And I'm being nitpicky.

> +
> +	write_sysreg_el2(spsr, SYS_SPSR);
> +	write_sysreg_el2(read_sysreg_el1(SYS_ELR), SYS_ELR);
> +
> +	return true;
> +}
> +
>  static const exit_handler_fn hyp_exit_handlers[] = {
>  	[0 ... ESR_ELx_EC_MAX]		= NULL,
>  	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
> @@ -216,6 +259,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
>  	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
>  	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_hyp_handle_watchpt_low,
>  	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
> +	[ESR_ELx_EC_ERET]		= kvm_hyp_handle_eret,
>  	[ESR_ELx_EC_MOPS]		= kvm_hyp_handle_mops,
>  };
>  

Otherwise,

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

