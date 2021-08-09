Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5482D3E3E88
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 05:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhHID6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Aug 2021 23:58:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:53063 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232692AbhHID6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Aug 2021 23:58:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="201795074"
X-IronPort-AV: E=Sophos;i="5.84,305,1620716400"; 
   d="scan'208";a="201795074"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2021 20:58:13 -0700
X-IronPort-AV: E=Sophos;i="5.84,305,1620716400"; 
   d="scan'208";a="514769957"
Received: from raochun1-mobl.ccr.corp.intel.com (HELO localhost) ([10.255.28.63])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2021 20:58:08 -0700
Date:   Mon, 9 Aug 2021 11:58:06 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Wei Huang <wei.huang2@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
Subject: Re: [PATCH v2 1/3] KVM: x86: Allow CPU to force vendor-specific TDP
 level
Message-ID: <20210809035806.5cqdqm5vkexvngda@linux.intel.com>
References: <20210808192658.2923641-1-wei.huang2@amd.com>
 <20210808192658.2923641-2-wei.huang2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210808192658.2923641-2-wei.huang2@amd.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 08, 2021 at 02:26:56PM -0500, Wei Huang wrote:
> AMD future CPUs will require a 5-level NPT if host CR4.LA57 is set.

Sorry, but why? NPT is not indexed by HVA. 

> To prevent kvm_mmu_get_tdp_level() from incorrectly changing NPT level
> on behalf of CPUs, add a new parameter in kvm_configure_mmu() to force
> a fixed TDP level.
> 
> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  5 ++---
>  arch/x86/kvm/mmu/mmu.c          | 10 ++++++++--
>  arch/x86/kvm/svm/svm.c          |  4 +++-
>  arch/x86/kvm/vmx/vmx.c          |  3 ++-
>  4 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 974cbfb1eefe..6d16f75cc8da 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -723,7 +723,6 @@ struct kvm_vcpu_arch {
>  
>  	u64 reserved_gpa_bits;
>  	int maxphyaddr;
> -	int max_tdp_level;
>  
>  	/* emulate context */
>  
> @@ -1747,8 +1746,8 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
>  void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
>  
> -void kvm_configure_mmu(bool enable_tdp, int tdp_max_root_level,
> -		       int tdp_huge_page_level);
> +void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> +		       int tdp_max_root_level, int tdp_huge_page_level);
>  
>  static inline u16 kvm_read_ldt(void)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 66f7f5bc3482..c11ee4531f6d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -97,6 +97,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
>  bool tdp_enabled = false;
>  
>  static int max_huge_page_level __read_mostly;
> +static int tdp_root_level __read_mostly;

I think this is a broken design - meaning KVM can only use 5-level or
4-level NPT for all VMs.

B.R.
Yu

>  static int max_tdp_level __read_mostly;
>  
>  enum {
> @@ -4562,6 +4563,10 @@ static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
>  
>  static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
>  {
> +	/* tdp_root_level is architecture forced level, use it if nonzero */
> +	if (tdp_root_level)
> +		return tdp_root_level;
> +
>  	/* Use 5-level TDP if and only if it's useful/necessary. */
>  	if (max_tdp_level == 5 && cpuid_maxphyaddr(vcpu) <= 48)
>  		return 4;
> @@ -5253,10 +5258,11 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
>  	 */
>  }
>  
> -void kvm_configure_mmu(bool enable_tdp, int tdp_max_root_level,
> -		       int tdp_huge_page_level)
> +void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> +		       int tdp_max_root_level, int tdp_huge_page_level)
>  {
>  	tdp_enabled = enable_tdp;
> +	tdp_root_level = tdp_forced_root_level;
>  	max_tdp_level = tdp_max_root_level;
>  
>  	/*
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e8ccab50ebf6..f361d466e18e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1015,7 +1015,9 @@ static __init int svm_hardware_setup(void)
>  	if (!boot_cpu_has(X86_FEATURE_NPT))
>  		npt_enabled = false;
>  
> -	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
> +	/* Force VM NPT level equal to the host's max NPT level */
> +	kvm_configure_mmu(npt_enabled, get_max_npt_level(),
> +			  get_max_npt_level(), PG_LEVEL_1G);
>  	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
>  
>  	/* Note, SEV setup consumes npt_enabled. */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 927a552393b9..034e1397c7d5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7803,7 +7803,8 @@ static __init int hardware_setup(void)
>  		ept_lpage_level = PG_LEVEL_2M;
>  	else
>  		ept_lpage_level = PG_LEVEL_4K;
> -	kvm_configure_mmu(enable_ept, vmx_get_max_tdp_level(), ept_lpage_level);
> +	kvm_configure_mmu(enable_ept, 0, vmx_get_max_tdp_level(),
> +			  ept_lpage_level);
>  
>  	/*
>  	 * Only enable PML when hardware supports PML feature, and both EPT
> -- 
> 2.31.1
> 
