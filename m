Return-Path: <kvm+bounces-15471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24C548AC75A
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 10:47:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2791281426
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 08:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477A053E22;
	Mon, 22 Apr 2024 08:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DUaiycvM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1822751C40;
	Mon, 22 Apr 2024 08:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713775596; cv=none; b=pqEiw52ytAql8mugjgmZsb0YI8vawiUeMKEDnd+qRcgbUNrgWvkImfe6APy7INX7ei6nePmQx1nJAuMJI5Tmh0jVVL6drYuvMXYYdok+MQnYuh3u1Hg519U0hEViUmX1HNYaVVLTlAcyIEJiIPaEHwIAUQ7LKLf9nBhLIIGYWx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713775596; c=relaxed/simple;
	bh=3Nvg6aLMqCpBwmchT+qiCZ4eyxtvIcAIrqVuZuISGKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eyz+rMiLMIdGLbkFzuFqMchqaRVDZzFgtd3Cg5odG1D1ZYjFtVhi5v+yIYPV1iZ2g6Lwf4uKpJto/9q/etNcrLAyXxBy7IvqdFVNKJe9tKkwqvB9lqL3wZQoGydrEdZ7CysbvVHku3fH2gcW/dn9wGE9+D5joeiJGcqPqghH7Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DUaiycvM; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713775594; x=1745311594;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3Nvg6aLMqCpBwmchT+qiCZ4eyxtvIcAIrqVuZuISGKk=;
  b=DUaiycvMFc56ETf2F3JbmWnAsRlz96njEib49B14ZnvVTYxqrnJIdaOJ
   ir4+Opa1W/DF3VLGOo/ylNtsqpO2yActCDdohQ89A/XScEQO/rpcIMEzZ
   os9RHGUf8mH6M/JvLdle5kej3OjXuTJssnc1WArB/YYgVxSsrBjObQ5Lf
   WJeRzyJkYJ/vrIuNv9K/j43i9MWn8vIbQkeB2UkRbYcrtNzmKUpPEq03e
   kWGUkZVCwQDF9rZraP8/pqiLC5flNG1V4qtM08N4AS2W4+WzxhNu97gv3
   ZSg8lDJFTY1H0i1LVbRlbNy/9C/eECH5KR7CS8cxIvGOY14BB2OlRBnA9
   Q==;
X-CSE-ConnectionGUID: km4rVgRCRW2zO6mXyqtSrw==
X-CSE-MsgGUID: ++PM4aAGSz+ZupZjBu8aXA==
X-IronPort-AV: E=McAfee;i="6600,9927,11051"; a="26821752"
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="26821752"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 01:46:33 -0700
X-CSE-ConnectionGUID: bP/TayZPTu2EylGd11+jrw==
X-CSE-MsgGUID: skSrE0G5TfCwOfWAvC3nLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="23925338"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 01:46:30 -0700
Message-ID: <9477c21a-4b18-4539-9f82-11046e43063c@intel.com>
Date: Mon, 22 Apr 2024 16:46:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] KVM: x86/mmu: Extract __kvm_mmu_do_page_fault()
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com, binbin.wu@linux.intel.com, seanjc@google.com,
 rick.p.edgecombe@intel.com
References: <20240419085927.3648704-1-pbonzini@redhat.com>
 <20240419085927.3648704-4-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240419085927.3648704-4-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/19/2024 4:59 PM, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Extract out __kvm_mmu_do_page_fault() from kvm_mmu_do_page_fault().  The
> inner function is to initialize struct kvm_page_fault and to call the fault
> handler, and the outer function handles updating stats and converting
> return code.  

I don't see how the outer function converts return code.

> KVM_PRE_FAULT_MEMORY will call the KVM page fault handler.

I assume it means the inner function will be used by KVM_PRE_FAULT_MEMORY.

> This patch makes the emulation_type always set irrelevant to the return
> code.  kvm_mmu_page_fault() is the only caller of kvm_mmu_do_page_fault(),
> and references the value only when PF_RET_EMULATE is returned.  Therefore,
> this adjustment doesn't affect functionality.

This paragraph needs to be removed, I think. It's not true.

> No functional change intended.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Message-ID: <ddf1d98420f562707b11e12c416cce8fdb986bb1.1712785629.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/mmu/mmu_internal.h | 38 +++++++++++++++++++++------------
>   1 file changed, 24 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index e68a60974cf4..9baae6c223ee 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -287,8 +287,8 @@ static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
>   				      fault->is_private);
>   }
>   
> -static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> -					u64 err, bool prefetch, int *emulation_type)
> +static inline int __kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> +					  u64 err, bool prefetch, int *emulation_type)
>   {
>   	struct kvm_page_fault fault = {
>   		.addr = cr2_or_gpa,
> @@ -318,6 +318,27 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
>   	}
>   
> +	if (IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) && fault.is_tdp)
> +		r = kvm_tdp_page_fault(vcpu, &fault);
> +	else
> +		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
> +
> +	if (r == RET_PF_EMULATE && fault.is_private) {
> +		kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
> +		r = -EFAULT;
> +	}
> +
> +	if (fault.write_fault_to_shadow_pgtable && emulation_type)
> +		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
> +
> +	return r;
> +}
> +
> +static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> +					u64 err, bool prefetch, int *emulation_type)
> +{
> +	int r;
> +
>   	/*
>   	 * Async #PF "faults", a.k.a. prefetch faults, are not faults from the
>   	 * guest perspective and have already been counted at the time of the
> @@ -326,18 +347,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   	if (!prefetch)
>   		vcpu->stat.pf_taken++;
>   
> -	if (IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) && fault.is_tdp)
> -		r = kvm_tdp_page_fault(vcpu, &fault);
> -	else
> -		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
> -
> -	if (r == RET_PF_EMULATE && fault.is_private) {
> -		kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
> -		return -EFAULT;
> -	}
> -
> -	if (fault.write_fault_to_shadow_pgtable && emulation_type)
> -		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
> +	r = __kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, err, prefetch, emulation_type);
>   
>   	/*
>   	 * Similar to above, prefetch faults aren't truly spurious, and the


