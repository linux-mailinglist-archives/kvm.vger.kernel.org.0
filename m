Return-Path: <kvm+bounces-37862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DAF8BA30BB9
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 13:28:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CFAB3A9EF6
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 805871FDA9C;
	Tue, 11 Feb 2025 12:28:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8339F1FCF74
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 12:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739276898; cv=none; b=Xj9IhcOru669Pq+7bUqe4WHQOCqLn8gsGy+OcqjWvZlkX7qVOq99qs4xt9E4W3PRzHJ//p9PPAao6k8kMU/p1sqgN5KqFnHPAk3DByj0oA3ZKjVKK5WdY2EwdTEqtFe+yH3LZU/r3PbvL276C25pUBjODEQoSXYHXL12+zlX/0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739276898; c=relaxed/simple;
	bh=VWxGrKd9euXe3CxkVH/GuHBJNtg598pQJqgJ9JAc39M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=di8yzDZBqioqajj3E2Q7HhvFDU9VX88vOqskpBGxhVJFUqpepgljJaleiHS5p3c7lVlgtscQHYbLvHRCAmFj60cWcJkLfRfBndkiIns69c2dy/eYJJcG6ZTXMS7pEDZILUHyyB70ZnrXEEyaxhNv14VqVI9TjPTuONO0zPOU9wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B4B11424;
	Tue, 11 Feb 2025 04:28:36 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4EB3A3F6A8;
	Tue, 11 Feb 2025 04:28:13 -0800 (PST)
Date: Tue, 11 Feb 2025 12:28:10 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 03/18] KVM: arm64: Handle trapping of FEAT_LS64*
 instructions
Message-ID: <Z6tCWmsZxQZw4nmR@J2N7QTR9R3>
References: <20250210184150.2145093-1-maz@kernel.org>
 <20250210184150.2145093-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210184150.2145093-4-maz@kernel.org>

On Mon, Feb 10, 2025 at 06:41:34PM +0000, Marc Zyngier wrote:
> We generally don't expect FEAT_LS64* instructions to trap, unless
> they are trapped by a guest hypervisor.
> 
> Otherwise, this is just the guest playing tricks on us by using
> an instruction that isn't advertised, which we handle with a well
> deserved UNDEF.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/handle_exit.c | 64 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 512d152233ff2..4f8354bf7dc5f 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -294,6 +294,69 @@ static int handle_svc(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +static int handle_ls64b(struct kvm_vcpu *vcpu)

Structurally this looks good. As noted on patch 2, I think that
naming-wise this should be more general, e.g. handle_other_insn().

Mark.

> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	u64 esr = kvm_vcpu_get_esr(vcpu);
> +	u64 iss = ESR_ELx_ISS(esr);
> +	bool allowed;
> +
> +	switch (iss) {
> +	case ESR_ELx_ISS_ST64BV:
> +		allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V);
> +		break;
> +	case ESR_ELx_ISS_ST64BV0:
> +		allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA);
> +		break;
> +	case ESR_ELx_ISS_LDST64B:
> +		allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64);
> +		break;
> +	default:
> +		/* Clearly, we're missing something. */
> +		goto unknown_trap;
> +	}
> +
> +	if (!allowed)
> +		goto undef;
> +
> +	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
> +		u64 hcrx = __vcpu_sys_reg(vcpu, HCRX_EL2);
> +		bool fwd;
> +
> +		switch (iss) {
> +		case ESR_ELx_ISS_ST64BV:
> +			fwd = !(hcrx & HCRX_EL2_EnASR);
> +			break;
> +		case ESR_ELx_ISS_ST64BV0:
> +			fwd = !(hcrx & HCRX_EL2_EnAS0);
> +			break;
> +		case ESR_ELx_ISS_LDST64B:
> +			fwd = !(hcrx & HCRX_EL2_EnALS);
> +			break;
> +		default:
> +			/* We don't expect to be here */
> +			fwd = false;
> +		}
> +
> +		if (fwd) {
> +			kvm_inject_nested_sync(vcpu, esr);
> +			return 1;
> +		}
> +	}
> +
> +unknown_trap:
> +	/*
> +	 * If we land here, something must be very wrong, because we
> +	 * have no idea why we trapped at all. Warn and undef as a
> +	 * fallback.
> +	 */
> +	WARN_ON(1);
> +
> +undef:
> +	kvm_inject_undefined(vcpu);
> +	return 1;
> +}
> +
>  static exit_handle_fn arm_exit_handlers[] = {
>  	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
>  	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
> @@ -303,6 +366,7 @@ static exit_handle_fn arm_exit_handlers[] = {
>  	[ESR_ELx_EC_CP14_LS]	= kvm_handle_cp14_load_store,
>  	[ESR_ELx_EC_CP10_ID]	= kvm_handle_cp10_id,
>  	[ESR_ELx_EC_CP14_64]	= kvm_handle_cp14_64,
> +	[ESR_ELx_EC_LS64B]	= handle_ls64b,
>  	[ESR_ELx_EC_HVC32]	= handle_hvc,
>  	[ESR_ELx_EC_SMC32]	= handle_smc,
>  	[ESR_ELx_EC_HVC64]	= handle_hvc,
> -- 
> 2.39.2
> 

