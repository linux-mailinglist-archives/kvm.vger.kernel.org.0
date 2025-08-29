Return-Path: <kvm+bounces-56253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 045E1B3B38B
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 08:37:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC8C416B8D2
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 06:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F55257834;
	Fri, 29 Aug 2025 06:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="biDH6Hna"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5B8250BEC;
	Fri, 29 Aug 2025 06:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756449441; cv=none; b=p2yKR3IbQmQSv+aXO2m4GdGcBp7h2Akn/PZW8apE3vUxddo1kB0d/3KeKd/GTvVY0QuLuw3bSgEj+QjQ1fQLEUQpMwaKcXby4GAO0qvS4g1FLkJIk4hOYpbyA8JiIyBSO9qhF4KB54CJxei6zthOJKHV+zx7s8uOsVT94aJCce8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756449441; c=relaxed/simple;
	bh=A3ZnxoHMDZxruzcSDLOsn1mrsCjJu/QnHwbCBkGRwPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J0CPacdakjd90Nz1RZmPmdRcmEjicMGFpHlRcu/9QDemAYGeHCzHwgVlpaKWkGSNDkJr3Rhd2laeQ8VjgG1UjiHarsYp++QcOI+7IERdQqihofqZD1/BJF3vHTTddr2gsjsMSy+rtQZnfU5C+ZJFx5mExH54VRotl9q49C3hY3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=biDH6Hna; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756449440; x=1787985440;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=A3ZnxoHMDZxruzcSDLOsn1mrsCjJu/QnHwbCBkGRwPs=;
  b=biDH6HnarjhpBkyGCyPPgg8AaH9TZPf9YYlKkhOIuheEaluZiQgXB9o8
   C6YEKxKG9fRL+GEBxtPxuL9SnUlouGnWOZIqlHTsgK4vvOtoTdMnggjJK
   4ymoQHOyTX8Vr6/YUJHtsuQ6xOBBpSsSxCqu3RZrDSXJot5NfuP8eYzQH
   RQoiKFiLRtHr+M0mkyJ4rfQS5kI7DKb3dzeupnoXcaBX4t3DRimDhapq/
   ucXmUvfCvCWlsUwneD595rJqOIkLoacGrxOaBFQi9DzYZDMXyfxooDMIT
   bzR5/dZR19cW4NpXiKF75WjOtmMx9MKIOoXMCXIXuaW0HWfiAYCYxrTdd
   w==;
X-CSE-ConnectionGUID: Stxz4/JBQSWOVUmK5wXeiw==
X-CSE-MsgGUID: j+rgZYHHTweRBLHT5+joyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="46301674"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="46301674"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 23:37:12 -0700
X-CSE-ConnectionGUID: qLVDycIETH2+Jr81JpgWUw==
X-CSE-MsgGUID: gByn24WPQ+eRKatCAsKdSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="169565167"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 23:37:06 -0700
Message-ID: <8368132d-dc31-4820-99ba-b3af76a99d54@intel.com>
Date: Fri, 29 Aug 2025 14:37:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 02/21] KVM: x86: Report XSS as to-be-saved if there
 are supported features
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 john.allen@amd.com, mingo@redhat.com, minipli@grsecurity.net,
 mlevitsk@redhat.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com,
 seanjc@google.com, tglx@linutronix.de, weijiang.yang@intel.com,
 x86@kernel.org, xin@zytor.com
References: <20250821133132.72322-1-chao.gao@intel.com>
 <20250821133132.72322-3-chao.gao@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250821133132.72322-3-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/2025 9:30 PM, Chao Gao wrote:
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
> Signed-off-by: Chao Gao <chao.gao@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/x86.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 31a7e7ad310a..569583943779 100644
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
> @@ -7474,6 +7474,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
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


