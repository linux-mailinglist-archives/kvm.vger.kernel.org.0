Return-Path: <kvm+bounces-26015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9445696F87A
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 17:41:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48FF4281F5A
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 15:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4279B1D2F7D;
	Fri,  6 Sep 2024 15:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FQXtnkX3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF12381C2;
	Fri,  6 Sep 2024 15:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725637257; cv=none; b=pXlYFqfERjedYYm7x0YIrj/rUELSnBaTpD8OkqDiyhJKYVYg0zgxbKQI5h3nyOykDm7xLf71qF8KqXM7qCjTOEsNCAIT7oG8sBh4AXBthW9PB+kphRcGB5vYvLahdJtNG5Y928b2/ke+oevzsUW5T57me5GFOSBvtKQaqA76zfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725637257; c=relaxed/simple;
	bh=1Fu7uwV9RsPMnzLbXRB2dUkd/WKQaciTY4PTS+mZbkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B6K8d3AOcHMF8YHea7BsEM2owP9cb88KZNAtBN+GlBH133et2O72pQVoQduoPMhiPl3tkG9kBkG2Puw69pz65DB/fFfBXgqniiJfX7lXCaRtl0oyyKU5u4eps35T1M+VVnJP73vwHBBzRKLShdea7amkdlAKmE7mHsx62rM2oMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FQXtnkX3; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725637254; x=1757173254;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1Fu7uwV9RsPMnzLbXRB2dUkd/WKQaciTY4PTS+mZbkM=;
  b=FQXtnkX3MBuhzLYpzQy/xmn88JMyhMZyciHXT0+q8h6iSNBAmEkvod9U
   /d/B1Ff+G/mvsUZKlJ4k/6VqdFkg1+SuraPCIL8Ql6T8tCsiHiktXbFAu
   QV6i6dIcOhyyzwCo+pS1GW1mQCJ00+88LLrtBobINhzzL+tB7nJiTIueb
   dh58wYx1yF5EcATcwZ8YO/Nt4OVIPthO9Gml0sphRGY7So9i98BT2sSsx
   T697Csn3EcNG0N8BOACilIn7h9jUQdSQI5ykbGVsho+4qyhjRe1F5xo0B
   R5ZHB1bsc7h7TsiKFnRZgguywPDTHrQLkSnPTH/l1D5Exd6PGwss8rjyv
   Q==;
X-CSE-ConnectionGUID: l85X4wiwSwarmv2a4igdNw==
X-CSE-MsgGUID: aTNV7DRjSJOTjDfMTCNwFw==
X-IronPort-AV: E=McAfee;i="6700,10204,11187"; a="24349146"
X-IronPort-AV: E=Sophos;i="6.10,208,1719903600"; 
   d="scan'208";a="24349146"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2024 08:40:54 -0700
X-CSE-ConnectionGUID: kvCqxR8hRsWOkJvVNFLYCg==
X-CSE-MsgGUID: Ric9UC2/SOmekh8PD4LpJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,208,1719903600"; 
   d="scan'208";a="65960192"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2024 08:40:55 -0700
Received: from [10.212.119.23] (kliang2-mobl1.ccr.corp.intel.com [10.212.119.23])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 821F520B5782;
	Fri,  6 Sep 2024 08:40:52 -0700 (PDT)
Message-ID: <a585d90b-91f4-49de-bcba-5c2b45d339bc@linux.intel.com>
Date: Fri, 6 Sep 2024 11:40:51 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 06/58] perf: Support get/put passthrough PMU
 interfaces
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>,
 Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-7-mizhang@google.com>
 <f7b2c537-840d-4043-944e-59926f0fa3bb@linux.intel.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <f7b2c537-840d-4043-944e-59926f0fa3bb@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-09-06 6:59 a.m., Mi, Dapeng wrote:
> 
> On 8/1/2024 12:58 PM, Mingwei Zhang wrote:
>> From: Kan Liang <kan.liang@linux.intel.com>
>>
>> Currently, the guest and host share the PMU resources when a guest is
>> running. KVM has to create an extra virtual event to simulate the
>> guest's event, which brings several issues, e.g., high overhead, not
>> accuracy and etc.
>>
>> A new passthrough PMU method is proposed to address the issue. It requires
>> that the PMU resources can be fully occupied by the guest while it's
>> running. Two new interfaces are implemented to fulfill the requirement.
>> The hypervisor should invoke the interface while creating a guest which
>> wants the passthrough PMU capability.
>>
>> The PMU resources should only be temporarily occupied as a whole when a
>> guest is running. When the guest is out, the PMU resources are still
>> shared among different users.
>>
>> The exclude_guest event modifier is used to guarantee the exclusive
>> occupation of the PMU resources. When creating a guest, the hypervisor
>> should check whether there are !exclude_guest events in the system.
>> If yes, the creation should fail. Because some PMU resources have been
>> occupied by other users.
>> If no, the PMU resources can be safely accessed by the guest directly.
>> Perf guarantees that no new !exclude_guest events are created when a
>> guest is running.
>>
>> Only the passthrough PMU is affected, but not for other PMU e.g., uncore
>> and SW PMU. The behavior of those PMUs are not changed. The guest
>> enter/exit interfaces should only impact the supported PMUs.
>> Add a new PERF_PMU_CAP_PASSTHROUGH_VPMU flag to indicate the PMUs that
>> support the feature.
>>
>> Add nr_include_guest_events to track the !exclude_guest events of PMU
>> with PERF_PMU_CAP_PASSTHROUGH_VPMU.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
>> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>  include/linux/perf_event.h | 10 ++++++
>>  kernel/events/core.c       | 66 ++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 76 insertions(+)
>>
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index a5304ae8c654..45d1ea82aa21 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -291,6 +291,7 @@ struct perf_event_pmu_context;
>>  #define PERF_PMU_CAP_NO_EXCLUDE			0x0040
>>  #define PERF_PMU_CAP_AUX_OUTPUT			0x0080
>>  #define PERF_PMU_CAP_EXTENDED_HW_TYPE		0x0100
>> +#define PERF_PMU_CAP_PASSTHROUGH_VPMU		0x0200
>>  
>>  struct perf_output_handle;
>>  
>> @@ -1728,6 +1729,8 @@ extern void perf_event_task_tick(void);
>>  extern int perf_event_account_interrupt(struct perf_event *event);
>>  extern int perf_event_period(struct perf_event *event, u64 value);
>>  extern u64 perf_event_pause(struct perf_event *event, bool reset);
>> +int perf_get_mediated_pmu(void);
>> +void perf_put_mediated_pmu(void);
>>  #else /* !CONFIG_PERF_EVENTS: */
>>  static inline void *
>>  perf_aux_output_begin(struct perf_output_handle *handle,
>> @@ -1814,6 +1817,13 @@ static inline u64 perf_event_pause(struct perf_event *event, bool reset)
>>  {
>>  	return 0;
>>  }
>> +
>> +static inline int perf_get_mediated_pmu(void)
>> +{
>> +	return 0;
>> +}
>> +
>> +static inline void perf_put_mediated_pmu(void)			{ }
>>  #endif
>>  
>>  #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 8f908f077935..45868d276cde 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -402,6 +402,20 @@ static atomic_t nr_bpf_events __read_mostly;
>>  static atomic_t nr_cgroup_events __read_mostly;
>>  static atomic_t nr_text_poke_events __read_mostly;
>>  static atomic_t nr_build_id_events __read_mostly;
>> +static atomic_t nr_include_guest_events __read_mostly;
>> +
>> +static atomic_t nr_mediated_pmu_vms;
>> +static DEFINE_MUTEX(perf_mediated_pmu_mutex);
>> +
>> +/* !exclude_guest event of PMU with PERF_PMU_CAP_PASSTHROUGH_VPMU */
>> +static inline bool is_include_guest_event(struct perf_event *event)
>> +{
>> +	if ((event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) &&
>> +	    !event->attr.exclude_guest)
>> +		return true;
>> +
>> +	return false;
>> +}
>>  
>>  static LIST_HEAD(pmus);
>>  static DEFINE_MUTEX(pmus_lock);
>> @@ -5212,6 +5226,9 @@ static void _free_event(struct perf_event *event)
>>  
>>  	unaccount_event(event);
>>  
>> +	if (is_include_guest_event(event))
>> +		atomic_dec(&nr_include_guest_events);
>> +
>>  	security_perf_event_free(event);
>>  
>>  	if (event->rb) {
>> @@ -5769,6 +5786,36 @@ u64 perf_event_pause(struct perf_event *event, bool reset)
>>  }
>>  EXPORT_SYMBOL_GPL(perf_event_pause);
>>  
>> +/*
>> + * Currently invoked at VM creation to
>> + * - Check whether there are existing !exclude_guest events of PMU with
>> + *   PERF_PMU_CAP_PASSTHROUGH_VPMU
>> + * - Set nr_mediated_pmu_vms to prevent !exclude_guest event creation on
>> + *   PMUs with PERF_PMU_CAP_PASSTHROUGH_VPMU
>> + *
>> + * No impact for the PMU without PERF_PMU_CAP_PASSTHROUGH_VPMU. The perf
>> + * still owns all the PMU resources.
>> + */
>> +int perf_get_mediated_pmu(void)
>> +{
>> +	guard(mutex)(&perf_mediated_pmu_mutex);
>> +	if (atomic_inc_not_zero(&nr_mediated_pmu_vms))
>> +		return 0;
>> +
>> +	if (atomic_read(&nr_include_guest_events))
>> +		return -EBUSY;
>> +
>> +	atomic_inc(&nr_mediated_pmu_vms);
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(perf_get_mediated_pmu);
>> +
>> +void perf_put_mediated_pmu(void)
>> +{
>> +	atomic_dec(&nr_mediated_pmu_vms);
>> +}
>> +EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
>> +
>>  /*
>>   * Holding the top-level event's child_mutex means that any
>>   * descendant process that has inherited this event will block
>> @@ -11907,6 +11954,17 @@ static void account_event(struct perf_event *event)
>>  	account_pmu_sb_event(event);
>>  }
>>  
>> +static int perf_account_include_guest_event(void)
>> +{
>> +	guard(mutex)(&perf_mediated_pmu_mutex);
>> +
>> +	if (atomic_read(&nr_mediated_pmu_vms))
>> +		return -EACCES;
> 
> Kan, Namhyung posted a patchset
> https://lore.kernel.org/all/20240904064131.2377873-1-namhyung@kernel.org/
> which would remove to set exclude_guest flag from perf tools by default.
> This may impact current mediated vPMU solution, but fortunately the
> patchset provides a fallback mechanism to add exclude_guest flag if kernel
> returns "EOPNOTSUPP".
> 
> So we'd better return "EOPNOTSUPP" instead of "EACCES" here. BTW, returning
> "EOPNOTSUPP" here looks more reasonable than "EACCES".

It seems the existing Apple M1 PMU has ready returned "EOPNOTSUPP" for
the !exclude_guest. Yes, we should use the same error code.

Thanks,
Kan
> 
> 
>> +
>> +	atomic_inc(&nr_include_guest_events);
>> +	return 0;
>> +}
>> +
>>  /*
>>   * Allocate and initialize an event structure
>>   */
>> @@ -12114,11 +12172,19 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
>>  	if (err)
>>  		goto err_callchain_buffer;
>>  
>> +	if (is_include_guest_event(event)) {
>> +		err = perf_account_include_guest_event();
>> +		if (err)
>> +			goto err_security_alloc;
>> +	}
>> +
>>  	/* symmetric to unaccount_event() in _free_event() */
>>  	account_event(event);
>>  
>>  	return event;
>>  
>> +err_security_alloc:
>> +	security_perf_event_free(event);
>>  err_callchain_buffer:
>>  	if (!event->parent) {
>>  		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
> 

