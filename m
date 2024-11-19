Return-Path: <kvm+bounces-32088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7D619D2E6F
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 19:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 730CFB39BD4
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 18:17:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C30E1D3593;
	Tue, 19 Nov 2024 18:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WmEwY0uU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B40B1D14FD
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 18:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732040203; cv=none; b=cigZLRf7HmhiVRsiBOU3NymXuyTXfbBbNib/a0eFC6Hw3Mik3SVrBCTpuebLi6yxAm6s87hBjMytKTpwdphGBS+E2Q3eIRjeMqvTE69ikwmxdvgO5nFY72BmEaIL/wA8oGHbM9mw+oNvNF2QyNs2eWRVXzophM8dy7zqhN+3fRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732040203; c=relaxed/simple;
	bh=S6qePynJfvFNjGTiJCMXdcd4gjx5A5flHSQM0Yu8a90=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iDXhlUlF0gcGxnW7qze4drqOzltfyHBbEGGQRCSdWDD4C3ORo7PKkVFyQ3BsvYXlMK286RcbpsluBI6zMyFMy5YPDj0dlDy7AsoiQafSdmevFsoyIjQf0aJ9kKCUoUdKG8PgyfumWVXCQa4UXtAoNfVU3oWr92eusoWVd22JVYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WmEwY0uU; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ee6e1f2d25so61674797b3.0
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 10:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732040200; x=1732645000; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=idomr3Hl2BFFWSsWPJ0RzB0j8mo/mnxNDTGRrypBjvI=;
        b=WmEwY0uU4XI9qAA9KlpIeyZSCJF7mwzpmPMOxC7lOjrJ8ypA4VikJC8DX4g/QCwErK
         hf1A0Riq6Ktsj9hBn3ddLWTsSN5DAtM5JNO0Mkxbi51XlXcSd/eXjCmsumQQFOEmQfyf
         oph/YLIWpgtFu0UgWm1wkqR8puS4GVd9XokCUiZ6OliJdacIyQ6NZgcqjrZgVs8LAJqx
         JbDD8lkS9vCVFCpFDT8rQmOgN6+JWp/P1xXcTx1Jzk8/h9aK0AlEgzd3ULvjH+Py83Oa
         UFZAbpDNeHs+SNqF15KUBQShSGEFY/SBav76SRjcD5TlHnNapsFgcJh9tTJo4zMCtIsQ
         q3HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732040200; x=1732645000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=idomr3Hl2BFFWSsWPJ0RzB0j8mo/mnxNDTGRrypBjvI=;
        b=Ahhn99gp/OZiYfevNI7w1ZtS6CYfHzjnHPWC9jOV3+oVMY9Y7X5lx0BYhJmb/1bTnh
         y90kN7eLhNRN61sL4xg3dmvfteQC3rdvaVWrn5WCRnOAEc4YuGtU2wCy5vIaNn76SkRj
         a1h81f4jnikHL64AdJ1/CjEZTkcPIGA3+y+1ra1EMvELEwpZjRiOkWRGGC81PSLY/VoK
         ps52lzpODRh0vui/uGelXOD9kByZnlgqCAQQkeRDoh34Vxx70ThdoUKLMkjH06Ytu2vq
         ZHnIfb2uKQQnqgUAAplJbEf/Eph+W4eV09NggMsogVTz3klLY3ruEYEFSQnyF4El1YVi
         eJvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUp4Ka5l+HE+1r3TD2nGMktKjkJkegKVFgIljidE/XBHsiCuO03szungmm7bx60/nzR9z0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm4RPx+VzBe6oK8Ia/7Ii/Rb+p9xzVT4sI3NIxnwRzR5WxXXLi
	sveA0eqLAbouTSl7kOq+2HoN6RBq93o1/0JD2ZQ9zPsHo8Z0ImcgF1i0clbzjwmO6x6cdxCSeKy
	bXQ==
X-Google-Smtp-Source: AGHT+IFSmG4m0oHH/q7gNwHuQzmdwSVvXHtPSlKJsyH+VTHZK8FkxYqujncC6c7x+AQQzhLIhNCFQZtFCrU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3102:b0:6ea:1f5b:1f5e with SMTP id
 00721157ae682-6ee55c95b39mr983367b3.4.1732040200274; Tue, 19 Nov 2024
 10:16:40 -0800 (PST)
Date: Tue, 19 Nov 2024 10:16:38 -0800
In-Reply-To: <20240801045907.4010984-27-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-27-mizhang@google.com>
Message-ID: <ZzzWBoCg-2B5p9bN@google.com>
Subject: Re: [RFC PATCH v3 26/58] KVM: x86/pmu: Manage MSR interception for IA32_PERF_GLOBAL_CTRL
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 01, 2024, Mingwei Zhang wrote:
> ---
>  arch/x86/include/asm/vmx.h |   1 +
>  arch/x86/kvm/vmx/vmx.c     | 117 +++++++++++++++++++++++++++++++------
>  arch/x86/kvm/vmx/vmx.h     |   3 +-
>  3 files changed, 103 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index d77a31039f24..5ed89a099533 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -106,6 +106,7 @@
>  #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
>  #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
>  #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
> +#define VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL      0x40000000

Please add a helper in capabilities.h:

static inline bool cpu_has_save_perf_global_ctrl(void)
{
	return vmcs_config.vmexit_ctrl & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL;
}


>  #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 339742350b7a..34a420fa98c5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4394,6 +4394,97 @@ static u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
>  	return pin_based_exec_ctrl;
>  }
>  
> +static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)

This is a misleading and inaccurate name.  It does far more than "set" PERF_GLOBAL_CTRL,
it arguably doesn't ever "set" the MSR, and it gets the VMWRITE for the guest field
wrong too.

> +{
> +	u32 vmentry_ctrl = vm_entry_controls_get(vmx);
> +	u32 vmexit_ctrl = vm_exit_controls_get(vmx);
> +	struct vmx_msrs *m;
> +	int i;
> +
> +	if (cpu_has_perf_global_ctrl_bug() ||

Note, cpu_has_perf_global_ctrl_bug() broken and needs to be purged:
https://lore.kernel.org/all/20241119011433.1797921-1-seanjc@google.com

Note #2, as mentioned earlier, the mediated PMU should take a hard depenency on
the load/save controls.

On to this code, it fails to enable the load/save controls, e.g. if userspace
does KVM_SET_CPUID2 without a PMU, then KVM_SET_CPUID2 with a PMU.  In that case,
KVM will fail to set the control bits, and will fallback to the slow MSR load/save
lists.

With all of the above and other ideas combined, something like so:

	bool set = enable_mediated_pmu && kvm_pmu_has_perf_global_ctrl();

	vm_entry_controls_changebit(vmx, VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL, set);
	vm_exit_controls_changebit(vmx,
				   VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
				   VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL, set);


And I vote to put this in intel_pmu_refresh(); that avoids needing to figure out
a name for the helper, while giving more flexibililty on the local variable name.

Oh!  Definitely put it in intel_pmu_refresh(), because the RDPMC and MSR
interception logic needs to be there.  E.g. toggling CPU_BASED_RDPMC_EXITING
based solely on CPUID won't do the right thing if KVM ends up making the behavior
depend on PERF_CAPABILITIES.

Ditto for MSRs.  Though until my patch/series that drops kvm_pmu_refresh() from
kvm_pmu_init() lands[*], trying to update MSR intercepts during refresh() will hit
a NULL pointer deref as it's currently called before vmcs01 is allocated :-/

I expect to land that series before mediated PMU, but I don't think it makes sense
to take an explicit dependency for this series.  To fudge around the issue, maybe
do this for the next version?

static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
{
	__intel_pmu_refresh(vcpu);

	/*
	 * FIXME: Drop the MSR bitmap check if/when kvm_pmu_init() no longer
	 *        calls kvm_pmu_refresh(), i.e. when KVM refreshes the PMU only
	 *        after vmcs01 is allocated.
	 */
	if (to_vmx(vcpu)->vmcs01.msr_bitmap)
		intel_update_msr_intercepts(vcpu);

	vm_entry_controls_changebit(vmx, VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
				    enable_mediated_pmu && kvm_pmu_has_perf_global_ctrl());

	vm_exit_controls_changebit(vmx,
				   VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
				   VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL,
				   enable_mediated_pmu && kvm_pmu_has_perf_global_ctrl());
}

or with a local variable for "enable_mediated_pmu && kvm_pmu_has_perf_global_ctrl()".
I can't come up with a decent name. :-)

[*] https://lore.kernel.org/all/20240517173926.965351-10-seanjc@google.com

> +	    !is_passthrough_pmu_enabled(&vmx->vcpu)) {
> +		vmentry_ctrl &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> +		vmexit_ctrl &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> +		vmexit_ctrl &= ~VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL;
> +	}
> +
> +	if (is_passthrough_pmu_enabled(&vmx->vcpu)) {
> +		/*
> +		 * Setup auto restore guest PERF_GLOBAL_CTRL MSR at vm entry.
> +		 */
> +		if (vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) {
> +			vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, 0);

This incorrectly clobbers the guest's value.  A simple way to handle this is to
always propagate writes to PERF_GLOBAL_CTRL to the VMCS, if the write is allowed
and enable_mediated_pmu.  I.e. ensure GUEST_IA32_PERF_GLOBAL_CTRL is up-to-date
regardless of whether or not it's configured to be loaded.  Then there's no need
to write it here.

> +		} else {
> +			m = &vmx->msr_autoload.guest;
> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
> +			if (i < 0) {
> +				i = m->nr++;
> +				vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->nr);
> +			}
> +			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
> +			m->val[i].value = 0;
> +		}
> +		/*
> +		 * Setup auto clear host PERF_GLOBAL_CTRL msr at vm exit.
> +		 */
> +		if (vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) {
> +			vmcs_write64(HOST_IA32_PERF_GLOBAL_CTRL, 0);

This should be unnecessary.  KVM should clear HOST_IA32_PERF_GLOBAL_CTRL in
vmx_set_constant_host_state() if enable_mediated_pmu is true.  Arguably, it might
make sense to clear it unconditionally, but with a comment explaining that it's
only actually constant for the mediated PMU.

And if the mediated PMU requires the VMCS knobs, then all of the load/store list
complexity goes away.

>  static u32 vmx_vmentry_ctrl(void)
>  {
>  	u32 vmentry_ctrl = vmcs_config.vmentry_ctrl;
> @@ -4401,17 +4492,10 @@ static u32 vmx_vmentry_ctrl(void)
>  	if (vmx_pt_mode_is_system())
>  		vmentry_ctrl &= ~(VM_ENTRY_PT_CONCEAL_PIP |
>  				  VM_ENTRY_LOAD_IA32_RTIT_CTL);
> -	/*
> -	 * IA32e mode, and loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically.
> -	 */
> -	vmentry_ctrl &= ~(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
> -			  VM_ENTRY_LOAD_IA32_EFER |
> -			  VM_ENTRY_IA32E_MODE);
> -
> -	if (cpu_has_perf_global_ctrl_bug())
> -		vmentry_ctrl &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> -
> -	return vmentry_ctrl;
> +	 /*
> +	  * IA32e mode, and loading of EFER is toggled dynamically.
> +	  */
> +	return vmentry_ctrl &= ~(VM_ENTRY_LOAD_IA32_EFER | VM_ENTRY_IA32E_MODE);

With my above suggestion, these changes are unnecessary.  If enable_mediated_pmu
is false, or the vCPU doesn't have a PMU, clearing the controls is correct.  And
when the vCPU is gifted a PMU, KVM will explicitly enabled the controls.

To discourage incorrect usage of these helpers maybe rename them to
vmx_get_initial_{vmentry,vmexit}_ctrl()?

>  }
>  
>  static u32 vmx_vmexit_ctrl(void)
> @@ -4429,12 +4513,8 @@ static u32 vmx_vmexit_ctrl(void)
>  		vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
>  				 VM_EXIT_CLEAR_IA32_RTIT_CTL);
>  
> -	if (cpu_has_perf_global_ctrl_bug())
> -		vmexit_ctrl &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> -
> -	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
> -	return vmexit_ctrl &
> -		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);

But this code needs to *add* clearing of VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL.

