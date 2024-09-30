Return-Path: <kvm+bounces-27662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 00DE198993A
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 04:26:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8994E1F212C8
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 02:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31D6F1CD2B;
	Mon, 30 Sep 2024 02:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fn4WWsWb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB07A3C39;
	Mon, 30 Sep 2024 02:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727663204; cv=none; b=RV2QxMDKK9LHFjXs6VyRk+OXXu/Q4hqBrb+elWRjUgXw2w5BOL3Ns+e7pKMbxqseVXUn1db7t+PtbeqY+iJQKTilbMFydZ5kuCqhyaDmrPa2kU6qslJ7pV6NjlqrdvztDvCwhzg8AsiwGCoLk28jbZ3zg7zYaL2CzPeCUYQS5Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727663204; c=relaxed/simple;
	bh=hmNJH608TMoKPUAnPh5uHKWvVcuJ3QWR7sKD5rQ5lUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KZ2a73ZU/8au2jv/+/e5b7b000MBi3NfP/Se+/fZmKESn5mK9dSWWGejXPjrQupQYyJc7o3PMLzy+F7iEBDaLao9LjBvfKcsuPjJLymqhfyVI6Es1QG/FAE/owwGGOvh4p7VB4jcUQtMU6wHTq5KNG2ScKLuBcfpMXfg08Qt78U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fn4WWsWb; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727663202; x=1759199202;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hmNJH608TMoKPUAnPh5uHKWvVcuJ3QWR7sKD5rQ5lUg=;
  b=fn4WWsWbbIUW/P7gawTMDUCt8jkAVzPWk7CmptNMu3WcyUAumqorZbAp
   AAmq0T9DCTVuv31Z8MFgicrm0MgM4HvexrmlHIlcRQOuh2MNCus+70Ccb
   TtD6IHPAL7ZaPGBXHLwDM6LZTk7IHaR0LWs7Zo08Zo/3Pt1SK0AWmHSAI
   g8Kcp6UjEXpofGFN/Bib8Z2kgKtCwiCxO19GD0sbVdDuD0D/N3orBYuOt
   3kvcTYQdmTOqA541U9pdL340+v/tNZKFz2jK+SqGB+nDGNgum0ChL4cTt
   SYjrfBz0gNgelkCwEHYPveOvx8codX2weA64OlCURGA+oXhvMUb8Fhnsy
   w==;
X-CSE-ConnectionGUID: Zc2j4Kv5Suebr4QafrdDtw==
X-CSE-MsgGUID: zyYeGEDOR4SbXe4nDQTsgg==
X-IronPort-AV: E=McAfee;i="6700,10204,11210"; a="30616147"
X-IronPort-AV: E=Sophos;i="6.11,164,1725346800"; 
   d="scan'208";a="30616147"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2024 19:26:42 -0700
X-CSE-ConnectionGUID: sY2Ruv0vQBegf2ztW3zUQA==
X-CSE-MsgGUID: uIzMYVhzSUCnXb63L40rUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,164,1725346800"; 
   d="scan'208";a="72814145"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.247.52]) ([10.125.247.52])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2024 19:14:04 -0700
Message-ID: <963c40a1-5ad9-4e25-b719-9cb1d98f5122@intel.com>
Date: Mon, 30 Sep 2024 10:14:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/25] KVM: TDX: Allow userspace to configure maximum
 vCPUs for TDX guests
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, linux-kernel@vger.kernel.org,
 Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-13-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240812224820.34826-13-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/2024 6:48 AM, Rick Edgecombe wrote:
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

The implementation of this patch should be dropped in next version and 
be replaced with something suggested in
https://lore.kernel.org/kvm/ZmzaqRy2zjvlsDfL@google.com/

> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> uAPI breakout v1:
>   - Change to use exported 'struct tdx_sysinfo' pointer.
>   - Remove the code to read 'max_vcpus_per_td' since it is now done in
>     TDX host code.
>   - Drop max_vcpu ops to use kvm.max_vcpus
>   - Remove TDX_MAX_VCPUS (Kai)
>   - Use type cast (u16) instead of calling memcpy() when reading the
>     'max_vcpus_per_td' (Kai)
>   - Improve change log and change patch title from "KVM: TDX: Make
>     KVM_CAP_MAX_VCPUS backend specific" (Kai)
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |  1 +
>   arch/x86/include/asm/kvm_host.h    |  1 +
>   arch/x86/kvm/vmx/main.c            | 10 ++++++++++
>   arch/x86/kvm/vmx/tdx.c             | 29 +++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h         |  5 +++++
>   arch/x86/kvm/x86.c                 |  4 ++++
>   6 files changed, 50 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 538f50eee86d..bd7434fe5d37 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -19,6 +19,7 @@ KVM_X86_OP(hardware_disable)
>   KVM_X86_OP(hardware_unsetup)
>   KVM_X86_OP(has_emulated_msr)
>   KVM_X86_OP(vcpu_after_set_cpuid)
> +KVM_X86_OP_OPTIONAL(vm_enable_cap)
>   KVM_X86_OP(vm_init)
>   KVM_X86_OP_OPTIONAL(vm_destroy)
>   KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c754183e0932..9d15f810f046 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1648,6 +1648,7 @@ struct kvm_x86_ops {
>   	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
>   
>   	unsigned int vm_size;
> +	int (*vm_enable_cap)(struct kvm *kvm, struct kvm_enable_cap *cap);
>   	int (*vm_init)(struct kvm *kvm);
>   	void (*vm_destroy)(struct kvm *kvm);
>   
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 59f4d2d42620..cd53091ddaab 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -7,6 +7,7 @@
>   #include "pmu.h"
>   #include "posted_intr.h"
>   #include "tdx.h"
> +#include "tdx_arch.h"
>   
>   static __init int vt_hardware_setup(void)
>   {
> @@ -41,6 +42,14 @@ static __init int vt_hardware_setup(void)
>   	return 0;
>   }
>   
> +static int vt_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +	if (is_td(kvm))
> +		return tdx_vm_enable_cap(kvm, cap);
> +
> +	return -EINVAL;
> +}
> +
>   static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	if (!is_td(kvm))
> @@ -72,6 +81,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.has_emulated_msr = vmx_has_emulated_msr,
>   
>   	.vm_size = sizeof(struct kvm_vmx),
> +	.vm_enable_cap = vt_vm_enable_cap,
>   	.vm_init = vmx_vm_init,
>   	.vm_destroy = vmx_vm_destroy,
>   
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index f9faec217ea9..84cd9b4f90b5 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -44,6 +44,35 @@ struct kvm_tdx_caps {
>   
>   static struct kvm_tdx_caps *kvm_tdx_caps;
>   
> +int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +	int r;
> +
> +	switch (cap->cap) {
> +	case KVM_CAP_MAX_VCPUS: {
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
>   static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>   {
>   	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index c69ca640abe6..c1bdf7d8fee3 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -119,8 +119,13 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
>   void vmx_setup_mce(struct kvm_vcpu *vcpu);
>   
>   #ifdef CONFIG_INTEL_TDX_HOST
> +int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   #else
> +static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +	return -EINVAL;
> +};
>   static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>   #endif
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7914ea50fd04..751b3841c48f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4754,6 +4754,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		break;
>   	case KVM_CAP_MAX_VCPUS:
>   		r = KVM_MAX_VCPUS;
> +		if (kvm)
> +			r = kvm->max_vcpus;
>   		break;
>   	case KVM_CAP_MAX_VCPU_ID:
>   		r = KVM_MAX_VCPU_IDS;
> @@ -6772,6 +6774,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   	}
>   	default:
>   		r = -EINVAL;
> +		if (kvm_x86_ops.vm_enable_cap)
> +			r = static_call(kvm_x86_vm_enable_cap)(kvm, cap);
>   		break;
>   	}
>   	return r;


