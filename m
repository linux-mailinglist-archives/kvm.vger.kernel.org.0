Return-Path: <kvm+bounces-16962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AD6468BF537
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 06:22:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E70DB20F4B
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 04:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2032B168B9;
	Wed,  8 May 2024 04:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WTrnBDj1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80271A2C23;
	Wed,  8 May 2024 04:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715142129; cv=none; b=NAUTUq6vSSQqQaaNR+mhfCyWdY93qjcbNfUDscurHY9szcwN3qsBEkFMdP6LN6WEZRmp3mzEOuPaKK2+ub1QcCvPeHk15uvj7Yn7iqA1un3XhOYR9IoN/eje99z1aUgjamM8ZlbYPLn34GniSn/4oRp+KsKIgKHIzDRY2PthZTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715142129; c=relaxed/simple;
	bh=Xbmb9k7dCGFPOturx0ynsEGt5VbwCznRaBGW5tLsNBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=URncCmZPJtXi6eP2Wrs5OsgN1LbiQOAy6Dx9JiBbdOBcqlW71/kS7gIrmx95prQeEplgc9mVx9HYtqR6O5xak7A5NNQHtuf1Gc5wyR0smUWD94x2uURy3lhBaWOySY/dlH2O+DSE3XkWZRr3Q58roZZwmNZuaRhoQJpXzU3LGls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WTrnBDj1; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715142128; x=1746678128;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Xbmb9k7dCGFPOturx0ynsEGt5VbwCznRaBGW5tLsNBM=;
  b=WTrnBDj1vPZJ36+LC2djWNmkeyFB1r1wl9M5A0h2x7SWB0I9zjpny/tn
   lDVIIsYj7mzBsxUaNpxSzXidh7opjcPtQNAl+iGH14AAxRikP8Y7Hw1wz
   V9E47CdJgYL89KKmwsab/UqkTt86MxRPaKNgzBtNC7jrru2eKWeMx+FoP
   e4+o7UWjShS/4QXqOcyqFhLt2EyzcNcedZCUdAa0dckhzGlcJtSzgmMM/
   cc0gMyvdEJaOUsFq8DYc1ayGePqHpPPPCqWeMizBKYCKn1ZYYcWj5ohko
   eMFeittSnRkcX4uSDCACVr+vSIp2gjbkPMbK9lHL7bgrlg6GsxCKuph7+
   Q==;
X-CSE-ConnectionGUID: xP1vqfFJSruXq+bvqR9ueg==
X-CSE-MsgGUID: YPEwsoPqSIOGsIfp1BAFAg==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="11421657"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="11421657"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 21:22:07 -0700
X-CSE-ConnectionGUID: bPK6vy59SimXj60cotCiHA==
X-CSE-MsgGUID: oswyRXu0QHmEMAd1KmvMZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="28845604"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 21:22:02 -0700
Message-ID: <549ac752-1079-4898-85f6-e59644f8f2d0@linux.intel.com>
Date: Wed, 8 May 2024 12:22:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 38/54] KVM: x86/pmu: Call perf_guest_enter() at PMU
 context switch
To: Peter Zijlstra <peterz@infradead.org>, Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-39-mizhang@google.com>
 <20240507093923.GX40213@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240507093923.GX40213@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/7/2024 5:39 PM, Peter Zijlstra wrote:
> On Mon, May 06, 2024 at 05:30:03AM +0000, Mingwei Zhang wrote:
>> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>>
>> perf subsystem should stop and restart all the perf events at the host
>> level when entering and leaving passthrough PMU respectively. So invoke
>> the perf API at PMU context switch functions.
>>
>> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>  arch/x86/events/core.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
>> index f5a043410614..6fe467bca809 100644
>> --- a/arch/x86/events/core.c
>> +++ b/arch/x86/events/core.c
>> @@ -705,6 +705,8 @@ void x86_perf_guest_enter(u32 guest_lvtpc)
>>  {
>>  	lockdep_assert_irqs_disabled();
>>  
>> +	perf_guest_enter();
>> +
>>  	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_GUEST_PMI_VECTOR |
>>  			       (guest_lvtpc & APIC_LVT_MASKED));
>>  }
>> @@ -715,6 +717,8 @@ void x86_perf_guest_exit(void)
>>  	lockdep_assert_irqs_disabled();
>>  
>>  	apic_write(APIC_LVTPC, APIC_DM_NMI);
>> +
>> +	perf_guest_exit();
>>  }
>>  EXPORT_SYMBOL_GPL(x86_perf_guest_exit);
> *sigh*.. why does this patch exist? Please merge with the one that
> introduces these functions.
>
> This is making review really hard.
Sure. we would adjust the patches sequence. Thanks.

