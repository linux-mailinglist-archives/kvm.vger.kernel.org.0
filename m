Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED91B6D6540
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 16:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbjDDOZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 10:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbjDDOZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 10:25:46 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC9C344AB
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 07:25:35 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91ECAD75;
        Tue,  4 Apr 2023 07:26:19 -0700 (PDT)
Received: from FVFF77S0Q05N.cambridge.arm.com (FVFF77S0Q05N.cambridge.arm.com [10.1.35.139])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF44B3F73F;
        Tue,  4 Apr 2023 07:25:32 -0700 (PDT)
Date:   Tue, 4 Apr 2023 15:25:27 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Will Deacon <will@kernel.org>, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v1 2/2] KVM: arm64: PMU: Ensure to trap PMU access from
 EL0 to EL2
Message-ID: <ZCwzV7ACl21VbLru@FVFF77S0Q05N.cambridge.arm.com>
References: <20230329002136.2463442-1-reijiw@google.com>
 <20230329002136.2463442-3-reijiw@google.com>
 <86jzyzwyrd.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86jzyzwyrd.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 29, 2023 at 01:03:18PM +0100, Marc Zyngier wrote:
> On Wed, 29 Mar 2023 01:21:36 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> > 
> > Currently, with VHE, KVM sets ER, CR, SW and EN bits of
> > PMUSERENR_EL0 to 1 on vcpu_load().  So, if the value of those bits
> > are cleared after vcpu_load() (the perf subsystem would do when PMU
> > counters are programmed for the guest), PMU access from the guest EL0
> > might be trapped to the guest EL1 directly regardless of the current
> > PMUSERENR_EL0 value of the vCPU.
> 
> + RobH.
> 
> Is that what is done when the event is created and armv8pmu_start()
> called? This is... crap. The EL0 access thing breaks everything, and
> nobody tested it with KVM, obviously.
> 
> I would be tempted to start mitigating it with the following:
> 
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index dde06c0f97f3..8063525bf3dd 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -806,17 +806,19 @@ static void armv8pmu_disable_event(struct perf_event *event)
>  
>  static void armv8pmu_start(struct arm_pmu *cpu_pmu)
>  {
> -	struct perf_event_context *ctx;
> -	int nr_user = 0;
> +	if (sysctl_perf_user_access) {
> +		struct perf_event_context *ctx;
> +		int nr_user = 0;
>  
> -	ctx = perf_cpu_task_ctx();
> -	if (ctx)
> -		nr_user = ctx->nr_user;
> +		ctx = perf_cpu_task_ctx();
> +		if (ctx)
> +			nr_user = ctx->nr_user;
>  
> -	if (sysctl_perf_user_access && nr_user)
> -		armv8pmu_enable_user_access(cpu_pmu);
> -	else
> -		armv8pmu_disable_user_access();
> +		if (nr_user)
> +			armv8pmu_enable_user_access(cpu_pmu);
> +		else
> +			armv8pmu_disable_user_access();
> +	}
>  
>  	/* Enable all counters */
>  	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
> 
> but that's obviously not enough as we want it to work with EL0 access
> enabled on the host as well.
> 
> What we miss is something that tells the PMU code "we're in a context
> where host userspace isn't present", and this would be completely
> skipped, relying on KVM to restore the appropriate state on
> vcpu_put(). But then the IPI stuff that controls EL0 can always come
> in and wreck things. Gahhh...

AFAICT the perf code only writes to PMUSERENR_EL0 in contexts where IRQs (and
hence preemption) are disabled, so as long as we have a shadow of the host
PMUSERENR value somewhere, I think we can update the perf code with something
like the below?

... unless the KVM code is interruptible before saving the host value, or after
restoring it?

Thanks,
Mark.

---->8----
diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index dde06c0f97f3e..bdab3d5cbb5e3 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -741,11 +741,26 @@ static inline u32 armv8pmu_getreset_flags(void)
        return value;
 }
 
-static void armv8pmu_disable_user_access(void)
+static void update_pmuserenr(u64 val)
 {
+       lockdep_assert_irqs_disabled();
+
+       if (IS_ENABLED(CONFIG_KVM)) {
+               struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+               if (vcpu) {
+                       vcpu->arch.pmuserenr_host = val;
+                       return;
+               }
+       }
+
        write_sysreg(0, pmuserenr_el0);
 }
 
+static void armv8pmu_disable_user_access(void)
+{
+       update_pmuserenr(0);
+}
+
 static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
 {
        int i;
@@ -759,8 +774,7 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
                        armv8pmu_write_evcntr(i, 0);
        }
 
-       write_sysreg(0, pmuserenr_el0);
-       write_sysreg(ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_CR, pmuserenr_el0);
+       update_pmuserenr(ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_CR);
 }
 
 static void armv8pmu_enable_event(struct perf_event *event)

