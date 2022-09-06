Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD0E5AF5B9
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 22:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiIFUVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 16:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiIFUUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 16:20:39 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9461A7968F
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 13:19:57 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-1279948d93dso11198838fac.10
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 13:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=gbBq9oSsimXhwPcj/18IdLMsGZl+C+oGEqB+OkpNjck=;
        b=oK3e02N3juvYgzLxWq4Q6AHFAqYWQ11CFPvfKK0z1jomy+ZlHIJUgUwH8XXWCgmPw3
         BS4c/ZNzuJcrZU2oALV/MZ1fmCGzww9/IDT3CGrxKZoytQwOl0Yb8HS0CMB889pKDu4r
         aztCp5vEItHWSjiYXBnjOlbvPKCwhhkhhRiIN9yWNWClEMZfsO1WLNI6U8woEE45SX4o
         6JvnpCyl9bT+nkjwd74yYclBw2j1TzUnbJRxuRv5Eh2cQVQJIYLf3akT2ndm2tRLgs6g
         nrJ5kpIcIkFHR6gafvMcTVLvW6OsSKJRwFN7rsK65IxUM557keRXNXpzyX6sdDS7xS3P
         pYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=gbBq9oSsimXhwPcj/18IdLMsGZl+C+oGEqB+OkpNjck=;
        b=QMQ5e79hVQcJGYyooSQLEcXldLdlhwhGYknvbs7+D1ypQsyfvWKsIMST0f9GVZUaLM
         FzPklaXER+hJEWlNhXRlByTclDDWcYFKsQB+gXTV83LO3eyIPwY0Ku6l/UTmbqnJmVr2
         YoRfta+9FQ8AG8kQ5lVTOM9X1pXWm12y/TN8qwZ6QLbodhGXiHDiziQmUrBlccSyGmjd
         2lTJVzT2z18QHxsbE8VB7OHMlaGqMclLPBKAAkyZq/DmlGc5UOH/Io+GgaKwzpn73UKR
         tcxgcKEK1jPe3PI9Z4kJrGKVg9u7N/T06ze20Ug8yiEYyJ9sCXfbG1AJ6LecJLJMroQ4
         i07A==
X-Gm-Message-State: ACgBeo2Zcxs0D5F7TzUzwA1z4SKQbsxdclA0kgmEKLr1NR54hhUSAiSg
        FtOIao3uCbb2bUo1W/zHHhqSSyXb2PWVBWVASf4DgqynuqXVRA==
X-Google-Smtp-Source: AA6agR5K6YFhZhdSzymx5/Q2C8h0pxSLeiHGVN4eJxTL6Pz3Io8Wh7mD5gK7Jsk6CUfbo3zeREY+ehOaZ/7HZgwDgVI=
X-Received: by 2002:a05:6870:c596:b0:101:6409:ae62 with SMTP id
 ba22-20020a056870c59600b001016409ae62mr12440717oab.112.1662495596120; Tue, 06
 Sep 2022 13:19:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220905123946.95223-1-likexu@tencent.com> <20220905123946.95223-4-likexu@tencent.com>
 <CALMp9eSBK3xVKoqrk4j2yNqk+Jh0z-Nk-rwCTaTE0Dca5DQoPA@mail.gmail.com> <c9b3d50e-ec3d-3fa3-2706-5672100ffe09@gmail.com>
In-Reply-To: <c9b3d50e-ec3d-3fa3-2706-5672100ffe09@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 6 Sep 2022 13:19:45 -0700
Message-ID: <CALMp9eSQ1QkmECM4at9XDPUew0h2nxG5=YUSN=aWnQpZkXy2dw@mail.gmail.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 6, 2022 at 5:45 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 6/9/2022 2:00 am, Jim Mattson wrote:
> > On Mon, Sep 5, 2022 at 5:44 AM Like Xu <like.xu.linux@gmail.com> wrote:
> >>
> >> From: Like Xu <likexu@tencent.com>
> >>
> >> If AMD Performance Monitoring Version 2 (PerfMonV2) is detected
> >> by the guest, it can use a new scheme to manage the Core PMCs using
> >> the new global control and status registers.
> >>
> >> In addition to benefiting from the PerfMonV2 functionality in the same
> >> way as the host (higher precision), the guest also can reduce the number
> >> of vm-exits by lowering the total number of MSRs accesses.
> >>
> >> In terms of implementation details, amd_is_valid_msr() is resurrected
> >> since three newly added MSRs could not be mapped to one vPMC.
> >> The possibility of emulating PerfMonV2 on the mainframe has also
> >> been eliminated for reasons of precision.
> >>
> >> Co-developed-by: Sandipan Das <sandipan.das@amd.com>
> >> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
> >> Signed-off-by: Like Xu <likexu@tencent.com>
> >> ---
> >>   arch/x86/kvm/pmu.c     |  6 +++++
> >>   arch/x86/kvm/svm/pmu.c | 50 +++++++++++++++++++++++++++++++++---------
> >>   arch/x86/kvm/x86.c     | 11 ++++++++++
> >>   3 files changed, 57 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> >> index 7002e1b74108..56b4f898a246 100644
> >> --- a/arch/x86/kvm/pmu.c
> >> +++ b/arch/x86/kvm/pmu.c
> >> @@ -455,12 +455,15 @@ int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >>
> >>          switch (msr) {
> >>          case MSR_CORE_PERF_GLOBAL_STATUS:
> >> +       case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
> >>                  msr_info->data = pmu->global_status;
> >>                  return 0;
> >>          case MSR_CORE_PERF_GLOBAL_CTRL:
> >> +       case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
> >>                  msr_info->data = pmu->global_ctrl;
> >>                  return 0;
> >>          case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> >> +       case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
> >>                  msr_info->data = 0;
> >>                  return 0;
> >>          default:
> >> @@ -479,12 +482,14 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >>
> >>          switch (msr) {
> >>          case MSR_CORE_PERF_GLOBAL_STATUS:
> >> +       case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
> >>                  if (msr_info->host_initiated) {
> >>                          pmu->global_status = data;
> >>                          return 0;
> >>                  }
> >>                  break; /* RO MSR */
> >>          case MSR_CORE_PERF_GLOBAL_CTRL:
> >> +       case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
> >>                  if (pmu->global_ctrl == data)
> >>                          return 0;
> >>                  if (kvm_valid_perf_global_ctrl(pmu, data)) {
> >> @@ -495,6 +500,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >>                  }
> >>                  break;
> >>          case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> >> +       case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
> >>                  if (!(data & pmu->global_ovf_ctrl_mask)) {
> >>                          if (!msr_info->host_initiated)
> >>                                  pmu->global_status &= ~data;
> >> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> >> index 3a20972e9f1a..4c7d408e3caa 100644
> >> --- a/arch/x86/kvm/svm/pmu.c
> >> +++ b/arch/x86/kvm/svm/pmu.c
> >> @@ -92,12 +92,6 @@ static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
> >>          return amd_pmc_idx_to_pmc(vcpu_to_pmu(vcpu), idx & ~(3u << 30));
> >>   }
> >>
> >> -static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
> >> -{
> >> -       /* All MSRs refer to exactly one PMC, so msr_idx_to_pmc is enough.  */
> >> -       return false;
> >> -}
> >> -
> >>   static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
> >>   {
> >>          struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> >> @@ -109,6 +103,29 @@ static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
> >>          return pmc;
> >>   }
> >>
> >> +static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
> >> +{
> >> +       struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> >> +
> >> +       switch (msr) {
> >> +       case MSR_K7_EVNTSEL0 ... MSR_K7_PERFCTR3:
> >> +               return pmu->version > 0;
> >> +       case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
> >> +               return guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE);
> >> +       case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
> >> +       case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
> >> +       case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
> >> +               return pmu->version > 1;
> >> +       default:
> >> +               if (msr > MSR_F15H_PERF_CTR5 &&
> >> +                   msr < MSR_F15H_PERF_CTL0 + 2 * KVM_AMD_PMC_MAX_GENERIC)
> >> +                       return pmu->version > 1;
> >
> > Should this be bounded by guest CPUID.80000022H:EBX[NumCorePmc]
> > (unless host-initiated)?
>
> Indeed, how about:
>
>         default:
>                 if (msr > MSR_F15H_PERF_CTR5 &&
>                     msr < MSR_F15H_PERF_CTL0 + 2 * pmu->nr_arch_gp_counters)
>                         return pmu->version > 1;
>
> and for host-initiated:
>
> #define MSR_F15H_PERF_MSR_MAX  \
>         (MSR_F15H_PERF_CTR0 + 2 * (KVM_AMD_PMC_MAX_GENERIC - 1))

I think there may be an off-by-one error here.

>
> kvm_{set|get}_msr_common()
>         case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_MSR_MAX:
>                  if (kvm_pmu_is_valid_msr(vcpu, msr))
>                          return kvm_pmu_set_msr(vcpu, msr_info);
> ?
>
> >
> >> +               break;
> >> +       }
> >> +
> >> +       return amd_msr_idx_to_pmc(vcpu, msr);
> >> +}
> >> +
> >>   static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >>   {
> >>          struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> >> @@ -162,20 +179,31 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >>   static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
> >>   {
> >>          struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> >> +       struct kvm_cpuid_entry2 *entry;
> >> +       union cpuid_0x80000022_ebx ebx;
> >>
> >> -       if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
> >> +       pmu->version = 1;
> >> +       entry = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0);
> >> +       if (kvm_pmu_cap.version > 1 && entry && (entry->eax & BIT(0))) {
> >> +               pmu->version = 2;
> >> +               ebx.full = entry->ebx;
> >> +               pmu->nr_arch_gp_counters = min3((unsigned int)ebx.split.num_core_pmc,
> >> +                                               (unsigned int)kvm_pmu_cap.num_counters_gp,
> >> +                                               (unsigned int)KVM_AMD_PMC_MAX_GENERIC);
> >> +               pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
> >> +               pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask;
> >> +       } else if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
> >>                  pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
> >
> > The logic above doesn't seem quite right, since guest_cpuid_has(vcpu,
> > X86_FEATURE_PERFCTR_CORE) promises 6 PMCs, regardless of what
> > CPUID.80000022 says.
>
> I would have expected the appearance of CPUID.80000022 to override PERFCTR_CORE,
> now I don't think it's a good idea as you do, so how about:
>
> amd_pmu_refresh():
>
>         bool perfctr_core = guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE);
>
>         pmu->version = 1;
>         if (kvm_pmu_cap.version > 1)
>                 entry = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0);
>
>         if (!perfctr_core)
>                 pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
>         if (entry && (entry->eax & BIT(0))) {
>                 pmu->version = 2;
>                 ebx.full = entry->ebx;
>                 pmu->nr_arch_gp_counters = min3((unsigned int)ebx.split.num_core_pmc,
>                                                 (unsigned int)kvm_pmu_cap.num_counters_gp,
>                                                 (unsigned int)KVM_AMD_PMC_MAX_GENERIC);
>         }
>         /* PERFCTR_CORE promises 6 PMCs, regardless of CPUID.80000022 */
>         if (perfctr_core) {
>                 pmu->nr_arch_gp_counters = max(pmu->nr_arch_gp_counters,
>                                                AMD64_NUM_COUNTERS_CORE);
>         }

Even if X86_FEATURE_PERFCTR_CORE is clear, all AMD CPUs promise 4 PMCs.

>
>         if (pmu->version > 1) {
>                 pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
>                 pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask;
>         }
>
> ?
>
>
