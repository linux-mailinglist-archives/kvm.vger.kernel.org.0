Return-Path: <kvm+bounces-24478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E847B9560E3
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 03:22:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0042281944
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 01:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD5751C6A8;
	Mon, 19 Aug 2024 01:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BMGu/kiQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E777522F19;
	Mon, 19 Aug 2024 01:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724030547; cv=none; b=QclHTxmksIStpdOcO8i4S8W0cSfakiERfkYX0WWZwHjA3QzKHMow8uy0JZM7tsauJ5Nac75HXPOO20ZcTiAwUw4axRkCPUNzHYxEDGvHzGNLATxXreb8E41TWlgOTey3X9+1F/aUPZWcSaif1V3J//EcSlKvkLQ1WDpLHn6lF5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724030547; c=relaxed/simple;
	bh=pFAiDn+2JIcEC9UJ62RC7SxPm5KhMUI5vx7Q+nPpyNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uShPQJcOTRMU3NutJVW8GrOKenzUZ47fOAA51mlujPVZafH8QuYBLi3O9fn8o9GoazPC7VLUh4U5vZgmrb3OXWdrEcJu/WH4b50ZrvjDOdpRO18OIRldSGvdPR2+hYm1N6vNPcweh7GJwCdNHF9iiNWuBhyjS3Bwv6sTsvDj+Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BMGu/kiQ; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724030546; x=1755566546;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pFAiDn+2JIcEC9UJ62RC7SxPm5KhMUI5vx7Q+nPpyNs=;
  b=BMGu/kiQU+Ik2cS2mNs170rg8z4nzytNSZAsj1j6Cy6BdOaOApgcUYqF
   r+zJLxq2jZn3a0dEc8Itnv9nvVAdfTrOyzu8Tx8UyMz08aN0oRhkPlGYc
   SFejSrGXBN6CU7RpNEciNtZ/Nq29XnasuhEChzwqc0CgqF0hkLoteE896
   YOIZyPJMH9SbatpB3ey+UGt2XujHPB2tr1TETILVyuSBtPShstOPnq3EO
   GnE1j3Y+Oo7qKQA+gnP/VEJW6kEF+K+KVoCbJl5NtRuBmYLjzAFv1McRm
   xy/wigyeDiTCc/mOjPSyJu0UUYTLeW2gMOifq8CNbqIHj01VGGhbMBGmx
   g==;
X-CSE-ConnectionGUID: z5MC58iCQ0C+CVtbgaszKg==
X-CSE-MsgGUID: AUY9mX9oRCmD+J87DLyMCw==
X-IronPort-AV: E=McAfee;i="6700,10204,11168"; a="26051222"
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="26051222"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2024 18:22:25 -0700
X-CSE-ConnectionGUID: p57hoqnQR2Sr7OPZ28zoHw==
X-CSE-MsgGUID: LZ8YWdT3Tu27Ybx2NfDK3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,158,1719903600"; 
   d="scan'208";a="60370379"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2024 18:22:22 -0700
Date: Mon, 19 Aug 2024 09:17:10 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kai.huang@intel.com, isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH 12/25] KVM: TDX: Allow userspace to configure maximum
 vCPUs for TDX guests
Message-ID: <ZsKdFu9KTdoLJEBV@linux.bj.intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-13-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812224820.34826-13-rick.p.edgecombe@intel.com>

On Mon, Aug 12, 2024 at 03:48:07PM -0700, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX has its own mechanism to control the maximum number of vCPUs that
> the TDX guest can use.  When creating a TDX guest, the maximum number of
> vCPUs of the guest needs to be passed to the TDX module as part of the
> measurement of the guest.  Depending on TDX module's version, it may
> also report the maximum vCPUs it can support for all TDX guests.
> 
> Because the maximum number of vCPUs is part of the measurement, thus
> part of attestation, it's better to allow the userspace to be able to
> configure it.  E.g. the users may want to precisely control the maximum
> number of vCPUs their precious VMs can use.
> 
> The actual control itself must be done via the TDH.MNG.INIT SEAMCALL,
> where the number of maximum cpus is part of the input to the TDX module,
> but KVM needs to support the "per-VM maximum number of vCPUs" and
> reflect that in the KVM_CAP_MAX_VCPUS.
> 
> Currently, the KVM x86 always reports KVM_MAX_VCPUS for all VMs but
> doesn't allow to enable KVM_CAP_MAX_VCPUS to configure the number of
> maximum vCPUs on VM-basis.
> 
> Add "per-VM maximum number of vCPUs" to KVM x86/TDX to accommodate TDX's
> needs.
> 
> Specifically, use KVM's existing KVM_ENABLE_CAP IOCTL() to allow the
> userspace to configure the maximum vCPUs by making KVM x86 support
> enabling the KVM_CAP_MAX_VCPUS cap on VM-basis.
> 
> For that, add a new 'kvm_x86_ops::vm_enable_cap()' callback and call
> it from kvm_vm_ioctl_enable_cap() as a placeholder to handle the
> KVM_CAP_MAX_VCPUS for TDX guests (and other KVM_CAP_xx for TDX and/or
> other VMs if needed in the future).
> 
> Implement the callback for TDX guest to check whether the maximum vCPUs
> passed from usrspace can be supported by TDX, and if it can, override
> the 'struct kvm::max_vcpus'.  Leave VMX guests and all AMD guests
> unsupported to avoid any side-effect for those VMs.
> 
> Accordingly, in the KVM_CHECK_EXTENSION IOCTL(), change to return the
> 'struct kvm::max_vcpus' for a given VM for the KVM_CAP_MAX_VCPUS.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> uAPI breakout v1:
>  - Change to use exported 'struct tdx_sysinfo' pointer.
>  - Remove the code to read 'max_vcpus_per_td' since it is now done in
>    TDX host code.
>  - Drop max_vcpu ops to use kvm.max_vcpus
>  - Remove TDX_MAX_VCPUS (Kai)
>  - Use type cast (u16) instead of calling memcpy() when reading the
>    'max_vcpus_per_td' (Kai)
>  - Improve change log and change patch title from "KVM: TDX: Make
>    KVM_CAP_MAX_VCPUS backend specific" (Kai)
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/vmx/main.c            | 10 ++++++++++
>  arch/x86/kvm/vmx/tdx.c             | 29 +++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/x86_ops.h         |  5 +++++
>  arch/x86/kvm/x86.c                 |  4 ++++
>  6 files changed, 50 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 538f50eee86d..bd7434fe5d37 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -19,6 +19,7 @@ KVM_X86_OP(hardware_disable)
>  KVM_X86_OP(hardware_unsetup)
>  KVM_X86_OP(has_emulated_msr)
>  KVM_X86_OP(vcpu_after_set_cpuid)
> +KVM_X86_OP_OPTIONAL(vm_enable_cap)
>  KVM_X86_OP(vm_init)
>  KVM_X86_OP_OPTIONAL(vm_destroy)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c754183e0932..9d15f810f046 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1648,6 +1648,7 @@ struct kvm_x86_ops {
>  	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
>  
>  	unsigned int vm_size;
> +	int (*vm_enable_cap)(struct kvm *kvm, struct kvm_enable_cap *cap);
>  	int (*vm_init)(struct kvm *kvm);
>  	void (*vm_destroy)(struct kvm *kvm);
>  
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 59f4d2d42620..cd53091ddaab 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -7,6 +7,7 @@
>  #include "pmu.h"
>  #include "posted_intr.h"
>  #include "tdx.h"
> +#include "tdx_arch.h"
>  
>  static __init int vt_hardware_setup(void)
>  {
> @@ -41,6 +42,14 @@ static __init int vt_hardware_setup(void)
>  	return 0;
>  }
>  
> +static int vt_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +	if (is_td(kvm))
> +		return tdx_vm_enable_cap(kvm, cap);
> +
> +	return -EINVAL;
> +}
> +
>  static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	if (!is_td(kvm))
> @@ -72,6 +81,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.has_emulated_msr = vmx_has_emulated_msr,
>  
>  	.vm_size = sizeof(struct kvm_vmx),
> +	.vm_enable_cap = vt_vm_enable_cap,
>  	.vm_init = vmx_vm_init,
>  	.vm_destroy = vmx_vm_destroy,
>  
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index f9faec217ea9..84cd9b4f90b5 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -44,6 +44,35 @@ struct kvm_tdx_caps {
>  
>  static struct kvm_tdx_caps *kvm_tdx_caps;
>  
> +int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +	int r;
> +
> +	switch (cap->cap) {
> +	case KVM_CAP_MAX_VCPUS: {

How about delete the curly braces on the case?

> +		if (cap->flags || cap->args[0] == 0)
> +			return -EINVAL;
> +		if (cap->args[0] > KVM_MAX_VCPUS ||
> +		    cap->args[0] > tdx_sysinfo->td_conf.max_vcpus_per_td)
> +			return -E2BIG;
> +
> +		mutex_lock(&kvm->lock);
> +		if (kvm->created_vcpus)
> +			r = -EBUSY;
> +		else {
> +			kvm->max_vcpus = cap->args[0];
> +			r = 0;
> +		}
> +		mutex_unlock(&kvm->lock);
> +		break;
> +	}
> +	default:
> +		r = -EINVAL;
> +		break;
> +	}
> +	return r;
> +}
> +
>  static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>  {
>  	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index c69ca640abe6..c1bdf7d8fee3 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -119,8 +119,13 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
>  void vmx_setup_mce(struct kvm_vcpu *vcpu);
>  
>  #ifdef CONFIG_INTEL_TDX_HOST
> +int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>  #else
> +static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +	return -EINVAL;
> +};
>  static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>  #endif
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7914ea50fd04..751b3841c48f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4754,6 +4754,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		break;
>  	case KVM_CAP_MAX_VCPUS:
>  		r = KVM_MAX_VCPUS;
> +		if (kvm)
> +			r = kvm->max_vcpus;
>  		break;
>  	case KVM_CAP_MAX_VCPU_ID:
>  		r = KVM_MAX_VCPU_IDS;
> @@ -6772,6 +6774,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  	}
>  	default:
>  		r = -EINVAL;
> +		if (kvm_x86_ops.vm_enable_cap)
> +			r = static_call(kvm_x86_vm_enable_cap)(kvm, cap);

Can we use kvm_x86_call(vm_enable_cap)(kvm, cap)? Patch18 has similar situation
for "vcpu_mem_enc_ioctl", maybe we can also use kvm_x86_call there if static
call optimization is needed.

>  		break;
>  	}
>  	return r;
> -- 
> 2.34.1
> 
> 

