Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548BC2F98BA
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 05:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbhAREl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 23:41:26 -0500
Received: from mga06.intel.com ([134.134.136.31]:31561 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbhARElZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jan 2021 23:41:25 -0500
IronPort-SDR: G7g3NllnhW27/xK2IRZWNlBQhJAWuYmfyCSff1Ws8r0+FcEjmnp4XWDmjPVcotQZNPh1UUI3Vt
 O7zRo03T2bhQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="240300002"
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="240300002"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 20:40:44 -0800
IronPort-SDR: eEvw7leSaaJN9eymLLgynxNsOGJeSV55yCiBp97NG8dJkQ0Ik5jtq/b2whwL85LQOqaO9CSC4d
 2hq4jBbHNtUQ==
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="383426844"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 20:40:41 -0800
Subject: Re: [PATCH] KVM: x86/pmu: Fix HW_REF_CPU_CYCLES event pseudo-encoding
 in intel_arch_events[]
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Stephane Eranian <eranian@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
References: <20201230081916.63417-1-like.xu@linux.intel.com>
 <1ff5381c-3057-7ca2-6f62-bbdcefd8e427@linux.intel.com>
 <YAHRMK5SmrmMx8hg@google.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <b3623ea4-b2a1-e825-68f9-d97a6e7a07f4@intel.com>
Date:   Mon, 18 Jan 2021 12:40:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YAHRMK5SmrmMx8hg@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/16 1:30, Sean Christopherson wrote:
> On Fri, Jan 15, 2021, Like Xu wrote:
>> Ping ?
>>
>> On 2020/12/30 16:19, Like Xu wrote:
>>> The HW_REF_CPU_CYCLES event on the fixed counter 2 is pseudo-encoded as
>>> 0x0300 in the intel_perfmon_event_map[]. Correct its usage.
>>>
>>> Fixes: 62079d8a4312 ("KVM: PMU: add proper support for fixed counter 2")
>>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
thx.
>
>>> ---
>>>    arch/x86/kvm/vmx/pmu_intel.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>>> index a886a47daebd..013e8d253dfa 100644
>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>>> @@ -29,7 +29,7 @@ static struct kvm_event_hw_type_mapping intel_arch_events[] = {
>>>    	[4] = { 0x2e, 0x41, PERF_COUNT_HW_CACHE_MISSES },
>>>    	[5] = { 0xc4, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
>>>    	[6] = { 0xc5, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
>>> -	[7] = { 0x00, 0x30, PERF_COUNT_HW_REF_CPU_CYCLES },
>>> +	[7] = { 0x00, 0x03, PERF_COUNT_HW_REF_CPU_CYCLES },
> In a follow up patch, would it be sane/appropriate to define these magic numbers
> in asm/perf_event.h and share them between intel_perfmon_event_map and
> intel_arch_events?  Without this patch, it's not at all obvious that these are
> intended to align with the Core (arch?) event definitions.

The asm/perf_event.h is x86 generic and svm has a amd_perfmon_event_map.

How about adding an interface similar to perf_get_x86_pmu_capability()
so that we can use magic numbers directly from the host perf ?
(it looks we may have a performance drop, compared to static array)

---
thx, likexu

>
>>>    };
>>>    /* mapping between fixed pmc index and intel_arch_events array */

