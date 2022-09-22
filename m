Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED645E573B
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 02:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiIVAUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 20:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiIVAUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 20:20:34 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C6D9F188
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 17:20:32 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-11eab59db71so11544539fac.11
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 17:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=YsFo3p6L+p9ZptPsL/RpVYOo9zqwVJ/mpKD/KZaXPsU=;
        b=CVNdiM8vIjMgYamfc7SqaptjOzdVzh6gZ/Shpe+s/yr9WvXmJ7EKEW7f8xnDra2yyc
         yf3WqAQdlUOrxBDGpJBR0L2ofjK3DaM9HgThUft9GVX9IuZwR2i+/3yH0sNgCj7w26JQ
         HsKNOHB0gWvwNdZ+q2v6uCgkiZ8YHqAHKa4Gz39uYZxVyZqagVkGH2JUmAbXdETKjXZ0
         nvSHO9/7SQOK2twQiI4jU15PI66/ceJEs3ls3O5rrvTtIGDKPcGj2T63jg0jPWoIM4KB
         z09Hf3Mp8Sp+k4Q7TRS8qIQVFjHM5CNKimeRngKmEs82cht8sxOdj665xW5JXgeJxaCg
         KOlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=YsFo3p6L+p9ZptPsL/RpVYOo9zqwVJ/mpKD/KZaXPsU=;
        b=f6FpsT36sM2gDi/w8POSWo0WDOOfkt93B+dxHGdRttazqHlD08FE+l4reccCFyMXVv
         zh6EkLk5iFmtq/7crFRqX+4IBUG6LyCzoFRTb9aeQe5XTBcm/KwXtMrByp3fDGMBGpPP
         7ja3XCA090uqTmri6heBgr7dnpy24axsSrZPb6Yw/tWEJD7XaBn8pbboQuRtcLLlOX26
         rDlvmWiN5gyulmv0ujJX1ERDitgci0MjJkc+D5g6jyHKc1iS90H7bp2Carb9pwh0XD+O
         eUNHNvMjme4QL3kdgYduSeINQiyrWCXCu4tTfgyz8J1s46kOqucR1ew4gXSyWETzSgAU
         mFrg==
X-Gm-Message-State: ACrzQf33X6zp6Krws6H9KcBslRppcKcZUKfpMe9d8mYrci3U3TcuSh9Y
        TyBKzVViDc/y0YxvYp44jaaF6vp76a9WE/b7hsufhQ==
X-Google-Smtp-Source: AMsMyM4nSe0iV056Ag13Oz/X+BUKo24nQkF+am8IfSBS8HJOv8cBc9qtHQFmDP/UzYe3yPZnwsKHSqb2u0lxUQK9apo=
X-Received: by 2002:a05:6870:580c:b0:12a:f136:a8f5 with SMTP id
 r12-20020a056870580c00b0012af136a8f5mr6497974oap.269.1663806031338; Wed, 21
 Sep 2022 17:20:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220919093453.71737-1-likexu@tencent.com> <20220919093453.71737-2-likexu@tencent.com>
In-Reply-To: <20220919093453.71737-2-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 21 Sep 2022 17:20:20 -0700
Message-ID: <CALMp9eRPEFHFfW+MnMkcTBFB+vjcEe3ekg8JMrKJaRQuq7=-8Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: x86/pmu: Make part of the Intel v2 PMU MSRs
 handling x86 generic
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 19, 2022 at 2:35 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> From: Like Xu <likexu@tencent.com>
>
> The AMD PerfMonV2 defines three registers similar to part of the
> Intel v2 PMU registers, including the GLOBAL_CTRL, GLOBAL_STATUS
> and GLOBAL_OVF_CTRL MSRs. For better code reuse, this specific
> part of the handling can be extracted to make it generic for X86.
>
> The new non-prefix pmc_is_enabled() works well as legacy AMD vPMU
> version is indexeqd as 1. Note that the specific *_is_valid_msr will
Nit: indexed
> continue to be used to avoid cross-vendor msr access.
>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 -
>  arch/x86/kvm/pmu.c                     | 55 +++++++++++++++++++++---
>  arch/x86/kvm/pmu.h                     | 30 ++++++++++++-
>  arch/x86/kvm/svm/pmu.c                 |  9 ----
>  arch/x86/kvm/vmx/pmu_intel.c           | 58 +-------------------------
>  5 files changed, 80 insertions(+), 73 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> index c17e3e96fc1d..6c98f4bb4228 100644
> --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> @@ -13,7 +13,6 @@ BUILD_BUG_ON(1)
>   * at the call sites.
>   */
>  KVM_X86_PMU_OP(hw_event_available)
> -KVM_X86_PMU_OP(pmc_is_enabled)
>  KVM_X86_PMU_OP(pmc_idx_to_pmc)
>  KVM_X86_PMU_OP(rdpmc_ecx_to_pmc)
>  KVM_X86_PMU_OP(msr_idx_to_pmc)
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index fabbc43031b3..2643a3994624 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -83,11 +83,6 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
>  #undef __KVM_X86_PMU_OP
>  }
>
> -static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
> -{
> -       return static_call(kvm_x86_pmu_pmc_is_enabled)(pmc);
> -}
> -
>  static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
>  {
>         struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
> @@ -455,11 +450,61 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
>
>  int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
> +       struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +       u32 msr = msr_info->index;
> +
> +       switch (msr) {
> +       case MSR_CORE_PERF_GLOBAL_STATUS:
> +               msr_info->data = pmu->global_status;
> +               return 0;
> +       case MSR_CORE_PERF_GLOBAL_CTRL:
> +               msr_info->data = pmu->global_ctrl;
> +               return 0;
> +       case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> +               msr_info->data = 0;
> +               return 0;
> +       default:
> +               break;
> +       }
> +
>         return static_call(kvm_x86_pmu_get_msr)(vcpu, msr_info);
>  }
>
>  int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
> +       struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +       u32 msr = msr_info->index;
> +       u64 data = msr_info->data;
> +       u64 diff;
> +
> +       switch (msr) {
> +       case MSR_CORE_PERF_GLOBAL_STATUS:
> +               if (msr_info->host_initiated) {
> +                       pmu->global_status = data;
> +                       return 0;
> +               }
> +               break; /* RO MSR */
Perhaps 'return 1'?
> +       case MSR_CORE_PERF_GLOBAL_CTRL:
> +               if (pmu->global_ctrl == data)
> +                       return 0;
> +               if (kvm_valid_perf_global_ctrl(pmu, data)) {
> +                       diff = pmu->global_ctrl ^ data;
> +                       pmu->global_ctrl = data;
> +                       reprogram_counters(pmu, diff);
> +                       return 0;
> +               }
> +               break;
Perhaps 'return 1'?
> +       case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> +               if (!(data & pmu->global_ovf_ctrl_mask)) {
> +                       if (!msr_info->host_initiated)
> +                               pmu->global_status &= ~data;
> +                       return 0;
> +               }
> +               break;
Perhaps 'return 1'?
> +       default:
> +               break;
> +       }
> +
>         kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
>         return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
>  }
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 847e7112a5d3..0275f1bff5ea 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -26,7 +26,6 @@ struct kvm_event_hw_type_mapping {
>
>  struct kvm_pmu_ops {
>         bool (*hw_event_available)(struct kvm_pmc *pmc);
> -       bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
>         struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
>         struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
>                 unsigned int idx, u64 *mask);
> @@ -189,6 +188,35 @@ static inline void kvm_pmu_request_counter_reprogam(struct kvm_pmc *pmc)
>         kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
>  }
>
> +/*
> + * Check if a PMC is enabled by comparing it against global_ctrl bits.
> + *
> + * If the current version of vPMU doesn't have global_ctrl MSR,
> + * all vPMCs are enabled (return TRUE).

The name of this function is a bit misleading. A PMC can be disabled
either by PERF_CLOBAL_CTRL or by its corresponding EVTSEL.

> + */
> +static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
> +{
> +       struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> +
> +       if (pmu->version < 2)
> +               return true;
> +
> +       return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
> +}
> +
> +static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
> +{
> +       int bit;
> +
> +       if (!diff)
> +               return;
> +
> +       for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX)
> +               __set_bit(bit, pmu->reprogram_pmi);

I see that you've dropped the index to pmc conversion and the test for
a valid pmc. Maybe this is okay, but I'm not sure what the caller
looks like, since this is all in global_ctrl_changed() upstream.
What's your diff base?

> +
> +       kvm_make_request(KVM_REQ_PMU, pmu_to_vcpu(pmu));

Why this new request? It's not in the Intel-specific version of these
function that you elide below.

Perhaps you could split up the semantic changes from the simple renamings?

> +}
> +
>  void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
>  void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
>  int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index f99f2c869664..3a20972e9f1a 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -76,14 +76,6 @@ static bool amd_hw_event_available(struct kvm_pmc *pmc)
>         return true;
>  }
>
> -/* check if a PMC is enabled by comparing it against global_ctrl bits. Because
> - * AMD CPU doesn't have global_ctrl MSR, all PMCs are enabled (return TRUE).
> - */
> -static bool amd_pmc_is_enabled(struct kvm_pmc *pmc)
> -{
> -       return true;
> -}
> -
>  static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
>  {
>         struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -218,7 +210,6 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
>
>  struct kvm_pmu_ops amd_pmu_ops __initdata = {
>         .hw_event_available = amd_hw_event_available,
> -       .pmc_is_enabled = amd_pmc_is_enabled,
>         .pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
>         .rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
>         .msr_idx_to_pmc = amd_msr_idx_to_pmc,
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 612c89ef5398..12eb2edfe9bc 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -68,18 +68,6 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
>         }
>  }
>
> -static void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
> -{
> -       int bit;
> -       struct kvm_pmc *pmc;
> -
> -       for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX) {
> -               pmc = intel_pmc_idx_to_pmc(pmu, bit);
> -               if (pmc)
> -                       kvm_pmu_request_counter_reprogam(pmc);
> -       }
> -}
> -
>  static bool intel_hw_event_available(struct kvm_pmc *pmc)
>  {
>         struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> @@ -102,17 +90,6 @@ static bool intel_hw_event_available(struct kvm_pmc *pmc)
>         return true;
>  }
>
> -/* check if a PMC is enabled by comparing it with globl_ctrl bits. */
> -static bool intel_pmc_is_enabled(struct kvm_pmc *pmc)
> -{
> -       struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> -
> -       if (!intel_pmu_has_perf_global_ctrl(pmu))
> -               return true;
> -
> -       return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
> -}
> -
>  static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
>  {
>         struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -347,15 +324,6 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>         case MSR_CORE_PERF_FIXED_CTR_CTRL:
>                 msr_info->data = pmu->fixed_ctr_ctrl;
>                 return 0;
> -       case MSR_CORE_PERF_GLOBAL_STATUS:
> -               msr_info->data = pmu->global_status;
> -               return 0;
> -       case MSR_CORE_PERF_GLOBAL_CTRL:
> -               msr_info->data = pmu->global_ctrl;
> -               return 0;
> -       case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> -               msr_info->data = 0;
> -               return 0;
>         case MSR_IA32_PEBS_ENABLE:
>                 msr_info->data = pmu->pebs_enable;
>                 return 0;
> @@ -404,29 +372,6 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>                         return 0;
>                 }
>                 break;
> -       case MSR_CORE_PERF_GLOBAL_STATUS:
> -               if (msr_info->host_initiated) {
> -                       pmu->global_status = data;
> -                       return 0;
> -               }
> -               break; /* RO MSR */
> -       case MSR_CORE_PERF_GLOBAL_CTRL:
> -               if (pmu->global_ctrl == data)
> -                       return 0;
> -               if (kvm_valid_perf_global_ctrl(pmu, data)) {
> -                       diff = pmu->global_ctrl ^ data;
> -                       pmu->global_ctrl = data;
> -                       reprogram_counters(pmu, diff);
> -                       return 0;
> -               }
> -               break;
> -       case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> -               if (!(data & pmu->global_ovf_ctrl_mask)) {
> -                       if (!msr_info->host_initiated)
> -                               pmu->global_status &= ~data;
> -                       return 0;
> -               }
> -               break;
>         case MSR_IA32_PEBS_ENABLE:
>                 if (pmu->pebs_enable == data)
>                         return 0;
> @@ -783,7 +728,7 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
>                 pmc = intel_pmc_idx_to_pmc(pmu, bit);
>
>                 if (!pmc || !pmc_speculative_in_use(pmc) ||
> -                   !intel_pmc_is_enabled(pmc) || !pmc->perf_event)
> +                   !pmc_is_enabled(pmc) || !pmc->perf_event)
>                         continue;
>
>                 hw_idx = pmc->perf_event->hw.idx;
> @@ -795,7 +740,6 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
>
>  struct kvm_pmu_ops intel_pmu_ops __initdata = {
>         .hw_event_available = intel_hw_event_available,
> -       .pmc_is_enabled = intel_pmc_is_enabled,
>         .pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
>         .rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
>         .msr_idx_to_pmc = intel_msr_idx_to_pmc,
> --
> 2.37.3
>
