Return-Path: <kvm+bounces-15527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C5308AD118
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 17:40:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E894B23DB6
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 15:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 901DA14F130;
	Mon, 22 Apr 2024 15:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HsLzHZaK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8691D2E40D;
	Mon, 22 Apr 2024 15:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713800418; cv=none; b=aO5ettbZ+tWnbBGRLDPMh64L4n96LMWkCaFs4hZhab7M+WOd8RmoFpFcqTt82kA4rDmCGmdp/cb3kvcETXCS07bMwhSz3zwSIOO+gjk65y6llxHXF+ug58zzT6ZOSijNlhQ8ZtPugtBjen+kksRGXdjdFLa9ejAplf1xtcABNWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713800418; c=relaxed/simple;
	bh=MrbHq4CdRI8nAOdmRihgaz+T1q6xBTOrnbs8igIlUs0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gROjazKklheGn0n3wzSTCiZyeyLUP9c5SDndAdzWL5kiO85pJ5soCdcQxgQEO4WVBYZ6rR/r5cNw6k2rIJgPLv9GdVpsYSDOB3K4fEY4qy37sL9AfeSRiZuGEiCmpAYF/kxV9Hg2UfRO2LDcBz8aSdxc1CtTH4yFyQzlTI8xwo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HsLzHZaK; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713800417; x=1745336417;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MrbHq4CdRI8nAOdmRihgaz+T1q6xBTOrnbs8igIlUs0=;
  b=HsLzHZaK0nedFo/fthiUpaGNAj88CdXsFrGiSfK3t69q3ZPt1vqU3yOl
   nTImn+xWiknKTYXVlpCkTmfflwxYTwlltk1SvJrU/YeNSIs3PIER7xO3A
   v++i/2vnZp5e8R2Yf/GY/YYXJNexpEh00GMtzpRv180JvhT+KjpxQq147
   LLMXCphjAscNTKb5w01kZj00muVDrZyKzyg3tVxQyPSmDss3QXQa+Qm9R
   A9fasrJJmM1bHG7+Q32Vh0FC0862Fx0rplf2S8V5dw5BRJS90dzCLaWFI
   5aiek1PPt7+K2DIzeS+tPDxu5EeoyBt0i37HFTpIKe1oZuTE2buP63SCw
   Q==;
X-CSE-ConnectionGUID: ChNUcS1XSyKicdghSeKq8g==
X-CSE-MsgGUID: T4mhb8g6S+eg21A5pt/6/A==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="34743754"
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="34743754"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 08:37:28 -0700
X-CSE-ConnectionGUID: TdxRRIFDS8OsESi5q3Oa7g==
X-CSE-MsgGUID: Equdo2TJSw6Ktr7//9aGjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="28717697"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 08:37:25 -0700
Message-ID: <d5a6e125-bff4-4d82-ae65-b99d9cb10e90@intel.com>
Date: Mon, 22 Apr 2024 23:37:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] KVM: x86: Implement kvm_arch_vcpu_pre_fault_memory()
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com, binbin.wu@linux.intel.com, seanjc@google.com,
 rick.p.edgecombe@intel.com
References: <20240419085927.3648704-1-pbonzini@redhat.com>
 <20240419085927.3648704-6-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240419085927.3648704-6-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/19/2024 4:59 PM, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Wire KVM_PRE_FAULT_MEMORY ioctl to __kvm_mmu_do_page_fault() to populate guest
> memory.  It can be called right after KVM_CREATE_VCPU creates a vCPU,
> since at that point kvm_mmu_create() and kvm_init_mmu() are called and
> the vCPU is ready to invoke the KVM page fault handler.
> 
> The helper function kvm_mmu_map_tdp_page take care of the logic to
> process RET_PF_* return values and convert them to success or errno.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Message-ID: <9b866a0ae7147f96571c439e75429a03dcb659b6.1712785629.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/Kconfig   |  1 +
>   arch/x86/kvm/mmu/mmu.c | 72 ++++++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/x86.c     |  3 ++
>   3 files changed, 76 insertions(+)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 7632fe6e4db9..54c155432793 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -44,6 +44,7 @@ config KVM
>   	select KVM_VFIO
>   	select HAVE_KVM_PM_NOTIFIER if PM
>   	select KVM_GENERIC_HARDWARE_ENABLING
> +	select KVM_GENERIC_PRE_FAULT_MEMORY
>   	help
>   	  Support hosting fully virtualized guest machines using hardware
>   	  virtualization extensions.  You will need a fairly recent
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 10e90788b263..a045b23964c0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4647,6 +4647,78 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   	return direct_page_fault(vcpu, fault);
>   }
>   
> +static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> +		     u8 *level)
> +{
> +	int r;
> +
> +	/* Restrict to TDP page fault. */
> +	if (vcpu->arch.mmu->page_fault != kvm_tdp_page_fault)
> +		return -EOPNOTSUPP;
> +
> +retry:
> +	r = __kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
> +	if (r < 0)
> +		return r;
> +
> +	switch (r) {
> +	case RET_PF_RETRY:
> +		if (signal_pending(current))
> +			return -EINTR;
> +		cond_resched();
> +		goto retry;
> +
> +	case RET_PF_FIXED:
> +	case RET_PF_SPURIOUS:
> +		break;
> +
> +	case RET_PF_EMULATE:
> +		return -ENOENT;
> +
> +	case RET_PF_CONTINUE:
> +	case RET_PF_INVALID:
> +	default:
> +		WARN_ON_ONCE(r);
> +		return -EIO;

Need to update patch 1 for -EIO

> +	}
> +
> +	return 0;
> +}
> +
> +long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> +				    struct kvm_pre_fault_memory *range)
> +{
> +	u64 error_code = PFERR_GUEST_FINAL_MASK;
> +	u8 level = PG_LEVEL_4K;
> +	u64 end;
> +	int r;
> +
> +	/*
> +	 * reload is efficient when called repeatedly, so we can do it on
> +	 * every iteration.
> +	 */
> +	kvm_mmu_reload(vcpu);
> +
> +	if (kvm_arch_has_private_mem(vcpu->kvm) &&
> +	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))
> +		error_code |= PFERR_PRIVATE_ACCESS;
> +
> +	/*
> +	 * Shadow paging uses GVA for kvm page fault, so restrict to
> +	 * two-dimensional paging.
> +	 */
> +	r = kvm_tdp_map_page(vcpu, range->gpa, error_code, &level);
> +	if (r < 0)
> +		return r;
> +
> +	/*
> +	 * If the mapping that covers range->gpa can use a huge page, it
> +	 * may start below it or end after range->gpa + range->size.
> +	 */
> +	end = (range->gpa & KVM_HPAGE_MASK(level)) + KVM_HPAGE_SIZE(level);
> +	return min(range->size, end - range->gpa);
> +}
> +
>   static void nonpaging_init_context(struct kvm_mmu *context)
>   {
>   	context->page_fault = nonpaging_page_fault;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 83b8260443a3..619ad713254e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4715,6 +4715,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_MEMORY_FAULT_INFO:
>   		r = 1;
>   		break;
> +	case KVM_CAP_PRE_FAULT_MEMORY:
> +		r = tdp_enabled;
> +		break;
>   	case KVM_CAP_EXIT_HYPERCALL:
>   		r = KVM_EXIT_HYPERCALL_VALID_MASK;
>   		break;


