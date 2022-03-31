Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE254ED31B
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 06:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiCaE4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 00:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiCaE4w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 00:56:52 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7694AE0C;
        Wed, 30 Mar 2022 21:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648702506; x=1680238506;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=crMeP9YAde2CTGHdA4xFwFZkSqtmw7o1yT32N4SwJPo=;
  b=QoaXq1tSgvxzbGrgr80mOvyMOowb+yvxI/xrVEuGceaanjxz7V9StB2i
   eOry/qLV0K2VWgtIjfuNqrXXOHmYP0H0kCHLR2uphj3uRHzjd6NFZAVLN
   UOMcd6gicziERhsyMA355kfn86sS9aS4JPChQRSVt2qTzbYSSc/lZ8nVm
   YtNINnsmwwDyfhmB/Cx5NVcZE7HpqUBjxxrYqD8fopLY7F3Ok4eOSU0eU
   PeEjy70YCzRqJWEWPzGXg1NHE2of0ZCHbHPot0oH2tZzfTLoTxK+L7LaY
   DU9MLqmt+dJ08zfQEg+x5iSfPb3qCqcPJTUepforB+DrhETm0IGazwUdG
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="320415515"
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="320415515"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 21:55:05 -0700
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="554927743"
Received: from dhathawa-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.53.226])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 21:55:03 -0700
Message-ID: <509fb6fb5c581e6bf14149dff17d7426a6b061f2.camel@intel.com>
Subject: Re: [RFC PATCH v5 027/104] KVM: TDX: initialize VM with TDX
 specific parameters
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 31 Mar 2022 17:55:01 +1300
In-Reply-To: <c3b37cf5c83f92be0e153075d81a80729bf1031e.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <c3b37cf5c83f92be0e153075d81a80729bf1031e.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
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
> encrypts memory per-guest bases.  It assigns Device model passes per-VM
> parameters for the TDX guest.  The maximum number of vcpus, tsc frequency
> (TDX guest has fised VM-wide TSC frequency. not per-vcpu.  The TDX guest
> can not change it.), attributes (production or debug), available extended
> features (which is reflected into guest XCR0, IA32_XSS MSR), cpuids, sha384
> measurements, and etc.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h       |   2 +
>  arch/x86/include/uapi/asm/kvm.h       |  12 ++
>  arch/x86/kvm/vmx/tdx.c                | 200 ++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h                |  26 ++++
>  arch/x86/kvm/x86.c                    |   3 +-
>  arch/x86/kvm/x86.h                    |   2 +
>  tools/arch/x86/include/uapi/asm/kvm.h |  12 ++
>  7 files changed, 256 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5ff7a0fba311..290e200f012c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1234,6 +1234,8 @@ struct kvm_arch {
>  	hpa_t	hv_root_tdp;
>  	spinlock_t hv_root_tdp_lock;
>  #endif
> +
> +	gfn_t gfn_shared_mask;
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 70f9be4ea575..6e26dde0dce6 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -531,6 +531,7 @@ struct kvm_pmu_event_filter {
>  /* Trust Domain eXtension sub-ioctl() commands. */
>  enum kvm_tdx_cmd_id {
>  	KVM_TDX_CAPABILITIES = 0,
> +	KVM_TDX_INIT_VM,
>  
>  	KVM_TDX_CMD_NR_MAX,
>  };
> @@ -561,4 +562,15 @@ struct kvm_tdx_capabilities {
>  	struct kvm_tdx_cpuid_config cpuid_configs[0];
>  };
>  
> +struct kvm_tdx_init_vm {
> +	__u32 max_vcpus;
> +	__u32 tsc_khz;
> +	__u64 attributes;
> +	__u64 cpuid;

Is it better to append all CPUIDs directly into this structure, perhaps at end
of this structure, to make it more consistent with TD_PARAMS?

Also, I think somewhere in commit message or comments we should explain why
CPUIDs are passed here (why existing KVM_SET_CUPID2 is not sufficient).

> +	__u64 mrconfigid[6];	/* sha384 digest */
> +	__u64 mrowner[6];	/* sha384 digest */
> +	__u64 mrownerconfig[6];	/* sha348 digest */
> +	__u64 reserved[43];	/* must be zero for future extensibility */
> +};
> +
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 20b45bb0b032..236faaca68a0 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -387,6 +387,203 @@ static int tdx_capabilities(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>  	return 0;
>  }
>  
> +static struct kvm_cpuid_entry2 *tdx_find_cpuid_entry(struct kvm_tdx *kvm_tdx,
> +						u32 function, u32 index)
> +{
> +	struct kvm_cpuid_entry2 *e;
> +	int i;
> +
> +	for (i = 0; i < kvm_tdx->cpuid_nent; i++) {
> +		e = &kvm_tdx->cpuid_entries[i];
> +
> +		if (e->function == function && (e->index == index ||
> +		    !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
> +			return e;
> +	}
> +	return NULL;
> +}
> +
> +static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
> +			struct kvm_tdx_init_vm *init_vm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct tdx_cpuid_config *config;
> +	struct kvm_cpuid_entry2 *entry;
> +	struct tdx_cpuid_value *value;
> +	u64 guest_supported_xcr0;
> +	u64 guest_supported_xss;
> +	u32 guest_tsc_khz;
> +	int max_pa;
> +	int i;
> +
> +	/* init_vm->reserved must be zero */
> +	if (find_first_bit((unsigned long *)init_vm->reserved,
> +			   sizeof(init_vm->reserved) * 8) !=
> +	    sizeof(init_vm->reserved) * 8)
> +		return -EINVAL;
> +
> +	td_params->max_vcpus = init_vm->max_vcpus;
> +
> +	td_params->attributes = init_vm->attributes;
> +	if (td_params->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
> +		pr_warn("TD doesn't support perfmon. KVM needs to save/restore "
> +			"host perf registers properly.\n");
> +		return -EOPNOTSUPP;
> +	}

PERFMON can be supported but it's not support in this series, so perhaps add a
comment to explain it's a TODO?

> +
> +	/* TODO: Enforce consistent CPUID features for all vCPUs. */

I guess you have to enforce when you do KVM_SET_CPUID2 after vcpu is created?
Then I guess this comment shouldn't be here, because the enforcement isn't
something you can do here in setup_tdparams().

> +	for (i = 0; i < tdx_caps.nr_cpuid_configs; i++) {
> +		config = &tdx_caps.cpuid_configs[i];
> +
> +		entry = tdx_find_cpuid_entry(kvm_tdx, config->leaf,
> +					     config->sub_leaf);
> +		if (!entry)
> +			continue;
> +
> +		/*
> +		 * Non-configurable bits must be '0', even if they are fixed to
> +		 * '1' by the TDX module, i.e. mask off non-configurable bits.
> +		 */
> +		value = &td_params->cpuid_values[i];
> +		value->eax = entry->eax & config->eax;
> +		value->ebx = entry->ebx & config->ebx;
> +		value->ecx = entry->ecx & config->ecx;
> +		value->edx = entry->edx & config->edx;
> +	}
> +
> +	max_pa = 36;
> +	entry = tdx_find_cpuid_entry(kvm_tdx, 0x80000008, 0);
> +	if (entry)
> +		max_pa = entry->eax & 0xff;
> +
> +	td_params->eptp_controls = VMX_EPTP_MT_WB;
> +	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
> +		td_params->eptp_controls |= VMX_EPTP_PWL_5;
> +		td_params->exec_controls |= TDX_EXEC_CONTROL_MAX_GPAW;
> +	} else {
> +		td_params->eptp_controls |= VMX_EPTP_PWL_4;
> +	}

Not quite sure, but could we support >48 GPA with 4-level EPT?



