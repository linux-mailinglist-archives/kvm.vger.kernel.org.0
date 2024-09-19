Return-Path: <kvm+bounces-27178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA27697C99C
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 15:01:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06645B22B17
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 13:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAA0D19DFAE;
	Thu, 19 Sep 2024 13:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iFioIop1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2E741746;
	Thu, 19 Sep 2024 13:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726750860; cv=none; b=Ad4q02sbCfgBoxwXYYBzqDgidFKWYw9TpSN7//S7WAZHL7f/hZxYGbKhKXotSvA51awWU01EeO9nmJiG0gw7gl1KnPn044ceXqJ90s7n4WHwlp7DjJQbVfhvubh7i3Z6oqIpjD+ldn+cvrd4R4Ssz4KjBE1Br/SOYP2dGmQgGEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726750860; c=relaxed/simple;
	bh=+KPAsjX34xbAwq1NL0SgPf0Wc1ZNqJh0/Z/0io7fmSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=os5UrdtTJZsx/dnfOmb2cncr/i8FMx91dpQ61NB81lnyyXn9YgYfzmfoB7EtFZPjH6xydkOjyJwIT+OZadqIRZ+EIZ2wnFTUcmcFCXMsZPIICpHFnnKDCQWBomr8q8oHCnK9qXPFdD/K5rJBXHBfbCK922VKZoINGevjp2x2Tjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iFioIop1; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726750858; x=1758286858;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+KPAsjX34xbAwq1NL0SgPf0Wc1ZNqJh0/Z/0io7fmSE=;
  b=iFioIop1B++V0/Udb0hBJwyLv74xJgUnqjp8vTplVF2ZCed+avpNXKvd
   R2KVZuKLfuy0f0ScWjLikxf1jsYuNU7ytLTCv71awD0nIIH4V7WXXic77
   tI1Zw4lgyOtShTqdYOwymU+n/BXk3vYPDydKdlvm80ASbu9Jz+MdcU6NY
   Ia1qdUeG0pRryJJEWcQhZxznWcN4rv+0tV2Q1D7xnWdzOTpXMpT15RwVM
   +nqO6F/sYZ2evT1yWzVYqQPLYrsLSXVSjI89qImvYJ23Esm2AOcc994jV
   PemboUkhIa+FC+Xw1cRf/h28vUVxSCQc4isfn6gRJFVerSmQP8yKwTKW+
   A==;
X-CSE-ConnectionGUID: j6+ltzppTX2vlsAL9229XQ==
X-CSE-MsgGUID: 7CaU7igLSZerZD0WgZJTqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25231229"
X-IronPort-AV: E=Sophos;i="6.10,241,1719903600"; 
   d="scan'208";a="25231229"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2024 06:00:58 -0700
X-CSE-ConnectionGUID: 6nR+txzsQe+hsFkJlZ70eg==
X-CSE-MsgGUID: P8erXjGnQ1GWRsEFukyRNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,241,1719903600"; 
   d="scan'208";a="69953033"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2024 06:00:57 -0700
Received: from [10.212.121.54] (kliang2-mobl1.ccr.corp.intel.com [10.212.121.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id AF77720CFEE5;
	Thu, 19 Sep 2024 06:00:54 -0700 (PDT)
Message-ID: <1db598cd-328e-4b4d-a147-7030eb697ece@linux.intel.com>
Date: Thu, 19 Sep 2024 09:00:53 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 14/58] perf: Add switch_interrupt() interface
To: Manali Shukla <manali.shukla@amd.com>, Mingwei Zhang
 <mizhang@google.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-15-mizhang@google.com>
 <9bf5ba7d-d65e-4f2c-96fb-1a1ca0193732@amd.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <9bf5ba7d-d65e-4f2c-96fb-1a1ca0193732@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-09-19 2:02 a.m., Manali Shukla wrote:
> On 8/1/2024 10:28 AM, Mingwei Zhang wrote:
>> From: Kan Liang <kan.liang@linux.intel.com>
>>
>> There will be a dedicated interrupt vector for guests on some platforms,
>> e.g., Intel. Add an interface to switch the interrupt vector while
>> entering/exiting a guest.
>>
>> When PMI switch into a new guest vector, guest_lvtpc value need to be
>> reflected onto HW, e,g., guest clear PMI mask bit, the HW PMI mask
>> bit should be cleared also, then PMI can be generated continuously
>> for guest. So guest_lvtpc parameter is added into perf_guest_enter()
>> and switch_interrupt().
>>
>> At switch_interrupt(), the target pmu with PASSTHROUGH cap should
>> be found. Since only one passthrough pmu is supported, we keep the
>> implementation simply by tracking the pmu as a global variable.
>>
>> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
>>
>> [Simplify the commit with removal of srcu lock/unlock since only one pmu is
>> supported.]
>>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>  include/linux/perf_event.h |  9 +++++++--
>>  kernel/events/core.c       | 36 ++++++++++++++++++++++++++++++++++--
>>  2 files changed, 41 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index 75773f9890cc..aeb08f78f539 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -541,6 +541,11 @@ struct pmu {
>>  	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
>>  	 */
>>  	int (*check_period)		(struct perf_event *event, u64 value); /* optional */
>> +
>> +	/*
>> +	 * Switch the interrupt vectors, e.g., guest enter/exit.
>> +	 */
>> +	void (*switch_interrupt)	(bool enter, u32 guest_lvtpc); /* optional */
>>  };
>>  
>>  enum perf_addr_filter_action_t {
>> @@ -1738,7 +1743,7 @@ extern int perf_event_period(struct perf_event *event, u64 value);
>>  extern u64 perf_event_pause(struct perf_event *event, bool reset);
>>  int perf_get_mediated_pmu(void);
>>  void perf_put_mediated_pmu(void);
>> -void perf_guest_enter(void);
>> +void perf_guest_enter(u32 guest_lvtpc);
>>  void perf_guest_exit(void);
>>  #else /* !CONFIG_PERF_EVENTS: */
>>  static inline void *
>> @@ -1833,7 +1838,7 @@ static inline int perf_get_mediated_pmu(void)
>>  }
>>  
>>  static inline void perf_put_mediated_pmu(void)			{ }
>> -static inline void perf_guest_enter(void)			{ }
>> +static inline void perf_guest_enter(u32 guest_lvtpc)		{ }
>>  static inline void perf_guest_exit(void)			{ }
>>  #endif
>>  
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 57ff737b922b..047ca5748ee2 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -422,6 +422,7 @@ static inline bool is_include_guest_event(struct perf_event *event)
>>  
>>  static LIST_HEAD(pmus);
>>  static DEFINE_MUTEX(pmus_lock);
>> +static struct pmu *passthru_pmu;
>>  static struct srcu_struct pmus_srcu;
>>  static cpumask_var_t perf_online_mask;
>>  static struct kmem_cache *perf_event_cache;
>> @@ -5941,8 +5942,21 @@ void perf_put_mediated_pmu(void)
>>  }
>>  EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
>>  
>> +static void perf_switch_interrupt(bool enter, u32 guest_lvtpc)
>> +{
>> +	/* Mediated passthrough PMU should have PASSTHROUGH_VPMU cap. */
>> +	if (!passthru_pmu)
>> +		return;
>> +
>> +	if (passthru_pmu->switch_interrupt &&
>> +	    try_module_get(passthru_pmu->module)) {
>> +		passthru_pmu->switch_interrupt(enter, guest_lvtpc);
>> +		module_put(passthru_pmu->module);
>> +	}
>> +}
>> +
>>  /* When entering a guest, schedule out all exclude_guest events. */
>> -void perf_guest_enter(void)
>> +void perf_guest_enter(u32 guest_lvtpc)
>>  {
>>  	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
>>  
>> @@ -5962,6 +5976,8 @@ void perf_guest_enter(void)
>>  		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
>>  	}
>>  
>> +	perf_switch_interrupt(true, guest_lvtpc);
>> +
>>  	__this_cpu_write(perf_in_guest, true);
>>  
>>  unlock:
>> @@ -5980,6 +5996,8 @@ void perf_guest_exit(void)
>>  	if (WARN_ON_ONCE(!__this_cpu_read(perf_in_guest)))
>>  		goto unlock;
>>  
>> +	perf_switch_interrupt(false, 0);
>> +
>>  	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
>>  	ctx_sched_in(&cpuctx->ctx, EVENT_GUEST);
>>  	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
>> @@ -11842,7 +11860,21 @@ int perf_pmu_register(struct pmu *pmu, const char *name, int type)
>>  	if (!pmu->event_idx)
>>  		pmu->event_idx = perf_event_idx_default;
>>  
>> -	list_add_rcu(&pmu->entry, &pmus);
>> +	/*
>> +	 * Initialize passthru_pmu with the core pmu that has
>> +	 * PERF_PMU_CAP_PASSTHROUGH_VPMU capability.
>> +	 */
>> +	if (pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) {
>> +		if (!passthru_pmu)
>> +			passthru_pmu = pmu;
>> +
>> +		if (WARN_ONCE(passthru_pmu != pmu, "Only one passthrough PMU is supported\n")) {
>> +			ret = -EINVAL;
>> +			goto free_dev;
>> +		}
>> +	}
> 
> 
> Our intention is to virtualize IBS PMUs (Op and Fetch) using the same framework. However, 
> if IBS PMUs are also using the PERF_PMU_CAP_PASSTHROUGH_VPMU capability, IBS PMU registration
> fails at this point because the Core PMU is already registered with PERF_PMU_CAP_PASSTHROUGH_VPMU.
>

The original implementation doesn't limit the number of PMUs with
PERF_PMU_CAP_PASSTHROUGH_VPMU. But at that time, we could not find a
case of more than one PMU with the flag. After several debates, the
patch was simplified only to support one PMU with the flag.
It should not be hard to change it back.

Thanks,
Kan

>> +
>> +	list_add_tail_rcu(&pmu->entry, &pmus);
>>  	atomic_set(&pmu->exclusive_cnt, 0);
>>  	ret = 0;
>>  unlock:
> 
> 

