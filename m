Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7303F2F7F28
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 16:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732429AbhAOPNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 10:13:13 -0500
Received: from mga06.intel.com ([134.134.136.31]:40521 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727719AbhAOPNM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 10:13:12 -0500
IronPort-SDR: 9hF5RDPqv+L5bMA891vlFdV1fpVpa/68mjZnTywI/vkMgxqv6b8jFaGDsU9G66fgj3QLXXyCj8
 Z2gYKW5PqVyA==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="240104676"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="240104676"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 07:12:32 -0800
IronPort-SDR: YMRvbCJfBgNMtsfli4winv39sw8mvETNYSyyFo7Vc/HVBypP1QY3aFIOoXdd4lvX71KuFz+uVO
 5Uam87Dptpag==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="382694568"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.174.174]) ([10.249.174.174])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 07:12:28 -0800
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
 <2c197d5a-09a8-968c-a942-c95d18983c9d@intel.com>
 <YAGqWNl2FKxVussV@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <18715b60-9510-566d-f533-d722d50145d1@intel.com>
Date:   Fri, 15 Jan 2021 23:12:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YAGqWNl2FKxVussV@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/15 22:44, Peter Zijlstra wrote:
> On Fri, Jan 15, 2021 at 10:30:13PM +0800, Xu, Like wrote:
>
>>> Are you sure? Spurious NMI/PMIs are known to happen anyway. We have far
>>> too much code to deal with them.
>> https://lore.kernel.org/lkml/20170628130748.GI5981@leverpostej/T/
>>
>> In the rr workload, the commit change "the PMI interrupts in skid region
>> should be dropped"
>> is reverted since some users complain that:
>>
>>> It seems to me that it might be reasonable to ignore the interrupt if
>>> the purpose of the interrupt is to trigger sampling of the CPUs
>>> register state.  But if the interrupt will trigger some other
>>> operation, such as a signal on an fd, then there's no reason to drop
>>> it.
>> I assume that if the PMI drop is unacceptable, either will spurious PMI
>> injection.
>>
>> I'm pretty open if you insist that we really need to do this for guest PEBS
>> enabling.
> That was an entirely different issue. We were dropping events on the
> floor because they'd passed priv boundaries. So there was an actual
> event, and we made it go away.

Thanks for your clarification and support.

> What we're talking about here is raising an PMI with BUFFER_OVF set,
> even if the DS is empty. That should really be harmless. We'll take the
> PMI, find there's nothing there, and do nothing.

The only harm point is confusing the guest PEBS user with
the behavior of pebs_interrupt_threshold.

Now that KVM has to break it due to cross-mapping issue,
Let me implement this idea in the next version w/ relevant performance data.


