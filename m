Return-Path: <kvm+bounces-28648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0027699AD17
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 21:50:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F51F1C213BB
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 19:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADEE61D0E2F;
	Fri, 11 Oct 2024 19:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eilKhl4J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AED1CF295;
	Fri, 11 Oct 2024 19:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728676190; cv=none; b=dzgEZ4Qw2xvDclfUztXfWVzeizGknEISeXZGkOW0gPcHUYFRNNrq2F2Cvd+NgYpNE7hnW9tuHCfNTAYT/6/ZE0wn3xkbYXdGuFRgTp/fijK+TIi6BjtAxHyUJV8+OaecntOXFYtlXsPVeh4X4JPXrQNNj5KunZcmHoNuZ/+Lcbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728676190; c=relaxed/simple;
	bh=maR0DPaRvlnXjxhuqIkFgSC3w2zg4X1CGE52ukaQHvo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GGKEXECAaKxW/jbn4Il0rqZQtcWDgjA4mOltmTT5Zs/8jvVe+vjaiPbzAYo0coh0y2JbdTaL5XiFiBwVYhVdzDLcvyvcUpEjMjtNVlUeutTOYSC/FXDVkcxEVZcIyU2QQWk7i+a4esaG15aebQ+VPOcavY8F6kkrl6jgwO+G8iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eilKhl4J; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728676189; x=1760212189;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=maR0DPaRvlnXjxhuqIkFgSC3w2zg4X1CGE52ukaQHvo=;
  b=eilKhl4J5+5wizWpeTD8g7uX17ndCUsiNzBg/DyZ6qzg6Sivn9UOfnIk
   7eA8fA/hTyqHNEis36kD/SzNVNo0JdVJ1TXZmsqeR2M9yBflRjZDpQ2pQ
   AvQpypA4kTQwRCPvNu+FcVsOiieDOXwDwca+yfB4yI3sQAnVjSSPJuOCb
   9QfBzDGSoZyXzy9O6uO34dor9tPkiXDyCEPPSE9zyDE1tEs6Ws0xPv2iz
   aIeM7PLj+gxruPkxhr5iCOIyXg3zkPBx0Pdm+AFzGMhScjhMsTM5iVQfo
   VoT0iIvd2EyuFoC2nH+sCGDsOK9ZpiPKRnzFQoQ63m4MkxKWSqeXslGyp
   w==;
X-CSE-ConnectionGUID: mHrqfStHRHuiW/C3ojclKA==
X-CSE-MsgGUID: fo6l783RSvyNdkr5SeJMmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="45597296"
X-IronPort-AV: E=Sophos;i="6.11,196,1725346800"; 
   d="scan'208";a="45597296"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2024 12:49:48 -0700
X-CSE-ConnectionGUID: 4p4+m52MRHy1scdDO7XxHw==
X-CSE-MsgGUID: AaRQBLpcQBCvmZvNBFvMYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,196,1725346800"; 
   d="scan'208";a="100314221"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2024 12:49:48 -0700
Received: from [10.212.74.37] (kliang2-mobl1.ccr.corp.intel.com [10.212.74.37])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 4FC1F20B5782;
	Fri, 11 Oct 2024 12:49:45 -0700 (PDT)
Message-ID: <a3326ee7-5ff0-4745-9e33-3ed5eec94c24@linux.intel.com>
Date: Fri, 11 Oct 2024 15:49:44 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 09/58] perf: Add a EVENT_GUEST flag
To: Peter Zijlstra <peterz@infradead.org>, Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-10-mizhang@google.com>
 <20241011184237.GQ17263@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20241011184237.GQ17263@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-10-11 2:42 p.m., Peter Zijlstra wrote:
> 
> Can you rework this one along these lines?

Sure.

I probably also add macros to replace the magic number 0 and 1. For example,

#define T_TOTAL		0
#define T_GUEST		1

Thanks,
Kan
> 
> ---
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -975,6 +975,7 @@ struct perf_event_context {
>  	 * Context clock, runs when context enabled.
>  	 */
>  	struct perf_time_ctx		time;
> +	struct perf_time_ctx		timeguest;
>  
>  	/*
>  	 * These fields let us detect when two contexts have both
> @@ -1066,6 +1067,7 @@ struct bpf_perf_event_data_kern {
>   */
>  struct perf_cgroup_info {
>  	struct perf_time_ctx		time;
> +	struct perf_time_ctx		timeguest;
>  	int				active;
>  };
>  
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -782,12 +782,44 @@ static inline int is_cgroup_event(struct
>  	return event->cgrp != NULL;
>  }
>  
> +static_assert(offsetof(struct perf_event, timeguest) -
> +	      offsetof(struct perf_event, time) == 
> +	      sizeof(struct perf_time_ctx));
> +
> +static_assert(offsetof(struct perf_cgroup_info, timeguest) -
> +	      offsetof(struct perf_cgroup_info, time) ==
> +	      sizeof(struct perf_time_ctx));
> +
> +static inline u64 __perf_event_time_ctx(struct perf_event *event,
> +					struct perf_time_ctx *times)
> +{
> +	u64 time = times[0].time;
> +	if (event->attr.exclude_guest)
> +		time -= times[1].time;
> +	return time;
> +}
> +
> +static inline u64 __perf_event_time_ctx_now(struct perf_event *event,
> +					    struct perf_time_ctx *times,
> +					    u64 now)
> +{
> +	if (event->attr.exclude_guest) {
> +		/*
> +		 * (now + times[0].offset) - (now + times[1].offset) :=
> +		 * times[0].offset - times[1].offset
> +		 */
> +		return READ_ONCE(times[0].offset) - READ_ONCE(times[1].offset);
> +	}
> +
> +	return now + READ_ONCE(times[0].offset);
> +}
> +
>  static inline u64 perf_cgroup_event_time(struct perf_event *event)
>  {
>  	struct perf_cgroup_info *t;
>  
>  	t = per_cpu_ptr(event->cgrp->info, event->cpu);
> -	return t->time.time;
> +	return __perf_event_time_ctx(event, &t->time);
>  }
>  
>  static inline u64 perf_cgroup_event_time_now(struct perf_event *event, u64 now)
> @@ -796,12 +828,12 @@ static inline u64 perf_cgroup_event_time
>  
>  	t = per_cpu_ptr(event->cgrp->info, event->cpu);
>  	if (!__load_acquire(&t->active))
> -		return t->time.time;
> +		return __perf_event_time_ctx(event, &t->time);
>  	now += READ_ONCE(t->time.offset);
> -	return now;
> +	return __perf_event_time_ctx_now(event, &t->time, now);
>  }
>  
> -static inline void update_perf_time_ctx(struct perf_time_ctx *time, u64 now, bool adv)
> +static inline void __update_perf_time_ctx(struct perf_time_ctx *time, u64 now, bool adv)
>  {
>  	if (adv)
>  		time->time += now - time->stamp;
> @@ -819,6 +851,13 @@ static inline void update_perf_time_ctx(
>  	WRITE_ONCE(time->offset, time->time - time->stamp);
>  }
>  
> +static inline void update_perf_time_ctx(struct perf_time_ctx *time, u64 now, bool adv)
> +{
> +	__update_perf_time_ctx(time + 0, now, adv);
> +	if (__this_cpu_read(perf_in_guest))
> +		__update_perf_time_ctx(time + 1, now, adv)
> +}
> +
>  static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx, bool final)
>  {
>  	struct perf_cgroup *cgrp = cpuctx->cgrp;
> 


