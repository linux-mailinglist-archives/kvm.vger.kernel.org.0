Return-Path: <kvm+bounces-6896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EB0D83B712
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:19:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E38191F23D8E
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 02:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46CEA63AC;
	Thu, 25 Jan 2024 02:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ej1WBVtH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6530C17EF;
	Thu, 25 Jan 2024 02:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706149178; cv=none; b=ok8wXwjtrRZyzOo85bV70ocgkYwpQKkWvNd8E32Xf3lf+k0/MGzEjse4iE7vnrXAwo9LWkP5FSjfdjnNzsqKI/Flcu0GQh0tepjlOcwtiFqZJgvO5fbOR7Lgd7VmGuKcVxFm2s3J5OpQuSrwcZLhpkcl2xXPV3Fx3Oo3/QY/hVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706149178; c=relaxed/simple;
	bh=KEAUFvVjkY/l2riHiNMhvrbBMm8nIv1byVtDbnkRMhA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OU9Nxmp/9n2hjDXp53BzBg2XEeB46fi6kBgLeI6XOzqZD8BLPwD9ptwiQE0j4zMbgYwhrYCH1VkaQrKLx5v2Zi2KoDY3Z6+xf7tNTUaNz+YiqsNlGXXr0CApTJbxvoJrS1X3if+Drab1I9w0b1gsNWgBFFFYrpd+/wzsDg3TdhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ej1WBVtH; arc=none smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706149176; x=1737685176;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KEAUFvVjkY/l2riHiNMhvrbBMm8nIv1byVtDbnkRMhA=;
  b=Ej1WBVtHb3zHUtaS4vRyA/mRRlwdsq9ljip/JXZ0ja4MzT9ZEsYzG9LK
   bSTxLsu1oJJPPWANdvFaSa5sXaEcJ5Au23ulVOpA2s4d0n2TSurhzvgtS
   aVojVGRObSzw7NbW6I3cwchqAIXQGV8ufNd3SxkfhtCZ1lVSY/U80PIdA
   iGApS1ID2iM9vFYfiMOc9JSAthSvdU2OGnh5HdVgkdPAz6uwiUJuxsrCs
   S1bQ4LN9QSyI+2emrY+Hpx5C6stEtSmySvBHfI6/BUkHJ/67g6mwqjJ7B
   JEGkBHELcGshHKJvj+A3Lb9pZkl4QFNEY5VTvbv/kYYWMU366WiuBsYfA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="433189417"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="433189417"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 18:19:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="20910991"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.49]) ([10.238.10.49])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 18:19:32 -0800
Message-ID: <6e517d2e-45ae-46ec-8067-c3e7eb1b2afa@linux.intel.com>
Date: Thu, 25 Jan 2024 10:19:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 025/121] KVM: TDX: initialize VM with TDX specific
 parameters
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <af0e1a82fdf797a7fffc9d08141d15037ed8537b.1705965634.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <af0e1a82fdf797a7fffc9d08141d15037ed8537b.1705965634.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX requires additional parameters for TDX VM for confidential execution to
> protect the confidentiality of its memory contents and CPU state from any
> other software, including VMM.  When creating a guest TD VM before creating
> vcpu, the number of vcpu, TSC frequency (the values are the same among
> vcpus, and it can't change.)  CPUIDs which the TDX module emulates.  Guest
> TDs can trust those CPUIDs and sha384 values for measurement.
>
> Add a new subcommand, KVM_TDX_INIT_VM, to pass parameters for the TDX
> guest.  It assigns an encryption key to the TDX guest for memory
> encryption.  TDX encrypts memory per guest basis.  The device model, say
> qemu, passes per-VM parameters for the TDX guest.  The maximum number of
> vcpus, TSC frequency (TDX guest has fixed VM-wide TSC frequency, not per
> vcpu.  The TDX guest can not change it.), attributes (production or debug),
> available extended features (which configure guest XCR0, IA32_XSS MSR),
> CPUIDs, sha384 measurements, etc.
>
> Call this subcommand before creating vcpu and KVM_SET_CPUID2, i.e.  CPUID
> configurations aren't available yet.  So CPUIDs configuration values need
> to be passed in struct kvm_tdx_init_vm.  The device model's responsibility
> to make this CPUID config for KVM_TDX_INIT_VM and KVM_SET_CPUID2.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>
> ---
> v18:
> - remove the change of tools/arch/x86/include/uapi/asm/kvm.h
> - typo in comment. sha348 => sha384
> - updated comment in setup_tdparams_xfam()
> - fix setup_tdparams_xfam() to use init_vm instead of td_params
>
> v15 -> v16:
> - Removed AMX check as the KVM upstream supports AMX.
> - Added CET flag to guest supported xss
>
> v14 -> v15:
> - add check if the reserved area of init_vm is zero
> ---
>   arch/x86/include/uapi/asm/kvm.h |  27 ++++
>   arch/x86/kvm/cpuid.c            |   7 +
>   arch/x86/kvm/cpuid.h            |   2 +
>   arch/x86/kvm/vmx/tdx.c          | 261 ++++++++++++++++++++++++++++++--
>   arch/x86/kvm/vmx/tdx.h          |  18 +++
>   arch/x86/kvm/vmx/tdx_arch.h     |   6 +
>   6 files changed, 311 insertions(+), 10 deletions(-)
>
[...]
> +
> +static int setup_tdparams_xfam(struct kvm_cpuid2 *cpuid, struct td_params *td_params)
> +{
> +	const struct kvm_cpuid_entry2 *entry;
> +	u64 guest_supported_xcr0;
> +	u64 guest_supported_xss;
> +
> +	/* Setup td_params.xfam */
> +	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0xd, 0);
> +	if (entry)
> +		guest_supported_xcr0 = (entry->eax | ((u64)entry->edx << 32));
> +	else
> +		guest_supported_xcr0 = 0;
> +	guest_supported_xcr0 &= kvm_caps.supported_xcr0;
> +
> +	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0xd, 1);
> +	if (entry)
> +		guest_supported_xss = (entry->ecx | ((u64)entry->edx << 32));
> +	else
> +		guest_supported_xss = 0;
> +
> +	/*
> +	 * PT can be exposed to TD guest regardless of KVM's XSS and CET
> +	 * support.
> +	 */
According to the code below, it seems that both PT and CET can be 
exposed to TD
guest regardless of KVM's XSS support?

> +	guest_supported_xss &=
> +		(kvm_caps.supported_xss | XFEATURE_MASK_PT | TDX_TD_XFAM_CET);
> +
> +	td_params->xfam = guest_supported_xcr0 | guest_supported_xss;
> +	if (td_params->xfam & XFEATURE_MASK_LBR) {
> +		/*
> +		 * TODO: once KVM supports LBR(save/restore LBR related
> +		 * registers around TDENTER), remove this guard.
> +		 */
> +#define MSG_LBR	"TD doesn't support LBR yet. KVM needs to save/restore IA32_LBR_DEPTH properly.\n"
> +		pr_warn(MSG_LBR);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
> +			struct kvm_tdx_init_vm *init_vm)
> +{
> +	struct kvm_cpuid2 *cpuid = &init_vm->cpuid;
> +	int ret;
> +
> +	if (kvm->created_vcpus)
> +		return -EBUSY;
> +
> +	if (init_vm->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
> +		/*
> +		 * TODO: save/restore PMU related registers around TDENTER.
> +		 * Once it's done, remove this guard.
> +		 */
> +#define MSG_PERFMON	"TD doesn't support perfmon yet. KVM needs to save/restore host perf registers properly.\n"
> +		pr_warn(MSG_PERFMON);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	td_params->max_vcpus = kvm->max_vcpus;
Can the max vcpu number be passed by KVM_TDX_INIT_VM?
So that no need to add KVM_CAP_MAX_VCPUS in patch 23/121.

> +	td_params->attributes = init_vm->attributes;
> +	td_params->tsc_frequency = TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default_tsc_khz);
> +
> +	ret = setup_tdparams_eptp_controls(cpuid, td_params);
> +	if (ret)
> +		return ret;
> +	setup_tdparams_cpuids(cpuid, td_params);
> +	ret = setup_tdparams_xfam(cpuid, td_params);
> +	if (ret)
> +		return ret;
> +
> +#define MEMCPY_SAME_SIZE(dst, src)				\
> +	do {							\
> +		BUILD_BUG_ON(sizeof(dst) != sizeof(src));	\
> +		memcpy((dst), (src), sizeof(dst));		\
> +	} while (0)
> +
> +	MEMCPY_SAME_SIZE(td_params->mrconfigid, init_vm->mrconfigid);
> +	MEMCPY_SAME_SIZE(td_params->mrowner, init_vm->mrowner);
> +	MEMCPY_SAME_SIZE(td_params->mrownerconfig, init_vm->mrownerconfig);
> +
> +	return 0;
> +}
> +
> +static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
> +			 u64 *seamcall_err)
>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct tdx_module_args out;
>   	cpumask_var_t packages;
>   	unsigned long *tdcs_pa = NULL;
>   	unsigned long tdr_pa = 0;
> @@ -469,6 +623,7 @@ static int __tdx_td_init(struct kvm *kvm)
>   	int ret, i;
>   	u64 err;
>   
> +	*seamcall_err = 0;
>   	ret = tdx_guest_keyid_alloc();
>   	if (ret < 0)
>   		return ret;
> @@ -583,10 +738,23 @@ static int __tdx_td_init(struct kvm *kvm)
>   		}
>   	}
>   
> -	/*
> -	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
> -	 * ioctl() to define the configure CPUID values for the TD.
> -	 */
> +	err = tdh_mng_init(kvm_tdx->tdr_pa, __pa(td_params), &out);
> +	if ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_INVALID) {
> +		/*
> +		 * Because a user gives operands, don't warn.
> +		 * Return a hint to the user because it's sometimes hard for the
> +		 * user to figure out which operand is invalid.  SEAMCALL status
> +		 * code includes which operand caused invalid operand error.
> +		 */
> +		*seamcall_err = err;
> +		ret = -EINVAL;
> +		goto teardown;
> +	} else if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_INIT, err, &out);
> +		ret = -EIO;
> +		goto teardown;
> +	}
> +
>   	return 0;
>   
>   	/*
> @@ -629,6 +797,76 @@ static int __tdx_td_init(struct kvm *kvm)
>   	return ret;
>   }
>   
> +static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct kvm_tdx_init_vm *init_vm = NULL;
> +	struct td_params *td_params = NULL;
> +	int ret;
> +
> +	BUILD_BUG_ON(sizeof(*init_vm) != 8 * 1024);
> +	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
> +
> +	if (is_hkid_assigned(kvm_tdx))
> +		return -EINVAL;
> +
> +	if (cmd->flags)
> +		return -EINVAL;
> +
> +	init_vm = kzalloc(sizeof(*init_vm) +
> +			  sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
> +			  GFP_KERNEL);
> +	if (!init_vm)
> +		return -ENOMEM;
> +	if (copy_from_user(init_vm, (void __user *)cmd->data, sizeof(*init_vm))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +	if (init_vm->cpuid.nent > KVM_MAX_CPUID_ENTRIES) {
> +		ret = -E2BIG;
> +		goto out;
> +	}
> +	if (copy_from_user(init_vm->cpuid.entries,
> +			   (void __user *)cmd->data + sizeof(*init_vm),
> +			   flex_array_size(init_vm, cpuid.entries, init_vm->cpuid.nent))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	if (memchr_inv(init_vm->reserved, 0, sizeof(init_vm->reserved))) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +	if (init_vm->cpuid.padding) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	td_params = kzalloc(sizeof(struct td_params), GFP_KERNEL);
> +	if (!td_params) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	ret = setup_tdparams(kvm, td_params, init_vm);
> +	if (ret)
> +		goto out;
> +
> +	ret = __tdx_td_init(kvm, td_params, &cmd->error);
> +	if (ret)
> +		goto out;
> +
> +	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
> +	kvm_tdx->attributes = td_params->attributes;
> +	kvm_tdx->xfam = td_params->xfam;
> +
> +out:
> +	/* kfree() accepts NULL. */
> +	kfree(init_vm);
> +	kfree(td_params);
> +	return ret;
> +}
> +
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_tdx_cmd tdx_cmd;
> @@ -645,6 +883,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>   	case KVM_TDX_CAPABILITIES:
>   		r = tdx_get_capabilities(&tdx_cmd);
>   		break;
> +	case KVM_TDX_INIT_VM:
> +		r = tdx_td_init(kvm, &tdx_cmd);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		goto out;
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index ae117f864cfb..184fe394da86 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -12,7 +12,11 @@ struct kvm_tdx {
>   	unsigned long tdr_pa;
>   	unsigned long *tdcs_pa;
>   
> +	u64 attributes;
> +	u64 xfam;
>   	int hkid;
> +
> +	u64 tsc_offset;
>   };
>   
>   struct vcpu_tdx {
> @@ -39,6 +43,20 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
>   {
>   	return container_of(vcpu, struct vcpu_tdx, vcpu);
>   }
> +
> +static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
> +{
> +	struct tdx_module_args out;
> +	u64 err;
> +
> +	err = tdh_mng_rd(kvm_tdx->tdr_pa, TDCS_EXEC(field), &out);
> +	if (unlikely(err)) {
> +		pr_err("TDH_MNG_RD[EXEC.0x%x] failed: 0x%llx\n", field, err);
> +		return 0;
> +	}
> +	return out.r8;
> +}
> +
>   #else
>   struct kvm_tdx {
>   	struct kvm kvm;
> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> index 569d59c55229..eb11618366b7 100644
> --- a/arch/x86/kvm/vmx/tdx_arch.h
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
> @@ -123,6 +123,12 @@ struct tdx_cpuid_value {
>   #define TDX_TD_ATTRIBUTE_KL		BIT_ULL(31)
>   #define TDX_TD_ATTRIBUTE_PERFMON	BIT_ULL(63)
>   
> +/*
> + * TODO: Once XFEATURE_CET_{U, S} in arch/x86/include/asm/fpu/types.h is
> + * defined, Replace these with define ones.
> + */
> +#define TDX_TD_XFAM_CET	(BIT(11) | BIT(12))
> +
>   /*
>    * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
>    */


