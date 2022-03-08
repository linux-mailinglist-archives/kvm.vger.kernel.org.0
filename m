Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B02F4D0CD3
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 01:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbiCHAiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 19:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiCHAiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 19:38:05 -0500
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD12B289A1
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 16:37:09 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id j7-20020a4ad6c7000000b0031c690e4123so20086607oot.11
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 16:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ijc7GxRXdA+HmfzmTLANOZDH8XL9NNAM8VDg2IQJGx0=;
        b=a0E3weZ9V8rChd7Z36FqSqgw4r/K94i1aMcmm0f7yN1diV+6YgWZSKihyzekXug7Vh
         OQKHuPZ9RZZhldYbxYXNihh3ghZLaP9xbD/0jH1lOkRy2pbIhr0FA/bKHwRXEDHMKxev
         HOrt4gcnRT0u+/vlRLZE0NjfI9uZtoF6CzZXM0sGWkFMUyJhcro/BaSdt2kFpQpubWBQ
         mv1DDpJjG9/tTpmwZBHdzuh0mZz6BE4Ee3CYEQj6sZOryQqmlL1qMkPNAkzlY6KBa0Lo
         L3z5HjJTwT0IIFxG5LMnxcgwqwDUVrGFJIq6ufs8yk7dUKZpUAL+3gudRiRTUdNFEZAu
         aUZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ijc7GxRXdA+HmfzmTLANOZDH8XL9NNAM8VDg2IQJGx0=;
        b=pdJScWIafvBAkPgJfWow9+i1oKitj/Z9mgR7P+4E4VS1lu1F/GqRc7Dkte7ivWeS9f
         HpziG6N2UsPi/+CkAmdlcwOvt27F+qZhpZ8ts6VDOx/kAVXRFbGrzsxg4hUSKUiskoHq
         TKRca6orUc5GvNUbK86wghBPkFMhyNkEiEGDPxlNqWUj3ztgJHwg26rZtNHJLHPrQE+M
         omvpAvv5Om6w9SxNkb8NXgHTmrrkokeEcYrNqT4gFZKWilwDaJhGM6EDPAgv+Wn7ErxT
         EqLivoy2+9RMEazP5LnfKqCXNZBZWWol4Sj3gcTJ0p88uk+9uKYFVk7m6UwKk+Hnhp7D
         pEKw==
X-Gm-Message-State: AOAM533E7UjOwtfJoTuv9FnQ++ulBHsP9GKe1mIonSX2lv0RXpQ5Gy0N
        bSvfxKkGGZXoD+5VQca4rwakol3SUm5tSMFFQHg37A==
X-Google-Smtp-Source: ABdhPJwt8fuIzjjOdXl6gzTequQN2CdAIk2Wdm0n8JHCzPGB/LeovNgLZ+MbK2C0pZrT8h0jGkzgwJDDztjooLzvolM=
X-Received: by 2002:a05:6870:1041:b0:d3:521b:f78a with SMTP id
 1-20020a056870104100b000d3521bf78amr945118oaj.13.1646699828901; Mon, 07 Mar
 2022 16:37:08 -0800 (PST)
MIME-Version: 1.0
References: <20220302111334.12689-1-likexu@tencent.com> <20220302111334.12689-8-likexu@tencent.com>
In-Reply-To: <20220302111334.12689-8-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 7 Mar 2022 16:36:57 -0800
Message-ID: <CALMp9eQtzS6HEHZ4__K9VuG+-Duwt5uUFb_FcW4DaBKPDmcYkA@mail.gmail.com>
Subject: Re: [PATCH v2 07/12] KVM: x86/pmu: Use PERF_TYPE_RAW to merge
 reprogram_{gp, fixed}counter()
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 2, 2022 at 3:14 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> From: Like Xu <likexu@tencent.com>
>
> The code sketch for reprogram_{gp, fixed}_counter() is similar, while the
> fixed counter using the PERF_TYPE_HARDWAR type and the gp being
> able to use either PERF_TYPE_HARDWAR or PERF_TYPE_RAW type
> depending on the pmc->eventsel value.
>
> After 'commit 761875634a5e ("KVM: x86/pmu: Setup pmc->eventsel
> for fixed PMCs")', the pmc->eventsel of the fixed counter will also have
> been setup with the same semantic value and will not be changed during
> the guest runtime. But essentially, "the HARDWARE is just a convenience
> wrapper over RAW IIRC", quoated from Peterz. So it could be pretty safe
> to use the PERF_TYPE_RAW type only to program both gp and fixed
> counters naturally in the reprogram_counter().
>
> To make the gp and fixed counters more semantically symmetrical,
> the selection of EVENTSEL_{USER, OS, INT} bits is temporarily translated
> via fixed_ctr_ctrl before the pmc_reprogram_counter() call.
>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/pmu.c           | 128 +++++++++++++----------------------
>  arch/x86/kvm/vmx/pmu_intel.c |   2 +-
>  2 files changed, 47 insertions(+), 83 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 5299488b002c..00e1660c10ca 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -215,85 +215,60 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
>         return allow_event;
>  }
>
> -static void reprogram_gp_counter(struct kvm_pmc *pmc)
> -{
> -       u64 config;
> -       u32 type = PERF_TYPE_RAW;
> -       u64 eventsel = pmc->eventsel;
> -
> -       if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
> -               printk_once("kvm pmu: pin control bit is ignored\n");
> -
> -       pmc_pause_counter(pmc);
> -
> -       if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE) || !pmc_is_enabled(pmc))
> -               return;
> -
> -       if (!check_pmu_event_filter(pmc))
> -               return;
> -
> -       if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
> -                         ARCH_PERFMON_EVENTSEL_INV |
> -                         ARCH_PERFMON_EVENTSEL_CMASK |
> -                         HSW_IN_TX |
> -                         HSW_IN_TX_CHECKPOINTED))) {
> -               config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
> -               if (config != PERF_COUNT_HW_MAX)
> -                       type = PERF_TYPE_HARDWARE;
> -       }
> -
> -       if (type == PERF_TYPE_RAW)
> -               config = eventsel & AMD64_RAW_EVENT_MASK;
> -
> -       if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
> -               return;
> -
> -       pmc_release_perf_event(pmc);
> -
> -       pmc->current_config = eventsel;
> -       pmc_reprogram_counter(pmc, type, config,
> -                             !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
> -                             !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
> -                             eventsel & ARCH_PERFMON_EVENTSEL_INT,
> -                             (eventsel & HSW_IN_TX),
> -                             (eventsel & HSW_IN_TX_CHECKPOINTED));
> -}
> -
> -static void reprogram_fixed_counter(struct kvm_pmc *pmc)
> +static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
>  {
>         struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> -       int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
> -       u8 ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl, idx);
> -       unsigned en_field = ctrl & 0x3;
> -       bool pmi = ctrl & 0x8;
>
> -       pmc_pause_counter(pmc);
> +       if (pmc_is_fixed(pmc))
> +               return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
> +                       pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
>
> -       if (!en_field || !pmc_is_enabled(pmc))
> -               return;
> -
> -       if (!check_pmu_event_filter(pmc))
> -               return;
> -
> -       if (pmc->current_config == (u64)ctrl && pmc_resume_counter(pmc))
> -               return;
> -
> -       pmc_release_perf_event(pmc);
> -
> -       pmc->current_config = (u64)ctrl;
> -       pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
> -                             kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc),
> -                             !(en_field & 0x2), /* exclude user */
> -                             !(en_field & 0x1), /* exclude kernel */
> -                             pmi, false, false);
> +       return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
>  }
>
>  void reprogram_counter(struct kvm_pmc *pmc)
>  {
> -       if (pmc_is_gp(pmc))
> -               reprogram_gp_counter(pmc);
> -       else
> -               reprogram_fixed_counter(pmc);
> +       struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> +       u64 eventsel = pmc->eventsel;
> +       u64 new_config = eventsel;
> +       u8 fixed_ctr_ctrl;
> +
> +       pmc_pause_counter(pmc);
> +
> +       if (!pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
> +               return;
> +
> +       if (!check_pmu_event_filter(pmc))
> +               return;
> +
> +       if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
> +               printk_once("kvm pmu: pin control bit is ignored\n");
> +
> +       if (pmc_is_fixed(pmc)) {
> +               fixed_ctr_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl,
> +                                                 pmc->idx - INTEL_PMC_IDX_FIXED);
> +               if (fixed_ctr_ctrl & 0x1)
> +                       eventsel |= ARCH_PERFMON_EVENTSEL_OS;
> +               if (fixed_ctr_ctrl & 0x2)
> +                       eventsel |= ARCH_PERFMON_EVENTSEL_USR;
> +               if (fixed_ctr_ctrl & 0x8)
> +                       eventsel |= ARCH_PERFMON_EVENTSEL_INT;
> +               new_config = (u64)fixed_ctr_ctrl;
> +       }
> +
> +       if (pmc->current_config == new_config && pmc_resume_counter(pmc))
> +               return;
> +
> +       pmc_release_perf_event(pmc);
> +
> +       pmc->current_config = new_config;
> +       pmc_reprogram_counter(pmc, PERF_TYPE_RAW,
> +                       (eventsel & AMD64_RAW_EVENT_MASK),
> +                       !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
> +                       !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
> +                       eventsel & ARCH_PERFMON_EVENTSEL_INT,
> +                       (eventsel & HSW_IN_TX),
> +                       (eventsel & HSW_IN_TX_CHECKPOINTED));

It seems that this extremely long argument list was motivated by the
differences between the two original call sites. Now that you have
mocked up a full eventsel (with USR, OS, INT, IN_TX, and IN_TXCP bits)
for the fixed counters, why not pass the entire eventsel as the third
argument and drop all of the rest? Then, pmc_reprogram_counter() can
extract/check the bits of interest.

>  }
>  EXPORT_SYMBOL_GPL(reprogram_counter);
>
> @@ -451,17 +426,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
>         kvm_pmu_refresh(vcpu);
>  }
>
> -static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
> -{
> -       struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> -
> -       if (pmc_is_fixed(pmc))
> -               return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
> -                       pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
> -
> -       return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
> -}
> -
>  /* Release perf_events for vPMCs that have been unused for a full time slice.  */
>  void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 19b78a9d9d47..d823fbe4e155 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -492,7 +492,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>         pmu->reserved_bits = 0xffffffff00200000ull;
>
>         entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
> -       if (!entry || !vcpu->kvm->arch.enable_pmu)
> +       if (!entry || !vcpu->kvm->arch.enable_pmu || !boot_cpu_has(X86_FEATURE_ARCH_PERFMON))

This change seems unrelated.

>                 return;
>         eax.full = entry->eax;
>         edx.full = entry->edx;
> --
> 2.35.1
>
