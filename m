Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E84A1D948E
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 12:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgESKpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 06:45:06 -0400
Received: from foss.arm.com ([217.140.110.172]:58720 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgESKpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 06:45:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A279A101E;
        Tue, 19 May 2020 03:45:05 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.1.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5837B3F305;
        Tue, 19 May 2020 03:45:02 -0700 (PDT)
Date:   Tue, 19 May 2020 11:44:57 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 26/26] KVM: arm64: Parametrize exception entry with a
 target EL
Message-ID: <20200519104457.GA19548@C02TD0UTHF1T.local>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-27-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422120050.3693593-27-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 01:00:50PM +0100, Marc Zyngier wrote:
> We currently assume that an exception is delivered to EL1, always.
> Once we emulate EL2, this no longer will be the case. To prepare
> for this, add a target_mode parameter.
> 
> While we're at it, merge the computing of the target PC and PSTATE in
> a single function that updates both PC and CPSR after saving their
> previous values in the corresponding ELR/SPSR. This ensures that they
> are updated in the correct order (a pretty common source of bugs...).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/inject_fault.c | 75 ++++++++++++++++++-----------------
>  1 file changed, 38 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index d3ebf8bca4b89..3dbcbc839b9c3 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -26,28 +26,12 @@ enum exception_type {
>  	except_type_serror	= 0x180,
>  };
>  
> -static u64 get_except_vector(struct kvm_vcpu *vcpu, enum exception_type type)
> -{
> -	u64 exc_offset;
> -
> -	switch (*vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT)) {
> -	case PSR_MODE_EL1t:
> -		exc_offset = CURRENT_EL_SP_EL0_VECTOR;
> -		break;
> -	case PSR_MODE_EL1h:
> -		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
> -		break;
> -	case PSR_MODE_EL0t:
> -		exc_offset = LOWER_EL_AArch64_VECTOR;
> -		break;
> -	default:
> -		exc_offset = LOWER_EL_AArch32_VECTOR;
> -	}
> -
> -	return vcpu_read_sys_reg(vcpu, VBAR_EL1) + exc_offset + type;
> -}
> -
>  /*
> + * This performs the exception entry at a given EL (@target_mode), stashing PC
> + * and PSTATE into ELR and SPSR respectively, and compute the new PC/PSTATE.
> + * The EL passed to this function *must* be a non-secure, privileged mode with
> + * bit 0 being set (PSTATE.SP == 1).
> + *
>   * When an exception is taken, most PSTATE fields are left unchanged in the
>   * handler. However, some are explicitly overridden (e.g. M[4:0]). Luckily all
>   * of the inherited bits have the same position in the AArch64/AArch32 SPSR_ELx
> @@ -59,10 +43,35 @@ static u64 get_except_vector(struct kvm_vcpu *vcpu, enum exception_type type)
>   * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout, from
>   * MSB to LSB.
>   */
> -static unsigned long get_except64_pstate(struct kvm_vcpu *vcpu)
> +static void enter_exception(struct kvm_vcpu *vcpu, unsigned long target_mode,
> +			    enum exception_type type)

Since this is all for an AArch64 target, could we keep `64` in the name,
e.g enter_exception64? That'd mirror the callers below.

>  {
> -	unsigned long sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> -	unsigned long old, new;
> +	unsigned long sctlr, vbar, old, new, mode;
> +	u64 exc_offset;
> +
> +	mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
> +
> +	if      (mode == target_mode)
> +		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
> +	else if ((mode | 1) == target_mode)
> +		exc_offset = CURRENT_EL_SP_EL0_VECTOR;

It would be nice if we could add a mnemonic for the `1` here, e.g.
PSR_MODE_SP0 or PSR_MODE_THREAD_BIT.

> +	else if (!(mode & PSR_MODE32_BIT))
> +		exc_offset = LOWER_EL_AArch64_VECTOR;
> +	else
> +		exc_offset = LOWER_EL_AArch32_VECTOR;

Other than the above, I couldn't think of a nicer way of writing thism
and AFAICT this is correct.

> +
> +	switch (target_mode) {
> +	case PSR_MODE_EL1h:
> +		vbar = vcpu_read_sys_reg(vcpu, VBAR_EL1);
> +		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> +		vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
> +		break;
> +	default:
> +		/* Don't do that */
> +		BUG();
> +	}
> +
> +	*vcpu_pc(vcpu) = vbar + exc_offset + type;
>  
>  	old = *vcpu_cpsr(vcpu);
>  	new = 0;
> @@ -105,9 +114,10 @@ static unsigned long get_except64_pstate(struct kvm_vcpu *vcpu)
>  	new |= PSR_I_BIT;
>  	new |= PSR_F_BIT;
>  
> -	new |= PSR_MODE_EL1h;
> +	new |= target_mode;

As a heads-up, some of the other bits will need to change for an EL2
target (e.g. SPAN will depend on HCR_EL2.E2H), but as-is this this is
fine.

Regardless of the above comments:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.
