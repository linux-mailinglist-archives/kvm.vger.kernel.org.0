Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E60E5B87C
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 11:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfGAJ6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 05:58:50 -0400
Received: from foss.arm.com ([217.140.110.172]:59280 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbfGAJ6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 05:58:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06D0B2B;
        Mon,  1 Jul 2019 02:58:49 -0700 (PDT)
Received: from [10.1.31.185] (unknown [10.1.31.185])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C44A3F718;
        Mon,  1 Jul 2019 02:58:47 -0700 (PDT)
Subject: Re: [PATCH 13/59] KVM: arm64: nv: Handle virtual EL2 registers in
 vcpu_read/write_sys_reg()
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-14-marc.zyngier@arm.com>
 <6a866fda-a332-9881-b466-2a855deea6a5@arm.com>
Message-ID: <5d65b27b-af57-7e58-a21b-f785326f1263@arm.com>
Date:   Mon, 1 Jul 2019 10:58:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <6a866fda-a332-9881-b466-2a855deea6a5@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/25/19 4:18 PM, Alexandru Elisei wrote:
> Hi Marc,
>
> A question regarding this patch. This patch modifies vcpu_{read,write}_sys_reg
> to handle virtual EL2 registers. However, the file kvm/emulate-nested.c added by
> patch 10/59 "KVM: arm64: nv: Support virtual EL2 exceptions" already uses
> vcpu_{read,write}_sys_reg to access EL2 registers. In my opinion, it doesn't
> really matter which comes first because nested support is only enabled in the
> last patch of the series, but I thought I should bring this up in case it is not
> what you intended.
>
> On 6/21/19 10:37 AM, Marc Zyngier wrote:
>> From: Andre Przywara <andre.przywara@arm.com>
>>
>> KVM internally uses accessor functions when reading or writing the
>> guest's system registers. This takes care of accessing either the stored
>> copy or using the "live" EL1 system registers when the host uses VHE.
>>
>> With the introduction of virtual EL2 we add a bunch of EL2 system
>> registers, which now must also be taken care of:
>> - If the guest is running in vEL2, and we access an EL1 sysreg, we must
>>   revert to the stored version of that, and not use the CPU's copy.
>> - If the guest is running in vEL1, and we access an EL2 sysreg, we must
>>   also use the stored version, since the CPU carries the EL1 copy.
>> - Some EL2 system registers are supposed to affect the current execution
>>   of the system, so we need to put them into their respective EL1
>>   counterparts. For this we need to define a mapping between the two.
>>   This is done using the newly introduced struct el2_sysreg_map.
>> - Some EL2 system registers have a different format than their EL1
>>   counterpart, so we need to translate them before writing them to the
>>   CPU. This is done using an (optional) translate function in the map.
>> - There are the three special registers SP_EL2, SPSR_EL2 and ELR_EL2,
>>   which need some separate handling.
> I see no change in this patch related to SPSR_EL2. Special handling of SPSR_EL2
> is added in the next patch, patch 14/59 "KVM: arm64: nv: Handle SPSR_EL2 specially".
>> All of these cases are now wrapped into the existing accessor functions,
>> so KVM users wouldn't need to care whether they access EL2 or EL1
>> registers and also which state the guest is in.
>>
>> This handles what was formerly known as the "shadow state" dynamically,
>> without requiring a separate copy for each vCPU EL.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_emulate.h |   6 +
>>  arch/arm64/include/asm/kvm_host.h    |   5 +
>>  arch/arm64/kvm/sys_regs.c            | 163 +++++++++++++++++++++++++++
>>  3 files changed, 174 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index c43aac5fed69..f37006b6eec4 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -70,6 +70,12 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu);
>>  int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2);
>>  int kvm_inject_nested_irq(struct kvm_vcpu *vcpu);
>>  
>> +u64 translate_tcr(u64 tcr);
>> +u64 translate_cptr(u64 tcr);
>> +u64 translate_sctlr(u64 tcr);
>> +u64 translate_ttbr0(u64 tcr);
>> +u64 translate_cnthctl(u64 tcr);
>> +
>>  static inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
>>  {
>>  	return !(vcpu->arch.hcr_el2 & HCR_RW);
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 2d4290d2513a..dae9c42a7219 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -217,6 +217,11 @@ enum vcpu_sysreg {
>>  	NR_SYS_REGS	/* Nothing after this line! */
>>  };
>>  
>> +static inline bool sysreg_is_el2(int reg)
>> +{
>> +	return reg >= FIRST_EL2_SYSREG && reg < NR_SYS_REGS;
>> +}
>> +
>>  /* 32bit mapping */
>>  #define c0_MPIDR	(MPIDR_EL1 * 2)	/* MultiProcessor ID Register */
>>  #define c0_CSSELR	(CSSELR_EL1 * 2)/* Cache Size Selection Register */
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 693dd063c9c2..d024114da162 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -76,11 +76,142 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
>>  	return false;
>>  }
>>  
>> +static u64 tcr_el2_ips_to_tcr_el1_ps(u64 tcr_el2)
> The code seems to suggest that you are translating TCR_EL2.PS to TCR_EL1.IPS.
> Perhaps the function should be named tcr_el2_ps_to_tcr_el1_ips?
>> +{
>> +	return ((tcr_el2 & TCR_EL2_PS_MASK) >> TCR_EL2_PS_SHIFT)
>> +		<< TCR_IPS_SHIFT;
>> +}
>> +
>> +u64 translate_tcr(u64 tcr)
>> +{
>> +	return TCR_EPD1_MASK |				/* disable TTBR1_EL1 */
>> +	       ((tcr & TCR_EL2_TBI) ? TCR_TBI0 : 0) |
>> +	       tcr_el2_ips_to_tcr_el1_ps(tcr) |
>> +	       (tcr & TCR_EL2_TG0_MASK) |
>> +	       (tcr & TCR_EL2_ORGN0_MASK) |
>> +	       (tcr & TCR_EL2_IRGN0_MASK) |
>> +	       (tcr & TCR_EL2_T0SZ_MASK);
>> +}
>> +
>> +u64 translate_cptr(u64 cptr_el2)
> The argument name is not consistent with the other translate_* functions. I
> think it is reasonably obvious that you are translating an EL2 register.
>> +{
>> +	u64 cpacr_el1 = 0;
>> +
>> +	if (!(cptr_el2 & CPTR_EL2_TFP))
>> +		cpacr_el1 |= CPACR_EL1_FPEN;
>> +	if (cptr_el2 & CPTR_EL2_TTA)
>> +		cpacr_el1 |= CPACR_EL1_TTA;
>> +	if (!(cptr_el2 & CPTR_EL2_TZ))
>> +		cpacr_el1 |= CPACR_EL1_ZEN;
>> +
>> +	return cpacr_el1;
>> +}
>> +
>> +u64 translate_sctlr(u64 sctlr)
>> +{
>> +	/* Bit 20 is RES1 in SCTLR_EL1, but RES0 in SCTLR_EL2 */
>> +	return sctlr | BIT(20);
>> +}
>> +
>> +u64 translate_ttbr0(u64 ttbr0)
>> +{
>> +	/* Force ASID to 0 (ASID 0 or RES0) */
> Are you forcing ASID to 0 because you are only expecting a non-vhe guest
> hypervisor to access ttbr0_el2, in which case the architecture says that the
> ASID field is RES0? Is it so unlikely that a vhe guest hypervisor will access
> ttbr0_el2 directly that it's not worth adding a check for that?

My mistake, obviously the translate functions are used only when VHE is
disabled, because when E2H is set, they have the same format as their EL1
counterparts.

Sorry for the noise,

Alex

