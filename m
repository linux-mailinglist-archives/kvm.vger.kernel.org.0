Return-Path: <kvm+bounces-11108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D185872F4D
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 08:13:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 814A21C20A0E
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 07:13:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED0D95C605;
	Wed,  6 Mar 2024 07:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZO2pvPgs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0795BAF0;
	Wed,  6 Mar 2024 07:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709709210; cv=none; b=cV8RVPQvgwHn3gegvQE/PtQqFS9RQmyiegAb8m4ZQK4JyAEy2kODjNGfWXLBp35Lcyhk7eT844Vk7cmR33QgzXVuczd3m54ne8EbVbouhsGRVkACBSeGEKhjh0LB089wI5O4Mnw9xe7niAQTxwj6glnDcmVyesm/rzr+NtVDpQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709709210; c=relaxed/simple;
	bh=MyleJJKYVaih73yAil6EbhYeZ5POQD3vU4WlCfEGD7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=clXqOVndvK3X7fhJoUnw02y/hMJ86wrJPGg/qcuFuh67VGmTq1if+/QAPyj51xDenYfbDms5x2H17Qp2IN5XtDbO/mqR+bokb0/yJq37Q7mbHnNrh/Vv4vCETN4VbWeet+gFp/FgHV+o5cfcuXauO/aDFTICv8HvoAlpYfOLRr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZO2pvPgs; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709709209; x=1741245209;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MyleJJKYVaih73yAil6EbhYeZ5POQD3vU4WlCfEGD7U=;
  b=ZO2pvPgsnGw6Zo9GdpT4xHEWqGrFXwPbXX3UQH4hT4wvOdNzU8qytmNY
   aVUHUa1Mixtd3AMHpbVOnv6EPxufYiVngTj+CbInQbSkj5VUxtlAlmtOk
   vbOZKka0OFyS6ysj13ooNi9VVIAUOo/KSjNP4ODOR6T5/2N/twQXz2K7g
   pkP610azjsoY4gzSMlZ6niJz1M8X6eV+EQolPeW/md7Su8s9XpXkk0Tuq
   NaZ4iZ77qfMtVf7TeuYmEQHxnGJ/BcAh9+hMucb5xGWi9p5d7Pfu43WAh
   zc7vgfuIY3N0EPcYamU42ThUDmR/61J4P9CCSsH7KhqkppD4U9d0c/pjk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="8111505"
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="8111505"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 23:13:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="9737922"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.218]) ([10.238.8.218])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 23:13:24 -0800
Message-ID: <4555c300-5934-4563-a639-3e43d2ce405f@linux.intel.com>
Date: Wed, 6 Mar 2024 15:13:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 016/130] KVM: x86/mmu: Introduce
 kvm_mmu_map_tdp_page() for use by TDX
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b2b7eeb1bab4cbf5421bf18647357a59b472dabe.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <b2b7eeb1bab4cbf5421bf18647357a59b472dabe.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Introduce a helper to directly (pun intended) fault-in a TDP page
> without having to go through the full page fault path.  This allows
> TDX to get the resulting pfn and also allows the RET_PF_* enums to
> stay in mmu.c where they belong.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v19:
> - Move up for KVM_MEMORY_MAPPING.
> - Add goal_level for the caller to know how many pages are mapped.
>
> v14 -> v15:
> - Remove loop in kvm_mmu_map_tdp_page() and return error code based on
>    RET_FP_xxx value to avoid potential infinite loop.  The caller should
>    loop on -EAGAIN instead now.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu.h     |  3 +++
>   arch/x86/kvm/mmu/mmu.c | 58 ++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 61 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 60f21bb4c27b..d96c93a25b3b 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -183,6 +183,9 @@ static inline void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
>   	__kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
>   }
>   
> +int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> +			 u8 max_level, u8 *goal_level);
> +
>   /*
>    * Check if a given access (described through the I/D, W/R and U/S bits of a
>    * page fault error code pfec) causes a permission fault with the given PTE
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 61674d6b17aa..ca0c91f14063 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4615,6 +4615,64 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   	return direct_page_fault(vcpu, fault);
>   }
>   
> +int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> +			 u8 max_level, u8 *goal_level)
> +{
> +	int r;
> +	struct kvm_page_fault fault = (struct kvm_page_fault) {
> +		.addr = gpa,
> +		.error_code = error_code,
> +		.exec = error_code & PFERR_FETCH_MASK,
> +		.write = error_code & PFERR_WRITE_MASK,
> +		.present = error_code & PFERR_PRESENT_MASK,
> +		.rsvd = error_code & PFERR_RSVD_MASK,
> +		.user = error_code & PFERR_USER_MASK,
> +		.prefetch = false,
> +		.is_tdp = true,
> +		.is_private = error_code & PFERR_GUEST_ENC_MASK,
> +		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(vcpu->kvm),
> +	};
> +
> +	WARN_ON_ONCE(!vcpu->arch.mmu->root_role.direct);
> +	fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
> +
> +	r = mmu_topup_memory_caches(vcpu, false);

Does it need a cache topup here?
Both kvm_tdp_mmu_page_fault() and direct_page_fault() will call
mmu_topup_memory_caches() when needed.

> +	if (r)
> +		return r;
> +
> +	fault.max_level = max_level;
> +	fault.req_level = PG_LEVEL_4K;
> +	fault.goal_level = PG_LEVEL_4K;
> +
> +#ifdef CONFIG_X86_64
> +	if (tdp_mmu_enabled)
> +		r = kvm_tdp_mmu_page_fault(vcpu, &fault);
> +	else
> +#endif
> +		r = direct_page_fault(vcpu, &fault);
> +
> +	if (is_error_noslot_pfn(fault.pfn) || vcpu->kvm->vm_bugged)
> +		return -EFAULT;
> +
> +	switch (r) {
> +	case RET_PF_RETRY:
> +		return -EAGAIN;
> +
> +	case RET_PF_FIXED:
> +	case RET_PF_SPURIOUS:
> +		if (goal_level)
> +			*goal_level = fault.goal_level;
> +		return 0;
> +
> +	case RET_PF_CONTINUE:
> +	case RET_PF_EMULATE:
> +	case RET_PF_INVALID:
> +	default:
> +		return -EIO;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(kvm_mmu_map_tdp_page);
> +
>   static void nonpaging_init_context(struct kvm_mmu *context)
>   {
>   	context->page_fault = nonpaging_page_fault;


