Return-Path: <kvm+bounces-35495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E31B8A1177E
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 03:52:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F011C18894E1
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 02:52:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0542722DFB2;
	Wed, 15 Jan 2025 02:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SLEaCYUI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C9A6FB9;
	Wed, 15 Jan 2025 02:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736909532; cv=none; b=Dtu/k8V6oVF2mLfxhnmHlsD7M694DavaS9mWEl5fqQ++1JmjA98Io0MN7ftl3FqNlcVhgMrwcB7fCoR9PO/gqvbbxIGoLV9QhM63W47wX0QQgetUAV8TfPzIr6wITbcerpezqiQsHNn+GlQIBP8O/wUZehoRRXWCqeTQpi5ZU+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736909532; c=relaxed/simple;
	bh=yMuW3rZ5VC8zMDyShFBfQdCFCTvHdntK2B1qzK7sFuE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pgI47bitKO4enXzF8UHfhU8L7h1SJaKAoP3rxQjJjfFvP6Mbm4aENAXlJK87GbawczSLV0JtEPP9M5eYkYyNWKCEeYRCbSYUJr2sI+OCS5uRfRR4n0vadkEpoBbCD1PHD9EpyQlaNj2ko1mYlqFmdd1GO+eRSb1Gv3fMwEyhlnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SLEaCYUI; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736909531; x=1768445531;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yMuW3rZ5VC8zMDyShFBfQdCFCTvHdntK2B1qzK7sFuE=;
  b=SLEaCYUIfNhPKZtvKQiLSh5xQatP+JyGQCtaTN0hUA1xh1UZm3MDIPbE
   0osZChP9hCV0o6gfJEzt32WgJCTN3PA3dHz1t1MCqdNDafSBvjH2QO6Hu
   niuFC2mHbpR2BzOOHFvqmnO01RcInYADCnED8i29flQnY4LIkNZevvOaA
   UIYQLzXg4odZ3UFTNbSsq+/dVlB6zWopHCV8ikLagSe3VbIiCPnL+dFe8
   qgbYPv1sdlBAVnumHW5AW7UIjnnDEtQxwwsTn9tImi6rBm3TIU0D1w20b
   EdqHyJazBGG/h392zquGpWTibf9VH5FK9AAuEg14N0873VnMfQxDZ6tXF
   w==;
X-CSE-ConnectionGUID: 7m4Z6FGBQuS86Ezm2z5BRw==
X-CSE-MsgGUID: Xas3W/G8T9WBWxuZM7GjWg==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="40909667"
X-IronPort-AV: E=Sophos;i="6.12,316,1728975600"; 
   d="scan'208";a="40909667"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 18:52:10 -0800
X-CSE-ConnectionGUID: mglLaGBRR5aJ+/PLxKk0JA==
X-CSE-MsgGUID: JOTLoJsvTwm5KtGuRfeqBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="135860276"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 18:52:04 -0800
Message-ID: <de34d0eb-095b-4992-a48d-28f5a59634ca@linux.intel.com>
Date: Wed, 15 Jan 2025 10:52:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 18/58] KVM: x86/pmu: Introduce
 enable_passthrough_pmu module parameter
To: Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-19-mizhang@google.com> <Zzyg_0ACKwHGLC7w@google.com>
 <50ba7bd1-6acf-4b50-9eb1-8beb2beee9ec@linux.intel.com>
 <Z4b-kkRNp1V0faTq@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Z4b-kkRNp1V0faTq@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 1/15/2025 8:17 AM, Mingwei Zhang wrote:
> On Wed, Nov 20, 2024, Mi, Dapeng wrote:
>> On 11/19/2024 10:30 PM, Sean Christopherson wrote:
>>> As per my feedback in the initial RFC[*]:
>>>
>>>  2. The module param absolutely must not be exposed to userspace until all patches
>>>     are in place.  The easiest way to do that without creating dependency hell is
>>>     to simply not create the module param.
>>>
>>> [*] https://lore.kernel.org/all/ZhhQBHQ6V7Zcb8Ve@google.com
>> Sure. It looks we missed this comment. Would address it.
>>
> Dapeng, just synced with Sean offline. His point is that we still need
> kernel parameter but introduce that in the last part of the series so
> that any bisect won't trigger the new PMU logic in the middle of the
> series. But I think you are right to create a global config and make it
> false.

Ok, I would add a patch to expose the kernel parameter and put it at the
last. Thanks.


>
>>> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>>>> Introduce enable_passthrough_pmu as a RO KVM kernel module parameter. This
>>>> variable is true only when the following conditions satisfies:
>>>>  - set to true when module loaded.
>>>>  - enable_pmu is true.
>>>>  - is running on Intel CPU.
>>>>  - supports PerfMon v4.
>>>>  - host PMU supports passthrough mode.
>>>>
>>>> The value is always read-only because passthrough PMU currently does not
>>>> support features like LBR and PEBS, while emualted PMU does. This will end
>>>> up with two different values for kvm_cap.supported_perf_cap, which is
>>>> initialized at module load time. Maintaining two different perf
>>>> capabilities will add complexity. Further, there is not enough motivation
>>>> to support running two types of PMU implementations at the same time,
>>>> although it is possible/feasible in reality.
>>>>
>>>> Finally, always propagate enable_passthrough_pmu and perf_capabilities into
>>>> kvm->arch for each KVM instance.
>>>>
>>>> Co-developed-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>>>> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>>>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>>>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>>> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>>>> ---
>>>>  arch/x86/include/asm/kvm_host.h |  1 +
>>>>  arch/x86/kvm/pmu.h              | 14 ++++++++++++++
>>>>  arch/x86/kvm/vmx/vmx.c          |  7 +++++--
>>>>  arch/x86/kvm/x86.c              |  8 ++++++++
>>>>  arch/x86/kvm/x86.h              |  1 +
>>>>  5 files changed, 29 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>>> index f8ca74e7678f..a15c783f20b9 100644
>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>> @@ -1406,6 +1406,7 @@ struct kvm_arch {
>>>>  
>>>>  	bool bus_lock_detection_enabled;
>>>>  	bool enable_pmu;
>>>> +	bool enable_passthrough_pmu;
>>> Again, as I suggested/requested in the initial RFC[*], drop the per-VM flag as well
>>> as kvm_pmu.passthrough.  There is zero reason to cache the module param.  KVM
>>> should always query kvm->arch.enable_pmu prior to checking if the mediated PMU
>>> is enabled, so I doubt we even need a helper to check both.
>>>
>>> [*] https://lore.kernel.org/all/ZhhOEDAl6k-NzOkM@google.com
>> Sure.
>>
>>
>>>>  
>>>>  	u32 notify_window;
>>>>  	u32 notify_vmexit_flags;
>>>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>>>> index 4d52b0b539ba..cf93be5e7359 100644
>>>> --- a/arch/x86/kvm/pmu.h
>>>> +++ b/arch/x86/kvm/pmu.h
>>>> @@ -208,6 +208,20 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>>>>  			enable_pmu = false;
>>>>  	}
>>>>  
>>>> +	/* Pass-through vPMU is only supported in Intel CPUs. */
>>>> +	if (!is_intel)
>>>> +		enable_passthrough_pmu = false;
>>>> +
>>>> +	/*
>>>> +	 * Pass-through vPMU requires at least PerfMon version 4 because the
>>>> +	 * implementation requires the usage of MSR_CORE_PERF_GLOBAL_STATUS_SET
>>>> +	 * for counter emulation as well as PMU context switch.  In addition, it
>>>> +	 * requires host PMU support on passthrough mode. Disable pass-through
>>>> +	 * vPMU if any condition fails.
>>>> +	 */
>>>> +	if (!enable_pmu || kvm_pmu_cap.version < 4 || !kvm_pmu_cap.passthrough)
>>> As is quite obvious by the end of the series, the v4 requirement is specific to
>>> Intel.
>>>
>>> 	if (!enable_pmu || !kvm_pmu_cap.passthrough ||
>>> 	    (is_intel && kvm_pmu_cap.version < 4) ||
>>> 	    (is_amd && kvm_pmu_cap.version < 2))
>>> 		enable_passthrough_pmu = false;
>>>
>>> Furthermore, there is zero reason to explicitly and manually check the vendor,
>>> kvm_init_pmu_capability() takes kvm_pmu_ops.  Adding a callback is somewhat
>>> undesirable as it would lead to duplicate code, but we can still provide separation
>>> of concerns by adding const variables to kvm_pmu_ops, a la MAX_NR_GP_COUNTERS.
>>>
>>> E.g.
>>>
>>> 	if (enable_pmu) {
>>> 		perf_get_x86_pmu_capability(&kvm_pmu_cap);
>>>
>>> 		/*
>>> 		 * WARN if perf did NOT disable hardware PMU if the number of
>>> 		 * architecturally required GP counters aren't present, i.e. if
>>> 		 * there are a non-zero number of counters, but fewer than what
>>> 		 * is architecturally required.
>>> 		 */
>>> 		if (!kvm_pmu_cap.num_counters_gp ||
>>> 		    WARN_ON_ONCE(kvm_pmu_cap.num_counters_gp < min_nr_gp_ctrs))
>>> 			enable_pmu = false;
>>> 		else if (pmu_ops->MIN_PMU_VERSION > kvm_pmu_cap.version)
>>> 			enable_pmu = false;
>>> 	}
>>>
>>> 	if (!enable_pmu || !kvm_pmu_cap.passthrough ||
>>> 	    pmu_ops->MIN_MEDIATED_PMU_VERSION > kvm_pmu_cap.version)
>>> 		enable_mediated_pmu = false;
>> Sure.  would do.
>>
>>
>>>> +		enable_passthrough_pmu = false;
>>>> +
>>>>  	if (!enable_pmu) {
>>>>  		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
>>>>  		return;
>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>> index ad465881b043..2ad122995f11 100644
>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>> @@ -146,6 +146,8 @@ module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
>>>>  extern bool __read_mostly allow_smaller_maxphyaddr;
>>>>  module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
>>>>  
>>>> +module_param(enable_passthrough_pmu, bool, 0444);
>>> Hmm, we either need to put this param in kvm.ko, or move enable_pmu to vendor
>>> modules (or duplicate it there if we need to for backwards compatibility?).
>>>
>>> There are advantages to putting params in vendor modules, when it's safe to do so,
>>> e.g. it allows toggling the param when (re)loading a vendor module, so I think I'm
>>> supportive of having the param live in vendor code.  I just don't want to split
>>> the two PMU knobs.
>> Since enable_passthrough_pmu has already been in vendor modules,  we'd
>> better duplicate enable_pmu module parameter in vendor modules as the 1st step.
>>
>>
>>>>  #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
>>>>  #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR0_NE
>>>>  #define KVM_VM_CR0_ALWAYS_ON				\
>>>> @@ -7924,7 +7926,8 @@ static __init u64 vmx_get_perf_capabilities(void)
>>>>  	if (boot_cpu_has(X86_FEATURE_PDCM))
>>>>  		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
>>>>  
>>>> -	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR)) {
>>>> +	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR) &&
>>>> +	    !enable_passthrough_pmu) {
>>>>  		x86_perf_get_lbr(&vmx_lbr_caps);
>>>>  
>>>>  		/*
>>>> @@ -7938,7 +7941,7 @@ static __init u64 vmx_get_perf_capabilities(void)
>>>>  			perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
>>>>  	}
>>>>  
>>>> -	if (vmx_pebs_supported()) {
>>>> +	if (vmx_pebs_supported() && !enable_passthrough_pmu) {
>>> Checking enable_mediated_pmu belongs in vmx_pebs_supported(), not in here,
>>> otherwise KVM will incorrectly advertise support to userspace:
>>>
>>> 	if (vmx_pebs_supported()) {
>>> 		kvm_cpu_cap_check_and_set(X86_FEATURE_DS);
>>> 		kvm_cpu_cap_check_and_set(X86_FEATURE_DTES64);
>>> 	}
>> Sure. Thanks for pointing this.
>>
>>
>>>>  		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
>>>>  		/*
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index f1d589c07068..0c40f551130e 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -187,6 +187,10 @@ bool __read_mostly enable_pmu = true;
>>>>  EXPORT_SYMBOL_GPL(enable_pmu);
>>>>  module_param(enable_pmu, bool, 0444);
>>>>  
>>>> +/* Enable/disable mediated passthrough PMU virtualization */
>>>> +bool __read_mostly enable_passthrough_pmu;
>>>> +EXPORT_SYMBOL_GPL(enable_passthrough_pmu);
>>>> +
>>>>  bool __read_mostly eager_page_split = true;
>>>>  module_param(eager_page_split, bool, 0644);
>>>>  
>>>> @@ -6682,6 +6686,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>>>  		mutex_lock(&kvm->lock);
>>>>  		if (!kvm->created_vcpus) {
>>>>  			kvm->arch.enable_pmu = !(cap->args[0] & KVM_PMU_CAP_DISABLE);
>>>> +			/* Disable passthrough PMU if enable_pmu is false. */
>>>> +			if (!kvm->arch.enable_pmu)
>>>> +				kvm->arch.enable_passthrough_pmu = false;
>>> And this code obviously goes away if the per-VM snapshot is removed.

