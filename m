Return-Path: <kvm+bounces-29683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6933A9AF7A5
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 04:50:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28B1D281A10
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 02:50:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE8E18A6CE;
	Fri, 25 Oct 2024 02:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Aap4k3nB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE3E33FE;
	Fri, 25 Oct 2024 02:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729824643; cv=none; b=Vbv19crbSroQo7zDKCrJnTfmc+KwyhhwIArbiT698tVwk2vUDu8w4CrEH5v8rZai8hS1zNztlq/6uQaMR2lMirsnCrt24Mu9mJBFvPbcovfqy8HraXVM9/KtWF9Eqj9UZXqXIgIv0eNzOwO1T6hdOTxiLJvk7aaHW86nBDpxvAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729824643; c=relaxed/simple;
	bh=5dFAQi9Yerkaf4FNcVF2eQYanQvgoUKw/SMbyS9J7p0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xn0QeAp3IhdU3opqWDRPGFsHnhFFpRmX5j0HONzehOIcV8P2MhzFEYHpOEBsu3G/MJQa5+i2daCjoBgXgBnNRIyBxGfjeQeYxNsm3JEBe2iowWoOK70LJ8ny+mWNTnalZUrZ9wi1W9U6GZI2DOQppw0ra4nwTnUT3j5dXWTGHug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Aap4k3nB; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729824642; x=1761360642;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5dFAQi9Yerkaf4FNcVF2eQYanQvgoUKw/SMbyS9J7p0=;
  b=Aap4k3nBUfBFiEtkZi7HSI/5ME/yTbNLBgmm7SsxrEPSwyJO4Dg1eL02
   d/vDabe5nKeI48rNQHMR53wPP4Tno0u6jttTi9n1Ys24kyGnPrpTcsryq
   4Bonanm+5Akrsf2jVYCV0BwzvGb/4SdjJFKtXebqJxHR3MTMFEbQ074Si
   lEkkGh/big0s8xbyMQtV9FgFGSLG6YrdXmt88jww0rXUTZyeimEiFnD9F
   RPUdF5/GoGZ0jmVMe5HAkFZpuzUI2H92L7hGE3irNW+rHvADyWp67RefR
   Lr/e5DLlWrfeVu9Ri50+Ks2VwXQBPnNYjtXLK6yiJJz0vXTh2EQl7IK+a
   A==;
X-CSE-ConnectionGUID: oa3/YYaKQO6odQSdazniyQ==
X-CSE-MsgGUID: 3GztiEFjQDSzIpEuObfM3A==
X-IronPort-AV: E=McAfee;i="6700,10204,11235"; a="54887261"
X-IronPort-AV: E=Sophos;i="6.11,231,1725346800"; 
   d="scan'208";a="54887261"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 19:50:41 -0700
X-CSE-ConnectionGUID: vNMJ1xhxSkWl7JrckhB5pQ==
X-CSE-MsgGUID: cKkij09BTw6pfRCIL3O3mA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,231,1725346800"; 
   d="scan'208";a="81214460"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.125.240.3]) ([10.125.240.3])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 19:50:35 -0700
Message-ID: <05ef9830-0a76-4e15-a084-f614c5a85a00@linux.intel.com>
Date: Fri, 25 Oct 2024 10:50:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 27/58] KVM: x86/pmu: Create a function prototype to
 disable MSR interception
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
 <20240801045907.4010984-28-mizhang@google.com>
 <b3e57722-3599-45c5-9307-e8797f167f3c@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <b3e57722-3599-45c5-9307-e8797f167f3c@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 10/25/2024 3:58 AM, Chen, Zide wrote:
>
> On 7/31/2024 9:58 PM, Mingwei Zhang wrote:
>> Add one extra pmu function prototype in kvm_pmu_ops to disable PMU MSR
>> interception.
>>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>> ---
>>  arch/x86/include/asm/kvm-x86-pmu-ops.h | 1 +
>>  arch/x86/kvm/cpuid.c                   | 4 ++++
>>  arch/x86/kvm/pmu.c                     | 5 +++++
>>  arch/x86/kvm/pmu.h                     | 2 ++
>>  4 files changed, 12 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
>> index fd986d5146e4..1b7876dcb3c3 100644
>> --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
>> +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
>> @@ -24,6 +24,7 @@ KVM_X86_PMU_OP(is_rdpmc_passthru_allowed)
>>  KVM_X86_PMU_OP_OPTIONAL(reset)
>>  KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
>>  KVM_X86_PMU_OP_OPTIONAL(cleanup)
>> +KVM_X86_PMU_OP_OPTIONAL(passthrough_pmu_msrs)
>>  
>>  #undef KVM_X86_PMU_OP
>>  #undef KVM_X86_PMU_OP_OPTIONAL
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index f2f2be5d1141..3deb79b39847 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -381,6 +381,10 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>  	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
>>  
>>  	kvm_pmu_refresh(vcpu);
>> +
>> +	if (is_passthrough_pmu_enabled(vcpu))
>> +		kvm_pmu_passthrough_pmu_msrs(vcpu);
>> +
>>  	vcpu->arch.cr4_guest_rsvd_bits =
>>  	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
>>  
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 3afefe4cf6e2..bd94f2d67f5c 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -1059,3 +1059,8 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>>  	kfree(filter);
>>  	return r;
>>  }
>> +
>> +void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
>> +{
>> +	static_call_cond(kvm_x86_pmu_passthrough_pmu_msrs)(vcpu);
>> +}
>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>> index e1af6d07b191..63f876557716 100644
>> --- a/arch/x86/kvm/pmu.h
>> +++ b/arch/x86/kvm/pmu.h
>> @@ -41,6 +41,7 @@ struct kvm_pmu_ops {
>>  	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
>>  	void (*cleanup)(struct kvm_vcpu *vcpu);
>>  	bool (*is_rdpmc_passthru_allowed)(struct kvm_vcpu *vcpu);
>> +	void (*passthrough_pmu_msrs)(struct kvm_vcpu *vcpu);
> Seems after_set_cpuid() is a better name. It's more generic to reflect
> the fact that PMU needs to do something after userspace sets CPUID.
> Currently PMU needs to update the MSR interception policy, but it may
> want to do more in the future.
>
> Also, it's more consistent to other APIs called in
> kvm_vcpu_after_set_cpuid().

Looks reasonable.


>
>>  
>>  	const u64 EVENTSEL_EVENT;
>>  	const int MAX_NR_GP_COUNTERS;
>> @@ -292,6 +293,7 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
>>  int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
>>  void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel);
>>  bool kvm_pmu_check_rdpmc_passthrough(struct kvm_vcpu *vcpu);
>> +void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu);
>>  
>>  bool is_vmware_backdoor_pmc(u32 pmc_idx);
>>  

