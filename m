Return-Path: <kvm+bounces-4907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EF7281994A
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 08:17:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A21B288852
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 07:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D5616425;
	Wed, 20 Dec 2023 07:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vdk78zJ+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882C116417
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 07:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703056610; x=1734592610;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FXniwdFSYiK/07pqlWb+ORaYifrq2h6SLJGdSfZSg2c=;
  b=Vdk78zJ+W3nbm7gMlxegWo5Y3orNoDDAoBtHPYlUgQUtvKcrDzs3odGP
   ChfR3yR7E5jnB10hObW60xLUFa7F6VFjUrfR2QbTgbvPPy/Qd7Zwb8mJR
   Der6Fwl4LyFOKN9ZVu8WFcvTGvMYCzXqNFpdPUhj2rLBrZRVxluIjw87w
   Cso2QVbUXD98TUn80foW+Xj2m6EWPtvVnx7/8IyUsSJXq56rZ1V5Hz6ub
   hFrqu2utJVbe3smBLQlue6Qxqlk8fRMVILFmDo6awV3Ikvk8IIbG8143K
   db7N7HvSzOQ+T5SfS1VdMbbJc+RCHYxzd9FW048x/yIk2SD3Y1RgyiBhO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="462224201"
X-IronPort-AV: E=Sophos;i="6.04,290,1695711600"; 
   d="scan'208";a="462224201"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 23:16:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="1107640841"
X-IronPort-AV: E=Sophos;i="6.04,290,1695711600"; 
   d="scan'208";a="1107640841"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.8.39]) ([10.93.8.39])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 23:16:47 -0800
Message-ID: <6cfc6f05-7c43-49d9-8e1a-bfa6e34f6b56@intel.com>
Date: Wed, 20 Dec 2023 15:16:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>
Cc: Jim Mattson <jmattson@google.com>, Tao Su <tao1.su@linux.intel.com>,
 kvm@vger.kernel.org, pbonzini@redhat.com, eddie.dong@intel.com,
 yuan.yao@linux.intel.com, yi1.lai@intel.com, xudong.hao@intel.com,
 chao.p.peng@intel.com
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-2-tao1.su@linux.intel.com>
 <ZYBhl200jZpWDqpU@google.com> <ZYEFGQBti5DqlJiu@chao-email>
 <CALMp9eSJT7PajjX==L9eLKEEVuL-tvY0yN1gXmtzW5EUKHX3Yg@mail.gmail.com>
 <ZYFPsISS9K867BU5@chao-email> <ZYG2CDRFlq50siec@google.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZYG2CDRFlq50siec@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/2023 11:26 PM, Sean Christopherson wrote:
> KVM can simply
> constrain the advertised MAXPHYADDR, no?

Sean. It looks you agree with this patch (Patch 1) now.

I think it's better for you to comment the original code from Tao 
instead of throwing out your own version. Tao needs to know why his 
version is not OK/correct and what can be improved.

Thanks,
-Xiaoyao

> ---
>   arch/x86/kvm/cpuid.c   | 17 +++++++++++++----
>   arch/x86/kvm/mmu.h     |  2 ++
>   arch/x86/kvm/mmu/mmu.c |  5 +++++
>   3 files changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 294e5bd5f8a0..5c346e1a10bd 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1233,12 +1233,21 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   		 *
>   		 * If TDP is enabled but an explicit guest MAXPHYADDR is not
>   		 * provided, use the raw bare metal MAXPHYADDR as reductions to
> -		 * the HPAs do not affect GPAs.
> +		 * the HPAs do not affect GPAs.  Finally, if TDP is enabled and
> +		 * doesn't support 5-level paging, cap guest MAXPHYADDR at 48
> +		 * bits as KVM can't install SPTEs for larger GPAs.
>   		 */
> -		if (!tdp_enabled)
> +		if (!tdp_enabled) {
>   			g_phys_as = boot_cpu_data.x86_phys_bits;
> -		else if (!g_phys_as)
> -			g_phys_as = phys_as;
> +		} else {
> +			u8 max_tdp_level = kvm_mmu_get_max_tdp_level();
> +
> +			if (!g_phys_as)
> +				g_phys_as = phys_as;
> +
> +			if (max_tdp_level < 5)
> +				g_phys_as = min(g_phys_as, 48);
> +		}
>   
>   		entry->eax = g_phys_as | (virt_as << 8);
>   		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 60f21bb4c27b..b410a227c601 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -100,6 +100,8 @@ static inline u8 kvm_get_shadow_phys_bits(void)
>   	return boot_cpu_data.x86_phys_bits;
>   }
>   
> +u8 kvm_mmu_get_max_tdp_level(void);
> +
>   void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
>   void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
>   void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3c844e428684..b2845f5520b3 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5267,6 +5267,11 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
>   	return max_tdp_level;
>   }
>   
> +u8 kvm_mmu_get_max_tdp_level(void)
> +{
> +	return tdp_root_level ? tdp_root_level : max_tdp_level;
> +}
> +
>   static union kvm_mmu_page_role
>   kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
>   				union kvm_cpu_role cpu_role)
> 
> base-commit: f2a3fb7234e52f72ff4a38364dbf639cf4c7d6c6
> -- 


