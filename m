Return-Path: <kvm+bounces-11783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D16F687B7F7
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 07:29:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B46928567C
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 06:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B50A914A89;
	Thu, 14 Mar 2024 06:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fa0HQCZR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE4413FE0;
	Thu, 14 Mar 2024 06:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710397755; cv=none; b=oi9t/oN0aSIHyV4Q4wG2/vrNyq7pI9oBPvlXYjje2jbMkdJuseyHxTs4hs6tO9Cx1BXQAn+kl27MY942dtTxaPzzanJDuoVq/MZFrKPZ7ODCI9WOMBFFHDY0AwDzsH26nZoNpWuL+c128HzbWI6PFhNaMBWodFMTIW6Q566eW2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710397755; c=relaxed/simple;
	bh=LetTxJcWQilZiAJb8Y1siIp9RZmyzzRYvYe9IgrPWqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NA19KVe9gpI9mT0Gc4YfbDDvnYxKicvP7pTr0BVCApSmLUqeHSJmYeUGTGQ6Jt2iaZthJm4of4cLF9H8vEUpEHj46EhJxCFWAPH4SsRxBscyd4XmcLa8KvIQHQUyAZ+pas0WWIAAReyn4p1aiIOakCPQLg3CoB6pDgENqyHdgh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fa0HQCZR; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710397754; x=1741933754;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LetTxJcWQilZiAJb8Y1siIp9RZmyzzRYvYe9IgrPWqQ=;
  b=fa0HQCZRbLGzGEemNnLtvO3I9w/NT/7Z8f+zvLVcrxzxBugJKGvbRBZN
   uRU/auLjfsKGX76UpFA7uZlhFNbDPj7aKqFlVT/W8SZ8Wro3unCfVXWvr
   EzjAj6HM98NhFsh5Ud4St/nTo6O6wWRdeGC5yMD/RJUeuSm6Goby+C+Je
   jsoGA0yOIvMrQHTJ5L/zNt5oMD3jFUaq0Ytm8PL5EuYlgUUgvtVITi+ab
   HADeAhF6J1KUzKtUEtO8OVBzIqhRfBwYUfghc2o5oTGBawzu+XjA2U0t4
   UvykVQ5j+3YHd3B2YgdJIimF2UOHA0IQmJvYVFB4IcrjuYEwSAWGvOXEo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="5326201"
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="5326201"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 23:29:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="12582189"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 23:29:10 -0700
Message-ID: <f4961c6d-aa67-4427-bcc7-17942b5f1a9b@linux.intel.com>
Date: Thu, 14 Mar 2024 14:29:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 025/130] KVM: TDX: Make TDX VM type supported
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5159c2b6a23560e9d8252c1311dd91d328e58871.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <5159c2b6a23560e9d8252c1311dd91d328e58871.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> NOTE: This patch is in position of the patch series for developers to be
> able to test codes during the middle of the patch series although this
> patch series doesn't provide functional features until the all the patches
> of this patch series.  When merging this patch series, this patch can be
> moved to the end.

Maybe at this point of time, you can consider to move this patch to the end?

>
> As first step TDX VM support, return that TDX VM type supported to device
> model, e.g. qemu.  The callback to create guest TD is vm_init callback for
> KVM_CREATE_VM.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c    | 18 ++++++++++++++++--
>   arch/x86/kvm/vmx/tdx.c     |  6 ++++++
>   arch/x86/kvm/vmx/vmx.c     |  6 ------
>   arch/x86/kvm/vmx/x86_ops.h |  3 ++-
>   4 files changed, 24 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index e11edbd19e7c..fa19682b366c 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -10,6 +10,12 @@
>   static bool enable_tdx __ro_after_init;
>   module_param_named(tdx, enable_tdx, bool, 0444);
>   
> +static bool vt_is_vm_type_supported(unsigned long type)
> +{
> +	return __kvm_is_vm_type_supported(type) ||
> +		(enable_tdx && tdx_is_vm_type_supported(type));
> +}
> +
>   static __init int vt_hardware_setup(void)
>   {
>   	int ret;
> @@ -26,6 +32,14 @@ static __init int vt_hardware_setup(void)
>   	return 0;
>   }
>   
> +static int vt_vm_init(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return -EOPNOTSUPP;	/* Not ready to create guest TD yet. */
> +
> +	return vmx_vm_init(kvm);
> +}
> +
>   #define VMX_REQUIRED_APICV_INHIBITS				\
>   	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
>   	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
> @@ -47,9 +61,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.hardware_disable = vmx_hardware_disable,
>   	.has_emulated_msr = vmx_has_emulated_msr,
>   
> -	.is_vm_type_supported = vmx_is_vm_type_supported,
> +	.is_vm_type_supported = vt_is_vm_type_supported,
>   	.vm_size = sizeof(struct kvm_vmx),
> -	.vm_init = vmx_vm_init,
> +	.vm_init = vt_vm_init,
>   	.vm_destroy = vmx_vm_destroy,
>   
>   	.vcpu_precreate = vmx_vcpu_precreate,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 14ef0ccd8f1a..a7e096fd8361 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -24,6 +24,12 @@ static int __init tdx_module_setup(void)
>   	return 0;
>   }
>   
> +bool tdx_is_vm_type_supported(unsigned long type)
> +{
> +	/* enable_tdx check is done by the caller. */
> +	return type == KVM_X86_TDX_VM;
> +}
> +
>   struct tdx_enabled {
>   	cpumask_var_t enabled;
>   	atomic_t err;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2fb1cd2e28a2..d928acc15d0f 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7531,12 +7531,6 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>   	return err;
>   }
>   
> -bool vmx_is_vm_type_supported(unsigned long type)
> -{
> -	/* TODO: Check if TDX is supported. */
> -	return __kvm_is_vm_type_supported(type);
> -}
> -
>   #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
>   #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
>   
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 346289a2a01c..f4da88a228d0 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -28,7 +28,6 @@ void vmx_hardware_unsetup(void);
>   int vmx_check_processor_compat(void);
>   int vmx_hardware_enable(void);
>   void vmx_hardware_disable(void);
> -bool vmx_is_vm_type_supported(unsigned long type);
>   int vmx_vm_init(struct kvm *kvm);
>   void vmx_vm_destroy(struct kvm *kvm);
>   int vmx_vcpu_precreate(struct kvm *kvm);
> @@ -137,8 +136,10 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
>   
>   #ifdef CONFIG_INTEL_TDX_HOST
>   int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
> +bool tdx_is_vm_type_supported(unsigned long type);
>   #else
>   static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
> +static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
>   #endif
>   
>   #endif /* __KVM_X86_VMX_X86_OPS_H */


