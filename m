Return-Path: <kvm+bounces-4290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C243810A49
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 07:29:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C56F3281F61
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 06:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2548FFBF6;
	Wed, 13 Dec 2023 06:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b8FOit9u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA8212D;
	Tue, 12 Dec 2023 22:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702448952; x=1733984952;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Fy/NIVMWckJsL0DQmkMTwNSrWL5lkaKiToMQxes+bBI=;
  b=b8FOit9ubZUoijNvwxmq8SLyDgm9+hSThbPq+X2FCeZBnQcblSOEkKRc
   yqXpdZNL/RPI1zGXAC1DTXVrp0fpIKdj812mFfDYLdWJskfbEWZ/+BAHG
   cH5plNHlrJI1SGHcBbNssGTCy4nMcEnytWRnkOifkfqX8EDVfvaCuFIxc
   6BJtCIjBWtWDS5vpR3+95VfuRHhIoG8LK9qTEYOP6rZOP1v1tNf3WAa/u
   dJ1tuUoJENdP6eKkZYImBbn1uk8YHqxh/uv+ysoA3Ps7WnPl/oZlWbzHO
   WTFnezHkVyhe4yAzvJwdbZsarWK55XA5o7ev3AqLFfoucVQ95jnOFzYG6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="379913579"
X-IronPort-AV: E=Sophos;i="6.04,272,1695711600"; 
   d="scan'208";a="379913579"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 22:29:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="844201005"
X-IronPort-AV: E=Sophos;i="6.04,272,1695711600"; 
   d="scan'208";a="844201005"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.2.128]) ([10.238.2.128])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 22:29:07 -0800
Message-ID: <b6fc0015-1ec5-4219-86c5-2ca60b1f0a33@linux.intel.com>
Date: Wed, 13 Dec 2023 14:29:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 021/116] KVM: TDX: initialize VM with TDX specific
 parameters
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <16c7e2802047dde09dec7beb87906c1c2daffbba.1699368322.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <16c7e2802047dde09dec7beb87906c1c2daffbba.1699368322.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2023 10:55 PM, isaku.yamahata@intel.com wrote:
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
> v15 -> v16:
> - Removed AMX check as the KVM upstream supports AMX.
> - Added CET flag to guest supported xss
>
> v14 -> v15:
> - add check if the reserved area of init_vm is zero
> ---
>   arch/x86/include/asm/tdx.h            |   2 +
>   arch/x86/include/uapi/asm/kvm.h       |  27 +++
>   arch/x86/kvm/cpuid.c                  |   7 +
>   arch/x86/kvm/cpuid.h                  |   2 +
>   arch/x86/kvm/vmx/tdx.c                | 263 +++++++++++++++++++++++++-
>   arch/x86/kvm/vmx/tdx.h                |  18 ++
>   arch/x86/kvm/vmx/tdx_arch.h           |   6 +
>   tools/arch/x86/include/uapi/asm/kvm.h |  33 ++++
>   8 files changed, 348 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 276bdae47738..f4ce6a8b1056 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -109,6 +109,8 @@ static inline u64 sc_retry(sc_func_t func, u64 fn,
>   #define seamcall_ret(_fn, _args)	sc_retry(__seamcall_ret, (_fn), (_args))
>   #define seamcall_saved_ret(_fn, _args)	sc_retry(__seamcall_saved_ret, (_fn), (_args))
>   
> +/* -1 indicates CPUID leaf with no sub-leaves. */
> +#define TDX_CPUID_NO_SUBLEAF	((u32)-1)
>   struct tdx_cpuid_config {
>   	__struct_group(tdx_cpuid_config_leaf, leaf_sub_leaf, __packed,
>   		u32 leaf;
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 3fbd43d5177b..7112546bd1d0 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -570,6 +570,7 @@ struct kvm_pmu_event_filter {
>   /* Trust Domain eXtension sub-ioctl() commands. */
>   enum kvm_tdx_cmd_id {
>   	KVM_TDX_CAPABILITIES = 0,
> +	KVM_TDX_INIT_VM,
>   
>   	KVM_TDX_CMD_NR_MAX,
>   };
> @@ -617,4 +618,30 @@ struct kvm_tdx_capabilities {
>   	struct kvm_tdx_cpuid_config cpuid_configs[];
>   };
>   
> +struct kvm_tdx_init_vm {
> +	__u64 attributes;
> +	__u64 mrconfigid[6];	/* sha384 digest */
> +	__u64 mrowner[6];	/* sha384 digest */
> +	__u64 mrownerconfig[6];	/* sha348 digest */
s/sha348/sha384

Also, the "struct kvm_tdx_init_vm" here is not aligned of
which in tools/arch/x86/include/uapi/asm/kvm.h,
which one is correct?

> +	/*
> +	 * For future extensibility to make sizeof(struct kvm_tdx_init_vm) = 8KB.
> +	 * This should be enough given sizeof(TD_PARAMS) = 1024.
> +	 * 8KB was chosen given because
> +	 * sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES(=256) = 8KB.
> +	 */
> +	__u64 reserved[1004];
> +
> +	/*
> +	 * Call KVM_TDX_INIT_VM before vcpu creation, thus before
> +	 * KVM_SET_CPUID2.
> +	 * This configuration supersedes KVM_SET_CPUID2s for VCPUs because the
> +	 * TDX module directly virtualizes those CPUIDs without VMM.  The user
> +	 * space VMM, e.g. qemu, should make KVM_SET_CPUID2 consistent with
> +	 * those values.  If it doesn't, KVM may have wrong idea of vCPUIDs of
> +	 * the guest, and KVM may wrongly emulate CPUIDs or MSRs that the TDX
> +	 * module doesn't virtualize.
> +	 */
> +	struct kvm_cpuid2 cpuid;
> +};
> +
>   #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index dda6fc4cfae8..8074c5313d6f 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1422,6 +1422,13 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>   	return r;
>   }
>   
> +struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(
> +	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index)
> +{
> +	return cpuid_entry2_find(entries, nent, function, index);
> +}
> +EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry2);
> +
>   struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
>   						    u32 function, u32 index)
>   {
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 0b90532b6e26..dccd1dd03ed4 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -13,6 +13,8 @@ void kvm_set_cpu_caps(void);
>   
>   void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
>   void kvm_update_pv_runtime(struct kvm_vcpu *vcpu);
> +struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(struct kvm_cpuid_entry2 *entries,
> +					       int nent, u32 function, u64 index);
>   struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
>   						    u32 function, u32 index);
>   struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 692619411da2..6017e0feac1e 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -7,7 +7,6 @@
>   #include "x86_ops.h"
>   #include "mmu.h"
>   #include "tdx.h"
> -#include "tdx_ops.h"
>   #include "x86.h"
>   
>   #undef pr_fmt
> @@ -317,18 +316,21 @@ static int tdx_do_tdh_mng_key_config(void *param)
>   	return 0;
>   }
>   
> -static int __tdx_td_init(struct kvm *kvm);
> -
>   int tdx_vm_init(struct kvm *kvm)
>   {
> +	/*
> +	 * This function initializes only KVM software construct.  It doesn't
> +	 * initialize TDX stuff, e.g. TDCS, TDR, TDCX, HKID etc.
> +	 * It is handled by KVM_TDX_INIT_VM, __tdx_td_init().
> +	 */
> +
>   	/*
>   	 * TDX has its own limit of the number of vcpus in addition to
>   	 * KVM_MAX_VCPUS.
>   	 */
>   	kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);
>   
> -	/* Place holder for TDX specific logic. */
> -	return __tdx_td_init(kvm);
> +	return 0;
>   }
>   
>   static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
> @@ -391,9 +393,163 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>   	return ret;
>   }
>   
> -static int __tdx_td_init(struct kvm *kvm)
> +static int setup_tdparams_eptp_controls(struct kvm_cpuid2 *cpuid,
> +					struct td_params *td_params)
> +{
> +	const struct kvm_cpuid_entry2 *entry;
> +	int max_pa = 36;
> +
> +	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x80000008, 0);
> +	if (entry)
> +		max_pa = entry->eax & 0xff;
> +
> +	td_params->eptp_controls = VMX_EPTP_MT_WB;
> +	/*
> +	 * No CPU supports 4-level && max_pa > 48.
> +	 * "5-level paging and 5-level EPT" section 4.1 4-level EPT
> +	 * "4-level EPT is limited to translating 48-bit guest-physical
> +	 *  addresses."
> +	 * cpu_has_vmx_ept_5levels() check is just in case.
> +	 */
> +	if (!cpu_has_vmx_ept_5levels() && max_pa > 48)
> +		return -EINVAL;
> +	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
> +		td_params->eptp_controls |= VMX_EPTP_PWL_5;
> +		td_params->exec_controls |= TDX_EXEC_CONTROL_MAX_GPAW;
> +	} else {
> +		td_params->eptp_controls |= VMX_EPTP_PWL_4;
> +	}
> +
> +	return 0;
> +}
> +
> +static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tdsysinfo,
> +				  struct kvm_cpuid2 *cpuid,
> +				  struct td_params *td_params)
> +{
> +	int i;
> +
> +	/*
> +	 * td_params.cpuid_values: The number and the order of cpuid_value must
> +	 * be same to the one of struct tdsysinfo.{num_cpuid_config, cpuid_configs}
> +	 * It's assumed that td_params was zeroed.
> +	 */
> +	for (i = 0; i < tdsysinfo->num_cpuid_config; i++) {
> +		const struct tdx_cpuid_config *config = &tdsysinfo->cpuid_configs[i];
> +		/* TDX_CPUID_NO_SUBLEAF in TDX CPUID_CONFIG means index = 0. */
> +		u32 index = config->sub_leaf == TDX_CPUID_NO_SUBLEAF ? 0 : config->sub_leaf;
> +		const struct kvm_cpuid_entry2 *entry =
> +			kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent,
> +					      config->leaf, index);
> +		struct tdx_cpuid_value *value = &td_params->cpuid_values[i];
> +
> +		if (!entry)
> +			continue;
> +
> +		/*
> +		 * tdsysinfo.cpuid_configs[].{eax, ebx, ecx, edx}
> +		 * bit 1 means it can be configured to zero or one.
> +		 * bit 0 means it must be zero.
> +		 * Mask out non-configurable bits.
> +		 */
> +		value->eax = entry->eax & config->eax;
> +		value->ebx = entry->ebx & config->ebx;
> +		value->ecx = entry->ecx & config->ecx;
> +		value->edx = entry->edx & config->edx;
> +	}
> +}
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
> +	/* PT can be exposed to TD guest regardless of KVM's XSS support */

May also add description of CET to the comment.

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
> +	const struct tdsysinfo_struct *tdsysinfo;
> +	int ret;
> +
> +	tdsysinfo = tdx_get_sysinfo();
> +	if (!tdsysinfo)
> +		return -EOPNOTSUPP;
> +	if (kvm->created_vcpus)
> +		return -EBUSY;
> +
> +	if (td_params->attributes & TDX_TD_ATTRIBUTE_PERFMON) {

It should check against init_vm->attributes,
td_params->attributes is empty currently.

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
> +	td_params->attributes = init_vm->attributes;
> +	td_params->tsc_frequency = TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default_tsc_khz);
> +
> +	ret = setup_tdparams_eptp_controls(cpuid, td_params);
> +	if (ret)
> +		return ret;
> +	setup_tdparams_cpuids(tdsysinfo, cpuid, td_params);
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
> @@ -401,6 +557,7 @@ static int __tdx_td_init(struct kvm *kvm)
>   	int ret, i;
>   	u64 err;
>   
> +	*seamcall_err = 0;
>   	ret = tdx_guest_keyid_alloc();
>   	if (ret < 0)
>   		return ret;
> @@ -506,10 +663,23 @@ static int __tdx_td_init(struct kvm *kvm)
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
> @@ -552,6 +722,76 @@ static int __tdx_td_init(struct kvm *kvm)
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
> @@ -568,6 +808,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
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
> index 845b6ef9f787..fc9a8898765c 100644
> --- a/arch/x86/kvm/vmx/tdx_arch.h
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
> @@ -122,6 +122,12 @@ struct tdx_cpuid_value {
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
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h

Should drop this part according to
https://lore.kernel.org/all/Y8bZ%2FJ98V5i3wG%2Fv@google.com/


> index 7a08723e99e2..61ce7d174fcf 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -565,6 +565,7 @@ struct kvm_pmu_event_filter {
>   /* Trust Domain eXtension sub-ioctl() commands. */
>   enum kvm_tdx_cmd_id {
>   	KVM_TDX_CAPABILITIES = 0,
> +	KVM_TDX_INIT_VM,
>   
>   	KVM_TDX_CMD_NR_MAX,
>   };
> @@ -614,4 +615,36 @@ struct kvm_tdx_capabilities {
>   	struct kvm_tdx_cpuid_config cpuid_configs[];
>   };
>   
> +struct kvm_tdx_init_vm {
> +	__u64 attributes;
> +	__u32 max_vcpus;
> +	__u32 padding;
> +	__u64 mrconfigid[6];    /* sha384 digest */
> +	__u64 mrowner[6];       /* sha384 digest */
> +	__u64 mrownerconfig[6]; /* sha348 digest */
s/sha348/sha384

> +	union {
> +		/*
> +		 * KVM_TDX_INIT_VM is called before vcpu creation, thus before
> +		 * KVM_SET_CPUID2.  CPUID configurations needs to be passed.
> +		 *
> +		 * This configuration supersedes KVM_SET_CPUID{,2}.
> +		 * The user space VMM, e.g. qemu, should make them consistent
> +		 * with this values.
> +		 * sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES(256)
> +		 * = 8KB.
> +		 */
> +		struct {
> +			struct kvm_cpuid2 cpuid;
> +			/* 8KB with KVM_MAX_CPUID_ENTRIES. */
> +			struct kvm_cpuid_entry2 entries[];
> +		};
> +		/*
> +		 * For future extensibility.
> +		 * The size(struct kvm_tdx_init_vm) = 16KB.
> +		 * This should be enough given sizeof(TD_PARAMS) = 1024
> +		 */
> +		__u64 reserved[2028];
> +	};
> +};
> +
>   #endif /* _ASM_X86_KVM_H */


