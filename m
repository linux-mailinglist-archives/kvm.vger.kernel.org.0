Return-Path: <kvm+bounces-58357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A808CB8F407
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 09:15:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A0AE1894DC8
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 07:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 804492F28F9;
	Mon, 22 Sep 2025 07:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CDO+Sbwl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AA0C13B;
	Mon, 22 Sep 2025 07:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758525326; cv=none; b=PyUg0X9Wz/XMxUB2UvMSzur6QMszuRRoen1h7iCEHkSqda28i5klDHMygiYsSz+YP2VHk7ilaUdDyBxQiRorlfZtrAW8nBQhy6Sx5MFg7R1LkWQXszQz6GME/FX3CYQEOkzd3R4o+o9d7ADkOosJnuq7DNzJhgGZ6Q+q0FrG3uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758525326; c=relaxed/simple;
	bh=9XjEIiZUMnEXr26fGuRXOrsJqG5hsCCqqHkiXhYDgPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AVXSze8u8D0MRj0qUwe+Jr2CBZORYJEFFUmdaR6nq1YAQYQm8NkNfg5DUiRKZizSp14wyss4CKjtlkF1IVJIXZCiRzLZEDSjRl4esdxnTy0+rVVBmrUNat5Vkc4DSlO7RPw5efPhth+bALqfcnmLfYG4fcISe8Y4sJfSexnQgqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CDO+Sbwl; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758525325; x=1790061325;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9XjEIiZUMnEXr26fGuRXOrsJqG5hsCCqqHkiXhYDgPc=;
  b=CDO+SbwlVA3OjsTh2bYPWtTraeA4QJfoi85lvsLo03AEBvZ3zc8D9PqU
   1/yCr8+92yj2h4JmgSMujJm9rlDuD2uhPJnZJcFvgEoIt2fd0zDj5XVwQ
   +K/HFiQAnfVhPBFYkdfYPoVjO9UJircWg5k6wSkBmZyROQgtLNGDktd0R
   kEI2mHpXGr4802WMznjvziH/lBNcfENJ+PWoPRI2Gqn9sgZcQylDdGm7h
   5xw8EgT1iF+JunzjSoaxSp9/PQGhHQ8wGO/LKeCWwqCawFaJfhpwu5tgq
   D772bUjb9BwGCetXt+Aoypi49UHSGdQyxZQubmCzUovL0t94NS++2JZ/e
   Q==;
X-CSE-ConnectionGUID: 1m9+sUwUQc2hsB8sjoRf9w==
X-CSE-MsgGUID: azHy9/fPS4OjRijD0rjcaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="60839280"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="60839280"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 00:15:24 -0700
X-CSE-ConnectionGUID: +RP0sdqpSqiRw+5jz9yhGA==
X-CSE-MsgGUID: IybGDvzITguv4lKfO4Krrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="176844302"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 00:15:21 -0700
Message-ID: <73f2301c-0520-422e-b3f9-8ce19e325b37@linux.intel.com>
Date: Mon, 22 Sep 2025 15:15:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 20/51] KVM: x86: Emulate SSP[63:32]!=0 #GP(0) for FAR
 JMP to 32-bit mode
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-21-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-21-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> Emulate the Shadow Stack restriction that the current SSP must be a 32-bit
> value on a FAR JMP from 64-bit mode to compatibility mode.  From the SDM's
> pseudocode for FAR JMP:
>
>    IF ShadowStackEnabled(CPL)
>      IF (IA32_EFER.LMA and DEST(segment selector).L) = 0
>        (* If target is legacy or compatibility mode then the SSP must be in low 4GB *)
>        IF (SSP & 0xFFFFFFFF00000000 != 0); THEN
>          #GP(0);
>        FI;
>      FI;
>    FI;
>
> Note, only the current CPL needs to be considered, as FAR JMP can't be
> used for inter-privilege level transfers, and KVM rejects emulation of all
> other far branch instructions when Shadow Stacks are enabled.
>
> To give the emulator access to GUEST_SSP, special case handling
> MSR_KVM_INTERNAL_GUEST_SSP in emulator_get_msr() to treat the access as a
> host access (KVM doesn't allow guest accesses to internal "MSRs").  The
> ->get_msr() API is only used for implicit accesses from the emulator, i.e.
> is only used with hardcoded MSR indices, and so any access to
> MSR_KVM_INTERNAL_GUEST_SSP is guaranteed to be from KVM, i.e. not from the
> guest via RDMSR.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/emulate.c | 35 +++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/x86.c     |  9 +++++++++
>   2 files changed, 44 insertions(+)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index dc0249929cbf..5c5fb6a6f7f9 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1605,6 +1605,37 @@ static int write_segment_descriptor(struct x86_emulate_ctxt *ctxt,
>   	return linear_write_system(ctxt, addr, desc, sizeof(*desc));
>   }
>   
> +static bool emulator_is_ssp_invalid(struct x86_emulate_ctxt *ctxt, u8 cpl)
> +{
> +	const u32 MSR_IA32_X_CET = cpl == 3 ? MSR_IA32_U_CET : MSR_IA32_S_CET;
> +	u64 efer = 0, cet = 0, ssp = 0;
> +
> +	if (!(ctxt->ops->get_cr(ctxt, 4) & X86_CR4_CET))
> +		return false;
> +
> +	if (ctxt->ops->get_msr(ctxt, MSR_EFER, &efer))
> +		return true;
> +
> +	/* SSP is guaranteed to be valid if the vCPU was already in 32-bit mode. */
> +	if (!(efer & EFER_LMA))
> +		return false;
> +
> +	if (ctxt->ops->get_msr(ctxt, MSR_IA32_X_CET, &cet))
> +		return true;
> +
> +	if (!(cet & CET_SHSTK_EN))
> +		return false;
> +
> +	if (ctxt->ops->get_msr(ctxt, MSR_KVM_INTERNAL_GUEST_SSP, &ssp))
> +		return true;
> +
> +	/*
> +	 * On transfer from 64-bit mode to compatibility mode, SSP[63:32] must
> +	 * be 0, i.e. SSP must be a 32-bit value outside of 64-bit mode.
> +	 */
> +	return ssp >> 32;
> +}
> +
>   static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
>   				     u16 selector, int seg, u8 cpl,
>   				     enum x86_transfer_type transfer,
> @@ -1745,6 +1776,10 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
>   			if (efer & EFER_LMA)
>   				goto exception;
>   		}
> +		if (!seg_desc.l && emulator_is_ssp_invalid(ctxt, cpl)) {
> +			err_code = 0;
> +			goto exception;
> +		}
>   
>   		/* CS(RPL) <- CPL */
>   		selector = (selector & 0xfffc) | cpl;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0c060e506f9d..40596fc5142e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8741,6 +8741,15 @@ static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
>   static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
>   			    u32 msr_index, u64 *pdata)
>   {
> +	/*
> +	 * Treat emulator accesses to the current shadow stack pointer as host-
> +	 * initiated, as they aren't true MSR accesses (SSP is a "just a reg"),
> +	 * and this API is used only for implicit accesses, i.e. not RDMSR, and
> +	 * so the index is fully KVM-controlled.
> +	 */
> +	if (unlikely(msr_index == MSR_KVM_INTERNAL_GUEST_SSP))
> +		return kvm_msr_read(emul_to_vcpu(ctxt), msr_index, pdata);
> +
>   	return __kvm_emulate_msr_read(emul_to_vcpu(ctxt), msr_index, pdata);
>   }
>   


