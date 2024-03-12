Return-Path: <kvm+bounces-11635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FD3F878E31
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 06:34:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2362E1C21A98
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 05:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 078FF1E48C;
	Tue, 12 Mar 2024 05:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YePVUfnI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17833D510;
	Tue, 12 Mar 2024 05:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710221671; cv=none; b=cfsncFPzTm0u3TGvj/18g/JujNoySDyRXE5PxOaUEeplUoNFIHkf4Ys7mE9lvNEgMrjdA9T7z9f17OxsMul76/YAVVSYIr9ewswg/2dFCJUcn1ji/XwgS3CtW/G8Vj2pioVKS6Ug5AShkX9GnqDcqmt05WthFghP7mhjI04fAF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710221671; c=relaxed/simple;
	bh=C8jt+0Wc7e5wlrKLctTvtdtd61QZ/LAhkcyir9GgLLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UbmlE241KwrivuoTtjCEBlHKn8ebxQEEMoC7RcG0TDjvt3MXAtYZf9tTS3Skw+skxm9zKebeu/dbUlO7zb+TxYDtpLPhTEe7UfDQgl534MWtiNMi3JSkyjUxmJfU1628uqozTw9R5XLFZLpawF674c/buiG/lB/SxJCNpBrClYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YePVUfnI; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710221669; x=1741757669;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=C8jt+0Wc7e5wlrKLctTvtdtd61QZ/LAhkcyir9GgLLA=;
  b=YePVUfnIwcYx9n/sTEmbgBDIa0eHHPkDPXtv7vDULVVdPz2248038gyj
   37XLYt207APNoKeGwBKLjeJ/W5hqmiy9jBMYux2FB7zDUz9vmtm96p3Lv
   TfsiI8+uYE6MR3jGwD3zcPDV82bUNpti9C3AnLNbnLUPgLsuOWMIybTzj
   viPlxbUwI7zg0TEpsxA2BUg6uZUA0HJihzSv3Ujx0DpVsbl8ULOff6S5q
   GZyAGUz7v1iuwes5aQL7Fa3agxXXKU8AGOW7OxAOFXLL4lcDnz81Cq4G+
   SwQ0KBi8IldfAsvm91cxIVECiVe69/9z24dpc+GPp7zDv0ek0jkgNB7gz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="7860617"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="7860617"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 22:34:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="11487708"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.125.242.247]) ([10.125.242.247])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 22:34:18 -0700
Message-ID: <47d11b68-2f48-4868-b341-7c6883272619@linux.intel.com>
Date: Tue, 12 Mar 2024 13:34:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/16] KVM: x86/mmu: Use synthetic page fault error code
 to indicate private faults
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
 David Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-6-seanjc@google.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240228024147.41573-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/28/2024 10:41 AM, Sean Christopherson wrote:
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
> ---
>   arch/x86/include/asm/kvm_host.h | 11 +++++++++++
>   arch/x86/kvm/mmu/mmu.c          | 26 +++++++++++++++++++-------
>   arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>   3 files changed, 31 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1e69743ef0fb..4077c46c61ab 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -267,7 +267,18 @@ enum x86_intercept_stage;
>   #define PFERR_GUEST_ENC_MASK	BIT_ULL(34)
>   #define PFERR_GUEST_SIZEM_MASK	BIT_ULL(35)
>   #define PFERR_GUEST_VMPL_MASK	BIT_ULL(36)
> +
> +/*
> + * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP checks
> + * when emulating instructions that triggers implicit access.
> + */
>   #define PFERR_IMPLICIT_ACCESS	BIT_ULL(48)
> +/*
> + * PRIVATE_ACCESS is a KVM-defined flag us to indicate that a fault occurred

Here "us" is a typo? should be used?

> + * when the guest was accessing private memory.
> + */
> +#define PFERR_PRIVATE_ACCESS	BIT_ULL(49)
> +#define PFERR_SYNTHETIC_MASK	(PFERR_IMPLICIT_ACCESS | PFERR_PRIVATE_ACCESS)
>   
>   #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
>   				 PFERR_WRITE_MASK |		\
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 408969ac1291..7807bdcd87e8 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5839,19 +5839,31 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>   	bool direct = vcpu->arch.mmu->root_role.direct;
>   
>   	/*
> -	 * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP
> -	 * checks when emulating instructions that triggers implicit access.
>   	 * WARN if hardware generates a fault with an error code that collides
> -	 * with the KVM-defined value.  Clear the flag and continue on, i.e.
> -	 * don't terminate the VM, as KVM can't possibly be relying on a flag
> -	 * that KVM doesn't know about.
> +	 * with KVM-defined sythentic flags.  Clear the flags and continue on,

:s/sythentic/synthetic/

Others,
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> +	 * i.e. don't terminate the VM, as KVM can't possibly be relying on a
> +	 * flag that KVM doesn't know about.
>   	 */
> -	if (WARN_ON_ONCE(error_code & PFERR_IMPLICIT_ACCESS))
> -		error_code &= ~PFERR_IMPLICIT_ACCESS;
> +	if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
> +		error_code &= ~PFERR_SYNTHETIC_MASK;
>   
>   	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
>   		return RET_PF_RETRY;
>   
> +	/*
> +	 * Except for reserved faults (emulated MMIO is shared-only), set the
> +	 * private flag for software-protected VMs based on the gfn's current
> +	 * attributes, which are the source of truth for such VMs.  Note, this
> +	 * wrong for nested MMUs as the GPA is an L2 GPA, but KVM doesn't
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
> index 1fab1f2359b5..d7c10d338f14 100644
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


