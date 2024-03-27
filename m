Return-Path: <kvm+bounces-12762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B25A88D6CA
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 07:44:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B97D1C25ACF
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 06:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 154FB22089;
	Wed, 27 Mar 2024 06:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M0F6D7d8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C974C9D;
	Wed, 27 Mar 2024 06:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711521841; cv=none; b=QLBXSn4I5D5KBipdk9qmvCOu9MSnYx2fu+D+3ED6hFOfPMtbMRo+pl/nySolvVN7/N4PJHbuUQcDMqD/4Ixvl+opZknm67l/99X5t4uVTgpcTMqRyExP3apUEgDyORAIMYRfE2kelqZVMJgAMfFN2aQAWCRHX88MbPSuxsXx43E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711521841; c=relaxed/simple;
	bh=gjxD+4XwapFfO+Ut0KmYydbgFTnH0aPydPXYf435b9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rdIbXgA9R4vIOAgpp4QqWrpA4UGOxJ0BOdERHHf8KuXBoGo7HHbA+wqaT930szkhJDdSZhlvWUE8Nbe1ncnUz/UKuKHqclPgo67op6zrXx2BHlFn3u5s64Liwu2/2t2uKijYPC4giaxWLGE0BtSKCmckXk6xGFlK8b9EalFzDvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M0F6D7d8; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711521840; x=1743057840;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gjxD+4XwapFfO+Ut0KmYydbgFTnH0aPydPXYf435b9o=;
  b=M0F6D7d8kfGuBzYatjKPF+uZ0rWCmkRjfEZSh6pj/Q6+NtSMqfLTetCk
   nUv2ZZ5rqkEoL5C+3BdntCN73H8phJANG8QRcGHpigYKLeaCoIzRnMQ9G
   bs+/PRN9yLNtoqnKkThFHVeW4eKL7sSzUBNq8ErvJMA0AV36USA3p55U/
   qxw7x8v7UVdADoIYvQo31Or9J0DNZpvOYjvi9Fq25zGRQdcc722GzqyDe
   7k5npCNdgZ0jPVzsfXAXYS1lB+JmYopXFxEQuTRi9/RTeYyhcIDgZdwIZ
   dFZz3BiyOhclqolBiQJtn5Ob0XWF+POTIwGKlJnBduGWMXnBiCC7rBhc+
   w==;
X-CSE-ConnectionGUID: pwNbSCW7Tt2t2El/7gYn0A==
X-CSE-MsgGUID: UN6wFzF2R0Oh1FN8W1q1dw==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="6735529"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="6735529"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 23:43:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="16577421"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.125.242.198]) ([10.125.242.198])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 23:43:56 -0700
Message-ID: <894d480c-5785-4896-bb79-9560611347cb@linux.intel.com>
Date: Wed, 27 Mar 2024 14:43:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch v3 03/11] x86: pmu: Add asserts to warn
 inconsistent fixed events and counters
Content-Language: en-US
To: Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong
 <xiong.y.zhang@intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-4-dapeng1.mi@linux.intel.com>
 <ZgOu5PP2qXhbflRc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZgOu5PP2qXhbflRc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/27/2024 1:30 PM, Mingwei Zhang wrote:
> On Wed, Jan 03, 2024, Dapeng Mi wrote:
>> Current PMU code deosn't check whether PMU fixed counter number is
>> larger than pre-defined fixed events. If so, it would cause memory
>> access out of range.
>>
>> So add assert to warn this invalid case.
>>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Reviewed-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>   x86/pmu.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index a13b8a8398c6..a42fff8d8b36 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -111,8 +111,12 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
>>   		for (i = 0; i < gp_events_size; i++)
>>   			if (gp_events[i].unit_sel == (cnt->config & 0xffff))
>>   				return &gp_events[i];
>> -	} else
>> -		return &fixed_events[cnt->ctr - MSR_CORE_PERF_FIXED_CTR0];
>> +	} else {
>> +		int idx = cnt->ctr - MSR_CORE_PERF_FIXED_CTR0;
> maybe unsigned int is better?

Make sense. Thanks for review.

>> +
>> +		assert(idx < ARRAY_SIZE(fixed_events));
>> +		return &fixed_events[idx];
>> +	}
>>   
>>   	return (void*)0;
>>   }
>> @@ -245,6 +249,7 @@ static void check_fixed_counters(void)
>>   	};
>>   	int i;
>>   
>> +	assert(pmu.nr_fixed_counters <= ARRAY_SIZE(fixed_events));
>>   	for (i = 0; i < pmu.nr_fixed_counters; i++) {
>>   		cnt.ctr = fixed_events[i].unit_sel;
>>   		measure_one(&cnt);
>> @@ -266,6 +271,7 @@ static void check_counters_many(void)
>>   			gp_events[i % gp_events_size].unit_sel;
>>   		n++;
>>   	}
>> +	assert(pmu.nr_fixed_counters <= ARRAY_SIZE(fixed_events));
>>   	for (i = 0; i < pmu.nr_fixed_counters; i++) {
>>   		cnt[n].ctr = fixed_events[i].unit_sel;
>>   		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR;
>> -- 
>> 2.34.1
>>

