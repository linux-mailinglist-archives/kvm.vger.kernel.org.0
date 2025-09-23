Return-Path: <kvm+bounces-58546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08567B96753
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:58:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C65C33A5DEF
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C14F32459E5;
	Tue, 23 Sep 2025 14:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M2q5lZnt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF2114A0BC;
	Tue, 23 Sep 2025 14:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758639346; cv=none; b=G1onW18Z1VvGEE9GsesAvXh3433Iod3zXKPNljpeRHFaYcbyohxDj1j2/bLHXgQ/3JHmXOot7xzChJ+0kEZo8pFYmQR6AIBZLByBGHy6QOCMB5LEpm0Xyg6LpkSP1Wo33a4Usf3XAnoZNafCDH4AdoXxQYh1PMNByGJD2BBrPXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758639346; c=relaxed/simple;
	bh=UQytHJXYrnHSxzAs5M8oz0QT0zfFrXxZMzqeux9v1vM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=umybOv2SxBux+Cadp48HQavpJqBg5zBzJPjzKLvxZ9S7f4/w5Iz/DoN5foRwtAB4CICdbcGPHhlUvV6Xuugthx+CR+n5Z0lvIVVy6crwYv4PctOXamhTbBhZfq1ExZJLMXBr5n5zLeoj4clmoVB23QV68k3HDpp11zkBrLDsbhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M2q5lZnt; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758639346; x=1790175346;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UQytHJXYrnHSxzAs5M8oz0QT0zfFrXxZMzqeux9v1vM=;
  b=M2q5lZnttvH/H8agtLtwqWbxRUIXDJZCFWe/UYKN5XQDXpANMDzI6B94
   guEkBkaUJzY12kPoG/BaQ/n+sX8t0IZEbCXxqsBIb0nBfo3m4Dg2TpVv1
   R4WCc5Gj//ORBz4PrNkeP4kw7/AjE30nDJyb1GhjBJwgiDI8qPfHkrdE0
   fOgI+8h/613ogOqWX6+C/GDFNE8PbDrAxsNhg5Y2BgXdEZyUeONTB8itv
   bTUV2aDKATmCzKI2vIRJdvuV9AQY31bvu4PuC3U8moVFb9nF3aOb2nh5A
   8JdtX2x9bbE+el4MRPa0xrbopKTyWHENBFhEW40THzVLUFP3wdqBMcwvi
   A==;
X-CSE-ConnectionGUID: w7vS8Vx1TMmQqHlACRGOUg==
X-CSE-MsgGUID: illHDN0mSMmNq5aSHYxDAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="71593484"
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="71593484"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:55:45 -0700
X-CSE-ConnectionGUID: K7m4i86pSs6k9H/rqHRTOA==
X-CSE-MsgGUID: fvIMYAf3RTamYk/tz7kojg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="180775592"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:55:41 -0700
Message-ID: <c2873e33-cff0-476d-8891-95cbee839db9@intel.com>
Date: Tue, 23 Sep 2025 22:55:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 25/51] KVM: x86: Add XSS support for CET_KERNEL and
 CET_USER
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-26-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250919223258.1604852-26-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Add CET_KERNEL and CET_USER to KVM's set of supported XSS bits when IBT
> *or* SHSTK is supported.  Like CR4.CET, XFEATURE support for IBT and SHSTK
> are bundle together under the CET umbrella, and thus prone to
> virtualization holes if KVM or the guest supports only one of IBT or SHSTK,
> but hardware supports both.  However, again like CR4.CET, such
> virtualization holes are benign from the host's perspective so long as KVM
> takes care to always honor the "or" logic.
> 
> Require CET_KERNEL and CET_USER to come as a pair, and refuse to support
> IBT or SHSTK if one (or both) features is missing, as the (host) kernel
> expects them to come as a pair, i.e. may get confused and corrupt state if
> only one of CET_KERNEL or CET_USER is supported.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> [sean: split to separate patch, write changelog, add XFEATURE_MASK_CET_ALL]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/x86.c | 18 +++++++++++++++---
>   1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 40596fc5142e..4a0ff0403bb2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -220,13 +220,14 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>   				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>   				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>   
> +#define XFEATURE_MASK_CET_ALL	(XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)
>   /*
>    * Note, KVM supports exposing PT to the guest, but does not support context
>    * switching PT via XSTATE (KVM's PT virtualization relies on perf; swapping
>    * PT via guest XSTATE would clobber perf state), i.e. KVM doesn't support
>    * IA32_XSS[bit 8] (guests can/must use RDMSR/WRMSR to save/restore PT MSRs).
>    */
> -#define KVM_SUPPORTED_XSS     0
> +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_ALL)
>   
>   bool __read_mostly allow_smaller_maxphyaddr = 0;
>   EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
> @@ -10104,6 +10105,16 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>   	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>   		kvm_caps.supported_xss = 0;
>   
> +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> +		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
> +
> +	if ((kvm_caps.supported_xss & XFEATURE_MASK_CET_ALL) != XFEATURE_MASK_CET_ALL) {
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
> +	}
> +
>   	if (kvm_caps.has_tsc_control) {
>   		/*
>   		 * Make sure the user can only configure tsc_khz values that
> @@ -12775,10 +12786,11 @@ static void kvm_xstate_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	/*
>   	 * On INIT, only select XSTATE components are zeroed, most components
>   	 * are unchanged.  Currently, the only components that are zeroed and
> -	 * supported by KVM are MPX related.
> +	 * supported by KVM are MPX and CET related.
>   	 */
>   	xfeatures_mask = (kvm_caps.supported_xcr0 | kvm_caps.supported_xss) &
> -			 (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
> +			 (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR |
> +			  XFEATURE_MASK_CET_ALL);
>   	if (!xfeatures_mask)
>   		return;
>   


