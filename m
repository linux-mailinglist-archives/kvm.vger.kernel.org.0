Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A7C4AA578
	for <lists+kvm@lfdr.de>; Sat,  5 Feb 2022 02:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378927AbiBEBzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 20:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242053AbiBEBzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 20:55:44 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F53C061346
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 17:55:43 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id u25-20020a4ad0d9000000b002e8d4370689so6680733oor.12
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 17:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hsH4XSzPvplGNuSkHB3Wuw3VI1CbzbgPtHERwTztYTU=;
        b=k+Ar6VYgB1tXJyhXbcDwM3+8R2RK3yTrevfyDo6jWTGg7kG4hdCtRcQF+Y1JO9XGBY
         6sdT9BYf38NTEQELRFDj8kIn1317hb9Pg44IV92CzRnGgFtMBWPh/ex8krLEJ4OFR32g
         yn7pff6De1KqLuHd+rjlZ2qL5OpFtlnn+rgmmFMX1u3M7chUlcKGq/ac8Aj/oqZRhtkA
         WBXFU4YXdzTyeYfZGNdyb5nObWwpA00vVdw6D1md0O3RtDGGL5vRlFScvH5mOwCirVcN
         rhA9hWlAR0hWiIlZTyfxuWwFBGd0C0hoQU4R4YMpjroQI3DoulCy1wfe5p53nyIyY4in
         GShg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hsH4XSzPvplGNuSkHB3Wuw3VI1CbzbgPtHERwTztYTU=;
        b=ZK4ZSNnX48H2kKBjsJ9u3d7xIqHLG99i5dxcOP14iRIqOtip0c9woJht9jQEnEs8YG
         dtRVeNGOoe6y2vfiBqZI5rukn0e1/aUkhTnLfo9avaIH5g9Y2cvSEOO9TY4cmgJZL/07
         LX6kPPax53hw1nnAfGs5CUjxS+oDvQ3nEr/P/9VGdlE2KVYBtPebczs+JXyFZY6d3fzw
         J1leb3cS5mGkeq899AbGY0cyLTJz7N5UuknIxMsQeaFRmUfHOLckBLnfbtGz2tGmFj/U
         t3symbX1/ri5cjjKArxSXle9/NYbANo/N1ALnGtN9GSgYwIO2LooQyzZivx4e45qoBZg
         D8hQ==
X-Gm-Message-State: AOAM530FyzrklvQtGnM3tAhLFh9jbg+1wxKNjtV2jh6A9v+tFYl/CerR
        6GPDiOqf+c1O5nGR44HVAus4L/VtoxLDOkSsMyIB2g==
X-Google-Smtp-Source: ABdhPJy0A+9GRscp1BaRP0N6zCOdlAtZFSTW6xYR0MyWybosHHvdX+gXO40emPtaYzyn8mvUHzK9Y4smLbJChvyPyTw=
X-Received: by 2002:a05:6871:581:: with SMTP id u1mr464555oan.139.1644026142231;
 Fri, 04 Feb 2022 17:55:42 -0800 (PST)
MIME-Version: 1.0
References: <20211130074221.93635-1-likexu@tencent.com> <20211130074221.93635-3-likexu@tencent.com>
In-Reply-To: <20211130074221.93635-3-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 4 Feb 2022 17:55:31 -0800
Message-ID: <CALMp9eQG7eqq+u3igApsRDV=tt0LdjZzmD_dC8zw=gt=f5NjSA@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
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

On Mon, Nov 29, 2021 at 11:42 PM Like Xu <like.xu.linux@gmail.com> wrote:
>
> From: Like Xu <likexu@tencent.com>
>
> The find_arch_event() returns a "unsigned int" value,
> which is used by the pmc_reprogram_counter() to
> program a PERF_TYPE_HARDWARE type perf_event.
>
> The returned value is actually the kernel defined gernic
> perf_hw_id, let's rename it to pmc_perf_hw_id() with simpler
> incoming parameters for better self-explanation.
>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/pmu.c           | 8 +-------
>  arch/x86/kvm/pmu.h           | 3 +--
>  arch/x86/kvm/svm/pmu.c       | 8 ++++----
>  arch/x86/kvm/vmx/pmu_intel.c | 9 +++++----
>  4 files changed, 11 insertions(+), 17 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 09873f6488f7..3b3ccf5b1106 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -174,7 +174,6 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
>  void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>  {
>         unsigned config, type = PERF_TYPE_RAW;
> -       u8 event_select, unit_mask;
>         struct kvm *kvm = pmc->vcpu->kvm;
>         struct kvm_pmu_event_filter *filter;
>         int i;
> @@ -206,17 +205,12 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>         if (!allow_event)
>                 return;
>
> -       event_select = eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
> -       unit_mask = (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
> -
>         if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
>                           ARCH_PERFMON_EVENTSEL_INV |
>                           ARCH_PERFMON_EVENTSEL_CMASK |
>                           HSW_IN_TX |
>                           HSW_IN_TX_CHECKPOINTED))) {
> -               config = kvm_x86_ops.pmu_ops->find_arch_event(pmc_to_pmu(pmc),
> -                                                     event_select,
> -                                                     unit_mask);
> +               config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
>                 if (config != PERF_COUNT_HW_MAX)
>                         type = PERF_TYPE_HARDWARE;
>         }
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 59d6b76203d5..dd7dbb1c5048 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -24,8 +24,7 @@ struct kvm_event_hw_type_mapping {
>  };
>
>  struct kvm_pmu_ops {
> -       unsigned (*find_arch_event)(struct kvm_pmu *pmu, u8 event_select,
> -                                   u8 unit_mask);
> +       unsigned int (*pmc_perf_hw_id)(struct kvm_pmc *pmc);
>         unsigned (*find_fixed_event)(int idx);
>         bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
>         struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 0cf05e4caa4c..fb0ce8cda8a7 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -138,10 +138,10 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
>         return &pmu->gp_counters[msr_to_index(msr)];
>  }
>
> -static unsigned amd_find_arch_event(struct kvm_pmu *pmu,
> -                                   u8 event_select,
> -                                   u8 unit_mask)
> +static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
>  {
> +       u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
On AMD, the event select is 12 bits.
> +       u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
>         int i;
>
>         for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
> @@ -323,7 +323,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
>  }
>
>  struct kvm_pmu_ops amd_pmu_ops = {
> -       .find_arch_event = amd_find_arch_event,
> +       .pmc_perf_hw_id = amd_pmc_perf_hw_id,
>         .find_fixed_event = amd_find_fixed_event,
>         .pmc_is_enabled = amd_pmc_is_enabled,
>         .pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index b7ab5fd03681..67a0188ecdc5 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -68,10 +68,11 @@ static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
>                 reprogram_counter(pmu, bit);
>  }
>
> -static unsigned intel_find_arch_event(struct kvm_pmu *pmu,
> -                                     u8 event_select,
> -                                     u8 unit_mask)
> +static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
>  {
> +       struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> +       u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
> +       u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
>         int i;
>
>         for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++)
> @@ -719,7 +720,7 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
>  }
>
>  struct kvm_pmu_ops intel_pmu_ops = {
> -       .find_arch_event = intel_find_arch_event,
> +       .pmc_perf_hw_id = intel_pmc_perf_hw_id,
>         .find_fixed_event = intel_find_fixed_event,
>         .pmc_is_enabled = intel_pmc_is_enabled,
>         .pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
> --
> 2.33.1
>
