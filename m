Return-Path: <kvm+bounces-11098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE7A872CF9
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 03:48:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 751221F287EA
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 02:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590F4DDAB;
	Wed,  6 Mar 2024 02:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mTfJrO2I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B1A6117;
	Wed,  6 Mar 2024 02:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709693304; cv=none; b=CDOumlU2c0kp/melMYV0+krVS/P6pNUrmJzXX4pxXpYznvyLI9j3xjtj0Jc7EoYeROf1tZIPx/vPUx825pbuvUB6sqg7WsP7Yb9rjGpSQbF1H7FJfzD74ufgp0lJh0hieaJvtKk9HXBqy4kdtMt5Qr9bCmkI0um2BZR+7WChx40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709693304; c=relaxed/simple;
	bh=hHT9l3jfKJR+AUAfQNpmrgJhnGQrE6S26vFxeGU+PKg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PlANCoX83mLFwHymQpMA3yzUicyM4E1XvlB5B8V+TAZr8HtgKX9yShX0ILwvL/LL2aIUkjfYqP/bA1qDoILGOCmq+H4hSga5IIHUxkSOZxLzkQa8Rz79D6E/TtEZoBaCb7dUBNqDu7Sd+ooqWnT+bHEoMdgKy8is2LLPBbXWovE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mTfJrO2I; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709693302; x=1741229302;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hHT9l3jfKJR+AUAfQNpmrgJhnGQrE6S26vFxeGU+PKg=;
  b=mTfJrO2IJFM4Rq+2SKImLv4h29NC4q1TCqRz3nQepKDsEjk/ETmQUGGD
   f7QlazZWbRTpSz+rw1YeZ5+tOAOgxLVRf6m7oU98RVbc7+1gLyiZrXfOK
   eyE6OqjMMec3VizSn+HhqtJaWSE+TuCZkzIuNFK6uWinZhG4rFA6Ds9pT
   Z+WunrR/MJ7Z/siV7Z/SF/Y9aVk8BdPj99lYaqkNaExVEwH1eka84gOZl
   2twizYDLxRQr6teBFDBI1a61PglvNgPlneN6eK0YkLdmtvF57V2JfcKtY
   Cxa4Joo+hmh+4gPfpC6gRvIhWlkz9UHyErD5JyXnRn6mH9okPBkLkL+0J
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="4456616"
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="4456616"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 18:48:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="40473773"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.239.60]) ([10.124.239.60])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 18:48:18 -0800
Message-ID: <8bb0e8d7-3f1e-48f6-b14b-23b47892dc4b@linux.intel.com>
Date: Wed, 6 Mar 2024 10:48:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/svm/pmu: Set PerfMonV2 global control bits
 correctly
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Sandipan Das <sandipan.das@amd.com>, Like Xu <like.xu.linux@gmail.com>,
 pbonzini@redhat.com, mizhang@google.com, jmattson@google.com,
 ravi.bangoria@amd.com, nikunj.dadhania@amd.com, santosh.shukla@amd.com,
 manali.shukla@amd.com, babu.moger@amd.com, kvm list <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240301075007.644152-1-sandipan.das@amd.com>
 <06061a28-88c0-404b-98a6-83cc6cc8c796@gmail.com>
 <cc8699be-3aae-42aa-9c70-f8b6a9728ee3@amd.com>
 <f5bbe9ac-ca35-4c3e-8cd7-249839fbb8b8@linux.intel.com>
 <ZeYlEGORqeTPLK2_@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZeYlEGORqeTPLK2_@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 3/5/2024 3:46 AM, Sean Christopherson wrote:
> On Mon, Mar 04, 2024, Dapeng Mi wrote:
>> On 3/1/2024 5:00 PM, Sandipan Das wrote:
>>> On 3/1/2024 2:07 PM, Like Xu wrote:
>>>> On 1/3/2024 3:50 pm, Sandipan Das wrote:
>>>>> With PerfMonV2, a performance monitoring counter will start operating
>>>>> only when both the PERF_CTLx enable bit as well as the corresponding
>>>>> PerfCntrGlobalCtl enable bit are set.
>>>>>
>>>>> When the PerfMonV2 CPUID feature bit (leaf 0x80000022 EAX bit 0) is set
>>>>> for a guest but the guest kernel does not support PerfMonV2 (such as
>>>>> kernels older than v5.19), the guest counters do not count since the
>>>>> PerfCntrGlobalCtl MSR is initialized to zero and the guest kernel never
>>>>> writes to it.
>>>> If the vcpu has the PerfMonV2 feature, it should not work the way legacy
>>>> PMU does. Users need to use the new driver to operate the new hardware,
>>>> don't they ? One practical approach is that the hypervisor should not set
>>>> the PerfMonV2 bit for this unpatched 'v5.19' guest.
>>>>
>>> My understanding is that the legacy method of managing the counters should
>>> still work because the enable bits in PerfCntrGlobalCtl are expected to be
>>> set. The AMD PPR does mention that the PerfCntrEn bitfield of PerfCntrGlobalCtl
>>> is set to 0x3f after a system reset. That way, the guest kernel can use either
>> If so, please add the PPR description here as comments.
> Or even better, make that architectural behavior that's documented in the APM.
>
>>>>> ---
>>>>>     arch/x86/kvm/svm/pmu.c | 1 +
>>>>>     1 file changed, 1 insertion(+)
>>>>>
>>>>> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
>>>>> index b6a7ad4d6914..14709c564d6a 100644
>>>>> --- a/arch/x86/kvm/svm/pmu.c
>>>>> +++ b/arch/x86/kvm/svm/pmu.c
>>>>> @@ -205,6 +205,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>>>>>         if (pmu->version > 1) {
>>>>>             pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
>>>>>             pmu->global_status_mask = pmu->global_ctrl_mask;
>>>>> +        pmu->global_ctrl = ~pmu->global_ctrl_mask;
>> It seems to be more easily understand to calculate global_ctrl firstly and
>> then derive the globol_ctrl_mask (negative logic).
> Hrm, I'm torn.  On one hand, awful name aside (global_ctrl_mask should really be
> something like global_ctrl_rsvd_bits), the computation of the reserved bits should

Yeah, same feeling here. global_ctrl_mask is ambiguous and users are 
hard to get its real meaning just from the name and have to read the all 
the code. global_ctrl_rsvd_bits looks  to be a better name. There are 
several other variables with similar name "xxx_mask". Sean, do you think 
it's a good time to change the name for all these variables? Thanks.


> come from the capabilities of the PMU, not from the RESET value.
>
> On the other hand, setting _all_ non-reserved bits will likely do the wrong thing
> if AMD ever adds bits in PerfCntGlobalCtl that aren't tied to general purpose
> counters.  But, that's a future theoretical problem, so I'm inclined to vote for
> Sandipan's approach.
>
>> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
>> index e886300f0f97..7ac9b080aba6 100644
>> --- a/arch/x86/kvm/svm/pmu.c
>> +++ b/arch/x86/kvm/svm/pmu.c
>> @@ -199,7 +199,8 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>> kvm_pmu_cap.num_counters_gp);
>>
>>          if (pmu->version > 1) {
>> -               pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters)
>> - 1);
>> +               pmu->global_ctrl = (1ull << pmu->nr_arch_gp_counters) - 1;
>> +               pmu->global_ctrl_mask = ~pmu->global_ctrl;
>>                  pmu->global_status_mask = pmu->global_ctrl_mask;
>>          }
>>
>>>>>         }
>>>>>           pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;

