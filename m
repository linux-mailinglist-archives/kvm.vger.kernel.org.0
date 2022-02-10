Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17C14B0DF3
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 13:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241839AbiBJM4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 07:56:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234200AbiBJM4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 07:56:08 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B191BD;
        Thu, 10 Feb 2022 04:56:09 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id y8so7324522pfa.11;
        Thu, 10 Feb 2022 04:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=gVKJwu5ERjnZG+6nDLNO4990OulCMrqau9J8QnEaUak=;
        b=jqyceszF7jyQsxmAF0DP4Y17pXPn7jQO2JQZ0z+nSfyH3FPKgnbkG+zVPNOXq5Fptg
         BkU6WSrT+9gauHWAq0mnlzvwixsqtlAJkghd1nxQBfgMmx6szjsVrosQwBFb33UKgCee
         EN9ElQKs8NwR8ndyXktqLoP9zn8gXpKWsafqdpsfFvtKQliM2pIUX3yeOFWp6NUU+s8Z
         /4Exxn6Mz2f01p2S4SK9nJdIsFIqDeZ6oYjRHtBNcRpYJLH5sZ35EXbkRRou/I9L5WSo
         ysSymDcaIDL54X8n7lRey0i8VeykGf31qt+HdP3tWMpT8cth0lJs3EEBGQuRtwevtY0c
         BNbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=gVKJwu5ERjnZG+6nDLNO4990OulCMrqau9J8QnEaUak=;
        b=amc7el1kwdm8hu3baHB+SmCh2Jn01t566NMSmxCrB6+ko/S0Re4NQi/4D2hWgWOhB/
         2SilfdZd5wft6Hzkw1dAuQMpRbBHHNzkLxTGTJNlQfdJ06at5Ude+vWqkNOQT8oIchTp
         qZh41x75VuRfMD6EQ1mT2SmRFDwkkG/BZ/B5jL3zDpvrKkVVsAzolpowM9EeIM3qvOhK
         a1oTmbmY8VNGS3dznWZYxwvonRbB7rf8hvue7I3+BG2W9zHe4AMqCf+QGtaoacecREo0
         9V6Ht4f9lSqd28Ao4BlE/xWOS/3jvkT8tqXcilyHJV+ZJ7jlN75wFyhtlfIKHFA3LoC3
         zlOg==
X-Gm-Message-State: AOAM531dkuVeJz19Mas/nHa2LP3bsPor5RNO18ZFQOTr0JktblRf2ufh
        963L6wkOZ/gpgFdFT/Qu2d0=
X-Google-Smtp-Source: ABdhPJxN5ItqmYGrMDr9Z3JwQkeo6Ly+mT8J3bXZF0BBgPdOhY106zoCEZHr54laiGx1AsQFA2TLGA==
X-Received: by 2002:a05:6a02:18e:: with SMTP id bj14mr6227006pgb.352.1644497769066;
        Thu, 10 Feb 2022 04:56:09 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v17sm22423250pfm.10.2022.02.10.04.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 04:56:08 -0800 (PST)
Message-ID: <76d94feb-3f9e-36da-5f5c-c9e047778b7e@gmail.com>
Date:   Thu, 10 Feb 2022 20:55:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Dunn <daviddunn@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Jim Mattson <jmattson@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
References: <20220117085307.93030-1-likexu@tencent.com>
 <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
 <YgO/3usazae9rCEh@hirez.programming.kicks-ass.net>
 <69c0fc41-a5bd-fea9-43f6-4724368baf66@intel.com>
 <CALMp9eS=1U7T39L-vL_cTXTNN2Li8epjtAPoP_+Hwefe9d+teQ@mail.gmail.com>
 <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/2/2022 2:57 am, Dave Hansen wrote:
> On 2/9/22 10:47, Jim Mattson wrote:
>> On Wed, Feb 9, 2022 at 7:41 AM Dave Hansen <dave.hansen@intel.com> wrote:
>>>
>>> On 2/9/22 05:21, Peter Zijlstra wrote:
>>>> On Wed, Feb 02, 2022 at 02:35:45PM -0800, Jim Mattson wrote:
>>>>> 3) TDX is going to pull the rug out from under us anyway. When the TDX
>>>>> module usurps control of the PMU, any active host counters are going
>>>>> to stop counting. We are going to need a way of telling the host perf
>>>>> subsystem what's happening, or other host perf clients are going to
>>>>> get bogus data.
>>>> That's not acceptible behaviour. I'm all for unilaterally killing any
>>>> guest that does this.
>>>
>>> I'm not sure where the "bogus data" comes or to what that refers
>>> specifically.  But, the host does have some level of control:
>>
>> I was referring to gaps in the collection of data that the host perf
>> subsystem doesn't know about if ATTRIBUTES.PERFMON is set for a TDX
>> guest. This can potentially be a problem if someone is trying to
>> measure events per unit of time.
> 
> Ahh, that makes sense.
> 
> Does SGX cause problem for these people?  It can create some of the same
> collection gaps:
> 
> 	performance monitoring activities are suppressed when entering
> 	an opt-out (of performance monitoring) enclave.
> 

Are the end perf user aware of the collection gaps caused by the code running 
under SGX?

As far as I know there shouldn't be one yet, we may need a tool like "perf-kvm" 
for SGX enclaves.

>>>> The host VMM controls whether a guest TD can use the performance
>>>> monitoring ISA using the TD’s ATTRIBUTES.PERFMON bit...
>>>
>>> So, worst-case, we don't need to threaten to kill guests.  The host can
>>> just deny access in the first place.

The KVM module parameter "enable_pmu" might be respected,
together with a per-TD guest user space control option.

>>>
>>> I'm not too picky about what the PMU does, but the TDX behavior didn't
>>> seem *that* onerous to me.  The gory details are all in "On-TD
>>> Performance Monitoring" here:
>>>
>>>> https://www.intel.com/content/dam/develop/external/us/en/documents/tdx-module-1.0-public-spec-v0.931.pdf
>>>
>>> My read on it is that TDX host _can_ cede the PMU to TDX guests if it
>>> wants.  I assume the context-switching model Jim mentioned is along the
>>> lines of what TDX is already doing on host<->guest transitions.
>>
>> Right. If ATTRIBUTES.PERFMON is set, then "perfmon state is
>> context-switched by the Intel TDX module across TD entry and exit
>> transitions." Furthermore, the VMM has no access to guest perfmon
>> state.

Even the guest TD is under off-TD debug and is untrusted ?

I think we (host administrators) need to profile off-TD guests to locate
performance bottlenecks with a holistic view, regardless of whether the
ATTRIBUTES.PERFMON bit is cleared or not.

Perhaps shared memory could be a way to pass guests performance data
to the host if PMU activities are suppressed across TD entry and exit
transitions for the guest TD is under off-TD debug and is untrusted.

>>
>> If you're saying that setting this bit is unacceptable, then perhaps
>> the TDX folks need to redesign their in-guest PMU support.
> 
> It's fine with *me*, but I'm not too picky about the PMU.  But, it
> sounded like Peter was pretty concerned about it.

One protocol I've seen is that the (TD or normal) guest cannot compromise
the host's availability to PMU resources (at least in the host runtime).

It's pretty fine and expected that performance data within the trusted TDX guest
should be logically isolated from host data (without artificial aggregation).

> 
> In any case, if we (Linux folks) need a change, it's *possible* because
> most of this policy is implemented in software in the TDX module.  It
> would just be painful for the folks who came up with the existing mechanism.
> 

When the code to enable ATTRIBUTES.PERFMON appears in the mailing list,
we can have more discussions in a very good time window.
