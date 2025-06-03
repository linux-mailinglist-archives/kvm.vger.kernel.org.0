Return-Path: <kvm+bounces-48248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AECFACBEF6
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 05:53:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAD94170124
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 03:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D98319DF62;
	Tue,  3 Jun 2025 03:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kxumlCYv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC0E1547CC;
	Tue,  3 Jun 2025 03:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748922781; cv=none; b=ZbkQ7kaluP7HyPxVDa1u/WyZLbw/bSQhz1Tvt1dREBhDCj+D+8pkl+v1HDm3wUAvSLc1kAHVuKFiEEXPTAv++MKgMz9Uqb3m7VtZJJJ4dCBmZoLungHRO/0bsp4659UPfEvtt1vld7+Sibh9ZXWnJ/NAwQjwI51h91zj28TqHyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748922781; c=relaxed/simple;
	bh=3GzzoqyGWJHpwlcI2zrvuLpf3wJOuywQpbyUpi19BI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f6NCTh7MXoC7aQer1TBbPQVS+FuWkzwqNw1DIb0xXgR2Z8AK3tszZKPD0qMdHoORvcI52qTWcrefIjWl06udL2tgjI8hqH14ba2iAk6DY/oFnl5+h9xYO3Zltc9m6RjQqMzOxSRHtLshZh2gttk+mZhJJQcyRqfcUKKJhhE2LMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kxumlCYv; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748922779; x=1780458779;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3GzzoqyGWJHpwlcI2zrvuLpf3wJOuywQpbyUpi19BI4=;
  b=kxumlCYvzVm14Cb8P7c+1Xvj7IVcfMjcLF/YQhjsE/4naT7y+htH12CV
   n7ul9T+IXFUE60WY/TgIB1b8elPmw4ktJW3nUOCIuKNp4Ql5HaXSJwzT1
   2pIGAxiu0uP1qN4inz+yI4/K2Rm9/s/tdpWAKpaC9K45Px/tMT18fRiyl
   UDE5YeBbymqOhID5xVWFdOG6+XT7RschfKY3J1UzNEZpylYZSY2xEwb0q
   /ulUPGQl/2Pzizd0ytWrV0JjSyvf81GxQ4AJBm53dZKboaswGT7on/mCp
   /suaQQx6X99tkzD3DvX4bQ6VURlF445mQvMPiLb977TRJVNH/Ijb72lhW
   g==;
X-CSE-ConnectionGUID: sJwiu5UgR6u1L6o219JPdQ==
X-CSE-MsgGUID: f2KhPDzsS9+PV0f5v6MlhA==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="51091618"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="51091618"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 20:52:58 -0700
X-CSE-ConnectionGUID: CHo+rePZQKqtYl6t+eFUHg==
X-CSE-MsgGUID: hdBp5Jv3QS2SZcW/zBEwBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="145064341"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 20:52:56 -0700
Message-ID: <e75da0ce-670a-4a01-b68a-81201babe1bf@linux.intel.com>
Date: Tue, 3 Jun 2025 11:52:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/28] KVM: VMX: Manually recalc all MSR intercepts on
 userspace MSR filter change
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>,
 Chao Gao <chao.gao@intel.com>
References: <20250529234013.3826933-1-seanjc@google.com>
 <20250529234013.3826933-17-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250529234013.3826933-17-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 5/30/2025 7:40 AM, Sean Christopherson wrote:
> On a userspace MSR filter change, recalculate all MSR intercepts using the
> filter-agnostic logic instead of maintaining a "shadow copy" of KVM's
> desired intercepts.  The shadow bitmaps add yet another point of failure,
> are confusing (e.g. what does "handled specially" mean!?!?), an eyesore,
> and a maintenance burden.
>
> Given that KVM *must* be able to recalculate the correct intercepts at any
> given time, and that MSR filter updates are not hot paths, there is zero
> benefit to maintaining the shadow bitmaps.
>
> Link: https://lore.kernel.org/all/aCdPbZiYmtni4Bjs@google.com
> Link: https://lore.kernel.org/all/20241126180253.GAZ0YNTdXH1UGeqsu6@fat_crate.local
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Xin Li <xin@zytor.com>
> Cc: Chao Gao <chao.gao@intel.com>
> Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 184 +++++++++++------------------------------
>  arch/x86/kvm/vmx/vmx.h |   7 --
>  2 files changed, 47 insertions(+), 144 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8f7fe04a1998..6ffa2b2b85ce 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -166,31 +166,6 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
>  	RTIT_STATUS_ERROR | RTIT_STATUS_STOPPED | \
>  	RTIT_STATUS_BYTECNT))
>  
> -/*
> - * List of MSRs that can be directly passed to the guest.
> - * In addition to these x2apic, PT and LBR MSRs are handled specially.
> - */
> -static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
> -	MSR_IA32_SPEC_CTRL,
> -	MSR_IA32_PRED_CMD,
> -	MSR_IA32_FLUSH_CMD,
> -	MSR_IA32_TSC,
> -#ifdef CONFIG_X86_64
> -	MSR_FS_BASE,
> -	MSR_GS_BASE,
> -	MSR_KERNEL_GS_BASE,
> -	MSR_IA32_XFD,
> -	MSR_IA32_XFD_ERR,
> -#endif
> -	MSR_IA32_SYSENTER_CS,
> -	MSR_IA32_SYSENTER_ESP,
> -	MSR_IA32_SYSENTER_EIP,
> -	MSR_CORE_C1_RES,
> -	MSR_CORE_C3_RESIDENCY,
> -	MSR_CORE_C6_RESIDENCY,
> -	MSR_CORE_C7_RESIDENCY,
> -};
> -
>  /*
>   * These 2 parameters are used to config the controls for Pause-Loop Exiting:
>   * ple_gap:    upper bound on the amount of time between two successive
> @@ -672,40 +647,6 @@ static inline bool cpu_need_virtualize_apic_accesses(struct kvm_vcpu *vcpu)
>  	return flexpriority_enabled && lapic_in_kernel(vcpu);
>  }
>  
> -static int vmx_get_passthrough_msr_slot(u32 msr)
> -{
> -	int i;
> -
> -	switch (msr) {
> -	case 0x800 ... 0x8ff:
> -		/* x2APIC MSRs. These are handled in vmx_update_msr_bitmap_x2apic() */
> -		return -ENOENT;
> -	case MSR_IA32_RTIT_STATUS:
> -	case MSR_IA32_RTIT_OUTPUT_BASE:
> -	case MSR_IA32_RTIT_OUTPUT_MASK:
> -	case MSR_IA32_RTIT_CR3_MATCH:
> -	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
> -		/* PT MSRs. These are handled in pt_update_intercept_for_msr() */
> -	case MSR_LBR_SELECT:
> -	case MSR_LBR_TOS:
> -	case MSR_LBR_INFO_0 ... MSR_LBR_INFO_0 + 31:
> -	case MSR_LBR_NHM_FROM ... MSR_LBR_NHM_FROM + 31:
> -	case MSR_LBR_NHM_TO ... MSR_LBR_NHM_TO + 31:
> -	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
> -	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
> -		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
> -		return -ENOENT;
> -	}
> -
> -	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++) {
> -		if (vmx_possible_passthrough_msrs[i] == msr)
> -			return i;
> -	}
> -
> -	WARN(1, "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);
> -	return -ENOENT;
> -}
> -
>  struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
>  {
>  	int i;
> @@ -4015,25 +3956,12 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> -	int idx;
>  
>  	if (!cpu_has_vmx_msr_bitmap())
>  		return;
>  
>  	vmx_msr_bitmap_l01_changed(vmx);
>  
> -	/*
> -	 * Mark the desired intercept state in shadow bitmap, this is needed
> -	 * for resync when the MSR filters change.
> -	 */
> -	idx = vmx_get_passthrough_msr_slot(msr);
> -	if (idx >= 0) {
> -		if (type & MSR_TYPE_R)
> -			__clear_bit(idx, vmx->shadow_msr_intercept.read);
> -		if (type & MSR_TYPE_W)
> -			__clear_bit(idx, vmx->shadow_msr_intercept.write);
> -	}
> -

The patch looks good to me. Only a minor code refine on
vmx_disable_intercept_for_msr().

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9a83d5b174c8..e898ff296fd5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4041,23 +4041,19 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu
*vcpu, u32 msr, int type)
                        clear_bit(idx, vmx->shadow_msr_intercept.write);
        }

-       if ((type & MSR_TYPE_R) &&
-           !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ)) {
-               vmx_set_msr_bitmap_read(msr_bitmap, msr);
-               type &= ~MSR_TYPE_R;
+       if (type & MSR_TYPE_R) {
+               if (!kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
+                       vmx_set_msr_bitmap_read(msr_bitmap, msr);
+               else
+                       vmx_clear_msr_bitmap_read(msr_bitmap, msr);
        }

-       if ((type & MSR_TYPE_W) &&
-           !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE)) {
-               vmx_set_msr_bitmap_write(msr_bitmap, msr);
-               type &= ~MSR_TYPE_W;
+       if (type & MSR_TYPE_W) {
+               if (!kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
+                       vmx_set_msr_bitmap_write(msr_bitmap, msr);
+               else
+                       vmx_clear_msr_bitmap_write(msr_bitmap, msr);
        }
-
-       if (type & MSR_TYPE_R)
-               vmx_clear_msr_bitmap_read(msr_bitmap, msr);
-
-       if (type & MSR_TYPE_W)
-               vmx_clear_msr_bitmap_write(msr_bitmap, msr);
 }

It looks simpler and easily understood.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



>  	if ((type & MSR_TYPE_R) &&
>  	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ)) {
>  		vmx_set_msr_bitmap_read(msr_bitmap, msr);
> @@ -4057,25 +3985,12 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> -	int idx;
>  
>  	if (!cpu_has_vmx_msr_bitmap())
>  		return;
>  
>  	vmx_msr_bitmap_l01_changed(vmx);
>  
> -	/*
> -	 * Mark the desired intercept state in shadow bitmap, this is needed
> -	 * for resync when the MSR filter changes.
> -	 */
> -	idx = vmx_get_passthrough_msr_slot(msr);
> -	if (idx >= 0) {
> -		if (type & MSR_TYPE_R)
> -			__set_bit(idx, vmx->shadow_msr_intercept.read);
> -		if (type & MSR_TYPE_W)
> -			__set_bit(idx, vmx->shadow_msr_intercept.write);
> -	}
> -
>  	if (type & MSR_TYPE_R)
>  		vmx_set_msr_bitmap_read(msr_bitmap, msr);
>  
> @@ -4159,35 +4074,59 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> -void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
> +static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>  {
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	u32 i;
> -
>  	if (!cpu_has_vmx_msr_bitmap())
>  		return;
>  
> -	/*
> -	 * Redo intercept permissions for MSRs that KVM is passing through to
> -	 * the guest.  Disabling interception will check the new MSR filter and
> -	 * ensure that KVM enables interception if usersepace wants to filter
> -	 * the MSR.  MSRs that KVM is already intercepting don't need to be
> -	 * refreshed since KVM is going to intercept them regardless of what
> -	 * userspace wants.
> -	 */
> -	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++) {
> -		u32 msr = vmx_possible_passthrough_msrs[i];
> -
> -		if (!test_bit(i, vmx->shadow_msr_intercept.read))
> -			vmx_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_R);
> -
> -		if (!test_bit(i, vmx->shadow_msr_intercept.write))
> -			vmx_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_W);
> +	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC, MSR_TYPE_R);
> +#ifdef CONFIG_X86_64
> +	vmx_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
> +	vmx_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
> +	vmx_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
> +#endif
> +	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
> +	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
> +	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
> +	if (kvm_cstate_in_guest(vcpu->kvm)) {
> +		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
> +		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
> +		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
> +		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
>  	}
>  
>  	/* PT MSRs can be passed through iff PT is exposed to the guest. */
>  	if (vmx_pt_mode_is_host_guest())
>  		pt_update_intercept_for_msr(vcpu);
> +
> +	if (vcpu->arch.xfd_no_write_intercept)
> +		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_XFD, MSR_TYPE_RW);
> +
> +
> +	vmx_set_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW,
> +				  !to_vmx(vcpu)->spec_ctrl);
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_XFD))
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R,
> +					  !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD));
> +
> +	if (boot_cpu_has(X86_FEATURE_IBPB))
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
> +					  !guest_has_pred_cmd_msr(vcpu));
> +
> +	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
> +					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
> +
> +	/*
> +	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
> +	 * filtered by userspace.
> +	 */
> +}
> +
> +void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
> +{
> +	vmx_recalc_msr_intercepts(vcpu);
>  }
>  
>  static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
> @@ -7537,26 +7476,6 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>  		evmcs->hv_enlightenments_control.msr_bitmap = 1;
>  	}
>  
> -	/* The MSR bitmap starts with all ones */
> -	bitmap_fill(vmx->shadow_msr_intercept.read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
> -	bitmap_fill(vmx->shadow_msr_intercept.write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
> -
> -	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC, MSR_TYPE_R);
> -#ifdef CONFIG_X86_64
> -	vmx_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
> -	vmx_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
> -	vmx_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
> -#endif
> -	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
> -	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
> -	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
> -	if (kvm_cstate_in_guest(vcpu->kvm)) {
> -		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
> -		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
> -		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
> -		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
> -	}
> -
>  	vmx->loaded_vmcs = &vmx->vmcs01;
>  
>  	if (cpu_need_virtualize_apic_accesses(vcpu)) {
> @@ -7842,18 +7761,6 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  		}
>  	}
>  
> -	if (kvm_cpu_cap_has(X86_FEATURE_XFD))
> -		vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R,
> -					  !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD));
> -
> -	if (boot_cpu_has(X86_FEATURE_IBPB))
> -		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
> -					  !guest_has_pred_cmd_msr(vcpu));
> -
> -	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
> -		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
> -					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
> -
>  	set_cr4_guest_host_mask(vmx);
>  
>  	vmx_write_encls_bitmap(vcpu, NULL);
> @@ -7869,6 +7776,9 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  		vmx->msr_ia32_feature_control_valid_bits &=
>  			~FEAT_CTL_SGX_LC_ENABLED;
>  
> +	/* Recalc MSR interception to account for feature changes. */
> +	vmx_recalc_msr_intercepts(vcpu);
> +
>  	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>  	vmx_update_exception_bitmap(vcpu);
>  }
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 0afe97e3478f..a26fe3d9e1d2 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -294,13 +294,6 @@ struct vcpu_vmx {
>  	struct pt_desc pt_desc;
>  	struct lbr_desc lbr_desc;
>  
> -	/* Save desired MSR intercept (read: pass-through) state */
> -#define MAX_POSSIBLE_PASSTHROUGH_MSRS	16
> -	struct {
> -		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
> -		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
> -	} shadow_msr_intercept;
> -
>  	/* ve_info must be page aligned. */
>  	struct vmx_ve_information *ve_info;
>  };

