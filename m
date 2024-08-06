Return-Path: <kvm+bounces-23313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 395999489B7
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 09:04:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D57F1C23000
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 07:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE3AB15B11E;
	Tue,  6 Aug 2024 07:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eSv38iX8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E767EB663;
	Tue,  6 Aug 2024 07:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722927853; cv=none; b=HryYDIL177Rwpl1rQRMnEUjixI35ezBIz3sTuUl8fcqbfRbha84GWYxTe1hc3f8phpirvy6pPV9vC6wVl5d5yBaXLN6SVfaRUY5jdeLFjNa0p4twrfrNg4zG5vTRmJguIk3mhybfne0qsHCAG9L9xZ5e7ygIedp5o0MuqU8CPzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722927853; c=relaxed/simple;
	bh=n9b/XZZyEMb4JIJ0ueITU4YypOous9FPGDk4b2QFECw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S4d76i2X/FsG9CuXVipVsgmyU7wP6SMXD74IWgWFXk+EGybm3YsiNz4Hep5iPR+Bo3oW9iPKxwdTWsjvOAKIMlgwxNhWZyyNOud+SXHrYFE25AFR1gj9JWaVCuaeH2ASCO3Jd1NeRjRDZt8MwbPxcjYkRXGyRZovKr8APj86kMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eSv38iX8; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722927851; x=1754463851;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=n9b/XZZyEMb4JIJ0ueITU4YypOous9FPGDk4b2QFECw=;
  b=eSv38iX8yjEoMy/xGN1k3ZCPC5BonFqpiGUg0GgS9sKT/9HwoeVSg5WS
   TuOv7QAzpDaNrAO1qlSXgt3OmkfYmyAo8V8bWYCYGcQE41OEDasbD+JSA
   Z/1zjgYDBxLbfUQ95J6Pntc62+/D5UDycwjzFssoYyFUebS/ms2Y16J8n
   ZcxClpZNqY76MiNd23so532NcYSB2eoVwlyTFVFi3lfgRK/nm/kKoTffm
   ZhAVK5MImgSxvE82wJpQX5FzCfbMqHHmn3G+adUZZ6s1Q71lESjWNPWAf
   0SUeLx/Q8qpd9/oYeIk+pnd5i2LYXMu+feBhqyL/VbdwCkzSqvywQzShd
   g==;
X-CSE-ConnectionGUID: lhDt0/RVQ/KaG1dHQVpTLQ==
X-CSE-MsgGUID: 4DYdaAHZSbOP6y2g9c172Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="24789344"
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="24789344"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2024 00:04:10 -0700
X-CSE-ConnectionGUID: e4Tv2qY+R8WFvTvmSq6+Iw==
X-CSE-MsgGUID: bfD7wjf6T06D3rb0aNWGuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="56351604"
Received: from unknown (HELO [10.238.3.66]) ([10.238.3.66])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2024 00:04:06 -0700
Message-ID: <6e5d171e-b821-4636-be8f-71d90447cc2c@linux.intel.com>
Date: Tue, 6 Aug 2024 15:04:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 26/58] KVM: x86/pmu: Manage MSR interception for
 IA32_PERF_GLOBAL_CTRL
To: Mingwei Zhang <mizhang@google.com>,
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
 <20240801045907.4010984-27-mizhang@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240801045907.4010984-27-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 8/1/2024 12:58 PM, Mingwei Zhang wrote:
> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>
> In PMU passthrough mode, there are three requirements to manage
> IA32_PERF_GLOBAL_CTRL:
>  - guest IA32_PERF_GLOBAL_CTRL MSR must be saved at vm exit.
>  - IA32_PERF_GLOBAL_CTRL MSR must be cleared at vm exit to avoid any
>    counter of running within KVM runloop.
>  - guest IA32_PERF_GLOBAL_CTRL MSR must be restored at vm entry.
>
> Introduce vmx_set_perf_global_ctrl() function to auto switching
> IA32_PERF_GLOBAL_CTR and invoke it after the VMM finishes setting up the
> CPUID bits.
>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
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
>  
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
> +{
> +	u32 vmentry_ctrl = vm_entry_controls_get(vmx);
> +	u32 vmexit_ctrl = vm_exit_controls_get(vmx);
> +	struct vmx_msrs *m;
> +	int i;
> +
> +	if (cpu_has_perf_global_ctrl_bug() ||
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
> +		} else {
> +			m = &vmx->msr_autoload.guest;
> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
> +			if (i < 0) {
> +				i = m->nr++;
> +				vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->nr);
> +			}
> +			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
> +			m->val[i].value = 0;

This function has much duplicated code to initialize/clear MSR
autoload/restore region, we may create two simple helpers to avoid these
duplicated code.

static inline void vmx_init_loadstore_msr(struct vmx_msrs *m, int idx, bool
load);

static inline void vmx_clear_loadstore_msr(struct vmx_msrs *m, int idx,
bool load);


> +		}
> +		/*
> +		 * Setup auto clear host PERF_GLOBAL_CTRL msr at vm exit.
> +		 */
> +		if (vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) {
> +			vmcs_write64(HOST_IA32_PERF_GLOBAL_CTRL, 0);
> +		} else {
> +			m = &vmx->msr_autoload.host;
> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
> +			if (i < 0) {
> +				i = m->nr++;
> +				vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->nr);
> +			}
> +			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
> +			m->val[i].value = 0;
> +		}
> +		/*
> +		 * Setup auto save guest PERF_GLOBAL_CTRL msr at vm exit
> +		 */
> +		if (!(vmexit_ctrl & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL)) {
> +			m = &vmx->msr_autostore.guest;
> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
> +			if (i < 0) {
> +				i = m->nr++;
> +				vmcs_write32(VM_EXIT_MSR_STORE_COUNT, m->nr);
> +			}
> +			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
> +		}
> +	} else {
> +		if (!(vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)) {
> +			m = &vmx->msr_autoload.guest;
> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
> +			if (i >= 0) {
> +				m->nr--;
> +				m->val[i] = m->val[m->nr];
> +				vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->nr);
> +			}
> +		}
> +		if (!(vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)) {
> +			m = &vmx->msr_autoload.host;
> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
> +			if (i >= 0) {
> +				m->nr--;
> +				m->val[i] = m->val[m->nr];
> +				vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->nr);
> +			}
> +		}
> +		if (!(vmexit_ctrl & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL)) {
> +			m = &vmx->msr_autostore.guest;
> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
> +			if (i >= 0) {
> +				m->nr--;
> +				m->val[i] = m->val[m->nr];
> +				vmcs_write32(VM_EXIT_MSR_STORE_COUNT, m->nr);
> +			}
> +		}
> +	}
> +
> +	vm_entry_controls_set(vmx, vmentry_ctrl);
> +	vm_exit_controls_set(vmx, vmexit_ctrl);
> +}
> +
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
> +	/* Loading of EFER is toggled dynamically */
> +	return vmexit_ctrl & ~VM_EXIT_LOAD_IA32_EFER;
>  }
>  
>  void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> @@ -4777,6 +4857,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>  		vmcs_write64(VM_FUNCTION_CONTROL, 0);
>  
>  	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
> +	vmcs_write64(VM_EXIT_MSR_STORE_ADDR, __pa(vmx->msr_autostore.guest.val));
>  	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, 0);
>  	vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.host.val));
>  	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 0);
> @@ -7916,6 +7997,8 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	else
>  		exec_controls_setbit(vmx, CPU_BASED_RDPMC_EXITING);
>  
> +	vmx_set_perf_global_ctrl(vmx);
> +
>  	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>  	vmx_update_exception_bitmap(vcpu);
>  }
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 7b64e271a931..32e3974c1a2c 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -510,7 +510,8 @@ static inline u8 vmx_get_rvi(void)
>  	       VM_EXIT_LOAD_IA32_EFER |					\
>  	       VM_EXIT_CLEAR_BNDCFGS |					\
>  	       VM_EXIT_PT_CONCEAL_PIP |					\
> -	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
> +	       VM_EXIT_CLEAR_IA32_RTIT_CTL |                            \
> +	       VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL)
>  
>  #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
>  	(PIN_BASED_EXT_INTR_MASK |					\

