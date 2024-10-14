Return-Path: <kvm+bounces-28785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B5499D410
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 17:58:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9344F1F2425E
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 15:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A3741ABECD;
	Mon, 14 Oct 2024 15:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KgmArYgi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D171AB6F8;
	Mon, 14 Oct 2024 15:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728921431; cv=none; b=N0vMS0gx9SYUXvzZ/XKrnJDLwrGaANEbO3/5HpQkWux7+VbtC92u1wds409Mi1syz14ten45jhGur24Nv2seB8fWt1UlEU5JhvJsvZ4wtDeY8q4x/Iv5cfhQ6BYnc8KYjKVXKZPj6M0x+YBUgvCfJ9tlW3Lvn2No97j1CYhbeo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728921431; c=relaxed/simple;
	bh=G9fPElAJxrDGQC/kZ+EYJCbvxe/7Ndmr/D5FzKdq6t0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=feuajTuM5sT1L94SKUhU7thPDbelqbVAiZ9Qoonw53N13/xyZgwcAShqc3nUo0zyshsuBxJkpI9PXVGvynfbPfbzmWSZzYHgCH67awNZPN0bE8RPaDom33m+hp9wuwNhkwxiL4Cvrbt1R4NaeDot5N6gC3vmkcolkzG/BMPcups=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KgmArYgi; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728921430; x=1760457430;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=G9fPElAJxrDGQC/kZ+EYJCbvxe/7Ndmr/D5FzKdq6t0=;
  b=KgmArYgiadY3doCMqikcJjm1i2vXm2HSpE0n0p1fVQflyqDkZ5AcR5Q3
   RHOCyFjMgTiZHj6xqGNEiPVp/EDcmH/9ySIRgbt8suFEjJwmH/G1l5yk2
   JMSgG+/is8InB4Weap3eZYAcK2LZEdp1jBY/leQJO6o7EDm58f0vHqF3L
   LRd7HhvHZOsLLfOAqb3A0QEGjy4XRZpWRYhh+Mc4IKMB4hcqj7rQhtUWm
   pD3iBY5z6lLyFNHK97kFcZZAq2Y1zq4cmi166QrJuq+Ml18470Tb7Kp0/
   OUCYNPWRd2am8MkAzBkQK6sSvXHsxX2yqW3+0WqrcQc8oX9TshNTUg5PV
   g==;
X-CSE-ConnectionGUID: KCWd8SoPSBCv0wJ7sCM3pw==
X-CSE-MsgGUID: 6K54xQp4R4qkCgjq1AH0YA==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="38855025"
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="38855025"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 08:57:09 -0700
X-CSE-ConnectionGUID: qWC8gt/QSU6/DtkuD8K4RQ==
X-CSE-MsgGUID: QG2L3XvgQSifHOToiM3t1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="82172874"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 08:57:08 -0700
Received: from [10.212.61.73] (kliang2-mobl1.ccr.corp.intel.com [10.212.61.73])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 192B420CFEDE;
	Mon, 14 Oct 2024 08:57:04 -0700 (PDT)
Message-ID: <a69d870b-5fc2-49c6-a7d3-fed6b5b3add1@linux.intel.com>
Date: Mon, 14 Oct 2024 11:57:03 -0400
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
 <20241014135242.GH16066@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20241014135242.GH16066@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-10-14 9:52 a.m., Peter Zijlstra wrote:
> On Thu, Aug 01, 2024 at 04:58:23AM +0000, Mingwei Zhang wrote:
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
> 
> This seems to suggest the method is named wrong, it should probably be
> guest_enter() or somsuch.
>

The ctx_sched_in() is to schedule in the host context after the
guest_exit(). The EVENT_GUEST is to indicate the guest ctx switch.

The name may brings some confusion. Maybe I can add a wrap function
perf_host_enter() to include the above codes.

Thanks,
Kan

