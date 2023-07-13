Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3997524A9
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 16:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbjGMOJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 10:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbjGMOJ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 10:09:57 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6ED61998;
        Thu, 13 Jul 2023 07:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689257396; x=1720793396;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nqdEZTgsNGeRzBdlPkYQmuACZnzYsRBxWOC1j3tf6do=;
  b=VKyMQVjsLjuRpu5e2g5rG4pQ74anyHXPNI1tSTSyFvok3/34LqhpwfL+
   4kE6KMAbeu5p81m3fKwRVB3avTU2PNsgRWjQ/bZ85hXmvhoHjocUNK3+i
   1ZBrDt+SxcixChRFbck5oGItvZQHSSKuARGEzTVluoro4h79DHZgxPsLO
   uU7aatjFGJATDff5LnWdEOTxdGl3YYetPmksIzVl/UTD2BJlu9J0mNNGM
   kfwnDPVAzaqEruYHHbbVuSglwhTKpXAuWeAm2JxaF/OwKzEOvpRtteOYX
   XSo4dl37PWgp8w6o+saQiEc/wKV9kAXtbKAZPOlMP1tFfwArn5Rxv8OqO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="428952173"
X-IronPort-AV: E=Sophos;i="6.01,203,1684825200"; 
   d="scan'208";a="428952173"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 06:32:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="792029413"
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="792029413"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.18.246]) ([10.93.18.246])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 06:32:14 -0700
Message-ID: <a6fd8266-54a8-bb4b-f3d2-643a94e27e9e@intel.com>
Date:   Thu, 13 Jul 2023 21:32:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [RFC 0/3] KVM: x86: introduce pv feature lazy tscdeadline
Content-Language: en-US
To:     Wang Jianchao <jianchwa@outlook.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, arkinjob@outlook.com,
        linux-kernel@vger.kernel.org
References: <BYAPR03MB4133436C792BBF9EC6D77672CD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
 <20230712211453.000025f6.zhi.wang.linux@gmail.com>
 <BYAPR03MB4133E3A1487ED160FBB59E0CCD37A@BYAPR03MB4133.namprd03.prod.outlook.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <BYAPR03MB4133E3A1487ED160FBB59E0CCD37A@BYAPR03MB4133.namprd03.prod.outlook.com>
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

On 7/13/2023 10:50 AM, Wang Jianchao wrote:
> 
> 
> On 2023.07.13 02:14, Zhi Wang wrote:
>> On Fri,  7 Jul 2023 14:17:58 +0800
>> Wang Jianchao <jianchwa@outlook.com> wrote:
>>
>>> Hi
>>>
>>> This patchset attemps to introduce a new pv feature, lazy tscdeadline.
>>> Everytime guest write msr of MSR_IA32_TSC_DEADLINE, a vm-exit occurs
>>> and host side handle it. However, a lot of the vm-exit is unnecessary
>>> because the timer is often over-written before it expires.
>>>
>>> v : write to msr of tsc deadline
>>> | : timer armed by tsc deadline
>>>
>>>           v v v v v        | | | | |
>>> --------------------------------------->  Time
>>>
>>> The timer armed by msr write is over-written before expires and the
>>> vm-exit caused by it are wasted. The lazy tscdeadline works as following,
>>>
>>>           v v v v v        |       |
>>> --------------------------------------->  Time
>>>                            '- arm -'
>>>
>>
>> Interesting patch.
>>
>> I am a little bit confused of the chart above. It seems the write of MSR,
>> which is said to cause VM exit, is not reduced in the chart of lazy
>> tscdeadline, only the times of arm are getting less. And the benefit of
>> lazy tscdeadline is said coming from "less vm exit". Maybe it is better
>> to imporve the chart a little bit to help people jump into the idea
>> easily?
> 
> Thanks so much for you comment and sorry for my poor chart.
> 
> Let me try to rework the chart.
> 
> Before this patch, every time guest start or modify a hrtimer, we need to write the msr of tsc deadline,
> a vm-exit occurs and host arms a hv or sw timer for it.
> 
> 
> w: write msr
> x: vm-exit
> t: hv or sw timer
> 
> 
> Guest
>           w
> --------------------------------------->  Time
> Host     x              t
>   
> 
> However, in some workload that needs setup timer frequently, msr of tscdeadline is usually overwritten
> many times before the timer expires. And every time we modify the tscdeadline, a vm-exit ocurrs
> 
> 
> 1. write to msr with t0
> 
> Guest
>           w0
> ---------------------------------------->  Time
> Host     x0             t0
> 
>   
> 2. write to msr with t1
> Guest
>               w1
> ------------------------------------------>  Time
> Host         x1          t0->t1
> 
> 
> 2. write to msr with t2
> Guest
>                  w2
> ------------------------------------------>  Time
> Host            x2          t1->t2
>   
> 
> 3. write to msr with t3
> Guest
>                      w3
> ------------------------------------------>  Time
> Host                x3           t2->t3
> 
> 
> 
> What this patch want to do is to eliminate the vm-exit of x1 x2 and x3 as following,
> 
> 
> Firstly, we have two fields shared between guest and host as other pv features, saying,
>   - armed, the value of tscdeadline that has a timer in host side, only updated by __host__ side
>   - pending, the next value of tscdeadline, only updated by __guest__ side
> 
> 
> 1. write to msr with t0
> 
>               armed   : t0
>               pending : t0
> Guest
>           w0
> ---------------------------------------->  Time
> Host     x0             t0
> 
> vm-exit occurs and arms a timer for t0 in host side

What's the initial value of @armed and @pending?

>   
> 2. write to msr with t1
> 
>               armed   : t0
>               pending : t1
> 
> Guest
>               w1
> ------------------------------------------>  Time
> Host                     t0
> 
> the value of tsc deadline that has been armed, namely t0, is smaller than t1, needn't to write
> to msr but just update pending

if t1 < t0, then it triggers the vm exit, right?
And in this case, I think @armed will be updated to t1. What about 
pending? will it get updated to t1 or not?

> 
> 3. write to msr with t2
> 
>               armed   : t0
>               pending : t2
>   
> Guest
>                  w2
> ------------------------------------------>  Time
> Host                      t0
>   
> Similar with step 2, just update pending field with t2, no vm-exit
> 
> 
> 4.  write to msr with t3
> 
>               armed   : t0
>               pending : t3
> 
> Guest
>                      w3
> ------------------------------------------>  Time
> Host                       t0
> Similar with step 2, just update pending field with t3, no vm-exit
> 
> 
> 5.  t0 expires, arm t3
> 
>               armed   : t3
>               pending : t3
> 
> 
> Guest
>                              
> ------------------------------------------>  Time
> Host                       t0  ------> t3
> 
> t0 is fired, it checks the pending field and re-arm a timer based on it.
> 
> 
> Here is the core ideal of this patch ;)
> 
> 
> Thanks
> Jianchao
> 
>>
>>> The 1st timer is responsible for arming the next timer. When the armed
>>> timer is expired, it will check pending and arm a new timer.
>>>
>>> In the netperf test with TCP_RR on loopback, this lazy_tscdeadline can
>>> reduce vm-exit obviously.
>>>
>>>                           Close               Open
>>> --------------------------------------------------------
>>> VM-Exit
>>>               sum         12617503            5815737
>>>              intr      0% 37023            0% 33002
>>>             cpuid      0% 1                0% 0
>>>              halt     19% 2503932         47% 2780683
>>>         msr-write     79% 10046340        51% 2966824
>>>             pause      0% 90               0% 84
>>>     ept-violation      0% 584              0% 336
>>>     ept-misconfig      0% 0                0% 2
>>> preemption-timer      0% 29518            0% 34800
>>> -------------------------------------------------------
>>> MSR-Write
>>>              sum          10046455            2966864
>>>          apic-icr     25% 2533498         93% 2781235
>>>      tsc-deadline     74% 7512945          6% 185629
>>>
>>> This patchset is made and tested on 6.4.0, includes 3 patches,
>>>
>>> The 1st one adds necessary data structures for this feature
>>> The 2nd one adds the specific msr operations between guest and host
>>> The 3rd one are the one make this feature works.
>>>
>>> Any comment is welcome.
>>>
>>> Thanks
>>> Jianchao
>>>
>>> Wang Jianchao (3)
>>> 	KVM: x86: add msr register and data structure for lazy tscdeadline
>>> 	KVM: x86: exchange info about lazy_tscdeadline with msr
>>> 	KVM: X86: add lazy tscdeadline support to reduce vm-exit of msr-write
>>>
>>>
>>>   arch/x86/include/asm/kvm_host.h      |  10 ++++++++
>>>   arch/x86/include/uapi/asm/kvm_para.h |   9 +++++++
>>>   arch/x86/kernel/apic/apic.c          |  47 ++++++++++++++++++++++++++++++++++-
>>>   arch/x86/kernel/kvm.c                |  13 ++++++++++
>>>   arch/x86/kvm/cpuid.c                 |   1 +
>>>   arch/x86/kvm/lapic.c                 | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
>>>   arch/x86/kvm/lapic.h                 |   4 +++
>>>   arch/x86/kvm/x86.c                   |  26 ++++++++++++++++++++
>>>   8 files changed, 229 insertions(+), 9 deletions(-)
>>

