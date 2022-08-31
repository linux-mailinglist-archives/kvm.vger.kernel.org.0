Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F695A770A
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 09:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiHaHHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 03:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiHaHHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 03:07:15 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE695E33D;
        Wed, 31 Aug 2022 00:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661929634; x=1693465634;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kVV9HRdEeMuPwKG8bSE257Bhd6inSuO7fo2Ew7TH9RU=;
  b=Zbbz03rNP1dOzVxAMyr3MejPH9D2wose/Hv1qBjz9CSNuHlGLYTLBvi5
   YOvE6y7VCf6h/irhHs8kw+ZXQwqQSbMWoJ8YuDPNdmuZpgcjxccDT99am
   IuxKxDeT1Gcqaa1EAEdMbwZnnJgeQ54EpZjjmk0gCJ7/OAoPL4B5ita4U
   F6pqqbfFq85p7ahWOELgDOjClmgyHdV2cJi2ePXRzmwTe+Rbob6Q3ujgB
   OF93vs2tAEZlJL4e7/jufiVOtj/4KrdbaT/OU9VGli0pjbM/No6JxYgz3
   D30rChVrGJfYcaEBDDaI1a3GxuUxbirp3EUbii5Z9jxG+VWLzneqnhiyL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="294129498"
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="294129498"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 00:07:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="641739280"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga008.jf.intel.com with ESMTP; 31 Aug 2022 00:07:12 -0700
Date:   Wed, 31 Aug 2022 15:07:11 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 030/103] KVM: x86/mmu: Add address conversion
 functions for TDX shared bit of GPA
Message-ID: <20220831070711.yli6s6yk7euyvgqu@yy-desk-7060>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <97e6f89f0460ac0b29392528e848cca2458b54c9.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97e6f89f0460ac0b29392528e848cca2458b54c9.1659854790.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 07, 2022 at 03:01:15PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX repurposes one GPA bit (51 bit or 47 bit based on configuration) to
> indicate the GPA is private(if cleared) or shared (if set) with VMM.  If
> GPA.shared is set, GPA is covered by the existing conventional EPT pointed
> by EPTP.  If GPA.shared bit is cleared, GPA is covered by TDX module.
> VMM has to issue SEAMCALLs to operate.
>
> Add a member to remember GPA shared bit for each guest TDs, add address
> conversion functions between private GPA and shared GPA and test if GPA
> is private.
>
> Because struct kvm_arch (or struct kvm which includes struct kvm_arch. See
> kvm_arch_alloc_vm() that passes __GPF_ZERO) is zero-cleared when allocated,
> the new member to remember GPA shared bit is guaranteed to be zero with
> this patch unless it's initialized explicitly.
>
> Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> ---
>  arch/x86/include/asm/kvm_host.h |  4 ++++
>  arch/x86/kvm/mmu.h              | 32 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.c          |  5 +++++
>  3 files changed, 41 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e856abbe80ab..6787d5214fd8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1358,6 +1358,10 @@ struct kvm_arch {
>  	 */
>  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
>  	struct kvm_mmu_memory_cache split_desc_cache;
> +
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +	gfn_t gfn_shared_mask;
> +#endif
>  };
>
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index a99acec925eb..df9f79ee07d4 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -276,4 +276,36 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
>  		return gpa;
>  	return translate_nested_gpa(vcpu, gpa, access, exception);
>  }
> +
> +static inline gfn_t kvm_gfn_shared_mask(const struct kvm *kvm)
> +{
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +	return kvm->arch.gfn_shared_mask;
> +#else
> +	return 0;
> +#endif
> +}
> +
> +static inline gfn_t kvm_gfn_shared(const struct kvm *kvm, gfn_t gfn)
> +{
> +	return gfn | kvm_gfn_shared_mask(kvm);
> +}
> +
> +static inline gfn_t kvm_gfn_private(const struct kvm *kvm, gfn_t gfn)
> +{
> +	return gfn & ~kvm_gfn_shared_mask(kvm);
> +}
> +
> +static inline gpa_t kvm_gpa_private(const struct kvm *kvm, gpa_t gpa)
> +{
> +	return gpa & ~gfn_to_gpa(kvm_gfn_shared_mask(kvm));
> +}
> +
> +static inline bool kvm_is_private_gpa(const struct kvm *kvm, gpa_t gpa)
> +{
> +	gfn_t mask = kvm_gfn_shared_mask(kvm);
> +
> +	return mask && !(gpa_to_gfn(gpa) & mask);
> +}
> +
>  #endif
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 37272fe1e69f..36d2127cb7b7 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -753,6 +753,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>  	kvm_tdx->xfam = td_params->xfam;
>  	kvm->max_vcpus = td_params->max_vcpus;
>
> +	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
> +		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(51));
> +	else
> +		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(47));
> +
>  out:
>  	/* kfree() accepts NULL. */
>  	kfree(init_vm);
> --
> 2.25.1
>
