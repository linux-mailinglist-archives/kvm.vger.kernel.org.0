Return-Path: <kvm+bounces-3681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7E658069FE
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 09:43:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92DA0281D6C
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 08:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A94F31A702;
	Wed,  6 Dec 2023 08:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KhipxHYx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C58B1A2;
	Wed,  6 Dec 2023 00:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701852191; x=1733388191;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qIdN+b2rLjTnQPYTeBHnfLQ8YM9/DljqKcBdpdxf2tc=;
  b=KhipxHYxtQfkGpEXMcbRXpeq4pIEEO44i60kPdSKGfTah6wgvSTd0CDV
   MWA0tagCzSEjo50cwScInpGgSBAywdLezmZSOIZSWGC6mRIA8RBIbdOrF
   2HvM6HxrBeqIQnm970w5wFfOdMcl0KyKXXY+6q9BUuVFYlnv03D5jPfTL
   54VL/SnmfcqQUdGLHSDEygSExRf9xYmB/2sKwHeyUQI4cHyb/gq5zikOZ
   +EUEvuZhorO23Yjb4ZwG2QA9xgCtMlP540ZcKdgnM9ygeXXUoAOj3wNLb
   SAP2oa5CDnOnDuvoBMUZstifdODgwKOVyanZXYEVjJ8fhlwGuzBexk98+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="460518072"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="460518072"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 00:43:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="800271912"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="800271912"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.126]) ([10.238.10.126])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 00:43:06 -0800
Message-ID: <83f502c2-3649-425a-8f02-9cd460755e5b@linux.intel.com>
Date: Wed, 6 Dec 2023 16:43:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 018/116] KVM: TDX: x86: Add ioctl to get TDX
 systemwide parameters
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <c0242f096fffd63d544c4fbdd3b2415ce94388c6.1699368322.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <c0242f096fffd63d544c4fbdd3b2415ce94388c6.1699368322.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2023 10:55 PM, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Implement an ioctl to get system-wide parameters for TDX.  Although the
> function is systemwide, vm scoped mem_enc ioctl works for userspace VMM
> like qemu and device scoped version is not define, re-use vm scoped
> mem_enc.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v14 -> v15:
> - ABI change: added supported_gpaw and reserved area,
> ---
>   arch/x86/include/uapi/asm/kvm.h       | 24 ++++++++++
>   arch/x86/kvm/vmx/tdx.c                | 64 +++++++++++++++++++++++++++
>   tools/arch/x86/include/uapi/asm/kvm.h | 52 ++++++++++++++++++++++
>   3 files changed, 140 insertions(+)
>
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 615fb60b3717..3fbd43d5177b 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -593,4 +593,28 @@ struct kvm_tdx_cmd {
>   	__u64 error;
>   };
>   
> +struct kvm_tdx_cpuid_config {
> +	__u32 leaf;
> +	__u32 sub_leaf;
> +	__u32 eax;
> +	__u32 ebx;
> +	__u32 ecx;
> +	__u32 edx;
> +};
> +
> +struct kvm_tdx_capabilities {
> +	__u64 attrs_fixed0;
> +	__u64 attrs_fixed1;
> +	__u64 xfam_fixed0;
> +	__u64 xfam_fixed1;
> +#define TDX_CAP_GPAW_48	(1 << 0)
> +#define TDX_CAP_GPAW_52	(1 << 1)
> +	__u32 supported_gpaw;
> +	__u32 padding;
> +	__u64 reserved[251];
> +
> +	__u32 nr_cpuid_configs;
> +	struct kvm_tdx_cpuid_config cpuid_configs[];
> +};
> +
>   #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index ead229e34813..f9e80582865d 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -6,6 +6,7 @@
>   #include "capabilities.h"
>   #include "x86_ops.h"
>   #include "x86.h"
> +#include "mmu.h"
>   #include "tdx.h"
>   
>   #undef pr_fmt
> @@ -16,6 +17,66 @@
>   		offsetof(struct tdsysinfo_struct, cpuid_configs))	\
>   		/ sizeof(struct tdx_cpuid_config))
>   
> +static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
> +{
> +	struct kvm_tdx_capabilities __user *user_caps;
> +	const struct tdsysinfo_struct *tdsysinfo;
> +	struct kvm_tdx_capabilities *caps = NULL;
> +	int ret = 0;
> +
> +	BUILD_BUG_ON(sizeof(struct kvm_tdx_cpuid_config) !=
> +		     sizeof(struct tdx_cpuid_config));
> +
> +	if (cmd->flags)
> +		return -EINVAL;
> +
> +	tdsysinfo = tdx_get_sysinfo();
> +	if (!tdsysinfo)
> +		return -EOPNOTSUPP;
> +
> +	caps = kmalloc(sizeof(*caps), GFP_KERNEL);
> +	if (!caps)
> +		return -ENOMEM;
> +
> +	user_caps = (void __user *)cmd->data;
> +	if (copy_from_user(caps, user_caps, sizeof(*caps))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	if (caps->nr_cpuid_configs < tdsysinfo->num_cpuid_config) {
> +		ret = -E2BIG;
> +		goto out;
> +	}
> +
> +	*caps = (struct kvm_tdx_capabilities) {
> +		.attrs_fixed0 = tdsysinfo->attributes_fixed0,
> +		.attrs_fixed1 = tdsysinfo->attributes_fixed1,
> +		.xfam_fixed0 = tdsysinfo->xfam_fixed0,
> +		.xfam_fixed1 = tdsysinfo->xfam_fixed1,
> +		.supported_gpaw = TDX_CAP_GPAW_48 |
> +		(kvm_get_shadow_phys_bits() >= 52 &&
> +		 cpu_has_vmx_ept_5levels()) ? TDX_CAP_GPAW_52 : 0,
> +		.nr_cpuid_configs = tdsysinfo->num_cpuid_config,
> +		.padding = 0,
> +	};
> +
> +	if (copy_to_user(user_caps, caps, sizeof(*caps))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +	if (copy_to_user(user_caps->cpuid_configs, &tdsysinfo->cpuid_configs,
> +			 tdsysinfo->num_cpuid_config *
> +			 sizeof(struct tdx_cpuid_config))) {
> +		ret = -EFAULT;
> +	}
> +
> +out:
> +	/* kfree() accepts NULL. */
> +	kfree(caps);
> +	return ret;
> +}
> +
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_tdx_cmd tdx_cmd;
> @@ -29,6 +90,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>   	mutex_lock(&kvm->lock);
>   
>   	switch (tdx_cmd.id) {
> +	case KVM_TDX_CAPABILITIES:
> +		r = tdx_get_capabilities(&tdx_cmd);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		goto out;
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> index 1a6a1f987949..7a08723e99e2 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h

According to the discussion, Sean's preference is "never update KVM's
uapi headers in tools/ in KVM's tree"
https://lore.kernel.org/all/Y8bZ%2FJ98V5i3wG%2Fv@google.com/

> @@ -562,4 +562,56 @@ struct kvm_pmu_event_filter {
>   /* x86-specific KVM_EXIT_HYPERCALL flags. */
>   #define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
>   
> +/* Trust Domain eXtension sub-ioctl() commands. */
> +enum kvm_tdx_cmd_id {
> +	KVM_TDX_CAPABILITIES = 0,
> +
> +	KVM_TDX_CMD_NR_MAX,
> +};
> +
> +struct kvm_tdx_cmd {
> +	/* enum kvm_tdx_cmd_id */
> +	__u32 id;
> +	/* flags for sub-commend. If sub-command doesn't use this, set zero. */
> +	__u32 flags;
> +	/*
> +	 * data for each sub-command. An immediate or a pointer to the actual
> +	 * data in process virtual address.  If sub-command doesn't use it,
> +	 * set zero.
> +	 */
> +	__u64 data;
> +	/*
> +	 * Auxiliary error code.  The sub-command may return TDX SEAMCALL
> +	 * status code in addition to -Exxx.
> +	 * Defined for consistency with struct kvm_sev_cmd.
> +	 */
> +	__u64 error;
> +	/* Reserved: Defined for consistency with struct kvm_sev_cmd. */
> +	__u64 unused;
> +};
> +
> +struct kvm_tdx_cpuid_config {
> +	__u32 leaf;
> +	__u32 sub_leaf;
> +	__u32 eax;
> +	__u32 ebx;
> +	__u32 ecx;
> +	__u32 edx;
> +};
> +
> +struct kvm_tdx_capabilities {
> +	__u64 attrs_fixed0;
> +	__u64 attrs_fixed1;
> +	__u64 xfam_fixed0;
> +	__u64 xfam_fixed1;
> +#define TDX_CAP_GPAW_48		(1 << 0)
> +#define TDX_CAP_GPAW_52		(1 << 1)
> +	__u32 supported_gpaw;
> +	__u32 padding;
> +	__u64 reserved[251];
> +
> +	__u32 nr_cpuid_configs;
> +	struct kvm_tdx_cpuid_config cpuid_configs[];
> +};
> +
>   #endif /* _ASM_X86_KVM_H */


