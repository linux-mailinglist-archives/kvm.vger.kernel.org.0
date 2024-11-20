Return-Path: <kvm+bounces-32130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AEC29D34E3
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 08:56:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A46F284AC5
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 07:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8729F1684A0;
	Wed, 20 Nov 2024 07:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nI4MWO0o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF216166F0C;
	Wed, 20 Nov 2024 07:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732089381; cv=none; b=uKEevLTpB6bf2+5Gikmbevf+mQfsXnai8A6gUluz600bt7MexIox9QjX5NS0Jw8Fsx3ks32j/KvzEXJgtCIYnzP0i2hr9TWWxSKuVRebDrkwuBdRFMNyKwj37pB/MZEw+cGeZ+WNYvkC+1wOBKMFhMuRePbPLOanluu+zefZKV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732089381; c=relaxed/simple;
	bh=2H6JjkzDt7s29a+Z6v0zn7b05Ed//Gcik3VRXIdfZN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nbSS9OgypVzwDvjp8bclNudCIaDZnvna4qUSNahRotiM1Dmg27bMRgRvQzaAqGCUPBaq0NOm4xQuujaV0UwBgg0lGhk9aqdEpUGtGZgYZ2LCB4hjiwlSB374qJoWWacCFDlNZWEBgdwsk2tDQOJfJHHfCvrvumskKcmLhP9Up1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nI4MWO0o; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732089380; x=1763625380;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2H6JjkzDt7s29a+Z6v0zn7b05Ed//Gcik3VRXIdfZN8=;
  b=nI4MWO0oounBZS7sZK0JoHwltuicGIC+BHje6forP6PxXL8c3fDKTiGS
   jzCalE9/4s8ZIEzTGdsTvSsopyuFvowXl+OHge6WjLWAUUUNWWfMEnAOv
   4V8Lw3hpaNM5vCG6jZl/L5bPNtg1nC2dVZJvIMlAUC5T+5g8cD+WxVqhi
   UjWsRKELGlHNQLfZ4FhJp62zW+CqAhoyvkRkXvmxHQipX4++OVlB5tDVS
   6pw+oey1J7yHkhWxjiJYVUCQWlhF+GfAj2fyJpt8cz4BCdMqn1JZFUsgq
   ohEA6SNJrzlFuAsOh3/UHqpfbbm0iwriEHG3MmHq2XyUI2d5gHVBWNOqz
   Q==;
X-CSE-ConnectionGUID: 26R/R/JmRWy+bMth2Ft46A==
X-CSE-MsgGUID: xTx+9Su6Th6J3DzuXsn0gQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="32381998"
X-IronPort-AV: E=Sophos;i="6.12,169,1728975600"; 
   d="scan'208";a="32381998"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 23:56:19 -0800
X-CSE-ConnectionGUID: AmnhSyOZRO+0lZ2peyOorQ==
X-CSE-MsgGUID: DGSq2X39T3uKUSPiTgzp8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,169,1728975600"; 
   d="scan'208";a="90224961"
Received: from unknown (HELO [10.238.2.170]) ([10.238.2.170])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 23:56:15 -0800
Message-ID: <7605d1ae-3d29-45b9-813c-27c58c8de101@linux.intel.com>
Date: Wed, 20 Nov 2024 15:56:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 26/58] KVM: x86/pmu: Manage MSR interception for
 IA32_PERF_GLOBAL_CTRL
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
 <20240801045907.4010984-27-mizhang@google.com> <ZzzWBoCg-2B5p9bN@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZzzWBoCg-2B5p9bN@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/20/2024 2:16 AM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> ---
>>  arch/x86/include/asm/vmx.h |   1 +
>>  arch/x86/kvm/vmx/vmx.c     | 117 +++++++++++++++++++++++++++++++------
>>  arch/x86/kvm/vmx/vmx.h     |   3 +-
>>  3 files changed, 103 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
>> index d77a31039f24..5ed89a099533 100644
>> --- a/arch/x86/include/asm/vmx.h
>> +++ b/arch/x86/include/asm/vmx.h
>> @@ -106,6 +106,7 @@
>>  #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
>>  #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
>>  #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
>> +#define VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL      0x40000000
> Please add a helper in capabilities.h:
>
> static inline bool cpu_has_save_perf_global_ctrl(void)
> {
> 	return vmcs_config.vmexit_ctrl & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL;
> }

Sure.


>
>>  #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
>>  
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 339742350b7a..34a420fa98c5 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -4394,6 +4394,97 @@ static u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
>>  	return pin_based_exec_ctrl;
>>  }
>>  
>> +static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)
> This is a misleading and inaccurate name.  It does far more than "set" PERF_GLOBAL_CTRL,
> it arguably doesn't ever "set" the MSR, and it gets the VMWRITE for the guest field
> wrong too.
>
>> +{
>> +	u32 vmentry_ctrl = vm_entry_controls_get(vmx);
>> +	u32 vmexit_ctrl = vm_exit_controls_get(vmx);
>> +	struct vmx_msrs *m;
>> +	int i;
>> +
>> +	if (cpu_has_perf_global_ctrl_bug() ||
> Note, cpu_has_perf_global_ctrl_bug() broken and needs to be purged:
> https://lore.kernel.org/all/20241119011433.1797921-1-seanjc@google.com
>
> Note #2, as mentioned earlier, the mediated PMU should take a hard depenency on
> the load/save controls.
>
> On to this code, it fails to enable the load/save controls, e.g. if userspace
> does KVM_SET_CPUID2 without a PMU, then KVM_SET_CPUID2 with a PMU.  In that case,
> KVM will fail to set the control bits, and will fallback to the slow MSR load/save
> lists.
>
> With all of the above and other ideas combined, something like so:
>
> 	bool set = enable_mediated_pmu && kvm_pmu_has_perf_global_ctrl();
>
> 	vm_entry_controls_changebit(vmx, VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL, set);
> 	vm_exit_controls_changebit(vmx,
> 				   VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
> 				   VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL, set);
>
>
> And I vote to put this in intel_pmu_refresh(); that avoids needing to figure out
> a name for the helper, while giving more flexibililty on the local variable name.
>
> Oh!  Definitely put it in intel_pmu_refresh(), because the RDPMC and MSR
> interception logic needs to be there.  E.g. toggling CPU_BASED_RDPMC_EXITING
> based solely on CPUID won't do the right thing if KVM ends up making the behavior
> depend on PERF_CAPABILITIES.
>
> Ditto for MSRs.  Though until my patch/series that drops kvm_pmu_refresh() from
> kvm_pmu_init() lands[*], trying to update MSR intercepts during refresh() will hit
> a NULL pointer deref as it's currently called before vmcs01 is allocated :-/
>
> I expect to land that series before mediated PMU, but I don't think it makes sense
> to take an explicit dependency for this series.  To fudge around the issue, maybe
> do this for the next version?
>
> static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
> {
> 	__intel_pmu_refresh(vcpu);
>
> 	/*
> 	 * FIXME: Drop the MSR bitmap check if/when kvm_pmu_init() no longer
> 	 *        calls kvm_pmu_refresh(), i.e. when KVM refreshes the PMU only
> 	 *        after vmcs01 is allocated.
> 	 */
> 	if (to_vmx(vcpu)->vmcs01.msr_bitmap)
> 		intel_update_msr_intercepts(vcpu);
>
> 	vm_entry_controls_changebit(vmx, VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
> 				    enable_mediated_pmu && kvm_pmu_has_perf_global_ctrl());
>
> 	vm_exit_controls_changebit(vmx,
> 				   VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
> 				   VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL,
> 				   enable_mediated_pmu && kvm_pmu_has_perf_global_ctrl());
> }
>
> or with a local variable for "enable_mediated_pmu && kvm_pmu_has_perf_global_ctrl()".
> I can't come up with a decent name. :-)
>
> [*] https://lore.kernel.org/all/20240517173926.965351-10-seanjc@google.com

Sure. This looks better.


>
>> +	    !is_passthrough_pmu_enabled(&vmx->vcpu)) {
>> +		vmentry_ctrl &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
>> +		vmexit_ctrl &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
>> +		vmexit_ctrl &= ~VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL;
>> +	}
>> +
>> +	if (is_passthrough_pmu_enabled(&vmx->vcpu)) {
>> +		/*
>> +		 * Setup auto restore guest PERF_GLOBAL_CTRL MSR at vm entry.
>> +		 */
>> +		if (vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) {
>> +			vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, 0);
> This incorrectly clobbers the guest's value.  A simple way to handle this is to
> always propagate writes to PERF_GLOBAL_CTRL to the VMCS, if the write is allowed
> and enable_mediated_pmu.  I.e. ensure GUEST_IA32_PERF_GLOBAL_CTRL is up-to-date
> regardless of whether or not it's configured to be loaded.  Then there's no need
> to write it here.

For mediated vPMU, I think we can move this into intel_pmu_refresh() as
well, and just after the vm_entry_controls_changebit() helpers. the value
should be supported gp counters mask which respects the behavior of
PERF_GLOBAL_CTRL reset.


>
>> +		} else {
>> +			m = &vmx->msr_autoload.guest;
>> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
>> +			if (i < 0) {
>> +				i = m->nr++;
>> +				vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->nr);
>> +			}
>> +			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
>> +			m->val[i].value = 0;
>> +		}
>> +		/*
>> +		 * Setup auto clear host PERF_GLOBAL_CTRL msr at vm exit.
>> +		 */
>> +		if (vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) {
>> +			vmcs_write64(HOST_IA32_PERF_GLOBAL_CTRL, 0);
> This should be unnecessary.  KVM should clear HOST_IA32_PERF_GLOBAL_CTRL in
> vmx_set_constant_host_state() if enable_mediated_pmu is true.  Arguably, it might
> make sense to clear it unconditionally, but with a comment explaining that it's
> only actually constant for the mediated PMU.

Sure. would move this clearing into vmx_set_constant_host_state(). Yeah, I
suppose it can be cleared unconditionally since
VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL bit never be set for legacy emulated vPMU.


>
> And if the mediated PMU requires the VMCS knobs, then all of the load/store list
> complexity goes away.
>
>>  static u32 vmx_vmentry_ctrl(void)
>>  {
>>  	u32 vmentry_ctrl = vmcs_config.vmentry_ctrl;
>> @@ -4401,17 +4492,10 @@ static u32 vmx_vmentry_ctrl(void)
>>  	if (vmx_pt_mode_is_system())
>>  		vmentry_ctrl &= ~(VM_ENTRY_PT_CONCEAL_PIP |
>>  				  VM_ENTRY_LOAD_IA32_RTIT_CTL);
>> -	/*
>> -	 * IA32e mode, and loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically.
>> -	 */
>> -	vmentry_ctrl &= ~(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
>> -			  VM_ENTRY_LOAD_IA32_EFER |
>> -			  VM_ENTRY_IA32E_MODE);
>> -
>> -	if (cpu_has_perf_global_ctrl_bug())
>> -		vmentry_ctrl &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
>> -
>> -	return vmentry_ctrl;
>> +	 /*
>> +	  * IA32e mode, and loading of EFER is toggled dynamically.
>> +	  */
>> +	return vmentry_ctrl &= ~(VM_ENTRY_LOAD_IA32_EFER | VM_ENTRY_IA32E_MODE);
> With my above suggestion, these changes are unnecessary.  If enable_mediated_pmu
> is false, or the vCPU doesn't have a PMU, clearing the controls is correct.  And
> when the vCPU is gifted a PMU, KVM will explicitly enabled the controls.
Yes.

>
> To discourage incorrect usage of these helpers maybe rename them to
> vmx_get_initial_{vmentry,vmexit}_ctrl()?

Sure.


>
>>  }
>>  
>>  static u32 vmx_vmexit_ctrl(void)
>> @@ -4429,12 +4513,8 @@ static u32 vmx_vmexit_ctrl(void)
>>  		vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
>>  				 VM_EXIT_CLEAR_IA32_RTIT_CTL);
>>  
>> -	if (cpu_has_perf_global_ctrl_bug())
>> -		vmexit_ctrl &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
>> -
>> -	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
>> -	return vmexit_ctrl &
>> -		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);
> But this code needs to *add* clearing of VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL.

Sure.



