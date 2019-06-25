Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE46C54F63
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 14:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbfFYMzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 08:55:25 -0400
Received: from foss.arm.com ([217.140.110.172]:41240 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbfFYMzZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 08:55:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 165B42B;
        Tue, 25 Jun 2019 05:55:25 -0700 (PDT)
Received: from [10.37.8.194] (unknown [10.37.8.194])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 49DD23F71E;
        Tue, 25 Jun 2019 05:55:23 -0700 (PDT)
Subject: Re: [PATCH 21/59] KVM: arm64: nv: Set a handler for the system
 instruction traps
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-22-marc.zyngier@arm.com>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <880f9a31-10bb-0fbd-987a-03dabf536f2f@arm.com>
Date:   Tue, 25 Jun 2019 13:55:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-22-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/21/2019 10:38 AM, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> When HCR.NV bit is set, execution of the EL2 translation regime address
> aranslation instructions and TLB maintenance instructions are trapped to
> EL2. In addition, execution of the EL1 translation regime address
> aranslation instructions and TLB maintenance instructions that are only

What's "translation regime address aranslation" ? I would guess
"aranslation" should be removed, but since the same pattern appears
twice in the commit doubt took over me :) .

> accessible from EL2 and above are trapped to EL2. In these cases,
> ESR_EL2.EC will be set to 0x18.
> 
> Change the existing handler to handle those system instructions as well
> as MRS/MSR instructions.  Emulation of each system instructions will be
> done in separate patches.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/kvm_coproc.h |  2 +-
>  arch/arm64/kvm/handle_exit.c        |  2 +-
>  arch/arm64/kvm/sys_regs.c           | 53 +++++++++++++++++++++++++----
>  arch/arm64/kvm/trace.h              |  2 +-
>  4 files changed, 50 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_coproc.h b/arch/arm64/include/asm/kvm_coproc.h
> index 0b52377a6c11..1b3d21bd8adb 100644
> --- a/arch/arm64/include/asm/kvm_coproc.h
> +++ b/arch/arm64/include/asm/kvm_coproc.h
> @@ -43,7 +43,7 @@ int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
> -int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run);
> +int kvm_handle_sys(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  
>  #define kvm_coproc_table_init kvm_sys_reg_table_init
>  void kvm_sys_reg_table_init(void);
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 2517711f034f..e662f23b63a1 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -236,7 +236,7 @@ static exit_handle_fn arm_exit_handlers[] = {
>  	[ESR_ELx_EC_SMC32]	= handle_smc,
>  	[ESR_ELx_EC_HVC64]	= handle_hvc,
>  	[ESR_ELx_EC_SMC64]	= handle_smc,
> -	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
> +	[ESR_ELx_EC_SYS64]	= kvm_handle_sys,
>  	[ESR_ELx_EC_SVE]	= handle_sve,
>  	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
>  	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1d1312425cf2..e711dde4511c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2597,6 +2597,40 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
>  	return 1;
>  }
>  
> +static int emulate_tlbi(struct kvm_vcpu *vcpu,
> +			     struct sys_reg_params *params)
> +{
> +	/* TODO: support tlbi instruction emulation*/
> +	kvm_inject_undefined(vcpu);
> +	return 1;
> +}
> +
> +static int emulate_at(struct kvm_vcpu *vcpu,
> +			     struct sys_reg_params *params)
> +{
> +	/* TODO: support address translation instruction emulation */
> +	kvm_inject_undefined(vcpu);
> +	return 1;
> +}
> +
> +static int emulate_sys_instr(struct kvm_vcpu *vcpu,
> +			     struct sys_reg_params *params)
> +{
> +	int ret = 0;
> +
> +	/* TLB maintenance instructions*/
> +	if (params->CRn == 0b1000)
> +		ret = emulate_tlbi(vcpu, params);
> +	/* Address Translation instructions */
> +	else if (params->CRn == 0b0111 && params->CRm == 0b1000)
> +		ret = emulate_at(vcpu, params);
> +

So, in theory the NV bit shouldn't trap other Op0 == 1 instructions.
Would it be worth adding a WARN() or BUG() in an "else" branch here,
just in case?

Thanks,

-- 
Julien Thierry
