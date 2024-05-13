Return-Path: <kvm+bounces-17290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A55A8C3B17
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 07:50:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6BA21F213A6
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 05:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 621F114659C;
	Mon, 13 May 2024 05:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QkmrbKzH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456441CD3D;
	Mon, 13 May 2024 05:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715579429; cv=none; b=Oc0AAjICQJMI4+21Bu+OrsyES16XF73/3o0G/ySH+H2h97DgbYHeG8Y3GNxI0TzU68XO6eYBjg15CUxzMk83mL5nHor00V6W7e4XduVde+u31jgH2fEo/lIlj+jfceOBDY8jRcEFkUkeEydn2lc8HCwEfdQmlrkm3weqZWGVPJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715579429; c=relaxed/simple;
	bh=cTisG/wWFStNxcixatGO/BSRIF8skJ05OMYCUvIo4Rg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OfydWkVASlna5zU7MjA29z5Gge8ZmWk0b3Jy5rvK9zm2+5rOneGCiKES6Icf+V+gTK4lH2IhlUSoTzmkkb4kRp66ptrDOQ2zY5gH28HFmP9Hpw2fjTnzDtXC9LTWTLu4iufkUAVd9/7aMPfIgYaPpA9fzdNDAdIORibjgyWuBso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QkmrbKzH; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715579427; x=1747115427;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cTisG/wWFStNxcixatGO/BSRIF8skJ05OMYCUvIo4Rg=;
  b=QkmrbKzH+1b2UfAB2rPe/4OGhLbPV28T1Seg9dOMRyQKCHdc97Y2gNVE
   ee9QMKh7bOdysQhzdEh++iHCTmH0YNnqLDEo4L5YOl7SCLgZsNx+KniF4
   IlHh3GzinMWTiB38fKjwujyb4rV4cDMMT5tRSnSE5uPgD7rjBfrb6hX+a
   wOuQmAornZokavUDYUWuz3Uku/MSCsKMJuHPQuZML0c7XZgrAZhOcvANn
   mFMteOfDXwXMYq0JkiWVJgCW+6MTD1BPCOt8kI5SoUBAw1w2hJTSjpy8u
   eZCeHaK3iLT2pcnoiM5wLifE8zo4zVA5DX5OVINXfYw8RWgf0DcVXclIo
   Q==;
X-CSE-ConnectionGUID: j4RrnMAkQSqLFCupvOaeLA==
X-CSE-MsgGUID: ove0mJXQTQ6cBhLgWoSShQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="22069778"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="22069778"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 22:50:26 -0700
X-CSE-ConnectionGUID: 4+gxAaO3Q3OT31BpFOXOkA==
X-CSE-MsgGUID: nHMH4IrFTt6xiO3EEHz+vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="30216756"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.198]) ([10.125.243.198])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 22:50:24 -0700
Message-ID: <3b6bc6ac-276f-4a83-8972-68b98db672c7@intel.com>
Date: Mon, 13 May 2024 13:50:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/17] KVM: x86: Move synthetic PFERR_* sanity checks to
 SVM's #NPF handler
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
 <20240507155817.3951344-5-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240507155817.3951344-5-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/2024 11:58 PM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Move the sanity check that hardware never sets bits that collide with KVM-
> define synthetic bits from kvm_mmu_page_fault() to npf_interception(),
> i.e. make the sanity check #NPF specific.  The legacy #PF path already
> WARNs if _any_ of bits 63:32 are set, and the error code that comes from
> VMX's EPT Violatation and Misconfig is 100% synthesized (KVM morphs VMX's
> EXIT_QUALIFICATION into error code flags).
> 
> Add a compile-time assert in the legacy #PF handler to make sure that KVM-
> define flags are covered by its existing sanity check on the upper bits.
> 
> Opportunistically add a description of PFERR_IMPLICIT_ACCESS, since we
> are removing the comment that defined it.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Message-ID: <20240228024147.41573-8-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  6 ++++++
>   arch/x86/kvm/mmu/mmu.c          | 14 +++-----------
>   arch/x86/kvm/svm/svm.c          |  9 +++++++++
>   3 files changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 58bbcf76ad1e..12e727301262 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -267,7 +267,13 @@ enum x86_intercept_stage;
>   #define PFERR_GUEST_ENC_MASK	BIT_ULL(34)
>   #define PFERR_GUEST_SIZEM_MASK	BIT_ULL(35)
>   #define PFERR_GUEST_VMPL_MASK	BIT_ULL(36)
> +
> +/*
> + * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP checks
> + * when emulating instructions that triggers implicit access.
> + */
>   #define PFERR_IMPLICIT_ACCESS	BIT_ULL(48)
> +#define PFERR_SYNTHETIC_MASK	(PFERR_IMPLICIT_ACCESS)
>   
>   #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
>   				 PFERR_WRITE_MASK |		\
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c72a2033ca96..5562d693880a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4502,6 +4502,9 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>   		return -EFAULT;
>   #endif
>   
> +	/* Ensure the above sanity check also covers KVM-defined flags. */

1. There is no sanity check above related to KVM-defined flags yet. It 
has to be after Patch 6.

2. I somehow cannot parse the comment properly, though I know it's to 
ensure KVM-defined PFERR_SYNTHETIC_MASK not contain any bit below 32-bits.

> +	BUILD_BUG_ON(lower_32_bits(PFERR_SYNTHETIC_MASK));
> +
>   	vcpu->arch.l1tf_flush_l1d = true;
>   	if (!flags) {
>   		trace_kvm_page_fault(vcpu, fault_address, error_code);
> @@ -5786,17 +5789,6 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>   	int r, emulation_type = EMULTYPE_PF;
>   	bool direct = vcpu->arch.mmu->root_role.direct;
>   
> -	/*
> -	 * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP
> -	 * checks when emulating instructions that triggers implicit access.
> -	 * WARN if hardware generates a fault with an error code that collides
> -	 * with the KVM-defined value.  Clear the flag and continue on, i.e.
> -	 * don't terminate the VM, as KVM can't possibly be relying on a flag
> -	 * that KVM doesn't know about.
> -	 */
> -	if (WARN_ON_ONCE(error_code & PFERR_IMPLICIT_ACCESS))
> -		error_code &= ~PFERR_IMPLICIT_ACCESS;
> -
>   	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
>   		return RET_PF_RETRY;
>   
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 0f3b59da0d4a..535018f152a3 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2047,6 +2047,15 @@ static int npf_interception(struct kvm_vcpu *vcpu)
>   	u64 fault_address = svm->vmcb->control.exit_info_2;
>   	u64 error_code = svm->vmcb->control.exit_info_1;
>   
> +	/*
> +	 * WARN if hardware generates a fault with an error code that collides
> +	 * with KVM-defined sythentic flags.  Clear the flags and continue on,
> +	 * i.e. don't terminate the VM, as KVM can't possibly be relying on a
> +	 * flag that KVM doesn't know about.
> +	 */
> +	if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
> +		error_code &= ~PFERR_SYNTHETIC_MASK;
> +
>   	trace_kvm_page_fault(vcpu, fault_address, error_code);
>   	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
>   			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?


