Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C944D4A707B
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 13:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344065AbiBBMJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 07:09:54 -0500
Received: from foss.arm.com ([217.140.110.172]:54654 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232109AbiBBMJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 07:09:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 751E71FB;
        Wed,  2 Feb 2022 04:09:53 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A66663F718;
        Wed,  2 Feb 2022 04:09:50 -0800 (PST)
Date:   Wed, 2 Feb 2022 12:10:00 +0000
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
Subject: Re: [PATCH v6 06/64] KVM: arm64: nv: Add nested virt VCPU primitives
 for vEL2 VCPU state
Message-ID: <Yfp0fTypgtqYzNdD@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-7-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-7-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Jan 28, 2022 at 12:18:14PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> When running a nested hypervisor we commonly have to figure out if
> the VCPU mode is running in the context of a guest hypervisor or guest
> guest, or just a normal guest.
> 
> Add convenient primitives for this.
> 
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 53 ++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index d62405ce3e6d..ea9a130c4b6a 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -178,6 +178,59 @@ static __always_inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
>  		vcpu_gp_regs(vcpu)->regs[reg_num] = val;
>  }
>  
> +static inline bool vcpu_is_el2_ctxt(const struct kvm_cpu_context *ctxt)
> +{
> +	switch (ctxt->regs.pstate & (PSR_MODE32_BIT | PSR_MODE_MASK)) {
> +	case PSR_MODE_EL2h:
> +	case PSR_MODE_EL2t:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +static inline bool vcpu_is_el2(const struct kvm_vcpu *vcpu)
> +{
> +	return vcpu_is_el2_ctxt(&vcpu->arch.ctxt);
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
> +	 */
> +	return vcpu_is_el2_ctxt(ctxt) ||
> +		(__vcpu_el2_e2h_is_set(ctxt) && __vcpu_el2_tge_is_set(ctxt)) ||
> +		WARN_ON(__vcpu_el2_tge_is_set(ctxt));

Why the WARN_ON? Wouldn't it be easy for a guest to flood the host's dmesg with
warnings by setting HCR_EL2.{E2H,TGE} = {0, 1} and then repeatedly accessing EL2
registers (for example)?

> +}
> +
> +static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)

When KVM boots at EL2 and FEAT_VHE is not implemented it prints to dmesg:

[    1.352302] kvm [1]: Hyp mode initialized successfully

I take it in that context "Hyp" means "EL2 NVHE", because when E2H,TGE are
set the message changes to:

[    0.037683] kvm [1]: VHE mode initialized successfully

In this file, in the function is_kernel_in_hyp_mode(), "hyp" actually means
that the exception level is EL2. In kvm/arm.c, "hyp" also means EL2 (or
maybe EL2 NVHE?).

Wouldn't it be nice to avoid having "hyp" mean yet another thing and
replace it with "hypervisor" in these two functions?

Thanks,
Alex

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
