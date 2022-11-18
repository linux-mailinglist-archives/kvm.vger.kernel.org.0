Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBD462ED87
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 07:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241089AbiKRGRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 01:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbiKRGRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 01:17:15 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C579A27E
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 22:17:14 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id v3-20020a17090ac90300b00218441ac0f6so7493241pjt.0
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 22:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O4krRe8XDBdLIpjFY/ER5AqvIQp00WsZTiZcVijc1ZI=;
        b=XpXWPsuUQPdeaSh+PB7FepZiiaCD2ScGfbp3zoh2o1VxOfHYXcccs2zVlSeCXWR482
         pCgoir28+6RM1WCKscSprXI4GSA2g/hw/KzlqPmC6NBRL+R5p7u43tzcfU/SU3udOt5F
         W5I5b+NdertH6JIBi9b5aXaTJH3560AduFVgMy4ZwliolBJZzhKD8XdpUo6oiIRyaItW
         N2/Np8pDGroR8EizlFI11TZViucKHufjUjdFl2pjND/C1f/21Fx1NtiR57VMcrnvKUR3
         X95M8MrtNqshEKXbjTONVOmHRfAIWniYJoRB2jvwUcQC4oQyFdSiEfsThFytQ1yGv4bX
         Hpmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O4krRe8XDBdLIpjFY/ER5AqvIQp00WsZTiZcVijc1ZI=;
        b=4CL240+/raUxPAfSbdMtGfmMvFSkQ19nLa/i10cTCXhoY2tJlult4TPUTGOer9Rakn
         mgU9oo2ADO1pMHRmF1iEvWZYxg8Yt9zpzC+2Z2u8OZUWgyDIzNH6k+765yo9THROFkc3
         MRcDD8e1S0r08IBcNSpwoHO0z3fhRP5Rpz33TP54v7YkXH/zuMWaDcYj1MO+e/uIiopl
         ZiTkyQski9l7ypiw96mK3iTwHui0k1hwS/567pjs6sbPzjEu6ya1UwRUxl0SoFKdssrD
         TAYAowygjjVHEzWTghNj3aee/qzfuCojZknLfeyFWIeE2okZg4qK2U3yytkf1Bp+xgkl
         V0Eg==
X-Gm-Message-State: ANoB5plcPWgxOyMJ8apMwFVYiPjyDmiafYEzLSRXPSfZwNAwe1jRlYUn
        RdnHudetYqfs1NjhUXVZC/l4h1o7sgivxlfkXjYO+aWYT1X2QA==
X-Google-Smtp-Source: AA0mqf6F3NyThYJD8zv8B8XMOE2kYz0CUcnIuV6DoYi9y5eEjTe+8F6Mn2Uq93dJuL2v0dYfk/N2/a1lsRjiy2L+4Kw=
X-Received: by 2002:a17:90a:ab84:b0:213:343:9873 with SMTP id
 n4-20020a17090aab8400b0021303439873mr12284511pjq.102.1668752233721; Thu, 17
 Nov 2022 22:17:13 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-8-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-8-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 17 Nov 2022 22:16:57 -0800
Message-ID: <CAAeT=FysJPMs5mG1E02rMcGtjULb7MviZr6RE699x_a=LZNK6w@mail.gmail.com>
Subject: Re: [PATCH v4 07/16] KVM: arm64: PMU: Add counter_index_to_*reg() helpers
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

On Sun, Nov 13, 2022 at 8:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> In order to reduce the boilerplate code, add two helpers returning
> the counter register index (resp. the event register) in the vcpu
> register file from the counter index.
>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 33 ++++++++++++++++++---------------
>  1 file changed, 18 insertions(+), 15 deletions(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 1fab889dbc74..faab0f57a45d 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -77,6 +77,16 @@ static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
>         return container_of(vcpu_arch, struct kvm_vcpu, arch);
>  }
>
> +static u32 counter_index_to_reg(u64 idx)
> +{
> +       return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + idx;
> +}
> +
> +static u32 counter_index_to_evtreg(u64 idx)
> +{
> +       return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + idx;
> +}

It looks like we could use this function for access_pmu_evtyper()
in arch/arm64/kvm/sys_regs.c as well.

Thank you,
Reiji


> +
>  /**
>   * kvm_pmu_get_counter_value - get PMU counter value
>   * @vcpu: The vcpu pointer
> @@ -91,8 +101,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>         if (!kvm_vcpu_has_pmu(vcpu))
>                 return 0;
>
> -       reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> -               ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> +       reg = counter_index_to_reg(select_idx);
>         counter = __vcpu_sys_reg(vcpu, reg);
>
>         /*
> @@ -122,8 +131,7 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>         if (!kvm_vcpu_has_pmu(vcpu))
>                 return;
>
> -       reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -             ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
> +       reg = counter_index_to_reg(select_idx);
>         __vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
>
>         /* Recreate the perf event to reflect the updated sample_period */
> @@ -158,10 +166,7 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>
>         val = kvm_pmu_get_counter_value(vcpu, pmc->idx);
>
> -       if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> -               reg = PMCCNTR_EL0;
> -       else
> -               reg = PMEVCNTR0_EL0 + pmc->idx;
> +       reg = counter_index_to_reg(pmc->idx);
>
>         __vcpu_sys_reg(vcpu, reg) = val;
>
> @@ -404,16 +409,16 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
>                 u64 type, reg;
>
>                 /* Filter on event type */
> -               type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
> +               type = __vcpu_sys_reg(vcpu, counter_index_to_evtreg(i));
>                 type &= kvm_pmu_event_mask(vcpu->kvm);
>                 if (type != event)
>                         continue;
>
>                 /* Increment this counter */
> -               reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
> +               reg = __vcpu_sys_reg(vcpu, counter_index_to_reg(i)) + 1;
>                 if (!kvm_pmu_idx_is_64bit(vcpu, i))
>                         reg = lower_32_bits(reg);
> -               __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
> +               __vcpu_sys_reg(vcpu, counter_index_to_reg(i)) = reg;
>
>                 /* No overflow? move on */
>                 if (kvm_pmu_idx_has_64bit_overflow(vcpu, i) ? reg : lower_32_bits(reg))
> @@ -549,8 +554,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>         struct perf_event_attr attr;
>         u64 eventsel, counter, reg, data;
>
> -       reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> -             ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + pmc->idx;
> +       reg = counter_index_to_evtreg(select_idx);
>         data = __vcpu_sys_reg(vcpu, reg);
>
>         kvm_pmu_stop_counter(vcpu, pmc);
> @@ -632,8 +636,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>         mask &= ~ARMV8_PMU_EVTYPE_EVENT;
>         mask |= kvm_pmu_event_mask(vcpu->kvm);
>
> -       reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -             ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
> +       reg = counter_index_to_evtreg(select_idx);
>
>         __vcpu_sys_reg(vcpu, reg) = data & mask;
>
> --
> 2.34.1
>
