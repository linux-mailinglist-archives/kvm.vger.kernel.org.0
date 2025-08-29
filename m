Return-Path: <kvm+bounces-56262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB9F1B3B7B6
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 11:50:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B57FF1C2737D
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 09:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CED9A305048;
	Fri, 29 Aug 2025 09:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ND9XEO/W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE892638AF;
	Fri, 29 Aug 2025 09:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756460999; cv=none; b=EZORH3N6Y9VjFiUWO1tFp+Tw0EwUOruEgT8/Ii21Sd7mhUxQ4ssPPTtxWbKx8zR3//9R0mVGRVtoT+NcYMSMpOzHteB+sNhcHGe9Bu30HRrMdSGhW4LjmQwyVvRRoIrrP61xR0L/u1UyEfGukU8DNMjhHb8Ph/1NGDrGGoqv+K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756460999; c=relaxed/simple;
	bh=vTrZCzGqprJa4CTDYYxT6WV6QVw3cRAJY7/mRObXOP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=puYMnhToXVBkCVOEHs8yeeF50KDbAyPMip8LDeLhLq+QBwZMuV1DKhp1CEwRXvArkIbuI9zHxbJbKY2IUkZVNyvISdrE3zIC3DjqDir2FksBzpkp7QxY/y6xm5KfmVCry1RVqRqAyh9wekaR1nc1hoRa9WXxlh4EQnzg/FxOci0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ND9XEO/W; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756460998; x=1787996998;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vTrZCzGqprJa4CTDYYxT6WV6QVw3cRAJY7/mRObXOP8=;
  b=ND9XEO/WxNGu9xhUNRbgO+cRKp9/PV2wW4z7oQdkM9EvsR663C6l0gGO
   Tnrp25KqVMF0b9tiHZwt79eD2ObkLFSnwZ5VrW27EQs+V+QV4LhVy6dKJ
   52V0b7M6iI6usNCbZ6f2604uCCvD+Xip+a5vdqW3fzkHhOAz1RQ1ojXNu
   UtctExeUbfIrolSuGz3i+1b/yCeA7bs42ZO/8FICN7gtgs5koXkPPARXN
   Xo2mnINXWsXWmn90+cF5qttSrwo/mYbE2JXBj0Bl7IMgw0mbWzlTn9cv5
   xK4Ri146005BMHhqv/ylUniG1oDOZX3FMWD3WGec5a8kjxSysryLvoL5O
   A==;
X-CSE-ConnectionGUID: wGTOAzENQaCIaDBcMMRwjA==
X-CSE-MsgGUID: wpIbUhEOTfKonfg4zquP3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58667411"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58667411"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 02:49:57 -0700
X-CSE-ConnectionGUID: akA7G3iWTmGzLjPNu+Xh6Q==
X-CSE-MsgGUID: cUeVsKv5TKqVRHsJNmXV5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="170730842"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 02:49:53 -0700
Message-ID: <ac78e6fd-24d4-4d1e-9b98-a0831f369f82@linux.intel.com>
Date: Fri, 29 Aug 2025 17:49:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 07/18] KVM: TDX: Fold tdx_sept_drop_private_spte()
 into tdx_sept_remove_private_spte()
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
 Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ackerley Tng <ackerleytng@google.com>
References: <20250829000618.351013-1-seanjc@google.com>
 <20250829000618.351013-8-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250829000618.351013-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/29/2025 8:06 AM, Sean Christopherson wrote:
> Fold tdx_sept_drop_private_spte() into tdx_sept_remove_private_spte() to
> avoid having to differnatiate between "zap", "drop", and "remove", and to
> eliminate dead code due to redundant checks, e.g. on an HKID being
> assigned.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/tdx.c | 90 +++++++++++++++++++-----------------------
>   1 file changed, 40 insertions(+), 50 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 50a9d81dad53..8cb6a2627eb2 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1651,55 +1651,6 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>   	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
>   }
>   
> -static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> -				      enum pg_level level, struct page *page)
> -{
> -	int tdx_level = pg_level_to_tdx_sept_level(level);
> -	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> -	gpa_t gpa = gfn_to_gpa(gfn);
> -	u64 err, entry, level_state;
> -
> -	/* TODO: handle large pages. */
> -	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> -		return -EIO;
> -
> -	if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
> -		return -EIO;
> -
> -	/*
> -	 * When zapping private page, write lock is held. So no race condition
> -	 * with other vcpu sept operation.
> -	 * Race with TDH.VP.ENTER due to (0-step mitigation) and Guest TDCALLs.
> -	 */
> -	err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
> -				  &level_state);
> -
> -	if (unlikely(tdx_operand_busy(err))) {
> -		/*
> -		 * The second retry is expected to succeed after kicking off all
> -		 * other vCPUs and prevent them from invoking TDH.VP.ENTER.
> -		 */
> -		tdx_no_vcpus_enter_start(kvm);
> -		err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
> -					  &level_state);
> -		tdx_no_vcpus_enter_stop(kvm);
> -	}
> -
> -	if (KVM_BUG_ON(err, kvm)) {
> -		pr_tdx_error_2(TDH_MEM_PAGE_REMOVE, err, entry, level_state);
> -		return -EIO;
> -	}
> -
> -	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
> -
> -	if (KVM_BUG_ON(err, kvm)) {
> -		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
> -		return -EIO;
> -	}
> -	tdx_clear_page(page);
> -	return 0;
> -}
> -
>   static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
>   				     enum pg_level level, void *private_spt)
>   {
> @@ -1861,7 +1812,11 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
>   static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>   					enum pg_level level, kvm_pfn_t pfn)
>   {
> +	int tdx_level = pg_level_to_tdx_sept_level(level);
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>   	struct page *page = pfn_to_page(pfn);
> +	gpa_t gpa = gfn_to_gpa(gfn);
> +	u64 err, entry, level_state;
>   	int ret;
>   
>   	/*
> @@ -1872,6 +1827,10 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>   	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
>   		return -EIO;
>   
> +	/* TODO: handle large pages. */
> +	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> +		return -EIO;
> +
>   	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
>   	if (ret <= 0)
>   		return ret;
> @@ -1882,7 +1841,38 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>   	 */
>   	tdx_track(kvm);
>   
> -	return tdx_sept_drop_private_spte(kvm, gfn, level, page);
> +	/*
> +	 * When zapping private page, write lock is held. So no race condition
> +	 * with other vcpu sept operation.
> +	 * Race with TDH.VP.ENTER due to (0-step mitigation) and Guest TDCALLs.
> +	 */
> +	err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
> +				  &level_state);
> +
> +	if (unlikely(tdx_operand_busy(err))) {
> +		/*
> +		 * The second retry is expected to succeed after kicking off all
> +		 * other vCPUs and prevent them from invoking TDH.VP.ENTER.
> +		 */
> +		tdx_no_vcpus_enter_start(kvm);
> +		err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
> +					  &level_state);
> +		tdx_no_vcpus_enter_stop(kvm);
> +	}
> +
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error_2(TDH_MEM_PAGE_REMOVE, err, entry, level_state);
> +		return -EIO;
> +	}
> +
> +	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
> +		return -EIO;
> +	}
> +
> +	tdx_clear_page(page);
> +	return 0;
>   }
>   
>   void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,


