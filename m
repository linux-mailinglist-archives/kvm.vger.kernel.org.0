Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13146267DA
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 08:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbiKLHz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 02:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiKLHz5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 02:55:57 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84291FCD6
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 23:55:55 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 6so6104876pgm.6
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 23:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=y6EtP1Qjdh6B95kwSPzSGW2ptWL2ACP203geTKQqyBY=;
        b=tdZT8tmtoToheAj7p27omikLKmlhxwjXq2iBy2YxumwEvolVn4mo/cur4uC6uWlmPc
         lNTpqauJxBBVYMaykKPY7XS7uybQRuZa2o5BmVsWj3puxKpylRSdlv8/pdTFv6aAre0/
         0+rUZ7p1npgc+8aX/Wc8Ygw2HJE13cBtaluhw4z9F5ysk69vb2lIWl7NR+u7ViVEgREb
         YbWOwCVFxuqaYb9g3gnVDwb8givvJSaAHBcq6KX9Ex+XmO7KTB5G7VfRmTKptHW7w9th
         vdP4TwQA24TMIGdJ7jqx2KkH8393ylL2Oh0FMMyodi38I+ILpJ6uwy3daTwldghf8vBw
         fQ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y6EtP1Qjdh6B95kwSPzSGW2ptWL2ACP203geTKQqyBY=;
        b=RSOB4csf0IvuPDpmKZGOYVcttumhJC0GpFq3kO9J+gJ1hGpv72CIvNqkUu4hwQETKT
         +uxNoimMvvQYwXZ5h/iBKHMT7AD8e+1bEk/gPyVaA2cjkTYhUvPAKNh6Zd3oMU+yI/5j
         2g4AruWkE4IXrPUgn6e1bYNbpqYWCd5SGSPolwyRcW4OtA4rFfmpEml5aCahRyTPiSfo
         SPoXMiY65hyrSobh80AOYLpTeY0vzwM6fqARMPLJ2EKH+2Do++aR8uy9iYl9dzqx04Y2
         q1jVsTROj5BPXuY3siFVAxNoC5ozsWrp35TFE2+4MfcgDmf5s8JEy2nXPO/njaYOsuNk
         6C4Q==
X-Gm-Message-State: ANoB5plT200gjCow3bFKmmdbyax5Vi90S4A5JKCP9DylUnKK8wkUSZrP
        kn7T7oP/grUbB7ZvnBj868up7tpFo9xlwO/T/i8erA==
X-Google-Smtp-Source: AA0mqf6BbgpCCuOcPrqGy/gyr6/MVU6fFyhe2rCEYLEZczasQW/VPxTjEDNRvOfikCgJ+r+VIXnXt/zM3irAjVm8vpo=
X-Received: by 2002:a63:4a21:0:b0:46f:d9f:476 with SMTP id x33-20020a634a21000000b0046f0d9f0476mr4509621pga.468.1668239754753;
 Fri, 11 Nov 2022 23:55:54 -0800 (PST)
MIME-Version: 1.0
References: <20221107085435.2581641-1-maz@kernel.org> <20221107085435.2581641-3-maz@kernel.org>
In-Reply-To: <20221107085435.2581641-3-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 11 Nov 2022 23:55:38 -0800
Message-ID: <CAAeT=FwNKZhc=a4Jggw-ENL=9G26QTU7OsRbHd2+F+=ZTPt24w@mail.gmail.com>
Subject: Re: [PATCH v3 02/14] KVM: arm64: PMU: Align chained counter
 implementation with architecture pseudocode
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Mon, Nov 7, 2022 at 12:54 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Ricardo recently pointed out that the PMU chained counter emulation
> in KVM wasn't quite behaving like the one on actual hardware, in
> the sense that a chained counter would expose an overflow on
> both halves of a chained counter, while KVM would only expose the
> overflow on the top half.
>
> The difference is subtle, but significant. What does the architecture
> say (DDI0087 H.a):
>
> - Up to PMUv3p4, all counters but the cycle counter are 32bit
>
> - A 32bit counter that overflows generates a CHAIN event on the
>   adjacent counter after exposing its own overflow status
>
> - The CHAIN event is accounted if the counter is correctly
>   configured (CHAIN event selected and counter enabled)
>
> This all means that our current implementation (which uses 64bit
> perf events) prevents us from emulating this overflow on the lower half.
>
> How to fix this? By implementing the above, to the letter.
>
> This largly results in code deletion, removing the notions of
> "counter pair", "chained counters", and "canonical counter".
> The code is further restructured to make the CHAIN handling similar
> to SWINC, as the two are now extremely similar in behaviour.
>
> Reported-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 312 ++++++++++----------------------------
>  include/kvm/arm_pmu.h     |   2 -
>  2 files changed, 83 insertions(+), 231 deletions(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 0003c7d37533..a38b3127f649 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -15,16 +15,14 @@
>  #include <kvm/arm_pmu.h>
>  #include <kvm/arm_vgic.h>
>
> +#define PERF_ATTR_CFG1_COUNTER_64BIT   BIT(0)

Although this isn't the new code (but just a name change),
wouldn't it be nicer to have armv8pmu_event_is_64bit()
(in arch/arm64/kernel/perf_event.c) use the macro as well ?

> +
>  DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
>
>  static LIST_HEAD(arm_pmus);
>  static DEFINE_MUTEX(arm_pmus_lock);
>
>  static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
> -static void kvm_pmu_update_pmc_chained(struct kvm_vcpu *vcpu, u64 select_idx);
> -static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
> -
> -#define PERF_ATTR_CFG1_KVM_PMU_CHAINED 0x1
>
>  static u32 kvm_pmu_event_mask(struct kvm *kvm)
>  {
> @@ -57,6 +55,11 @@ static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
>                 __vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
>  }
>
> +static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
> +{
> +       return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX);
> +}
> +
>  static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
>  {
>         struct kvm_pmu *pmu;
> @@ -69,91 +72,22 @@ static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
>  }
>
>  /**
> - * kvm_pmu_pmc_is_chained - determine if the pmc is chained
> - * @pmc: The PMU counter pointer
> - */
> -static bool kvm_pmu_pmc_is_chained(struct kvm_pmc *pmc)
> -{
> -       struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
> -
> -       return test_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
> -}
> -
> -/**
> - * kvm_pmu_idx_is_high_counter - determine if select_idx is a high/low counter
> - * @select_idx: The counter index
> - */
> -static bool kvm_pmu_idx_is_high_counter(u64 select_idx)
> -{
> -       return select_idx & 0x1;
> -}
> -
> -/**
> - * kvm_pmu_get_canonical_pmc - obtain the canonical pmc
> - * @pmc: The PMU counter pointer
> - *
> - * When a pair of PMCs are chained together we use the low counter (canonical)
> - * to hold the underlying perf event.
> - */
> -static struct kvm_pmc *kvm_pmu_get_canonical_pmc(struct kvm_pmc *pmc)
> -{
> -       if (kvm_pmu_pmc_is_chained(pmc) &&
> -           kvm_pmu_idx_is_high_counter(pmc->idx))
> -               return pmc - 1;
> -
> -       return pmc;
> -}
> -static struct kvm_pmc *kvm_pmu_get_alternate_pmc(struct kvm_pmc *pmc)
> -{
> -       if (kvm_pmu_idx_is_high_counter(pmc->idx))
> -               return pmc - 1;
> -       else
> -               return pmc + 1;
> -}
> -
> -/**
> - * kvm_pmu_idx_has_chain_evtype - determine if the event type is chain
> + * kvm_pmu_get_counter_value - get PMU counter value
>   * @vcpu: The vcpu pointer
>   * @select_idx: The counter index
>   */
> -static bool kvm_pmu_idx_has_chain_evtype(struct kvm_vcpu *vcpu, u64 select_idx)
> -{
> -       u64 eventsel, reg;
> -
> -       select_idx |= 0x1;
> -
> -       if (select_idx == ARMV8_PMU_CYCLE_IDX)
> -               return false;
> -
> -       reg = PMEVTYPER0_EL0 + select_idx;
> -       eventsel = __vcpu_sys_reg(vcpu, reg) & kvm_pmu_event_mask(vcpu->kvm);
> -
> -       return eventsel == ARMV8_PMUV3_PERFCTR_CHAIN;
> -}
> -
> -/**
> - * kvm_pmu_get_pair_counter_value - get PMU counter value
> - * @vcpu: The vcpu pointer
> - * @pmc: The PMU counter pointer
> - */
> -static u64 kvm_pmu_get_pair_counter_value(struct kvm_vcpu *vcpu,
> -                                         struct kvm_pmc *pmc)
> +u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>  {
> -       u64 counter, counter_high, reg, enabled, running;
> -
> -       if (kvm_pmu_pmc_is_chained(pmc)) {
> -               pmc = kvm_pmu_get_canonical_pmc(pmc);
> -               reg = PMEVCNTR0_EL0 + pmc->idx;
> +       u64 counter, reg, enabled, running;
> +       struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +       struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>
> -               counter = __vcpu_sys_reg(vcpu, reg);
> -               counter_high = __vcpu_sys_reg(vcpu, reg + 1);
> +       if (!kvm_vcpu_has_pmu(vcpu))
> +               return 0;
>
> -               counter = lower_32_bits(counter) | (counter_high << 32);
> -       } else {
> -               reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> -                     ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> -               counter = __vcpu_sys_reg(vcpu, reg);
> -       }
> +       reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> +               ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> +       counter = __vcpu_sys_reg(vcpu, reg);
>
>         /*
>          * The real counter value is equal to the value of counter register plus
> @@ -163,29 +97,7 @@ static u64 kvm_pmu_get_pair_counter_value(struct kvm_vcpu *vcpu,
>                 counter += perf_event_read_value(pmc->perf_event, &enabled,
>                                                  &running);
>
> -       return counter;
> -}
> -
> -/**
> - * kvm_pmu_get_counter_value - get PMU counter value
> - * @vcpu: The vcpu pointer
> - * @select_idx: The counter index
> - */
> -u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> -{
> -       u64 counter;
> -       struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -       struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> -
> -       if (!kvm_vcpu_has_pmu(vcpu))
> -               return 0;
> -
> -       counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
> -
> -       if (kvm_pmu_pmc_is_chained(pmc) &&
> -           kvm_pmu_idx_is_high_counter(select_idx))
> -               counter = upper_32_bits(counter);
> -       else if (select_idx != ARMV8_PMU_CYCLE_IDX)
> +       if (select_idx != ARMV8_PMU_CYCLE_IDX)

Nit:Using 'pmc->idx' instead of 'select_idx' appears to be more consistent.


>                 counter = lower_32_bits(counter);
>
>         return counter;
> @@ -218,7 +130,6 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>   */
>  static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
>  {
> -       pmc = kvm_pmu_get_canonical_pmc(pmc);
>         if (pmc->perf_event) {
>                 perf_event_disable(pmc->perf_event);
>                 perf_event_release_kernel(pmc->perf_event);
> @@ -236,11 +147,10 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  {
>         u64 counter, reg, val;
>
> -       pmc = kvm_pmu_get_canonical_pmc(pmc);
>         if (!pmc->perf_event)
>                 return;
>
> -       counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
> +       counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
>
>         if (pmc->idx == ARMV8_PMU_CYCLE_IDX) {
>                 reg = PMCCNTR_EL0;
> @@ -252,9 +162,6 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>
>         __vcpu_sys_reg(vcpu, reg) = val;
>
> -       if (kvm_pmu_pmc_is_chained(pmc))
> -               __vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
> -
>         kvm_pmu_release_perf_event(pmc);
>  }
>
> @@ -285,8 +192,6 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
>
>         for_each_set_bit(i, &mask, 32)
>                 kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
> -
> -       bitmap_zero(vcpu->arch.pmu.chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
>  }
>
>  /**
> @@ -340,11 +245,8 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>
>                 pmc = &pmu->pmc[i];
>
> -               /* A change in the enable state may affect the chain state */
> -               kvm_pmu_update_pmc_chained(vcpu, i);
>                 kvm_pmu_create_perf_event(vcpu, i);
>
> -               /* At this point, pmc must be the canonical */
>                 if (pmc->perf_event) {
>                         perf_event_enable(pmc->perf_event);
>                         if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
> @@ -375,11 +277,8 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>
>                 pmc = &pmu->pmc[i];
>
> -               /* A change in the enable state may affect the chain state */
> -               kvm_pmu_update_pmc_chained(vcpu, i);
>                 kvm_pmu_create_perf_event(vcpu, i);

Do we still need to call kvm_pmu_update_pmc_chained() here even
with this patch ? (I would think the reason why the function was
called here was because the chain state change could affect the
backed perf event attribute before).
I have the same comment for kvm_pmu_enable_counter_mask().


>
> -               /* At this point, pmc must be the canonical */
>                 if (pmc->perf_event)
>                         perf_event_disable(pmc->perf_event);
>         }
> @@ -484,6 +383,48 @@ static void kvm_pmu_perf_overflow_notify_vcpu(struct irq_work *work)
>         kvm_vcpu_kick(vcpu);
>  }
>
> +/*
> + * Perform an increment on any of the counters described in @mask,
> + * generating the overflow if required, and propagate it as a chained
> + * event if possible.
> + */
> +static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
> +                                     unsigned long mask, u32 event)
> +{
> +       int i;
> +
> +       if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
> +               return;
> +
> +       /* Weed out disabled counters */
> +       mask &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
> +
> +       for_each_set_bit(i, &mask, ARMV8_PMU_CYCLE_IDX) {
> +               u64 type, reg;
> +
> +               /* Filter on event type */
> +               type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
> +               type &= kvm_pmu_event_mask(vcpu->kvm);
> +               if (type != event)
> +                       continue;
> +
> +               /* Increment this counter */
> +               reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
> +               reg = lower_32_bits(reg);
> +               __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
> +
> +               if (reg) /* No overflow? move on */
> +                       continue;
> +
> +               /* Mark overflow */
> +               __vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
> +
> +               if (kvm_pmu_counter_can_chain(vcpu, i))
> +                       kvm_pmu_counter_increment(vcpu, BIT(i + 1),
> +                                                 ARMV8_PMUV3_PERFCTR_CHAIN);
> +       }
> +}
> +
>  /**
>   * When the perf event overflows, set the overflow status and inform the vcpu.
>   */
> @@ -514,6 +455,10 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
>
>         __vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(idx);
>
> +       if (kvm_pmu_counter_can_chain(vcpu, idx))
> +               kvm_pmu_counter_increment(vcpu, BIT(idx + 1),
> +                                         ARMV8_PMUV3_PERFCTR_CHAIN);
> +
>         if (kvm_pmu_overflow_status(vcpu)) {
>                 kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>
> @@ -533,50 +478,7 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
>   */
>  void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
>  {
> -       struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -       int i;
> -
> -       if (!kvm_vcpu_has_pmu(vcpu))
> -               return;
> -
> -       if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
> -               return;
> -
> -       /* Weed out disabled counters */
> -       val &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
> -
> -       for (i = 0; i < ARMV8_PMU_CYCLE_IDX; i++) {
> -               u64 type, reg;
> -
> -               if (!(val & BIT(i)))
> -                       continue;
> -
> -               /* PMSWINC only applies to ... SW_INC! */
> -               type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
> -               type &= kvm_pmu_event_mask(vcpu->kvm);
> -               if (type != ARMV8_PMUV3_PERFCTR_SW_INCR)
> -                       continue;
> -
> -               /* increment this even SW_INC counter */
> -               reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
> -               reg = lower_32_bits(reg);
> -               __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
> -
> -               if (reg) /* no overflow on the low part */
> -                       continue;
> -
> -               if (kvm_pmu_pmc_is_chained(&pmu->pmc[i])) {
> -                       /* increment the high counter */
> -                       reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i + 1) + 1;
> -                       reg = lower_32_bits(reg);
> -                       __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i + 1) = reg;
> -                       if (!reg) /* mark overflow on the high counter */
> -                               __vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i + 1);
> -               } else {
> -                       /* mark overflow on low counter */
> -                       __vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
> -               }
> -       }
> +       kvm_pmu_counter_increment(vcpu, val, ARMV8_PMUV3_PERFCTR_SW_INCR);
>  }
>
>  /**
> @@ -625,18 +527,11 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  {
>         struct arm_pmu *arm_pmu = vcpu->kvm->arch.arm_pmu;
>         struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -       struct kvm_pmc *pmc;
> +       struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>         struct perf_event *event;
>         struct perf_event_attr attr;
>         u64 eventsel, counter, reg, data;
>
> -       /*
> -        * For chained counters the event type and filtering attributes are
> -        * obtained from the low/even counter. We also use this counter to
> -        * determine if the event is enabled/disabled.
> -        */
> -       pmc = kvm_pmu_get_canonical_pmc(&pmu->pmc[select_idx]);
> -
>         reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
>               ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + pmc->idx;
>         data = __vcpu_sys_reg(vcpu, reg);
> @@ -647,8 +542,12 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>         else
>                 eventsel = data & kvm_pmu_event_mask(vcpu->kvm);
>
> -       /* Software increment event doesn't need to be backed by a perf event */
> -       if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR)
> +       /*
> +        * Neither SW increment nor chained events need to be backed
> +        * by a perf event.
> +        */
> +       if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR ||
> +           eventsel == ARMV8_PMUV3_PERFCTR_CHAIN)
>                 return;
>
>         /*
> @@ -670,30 +569,21 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>         attr.exclude_host = 1; /* Don't count host events */
>         attr.config = eventsel;
>
> -       counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
> +       counter = kvm_pmu_get_counter_value(vcpu, select_idx);

Nit: Since all existing codes in the function use pmc->idx,
I would think it would be better to use 'pmc->idx' instead of
'select_idx' consistently.


> -       if (kvm_pmu_pmc_is_chained(pmc)) {
> -               /**
> -                * The initial sample period (overflow count) of an event. For
> -                * chained counters we only support overflow interrupts on the
> -                * high counter.
> -                */
> +       /*
> +        * If counting with a 64bit counter, advertise it to the perf
> +        * code, carefully dealing with the initial sample period.
> +        */
> +       if (kvm_pmu_idx_is_64bit(vcpu, select_idx)) {

I have the same comments on this as above.

Thank you,
Reiji




> +               attr.config1 |= PERF_ATTR_CFG1_COUNTER_64BIT;
>                 attr.sample_period = (-counter) & GENMASK(63, 0);
> -               attr.config1 |= PERF_ATTR_CFG1_KVM_PMU_CHAINED;
> -
> -               event = perf_event_create_kernel_counter(&attr, -1, current,
> -                                                        kvm_pmu_perf_overflow,
> -                                                        pmc + 1);
>         } else {
> -               /* The initial sample period (overflow count) of an event. */
> -               if (kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
> -                       attr.sample_period = (-counter) & GENMASK(63, 0);
> -               else
> -                       attr.sample_period = (-counter) & GENMASK(31, 0);
> +               attr.sample_period = (-counter) & GENMASK(31, 0);
> +       }
>
> -               event = perf_event_create_kernel_counter(&attr, -1, current,
> +       event = perf_event_create_kernel_counter(&attr, -1, current,
>                                                  kvm_pmu_perf_overflow, pmc);
> -       }
>
>         if (IS_ERR(event)) {
>                 pr_err_once("kvm: pmu event creation failed %ld\n",
> @@ -704,41 +594,6 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>         pmc->perf_event = event;
>  }
>
> -/**
> - * kvm_pmu_update_pmc_chained - update chained bitmap
> - * @vcpu: The vcpu pointer
> - * @select_idx: The number of selected counter
> - *
> - * Update the chained bitmap based on the event type written in the
> - * typer register and the enable state of the odd register.
> - */
> -static void kvm_pmu_update_pmc_chained(struct kvm_vcpu *vcpu, u64 select_idx)
> -{
> -       struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -       struct kvm_pmc *pmc = &pmu->pmc[select_idx], *canonical_pmc;
> -       bool new_state, old_state;
> -
> -       old_state = kvm_pmu_pmc_is_chained(pmc);
> -       new_state = kvm_pmu_idx_has_chain_evtype(vcpu, pmc->idx) &&
> -                   kvm_pmu_counter_is_enabled(vcpu, pmc->idx | 0x1);
> -
> -       if (old_state == new_state)
> -               return;
> -
> -       canonical_pmc = kvm_pmu_get_canonical_pmc(pmc);
> -       kvm_pmu_stop_counter(vcpu, canonical_pmc);
> -       if (new_state) {
> -               /*
> -                * During promotion from !chained to chained we must ensure
> -                * the adjacent counter is stopped and its event destroyed
> -                */
> -               kvm_pmu_stop_counter(vcpu, kvm_pmu_get_alternate_pmc(pmc));
> -               set_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
> -               return;
> -       }
> -       clear_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
> -}
> -
>  /**
>   * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
>   * @vcpu: The vcpu pointer
> @@ -766,7 +621,6 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>
>         __vcpu_sys_reg(vcpu, reg) = data & mask;
>
> -       kvm_pmu_update_pmc_chained(vcpu, select_idx);
>         kvm_pmu_create_perf_event(vcpu, select_idx);
>  }
>
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index c0b868ce6a8f..96b192139a23 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -11,7 +11,6 @@
>  #include <asm/perf_event.h>
>
>  #define ARMV8_PMU_CYCLE_IDX            (ARMV8_PMU_MAX_COUNTERS - 1)
> -#define ARMV8_PMU_MAX_COUNTER_PAIRS    ((ARMV8_PMU_MAX_COUNTERS + 1) >> 1)
>
>  #ifdef CONFIG_HW_PERF_EVENTS
>
> @@ -29,7 +28,6 @@ struct kvm_pmu {
>         struct irq_work overflow_work;
>         struct kvm_pmu_events events;
>         struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
> -       DECLARE_BITMAP(chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
>         int irq_num;
>         bool created;
>         bool irq_level;
> --
> 2.34.1
>
