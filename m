Return-Path: <kvm+bounces-10591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 80F4B86DC0E
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 08:26:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BA9B1F25652
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 07:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4EE69959;
	Fri,  1 Mar 2024 07:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XQhHJVjl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D7167E81;
	Fri,  1 Mar 2024 07:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709277974; cv=none; b=gSD4RWuIsgnPmDkakG4r9K79H7e2PtgDwYsrA9//0mSdJ2Q3igHV8ho/DL/4jPgwllBv0wVL4zGUoDMVWDf6sl7RZTfbr14kLvcEWM8zuBFfUaa6qth/B+wA+i+iSRSAB4Mv9eihk+YDcxa49NEmTM6S0LIJbJS0Donlwrl2N+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709277974; c=relaxed/simple;
	bh=Rhs6jAAGLoJTszhcWzmU7in30IBcE5D1BcGRAqr55KA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XvzV0hYm5tSjCij1WOAsznclV8owONmEdoTnHLyBTHAvN/GXkNmw+QZCl1erLNgiHk1JJs8sByVkMByZifFctT5tYJsFODNqkfVp7K0BSBOUNTjSPmhKglEavV0PoUXMo+jZbv0U9fPqY6w8whBmAVMx7a2l92BfebBfCXJyZIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XQhHJVjl; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709277973; x=1740813973;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Rhs6jAAGLoJTszhcWzmU7in30IBcE5D1BcGRAqr55KA=;
  b=XQhHJVjlXX4IyuWkOOSYf19RfTOleuIkoMedV0y4ti6amcpKR4FsJs65
   NQtlPGruZCEbxEPWdcTqwJrDCGS6josW8DMDH4bjEqiwmDjVKQswYxBI/
   wYhmPfa8GcwRkQgGNqWMqA/PVoaXTZV19w/0AmUbBrdM8pl7WtLpuN8Ym
   0CAKVrPYKhZ796yqfVIjEgcfD+qPw1l4JRrCmyvzY7aVmutHMIu8DhTlO
   QCmlsKTAtS+EfMFg3laO0LLlfjCoL+kfQCKQYFSOcYQeA2dBV2H/1ACTw
   1nVxTG87jHdSi64U8a2PiuL5QfiqhDkUI8uuYGg6cS34UKGvl8xv8VIZe
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="3657784"
X-IronPort-AV: E=Sophos;i="6.06,195,1705392000"; 
   d="scan'208";a="3657784"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 23:26:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,195,1705392000"; 
   d="scan'208";a="12797487"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 23:26:09 -0800
Message-ID: <8a9104e6-6fa2-4aaa-88c2-491b1ee612b4@intel.com>
Date: Fri, 1 Mar 2024 15:26:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/21] KVM: x86/mmu: Add Suppress VE bit to EPT
 shadow_mmio_mask/shadow_present_mask
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, michael.roth@amd.com, isaku.yamahata@intel.com,
 thomas.lendacky@amd.com
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-6-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
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

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

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


