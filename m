Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5FEB29C2ED
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 18:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1821223AbgJ0RlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 13:41:24 -0400
Received: from foss.arm.com ([217.140.110.172]:48686 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1821214AbgJ0RlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 13:41:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78F08139F;
        Tue, 27 Oct 2020 10:41:20 -0700 (PDT)
Received: from [172.16.1.113] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE14A3F719;
        Tue, 27 Oct 2020 10:41:18 -0700 (PDT)
Subject: Re: [PATCH 07/11] KVM: arm64: Inject AArch64 exceptions from HYP
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kernel-team@android.com
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-8-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <cf4dc11c-fb9f-ee01-a93a-c1c0a721aa19@arm.com>
Date:   Tue, 27 Oct 2020 17:41:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201026133450.73304-8-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 26/10/2020 13:34, Marc Zyngier wrote:
> Move the AArch64 exception injection code from EL1 to HYP, leaving
> only the ESR_EL1 updates to EL1. In order to come with the differences

(cope with the differences?)


> between VHE and nVHE, two set of system register accessors are provided.
> 
> SPSR, ELR, PC and PSTATE are now completely handled in the hypervisor.


> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index 6533a9270850..cd6e643639e8 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -11,7 +11,167 @@
>   */
>  
>  #include <hyp/adjust_pc.h>
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_emulate.h>
> +
> +#if defined (__KVM_NVHE_HYPERVISOR__)
> +/*
> + * System registers are never loaded on the CPU until we actually
> + * restore them.
> + */
> +static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
> +{
> +	return __vcpu_sys_reg(vcpu, reg);
> +}
> +
> +static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
> +{
> +	 __vcpu_sys_reg(vcpu, reg) = val;
> +}
> +
> +static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	write_sysreg_el1(val, SYS_SPSR);
> +}
> +#elif defined (__KVM_VHE_HYPERVISOR__)
> +/* On VHE, all the registers are already loaded on the CPU */
> +static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
> +{
> +	u64 val;

> +	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
> +		return val;

As has_vhe()'s behaviour changes based on these KVM preprocessor symbols, would:
|	if (has_vhe() && __vcpu_read_sys_reg_from_cpu(reg, &val))
|		return val;

let you do both of these with only one copy of the function?


> +	return __vcpu_sys_reg(vcpu, reg);
> +}
> +
> +static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
> +{
> +	if (__vcpu_write_sys_reg_to_cpu(val, reg))
> +		return;
> +
> +	 __vcpu_sys_reg(vcpu, reg) = val;
> +}


> +static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	write_sysreg_el1(val, SYS_SPSR);
> +}

This one doesn't look like it needs duplicating.


> +#else
> +#error Hypervisor code only!
> +#endif


Thanks,

James
