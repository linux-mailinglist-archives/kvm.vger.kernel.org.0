Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E35B628FE9
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 03:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiKOC2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 21:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiKOC22 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 21:28:28 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7E264E3;
        Mon, 14 Nov 2022 18:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668479307; x=1700015307;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=56E4m5bJqKHt3xAQjNtHZH9cYY7UhcBHc5g80ledtOU=;
  b=Coc51Ulo5FlseXRRH+Uk9JQSjefeEKxAnvooB4qxNJnsSxLaYncrYXtQ
   W/IzaN/yvHTYQ6TOjwGiTfetnRC3iBtKAw5ptw7z62ounyRFI7R15orq0
   1P5IqlJ1lw2fCplj8xOhI9Km0njq3fAJK4mGpuzFXaVpvIj50y0fKDHSn
   qNVR02/FwzmxuwDOF33ItYB/MnIT3rAviQ6hc9GjWRy5Gz7Fl7afIjHE5
   Y6sA7BO0W5XdWdGQJRMzch5KSsBfqnn4t9tTTCDE/ix1qECgVMWMiHxyR
   GB+ajWOz0Z0YPcmKRVF/PzMMZ2TsqaL+0pNrw7CVp/5PSpDhlwqNIlh9T
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="310847348"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="310847348"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 18:28:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="727773453"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="727773453"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.31.168]) ([10.255.31.168])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 18:28:22 -0800
Message-ID: <b6276f58-8ff5-9a3c-e6c7-c38f2ddb682a@linux.intel.com>
Date:   Tue, 15 Nov 2022 10:28:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v10 076/108] KVM: TDX: handle vcpu migration over logical
 processor
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <782f74f7d5375a36b2857be59262c1c4c4cf16a7.1667110240.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <782f74f7d5375a36b2857be59262c1c4c4cf16a7.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/30/2022 2:23 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> For vcpu migration, in the case of VMX, VCMS

typo, VMCS


>   is flushed on the source pcpu,
> and load it on the target pcpu.  There are corresponding TDX SEAMCALL APIs,
> call them on vcpu migration.  The logic is mostly same as VMX except the
> TDX SEAMCALLs are used.
>
> When shutting down the machine, (VMX or TDX) vcpus needs to be shutdown on
> each pcpu.  Do the similar for TDX with TDX SEAMCALL APIs.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c    |  43 +++++++++++--
>   arch/x86/kvm/vmx/tdx.c     | 121 +++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.h     |   2 +
>   arch/x86/kvm/vmx/x86_ops.h |   6 ++
>   4 files changed, 168 insertions(+), 4 deletions(-)
>
>
> @@ -176,6 +214,41 @@ static void tdx_reclaim_td_page(struct tdx_td_page *page)
>   	}
>   }
>   
> +static void tdx_flush_vp(void *arg)
> +{
> +	struct kvm_vcpu *vcpu = arg;
> +	u64 err;
> +
> +	lockdep_assert_irqs_disabled();
> +
> +	/* Task migration can race with CPU offlining. */
> +	if (vcpu->cpu != raw_smp_processor_id())
> +		return;
> +
> +	/*
> +	 * No need to do TDH_VP_FLUSH if the vCPU hasn't been initialized.  The
> +	 * list tracking still needs to be updated so that it's correct if/when
> +	 * the vCPU does get initialized.
> +	 */
> +	if (is_td_vcpu_created(to_tdx(vcpu))) {
> +		err = tdh_vp_flush(to_tdx(vcpu)->tdvpr.pa);

Need to retry here if tdh.vp.flush fails due to tdx operand busy?

If such failure occurs, the next vp enter will fail after the vCPU 
migrated to another LP, how is it hanlded?



> +		if (unlikely(err && err != TDX_VCPU_NOT_ASSOCIATED)) {
> +			if (WARN_ON_ONCE(err))
> +				pr_tdx_error(TDH_VP_FLUSH, err, NULL);
> +		}
> +	}
> +
> +	tdx_disassociate_vp(vcpu);
> +}
> +
> +static void tdx_flush_vp_on_cpu(struct kvm_vcpu *vcpu)
> +{
> +	if (unlikely(vcpu->cpu == -1))
> +		return;
> +
> +	smp_call_function_single(vcpu->cpu, tdx_flush_vp, vcpu, 1);
> +}
> +
>   static int tdx_do_tdh_phymem_cache_wb(void *param)
>   {
>   	u64 err = 0;
> @@ -200,6 +273,8 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>   	cpumask_var_t packages;
>   	bool cpumask_allocated;
> +	struct kvm_vcpu *vcpu;
> +	unsigned long j;
>   	u64 err;
>   	int ret;
>   	int i;
> @@ -210,6 +285,19 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>   	if (!is_td_created(kvm_tdx))
>   		goto free_hkid;
>   
> +	kvm_for_each_vcpu(j, vcpu, kvm)
> +		tdx_flush_vp_on_cpu(vcpu);
> +
> +	mutex_lock(&tdx_lock);
> +	err = tdh_mng_vpflushdone(kvm_tdx->tdr.pa);
> +	mutex_unlock(&tdx_lock);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_VPFLUSHDONE, err, NULL);
> +		pr_err("tdh_mng_vpflushdone failed. HKID %d is leaked.\n",
> +			kvm_tdx->hkid);
> +		return;
> +	}
> +
>   	cpumask_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
>   	cpus_read_lock();
>   	for_each_online_cpu(i) {
> @@ -355,6 +443,26 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   	return 0;
>   }
>   
> +void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	if (vcpu->cpu == cpu)
> +		return;
> +
> +	tdx_flush_vp_on_cpu(vcpu);
> +
> +	local_irq_disable();
> +	/*
> +	 * Pairs with the smp_wmb() in tdx_disassociate_vp() to ensure
> +	 * vcpu->cpu is read before tdx->cpu_list.
> +	 */
> +	smp_rmb();
> +
> +	list_add(&tdx->cpu_list, &per_cpu(associated_tdvcpus, cpu));
> +	local_irq_enable();
> +}
> +
>   void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_tdx *tdx = to_tdx(vcpu);
> @@ -405,6 +513,19 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
>   		tdx->tdvpx = NULL;
>   	}
>   	tdx_reclaim_td_page(&tdx->tdvpr);
> +
> +	/*
> +	 * kvm_free_vcpus()
> +	 *   -> kvm_unload_vcpu_mmu()
> +	 *
> +	 * does vcpu_load() for every vcpu after they already disassociated
> +	 * from the per cpu list when tdx_vm_teardown(). So we need to
> +	 * disassociate them again, otherwise the freed vcpu data will be
> +	 * accessed when do list_{del,add}() on associated_tdvcpus list
> +	 * later.
> +	 */
> +	tdx_flush_vp_on_cpu(vcpu);
> +	WARN_ON_ONCE(vcpu->cpu != -1);
>   }
>   
>   void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index e5f973b2d752..c02073102a5f 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -68,6 +68,8 @@ struct vcpu_tdx {
>   	struct tdx_td_page tdvpr;
>   	struct tdx_td_page *tdvpx;
>   
> +	struct list_head cpu_list;
> +
>   	union tdx_exit_reason exit_reason;
>   
>   	bool vcpu_initialized;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index a4e50c5a4bf5..d4fcb6b29ffe 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -138,6 +138,8 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
>   bool tdx_is_vm_type_supported(unsigned long type);
>   void tdx_hardware_unsetup(void);
>   int tdx_offline_cpu(void);
> +void tdx_hardware_enable(void);
> +void tdx_hardware_disable(void);
>   int tdx_dev_ioctl(void __user *argp);
>   
>   int tdx_vm_init(struct kvm *kvm);
> @@ -150,6 +152,7 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
>   fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
>   void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_put(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>   
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
> @@ -162,6 +165,8 @@ static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
>   static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
>   static inline void tdx_hardware_unsetup(void) {}
>   static inline int tdx_offline_cpu(void) { return 0; }
> +static inline void tdx_hardware_enable(void) {}
> +static inline void tdx_hardware_disable(void) {}
>   static inline int tdx_dev_ioctl(void __user *argp) { return -EOPNOTSUPP; };
>   
>   static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
> @@ -175,6 +180,7 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
>   static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
>   static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
>   static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
> +static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
>   
>   static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
