Return-Path: <kvm+bounces-32122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEC7C9D3319
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 06:21:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20A962845DF
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 05:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 008C3156F39;
	Wed, 20 Nov 2024 05:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Smr0LESh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80E3168DA;
	Wed, 20 Nov 2024 05:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732080081; cv=none; b=P/Eyxm3JAnH4h5icRmAusHHD1D5IPuiqTBZYg9m1o/lxD5XWtrSMtCs9aQZLNx/f/e18XlOcJh7sW0s0BDngFo/fLSV7q8kRcQqrGTtcZWlbnZPThm/oWRbFhaTaqG4TYt2HRlW+dni3P9j8rL95ffVrXsm3+RwDKzPvL6lqNmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732080081; c=relaxed/simple;
	bh=9flpDgIPhd7BrW+eyLupmQ1fvsdcsHdWEsqpQGRfLeM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cQF4uwo6yvbxpK5BxzN5bY1/MAONx2UgykhE7sz5N44TXNTp3Pee0+4j1ODlfCwNTMyKoybIPYnoJELYkVMHTbU4MFOlv00aXzQWliUjBa8AsUWyesSpnacU2H7hsENWd50Nt/noAbongirswHMUrO/KQxwpJ0ncafT1K/qC6CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Smr0LESh; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732080079; x=1763616079;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9flpDgIPhd7BrW+eyLupmQ1fvsdcsHdWEsqpQGRfLeM=;
  b=Smr0LEShADUliWb34mIbEowar1+0tF50t0xOmPcQVQSc/HQRQ1kQ0tVo
   igJimG3SyA5R1sB9wfryB1avwObh7DJorvjSilzD19fgtMgV+gPU77hVc
   rodAOVvOzUkIsiuuLKv0hwTNX9WkvEnw+6y380OJuLLI8QyGHhloUmVrF
   CXj8vHZwnaTTtttXwO0aC+A+gGa6DwDfHTF9UqL3iVUegac1PTkbeOVSq
   aJq1OlBD6Hh6S1Tf4rGapz6AN3vZJOeccrrx66hvDsFmLEKR6zop6NQ1W
   8H8dUlAQkZhtVtfpHUdQjNwYLAhfzvxWI54UJfx5U8uoTvnDQtwbOFFYa
   A==;
X-CSE-ConnectionGUID: W6tqIWF6T3CtDyhv7QPg2A==
X-CSE-MsgGUID: G+jkEnv5Sz23YQtvTw00vQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="31977829"
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="31977829"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 21:21:19 -0800
X-CSE-ConnectionGUID: rH6jzUwERbGBwyxHaRwNuA==
X-CSE-MsgGUID: ePqZ1yB0R8KQRTbAQN03XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="89737919"
Received: from unknown (HELO [10.238.2.170]) ([10.238.2.170])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 21:21:15 -0800
Message-ID: <0fe5f985-4e8a-4599-9e47-9da833cfac9e@linux.intel.com>
Date: Wed, 20 Nov 2024 13:21:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 22/58] KVM: x86/pmu: Add host_perf_cap and
 initialize it in kvm_x86_vendor_init()
To: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang
 <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-23-mizhang@google.com> <ZzyyDC7nh_5XGaHa@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZzyyDC7nh_5XGaHa@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/19/2024 11:43 PM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 0c40f551130e..6db4dc496d2b 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -239,6 +239,9 @@ EXPORT_SYMBOL_GPL(host_xss);
>>  u64 __read_mostly host_arch_capabilities;
>>  EXPORT_SYMBOL_GPL(host_arch_capabilities);
>>  
>> +u64 __read_mostly host_perf_cap;
>> +EXPORT_SYMBOL_GPL(host_perf_cap);
> In case you don't get a conflict on rebase, this should go in "struct kvm_host_values"
> as "perf_capabilities".

Sure. Thanks.


>
>>  const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>>  	KVM_GENERIC_VM_STATS(),
>>  	STATS_DESC_COUNTER(VM, mmu_shadow_zapped),
>> @@ -9793,6 +9796,9 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>>  	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
>>  		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, host_arch_capabilities);
>>  
>> +	if (boot_cpu_has(X86_FEATURE_PDCM))
>> +		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
>> +
>>  	r = ops->hardware_setup();
>>  	if (r != 0)
>>  		goto out_mmu_exit;
>> -- 
>> 2.46.0.rc1.232.g9752f9e123-goog
>>

