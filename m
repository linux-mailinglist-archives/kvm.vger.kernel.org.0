Return-Path: <kvm+bounces-57280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30D59B5293E
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 08:52:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7658D1BC6F51
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 06:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7163257AC1;
	Thu, 11 Sep 2025 06:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QUTcuoel"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A961DF97D;
	Thu, 11 Sep 2025 06:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757573561; cv=none; b=psrpVqpUmqI0qlePlUu2wo2mJhRF/laVkqX/ONniEwgXsi2Il5Wz5mmlEecmeI/NVdVM4R/XsIpO2DQTsuXFNppRQuq62Er2kEcbu+JdNNTqMbW2ushCjHaHpyM2kDN2ANvXth5+UHezxNzSWFaTh9TYVSI6+miJOL46WMsWq4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757573561; c=relaxed/simple;
	bh=U4NaHTrJuPhGYd9RgDnrJSxb0pLpENgCkrEDV03NA/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jPnNzOIZBwHL/ehFYyoDwjMsFMmQmMz+DMxrS4jzAC9uHGfb9VNjAsSUk/fqWp4w0Y9js353pooV888ACJnOhnnaNRl6xEnwNxwkyeI5uE02Qj00PB1hGpV01iSqaiP2aQHtONuRlH27JnYNuJX02YSKd054Oe8ZY+NKsH5DHAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QUTcuoel; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757573559; x=1789109559;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=U4NaHTrJuPhGYd9RgDnrJSxb0pLpENgCkrEDV03NA/8=;
  b=QUTcuoeln3OHAmk0RZuAYDpi1QNYnB07pPmjQ6kRclABMnaPp9cFwDH9
   eT3AeJY/uWCOCXL1i7YulmHIKxOkxdLOanFJKjbp0FbJ8OEjPTPRfILpm
   CIuYfxPqC3kyhCNR+k72STnPTMNzj/oVsbu5vv76g2/jvJkU3zmqZzqMK
   T4AOiWLGMd6PfMCLqLO7P5pdYA47S8Lsxht1zAzEGSgNYS6SuuDjGmX/f
   ZsCJcogWEE1Jd8eNRjYSSxfr26NzoF0MUwge+KNg+/nXA9IOuk2Tt+LDH
   yETLRCIb0+fL45f9sS22k5HB/s2Fcz+OAZDAJHmrL8j+YXMVOuvOI+e12
   Q==;
X-CSE-ConnectionGUID: Z2Wc160yTGul6Wk4XwdAXA==
X-CSE-MsgGUID: TA8z09QuSqSkFgQKpxznrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59960569"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59960569"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 23:52:39 -0700
X-CSE-ConnectionGUID: 1DLSL7J7R9Kr+mYeZY1wJA==
X-CSE-MsgGUID: SJJ63r95S3639eCF7AT+pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,256,1751266800"; 
   d="scan'208";a="172899554"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 23:52:34 -0700
Message-ID: <708d43af-3d87-4412-896b-1fbac1ef81b2@linux.intel.com>
Date: Thu, 11 Sep 2025 14:52:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 02/22] KVM: x86: Report XSS as to-be-saved if there
 are supported features
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 john.allen@amd.com, mingo@kernel.org, mingo@redhat.com,
 minipli@grsecurity.net, mlevitsk@redhat.com, namhyung@kernel.org,
 pbonzini@redhat.com, prsampat@amd.com, rick.p.edgecombe@intel.com,
 seanjc@google.com, shuah@kernel.org, tglx@linutronix.de,
 weijiang.yang@intel.com, x86@kernel.org, xin@zytor.com, xiaoyao.li@intel.com
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-3-chao.gao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250909093953.202028-3-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/9/2025 5:39 PM, Chao Gao wrote:
> From: Sean Christopherson <seanjc@google.com>
>
> Add MSR_IA32_XSS to list of MSRs reported to userspace if supported_xss
> is non-zero, i.e. KVM supports at least one XSS based feature.
>
> Before enabling CET virtualization series, guest IA32_MSR_XSS is
> guaranteed to be 0, i.e., XSAVES/XRSTORS is executed in non-root mode
> with XSS == 0, which equals to the effect of XSAVE/XRSTOR.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


> ---
>   arch/x86/kvm/x86.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f32d3edfc7b1..47b60f275fd7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -335,7 +335,7 @@ static const u32 msrs_to_save_base[] = {
>   	MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
>   	MSR_IA32_UMWAIT_CONTROL,
>   
> -	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
> +	MSR_IA32_XFD, MSR_IA32_XFD_ERR, MSR_IA32_XSS,
>   };
>   
>   static const u32 msrs_to_save_pmu[] = {
> @@ -7470,6 +7470,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>   		if (!(kvm_get_arch_capabilities() & ARCH_CAP_TSX_CTRL_MSR))
>   			return;
>   		break;
> +	case MSR_IA32_XSS:
> +		if (!kvm_caps.supported_xss)
> +			return;
> +		break;
>   	default:
>   		break;
>   	}


