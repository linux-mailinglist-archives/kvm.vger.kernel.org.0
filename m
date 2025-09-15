Return-Path: <kvm+bounces-57514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ED42B5704B
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 08:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 325AA1745B7
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 06:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98ADF283C9F;
	Mon, 15 Sep 2025 06:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lCJHdYaP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391AA285078;
	Mon, 15 Sep 2025 06:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757917843; cv=none; b=Rw6T1ddb5kHnIumwKuEygDR0tX1R5gw9xGuopMckW0mXf5jfikTVt5mELgxBHGfbu4R9ntsTKFpGtw0pXWSIy0qLd0q1mvWCakoDR6Oy+3HxNZuHJlSQ1N0qAm7sSdQVnB37xP3okoJL5VAJuv3IyUYyZYMo+iz/Jk+POlZorZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757917843; c=relaxed/simple;
	bh=/UfRt76UTpLt3AeUfWvzLeRFXoq4bBdnjvmC8NwFm1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sLwkQR2kbWSQSYmTCeTXjrrllCm98xL3HpQanWviz4jTKhrozKFz7lGju0B8L7CgvKXpJK9HdaYNOfkXbr3grA9+3xbWtQ9gR99osF5DjcRFiZH2gH7EuoFGmKnstMjPYXAuFDOxCK384iC3FdyX38I6KGEjIsTcKlTsbuVmt34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lCJHdYaP; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757917843; x=1789453843;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/UfRt76UTpLt3AeUfWvzLeRFXoq4bBdnjvmC8NwFm1I=;
  b=lCJHdYaP0UPHPaadnXt9zdKQQ9qi/sHwGnD4RgEemR/mVqVrI9/kktYl
   5b8wB0B2lmINdQOLD6+jxBs56MtRaciQT/rCipVIUe24E+Xfu1nMdWWwk
   mxJbknrLIKWxTMAG1DZbk+V10UaPcAkP61m0btOfO/MaVwlKUu/kAfFiD
   J1lGC39qflmkqY8gztHE10aHftXsQToHXv2C6sz5mv5ezmEKoDh+w/Xib
   27SUDIFUyRcnJRks4EP+5+D+kcJMp7a2NbCHVMCdZIqs8ku78o4bFnzT4
   btC+xRBFtptY+l42e1T9uJSeLBg19BNxdQ7lZNu7RwIT8yuI/blRbXhDe
   g==;
X-CSE-ConnectionGUID: esCiC9rSSlKyc/NBe+KcpQ==
X-CSE-MsgGUID: L4yJZeiUT5+oudBJvnEOfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63979543"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63979543"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2025 23:30:42 -0700
X-CSE-ConnectionGUID: VckSAqD6Tum9vhBQoBS0qA==
X-CSE-MsgGUID: 67lBLui+TgiBT8+6JfOIJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,265,1751266800"; 
   d="scan'208";a="174974878"
Received: from junlongf-mobl.ccr.corp.intel.com (HELO [10.238.1.52]) ([10.238.1.52])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2025 23:30:39 -0700
Message-ID: <793a01d8-c439-45ee-a509-606245f42f07@intel.com>
Date: Mon, 15 Sep 2025 14:30:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 11/41] KVM: x86: Report KVM supported CET MSRs as
 to-be-saved
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-12-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250912232319.429659-12-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Add CET MSRs to the list of MSRs reported to userspace if the feature,
> i.e. IBT or SHSTK, associated with the MSRs is supported by KVM.
> 
> Suggested-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/x86.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5653ddfe124e..2c9908bc8b32 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -344,6 +344,10 @@ static const u32 msrs_to_save_base[] = {
>   	MSR_IA32_UMWAIT_CONTROL,
>   
>   	MSR_IA32_XFD, MSR_IA32_XFD_ERR, MSR_IA32_XSS,
> +
> +	MSR_IA32_U_CET, MSR_IA32_S_CET,
> +	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
> +	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB,
>   };
>   
>   static const u32 msrs_to_save_pmu[] = {
> @@ -7598,6 +7602,20 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>   		if (!kvm_caps.supported_xss)
>   			return;
>   		break;
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_S_CET:
> +		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> +		    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> +			return;
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		if (!kvm_cpu_cap_has(X86_FEATURE_LM))
> +			return;
> +		fallthrough;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> +			return;
> +		break;
>   	default:
>   		break;
>   	}


