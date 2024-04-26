Return-Path: <kvm+bounces-16014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB2CD8B2F51
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 06:10:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BCF7282B3E
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 04:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07547824B0;
	Fri, 26 Apr 2024 04:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NeG+3NwX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85445823DC;
	Fri, 26 Apr 2024 04:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104598; cv=none; b=ILBy9ErUi4lb8Z/K4jUcpyv6KVt4uNJ7aWiORGndyRsM75k2lYfnyiVnkLpInU/DdAQFaNsNzWEjcwwQeP1gwzfnsLqKn49Pd9CWa1/xQhJghPjIju1Ob77J6BCSjviQrNnsSePshzCI5V6KRcsJdjmK+GYhT0s+SqoQoJ3O0fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104598; c=relaxed/simple;
	bh=HoKx09rdRxN0ZIAbUYC7LzWiGNN0kAzLltW3ZSNTTmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lmDJh06pYjL06FpxqkHce1kS+j3oOChvV210CNob8fahtL4wqw/Ae+ecTbLVmQ+vCg6wz5chHrKFuyv2IrCHwrplsznENX0NDLoAZs3aIKqh/CcUJ8bfbdUZ0OcSckVjNSaR28vvf9Muj0OjuGUIw/JXwh7USF5aFgoAHBUVgeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NeG+3NwX; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714104596; x=1745640596;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HoKx09rdRxN0ZIAbUYC7LzWiGNN0kAzLltW3ZSNTTmQ=;
  b=NeG+3NwXaL5QgOX6MQtQOF+pYR2I3VmO/DqgKLHdr7ruV5cNxfjdZHuO
   8zJNa6K01FrWzYdiXyZCuBlAEiCumFChgi8G0I0C/QbxICTKRwRPqH5Yq
   FoAYEgDk2xkaz3U/Q/9ka0t41RkCiqsKDcJXy5RMRVsMpXABsSmdrYSVc
   9NlrHqijj/2oEXIYuHOdqXAipCaTZeyyPrB3TdLQprZYOwCneCyR+guqh
   IkF/dBaAOGlDNQ4eot4wGjgMU42bE2HWzoRpLNZliDZ73LL7KUMN/CKg5
   6B89TZk2cFFzu5poDG5txGCLQ4W/mnqwRXAWO93dDSeZWtpiEtE0tWsCs
   g==;
X-CSE-ConnectionGUID: f2X5DvzTQtmjzKVig14RPA==
X-CSE-MsgGUID: vUjk0fFoTl6C8F+01+g8yQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="13665062"
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="13665062"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 21:09:56 -0700
X-CSE-ConnectionGUID: m6D5xHUyRX6/nMLIVjw3xQ==
X-CSE-MsgGUID: RP5RRLT7Sn2Wjn72m1/kUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="25175174"
Received: from xiongzha-mobl1.ccr.corp.intel.com (HELO [10.124.225.233]) ([10.124.225.233])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 21:09:52 -0700
Message-ID: <f8a525e0-6364-4565-bd34-605846dc367c@linux.intel.com>
Date: Fri, 26 Apr 2024 12:09:48 +0800
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
Content-Language: en-US
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <23af8648-ca9f-41d2-8782-f2ffc3c11e9e@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


>>> +static inline int perf_force_exclude_guest_check(struct perf_event *event,
>>> +						 int cpu, struct task_struct *task)
>>> +{
>>> +	bool *force_exclude_guest = NULL;
>>> +
>>> +	if (!has_vpmu_passthrough_cap(event->pmu))
>>> +		return 0;
>>> +
>>> +	if (event->attr.exclude_guest)
>>> +		return 0;
>>> +
>>> +	if (cpu != -1) {
>>> +		force_exclude_guest = per_cpu_ptr(&__perf_force_exclude_guest, cpu);
>>> +	} else if (task && (task->flags & PF_VCPU)) {
>>> +		/*
>>> +		 * Just need to check the running CPU in the event creation. If the
>>> +		 * task is moved to another CPU which supports the force_exclude_guest.
>>> +		 * The event will filtered out and be moved to the error stage. See
>>> +		 * merge_sched_in().
>>> +		 */
>>> +		force_exclude_guest = per_cpu_ptr(&__perf_force_exclude_guest, task_cpu(task));
>>> +	}
>>
>> These checks are extremely racy, I don't see how this can possibly do the
>> right thing.  PF_VCPU isn't a "this is a vCPU task", it's a "this task is about
>> to do VM-Enter, or just took a VM-Exit" (the "I'm a virtual CPU" comment in
>> include/linux/sched.h is wildly misleading, as it's _only_ valid when accounting
>> time slices).
>>
> 
> This is to reject an !exclude_guest event creation for a running
> "passthrough" guest from host perf tool.
> Could you please suggest a way to detect it via the struct task_struct?
Here PF_VCPU is used to distinguish a perf event profiling userspace VMM
process, like perf record -e {} -p $QEMU_PID. A lot of emails have
discussed how to handle system wide perf event which has
perf_event.attr.task == NULL. But perf event for user space VMM should be
handled the same as system wide perf event, perf need a method to identify
a process perf event is for user space VMM. PF_VCPU isn't the right one,
then an open how to handle this ?

thanks
> 
> 
>> Digging deeper, I think __perf_force_exclude_guest has similar problems, e.g.
>> perf_event_create_kernel_counter() calls perf_event_alloc() before acquiring the
>> per-CPU context mutex.
> 
> Do you mean that the perf_guest_enter() check could be happened right
> after the perf_force_exclude_guest_check()?
> It's possible. For this case, the event can still be created. It will be
> treated as an existing event and handled in merge_sched_in(). It will
> never be scheduled when a guest is running.
> 
> The perf_force_exclude_guest_check() is to make sure most of the cases
> can be rejected at the creation place. For the corner cases, they will
> be rejected in the schedule stage.
> 
>>
>>> +	if (force_exclude_guest && *force_exclude_guest)
>>> +		return -EBUSY;
>>> +	return 0;
>>> +}
>>> +
>>>  /*
>>>   * Holding the top-level event's child_mutex means that any
>>>   * descendant process that has inherited this event will block
>>> @@ -11973,6 +12142,11 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
>>>  		goto err_ns;
>>>  	}
>>>  
>>> +	if (perf_force_exclude_guest_check(event, cpu, task)) {
>>
>> This should be:
>>
>> 	err = perf_force_exclude_guest_check(event, cpu, task);
>> 	if (err)
>> 		goto err_pmu;
>>
>> i.e. shouldn't effectively ignore/override the return result.
>>
> 
> Sure.
> 
> Thanks,
> Kan
> 
>>> +		err = -EBUSY;
>>> +		goto err_pmu;
>>> +	}
>>> +
>>>  	/*
>>>  	 * Disallow uncore-task events. Similarly, disallow uncore-cgroup
>>>  	 * events (they don't make sense as the cgroup will be different
>>> -- 
>>> 2.34.1
>>>
> 

