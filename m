Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C0B2FFC48
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 06:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbhAVFcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 00:32:16 -0500
Received: from mga04.intel.com ([192.55.52.120]:18429 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbhAVFcO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 00:32:14 -0500
IronPort-SDR: WCDWQCTvniFY4mpZS+qh0YJfN6WUb3c9+DUacmvKg1OAHHGAaJc1uuddaWvfCc31J4rhvKQwxz
 tuWVIoVMIRvA==
X-IronPort-AV: E=McAfee;i="6000,8403,9871"; a="176819320"
X-IronPort-AV: E=Sophos;i="5.79,365,1602572400"; 
   d="scan'208";a="176819320"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 21:30:26 -0800
IronPort-SDR: XItnVAeefTRK2Jb69hVua/FZtbJXZhZJ5d9h39B8GOXIopNAb1/y2WwIFyp/FifMnCYRCXR1X5
 dUSJCum4v5eg==
X-IronPort-AV: E=Sophos;i="5.79,365,1602572400"; 
   d="scan'208";a="427665171"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 21:30:22 -0800
Subject: Re: [PATCH v3 04/17] perf: x86/ds: Handle guest PEBS overflow PMI and
 inject it to guest
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-5-like.xu@linux.intel.com>
 <YACTnkdi1rxfrRCg@google.com>
 <a0b5dc29-e63f-6ec9-a03f-6435cb3373c6@intel.com>
 <YAHT+zLiIg/oUygZ@google.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <9fa07da4-8ef4-f1f2-72a0-5d747e283912@linux.intel.com>
Date:   Fri, 22 Jan 2021 13:30:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YAHT+zLiIg/oUygZ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/16 1:42, Sean Christopherson wrote:
> On Fri, Jan 15, 2021, Xu, Like wrote:
>> On 2021/1/15 2:55, Sean Christopherson wrote:
>>> On Mon, Jan 04, 2021, Like Xu wrote:
>>>> +	 * Note: KVM disables the co-existence of guest PEBS and host PEBS.
>>> By "KVM", do you mean KVM's loading of the MSRs provided by intel_guest_get_msrs()?
>>> Because the PMU should really be the entity that controls guest vs. host.  KVM
>>> should just be a dumb pipe that handles the mechanics of how values are context
>>> switch.
>>
>> The intel_guest_get_msrs() and atomic_switch_perf_msrs()
>> will work together to disable the co-existence of guest PEBS and host PEBS:
>>
>> https://lore.kernel.org/kvm/961e6135-ff6d-86d1-3b7b-a1846ad0e4c4@intel.com/
>>
>> +
>>
>> static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>> ...
>>      if (nr_msrs > 2 && (msrs[1].guest & msrs[0].guest)) {
>>          msrs[2].guest = pmu->ds_area;
>>          if (nr_msrs > 3)
>>              msrs[3].guest = pmu->pebs_data_cfg;
>>      }
>>
>>     for (i = 0; i < nr_msrs; i++)
>> ...
> 
> Yeah, that's exactly what I'm complaining about.  Splitting the logic for
> determining the guest values is unnecessarily confusing, and as evidenced by the
> PEBS_ENABLE bug, potentially fragile.  Perf should have full knowledge and
> control of what values are loaded for the guest.  And, the above indexing magic
> is nigh impossible to follow and _super_ fragile.

Thanks for pointing this out.

> 
> If we change .guest_get_msrs() to take a struct kvm_pmu pointer, then it can
> generate the full set of guest values by grabbing ds_area and pebs_data_cfg.
> Alternatively, .guest_get_msrs() could take the desired guest MSR values
> directly (ds_area and pebs_data_cfg), but kvm_pmu is vendor agnostic, so I don't
> see any reason to not just pass the pointer.

Hi Peter,

What do you think of us passing a "struct kvm_pmu" pointer (defined in 
arch/x86/include/asm/kvm_host.h) to guest_get_msrs(int *nr) ?

---
thx,likexu

