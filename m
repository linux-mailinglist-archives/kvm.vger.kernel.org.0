Return-Path: <kvm+bounces-14388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D62C8A2617
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:03:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EBB51C22DA7
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 06:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 659C6200D4;
	Fri, 12 Apr 2024 06:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kt+UOFr4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDE42C853;
	Fri, 12 Apr 2024 06:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712901794; cv=none; b=kqOOABwmEN4Kk09lH+CGA+Tv1r2y3H7Lsgx2QnnyccR6EStxAs/QkdGO9gAQoZqwzZoyhlx7sNaMj99q+5V5kYPD+19AosjpLE2L+jkFxaKInssLScQ87NZ+rO+MeeyfL92YTq6G+R7BV7H796xvpnQx/wc8FnusOSCgVfLDnWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712901794; c=relaxed/simple;
	bh=Pam1GGFHhZowHw2vCwE7Sonxu+8AJ5i7jefiUaNUqJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kbnnDtc0hHxoewm7hCz2aB+zHat9zab5c12o1s8gCfUAbqEbYQo2pTcYpI1VZgMPJxrbckHINhPtxPZ5lw1G9iXUpJXtmF47lvamBComs4O6z9VBkf0GOltdXT6jKl5mCMJ1rfsQueaqKE4XOOm+Gv9us91YgqFarieW+IKi9EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kt+UOFr4; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712901792; x=1744437792;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Pam1GGFHhZowHw2vCwE7Sonxu+8AJ5i7jefiUaNUqJg=;
  b=kt+UOFr4r9LbENZm46Jf/pUO+LEmnc0+LN6T5G/IypgtzIJda5WP6dMX
   LZGPIr92cPoZaBQApZWiwktmJ64HdvelHcc4v90oUdTvbtuImefL+LY1T
   UGuxPSRBTyZJkvC2EZ2SAa6uKNFAkiU0c6XL1QAFtXwqggC1M0Q5aL09H
   2bkvNHfacWxThjHqIPkVVPOeopdHUCsnc3WCANRCOEqYHB4EMNa7wvlPb
   G+De5iBDDzH2SH0FBpQGpzryrVzRNWaWJJdSWv9bxPDbLAHKqzdjRivQF
   PU8+9ramYkoGmVUc14QJgsusR72/SWPhwEgMRA6hum3DbCOH36cuQ/7x8
   A==;
X-CSE-ConnectionGUID: goCbicWATteKyIkEgBirAQ==
X-CSE-MsgGUID: 1Rq/7vS2RleKecJmAc3jmw==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="12198053"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="12198053"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 23:03:12 -0700
X-CSE-ConnectionGUID: ECa57ormQ4CcC5eP0sbrnw==
X-CSE-MsgGUID: KMUUNdRCQZm6KYIzr+9rbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="52300920"
Received: from xiongzha-mobl1.ccr.corp.intel.com (HELO [10.124.244.162]) ([10.124.244.162])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 23:03:07 -0700
Message-ID: <57dba444-5cb9-4128-8a16-a6924f6f2e67@linux.intel.com>
Date: Fri, 12 Apr 2024 14:03:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 06/41] perf: x86: Add function to switch PMI handler
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com,
 kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-7-xiong.y.zhang@linux.intel.com>
 <Zhg3X_5A6BslIg-u@google.com> <Zhg7NO9jHsh5rfGa@google.com>
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <Zhg7NO9jHsh5rfGa@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/12/2024 3:34 AM, Sean Christopherson wrote:
> On Thu, Apr 11, 2024, Sean Christopherson wrote:
>> On Fri, Jan 26, 2024, Xiong Zhang wrote:
>>> From: Xiong Zhang <xiong.y.zhang@intel.com>
>>>
>>> Add function to switch PMI handler since passthrough PMU and host PMU will
>>> use different interrupt vectors.
>>>
>>> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
>>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>>> ---
>>>  arch/x86/events/core.c            | 15 +++++++++++++++
>>>  arch/x86/include/asm/perf_event.h |  3 +++
>>>  2 files changed, 18 insertions(+)
>>>
>>> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
>>> index 40ad1425ffa2..3f87894d8c8e 100644
>>> --- a/arch/x86/events/core.c
>>> +++ b/arch/x86/events/core.c
>>> @@ -701,6 +701,21 @@ struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
>>>  }
>>>  EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
>>>  
>>> +void perf_guest_switch_to_host_pmi_vector(void)
>>> +{
>>> +	lockdep_assert_irqs_disabled();
>>> +
>>> +	apic_write(APIC_LVTPC, APIC_DM_NMI);
>>> +}
>>> +EXPORT_SYMBOL_GPL(perf_guest_switch_to_host_pmi_vector);
>>> +
>>> +void perf_guest_switch_to_kvm_pmi_vector(void)
>>> +{
>>> +	lockdep_assert_irqs_disabled();
>>> +
>>> +	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_VPMU_VECTOR);
>>> +}
>>> +EXPORT_SYMBOL_GPL(perf_guest_switch_to_kvm_pmi_vector);
>>
>> Why slice and dice the context switch if it's all in perf?  Just do this in
>> perf_guest_enter().  
> 
> Ah, because perf_guest_enter() isn't x86-specific.
> 
> That can be solved by having the exported APIs be arch specific, e.g.
> x86_perf_guest_enter(), and making perf_guest_enter() a perf-internal API.
> 
> That has the advantage of making it impossible to call perf_guest_enter() on an
> unsupported architecture (modulo perf bugs).
> 
Make sense. I will try it.

thanks

