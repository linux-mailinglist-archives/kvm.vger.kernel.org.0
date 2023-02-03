Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69027688F3B
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 06:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbjBCF7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 00:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjBCF7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 00:59:54 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0F36FD2F;
        Thu,  2 Feb 2023 21:59:53 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id n2so2841571pfo.3;
        Thu, 02 Feb 2023 21:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X/vaU3Sg2F/eUBMFHqD3MA69l323THpXmYdZXpW+Tyk=;
        b=m8n5hoXlyHjMqOXX1qgb5q983jJP18mBmPdP6gB7cWEJMS3br2zlc2DR8+yTwyg7qK
         uRpGqXxg7HBCtxQwtCgBjKVA2jHzrEnc6NBoEYHNVyPlyn3+CUCES+Lz3j5jtGynKZAS
         D10Ex57b7zwlH3uj5JoBTxE4FH/j9yEoXw3WjH3YgR7HdyMNAtILXv5BMKI+tp51HP6N
         vhY0VAisUD4urEmLws5WDnXB6Y7PRkEWtzgPp1TJd+rZb0y5anPZ4fWKfs+FcIvfNs/G
         TYbA2R63Ys1QyISsTqquq9rUlnFxrVu/u6MRMip15XpnkM5Bc/7djCAcvktpub0xSjLo
         r4xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X/vaU3Sg2F/eUBMFHqD3MA69l323THpXmYdZXpW+Tyk=;
        b=NHLesr2itburp431celVe0MqqcvXCqn+ciV7zIxa+eM57l55H/pjIjpgKsQ0kF/CyP
         mUkEWBvNSHwBMlJuTXj9Nz+oqAMgckivWnGHkKsnYJsfvxEvSB+eFL0CExwJkLbWP8A/
         zg0ZlGeMkHwzGMELtEkuTpal0pNRRivkPhbRVShFrHevScQt3dxKhO8Mzve4p87cPXV6
         hZKBCyyE2yw1Rhonsd0GAxWjRuY/9qYKxR3q5upeSLBwjIpH36UMoys76PCAqPFJO59Y
         BkZsJBTVuJI6JGVdnmUY+KPYlKvYTogqwchazpAZxubSUMN8xV48hdYXy1z5zF2WDfKW
         rxfQ==
X-Gm-Message-State: AO0yUKVdBvuNVddcepl3X3aQMa8SS9Ydj86LkZE7wUmJK1/GCyslNqbi
        1+iLQHtaBiIwbEpQ8SWtVts=
X-Google-Smtp-Source: AK7set8XA/jh/lRsEGpF/TDEBH461DhyoZ5x5KVCFTY8Mf/8x03MhHFR+Xr1Yxucg2FRE0EOvq3pLQ==
X-Received: by 2002:a05:6a00:26f2:b0:593:c7d4:22b0 with SMTP id p50-20020a056a0026f200b00593c7d422b0mr6907787pfw.2.1675403992420;
        Thu, 02 Feb 2023 21:59:52 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a33-20020a056a001d2100b005941ff79428sm733317pfx.90.2023.02.02.21.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 21:59:51 -0800 (PST)
Message-ID: <79bab707-6592-0c45-d21f-c3014362bb82@gmail.com>
Date:   Fri, 3 Feb 2023 13:59:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH] KVM: x86/pmu: Disallow legacy LBRs if architectural LBRs
 are available
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Weijiang <weijiang.yang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230128001427.2548858-1-seanjc@google.com>
 <f106a06e-ae6f-2c79-df87-721817aacc02@gmail.com>
 <Y9wK/LkBYusOv1DO@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y9wK/LkBYusOv1DO@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/2/2023 3:11 am, Sean Christopherson wrote:
> On Tue, Jan 31, 2023, Like Xu wrote:
>> On 28/1/2023 8:14 am, Sean Christopherson wrote:
>>> Disallow enabling LBR support if the CPU supports architectural LBRs.
>>> Traditional LBR support is absent on CPU models that have architectural
>>> LBRs, and KVM doesn't yet support arch LBRs, i.e. KVM will pass through
>>> non-existent MSRs if userspace enables LBRs for the guest.
>>
>> True, we have call_trace due to MSR_ARCH_LBR_FROM_0 (0x1500) for example.
>>
>>>
>>> Cc: stable@vger.kernel.org
>>> Cc: Yang Weijiang <weijiang.yang@intel.com>
>>> Cc: Like Xu <like.xu.linux@gmail.com>
>>
>> Tested-by: Like Xu <likexu@tencent.com>
>>
>>> Reported-by: Paolo Bonzini <pbonzini@redhat.com>
>>
>> Fixes: 145dfad998ea ("KVM: VMX: Advertise PMU LBRs if and only if perf
>> supports LBRs")
> 
> If we want a fixes, I'd argue this is more appropriate:
> 
>    Fixes: be635e34c284 ("KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES")
> 
> Though I'd prefer not to blame KVM, there's not much we could have done in KVM
> to know that Intel would effectively break backwards compatibility.

Personally, I assume the bigger role of the Fix tag is to help the stable tree's
bots make it easier to back port patches automatically, and there will be less
sense of blame for the developers. In pmu scope, if a feature is not "architecture",
I'm not surprised that a new arrival will break compatibility, and sometimes
kernel developers need to plan ahead.

> 
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>
>>> Am I missing something that would prevent this scenario?
>>>
>>>    arch/x86/kvm/vmx/vmx.c | 8 +++++---
>>>    1 file changed, 5 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index 8f0f67c75f35..77ee6b4a5ec4 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -7761,9 +7761,11 @@ static u64 vmx_get_perf_capabilities(void)
>>>    	if (boot_cpu_has(X86_FEATURE_PDCM))
>>>    		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
>>> -	x86_perf_get_lbr(&lbr);
>>> -	if (lbr.nr)
>>> -		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
>>> +	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR)) {
>>
>> To avoid changing this again in the Arch lbr enabling part, how about:
>>
>> 	x86_perf_get_lbr(&lbr);
>> 	if (lbr.nr && cpu_feature_enabled(X86_FEATURE_ARCH_LBR) ==
>> 	    kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
>> 		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
>>
>> ?
> 
> I'd rather force arch LBR enabling to explicitly update this code.  And I'd prefer
> that KVM explicitly clear PMU_CAP_LBR_FMT when KVM can't use arch LBRs for whatever
> reason, both for documentation purposes and to avoid ordering dependencies between
> consuming vmx_get_perf_capabilities() and updating kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR).

Indeed, we have too many assumptions about the order of function calls in the 
kernel world.
"Avoid ordering dependencies" looks good to me. Thanks.
