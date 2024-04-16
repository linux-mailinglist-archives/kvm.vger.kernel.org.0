Return-Path: <kvm+bounces-14725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7AD48A6307
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 07:34:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69003286BA9
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 05:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 081313B7AC;
	Tue, 16 Apr 2024 05:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D9V+0Cju"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850CE11720;
	Tue, 16 Apr 2024 05:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713245670; cv=none; b=Lg8yP7AFt/yrXcoYyopi95R+x65UTd7CiyXcHewwlGr5WfxZt7JAtc2cx14fQTKabmwta1KhuloI8WNyvk6Z76BsvBw/CxIYMcd+Is5rDxutkVhUQFRArhiVKVh6p3XyGJLFLEMx4rdKdlCoxaECli8xKNKgAGwz/ilYxrC8wv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713245670; c=relaxed/simple;
	bh=kzqpX5pisSA0RMcIWuJDckngNn3ETsX1+xRIIt6hxSc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bi5br6OilCfjXEjWccH8Exvt/jBS1TXhDEglUj8d1te733uSNJeAPSK1N4SMHva6jOe6c0IBZwLihmro75WqewEgV037Xe7XjmYKrH0fhQm53cy3j0BuKDFow69Yw+p+EY2BnR4FkCSO2Wq8R5loLjjAOpWhmCww47R1P/91lPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D9V+0Cju; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713245669; x=1744781669;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kzqpX5pisSA0RMcIWuJDckngNn3ETsX1+xRIIt6hxSc=;
  b=D9V+0CjuqeXOwW7abvZlf0HPAiiYlG+Gn1mkYkrTOUyTs0c3A+lTmE6f
   hCSFQxRP18YSjYcWuz1fGN+6BMzW43tM+OYoj6S61qa4tEFfG6IvhTei1
   uCDrpV8ypYpxQ+BVh9kE3EM9rb1j1+7j6ioeZbeUcTdJ/YrYfQi/1Tp9y
   CzryJfrRe9VCxKMFuzJRcWweKN/Ym8Snmgqui3IrU+ltKcr409zXqxZTT
   LUATMqo8sKYIE8qpxBT73KozrYBDc950F/stpeQVGLP2j2S6QTLpVYU72
   5tXezf4KFMOW54SREmZffzbDbP2jr4VbKZbjwDgW9pP/auFC8q31Lgf6m
   Q==;
X-CSE-ConnectionGUID: bp11ffVLSp6Flp61qhPF4Q==
X-CSE-MsgGUID: mL9wRkw/T5GxEaXu1OJ0zA==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="9217857"
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="9217857"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 22:34:27 -0700
X-CSE-ConnectionGUID: m6n7iNoyThqdyNYIr9nF7A==
X-CSE-MsgGUID: IV4WrLTeRgaMvvY208Uxrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="22615794"
Received: from unknown (HELO [10.238.128.139]) ([10.238.128.139])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 22:34:23 -0700
Message-ID: <998fd76f-2bd9-4492-bf2e-e8cd981df67f@linux.intel.com>
Date: Tue, 16 Apr 2024 13:34:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/41] perf: Support guest enter/exit interfaces
To: "Liang, Kan" <kan.liang@linux.intel.com>,
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
Content-Language: en-US
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <ab2953b7-18fd-4b4c-a83b-ab243e2a21e1@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/16/2024 12:03 AM, Liang, Kan wrote:
> 
> 
> On 2024-04-12 4:56 p.m., Liang, Kan wrote:
>>> What if perf had a global knob to enable/disable mediate PMU support?  Then when
>>> KVM is loaded with enable_mediated_true, call into perf to (a) check that there
>>> are no existing !exclude_guest events (this part could be optional), and (b) set
>>> the global knob to reject all new !exclude_guest events (for the core PMU?).
>>>
>>> Hmm, or probably better, do it at VM creation.  That has the advantage of playing
>>> nice with CONFIG_KVM=y (perf could reject the enabling without completely breaking
>>> KVM), and not causing problems if KVM is auto-probed but the user doesn't actually
>>> want to run VMs.
>> I think it should be doable, and may simplify the perf implementation.
>> (The check in the schedule stage should not be necessary anymore.)
>>
>> With this, something like NMI watchdog should fail the VM creation. The
>> user should either disable the NMI watchdog or use a replacement.
>>
>> Thanks,
>> Kan
>>> E.g. (very roughly)
>>>
>>> int x86_perf_get_mediated_pmu(void)
>>> {
>>> 	if (refcount_inc_not_zero(...))
>>> 		return 0;
>>>
>>> 	if (<system wide events>)
>>> 		return -EBUSY;
>>>
>>> 	<slow path with locking>
>>> }
>>>
>>> void x86_perf_put_mediated_pmu(void)
>>> {
>>> 	if (!refcount_dec_and_test(...))
>>> 		return;
>>>
>>> 	<slow path with locking>
>>> }
> 
> 
> I think the locking should include the refcount check and system wide
> event check as well.
> It should be possible that two VMs are created very close.
> The second creation may mistakenly return 0 if there is no lock.
> 
> I plan to do something as below (not test yet).
> 
> +/*
> + * Currently invoked at VM creation to
> + * - Check whether there are existing !exclude_guest system wide events
> + *   of PMU with PERF_PMU_CAP_MEDIATED_VPMU
> + * - Set nr_mediated_pmu to prevent !exclude_guest event creation on
> + *   PMUs with PERF_PMU_CAP_MEDIATED_VPMU
> + *
> + * No impact for the PMU without PERF_PMU_CAP_MEDIATED_VPMU. The perf
> + * still owns all the PMU resources.
> + */
> +int x86_perf_get_mediated_pmu(void)
> +{
> +	int ret = 0;
> +	mutex_lock(&perf_mediated_pmu_mutex);
> +	if (refcount_inc_not_zero(&nr_mediated_pmu_vms))
> +		goto end;
> +
> +	if (atomic_read(&nr_include_guest_events)) {
> +		ret = -EBUSY;
> +		goto end;
> +	}
> +	refcount_inc(&nr_mediated_pmu_vms);
> +end:
> +	mutex_unlock(&perf_mediated_pmu_mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(x86_perf_get_mediated_pmu);
> +
> +void x86_perf_put_mediated_pmu(void)
> +{
> +	mutex_lock(&perf_mediated_pmu_mutex);
> +	refcount_dec(&nr_mediated_pmu_vms);
> +	mutex_unlock(&perf_mediated_pmu_mutex);
> +}
> +EXPORT_SYMBOL_GPL(x86_perf_put_mediated_pmu);
> 
> 
> Thanks,
> Kan
x86_perf_get_mediated_pmu() is called at vm_create(), x86_perf_put_mediated_pmu() is called at vm_destroy(), then system wide perf events without exclude_guest=1 can not be created during the whole vm life cycle (where nr_mediated_pmu_vms > 0 always), do I understand and use the interface correctly ?

thanks

