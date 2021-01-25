Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E7E30340F
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbhAZFNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:13:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:21973 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbhAYJUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:20:15 -0500
IronPort-SDR: 6Z8pwwGR9ZByhUNj53GCp7mwzjsISPKnjUXAb171icLZhlZXZJuJbb/UK4rhfbCiAoS+WnZoRw
 GDZ+/bmwPMIw==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="198459800"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="198459800"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 00:26:36 -0800
IronPort-SDR: krmTHTvV9H1Em7YztLgy8AHyHyDUYxQkj03g7g4NA78ph4D8nEIi8ocAQEiHfrfeZEd2vGIV6W
 s89XGV2WwhSQ==
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="387239873"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 00:26:24 -0800
Subject: Re: [PATCH v3 04/17] perf: x86/ds: Handle guest PEBS overflow PMI and
 inject it to guest
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org,
        "Xu, Like" <like.xu@intel.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-5-like.xu@linux.intel.com>
 <X/86UWuV/9yt14hQ@hirez.programming.kicks-ass.net>
 <9c343e40-bbdf-8af0-3307-5274070ee3d2@intel.com>
 <YAGEFgqQv281jVHc@hirez.programming.kicks-ass.net>
 <2c197d5a-09a8-968c-a942-c95d18983c9d@intel.com>
 <YAGqWNl2FKxVussV@hirez.programming.kicks-ass.net>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <ed5b16cb-30c7-dab7-92c3-b70ba8483d1e@linux.intel.com>
Date:   Mon, 25 Jan 2021 16:26:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YAGqWNl2FKxVussV@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 2021/1/15 22:44, Peter Zijlstra wrote:
> On Fri, Jan 15, 2021 at 10:30:13PM +0800, Xu, Like wrote:
> 
>>> Are you sure? Spurious NMI/PMIs are known to happen anyway. We have far
>>> too much code to deal with them.
>>
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
>>
>> I assume that if the PMI drop is unacceptable, either will spurious PMI
>> injection.
>>
>> I'm pretty open if you insist that we really need to do this for guest PEBS
>> enabling.
> 
> That was an entirely different issue. We were dropping events on the
> floor because they'd passed priv boundaries. So there was an actual
> event, and we made it go away.
> 
> What we're talking about here is raising an PMI with BUFFER_OVF set,
> even if the DS is empty. That should really be harmless. We'll take the
> PMI, find there's nothing there, and do nothing.
> 

In the host and guest PEBS both enabled case,
we'll get a crazy dmesg *bombing* about spurious PMI warning
if we pass the host PEBS PMI "harmlessly" to the guest:

[11261.502536] Uhhuh. NMI received for unknown reason 2c on CPU 36.
[11261.502539] Do you have a strange power saving mode enabled?
[11261.502541] Dazed and confused, but trying to continue

Legacy guest users may be very confused and dissatisfied with that.

I'm double checking with you if it's acceptable to take the proposal
"disables the co-existence of guest PEBS and host PEBS" as the first
step to upstream, and enable both host and guest PEBS in the near future.

---
thx,likexu
