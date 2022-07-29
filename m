Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0ED2584E12
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 11:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbiG2Jd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 05:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbiG2Jd4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 05:33:56 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA37E564DF;
        Fri, 29 Jul 2022 02:33:55 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id b133so4161721pfb.6;
        Fri, 29 Jul 2022 02:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=n7v7GIhdp8tVUQO1CPRpXJkxzUcOyBhqvldWOTo6n+s=;
        b=dqWJm2Chu+IEGzIXTJ/ifJj9SkjbrtV8plnK7hPiZXuycrZNyiLmhyqlUv26MOYkQB
         CfJnxdkd50lgNzEoyvx1neOLvNkt9Lyruzvjc/tz3F0stlzl4rVQb5a+5Bhip4lN9+jl
         r5AbXwmxwb7EM7hU0Zv6/gkC+x7JABKI8A3DDQb2Tew4O1dXbA0y8ASzAakUN9uftKX4
         ecJTMFFGh516ULKRsDmruRhsRYD9q+yPmiO2RFiALya+CY/z467pTGUBsGY4IEigeOL9
         BrdyBq22JX6GF5KpnflhYg+i7ShqPusWCQT1QwxlKme6NaccSHRC3W8FYFMNqzTI5cw7
         Nxug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=n7v7GIhdp8tVUQO1CPRpXJkxzUcOyBhqvldWOTo6n+s=;
        b=MXUSsa9rj7HDwTGNhkEYoaS3byb27z8UWMmvBRJ34mglzR8ZTKsEtQGotu10McfBo0
         xAsRMHLvLfm9gxyA7OmbCafiMEZsACRUty9JumNyQaQrxUnNvY7ycUHRz6DDFb+eezhC
         XhU239zPEiKN6Zv7h0c8bDtnmhH0r/6Ur/22+GL2I8+KbfFx47L0HyePN8SW6CTJW9ql
         fz/OYkz2m1ZEhuR2+EJC6znIfhABh3GQ6JAnA+MHb1OKq5EXarYmz/dconGaTGZBiaY6
         3DTSRsA0RmgAGIFYUneneHxFtMen8d+gwoOtpPmkD2HzH3MvXeXcoi3+AJqPNGsUEtgg
         RpYw==
X-Gm-Message-State: AJIora9Nu3b6en6IN/OXsauPV1iqSQ8ACGxKaPWWbHg/LG+rFnd12mIa
        cV8kZC6mMhVtFouZVAZKMGo=
X-Google-Smtp-Source: AGRyM1uCd9inC3nzGJFR44SjfR2WgmoFknzNMDbUrje3kVle+6OlIVQsdNKbtSWM0DsR3z85bBNNVg==
X-Received: by 2002:a63:8848:0:b0:412:a9d9:d405 with SMTP id l69-20020a638848000000b00412a9d9d405mr2228511pgd.384.1659087235092;
        Fri, 29 Jul 2022 02:33:55 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b0016d88f68dbfsm3053357plg.63.2022.07.29.02.33.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 02:33:54 -0700 (PDT)
Message-ID: <5090d500-1549-79ba-53a9-4929114eb569@gmail.com>
Date:   Fri, 29 Jul 2022 17:33:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH 1/3] KVM: x86: Refresh PMU after writes to
 MSR_IA32_PERF_CAPABILITIES
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220727233424.2968356-1-seanjc@google.com>
 <20220727233424.2968356-2-seanjc@google.com>
 <271bddfa-9e48-d5f6-6147-af346d7946bf@gmail.com>
 <YuKqyTvbVx2UyP2w@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <YuKqyTvbVx2UyP2w@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/7/2022 11:27 pm, Sean Christopherson wrote:
> On Thu, Jul 28, 2022, Like Xu wrote:
>> On 28/7/2022 7:34 am, Sean Christopherson wrote:
>>> Refresh the PMU if userspace modifies MSR_IA32_PERF_CAPABILITIES.  KVM
>>> consumes the vCPU's PERF_CAPABILITIES when enumerating PEBS support, but
>>> relies on CPUID updates to refresh the PMU.  I.e. KVM will do the wrong
>>> thing if userspace stuffs PERF_CAPABILITIES _after_ setting guest CPUID.
>>
>> Unwise userspace should reap its consequences if it does not break KVM or host.
> 
> I don't think this is a case of userspace being weird or unwise.  IMO, setting
> CPUID before MSRs is perfectly logical and intuitive.

The concern is whether to allow changing the semantically featured MSR value
(as an alternative to CPUID or KVM_CAP.) from user space after the guest CPUID
is finalized or the guest has run for a while.

Changing the presence semantics of related CPUID via a post-written msr-feature,
or vice versa, is seen as a user-space ill-advisedness. Based on the ill-advisedness
of the user space input, KVM's strange behaviour is to be expected. Right ?

A wise user space should take care of both PEBS CPUID and PEBS fields
in the PERF_CAPABILITIES, in whatever time order they are passed to KVM.
KVM implementation should treat them as equivalent for any availability check
(regardless of performance issue, it's my bad to traverse CPUID rathe than 
perf_cap).

If two or more settings cannot be coordinated with each other in the user space 
level,
KVM must choose to rely on one setting or another or check all settings (more 
expensive).

> 
>> When a guest feature can be defined/controlled by multiple KVM APIs entries,
>> (such as SET_CPUID2, msr_feature, KVM_CAP, module_para), should KVM
>> define the priority of these APIs (e.g. whether they can override each other) ?
> 
> KVM does have "rules" in the sense that it has an established ABI for things
> like KVM_CAP and module params, though documentation may be lacking in some cases.
> The CPUID and MSR ioctls don't have a prescribe ordering though.

Should we continue with this inter-dependence (as a silent feature) ?
The patch implies that it should be left as it is in order not to break any user 
space.

How we break out of this rut ?

> 
>> Removing this ambiguity ensures consistency in the architecture and behavior
>> of all KVM features.
> 
> Agreed, but the CPUID and MSR ioctls (among many others) have existed for quite
> some time.  KVM likely can't retroactively force a specific order without breaking
> one userspace or another.
> 
>> Any further performance optimizations can be based on these finalized values
>> as you do.
>>
>>>
>>> Opportunistically fix a curly-brace indentation.
>>>
>>> Fixes: c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")
>>> Cc: Like Xu <like.xu.linux@gmail.com>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    arch/x86/kvm/x86.c | 4 ++--
>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 5366f884e9a7..362c538285db 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -3543,9 +3543,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>    			return 1;
>>>    		vcpu->arch.perf_capabilities = data;
>>> -
>>> +		kvm_pmu_refresh(vcpu);
>>
>> I had proposed this diff but was met with silence.
> 
> My apologies, I either missed it or didn't connect the dots.
