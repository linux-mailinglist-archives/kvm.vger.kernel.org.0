Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA632C5EB2
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 03:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392202AbgK0CO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 21:14:56 -0500
Received: from mga14.intel.com ([192.55.52.115]:10922 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392194AbgK0CO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Nov 2020 21:14:56 -0500
IronPort-SDR: hJ3cfura3hCxmqd4YDYOY4zwdU+eYo2lilAFoFJ8YSps2Nh8AON5J/R0au0tM6Ktwm6QOB2tgp
 /NIX8NRiw3/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9817"; a="171560412"
X-IronPort-AV: E=Sophos;i="5.78,373,1599548400"; 
   d="scan'208";a="171560412"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2020 18:14:55 -0800
IronPort-SDR: yWJeDj0DU3bGwjXS9UiOcHoAKzsabIXJHBjwFFeZtUYXj9smuI/cMCThEw/dGhO2UN/whyz+Fv
 wTFwRu9eOuOw==
X-IronPort-AV: E=Sophos;i="5.78,373,1599548400"; 
   d="scan'208";a="547899967"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.107]) ([10.238.4.107])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2020 18:14:51 -0800
Subject: Re: [PATCH v2 04/17] perf: x86/ds: Handle guest PEBS overflow PMI and
 inject it to guest
To:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu@linux.intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
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
 <b2c3f889-44dd-cadb-f225-a4c5db3a4447@linux.intel.com>
 <20201118180721.GA3121392@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <682011d8-934f-4c76-69b0-788f71d91961@intel.com>
Date:   Fri, 27 Nov 2020 10:14:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201118180721.GA3121392@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 2020/11/19 2:07, Peter Zijlstra wrote:
> On Thu, Nov 19, 2020 at 12:15:09AM +0800, Like Xu wrote:
>
>>> ISTR there was lots of fail trying to virtualize it earlier. What's
>>> changed? There's 0 clues here.
>> Ah, now we have EPT-friendly PEBS facilities supported since Ice Lake
>> which makes guest PEBS feature possible w/o guest memory pinned.
> OK.
>
>>> Why are the host and guest DS area separate, why can't we map them to
>>> the exact same physical pages?
>> If we map both guest and host DS_AREA to the exact same physical pages,
>> - the guest can access the host PEBS records, which means that the host
>> IP maybe leaked, because we cannot predict the time guest drains records and
>> it would be over-designed to clean it up before each vm-entry;
>> - different tasks/vcpus on the same pcpu cannot share the same PEBS DS
>> settings from the same physical page. For example, some require large
>> PEBS and reset values, while others do not.
>>
>> Like many guest msrs, we use the separate guest DS_AREA for the guest's
>> own use and it avoids mutual interference as little as possible.
> OK, but the code here wanted to inspect the guest DS from the host. It
> states this is somehow complicated/expensive. But surely we can at the
> very least map the first guest DS page somewhere so we can at least
> access the control bits without too much magic.
We note that the SDM has a contiguous present memory mapping
assumption about the DS save area and the PEBS buffer area.

Therefore, we revisit your suggestion here and move it a bit forward:

When the PEBS is enabled, KVM will cache the following values:
- gva ds_area (kvm msr trap)
- hva1 for "gva ds_area" (walk guest page table)
- hva2 for "gva pebs_buffer_base" via hva1 (walk guest page table)

if the "gva ds_area" cache hits,
- access PEBS "interrupt threshold" and "Counter Reset[]" via hva1
- get "gva2 pebs_buffer_base" via __copy_from_user(hva1)

if the "gva2 pebs_buffer_base" cache hits,
- we get "gva2 pebs_index" via __copy_from_user(hva2),
- rewrite the guest PEBS records via hva2 and pebs_index

If any cache misses, setup the cache values via walking tables again.

I wonder if you would agree with this optimization idea,
we look forward to your confirmation for the next step.

Thanks,
Like Xu

