Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA2F5AFAFA
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 06:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiIGEMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 00:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiIGEMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 00:12:07 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC267FE5E
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 21:12:03 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-1278a61bd57so14638348fac.7
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 21:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=BFj3mGZHr9XxUQGoHBeMyU6gWYy0BtRLXs5VJDlq6ME=;
        b=AKBHTlrWuDM+vsfTYx+NFKyB1uAN3NBrNCbUvm0gP5zXeoaVuC4tPEXVhLeWtTRSnZ
         28UFqDwSZHMf3bC6PD+TRWpUEWJDjth6stOsfNfeTwSH3jM/hVhtx2SkB24qZiphCazG
         p9NPil0P1n+kxzMi+Mg9PPSHrrK4lS3+/8QAJVCGy7a3GjHaNgwO4PsqqN1KI3ht7h1p
         6lsrdQO7UQChV2Pr26lnlatyCL4h7OclwUIK1Bz1ABt4TML2XtGWdmFfbAyNzzf5Zhti
         Qdsjq3Uwe1XvCIzwgELILk+8t6o5m811brP1EhZ7Tif2KYWfxCoJJR+orXPuPH2YTWW4
         cQSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=BFj3mGZHr9XxUQGoHBeMyU6gWYy0BtRLXs5VJDlq6ME=;
        b=nzx1kP/1zFicotY0gdEXkXkG2PDA0z3celNiIfq4eLruUOt/r241DN9BFuqYVePhHi
         1SgSIwEc/x4UGOnuLsJTxvDGxH/zzzCjqCcJuDzrzw+1IN8/J/X/hD4OraBrmRy6HbLO
         FVwb0lkrMjSCCGnV/c7Oc9jVIPn2GPH43gaWW9QLgzrCy7wA55TCQ5IlZo1jFKsPZwXs
         YCXcWH1XTh/TWhoKbRvqhy+6VpiKbVTWHlmwmMkI4HYHQWkAO8bWV7/6p5XG1tRQePeN
         aA+h/xKt6mKwIuh2cYBjfFGq2k8r5dFfv5N51USjUzLb6h5zg9MTmGfEq+gvOBjgFzPL
         CHdQ==
X-Gm-Message-State: ACgBeo18b1kJl99+ZYuOklOh6MAXFBcj447rNMzxGRN90QBoR4sj7+VK
        oFegYCWM+q+CQAXlbTkwbi28/BGRg+yzm4xDxdBT+w==
X-Google-Smtp-Source: AA6agR4AuHpv2JvDK8XjYcOaeWAO/x49CJx1chwFnDGTHGVuPDZkW52fw6IOt3HL14grS9kper+4uhTB0NyzGfQ7JHo=
X-Received: by 2002:a05:6870:41d0:b0:126:5d06:28a5 with SMTP id
 z16-20020a05687041d000b001265d0628a5mr821542oac.181.1662523923026; Tue, 06
 Sep 2022 21:12:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220905123946.95223-1-likexu@tencent.com> <20220905123946.95223-5-likexu@tencent.com>
 <CALMp9eQtjZ-iRiW5Jusa+NF-P0sdHtcoR8fPiBSKtNXKgstgVA@mail.gmail.com>
 <0e0f773b-0dde-2282-c2d0-fad2311f59a7@gmail.com> <CALMp9eQQe-XDUZmNtg5Z+Vv8hMu_R_fuTv2+-ZfuRwzNUmW0fA@mail.gmail.com>
 <d63e79d8-fcbc-9def-4a90-e7a4614493bb@gmail.com>
In-Reply-To: <d63e79d8-fcbc-9def-4a90-e7a4614493bb@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 6 Sep 2022 21:11:51 -0700
Message-ID: <CALMp9eSXTpkKpmqJiS=0NuQOjCFKDeOqjN3wWfyPCBhx-H=Vsw@mail.gmail.com>
Subject: Re: [PATCH 4/4] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022
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

On Tue, Sep 6, 2022 at 8:59 PM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 7/9/2022 4:08 am, Jim Mattson wrote:
> > On Tue, Sep 6, 2022 at 5:53 AM Like Xu <like.xu.linux@gmail.com> wrote:
> >>
> >> On 6/9/2022 1:36 am, Jim Mattson wrote:
> >>> On Mon, Sep 5, 2022 at 5:45 AM Like Xu <like.xu.linux@gmail.com> wrote:
> >>>>
> >>>> From: Sandipan Das <sandipan.das@amd.com>
> >>>>
> >>>> CPUID leaf 0x80000022 i.e. ExtPerfMonAndDbg advertises some
> >>>> new performance monitoring features for AMD processors.
> >>>>
> >>>> Bit 0 of EAX indicates support for Performance Monitoring
> >>>> Version 2 (PerfMonV2) features. If found to be set during
> >>>> PMU initialization, the EBX bits of the same CPUID function
> >>>> can be used to determine the number of available PMCs for
> >>>> different PMU types.
> >>>>
> >>>> Expose the relevant bits via KVM_GET_SUPPORTED_CPUID so
> >>>> that guests can make use of the PerfMonV2 features.
> >>>>
> >>>> Co-developed-by: Like Xu <likexu@tencent.com>
> >>>> Signed-off-by: Like Xu <likexu@tencent.com>
> >>>> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
> >>>> ---
> >>>>    arch/x86/include/asm/perf_event.h |  8 ++++++++
> >>>>    arch/x86/kvm/cpuid.c              | 21 ++++++++++++++++++++-
> >>>>    2 files changed, 28 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> >>>> index f6fc8dd51ef4..c848f504e467 100644
> >>>> --- a/arch/x86/include/asm/perf_event.h
> >>>> +++ b/arch/x86/include/asm/perf_event.h
> >>>> @@ -214,6 +214,14 @@ union cpuid_0x80000022_ebx {
> >>>>           unsigned int            full;
> >>>>    };
> >>>>
> >>>> +union cpuid_0x80000022_eax {
> >>>> +       struct {
> >>>> +               /* Performance Monitoring Version 2 Supported */
> >>>> +               unsigned int    perfmon_v2:1;
> >>>> +       } split;
> >>>> +       unsigned int            full;
> >>>> +};
> >>>> +
> >>>>    struct x86_pmu_capability {
> >>>>           int             version;
> >>>>           int             num_counters_gp;
> >>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> >>>> index 75dcf7a72605..08a29ab096d2 100644
> >>>> --- a/arch/x86/kvm/cpuid.c
> >>>> +++ b/arch/x86/kvm/cpuid.c
> >>>> @@ -1094,7 +1094,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >>>>                   entry->edx = 0;
> >>>>                   break;
> >>>>           case 0x80000000:
> >>>> -               entry->eax = min(entry->eax, 0x80000021);
> >>>> +               entry->eax = min(entry->eax, 0x80000022);
> >>>>                   /*
> >>>>                    * Serializing LFENCE is reported in a multitude of ways, and
> >>>>                    * NullSegClearsBase is not reported in CPUID on Zen2; help
> >>>> @@ -1203,6 +1203,25 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >>>>                   if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
> >>>>                           entry->eax |= BIT(6);
> >>>>                   break;
> >>>> +       /* AMD Extended Performance Monitoring and Debug */
> >>>> +       case 0x80000022: {
> >>>> +               union cpuid_0x80000022_eax eax;
> >>>> +               union cpuid_0x80000022_ebx ebx;
> >>>> +
> >>>> +               entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> >>>> +               if (!enable_pmu)
> >>>> +                       break;
> >>>> +
> >>>> +               if (kvm_pmu_cap.version > 1) {
> >>>> +                       /* AMD PerfMon is only supported up to V2 in the KVM. */
> >>>> +                       eax.split.perfmon_v2 = 1;
> >>>> +                       ebx.split.num_core_pmc = min(kvm_pmu_cap.num_counters_gp,
> >>>> +                                                    KVM_AMD_PMC_MAX_GENERIC);
> >>>
> >>> Note that the number of core PMCs has to be at least 6 if
> >>> guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE). I suppose this leaf
> >>> could claim fewer, but the first 6 PMCs must work, per the v1 PMU
> >>> spec. That is, software that knows about PERFCTR_CORE, but not about
> >>> PMU v2, can rightfully expect 6 PMCs.
> >>
> >> I thought the NumCorePmc number would only make sense if
> >> CPUID.80000022.eax.perfmon_v2
> >> bit was present, but considering that the user space is perfectly fine with just
> >> configuring the
> >> NumCorePmc number without setting perfmon_v2 bit at all, so how about:
> >
> > CPUID.80000022H might only make sense if X86_FEATURE_PERFCTR_CORE is
> > present. It's hard to know in the absence of documentation.
>
> Whenever this happens, we may always leave the definition of behavior to the
> hypervisor.

I disagree. If CPUID.0H reports "AuthenticAMD," then AMD is the sole
authority on behavior.

> >
> >>          /* AMD Extended Performance Monitoring and Debug */
> >>          case 0x80000022: {
> >>                  union cpuid_0x80000022_eax eax;
> >>                  union cpuid_0x80000022_ebx ebx;
> >>                  bool perfctr_core;
> >>
> >>                  entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> >>                  if (!enable_pmu)
> >>                          break;
> >>
> >>                  perfctr_core = kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE);
> >>                  if (!perfctr_core)
> >>                          ebx.split.num_core_pmc = AMD64_NUM_COUNTERS;
> >>                  if (kvm_pmu_cap.version > 1) {
> >>                          /* AMD PerfMon is only supported up to V2 in the KVM. */
> >>                          eax.split.perfmon_v2 = 1;
> >>                          ebx.split.num_core_pmc = min(kvm_pmu_cap.num_counters_gp,
> >>                                                       KVM_AMD_PMC_MAX_GENERIC);
> >>                  }
> >>                  if (perfctr_core) {
> >>                          ebx.split.num_core_pmc = max(ebx.split.num_core_pmc,
> >>                                                       AMD64_NUM_COUNTERS_CORE);
> >>                  }
> >
> > This still isn't quite right. All AMD CPUs must support a minimum of 4 PMCs.
>
> K7 at least. I could not confirm that all antique AMD CPUs have 4 counters w/o
> perfctr_core.

The APM says, "All implementations support the base set of four
performance counter / event-select pairs." That is unequivocal.

> >
> >>
> >>                  entry->eax = eax.full;
> >>                  entry->ebx = ebx.full;
> >>                  break;
> >>          }
> >>
> >> ?
> >>
> >> Once 0x80000022 appears, ebx.split.num_core_pmc will report only
> >> the real "Number of Core Performance Counters" regardless of perfmon_v2.
> >>
> >>>
> >>>
> >>>> +               }
> >>>> +               entry->eax = eax.full;
> >>>> +               entry->ebx = ebx.full;
> >>>> +               break;
> >>>> +       }
> >>>>           /*Add support for Centaur's CPUID instruction*/
> >>>>           case 0xC0000000:
> >>>>                   /*Just support up to 0xC0000004 now*/
> >>>> --
> >>>> 2.37.3
> >>>>
