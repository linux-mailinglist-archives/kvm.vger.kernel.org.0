Return-Path: <kvm+bounces-11311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27DC28752E2
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 16:15:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B6661C23249
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 15:15:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9F3012EBCC;
	Thu,  7 Mar 2024 15:15:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FCAD12DD99
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 15:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824505; cv=none; b=O3p/TciZQ8eBXQjUSc8YMNEZacOZaPnzl4xEthewouYaCON744osNLm3and3DNPpeSJFW7KyXTTI9K3ejDBSJBJO2cDW77Jnr4W24UN9c14ZvOg5HCwb8nTgch1uaJQar4T1WdRxqSQ5yvKtHINuHoNjDcaKqYRlwgzwIa0NCJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824505; c=relaxed/simple;
	bh=g20Xpc6OyJvxtAVwhdWMbolXe263sghDZOnUASUTrdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VZ6j+c7XhRJsiEkIFhAZxF87FabEnJARr/9zcPCGniJV9IleBEXtCWIkK+4QyJIEQ+4kZjFTniJuVVa0FfiX+oGBT7qj/eXDBjyLugMN4pkK7f8NspNe8UM4z7DtFnSRJW/Qan+Rt+jR8v3lLK+6Z1tZ5iuI5qqQHxUMzMQfY54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 736EB1FB;
	Thu,  7 Mar 2024 07:15:38 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB0243F73F;
	Thu,  7 Mar 2024 07:14:59 -0800 (PST)
Date: Thu, 7 Mar 2024 15:14:54 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 08/13] KVM: arm64: nv: Handle HCR_EL2.{API,APK}
 independently
Message-ID: <20240307151454.GA913041@e124191.cambridge.arm.com>
References: <20240226100601.2379693-1-maz@kernel.org>
 <20240226100601.2379693-9-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226100601.2379693-9-maz@kernel.org>

On Mon, Feb 26, 2024 at 10:05:56AM +0000, Marc Zyngier wrote:
> Although KVM couples API and APK for simplicity, the architecture
> makes no such requirement, and the two can be independently set or
> cleared.
> 
> Check for which of the two possible reasons we have trapped here,
> and if the corresponding L1 control bit isn't set, delegate the
> handling for forwarding.
> 
> Otherwise, set this exact bit in HCR_EL2 and resume the guest.
> Of course, in the non-NV case, we keep setting both bits and
> be done with it. Note that the entry core already saves/restores
> the keys should any of the two control bits be set.
> 
> This results in a bit of rework, and the removal of the (trivial)
> vcpu_ptrauth_enable() helper.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h    |  5 ----
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 32 +++++++++++++++++++++----
>  2 files changed, 27 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index debc3753d2ef..d2177bc77844 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -125,11 +125,6 @@ static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
>  	vcpu->arch.hcr_el2 |= HCR_TWI;
>  }
>  
> -static inline void vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
> -{
> -	vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
> -}
> -
>  static inline void vcpu_ptrauth_disable(struct kvm_vcpu *vcpu)
>  {
>  	vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index f5f701f309a9..a0908d7a8f56 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -480,11 +480,35 @@ DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
>  static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
>  	struct kvm_cpu_context *ctxt;
> -	u64 val;
> +	u64 enable = 0;
>  
>  	if (!vcpu_has_ptrauth(vcpu))
>  		return false;
>  
> +	/*
> +	 * NV requires us to handle API and APK independently, just in
> +	 * case the hypervisor is totally nuts. Please barf >here<.
> +	 */
> +	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
> +		switch (ESR_ELx_EC(kvm_vcpu_get_esr(vcpu))) {
> +		case ESR_ELx_EC_PAC:
> +			if (!(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_API))
> +				return false;
> +
> +			enable |= HCR_API;
> +			break;
> +
> +		case ESR_ELx_EC_SYS64:
> +			if (!(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_APK))
> +				return false;
> +
> +			enable |= HCR_APK;
> +			break;
> +		}
> +	} else {
> +		enable = HCR_API | HCR_APK;
> +	}
> +
>  	ctxt = this_cpu_ptr(&kvm_hyp_ctxt);
>  	__ptrauth_save_key(ctxt, APIA);
>  	__ptrauth_save_key(ctxt, APIB);
> @@ -492,11 +516,9 @@ static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	__ptrauth_save_key(ctxt, APDB);
>  	__ptrauth_save_key(ctxt, APGA);
>  
> -	vcpu_ptrauth_enable(vcpu);
>  
> -	val = read_sysreg(hcr_el2);
> -	val |= (HCR_API | HCR_APK);
> -	write_sysreg(val, hcr_el2);
> +	vcpu->arch.hcr_el2 |= enable;
> +	sysreg_clear_set(hcr_el2, 0, enable);
>  
>  	return true;
>  }

A bit of sleuthing tells me you plan to delete kvm_hyp_handle_ptrauth() anyway,
so presumably it makes some sense to put that patch before this to avoid
modifying the code just to delete it!

Thanks,
Joey

