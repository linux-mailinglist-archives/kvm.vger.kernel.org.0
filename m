Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A606487EA3
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 22:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiAGVzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 16:55:48 -0500
Received: from foss.arm.com ([217.140.110.172]:44568 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230183AbiAGVzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 16:55:48 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1304A113E;
        Fri,  7 Jan 2022 13:55:48 -0800 (PST)
Received: from localhost.localdomain (unknown [10.122.33.8])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A0643F66F;
        Fri,  7 Jan 2022 13:55:47 -0800 (PST)
From:   Chase Conklin <chase.conklin@arm.com>
To:     maz@kernel.org
Cc:     alexandru.elisei@arm.com, andre.przywara@arm.com,
        christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com,
        haibo.xu@linaro.org, james.morse@arm.com, jintack@cs.columbia.edu,
        kernel-team@android.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        suzuki.poulose@arm.com
Subject: Re: [PATCH v5 08/69] KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU nested virt is set
Date:   Fri,  7 Jan 2022 15:54:01 -0600
Message-Id: <20220107215401.61828-1-chase.conklin@arm.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211129200150.351436-9-maz@kernel.org>
References: <20211129200150.351436-9-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Mon Nov 29 15:00:49 EST 2021, Marc Zyngier <maz@kernel.org> wrote:
> From: Christoffer Dall <christoffer.dall at arm.com>
>
> Reset the VCPU with PSTATE.M = EL2h when the nested virtualization
> feature is enabled on the VCPU.
>
> Signed-off-by: Christoffer Dall <christoffer.dall at arm.com>
> [maz: rework register reset not to use empty data structures]
> Signed-off-by: Marc Zyngier <maz at kernel.org>
> ---
>  arch/arm64/kvm/reset.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 426bd7fbc3fd..38a7182819fb 100644
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
> @@ -176,8 +180,8 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
>  	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
>  		return false;
>  
> -	/* MTE is incompatible with AArch32 */
> -	if (kvm_has_mte(vcpu->kvm) && is32bit)
> +	/* MTE and NV are incompatible with AArch32 */
> +	if ((kvm_has_mte(vcpu->kvm) || nested_virt_in_use(vcpu)) && is32bit)
>  		return false;

Should something similar be done for SVE? I see from the ID register emulation
that SVE is hidden from the guest but there isn't anything in
kvm_vcpu_enable_sve() that checks if NV is in use. That means it's possible to
have both nested_virt_in_use(vcpu) and vcpu_has_sve(vcpu) be true
simultaneously. If that happens, the FPSIMD fixup can get confused

	/*
	 * Don't handle SVE traps for non-SVE vcpus here. This
	 * includes NV guests for the time being.
	 */
	if (!sve_guest && (esr_ec != ESR_ELx_EC_FP_ASIMD ||
			   guest_hyp_fpsimd_traps_enabled(vcpu)))
		return false;

and incorrectly restore the wrong context instead of forwarding a FPSIMD trap to
the guest hypervisor.

Thanks,
Chase

>  	/* Check that the vcpus are either all 32bit or all 64bit */
> @@ -255,6 +259,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	default:
>  		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
>  			pstate = VCPU_RESET_PSTATE_SVC;
> +		} else if (nested_virt_in_use(vcpu)) {
> +			pstate = VCPU_RESET_PSTATE_EL2;
>  		} else {
>  			pstate = VCPU_RESET_PSTATE_EL1;
>  		}
> -- 
> 2.30.2

