Return-Path: <kvm+bounces-17288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6009A8C3AF4
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 07:26:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B9341F21281
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 05:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 527CB146584;
	Mon, 13 May 2024 05:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E+h2s6kE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EE7146006;
	Mon, 13 May 2024 05:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715577964; cv=none; b=ZP1IfKGYWLEKnWXXznJB+qxsgqMHVjmayZKyCzQs7grMGi8ayTypAQ4OoEsqKvh+aeBp1uOrcwzoYW+mAA3t3i8Ax44U5Uw/1zSjJ5+cNp+VlYhBKk/hVVboP7uwLRyVAMiljqOWSakC9E0/cQvDU/9VGeKqfOBds++EveRgyWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715577964; c=relaxed/simple;
	bh=1SNWQqlP+cDSQB765TNrbhmu/uVz6UANgzXoGbpiemk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HPSC+iX85MW2Uumywt6vSztS4kDKG9WPIjcA1Yek4AYXV5qhb911UDG+zsw6SGFxHq5TVLt1M2Rrz34jXbmaH7jcX7g0HCe8M36v7tmrYyxJHm074kghWnGZCsfyfpgCwcwsXd4FFIVcaZBJIQhrdIa+byoXDEpQBjPTs4j0nOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E+h2s6kE; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715577962; x=1747113962;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1SNWQqlP+cDSQB765TNrbhmu/uVz6UANgzXoGbpiemk=;
  b=E+h2s6kEr+CmQBJvlzXiX+miWV3T5uz03zxQDWEPb0v5nspCzYV9C1Xa
   a3QdkiJJaaRyX9yPlO6dbZf82AnUo5Lj9f/WAuvctJRn2eXd5kG5JPaQ/
   G4+jj9XUuV98WZhRcI/9GaWBcRdkR3I50/EZ5cyUcQtb9zIZPsD4ccLnm
   DoShh41xH1kEurxt6Ed1xCz/q0rdHEKbgFZnpViyJUDUJ/e3MfIfSZq4/
   E+x9INzlfQji9XXEnmn6uZSsBQ3bPlrsIRyWbDFR/+Gg/7SGFB+ZOzeVm
   2gQiZxnXIK9Mwc0PF1rG3g9PJRGz90/MyqMxd2ohztwQnuugi6DOZB9BT
   Q==;
X-CSE-ConnectionGUID: IHCSgbyLROKrPBVE12qyZQ==
X-CSE-MsgGUID: 4y6j8kWrQYOkdFsO82X0dw==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="11328929"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="11328929"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 22:26:01 -0700
X-CSE-ConnectionGUID: kFPvqhbUQt66tWlW4T7UlQ==
X-CSE-MsgGUID: U8bLqxN8RMmwzw52KbN1cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="34979067"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.198]) ([10.125.243.198])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 22:26:00 -0700
Message-ID: <89c9df54-1dcd-4acc-bd67-49d6a2bf2f5d@intel.com>
Date: Mon, 13 May 2024 13:25:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/17] KVM: x86/mmu: Exit to userspace with -EFAULT if
 private fault hits emulation
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Yan Zhao <yan.y.zhao@intel.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
 <20240507155817.3951344-2-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240507155817.3951344-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/2024 11:58 PM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Exit to userspace with -EFAULT / KVM_EXIT_MEMORY_FAULT if a private fault
> triggers emulation of any kind, as KVM doesn't currently support emulating
> access to guest private memory.  Practically speaking, private faults and
> emulation are already mutually exclusive, but there are many flow that
> can result in KVM returning RET_PF_EMULATE, and adding one last check
> to harden against weird, unexpected combinations and/or KVM bugs is
> inexpensive.
> 
> Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-ID: <20240228024147.41573-2-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/mmu/mmu.c          |  8 --------
>   arch/x86/kvm/mmu/mmu_internal.h | 19 +++++++++++++++++++
>   2 files changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 45b6d8f9e359..c72a2033ca96 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4257,14 +4257,6 @@ static inline u8 kvm_max_level_for_order(int order)
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
> index 5390a591a571..61f49967047a 100644
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
> @@ -320,6 +328,17 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   	else
>   		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
>   
> +	/*
> +	 * Not sure what's happening, but punt to userspace and hope that
> +	 * they can fix it by changing memory to shared, or they can
> +	 * provide a better error.
> +	 */
> +	if (r == RET_PF_EMULATE && fault.is_private) {
> +		pr_warn_ratelimited("kvm: unexpected emulation request on private memory\n");
> +		kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
> +		return -EFAULT;
> +	}
> +
>   	if (fault.write_fault_to_shadow_pgtable && emulation_type)
>   		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
>   


