Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59503303BC2
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 12:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405267AbhAZLgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 06:36:10 -0500
Received: from mga07.intel.com ([134.134.136.100]:6108 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392519AbhAZLgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 06:36:00 -0500
IronPort-SDR: /22Pi39QT/Dbj4kXdHIOEUKL9vmRCNQEJBblZ0q1TdwlvbKBqJIWKV6b2aefV666145f9oFJAT
 P1YQKbaj707A==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="243967464"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="243967464"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 03:35:15 -0800
IronPort-SDR: Vg+lqfCQ2ir7vbOY6UBID19xkT+JjPuBM561szN2irDGFvDoHTpbN9inYffIhYHgQiXANptSkH
 rddDnZ3fwHsA==
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="387792575"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.170.244]) ([10.249.170.244])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 03:35:05 -0800
Subject: Re: [PATCH] perf/intel: Remove Perfmon-v4 counter_freezing support
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
 <20201110151257.GP2611@hirez.programming.kicks-ass.net>
 <20201110153721.GQ2651@hirez.programming.kicks-ass.net>
 <CABPqkBS+-g0qbsruAMfOJf-Zfac8nz9v2LCWfrrvVd+ptoLxZg@mail.gmail.com>
 <2ce24056-0711-26b3-a62c-3bedc88d7aa7@intel.com>
 <9a85e154-d552-3478-6e99-3f693b3da7ed@redhat.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <0d26d8fc-5192-afbc-abab-88dd3d428eca@intel.com>
Date:   Tue, 26 Jan 2021 19:35:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <9a85e154-d552-3478-6e99-3f693b3da7ed@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/26 17:51, Paolo Bonzini wrote:
> On 11/11/20 03:42, Xu, Like wrote:
>> Hi Peter,
>>
>> On 2020/11/11 4:52, Stephane Eranian wrote:
>>> On Tue, Nov 10, 2020 at 7:37 AM Peter Zijlstra<peterz@infradead.org>  
>>> wrote:
>>>> On Tue, Nov 10, 2020 at 04:12:57PM +0100, Peter Zijlstra wrote:
>>>>> On Mon, Nov 09, 2020 at 10:12:37AM +0800, Like Xu wrote:
>>>>>> The Precise Event Based Sampling(PEBS) supported on Intel Ice Lake 
>>>>>> server
>>>>>> platforms can provide an architectural state of the instruction 
>>>>>> executed
>>>>>> after the instruction that caused the event. This patch set enables the
>>>>>> the PEBS via DS feature for KVM (also non) Linux guest on the Ice Lake.
>>>>>> The Linux guest can use PEBS feature like native:
>>>>>>
>>>>>>    # perf record -e instructions:ppp ./br_instr a
>>>>>>    # perf record -c 100000 -e instructions:pp ./br_instr a
>>>>>>
>>>>>> If the counter_freezing is not enabled on the host, the guest PEBS will
>>>>>> be disabled on purpose when host is using PEBS facility. By default,
>>>>>> KVM disables the co-existence of guest PEBS and host PEBS.
>> Thanks Stephane for clarifying the use cases for Freeze-on-[PMI|Overflow].
>>
>> Please let me express it more clearly.
>>
>> The goal of the whole patch set is to enable guest PEBS, regardless of
>> whether the counter_freezing is frozen or not. By default, it will not
>> support both the guest and the host to use PEBS at the same time.
>>
>> Please continue reviewing the patch set, especially for the slow path
>> we proposed this time and related host perf changes:
>>
>> - add intel_pmu_handle_guest_pebs() to __intel_pmu_pebs_event();
>> - add switch MSRs (PEBS_ENABLE, DS_AREA, DATA_CFG) to 
>> intel_guest_get_msrs();
>> - the construction of incoming parameters for 
>> perf_event_create_kernel_counter();
>>
>> I believe if you understand the general idea, the comments will be very 
>> valuable.
>
> What is the state of this work?  I was expecting a new version that 
> doesn't use counter_freezing.  However, I see that counter_freezing is 
> still in there, so this patch from Peter has never been applied.
>
> Paolo

Ah, now we have the v3 version on guest PEBS feature.
It does not rely on counter_freezing, but disables the co-existence of 
guest PEBS and host PEBS.
I am not clear about your attitude towards this co-existence.

There are also more interesting topics for you to review and comment.
Please check 
https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/
