Return-Path: <kvm+bounces-29762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A48D59B1D9A
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 13:06:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64305281C5C
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 12:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B072D154BED;
	Sun, 27 Oct 2024 12:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jz31HBDS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740FE7DA67;
	Sun, 27 Oct 2024 12:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730030804; cv=none; b=VJZIs4PUplWeXoWtivSPWqGJmSm3+1M8ZxILPo6nXkM+C7JsV+tDLBKUtZZaBoqaUWgeMLynM0Cek58ji2XzqK2uemcg8soVMrRTbPKzjpP90WPy1YBo8QqHNTxTFaIbOwchW9SXHPMWjHbapM6c+EZSJQil9u47v2aHi08C/XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730030804; c=relaxed/simple;
	bh=iHfvyFI5jiAmSBtDrE4mKuQ2KDG8G0iL340AzkPpyL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=acxUGUHiejH+97RbBi9UlgRLF8lfdyvsfA0OXRpQy56paJoDhz223uoznU1FWhq4y0FkzB/mi6E9r+0JxW7gbjSePpTwhYxc0Y4QKXyj9G5io6+bucXGpTYxqFnt41ZfPP6RZBDqx4BWVIOt35hVSm5u6ioBs/6/P28jr4T3UDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jz31HBDS; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730030802; x=1761566802;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iHfvyFI5jiAmSBtDrE4mKuQ2KDG8G0iL340AzkPpyL8=;
  b=Jz31HBDSlRLm3dmo6DldqppXEeGNzev/4lqulTjrI8m/IvufQjMmGRbL
   VzZnIodV9S5+IWtYbOZ+JNARUIZaNb+pVlBY5InnRs7E2Uje11lAOBEvh
   4BjMDYVrGAtQiCYv/Xi5iYk3ZQahVEwfuUrZl7UK6IQ49FW7q94wTBJlL
   BKGBzKzYmOkXKvksRb57B1PNBGySIy/b64PLxga+1Tb02hmuXOsPpE/q7
   NCjltK2GJFrNz14fH42STE1/vIbVtg1yDC5jZX/RLfL9r9zUGfwwVDANI
   n+3uYPz/gg87sZHZSeKFerNv8Ro22t+/YTrItbqFVQAQtmm4OqnzZRt9S
   A==;
X-CSE-ConnectionGUID: fxvnWf0nTvSw9RT9+r8ElQ==
X-CSE-MsgGUID: 2V56TaUXSVug5yIlyZaLRw==
X-IronPort-AV: E=McAfee;i="6700,10204,11237"; a="29103280"
X-IronPort-AV: E=Sophos;i="6.11,237,1725346800"; 
   d="scan'208";a="29103280"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2024 05:06:40 -0700
X-CSE-ConnectionGUID: LneXGWtqSx+D02z9FVwWrw==
X-CSE-MsgGUID: X6TwckngTi2QKLPhln6agg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,237,1725346800"; 
   d="scan'208";a="81803930"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.125.240.3]) ([10.125.240.3])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2024 05:06:35 -0700
Message-ID: <7295b12c-c780-4457-8895-cc554d5b597a@linux.intel.com>
Date: Sun, 27 Oct 2024 20:06:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 43/58] KVM: x86/pmu: Introduce PMU operator for
 setting counter overflow
To: "Chen, Zide" <zide.chen@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-44-mizhang@google.com>
 <d0d8a945-1623-448a-b08a-8877464a4531@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <d0d8a945-1623-448a-b08a-8877464a4531@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 10/26/2024 12:16 AM, Chen, Zide wrote:
>
> On 7/31/2024 9:58 PM, Mingwei Zhang wrote:
>> Introduce PMU operator for setting counter overflow. When emulating counter
>> increment, multiple counters could overflow at the same time, i.e., during
>> the execution of the same instruction. In passthrough PMU, having an PMU
>> operator provides convenience to update the PMU global status in one shot
>> with details hidden behind the vendor specific implementation.
> Since neither Intel nor AMD does implement this API, this patch should
> be dropped.

oh, yes.


>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>  arch/x86/include/asm/kvm-x86-pmu-ops.h | 1 +
>>  arch/x86/kvm/pmu.h                     | 1 +
>>  arch/x86/kvm/vmx/pmu_intel.c           | 5 +++++
>>  3 files changed, 7 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
>> index 72ca78df8d2b..bd5b118a5ce5 100644
>> --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
>> +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
>> @@ -28,6 +28,7 @@ KVM_X86_PMU_OP_OPTIONAL(passthrough_pmu_msrs)
>>  KVM_X86_PMU_OP_OPTIONAL(save_pmu_context)
>>  KVM_X86_PMU_OP_OPTIONAL(restore_pmu_context)
>>  KVM_X86_PMU_OP_OPTIONAL(incr_counter)
>> +KVM_X86_PMU_OP_OPTIONAL(set_overflow)
>>  
>>  #undef KVM_X86_PMU_OP
>>  #undef KVM_X86_PMU_OP_OPTIONAL
>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>> index 325f17673a00..78a7f0c5f3ba 100644
>> --- a/arch/x86/kvm/pmu.h
>> +++ b/arch/x86/kvm/pmu.h
>> @@ -45,6 +45,7 @@ struct kvm_pmu_ops {
>>  	void (*save_pmu_context)(struct kvm_vcpu *vcpu);
>>  	void (*restore_pmu_context)(struct kvm_vcpu *vcpu);
>>  	bool (*incr_counter)(struct kvm_pmc *pmc);
>> +	void (*set_overflow)(struct kvm_vcpu *vcpu);
>>  
>>  	const u64 EVENTSEL_EVENT;
>>  	const int MAX_NR_GP_COUNTERS;
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 42af2404bdb9..2d46c911f0b7 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -881,6 +881,10 @@ static void intel_restore_guest_pmu_context(struct kvm_vcpu *vcpu)
>>  	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl_hw);
>>  }
>>  
>> +static void intel_set_overflow(struct kvm_vcpu *vcpu)
>> +{
>> +}
>> +
>>  struct kvm_pmu_ops intel_pmu_ops __initdata = {
>>  	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
>>  	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
>> @@ -897,6 +901,7 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
>>  	.save_pmu_context = intel_save_guest_pmu_context,
>>  	.restore_pmu_context = intel_restore_guest_pmu_context,
>>  	.incr_counter = intel_incr_counter,
>> +	.set_overflow = intel_set_overflow,
>>  	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
>>  	.MAX_NR_GP_COUNTERS = KVM_INTEL_PMC_MAX_GENERIC,
>>  	.MIN_NR_GP_COUNTERS = 1,

