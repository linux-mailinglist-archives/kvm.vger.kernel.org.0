Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E95B5AD85F
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 19:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiIER1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 13:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiIER07 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 13:26:59 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F295D117
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 10:26:57 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-11f11d932a8so22792265fac.3
        for <kvm@vger.kernel.org>; Mon, 05 Sep 2022 10:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=wiTlUO4bKJB5mIc5pzysFouMdeYXvcZN+PGCeIOyA9o=;
        b=gCr1hfUa+/WK1fmjnuj9/t4ayZdVUpXZDUtVROQ/WEHgZNLC7IGzx+3LKMtCELUT0H
         plL3SC4s9Srr1XFrojvRjmQ3DOwIg7ZnG3TfJu1jMo8FOm16+xUdb3G5SEN8Zb4X6yux
         BROrfWmDpVdP8goNUaOSq6OH/BfRGtUGfEmCDm4qoqFwuvLguU8ztSr6mZrdLQ8lbADW
         Fc3PTDN9BbZ2GktdGTg7lTthBwKxsvhBkXLmlD3Qmd1u9gFL3qgvgEbXw8X1/8AGH1bM
         ZYfX4QOHjr0tjNsaNehA+CjRO1qkrAwsmGJVT1LliFYKCmTe6dbmtjaAqynMg3M7SbHy
         cN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=wiTlUO4bKJB5mIc5pzysFouMdeYXvcZN+PGCeIOyA9o=;
        b=PV9+K7etshC5Rrha/M3FKgvE8+TLe1OOenqPDmbECRfZ921tEOslFoc0kUted75/G9
         HtWasxKCM0KHat4/Ipy8I49Ymz4pJBtn50kK0YJOzgAurqx5NAUXZ+1gxFXJ0jxacjWF
         J1Vi6EWyX4H9Cc62I9tiQYY2j/ScGNqM1kzGJbhojHhQ2OlOvvscer2DUXMVRBkFvmaN
         JOSCoCRWhlZYVEu3XYHt0x/sCbLJMdVNcdielPY5qWMNQcCIG5TWk42xVKBKgnG+fnNE
         ULh3TOzsSUGrzH9ZBp7E9PtT9a3NccFpFW/GSrLvLVm1JrQ3IXkXLGMcGiVYppdyDd4u
         vaRQ==
X-Gm-Message-State: ACgBeo2cABeD5qGaNr409kA42VVdAhEFdubmWq+K+afaF4YnbyrfFpXG
        LtS8VY43abpOM4SrGJym+T1irVhrroeTnO0OdkaD3A==
X-Google-Smtp-Source: AA6agR4Q4NmpbQLP9rhwXPUZUIYyMJksRer3zYTGX6tLakGrrlUJx6aeIIeJ1UogkUFjMJlVPnZRdG1x5PfYYNy2lhA=
X-Received: by 2002:a05:6870:41d0:b0:126:5d06:28a5 with SMTP id
 z16-20020a05687041d000b001265d0628a5mr5632497oac.181.1662398817061; Mon, 05
 Sep 2022 10:26:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220905123946.95223-1-likexu@tencent.com> <20220905123946.95223-2-likexu@tencent.com>
In-Reply-To: <20220905123946.95223-2-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 5 Sep 2022 10:26:45 -0700
Message-ID: <CALMp9eR3qSVvVgCVq9qsZkFOxa1mHWaAhZimOd14j30_3fXsZg@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: x86/svm/pmu: Limit the maximum number of
 supported GP counters
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sandipan Das <sandipan.das@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Mon, Sep 5, 2022 at 5:45 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> From: Like Xu <likexu@tencent.com>
>
> The AMD PerfMonV2 specification allows for a maximum of 16 GP counters,
> which is clearly not supported with zero code effort in the current KVM.
>
> A local macro (named like INTEL_PMC_MAX_GENERIC) is introduced to
> take back control of this virt capability, which also makes it easier to
> statically partition all available counters between hosts and guests.
>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/pmu.h     | 2 ++
>  arch/x86/kvm/svm/pmu.c | 7 ++++---
>  arch/x86/kvm/x86.c     | 2 ++
>  3 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 847e7112a5d3..e3a3813b6a38 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -18,6 +18,8 @@
>  #define VMWARE_BACKDOOR_PMC_REAL_TIME          0x10001
>  #define VMWARE_BACKDOOR_PMC_APPARENT_TIME      0x10002
>
> +#define KVM_AMD_PMC_MAX_GENERIC        AMD64_NUM_COUNTERS_CORE
> +
>  struct kvm_event_hw_type_mapping {
>         u8 eventsel;
>         u8 unit_mask;
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 2ec420b85d6a..f99f2c869664 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -192,9 +192,10 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
>         struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>         int i;
>
> -       BUILD_BUG_ON(AMD64_NUM_COUNTERS_CORE > INTEL_PMC_MAX_GENERIC);
> +       BUILD_BUG_ON(AMD64_NUM_COUNTERS_CORE > KVM_AMD_PMC_MAX_GENERIC);
> +       BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > INTEL_PMC_MAX_GENERIC);
>
> -       for (i = 0; i < AMD64_NUM_COUNTERS_CORE ; i++) {
> +       for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC ; i++) {
>                 pmu->gp_counters[i].type = KVM_PMC_GP;
>                 pmu->gp_counters[i].vcpu = vcpu;
>                 pmu->gp_counters[i].idx = i;
> @@ -207,7 +208,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
>         struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>         int i;
>
> -       for (i = 0; i < AMD64_NUM_COUNTERS_CORE; i++) {
> +       for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC; i++) {
>                 struct kvm_pmc *pmc = &pmu->gp_counters[i];
>
>                 pmc_stop_counter(pmc);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 43a6a7efc6ec..b9738efd8425 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1444,12 +1444,14 @@ static const u32 msrs_to_save_all[] = {
>         MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,

IIRC, the effective maximum on the Intel side is 18, despite what
INTEL_PMC_MAX_GENERIC says, due to collisions with other existing MSR
indices. That's why the Intel list stops here. Should we introduce a
KVM_INTEL_PMC_MAX_GENERIC as well?

>         MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
>
> +       /* This part of MSRs should match KVM_AMD_PMC_MAX_GENERIC. */

Perhaps the comment above should be moved down two lines, since the
next two lines deal with the legacy counters.

>         MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
>         MSR_K7_PERFCTR0, MSR_K7_PERFCTR1, MSR_K7_PERFCTR2, MSR_K7_PERFCTR3,
>         MSR_F15H_PERF_CTL0, MSR_F15H_PERF_CTL1, MSR_F15H_PERF_CTL2,
>         MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
>         MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
>         MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,

At some point, we may want to consider populating the PMU MSR list
dynamically, rather than statically enumerating all of them (for both
AMD and Intel).

Reviewed-by: Jim Mattson <jmattson@google.com>
