Return-Path: <kvm+bounces-11656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C4C8792D0
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 12:17:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AB7F284CAF
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 11:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 180FE79B75;
	Tue, 12 Mar 2024 11:17:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A07817993D
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 11:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710242271; cv=none; b=lo7Zn/H4cWAv6e7hFlgHASgFX1CQsSGABYF7IxqhECUcozXrVSh1WAHbkunJ3Bpxp3Ri8nsXt0KJ04SWfB+Fkys+5EnJJRQin7CrTTZFlmFMYb4cvnVx/ty6CJt44Um1lnKW//Vr9UtHdyzI7xwT1Ifq3Y23n0CPHFaFibywGKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710242271; c=relaxed/simple;
	bh=m5rgtW1UM30ykYf+ugPgEXgV7jBy/L9CHYiImNcdCW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OxmKNr4lfoZR5bNtphdH6lNBxneMx90LR8e1RLBMOGBrUVbA9rBzEsfFIcTe39IHx70ptCjImZ/KOUZTTN7yBht32rE7LZq4hGct9bIuwZK7zqgVu5pqiX5HhwIMVPvapGkmKKHABgvDnpPixX9WTzqhX2EySIQwtwhnJauvljs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32C6B1007;
	Tue, 12 Mar 2024 04:18:26 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C76F3F762;
	Tue, 12 Mar 2024 04:17:47 -0700 (PDT)
Date: Tue, 12 Mar 2024 11:17:42 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 12/13] KVM: arm64: nv: Handle ERETA[AB] instructions
Message-ID: <20240312111742.GA1635791@e124191.cambridge.arm.com>
References: <20240226100601.2379693-1-maz@kernel.org>
 <20240226100601.2379693-13-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226100601.2379693-13-maz@kernel.org>

On Mon, Feb 26, 2024 at 10:06:00AM +0000, Marc Zyngier wrote:
> Now that we have some emulation in place for ERETA[AB], we can
> plug it into the exception handling machinery.
> 
> As for a bare ERET, an "easy" ERETAx instruction is processed as
> a fixup, while something that requires a translation regime
> transition or an exception delivery is left to the slow path.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 22 ++++++++++++++++++++--
>  arch/arm64/kvm/handle_exit.c    |  3 ++-
>  arch/arm64/kvm/hyp/vhe/switch.c | 13 +++++++++++--
>  3 files changed, 33 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 63a74c0330f1..72d733c74a38 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2172,7 +2172,7 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
>  
>  void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
>  {
> -	u64 spsr, elr;
> +	u64 spsr, elr, esr;
>  
>  	/*
>  	 * Forward this trap to the virtual EL2 if the virtual
> @@ -2181,12 +2181,30 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
>  	if (forward_traps(vcpu, HCR_NV))
>  		return;
>  
> +	/* Check for an ERETAx */
> +	esr = kvm_vcpu_get_esr(vcpu);
> +	if (esr_iss_is_eretax(esr) && !kvm_auth_eretax(vcpu, &elr)) {
> +		/*
> +		 * Oh no, ERETAx failed to authenticate.  If we have
> +		 * FPACCOMBINE, deliver an exception right away.  If we
> +		 * don't, then let the mangled ELR value trickle down the
> +		 * ERET handling, and the guest will have a little surprise.
> +		 */
> +		if (kvm_has_pauth(vcpu->kvm, FPACCOMBINE)) {
> +			esr &= ESR_ELx_ERET_ISS_ERETA;
> +			esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_FPAC);
> +			kvm_inject_nested_sync(vcpu, esr);
> +			return;
> +		}
> +	}
> +
>  	preempt_disable();
>  	kvm_arch_vcpu_put(vcpu);
>  
>  	spsr = __vcpu_sys_reg(vcpu, SPSR_EL2);
>  	spsr = kvm_check_illegal_exception_return(vcpu, spsr);
> -	elr = __vcpu_sys_reg(vcpu, ELR_EL2);
> +	if (!esr_iss_is_eretax(esr))
> +		elr = __vcpu_sys_reg(vcpu, ELR_EL2);
>  
>  	trace_kvm_nested_eret(vcpu, elr, spsr);
>  
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 1ba2f788b2c3..407bdfbb572b 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -248,7 +248,8 @@ static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
>  
>  static int kvm_handle_eret(struct kvm_vcpu *vcpu)
>  {
> -	if (esr_iss_is_eretax(kvm_vcpu_get_esr(vcpu)))
> +	if (esr_iss_is_eretax(kvm_vcpu_get_esr(vcpu)) &&
> +	    !vcpu_has_ptrauth(vcpu))
>  		return kvm_handle_ptrauth(vcpu);
>  
>  	/*
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 3ea9bdf6b555..49d36666040e 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -208,7 +208,8 @@ void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
>  
>  static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
> -	u64 spsr, mode;
> +	u64 esr = kvm_vcpu_get_esr(vcpu);
> +	u64 spsr, elr, mode;
>  
>  	/*
>  	 * Going through the whole put/load motions is a waste of time
> @@ -242,10 +243,18 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
>  		return false;
>  	}
>  
> +	/* If ERETAx fails, take the slow path */
> +	if (esr_iss_is_eretax(esr)) {
> +		if (!(vcpu_has_ptrauth(vcpu) && kvm_auth_eretax(vcpu, &elr)))
> +			return false;
> +	} else {
> +		elr = read_sysreg_el1(SYS_ELR);
> +	}
> +
>  	spsr = (spsr & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
>  
>  	write_sysreg_el2(spsr, SYS_SPSR);
> -	write_sysreg_el2(read_sysreg_el1(SYS_ELR), SYS_ELR);
> +	write_sysreg_el2(elr, SYS_ELR);
>  
>  	return true;
>  }
> 

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

