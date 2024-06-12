Return-Path: <kvm+bounces-19449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD6159053E9
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 15:38:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 619082839BA
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 13:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B901217BB31;
	Wed, 12 Jun 2024 13:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eDZJ9c9r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596FA178398;
	Wed, 12 Jun 2024 13:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718199492; cv=none; b=J3qq+/T7aRiLCqa+OAUEvGJqmu9lkIx0sbl9uC+WUfR8K+Q4s/ybV/5pOAF2bRdEbyVdTj7EAStlnzqdAyc3oDRNdsrA0NA2bev+WY8fTvbch1tCckRl3Pfyf6EU2XHX8x+swij7cDNg/F6RjJUGykzmFmhnHu9mxO59cfdedTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718199492; c=relaxed/simple;
	bh=GAIDHXecjjeCcaH4nBavfTaUc1opIy56ggHhblmAVmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xirekp/mSYZUvHD0Zb5Lvhy90FJUD4hNT98qV5U3efnfaT3bfB2PyTa/kijh1hK0AdeU3wBtbaRTP8lVV/at6MsyRtnt0duBKsy/OptcE+d/C5uFvAtoE6WL27ZMOKCLmmRUkg0uRhT9Dt19SM+KTVrxrvP6SNaMmdciJBBXQPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eDZJ9c9r; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718199491; x=1749735491;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GAIDHXecjjeCcaH4nBavfTaUc1opIy56ggHhblmAVmg=;
  b=eDZJ9c9rivjeQ1oDPyMZznrUDrjZPEoxxe0B8Uo+sCUQvrC3OLXt653g
   P4cJZ0kXUdOipGEfyGJLlwhMogDr1Gk1WNruoldficO12QHX4DA3BI5LJ
   vmQNy2sr1by1ykjZGi4RcWYwOYyWrg7xB7CYfmwihqkhw1qevz14Nn8hp
   CRLq7TNuu+jjxIsH/OJTKnBSxVC7Q81Vod8hEdY9u05SW3UJzuQFgYWjb
   /MLXssnpJDDFUNjgKFvkwUFr/OccNxTxcMF2ZdnlzmJ1EQNSXjOvUIgk4
   31FBYrTYlIYzm4UHiTQ3GOyQiUdWKfhkFUd3+gnWNjGK6DHzLqtoP29hW
   A==;
X-CSE-ConnectionGUID: Eryf/IheTGOtwVSMSO02LQ==
X-CSE-MsgGUID: /ZMp4jSNQXW9Y2WeEblWbw==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="14764586"
X-IronPort-AV: E=Sophos;i="6.08,233,1712646000"; 
   d="scan'208";a="14764586"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 06:38:10 -0700
X-CSE-ConnectionGUID: zf8r4UJYRBu/ogolF/JApw==
X-CSE-MsgGUID: jnNGnMJsRAm7j+bosk4lzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,233,1712646000"; 
   d="scan'208";a="39856133"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 06:38:10 -0700
Received: from [10.212.10.32] (kliang2-mobl1.ccr.corp.intel.com [10.212.10.32])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 6718920B5703;
	Wed, 12 Jun 2024 06:38:07 -0700 (PDT)
Message-ID: <e72c847f-a069-43e4-9e49-37c0bf9f0a8b@linux.intel.com>
Date: Wed, 12 Jun 2024 09:38:06 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/54] perf: Add generic exclude_guest support
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-8-mizhang@google.com>
 <20240507085807.GS40213@noisy.programming.kicks-ass.net>
 <902c40cc-6e0b-4b2f-826c-457f533a0a76@linux.intel.com>
 <20240611120641.GF8774@noisy.programming.kicks-ass.net>
 <0a403a6c-8d55-42cb-a90c-c13e1458b45e@linux.intel.com>
 <20240612111732.GW40213@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20240612111732.GW40213@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-06-12 7:17 a.m., Peter Zijlstra wrote:
> On Tue, Jun 11, 2024 at 09:27:46AM -0400, Liang, Kan wrote:
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index dd4920bf3d1b..68c8b93c4e5c 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -945,6 +945,7 @@ struct perf_event_context {
>>  	u64				time;
>>  	u64				timestamp;
>>  	u64				timeoffset;
>> +	u64				timeguest;
>>
>>  	/*
>>  	 * These fields let us detect when two contexts have both
> 
>> @@ -651,10 +653,26 @@ __perf_update_times(struct perf_event *event, u64
>> now, u64 *enabled, u64 *runnin
>>
>>  static void perf_event_update_time(struct perf_event *event)
>>  {
>> -	u64 now = perf_event_time(event);
>> +	u64 now;
>> +
>> +	/* Never count the time of an active guest into an exclude_guest event. */
>> +	if (event->ctx->timeguest &&
>> +	    event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) {
>> +		/*
>> +		 * If a guest is running, use the timestamp while entering the guest.
>> +		 * If the guest is leaving, reset the event timestamp.
>> +		 */
>> +		if (__this_cpu_read(perf_in_guest))
>> +			event->tstamp = event->ctx->timeguest;
>> +		else
>> +			event->tstamp = event->ctx->time;
>> +		return;
>> +	}
>>
>> +	now = perf_event_time(event);
>>  	__perf_update_times(event, now, &event->total_time_enabled,
>>  					&event->total_time_running);
>> +
>>  	event->tstamp = now;
>>  }
> 
> So I really don't like this much, 

An alternative way I can imagine may maintain a dedicated timeline for
the PASSTHROUGH PMUs. For that, we probably need two new timelines for
the normal events and the cgroup events. That sounds too complex.

> and AFAICT this is broken. At the very
> least this doesn't work right for cgroup events, because they have their
> own timeline.

I think we just need a new start time for an event. So we may use
perf_event_time() to replace the ctx->time for the cgroup events.

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 019c237dd456..6c46699c6752 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -665,7 +665,7 @@ static void perf_event_update_time(struct perf_event
*event)
 		if (__this_cpu_read(perf_in_guest))
 			event->tstamp = event->ctx->timeguest;
 		else
-			event->tstamp = event->ctx->time;
+			event->tstamp = perf_event_time(event);
 		return;
 	}


> 
> Let me have a poke...

Sure.

Thanks,
Kan

