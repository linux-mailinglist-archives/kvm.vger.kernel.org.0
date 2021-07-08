Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAF23BF71A
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 10:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhGHIzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 04:55:07 -0400
Received: from mga18.intel.com ([134.134.136.126]:50822 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhGHIzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 04:55:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="196745671"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="196745671"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 01:52:25 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="487473775"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.249.171.108]) ([10.249.171.108])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 01:52:19 -0700
Subject: Re: [PATCH V7 15/18] KVM: x86/pmu: Disable guest PEBS temporarily in
 two rare situations
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     pbonzini@redhat.com, bp@alien8.de, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, weijiang.yang@intel.com,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, Like Xu <like.xu@linux.intel.com>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <20210622094306.8336-16-lingshan.zhu@intel.com>
 <YN8KuNOOm1UBBsGJ@hirez.programming.kicks-ass.net>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <7c6fde51-add4-35eb-fcff-bad847b85010@intel.com>
Date:   Thu, 8 Jul 2021 16:52:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YN8KuNOOm1UBBsGJ@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/2/2021 8:46 PM, Peter Zijlstra wrote:
> On Tue, Jun 22, 2021 at 05:43:03PM +0800, Zhu Lingshan wrote:
>> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
>> index 22386c1a32b4..8bf494f8af3e 100644
>> --- a/arch/x86/events/intel/core.c
>> +++ b/arch/x86/events/intel/core.c
>> @@ -3970,8 +3970,15 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>>   		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
>>   	};
>>   
>> -	/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
>> -	arr[0].guest |= arr[*nr].guest;
>> +	if (arr[*nr].host) {
>> +		/* Disable guest PEBS if host PEBS is enabled. */
>> +		arr[*nr].guest = 0;
>> +	} else {
>> +		/* Disable guest PEBS for cross-mapped PEBS counters. */
>> +		arr[*nr].guest &= ~pmu->host_cross_mapped_mask;
>> +		/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
>> +		arr[0].guest |= arr[*nr].guest;
>> +	}
> Not saying I disagree, but is there any way for the guest to figure out
> why things aren't working? Is there like a guest log we can dump
> something in?
Hi Peter,

We expect to handle these cases in the "slow path" series, try to 
cross-map the counters.

Thanks!
>
>> +void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
>> +{
>> +	struct kvm_pmc *pmc = NULL;
>> +	int bit;
>> +
>> +	for_each_set_bit(bit, (unsigned long *)&pmu->global_ctrl,
>> +			 X86_PMC_IDX_MAX) {
>> +		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
>> +
>> +		if (!pmc || !pmc_speculative_in_use(pmc) ||
>> +		    !pmc_is_enabled(pmc))
>> +			continue;
>> +
>> +		if (pmc->perf_event && (pmc->idx != pmc->perf_event->hw.idx))
>> +			pmu->host_cross_mapped_mask |=
>> +				BIT_ULL(pmc->perf_event->hw.idx);
> { } again.
>
>> +	}
>> +}

