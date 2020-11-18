Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A7E2B818E
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 17:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgKRQPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 11:15:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:12838 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgKRQPW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Nov 2020 11:15:22 -0500
IronPort-SDR: BYC0+XFW+tVL1gVtVuyE+TOIGbFCa04FYU4WFDykUg1gbOo4k+SsC3dm5b1Q4cCitu4RI5bFij
 Opnf3jQWtX0g==
X-IronPort-AV: E=McAfee;i="6000,8403,9808"; a="158173552"
X-IronPort-AV: E=Sophos;i="5.77,486,1596524400"; 
   d="scan'208";a="158173552"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 08:15:19 -0800
IronPort-SDR: KXXwI6zttn0bm+t5tKedpWUNYCmo50FeuvjTm8URD5vp07OlxH3tgEOezC1rIlKY0yExugHu0J
 z+qEsuFpLk9Q==
X-IronPort-AV: E=Sophos;i="5.77,486,1596524400"; 
   d="scan'208";a="476411969"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.255.28.176]) ([10.255.28.176])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 08:15:12 -0800
Subject: Re: [PATCH v2 04/17] perf: x86/ds: Handle guest PEBS overflow PMI and
 inject it to guest
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, wei.w.wang@intel.com,
        Tony Luck <tony.luck@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
References: <20201109021254.79755-1-like.xu@linux.intel.com>
 <20201109021254.79755-5-like.xu@linux.intel.com>
 <20201117143529.GJ3121406@hirez.programming.kicks-ass.net>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <b2c3f889-44dd-cadb-f225-a4c5db3a4447@linux.intel.com>
Date:   Thu, 19 Nov 2020 00:15:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201117143529.GJ3121406@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 2020/11/17 22:35, Peter Zijlstra wrote:
> On Mon, Nov 09, 2020 at 10:12:41AM +0800, Like Xu wrote:
>> With PEBS virtualization, the PEBS records get delivered to the guest,
>> and host still sees the PEBS overflow PMI from guest PEBS counters.
>> This would normally result in a spurious host PMI and we needs to inject
>> that PEBS overflow PMI into the guest, so that the guest PMI handler
>> can handle the PEBS records.
>>
>> Check for this case in the host perf PEBS handler. If a PEBS overflow
>> PMI occurs and it's not generated from host side (via check host DS),
>> a fake event will be triggered. The fake event causes the KVM PMI callback
>> to be called, thereby injecting the PEBS overflow PMI into the guest.
>>
>> No matter how many guest PEBS counters are overflowed, only triggering
>> one fake event is enough. The guest PEBS handler would retrieve the
>> correct information from its own PEBS records buffer.
>>
>> If the counter_freezing is disabled on the host, a guest PEBS overflow
>> PMI would be missed when a PEBS counter is enabled on the host side
>> and coincidentally a host PEBS overflow PMI based on host DS_AREA is
>> also triggered right after vm-exit due to the guest PEBS overflow PMI
>> based on guest DS_AREA. In that case, KVM will disable guest PEBS before
>> vm-entry once there's a host PEBS counter enabled on the same CPU.
> 
> How does this guest DS crud work? DS_AREA is a host virtual address;

A host counter will be scheduled (maybe cross-mapped) for a guest PEBS 
counter (via guest PEBS event), and its enable bits (PEBS_ENABLE + EN
+ GLOBAL_CTRL) will be set according to guest's values right before the
vcpu entry (via atomic_switch_perf_msrs).

The guest PEBS record(s) will be written to the guest DS buffer referenced
by the guest DS_AREA msr, which is switched during the vmx transaction,
and it is the guest virtual address.

> ISTR there was lots of fail trying to virtualize it earlier. What's
> changed? There's 0 clues here.

Ah, now we have EPT-friendly PEBS facilities supported since Ice Lake
which makes guest PEBS feature possible w/o guest memory pinned.

> 
> Why are the host and guest DS area separate, why can't we map them to
> the exact same physical pages?

If we map both guest and host DS_AREA to the exact same physical pages,
- the guest can access the host PEBS records, which means that the host
IP maybe leaked, because we cannot predict the time guest drains records 
and it would be over-designed to clean it up before each vm-entry;
- different tasks/vcpus on the same pcpu cannot share the same PEBS DS
settings from the same physical page. For example, some require large
PEBS and reset values, while others do not.

Like many guest msrs, we use the separate guest DS_AREA for the guest's
own use and it avoids mutual interference as little as possible.

Thanks,
Like Xu

