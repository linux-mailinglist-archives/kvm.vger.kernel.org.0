Return-Path: <kvm+bounces-10604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B346286DD70
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 09:48:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E54CD1C226DB
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 08:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD3446A01C;
	Fri,  1 Mar 2024 08:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hCO0Ev1/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E5169E0D;
	Fri,  1 Mar 2024 08:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709282892; cv=none; b=KqvRrJoph98RhQ6M/JtUVVVqcyDMZc+LiXd6HQ4i9Hu/FihtuJLX/PBADGW+wD7S5i+Bf7lZSTVMOyWNIAFZbEICJDp1nCL4XqpqKQ7j2rQ0sTkK/lKTXC7M4Qr8gbc+FxlZ0pB4pHZhjuf6MndFdxQpOeA4LMR87YyiSWpJQlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709282892; c=relaxed/simple;
	bh=R/rOgd/qTFMbMHisoVlhy59ZyhPRxFPfUxNO/Cto76Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UxUbCXJyuQOnY1j5gJJQZpnPuoHi/r5QmeCf9eKg20g1DAu8KMWm1oK6kVge9rkDDorRZM/qvY1iUo2tO+Q+izGIFhGCTW3YFtHlpvxDfABdBGJ4Zt1CFuHYEYl124xlaIYPavYTrAJgl5wv7LqYZjPTgZg2NjZYUt+gG/fnbho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hCO0Ev1/; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709282891; x=1740818891;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=R/rOgd/qTFMbMHisoVlhy59ZyhPRxFPfUxNO/Cto76Q=;
  b=hCO0Ev1/OmBFVohDjCqbOH0PEIiJWtR0s9pUZpc4q9G6sEcwZb06AKSq
   6f2ixu+fTXIOBcbj6VfmISVGaf253WmIVyPslRZ3EOcYtimb6ylPuhZ12
   CyJv+DCjOwq8FwQYqXlFq36r1i3BDHyzyS6bCx8ZcZyEMVdLrya9vQh9J
   Uh4jJY/vM+2ESGlnTvcUxRZz91oCD8koJX9r4/2JHmuM6q+bcgYMZoKkA
   BtLD5a8Y+QtIoddNN+sLSSpREimgG8S8qJKZEGVRrIo7R6KwKoI5Qo/90
   b2IjR12Y74yZuZTa7C8HH967PM2YrQ9F9RbHOU7z1vCKI9QWwJOeCJVL6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="6760650"
X-IronPort-AV: E=Sophos;i="6.06,195,1705392000"; 
   d="scan'208";a="6760650"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 00:48:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,195,1705392000"; 
   d="scan'208";a="12815068"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 00:48:07 -0800
Message-ID: <589d8a80-f8e9-4ba3-8eaf-4c85f603285a@intel.com>
Date: Fri, 1 Mar 2024 16:48:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/16] KVM: x86/mmu: Exit to userspace with -EFAULT if
 private fault hits emulation
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
 Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
 David Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-2-seanjc@google.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240228024147.41573-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/2024 10:41 AM, Sean Christopherson wrote:
> Exit to userspace with -EFAULT / KVM_EXIT_MEMORY_FAULT if a private fault
> triggers emulation of any kind, as KVM doesn't currently support emulating
> access to guest private memory.  Practically speaking, private faults and
> emulation are already mutually exclusive, but there are edge cases upon
> edge cases where KVM can return RET_PF_EMULATE, and adding one last check
> to harden against weird, unexpected combinations is inexpensive.
> 
> Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c          |  8 --------
>   arch/x86/kvm/mmu/mmu_internal.h | 13 +++++++++++++
>   2 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e4cc7f764980..e2fd74e06ff8 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4309,14 +4309,6 @@ static inline u8 kvm_max_level_for_order(int order)
>   	return PG_LEVEL_4K;
>   }
>   
> -static void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
> -					      struct kvm_page_fault *fault)
> -{
> -	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
> -				      PAGE_SIZE, fault->write, fault->exec,
> -				      fault->is_private);
> -}
> -
>   static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
>   				   struct kvm_page_fault *fault)
>   {
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 0669a8a668ca..0eea6c5a824d 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -279,6 +279,14 @@ enum {
>   	RET_PF_SPURIOUS,
>   };
>   
> +static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
> +						     struct kvm_page_fault *fault)
> +{
> +	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
> +				      PAGE_SIZE, fault->write, fault->exec,
> +				      fault->is_private);
> +}
> +
>   static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   					u32 err, bool prefetch, int *emulation_type)
>   {
> @@ -320,6 +328,11 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   	else
>   		r = vcpu->arch.mmu->page_fault(vcpu, &fault);

Beg for some comment to explain the paraniod.

> +	if (r == RET_PF_EMULATE && fault.is_private) {
> +		kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
> +		return -EFAULT;
> +	}
> +
>   	if (fault.write_fault_to_shadow_pgtable && emulation_type)
>   		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
>   


