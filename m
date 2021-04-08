Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA27357E54
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 10:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhDHIob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 04:44:31 -0400
Received: from mga07.intel.com ([134.134.136.100]:46106 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229588AbhDHIob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 04:44:31 -0400
IronPort-SDR: HRQzzJjrF9otLwiqVZilH5a7EA/0HWBqrupB715Zu8zzY0boJz7E7surNThLNK66T6cEZ5qk00
 DlC3YBxc4smg==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="257477051"
X-IronPort-AV: E=Sophos;i="5.82,205,1613462400"; 
   d="scan'208";a="257477051"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 01:44:19 -0700
IronPort-SDR: ndJ9uh+y3ZENsCyinQKz6gZyzFsEZSAQW9ZLGg0BfUEVJ5Agw6izh9rpXAwEgMwWja+KvegCzE
 HdGPIBFp0/BA==
X-IronPort-AV: E=Sophos;i="5.82,205,1613462400"; 
   d="scan'208";a="458736086"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 01:44:15 -0700
Subject: Re: [PATCH v4 08/16] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to
 manage guest DS buffer
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Like Xu <like.xu@linux.intel.com>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
 <20210329054137.120994-9-like.xu@linux.intel.com>
 <YG3SPsiFJPeXQXhq@hirez.programming.kicks-ass.net>
 <610bfd14-3250-0542-2d93-cbd15f2b4e16@intel.com>
 <YG62VBBix2WVy3XA@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <f226e7b0-b419-06d3-cc55-8c8defd51cfc@intel.com>
Date:   Thu, 8 Apr 2021 16:44:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YG62VBBix2WVy3XA@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/4/8 15:52, Peter Zijlstra wrote:
> On Thu, Apr 08, 2021 at 01:39:49PM +0800, Xu, Like wrote:
>> Hi Peter,
>>
>> Thanks for your detailed comments.
>>
>> If you have more comments for other patches, please let me know.
>>
>> On 2021/4/7 23:39, Peter Zijlstra wrote:
>>> On Mon, Mar 29, 2021 at 01:41:29PM +0800, Like Xu wrote:
>>>> @@ -3869,10 +3876,12 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>>>>    		if (arr[1].guest)
>>>>    			arr[0].guest |= arr[1].guest;
>>>> -		else
>>>> +		else {
>>>>    			arr[1].guest = arr[1].host;
>>>> +			arr[2].guest = arr[2].host;
>>>> +		}
>>> What's all this gibberish?
>>>
>>> The way I read that it says:
>>>
>>> 	if guest has PEBS_ENABLED
>>> 		guest GLOBAL_CTRL |= PEBS_ENABLED
>>> 	otherwise
>>> 		guest PEBS_ENABLED = host PEBS_ENABLED
>>> 		guest DS_AREA = host DS_AREA
>>>
>>> which is just completely random garbage afaict. Why would you leak host
>>> msrs into the guest?
>> In fact, this is not a leak at all.
>>
>> When we do "arr[i].guest = arr[i].host;" assignment in the
>> intel_guest_get_msrs(), the KVM will check "if (msrs[i].host ==
>> msrs[i].guest)" and if so, it disables the atomic switch for this msr
>> during vmx transaction in the caller atomic_switch_perf_msrs().
> Another marvel of bad coding style that function is :-( Lots of missing
> {} and indentation fail.

Sorry for that and I'll fix them.

>
> This is terrible though, why would we clear the guest MSRs when it
> changes PEBS_ENABLED.

The values of arr[1].host and arr[1].guest depend on the arrangement of 
host perf:

         arr[1].host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask;
         arr[1].guest = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;

rather than the guest value of PEBS_ENABLE.

When the value of this msr is different across vmx-transaction,
we will load arr[1].host after vm-exit and load arr[1].guest before vm-entry.

If the value of this msr is the same before and after vmx-transaction,
we do nothing and keep the original value on the register.

> The guest had better clear them itself.

I don't understand what you are referring to here.

Can you explain what you think is the correct behavior here ?

> Removing
> guest DS_AREA just because we don't have any bits set in PEBS_ENABLED is
> wrong and could very break all sorts of drivers.

Except for PEBS, other features that rely on DS_AREA are not available in 
the guest .

Can you explain more of your concerns for DS_AREA switch ?

>
>> In that case, the msr value doesn't change and any guest write will be
>> trapped.  If the next check is "msrs[i].host != msrs[i].guest", the
>> atomic switch will be triggered again.
>>
>> Compared to before, this part of the logic has not changed, which helps to
>> reduce overhead.
> It's unreadable garbage at best. If you don't want it changed, then
> don't add it to the arr[] thing in the first place.

Thanks, adding GLOBAL_CTRL to arr[] in the last step is a better choice.

>
>>> Why would you change guest GLOBAL_CTRL implicitly;
>> This is because in the early part of this function, we have operations:
>>
>>      if (x86_pmu.flags & PMU_FL_PEBS_ALL)
>>          arr[0].guest &= ~cpuc->pebs_enabled;
>>      else
>>          arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
>>
>> and if guest has PEBS_ENABLED, we need these bits back for PEBS counters:
>>
>>      arr[0].guest |= arr[1].guest;
> I don't think that's right, who's to say they were set in the first
> place? The guest's GLOBAL_CTRL could have had the bits cleared at VMEXIT
> time.

Please note the guest GLOBAL_CTRL value is stored in the pmu->global_ctrl,
while the actual loaded value for GLOBAL_CTRL msr after vm-entry is
"x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask".

> You can't unconditionally add PEBS_ENABLED into GLOBAL_CTRL,
> that's wrong.

The determination of the msr values ​​before and after vmx-transaction
are always in the context of host perf which means the PEBS perf_events
created by the KVM are all scheduled on and used legally , and it does not
depend on the guest values at all.

>
>>> guest had better wrmsr that himself to control when stuff is enabled.
>> When vm_entry, the msr value of GLOBAL_CTRL on the hardware may be
>> different from trapped value "pmu->global_ctrl" written by the guest.
>>
>> If the perf scheduler cross maps guest counter X to the host counter Y,
>> we have to enable the bit Y in GLOBAL_CTRL before vm_entry rather than X.
> Sure, but I don't see that happening here.

Just fire questions if we're not on the same page or you're out of KVM context.


