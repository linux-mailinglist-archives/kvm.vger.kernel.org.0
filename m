Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A949492B5B
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 17:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbiARQgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 11:36:54 -0500
Received: from foss.arm.com ([217.140.110.172]:32924 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231135AbiARQgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 11:36:54 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF03F1FB;
        Tue, 18 Jan 2022 08:36:53 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8200E3F774;
        Tue, 18 Jan 2022 08:36:51 -0800 (PST)
Date:   Tue, 18 Jan 2022 16:36:59 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v5 16/69] KVM: arm64: nv: Handle trapped ERET from
 virtual EL2
Message-ID: <Yebsq0wWHO5mWZjx@monolith.localdoman>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-17-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-17-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Mon, Nov 29, 2021 at 08:00:57PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> When a guest hypervisor running virtual EL2 in EL1 executes an ERET
> instruction, we will have set HCR_EL2.NV which traps ERET to EL2, so
> that we can emulate the exception return in software.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/esr.h     |  5 +++++
>  arch/arm64/include/asm/kvm_arm.h |  2 +-
>  arch/arm64/kvm/handle_exit.c     | 10 ++++++++++
>  3 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index d52a0b269ee8..6835e4231119 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -257,6 +257,11 @@
>  		(((e) & ESR_ELx_SYS64_ISS_OP2_MASK) >>		\
>  		 ESR_ELx_SYS64_ISS_OP2_SHIFT))
>  
> +/* ISS field definitions for ERET/ERETAA/ERETAB trapping */
> +
> +#define ESR_ELx_ERET_ISS_ERET_ERETAx	0x2
> +#define ESR_ELx_ERET_ISS_ERETA_ERATAB	0x1
                            ^^^^^
Shouldn't that be ERETAA?

Other than that, the patch looks good to me, although I'm unfamiliar with
PAuth:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> +
>  /*
>   * ISS field definitions for floating-point exception traps
>   * (FP_EXC_32/FP_EXC_64).
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 589a6b92d741..0a0ee998ec5a 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -353,7 +353,7 @@
>  	ECN(SP_ALIGN), ECN(FP_EXC32), ECN(FP_EXC64), ECN(SERROR), \
>  	ECN(BREAKPT_LOW), ECN(BREAKPT_CUR), ECN(SOFTSTP_LOW), \
>  	ECN(SOFTSTP_CUR), ECN(WATCHPT_LOW), ECN(WATCHPT_CUR), \
> -	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64)
> +	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64), ECN(ERET)
>  
>  #define CPACR_EL1_FPEN		(3 << 20)
>  #define CPACR_EL1_TTA		(1 << 28)
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 1fd1c6dfd6a0..95ae624d6aa8 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -169,6 +169,15 @@ static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +static int kvm_handle_eret(struct kvm_vcpu *vcpu)
> +{
> +	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_ERET_ISS_ERET_ERETAx)
> +		return kvm_handle_ptrauth(vcpu);
> +
> +	kvm_emulate_nested_eret(vcpu);
> +	return 1;
> +}
> +
>  static exit_handle_fn arm_exit_handlers[] = {
>  	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
>  	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
> @@ -183,6 +192,7 @@ static exit_handle_fn arm_exit_handlers[] = {
>  	[ESR_ELx_EC_SMC64]	= handle_smc,
>  	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
>  	[ESR_ELx_EC_SVE]	= handle_sve,
> +	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
>  	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
>  	[ESR_ELx_EC_DABT_LOW]	= kvm_handle_guest_abort,
>  	[ESR_ELx_EC_SOFTSTP_LOW]= kvm_handle_guest_debug,
> -- 
> 2.30.2
> 
