Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8A0688FE5
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 07:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjBCGzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 01:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjBCGzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 01:55:50 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBF393D2;
        Thu,  2 Feb 2023 22:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675407349; x=1706943349;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ALVoZ5yUnWWYryD5/A24qUpsX/RD4sVgHT984aayrnk=;
  b=IH0V3NBVjusge6INAoAtpRfC62dMAB7X8QpJSZVMDw17qdIx2t8smNOX
   qc3qHj4KERCnW6OGDO7eayLuFfQYorrI4SSZYdW1vN96IHfVeuS/5tfxb
   +y2Z6Q+WA0WbRrz9Dk5rMbm++C7Xjpdy3gPI7UNq2NLIwXvumxPSEEyXy
   kBzAQ+sGHuVFpBLFdrmJNW47mpGcOAHMu5uVRg3H8sZl1FR6fEtPQxDhs
   RxPJosZy2gkk+Q3qH5CXlB8W3AHnQoUeKvQLGKQN8B9yMh4w6XdEuultf
   1eoaU0I6KMNzdKLquryaj6cvr2IiksDD3zAyBbk3CfTmBakwtwCmx4fk7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="327318644"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="327318644"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 22:55:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="659006910"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="659006910"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga007.jf.intel.com with ESMTP; 02 Feb 2023 22:55:46 -0800
Date:   Fri, 3 Feb 2023 14:55:45 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v11 058/113] KVM: TDX: MTRR: implement get_mt_mask() for
 TDX
Message-ID: <20230203065545.piywnc3jnxqotehv@yy-desk-7060>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <21e0d94ccf2fd3d766d6aa7b45441791c04e5e4f.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21e0d94ccf2fd3d766d6aa7b45441791c04e5e4f.1673539699.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 08:32:06AM -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Although TDX supports only WB for private GPA, MTRR/PAT for shared GPA
> should be supported. Implement get_mt_mask() following vmx case.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/main.c    | 10 +++++++++-
>  arch/x86/kvm/vmx/tdx.c     | 19 +++++++++++++++++++
>  arch/x86/kvm/vmx/x86_ops.h |  2 ++
>  3 files changed, 30 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 770d1b29d1c3..4319f6d7a4da 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -158,6 +158,14 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
>  }
>
> +static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_get_mt_mask(vcpu, gfn, is_mmio);
> +
> +	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
> +}
> +
>  static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	if (!is_td(kvm))
> @@ -267,7 +275,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>
>  	.set_tss_addr = vmx_set_tss_addr,
>  	.set_identity_map_addr = vmx_set_identity_map_addr,
> -	.get_mt_mask = vmx_get_mt_mask,
> +	.get_mt_mask = vt_get_mt_mask,
>
>  	.get_exit_info = vmx_get_exit_info,
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index e68816999387..c4c5a8f786c1 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -309,6 +309,25 @@ int tdx_vm_init(struct kvm *kvm)
>  	return 0;
>  }
>
> +u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> +{
> +	/* TDX private GPA is always WB. */
> +	if (gfn & kvm_gfn_shared_mask(vcpu->kvm)) {
> +		WARN_ON_ONCE(is_mmio);
> +		return  MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
> +	}

This looks not clear enough, the comment says things about private GPA
but the code returns WB for shared GPA, please align them.

> +
> +	if (is_mmio)
> +		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
> +
> +	/*
> +	 * Device assignemnt without VT-d snooping capability with shared-GPA
> +	 * is dubious.
> +	 */
> +	WARN_ON_ONCE(kvm_arch_has_noncoherent_dma(vcpu->kvm));
> +	return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> +}
> +
>  int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpuid_entry2 *e;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 8ae689929347..d903e0f606d3 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -154,6 +154,7 @@ void tdx_vm_free(struct kvm *kvm);
>  int tdx_vcpu_create(struct kvm_vcpu *vcpu);
>  void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>  void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
> +u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
>
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>  int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
> @@ -176,6 +177,7 @@ static inline void tdx_vm_free(struct kvm *kvm) {}
>  static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
>  static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
>  static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
> +static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
>
>  static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>  static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
> --
> 2.25.1
>
