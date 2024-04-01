Return-Path: <kvm+bounces-13266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 886B0893893
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 09:09:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42D0A281AF4
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 07:09:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BA4EBA2E;
	Mon,  1 Apr 2024 07:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Orh85Lt1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60ACBE4B;
	Mon,  1 Apr 2024 07:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711955359; cv=none; b=Has/cf6T3A8CJwevpFABMp95o6XJnOnE/BusEt862zrkgc78U2TpzRSLLD5tny7ue3XJBgzq4JiuD5GdmTZMW+J79Cz/qWfc2e7Hx3dVKvQJjrcSVT3Ae5ju/MEpZuS5GqedSzqBAlW5VHwhcpnrUeQ9j36xa8OSf7TcspUH8VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711955359; c=relaxed/simple;
	bh=QK03u+6ppdo1nULFDMzZhk4/uikkG5Uc2lkrQyuYkqs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hyiE2C/4IpzcOVrmTS1Xg/A+1WNXGInM0KpI7uFYVgdzZL6tqCrEeArkpEL4+5cMLmv5grSCYuI4KZFTx8d9Tv3o3yLjx7YwaV7yW5eeRjV2N07LxsVtT1QX82awcxbRUItdtoSPPBew15KuPU0wC0d3qVjFJAliKnjJeok9qaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Orh85Lt1; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711955358; x=1743491358;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QK03u+6ppdo1nULFDMzZhk4/uikkG5Uc2lkrQyuYkqs=;
  b=Orh85Lt1cMKSIC/Yk7a9XyO9uqHFroe6elwU559Dajuj+7S+TPZBLxEF
   x8CcrkRcaCFSeOi+J6t+sANPzG+J6z8Tqm2r1iGYhNnlhrQpBhaLxzb5u
   s88Ui9xSUjyW1w/MUOydKL4nIukM66MN1hYdVTF6b8TNtb2fU1en5D79P
   og6l3fWETCZESY0/psFjwyLpJWCCAH4iRBuSJJ70LTPCswtyG+M3RxKak
   s2SdeJYWQcE0xnPe61+I4yM/BYqXaaCg/II4Wetu1B68eZaYbIm3iRX/5
   aeDL9jlBHAoBgW15a0hga6b8sSLcM/VxoLVbkKKHadgh4wUgWAdANuP5j
   g==;
X-CSE-ConnectionGUID: 6NApPkTHREmFkmBrSi42tA==
X-CSE-MsgGUID: ZBgmWJTmSsG3lAJlImtI9g==
X-IronPort-AV: E=McAfee;i="6600,9927,11030"; a="10896469"
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="10896469"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 00:09:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="48614457"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 00:09:06 -0700
Message-ID: <329c7188-bd24-4200-9934-ff4a07fa1c61@intel.com>
Date: Mon, 1 Apr 2024 15:09:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 9/9] KVM: nVMX: Use macros and #defines in
 vmx_restore_vmx_misc()
To: Sean Christopherson <seanjc@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xin Li <xin3.li@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
 <20240309012725.1409949-10-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240309012725.1409949-10-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/9/2024 9:27 AM, Sean Christopherson wrote:
> From: Xin Li <xin3.li@intel.com>
> 
> Use macros in vmx_restore_vmx_misc() instead of open coding everything
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
>   arch/x86/kvm/vmx/nested.c | 27 ++++++++++++++++++++-------
>   1 file changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 06512ee7a5c4..6610d258c680 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1322,16 +1322,29 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
>   
>   static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
>   {
> -	const u64 feature_and_reserved_bits =
> -		/* feature */
> -		BIT_ULL(5) | GENMASK_ULL(8, 6) | BIT_ULL(14) | BIT_ULL(15) |
> -		BIT_ULL(28) | BIT_ULL(29) | BIT_ULL(30) |
> -		/* reserved */
> -		GENMASK_ULL(13, 9) | BIT_ULL(31);
> +	const u64 feature_bits = VMX_MISC_SAVE_EFER_LMA |
> +				 VMX_MISC_ACTIVITY_HLT |
> +				 VMX_MISC_ACTIVITY_SHUTDOWN |
> +				 VMX_MISC_ACTIVITY_WAIT_SIPI |
> +				 VMX_MISC_INTEL_PT |
> +				 VMX_MISC_RDMSR_IN_SMM |
> +				 VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |
> +				 VMX_MISC_VMXOFF_BLOCK_SMI |
> +				 VMX_MISC_ZERO_LEN_INS;
> +
> +	const u64 reserved_bits = BIT_ULL(31) | GENMASK_ULL(13, 9);
> +
>   	u64 vmx_misc = vmx_control_msr(vmcs_config.nested.misc_low,
>   				       vmcs_config.nested.misc_high);
>   
> -	if (!is_bitwise_subset(vmx_misc, data, feature_and_reserved_bits))
> +	BUILD_BUG_ON(feature_bits & reserved_bits);
> +
> +	/*
> +	 * The incoming value must not set feature bits or reserved bits that
> +	 * aren't allowed/supported by KVM.  Fields, i.e. multi-bit values, are
> +	 * explicitly checked below.
> +	 */
> +	if (!is_bitwise_subset(vmx_misc, data, feature_bits | reserved_bits))
>   		return -EINVAL;
>   
>   	if ((vmx->nested.msrs.pinbased_ctls_high &


