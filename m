Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BF824AD58
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 05:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgHTDcp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 23:32:45 -0400
Received: from mga06.intel.com ([134.134.136.31]:60344 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbgHTDcn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 23:32:43 -0400
IronPort-SDR: 4SRboyQGcOy9J7mluKLMzczxS02sZUQlSlNLLRBDGjDXHIzvYu23P5G52r8kXlfr3FxHtFVHcW
 RMfPKjWDdmDg==
X-IronPort-AV: E=McAfee;i="6000,8403,9718"; a="216765273"
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="216765273"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 20:32:42 -0700
IronPort-SDR: axVaO01PiEwdrsY0XR0Zs3O9fWoXIXfcdqJr+2+0OrOhS2gTJz67WfqAXaLG9BdFPh2R/m8ouo
 ZkY7Asw5Ghhg==
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="472477121"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.128]) ([10.238.4.128])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 20:32:36 -0700
Subject: Re: [PATCH v1 01/11] perf/x86/core: Support KVM to assign a dedicated
 counter for guest PEBS
To:     Peter Zijlstra <peterz@infradead.org>,
        "Paolo Bonzini (KVM Super Maintainer)" <pbonzini@redhat.com>
Cc:     "Kang, Luwei" <luwei.kang@intel.com>,
        "Liang, Kan" <kan.liang@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "alexander.shishkin@linux.intel.com" 
        <alexander.shishkin@linux.intel.com>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "pawan.kumar.gupta@linux.intel.com" 
        <pawan.kumar.gupta@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
 <1583431025-19802-2-git-send-email-luwei.kang@intel.com>
 <20200306135317.GD12561@hirez.programming.kicks-ass.net>
 <b72cb68e-1a0a-eeff-21b4-ce412e939cfd@linux.intel.com>
 <20200309100443.GG12561@hirez.programming.kicks-ass.net>
 <97ce1ba4-d75a-8db2-ea2f-7d334942b4e6@linux.intel.com>
 <20200309150526.GI12561@hirez.programming.kicks-ass.net>
 <DM5PR1101MB22667E832B3E9C1EF5389F2280810@DM5PR1101MB2266.namprd11.prod.outlook.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <34cb1d8c-d7c0-0dc1-49b2-072147f37379@linux.intel.com>
Date:   Thu, 20 Aug 2020 11:32:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <DM5PR1101MB22667E832B3E9C1EF5389F2280810@DM5PR1101MB2266.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 2020/6/12 13:28, Kang, Luwei wrote:
>>>> Suppose your KVM thing claims counter 0/2 (ICL/SKL) for some random
>>>> PEBS event, and then the host wants to use PREC_DIST.. Then one of
>>>> them will be screwed for no reason what so ever.
>>>>
>>>
>>> The multiplexing should be triggered.
>>>
>>> For host, if both user A and user B requires PREC_DIST, the
>>> multiplexing should be triggered for them.
>>> Now, the user B is KVM. I don't think there is difference. The
>>> multiplexing should still be triggered. Why it is screwed?
>>
>> Becuase if KVM isn't PREC_DIST we should be able to reschedule it to a
>> different counter.
>>
>>>> How is that not destroying scheduling freedom? Any other situation
>>>> we'd have moved the !PREC_DIST PEBS event to another counter.
>>>>
>>>
>>> All counters are equivalent for them. It doesn't matter if we move it
>>> to another counter. There is no impact for the user.
>>
>> But we cannot move it to another counter, because you're pinning it.
> 
> Hi Peter,
> 
> To avoid the pinning counters, I have tried to do some evaluation about
> patching the PEBS record for guest in KVM. In this approach, about ~30%
> time increased on guest PEBS PMI handler latency (
> e.g.perf record -e branch-loads:p -c 1000 ~/Tools/br_instr a).
> 
> Some implementation details as below:
> 1. Patching the guest PEBS records "Applicable Counters" filed when the guest
>       required counter is not the same with the host. Because the guest PEBS
>       driver will drop these PEBS records if the "Applicable Counters" not the
>       same with the required counter index.
> 2. Traping the guest driver's behavior(VM-exit) of disabling PEBS.
>       It happens before reading PEBS records (e.g. PEBS PMI handler, before
>       application exit and so on)
> 3. To patch the Guest PEBS records in KVM, we need to get the HPA of the
>       guest PEBS buffer.
>       <1> Trapping the guest write of IA32_DS_AREA register and get the GVA
>               of guest DS_AREA.
>       <2> Translate the DS AREA GVA to GPA(kvm_mmu_gva_to_gpa_read)
>               and get the GVA of guest PEBS buffer from DS AREA
>               (kvm_vcpu_read_guest_atomic).
>       <3> Although we have got the GVA of PEBS buffer, we need to do the
>               address translation(GVA->GPA->HPA) for each page. Because we can't
>               assume the GPAs of Guest PEBS buffer are always continuous.
> 	
> But we met another issue about the PEBS counter reset field in DS AREA.
> pebs_event_reset in DS area has to be set for auto reload, which is per
> counter. Guest and Host may use different counters. Let's say guest wants to
> use counter 0, but host assign counter 1 to guest. Guest sets the reset value to
> pebs_event_reset[0]. However, since counter 1 is the one which is eventually
> scheduled, HW will use  pebs_event_reset[1] as reset value.
> 
> We can't copy the value of the guest pebs_event_reset[0] to
> pebs_event_reset[1] directly(Patching DS AREA) because the guest driver may
> confused, and we can't assume the guest counter 0 and 1 are not used for this
> PEBS task at the same time. And what's more, KVM can't aware the guest
> read/write to the DS AREA because it just a general memory for guest.
> 
> What is your opinion or do you have a better proposal?

Do we have any update or clear attitude
on this "patching the PEBS record for guest in KVM" proposal ？

Thanks,
Like Xu

> 
> Thanks,
> Luwei Kang
> 
>>
>>> In the new proposal, KVM user is treated the same as other host events
>>> with event constraint. The scheduler is free to choose whether or not
>>> to assign a counter for it.
>>
>> That's what it does, I understand that. I'm saying that that is creating artificial
>> contention.
>>
>>
>> Why is this needed anyway? Can't we force the guest to flush and then move it
>> over to a new counter?

