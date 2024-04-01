Return-Path: <kvm+bounces-13264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A77B893883
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 09:00:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A98D281728
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 07:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78496B666;
	Mon,  1 Apr 2024 07:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eGLfaRcg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7651929AF;
	Mon,  1 Apr 2024 07:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711954844; cv=none; b=LfX5jq7O+sUgvW5STD8USqxdYUONIT0NDXpMFyhJQgahP0uWIEUGXJ7eVCnYttoQaT1sfLE+RiJE8Jv8geqCAuXtPfo2C/tEbIb67Wl/pLhJ4c6jkKpFyM+PyjVydEbQaEzU/Dg1aIb7D13TtivGTexuCun5phIGPrBAnZWf+J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711954844; c=relaxed/simple;
	bh=LLuf8x6ofMo6yXJcAwwDMleIkfrsw+/zwHuV6rhATF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JDagCoHoBN4H8kmj083Nx9o0V9URSsuvRs26ZWKC/crA9mvHLknox/GgeVLxY5Moqkjk8YetGhdJUc+GAlLkEgQqchoxtHNwVBuCE6efnYwAFUiEtjBwvOiAgmtOJde1yKFdzezPQWpDRryXHXTeHY2GxWWFNo0DALORyjnd2B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eGLfaRcg; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711954843; x=1743490843;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LLuf8x6ofMo6yXJcAwwDMleIkfrsw+/zwHuV6rhATF4=;
  b=eGLfaRcg3sWiGleNxtDcAt9oP+91vpDh9M4cmkM/3nLJfqbm/9i4LfRX
   JdQugNZXMJKECHbeyxPoA+V2XmLVgHBX9H3AkWFXr3/bBymhdOB2oJFt7
   sFQqassQ2wMOaPMr6u3RSRdLTcYi+7lu48Jr98Q+9jDrh/E6ZnU1BpVmX
   IMFCon2aHJ6PrNaQeADasJxoNhqXjPVhkFE+TwBUtLQ898wWa58k3Pnle
   7DmSyH3DsI6xwWyUAuJmT0p/gPGQZt8hZdo7bftG26fAt3ujQQ8bJmN7w
   2Rmtnh+nR7CouaxdpsvPEXEOOJYDuOhYZVFDdZoiLcJLT21FgZNWYp6Sz
   g==;
X-CSE-ConnectionGUID: B+jZWSBlQGGMQ8wE2L99Mw==
X-CSE-MsgGUID: s/L/fPmhTyWEgts2GvvZUg==
X-IronPort-AV: E=McAfee;i="6600,9927,11030"; a="6906441"
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="6906441"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 00:00:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="18256849"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 00:00:38 -0700
Message-ID: <1bf2a76f-e89b-4aee-8330-7a47280704f1@intel.com>
Date: Mon, 1 Apr 2024 15:00:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 6/9] KVM: nVMX: Use macros and #defines in
 vmx_restore_vmx_basic()
To: Sean Christopherson <seanjc@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xin Li <xin3.li@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
 <20240309012725.1409949-7-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240309012725.1409949-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/9/2024 9:27 AM, Sean Christopherson wrote:
> From: Xin Li <xin3.li@intel.com>
> 
> Use macros in vmx_restore_vmx_basic() instead of open coding everything
> using BIT_ULL() and GENMASK_ULL().  Opportunistically split feature bits
> and reserved bits into separate variables, and add a comment explaining
> the subset logic (it's not immediately obvious that the set of feature
> bits is NOT the set of _supported_ feature bits).
> 
> Cc: Shan Kang <shan.kang@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> [sean: split to separate patch, write changelog, drop #defines]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/vmx/nested.c | 25 ++++++++++++++++++-------
>   1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 82a35aba7d2b..4ad8696c25af 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1228,21 +1228,32 @@ static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
>   
>   static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
>   {
> -	const u64 feature_and_reserved =
> -		/* feature (except bit 48; see below) */
> -		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
> -		/* reserved */
> -		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
> +	const u64 feature_bits = VMX_BASIC_DUAL_MONITOR_TREATMENT |
> +				 VMX_BASIC_INOUT |
> +				 VMX_BASIC_TRUE_CTLS;
> +
> +	const u64 reserved_bits = GENMASK_ULL(63, 56) |
> +				  GENMASK_ULL(47, 45) |
> +				  BIT_ULL(31);
> +
>   	u64 vmx_basic = vmcs_config.nested.basic;
>   
> -	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
> +	BUILD_BUG_ON(feature_bits & reserved_bits);
> +
> +	/*
> +	 * Except for 32BIT_PHYS_ADDR_ONLY, which is an anti-feature bit (has
> +	 * inverted polarity), the incoming value must not set feature bits or
> +	 * reserved bits that aren't allowed/supported by KVM.  Fields, i.e.
> +	 * multi-bit values, are explicitly checked below.
> +	 */
> +	if (!is_bitwise_subset(vmx_basic, data, feature_bits | reserved_bits))
>   		return -EINVAL;
>   
>   	/*
>   	 * KVM does not emulate a version of VMX that constrains physical
>   	 * addresses of VMX structures (e.g. VMCS) to 32-bits.
>   	 */
> -	if (data & BIT_ULL(48))
> +	if (data & VMX_BASIC_32BIT_PHYS_ADDR_ONLY)
>   		return -EINVAL;
>   
>   	if (vmx_basic_vmcs_revision_id(vmx_basic) !=


