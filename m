Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C5E2F7E38
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 15:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731350AbhAOObF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 09:31:05 -0500
Received: from mga05.intel.com ([192.55.52.43]:31221 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbhAOObE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 09:31:04 -0500
IronPort-SDR: PXGn5dbfwb0INzVeZuDcWYSZO6B+8DtFirfH1kG3TxuE5xJD2+JJAYjTjj2aulv8CLCIS5D53V
 dVlVebakEgNg==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="263348034"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="263348034"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 06:30:23 -0800
IronPort-SDR: 4FsvEmS2/X+aI6EkThB/85Bj7aHrFu8rh3bYUNF8Gd+04nOwGYP/j0+4R7yBlOKzQB9PbiYuwH
 P6rq6QBqHkLQ==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="382680972"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.174.174]) ([10.249.174.174])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 06:30:19 -0800
Subject: Re: [PATCH v3 04/17] perf: x86/ds: Handle guest PEBS overflow PMI and
 inject it to guest
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-5-like.xu@linux.intel.com>
 <X/86UWuV/9yt14hQ@hirez.programming.kicks-ass.net>
 <9c343e40-bbdf-8af0-3307-5274070ee3d2@intel.com>
 <YAGEFgqQv281jVHc@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <2c197d5a-09a8-968c-a942-c95d18983c9d@intel.com>
Date:   Fri, 15 Jan 2021 22:30:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YAGEFgqQv281jVHc@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/15 20:01, Peter Zijlstra wrote:
> On Thu, Jan 14, 2021 at 11:39:00AM +0800, Xu, Like wrote:
>
>>> Why do we need to? Can't we simply always forward the PMI if the guest
>>> has bits set in MSR_IA32_PEBS_ENABLE ? Surely we can access the guest
>>> MSRs at a reasonable rate..
>>>
>>> Sure, it'll send too many PMIs, but is that really a problem?
>> More vPMI means more guest irq handler calls and
>> more PMI virtualization overhead.
> Only if you have both guest and host PEBS. And in that case I really
> can't be arsed about some overhead to the guest.

Less overhead makes everyone happier.

Ah, can I assume that you're fine with disabling the
co-existence of guest PEBS and host PEBS as the first upstream step ?

>
>> In addition,
>> the correctness of some workloads (RR?) depends on
>> the correct number of PMIs and the PMI trigger times
>> and virt may not want to break this assumption.
> Are you sure? Spurious NMI/PMIs are known to happen anyway. We have far
> too much code to deal with them.

https://lore.kernel.org/lkml/20170628130748.GI5981@leverpostej/T/

In the rr workload, the commit change "the PMI interrupts in skid region 
should be dropped"
is reverted since some users complain that:

> It seems to me that it might be reasonable to ignore the interrupt if
> the purpose of the interrupt is to trigger sampling of the CPUs
> register state.  But if the interrupt will trigger some other
> operation, such as a signal on an fd, then there's no reason to drop
> it.

I assume that if the PMI drop is unacceptable, either will spurious PMI 
injection.

I'm pretty open if you insist that we really need to do this for guest PEBS 
enabling.

>
>>>> +	 * If PEBS interrupt threshold on host is not exceeded in a NMI, there
>>>> +	 * must be a PEBS overflow PMI generated from the guest PEBS counters.
>>>> +	 * There is no ambiguity since the reported event in the PMI is guest
>>>> +	 * only. It gets handled correctly on a case by case base for each event.
>>>> +	 *
>>>> +	 * Note: KVM disables the co-existence of guest PEBS and host PEBS.
>>> Where; I need a code reference here.
>> How about:
>>
>> Note: KVM will disable the co-existence of guest PEBS and host PEBS.
>> In the intel_guest_get_msrs(), when we have host PEBS ctrl bit(s) enabled,
>> KVM will clear the guest PEBS ctrl enable bit(s) before vm-entry.
>> The guest PEBS users should be notified of this runtime restriction.
> Since you had me look at that function, can clean up that
> CONFIG_RETPOLINE crud and replace it with static_call() ?

Sure. Let me try it.

---
thx, likexu

