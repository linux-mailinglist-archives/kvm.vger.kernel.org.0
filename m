Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F90A65CDF1
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 08:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbjADH7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 02:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbjADH7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 02:59:17 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65011868D;
        Tue,  3 Jan 2023 23:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672819155; x=1704355155;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=USF2fanSgaIK7zt2gxBK+vlxIsNSVKalkrSdoHPqaEM=;
  b=UZFshW1LXSa3lNDh4zTEYXlDcIFR5LAlB4adGD8lDxTOVsLuESnv/tfo
   yVa48D4rOhy0DAk6+R9hXnqwa/iUmmuHJ/yDYz0yUIRnnF8zLKyGHW8in
   NECp71oC4qo7YRGXspgjYBLCya4eFXRerKWnutUa7BWxQtSxL0bjypG7Y
   WPObmzKnCd3gSTEOyYuU6ih2z3e/jaUbX79K8i0GCa2byW1MSRNEo4hzL
   E6oqdGxVtHPZ104VUGjjoamZDCAbEBQkow8/8JWx9vaNE9x3zeBKCUhlO
   gT2ieQfq6ac5n7X+lpxQ3VoPhPZFmP6inEFG92KFHg37YP7YAOejtLRtw
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="323868674"
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="323868674"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 23:59:15 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="685673579"
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="685673579"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.254.214.111]) ([10.254.214.111])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 23:59:12 -0800
Message-ID: <f9d7c13e-e96c-2afd-4c8b-cb7f17d61445@intel.com>
Date:   Wed, 4 Jan 2023 15:59:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.1
Subject: Re: [PATCH v10 021/108] KVM: TDX: initialize VM with TDX specific
 parameters
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <ebb4beadff8e117d0fb643af4ee310b6608679bf.1667110240.git.isaku.yamahata@intel.com>
From:   "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <ebb4beadff8e117d0fb643af4ee310b6608679bf.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/30/2022 2:22 PM, isaku.yamahata@intel.com wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> TDX requires additional parameters for TDX VM for confidential execution to
> protect its confidentiality of its memory contents and its CPU state from
> any other software, including VMM. When creating guest TD VM before
> creating vcpu, the number of vcpu, TSC frequency (that is same among
> vcpus. and it can't be changed.)  CPUIDs which is emulated by the TDX
> module. It means guest can trust those CPUIDs. and sha384 values for
> measurement.
> 
> Add new subcommand, KVM_TDX_INIT_VM, to pass parameters for TDX guest.  It
> assigns encryption key to the TDX guest for memory encryption.  TDX
> encrypts memory per-guest bases.  It assigns device model passes per-VM
> parameters for the TDX guest.  The maximum number of vcpus, tsc frequency
> (TDX guest has fised VM-wide TSC frequency. not per-vcpu.  The TDX guest
> can not change it.), attributes (production or debug), available extended
> features (which is reflected into guest XCR0, IA32_XSS MSR), cpuids, sha384
> measurements, and etc.
> 
> This subcommand is called before creating vcpu and KVM_SET_CPUID2, i.e.
> cpuids configurations aren't available yet.  So CPUIDs configuration values
> needs to be passed in struct kvm_init_vm.  It's device model responsibility

I suppose this should be kvm_tdx_init_vm.

> to make this cpuid config for KVM_TDX_INIT_VM and KVM_SET_CPUID2.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/tdx.h            |   3 +
>  arch/x86/include/uapi/asm/kvm.h       |  31 +++
>  arch/x86/kvm/vmx/tdx.c                | 296 ++++++++++++++++++++++----
>  arch/x86/kvm/vmx/tdx.h                |  22 ++
>  tools/arch/x86/include/uapi/asm/kvm.h |  33 +++
>  5 files changed, 347 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index cd304d323d33..05ac4bfc8f8a 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -131,6 +131,9 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
>  #endif /* CONFIG_INTEL_TDX_GUEST && CONFIG_KVM_GUEST */
>  
>  #ifdef CONFIG_INTEL_TDX_HOST
> +
> +/* -1 indicates CPUID leaf with no sub-leaves. */
> +#define TDX_CPUID_NO_SUBLEAF	((u32)-1)
>  struct tdx_cpuid_config {
>  	u32	leaf;
>  	u32	sub_leaf;
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 2ad9666e02a5..26661879c031 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -538,6 +538,7 @@ struct kvm_pmu_event_filter {
>  /* Trust Domain eXtension sub-ioctl() commands. */
>  enum kvm_tdx_cmd_id {
>  	KVM_TDX_CAPABILITIES = 0,
> +	KVM_TDX_INIT_VM,
>  
>  	KVM_TDX_CMD_NR_MAX,
>  };
> @@ -583,4 +584,34 @@ struct kvm_tdx_capabilities {
>  	struct kvm_tdx_cpuid_config cpuid_configs[0];
>  };
>  
> +struct kvm_tdx_init_vm {
> +	__u64 attributes;
> +	__u64 mrconfigid[6];	/* sha384 digest */
> +	__u64 mrowner[6];	/* sha384 digest */
> +	__u64 mrownerconfig[6];	/* sha348 digest */
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
> +		__u64 reserved[2029];
> +	};
> +};
> +
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index d77709a6da51..54045e0576e7 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -284,6 +284,205 @@ static int tdx_do_tdh_mng_key_config(void *param)
>  int tdx_vm_init(struct kvm *kvm)
>  {
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +
> +	kvm_tdx->hkid = -1;
> +
> +	/*
> +	 * This function initializes only KVM software construct.  It doesn't
> +	 * initialize TDX stuff, e.g. TDCS, TDR, TDCX, HKID etc.
> +	 * It is handled by KVM_TDX_INIT_VM, __tdx_td_init().
> +	 */
> +
> +	return 0;
> +}
> +
> +int tdx_dev_ioctl(void __user *argp)
> +{
> +	struct kvm_tdx_capabilities __user *user_caps;
> +	struct kvm_tdx_capabilities caps;
> +	struct kvm_tdx_cmd cmd;
> +
> +	BUILD_BUG_ON(sizeof(struct kvm_tdx_cpuid_config) !=
> +		     sizeof(struct tdx_cpuid_config));
> +
> +	if (copy_from_user(&cmd, argp, sizeof(cmd)))
> +		return -EFAULT;
> +	if (cmd.flags || cmd.error || cmd.unused)
> +		return -EINVAL;
> +	/*
> +	 * Currently only KVM_TDX_CAPABILITIES is defined for system-scoped
> +	 * mem_enc_ioctl().
> +	 */
> +	if (cmd.id != KVM_TDX_CAPABILITIES)
> +		return -EINVAL;
> +
> +	user_caps = (void __user *)cmd.data;
> +	if (copy_from_user(&caps, user_caps, sizeof(caps)))
> +		return -EFAULT;
> +
> +	if (caps.nr_cpuid_configs < tdx_caps.nr_cpuid_configs)
> +		return -E2BIG;
> +
> +	caps = (struct kvm_tdx_capabilities) {
> +		.attrs_fixed0 = tdx_caps.attrs_fixed0,
> +		.attrs_fixed1 = tdx_caps.attrs_fixed1,
> +		.xfam_fixed0 = tdx_caps.xfam_fixed0,
> +		.xfam_fixed1 = tdx_caps.xfam_fixed1,
> +		.nr_cpuid_configs = tdx_caps.nr_cpuid_configs,
> +		.padding = 0,
> +	};
> +
> +	if (copy_to_user(user_caps, &caps, sizeof(caps)))
> +		return -EFAULT;
> +	if (copy_to_user(user_caps->cpuid_configs, &tdx_caps.cpuid_configs,
> +			 tdx_caps.nr_cpuid_configs *
> +			 sizeof(struct tdx_cpuid_config)))
> +		return -EFAULT;
> +
> +	return 0;
> +}

tdx_dev_ioctl() is introduced in previous patch with the same code added here,
which means this is just a place change and it will confuse reviewers. Is it
neccesary to do so?

> +
> +/*
> + * cpuid entry lookup in TDX cpuid config way.
> + * The difference is how to specify index(subleaves).
> + * Specify index to TDX_CPUID_NO_SUBLEAF for CPUID leaf with no-subleaves.
> + */
> +static const struct kvm_cpuid_entry2 *tdx_find_cpuid_entry(const struct kvm_cpuid2 *cpuid,
> +							   u32 function, u32 index)
> +{
> +	int i;
> +
> +	/* In TDX CPU CONFIG, TDX_CPUID_NO_SUBLEAF means index = 0. */
> +	if (index == TDX_CPUID_NO_SUBLEAF)
> +		index = 0;
> +
> +	for (i = 0; i < cpuid->nent; i++) {
> +		const struct kvm_cpuid_entry2 *e = &cpuid->entries[i];
> +
> +		if (e->function == function &&
> +		    (e->index == index ||
> +		     !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
> +			return e;
> +	}
> +	return NULL;
> +}
> +
> +static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
> +			struct kvm_tdx_init_vm *init_vm)

Indentation is broken here, please fix it.

> +{
> +	const struct kvm_cpuid2 *cpuid = &init_vm->cpuid;
> +	const struct kvm_cpuid_entry2 *entry;
> +	u64 guest_supported_xcr0;
> +	u64 guest_supported_xss;
> +	int max_pa;
> +	int i;
> +
> +	if (kvm->created_vcpus)
> +		return -EBUSY;
> +	td_params->max_vcpus = kvm->max_vcpus;
> +	td_params->attributes = init_vm->attributes;
> +	if (td_params->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
> +		/*
> +		 * TODO: save/restore PMU related registers around TDENTER.
> +		 * Once it's done, remove this guard.
> +		 */
> +		pr_warn("TD doesn't support perfmon yet. KVM needs to save/restore "
> +			"host perf registers properly.\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	for (i = 0; i < tdx_caps.nr_cpuid_configs; i++) {
> +		const struct tdx_cpuid_config *config = &tdx_caps.cpuid_configs[i];
> +		const struct kvm_cpuid_entry2 *entry =
> +			tdx_find_cpuid_entry(cpuid, config->leaf, config->sub_leaf);
> +		struct tdx_cpuid_value *value = &td_params->cpuid_values[i];
> +
> +		if (!entry)
> +			continue;
> +
> +		value->eax = entry->eax & config->eax;
> +		value->ebx = entry->ebx & config->ebx;
> +		value->ecx = entry->ecx & config->ecx;
> +		value->edx = entry->edx & config->edx;
> +	}
> +
> +	max_pa = 36;
> +	entry = tdx_find_cpuid_entry(cpuid, 0x80000008, 0);
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
> +	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
> +		td_params->eptp_controls |= VMX_EPTP_PWL_5;
> +		td_params->exec_controls |= TDX_EXEC_CONTROL_MAX_GPAW;
> +	} else {
> +		td_params->eptp_controls |= VMX_EPTP_PWL_4;
> +	}
> +
> +	/* Setup td_params.xfam */
> +	entry = tdx_find_cpuid_entry(cpuid, 0xd, 0);
> +	if (entry)
> +		guest_supported_xcr0 = (entry->eax | ((u64)entry->edx << 32));
> +	else
> +		guest_supported_xcr0 = 0;
> +	guest_supported_xcr0 &= kvm_caps.supported_xcr0;
> +
> +	entry = tdx_find_cpuid_entry(cpuid, 0xd, 1);
> +	if (entry)
> +		guest_supported_xss = (entry->ecx | ((u64)entry->edx << 32));
> +	else
> +		guest_supported_xss = 0;
> +	/* PT can be exposed to TD guest regardless of KVM's XSS support */
> +	guest_supported_xss &= (kvm_caps.supported_xss | XFEATURE_MASK_PT);
> +
> +	td_params->xfam = guest_supported_xcr0 | guest_supported_xss;
> +	if (td_params->xfam & XFEATURE_MASK_LBR) {
> +		/*
> +		 * TODO: once KVM supports LBR(save/restore LBR related
> +		 * registers around TDENTER), remove this guard.
> +		 */
> +		pr_warn("TD doesn't support LBR yet. KVM needs to save/restore "
> +			"IA32_LBR_DEPTH properly.\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (td_params->xfam & XFEATURE_MASK_XTILE) {
> +		/*
> +		 * TODO: once KVM supports AMX(save/restore AMX related
> +		 * registers around TDENTER), remove this guard.
> +		 */
> +		pr_warn("TD doesn't support AMX yet. KVM needs to save/restore "
> +			"IA32_XFD, IA32_XFD_ERR properly.\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	td_params->tsc_frequency =
> +		TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default_tsc_khz);
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
> +static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct tdx_module_output out;
>  	cpumask_var_t packages;
>  	int ret, i;
>  	u64 err;
> @@ -390,10 +589,13 @@ int tdx_vm_init(struct kvm *kvm)
>  		tdx_mark_td_page_added(&kvm_tdx->tdcs[i]);
>  	}
>  
> -	/*
> -	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
> -	 * ioctl() to define the configure CPUID values for the TD.
> -	 */
> +	err = tdh_mng_init(kvm_tdx->tdr.pa, __pa(td_params), &out);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_INIT, err, &out);
> +		ret = -EIO;
> +		goto teardown;
> +	}
> +
>  	return 0;
>  
>  	/*
> @@ -431,50 +633,65 @@ int tdx_vm_init(struct kvm *kvm)
>  	return ret;
>  }
>  
> -int tdx_dev_ioctl(void __user *argp)
> +static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>  {
> -	struct kvm_tdx_capabilities __user *user_caps;
> -	struct kvm_tdx_capabilities caps;
> -	struct kvm_tdx_cmd cmd;
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct kvm_tdx_init_vm *init_vm = NULL;
> +	struct td_params *td_params = NULL;
> +	void *entries_end;
> +	int ret;
>  
> -	BUILD_BUG_ON(sizeof(struct kvm_tdx_cpuid_config) !=
> -		     sizeof(struct tdx_cpuid_config));
> +	BUILD_BUG_ON(sizeof(*init_vm) != 16 * 1024);
> +	BUILD_BUG_ON((sizeof(*init_vm) - offsetof(typeof(*init_vm), entries)) /
> +		     sizeof(init_vm->entries[0]) < KVM_MAX_CPUID_ENTRIES);
> +	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
>  
> -	if (copy_from_user(&cmd, argp, sizeof(cmd)))
> -		return -EFAULT;
> -	if (cmd.flags || cmd.error || cmd.unused)
> +	if (is_td_initialized(kvm))
>  		return -EINVAL;
> -	/*
> -	 * Currently only KVM_TDX_CAPABILITIES is defined for system-scoped
> -	 * mem_enc_ioctl().
> -	 */
> -	if (cmd.id != KVM_TDX_CAPABILITIES)
> +
> +	if (cmd->flags)
>  		return -EINVAL;
>  
> -	user_caps = (void __user *)cmd.data;
> -	if (copy_from_user(&caps, user_caps, sizeof(caps)))
> -		return -EFAULT;
> +	init_vm = kzalloc(sizeof(*init_vm), GFP_KERNEL);
> +	if (copy_from_user(init_vm, (void __user *)cmd->data, sizeof(*init_vm))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
>  
> -	if (caps.nr_cpuid_configs < tdx_caps.nr_cpuid_configs)
> -		return -E2BIG;
> +	ret = -EINVAL;
> +	if (init_vm->cpuid.padding)
> +		goto out;
> +	/* init_vm->entries shouldn't overrun. */
> +	entries_end = init_vm->entries + init_vm->cpuid.nent;
> +	if (entries_end > (void *)(init_vm + 1))
> +		goto out;
> +	/* Unused part must be zero. */
> +	if (memchr_inv(entries_end, 0, (void *)(init_vm + 1) - entries_end))
> +		goto out;
>  
> -	caps = (struct kvm_tdx_capabilities) {
> -		.attrs_fixed0 = tdx_caps.attrs_fixed0,
> -		.attrs_fixed1 = tdx_caps.attrs_fixed1,
> -		.xfam_fixed0 = tdx_caps.xfam_fixed0,
> -		.xfam_fixed1 = tdx_caps.xfam_fixed1,
> -		.nr_cpuid_configs = tdx_caps.nr_cpuid_configs,
> -		.padding = 0,
> -	};
> +	td_params = kzalloc(sizeof(struct td_params), GFP_KERNEL);
> +	if (!td_params) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
>  
> -	if (copy_to_user(user_caps, &caps, sizeof(caps)))
> -		return -EFAULT;
> -	if (copy_to_user(user_caps->cpuid_configs, &tdx_caps.cpuid_configs,
> -			 tdx_caps.nr_cpuid_configs *
> -			 sizeof(struct tdx_cpuid_config)))
> -		return -EFAULT;
> +	ret = setup_tdparams(kvm, td_params, init_vm);
> +	if (ret)
> +		goto out;
>  
> -	return 0;
> +	ret = __tdx_td_init(kvm, td_params);
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
>  }
>  
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> @@ -490,6 +707,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  	mutex_lock(&kvm->lock);
>  
>  	switch (tdx_cmd.id) {
> +	case KVM_TDX_INIT_VM:
> +		r = tdx_td_init(kvm, &tdx_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 938314635b47..ff0ea9cad347 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -18,7 +18,11 @@ struct kvm_tdx {
>  	struct tdx_td_page tdr;
>  	struct tdx_td_page *tdcs;
>  
> +	u64 attributes;
> +	u64 xfam;
>  	int hkid;
> +
> +	u64 tsc_offset;
>  };
>  
>  struct vcpu_tdx {
> @@ -48,6 +52,11 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
>  	return container_of(vcpu, struct vcpu_tdx, vcpu);
>  }
>  
> +static inline bool is_td_initialized(struct kvm *kvm)
> +{
> +	return to_kvm_tdx(kvm)->hkid > 0;
> +}

There is a similar function, is_hkid_assigned(), which is previously defined. Do
you think redefining a new function here will bring code redundency?

> +
>  static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
>  {
>  #define VMCS_ENC_ACCESS_TYPE_MASK	0x1UL
> @@ -148,6 +157,19 @@ TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
>  TDX_BUILD_TDVPS_ACCESSORS(64, STATE_NON_ARCH, state_non_arch);
>  TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
>  
> +static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
> +{
> +	struct tdx_module_output out;
> +	u64 err;
> +
> +	err = tdh_mng_rd(kvm_tdx->tdr.pa, TDCS_EXEC(field), &out);
> +	if (unlikely(err)) {
> +		pr_err("TDH_MNG_RD[EXEC.0x%x] failed: 0x%llx\n", field, err);
> +		return 0;
> +	}
> +	return out.r8;
> +}
> +
>  #else
>  struct kvm_tdx {
>  	struct kvm kvm;
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> index 2ad9666e02a5..531a0033e530 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -538,6 +538,7 @@ struct kvm_pmu_event_filter {
>  /* Trust Domain eXtension sub-ioctl() commands. */
>  enum kvm_tdx_cmd_id {
>  	KVM_TDX_CAPABILITIES = 0,
> +	KVM_TDX_INIT_VM,
>  
>  	KVM_TDX_CMD_NR_MAX,
>  };
> @@ -583,4 +584,36 @@ struct kvm_tdx_capabilities {
>  	struct kvm_tdx_cpuid_config cpuid_configs[0];
>  };
>  
> +struct kvm_tdx_init_vm {
> +	__u64 attributes;
> +	__u32 max_vcpus;
> +	__u32 padding;
> +	__u64 mrconfigid[6];    /* sha384 digest */
> +	__u64 mrowner[6];       /* sha384 digest */
> +	__u64 mrownerconfig[6]; /* sha348 digest */
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
>  #endif /* _ASM_X86_KVM_H */
