Return-Path: <kvm+bounces-4028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CED0180C468
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 10:23:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18135281410
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 09:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A177E21344;
	Mon, 11 Dec 2023 09:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y1ZI9bH/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575D0CE;
	Mon, 11 Dec 2023 01:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702286569; x=1733822569;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=+ODZaxYb7w0tO5TdpkJsX+x6tQ0MA4z3+FLXUMt8UlM=;
  b=Y1ZI9bH/eR41Rh0LZWF6b7FZavi7Q1F/wgTSz4chlpukSGBFQSM+lnje
   XLz+pgBO8nlM7goL0EVrL+qYM5fo8Wy4P2+Hh2daxfpjDI9gzijSVv2PN
   lQIERIr8fGyAf+eKUwNx6rFZ/1f93EkXRGgZpQM4oBYgOuLxOH7Jmqy85
   KyiggPLSl1ugHjKNcBbOgLEQdd+vBxrzro42Lvinn61gAylRLdPlEb9l2
   x0RHD2KFB3TtUqGqRajqICM3b5FsKX5ZFvKqsDTyRb8oBxb0MNWhHoqK+
   QuXEJa7PCwXWZBzNpEJXtILrfb8WgRbF5waM4UxXxxqqCqoeLIzzZKB2K
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10920"; a="480810409"
X-IronPort-AV: E=Sophos;i="6.04,267,1695711600"; 
   d="scan'208";a="480810409"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 01:22:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10920"; a="749212539"
X-IronPort-AV: E=Sophos;i="6.04,267,1695711600"; 
   d="scan'208";a="749212539"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.126]) ([10.238.10.126])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 01:22:43 -0800
Message-ID: <41ff6a9a-c32b-41f1-9d72-e26f2008acf3@linux.intel.com>
Date: Mon, 11 Dec 2023 17:22:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v17 019/116] KVM: x86, tdx: Make KVM_CAP_MAX_VCPUS backend
 specific
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <376bdde3fac2fb13579b33b9db3d3d2bc2774ffa.1699368322.git.isaku.yamahata@intel.com>
In-Reply-To: <376bdde3fac2fb13579b33b9db3d3d2bc2774ffa.1699368322.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/7/2023 10:55 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata<isaku.yamahata@intel.com>
>
> TDX has its own limitation on the maximum number of vcpus that the guest
> can accommodate.  Allow x86 kvm backend to implement its own KVM_ENABLE_CAP
> handler and implement TDX backend for KVM_CAP_MAX_VCPUS.  user space VMM,
> e.g. qemu, can specify its value instead of KVM_MAX_VCPUS.

Should use "TDX" instread of "x86, tdx" in shortlog?


> Signed-off-by: Isaku Yamahata<isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |  2 ++
>   arch/x86/include/asm/kvm_host.h    |  2 ++
>   arch/x86/kvm/vmx/main.c            | 22 ++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.c             | 30 ++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.h             |  3 +++
>   arch/x86/kvm/vmx/x86_ops.h         |  5 +++++
>   arch/x86/kvm/x86.c                 |  4 ++++
>   7 files changed, 68 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 09abb53d92ea..b7b591f1ff72 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -21,6 +21,8 @@ KVM_X86_OP(hardware_unsetup)
>   KVM_X86_OP(has_emulated_msr)
>   KVM_X86_OP(vcpu_after_set_cpuid)
>   KVM_X86_OP(is_vm_type_supported)
> +KVM_X86_OP_OPTIONAL(max_vcpus);
> +KVM_X86_OP_OPTIONAL(vm_enable_cap)
>   KVM_X86_OP(vm_init)
>   KVM_X86_OP_OPTIONAL(vm_destroy)
>   KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6509e967454a..f240c3d025b1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1574,7 +1574,9 @@ struct kvm_x86_ops {
>   	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
>   
>   	bool (*is_vm_type_supported)(unsigned long vm_type);
> +	int (*max_vcpus)(struct kvm *kvm);
>   	unsigned int vm_size;
> +	int (*vm_enable_cap)(struct kvm *kvm, struct kvm_enable_cap *cap);
>   	int (*vm_init)(struct kvm *kvm);
>   	void (*vm_destroy)(struct kvm *kvm);
>   
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index a95bbd10c3d8..5a857c8defd9 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -6,6 +6,7 @@
>   #include "nested.h"
>   #include "pmu.h"
>   #include "tdx.h"
> +#include "tdx_arch.h"
>   
>   static bool enable_tdx __ro_after_init;
>   module_param_named(tdx, enable_tdx, bool, 0444);
> @@ -16,6 +17,17 @@ static bool vt_is_vm_type_supported(unsigned long type)
>   		(enable_tdx && tdx_is_vm_type_supported(type));
>   }
>   
> +static int vt_max_vcpus(struct kvm *kvm)
> +{
> +	if (!kvm)
> +		return KVM_MAX_VCPUS;
> +
> +	if (is_td(kvm))
> +		return min3(kvm->max_vcpus, KVM_MAX_VCPUS, TDX_MAX_VCPUS);

kvm->max_vcpus is initialized to KVM_MAX_VCPUS when kvm_create_vm().
Also, when userspace tries to set the value, it's also limited by KVM_MAX_VCPUS.
So, for x86, the value is <= KVM_MAX_VCPUS for sure.

It could be simpler:
+	if (is_td(kvm))
+		return min(kvm->max_vcpus, TDX_MAX_VCPUS);



> +
> +	return kvm->max_vcpus;
> +}
> +
>   static int vt_hardware_enable(void)
>   {
>   	int ret;
> @@ -43,6 +55,14 @@ static __init int vt_hardware_setup(void)
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
>   static int vt_vm_init(struct kvm *kvm)
>   {
>   	if (is_td(kvm))
> @@ -80,7 +100,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.has_emulated_msr = vmx_has_emulated_msr,
>   
>   	.is_vm_type_supported = vt_is_vm_type_supported,
> +	.max_vcpus = vt_max_vcpus,
>   	.vm_size = sizeof(struct kvm_vmx),
> +	.vm_enable_cap = vt_vm_enable_cap,
>   	.vm_init = vt_vm_init,
>   	.vm_destroy = vmx_vm_destroy,
>   
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index f9e80582865d..331fbaa10d46 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -17,6 +17,36 @@
>   		offsetof(struct tdsysinfo_struct, cpuid_configs))	\
>   		/ sizeof(struct tdx_cpuid_config))
>   
> +int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +	int r;
> +
> +	switch (cap->cap) {
> +	case KVM_CAP_MAX_VCPUS: {
> +		if (cap->flags || cap->args[0] == 0)
> +			return -EINVAL;
> +		if (cap->args[0] > KVM_MAX_VCPUS)
> +			return -E2BIG;
> +		if (cap->args[0] > TDX_MAX_VCPUS)
> +			return -E2BIG;
Can merge the two if statements into one.

+        if (cap->args[0] > KVM_MAX_VCPUS || cap->args[0] > TDX_MAX_VCPUS)
+            return -E2BIG;

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
>   	struct kvm_tdx_capabilities __user *user_caps;
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 473013265bd8..22c0b57f69ca 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -3,6 +3,9 @@
>   #define __KVM_X86_TDX_H
>   
>   #ifdef CONFIG_INTEL_TDX_HOST
> +
> +#include "tdx_ops.h"
> +
>   struct kvm_tdx {
>   	struct kvm kvm;
>   	/* TDX specific members follow. */
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 6487884a8d8e..ee5d8a38e7f8 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -138,11 +138,16 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
>   int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
>   bool tdx_is_vm_type_supported(unsigned long type);
>   
> +int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   #else
>   static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
>   static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
>   
> +static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +	return -EINVAL;
> +};
>   static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>   #endif
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ced75e9204b9..de6e6462e7f3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4694,6 +4694,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		break;
>   	case KVM_CAP_MAX_VCPUS:
>   		r = KVM_MAX_VCPUS;
> +		if (kvm_x86_ops.max_vcpus)
> +			r = static_call(kvm_x86_max_vcpus)(kvm);
>   		break;
>   	case KVM_CAP_MAX_VCPU_ID:
>   		r = KVM_MAX_VCPU_IDS;
> @@ -6641,6 +6643,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		break;
>   	default:
>   		r = -EINVAL;
> +		if (kvm_x86_ops.vm_enable_cap)
> +			r = static_call(kvm_x86_vm_enable_cap)(kvm, cap);
>   		break;
>   	}
>   	return r;


