Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0525D55DAA2
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245294AbiF1IbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 04:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbiF1IbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 04:31:00 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9789A26542;
        Tue, 28 Jun 2022 01:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656405059; x=1687941059;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BLR/tvh2tTSFmGfg3EntkRSWD9GhsnLxCEf0hX4nxP4=;
  b=EWMJqjX0A+IeIrl87BtJkWKrJZp70fpSQWUJwEejPG1Db2pWK5UMK/aS
   tiwLEpLoFcuuIgqBHdux64h7b3Tg8XCaTufwZqyRXhkPibUGT2CreRdV8
   iW6alu5YVpICB+sKEpOuiPfVuwGEDwOEnhGl1eIcF8idtE8xAc0/PSxMm
   86a+Hs9P4d9hdzC1fx7Qy86k+s/9uV61P6HkITxlekyCsbc1soMdg7y6l
   dv6f6UtdNM+0dkJLYgJeAxgMrMvF+h4XYHM5aw28m66hpqIWfu+TFMim0
   JAxKgauj6EOUvp06zvzmVWZOy7z7hmbDP5/YO+eMuo3x//kXKA9Iqu4vu
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="264715857"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="264715857"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 01:30:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="646817911"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.174.143]) ([10.249.174.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 01:30:55 -0700
Message-ID: <dd6a51df-995c-6793-3988-b096188cd447@intel.com>
Date:   Tue, 28 Jun 2022 16:30:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.10.0
Subject: Re: [PATCH v7 025/102] KVM: TDX: initialize VM with TDX specific
 parameters
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <cb901b3a0eb475d7a33507318c1ba95120fc425e.1656366338.git.isaku.yamahata@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <cb901b3a0eb475d7a33507318c1ba95120fc425e.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/28/2022 5:53 AM, isaku.yamahata@intel.com wrote:
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
> to make this cpuid config for KVM_TDX_INIT_VM and KVM_SET_CPUID2.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h       |   2 +
>   arch/x86/include/asm/tdx.h            |   3 +
>   arch/x86/include/uapi/asm/kvm.h       |  33 +++++
>   arch/x86/kvm/vmx/tdx.c                | 206 ++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.h                |  23 +++
>   tools/arch/x86/include/uapi/asm/kvm.h |  33 +++++
>   6 files changed, 300 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 342decc69649..81638987cdb9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1338,6 +1338,8 @@ struct kvm_arch {
>   	 * the global KVM_MAX_VCPU_IDS may lead to significant memory waste.
>   	 */
>   	u32 max_vcpu_ids;
> +
> +	gfn_t gfn_shared_mask;

I think it's better to put in a seperate patch or the patch that 
consumes it.

>   };
>   
...

> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 2a9dfd54189f..1273b60a1a00 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -438,6 +438,209 @@ int tdx_dev_ioctl(void __user *argp)
>   	return 0;
>   }
>   
> +/*
> + * cpuid entry lookup in TDX cpuid config way.
> + * The difference is how to specify index(subleaves).
> + * Specify index to TDX_CPUID_NO_SUBLEAF for CPUID leaf with no-subleaves.
> + */
> +static const struct kvm_cpuid_entry2 *tdx_find_cpuid_entry(
> +	const struct kvm_cpuid2 *cpuid, u32 function, u32 index)
> +{
> +	int i;
> +
> +

superfluous line

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

no need for kvm_tdx->tsc_khz field. We have kvm->arch.default_tsc_khz.
It seems kvm_tdx->tsc_khz is not used in the following patches.

...

> +
> +	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
> +	kvm_tdx->attributes = td_params->attributes;
> +	kvm_tdx->xfam = td_params->xfam;
> +	kvm_tdx->tsc_khz = TDX_TSC_25MHZ_TO_KHZ(td_params->tsc_frequency);
> +	kvm->max_vcpus = td_params->max_vcpus;
> +
> +	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
> +		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(51));
> +	else
> +		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(47));
> +

....

> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> index a9ea3573be1b..779dfd683d66 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -531,6 +531,7 @@ struct kvm_pmu_event_filter {
>   /* Trust Domain eXtension sub-ioctl() commands. */
>   enum kvm_tdx_cmd_id {
>   	KVM_TDX_CAPABILITIES = 0,
> +	KVM_TDX_INIT_VM,
>   
>   	KVM_TDX_CMD_NR_MAX,
>   };
> @@ -576,4 +577,36 @@ struct kvm_tdx_capabilities {
>   	struct kvm_tdx_cpuid_config cpuid_configs[0];
>   };
>   
> +struct kvm_tdx_init_vm {
> +	__u64 attributes;
> +	__u32 max_vcpus;
> +	__u32 tsc_khz;

it needs to align with arch/x86/include/uapi/asm/kvm.h that @tsc_khz 
needs to be removed.


