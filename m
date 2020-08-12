Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18572429E0
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 14:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbgHLM46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 08:56:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:57977 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727977AbgHLM45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 08:56:57 -0400
IronPort-SDR: 4c5hsD7oNS8j//x5JDjKNcMPAzIj5A8mLL+QGUxVwCuJi6xKFhLRaI6U7GH13MjstRj+o/qXGv
 66Psvvn9itQw==
X-IronPort-AV: E=McAfee;i="6000,8403,9710"; a="141565529"
X-IronPort-AV: E=Sophos;i="5.76,304,1592895600"; 
   d="scan'208";a="141565529"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2020 05:56:56 -0700
IronPort-SDR: vb0plur+z9CHm3M4u+Sb1rVDBOrjsBMYZgDSSGvqYZ3vcsJFEZaJHxUVfkcENt3E4Dl3uuh9P+
 na8O+ccUp+uA==
X-IronPort-AV: E=Sophos;i="5.76,304,1592895600"; 
   d="scan'208";a="469812685"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.255.29.234]) ([10.255.29.234])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2020 05:56:52 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH] KVM: x86/pmu: Add '.exclude_hv = 1' for guest perf_event
To:     Paolo Bonzini <pbonzini@redhat.com>, peterz@infradead.org
Cc:     Like Xu <like.xu@linux.intel.com>, Yao <yao.jin@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
References: <20200812050722.25824-1-like.xu@linux.intel.com>
 <5c41978e-8341-a179-b724-9aa6e7e8a073@redhat.com>
 <20200812111115.GO2674@hirez.programming.kicks-ass.net>
 <65eddd3c-c901-1c5a-681f-f0cb07b5fbb1@redhat.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <b55afd09-77c8-398b-309b-6bd9f9cfc876@intel.com>
Date:   Wed, 12 Aug 2020 20:56:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <65eddd3c-c901-1c5a-681f-f0cb07b5fbb1@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/8/12 19:32, Paolo Bonzini wrote:
> On 12/08/20 13:11, peterz@infradead.org wrote:
>>> x86 does not have a hypervisor privilege level, so it never uses
>> Arguably it does when Xen, but I don't think we support that, so *phew*.
> Yeah, I suppose you could imagine having paravirtualized perf counters
> where the Xen privileged domain could ask Xen to run perf counters on
> itself.
>
>>> exclude_hv; exclude_host already excludes all root mode activity for
>>> both ring0 and ring3.
>> Right, but we want to tighten the permission checks and not excluding_hv
>> is just sloppy.
> I would just document that it's ignored as it doesn't make sense.  ARM64
> does that too, for new processors where the kernel is not itself split
> between supervisor and hypervisor privilege levels.
>
> There are people that are trying to run Linux-based firmware and have
> SMM handlers as part of the kernel.  Perhaps they could use exclude_hv
> to exclude the SMM handlers from perf (if including them is possible at
> all).
Hi Paolo,

My proposal is to define:
the "hypervisor privilege levels" events in the KVM/x86 context as
all the host kernel events plus /dev/kvm user space events.

If we add ".exclude_hv = 1" in the pmc_reprogram_counter(),
do you see any side effect to cover the above usages?

The fact that exclude_hv has never been used in x86 does help
the generic perf code to handle permission checks in a more concise way.

Thanks,
Like Xu
>> The thing is, we very much do not want to allow unpriv user to be able
>> to create: exclude_host=1, exclude_guest=0 counters (they currently
>> can).
> That would be the case of an unprivileged user that wants to measure
> performance of its guests.  It's a scenario that makes a lot of sense,
> are you worried about side channels?  Can perf-events on guests leak
> more about the host than perf-events on a random userspace program?
>
>> Also, exclude_host is really poorly defined:
>>
>>    https://lkml.kernel.org/r/20200806091827.GY2674@hirez.programming.kicks-ass.net
>>
>>    "Suppose we have nested virt:
>>
>> 	  L0-hv
>> 	  |
>> 	  G0/L1-hv
>> 	     |
>> 	     G1
>>
>>    And we're running in G0, then:
>>
>>    - 'exclude_hv' would exclude L0 events
>>    - 'exclude_host' would ... exclude L1-hv events?
>>    - 'exclude_guest' would ... exclude G1 events?
>  From the point of view of G0, L0 *does not exist at all*.  You just
> cannot see L0 events if you're running in G0.
>
> exclude_host/exclude_guest are the right definition.
>
>>    Then the next question is, if G0 is a host, does the L1-hv run in
>>    G0 userspace or G0 kernel space?
> It's mostly kernel, but sometimes you're interested in events from QEMU
> or whoever else has opened /dev/kvm.  In that case you care about G0
> userspace too.
>
>> The way it is implemented, you basically have to always set
>> exclude_host=0, even if there is no virt at all and you want to measure
>> your own userspace thing -- which is just weird.
> I understand regretting having exclude_guest that way; include_guest
> (defaulting to 0!) would have made more sense.  But defaulting to
> exclude_host==0 makes sense: if there is no virt at all, memset(0) does
> the right thing so it does not seem weird to me.
>
>> I suppose the 'best' option at this point is something like:
>>
>> 	/*
>> 	 * comment that explains the trainwreck.
>> 	 */
>> 	if (!exclude_host && !exclude_guest)
>> 		exclude_guest = 1;
>>
>> 	if ((!exclude_hv || !exclude_guest) && !perf_allow_kernel())
>> 		return -EPERM;
>>
>> But that takes away the possibility of actually having:
>> 'exclude_host=0, exclude_guest=0' to create an event that measures both,
>> which also sucks.
> In fact both of the above "if"s suck. :(
>
> Paolo
>

