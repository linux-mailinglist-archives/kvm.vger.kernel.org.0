Return-Path: <kvm+bounces-21312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CFD1992D4BE
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 17:13:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 895E62846BB
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 15:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05773194135;
	Wed, 10 Jul 2024 15:13:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FD7818787A
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 15:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720624381; cv=none; b=LcMRNIfCHgyUfBonk2cP8wycbXZfvIlXsoBGY3LvIivkYu3/1wPw4pS+3wdfJJj6fxFpqBVY36yRNzMlmzSAuK3xnNgcSHSOaSE2wy+Op5NVtVxuSMl5tQuDMFgNHft1rBV1cGnCGEvsltgV9/ITkBP9TdpdkXad6Zau9y0Pa18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720624381; c=relaxed/simple;
	bh=fbtXpYWT3DD93tvLAiRCge13CGuKYNj5IQxCFo4nYtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FdfNQyWh7y31HA9DO21vcda6OQwX/xnUVljdpmutUeuFQJH/7SFFeFp8xYfe/yhtvS5xXn72XTxTqhDKIPVwY3nyw1L5N0dKW6tcJH9yDeDpeC4PxqTschORT2tzcuTFjcLgBuyGT3Ke58oJOWh8WxQjQVeJIlLWf+NsPz5oWq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C15AA106F;
	Wed, 10 Jul 2024 08:13:22 -0700 (PDT)
Received: from arm.com (e121798.manchester.arm.com [10.32.101.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F0763F766;
	Wed, 10 Jul 2024 08:12:56 -0700 (PDT)
Date: Wed, 10 Jul 2024 16:12:53 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 10/12] KVM: arm64: nv: Add SW walker for AT S1 emulation
Message-ID: <Zo6k9WkuXFGLAQFv@arm.com>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240708165800.1220065-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240708165800.1220065-1-maz@kernel.org>

Hi Marc,

On Mon, Jul 08, 2024 at 05:57:58PM +0100, Marc Zyngier wrote:
> In order to plug the brokenness of our current AT implementation,
> we need a SW walker that is going to... err.. walk the S1 tables
> and tell us what it finds.
> 
> Of course, it builds on top of our S2 walker, and share similar
> concepts. The beauty of it is that since it uses kvm_read_guest(),
> it is able to bring back pages that have been otherwise evicted.
> 
> This is then plugged in the two AT S1 emulation functions as
> a "slow path" fallback. I'm not sure it is that slow, but hey.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> [..]
> @@ -331,18 +801,17 @@ void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  	}
>  
>  	if (!fail)
> -		par = read_sysreg(par_el1);
> +		par = read_sysreg_par();
>  	else
>  		par = SYS_PAR_EL1_F;
>  
> +	retry_slow = !fail;
> +
>  	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
>  
>  	/*
> -	 * Failed? let's leave the building now.
> -	 *
> -	 * FIXME: how about a failed translation because the shadow S2
> -	 * wasn't populated? We may need to perform a SW PTW,
> -	 * populating our shadow S2 and retry the instruction.
> +	 * Failed? let's leave the building now, unless we retry on
> +	 * the slow path.
>  	 */
>  	if (par & SYS_PAR_EL1_F)
>  		goto nopan;

This is what follows after the 'if' statement above, and before the 'switch'
below:

        /* No PAN? No problem. */
        if (!(*vcpu_cpsr(vcpu) & PSR_PAN_BIT))
                goto nopan;

When KVM is executing this statement, the following is true:

1. SYS_PAR_EL1_F is clear => the hardware translation table walk was successful.
2. retry_slow = true;

Then if the PAN bit is not set, the function jumps to the nopan label, and
performs a software translation table walk, even though the hardware walk
performed by AT was successful.

> @@ -354,29 +823,58 @@ void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  	switch (op) {
>  	case OP_AT_S1E1RP:
>  	case OP_AT_S1E1WP:
> +		retry_slow = false;
>  		fail = check_at_pan(vcpu, vaddr, &par);
>  		break;
>  	default:
>  		goto nopan;
>  	}
>  
> +	if (fail) {
> +		vcpu_write_sys_reg(vcpu, SYS_PAR_EL1_F, PAR_EL1);
> +		goto nopan;
> +	}
> +
>  	/*
>  	 * If the EL0 translation has succeeded, we need to pretend
>  	 * the AT operation has failed, as the PAN setting forbids
>  	 * such a translation.
> -	 *
> -	 * FIXME: we hardcode a Level-3 permission fault. We really
> -	 * should return the real fault level.
>  	 */
> -	if (fail || !(par & SYS_PAR_EL1_F))
> -		vcpu_write_sys_reg(vcpu, (0xf << 1) | SYS_PAR_EL1_F, PAR_EL1);
> -
> +	if (par & SYS_PAR_EL1_F) {
> +		u8 fst = FIELD_GET(SYS_PAR_EL1_FST, par);
> +
> +		/*
> +		 * If we get something other than a permission fault, we
> +		 * need to retry, as we're likely to have missed in the PTs.
> +		 */
> +		if ((fst & ESR_ELx_FSC_TYPE) != ESR_ELx_FSC_PERM)
> +			retry_slow = true;

Shouldn't VCPU's PAR_EL1 register be updated here? As far as I can tell, at this
point the VCPU PAR_EL1 register has the result from the successful walk
performed by AT S1E1R or AT S1E1W in the first 'switch' statement.

Thanks,
Alex

> +	} else {
> +		/*
> +		 * The EL0 access succeded, but we don't have the full
> +		 * syndrom information to synthetize the failure. Go slow.
> +		 */
> +		retry_slow = true;
> +	}
>  nopan:
>  	__mmu_config_restore(&config);
>  out:
>  	local_irq_restore(flags);
>  
>  	write_unlock(&vcpu->kvm->mmu_lock);
> +
> +	/*
> +	 * If retry_slow is true, then we either are missing shadow S2
> +	 * entries, have paged out guest S1, or something is inconsistent.
> +	 *
> +	 * Either way, we need to walk the PTs by hand so that we can either
> +	 * fault things back, in or record accurate fault information along
> +	 * the way.
> +	 */
> +	if (retry_slow) {
> +		par = handle_at_slow(vcpu, op, vaddr);
> +		vcpu_write_sys_reg(vcpu, par, PAR_EL1);
> +	}
>  }

