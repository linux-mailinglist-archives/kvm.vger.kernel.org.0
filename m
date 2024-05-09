Return-Path: <kvm+bounces-17079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2B778C08F3
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 03:11:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 787E21F21C9F
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 01:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3222113A41D;
	Thu,  9 May 2024 01:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K+Z83yY9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15C013A3F0;
	Thu,  9 May 2024 01:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715217104; cv=none; b=FgMj6AaUwMs4/j0cDwMRIcqmzsFqCaZ20VEPyFaSKu77xsLknNVYeMFb84bTC0MCa0YB5GDJEbcYwJ6g1fqxmRXsXsIpvlRLkLAMMOLndEHOYFYo1Qt/E2FpHG0BottdZBMQVP02XEPYohx7GJaj1gjLDyxdCvMeewFCk8bqTho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715217104; c=relaxed/simple;
	bh=B9JeEIKGCcADmlV7K5aTdnLdvO5DeN0Kijfvke6PzeY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N9zPJNGyhKYLZOxFLf35hO8/olZRTBdM2K62jyoOaUKX7vjhgILGqHXw705HALkC614oOnAAtYoJGPY80D5cO8xUHo9CvaAVydq2zTZm4PMqt9DC3g1Dio8NNV3wRPFvCeOQGIX2Zm4mkgGhCm7XoGiZuZJQSswhiZxm8RcgA/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K+Z83yY9; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715217103; x=1746753103;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=B9JeEIKGCcADmlV7K5aTdnLdvO5DeN0Kijfvke6PzeY=;
  b=K+Z83yY9E0VZnlKwS1k/26adFzEHmgN3pOk17IC7ZKJ5mKaUwPQhhIV+
   V5jE6XusMX4BDBf211a33vsYLVP2ZQPZi95m2dvses5W9gsQ9BXS9qSf4
   MSDqFZI9Zxey6zPlG7JtEXdBhinc6b1PPAt9xg9fSHTX7uYeYpyp/4pi4
   w6EKHBTkozVMTKQwDz6mUYCI6hBHktQ6KYGPB2PPBXARq98g5oW9x7MBN
   6Ux0n4WN9zgAT35uHp1HH03u2SMXv55m9CBMh6pKltsha+mqjkvYuWG7Q
   GNEGsy41PH446y0nE5wvCemYdm73egXW3GRyl5PGcxa9t2KsS5nIPzFnM
   Q==;
X-CSE-ConnectionGUID: w/ynlM97ROKLWxFQkIz0tg==
X-CSE-MsgGUID: jyw7jrIeSveA+AO6dSVzOw==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="22262775"
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="22262775"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 18:11:42 -0700
X-CSE-ConnectionGUID: i/PyEMwnSPa2/aqAzecbgQ==
X-CSE-MsgGUID: BaTVnR/TRTWwrvPKNNEZ2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="29126335"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 18:11:36 -0700
Message-ID: <7c17fd63-d3b1-4438-b6d8-11417321c56e@linux.intel.com>
Date: Thu, 9 May 2024 09:11:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 42/54] KVM: x86/pmu: Implement emulated counter
 increment for passthrough PMU
To: "Chen, Zide" <zide.chen@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-43-mizhang@google.com>
 <8da387e4-0c44-4402-8103-fc232600cb02@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <8da387e4-0c44-4402-8103-fc232600cb02@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/9/2024 2:28 AM, Chen, Zide wrote:
>
> On 5/5/2024 10:30 PM, Mingwei Zhang wrote:
>> @@ -896,6 +924,12 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
>>  		return;
>>  
>>  	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
>> +		if (is_passthrough)
>> +			is_pmc_allowed = pmc_speculative_in_use(pmc) &&
>> +					 check_pmu_event_filter(pmc);
>> +		else
>> +			is_pmc_allowed = pmc_event_is_allowed(pmc);
>> +
> Why don't need to check pmc_is_globally_enabled() in PMU passthrough
> case? Sorry if I missed something.

Not sure if it's because the historical reason. Since pmu->global_ctrl
would be updated in each vm-exit right now, we may not need to skip
pmc_is_globally_enabled() anymore. Need Mingwei to confirm.


