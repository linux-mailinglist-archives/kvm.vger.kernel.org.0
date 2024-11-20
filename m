Return-Path: <kvm+bounces-32116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9D159D3281
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 04:21:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69E7B283F7B
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 03:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FDAD155CA5;
	Wed, 20 Nov 2024 03:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TtuzVoKC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B200E545;
	Wed, 20 Nov 2024 03:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732072872; cv=none; b=X9qhvrQkinWLsKh1cVv4A1MhdXcYWms+sQNb61pPAHSAuhkRccDvCaJrTtYOG7hSosE0dRJ9wUorFMVact6CKVIgY8TPpILmrxIt1kRI6cEvjVuZXmj+EjPRDlUtyZTrZW5KPO6ps7c3Ja+off1AKQup7N1Cs76Ztpn8AllEYXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732072872; c=relaxed/simple;
	bh=3uTAZjU6v6VdAW5glrq1H3k9HCRp6oMemJ4E/bYW/Vs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ApDz7FN+i0TowD8Z3F+YfvMgL2urmHsPg9O3v9Ce/bAqgXKXBlBDVy92Xp6jOh12Cw0U+IIBHJ5vNDBRA+hR+BWB2IqYY7h2WVTLEmuUf8m9GgZnZsW91Yrvtf8z17D2O64KEvAwIBCUENbonS2HSeosxr4RQZ6Y6nh/jd8lihM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TtuzVoKC; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732072870; x=1763608870;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3uTAZjU6v6VdAW5glrq1H3k9HCRp6oMemJ4E/bYW/Vs=;
  b=TtuzVoKCUpE/lAN9wCgORSUvruQ4v4JHzQapVN5EAvi5RXmna4d0kI0P
   RyYQqh29xcwIbnQ1EeUm4jmZqcfCwNzlL50im9+RY4KjBp4tS3w5xTboh
   QrD/AnGTbVAVyNLM1+PQthhadmpPPXSmliUQCEjXWVTISypmTQsCIHsg/
   a5mNsZB7yW6gYLq+aeKiqt+JfzR1gIvqYXSIaBogy8h9b/QDy6KTIlmUz
   MXXwlamgjfYfPm4FiPuTcpyra+TWAwGoVuRteife56TbH6Hl21M3c2NRx
   rPNJkrzglkVisSIr80HkZkGylLNnp3LB0fVs4odoz3yOLkNW3h+R9tZW+
   g==;
X-CSE-ConnectionGUID: JUZhOCDcSXSSFgz+slOwKQ==
X-CSE-MsgGUID: 95GGrnNaTTeigoGS6TbxHQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="43494486"
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="43494486"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 19:21:10 -0800
X-CSE-ConnectionGUID: FZwcr2pRSf+OaCvOQzGXUw==
X-CSE-MsgGUID: bNutG5V7Qju9CQhscs7wDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="94699919"
Received: from unknown (HELO [10.238.2.170]) ([10.238.2.170])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 19:21:05 -0800
Message-ID: <50ba7bd1-6acf-4b50-9eb1-8beb2beee9ec@linux.intel.com>
Date: Wed, 20 Nov 2024 11:21:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 18/58] KVM: x86/pmu: Introduce
 enable_passthrough_pmu module parameter
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
 <20240801045907.4010984-19-mizhang@google.com> <Zzyg_0ACKwHGLC7w@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zzyg_0ACKwHGLC7w@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 11/19/2024 10:30 PM, Sean Christopherson wrote:
> As per my feedback in the initial RFC[*]:
>
>  2. The module param absolutely must not be exposed to userspace until all patches
>     are in place.  The easiest way to do that without creating dependency hell is
>     to simply not create the module param.
>
> [*] https://lore.kernel.org/all/ZhhQBHQ6V7Zcb8Ve@google.com

Sure. It looks we missed this comment. Would address it.


>
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> Introduce enable_passthrough_pmu as a RO KVM kernel module parameter. This
>> variable is true only when the following conditions satisfies:
>>  - set to true when module loaded.
>>  - enable_pmu is true.
>>  - is running on Intel CPU.
>>  - supports PerfMon v4.
>>  - host PMU supports passthrough mode.
>>
>> The value is always read-only because passthrough PMU currently does not
>> support features like LBR and PEBS, while emualted PMU does. This will end
>> up with two different values for kvm_cap.supported_perf_cap, which is
>> initialized at module load time. Maintaining two different perf
>> capabilities will add complexity. Further, there is not enough motivation
>> to support running two types of PMU implementations at the same time,
>> although it is possible/feasible in reality.
>>
>> Finally, always propagate enable_passthrough_pmu and perf_capabilities into
>> kvm->arch for each KVM instance.
>>
>> Co-developed-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  1 +
>>  arch/x86/kvm/pmu.h              | 14 ++++++++++++++
>>  arch/x86/kvm/vmx/vmx.c          |  7 +++++--
>>  arch/x86/kvm/x86.c              |  8 ++++++++
>>  arch/x86/kvm/x86.h              |  1 +
>>  5 files changed, 29 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index f8ca74e7678f..a15c783f20b9 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1406,6 +1406,7 @@ struct kvm_arch {
>>  
>>  	bool bus_lock_detection_enabled;
>>  	bool enable_pmu;
>> +	bool enable_passthrough_pmu;
> Again, as I suggested/requested in the initial RFC[*], drop the per-VM flag as well
> as kvm_pmu.passthrough.  There is zero reason to cache the module param.  KVM
> should always query kvm->arch.enable_pmu prior to checking if the mediated PMU
> is enabled, so I doubt we even need a helper to check both.
>
> [*] https://lore.kernel.org/all/ZhhOEDAl6k-NzOkM@google.com

Sure.


>
>>  
>>  	u32 notify_window;
>>  	u32 notify_vmexit_flags;
>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>> index 4d52b0b539ba..cf93be5e7359 100644
>> --- a/arch/x86/kvm/pmu.h
>> +++ b/arch/x86/kvm/pmu.h
>> @@ -208,6 +208,20 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>>  			enable_pmu = false;
>>  	}
>>  
>> +	/* Pass-through vPMU is only supported in Intel CPUs. */
>> +	if (!is_intel)
>> +		enable_passthrough_pmu = false;
>> +
>> +	/*
>> +	 * Pass-through vPMU requires at least PerfMon version 4 because the
>> +	 * implementation requires the usage of MSR_CORE_PERF_GLOBAL_STATUS_SET
>> +	 * for counter emulation as well as PMU context switch.  In addition, it
>> +	 * requires host PMU support on passthrough mode. Disable pass-through
>> +	 * vPMU if any condition fails.
>> +	 */
>> +	if (!enable_pmu || kvm_pmu_cap.version < 4 || !kvm_pmu_cap.passthrough)
> As is quite obvious by the end of the series, the v4 requirement is specific to
> Intel.
>
> 	if (!enable_pmu || !kvm_pmu_cap.passthrough ||
> 	    (is_intel && kvm_pmu_cap.version < 4) ||
> 	    (is_amd && kvm_pmu_cap.version < 2))
> 		enable_passthrough_pmu = false;
>
> Furthermore, there is zero reason to explicitly and manually check the vendor,
> kvm_init_pmu_capability() takes kvm_pmu_ops.  Adding a callback is somewhat
> undesirable as it would lead to duplicate code, but we can still provide separation
> of concerns by adding const variables to kvm_pmu_ops, a la MAX_NR_GP_COUNTERS.
>
> E.g.
>
> 	if (enable_pmu) {
> 		perf_get_x86_pmu_capability(&kvm_pmu_cap);
>
> 		/*
> 		 * WARN if perf did NOT disable hardware PMU if the number of
> 		 * architecturally required GP counters aren't present, i.e. if
> 		 * there are a non-zero number of counters, but fewer than what
> 		 * is architecturally required.
> 		 */
> 		if (!kvm_pmu_cap.num_counters_gp ||
> 		    WARN_ON_ONCE(kvm_pmu_cap.num_counters_gp < min_nr_gp_ctrs))
> 			enable_pmu = false;
> 		else if (pmu_ops->MIN_PMU_VERSION > kvm_pmu_cap.version)
> 			enable_pmu = false;
> 	}
>
> 	if (!enable_pmu || !kvm_pmu_cap.passthrough ||
> 	    pmu_ops->MIN_MEDIATED_PMU_VERSION > kvm_pmu_cap.version)
> 		enable_mediated_pmu = false;

Sure.  would do.


>> +		enable_passthrough_pmu = false;
>> +
>>  	if (!enable_pmu) {
>>  		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
>>  		return;
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index ad465881b043..2ad122995f11 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -146,6 +146,8 @@ module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
>>  extern bool __read_mostly allow_smaller_maxphyaddr;
>>  module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
>>  
>> +module_param(enable_passthrough_pmu, bool, 0444);
> Hmm, we either need to put this param in kvm.ko, or move enable_pmu to vendor
> modules (or duplicate it there if we need to for backwards compatibility?).
>
> There are advantages to putting params in vendor modules, when it's safe to do so,
> e.g. it allows toggling the param when (re)loading a vendor module, so I think I'm
> supportive of having the param live in vendor code.  I just don't want to split
> the two PMU knobs.

Since enable_passthrough_pmu has already been in vendor modules,  we'd
better duplicate enable_pmu module parameter in vendor modules as the 1st step.


>
>>  #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
>>  #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR0_NE
>>  #define KVM_VM_CR0_ALWAYS_ON				\
>> @@ -7924,7 +7926,8 @@ static __init u64 vmx_get_perf_capabilities(void)
>>  	if (boot_cpu_has(X86_FEATURE_PDCM))
>>  		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
>>  
>> -	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR)) {
>> +	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR) &&
>> +	    !enable_passthrough_pmu) {
>>  		x86_perf_get_lbr(&vmx_lbr_caps);
>>  
>>  		/*
>> @@ -7938,7 +7941,7 @@ static __init u64 vmx_get_perf_capabilities(void)
>>  			perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
>>  	}
>>  
>> -	if (vmx_pebs_supported()) {
>> +	if (vmx_pebs_supported() && !enable_passthrough_pmu) {
> Checking enable_mediated_pmu belongs in vmx_pebs_supported(), not in here,
> otherwise KVM will incorrectly advertise support to userspace:
>
> 	if (vmx_pebs_supported()) {
> 		kvm_cpu_cap_check_and_set(X86_FEATURE_DS);
> 		kvm_cpu_cap_check_and_set(X86_FEATURE_DTES64);
> 	}

Sure. Thanks for pointing this.


>
>>  		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
>>  		/*
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index f1d589c07068..0c40f551130e 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -187,6 +187,10 @@ bool __read_mostly enable_pmu = true;
>>  EXPORT_SYMBOL_GPL(enable_pmu);
>>  module_param(enable_pmu, bool, 0444);
>>  
>> +/* Enable/disable mediated passthrough PMU virtualization */
>> +bool __read_mostly enable_passthrough_pmu;
>> +EXPORT_SYMBOL_GPL(enable_passthrough_pmu);
>> +
>>  bool __read_mostly eager_page_split = true;
>>  module_param(eager_page_split, bool, 0644);
>>  
>> @@ -6682,6 +6686,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>  		mutex_lock(&kvm->lock);
>>  		if (!kvm->created_vcpus) {
>>  			kvm->arch.enable_pmu = !(cap->args[0] & KVM_PMU_CAP_DISABLE);
>> +			/* Disable passthrough PMU if enable_pmu is false. */
>> +			if (!kvm->arch.enable_pmu)
>> +				kvm->arch.enable_passthrough_pmu = false;
> And this code obviously goes away if the per-VM snapshot is removed.

