Return-Path: <kvm+bounces-9379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B92A585F677
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 12:05:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 441FA1F280EC
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 11:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5EB43FE27;
	Thu, 22 Feb 2024 11:05:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0E3B3FB1F
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 11:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708599919; cv=none; b=VIh/lrYyI0/m9Ab2khtxpUvYTC/RCyxYK66SENCCiDRq6gPMWoAcXCZVflLqE92++KxL9AmHarSHjamNNWskh6moYdCKhS9AVHlIzZXINoOTqhWB5n7dQ6SSun8F5BQkq1DEMG7WG3aseeWo91DO41e4WXurxkN290h99PZZl6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708599919; c=relaxed/simple;
	bh=72QgVDs8Um5+YNh56G+R8LuBKfWE88zXhffji+PjWA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lJIUztqOBUgjGgGmr9E3G18vb0QBIhZyHVkG0eFyr0IEC2Y7IzCEr0YhV0HC0vZB7YRHnIJaxs4Cq/G3YCA5ZBJeUHLUGNyEERginaHb+8NiUT9IClx/Mxd4v9mlFbfAHX3ZE29xMFOdLhXW1yt0AWGpD2OKjZE8OAKOVQzO9EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FC91DA7;
	Thu, 22 Feb 2024 03:05:54 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD73A3F73F;
	Thu, 22 Feb 2024 03:05:14 -0800 (PST)
Date: Thu, 22 Feb 2024 11:05:10 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 05/13] KVM: arm64: nv: Add trap forwarding for ERET and
 SMC
Message-ID: <20240222110510.GA945329@e124191.cambridge.arm.com>
References: <20240219092014.783809-1-maz@kernel.org>
 <20240219092014.783809-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219092014.783809-6-maz@kernel.org>

On Mon, Feb 19, 2024 at 09:20:06AM +0000, Marc Zyngier wrote:
> Honor the trap forwarding bits for both ERET and SMC, using a new
> helper that checks for common conditions.
> 
> Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

>  arch/arm64/include/asm/kvm_nested.h |  1 +
>  arch/arm64/kvm/emulate-nested.c     | 27 +++++++++++++++++++++++++++
>  arch/arm64/kvm/handle_exit.c        |  7 +++++++
>  3 files changed, 35 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index c77d795556e1..dbc4e3a67356 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -60,6 +60,7 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
>  	return ttbr0 & ~GENMASK_ULL(63, 48);
>  }
>  
> +extern bool forward_smc_trap(struct kvm_vcpu *vcpu);
>  
>  int kvm_init_nv_sysregs(struct kvm *kvm);
>  
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 4697ba41b3a9..2d80e81ae650 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2117,6 +2117,26 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
>  	return true;
>  }
>  
> +static bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
> +{
> +	bool control_bit_set;
> +
> +	if (!vcpu_has_nv(vcpu))
> +		return false;
> +
> +	control_bit_set = __vcpu_sys_reg(vcpu, HCR_EL2) & control_bit;
> +	if (!is_hyp_ctxt(vcpu) && control_bit_set) {
> +		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +		return true;
> +	}
> +	return false;
> +}
> +
> +bool forward_smc_trap(struct kvm_vcpu *vcpu)
> +{
> +	return forward_traps(vcpu, HCR_TSC);
> +}
> +
>  static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
>  {
>  	u64 mode = spsr & PSR_MODE_MASK;
> @@ -2155,6 +2175,13 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
>  	u64 spsr, elr, mode;
>  	bool direct_eret;
>  
> +	/*
> +	 * Forward this trap to the virtual EL2 if the virtual
> +	 * HCR_EL2.NV bit is set and this is coming from !EL2.
> +	 */
> +	if (forward_traps(vcpu, HCR_NV))
> +		return;
> +
>  	/*
>  	 * Going through the whole put/load motions is a waste of time
>  	 * if this is a VHE guest hypervisor returning to its own
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 0646c623d1da..1ccdfe40c691 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -55,6 +55,13 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
>  
>  static int handle_smc(struct kvm_vcpu *vcpu)
>  {
> +	/*
> +	 * Forward this trapped smc instruction to the virtual EL2 if
> +	 * the guest has asked for it.
> +	 */
> +	if (forward_smc_trap(vcpu))
> +		return 1;
> +
>  	/*
>  	 * "If an SMC instruction executed at Non-secure EL1 is
>  	 * trapped to EL2 because HCR_EL2.TSC is 1, the exception is a

Thanks,
Joey

