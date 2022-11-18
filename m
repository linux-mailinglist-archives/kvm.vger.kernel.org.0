Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7864C62EE9C
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 08:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241240AbiKRHpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 02:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiKRHpl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 02:45:41 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E488B103
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 23:45:40 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id g62so4139443pfb.10
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 23:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Gdi9Y0gA2RIvhSzWh83jBN+VndNjkNvj2Yl5/Jq0Qwc=;
        b=Ixr/QfKKvVCY/z813TIOr2kixg8g7Q2tYoA9hXcbYVMP7l60PiwC2W1YE+i9vo4igC
         0CNk3c/yZvjtdnx4JxEGIg5eCNPr8EZ2LzHN8wtYoQ0RDrldnlwqsZ9fsZuT0sXD+KAZ
         MpRwp/AqLjIitmtJtFiTYwszhdw813n7uPfd6nA/Qvecp5C6+KwHJ2JX9hf9flTg4LdS
         Qmpu2P9BqWLb7X9m6N246pZXLBY3Eu0Gxd9JZbWKKOyZ3MMJgUQlTxVogDBWNE8+IL9h
         z/17pZe47npvmxk3P1/pXsnE/TVlDDb9H8tslmpdYGIs3vVyNnKBUcP/9haUGtaQeJ5n
         HNZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gdi9Y0gA2RIvhSzWh83jBN+VndNjkNvj2Yl5/Jq0Qwc=;
        b=6kfpbq9lasnhgCvPRPTD1eWU0WVDBzA8bMS38Qo005mM/DAUNQkiYK8e2+tTbOZMUl
         dmYMC1tOsLnncsjnR0BbSD+xslhW+bu35OqmtD+o9XzgFhRsp5bHbRH5NRlh2Xl8KGoP
         Af3TvyoOigy176vQzF2nd7aA/tTA/RREYxVff+I5tnu3Af67w/f6j8V0YEaL21bCUPss
         Xq4izlYdvC1FHM9PULUtXDn2lYyp6TZPiKq4O8YLYhEtl3CCVH7TRGZ2FqMBqEPfIs1n
         aUedp0/wyljHtPJM8p1o0TIwG0K1CM5SDRrn+FA43hUbDfU3YF7Y2M0T/fNBE7EGXF0z
         tL3A==
X-Gm-Message-State: ANoB5pnYLFuqL+G0Q3mnrFV0D/MfiWY2weH2rphreg7GdwioKt9m5kdn
        0Rv+jYr6gpVV0AQFjkpN3fR6Ir0WMHBzroy2ftQB/w==
X-Google-Smtp-Source: AA0mqf5+Kmp2LJTTHcEFtRf3v9oCJzsEHfPTrRYloeoM4dpAxHCbuDwGxEccdUkQgFawYVyPt2I5kRsljmJH0+N9Z6Y=
X-Received: by 2002:a63:e509:0:b0:474:4380:cca6 with SMTP id
 r9-20020a63e509000000b004744380cca6mr5598521pgh.229.1668757539573; Thu, 17
 Nov 2022 23:45:39 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-10-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-10-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 17 Nov 2022 23:45:23 -0800
Message-ID: <CAAeT=FzvGPs04N8=y2pjBxv_HTgQHwRN8hEsyheu0bi+WJzRQQ@mail.gmail.com>
Subject: Re: [PATCH v4 09/16] KVM: arm64: PMU: Do not let AArch32 change the
 counters' top 32 bits
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
> Even when using PMUv3p5 (which implies 64bit counters), there is
> no way for AArch32 to write to the top 32 bits of the counters.
> The only way to influence these bits (other than by counting
> events) is by writing PMCR.P==1.
>
> Make sure we obey the architecture and preserve the top 32 bits
> on a counter update.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 35 +++++++++++++++++++++++++++--------
>  1 file changed, 27 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index ea0c8411641f..419e5e0a13d0 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -119,13 +119,8 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>         return counter;
>  }
>
> -/**
> - * kvm_pmu_set_counter_value - set PMU counter value
> - * @vcpu: The vcpu pointer
> - * @select_idx: The counter index
> - * @val: The counter value
> - */
> -void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
> +static void kvm_pmu_set_counter(struct kvm_vcpu *vcpu, u64 select_idx, u64 val,
> +                               bool force)
>  {
>         u64 reg;
>
> @@ -135,12 +130,36 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>         kvm_pmu_release_perf_event(&vcpu->arch.pmu.pmc[select_idx]);
>
>         reg = counter_index_to_reg(select_idx);
> +
> +       if (vcpu_mode_is_32bit(vcpu) && select_idx != ARMV8_PMU_CYCLE_IDX &&
> +           !force) {
> +               /*
> +                * Even with PMUv3p5, AArch32 cannot write to the top
> +                * 32bit of the counters. The only possible course of
> +                * action is to use PMCR.P, which will reset them to
> +                * 0 (the only use of the 'force' parameter).
> +                */
> +               val  = lower_32_bits(val);
> +               val |= upper_32_bits(__vcpu_sys_reg(vcpu, reg));

Shouldn't the result of upper_32_bits() be shifted 32bits left
before ORing (to maintain the upper 32bits of the current value) ?

Thank you,
Reiji

> +       }
> +
>         __vcpu_sys_reg(vcpu, reg) = val;
>
>         /* Recreate the perf event to reflect the updated sample_period */
>         kvm_pmu_create_perf_event(vcpu, select_idx);
>  }
>
> +/**
> + * kvm_pmu_set_counter_value - set PMU counter value
> + * @vcpu: The vcpu pointer
> + * @select_idx: The counter index
> + * @val: The counter value
> + */
> +void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
> +{
> +       kvm_pmu_set_counter(vcpu, select_idx, val, false);
> +}
> +
>  /**
>   * kvm_pmu_release_perf_event - remove the perf event
>   * @pmc: The PMU counter pointer
> @@ -533,7 +552,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
>                 unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
>                 mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
>                 for_each_set_bit(i, &mask, 32)
> -                       kvm_pmu_set_counter_value(vcpu, i, 0);
> +                       kvm_pmu_set_counter(vcpu, i, 0, true);
>         }
>  }
>
> --
> 2.34.1
>
