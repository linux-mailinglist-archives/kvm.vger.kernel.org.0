Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5B63DF9DF
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 05:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbhHDDDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 23:03:21 -0400
Received: from mga04.intel.com ([192.55.52.120]:26646 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230088AbhHDDDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 23:03:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="211971562"
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="211971562"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 20:03:08 -0700
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="521655496"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.249.168.129]) ([10.249.168.129])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 20:03:02 -0700
Subject: Re: [PATCH V9 00/18] KVM: x86/pmu: Add *basic* support to enable
 guest PEBS via DS
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     pbonzini@redhat.com, bp@alien8.de, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, boris.ostrvsky@oracle.com
References: <20210722054159.4459-1-lingshan.zhu@intel.com>
 <YQF7lwM6qzYso0Gg@hirez.programming.kicks-ass.net>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <9ee8c1a8-6de5-06eb-dc55-b0b2a444387b@intel.com>
Date:   Wed, 4 Aug 2021 11:03:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQF7lwM6qzYso0Gg@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/28/2021 11:45 PM, Peter Zijlstra wrote:
> On Thu, Jul 22, 2021 at 01:41:41PM +0800, Zhu Lingshan wrote:
>> The guest Precise Event Based Sampling (PEBS) feature can provide an
>> architectural state of the instruction executed after the guest instruction
>> that exactly caused the event. It needs new hardware facility only available
>> on Intel Ice Lake Server platforms. This patch set enables the basic PEBS
>> feature for KVM guests on ICX.
>>
>> We can use PEBS feature on the Linux guest like native:
>>
>>     # echo 0 > /proc/sys/kernel/watchdog (on the host)
>>     # perf record -e instructions:ppp ./br_instr a
>>     # perf record -c 100000 -e instructions:pp ./br_instr a
> Why does the host need to disable the watchdog? IIRC ICL has multiple
> PEBS capable counters. Also, I think the watchdog ends up on a fixed
> counter by default anyway.
>
>> Like Xu (17):
>>    perf/core: Use static_call to optimize perf_guest_info_callbacks
>>    perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
>>    perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
>>    perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
>>    KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
>>    KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
>>    KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
>>    KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
>>    KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
>>    KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS
>>    KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
>>    KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
>>    KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
>>    KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations
>>    KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
>>    KVM: x86/cpuid: Refactor host/guest CPU model consistency check
>>    KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
>>
>> Peter Zijlstra (Intel) (1):
>>    x86/perf/core: Add pebs_capable to store valid PEBS_COUNTER_MASK value
> Looks good:
>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>
> How do we want to route this, all through the KVM tree?
I will send a V10 patchset then ping Paolo.
>
> One little nit I had; would something like the below (on top perhaps)
> make the code easier to read?
V10 will include this change.

Thanks,
Zhu Lingshan
>
> ---
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -3921,9 +3921,12 @@ static struct perf_guest_switch_msr *int
>   	struct kvm_pmu *kvm_pmu = (struct kvm_pmu *)data;
>   	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
>   	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
> +	int global_ctrl, pebs_enable;
>   
>   	*nr = 0;
> -	arr[(*nr)++] = (struct perf_guest_switch_msr){
> +
> +	global_ctrl = (*nr)++;
> +	arr[global_ctrl] = (struct perf_guest_switch_msr){
>   		.msr = MSR_CORE_PERF_GLOBAL_CTRL,
>   		.host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
>   		.guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
> @@ -3966,23 +3969,23 @@ static struct perf_guest_switch_msr *int
>   		};
>   	}
>   
> -	arr[*nr] = (struct perf_guest_switch_msr){
> +	pebs_enable = (*nr)++;
> +	arr[pebs_enable] = (struct perf_guest_switch_msr){
>   		.msr = MSR_IA32_PEBS_ENABLE,
>   		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
>   		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
>   	};
>   
> -	if (arr[*nr].host) {
> +	if (arr[pebs_enable].host) {
>   		/* Disable guest PEBS if host PEBS is enabled. */
> -		arr[*nr].guest = 0;
> +		arr[pebs_enable].guest = 0;
>   	} else {
>   		/* Disable guest PEBS for cross-mapped PEBS counters. */
> -		arr[*nr].guest &= ~kvm_pmu->host_cross_mapped_mask;
> +		arr[pebs_enable].guest &= ~kvm_pmu->host_cross_mapped_mask;
>   		/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
> -		arr[0].guest |= arr[*nr].guest;
> +		arr[global_ctrl].guest |= arr[pebs_enable].guest;
>   	}
>   
> -	++(*nr);
>   	return arr;
>   }
>   
>
>
>

