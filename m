Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB514D1683
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 12:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238703AbiCHLpk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 06:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346566AbiCHLpe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 06:45:34 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F58631530;
        Tue,  8 Mar 2022 03:44:10 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id s18so3599875plp.1;
        Tue, 08 Mar 2022 03:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=PsnYcALElaSEddN27dmZjvzCTwgE3HzvzMiPEnPOVxQ=;
        b=pxp8Dnr+tk9VVvKvNLUMMPe7nsUzbmSkBCNII6KWn8c4Khlgp4PXG8ZWv7CloZSH0A
         oRl7jTTy+AckkIrKQCZoLREwheo1x3LlTxBVHnOnQdRPqsmWKqn9uVG0S/GwRlES1GC4
         eXchnmfTS3UOjo3SDbA+rvzZAj84HBM2H97PnAG3CYQbwqCEu+fnV0rLFGMBigUJbrlM
         Sw8k06F9yPinnDumtvE/dvKyTH4L7sqjn7uAO8q6mA368GcGApvg4Kpm7Xud0/hp+4bE
         GkuJD4xWpet+cP4Gwt2X7SwHObkNJocogjLCV69nvez/s2N7DwjgRe1m6g8nAKHHDnxU
         lxkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=PsnYcALElaSEddN27dmZjvzCTwgE3HzvzMiPEnPOVxQ=;
        b=BtU9DlpNRR8LTUt1/8OyIPYgPy3iVV3m9zyD02/Ak5qkmNbQZHDqWMyD9AX3/lAaSh
         By28JnQ3Sb69uWHDpewju6V7mRUZRM26ZjxzLh66fK3sPcRcTRejgYe7Gz3Tn2iratMl
         BNh/2i6ygUN9El23P4mjpgWcMLX9rCUVEyKg+ZAzwrtzI1LQgT8Gmf3ukK4boFK2mH1j
         HBgikEH47185xYtyCU14FQ1G0tvWT+FldQ6gs6nJ5x2f6B+dbmWEcSNAmuLx/MgREpbD
         gFg835UyKb4s7+dEspzKw6xCCSfBAOBd48pgzpj71BMLcG66YGGI9/WBGSsqyt2MlFSE
         ZnIg==
X-Gm-Message-State: AOAM533fU6/IL5byyEDdYuMw1N8yrkb3U0XNoDnxxYPlwB8lfPZa/RNn
        CTqLy8sHiF4NPV5qQdUy3tc=
X-Google-Smtp-Source: ABdhPJxgH59IV4zmpFOMKJiy+MMw9boPwn6G1VOc/ZQQrQBAgve626tO8CH4zg/XPE0FI+vKPv5HPA==
X-Received: by 2002:a17:902:bcc6:b0:151:f36d:2658 with SMTP id o6-20020a170902bcc600b00151f36d2658mr7171515pls.125.1646739849646;
        Tue, 08 Mar 2022 03:44:09 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id k7-20020a63ff07000000b00372dc67e854sm14904406pgi.14.2022.03.08.03.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 03:44:08 -0800 (PST)
Message-ID: <888d5878-a2be-4624-d2c5-227fa19c8150@gmail.com>
Date:   Tue, 8 Mar 2022 19:43:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v2 07/12] KVM: x86/pmu: Use PERF_TYPE_RAW to merge
 reprogram_{gp, fixed}counter()
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20220302111334.12689-1-likexu@tencent.com>
 <20220302111334.12689-8-likexu@tencent.com>
 <CALMp9eQtzS6HEHZ4__K9VuG+-Duwt5uUFb_FcW4DaBKPDmcYkA@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CALMp9eQtzS6HEHZ4__K9VuG+-Duwt5uUFb_FcW4DaBKPDmcYkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/2022 8:36 am, Jim Mattson wrote:
> On Wed, Mar 2, 2022 at 3:14 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> The code sketch for reprogram_{gp, fixed}_counter() is similar, while the
>> fixed counter using the PERF_TYPE_HARDWAR type and the gp being
>> able to use either PERF_TYPE_HARDWAR or PERF_TYPE_RAW type
>> depending on the pmc->eventsel value.
>>
>> After 'commit 761875634a5e ("KVM: x86/pmu: Setup pmc->eventsel
>> for fixed PMCs")', the pmc->eventsel of the fixed counter will also have
>> been setup with the same semantic value and will not be changed during
>> the guest runtime. But essentially, "the HARDWARE is just a convenience
>> wrapper over RAW IIRC", quoated from Peterz. So it could be pretty safe
>> to use the PERF_TYPE_RAW type only to program both gp and fixed
>> counters naturally in the reprogram_counter().
>>
>> To make the gp and fixed counters more semantically symmetrical,
>> the selection of EVENTSEL_{USER, OS, INT} bits is temporarily translated
>> via fixed_ctr_ctrl before the pmc_reprogram_counter() call.
>>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Suggested-by: Jim Mattson <jmattson@google.com>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/pmu.c           | 128 +++++++++++++----------------------
>>   arch/x86/kvm/vmx/pmu_intel.c |   2 +-
>>   2 files changed, 47 insertions(+), 83 deletions(-)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 5299488b002c..00e1660c10ca 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -215,85 +215,60 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
>>          return allow_event;
>>   }
>>
>> -static void reprogram_gp_counter(struct kvm_pmc *pmc)
>> -{
>> -       u64 config;
>> -       u32 type = PERF_TYPE_RAW;
>> -       u64 eventsel = pmc->eventsel;
>> -
>> -       if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
>> -               printk_once("kvm pmu: pin control bit is ignored\n");
>> -
>> -       pmc_pause_counter(pmc);
>> -
>> -       if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE) || !pmc_is_enabled(pmc))
>> -               return;
>> -
>> -       if (!check_pmu_event_filter(pmc))
>> -               return;
>> -
>> -       if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
>> -                         ARCH_PERFMON_EVENTSEL_INV |
>> -                         ARCH_PERFMON_EVENTSEL_CMASK |
>> -                         HSW_IN_TX |
>> -                         HSW_IN_TX_CHECKPOINTED))) {
>> -               config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
>> -               if (config != PERF_COUNT_HW_MAX)
>> -                       type = PERF_TYPE_HARDWARE;
>> -       }
>> -
>> -       if (type == PERF_TYPE_RAW)
>> -               config = eventsel & AMD64_RAW_EVENT_MASK;
>> -
>> -       if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
>> -               return;
>> -
>> -       pmc_release_perf_event(pmc);
>> -
>> -       pmc->current_config = eventsel;
>> -       pmc_reprogram_counter(pmc, type, config,
>> -                             !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
>> -                             !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
>> -                             eventsel & ARCH_PERFMON_EVENTSEL_INT,
>> -                             (eventsel & HSW_IN_TX),
>> -                             (eventsel & HSW_IN_TX_CHECKPOINTED));
>> -}
>> -
>> -static void reprogram_fixed_counter(struct kvm_pmc *pmc)
>> +static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
>>   {
>>          struct kvm_pmu *pmu = pmc_to_pmu(pmc);
>> -       int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
>> -       u8 ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl, idx);
>> -       unsigned en_field = ctrl & 0x3;
>> -       bool pmi = ctrl & 0x8;
>>
>> -       pmc_pause_counter(pmc);
>> +       if (pmc_is_fixed(pmc))
>> +               return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
>> +                       pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
>>
>> -       if (!en_field || !pmc_is_enabled(pmc))
>> -               return;
>> -
>> -       if (!check_pmu_event_filter(pmc))
>> -               return;
>> -
>> -       if (pmc->current_config == (u64)ctrl && pmc_resume_counter(pmc))
>> -               return;
>> -
>> -       pmc_release_perf_event(pmc);
>> -
>> -       pmc->current_config = (u64)ctrl;
>> -       pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
>> -                             kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc),
>> -                             !(en_field & 0x2), /* exclude user */
>> -                             !(en_field & 0x1), /* exclude kernel */
>> -                             pmi, false, false);
>> +       return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
>>   }
>>
>>   void reprogram_counter(struct kvm_pmc *pmc)
>>   {
>> -       if (pmc_is_gp(pmc))
>> -               reprogram_gp_counter(pmc);
>> -       else
>> -               reprogram_fixed_counter(pmc);
>> +       struct kvm_pmu *pmu = pmc_to_pmu(pmc);
>> +       u64 eventsel = pmc->eventsel;
>> +       u64 new_config = eventsel;
>> +       u8 fixed_ctr_ctrl;
>> +
>> +       pmc_pause_counter(pmc);
>> +
>> +       if (!pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
>> +               return;
>> +
>> +       if (!check_pmu_event_filter(pmc))
>> +               return;
>> +
>> +       if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
>> +               printk_once("kvm pmu: pin control bit is ignored\n");
>> +
>> +       if (pmc_is_fixed(pmc)) {
>> +               fixed_ctr_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl,
>> +                                                 pmc->idx - INTEL_PMC_IDX_FIXED);
>> +               if (fixed_ctr_ctrl & 0x1)
>> +                       eventsel |= ARCH_PERFMON_EVENTSEL_OS;
>> +               if (fixed_ctr_ctrl & 0x2)
>> +                       eventsel |= ARCH_PERFMON_EVENTSEL_USR;
>> +               if (fixed_ctr_ctrl & 0x8)
>> +                       eventsel |= ARCH_PERFMON_EVENTSEL_INT;
>> +               new_config = (u64)fixed_ctr_ctrl;
>> +       }
>> +
>> +       if (pmc->current_config == new_config && pmc_resume_counter(pmc))
>> +               return;
>> +
>> +       pmc_release_perf_event(pmc);
>> +
>> +       pmc->current_config = new_config;
>> +       pmc_reprogram_counter(pmc, PERF_TYPE_RAW,
>> +                       (eventsel & AMD64_RAW_EVENT_MASK),
>> +                       !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
>> +                       !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
>> +                       eventsel & ARCH_PERFMON_EVENTSEL_INT,
>> +                       (eventsel & HSW_IN_TX),
>> +                       (eventsel & HSW_IN_TX_CHECKPOINTED));
> 
> It seems that this extremely long argument list was motivated by the
> differences between the two original call sites. Now that you have
> mocked up a full eventsel (with USR, OS, INT, IN_TX, and IN_TXCP bits)
> for the fixed counters, why not pass the entire eventsel as the third

I've thought about it.

I'm trying to pass-in generic bits (EVENT_MASK, USER, OS, INT) to
pmc_reprogram_counter() and let the latter handle the implementation details
of assembling the "struct perf_event_attr" to talk carefully with perf core.

I suppose the fixed counters doesn't support IN_TX* bits and I try to
clean those two away in another patch as you know.

In terms of code readability, the current one achieves a good balance.

> argument and drop all of the rest? Then, pmc_reprogram_counter() can
> extract/check the bits of interest.
> 
>>   }
>>   EXPORT_SYMBOL_GPL(reprogram_counter);
>>
>> @@ -451,17 +426,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
>>          kvm_pmu_refresh(vcpu);
>>   }
>>
>> -static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
>> -{
>> -       struct kvm_pmu *pmu = pmc_to_pmu(pmc);
>> -
>> -       if (pmc_is_fixed(pmc))
>> -               return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
>> -                       pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
>> -
>> -       return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
>> -}
>> -
>>   /* Release perf_events for vPMCs that have been unused for a full time slice.  */
>>   void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
>>   {
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 19b78a9d9d47..d823fbe4e155 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -492,7 +492,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>          pmu->reserved_bits = 0xffffffff00200000ull;
>>
>>          entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
>> -       if (!entry || !vcpu->kvm->arch.enable_pmu)
>> +       if (!entry || !vcpu->kvm->arch.enable_pmu || !boot_cpu_has(X86_FEATURE_ARCH_PERFMON))
> 
> This change seems unrelated.

The intention of using the PERF_TYPE_HARDWARE type is to emulate guest architecture
PMU on a host without architecture PMU (the oldest Pentium 4), for which the 
guest vPMC
needs to be reprogrammed using the kernel generic perf_hw_id.

This is the most original story of PERF_TYPE_HARDWARE, thanks to history teacher 
Paolo,
who also suggested this way to drop this kind of support.

> 
>>                  return;
>>          eax.full = entry->eax;
>>          edx.full = entry->edx;
>> --
>> 2.35.1
>>
