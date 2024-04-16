Return-Path: <kvm+bounces-14765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37FCB8A6B6E
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:48:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2EDC281CA0
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 12:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52FFB12BF21;
	Tue, 16 Apr 2024 12:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mEevrMEh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35DA6BFDD;
	Tue, 16 Apr 2024 12:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713271704; cv=none; b=jExF1Vwfoj+TyMxJy05O2TzHFzyWYx4ndKVyjmO9fHYsthfyhQ9YAjG0OB+ZvhIMajAwhxJnmv5EZBO9UIKp3kNFLLW66+WtlI3vXH2vvY0AhG+cCmgDjkS+4nu8RL71wllRPzZ8rhxo6a6MaGfy4OxTX8IldISDOlLWaEpflbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713271704; c=relaxed/simple;
	bh=icMcUvf31+/80gYgujfIto6pSPFOvMmLnaKaozMWjL0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g/dwNlF2K40aHdrfNVpV6B5CREBVPl0G4fB/kXl6bbWXqPC6tmpXGB6oIVa1SJAhtLjcNgTIQKb8PJ9zgWpNgzYBOT0BhIf4Y+J0xuL1FmYlogqBQMUHFnjd52Gt+3pCGN+7HFFngbOYHaxwuQ8pucxxjTWAb6qJt2+LlV5rYiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mEevrMEh; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713271703; x=1744807703;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=icMcUvf31+/80gYgujfIto6pSPFOvMmLnaKaozMWjL0=;
  b=mEevrMEhp9sL464IgUXAl0mbgwwYRONwkysp5hfOB5YkF4ox6qpQkP+h
   VrjFWUAgNEQhmcWnrZIxTiNzZGxLKQQa/DUGFdVVLuEeiYuKiCcpxoiKC
   hDYb5SafMLQaWq3oZmcKxpQKf9YgXVICrPXtnsLxS8yf/cDUHCQKC2rVJ
   vOuxW5kemi+2bR58tb8JpvaTMTaAArhpOEAQEJTileZFOobfuUQ4TOEkO
   Gg5WxdC0CDoh1QSfQ32Gwuv7+fste62kjmT1IY4hSsRKBcpz843kQ2L7c
   jQiSTO+gKIjm0sgINIfqmx9+j/e17baa5P2SKgTUoyP85yW8C/4eK47Lj
   g==;
X-CSE-ConnectionGUID: MmuzrKozSzCqYV5UULhT8g==
X-CSE-MsgGUID: 7+/QCdGKS+KLiF/JHOPETQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19309077"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="19309077"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 05:48:22 -0700
X-CSE-ConnectionGUID: mNaG9A7FTq+gt5+eM4DuKQ==
X-CSE-MsgGUID: fF1WUH3iTo29H0/k4xAE1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="59699656"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 05:48:22 -0700
Received: from [10.213.186.145] (kliang2-mobl1.ccr.corp.intel.com [10.213.186.145])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id B488C206DFDC;
	Tue, 16 Apr 2024 05:48:19 -0700 (PDT)
Message-ID: <eca7cdb9-6c8d-4d2e-8ac6-b87ea47a1bac@linux.intel.com>
Date: Tue, 16 Apr 2024 08:48:18 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/41] perf: Support guest enter/exit interfaces
To: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com,
 kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-3-xiong.y.zhang@linux.intel.com>
 <ZhgmrczGpccfU-cI@google.com>
 <23af8648-ca9f-41d2-8782-f2ffc3c11e9e@linux.intel.com>
 <ZhmIrQQVgblrhCZs@google.com>
 <2342a4e2-2834-48e2-8403-f0050481e59e@linux.intel.com>
 <ab2953b7-18fd-4b4c-a83b-ab243e2a21e1@linux.intel.com>
 <998fd76f-2bd9-4492-bf2e-e8cd981df67f@linux.intel.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <998fd76f-2bd9-4492-bf2e-e8cd981df67f@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-04-16 1:34 a.m., Zhang, Xiong Y wrote:
> 
> 
> On 4/16/2024 12:03 AM, Liang, Kan wrote:
>>
>>
>> On 2024-04-12 4:56 p.m., Liang, Kan wrote:
>>>> What if perf had a global knob to enable/disable mediate PMU support?  Then when
>>>> KVM is loaded with enable_mediated_true, call into perf to (a) check that there
>>>> are no existing !exclude_guest events (this part could be optional), and (b) set
>>>> the global knob to reject all new !exclude_guest events (for the core PMU?).
>>>>
>>>> Hmm, or probably better, do it at VM creation.  That has the advantage of playing
>>>> nice with CONFIG_KVM=y (perf could reject the enabling without completely breaking
>>>> KVM), and not causing problems if KVM is auto-probed but the user doesn't actually
>>>> want to run VMs.
>>> I think it should be doable, and may simplify the perf implementation.
>>> (The check in the schedule stage should not be necessary anymore.)
>>>
>>> With this, something like NMI watchdog should fail the VM creation. The
>>> user should either disable the NMI watchdog or use a replacement.
>>>
>>> Thanks,
>>> Kan
>>>> E.g. (very roughly)
>>>>
>>>> int x86_perf_get_mediated_pmu(void)
>>>> {
>>>> 	if (refcount_inc_not_zero(...))
>>>> 		return 0;
>>>>
>>>> 	if (<system wide events>)
>>>> 		return -EBUSY;
>>>>
>>>> 	<slow path with locking>
>>>> }
>>>>
>>>> void x86_perf_put_mediated_pmu(void)
>>>> {
>>>> 	if (!refcount_dec_and_test(...))
>>>> 		return;
>>>>
>>>> 	<slow path with locking>
>>>> }
>>
>>
>> I think the locking should include the refcount check and system wide
>> event check as well.
>> It should be possible that two VMs are created very close.
>> The second creation may mistakenly return 0 if there is no lock.
>>
>> I plan to do something as below (not test yet).
>>
>> +/*
>> + * Currently invoked at VM creation to
>> + * - Check whether there are existing !exclude_guest system wide events
>> + *   of PMU with PERF_PMU_CAP_MEDIATED_VPMU
>> + * - Set nr_mediated_pmu to prevent !exclude_guest event creation on
>> + *   PMUs with PERF_PMU_CAP_MEDIATED_VPMU
>> + *
>> + * No impact for the PMU without PERF_PMU_CAP_MEDIATED_VPMU. The perf
>> + * still owns all the PMU resources.
>> + */
>> +int x86_perf_get_mediated_pmu(void)
>> +{
>> +	int ret = 0;
>> +	mutex_lock(&perf_mediated_pmu_mutex);
>> +	if (refcount_inc_not_zero(&nr_mediated_pmu_vms))
>> +		goto end;
>> +
>> +	if (atomic_read(&nr_include_guest_events)) {
>> +		ret = -EBUSY;
>> +		goto end;
>> +	}
>> +	refcount_inc(&nr_mediated_pmu_vms);
>> +end:
>> +	mutex_unlock(&perf_mediated_pmu_mutex);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(x86_perf_get_mediated_pmu);
>> +
>> +void x86_perf_put_mediated_pmu(void)
>> +{
>> +	mutex_lock(&perf_mediated_pmu_mutex);
>> +	refcount_dec(&nr_mediated_pmu_vms);
>> +	mutex_unlock(&perf_mediated_pmu_mutex);
>> +}
>> +EXPORT_SYMBOL_GPL(x86_perf_put_mediated_pmu);
>>
>>
>> Thanks,
>> Kan
> x86_perf_get_mediated_pmu() is called at vm_create(), x86_perf_put_mediated_pmu() is called at vm_destroy(), then system wide perf events without exclude_guest=1 can not be created during the whole vm life cycle (where nr_mediated_pmu_vms > 0 always), do I understand and use the interface correctly ?

Right, but it only impacts the events of PMU with the
PERF_PMU_CAP_MEDIATED_VPMU.
For other PMUs, the event with exclude_guest=1 can still be created.
KVM should not touch the counters of the PMU without
PERF_PMU_CAP_MEDIATED_VPMU.

BTW: I will also remove the prefix x86, since the functions are in the
generic code.

Thanks,
Kan

