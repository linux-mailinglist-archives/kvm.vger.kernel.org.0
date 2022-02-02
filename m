Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21834A7679
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 18:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346114AbiBBRIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 12:08:17 -0500
Received: from foss.arm.com ([217.140.110.172]:43360 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244540AbiBBRIQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 12:08:16 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B38F113E;
        Wed,  2 Feb 2022 09:08:16 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 00F3A3F40C;
        Wed,  2 Feb 2022 09:08:12 -0800 (PST)
Date:   Wed, 2 Feb 2022 17:08:26 +0000
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
Subject: Re: [PATCH v6 12/64] KVM: arm64: nv: Add non-VHE-EL2->EL1
 translation helpers
Message-ID: <Yfq6ig0TIv2Bs4Dq@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-13-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-13-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Jan 28, 2022 at 12:18:20PM +0000, Marc Zyngier wrote:
> Some EL2 system registers immediately affect the current execution
> of the system, so we need to use their respective EL1 counterparts.
> For this we need to define a mapping between the two. In general,
> this only affects non-VHE guest hypervisors, as VHE system registers
> are compatible with the EL1 counterparts.
> 
> These helpers will get used in subsequent patches.
> 
> Co-developed-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h | 54 +++++++++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index fd601ea68d13..5a85be6d8eb3 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -2,6 +2,7 @@
>  #ifndef __ARM64_KVM_NESTED_H
>  #define __ARM64_KVM_NESTED_H
>  
> +#include <linux/bitfield.h>
>  #include <linux/kvm_host.h>
>  
>  static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
> @@ -11,4 +12,57 @@ static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
>  		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
>  }
>  
> +/* Translation helpers from non-VHE EL2 to EL1 */
> +static inline u64 tcr_el2_ps_to_tcr_el1_ips(u64 tcr_el2)
> +{
> +	return (u64)FIELD_GET(TCR_EL2_PS_MASK, tcr_el2) << TCR_IPS_SHIFT;
> +}
> +
> +static inline u64 translate_tcr_el2_to_tcr_el1(u64 tcr)
> +{
> +	return TCR_EPD1_MASK |				/* disable TTBR1_EL1 */
> +	       ((tcr & TCR_EL2_TBI) ? TCR_TBI0 : 0) |
> +	       tcr_el2_ps_to_tcr_el1_ips(tcr) |
> +	       (tcr & TCR_EL2_TG0_MASK) |
> +	       (tcr & TCR_EL2_ORGN0_MASK) |
> +	       (tcr & TCR_EL2_IRGN0_MASK) |
> +	       (tcr & TCR_EL2_T0SZ_MASK);
> +}
> +
> +static inline u64 translate_cptr_el2_to_cpacr_el1(u64 cptr_el2)
> +{
> +	u64 cpacr_el1 = 0;
> +
> +	if (cptr_el2 & CPTR_EL2_TTA)
> +		cpacr_el1 |= CPACR_EL1_TTA;
> +	if (!(cptr_el2 & CPTR_EL2_TFP))
> +		cpacr_el1 |= CPACR_EL1_FPEN;
> +	if (!(cptr_el2 & CPTR_EL2_TZ))
> +		cpacr_el1 |= CPACR_EL1_ZEN;
> +
> +	return cpacr_el1;
> +}
> +
> +static inline u64 translate_sctlr_el2_to_sctlr_el1(u64 val)
> +{
> +	/* Only preserve the minimal set of bits we support */
> +	val &= (SCTLR_ELx_M | SCTLR_ELx_A | SCTLR_ELx_C | SCTLR_ELx_SA |
> +		SCTLR_ELx_I | SCTLR_ELx_IESB | SCTLR_ELx_WXN | SCTLR_ELx_EE);

Checked that the bit positions are the same between SCTLR_EL2 and SCTLR_EL1. I
think the IESB bit (bit 21) should be after the WXN bit (bit 19) to be
consistent; doesn't really matter either way.

> +	val |= SCTLR_EL1_RES1;
> +
> +	return val;
> +}
> +
> +static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
> +{
> +	/* Clear the ASID field */
> +	return ttbr0 & ~GENMASK_ULL(63, 48);
> +}
> +
> +static inline u64 translate_cnthctl_el2_to_cntkctl_el1(u64 cnthctl)
> +{
> +	return ((FIELD_GET(CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN, cnthctl) << 10) |
> +		(cnthctl & (CNTHCTL_EVNTI | CNTHCTL_EVNTDIR | CNTHCTL_EVNTEN)));

I asked about the field positions in the previous series and this is what you
replied:

> It's a classic one. Remember that we are running VHE, and remapping a
> nVHE view of CNTHCTL_EL2 into the VHE view *for the guest*, and that
> these things are completely shifted around (it has the CNTKCTL_EL1
> format).
>
> For example, on nVHE, CNTHCTL_EL2.EL1PCTEN is bit 0. On nVHE, this is
> bit 10. That's why we have this shift, and that you now need some
> paracetamol.
>
> You can also look at the way we deal with the same stuff in
> kvm_timer_init_vhe()".

Here's how this function is used in vhe/sysreg-sr.c:

static void __sysreg_restore_vel2_state(struct kvm_cpu_context *ctxt)
{
	[..]
	if (__vcpu_el2_e2h_is_set(ctxt)) {
		[..]
	} else {
		[..]
		val = translate_cnthctl_el2_to_cntkctl_el1(ctxt_sys_reg(ctxt, CNTHCTL_EL2));
		write_sysreg_el1(val, SYS_CNTKCTL);
	}
	[..]
}

CNTHCTL_EL2 is a pure EL2 register. The translate function is called when guest
HCR_EL2.E2H is not set, therefore virtual CNTHCTL_EL2 has the non-VHE format.
And the result of the function is used to write to the hardware CNTKCTL_EL1
register (using the CNTKCTL_EL12 encoding), which is different from the
CNTHCTL_EL2 register. CNTKCTL_EL1 also always has the same format regardless of
the value of the HCR_EL2.E2H bit.

I don't understand what the host running with VHE has to do with the translate
function.

Thanks,
Alex

> +}
> +
>  #endif /* __ARM64_KVM_NESTED_H */
> -- 
> 2.30.2
> 
