Return-Path: <kvm+bounces-10979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ECD05871FE8
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:17:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A9CC1C252BB
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C577E86131;
	Tue,  5 Mar 2024 13:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CDrfowPh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA4085C51;
	Tue,  5 Mar 2024 13:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709644646; cv=none; b=QF5Bw8CQmiUMfr96onivh8SXBfYdGNcVSlCsQ85xfgahfZVV1LPQQfUO3EintTPy12hBPWEdSX5URuGvB/kYxkuG00SZP1WfEnrARPuQZG+Mq49Ocy/7DW8s7dEnRRW4oU0bG/wFWR10ykUr8cQJP8zJ2bPrejr2RuFBSqjKZS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709644646; c=relaxed/simple;
	bh=XSZ000gYNJaQ6X4mzMWtTyUdxiMvcu9oyrTQhZJdmaA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DyIY2R89I+NF8s61k6YILfQ9iLcGEYcs4nPq0/NxqGj4dJNVQ8+pwa/BXZiaF0jp4fGowddtPGKLH1pZ11ieBfL2zr3aSjnaFA8SvJMcFT6abW1ffDYq3SkF5VePAGYkvLaLNFCcNeob0ApXvCswAHzGIglP53fuClOyZZ365qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CDrfowPh; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709644644; x=1741180644;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XSZ000gYNJaQ6X4mzMWtTyUdxiMvcu9oyrTQhZJdmaA=;
  b=CDrfowPh2NFiEloMzyVqnl41cQAGHWBeozeMHMk5vEQRtVaIxzGLPKxr
   b/4K0FxQkewuaS++03LgoASaXbtbBmIcjLM2ux/d69Xpb4Z7VXGhr4NZS
   7T4W7Y1HPrrvSbN0Dioq8MvZEplWC2aDLR5/A85LVzsTPQgK4+PlR0Qim
   InM3h3F+E9qToyo+ZI4nP79TLRhkGtV/eLRdFlxvHCoL5fiA39hVjnm42
   1F2dmH/ZSeMRB5e+uCnig84WcC7ssX8+m2ttgHv4t1LSDxQnqaWIqWt2G
   LylROoH+fims+LliAesUeWtZW4ATM51sQAo2PDjnzkjBJIBuYlM54adev
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="4777365"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="4777365"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 05:17:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="14051402"
Received: from peizhenz-mobl2.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 05:17:19 -0800
Message-ID: <891c98f2-9300-4393-b3d1-ac975892bcb8@linux.intel.com>
Date: Tue, 5 Mar 2024 21:17:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/21] KVM: x86/mmu: Add Suppress VE bit to EPT
 shadow_mmio_mask/shadow_present_mask
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
 michael.roth@amd.com, isaku.yamahata@intel.com, thomas.lendacky@amd.com
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-6-pbonzini@redhat.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240227232100.478238-6-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/28/2024 7:20 AM, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> To make use of the same value of shadow_mmio_mask and shadow_present_mask
> for TDX and VMX, add Suppress-VE bit to shadow_mmio_mask and
> shadow_present_mask so that they can be common for both VMX and TDX.
>
> TDX will require shadow_mmio_mask and shadow_present_mask to include
> VMX_SUPPRESS_VE for shared GPA so that EPT violation is triggered for
> shared GPA.  For VMX, VMX_SUPPRESS_VE doesn't matter for MMIO because the
> spte value is defined so as to cause EPT misconfig.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Message-Id: <97cc616b3563cd8277be91aaeb3e14bce23c3649.1705965635.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/include/asm/vmx.h | 1 +
>   arch/x86/kvm/mmu/spte.c    | 6 ++++--
>   2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 0e73616b82f3..76ed39541a52 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -513,6 +513,7 @@ enum vmcs_field {
>   #define VMX_EPT_IPAT_BIT    			(1ull << 6)
>   #define VMX_EPT_ACCESS_BIT			(1ull << 8)
>   #define VMX_EPT_DIRTY_BIT			(1ull << 9)
> +#define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
>   #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
>   						 VMX_EPT_WRITABLE_MASK |       \
>   						 VMX_EPT_EXECUTABLE_MASK)
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 4a599130e9c9..02a466de2991 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -429,7 +429,9 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
>   	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
>   	shadow_nx_mask		= 0ull;
>   	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
> -	shadow_present_mask	= has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
> +	/* VMX_EPT_SUPPRESS_VE_BIT is needed for W or X violation. */
> +	shadow_present_mask	=
> +		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | VMX_EPT_SUPPRESS_VE_BIT;
>   	/*
>   	 * EPT overrides the host MTRRs, and so KVM must program the desired
>   	 * memtype directly into the SPTEs.  Note, this mask is just the mask
> @@ -446,7 +448,7 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
>   	 * of an EPT paging-structure entry is 110b (write/execute).
>   	 */
>   	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE,
> -				   VMX_EPT_RWX_MASK, 0);
> +				   VMX_EPT_RWX_MASK | VMX_EPT_SUPPRESS_VE_BIT, 0);
>   }
>   EXPORT_SYMBOL_GPL(kvm_mmu_set_ept_masks);
>   


