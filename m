Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242D73597DB
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 10:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhDIIav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 04:30:51 -0400
Received: from mga04.intel.com ([192.55.52.120]:33479 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhDIIaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 04:30:46 -0400
IronPort-SDR: vCmdpw6qkvdchWVgDxL27j1UYzpZJeFaOF2KG/b7nrqEdMw/DjvYOY5j6xBSlk1spC+lqz9pTU
 aagJfMMKgdkg==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="191567606"
X-IronPort-AV: E=Sophos;i="5.82,208,1613462400"; 
   d="scan'208";a="191567606"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 01:30:20 -0700
IronPort-SDR: 4CBP2n1UCbEC7IphgTOX8DUauUMyRWtHmry8kTdOXTVsmp+gl8H8HheMpe6u6ma3gJ906fAXkm
 5opdCzW0kPrg==
X-IronPort-AV: E=Sophos;i="5.82,208,1613462400"; 
   d="scan'208";a="416174376"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 01:30:16 -0700
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
 <8695f271-9da9-f16d-15f2-e2757186db65@intel.com>
 <YHAJXh2AtSMcC5xf@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <9ec0e0ba-bef6-710e-1e9c-36beaedae16e@intel.com>
Date:   Fri, 9 Apr 2021 16:30:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YHAJXh2AtSMcC5xf@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/4/9 15:59, Peter Zijlstra wrote:
> On Fri, Apr 09, 2021 at 03:07:38PM +0800, Xu, Like wrote:
>> Hi Peter,
>>
>> On 2021/4/8 15:52, Peter Zijlstra wrote:
>>>> This is because in the early part of this function, we have operations:
>>>>
>>>>       if (x86_pmu.flags & PMU_FL_PEBS_ALL)
>>>>           arr[0].guest &= ~cpuc->pebs_enabled;
>>>>       else
>>>>           arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
>>>>
>>>> and if guest has PEBS_ENABLED, we need these bits back for PEBS counters:
>>>>
>>>>       arr[0].guest |= arr[1].guest;
>>> I don't think that's right, who's to say they were set in the first
>>> place? The guest's GLOBAL_CTRL could have had the bits cleared at VMEXIT
>>> time. You can't unconditionally add PEBS_ENABLED into GLOBAL_CTRL,
>>> that's wrong.
>> I can't keep up with you on this comment and would you explain more ?
> Well, it could be I'm terminally confused on how virt works (I usually
> am, it just doesn't make any sense ever).

I may help you a little on this.

>
> On top of that this code doesn't have any comments to help.

More comments will be added.

>
> So perf_guest_switch_msr has two msr values: guest and host.
>
> In my naive understanding guest is the msr value the guest sees and host
> is the value the host has. If it is not that, then the naming is just
> misleading at best.
>
> But thinking more about it, if these are fully emulated MSRs (which I
> think they are), then there might actually be 3 different values, not 2.

You are right about 3 different values.

>
> We have the value the guest sees when it uses {RD,WR}MSR.
> We have the value the hardware has when it runs a guest.
> We have the value the hardware has when it doesn't run a guest.
>
> And somehow this code does something, but I can't for the life of me
> figure out what and how.

Just focus on the last two values and the enabling bits (on the GLOBAL_CTRL
and PEBS_ENABLE) of "the value the hardware has when it runs a guest"
are exclusive with "the value the hardware has when it doesn't run a guest."

>> To address your previous comments, does the code below look good to you?
>>
>> static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>> {
>>      struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>>      struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
>>      struct debug_store *ds = __this_cpu_read(cpu_hw_events.ds);
>>      struct kvm_pmu *pmu = (struct kvm_pmu *)data;
>>      u64 pebs_mask = (x86_pmu.flags & PMU_FL_PEBS_ALL) ?
>>              cpuc->pebs_enabled : (cpuc->pebs_enabled & PEBS_COUNTER_MASK);
>>      int i = 0;
>>
>>      arr[i].msr = MSR_CORE_PERF_GLOBAL_CTRL;
>>      arr[i].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
>>      arr[i].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
>>      arr[i].guest &= ~pebs_mask;
>>
>>      if (!x86_pmu.pebs)
>>          goto out;
>>
>>      /*
>>       * If PMU counter has PEBS enabled it is not enough to
>>       * disable counter on a guest entry since PEBS memory
>>       * write can overshoot guest entry and corrupt guest
>>       * memory. Disabling PEBS solves the problem.
>>       *
>>       * Don't do this if the CPU already enforces it.
>>       */
>>      if (x86_pmu.pebs_no_isolation) {
>>          i++;
>>          arr[i].msr = MSR_IA32_PEBS_ENABLE;
>>          arr[i].host = cpuc->pebs_enabled;
>>          arr[i].guest = 0;
>>          goto out;
>>      }
>>
>>      if (!pmu || !x86_pmu.pebs_vmx)
>>          goto out;
>>
>>      i++;
>>      arr[i].msr = MSR_IA32_DS_AREA;
>>      arr[i].host = (unsigned long)ds;
>>      arr[i].guest = pmu->ds_area;
>>
>>      if (x86_pmu.intel_cap.pebs_baseline) {
>>          i++;
>>          arr[i].msr = MSR_PEBS_DATA_CFG;
>>          arr[i].host = cpuc->pebs_data_cfg;
>>          arr[i].guest = pmu->pebs_data_cfg;
>>      }
>>
>>      i++;
>>      arr[i].msr = MSR_IA32_PEBS_ENABLE;
>>      arr[i].host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask;
>>      arr[i].guest = pebs_mask & ~cpuc->intel_ctrl_host_mask;
>>
>>      if (arr[i].host) {
>>          /* Disable guest PEBS if host PEBS is enabled. */
>>          arr[i].guest = 0;
>>      } else {
>>          /* Disable guest PEBS for cross-mapped PEBS counters. */
>>          arr[i].guest &= ~pmu->host_cross_mapped_mask;
>>          arr[0].guest |= arr[i].guest;
>>      }
>>
>> out:
>>      *nr = ++i;
>>      return arr;
>> }
> The ++ is in a weird location, if you place it after filling out an
> entry it makes more sense I think. Something like:
>
> 	arr[i].msr = MSR_CORE_PERF_GLOBAL_CTRL;
> 	arr[i].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
> 	arr[i].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
> 	arr[i].guest &= ~pebs_mask;
> 	i++;
>
> or, perhaps even like:
>
> 	arr[i++] = (struct perf_guest_switch_msr){
> 		.msr = MSR_CORE_PERF_GLOBAL_CTRL,
> 		.host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
> 		.guest = x86_pmu.intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
> 	};

The later one looks good to me and I'll apply it.

> But it doesn't address the fundamental confusion I seem to be having,
> what actual msr value is what.

VMX hardware has the capability to switch MSR values atomically：
- for vm-entry instruction, it loads the value of arr[i].guest to arr[i].msr;
- for vm-exit instruction, it loads the value of arr[i].host to arr[i].msr;

The intel_guest_get_msrs() will populate arr[i].guest and arr[i].host values
before each vm-entry and its caller does the optimization to skip the switch
if arr[i].guest == arr[i].host.

Just let me know if you have more questions,
otherwise I assume we have reached an agreement on this part of code.
