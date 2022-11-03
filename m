Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944D16189C8
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 21:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiKCUos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 16:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiKCUor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 16:44:47 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE801CFD2
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 13:44:46 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-13b6c1c89bdso3528631fac.13
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 13:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f+1UXnbHGdIK3De5/zrEFzfAPZ6gH5pChAdbN9r+W4A=;
        b=qbTQ75Rp01epfSUPdhZSPNe0WQ/fIPdQOlufBzI9AZkCQJkgzihFi/mJ+f2SEA8kod
         79KVegLflkPN+QnRNkOkfKBSufSDhndTfvDT5n9sn0Yctc4oFE9kkc15q4116kmjJmx9
         MWbzT98/4SS9oxsr4b4BTmhstuq+NLfqmWX+I5Q8SBSVzR/C/gbPV1bb6wvKZ0Zuob3+
         Dqd5QYK7RnF3TVaPF5jbGvXW/g/5UQzE/L9CN1iWreLtjq9mUxuHT4WiKqzNbLjitXnV
         uLWsqUHu+3ybQrmlfN1oG1igPmYaPID5u4R0zq8AfG6GP07Oymab6TxruT1M0H4zQ/Cl
         0UOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f+1UXnbHGdIK3De5/zrEFzfAPZ6gH5pChAdbN9r+W4A=;
        b=XCmVWituOpnjMGeuCY7wJzdRBKZKQutFoTHuPiBhmoLTYycTCTp7/68W2+MWK87G8g
         XZaSM390RYcxMZ1olzSVwMDO4JfUQLI2ft5ckrdV2P/Va9kKEwdH4rwnQ/cwnL9WTkC7
         IocbHPslqgIgopwyxNvTsJb5M9LsFKSfFIjJe5EbSwm+R3mQjyKVNH8yaSWZRNq7Yg0O
         7XatitQ1bsWJtkIzXfw1gheMA+E8I/DKTTbzdOQgYnN1UhlWRQIZxbY1ePAiDGc2ZLej
         DJTfG2hxlHHLSZZ/W/cnYQWh4KBN6SwK51bndIVFLjJ0pLYlSsegVa3Us2uEpnoZkXb/
         Vzgw==
X-Gm-Message-State: ACrzQf3vc42sLPdtOfusdk5PEksSVhzuXeClKwO74kQfmWbL8WA27RG/
        jcFZI65LPeL1k/0+fHrdxGpF2kAEUWDN+GMlh4SEVA==
X-Google-Smtp-Source: AMsMyM64AAFKgqcaFOvUMlg264rZEPo9ZOtG5F9Q4+2r9YG/KU69ZMIwa7pHG+2lrcw0TupK401Z7Q+Yqx1HBrqPkL0=
X-Received: by 2002:a05:6871:8a3:b0:13b:18ef:e8df with SMTP id
 r35-20020a05687108a300b0013b18efe8dfmr18879685oaq.181.1667508285595; Thu, 03
 Nov 2022 13:44:45 -0700 (PDT)
MIME-Version: 1.0
References: <20221103191733.3153803-1-aaronlewis@google.com>
In-Reply-To: <20221103191733.3153803-1-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 3 Nov 2022 13:44:34 -0700
Message-ID: <CALMp9eTjJHMhQGDmbn2WYdcaFLWMvtQjWN4pTUMRXTAnBwj6jQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Omit PMU MSRs from KVM_GET_MSR_INDEX_LIST if !enable_pmu
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        Like Xu <like.xu.linux@gmail.com>
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

On Thu, Nov 3, 2022 at 12:18 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> When the PMU is disabled, don't bother sharing the PMU MSRs with
> userspace through KVM_GET_MSR_INDEX_LIST.  Instead, filter them out so
> userspace doesn't have to keep track of them.
>
> Note that 'enable_pmu' is read-only, so userspace has no control over
> whether the PMU MSRs are included in the list or not.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/x86.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 521b433f978c..19bc42a6946d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7042,13 +7042,20 @@ static void kvm_init_msr_list(void)
>                                 continue;
>                         break;
>                 case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
> -                       if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
> -                           min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
> +                       if ((msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
> +                           min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp)) ||
> +                           !enable_pmu)
>                                 continue;
>                         break;
>                 case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 17:
> -                       if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
> -                           min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
> +                       if ((msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
> +                           min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp)) ||
> +                           !enable_pmu)
> +                               continue;
> +                       break;
> +               case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
> +               case MSR_K7_EVNTSEL0 ... MSR_K7_PERFCTR3:
> +                       if (!enable_pmu)
>                                 continue;
>                         break;
>                 case MSR_IA32_XFD:

I think you've missed a bunch:

MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
MSR_IA32_PEBS_ENABLE, MSR_PEBS_DATA_CFG
