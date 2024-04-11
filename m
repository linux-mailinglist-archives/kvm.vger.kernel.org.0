Return-Path: <kvm+bounces-14327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B6188A1FC8
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:53:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64240B23C75
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FF8917BD8;
	Thu, 11 Apr 2024 19:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TuaiYfpC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09014D534;
	Thu, 11 Apr 2024 19:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712865215; cv=none; b=e7lCQmS0XlGL2ipd8AukWbAWbKOnVSGUNuB8stgW8u6Ao+QWV6zDb5LeD4X/DoSlxdY2/GwNgBPS9DFgE9h8Nrbk9rO0B7/s5Nnu4wVZE4vrPv4H3i9C4KnK8KYA2zlCBnK6Crd0VDzJKEU23IdxLC5mQPgjSbY7WluUMmXqKwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712865215; c=relaxed/simple;
	bh=ooc/3U/BIHQw6GI+B/XxilcVEV/bYvn4gSSCUU399o4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OIjy/AoD9GAZYXrzt2Zrvm+CZans+n5eL4krkBIZ/sEnTxtalvjOVv5nbCrM9ikxiqOnhbySJNmki19l9fAJDgMTcJraWyZTqrJg6ZJx5JNom8kakkStjxA8Tf5/qInmeWgY46oKVit8tbd/nnACRODIIgHKzvHTqyAAfI5UGKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TuaiYfpC; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712865215; x=1744401215;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ooc/3U/BIHQw6GI+B/XxilcVEV/bYvn4gSSCUU399o4=;
  b=TuaiYfpCVXmQ5Lu+BwJ7+QjPv4loMPgVEZdXfrBDbNXqVQ692UktZa2S
   owZLvNqK+MP1wCiGvN9Jhk/dVK6P6f9ezXXWb8ZDA1mEkohPU2ctgPjj+
   mQ3xhlmk4b1IT7oEQei4G3gUpgW5tGxwiIhjcHsLSxusjTLuvhaR+Cz1F
   S+RnxRDCTt7UFXgSa5dOJ4DY04WgRaBXOIE5YnCl0l3UsFQO9tK0vYwlZ
   lEllOwvzQ7J2BAm3M0wBNzwzWTHY1tQM5UbY32rs24ud9vtCua9Lwwxfz
   I679CmFwFkCglKJswyQk/Vo7TSR+iLHvlONZvQGkSUTx0HAy+FQvEC6rx
   g==;
X-CSE-ConnectionGUID: nQI8nukZTP6t59+kEbo3Bw==
X-CSE-MsgGUID: 5KiGRKVLQhWW7asoTwZ83w==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="12095154"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="12095154"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 12:53:34 -0700
X-CSE-ConnectionGUID: Q6Avs5dnRAKNgmSRyDPoYA==
X-CSE-MsgGUID: ib36SwfwQaaftes4YDnKgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="21600326"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 12:53:34 -0700
Received: from [10.212.101.117] (kliang2-mobl1.ccr.corp.intel.com [10.212.101.117])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 3C28320921DA;
	Thu, 11 Apr 2024 12:53:31 -0700 (PDT)
Message-ID: <23af8648-ca9f-41d2-8782-f2ffc3c11e9e@linux.intel.com>
Date: Thu, 11 Apr 2024 15:53:29 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/41] perf: Support guest enter/exit interfaces
To: Sean Christopherson <seanjc@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com,
 kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-3-xiong.y.zhang@linux.intel.com>
 <ZhgmrczGpccfU-cI@google.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <ZhgmrczGpccfU-cI@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-04-11 2:06 p.m., Sean Christopherson wrote:
> On Fri, Jan 26, 2024, Xiong Zhang wrote:
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 683dc086ef10..59471eeec7e4 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -3803,6 +3803,8 @@ static inline void group_update_userpage(struct perf_event *group_event)
>>  		event_update_userpage(event);
>>  }
>>  
>> +static DEFINE_PER_CPU(bool, __perf_force_exclude_guest);
>> +
>>  static int merge_sched_in(struct perf_event *event, void *data)
>>  {
>>  	struct perf_event_context *ctx = event->ctx;
>> @@ -3814,6 +3816,14 @@ static int merge_sched_in(struct perf_event *event, void *data)
>>  	if (!event_filter_match(event))
>>  		return 0;
>>  
>> +	/*
>> +	 * The __perf_force_exclude_guest indicates entering the guest.
>> +	 * No events of the passthrough PMU should be scheduled.
>> +	 */
>> +	if (__this_cpu_read(__perf_force_exclude_guest) &&
>> +	    has_vpmu_passthrough_cap(event->pmu))
> 
> As mentioned in the previous reply, I think perf should WARN and reject any attempt
> to trigger a "passthrough" context switch if such a switch isn't supported by
> perf, not silently let it go through and then skip things later.

perf supports many PMUs. The core PMU is one of them. Only the core PMU
supports "passthrough", and will do the "passthrough" context switch if
there are active events.
For other PMUs, they should not be impacted. The "passthrough" context
switch should be transparent for there.

Here is to reject an existing host event in the schedule stage. If a
"passthrough" guest is running, perf should rejects any existing host
events of the "passthrough" supported PMU.

> 
>> +		return 0;
>> +
>>  	if (group_can_go_on(event, *can_add_hw)) {
>>  		if (!group_sched_in(event, ctx))
>>  			list_add_tail(&event->active_list, get_event_list(event));
> 
> ...
> 
>> +/*
>> + * When a guest enters, force all active events of the PMU, which supports
>> + * the VPMU_PASSTHROUGH feature, to be scheduled out. The events of other
>> + * PMUs, such as uncore PMU, should not be impacted. The guest can
>> + * temporarily own all counters of the PMU.
>> + * During the period, all the creation of the new event of the PMU with
>> + * !exclude_guest are error out.
>> + */
>> +void perf_guest_enter(void)
>> +{
>> +	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
>> +
>> +	lockdep_assert_irqs_disabled();
>> +
>> +	if (__this_cpu_read(__perf_force_exclude_guest))
> 
> This should be a WARN_ON_ONCE, no?

To debug the improper behavior of KVM?
I guess yes.

> 
>> +		return;
>> +
>> +	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
>> +
>> +	perf_force_exclude_guest_enter(&cpuctx->ctx);
>> +	if (cpuctx->task_ctx)
>> +		perf_force_exclude_guest_enter(cpuctx->task_ctx);
>> +
>> +	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
>> +
>> +	__this_cpu_write(__perf_force_exclude_guest, true);
>> +}
>> +EXPORT_SYMBOL_GPL(perf_guest_enter);
>> +
>> +static void perf_force_exclude_guest_exit(struct perf_event_context *ctx)
>> +{
>> +	struct perf_event_pmu_context *pmu_ctx;
>> +	struct pmu *pmu;
>> +
>> +	update_context_time(ctx);
>> +	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
>> +		pmu = pmu_ctx->pmu;
>> +		if (!has_vpmu_passthrough_cap(pmu))
>> +			continue;
> 
> I don't see how we can sanely support a CPU that doesn't support writable
> PERF_GLOBAL_STATUS across all PMUs.

Only core PMU has the PERF_GLOBAL_STATUS. Other PMUs, e.g., uncore PMU,
aren't impacted by the MSR. Those MSRs should be ignored.

> 
>> +
>> +		perf_pmu_disable(pmu);
>> +		pmu_groups_sched_in(ctx, &ctx->pinned_groups, pmu);
>> +		pmu_groups_sched_in(ctx, &ctx->flexible_groups, pmu);
>> +		perf_pmu_enable(pmu);
>> +	}
>> +}
>> +
>> +void perf_guest_exit(void)
>> +{
>> +	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
>> +
>> +	lockdep_assert_irqs_disabled();
>> +
>> +	if (!__this_cpu_read(__perf_force_exclude_guest))
> 
> WARN_ON_ONCE here too?
> 
>> +		return;
>> +
>> +	__this_cpu_write(__perf_force_exclude_guest, false);
>> +
>> +	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
>> +
>> +	perf_force_exclude_guest_exit(&cpuctx->ctx);
>> +	if (cpuctx->task_ctx)
>> +		perf_force_exclude_guest_exit(cpuctx->task_ctx);
>> +
>> +	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
>> +}
>> +EXPORT_SYMBOL_GPL(perf_guest_exit);
>> +
>> +static inline int perf_force_exclude_guest_check(struct perf_event *event,
>> +						 int cpu, struct task_struct *task)
>> +{
>> +	bool *force_exclude_guest = NULL;
>> +
>> +	if (!has_vpmu_passthrough_cap(event->pmu))
>> +		return 0;
>> +
>> +	if (event->attr.exclude_guest)
>> +		return 0;
>> +
>> +	if (cpu != -1) {
>> +		force_exclude_guest = per_cpu_ptr(&__perf_force_exclude_guest, cpu);
>> +	} else if (task && (task->flags & PF_VCPU)) {
>> +		/*
>> +		 * Just need to check the running CPU in the event creation. If the
>> +		 * task is moved to another CPU which supports the force_exclude_guest.
>> +		 * The event will filtered out and be moved to the error stage. See
>> +		 * merge_sched_in().
>> +		 */
>> +		force_exclude_guest = per_cpu_ptr(&__perf_force_exclude_guest, task_cpu(task));
>> +	}
> 
> These checks are extremely racy, I don't see how this can possibly do the
> right thing.  PF_VCPU isn't a "this is a vCPU task", it's a "this task is about
> to do VM-Enter, or just took a VM-Exit" (the "I'm a virtual CPU" comment in
> include/linux/sched.h is wildly misleading, as it's _only_ valid when accounting
> time slices).
>

This is to reject an !exclude_guest event creation for a running
"passthrough" guest from host perf tool.
Could you please suggest a way to detect it via the struct task_struct?


> Digging deeper, I think __perf_force_exclude_guest has similar problems, e.g.
> perf_event_create_kernel_counter() calls perf_event_alloc() before acquiring the
> per-CPU context mutex.

Do you mean that the perf_guest_enter() check could be happened right
after the perf_force_exclude_guest_check()?
It's possible. For this case, the event can still be created. It will be
treated as an existing event and handled in merge_sched_in(). It will
never be scheduled when a guest is running.

The perf_force_exclude_guest_check() is to make sure most of the cases
can be rejected at the creation place. For the corner cases, they will
be rejected in the schedule stage.

> 
>> +	if (force_exclude_guest && *force_exclude_guest)
>> +		return -EBUSY;
>> +	return 0;
>> +}
>> +
>>  /*
>>   * Holding the top-level event's child_mutex means that any
>>   * descendant process that has inherited this event will block
>> @@ -11973,6 +12142,11 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
>>  		goto err_ns;
>>  	}
>>  
>> +	if (perf_force_exclude_guest_check(event, cpu, task)) {
> 
> This should be:
> 
> 	err = perf_force_exclude_guest_check(event, cpu, task);
> 	if (err)
> 		goto err_pmu;
> 
> i.e. shouldn't effectively ignore/override the return result.
>

Sure.

Thanks,
Kan

>> +		err = -EBUSY;
>> +		goto err_pmu;
>> +	}
>> +
>>  	/*
>>  	 * Disallow uncore-task events. Similarly, disallow uncore-cgroup
>>  	 * events (they don't make sense as the cgroup will be different
>> -- 
>> 2.34.1
>>

