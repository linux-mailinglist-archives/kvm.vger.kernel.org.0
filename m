Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0A1784F32
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 05:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbjHWDT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 23:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjHWDT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 23:19:56 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B726E4D
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 20:19:31 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id 006d021491bc7-570ca3e4f63so1956729eaf.1
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 20:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1692760770; x=1693365570;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ujpYk8vKKzKHm9A+vXj62Yec2XxblBjGH4PSetdizLE=;
        b=FZvceM4opcgE880iafq9GnzhIPzJ4+gK2HGqvgYeLQIVTcugbV5EzorngScgCv5spG
         A/aSwHG3COryNOsITsg8L75XGVcH4x9iZ14iCn9cqd7b1MUr8PO9kNG+W1DpblZglB2k
         mqITCV+aaqiVauWMpJ6nC1CH7ItCF4XzyN0dj8TW3CsJZI9mpPuD7h31FvA9slNOFrXv
         ZsQZoakKpSKw8GX8yLLICCsV0WG/7q3BOZ2fpTwdbBFZ58GtqaOT8lXL6obiD814X2yW
         PKOwwPCw/w2uZ2/MlgUFCU7vF+E0zzzTCH714Inw+9fbdqrgCg1anZr2YlT5AArDnhwY
         yk5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692760770; x=1693365570;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ujpYk8vKKzKHm9A+vXj62Yec2XxblBjGH4PSetdizLE=;
        b=fUhon+FDJ0HFLtJNmLnFcpKr65tnuOVno2h5XRVzhTXCkHf+tlv9MinWeaaseeUSJM
         m/Zham9TEV6fI6YZ4/x/n5jsHzemLM5rRsZXI72Bqw5/g4d+RQd1LHxE3DbRxQYfyVe4
         dV+X4ZIvsqsw/VTC0wguKlARrWFJsHhR5PiiEBd3M+J+0AMxUdWc+0Oy0jZd0UnVT1Mj
         kCoHtmYppeplZc299ZOGmoRpQuV/tUiR1kNb9t64JyDeYE37DefNkfWg5EPYHtTPtQsB
         GJgTpkUcOsnjlReilNUQWL6lTlEiBi0y1oSNotgw3kFW+sx4SwyU+inYcOaE9DEi6jV0
         7Y7Q==
X-Gm-Message-State: AOJu0YwxyC0WF5N6AKSAyoV0qiALtImIo+hpO8h/3oVMzXJVzXawmC1O
        tOCYAuD9iICbZ4LPjKZZmP3sBA==
X-Google-Smtp-Source: AGHT+IEch5i9ynoZtbJ6Wj/4Mlg5I3/gGj9zjxJlH+G6Ti3s5/v2krtEribent5HKHr6PaJccyZR+Q==
X-Received: by 2002:a05:6359:6784:b0:139:c75f:63eb with SMTP id sq4-20020a056359678400b00139c75f63ebmr8545969rwb.21.1692760770376;
        Tue, 22 Aug 2023 20:19:30 -0700 (PDT)
Received: from [10.3.220.88] ([61.213.176.13])
        by smtp.gmail.com with ESMTPSA id i10-20020a636d0a000000b0056c2f1a2f6bsm4192363pgc.41.2023.08.22.20.19.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Aug 2023 20:19:28 -0700 (PDT)
Message-ID: <ba2af89a-cdf4-4cb8-bfed-67034faa0f6e@bytedance.com>
Date:   Wed, 23 Aug 2023 11:19:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] KVM: arm/arm64: optimize vSGI injection performance
To:     Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhouyibo@bytedance.com,
        zhouliang.001@bytedance.com, Oliver Upton <oliver.upton@linux.dev>,
        kvmarm@lists.linux.dev, Mark Rutland <mark.rutland@arm.com>
References: <20230818104704.7651-1-zhaoxu.35@bytedance.com>
 <ZOMnZY_w83vTYnTo@FVFF77S0Q05N> <86msykg0ox.wl-maz@kernel.org>
 <b3e716ee-988a-49cd-996d-a27517aa8e91@bytedance.com>
 <86jztnfpl3.wl-maz@kernel.org>
From:   zhaoxu <zhaoxu.35@bytedance.com>
In-Reply-To: <86jztnfpl3.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2023/8/22 16:28, Marc Zyngier wrote:
> On Tue, 22 Aug 2023 04:51:30 +0100,
> zhaoxu <zhaoxu.35@bytedance.com> wrote:
>> In fact, the core vCPU search algorithm remains the same in the latest
>> kernel: iterate all vCPUs, if mpidr matches, inject. next version will
>> based on latest kernel.
> 
> My point is that performance numbers on such an ancient kernel hardly
> make any sense, as a large portion of the code will be different. We
> aim to live in the future, not in the past.
> 
Yes, i got it, thanks.
>>
>>> - which current guest OS *currently* make use of broadcast or 1:N
>>>     SGIs? Linux doesn't and overall SGI multicasting is pretty useless
>>>     to an OS.
>>>
>>> [...]
>> Yes, arm64 linux almost never send broadcast ipi. I will use another
>> test data to prove performence improvement
> 
> Exactly. I also contend that *no* operating system uses broadcast (or
> even multicast) signalling, because this is a very pointless
> operation.
> 
> So what are you optimising for?
> 
Explanation at the end.
>>>
>>>>>    /*
>>>>> - * Compare a given affinity (level 1-3 and a level 0 mask, from the SGI
>>>>> - * generation register ICC_SGI1R_EL1) with a given VCPU.
>>>>> - * If the VCPU's MPIDR matches, return the level0 affinity, otherwise
>>>>> - * return -1.
>>>>> + * Get affinity routing index from ICC_SGI_* register
>>>>> + * format:
>>>>> + *     aff3       aff2       aff1            aff0
>>>>> + * |- 8 bits -|- 8 bits -|- 8 bits -|- 4 bits or 8bits -|
>>>
>>> OK, so you are implementing RSS support:
>>>
>>> - Why isn't that mentioned anywhere in the commit log?
>>>
>>> - Given that KVM actively limits the MPIDR to 4 bits at Aff0, how does
>>>     it even work the first place?
>>>
>>> - How is that advertised to the guest?
>>>
>>> - How can the guest enable RSS support?
>>>
>> thanks to mention that, I also checked the relevant code, guest can't
>> enable RSS, it was my oversight. This part has removed in next
>> version.
> 
> Then what's the point of your patch? You don't explain anything, which
> makes it very hard to guess what you're aiming for.
This patch aims to optimize the vCPU search algorithm when injecting vSGI.

For example, in a 64-core VM, the CPU topology consists of 4 aff0 groups 
(0-15, 16-31, 32-47, 48-63). When the guest wants to send a SGI to core 
63, in the previous logic, kvm needs to iterate over all vCPUs to 
identify core 63 using the kvm_for_each_vcpu function, and then inject 
the vSGI into it. However, the ICC_SGI* register provides affinity 
routing information, enabling us to bypass the initial three aff0 
groups, starting with the last one. As a result, the iteration times 
will reduced from the number of vCPUs (64 in this case) to 16 or 8 
times(Using a mask to determine the distribution of a target list in 
ICC_SGI* register).

This optimization effect is evident under the following conditions: 1. A 
VM with more than 16 cores. 2. The inject target vCPU is located after 
the 16th core. Therefore, this patch must ensure that the performance 
will not deteriorate when the inject target is aff0 group (core 0-15), 
that’s the reason why I put these test data in the patch.
> 
>        M.
> 
	Xu.
