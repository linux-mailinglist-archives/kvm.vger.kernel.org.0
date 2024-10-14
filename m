Return-Path: <kvm+bounces-28777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2299E99D3B3
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 17:43:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 465151C23E10
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 15:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F1AC1AE877;
	Mon, 14 Oct 2024 15:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QOcTz+cJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDFE1AB6D4;
	Mon, 14 Oct 2024 15:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920427; cv=none; b=koend8H0TweTwKF8+rMAwf7ORhxkK/heDilHT+YJcq/ZIOVyS0jZz5lA9Q9C/njZ4Xx0QJvljH7PE//xOeyCZIc9rluZmq1qiYo313eLQwK5Wocf4Ffkm4OrCHlukVW1dbl426rYjOJmErG7b1fyfqqOwpFBqgUNqEols729zdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920427; c=relaxed/simple;
	bh=34dUQUcFKDFdIHwZqfFx3rcVXBMaQlLmOketdaPEtS8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J+JsFzv4CzdgERjc897CoZxATir3B4LBUzsxYEggwOW5OoBVJOuCZUl9jy+XdfFuGMJqAnN8VWQ/1Ik8e2zmC5OByyAS9BJDhsp5efdR7TJEFOCA/0mrjC5XKt4hVX4UDTVoLWaoKcz99EfPg5Z0fb+sLu+nvWc3kg5Tj+fsErQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QOcTz+cJ; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728920425; x=1760456425;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=34dUQUcFKDFdIHwZqfFx3rcVXBMaQlLmOketdaPEtS8=;
  b=QOcTz+cJo9oFZ9PgwLWBWAPAs0GDupDAU6RbTRQ1NMxhFbN3xrD1tRtm
   OeWH8Gk7+6qugxEBSSCtKa6opykVMrmkEw29PRqrdPys9upDxYMeKgVmz
   7oDWHD2lkYDj6ZVYLrS3jWk3JEBTrULgoPRsmAUG8ypywVAB7uzqsKXNL
   jnwsffsZaK4TZWjjrYVLus3cqlhA2s82e3t+lC4GK6udM6mCuGWZe4lLx
   rMF5II+9g2UCjj4LplvxsN17w/twxbjBHG5n8d8pqF7m991jmaUrd7mbU
   Wyo38WWiPTlhbi8Z2jhJgG4eOtreaGfweFNHtXGIQ2U3BdgPN9WUzoM0q
   g==;
X-CSE-ConnectionGUID: TnB83QAETwS5XtZIbpvIqQ==
X-CSE-MsgGUID: iBOAB6vCRn6gPHFKibahIA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28161071"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28161071"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 08:40:25 -0700
X-CSE-ConnectionGUID: TpJEMHKES0y5rG8ZSo5phA==
X-CSE-MsgGUID: g9ubOfTEShKmyqi7UV3KxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="77541546"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 08:40:25 -0700
Received: from [10.212.61.73] (kliang2-mobl1.ccr.corp.intel.com [10.212.61.73])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 51CE520B5782;
	Mon, 14 Oct 2024 08:40:22 -0700 (PDT)
Message-ID: <3da8094d-0763-4b66-9ac1-71cd333b7747@linux.intel.com>
Date: Mon, 14 Oct 2024 11:40:21 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 14/58] perf: Add switch_interrupt() interface
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
 <20240801045907.4010984-15-mizhang@google.com>
 <20241014115641.GE16066@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20241014115641.GE16066@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-10-14 7:56 a.m., Peter Zijlstra wrote:
> On Thu, Aug 01, 2024 at 04:58:23AM +0000, Mingwei Zhang wrote:
> 
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
> 
> Should we move the whole module reference to perf_pmu_(,un}register() ?

A PMU module can be load/unload anytime. How should we know if the PMU
module is available when the reference check is moved to
perf_pmu_(,un}register()?

> 
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
> 
> Why impose this limit? Changelog also fails to explain this.

Because the passthru_pmu is global variable. If there are two or more
PMUs with the PERF_PMU_CAP_PASSTHROUGH_VPMU, the former one will be
implicitly overwritten if without the check.

Thanks
Kan
> 
>> +		}
>> +	}
>> +
>> +	list_add_tail_rcu(&pmu->entry, &pmus);
>>  	atomic_set(&pmu->exclusive_cnt, 0);
>>  	ret = 0;
>>  unlock:
>> -- 
>> 2.46.0.rc1.232.g9752f9e123-goog
>>
> 


