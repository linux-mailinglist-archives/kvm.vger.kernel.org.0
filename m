Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB4A4B9BAE
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 10:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238420AbiBQJGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 04:06:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbiBQJGA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 04:06:00 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3907423DCFA;
        Thu, 17 Feb 2022 01:05:47 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id p8so588348pfh.8;
        Thu, 17 Feb 2022 01:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=USatb+AiRveRUIEu8ru5AbhgkcCKRQncgwcir0ybSxM=;
        b=lP+xhGn4MzLMLL9Y04k8MQJY2LVZow/+7PJsY5hMqwwbzmuTj2+KFKdFfZfLL7Fqo7
         Klsr4BK0ubgehql2kbCbTdM0x1Freq8XVzQYmDql1lnjmqnOOHw9WlyLRQvNjFV/6FzR
         LDV7QEOD8jVBOlTU/bNrs4s+ZUyw9jLclZfOBv0gSAsIXwfHRoProZ11w0xxK9eZ287M
         E0KNgwKWkbQE7QJ9xXKoTWYFhTzQ7S6p8mtx0b76ZBRii7rOTIFeZNeHy4Xh4WZfrxpx
         qIHBWG8AnrWeWd9Jk6++3teQMMiJRXa3vk/jCH9DlW97BviwUZVy++orXOKV0VVYW8Do
         r2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=USatb+AiRveRUIEu8ru5AbhgkcCKRQncgwcir0ybSxM=;
        b=zQF6NWiZGUx8QgOfpo/se0dFn0pF4vAxW9QEDbfPP8d14pHCZXnEuzdMMfcB6Trgo2
         gwtuRgVN+hS7QMRxbKC4UgsKfqdej+XXoyBTQO4arlUQCRanx8cVou2qJeD5U6u9Ew62
         g2vuYoAV/cHT3jSYQ3biEg9NQoedg3nkRUJ2w0JrbiNABUb3O3PG1Sg1bBN8VcT9arnG
         nDzZK/Aooc5uzjNTQlksF0WhXRZ7zx2MFXJwJ9otkSdbpUsUYK7FopQNvR3URyt6KFnQ
         KsD/p9/nJfXxECEWLtjFQTMd4NBsp9NyJejvWUrN5tt9TnajfSeCA1kvu/c7etpGuVcw
         4o4A==
X-Gm-Message-State: AOAM532frbdhEOiQX6g6bpWHhEKpIdMnj9H9KhkjFHJyiRbZ1/q65Xd3
        85ic9uBIn7K+JS2+Nt+lGUA=
X-Google-Smtp-Source: ABdhPJw6ulGrJMLX8IlMQbeBsPM0OhoUXLbX/CMSV+maYTY7VemkFMRS5s82MFBgWQgiGnc7/xFAgQ==
X-Received: by 2002:a63:e411:0:b0:342:a17:cad1 with SMTP id a17-20020a63e411000000b003420a17cad1mr1654903pgi.457.1645088746767;
        Thu, 17 Feb 2022 01:05:46 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 69sm7644601pgc.61.2022.02.17.01.05.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 01:05:46 -0800 (PST)
Message-ID: <ebd57e6b-c4c4-cdd5-6bd0-c872f2e0382d@gmail.com>
Date:   Thu, 17 Feb 2022 17:05:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH] KVM: x86/pmu: Distinguish EVENTSEL bitmasks for uniform
 event creation and filtering
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220210102603.42764-1-likexu@tencent.com>
 <CALMp9eQBzWUk2UBz3EP-YJizEypOnpL0whrmb1ttnFA8TNuspA@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CALMp9eQBzWUk2UBz3EP-YJizEypOnpL0whrmb1ttnFA8TNuspA@mail.gmail.com>
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

On 10/2/2022 10:09 pm, Jim Mattson wrote:
> On Thu, Feb 10, 2022 at 2:26 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> The current usage of EVENTSEL_* macro is a mess in the KVM context. Partly
>> because we have a conceptual ambiguity when choosing to create a RAW or
>> HARDWARE event: when bits other than HARDWARE_EVENT_MASK are set,
>> the pmc_reprogram_counter() will use the RAW type.
>>
>> By introducing the new macro AMD64_EXTRA_EVENTSEL_EVENT to simplify,
>> the following three issues can be addressed in one go:
>>
>> - the 12 selection bits are used as comparison keys for allow or deny;
>> - NON_HARDWARE_EVENT_MASK is only used to determine if a HARDWARE
>>    event is programmed or not, a 12-bit selected event will be a RAW event;
>>    (jmattson helped report this issue)
>> - by reusing AMD64_RAW_EVENT_MASK, the extra 4 selection bits (if set) are
>>    passed to the perf correctly and not filtered out by X86_RAW_EVENT_MASK;.
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/include/asm/perf_event.h |  3 ++-
>>   arch/x86/kvm/pmu.c                | 11 ++++-------
>>   arch/x86/kvm/pmu.h                |  6 ++++++
>>   3 files changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
>> index 8fc1b5003713..bd068fd19043 100644
>> --- a/arch/x86/include/asm/perf_event.h
>> +++ b/arch/x86/include/asm/perf_event.h
>> @@ -43,8 +43,9 @@
>>   #define AMD64_EVENTSEL_INT_CORE_SEL_MASK               \
>>          (0xFULL << AMD64_EVENTSEL_INT_CORE_SEL_SHIFT)
>>
>> +#define AMD64_EXTRA_EVENTSEL_EVENT                             (0x0FULL << 32)
>>   #define AMD64_EVENTSEL_EVENT   \
>> -       (ARCH_PERFMON_EVENTSEL_EVENT | (0x0FULL << 32))
>> +       (ARCH_PERFMON_EVENTSEL_EVENT | AMD64_EXTRA_EVENTSEL_EVENT)
>>   #define INTEL_ARCH_EVENT_MASK  \
>>          (ARCH_PERFMON_EVENTSEL_UMASK | ARCH_PERFMON_EVENTSEL_EVENT)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 2c98f3ee8df4..99426a8d7f18 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -198,7 +198,8 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>>
>>          filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
>>          if (filter) {
>> -               __u64 key = eventsel & AMD64_RAW_EVENT_MASK_NB;
>> +               __u64 key = eventsel & (INTEL_ARCH_EVENT_MASK |
>> +                                       AMD64_EXTRA_EVENTSEL_EVENT);
>>
>>                  if (bsearch(&key, filter->events, filter->nevents,
>>                              sizeof(__u64), cmp_u64))
>> @@ -209,18 +210,14 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>>          if (!allow_event)
>>                  return;
>>
>> -       if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
>> -                         ARCH_PERFMON_EVENTSEL_INV |
>> -                         ARCH_PERFMON_EVENTSEL_CMASK |
>> -                         HSW_IN_TX |
>> -                         HSW_IN_TX_CHECKPOINTED))) {
>> +       if (!(eventsel & NON_HARDWARE_EVENT_MASK)) {
> 
> I still don't understand why we even bother doing this lookup in the
> first place. What's wrong with simply requesting PERF_TYPE_RAW every
> time?

Thanks for the constant chasing, I finally got a reply from Peterz:
"think so; the HARDWARE is just a convenience wrapper over RAW IIRC".

Let me take this step and clean it up a bit.
