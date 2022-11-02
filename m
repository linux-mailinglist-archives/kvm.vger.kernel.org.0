Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36268615D54
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 09:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiKBIG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 04:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiKBIG1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 04:06:27 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65637275E2;
        Wed,  2 Nov 2022 01:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667376385; x=1698912385;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=x7lpqK2HGRRRUovKsHDPJSVlmxxxInIp+kFv4G/OMtY=;
  b=dY7SKXy7Les/Q9mnGXLPOSdSQhsErYEVKIADv6mWjKh7UzEU1oar5AHa
   yrD/fbrX48/1ta1XwpnZ3nOHzDoHkKghNpG1gojE0D9ydFVFFKhu+gLvQ
   /topj3J7Lnynxjx33CRI8z1N93gk0Zy3cfVzTQ81l8eihgMH7vK9Zdw52
   YOj4hAUiiswmAjtiTeaEmVxxp5vDyScxLLm2xulKfwloJUIXztkkBQvGK
   IuFqMf8hkWWchgM9jQpN/siey26ppjm3oK9784pmyra/+oyiK5jL1UqjK
   2wB1agBIL6YHpOqGueWvxZ0kWcqXWSFUM4f+9nqdrWy4xdDYUunM/y2TS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="289056823"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="289056823"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 01:06:25 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="697714153"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="697714153"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.28.60]) ([10.255.28.60])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 01:06:22 -0700
Message-ID: <5bb42920-cd17-e235-bfe0-ba05f1e2b5bc@linux.intel.com>
Date:   Wed, 2 Nov 2022 16:06:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v10 017/108] KVM: TDX: Refuse to unplug the last cpu on
 the package
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <de6b69781a6ba1fe65535f48db2677eef3ec6a83.1667110240.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <de6b69781a6ba1fe65535f48db2677eef3ec6a83.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/10/30 14:22, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> In order to reclaim TDX host key id, (i.e. when deleting guest TD), needs
> to call TDH.PHYMEM.PAGE.WBINVD on all packages.  If we have used TDX host
> key id, refuse to offline the last online cpu.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |  1 +
>   arch/x86/include/asm/kvm_host.h    |  1 +
>   arch/x86/kvm/vmx/main.c            |  1 +
>   arch/x86/kvm/vmx/tdx.c             | 40 +++++++++++++++++++++++++++++-
>   arch/x86/kvm/vmx/x86_ops.h         |  2 ++
>   arch/x86/kvm/x86.c                 | 27 ++++++++++++--------
>   6 files changed, 61 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 3a29a6b31ee8..0ceb8e58a6c0 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -17,6 +17,7 @@ BUILD_BUG_ON(1)
>   KVM_X86_OP(hardware_enable)
>   KVM_X86_OP(hardware_disable)
>   KVM_X86_OP(hardware_unsetup)
> +KVM_X86_OP_OPTIONAL_RET0(offline_cpu)
>   KVM_X86_OP(has_emulated_msr)
>   KVM_X86_OP(vcpu_after_set_cpuid)
>   KVM_X86_OP(is_vm_type_supported)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2870155ce6fb..50b39d0071ff 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1466,6 +1466,7 @@ struct kvm_x86_ops {
>   	int (*hardware_enable)(void);
>   	void (*hardware_disable)(void);
>   	void (*hardware_unsetup)(void);
> +	int (*offline_cpu)(void);
>   	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
>   	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
>   
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index d01a946a18cf..0918d1e6d2f3 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -67,6 +67,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.name = "kvm_intel",
>   
>   	.hardware_unsetup = vt_hardware_unsetup,
> +	.offline_cpu = tdx_offline_cpu,
>   	.check_processor_compatibility = vmx_check_processor_compatibility,
>   
>   	.hardware_enable = vmx_hardware_enable,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index ec88dde0d300..64229c3b3c5a 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -42,6 +42,7 @@ static struct tdx_capabilities tdx_caps;
>    */
>   static DEFINE_MUTEX(tdx_lock);
>   static struct mutex *tdx_mng_key_config_lock;
> +static atomic_t nr_configured_hkid;
>   
>   static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
>   {
> @@ -222,7 +223,8 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>   		pr_err("tdh_mng_key_freeid failed. HKID %d is leaked.\n",
>   			kvm_tdx->hkid);
>   		return;
> -	}
> +	} else
> +		atomic_dec(&nr_configured_hkid);
>   
>   free_hkid:
>   	tdx_hkid_free(kvm_tdx);
> @@ -371,6 +373,8 @@ int tdx_vm_init(struct kvm *kvm)
>   		if (ret)
>   			break;
>   	}
> +	if (!ret)
> +		atomic_inc(&nr_configured_hkid);
>   	cpus_read_unlock();
>   	free_cpumask_var(packages);
>   	if (ret)
> @@ -514,3 +518,37 @@ void tdx_hardware_unsetup(void)
>   	/* kfree accepts NULL. */
>   	kfree(tdx_mng_key_config_lock);
>   }
> +
> +int tdx_offline_cpu(void)
> +{
> +	int curr_cpu = smp_processor_id();
> +	cpumask_var_t packages;
> +	int ret = 0;
> +	int i;
> +
> +	if (!atomic_read(&nr_configured_hkid))
> +		return 0;
> +
> +	/*
> +	 * To reclaim hkid, need to call TDH.PHYMEM.PAGE.WBINVD on all packages.
> +	 * If this is the last online cpu on the package, refuse offline.
> +	 */
> +	if (!zalloc_cpumask_var(&packages, GFP_KERNEL))
> +		return -ENOMEM;
> +
> +	for_each_online_cpu(i) {
> +		if (i != curr_cpu)
> +			cpumask_set_cpu(topology_physical_package_id(i), packages);
> +	}
> +	if (!cpumask_test_cpu(topology_physical_package_id(curr_cpu), packages))
> +		ret = -EBUSY;
> +	free_cpumask_var(packages);
> +	if (ret)
> +		/*
> +		 * Because it's hard for human operator to understand the
> +		 * reason, warn it.
> +		 */
> +		pr_warn("TDX requires all packages to have an online CPU.  "
> +			"Delete all TDs in order to offline all CPUs of a package.\n");
> +	return ret;
> +}
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 95da978c9aa9..b2cb5786830a 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -134,6 +134,7 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
>   int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
>   bool tdx_is_vm_type_supported(unsigned long type);
>   void tdx_hardware_unsetup(void);
> +int tdx_offline_cpu(void);
>   
>   int tdx_vm_init(struct kvm *kvm);
>   void tdx_mmu_release_hkid(struct kvm *kvm);
> @@ -142,6 +143,7 @@ void tdx_vm_free(struct kvm *kvm);
>   static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
>   static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
>   static inline void tdx_hardware_unsetup(void) {}
> +static inline int tdx_offline_cpu(void) { return 0; }
>   
>   static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
>   static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4b22196cb12c..25c30c8c2d9b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12337,16 +12337,23 @@ int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
>   
>   int kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
>   {
> -	if (usage_count) {
> -		/*
> -		 * arch callback kvm_arch_hardware_disable() assumes that
> -		 * preemption is disabled for historical reason.  Disable
> -		 * preemption until all arch callbacks are fixed.
> -		 */
> -		preempt_disable();
> -		hardware_disable(NULL);
> -		preempt_enable();
> -	}
> +	int ret;
> +
> +	if (!usage_count)
> +		return 0;
> +
> +	ret = static_call(kvm_x86_offline_cpu)();

Use static_call_cond instead?
Seems the new interface for x86 is only implemented for Intel.


> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * arch callback kvm_arch_hardware_disable() assumes that preemption is
> +	 * disabled for historical reason.  Disable preemption until all arch
> +	 * callbacks are fixed.
> +	 */
> +	preempt_disable();
> +	hardware_disable(NULL);
> +	preempt_enable();
>   	return 0;
>   }
>   
