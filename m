Return-Path: <kvm+bounces-65497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B2543CACC23
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 10:53:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C1264301EFD3
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 09:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C808312813;
	Mon,  8 Dec 2025 09:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bG6XJnnX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346703101B4;
	Mon,  8 Dec 2025 09:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765186771; cv=none; b=DkAwoxo5DPMq9QpWBnUU6RmOPj0fFrKrVovC9HGSTuoh5vLIMskorXugQVR5QcELzBM31kmEPTY+VYbbnJqmLup0k66T8QCzvPEcdp7vFpiWStwsh+iEHq9Xop3PAeWdcvk/yxFI+3AtmXIjWhBEybuYDySIVWOfV8MLUL1vIyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765186771; c=relaxed/simple;
	bh=p82IBGZ4j1jkt4NBfcu7z7d/63zqeo9G4reT2I4uWDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d9UFDUGtNIm0Yjj2ZQnR6iF7XvTmwo8Af6RqFfrn8ywFfWuy2lz1XnndoAOMS72JfdDFMp8m9SdHh/amwiYyoq7iP/TdOJCtH6R/+Nf2EUtC+a5nWpFAixBsQ/+F0ZRml+OtxEXEkeQdDgKPdgu4r+KkcLPqaTbZ625QP2wTjpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bG6XJnnX; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765186770; x=1796722770;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=p82IBGZ4j1jkt4NBfcu7z7d/63zqeo9G4reT2I4uWDo=;
  b=bG6XJnnX+Nxb7n0oaV51zT1rfX+SYGcj9o2feEPxMCrKVgwOkuR/8cPU
   NfHabVf6goXRAMKk6MB2uTA4wxWIdbifAomscOO50ZJhYEINweqd9q9YX
   9TN+OsQQSsNp02Zbh3EOqnLp/liKYNljyVf3HmXeGN7zEzuPVtIq4Buok
   N5x54PejBfAbkwU7FyyfQ2lCqm5Th+NgKXj5OvHWW7BR2nB0U0QhmRSoY
   wAzLVtaU1HmmFTWbKa7qE/N+GfG3oVrnPcsmpypaLFjwMvCH4Jjtc/Y4g
   4NCSjwoqMele5Cjb3Shexi6CQQuLQUsyiDfoj3qeRgw0ej3Y1DYptHm+C
   g==;
X-CSE-ConnectionGUID: 8JOBxIXDTEu6LjDjXjENiA==
X-CSE-MsgGUID: PkM177UKTsesHfbGKp9Rjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="84532307"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="84532307"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:39:29 -0800
X-CSE-ConnectionGUID: RUNkPscvTKK1RrxIzPPi5w==
X-CSE-MsgGUID: ZP9ZxvGjQRmDCWEnSrL+eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="200807599"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.12]) ([10.124.240.12])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:39:21 -0800
Message-ID: <ee30ed9c-6377-4d14-b930-f0e2c809df7c@linux.intel.com>
Date: Mon, 8 Dec 2025 17:39:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 44/44] KVM: VMX: Add mediated PMU support for CPUs
 without "save perf global ctrl"
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Mingwei Zhang <mizhang@google.com>, Xudong Hao <xudong.hao@intel.com>,
 Sandipan Das <sandipan.das@amd.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
References: <20251206001720.468579-1-seanjc@google.com>
 <20251206001720.468579-45-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20251206001720.468579-45-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 12/6/2025 8:17 AM, Sean Christopherson wrote:
> Extend mediated PMU support for Intel CPUs without support for saving
> PERF_GLOBAL_CONTROL into the guest VMCS field on VM-Exit, e.g. for Skylake
> and its derivatives, as well as Icelake.  While supporting CPUs without
> VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL isn't completely trivial, it's not that
> complex either.  And not supporting such CPUs would mean not supporting 7+
> years of Intel CPUs released in the past 10 years.
>
> On VM-Exit, immediately propagate the saved PERF_GLOBAL_CTRL to the VMCS
> as well as KVM's software cache so that KVM doesn't need to add full EXREG
> tracking of PERF_GLOBAL_CTRL.  In practice, the vast majority of VM-Exits
> won't trigger software writes to guest PERF_GLOBAL_CTRL, so deferring the
> VMWRITE to the next VM-Enter would only delay the inevitable without
> batching/avoiding VMWRITEs.
>
> Note!  Take care to refresh VM_EXIT_MSR_STORE_COUNT on nested VM-Exit, as
> it's unfortunately possible that KVM could recalculate MSR intercepts
> while L2 is active, e.g. if userspace loads nested state and _then_ sets
> PERF_CAPABILITIES.  Eating the VMWRITE on every nested VM-Exit is
> unfortunate, but that's a pre-existing problem and can/should be solved
> separately, e.g. modifying the number of auto-load entries while L2 is
> active is also uncommon on modern CPUs.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c    |  6 ++++-
>  arch/x86/kvm/vmx/pmu_intel.c |  7 -----
>  arch/x86/kvm/vmx/vmx.c       | 52 ++++++++++++++++++++++++++++++++----
>  3 files changed, 52 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 614b789ecf16..1ee1edc8419d 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5142,7 +5142,11 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>  
>  	kvm_nested_vmexit_handle_ibrs(vcpu);
>  
> -	/* Update any VMCS fields that might have changed while L2 ran */
> +	/*
> +	 * Update any VMCS fields that might have changed while vmcs02 was the
> +	 * active VMCS.  The tracking is per-vCPU, not per-VMCS.
> +	 */
> +	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, vmx->msr_autostore.nr);
>  	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
>  	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
>  	vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 55249fa4db95..27eb76e6b6a0 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -777,13 +777,6 @@ static bool intel_pmu_is_mediated_pmu_supported(struct x86_pmu_capability *host_
>  	if (WARN_ON_ONCE(!cpu_has_load_perf_global_ctrl()))
>  		return false;
>  
> -	/*
> -	 * KVM doesn't yet support mediated PMU on CPUs without support for
> -	 * saving PERF_GLOBAL_CTRL via a dedicated VMCS field.
> -	 */
> -	if (!cpu_has_save_perf_global_ctrl())
> -		return false;
> -
>  	return true;
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6a17cb90eaf4..ba1262c3e3ff 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1204,6 +1204,17 @@ static bool update_transition_efer(struct vcpu_vmx *vmx)
>  	return true;
>  }
>  
> +static void vmx_add_autostore_msr(struct vcpu_vmx *vmx, u32 msr)
> +{
> +	vmx_add_auto_msr(&vmx->msr_autostore, msr, 0, VM_EXIT_MSR_STORE_COUNT,
> +			 vmx->vcpu.kvm);
> +}
> +
> +static void vmx_remove_autostore_msr(struct vcpu_vmx *vmx, u32 msr)
> +{
> +	vmx_remove_auto_msr(&vmx->msr_autostore, msr, VM_EXIT_MSR_STORE_COUNT);
> +}
> +
>  #ifdef CONFIG_X86_32
>  /*
>   * On 32-bit kernels, VM exits still load the FS and GS bases from the
> @@ -4225,6 +4236,8 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
>  
>  static void vmx_recalc_pmu_msr_intercepts(struct kvm_vcpu *vcpu)
>  {
> +	u64 vm_exit_controls_bits = VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
> +				    VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL;
>  	bool has_mediated_pmu = kvm_vcpu_has_mediated_pmu(vcpu);
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -4234,12 +4247,19 @@ static void vmx_recalc_pmu_msr_intercepts(struct kvm_vcpu *vcpu)
>  	if (!enable_mediated_pmu)
>  		return;
>  
> +	if (!cpu_has_save_perf_global_ctrl()) {
> +		vm_exit_controls_bits &= ~VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL;
> +
> +		if (has_mediated_pmu)
> +			vmx_add_autostore_msr(vmx, MSR_CORE_PERF_GLOBAL_CTRL);
> +		else
> +			vmx_remove_autostore_msr(vmx, MSR_CORE_PERF_GLOBAL_CTRL);
> +	}
> +
>  	vm_entry_controls_changebit(vmx, VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
>  				    has_mediated_pmu);
>  
> -	vm_exit_controls_changebit(vmx, VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
> -					VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL,
> -				   has_mediated_pmu);
> +	vm_exit_controls_changebit(vmx, vm_exit_controls_bits, has_mediated_pmu);
>  
>  	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
>  		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PERFCTR0 + i,
> @@ -7346,6 +7366,29 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>  					      msrs[i].host);
>  }
>  
> +static void vmx_refresh_guest_perf_global_control(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +	if (msr_write_intercepted(vmx, MSR_CORE_PERF_GLOBAL_CTRL))
> +		return;
> +
> +	if (!cpu_has_save_perf_global_ctrl()) {
> +		int slot = vmx_find_loadstore_msr_slot(&vmx->msr_autostore,
> +						       MSR_CORE_PERF_GLOBAL_CTRL);
> +
> +		if (WARN_ON_ONCE(slot < 0))
> +			return;
> +
> +		pmu->global_ctrl = vmx->msr_autostore.val[slot].value;
> +		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, pmu->global_ctrl);
> +		return;
> +	}
> +
> +	pmu->global_ctrl = vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL);
> +}
> +
>  static void vmx_update_hv_timer(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -7631,8 +7674,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
>  
>  	vmx->loaded_vmcs->launched = 1;
>  
> -	if (!msr_write_intercepted(vmx, MSR_CORE_PERF_GLOBAL_CTRL))
> -		vcpu_to_pmu(vcpu)->global_ctrl = vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL);
> +	vmx_refresh_guest_perf_global_control(vcpu);
>  
>  	vmx_recover_nmi_blocking(vmx);
>  	vmx_complete_interrupts(vmx);

The change looks good to me, but I still have no bandwidth to test the code
on Ice lake, I would go back after I finish the tests. Thanks.



