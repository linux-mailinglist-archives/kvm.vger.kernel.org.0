Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29DF23BF71C
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 10:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhGHIzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 04:55:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:9163 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231248AbhGHIza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 04:55:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="196644938"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="196644938"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 01:52:48 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="487473856"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.249.171.108]) ([10.249.171.108])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 01:52:43 -0700
Subject: Re: [PATCH V7 11/18] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to
 support guest DS
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     pbonzini@redhat.com, bp@alien8.de, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, weijiang.yang@intel.com,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, Like Xu <like.xu@linux.intel.com>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <20210622094306.8336-12-lingshan.zhu@intel.com>
 <YN799S5hwWqsbY/h@hirez.programming.kicks-ass.net>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <ce352882-0e37-c853-91e5-b87cbeacac46@intel.com>
Date:   Thu, 8 Jul 2021 16:52:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YN799S5hwWqsbY/h@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/2/2021 7:52 PM, Peter Zijlstra wrote:
> On Tue, Jun 22, 2021 at 05:42:59PM +0800, Zhu Lingshan wrote:
>> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
>> index 190d8d98abf0..b336bcaad626 100644
>> --- a/arch/x86/events/intel/core.c
>> +++ b/arch/x86/events/intel/core.c
>> @@ -21,6 +21,7 @@
>>   #include <asm/intel_pt.h>
>>   #include <asm/apic.h>
>>   #include <asm/cpu_device_id.h>
>> +#include <asm/kvm_host.h>
>>   
>>   #include "../perf_event.h"
>>   
>> @@ -3915,6 +3916,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>>   {
>>   	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>>   	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
>> +	struct kvm_pmu *pmu = (struct kvm_pmu *)data;
>>   	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
>>   	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
>>   
>> @@ -3945,9 +3947,15 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>>   		return arr;
>>   	}
>>   
>> -	if (!x86_pmu.pebs_vmx)
>> +	if (!pmu || !x86_pmu.pebs_vmx)
>>   		return arr;
>>   
>> +	arr[(*nr)++] = (struct perf_guest_switch_msr){
>> +		.msr = MSR_IA32_DS_AREA,
>> +		.host = (unsigned long)cpuc->ds,
>> +		.guest = pmu->ds_area,
>> +	};
>> +
>>   	arr[*nr] = (struct perf_guest_switch_msr){
>>   		.msr = MSR_IA32_PEBS_ENABLE,
>>   		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
> s/pmu/kvm_pmu/ or something. pmu is normally a struct pmu *, and having
> it be kvm_pmu here is super confusing.
will fix this in V8, Thanks!

