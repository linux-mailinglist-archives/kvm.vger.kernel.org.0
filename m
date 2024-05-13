Return-Path: <kvm+bounces-17291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 451498C3B1C
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 07:56:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67F951C20EC9
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 05:56:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66D5D1465A5;
	Mon, 13 May 2024 05:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HIcQmUJZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE65250280;
	Mon, 13 May 2024 05:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715579800; cv=none; b=qtVU8UbVIRtipkAee+/2iyBeY+DYnxDf2txMLh7n2d4HDr/49NT7ThGyOyFqnEyglXfkhWoCZ2iSuFeIluEeIAihyptesWTSI4TNGYYbsmYiA7ktXewIkHZqwjoZqRSISRJqIPB5Lf06DsZc3wvu6Fsj5/i2WCx6kiS7tMQVwRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715579800; c=relaxed/simple;
	bh=G8iOywcAcBnScphNUsC6tyWcLR3GHdaAtCcIaphQd+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S0pMAz57Xj9vTa0gwB0I+8zVW5qELJFnVuUxHKvLkiaqEp8TXMMoP3VZGwjd61ju7Pv0wgqRH4Ib+W/figtHFa7a/2Rbf91HdTGz/EnioMACcxedvf65+PPVrCUdkskL6oMBgR7RssUQrFCkXCDtSo4d0mAZsFiSgo5iIHgWZRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HIcQmUJZ; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715579798; x=1747115798;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=G8iOywcAcBnScphNUsC6tyWcLR3GHdaAtCcIaphQd+o=;
  b=HIcQmUJZlh74GCYAgv8OmorAUq62cVP/OvvPA92YRRfVf37/J8nNeRP/
   bMaOdoZJz0kovH8t0oWOK2eivbn5F4Yea8YJ+sSI+sIUkkkTlinL4oPKr
   tVqBt278L36qLRDk2jS+Ul9/bbeivBupcTsdxbt+6iFQ1vRTD4fJT34cN
   YxMtF7dR7PXhz7Y3IQfp9koeFWlCoWgXjQIvqM3yWa+NzMAAcTZVKvWQU
   CC5Ib/aqje9x4B6g2Ob/jdeqCZCAvTZHHzQwhvyDLh56zAm4KHf0jZg+r
   xHGGOmwpaKGYu3S6Cu62iez1zI2dSMd3Sh0/btwyKSB4PFUGZg/OCw7fk
   A==;
X-CSE-ConnectionGUID: E7Hc8rMBRme/3x5YkBRsbw==
X-CSE-MsgGUID: GWpr7pstRJm1HRcElt4TuA==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="11715083"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="11715083"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 22:56:37 -0700
X-CSE-ConnectionGUID: P6Zc/P7tTxOKeFH7mhe1SA==
X-CSE-MsgGUID: q++dGDfOQOOXcbZF73pT7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="30787423"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.198]) ([10.125.243.198])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 22:56:37 -0700
Message-ID: <a7def4e2-34f0-45cf-8efa-eb063c85591f@intel.com>
Date: Mon, 13 May 2024 13:56:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/17] KVM: x86/mmu: Use synthetic page fault error code
 to indicate private faults
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
 <20240507155817.3951344-8-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240507155817.3951344-8-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/2024 11:58 PM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Add and use a synthetic, KVM-defined page fault error code to indicate
> whether a fault is to private vs. shared memory.  TDX and SNP have
> different mechanisms for reporting private vs. shared, and KVM's
> software-protected VMs have no mechanism at all.  Usurp an error code
> flag to avoid having to plumb another parameter to kvm_mmu_page_fault()
> and friends.
> 
> Alternatively, KVM could borrow AMD's PFERR_GUEST_ENC_MASK, i.e. set it
> for TDX and software-protected VMs as appropriate, but that would require
> *clearing* the flag for SEV and SEV-ES VMs, which support encrypted
> memory at the hardware layer, but don't utilize private memory at the
> KVM layer.
> 
> Opportunistically add a comment to call out that the logic for software-
> protected VMs is (and was before this commit) broken for nested MMUs, i.e.
> for nested TDP, as the GPA is an L2 GPA.  Punt on trying to play nice with
> nested MMUs as there is a _lot_ of functionality that simply doesn't work
> for software-protected VMs, e.g. all of the paths where KVM accesses guest
> memory need to be updated to be aware of private vs. shared memory.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20240228024147.41573-6-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/include/asm/kvm_host.h |  7 ++++++-
>   arch/x86/kvm/mmu/mmu.c          | 14 ++++++++++++++
>   arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>   3 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 12e727301262..0dc755a6dc0c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -273,7 +273,12 @@ enum x86_intercept_stage;
>    * when emulating instructions that triggers implicit access.
>    */
>   #define PFERR_IMPLICIT_ACCESS	BIT_ULL(48)
> -#define PFERR_SYNTHETIC_MASK	(PFERR_IMPLICIT_ACCESS)
> +/*
> + * PRIVATE_ACCESS is a KVM-defined flag us to indicate that a fault occurred
> + * when the guest was accessing private memory.
> + */
> +#define PFERR_PRIVATE_ACCESS   BIT_ULL(49)
> +#define PFERR_SYNTHETIC_MASK   (PFERR_IMPLICIT_ACCESS | PFERR_PRIVATE_ACCESS)
>   
>   #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
>   				 PFERR_WRITE_MASK |		\
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3609167ba30e..eb041acec2dc 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5799,6 +5799,20 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>   	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
>   		return RET_PF_RETRY;
>   
> +	/*
> +	 * Except for reserved faults (emulated MMIO is shared-only), set the
> +	 * PFERR_PRIVATE_ACCESS flag for software-protected VMs based on the gfn's
> +	 * current attributes, which are the source of truth for such VMs.  Note,
> +	 * this wrong for nested MMUs as the GPA is an L2 GPA, but KVM doesn't
> +	 * currently supported nested virtualization (among many other things)
> +	 * for software-protected VMs.
> +	 */
> +	if (IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) &&
> +	    !(error_code & PFERR_RSVD_MASK) &&
> +	    vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM &&
> +	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
> +		error_code |= PFERR_PRIVATE_ACCESS;
> +
>   	r = RET_PF_INVALID;
>   	if (unlikely(error_code & PFERR_RSVD_MASK)) {
>   		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 797b80f996a7..dfd9ff383663 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -306,7 +306,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
>   		.req_level = PG_LEVEL_4K,
>   		.goal_level = PG_LEVEL_4K,
> -		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
> +		.is_private = err & PFERR_PRIVATE_ACCESS,
>   	};
>   	int r;
>   


