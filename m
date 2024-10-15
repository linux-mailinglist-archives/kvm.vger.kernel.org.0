Return-Path: <kvm+bounces-28907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 61B4999F239
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 18:01:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9201B1C227D9
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 16:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B1981F9EAA;
	Tue, 15 Oct 2024 16:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ix78B4lr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2541F7065;
	Tue, 15 Oct 2024 16:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729008002; cv=none; b=letB8RavK4yFkTKD5SLniIcI/M/x5IbeeJKq5iE+gdnEH2ONuQst9ftizO8RWMwzQro/J1zjE8HZmjx0+4+j7PsuDpYxxXteAsgy2zM7mUbETt7aF0Qcu0I5DglvyLE8D9EDZEK43vkBkZbWQRfd1zbQCHGHJLxz29CYS9ZBtxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729008002; c=relaxed/simple;
	bh=pCU+pB0KfcrmrFmAlcoOMXk3l4RlE2A7qXOkifOQMqI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oJ1LgGxKPXys/qOen7BipCYQxtWKsmn10NNrKgvLzgXYyfeNny0ZjLZn28s5M7Imdve1htSvZlmpIqvA3OD6xI58BNfDK3MRiN4LMkiqzSniIHDAnP1hTh5azCjLhI5bERXl49DST3c4uRpBMt5yDMApJXEbDY9AjGrpl/MOcnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ix78B4lr; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729008000; x=1760544000;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pCU+pB0KfcrmrFmAlcoOMXk3l4RlE2A7qXOkifOQMqI=;
  b=ix78B4lrBj3l6qWUTxTDoPL6V1DyuhSWmeC+UbQPePH8f7zJO7bX9RfD
   wOMIeRHQc5JyYpY6k8N/UY4Pp6EQHJEdKzAxs7pUk3ciXnQHgPnJDYAk2
   X0hYJCIOc8/kYESr5wB+K+rbJOB7L2k+62WatFHhf8jiHvPDd7g3VIfdP
   X1uVwhiTPPkv6LV9Aqiyhtp9kZ3qt++8aseXLzAbBBWPQlGTXKqBwvG2C
   JfZeZx3KX2dNkza2EgHVLOJmoFHVIzfrXJNlguY3OX4XFjWmK93QcScB3
   eNk8qR7EbhKgMJX0pWt9pSPKhyQ4cr56smJr7sUwfQHi/UF6PUSjvX8mE
   Q==;
X-CSE-ConnectionGUID: gc+kxh2ERVaepErZshRv0Q==
X-CSE-MsgGUID: UcPDkYCjQkKwiCPw8XhqVw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="39533452"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="39533452"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 08:59:59 -0700
X-CSE-ConnectionGUID: 6PdZecyvQDmtSavWVaMIlw==
X-CSE-MsgGUID: MXiTfl4KQUC53NZSD6JFKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,205,1725346800"; 
   d="scan'208";a="78010530"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 08:59:59 -0700
Received: from [10.212.125.233] (kliang2-mobl1.ccr.corp.intel.com [10.212.125.233])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 4890F20B5782;
	Tue, 15 Oct 2024 08:59:56 -0700 (PDT)
Message-ID: <4580f0d0-97e6-4f25-8837-3c30dacd3249@linux.intel.com>
Date: Tue, 15 Oct 2024 11:59:54 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 14/58] perf: Add switch_interrupt() interface
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mingwei Zhang <mizhang@google.com>, Manali Shukla
 <manali.shukla@amd.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-15-mizhang@google.com>
 <9bf5ba7d-d65e-4f2c-96fb-1a1ca0193732@amd.com>
 <1db598cd-328e-4b4d-a147-7030eb697ece@linux.intel.com>
 <3dd7e187-9fbe-4748-9be5-638c8816116e@amd.com>
 <CAL715W+a9p_44CVdXZ6HCS42oUgfam=qYT_XoeN6zxfS16YY8w@mail.gmail.com>
 <20241014115903.GF16066@noisy.programming.kicks-ass.net>
 <c4d61d85-fb4f-40c4-8400-4a5b907c79a7@linux.intel.com>
 <20241014174556.GJ16066@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20241014174556.GJ16066@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-10-14 1:45 p.m., Peter Zijlstra wrote:
> On Mon, Oct 14, 2024 at 12:15:11PM -0400, Liang, Kan wrote:
>>
>>
>> On 2024-10-14 7:59 a.m., Peter Zijlstra wrote:
>>> On Mon, Sep 23, 2024 at 08:49:17PM +0200, Mingwei Zhang wrote:
>>>
>>>> The original implementation is by design having a terrible performance
>>>> overhead, ie., every PMU context switch at runtime requires a SRCU
>>>> lock pair and pmu list traversal. To reduce the overhead, we put
>>>> "passthrough" pmus in the front of the list and quickly exit the pmu
>>>> traversal when we just pass the last "passthrough" pmu.
>>>
>>> What was the expensive bit? The SRCU memory barrier or the list
>>> iteration? How long is that list really?
>>
>> Both. But I don't think there is any performance data.
>>
>> The length of the list could vary on different platforms. For a modern
>> server, there could be hundreds of PMUs from uncore PMUs, CXL PMUs,
>> IOMMU PMUs, PMUs of accelerator devices and PMUs from all kinds of
>> devices. The number could keep increasing with more and more devices
>> supporting the PMU capability.
>>
>> Two methods were considered.
>> - One is to add a global variable to track the "passthrough" pmu. The
>> idea assumes that there is only one "passthrough" pmu that requires the
>> switch, and the situation will not be changed in the near feature.
>> So the SRCU memory barrier and the list iteration can be avoided.
>> It's implemented in the patch
>>
>> - The other one is always put the "passthrough" pmus in the front of the
>> list. So the unnecessary list iteration can be avoided. It does nothing
>> for the SRCU lock pair.
> 
> PaulMck has patches that introduce srcu_read_lock_lite(), which would
> avoid the smp_mb() in most cases.
> 
>   https://lkml.kernel.org/r/20241011173931.2050422-6-paulmck@kernel.org
> 
> We can also keep a second list, just for the passthrough pmus. A bit
> like sched_cb_list.

Maybe we can do something like pmu_event_list, which has its own lock.
So we should not need the srcu and the module reference.

Thanks,
Kan



