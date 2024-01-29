Return-Path: <kvm+bounces-7295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1AE183FBF1
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 02:50:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6BFD11F22396
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 01:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 060EBDF66;
	Mon, 29 Jan 2024 01:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S0qHdZIl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069FADDC1;
	Mon, 29 Jan 2024 01:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706493031; cv=none; b=WQ1U8N5GngDQTgxdqcA8Fkv+DuqdlVVgbilCerq6WPqF5pATzHem5TSSYgjstnvaf7UbO/5eaJLzCib2lqSvqcCbKVjjtSKw6JzZ+RM4yrXeUN5R7pGnk518dJb6AV2BXxUvkSdF4ku+lnAcs2WY/bftxi9Ye9RLyllIYlAxS/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706493031; c=relaxed/simple;
	bh=SalaM6JGrf0LlUVTIAvgjUI/PUUumRog1VzeLyjKhQo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BMTOz3Vrb3WUD9J4HvJ32n/34bhXokqe8PlcpEMTQeO0FCMwkyna9YSpqc14qOAoVwtH7N2Jjo/ZqIEbo8seD2hphV2SouurPJqc963YL7keVzjOQ9hARxFMlHvU+H8Wv6ksEr1yQkVIstHZsnawW7iWg5uxRR/xQ8eBYbWghkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S0qHdZIl; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706493029; x=1738029029;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SalaM6JGrf0LlUVTIAvgjUI/PUUumRog1VzeLyjKhQo=;
  b=S0qHdZIlBV74gow6C96e8x+TMlVUkVHkk+Y8too+PIGIsorVO5HhnYI/
   hrhIbuBJKvCj+wu0LyPBsVLAFQwT1wuSpX96+aVcr+6gaHybuWvcp4qxR
   WCik+uk8CdIvzhxRoIlI2ZDQCFLNle4KuubgSnIy/S1hGGui5qDUGv9EM
   2uGBykNfVHnr09OQxd0VRkdxZ0hhIsZDwwcI+DywD2U4DgdkmexdpgYti
   oI3LVxEyIowUyle8DD2IenTcC+rDm5uKApw2hTGd5cuqLmKRs36LxUmDi
   qKgPTHDT9Yn65E8EwmLsKpqcrUAvfX0YflVM/XmMiSKk/E5qCzQI9P/hT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10967"; a="10214620"
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="10214620"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 17:50:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="3259814"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.8.92]) ([10.93.8.92])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 17:50:15 -0800
Message-ID: <3833f6df-337f-442a-b37c-070a92bbd30f@linux.intel.com>
Date: Mon, 29 Jan 2024 09:50:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 046/121] KVM: x86/mmu: Add a new is_private member for
 union kvm_mmu_page_role
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <33812f5282bc42e0e8e6eaaa2a6a63ce4d258bfc.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <33812f5282bc42e0e8e6eaaa2a6a63ce4d258bfc.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Because TDX support introduces private mapping, add a new member in union
> kvm_mmu_page_role with access functions to check the member.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 27 +++++++++++++++++++++++++++
>   arch/x86/kvm/mmu/mmu_internal.h |  5 +++++
>   arch/x86/kvm/mmu/spte.h         |  6 ++++++
>   3 files changed, 38 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 313519edd79e..0cdbbc21136b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -349,7 +349,12 @@ union kvm_mmu_page_role {
>   		unsigned ad_disabled:1;
>   		unsigned guest_mode:1;
>   		unsigned passthrough:1;
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +		unsigned is_private:1;
> +		unsigned :4;
> +#else
>   		unsigned :5;
> +#endif
>   
>   		/*
>   		 * This is left at the top of the word so that
> @@ -361,6 +366,28 @@ union kvm_mmu_page_role {
>   	};
>   };
>   
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +static inline bool kvm_mmu_page_role_is_private(union kvm_mmu_page_role role)
> +{
> +	return !!role.is_private;
> +}
> +
> +static inline void kvm_mmu_page_role_set_private(union kvm_mmu_page_role *role)
> +{
> +	role->is_private = 1;
> +}
> +#else
> +static inline bool kvm_mmu_page_role_is_private(union kvm_mmu_page_role role)
> +{
> +	return false;
> +}
> +
> +static inline void kvm_mmu_page_role_set_private(union kvm_mmu_page_role *role)
> +{
> +	WARN_ON_ONCE(1);
> +}
> +#endif
> +
>   /*
>    * kvm_mmu_extended_role complements kvm_mmu_page_role, tracking properties
>    * relevant to the current MMU configuration.   When loading CR0, CR4, or EFER,
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 2b9377442927..97af4e39ce6f 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -145,6 +145,11 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
>   	return kvm_mmu_role_as_id(sp->role);
>   }
>   
> +static inline bool is_private_sp(const struct kvm_mmu_page *sp)
> +{
> +	return kvm_mmu_page_role_is_private(sp->role);
> +}
> +
>   static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
>   {
>   	/*
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 1a163aee9ec6..88db32cba0fd 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -264,6 +264,12 @@ static inline struct kvm_mmu_page *root_to_sp(hpa_t root)
>   	return spte_to_child_sp(root);
>   }
>   
> +static inline bool is_private_sptep(u64 *sptep)
> +{
> +	WARN_ON_ONCE(!sptep);

If sptep is NULL, should return here, otherwise, the following code will
de-reference a illegal pointer.

> +	return is_private_sp(sptep_to_sp(sptep));
> +}
> +
>   static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
>   {
>   	return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&


