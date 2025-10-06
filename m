Return-Path: <kvm+bounces-59516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 836FBBBD545
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 10:28:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE4A51894520
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 08:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 082A125DB1A;
	Mon,  6 Oct 2025 08:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZEVq2bqn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D2F14B953;
	Mon,  6 Oct 2025 08:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759739272; cv=none; b=hgBMuK2LhH/e9Qa2M1y6V75JGXYe+dYyH9QEDMHSRuMkXLTmUIkXfErVY/7XBBWv3/uGfZZPZmz+B6TBFiaVf7Mxc1Bh/m0wL55hm+O2km7px+YyQZ1phuYq3JjmhLtQyqnDcBESyBDVNQyoQhKjaCLpRJk2XevzCXHts4EYxqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759739272; c=relaxed/simple;
	bh=C7LeUaZn1B8sZIgBqMJlqx4SJPo4kEgFLME5WQuTY4k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kb0Wwz2jfulHrDjaoGTeGsvc50j2CFV0QweESeN2gCQ/o15Ywa7uuaHAwJT81J9H63hTqF0yuS1vdrwqAlC/xCc2wzObS2WhUsLjOtDJMIHEBr37jXwvZ8KpnGD1cX980A+ybrTV7UvJj5KRLuDMXbw63Qb6EFaAsUxeWZYMTzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZEVq2bqn; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759739270; x=1791275270;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=C7LeUaZn1B8sZIgBqMJlqx4SJPo4kEgFLME5WQuTY4k=;
  b=ZEVq2bqnpNSo0mCI2GNkZXWLs8hZ9pdtzYuBYNnULOV7mNJWx6ssPAJs
   vWKKfYnFLBKzhuXJmbQ0ryPc7og17PRbd3eXL6AskGu6Y1pKMaj0bCxlO
   Vxr+1egoKoZ4DnxuNgIfRBeylkL53Z15ZbGqYem9xkakwdyhmZwegQEP9
   OGz+hahHvb9xdnHnYJbOi1ZS4qFDE/nAdxJGo6eUJuk7Vwnh3bL1PrHVR
   SqiF3w4apH9hAFcp0Git0lQuSVNvU2IUgW1V5Ve37oAxv+QZ+lMX1xICq
   pWZivOyWzUd+fuhoVpuXq43dOPGBS+Zu27edrNU96BGkxErBMy2pdoIi8
   w==;
X-CSE-ConnectionGUID: 0ftuY+KgSW+LMHSJmz+D9g==
X-CSE-MsgGUID: zmUbNe71TC2A82usvJt4bQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11573"; a="61618639"
X-IronPort-AV: E=Sophos;i="6.18,319,1751266800"; 
   d="scan'208";a="61618639"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 01:27:47 -0700
X-CSE-ConnectionGUID: qtInCxNbQfqOafcplalvjw==
X-CSE-MsgGUID: PcS/8rmeR6OHiaxBfh3wmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,319,1751266800"; 
   d="scan'208";a="180623032"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.232.209]) ([10.124.232.209])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 01:27:43 -0700
Message-ID: <6a0c0406-670a-4cb6-90ad-338f05e6630e@linux.intel.com>
Date: Mon, 6 Oct 2025 16:27:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: REGRESSION on linux-next (next-20250919)
To: Sean Christopherson <seanjc@google.com>
Cc: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
 "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
 "intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>,
 Suresh Kumar Kurmi <suresh.kumar.kurmi@intel.com>,
 Jani Saarinen <jani.saarinen@intel.com>, lucas.demarchi@intel.com,
 linux-perf-users@vger.kernel.org, kvm@vger.kernel.org
References: <70b64347-2aca-4511-af78-a767d5fa8226@intel.com>
 <25af94f5-79e3-4005-964e-e77b1320a16e@linux.intel.com>
 <aNvyjkuDLOfxAANd@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <aNvyjkuDLOfxAANd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 9/30/2025 11:09 PM, Sean Christopherson wrote:
> On Tue, Sep 30, 2025, Dapeng Mi wrote:
>> On 9/30/2025 1:30 PM, Borah, Chaitanya Kumar wrote:
>>> Hello Sean,
>>>
>>> Hope you are doing well. I am Chaitanya from the linux graphics team in 
>>> Intel.
>>>
>>> This mail is regarding a regression we are seeing in our CI runs[1] on
>>> linux-next repository.
>>>
>>> Since the version next-20250919 [2], we are seeing the following regression
>>>
>>> `````````````````````````````````````````````````````````````````````````````````
>>> <4>[   10.973827] ------------[ cut here ]------------
>>> <4>[   10.973841] WARNING: arch/x86/events/core.c:3089 at 
>>> perf_get_x86_pmu_capability+0xd/0xc0, CPU#15: (udev-worker)/386
>>> ...
>>> <4>[   10.974028] Call Trace:
>>> <4>[   10.974030]  <TASK>
>>> <4>[   10.974033]  ? kvm_init_pmu_capability+0x2b/0x190 [kvm]
>>> <4>[   10.974154]  kvm_x86_vendor_init+0x1b0/0x1a40 [kvm]
>>> <4>[   10.974248]  vmx_init+0xdb/0x260 [kvm_intel]
>>> <4>[   10.974278]  ? __pfx_vt_init+0x10/0x10 [kvm_intel]
>>> <4>[   10.974296]  vt_init+0x12/0x9d0 [kvm_intel]
>>> <4>[   10.974309]  ? __pfx_vt_init+0x10/0x10 [kvm_intel]
>>> <4>[   10.974322]  do_one_initcall+0x60/0x3f0
>>> <4>[   10.974335]  do_init_module+0x97/0x2b0
>>> <4>[   10.974345]  load_module+0x2d08/0x2e30
>>> <4>[   10.974349]  ? __kernel_read+0x158/0x2f0
>>> <4>[   10.974370]  ? kernel_read_file+0x2b1/0x320
>>> <4>[   10.974381]  init_module_from_file+0x96/0xe0
>>> <4>[   10.974384]  ? init_module_from_file+0x96/0xe0
>>> <4>[   10.974399]  idempotent_init_module+0x117/0x330
>>> <4>[   10.974415]  __x64_sys_finit_module+0x73/0xe0
>>> ...
>>> `````````````````````````````````````````````````````````````````````````````````
>>> Details log can be found in [3].
>>>
>>> After bisecting the tree, the following patch [4] seems to be the first 
>>> "bad" commit
>>>
>>> `````````````````````````````````````````````````````````````````````````````````````````````````````````
>>>  From 51f34b1e650fc5843530266cea4341750bd1ae37 Mon Sep 17 00:00:00 2001
>>>
>>> From: Sean Christopherson <seanjc@google.com>
>>>
>>> Date: Wed, 6 Aug 2025 12:56:39 -0700
>>>
>>> Subject: KVM: x86/pmu: Snapshot host (i.e. perf's) reported PMU capabilities
>>>
>>> Take a snapshot of the unadulterated PMU capabilities provided by perf so
>>> that KVM can compare guest vPMU capabilities against hardware capabilities
>>> when determining whether or not to intercept PMU MSRs (and RDPMC).
>>> `````````````````````````````````````````````````````````````````````````````````````````````````````````
>>>
>>> We also verified that if we revert the patch the issue is not seen.
>>>
>>> Could you please check why the patch causes this regression and provide 
>>> a fix if necessary?
>> Hi Chaitanya,
>>
>> I suppose you found this warning on a hybrid client platform, right? It
>> looks the warning is triggered by the below WARN_ON_ONCE() in
>> perf_get_x86_pmu_capability() function.
>>
>>   if (WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) ||
>>         !x86_pmu_initialized()) {
>>         memset(cap, 0, sizeof(*cap));
>>         return;
>>     }
>>
>> The below change should fix it (just building, not test it). I would run a
>> full scope vPMU test after I come back from China national day's holiday.
> I have access to a hybrid system, I'll also double check there (though I'm 99.9%
> certain you've got it right).
>
>> Thanks.
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index cebce7094de8..6d87c25226d8 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -108,8 +108,6 @@ void kvm_init_pmu_capability(struct kvm_pmu_ops *pmu_ops)
>>         bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
>>         int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
>>
>> -       perf_get_x86_pmu_capability(&kvm_host_pmu);
>> -
>>         /*
>>          * Hybrid PMUs don't play nice with virtualization without careful
>>          * configuration by userspace, and KVM's APIs for reporting supported
>> @@ -120,6 +118,8 @@ void kvm_init_pmu_capability(struct kvm_pmu_ops *pmu_ops)
>>                 enable_pmu = false;
>>
>>         if (enable_pmu) {
>> +               perf_get_x86_pmu_capability(&kvm_host_pmu);
>> +
>>                 /*
>>                  * WARN if perf did NOT disable hardware PMU if the number of
>>                  * architecturally required GP counters aren't present, i.e. if
> If we go this route, then the !enable_pmu path should explicitly zero kvm_host_pmu
> so that the behavior is consistent userspace loads kvm.ko with enable_pmu=0,
> versus enable_pmu being cleared because of lack of support.
>
> 	if (!enable_pmu) {
> 		memset(&kvm_host_pmu, 0, sizeof(kvm_host_pmu));
> 		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
> 		return;
> 	}
>
> The alternative would be keep kvm_host_pmu valid at all times for !HYBRID, which
> is what I intended with the bad patch, but that too would lead to inconsistent
> behavior.  So I think it makes sense to go with Dapeng's approach; we can always
> revisit this if some future thing in KVM _needs_ kvm_host_pmu even with enable_pmu=0. 
>
> 	if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) {
> 		enable_pmu = false;
> 		memset(&kvm_host_pmu, 0, sizeof(kvm_host_pmu));
> 	} else {
> 		perf_get_x86_pmu_capability(&kvm_host_pmu);
> 	}

Yeah, it looks better. We should decouple "enable_pmu" and "kvm_host_pmu"
as the initial design. Thanks.


>

