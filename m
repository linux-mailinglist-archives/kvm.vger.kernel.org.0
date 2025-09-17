Return-Path: <kvm+bounces-57822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29F11B7E082
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:40:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41340581115
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 07:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00973302CD6;
	Wed, 17 Sep 2025 07:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HA+cC9hg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B566ADD;
	Wed, 17 Sep 2025 07:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758095610; cv=none; b=DPqVrbayBkP8FMo88dv1jBeq0TFKaUTpPH2YxLFZ0dCk3OB3g8QU/8TDq1jjPuA5Dxn03s6NDnHPJQwUn7qfvMh7S6azud5517uYYgxDBbq8aUM3y9S62/N4k91Qa7bMXyCHUFg9y2o8xpgh/iUeqlQi14HBi4oATl3c1Dd2Lyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758095610; c=relaxed/simple;
	bh=mpgPBax6W/qR/qodaQ2TfTr0vcQl8GDbKsdMebf72N0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YrkXYQqlWxGquYft8OOENuC1UcdWXrIa6kLjulv1u69vxlm/mpcaTOFAWlsHHCOIrSMAOfvmrVDAS3QD4qSjupC6Ydymmf/Ed3GGka7/4LlKcA8+Z+RKkaa+x8XvdYrmwfALJKab1hhJdgPoWW7A9qpz806mdDUvb3RblTd84hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HA+cC9hg; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758095608; x=1789631608;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mpgPBax6W/qR/qodaQ2TfTr0vcQl8GDbKsdMebf72N0=;
  b=HA+cC9hggDG7f8ZU1C34BtkBIk+ekiDi66B8yIRUgxGozcbOjo2GAq1G
   PMl67+8EfZV0wDRgUIftRpLl6QUJfWJAhhToAjRrWTR71qJwRYnFxVnlW
   CgQ1zzcT+8r2Ae3Ru/nc2SuVJ7E9SO27acMcgum1HqfBv6rbVURHIOE78
   VmpM/8+sAQg6WvcOyTCCFPv0vDMgph82dwv8YEzWAX20EaqrM4PhGijq7
   XJ/yhGCq/zKdWXWiS9mothhoodwjk+CB5rsRYEJHTTdcmdnlVZG241RUS
   VVxEIoJFmSZzxSxHyRk3bZcZLtKM8oYzaCYBw2z0mIXqm7WfwsJHccUNk
   A==;
X-CSE-ConnectionGUID: 2nRXIXAuQaqwkRsdoevECA==
X-CSE-MsgGUID: Fg/UofRdSTuLnyKk8mmakg==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="60537098"
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="60537098"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 00:53:26 -0700
X-CSE-ConnectionGUID: Q6XBhUiKRYCNXeU03DJ1ig==
X-CSE-MsgGUID: iy1PiVOeQBOlTnpIjGuF5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="174279794"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 00:53:24 -0700
Message-ID: <9267fb81-4e96-40df-ac66-db80987be269@linux.intel.com>
Date: Wed, 17 Sep 2025 15:53:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 15/41] KVM: x86: Save and reload SSP to/from SMRAM
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-16-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250912232319.429659-16-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
>
> Save CET SSP to SMRAM on SMI and reload it on RSM. KVM emulates HW arch
> behavior when guest enters/leaves SMM mode,i.e., save registers to SMRAM
> at the entry of SMM and reload them at the exit to SMM. Per SDM, SSP is
> one of such registers on 64-bit Arch, and add the support for SSP.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/smm.c | 8 ++++++++
>   arch/x86/kvm/smm.h | 2 +-
>   2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
> index 5dd8a1646800..b0b14ba37f9a 100644
> --- a/arch/x86/kvm/smm.c
> +++ b/arch/x86/kvm/smm.c
> @@ -269,6 +269,10 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
>   	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
>   
>   	smram->int_shadow = kvm_x86_call(get_interrupt_shadow)(vcpu);
> +
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
> +	    kvm_msr_read(vcpu, MSR_KVM_INTERNAL_GUEST_SSP, &smram->ssp))
> +		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>   }
>   #endif
>   
> @@ -558,6 +562,10 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
>   	kvm_x86_call(set_interrupt_shadow)(vcpu, 0);
>   	ctxt->interruptibility = (u8)smstate->int_shadow;
>   
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
> +	    kvm_msr_write(vcpu, MSR_KVM_INTERNAL_GUEST_SSP, smstate->ssp))
> +		return X86EMUL_UNHANDLEABLE;
> +
>   	return X86EMUL_CONTINUE;
>   }
>   #endif
> diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
> index 551703fbe200..db3c88f16138 100644
> --- a/arch/x86/kvm/smm.h
> +++ b/arch/x86/kvm/smm.h
> @@ -116,8 +116,8 @@ struct kvm_smram_state_64 {
>   	u32 smbase;
>   	u32 reserved4[5];
>   
> -	/* ssp and svm_* fields below are not implemented by KVM */
>   	u64 ssp;
> +	/* svm_* fields below are not implemented by KVM */
>   	u64 svm_guest_pat;
>   	u64 svm_host_efer;
>   	u64 svm_host_cr4;


