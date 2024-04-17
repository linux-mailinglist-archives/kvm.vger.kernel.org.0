Return-Path: <kvm+bounces-14949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A39278A8001
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 11:42:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C71A91C20F79
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 09:42:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2EE313328A;
	Wed, 17 Apr 2024 09:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Eb4PXhIp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9A0F516;
	Wed, 17 Apr 2024 09:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713346939; cv=none; b=DcbMRYPhYCq2OVU6XQ4uZlq0OY+iYNbQM38fQ8UJJuDClUhvkvxUjOI2jQ6wqxrMrYTAsClAO1SOjazMn5X2RAypdGrjfUP6OHefEyf3c7Ou63mtOBD/i9NrOdm82xhpKTKXOcgMpo4jIUO0Y4gSlXBkJeG8PIbmCUruzR6AHJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713346939; c=relaxed/simple;
	bh=RO/yekuzKpjnK5J65tWon3xbJlWRuk0W24/pV3bTqkc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f44tAu9CvHbWXFKJEFhqHAN+ED0ch9aAzksK4MjLXuFBUIpAWzOGlWujOEJhdM9HAv9uxEGLHbDBV2wRtLavBscNowMe+xef5hJsJjO45nFi7/NAJq6o+AedPaY0NJ7aCTetTZptDsJpnWr10S4U1EPF+6OL+dPkMtHLjBAQyeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Eb4PXhIp; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713346938; x=1744882938;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RO/yekuzKpjnK5J65tWon3xbJlWRuk0W24/pV3bTqkc=;
  b=Eb4PXhIpzms1Ys0uHThHaQHNa3B2491pmscThh6HNjW2w0IxE2bzZztb
   A6Wc0SMhlGtovpL3vrvNybDwwk/AxZsnCh/ZGFT+6HBOZJB9KqG7SiLY5
   8XnYRJhR5SntH7Lj6/V2+Dw0UpvG4P8gjC1du1cPijo2pXdlIRdvDbtb3
   7IC5hrnhzARBdOUUU3QmS33uInviIp3ITllN1uPouWDdbNhohhKXpf+GM
   MQ4+aaFytnCDAShDl2dzfamnxqTM2EHeoZIhmo2OtJl3kqYgzlRoUEObz
   8hlOh3aLSzp9c/t8ppl+fxdvrgVchtVw9MNB8nqir282sUYb2LMH4XC7j
   Q==;
X-CSE-ConnectionGUID: hKu2qcy6QJK8xXXcE4SOug==
X-CSE-MsgGUID: 63w4+mJcTUWPup6nefuL4g==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="12612527"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="12612527"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 02:42:17 -0700
X-CSE-ConnectionGUID: X2o1a1jsSf23UfRZFeShcw==
X-CSE-MsgGUID: fS5thnUAR++movCeIe9QYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="22632595"
Received: from xiongzha-mobl1.ccr.corp.intel.com (HELO [10.125.241.186]) ([10.125.241.186])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 02:42:12 -0700
Message-ID: <9056f6a2-546b-41fc-a07c-7b86173887db@linux.intel.com>
Date: Wed, 17 Apr 2024 17:42:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/41] perf: Support guest enter/exit interfaces
To: "Liang, Kan" <kan.liang@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com,
 kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-3-xiong.y.zhang@linux.intel.com>
 <ZhgmrczGpccfU-cI@google.com>
 <23af8648-ca9f-41d2-8782-f2ffc3c11e9e@linux.intel.com>
 <ZhmIrQQVgblrhCZs@google.com>
 <2342a4e2-2834-48e2-8403-f0050481e59e@linux.intel.com>
 <ab2953b7-18fd-4b4c-a83b-ab243e2a21e1@linux.intel.com>
 <998fd76f-2bd9-4492-bf2e-e8cd981df67f@linux.intel.com>
 <eca7cdb9-6c8d-4d2e-8ac6-b87ea47a1bac@linux.intel.com>
Content-Language: en-US
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <eca7cdb9-6c8d-4d2e-8ac6-b87ea47a1bac@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/16/2024 8:48 PM, Liang, Kan wrote:
> 
> 
> On 2024-04-16 1:34 a.m., Zhang, Xiong Y wrote:
>>
>>
>> On 4/16/2024 12:03 AM, Liang, Kan wrote:
>>>
>>>
>>> On 2024-04-12 4:56 p.m., Liang, Kan wrote:
>>>>> What if perf had a global knob to enable/disable mediate PMU support?  Then when
>>>>> KVM is loaded with enable_mediated_true, call into perf to (a) check that there
>>>>> are no existing !exclude_guest events (this part could be optional), and (b) set
>>>>> the global knob to reject all new !exclude_guest events (for the core PMU?).
>>>>>
>>>>> Hmm, or probably better, do it at VM creation.  That has the advantage of playing
>>>>> nice with CONFIG_KVM=y (perf could reject the enabling without completely breaking
>>>>> KVM), and not causing problems if KVM is auto-probed but the user doesn't actually
>>>>> want to run VMs.
>>>> I think it should be doable, and may simplify the perf implementation.
>>>> (The check in the schedule stage should not be necessary anymore.)
>>>>
>>>> With this, something like NMI watchdog should fail the VM creation. The
>>>> user should either disable the NMI watchdog or use a replacement.
>>>>
>>>> Thanks,
>>>> Kan
>>>>> E.g. (very roughly)
>>>>>
>>>>> int x86_perf_get_mediated_pmu(void)
>>>>> {
>>>>> 	if (refcount_inc_not_zero(...))
>>>>> 		return 0;
>>>>>
>>>>> 	if (<system wide events>)
>>>>> 		return -EBUSY;
>>>>>
>>>>> 	<slow path with locking>
>>>>> }
>>>>>
>>>>> void x86_perf_put_mediated_pmu(void)
>>>>> {
>>>>> 	if (!refcount_dec_and_test(...))
>>>>> 		return;
>>>>>
>>>>> 	<slow path with locking>
>>>>> }
>>>
>>>
>>> I think the locking should include the refcount check and system wide
>>> event check as well.
>>> It should be possible that two VMs are created very close.
>>> The second creation may mistakenly return 0 if there is no lock.
>>>
>>> I plan to do something as below (not test yet).
>>>
>>> +/*
>>> + * Currently invoked at VM creation to
>>> + * - Check whether there are existing !exclude_guest system wide events
>>> + *   of PMU with PERF_PMU_CAP_MEDIATED_VPMU
>>> + * - Set nr_mediated_pmu to prevent !exclude_guest event creation on
>>> + *   PMUs with PERF_PMU_CAP_MEDIATED_VPMU
>>> + *
>>> + * No impact for the PMU without PERF_PMU_CAP_MEDIATED_VPMU. The perf
>>> + * still owns all the PMU resources.
>>> + */
>>> +int x86_perf_get_mediated_pmu(void)
>>> +{
>>> +	int ret = 0;
>>> +	mutex_lock(&perf_mediated_pmu_mutex);
>>> +	if (refcount_inc_not_zero(&nr_mediated_pmu_vms))
>>> +		goto end;
>>> +
>>> +	if (atomic_read(&nr_include_guest_events)) {
>>> +		ret = -EBUSY;
>>> +		goto end;
>>> +	}
>>> +	refcount_inc(&nr_mediated_pmu_vms);
>>> +end:
>>> +	mutex_unlock(&perf_mediated_pmu_mutex);
>>> +	return ret;
>>> +}
>>> +EXPORT_SYMBOL_GPL(x86_perf_get_mediated_pmu);
>>> +
>>> +void x86_perf_put_mediated_pmu(void)
>>> +{
>>> +	mutex_lock(&perf_mediated_pmu_mutex);
>>> +	refcount_dec(&nr_mediated_pmu_vms);
>>> +	mutex_unlock(&perf_mediated_pmu_mutex);
>>> +}
>>> +EXPORT_SYMBOL_GPL(x86_perf_put_mediated_pmu);
>>>
>>>
>>> Thanks,
>>> Kan
>> x86_perf_get_mediated_pmu() is called at vm_create(), x86_perf_put_mediated_pmu() is called at vm_destroy(), then system wide perf events without exclude_guest=1 can not be created during the whole vm life cycle (where nr_mediated_pmu_vms > 0 always), do I understand and use the interface correctly ?
> 
> Right, but it only impacts the events of PMU with the
> PERF_PMU_CAP_MEDIATED_VPMU.
> For other PMUs, the event with exclude_guest=1 can still be created.
> KVM should not touch the counters of the PMU without
> PERF_PMU_CAP_MEDIATED_VPMU.
> 
> BTW: I will also remove the prefix x86, since the functions are in the
> generic code.
> 
> Thanks,
> Kan
After userspace VMM call VCPU SET_CPUID() ioctl, KVM knows whether vPMU is enabled or not. If perf_get_mediated_pmu() is called at vm create, it is too early. 
it is better to let perf_get_mediated_pmu() track per cpu PMU state, so perf_get_mediated_pmu() can be called by kvm after vcpu_cpuid_set(). Note user space vmm may call SET_CPUID() on one vcpu multi times, then here refcount maybe isn't suitable. what's a better solution ?

thanks

