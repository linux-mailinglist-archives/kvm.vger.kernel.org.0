Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD6248EF4F
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 18:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243914AbiANRl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 12:41:58 -0500
Received: from foss.arm.com ([217.140.110.172]:36288 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230300AbiANRl5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 12:41:57 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 235BF6D;
        Fri, 14 Jan 2022 09:41:57 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 782743F766;
        Fri, 14 Jan 2022 09:41:54 -0800 (PST)
Date:   Fri, 14 Jan 2022 17:42:04 +0000
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
Subject: Re: [PATCH v5 11/69] KVM: arm64: nv: Add nested virt VCPU primitives
 for vEL2 VCPU state
Message-ID: <YeG17OWrvFPQjgjS@monolith.localdoman>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-12-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-12-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

Bunch of bikeshedding regarding names below, which can be safely ignored.

On Mon, Nov 29, 2021 at 08:00:52PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> When running a nested hypervisor we commonly have to figure out if
> the VCPU mode is running in the context of a guest hypervisor or guest
> guest, or just a normal guest.
> 
> Add convenient primitives for this.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 55 ++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index f4871e47b2d0..f4b079945d0f 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -176,6 +176,61 @@ static __always_inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
>  		vcpu_gp_regs(vcpu)->regs[reg_num] = val;
>  }
>  
> +static inline bool vcpu_mode_el2_ctxt(const struct kvm_cpu_context *ctxt)

"The Armv8-A architecture defines a set of Exception levels, EL0 to EL3" (ARM
DDI 0487G.a, page G1-5941).

"AArch64 state does not support modes. Modes are a concept that is specific to
AArch32 state." (ARM DDI 0487G.a, page G1-5944).

Wouldn't it be better to use the same terminology as the architecture?

> +{
> +	unsigned long cpsr = ctxt->regs.pstate;

CPSR is an AArch32 register. Why not name the variable pstate?

> +
> +	switch (cpsr & (PSR_MODE32_BIT | PSR_MODE_MASK)) {
> +	case PSR_MODE_EL2h:
> +	case PSR_MODE_EL2t:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +static inline bool vcpu_mode_el2(const struct kvm_vcpu *vcpu)
> +{
> +	return vcpu_mode_el2_ctxt(&vcpu->arch.ctxt);
> +}
> +
> +static inline bool __vcpu_el2_e2h_is_set(const struct kvm_cpu_context *ctxt)
> +{
> +	return ctxt_sys_reg(ctxt, HCR_EL2) & HCR_E2H;
> +}
> +
> +static inline bool vcpu_el2_e2h_is_set(const struct kvm_vcpu *vcpu)
> +{
> +	return __vcpu_el2_e2h_is_set(&vcpu->arch.ctxt);
> +}
> +
> +static inline bool __vcpu_el2_tge_is_set(const struct kvm_cpu_context *ctxt)
> +{
> +	return ctxt_sys_reg(ctxt, HCR_EL2) & HCR_TGE;
> +}
> +
> +static inline bool vcpu_el2_tge_is_set(const struct kvm_vcpu *vcpu)

This is confusing. What does the exception level have to do with the HCR_EL2.TGE
bit being set? Wouldn't vcpu_hcr_tge_is_set() be better?

> +{
> +	return __vcpu_el2_tge_is_set(&vcpu->arch.ctxt);
> +}
> +
> +static inline bool __is_hyp_ctxt(const struct kvm_cpu_context *ctxt)
> +{
> +	/*
> +	 * We are in a hypervisor context if the vcpu mode is EL2 or
> +	 * E2H and TGE bits are set. The latter means we are in the user space
> +	 * of the VHE kernel. ARMv8.1 ARM describes this as 'InHost'

So why not call the function vcpu_is_inhost() or something along those lines to
match the architecture?

Thanks,
Alex

> +	 */
> +	return vcpu_mode_el2_ctxt(ctxt) ||
> +		(__vcpu_el2_e2h_is_set(ctxt) && __vcpu_el2_tge_is_set(ctxt)) ||
> +		WARN_ON(__vcpu_el2_tge_is_set(ctxt));
> +}
> +
> +static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
> +{
> +	return __is_hyp_ctxt(&vcpu->arch.ctxt);
> +}
> +
>  /*
>   * The layout of SPSR for an AArch32 state is different when observed from an
>   * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
> -- 
> 2.30.2
> 
