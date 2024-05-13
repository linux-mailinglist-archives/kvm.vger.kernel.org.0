Return-Path: <kvm+bounces-17289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C2788C3AFC
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 07:29:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F2D24B20979
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 05:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5496146006;
	Mon, 13 May 2024 05:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IVko/Bfl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE1D14600F;
	Mon, 13 May 2024 05:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715578149; cv=none; b=Rlu8BB4U5kOkGzvl395Qxn+GGTEINAIwWJ1SaRCPieanbUqiZili10LI1zmIQOHwIToYhKA69+tQsqiyoVZa1PCN1EXTuMq1m8eEYLTgRo6KAC6kzTuQTgeE5LO4JbFCGHs49p4f0cEwidYljwRgqTZJyajsf7SAAcmpkVDHh8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715578149; c=relaxed/simple;
	bh=BES6J55ekLIREdDyUEdgA+eV9k/ixyfMejWB90lAq5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KSSDq4q7oU7XpDTWblG1PgPApUO6Nqz4hASga6QeXqskoiFvmsqkB9VD2hA7p5qWlroKx1Lon2EuuPxaBC32BJO+LnLGeik1kliXBmv/YyFet+kO3gTriENbFT0DpHvG5LiV+5AoYcaKQu3FBIqNBs//qcceV6GZtfBzDO8/6kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IVko/Bfl; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715578148; x=1747114148;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BES6J55ekLIREdDyUEdgA+eV9k/ixyfMejWB90lAq5g=;
  b=IVko/Bfl9bdiln5DlMzxjjy08l0azIzpqIEgDuiJtAExXaGIKctrBI6b
   Radi4lwvJ2TOqkmFkqvogRtNAae8fH9+EXN/P1Dg7wJqbNuwsUTdGqmRk
   mWecMcz5OJGDzRBLdFvdqRJtcZMPY4UauSfSrI4lDOLF1gG3eT2HWOatz
   OSXVkShlQTxTdnq57kacc5O/6DIC7eCFhZ8TKXpvuGaEU710s+qnHhzlz
   I9i1MRQng/C1z1hFivNd12JnU8e6zNAizeLCnSx6FLLE7GhDzJ6S0r1pB
   E9KfhSyTU6Xpx4XoDE39u3g9rFFzS6bitXKs+Kj1VNsJ8hqT//lDFBqZM
   g==;
X-CSE-ConnectionGUID: LsiQvLf2T4225qsHUVkHxg==
X-CSE-MsgGUID: IffDHT2yS1GHcGD2uD655g==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="22164969"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="22164969"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 22:29:08 -0700
X-CSE-ConnectionGUID: phSYPFECSOGkweWUiDr51Q==
X-CSE-MsgGUID: sLwbJsSRRkGcJJW3S7JJIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="30064946"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.198]) ([10.125.243.198])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 22:29:06 -0700
Message-ID: <70b29862-8305-4642-8b02-80342ccea4f8@intel.com>
Date: Mon, 13 May 2024 13:29:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/17] KVM: x86: Remove separate "bit" defines for page
 fault error code masks
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
 <20240507155817.3951344-3-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240507155817.3951344-3-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/2024 11:58 PM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Open code the bit number directly in the PFERR_* masks and drop the
> intermediate PFERR_*_BIT defines, as having to bounce through two macros
> just to see which flag corresponds to which bit is quite annoying,

can't agree more on it.

> as is
> having to define two macros just to add recognition of a new flag.
> 
> Use ternary operator to derive the bit in permission_fault(), the one
> function that actually needs the bit number as part of clever shifting
> to avoid conditional branches.  Generally the compiler is able to turn
> it into a conditional move, and if not it's not really a big deal.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-ID: <20240228024147.41573-3-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.co
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/include/asm/kvm_host.h | 32 ++++++++++----------------------
>   arch/x86/kvm/mmu.h              |  5 ++---
>   2 files changed, 12 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9f92bdb78504..a047480da5af 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -254,28 +254,16 @@ enum x86_intercept_stage;
>   	KVM_GUESTDBG_INJECT_DB | \
>   	KVM_GUESTDBG_BLOCKIRQ)
>   
> -
> -#define PFERR_PRESENT_BIT 0
> -#define PFERR_WRITE_BIT 1
> -#define PFERR_USER_BIT 2
> -#define PFERR_RSVD_BIT 3
> -#define PFERR_FETCH_BIT 4
> -#define PFERR_PK_BIT 5
> -#define PFERR_SGX_BIT 15
> -#define PFERR_GUEST_FINAL_BIT 32
> -#define PFERR_GUEST_PAGE_BIT 33
> -#define PFERR_IMPLICIT_ACCESS_BIT 48
> -
> -#define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
> -#define PFERR_WRITE_MASK	BIT(PFERR_WRITE_BIT)
> -#define PFERR_USER_MASK		BIT(PFERR_USER_BIT)
> -#define PFERR_RSVD_MASK		BIT(PFERR_RSVD_BIT)
> -#define PFERR_FETCH_MASK	BIT(PFERR_FETCH_BIT)
> -#define PFERR_PK_MASK		BIT(PFERR_PK_BIT)
> -#define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
> -#define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
> -#define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
> -#define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
> +#define PFERR_PRESENT_MASK	BIT(0)
> +#define PFERR_WRITE_MASK	BIT(1)
> +#define PFERR_USER_MASK		BIT(2)
> +#define PFERR_RSVD_MASK		BIT(3)
> +#define PFERR_FETCH_MASK	BIT(4)
> +#define PFERR_PK_MASK		BIT(5)
> +#define PFERR_SGX_MASK		BIT(15)
> +#define PFERR_GUEST_FINAL_MASK	BIT_ULL(32)
> +#define PFERR_GUEST_PAGE_MASK	BIT_ULL(33)
> +#define PFERR_IMPLICIT_ACCESS	BIT_ULL(48)
>   
>   #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
>   				 PFERR_WRITE_MASK |		\
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 60f21bb4c27b..2343c9f00e31 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -213,7 +213,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>   	 */
>   	u64 implicit_access = access & PFERR_IMPLICIT_ACCESS;
>   	bool not_smap = ((rflags & X86_EFLAGS_AC) | implicit_access) == X86_EFLAGS_AC;
> -	int index = (pfec + (not_smap << PFERR_RSVD_BIT)) >> 1;
> +	int index = (pfec | (not_smap ? PFERR_RSVD_MASK : 0)) >> 1;
>   	u32 errcode = PFERR_PRESENT_MASK;
>   	bool fault;
>   
> @@ -234,8 +234,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>   		pkru_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
>   
>   		/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
> -		offset = (pfec & ~1) +
> -			((pte_access & PT_USER_MASK) << (PFERR_RSVD_BIT - PT_USER_SHIFT));
> +		offset = (pfec & ~1) | ((pte_access & PT_USER_MASK) ? PFERR_RSVD_MASK : 0);
>   
>   		pkru_bits &= mmu->pkru_mask >> offset;
>   		errcode |= -pkru_bits & PFERR_PK_MASK;


