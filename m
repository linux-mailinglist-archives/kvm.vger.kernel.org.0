Return-Path: <kvm+bounces-56264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 799DAB3B7C2
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 11:52:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 303D2A00103
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 09:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1940E3054C9;
	Fri, 29 Aug 2025 09:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K/X6w5hA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDCC270EBC;
	Fri, 29 Aug 2025 09:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756461146; cv=none; b=QMdz92R+Dv0C3BTlXO5OTYTpdiNW9ur7gcgdnwOS4iKIyVeBoL4fPib4OELN+URu8abwSIzASw9U5oNQHlq69pqINBwq02vM18V8xiupK3F7QdBBgv8FIo47Amub3mF51Yy2mPBgyRjzBnf31r6fQ25pANffdzSkjXMJDhaSEEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756461146; c=relaxed/simple;
	bh=iQ1V4QRcXi7Ekbaz4B60E53HmEmrlQqpOi0SmLfxvJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oe5/1Ai8Pyv/ZreIteQ9M02S4hCruIgyGfCdMu9+QAPHgGpLL1R5/fEwpYcO2e56AMn8fPhdO5LDqpjwUQcLDQyls/eVIYJC97Bn/Imh4ZDgL2fDLfa5aGl9a16GPVVNMVtBttgrhdel6qVjDGxmumLB8veaGm199kMNccE1nIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K/X6w5hA; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756461144; x=1787997144;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iQ1V4QRcXi7Ekbaz4B60E53HmEmrlQqpOi0SmLfxvJQ=;
  b=K/X6w5hAlmgPeo/r3rUYdqeg/MSYsklzI9pHB1jeCFjhrKgI8A+ffS2P
   b9HqwpF7VJlFjAiLXAKiMLC7FjEX+V+GuCQ+BYLIahcGtnrcRv8sTi4bn
   goNThIeVfF4gM1po7Mp2T9BpkUDZ0NO3gWOGGpQDCmrp7AtlU6D8Sjw9t
   Drv4GfH2ZrYhouqxi48Rrku6zrZ4nKpSH9iBp7IvAi0ngLYkJq+/vBAMf
   2tHLsHf1H3OdEVf68vwykwfT2lXOPw2DS4V5C01dakkL1JIKVitWqg0Wo
   wOT1y4JJTh93yxKXUPv5O/nhEK0AN1w8FYznuz81e6Q3ZUJbsAZHZRsxU
   g==;
X-CSE-ConnectionGUID: ZRGo64aDSfSiJKtTP3olig==
X-CSE-MsgGUID: OPakIk9kTjepxzhcZ05N9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="62561205"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="62561205"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 02:52:23 -0700
X-CSE-ConnectionGUID: o3nLuVTJTOWqp7Z+AnpQwQ==
X-CSE-MsgGUID: zvcQp0n6TWGV68/usONWPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="174717934"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 02:52:21 -0700
Message-ID: <9db57c7d-ee8f-49ee-ad09-33006811f047@linux.intel.com>
Date: Fri, 29 Aug 2025 17:52:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 08/18] KVM: x86/mmu: Drop the return code from
 kvm_x86_ops.remove_external_spte()
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
 Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ackerley Tng <ackerleytng@google.com>
References: <20250829000618.351013-1-seanjc@google.com>
 <20250829000618.351013-9-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250829000618.351013-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/29/2025 8:06 AM, Sean Christopherson wrote:
> Drop the return code from kvm_x86_ops.remove_external_spte(), a.k.a.
> tdx_sept_remove_private_spte(), as KVM simply does a KVM_BUG_ON() failure,
> and that KVM_BUG_ON() is redundant since all error paths in TDX also do a
> KVM_BUG_ON().
>
> Opportunistically pass the spte instead of the pfn, as the API is clearly
> about removing an spte.
>
> Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/include/asm/kvm_host.h |  4 ++--
>   arch/x86/kvm/mmu/tdp_mmu.c      |  8 ++------
>   arch/x86/kvm/vmx/tdx.c          | 17 ++++++++---------
>   3 files changed, 12 insertions(+), 17 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0d3cc0fc27af..d0a8404a6b8f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1852,8 +1852,8 @@ struct kvm_x86_ops {
>   				 void *external_spt);
>   
>   	/* Update external page table from spte getting removed, and flush TLB. */
> -	int (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> -				    kvm_pfn_t pfn_for_gfn);
> +	void (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +				     u64 spte);
>   
>   	bool (*has_wbinvd_exit)(void);
>   
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 3ea2dd64ce72..78ee085f7cbc 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -362,9 +362,6 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>   static void remove_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
>   				 int level)
>   {
> -	kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
> -	int ret;
> -
>   	/*
>   	 * External (TDX) SPTEs are limited to PG_LEVEL_4K, and external
>   	 * PTs are removed in a special order, involving free_external_spt().
> @@ -377,9 +374,8 @@ static void remove_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
>   
>   	/* Zapping leaf spte is allowed only when write lock is held. */
>   	lockdep_assert_held_write(&kvm->mmu_lock);
> -	/* Because write lock is held, operation should success. */
> -	ret = kvm_x86_call(remove_external_spte)(kvm, gfn, level, old_pfn);
> -	KVM_BUG_ON(ret, kvm);
> +
> +	kvm_x86_call(remove_external_spte)(kvm, gfn, level, old_spte);
>   }
>   
>   /**
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 8cb6a2627eb2..07f9ad1fbfb6 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1809,12 +1809,12 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
>   	return tdx_reclaim_page(virt_to_page(private_spt));
>   }
>   
> -static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
> -					enum pg_level level, kvm_pfn_t pfn)
> +static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
> +					 enum pg_level level, u64 spte)
>   {
> +	struct page *page = pfn_to_page(spte_to_pfn(spte));
>   	int tdx_level = pg_level_to_tdx_sept_level(level);
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> -	struct page *page = pfn_to_page(pfn);
>   	gpa_t gpa = gfn_to_gpa(gfn);
>   	u64 err, entry, level_state;
>   	int ret;
> @@ -1825,15 +1825,15 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>   	 * there can't be anything populated in the private EPT.
>   	 */
>   	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
> -		return -EIO;
> +		return;
>   
>   	/* TODO: handle large pages. */
>   	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> -		return -EIO;
> +		return;
>   
>   	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
>   	if (ret <= 0)
> -		return ret;
> +		return;
>   
>   	/*
>   	 * TDX requires TLB tracking before dropping private page.  Do
> @@ -1862,17 +1862,16 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>   
>   	if (KVM_BUG_ON(err, kvm)) {
>   		pr_tdx_error_2(TDH_MEM_PAGE_REMOVE, err, entry, level_state);
> -		return -EIO;
> +		return;
>   	}
>   
>   	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
>   	if (KVM_BUG_ON(err, kvm)) {
>   		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
> -		return -EIO;
> +		return;
>   	}
>   
>   	tdx_clear_page(page);
> -	return 0;
>   }
>   
>   void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,


