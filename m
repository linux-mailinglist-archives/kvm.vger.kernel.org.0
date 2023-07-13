Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077E6751ED4
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 12:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbjGMK2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 06:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234215AbjGMK2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 06:28:00 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723CF19BC;
        Thu, 13 Jul 2023 03:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689244078; x=1720780078;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IgmhEnEWRArAeV2bgr4HI5p3nvygfOQwMwsR4Iha0mU=;
  b=QdiJI6fPXSlGbH/1rdcBeSWxNwSzUKJEYo/5v3mT5pEJvHvOHTkOk3DU
   tpsPWQqJsat02pkpWMwq0cZBewa3xOoUfxXOB7bz5z72F19crfk3NwazM
   Ke9JQM5snTUZ1efFygDApw/d5imtw6//ILbT2T5AZK1ELOePxzQWxYjxS
   aUtpWMLy8QbAIn1aOygfbUj54ZPgD5SnMD28Ub5WPYwi90cQZbLDwNk71
   yvlQIgJ9DSo2Li5TMxHfU0wxPY/dJxyba86aT1z3+kwXAfOi/NQGvgO4N
   1WkkFLLYqlDroBAQ0+bZ87mqZIwMXaQs0mguDoq5tIjdoU08GH3Ufeb1U
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="368684071"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="368684071"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 03:27:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="866498761"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="866498761"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.28.138]) ([10.93.28.138])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 03:27:49 -0700
Message-ID: <93e37735-f0d6-9603-615e-e17d59a7b537@intel.com>
Date:   Thu, 13 Jul 2023 18:27:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [RFC 0/3] KVM: x86: introduce pv feature lazy tscdeadline
To:     Zhi Wang <zhi.wang.linux@gmail.com>,
        Wang Jianchao <jianchwa@outlook.com>
Cc:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, arkinjob@outlook.com,
        linux-kernel@vger.kernel.org
References: <BYAPR03MB4133436C792BBF9EC6D77672CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
 <20230712211453.000025f6.zhi.wang.linux@gmail.com>
 <BYAPR03MB4133E3A1487ED160FBB59E0CCD37A@BYAPR03MB4133.namprd03.prod.outlook.com>
 <20230713095755.00003d27.zhi.wang.linux@gmail.com>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230713095755.00003d27.zhi.wang.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/13/2023 2:57 PM, Zhi Wang wrote:
> On Thu, 13 Jul 2023 10:50:36 +0800
> Wang Jianchao <jianchwa@outlook.com> wrote:
> 
>>
>>
>> On 2023.07.13 02:14, Zhi Wang wrote:
>>> On Fri,  7 Jul 2023 14:17:58 +0800
>>> Wang Jianchao <jianchwa@outlook.com> wrote:
>>>
>>>> Hi
>>>>
>>>> This patchset attemps to introduce a new pv feature, lazy tscdeadline.
>>>> Everytime guest write msr of MSR_IA32_TSC_DEADLINE, a vm-exit occurs
>>>> and host side handle it. However, a lot of the vm-exit is unnecessary
>>>> because the timer is often over-written before it expires.
>>>>
>>>> v : write to msr of tsc deadline
>>>> | : timer armed by tsc deadline
>>>>
>>>>           v v v v v        | | | | |
>>>> --------------------------------------->  Time
>>>>
>>>> The timer armed by msr write is over-written before expires and the
>>>> vm-exit caused by it are wasted. The lazy tscdeadline works as following,
>>>>
>>>>           v v v v v        |       |
>>>> --------------------------------------->  Time
>>>>                            '- arm -'
>>>>
>>>
>>> Interesting patch.
>>>
>>> I am a little bit confused of the chart above. It seems the write of MSR,
>>> which is said to cause VM exit, is not reduced in the chart of lazy
>>> tscdeadline, only the times of arm are getting less. And the benefit of
>>> lazy tscdeadline is said coming from "less vm exit". Maybe it is better
>>> to imporve the chart a little bit to help people jump into the idea
>>> easily?
>>
>> Thanks so much for you comment and sorry for my poor chart.
>>
> 
> You don't have to say sorry here. :) Save it for later when you actually
> break something.
> 
>> Let me try to rework the chart.
>>
>> Before this patch, every time guest start or modify a hrtimer, we need to write the msr of tsc deadline,
>> a vm-exit occurs and host arms a hv or sw timer for it.
>>
>>
>> w: write msr
>> x: vm-exit
>> t: hv or sw timer
>>
>>
>> Guest
>>           w
>> --------------------------------------->  Time
>> Host     x              t
>>   
>>
>> However, in some workload that needs setup timer frequently, msr of tscdeadline is usually overwritten
>> many times before the timer expires. And every time we modify the tscdeadline, a vm-exit ocurrs
>>
>>
>> 1. write to msr with t0
>>
>> Guest
>>           w0
>> ---------------------------------------->  Time
>> Host     x0             t0
>>
>>   
>> 2. write to msr with t1
>> Guest
>>               w1
>> ------------------------------------------>  Time
>> Host         x1          t0->t1
>>
>>
>> 2. write to msr with t2
>> Guest
>>                  w2
>> ------------------------------------------>  Time
>> Host            x2          t1->t2
>>   
>>
>> 3. write to msr with t3
>> Guest
>>                      w3
>> ------------------------------------------>  Time
>> Host                x3           t2->t3
>>
>>
>>
>> What this patch want to do is to eliminate the vm-exit of x1 x2 and x3 as following,
>>
>>
>> Firstly, we have two fields shared between guest and host as other pv features, saying,
>>   - armed, the value of tscdeadline that has a timer in host side, only updated by __host__ side
>>   - pending, the next value of tscdeadline, only updated by __guest__ side
>>
>>
>> 1. write to msr with t0
>>
>>               armed   : t0
>>               pending : t0
>> Guest
>>           w0
>> ---------------------------------------->  Time
>> Host     x0             t0
>>
>> vm-exit occurs and arms a timer for t0 in host side
>>
>>   
>> 2. write to msr with t1
>>
>>               armed   : t0
>>               pending : t1
>>
>> Guest
>>               w1
>> ------------------------------------------>  Time
>> Host                     t0
>>
>> the value of tsc deadline that has been armed, namely t0, is smaller than t1, needn't to write
>> to msr but just update pending
>>
>>
>> 3. write to msr with t2
>>
>>               armed   : t0
>>               pending : t2
>>   
>> Guest
>>                  w2
>> ------------------------------------------>  Time
>> Host                      t0
>>   
>> Similar with step 2, just update pending field with t2, no vm-exit
>>
>>
>> 4.  write to msr with t3
>>
>>               armed   : t0
>>               pending : t3
>>
>> Guest
>>                      w3
>> ------------------------------------------>  Time
>> Host                       t0
>> Similar with step 2, just update pending field with t3, no vm-exit
>>
>>
>> 5.  t0 expires, arm t3
>>
>>               armed   : t3
>>               pending : t3
>>
>>
>> Guest
>>                              
>> ------------------------------------------>  Time
>> Host                       t0  ------> t3
>>
>> t0 is fired, it checks the pending field and re-arm a timer based on it.
>>
>>
>> Here is the core ideal of this patch ;)
>>
> 
> That's much better. Please keep this in the cover letter in the next RFC.
> 
> My concern about this approach is: it might slightly affect timing
> sensitive workload in the guest, as the approach merges the deadline
> interrupt. The guest might see less deadline interrupts than before. It
> might be better to have a comparison of number of deadline interrupts
> in the cover letter.

I don't think guest will get less deadline interrupts since the deadline 
is updated always before the timer expires.

However, host will get more deadline interrupt because timer for t0 is 
not disarmed when new deadline (t1, t2, t3) is programmed.


