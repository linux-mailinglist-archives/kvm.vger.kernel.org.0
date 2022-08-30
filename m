Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46FC95A59D7
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 05:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiH3DUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 23:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiH3DUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 23:20:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8845E565;
        Mon, 29 Aug 2022 20:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661829633; x=1693365633;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5M24hjnDntbeLHV39w6POtRtzY/wWmbY9AORdjodPS0=;
  b=FAvKRXUudXSA9ScXywGHFEleTptP1UQRFsTGwVn5QAi+TvwtIBy7JvJX
   la+bxQ9jzyox/qVFdWkhjSp3TwGMzdDTDL8xHkqvWcqXn8CBkEljkaL6h
   RwBeg4GI2GMn3KzU/l90w2UiTXCQNt/fYEo0jeVYXPSflBjIQLMUPAxbn
   BxJ6Asi+0eYKpQICakU16B0GKFv9KblDO9UD23jT6PKPbk5XTytwfOhPE
   YXVQrziU4SERe28+0hlvTNmJMTQXCWBlkNjvtqQLXa8xoXFvlST28PKPz
   FRjSWVhlnFeNC57SEt0n8AkmH/71CNHF6RdhHgIV7mv1BBHS4rirAA5YE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="278084014"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="278084014"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 20:20:32 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="641189928"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.172.100]) ([10.249.172.100])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 20:20:30 -0700
Message-ID: <717976b0-8c84-14f5-6bed-93bc628c04bf@linux.intel.com>
Date:   Tue, 30 Aug 2022 11:20:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v8 026/103] KVM: TDX: allocate/free TDX vcpu structure
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <2347416df71bf525bd716a036e92e21a2e2a7520.1659854790.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <2347416df71bf525bd716a036e92e21a2e2a7520.1659854790.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/8/8 6:01, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> The next step of TDX guest creation is to create vcpu.  Allocate TDX vcpu
> structures, initialize it.  Allocate pages of TDX vcpu for the TDX module.
>
> In the case of the conventional case, cpuid is empty at the initialization.
> and cpuid is configured after the vcpu initialization.  Because TDX
> supports only X2APIC mode, cpuid is forcibly initialized to support X2APIC
> on the vcpu initialization.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c    |  40 +++++++++--
>   arch/x86/kvm/vmx/tdx.c     | 135 +++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h |   8 +++
>   3 files changed, 179 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 067f5de56c53..4f4ed4ad65a7 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -73,6 +73,38 @@ static void vt_vm_free(struct kvm *kvm)
>   		return tdx_vm_free(kvm);
>   }
>   
> +static int vt_vcpu_precreate(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return 0;
> +
> +	return vmx_vcpu_precreate(kvm);
> +}
> +
> +static int vt_vcpu_create(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_vcpu_create(vcpu);
> +
> +	return vmx_vcpu_create(vcpu);
> +}
> +
> +static void vt_vcpu_free(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_vcpu_free(vcpu);
> +
> +	return vmx_vcpu_free(vcpu);
> +}
> +
> +static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_vcpu_reset(vcpu, init_event);
> +
> +	return vmx_vcpu_reset(vcpu, init_event);
> +}
> +
>   static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	if (!is_td(kvm))
> @@ -98,10 +130,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.vm_destroy = vt_vm_destroy,
>   	.vm_free = vt_vm_free,
>   
> -	.vcpu_precreate = vmx_vcpu_precreate,
> -	.vcpu_create = vmx_vcpu_create,
> -	.vcpu_free = vmx_vcpu_free,
> -	.vcpu_reset = vmx_vcpu_reset,
> +	.vcpu_precreate = vt_vcpu_precreate,
> +	.vcpu_create = vt_vcpu_create,
> +	.vcpu_free = vt_vcpu_free,
> +	.vcpu_reset = vt_vcpu_reset,
>   
>   	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
>   	.vcpu_load = vmx_vcpu_load,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index dcd2f460275e..ee682a65b233 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -6,6 +6,7 @@
>   #include "capabilities.h"
>   #include "x86_ops.h"
>   #include "tdx.h"
> +#include "x86.h"
>   
>   #undef pr_fmt
>   #define pr_fmt(fmt) "tdx: " fmt
> @@ -47,6 +48,11 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
>   	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
>   }
>   
> +static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
> +{
> +	return tdx->tdvpr.added;
> +}
> +
>   static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
>   {
>   	return kvm_tdx->tdr.added;
> @@ -378,6 +384,135 @@ int tdx_vm_init(struct kvm *kvm)
>   	return ret;
>   }
>   
> +int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	int ret, i;
> +
> +	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> +	if (!vcpu->arch.apic)
> +		return -EINVAL;
> +
> +	fpstate_set_confidential(&vcpu->arch.guest_fpu);
> +
> +	ret = tdx_alloc_td_page(&tdx->tdvpr);
> +	if (ret)
> +		return ret;
> +
> +	tdx->tdvpx = kcalloc(tdx_caps.tdvpx_nr_pages, sizeof(*tdx->tdvpx),
> +			GFP_KERNEL_ACCOUNT);
> +	if (!tdx->tdvpx) {
> +		ret = -ENOMEM;
> +		goto free_tdvpr;
> +	}
> +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
> +		ret = tdx_alloc_td_page(&tdx->tdvpx[i]);
> +		if (ret)
> +			goto free_tdvpx;
> +	}
> +
> +	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
> +
> +	vcpu->arch.cr0_guest_owned_bits = -1ul;
> +	vcpu->arch.cr4_guest_owned_bits = -1ul;
> +
> +	vcpu->arch.tsc_offset = to_kvm_tdx(vcpu->kvm)->tsc_offset;
> +	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
> +	vcpu->arch.guest_state_protected =
> +		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);
> +
> +	return 0;
> +
> +free_tdvpx:
> +	/* @i points at the TDVPX page that failed allocation. */
> +	for (--i; i >= 0; i--)
> +		free_page(tdx->tdvpx[i].va);
> +	kfree(tdx->tdvpx);
> +free_tdvpr:
> +	free_page(tdx->tdvpr.va);
> +
> +	return ret;
> +}
> +
> +void tdx_vcpu_free(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	int i;
> +
> +	/* Can't reclaim or free pages if teardown failed. */
> +	if (is_hkid_assigned(to_kvm_tdx(vcpu->kvm)))
> +		return;
> +
> +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++)
> +		tdx_reclaim_td_page(&tdx->tdvpx[i]);

What if some of the pages failed to be reclaimed?


> +	kfree(tdx->tdvpx);
> +	tdx_reclaim_td_page(&tdx->tdvpr);
> +}
> +
> +void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	struct msr_data apic_base_msr;
> +	u64 err;
> +	int i;
> +
> +	/* TDX doesn't support INIT event. */
> +	if (WARN_ON(init_event))
> +		goto td_bugged;
> +	if (WARN_ON(is_td_vcpu_created(tdx)))
> +		goto td_bugged;
> +
> +	err = tdh_vp_create(kvm_tdx->tdr.pa, tdx->tdvpr.pa);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_VP_CREATE, err, NULL);
> +		goto td_bugged;
> +	}
> +	tdx_mark_td_page_added(&tdx->tdvpr);
> +
> +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
> +		err = tdh_vp_addcx(tdx->tdvpr.pa, tdx->tdvpx[i].pa);
> +		if (WARN_ON_ONCE(err)) {
> +			pr_tdx_error(TDH_VP_ADDCX, err, NULL);
> +			goto td_bugged;
> +		}
> +		tdx_mark_td_page_added(&tdx->tdvpx[i]);
> +	}
> +
> +	if (!vcpu->arch.cpuid_entries) {
> +		/*
> +		 * On cpu creation, cpuid entry is blank.  Forcibly enable
> +		 * X2APIC feature to allow X2APIC.
> +		 */
> +		struct kvm_cpuid_entry2 *e;
> +
> +		e = kvmalloc_array(1, sizeof(*e), GFP_KERNEL_ACCOUNT);
> +		*e  = (struct kvm_cpuid_entry2) {
> +			.function = 1,	/* Features for X2APIC */
> +			.index = 0,
> +			.eax = 0,
> +			.ebx = 0,
> +			.ecx = 1ULL << 21,	/* X2APIC */
> +			.edx = 0,
> +		};

Just out of curiosity, where will this info be used afterwards?



> +		vcpu->arch.cpuid_entries = e;
> +		vcpu->arch.cpuid_nent = 1;
> +	}
> +	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC;
> +	if (kvm_vcpu_is_reset_bsp(vcpu))
> +		apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
> +	apic_base_msr.host_initiated = true;
> +	if (WARN_ON(kvm_set_apic_base(vcpu, &apic_base_msr)))
> +		goto td_bugged;
> +
> +	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> +
> +	return;
> +
> +td_bugged:
> +	vcpu->kvm->vm_bugged = true;
> +}
> +
>   int tdx_dev_ioctl(void __user *argp)
>   {
>   	struct kvm_tdx_capabilities __user *user_caps;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index f0fe40c7ac34..b98bbcd9ef42 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -138,6 +138,10 @@ int tdx_vm_init(struct kvm *kvm);
>   void tdx_mmu_release_hkid(struct kvm *kvm);
>   void tdx_vm_free(struct kvm *kvm);
>   
> +int tdx_vcpu_create(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_free(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
> +
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   #else
>   static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
> @@ -150,6 +154,10 @@ static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
>   static inline void tdx_flush_shadow_all_private(struct kvm *kvm) {}
>   static inline void tdx_vm_free(struct kvm *kvm) {}
>   
> +static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
> +static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
> +static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
> +
>   static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>   #endif
>   
