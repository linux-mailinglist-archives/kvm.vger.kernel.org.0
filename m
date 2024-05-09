Return-Path: <kvm+bounces-17100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBE428C0C08
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 09:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5A291C213D5
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 07:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF13149C4E;
	Thu,  9 May 2024 07:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="glJ5WtAF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E58713C801;
	Thu,  9 May 2024 07:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715240370; cv=none; b=RsDVJI5Oke3sUgtuHfP1ANM4a3o9QbmLZwnQFhQcnTLt/OyVICDiEwqysss+d5+aAbl4WysRvMZKUtCl5DQO37Ii6QXd6UH62jYTGp51vYAzWmCRZ9yS0i14A0g1FSVEJecoVKCs+Qi8s7ZRCy1ndtR/4ojZoh0O8G39lwA0Z1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715240370; c=relaxed/simple;
	bh=XFMcQ/A69OiBy3Lz1De3drWFpu9vtrOzMDyg8BmJZyo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=COEReg5ObL0pnqZVyt5xoi79MjdIYErVkMnOpL+gUquJIV6EGAt+pTDJJaAKbsW+CyMCTMbsqQCOwOJh9YfkxpgQ7uMj0xTV81DQmlTEa+fxKZwrAcrmMi6VOvCImGnSZuN/dqt56FGYTHtRecg6/yxaVdkPQaJ74Db+SAaSQbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=glJ5WtAF; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715240369; x=1746776369;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XFMcQ/A69OiBy3Lz1De3drWFpu9vtrOzMDyg8BmJZyo=;
  b=glJ5WtAFY6Ow4H2OUc+vr8cC9zaw75UEYPpqBcavPpzhI5X/Rt9RUNF5
   NvbK39NfN/GlB+sdbzGsNjitV4G8DU8NadGJQ02gDPQ9LOlbQS9M1dyCW
   /HcMy5+3cjx4jArD/j3fd+JEheCQvEf6Y+HKUjQCfB4vx1bfG1RCfY6yM
   CKhDuBsqg00w5k279XMzLFheWV4t0ldtlA8ufG10HvJabTioIKTWD+etG
   krx0m6IbQCYIdKZmT+iZG36+f9ToSubBhiTqbyWxVTQaaKY2YwZRahPJJ
   7eF60otIv7T+/3801158Q/li2R5lrcon88jEDh/AFLrSAZHGI0nt46ish
   A==;
X-CSE-ConnectionGUID: iCfuL9LMQB69TpKBsjzktQ==
X-CSE-MsgGUID: JuqjZkrFTAepFj7Nf1o+jQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="22539809"
X-IronPort-AV: E=Sophos;i="6.08,147,1712646000"; 
   d="scan'208";a="22539809"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 00:39:28 -0700
X-CSE-ConnectionGUID: 3quzHjsBRVOvmFmgdlm9wg==
X-CSE-MsgGUID: KJ6wJakhQGGARu73xS87qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,147,1712646000"; 
   d="scan'208";a="29695294"
Received: from xiongzha-mobl1.ccr.corp.intel.com (HELO [10.124.225.233]) ([10.124.225.233])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 00:39:23 -0700
Message-ID: <fd01485d-558b-4a96-bdc4-18663bf47759@linux.intel.com>
Date: Thu, 9 May 2024 15:39:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/54] perf: core/x86: Forbid PMI handler when guest
 own PMU
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
 <20240506053020.3911940-14-mizhang@google.com>
 <20240507093311.GW40213@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <20240507093311.GW40213@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/7/2024 5:33 PM, Peter Zijlstra wrote:
> On Mon, May 06, 2024 at 05:29:38AM +0000, Mingwei Zhang wrote:
> 
>> @@ -1749,6 +1749,23 @@ perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
>>  	u64 finish_clock;
>>  	int ret;
>>  
>> +	/*
>> +	 * When guest pmu context is loaded this handler should be forbidden from
>> +	 * running, the reasons are:
>> +	 * 1. After x86_perf_guest_enter() is called, and before cpu enter into
>> +	 *    non-root mode, NMI could happen, but x86_pmu_handle_irq() restore PMU
>> +	 *    to use NMI vector, which destroy KVM PMI vector setting.
>> +	 * 2. When VM is running, host NMI other than PMI causes VM exit, KVM will
>> +	 *    call host NMI handler (vmx_vcpu_enter_exit()) first before KVM save
>> +	 *    guest PMU context (kvm_pmu_save_pmu_context()), as x86_pmu_handle_irq()
>> +	 *    clear global_status MSR which has guest status now, then this destroy
>> +	 *    guest PMU status.
>> +	 * 3. After VM exit, but before KVM save guest PMU context, host NMI other
>> +	 *    than PMI could happen, x86_pmu_handle_irq() clear global_status MSR
>> +	 *    which has guest status now, then this destroy guest PMU status.
>> +	 */
>> +	if (perf_is_guest_context_loaded())
>> +		return 0;
> 
> A function call makes sense because? Also, isn't this naming at least the purpose of function call is to re-use the per-cpu variable defined in
perf core, otherwise another per-cpu variable will be defined in
arch/x86/event/core.c, whether function call or per-cpu variable depends on
the interface between perf and KVM.
> very little misleading? Specifically this is about passthrough, not
> guest context per se.
> 
>>  	/*
>>  	 * All PMUs/events that share this PMI handler should make sure to
>>  	 * increment active_events for their events.
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index acf16676401a..5da7de42954e 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -1736,6 +1736,7 @@ extern int perf_get_mediated_pmu(void);
>>  extern void perf_put_mediated_pmu(void);
>>  void perf_guest_enter(void);
>>  void perf_guest_exit(void);
>> +bool perf_is_guest_context_loaded(void);
>>  #else /* !CONFIG_PERF_EVENTS: */
>>  static inline void *
>>  perf_aux_output_begin(struct perf_output_handle *handle,
>> @@ -1830,6 +1831,10 @@ static inline int perf_get_mediated_pmu(void)
>>  static inline void perf_put_mediated_pmu(void)			{ }
>>  static inline void perf_guest_enter(void)			{ }
>>  static inline void perf_guest_exit(void)			{ }
>> +static inline bool perf_is_guest_context_loaded(void)
>> +{
>> +	return false;
>> +}
>>  #endif
>>  
>>  #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 4c6daf5cc923..184d06c23391 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -5895,6 +5895,11 @@ void perf_guest_exit(void)
>>  	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
>>  }
>>  
>> +bool perf_is_guest_context_loaded(void)
>> +{
>> +	return __this_cpu_read(perf_in_guest);
>> +}
>> +
>>  /*
>>   * Holding the top-level event's child_mutex means that any
>>   * descendant process that has inherited this event will block
>> -- 
>> 2.45.0.rc1.225.g2a3ae87e7f-goog
>>
> 

