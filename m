Return-Path: <kvm+bounces-57699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A623B5913E
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 10:48:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8993B5236CF
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 08:47:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD8E61DED52;
	Tue, 16 Sep 2025 08:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G0gACZ3M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49393195811;
	Tue, 16 Sep 2025 08:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758012419; cv=none; b=bHCIl6XxQNGyoTkfa4GH0MTMIzRIae0djH6HttUeh2IL0niRv/rOC8u2rg14hIBx52th0HY4/0eSYGJ3rjayzE3bwHTag4M3G7UUsJhviOuQMOsCRlTxmMOCC6JHLO8wNsv/eG43QTnBHISrw9vLsiDXjr1KILwUuVdovH9CGW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758012419; c=relaxed/simple;
	bh=ykt5iKNeqDYbUvArcIPqA4Dk2B/zsxIPAzUkjmckNlo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fhfAqJGK2ob3P3ruchspZfPdW9c/oCNYpxc2GRYoRv9DbE7iGJ7gO3YUhlh6NrAdIVZaHCcTtp7P75vPmQXdKItEyIEtZT6yOYJNU/W7vWcF8FPUxpamdMi7dfjohq2hfEsunJGJrDegmglO9AxJpXPjz/rcQ2TVXNvDYJPGFN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G0gACZ3M; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758012418; x=1789548418;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ykt5iKNeqDYbUvArcIPqA4Dk2B/zsxIPAzUkjmckNlo=;
  b=G0gACZ3Mrgm45eOA+q10nfEFuI+BS68sFAx5qI+myhNuJxUxNLbUmtEZ
   459o8P4boH6bMx/tj/aNxq+nYbG9JrIMqtZnB/mAT1UfNZixQMkI4kDrp
   RdG6abp6XOPMBFBPqM9at3dpWw1tSoHzgknMS9VgCtuKyoPv9hjqrspnw
   J7DD24AzZBfGXI0l6YXNCK1Rq/R5kWcIeFMebwnVrxDm6VfHxst3ClNfn
   PVhieWE3N3WLV/ddYP+nZpjK+z1CMGwD4wmX5H8qlOdzzAonc0LH6VTJn
   xy7DnJihMlGYa1TUOekPj2DivexJNqyUHqGVROSk4ZVzKSlczCrAOy3/y
   g==;
X-CSE-ConnectionGUID: nHHrNosPQZuDxneev0WKyQ==
X-CSE-MsgGUID: sogNXx5nR46/vghckBN1Aw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64091477"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64091477"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 01:46:57 -0700
X-CSE-ConnectionGUID: CzUhbfpRRQOO0eUlar3fXQ==
X-CSE-MsgGUID: 0zcksTDCRA+UDWtTtWu5tQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="180130901"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 01:46:54 -0700
Message-ID: <081acb09-43e4-4ed9-a12c-3b9c8f6da247@linux.intel.com>
Date: Tue, 16 Sep 2025 16:46:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 11/41] KVM: x86: Report KVM supported CET MSRs as
 to-be-saved
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-12-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
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

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

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


