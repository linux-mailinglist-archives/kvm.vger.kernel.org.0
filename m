Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4094C4A701C
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 12:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343943AbiBBLjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 06:39:54 -0500
Received: from foss.arm.com ([217.140.110.172]:53116 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229916AbiBBLjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 06:39:54 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D5BDB1FB;
        Wed,  2 Feb 2022 03:39:53 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 171DD3F40C;
        Wed,  2 Feb 2022 03:39:50 -0800 (PST)
Date:   Wed, 2 Feb 2022 11:40:04 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: Re: [PATCH v6 03/64] KVM: arm64: nv: Reset VCPU to EL2 registers if
 VCPU nested virt is set
Message-ID: <YfpteeR6460x31ZJ@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-4-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Jan 28, 2022 at 12:18:11PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> Reset the VCPU with PSTATE.M = EL2h when the nested virtualization
> feature is enabled on the VCPU.

Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> 
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> [maz: rework register reset not to use empty data structures]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/reset.c | 29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index ecc40c8cd6f6..d19a9aad2d85 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -27,6 +27,7 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_nested.h>
>  #include <asm/virt.h>
>  
>  /* Maximum phys_shift supported for any VM on this host */
> @@ -38,6 +39,9 @@ static u32 kvm_ipa_limit;
>  #define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
>  				 PSR_F_BIT | PSR_D_BIT)
>  
> +#define VCPU_RESET_PSTATE_EL2	(PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
> +				 PSR_F_BIT | PSR_D_BIT)
> +
>  #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
>  				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
>  
> @@ -188,12 +192,19 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
>  	unsigned long i;
>  
>  	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
> -	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
> -		return false;
> +	if (is32bit) {
> +		/* The HW must obviously support AArch32 at EL1 */
> +		if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1))
> +			return false;
>  
> -	/* MTE is incompatible with AArch32 */
> -	if (kvm_has_mte(vcpu->kvm) && is32bit)
> -		return false;
> +		/* MTE is incompatible with AArch32 */
> +		if (kvm_has_mte(vcpu->kvm))
> +			return false;
> +
> +		/* NV is incompatible with AArch32 */
> +		if (vcpu_has_nv(vcpu))
> +			return false;
> +	}
>  
>  	/* Check that the vcpus are either all 32bit or all 64bit */
>  	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> @@ -265,10 +276,18 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  		goto out;
>  	}
>  
> +	if (vcpu_has_nv(vcpu) &&
> +	    vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
>  	switch (vcpu->arch.target) {
>  	default:
>  		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
>  			pstate = VCPU_RESET_PSTATE_SVC;
> +		} else if (vcpu_has_nv(vcpu)) {
> +			pstate = VCPU_RESET_PSTATE_EL2;
>  		} else {
>  			pstate = VCPU_RESET_PSTATE_EL1;
>  		}
> -- 
> 2.30.2
> 
