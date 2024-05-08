Return-Path: <kvm+bounces-16964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E67168BF55F
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 06:54:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 221A9B22FCC
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 04:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0ABA16419;
	Wed,  8 May 2024 04:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JD8qMkP/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709B78F6C;
	Wed,  8 May 2024 04:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715144081; cv=none; b=WCRbY9xsCwc97zT9rIn4UoTg7PQM5gtvGCmb1Zehe3BwrV+z3iyuOmNbi6r896Cmd9KqOX94DszL8RH/NKYeMiJA5CvCpQ4wJWahj6B5MVHml1OCmRgqLNB4J1gkBCjuBXf5Dc9cKb4Y6lOh/3HI8pjlsjDwcGMyd95ONUpEqMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715144081; c=relaxed/simple;
	bh=Q0p0XJQCrTJtsx0ioCAJHqfKLioBExpKxiOwq3LY3jI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cubAn34Ms1HB7tTPYJjPPqktqMJKKqmyhvM0vykG9kjwAK5vvie+3DtVW6vIoEP3WzxnXMYjvjC1LH3/LsaKPigd3CAj77tBquRJywW8YkUzVsP6W0pMY56aLQbeBYgv+KO4g2+jUqCupu1UExn1YjGECP323Kl0HCA9BMEe+os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JD8qMkP/; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715144081; x=1746680081;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Q0p0XJQCrTJtsx0ioCAJHqfKLioBExpKxiOwq3LY3jI=;
  b=JD8qMkP/mBRcfYf2FmGtZB05vQKSpA3cHtfXebi63RPqaha0daE97rQl
   4QDDPCa9psBTYwwBJZqKaoHeMw+5ktMHOFz0/HbYzqboJBvGDIbH1KimZ
   6BhNy0wotLkJwV82V3/f9TAriRwEdQLfT51a6vmF/NB+AsAPQmxdMcAK8
   4wejM8dOTGbKYVyoO901e0kM72mrRY+RXqSUX0+GRW+lLvCCOND1DV5uc
   4bVGf8E1fEynqd/34nHZOY43wa5XUxnXfHbR1dvkqtgEwWvV/4w+ikS/u
   EUxUGQYSTbsohj8gjsdsPqX9yv3kvouRk6NlVEHHOOH7Tz+Gvd8gHPPgQ
   A==;
X-CSE-ConnectionGUID: k/qHidEfRuuK+NdbF48QqQ==
X-CSE-MsgGUID: ZOOu4KAuSlep2gEAK606NA==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="14774128"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="14774128"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 21:54:40 -0700
X-CSE-ConnectionGUID: U35HV1bpSK+vUFpVZKRAwQ==
X-CSE-MsgGUID: OYBWaiNATIyFIh2EVEdU9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="28842016"
Received: from xiongzha-mobl1.ccr.corp.intel.com (HELO [10.124.225.233]) ([10.124.225.233])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 21:54:34 -0700
Message-ID: <f04e33c3-9da8-4372-bc21-ee68c00ac289@linux.intel.com>
Date: Wed, 8 May 2024 12:54:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/54] perf: Support get/put passthrough PMU interfaces
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
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-7-mizhang@google.com>
 <20240507084113.GR40213@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <20240507084113.GR40213@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/7/2024 4:41 PM, Peter Zijlstra wrote:
> On Mon, May 06, 2024 at 05:29:31AM +0000, Mingwei Zhang wrote:
> 
>> +int perf_get_mediated_pmu(void)
>> +{
>> +	int ret = 0;
>> +
>> +	mutex_lock(&perf_mediated_pmu_mutex);
>> +	if (refcount_inc_not_zero(&nr_mediated_pmu_vms))
>> +		goto end;
>> +
>> +	if (atomic_read(&nr_include_guest_events)) {
>> +		ret = -EBUSY;
>> +		goto end;
>> +	}
>> +	refcount_set(&nr_mediated_pmu_vms, 1);
>> +end:
>> +	mutex_unlock(&perf_mediated_pmu_mutex);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(perf_get_mediated_pmu);
>> +
>> +void perf_put_mediated_pmu(void)
>> +{
>> +	if (!refcount_dec_not_one(&nr_mediated_pmu_vms))
>> +		refcount_set(&nr_mediated_pmu_vms, 0);
> 
> I'm sorry, but this made the WTF'o'meter go 'ding'.
> 
> Isn't that simply refcount_dec() ?
when nr_mediated_pmu_vms is 1, refcount_dec(&nr_mediated_pmu_vms) has an
error and call trace: refcount_t: decrement hit 0; leaking memory.

Similar when nr_mediated_pmu_vms is 0, refcount_inc(&nr_mediated_pmu_vms)
has an error and call trace also: refcount_t: addition on 0; use_after_free.

it seems refcount_set() should be used to set 1 or 0 to refcount_t.
> 
>> +}
>> +EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
>> +
>>  /*
>>   * Holding the top-level event's child_mutex means that any
>>   * descendant process that has inherited this event will block
>> @@ -12086,11 +12140,24 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
>>  	if (err)
>>  		goto err_callchain_buffer;
>>  
>> +	if (is_include_guest_event(event)) {
>> +		mutex_lock(&perf_mediated_pmu_mutex);
>> +		if (refcount_read(&nr_mediated_pmu_vms)) {
>> +			mutex_unlock(&perf_mediated_pmu_mutex);
>> +			err = -EACCES;
>> +			goto err_security_alloc;
>> +		}
>> +		atomic_inc(&nr_include_guest_events);
>> +		mutex_unlock(&perf_mediated_pmu_mutex);
>> +	}
> 
> Wouldn't all that be nicer with a helper function?
yes, it is nicer.

thanks
> 
> 	if (is_include_guest_event() && !perf_get_guest_event())
> 		goto err_security_alloc;
> 
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
>> -- 
>> 2.45.0.rc1.225.g2a3ae87e7f-goog
>>
> 

