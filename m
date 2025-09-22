Return-Path: <kvm+bounces-58371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 948D3B8F937
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 10:38:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D9253A6012
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 08:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29158277CAE;
	Mon, 22 Sep 2025 08:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PE98RXSg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75440126F0A;
	Mon, 22 Sep 2025 08:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758530279; cv=none; b=VrOgC/1+b6rTvb+oaqWSunWGEUl04sbK4bfhoLuNZ9Y5QB8tIHJ8Kf6GGhAjmD+oGPOarjNgmD1zjNDuW1IfFBzS4I31jkSGFlEaB8tZg93ItyJ0CztFKX7VASnUcBQtS8mbDKotBOCLU2QHZiEeI+3rc6wFc/yQGPBAhUvRCOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758530279; c=relaxed/simple;
	bh=oi12o4q5hIFskYvycyV2Jw8XJZYACMASrC6OmCmT+2c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hCytn0W+aakfBU2g34DVjHDfoDcP3c78fsMfxMtpzpS5O2+cjVhn9f4Mbj4A610TlgMTg0kXy6sDwIVdvVJx4RYfvAuQQyKYmWRWF7/RZuvNUjKAMD1fcXT/2txyjCZg0jSlT4Hqpsr5rQzZsHDRjzI/A9n2KZ8o08B6eUD2M/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PE98RXSg; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758530277; x=1790066277;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oi12o4q5hIFskYvycyV2Jw8XJZYACMASrC6OmCmT+2c=;
  b=PE98RXSgQ25dcV/yjD/z8cmMZjW4pTok8HFEmaCvRE+9qo39tSqEJOhy
   OkcPW0pzt8bplvCMNXlGIIxkw8qsuk9TaKZJriu15o43DeFE5fQvHrXXH
   EZTOycKlLiFrSyuxQzN67T2WFIa6DTpDb7cP6H0C0/S4sd77w3yuG+LlA
   eIrfy0hfDsQt6t8Z4Uo/RD5QyMU/VLiB9W4Hcg59VoL7AmCdiuRNYwVe8
   7cJwfmp/Yz0q0slsVW+JEe53AojQl34Z6V0nwwcjrht1wUdgH887Pa5q6
   GzkRtBIla4cidRyomMEXI1PZvf+zRru/QvNOmI4XYsxwLiSvXAcUvefOq
   g==;
X-CSE-ConnectionGUID: 9R7vZ02vQAyW/YniCwg4Hg==
X-CSE-MsgGUID: gXNrrvv7REWvsBnqbMgCaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="60845013"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="60845013"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 01:37:56 -0700
X-CSE-ConnectionGUID: BXkVqYdTT0ym4zdN7Jy0Ag==
X-CSE-MsgGUID: yFHc42fGQKC/JkvuRp90TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="176490946"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 01:37:53 -0700
Message-ID: <499c8f65-1a28-4efa-b9e8-14e516edf4ad@linux.intel.com>
Date: Mon, 22 Sep 2025 16:37:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 30/51] KVM: nVMX: Virtualize NO_HW_ERROR_CODE_CC for
 L1 event injection to L2
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-31-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-31-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
>
> Per SDM description(Vol.3D, Appendix A.1):
> "If bit 56 is read as 1, software can use VM entry to deliver a hardware
> exception with or without an error code, regardless of vector"
>
> Modify has_error_code check before inject events to nested guest. Only
> enforce the check when guest is in real mode, the exception is not hard
> exception and the platform doesn't enumerate bit56 in VMX_BASIC, in all
> other case ignore the check to make the logic consistent with SDM.
>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/nested.c | 27 ++++++++++++++++++---------
>   arch/x86/kvm/vmx/nested.h |  5 +++++
>   2 files changed, 23 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 846c07380eac..b644f4599f70 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1272,9 +1272,10 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
>   {
>   	const u64 feature_bits = VMX_BASIC_DUAL_MONITOR_TREATMENT |
>   				 VMX_BASIC_INOUT |
> -				 VMX_BASIC_TRUE_CTLS;
> +				 VMX_BASIC_TRUE_CTLS |
> +				 VMX_BASIC_NO_HW_ERROR_CODE_CC;
>   
> -	const u64 reserved_bits = GENMASK_ULL(63, 56) |
> +	const u64 reserved_bits = GENMASK_ULL(63, 57) |
>   				  GENMASK_ULL(47, 45) |
>   				  BIT_ULL(31);
>   
> @@ -2949,7 +2950,6 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
>   		u8 vector = intr_info & INTR_INFO_VECTOR_MASK;
>   		u32 intr_type = intr_info & INTR_INFO_INTR_TYPE_MASK;
>   		bool has_error_code = intr_info & INTR_INFO_DELIVER_CODE_MASK;
> -		bool should_have_error_code;
>   		bool urg = nested_cpu_has2(vmcs12,
>   					   SECONDARY_EXEC_UNRESTRICTED_GUEST);
>   		bool prot_mode = !urg || vmcs12->guest_cr0 & X86_CR0_PE;
> @@ -2966,12 +2966,19 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
>   		    CC(intr_type == INTR_TYPE_OTHER_EVENT && vector != 0))
>   			return -EINVAL;
>   
> -		/* VM-entry interruption-info field: deliver error code */
> -		should_have_error_code =
> -			intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
> -			x86_exception_has_error_code(vector);
> -		if (CC(has_error_code != should_have_error_code))
> -			return -EINVAL;
> +		/*
> +		 * Cannot deliver error code in real mode or if the interrupt
> +		 * type is not hardware exception. For other cases, do the
> +		 * consistency check only if the vCPU doesn't enumerate
> +		 * VMX_BASIC_NO_HW_ERROR_CODE_CC.
> +		 */
> +		if (!prot_mode || intr_type != INTR_TYPE_HARD_EXCEPTION) {
> +			if (CC(has_error_code))
> +				return -EINVAL;
> +		} else if (!nested_cpu_has_no_hw_errcode_cc(vcpu)) {
> +			if (CC(has_error_code != x86_exception_has_error_code(vector)))
> +				return -EINVAL;
> +		}
>   
>   		/* VM-entry exception error code */
>   		if (CC(has_error_code &&
> @@ -7217,6 +7224,8 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
>   	msrs->basic |= VMX_BASIC_TRUE_CTLS;
>   	if (cpu_has_vmx_basic_inout())
>   		msrs->basic |= VMX_BASIC_INOUT;
> +	if (cpu_has_vmx_basic_no_hw_errcode_cc())
> +		msrs->basic |= VMX_BASIC_NO_HW_ERROR_CODE_CC;
>   }
>   
>   static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index 6eedcfc91070..983484d42ebf 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -309,6 +309,11 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
>   	       __kvm_is_valid_cr4(vcpu, val);
>   }
>   
> +static inline bool nested_cpu_has_no_hw_errcode_cc(struct kvm_vcpu *vcpu)
> +{
> +	return to_vmx(vcpu)->nested.msrs.basic & VMX_BASIC_NO_HW_ERROR_CODE_CC;
> +}
> +
>   /* No difference in the restrictions on guest and host CR4 in VMX operation. */
>   #define nested_guest_cr4_valid	nested_cr4_valid
>   #define nested_host_cr4_valid	nested_cr4_valid


