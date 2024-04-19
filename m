Return-Path: <kvm+bounces-15208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 89D878AA945
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 09:35:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FEDB282407
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 07:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D06D647781;
	Fri, 19 Apr 2024 07:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MpqxRIGz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FFA3BBFE;
	Fri, 19 Apr 2024 07:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713512117; cv=none; b=ZLjsiSABLh/LOFtge50ISJNdhJMFf4GSZPQQeDXVBVEGK1b4nLCnO/dfabUy/XWZTgxI07Kdsd6BBnZKB2cQ/GwZO57T+UV8Wk6iUgd3ETf3ENM4BavGAdgu+kMBpoB8JvlYck8pgowhn0pKTo1uapNtMVj26Y58nqXElHLNZ7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713512117; c=relaxed/simple;
	bh=Z/1I5VPuFHd+wm5X7ByR4EwnyMSQhuYPwkbtHK+yhTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K3F2c70RKK+9WAH8/SIep2AQn+nfl4VnWdCwWPJjOgzizCOLXIzUnXqarZlmB5mWIHVssGoNmELr3oWi0iEJWQBherP9DCA9Va/47hKbdVCqOXM6PgCe9XxHg0RPpTeN/r1fgPL4f6JX4f03jGfbtXCRXepei0KyIPawr3djmE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MpqxRIGz; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713512115; x=1745048115;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Z/1I5VPuFHd+wm5X7ByR4EwnyMSQhuYPwkbtHK+yhTs=;
  b=MpqxRIGzN9iZdwKGOfNFLxynkCMY3fNLYccBRKYzO21azpPhAW+kJDyX
   yku/7MQeIN3ygI3OfI4VYCPli6wyGvxf8Imf3In2ev6Xw2ePLvgw4k5S/
   DIE8KpwIqUkQyteB1152ewC1hFlzp8/rYM/cG4j5SYwxmxzY55GqizM9s
   bWqkY5XyCoSrKh3Xr1kUXVcNI2sbvPsBV7kf7IttmKoUzEyYn/CGTXuAA
   R+2AnRdYdbqbD+6RVVfm0UyRbj675F3XB7npYHny/RcnjnOYQCLzhWfQk
   ywBT8N+sN6drlacHB6UGhXtdmpfXow6JYOxB/cK/OLW0pKmP8m7pSYa2J
   A==;
X-CSE-ConnectionGUID: UGMirkTcRz6+V6jWS81rzw==
X-CSE-MsgGUID: gvf+wShFQm+3bAkiU0MN7w==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="9259933"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="9259933"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 00:35:15 -0700
X-CSE-ConnectionGUID: 4iv1xvdLQTyGoXInCbiP6w==
X-CSE-MsgGUID: UdJGMuTZTgmrvWrMizAm2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="27909345"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 00:35:12 -0700
Message-ID: <9737d0db-0cce-41c5-94fa-c3d9550d7300@intel.com>
Date: Fri, 19 Apr 2024 15:35:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/10] KVM: x86/mmu: check for invalid async page
 faults involving private memory
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com, binbin.wu@linux.intel.com, chao.gao@intel.com
References: <20240416201935.3525739-1-pbonzini@redhat.com>
 <20240416201935.3525739-11-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240416201935.3525739-11-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/17/2024 4:19 AM, Paolo Bonzini wrote:
> Right now the error code is not used when an async page fault is completed.
> This is not a problem in the current code, but it is untidy.  For protected
> VMs, we will also need to check that the page attributes match the current
> state of the page, because asynchronous page faults can only occur on
> shared pages (private pages go through kvm_faultin_pfn_private() instead of
> __gfn_to_pfn_memslot()).
> 
> Start by piping the error code from kvm_arch_setup_async_pf() to
> kvm_arch_async_page_ready() via the architecture-specific async page
> fault data.  

It is missed in this patch ...

> For now, it can be used to assert that there are no
> async page faults on private memory.
> 
> Extracted from a patch by Isaku Yamahata.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/mmu/mmu.c          | 17 ++++++++++-------
>   2 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7c73952b6f4e..57ec96bd4221 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1850,6 +1850,7 @@ struct kvm_arch_async_pf {
>   	gfn_t gfn;
>   	unsigned long cr3;
>   	bool direct_map;
> +	u64 error_code;
>   };
>   
>   extern u32 __read_mostly kvm_nr_uret_msrs;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 33aea47dce8b..402d04aa5423 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4207,24 +4207,27 @@ static u32 alloc_apf_token(struct kvm_vcpu *vcpu)
>   	return (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
>   }
>   
> -static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> -				    gfn_t gfn)
> +static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
> +				    struct kvm_page_fault *fault)
>   {
>   	struct kvm_arch_async_pf arch;
>   
>   	arch.token = alloc_apf_token(vcpu);
> -	arch.gfn = gfn;
> +	arch.gfn = fault->gfn;
>   	arch.direct_map = vcpu->arch.mmu->root_role.direct;
>   	arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);

+ 	arch.error_code = fault->error_code;

>   
> -	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
> -				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
> +	return kvm_setup_async_pf(vcpu, fault->addr,
> +				  kvm_vcpu_gfn_to_hva(vcpu, fault->gfn), &arch);
>   }
>   
>   void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>   {
>   	int r;
>   
> +	if (WARN_ON_ONCE(work->arch.error_code & PFERR_GUEST_ENC_MASK))
> +		return;
> +
>   	if ((vcpu->arch.mmu->root_role.direct != work->arch.direct_map) ||
>   	      work->wakeup_all)
>   		return;
> @@ -4237,7 +4240,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>   	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
>   		return;
>   
> -	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
> +	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, work->arch.error_code, true, NULL);
>   }
>   
>   static inline u8 kvm_max_level_for_order(int order)
> @@ -4342,7 +4345,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>   			trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn);
>   			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
>   			return RET_PF_RETRY;
> -		} else if (kvm_arch_setup_async_pf(vcpu, fault->addr, fault->gfn)) {
> +		} else if (kvm_arch_setup_async_pf(vcpu, fault)) {
>   			return RET_PF_RETRY;
>   		}
>   	}


