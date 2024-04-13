Return-Path: <kvm+bounces-14594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B8F98A3AFE
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 06:13:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 747421F23829
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 04:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7BD21C6A0;
	Sat, 13 Apr 2024 04:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="afRqM0fW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4898E4C65;
	Sat, 13 Apr 2024 04:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712981588; cv=none; b=BASXKdJAgBX7gPZUS/YvvJ+nSmdijUIdlz/GLG4CopRBj5Rb5FcwGfbNNca6me1TytHW4vGicx3ahVnP/gGzyVFlgQcr2nenbnzKTYqKR3Hu8OioqlPK+yktQHFFyaN8ioMAzMNSSMd1cD8ZLH0/u7ihYcoqyQIRpypD8VXnLls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712981588; c=relaxed/simple;
	bh=P0ICQc6p95hpk0kk9xF4xUigjuVNicJgP60eXiKynkY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sqM1EnMixZ+XrfHSHFLiXooBArjKLlbKBRhqB8ORx1lU3q9axn34tFu/NiZ9brWmWH61VUm0ccy9DLhD2Q29yJGEiksL8RbMAcB1/wMwNl7wcy/MgK7ROnB1WXzvJSot78pYKwmKuJHquHuvR9trGLzLcIXhFHMOp/+4jpk9Yrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=afRqM0fW; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712981587; x=1744517587;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=P0ICQc6p95hpk0kk9xF4xUigjuVNicJgP60eXiKynkY=;
  b=afRqM0fWsJQgmi5Oy1As1em3bC16MChi20KdSZUkjKRH34Ft69AGkq71
   N4aRZR4la0RoBBSP+w3sDWwYdNt4dJWKYGMT+HhYXZAiRi5+tOD2EtyiA
   ky2x4ii8fBKWedy8SUNZDZH7n4OglrYq4DBbMcAlVbFDHOFQI5cAiBsmj
   SVElpc1NDOmJgQrNMv5oCtDd8R7/GnwRJwS9rMvoLCy7b505YwPFWOTZR
   GDFjYDLhERLt60PGWSD+4jKobw2hdfAVnElMHfFlU2+qN6qXrUPVHyUUj
   9D4nDfarxt4qt12rNOEVpUnlsE6YgCt1aTqsJBwdmcxzXJm2+98EX0jCh
   Q==;
X-CSE-ConnectionGUID: bSnRlzrNQb6rs5D7yJqWVw==
X-CSE-MsgGUID: 8TgulaYtReOCQPgX8V/BWw==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="19867301"
X-IronPort-AV: E=Sophos;i="6.07,198,1708416000"; 
   d="scan'208";a="19867301"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 21:13:06 -0700
X-CSE-ConnectionGUID: Psw8T3LDSSWfdBZZA4W4yw==
X-CSE-MsgGUID: 2ienEDwhR0+oRB6avL5SMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,198,1708416000"; 
   d="scan'208";a="26213713"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 21:13:01 -0700
Message-ID: <e0fe15f6-993c-45ec-aea2-531a055fb0cd@linux.intel.com>
Date: Sat, 13 Apr 2024 12:12:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 37/41] KVM: x86/pmu: Allow writing to fixed counter
 selector if counter is exposed
To: Sean Christopherson <seanjc@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com,
 kan.liang@intel.com, zhenyuw@linux.intel.com, jmattson@google.com,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-38-xiong.y.zhang@linux.intel.com>
 <ZhheJUWRhCmmYa_F@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZhheJUWRhCmmYa_F@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/12/2024 6:03 AM, Sean Christopherson wrote:
> On Fri, Jan 26, 2024, Xiong Zhang wrote:
>> From: Mingwei Zhang <mizhang@google.com>
>>
>> Allow writing to fixed counter selector if counter is exposed. If this
>> fixed counter is filtered out, this counter won't be enabled on HW.
>>
>> Passthrough PMU implements the context switch at VM Enter/Exit boundary the
>> guest value cannot be directly written to HW since the HW PMU is owned by
>> the host. Introduce a new field fixed_ctr_ctrl_hw in kvm_pmu to cache the
>> guest value.  which will be assigne to HW at PMU context restore.
>>
>> Since passthrough PMU intercept writes to fixed counter selector, there is
>> no need to read the value at pmu context save, but still clear the fix
>> counter ctrl MSR and counters when switching out to host PMU.
>>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |  1 +
>>   arch/x86/kvm/vmx/pmu_intel.c    | 28 ++++++++++++++++++++++++----
>>   2 files changed, 25 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index fd1c69371dbf..b02688ed74f7 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -527,6 +527,7 @@ struct kvm_pmu {
>>   	unsigned nr_arch_fixed_counters;
>>   	unsigned available_event_types;
>>   	u64 fixed_ctr_ctrl;
>> +	u64 fixed_ctr_ctrl_hw;
>>   	u64 fixed_ctr_ctrl_mask;
> Before introduce more fields, can someone please send a patch/series to rename
> the _mask fields?  AFAIK, they all should be e.g. fixed_ctr_ctrl_rsvd, or something
> to that effect.

Yeah, I remember I ever said to cook a patch to rename all these _mask 
fields. I would do it now.


>
> Because I think we should avoid reinventing the naming wheel, and use "shadow"
> instead of "hw", because KVM developers already know what "shadow" means.  But
> "mask" also has very specific meaning for shadowed fields.  That, and "mask" is
> a freaking awful name in the first place.
>
>>   	u64 global_ctrl;
>>   	u64 global_status;
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 713c2a7c7f07..93cfb86c1292 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -68,6 +68,25 @@ static int fixed_pmc_events[] = {
>>   	[2] = PSEUDO_ARCH_REFERENCE_CYCLES,
>>   };
>>   
>> +static void reprogram_fixed_counters_in_passthrough_pmu(struct kvm_pmu *pmu, u64 data)
> We need to come up with shorter names, this ain't Java.  :-)  Heh, that can be
> another argument for "mediated", it saves three characters.
>
> And somewhat related, kernel style is <scope>_<blah>, i.e.
>
> static void mediated_pmu_reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)

