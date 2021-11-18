Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1BE455A49
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343995AbhKRLbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343997AbhKRL3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 06:29:45 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D356C061210;
        Thu, 18 Nov 2021 03:26:45 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id p17so5078598pgj.2;
        Thu, 18 Nov 2021 03:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=HbcBPjl/CgPhWyR8EGJxFeqoCcz/Im26xERRkTRsJVE=;
        b=fdcJFKtEEe/N3oiO0PXGJxzCO1DVsRsGaSYGWx3n8JzhRgr7mreSexDUTUIP+GqDaN
         WCQGE5/EK1heKKPrtoOBr+k0pgvTAD3Pcs/cuv8F+2uv60vaueuSvkKo+nHGiRscaaiB
         Jsjj5N9jf0TMAlQw78rs+LGHMuFLYPLtpuRJyamDSw3RbGc3Zy0ZZ6nW/ZTXL8ly8LjB
         sAd0FC8ZMUT3vBXAIL7Vc6TjSDyPpGYnHpJmiNBKD82yeq/AyhoGLtgsqHzQ2E47XQeV
         U/dBUJ7JPjNLew2V+0wnUxY2+uTLE3O135TvOsVHMUt48jaRIzI8KydES4RzsQiQXDVY
         m75A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=HbcBPjl/CgPhWyR8EGJxFeqoCcz/Im26xERRkTRsJVE=;
        b=lQktIChqja62rRlHmkzmvB65C6QXz+hA1u9ZwBqhH0MsDWY2KLrjUDuOxdIVAvkpAg
         kzpPyPxwbVJEkKs9s0nBmiEexRcajF2XG2ErI0fRJG9hAz/X/6QVjhCNUMKUAJoIn1KM
         tSjQBf6AAqRf0iJyN2mGGeOaLAzMi6zQZQcfrH0I14V2hW+SSt4/gyfbvDG4wAxqe7Vy
         LJrZqY6JuO4w3Ox6jXHM14qVIuQTX+KKh1TWKn8Z+T6qigTNdk48NgNJdhrXLGTc+WWI
         QW3dXJ/KKZt6INcaNyADaV/1SOM9WUhZPpx8Aw2jDz1UqE3iGDj17LGaHDs9t2ccmE/6
         WQOQ==
X-Gm-Message-State: AOAM532aJR0+e0RuH4Y4UtE8WMFYtjL5lU8ikBige445H1YnVJvLtglj
        i2CtVBvPd7qTWjVUHkkKAPU=
X-Google-Smtp-Source: ABdhPJwTpqdmuP41PuWg/EvQku7vKhRdxKEhZbmwiPbBPIEqItBhjdB9bDOGTfrk3JCfMKPbk3A0yw==
X-Received: by 2002:a05:6a00:a02:b0:47b:f59a:2c80 with SMTP id p2-20020a056a000a0200b0047bf59a2c80mr55672733pfh.41.1637234805021;
        Thu, 18 Nov 2021 03:26:45 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id k129sm2119992pgk.72.2021.11.18.03.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 03:26:44 -0800 (PST)
Message-ID: <92782a36-82ce-a76b-289b-3635f801d4a1@gmail.com>
Date:   Thu, 18 Nov 2021 19:26:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH 1/2] KVM: x86: Update vPMCs when retiring instructions
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org)" 
        <pbonzini@redhat.com>, Eric Hankland <ehankland@google.com>,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Peter Zijlstra (Intel OTC, Netherlander)" <peterz@infradead.org>
References: <20211112235235.1125060-1-jmattson@google.com>
 <20211112235235.1125060-2-jmattson@google.com>
 <fcb9aea5-2cf5-897f-5a3d-054ead555da4@gmail.com>
 <CALMp9eR5oi=ZrrEsZpcAJ7AP-Jo2cLGz9GA=SoTjX--TiG4=sw@mail.gmail.com>
 <afb108ed-a2f3-cb49-d0b4-b1bd6739cdb6@gmail.com>
 <CALMp9eSYvGW=EfuDCyc+fu7gVNnKHmEvFMackYcuZ-sGT8H5uA@mail.gmail.com>
 <CALMp9eTq2NwhB5cq_LknUjJncKHK2xPuQ5vpTaDN_zCDPT_JWw@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CALMp9eTq2NwhB5cq_LknUjJncKHK2xPuQ5vpTaDN_zCDPT_JWw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/11/2021 11:37 am, Jim Mattson wrote:
> On Wed, Nov 17, 2021 at 12:01 PM Jim Mattson <jmattson@google.com> wrote:
>>
>> On Tue, Nov 16, 2021 at 7:22 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>>
>>> On 17/11/2021 6:15 am, Jim Mattson wrote:
>>>> On Tue, Nov 16, 2021 at 4:44 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>>>>
>>>>> Hi Jim,
>>>>>
>>>>> On 13/11/2021 7:52 am, Jim Mattson wrote:
>>>>>> When KVM retires a guest instruction through emulation, increment any
>>>>>> vPMCs that are configured to monitor "instructions retired," and
>>>>>> update the sample period of those counters so that they will overflow
>>>>>> at the right time.
>>>>>>
>>>>>> Signed-off-by: Eric Hankland <ehankland@google.com>
>>>>>> [jmattson:
>>>>>>      - Split the code to increment "branch instructions retired" into a
>>>>>>        separate commit.
>>>>>>      - Added 'static' to kvm_pmu_incr_counter() definition.
>>>>>>      - Modified kvm_pmu_incr_counter() to check pmc->perf_event->state ==
>>>>>>        PERF_EVENT_STATE_ACTIVE.
>>>>>> ]
>>>>>> Signed-off-by: Jim Mattson <jmattson@google.com>
>>>>>> Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
>>>>>> ---
>>>>>>     arch/x86/kvm/pmu.c | 31 +++++++++++++++++++++++++++++++
>>>>>>     arch/x86/kvm/pmu.h |  1 +
>>>>>>     arch/x86/kvm/x86.c |  3 +++
>>>>>>     3 files changed, 35 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>>>>>> index 09873f6488f7..153c488032a5 100644
>>>>>> --- a/arch/x86/kvm/pmu.c
>>>>>> +++ b/arch/x86/kvm/pmu.c
>>>>>> @@ -490,6 +490,37 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
>>>>>>         kvm_pmu_reset(vcpu);
>>>>>>     }
>>>>>>
>>>>>> +static void kvm_pmu_incr_counter(struct kvm_pmc *pmc, u64 evt)
>>>>>> +{
>>>>>> +     u64 counter_value, sample_period;
>>>>>> +
>>>>>> +     if (pmc->perf_event &&
>>>>>
>>>>> We need to incr pmc->counter whether it has a perf_event or not.
>>>>>
>>>>>> +         pmc->perf_event->attr.type == PERF_TYPE_HARDWARE &&
>>>>>
>>>>> We need to cover PERF_TYPE_RAW as well, for example,
>>>>> it has the basic bits for "{ 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },"
>>>>> plus HSW_IN_TX or ARCH_PERFMON_EVENTSEL_EDGE stuff.
>>>>>
>>>>> We just need to focus on checking the select and umask bits:
>>>>
>>>> [What follows applies only to Intel CPUs. I haven't looked at AMD's
>>>> PMU implementation yet.]
>>>
>>> x86 has the same bit definition and semantics on at least the select and umask bits.
>>
>> Yes, but AMD supports 12 bits of event selector. AMD also has the
>> HG_ONLY bits, which affect whether or not to count the event based on
>> context.
> 
> It looks like we already have an issue with event selector truncation
> on the AMD side. It's not clear from the APM if AMD has always had a
> 12-bit event selector field, but it's 12 bits now. Milan, for example,
> has at least 6 different events with selectors > 255. I don't see how
> a guest could monitor those events with the existing KVM
> implementation.

Yes and I have reproduced the issue on a Milan.
Thanks for your input, and let me try to fix it.

Thanks,
Like Xu

