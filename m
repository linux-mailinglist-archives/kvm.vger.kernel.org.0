Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98BC5AD871
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 19:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237446AbiIERhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 13:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiIERhD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 13:37:03 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8B25E668
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 10:37:02 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-1279948d93dso3015152fac.10
        for <kvm@vger.kernel.org>; Mon, 05 Sep 2022 10:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=a1Wl5OOBM+OdiCqwjpRNbQVvWBi9SOkRJQ7j+gqJGAI=;
        b=omXxCPqBgDlAxdUX5U3YmgblCVqUcKpbsoTO+4DUk94Iq8Ti9QLdiueFbqZ+DgSlp1
         V8iuStpxP2j4Ww3tI5mVwdlgs1zcuRT7t7INHg1D0a7/IAnd9sXOCdqgra40rPUE8wD0
         cg4U3zqiRno6i+kIK7wfyr0jwxRhlU3xtFU/jTVDRYdedLsMRBHOcbn1RUKJY2Unmeeb
         4iCsdLOAZ4xhRkAWzbOtmAMh4Fj2HMXy2Og0EuTF0lq0EjrIGgbFcqz+I3BrU271nVeH
         fzkUWc7H43GObS8fzc6AQAbWhMpWmlJsPGwVRHukT8vRkg/NL9sNpwmkJRLBvILW1I/Q
         3qpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=a1Wl5OOBM+OdiCqwjpRNbQVvWBi9SOkRJQ7j+gqJGAI=;
        b=yO8r/8yPaKUdwsU5zLnFmcIBwLPPrBqgw0yOKuobIQ7rNsRuCY2+pvXsPX4o5Esg2Q
         L0rVvx3oX5YUCnzjQnuf5V0cnQWNGegKE6DFhuXBWunPFSHObMw+5dNK3bZnkmAWuDLz
         YoTZJBLOX5NJw/H/ieAxJUHreZYeEdY1GfLJgAYovRLfZJKXs6FnSSMGsa6j58gCkkt/
         rrVd8NX/pmOtdofhMzUalVAaKfeiPCujYKAfJXlDoW4nzvceDW+JbRpXVTQBt6at0GoF
         29yA2sogVscyypMgSefyMurptUOcMICeqC3J3rwJpv54DRD7CgZGv52v59ueHQ1606Mp
         GPpg==
X-Gm-Message-State: ACgBeo2VS/sbQFE3EwR3ldQtqzmOajycDBJNWPtQgQd9r+d4QMXju0+0
        Dp00VObfoqRCQL5oyNdDB1Lq7so+3FoP2tyhPJdt4Q==
X-Google-Smtp-Source: AA6agR5aL8W3+sousDudZxT+/nLQAmWyTAA2BbxmIIkDasYIK+tFHEa7u4ZnJLfSCaHD7jyPJkRRUB/yg6ndTpAc0Jk=
X-Received: by 2002:a05:6808:150f:b0:343:3202:91cf with SMTP id
 u15-20020a056808150f00b00343320291cfmr8032565oiw.112.1662399422082; Mon, 05
 Sep 2022 10:37:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220905123946.95223-1-likexu@tencent.com> <20220905123946.95223-5-likexu@tencent.com>
In-Reply-To: <20220905123946.95223-5-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 5 Sep 2022 10:36:51 -0700
Message-ID: <CALMp9eQtjZ-iRiW5Jusa+NF-P0sdHtcoR8fPiBSKtNXKgstgVA@mail.gmail.com>
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

On Mon, Sep 5, 2022 at 5:45 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> From: Sandipan Das <sandipan.das@amd.com>
>
> CPUID leaf 0x80000022 i.e. ExtPerfMonAndDbg advertises some
> new performance monitoring features for AMD processors.
>
> Bit 0 of EAX indicates support for Performance Monitoring
> Version 2 (PerfMonV2) features. If found to be set during
> PMU initialization, the EBX bits of the same CPUID function
> can be used to determine the number of available PMCs for
> different PMU types.
>
> Expose the relevant bits via KVM_GET_SUPPORTED_CPUID so
> that guests can make use of the PerfMonV2 features.
>
> Co-developed-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
> ---
>  arch/x86/include/asm/perf_event.h |  8 ++++++++
>  arch/x86/kvm/cpuid.c              | 21 ++++++++++++++++++++-
>  2 files changed, 28 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index f6fc8dd51ef4..c848f504e467 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -214,6 +214,14 @@ union cpuid_0x80000022_ebx {
>         unsigned int            full;
>  };
>
> +union cpuid_0x80000022_eax {
> +       struct {
> +               /* Performance Monitoring Version 2 Supported */
> +               unsigned int    perfmon_v2:1;
> +       } split;
> +       unsigned int            full;
> +};
> +
>  struct x86_pmu_capability {
>         int             version;
>         int             num_counters_gp;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 75dcf7a72605..08a29ab096d2 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1094,7 +1094,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>                 entry->edx = 0;
>                 break;
>         case 0x80000000:
> -               entry->eax = min(entry->eax, 0x80000021);
> +               entry->eax = min(entry->eax, 0x80000022);
>                 /*
>                  * Serializing LFENCE is reported in a multitude of ways, and
>                  * NullSegClearsBase is not reported in CPUID on Zen2; help
> @@ -1203,6 +1203,25 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>                 if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
>                         entry->eax |= BIT(6);
>                 break;
> +       /* AMD Extended Performance Monitoring and Debug */
> +       case 0x80000022: {
> +               union cpuid_0x80000022_eax eax;
> +               union cpuid_0x80000022_ebx ebx;
> +
> +               entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> +               if (!enable_pmu)
> +                       break;
> +
> +               if (kvm_pmu_cap.version > 1) {
> +                       /* AMD PerfMon is only supported up to V2 in the KVM. */
> +                       eax.split.perfmon_v2 = 1;
> +                       ebx.split.num_core_pmc = min(kvm_pmu_cap.num_counters_gp,
> +                                                    KVM_AMD_PMC_MAX_GENERIC);

Note that the number of core PMCs has to be at least 6 if
guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE). I suppose this leaf
could claim fewer, but the first 6 PMCs must work, per the v1 PMU
spec. That is, software that knows about PERFCTR_CORE, but not about
PMU v2, can rightfully expect 6 PMCs.


> +               }
> +               entry->eax = eax.full;
> +               entry->ebx = ebx.full;
> +               break;
> +       }
>         /*Add support for Centaur's CPUID instruction*/
>         case 0xC0000000:
>                 /*Just support up to 0xC0000004 now*/
> --
> 2.37.3
>
