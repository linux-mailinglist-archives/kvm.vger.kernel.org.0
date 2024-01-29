Return-Path: <kvm+bounces-7310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E51183FEAE
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 07:54:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BA511C231FE
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 06:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE8444D599;
	Mon, 29 Jan 2024 06:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K1ILCCjA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415854CE04;
	Mon, 29 Jan 2024 06:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706511273; cv=none; b=fIf6KsPHySu9Q52CLo4+OKc5sZ+52WM7K1YsQxG9Qrqt3t1omDCoqH0fllhQvMexJ/8K8ejDrz8D/Bdx1GhEqT33tOJdYslG+Ot4P/RA4yG6nDXokkMS+KAmYPynY6qfCd+oomH6z2+zJt0bcoNgcPsBw8yCyvNaYYyVB0/IyqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706511273; c=relaxed/simple;
	bh=7VkLmcvC7wKyb1mQdaEt8jlCt92UuHjefj6OL5s9DdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X95y0j5ctOEZRrZ7ql657j8aibOioIYlJtHZZ3L68zJKSeEoSiCdXSiuggElRWymN+3iA/DOcwb0kfVVrXTC/lYpd26Qc9lAbKKoFq8fW3+Qa85KJ0vgEmyDv3bb3DYo26bNZaBypEEKkLdGMHg3JyfbORwqkVXuy9HJCtB2N3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K1ILCCjA; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706511271; x=1738047271;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7VkLmcvC7wKyb1mQdaEt8jlCt92UuHjefj6OL5s9DdY=;
  b=K1ILCCjAmhoewpBykiscYaptOP+B14Kbes9Twlbed1bYTZq1UpypAfxo
   GJEet4zqrw8aesq3hIUs3lBNpn7Lg3Zk1IPMUAtJCWaDF2L1t2BmEXhod
   /1Vco3culDERHOTMteOXPLlBSxBG+0eTm4gsfZSv7V4+bbfD2qzwidiUo
   wTFoWe0WGNGS9hfsvEFw/JNGeZof2Tjb6ZltYBE8hUakDXKO4tQDdhJ6L
   7uO2Ax2eW/4pvp9JoF9MEMiahBTOYjkjgA0QDYgoYGK05vX0m8uS0cl8X
   k31MkUCrLGuatnDSwOLzEobddv4b6vVfJitfIcsU6pFo1+M+gOF+xRBAn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10967"; a="9980068"
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="9980068"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 22:54:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="36031001"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orviesa001.jf.intel.com with ESMTP; 28 Jan 2024 22:54:27 -0800
Date: Mon, 29 Jan 2024 14:54:26 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
Subject: Re: [PATCH v18 003/121] KVM: x86: Add is_vm_type_supported callback
Message-ID: <20240129065425.r5knzj3jexae6e2u@yy-desk-7060>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <d46b8e7cd9f2f529142b195e856f710327eb2997.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d46b8e7cd9f2f529142b195e856f710327eb2997.1705965634.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215

On Mon, Jan 22, 2024 at 03:52:39PM -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> For TDX, allow the backend can override the supported vm type.  Add
> KVM_X86_TDX_VM to reserve the bit.

Please highlight that KVM_X86_SNP_VM is also defined for AMD SEV-SNP
in this patch.

>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>
> ---
> v18:
> - include into TDX KVM patch series v18
>
> Changes v3 -> v4:
> - Added KVM_X86_SNP_VM
>
> Changes v2 -> v3:
> - no change
> - didn't bother to rename KVM_X86_PROTECTED_VM to KVM_X86_SW_PROTECTED_VM
>
> Changes v1 -> v2
> - no change
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/include/uapi/asm/kvm.h    |  2 ++
>  arch/x86/kvm/svm/svm.c             |  7 +++++++
>  arch/x86/kvm/vmx/vmx.c             |  7 +++++++
>  arch/x86/kvm/x86.c                 | 12 +++++++++++-
>  arch/x86/kvm/x86.h                 |  2 ++
>  7 files changed, 31 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 378ed944b849..e6b1763b041d 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -20,6 +20,7 @@ KVM_X86_OP(hardware_disable)
>  KVM_X86_OP(hardware_unsetup)
>  KVM_X86_OP(has_emulated_msr)
>  KVM_X86_OP(vcpu_after_set_cpuid)
> +KVM_X86_OP(is_vm_type_supported)
>  KVM_X86_OP(vm_init)
>  KVM_X86_OP_OPTIONAL(vm_destroy)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8011bc668d79..26f4668b0273 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1601,6 +1601,7 @@ struct kvm_x86_ops {
>  	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
>  	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
>
> +	bool (*is_vm_type_supported)(unsigned long vm_type);
>  	unsigned int vm_size;
>  	int (*vm_init)(struct kvm *kvm);
>  	void (*vm_destroy)(struct kvm *kvm);
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index a448d0964fc0..aa7a56a47564 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -564,5 +564,7 @@ struct kvm_pmu_event_filter {
>
>  #define KVM_X86_DEFAULT_VM	0
>  #define KVM_X86_SW_PROTECTED_VM	1
> +#define KVM_X86_TDX_VM		2
> +#define KVM_X86_SNP_VM		3
>
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e90b429c84f1..f76dd52d29ba 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4886,6 +4886,12 @@ static void svm_vm_destroy(struct kvm *kvm)
>  	sev_vm_destroy(kvm);
>  }
>
> +static bool svm_is_vm_type_supported(unsigned long type)
> +{
> +	/* FIXME: Check if CPU is capable of SEV-SNP. */
> +	return __kvm_is_vm_type_supported(type);
> +}
> +
>  static int svm_vm_init(struct kvm *kvm)
>  {
>  	if (!pause_filter_count || !pause_filter_thresh)
> @@ -4914,6 +4920,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.vcpu_free = svm_vcpu_free,
>  	.vcpu_reset = svm_vcpu_reset,
>
> +	.is_vm_type_supported = svm_is_vm_type_supported,
>  	.vm_size = sizeof(struct kvm_svm),
>  	.vm_init = svm_vm_init,
>  	.vm_destroy = svm_vm_destroy,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e262bc2ba4e5..8fad7bba6d5f 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7541,6 +7541,12 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>  	return err;
>  }
>
> +static bool vmx_is_vm_type_supported(unsigned long type)
> +{
> +	/* TODO: Check if TDX is supported. */
> +	return __kvm_is_vm_type_supported(type);
> +}
> +
>  #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
>  #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
>
> @@ -8263,6 +8269,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.hardware_disable = vmx_hardware_disable,
>  	.has_emulated_msr = vmx_has_emulated_msr,
>
> +	.is_vm_type_supported = vmx_is_vm_type_supported,
>  	.vm_size = sizeof(struct kvm_vmx),
>  	.vm_init = vmx_vm_init,
>  	.vm_destroy = vmx_vm_destroy,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 363b1c080205..1b1045dc8e7a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4577,12 +4577,18 @@ static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
>  }
>  #endif
>
> -static bool kvm_is_vm_type_supported(unsigned long type)
> +bool __kvm_is_vm_type_supported(unsigned long type)
>  {
>  	return type == KVM_X86_DEFAULT_VM ||
>  	       (type == KVM_X86_SW_PROTECTED_VM &&
>  		IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_enabled);
>  }
> +EXPORT_SYMBOL_GPL(__kvm_is_vm_type_supported);
> +
> +static bool kvm_is_vm_type_supported(unsigned long type)
> +{
> +	return static_call(kvm_x86_is_vm_type_supported)(type);
> +}
>
>  int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  {
> @@ -4784,6 +4790,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = BIT(KVM_X86_DEFAULT_VM);
>  		if (kvm_is_vm_type_supported(KVM_X86_SW_PROTECTED_VM))
>  			r |= BIT(KVM_X86_SW_PROTECTED_VM);
> +		if (kvm_is_vm_type_supported(KVM_X86_TDX_VM))
> +			r |= BIT(KVM_X86_TDX_VM);
> +		if (kvm_is_vm_type_supported(KVM_X86_SNP_VM))
> +			r |= BIT(KVM_X86_SNP_VM);
>  		break;
>  	default:
>  		break;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 2f7e19166658..4e40c23d66ed 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -9,6 +9,8 @@
>  #include "kvm_cache_regs.h"
>  #include "kvm_emulate.h"
>
> +bool __kvm_is_vm_type_supported(unsigned long type);
> +
>  struct kvm_caps {
>  	/* control of guest tsc rate supported? */
>  	bool has_tsc_control;
> --
> 2.25.1
>
>

