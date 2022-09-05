Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B271D5AD8B1
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 20:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbiIESAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 14:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiIESAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 14:00:50 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB803204D
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 11:00:48 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-1278624b7c4so4695218fac.5
        for <kvm@vger.kernel.org>; Mon, 05 Sep 2022 11:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=vo/ZXNY6mxg/MesOYZ4vVl7X/uP2QTxbLQziPj/OqxE=;
        b=rMv0DtePu6GBRQ+5zF37wclZvMbnuRyvUsbLfibOgM2rLG/0qWO8DUQQuJxTxV4KdC
         4tXlqAAlBNUgH7UlT3O5s0qaBdGZcDwz0anyOs8TYfb0xDPVIYd2c+l2O0JAeA9yv0Nc
         9u7pp7oAhKistRCgPmREfoYDaaJGVFUn+Ic+Ikp5gNnHIML4TLWoYQK31uFsWgreQrCI
         ByvYLMhc5P153A+bWjbKaOm8se5Zop4W5Im4mh7LY+QEcgnbiMpU9BGQHkgC5ULz22HI
         PnWo4mBnB6cahsuVo7RxeYAm5FRQ/XeMzg9dwGlV3IlXNk4nMVhcfYCaxMrcsLRGw4w9
         CvOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=vo/ZXNY6mxg/MesOYZ4vVl7X/uP2QTxbLQziPj/OqxE=;
        b=P8yL5ulZmievpt387xMsl7ycqZdOkUPBPqGJopZ1pKsKoVTQ4LKI86PR0jiiY3WbC0
         SEorRmlmVXsfTmwUE4thbkch1lJbGh+C6adx6MInyqCAKPVIyrHqTtKXkKXJEePiSSZW
         CjYgPM7jj8GFMFXhvbZzX8NTlu4BQV9kILRAsIw/fN0XPNDRcdpWGNaFdcYyyz/aJwJh
         rqMfSChas3sZChaZyJ1U/HIcQ1Qp6Rxs9vNCssIYgDr7+Le4Z6gWvC9AlpGdymvhK9o2
         7Gi76bWq5TeJVPpUk45t5IcGwUqfsvKwsxHyDyR1Gdx7OovYBX7xA9BQMaQAGV5e+RLp
         RLpQ==
X-Gm-Message-State: ACgBeo1/jn9oMzCtHdc6frf5V2dKujSO7lWuijCMc4TxasG5jj7pb7DK
        Q1ZIIL3Ciu/40N13lAduqqTuJejeRuHbT8EiJsGPmPwPLw7FzQ==
X-Google-Smtp-Source: AA6agR5mpDMS6nAWKTerbWQmoi0LXpDu9Ci5i4IEEe1AN4NwOZzpoVhvKNAfwCslLcpvNNgEsybf7M5v5FTE0yg2XZ4=
X-Received: by 2002:a05:6808:150f:b0:343:3202:91cf with SMTP id
 u15-20020a056808150f00b00343320291cfmr8067243oiw.112.1662400848028; Mon, 05
 Sep 2022 11:00:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220905123946.95223-1-likexu@tencent.com> <20220905123946.95223-4-likexu@tencent.com>
In-Reply-To: <20220905123946.95223-4-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 5 Sep 2022 11:00:36 -0700
Message-ID: <CALMp9eSBK3xVKoqrk4j2yNqk+Jh0z-Nk-rwCTaTE0Dca5DQoPA@mail.gmail.com>
Subject: Re: [PATCH 3/4] KVM: x86/svm/pmu: Add AMD PerfMonV2 support
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

On Mon, Sep 5, 2022 at 5:44 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> From: Like Xu <likexu@tencent.com>
>
> If AMD Performance Monitoring Version 2 (PerfMonV2) is detected
> by the guest, it can use a new scheme to manage the Core PMCs using
> the new global control and status registers.
>
> In addition to benefiting from the PerfMonV2 functionality in the same
> way as the host (higher precision), the guest also can reduce the number
> of vm-exits by lowering the total number of MSRs accesses.
>
> In terms of implementation details, amd_is_valid_msr() is resurrected
> since three newly added MSRs could not be mapped to one vPMC.
> The possibility of emulating PerfMonV2 on the mainframe has also
> been eliminated for reasons of precision.
>
> Co-developed-by: Sandipan Das <sandipan.das@amd.com>
> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/pmu.c     |  6 +++++
>  arch/x86/kvm/svm/pmu.c | 50 +++++++++++++++++++++++++++++++++---------
>  arch/x86/kvm/x86.c     | 11 ++++++++++
>  3 files changed, 57 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 7002e1b74108..56b4f898a246 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -455,12 +455,15 @@ int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>
>         switch (msr) {
>         case MSR_CORE_PERF_GLOBAL_STATUS:
> +       case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
>                 msr_info->data = pmu->global_status;
>                 return 0;
>         case MSR_CORE_PERF_GLOBAL_CTRL:
> +       case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
>                 msr_info->data = pmu->global_ctrl;
>                 return 0;
>         case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> +       case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
>                 msr_info->data = 0;
>                 return 0;
>         default:
> @@ -479,12 +482,14 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>
>         switch (msr) {
>         case MSR_CORE_PERF_GLOBAL_STATUS:
> +       case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
>                 if (msr_info->host_initiated) {
>                         pmu->global_status = data;
>                         return 0;
>                 }
>                 break; /* RO MSR */
>         case MSR_CORE_PERF_GLOBAL_CTRL:
> +       case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
>                 if (pmu->global_ctrl == data)
>                         return 0;
>                 if (kvm_valid_perf_global_ctrl(pmu, data)) {
> @@ -495,6 +500,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>                 }
>                 break;
>         case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> +       case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
>                 if (!(data & pmu->global_ovf_ctrl_mask)) {
>                         if (!msr_info->host_initiated)
>                                 pmu->global_status &= ~data;
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 3a20972e9f1a..4c7d408e3caa 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -92,12 +92,6 @@ static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
>         return amd_pmc_idx_to_pmc(vcpu_to_pmu(vcpu), idx & ~(3u << 30));
>  }
>
> -static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
> -{
> -       /* All MSRs refer to exactly one PMC, so msr_idx_to_pmc is enough.  */
> -       return false;
> -}
> -
>  static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
>  {
>         struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -109,6 +103,29 @@ static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
>         return pmc;
>  }
>
> +static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
> +{
> +       struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +
> +       switch (msr) {
> +       case MSR_K7_EVNTSEL0 ... MSR_K7_PERFCTR3:
> +               return pmu->version > 0;
> +       case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
> +               return guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE);
> +       case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
> +       case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
> +       case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
> +               return pmu->version > 1;
> +       default:
> +               if (msr > MSR_F15H_PERF_CTR5 &&
> +                   msr < MSR_F15H_PERF_CTL0 + 2 * KVM_AMD_PMC_MAX_GENERIC)
> +                       return pmu->version > 1;

Should this be bounded by guest CPUID.80000022H:EBX[NumCorePmc]
(unless host-initiated)?

> +               break;
> +       }
> +
> +       return amd_msr_idx_to_pmc(vcpu, msr);
> +}
> +
>  static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
>         struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -162,20 +179,31 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +       struct kvm_cpuid_entry2 *entry;
> +       union cpuid_0x80000022_ebx ebx;
>
> -       if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
> +       pmu->version = 1;
> +       entry = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0);
> +       if (kvm_pmu_cap.version > 1 && entry && (entry->eax & BIT(0))) {
> +               pmu->version = 2;
> +               ebx.full = entry->ebx;
> +               pmu->nr_arch_gp_counters = min3((unsigned int)ebx.split.num_core_pmc,
> +                                               (unsigned int)kvm_pmu_cap.num_counters_gp,
> +                                               (unsigned int)KVM_AMD_PMC_MAX_GENERIC);
> +               pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
> +               pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask;
> +       } else if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
>                 pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;

The logic above doesn't seem quite right, since guest_cpuid_has(vcpu,
X86_FEATURE_PERFCTR_CORE) promises 6 PMCs, regardless of what
CPUID.80000022 says.
