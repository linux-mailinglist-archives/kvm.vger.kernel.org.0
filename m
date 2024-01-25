Return-Path: <kvm+bounces-6901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25AFF83B784
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:06:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4931F1C2342E
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE1896FCA;
	Thu, 25 Jan 2024 03:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lqJLYM9Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EF46FA7;
	Thu, 25 Jan 2024 03:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706151992; cv=none; b=czXtHBf2XN+dUHxGFxPBGKFSY03YkVICxXph2IhfLqNX6WCVarSgnI9gAZx6UzxVqsl6MLumrtXBtAP+uYbWPJPMkMwt0QvAURVrd/aicHGyIZbGwcMO1faQ/x84Y6I6dLF7zxtym+mclI/XW3Pn5I4+upqnEXNsXKF/+GAw5lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706151992; c=relaxed/simple;
	bh=3rJULeyM9xYbVpyP/NnT3ukU2TEBtC8bBU7bswXKk0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GdUULNeyB6b/+khdr1l9vczar9BvDU7UCtxjTKLCSwO1jzsPBGzrE8OUS19uQbWi+3ImJeS1d7anjWuVJF5JjeUca1f4+r24gziaF2upPD+Z1Xp4Zar3RaP2pBjOm54vALYg6LZBVeilczzel9g5tcrDcWpSELR92UPAbQVykbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lqJLYM9Q; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706151990; x=1737687990;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3rJULeyM9xYbVpyP/NnT3ukU2TEBtC8bBU7bswXKk0E=;
  b=lqJLYM9QC4bhGjd0y5znqUIeT1AYn7SW0Mv9bmQcuHRLJagpqOGNWIdk
   Z3pOG8X0kt+F3nJQV9SMD/7672Nj8UxcMhka3LmLTY2mkfC0qG9XIppLt
   T12Fd39itBq+R0mYtOiDVR0t4aQ3ZsVSbkAnJPFuIcMKV6gE3F+bg5gBN
   3S7m/h2PNMq/NgKrxKuslVXp7yJbZMReOJB6b3N2IGLj2cdmqttkKBmeY
   cc7sv1yH3JwgxnWqjNJdHrdFUWxlGanFEvABLocxkHjE/5dCMdI7YNTpU
   0hwpnUCPTM6rNBCacBQBIfKCSD7N4vzmCrSF2+h1RiqpzfcuKlEnEXv0Q
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="1884870"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="1884870"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:06:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2269262"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.49]) ([10.238.10.49])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:06:25 -0800
Message-ID: <49f044a1-e5ab-4a3d-8d73-67fa913e2948@linux.intel.com>
Date: Thu, 25 Jan 2024 11:06:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 029/121] KVM: TDX: create/free TDX vcpu structure
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <f857ba01c0b2ffbcc310727fd7a61599221c4f21.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <f857ba01c0b2ffbcc310727fd7a61599221c4f21.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> The next step of TDX guest creation is to create vcpu.  Create TDX vcpu
> structures, initialize it that doesn't require TDX SEAMCALL.  TDX specific
> vcpu initialization will be implemented as independent KVM_TDX_INIT_VCPU
> so that when error occurs it's easy to determine which component has the
> issue, KVM or TDX.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v18:
> - update commit log to use create instead of allocate because the patch
>    doesn't newly allocate memory for TDX vcpu.
>
> v15 -> v16:
> - Add AMX support as the KVM upstream supports it.
> ---
>   arch/x86/kvm/vmx/main.c    | 44 ++++++++++++++++++++++++++++++----
>   arch/x86/kvm/vmx/tdx.c     | 49 ++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h | 10 ++++++++
>   arch/x86/kvm/x86.c         |  2 ++
>   4 files changed, 101 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 50a1f50c0fc5..c2f1dc2000c5 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -102,6 +102,42 @@ static void vt_vm_free(struct kvm *kvm)
>   		tdx_vm_free(kvm);
>   }
>   
> +static int vt_vcpu_precreate(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return 0;
> +
> +	return vmx_vcpu_precreate(kvm);
> +}
> +
> +static int vt_vcpu_create(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_vcpu_create(vcpu);
> +
> +	return vmx_vcpu_create(vcpu);
> +}
> +
> +static void vt_vcpu_free(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_vcpu_free(vcpu);
> +		return;
> +	}
> +
> +	vmx_vcpu_free(vcpu);
> +}
> +
> +static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_vcpu_reset(vcpu, init_event);
> +		return;
> +	}
> +
> +	vmx_vcpu_reset(vcpu, init_event);
> +}
> +
>   static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	if (!is_td(kvm))
> @@ -140,10 +176,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.vm_destroy = vt_vm_destroy,
>   	.vm_free = vt_vm_free,
>   
> -	.vcpu_precreate = vmx_vcpu_precreate,
> -	.vcpu_create = vmx_vcpu_create,
> -	.vcpu_free = vmx_vcpu_free,
> -	.vcpu_reset = vmx_vcpu_reset,
> +	.vcpu_precreate = vt_vcpu_precreate,
> +	.vcpu_create = vt_vcpu_create,
> +	.vcpu_free = vt_vcpu_free,
> +	.vcpu_reset = vt_vcpu_reset,
>   
>   	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
>   	.vcpu_load = vmx_vcpu_load,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 1c6541789c39..8330f448ab8e 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -411,6 +411,55 @@ int tdx_vm_init(struct kvm *kvm)
>   	return 0;
>   }
>   
> +int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +
> +	/*
> +	 * On cpu creation, cpuid entry is blank.  Forcibly enable
> +	 * X2APIC feature to allow X2APIC.

This comment is a bit confusing.
Do you mean force x2apic here or elsewhere?
So far, in this patch, x2apic is not forced yet.

> +	 * Because vcpu_reset() can't return error, allocation is done here.

What do you mean "allocation" here?

> +	 */
> +	WARN_ON_ONCE(vcpu->arch.cpuid_entries);
> +	WARN_ON_ONCE(vcpu->arch.cpuid_nent);
> +
> +	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> +	if (!vcpu->arch.apic)
> +		return -EINVAL;
> +
> +	fpstate_set_confidential(&vcpu->arch.guest_fpu);
> +
> +	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
> +
> +	vcpu->arch.cr0_guest_owned_bits = -1ul;
> +	vcpu->arch.cr4_guest_owned_bits = -1ul;
> +
> +	vcpu->arch.tsc_offset = to_kvm_tdx(vcpu->kvm)->tsc_offset;
> +	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
> +	vcpu->arch.guest_state_protected =
> +		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);
> +
> +	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
> +		vcpu->arch.xfd_no_write_intercept = true;
> +
> +	return 0;
> +}
> +
> +void tdx_vcpu_free(struct kvm_vcpu *vcpu)
> +{
> +	/* This is stub for now.  More logic will come. */
> +}
> +
> +void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> +{
> +
> +	/* Ignore INIT silently because TDX doesn't support INIT event. */
> +	if (init_event)
> +		return;
> +
> +	/* This is stub for now. More logic will come here. */
> +}
> +
>   static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>   {
>   	struct kvm_tdx_capabilities __user *user_caps;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 645688081561..1ea532dfaf2a 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -144,7 +144,12 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>   int tdx_vm_init(struct kvm *kvm);
>   void tdx_mmu_release_hkid(struct kvm *kvm);
>   void tdx_vm_free(struct kvm *kvm);
> +
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
> +
> +int tdx_vcpu_create(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_free(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
>   #else
>   static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
>   static inline void tdx_hardware_unsetup(void) {}
> @@ -158,7 +163,12 @@ static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
>   static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
>   static inline void tdx_vm_free(struct kvm *kvm) {}
> +
>   static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
> +
> +static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
> +static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
> +static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
>   #endif
>   
>   #endif /* __KVM_X86_VMX_X86_OPS_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c5b66b493f1d..e0027134454c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -502,6 +502,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	kvm_recalculate_apic_map(vcpu->kvm);
>   	return 0;
>   }
> +EXPORT_SYMBOL_GPL(kvm_set_apic_base);
>   
>   /*
>    * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
> @@ -12488,6 +12489,7 @@ bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
>   {
>   	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
>   }
> +EXPORT_SYMBOL_GPL(kvm_vcpu_is_reset_bsp);
>   
>   bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
>   {


