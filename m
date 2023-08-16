Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 961BC77D82B
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 04:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241192AbjHPCKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 22:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241200AbjHPCKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 22:10:44 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB84C1;
        Tue, 15 Aug 2023 19:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692151843; x=1723687843;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=g5DE3UPzOn/3axSiUxrACU9/8H54KjKSPMGZUrH+Zxc=;
  b=ilu6K4apcQly7pcD3A4597T1rOmqGzIks3TYvHh6SLVZLxku9r0Ev15r
   klzrt+Hwr7L2EADNi37cOYmcpCDlqD5zfHkhL7/BjRJuEbzqYvwj/qCyK
   UwWFG9i9CHMGlZfyo+lc6ssUIzMGVNM2jo2ZAMKPwCTYItNumkPFaKNtW
   vCK3IQ4u4+XoKNx5S0XHQ2bFTXqFk4TvXQ8Cu77nqbH4AtROWRk9pMGDM
   uh6QqFZQ+VkyJRgWHqStMDpVQcGHJ5vD9qa1OFSIr1nvq8LQh/1W84dIe
   H1YWmNlxhuaLk7CyFlnw6XpMxnGl634fRXpWDpeqo/nqtthZgxs8Tiio+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="458773598"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="458773598"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 19:10:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="877583772"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga001.fm.intel.com with ESMTP; 15 Aug 2023 19:10:44 -0700
Date:   Wed, 16 Aug 2023 10:10:40 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH v3 02/15] KVM: x86/mmu: Use KVM-governed feature
 framework to track "GBPAGES enabled"
Message-ID: <20230816021040.tl2r5luajsqbb5al@yy-desk-7060>
References: <20230815203653.519297-1-seanjc@google.com>
 <20230815203653.519297-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230815203653.519297-3-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023 at 01:36:40PM -0700, Sean Christopherson wrote:
> Use the governed feature framework to track whether or not the guest can
> use 1GiB pages, and drop the one-off helper that wraps the surprisingly
> non-trivial logic surrounding 1GiB page usage in the guest.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c             | 17 +++++++++++++++++
>  arch/x86/kvm/governed_features.h |  2 ++
>  arch/x86/kvm/mmu/mmu.c           | 20 +++-----------------
>  3 files changed, 22 insertions(+), 17 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 4ba43ae008cb..67e9f79fe059 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -312,11 +312,28 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	struct kvm_cpuid_entry2 *best;
> +	bool allow_gbpages;
>
>  	BUILD_BUG_ON(KVM_NR_GOVERNED_FEATURES > KVM_MAX_NR_GOVERNED_FEATURES);
>  	bitmap_zero(vcpu->arch.governed_features.enabled,
>  		    KVM_MAX_NR_GOVERNED_FEATURES);
>
> +	/*
> +	 * If TDP is enabled, let the guest use GBPAGES if they're supported in
> +	 * hardware.  The hardware page walker doesn't let KVM disable GBPAGES,
> +	 * i.e. won't treat them as reserved, and KVM doesn't redo the GVA->GPA
> +	 * walk for performance and complexity reasons.  Not to mention KVM
> +	 * _can't_ solve the problem because GVA->GPA walks aren't visible to
> +	 * KVM once a TDP translation is installed.  Mimic hardware behavior so
> +	 * that KVM's is at least consistent, i.e. doesn't randomly inject #PF.
> +	 * If TDP is disabled, honor *only* guest CPUID as KVM has full control
> +	 * and can install smaller shadow pages if the host lacks 1GiB support.
> +	 */
> +	allow_gbpages = tdp_enabled ? boot_cpu_has(X86_FEATURE_GBPAGES) :
> +				      guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES);

tdp_enabled only changes at kvm_configure_mmu() when hardware setup for
VMX and SVM, so:

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> +	if (allow_gbpages)
> +		kvm_governed_feature_set(vcpu, X86_FEATURE_GBPAGES);
> +
>  	best = kvm_find_cpuid_entry(vcpu, 1);
>  	if (best && apic) {
>  		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
> diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
> index 40ce8e6608cd..b29c15d5e038 100644
> --- a/arch/x86/kvm/governed_features.h
> +++ b/arch/x86/kvm/governed_features.h
> @@ -5,5 +5,7 @@ BUILD_BUG()
>
>  #define KVM_GOVERNED_X86_FEATURE(x) KVM_GOVERNED_FEATURE(X86_FEATURE_##x)
>
> +KVM_GOVERNED_X86_FEATURE(GBPAGES)
> +
>  #undef KVM_GOVERNED_X86_FEATURE
>  #undef KVM_GOVERNED_FEATURE
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5bdda75bfd10..9e4cd8b4a202 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4779,28 +4779,13 @@ static void __reset_rsvds_bits_mask(struct rsvd_bits_validate *rsvd_check,
>  	}
>  }
>
> -static bool guest_can_use_gbpages(struct kvm_vcpu *vcpu)
> -{
> -	/*
> -	 * If TDP is enabled, let the guest use GBPAGES if they're supported in
> -	 * hardware.  The hardware page walker doesn't let KVM disable GBPAGES,
> -	 * i.e. won't treat them as reserved, and KVM doesn't redo the GVA->GPA
> -	 * walk for performance and complexity reasons.  Not to mention KVM
> -	 * _can't_ solve the problem because GVA->GPA walks aren't visible to
> -	 * KVM once a TDP translation is installed.  Mimic hardware behavior so
> -	 * that KVM's is at least consistent, i.e. doesn't randomly inject #PF.
> -	 */
> -	return tdp_enabled ? boot_cpu_has(X86_FEATURE_GBPAGES) :
> -			     guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES);
> -}
> -
>  static void reset_guest_rsvds_bits_mask(struct kvm_vcpu *vcpu,
>  					struct kvm_mmu *context)
>  {
>  	__reset_rsvds_bits_mask(&context->guest_rsvd_check,
>  				vcpu->arch.reserved_gpa_bits,
>  				context->cpu_role.base.level, is_efer_nx(context),
> -				guest_can_use_gbpages(vcpu),
> +				guest_can_use(vcpu, X86_FEATURE_GBPAGES),
>  				is_cr4_pse(context),
>  				guest_cpuid_is_amd_or_hygon(vcpu));
>  }
> @@ -4877,7 +4862,8 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
>  	__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
>  				context->root_role.level,
>  				context->root_role.efer_nx,
> -				guest_can_use_gbpages(vcpu), is_pse, is_amd);
> +				guest_can_use(vcpu, X86_FEATURE_GBPAGES),
> +				is_pse, is_amd);
>
>  	if (!shadow_me_mask)
>  		return;
> --
> 2.41.0.694.ge786442a9b-goog
>
