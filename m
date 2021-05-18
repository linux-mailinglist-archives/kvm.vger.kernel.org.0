Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC6D3879AE
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 15:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349492AbhERNR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 09:17:26 -0400
Received: from mga05.intel.com ([192.55.52.43]:24553 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230447AbhERNR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 09:17:26 -0400
IronPort-SDR: iHkiztZ4G44tl65t7VpFBLSZ+CCd05fiN3ZuQp2p7V5kUL7rMLVmAGDc1uqCR8+/3QdkCcjV6V
 L+RUYDWMZuXg==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="286240652"
X-IronPort-AV: E=Sophos;i="5.82,310,1613462400"; 
   d="scan'208";a="286240652"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 06:16:08 -0700
IronPort-SDR: LcDd7rPA9DICOZKuWjUH7c/hlK9q1r+zC7KbFKLQfJjojlwmZsKJYKz4cRoEBBgnTfvGs7oZa3
 l0PvbNOZqL2Q==
X-IronPort-AV: E=Sophos;i="5.82,310,1613462400"; 
   d="scan'208";a="472950105"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.255.30.127]) ([10.255.30.127])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 06:16:03 -0700
Subject: Re: [PATCH v6 07/16] KVM: x86/pmu: Reprogram PEBS event to emulate
 guest PEBS counter
To:     Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-8-like.xu@linux.intel.com>
 <YKIrtdbXRcZSiohg@hirez.programming.kicks-ass.net>
 <ff5a419f-188f-d14c-72c8-4b760052734d@linux.intel.com>
 <YKN/DVNt847iEctd@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <852ab586-2438-c7fc-c41d-0862e2f1b7ca@intel.com>
Date:   Tue, 18 May 2021 21:15:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YKN/DVNt847iEctd@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/18 16:47, Peter Zijlstra wrote:
> On Mon, May 17, 2021 at 07:44:15AM -0700, Andi Kleen wrote:
>> On 5/17/2021 1:39 AM, Peter Zijlstra wrote:
>>> On Tue, May 11, 2021 at 10:42:05AM +0800, Like Xu wrote:
>>>> +	if (pebs) {
>>>> +		/*
>>>> +		 * The non-zero precision level of guest event makes the ordinary
>>>> +		 * guest event becomes a guest PEBS event and triggers the host
>>>> +		 * PEBS PMI handler to determine whether the PEBS overflow PMI
>>>> +		 * comes from the host counters or the guest.
>>>> +		 *
>>>> +		 * For most PEBS hardware events, the difference in the software
>>>> +		 * precision levels of guest and host PEBS events will not affect
>>>> +		 * the accuracy of the PEBS profiling result, because the "event IP"
>>>> +		 * in the PEBS record is calibrated on the guest side.
>>>> +		 */
>>>> +		attr.precise_ip = 1;
>>>> +	}
>>> You've just destroyed precdist, no?
>> precdist can mean multiple things:
>>
>> - Convert cycles to the precise INST_RETIRED event. That is not meaningful
>> for virtualization because "cycles" doesn't exist, just the raw events.
>>
>> - For GLC+ and TNT+ it will force the event to a specific counter that is
>> more precise. This would be indeed "destroyed", but right now the patch kit
>> only supports Icelake which doesn't support that anyways.
>>
>> So I think the code is correct for now, but will need to be changed for
>> later CPUs. Should perhaps fix the comment though to discuss this.
> OK, can we then do a better comment that explains *why* this is correct
> now and what needs help later?
>
> Because IIUC the only reason it is correct now is because:
>
>   - we only support ICL
>
>     * and ICL has pebs_format>=2, so {1,2} are the same
>     * and ICL doesn't have precise_ip==3 support
>
>   - Other hardware (GLC+, TNT+) that could possibly care here
>     is unsupported atm. but needs changes.
>
> None of which is actually mentioned in that comment it does have.

Hi Andi & Peter,

By "precdist", do you mean the"Precise Distribution of Instructions Retired 
(PDIR) Facility"?

The SDM says Ice Lake Microarchitecture does support PEBS-PDIR on 
IA32_FIXED0 only.
And this patch kit enables it in the patch 0011, please take a look.

Or do I miss something about precdist on ICL ?

Thanks,
Like Xu





