Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082277A2780
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 21:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbjIOT44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 15:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237056AbjIOT4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 15:56:49 -0400
Received: from out-230.mta1.migadu.com (out-230.mta1.migadu.com [95.215.58.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD422111
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 12:56:44 -0700 (PDT)
Date:   Fri, 15 Sep 2023 19:56:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694807802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4cyq9z+NVEYHsFKyg9M91niGEqUL3RvbRSHxuDLlxgo=;
        b=m7q/WsJOgBJ088EOEuNGXvrtrOAv+gwEDmR6XuV5PP4DpFtADobiAF1Ea4I5SKSfR7iUK0
        DS439BsGIu+oz/tbl/Fr4bppRzYlJpstVhoQViRfl89H6wBNcYcgGv/bzpURWZtF6I+eaz
        IzJLHjnyzf2FMUppVEQlwD2854eDGQ4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 05/12] KVM: arm64: PMU: Simplify extracting PMCR_EL0.N
Message-ID: <ZQS28e8b4YduMkdE@linux.dev>
References: <20230817003029.3073210-1-rananta@google.com>
 <20230817003029.3073210-6-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817003029.3073210-6-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+cc will, rutland

Hi Raghu,

Please make sure you cc the right folks for changes that poke multiple
subsystems.

The diff looks OK, but I'm somewhat dubious of the need for this change
in the context of what you're trying to accomplish for KVM. I'd prefer
we either leave the existing definition/usage intact or rework *all* of
the PMUv3 masks to be of the shifted variety.

On Thu, Aug 17, 2023 at 12:30:22AM +0000, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
> 
> Some code extracts PMCR_EL0.N using ARMV8_PMU_PMCR_N_SHIFT and
> ARMV8_PMU_PMCR_N_MASK. Define ARMV8_PMU_PMCR_N (0x1f << 11),
> and simplify those codes using FIELD_GET() and/or ARMV8_PMU_PMCR_N.
> The following patches will also use these macros to extract PMCR_EL0.N.

Changelog is a bit wordy:

  Define a shifted mask for accessing PMCR_EL0.N amenable to the use of
  bitfield accessors and convert the existing, open-coded mask shifts to
  the new definition.

> No functional change intended.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/pmu-emul.c      | 3 +--
>  arch/arm64/kvm/sys_regs.c      | 7 +++----
>  drivers/perf/arm_pmuv3.c       | 3 +--
>  include/linux/perf/arm_pmuv3.h | 2 +-
>  4 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index b87822024828a..f7b5fa16341ad 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -245,9 +245,8 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
>  
>  u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
>  {
> -	u64 val = __vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMU_PMCR_N_SHIFT;
> +	u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, __vcpu_sys_reg(vcpu, PMCR_EL0));
>  
> -	val &= ARMV8_PMU_PMCR_N_MASK;
>  	if (val == 0)
>  		return BIT(ARMV8_PMU_CYCLE_IDX);
>  	else
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 39e9248c935e7..30108f09e088b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -750,7 +750,7 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  		return 0;
>  
>  	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
> -	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
> +	pmcr = read_sysreg(pmcr_el0) & ARMV8_PMU_PMCR_N;
>  	if (!kvm_supports_32bit_el0())
>  		pmcr |= ARMV8_PMU_PMCR_LC;
>  
> @@ -858,10 +858,9 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  
>  static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
>  {
> -	u64 pmcr, val;
> +	u64 val;
>  
> -	pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
> -	val = (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
> +	val = FIELD_GET(ARMV8_PMU_PMCR_N, __vcpu_sys_reg(vcpu, PMCR_EL0));
>  	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX) {
>  		kvm_inject_undefined(vcpu);
>  		return false;
> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index 08b3a1bf0ef62..7618b0adc0b8c 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -1128,8 +1128,7 @@ static void __armv8pmu_probe_pmu(void *info)
>  	probe->present = true;
>  
>  	/* Read the nb of CNTx counters supported from PMNC */
> -	cpu_pmu->num_events = (armv8pmu_pmcr_read() >> ARMV8_PMU_PMCR_N_SHIFT)
> -		& ARMV8_PMU_PMCR_N_MASK;
> +	cpu_pmu->num_events = FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read());
>  
>  	/* Add the CPU cycles counter */
>  	cpu_pmu->num_events += 1;
> diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
> index e3899bd77f5cc..ecbcf3f93560c 100644
> --- a/include/linux/perf/arm_pmuv3.h
> +++ b/include/linux/perf/arm_pmuv3.h
> @@ -216,7 +216,7 @@
>  #define ARMV8_PMU_PMCR_LC	(1 << 6) /* Overflow on 64 bit cycle counter */
>  #define ARMV8_PMU_PMCR_LP	(1 << 7) /* Long event counter enable */
>  #define ARMV8_PMU_PMCR_N_SHIFT	11  /* Number of counters supported */
> -#define ARMV8_PMU_PMCR_N_MASK	0x1f
> +#define	ARMV8_PMU_PMCR_N	(0x1f << ARMV8_PMU_PMCR_N_SHIFT)
>  #define ARMV8_PMU_PMCR_MASK	0xff    /* Mask for writable bits */
>  
>  /*
> -- 
> 2.41.0.694.ge786442a9b-goog
> 
> 

-- 
Thanks,
Oliver
