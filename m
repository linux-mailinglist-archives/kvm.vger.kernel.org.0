Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A722AE680
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 03:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgKKCmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 21:42:53 -0500
Received: from mga04.intel.com ([192.55.52.120]:21465 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgKKCmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 21:42:53 -0500
IronPort-SDR: Y8U+Arf3LcVopHzLHPawZh2c5lTtB3RPS+xzw4xf6h9I2SmwyzyLnH/UnqVFsNcoBeMqSddyR1
 BhWnlMj4ZQWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="167500828"
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="167500828"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 18:42:52 -0800
IronPort-SDR: jqmCJWUE7ySg9gl14UBrhIBZymWPQqwMQnLWztYZeD2pTKfwUhT5cRKTLcKMahURDd/I8rkEjI
 3s1W4aNJsG0w==
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="541595472"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.107]) ([10.238.4.107])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 18:42:48 -0800
Subject: Re: [PATCH] perf/intel: Remove Perfmon-v4 counter_freezing support
To:     Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
 <20201110151257.GP2611@hirez.programming.kicks-ass.net>
 <20201110153721.GQ2651@hirez.programming.kicks-ass.net>
 <CABPqkBS+-g0qbsruAMfOJf-Zfac8nz9v2LCWfrrvVd+ptoLxZg@mail.gmail.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <2ce24056-0711-26b3-a62c-3bedc88d7aa7@intel.com>
Date:   Wed, 11 Nov 2020 10:42:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <CABPqkBS+-g0qbsruAMfOJf-Zfac8nz9v2LCWfrrvVd+ptoLxZg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 2020/11/11 4:52, Stephane Eranian wrote:
> On Tue, Nov 10, 2020 at 7:37 AM Peter Zijlstra<peterz@infradead.org>  wrote:
>> On Tue, Nov 10, 2020 at 04:12:57PM +0100, Peter Zijlstra wrote:
>>> On Mon, Nov 09, 2020 at 10:12:37AM +0800, Like Xu wrote:
>>>> The Precise Event Based Sampling(PEBS) supported on Intel Ice Lake server
>>>> platforms can provide an architectural state of the instruction executed
>>>> after the instruction that caused the event. This patch set enables the
>>>> the PEBS via DS feature for KVM (also non) Linux guest on the Ice Lake.
>>>> The Linux guest can use PEBS feature like native:
>>>>
>>>>    # perf record -e instructions:ppp ./br_instr a
>>>>    # perf record -c 100000 -e instructions:pp ./br_instr a
>>>>
>>>> If the counter_freezing is not enabled on the host, the guest PEBS will
>>>> be disabled on purpose when host is using PEBS facility. By default,
>>>> KVM disables the co-existence of guest PEBS and host PEBS.
Thanks Stephane for clarifying the use cases for Freeze-on-[PMI|Overflow].

Please let me express it more clearly.

The goal of the whole patch set is to enable guest PEBS, regardless of
whether the counter_freezing is frozen or not. By default, it will not
support both the guest and the host to use PEBS at the same time.

Please continue reviewing the patch set, especially for the slow path
we proposed this time and related host perf changes:

- add intel_pmu_handle_guest_pebs() to __intel_pmu_pebs_event();
- add switch MSRs (PEBS_ENABLE, DS_AREA, DATA_CFG) to intel_guest_get_msrs();
- the construction of incoming parameters for 
perf_event_create_kernel_counter();

I believe if you understand the general idea, the comments will be very 
valuable.

Thanks,
Like Xu

>>> Uuhh, what?!? counter_freezing should never be enabled, its broken. Let
>>> me go delete all that code.
>> ---
>> Subject: perf/intel: Remove Perfmon-v4 counter_freezing support
>>
>> Perfmon-v4 counter freezing is fundamentally broken; remove this default
>> disabled code to make sure nobody uses it.
>>
>> The feature is called Freeze-on-PMI in the SDM, and if it would do that,
>> there wouldn't actually be a problem,*however*  it does something subtly
>> different. It globally disables the whole PMU when it raises the PMI,
>> not when the PMI hits.
>>
>> This means there's a window between the PMI getting raised and the PMI
>> actually getting served where we loose events and this violates the
>> perf counter independence. That is, a counting event should not result
>> in a different event count when there is a sampling event co-scheduled.
>>
> What is implemented is Freeze-on-Overflow, yet it is described as Freeze-on-PMI.
> That, in itself, is a problem. I agree with you on that point.
>
> However, there are use cases for both modes.
>
> I can sample on event A and count on B, C and when A overflows, I want
> to snapshot B, C.
> For that I want B, C at the moment of the overflow, not at the moment
> the PMI is delivered. Thus, youd
> would want the Freeze-on-overflow behavior. You can collect in this
> mode with the perf tool,
> IIRC: perf record -e '{cycles,instructions,branches:S}' ....
>
> The other usage model is that of the replay-debugger (rr) which you are alluding
> to, which needs precise count of an event including during the skid
> window. For that, you need
> Freeze-on-PMI (delivered). Note that this tool likely only cares about
> user level occurrences of events.
>
> As for counter independence, I am not sure it holds in all cases. If
> the events are setup for user+kernel
> then, as soon as you co-schedule a sampling event, you will likely get
> more counts on the counting
> event due to the additional kernel entries/exits caused by
> interrupt-based profiling. Even if you were to
> restrict to user level only, I would expect to see a few more counts.
>
>
>> This is known to break existing software.
>>
>> Signed-off-by: Peter Zijlstra (Intel)<peterz@infradead.org>

