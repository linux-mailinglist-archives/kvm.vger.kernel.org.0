Return-Path: <kvm+bounces-14387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ADBE8A260E
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 07:58:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 465DD28819B
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 05:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42A392C184;
	Fri, 12 Apr 2024 05:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F1C7VCAu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54691DDDB;
	Fri, 12 Apr 2024 05:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712901477; cv=none; b=cpvl+vDNIeuWcy8Pr58/HEw0BVzVPgPe0qDtk4zajgsH/BaLB8OlGVsozS3dQRJoLOW+m7q45LC0HfeLL37cxcGQxSy9A1xSDe0GVld0o4baPbdrrje3i2rzogfbz6lQYG/CFk97ANs9j+FWkU5+SIvo690h8jFMYKk2NsofKck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712901477; c=relaxed/simple;
	bh=G8hY+FjLTfuIVDy57N/LtDBhn3ksctV6ZZ1Ygu0usZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bAyLvjS6wZs5X4bVJP7scr8yBXUC0q/E6dswUN56VR9v/5oP495nYHyqGl0HR2USl9Dg3aSuTlfhZ4DBn2vLvtkSrC/TSYGo7Q5pGlT0MztjiYQ1caNyFx2oH14BQ7vxacExgPjXSpGzEnAwGAfsjkgr6oTc8IAxg/Sxuy92zo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F1C7VCAu; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712901476; x=1744437476;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=G8hY+FjLTfuIVDy57N/LtDBhn3ksctV6ZZ1Ygu0usZ8=;
  b=F1C7VCAubQQsab5goh3xq6S7Bu+5YTBCQLs10oQWTUNqOOeF5/8sczwa
   peFNL7N2XO+QcpPu4CWfipJPdrDclVwFSdQqiojAGhDmGvdYHyq2sSQ46
   BzLDkMAnk9Dq6zflhEYnHxJlNQxm84AXQMwmaX1wTyAfC9+6G4h+jZYVV
   6eWBfvUShzwafdHWLsTag5772oW1OHn8i9l3pqRkhltYMiU88ZcxJqDxw
   n39U37icRo3fFD+wl1TTS3EJgMItqv60OmV8j5cS0zuD79+/oHXx9qhBw
   jJm4C5MgHiAPwJ8z/ksnMfK3luN6uFyO77j04RIALZM56LD7fyHtncag7
   w==;
X-CSE-ConnectionGUID: gNngCGD/R2KaO1nj2A1zVw==
X-CSE-MsgGUID: D2jLTxB3SM6YanerxoLrgA==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="12197661"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="12197661"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 22:57:56 -0700
X-CSE-ConnectionGUID: 1KuqrSs2RDat7Er/1WVpHg==
X-CSE-MsgGUID: 8iIV9R12Si+eflAuqF5r4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="52299881"
Received: from xiongzha-mobl1.ccr.corp.intel.com (HELO [10.124.244.162]) ([10.124.244.162])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 22:57:50 -0700
Message-ID: <41c6af10-82f8-4e67-9d55-6034ad079418@linux.intel.com>
Date: Fri, 12 Apr 2024 13:57:47 +0800
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
 <Zhg3X_5A6BslIg-u@google.com>
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <Zhg3X_5A6BslIg-u@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/12/2024 3:17 AM, Sean Christopherson wrote:
> On Fri, Jan 26, 2024, Xiong Zhang wrote:
>> From: Xiong Zhang <xiong.y.zhang@intel.com>
>>
>> Add function to switch PMI handler since passthrough PMU and host PMU will
>> use different interrupt vectors.
>>
>> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>  arch/x86/events/core.c            | 15 +++++++++++++++
>>  arch/x86/include/asm/perf_event.h |  3 +++
>>  2 files changed, 18 insertions(+)
>>
>> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
>> index 40ad1425ffa2..3f87894d8c8e 100644
>> --- a/arch/x86/events/core.c
>> +++ b/arch/x86/events/core.c
>> @@ -701,6 +701,21 @@ struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
>>  }
>>  EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
>>  
>> +void perf_guest_switch_to_host_pmi_vector(void)
>> +{
>> +	lockdep_assert_irqs_disabled();
>> +
>> +	apic_write(APIC_LVTPC, APIC_DM_NMI);
>> +}
>> +EXPORT_SYMBOL_GPL(perf_guest_switch_to_host_pmi_vector);
>> +
>> +void perf_guest_switch_to_kvm_pmi_vector(void)
>> +{
>> +	lockdep_assert_irqs_disabled();
>> +
>> +	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_VPMU_VECTOR);
>> +}
>> +EXPORT_SYMBOL_GPL(perf_guest_switch_to_kvm_pmi_vector);
> 
> Why slice and dice the context switch if it's all in perf?  Just do this in
> perf_guest_enter().  
> 
As perf_guest_enter() is in perf core which manages all PMUs, while switch_pmi_vector is for x86 core PMU only, so switch_pmi_vector is put in x86 pmu driver. pmu driver can call perf core function directly, perf core manage pmu through pmu->ops and pmu->flags. If switch_pmi_vector is called in perf_guest_enter, extra interfaces will be added into pmu->ops, this impacts other PMU driver. 

