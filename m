Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2C73CE02A
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 17:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346178AbhGSPOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:14:11 -0400
Received: from foss.arm.com ([217.140.110.172]:34622 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345984AbhGSPN0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:13:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F1551FB;
        Mon, 19 Jul 2021 08:54:06 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A29CE3F73D;
        Mon, 19 Jul 2021 08:54:03 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] KVM: arm64: Narrow PMU sysreg reset values to
 architectural requirements
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Russell King <linux@arm.linux.org.uk>, kernel-team@android.com,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20210719123902.1493805-1-maz@kernel.org>
 <20210719123902.1493805-2-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <171cca9d-2a6e-248c-8502-feba8ebbe55e@arm.com>
Date:   Mon, 19 Jul 2021 16:55:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210719123902.1493805-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/19/21 1:38 PM, Marc Zyngier wrote:
> A number of the PMU sysregs expose reset values that are not
> compliant with the architecture (set bits in the RES0 ranges,
> for example).
>
> This in turn has the effect that we need to pointlessly mask
> some register fields when using them.
>
> Let's start by making sure we don't have illegal values in the
> shadow registers at reset time. This affects all the registers
> that dedicate one bit per counter, the counters themselves,
> PMEVTYPERn_EL0 and PMSELR_EL0.
>
> Reported-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 43 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 40 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f6f126eb6ac1..96bdfa0e68b2 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -603,6 +603,41 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
>  	return REG_HIDDEN;
>  }
>  
> +static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
> +
> +	/* No PMU available, any PMU reg may UNDEF... */
> +	if (!kvm_arm_support_pmu_v3())
> +		return;
> +
> +	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
> +	n &= ARMV8_PMU_PMCR_N_MASK;
> +	if (n)
> +		mask |= GENMASK(n - 1, 0);

Hm... seems to be missing the cycle counter.

Thanks,

Alex

> +
> +	reset_unknown(vcpu, r);
> +	__vcpu_sys_reg(vcpu, r->reg) &= mask;
> +}
> +
> +static void reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	reset_unknown(vcpu, r);
> +	__vcpu_sys_reg(vcpu, r->reg) &= GENMASK(31, 0);
> +}
> +
> +static void reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	reset_unknown(vcpu, r);
> +	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_EVTYPE_MASK;
> +}
> +
> +static void reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	reset_unknown(vcpu, r);
> +	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_COUNTER_MASK;
> +}
> +
>  static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	u64 pmcr, val;
> @@ -944,16 +979,18 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	  trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
>  
>  #define PMU_SYS_REG(r)						\
> -	SYS_DESC(r), .reset = reset_unknown, .visibility = pmu_visibility
> +	SYS_DESC(r), .reset = reset_pmu_reg, .visibility = pmu_visibility
>  
>  /* Macro to expand the PMEVCNTRn_EL0 register */
>  #define PMU_PMEVCNTR_EL0(n)						\
>  	{ PMU_SYS_REG(SYS_PMEVCNTRn_EL0(n)),				\
> +	  .reset = reset_pmevcntr,					\
>  	  .access = access_pmu_evcntr, .reg = (PMEVCNTR0_EL0 + n), }
>  
>  /* Macro to expand the PMEVTYPERn_EL0 register */
>  #define PMU_PMEVTYPER_EL0(n)						\
>  	{ PMU_SYS_REG(SYS_PMEVTYPERn_EL0(n)),				\
> +	  .reset = reset_pmevtyper,					\
>  	  .access = access_pmu_evtyper, .reg = (PMEVTYPER0_EL0 + n), }
>  
>  static bool undef_access(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> @@ -1595,13 +1632,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ PMU_SYS_REG(SYS_PMSWINC_EL0),
>  	  .access = access_pmswinc, .reg = PMSWINC_EL0 },
>  	{ PMU_SYS_REG(SYS_PMSELR_EL0),
> -	  .access = access_pmselr, .reg = PMSELR_EL0 },
> +	  .access = access_pmselr, .reset = reset_pmselr, .reg = PMSELR_EL0 },
>  	{ PMU_SYS_REG(SYS_PMCEID0_EL0),
>  	  .access = access_pmceid, .reset = NULL },
>  	{ PMU_SYS_REG(SYS_PMCEID1_EL0),
>  	  .access = access_pmceid, .reset = NULL },
>  	{ PMU_SYS_REG(SYS_PMCCNTR_EL0),
> -	  .access = access_pmu_evcntr, .reg = PMCCNTR_EL0 },
> +	  .access = access_pmu_evcntr, .reset = reset_unknown, .reg = PMCCNTR_EL0 },
>  	{ PMU_SYS_REG(SYS_PMXEVTYPER_EL0),
>  	  .access = access_pmu_evtyper, .reset = NULL },
>  	{ PMU_SYS_REG(SYS_PMXEVCNTR_EL0),
