Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AC56D6D11
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 21:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbjDDTYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 15:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbjDDTYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 15:24:19 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EDD4491;
        Tue,  4 Apr 2023 12:24:16 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id t14so35058356ljd.5;
        Tue, 04 Apr 2023 12:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680636254; x=1683228254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1na0fiVivC8Na5j2Uaf+mJFXfcNvgdldYH8Ox5CYdzE=;
        b=ZqZx2t8yPW8xkvk5g872l0fyMZ9tj57Iox2RtCa+y0qlsnOPlyN/G4fxJxnxAaRrKm
         PtDXSXhNYOU6IZR4YpOxC3oWMxhvXp0351CUzpJJU5mY7Ws2+yE4OyqQVtXNYvoGkrD7
         3UcBmHUyJzvUw3x9LCPSf/NgFbDidaa9PSvoPp6UpH0YKoWLriAcrlooFXmDHiRt5ffj
         eincAk8y7aU216Aov/ccJ5wfv411Gp4awr9gDsO5Y4QLtI5bXqOET5j0MeOG5jm7DJRS
         oV/kmC8QfVBa3ZeuZ8hq4wdtnue2bvg1AtFpUAwg5GLutIO9of0O1K5/LP+8d+aLSBPq
         NOAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680636254; x=1683228254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1na0fiVivC8Na5j2Uaf+mJFXfcNvgdldYH8Ox5CYdzE=;
        b=kKxhnyobAP8p/JBQiI1Bx2xHrb6rPY6i8UYzLWY02vag9kDJ40hz9Uby3jT6RAbQ5K
         mZHC6hRExrEX7KIIkCMftgvdqsRd2B85LvZpDqLI3eBwMoknJVB/MF+xEOUYBhuyr+On
         8kcQrQKh0jTR5CuCIBHe2+YnquznY1+Gm1u3BoFpgDxSiWRYUUrjWqYhSTHXERY2GVlK
         +JE5B28EFKzyfQPKaWBwcasdCNchqcS4RfBey0N3ObXey5LmTJ+M6Yu+vy/3M2OyPJi/
         YXr2k4+cWsHC7TSpJ8j4bB9n2p6Qj/s6+iuFylo4Hk/AgRguntvZELW6myHOOBZ43Rgo
         Kpmg==
X-Gm-Message-State: AAQBX9dwjB+FbYoY/pVuYFctws2VnfXWbhztl630dl6Y0DSdG3iLI3hi
        QP1Nf4SDoTTyxxtxb0wGFqk=
X-Google-Smtp-Source: AKy350YeIQbltteRzQ2jtbmNjUBW+wR4jCD678eoRGx2DxiRRKVQQWFTpcr1g1syTG2JgSSfrs6KOg==
X-Received: by 2002:a2e:a98b:0:b0:2a5:f4dc:8b4a with SMTP id x11-20020a2ea98b000000b002a5f4dc8b4amr261120ljq.5.1680636253885;
        Tue, 04 Apr 2023 12:24:13 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id v24-20020a2e9918000000b002986d306698sm2498926lji.95.2023.04.04.12.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 12:24:13 -0700 (PDT)
Date:   Tue, 4 Apr 2023 22:23:35 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v13 020/113] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20230404222335.000079ee.zhi.wang.linux@gmail.com>
In-Reply-To: <22eed5c3e61c8a05a8870f2b40f89f954a8112ef.1678643052.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
        <22eed5c3e61c8a05a8870f2b40f89f954a8112ef.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 12 Mar 2023 10:55:44 -0700
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX requires additional parameters for TDX VM for confidential execution to
> protect its confidentiality of its memory contents and its CPU state from
> any other software, including VMM. When creating guest TD VM before
> creating vcpu, the number of vcpu, TSC frequency (that is same among
> vcpus. and it can't be changed.) CPUIDs which is emulated by the TDX
   ^ This sentence seems broken. "
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
> needs to be passed in struct kvm_tdx_init_vm.  It's device model
> responsibility to make this cpuid config for KVM_TDX_INIT_VM and
> KVM_SET_CPUID2.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> Changes from v11 to v12
> - ABI change. Changes struct kvm_tdx_init_vm layout
> ---
>  arch/x86/include/asm/tdx.h            |   3 +
>  arch/x86/include/uapi/asm/kvm.h       |  24 +++
>  arch/x86/kvm/cpuid.c                  |   7 +
>  arch/x86/kvm/cpuid.h                  |   2 +
>  arch/x86/kvm/vmx/tdx.c                | 247 ++++++++++++++++++++++++--
>  arch/x86/kvm/vmx/tdx.h                |  18 ++
>  tools/arch/x86/include/uapi/asm/kvm.h |  33 ++++
>  7 files changed, 324 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 05870e5ed131..bd09b03d7edd 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -101,6 +101,9 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
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
> index af4c5bd0af1c..68e8d544afe5 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -565,6 +565,7 @@ struct kvm_pmu_event_filter {
>  /* Trust Domain eXtension sub-ioctl() commands. */
>  enum kvm_tdx_cmd_id {
>  	KVM_TDX_CAPABILITIES = 0,
> +	KVM_TDX_INIT_VM,
>  
>  	KVM_TDX_CMD_NR_MAX,
>  };
> @@ -610,4 +611,27 @@ struct kvm_tdx_capabilities {
>  	struct kvm_tdx_cpuid_config cpuid_configs[0];
>  };
>  
> +struct kvm_tdx_init_vm {
> +	__u64 attributes;
> +	__u64 mrconfigid[6];	/* sha384 digest */
> +	__u64 mrowner[6];	/* sha384 digest */
> +	__u64 mrownerconfig[6];	/* sha348 digest */
> +	/*
> +	 * For future extensibility to make sizeof(struct kvm_tdx_init_vm) = 8KB.
> +	 * This should be enough given sizeof(TD_PARAMS) = 1024.
> +	 * 8KB was chosen given because
> +	 * sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES(=256) = 8KB.
> +	 */
> +	__u64 reserved[1004];
> +
> +	/*
> +	 * KVM_TDX_INIT_VM is called before vcpu creation, thus before
> +	 * KVM_SET_CPUID2.
> +	 * This configuration supersedes KVM_SET_CPUID2s for VCPUs. The user
> +	 * space VMM, e.g. qemu, should make KVM_SET_CPUID2 consistent with this
> +	 * values.
                   ^
                     It would be nice to have one more sentence to talk about the
consequence if QEMU configures different CPUIDs in KVM_TDX_INIT_VM and the later
SET_CPUID2.
> +	 */
> +	struct kvm_cpuid2 cpuid;
> +};
> +
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 599aebec2d52..9cda9a3a558a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1386,6 +1386,13 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>  	return r;
>  }
>  
> +struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2( struct kvm_cpuid2 *cpuid,
> +						u32 function, u32 index)
> +{
> +	return cpuid_entry2_find(cpuid->entries, cpuid->nent, function, index);
> +}
> +EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry2);
> +
>  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
>  						    u32 function, u32 index)
>  {
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index b1658c0de847..a0e799297629 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -13,6 +13,8 @@ void kvm_set_cpu_caps(void);
>  
>  void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
>  void kvm_update_pv_runtime(struct kvm_vcpu *vcpu);
> +struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(struct kvm_cpuid2 *cpuid,
> +					       u32 function, u32 index);
>  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
>  						    u32 function, u32 index);
>  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 3ede8a726b47..496410ec6334 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -6,7 +6,6 @@
>  #include "capabilities.h"
>  #include "x86_ops.h"
>  #include "tdx.h"
> -#include "tdx_ops.h"
>  #include "x86.h"
>  
>  #undef pr_fmt
> @@ -303,18 +302,21 @@ static int tdx_do_tdh_mng_key_config(void *param)
>  	return 0;
>  }
>  
> -static int __tdx_td_init(struct kvm *kvm);
> -
>  int tdx_vm_init(struct kvm *kvm)
>  {
> +	/*
> +	 * This function initializes only KVM software construct.  It doesn't
> +	 * initialize TDX stuff, e.g. TDCS, TDR, TDCX, HKID etc.
> +	 * It is handled by KVM_TDX_INIT_VM, __tdx_td_init().
> +	 */
> +
>  	/*
>  	 * TDX has its own limit of the number of vcpus in addition to
>  	 * KVM_MAX_VCPUS.
>  	 */
>  	kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);
>  
> -	/* Place holder for TDX specific logic. */
> -	return __tdx_td_init(kvm);
> +	return 0;
>  }
>  
>  int tdx_dev_ioctl(void __user *argp)
> @@ -368,9 +370,162 @@ int tdx_dev_ioctl(void __user *argp)
>  	return 0;
>  }
>  
> -static int __tdx_td_init(struct kvm *kvm)
> +static void setup_tdparams_eptp_controls(struct kvm_cpuid2 *cpuid, struct td_params *td_params)
> +{
> +	const struct kvm_cpuid_entry2 *entry;
> +	int max_pa = 36;
> +
> +	entry = kvm_find_cpuid_entry2(cpuid, 0x80000008, 0);
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
> +		u32 index = config->sub_leaf == TDX_CPUID_NO_SUBLEAF ? 0: config->sub_leaf;
> +		const struct kvm_cpuid_entry2 *entry =
> +			kvm_find_cpuid_entry2(cpuid, config->leaf, index);
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
> +	entry = kvm_find_cpuid_entry2(cpuid, 0xd, 0);
> +	if (entry)
> +		guest_supported_xcr0 = (entry->eax | ((u64)entry->edx << 32));
> +	else
> +		guest_supported_xcr0 = 0;
> +	guest_supported_xcr0 &= kvm_caps.supported_xcr0;
> +
> +	entry = kvm_find_cpuid_entry2(cpuid, 0xd, 1);
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
> +		return -ENOTSUPP;
> +	if (kvm->created_vcpus)
> +		return -EBUSY;
> +
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
> +	td_params->max_vcpus = kvm->max_vcpus;
> +	td_params->attributes = init_vm->attributes;
> +	td_params->tsc_frequency = TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default_tsc_khz);
> +
> +	setup_tdparams_eptp_controls(cpuid, td_params);
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
> +static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params)
>  {
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct tdx_module_output out;
>  	cpumask_var_t packages;
>  	unsigned long *tdcs_pa = NULL;
>  	unsigned long tdr_pa = 0;
> @@ -484,10 +639,13 @@ static int __tdx_td_init(struct kvm *kvm)
>  		}
>  	}
>  
> -	/*
> -	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
> -	 * ioctl() to define the configure CPUID values for the TD.
> -	 */
> +	err = tdh_mng_init(kvm_tdx->tdr_pa, __pa(td_params), &out);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_INIT, err, &out);
> +		ret = -EIO;
> +		goto teardown;
> +	}
> +
>  	return 0;
>  
>  	/*
> @@ -522,6 +680,72 @@ static int __tdx_td_init(struct kvm *kvm)
>  	return ret;
>  }
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
> +			   sizeof(init_vm->cpuid.entries[0]) * init_vm->cpuid.nent)) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
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
> +}
> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_tdx_cmd tdx_cmd;
> @@ -535,6 +759,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
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
> index 4b790503e43e..1e00e75b1c5e 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -12,7 +12,11 @@ struct kvm_tdx {
>  	unsigned long tdr_pa;
>  	unsigned long *tdcs_pa;
>  
> +	u64 attributes;
> +	u64 xfam;
>  	int hkid;
> +
> +	u64 tsc_offset;
>  };
>  
>  struct vcpu_tdx {
> @@ -39,6 +43,20 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
>  {
>  	return container_of(vcpu, struct vcpu_tdx, vcpu);
>  }
> +
> +static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
> +{
> +	struct tdx_module_output out;
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
>  #else
>  struct kvm_tdx {
>  	struct kvm kvm;
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> index af4c5bd0af1c..c0f011384934 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -565,6 +565,7 @@ struct kvm_pmu_event_filter {
>  /* Trust Domain eXtension sub-ioctl() commands. */
>  enum kvm_tdx_cmd_id {
>  	KVM_TDX_CAPABILITIES = 0,
> +	KVM_TDX_INIT_VM,
>  
>  	KVM_TDX_CMD_NR_MAX,
>  };
> @@ -610,4 +611,36 @@ struct kvm_tdx_capabilities {
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

