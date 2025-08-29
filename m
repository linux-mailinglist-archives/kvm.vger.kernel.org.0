Return-Path: <kvm+bounces-56255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DA9AB3B3C6
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 09:05:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E88F17B4C00
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 07:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4009261B94;
	Fri, 29 Aug 2025 07:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZSQARCUI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFE51F8AD3;
	Fri, 29 Aug 2025 07:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756451110; cv=none; b=sXW1rOCJPoz/UON9BXHPNApzd7J4MagYX8ILLjgnHI5k4kb40mKKN9Ne9rNj/OYu99jJqLqpCbBnbd27vhgh3JYzjWuredy9KgfpaeTtLUQx9oGt2eCIrIhoOYSJrZIUYWETWvs6kKx4LJg6sOtESqtgqduiKyFt/LtXudwueqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756451110; c=relaxed/simple;
	bh=34+UGuEf9SYw9G3LAd6Gu8SfI59VORc81JlNCNUiiTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q99VOJN0zMvBwEIIgmRA9yhETBzs3yUPwx1gX+LnWpzPg9S0n/t9LW7Uaec4IAU8FCuX5rIIFolnR0m1yRxbGThxzr2WkB5IG1PbA1agqpmP8q54ImFU8C4YV/zzDs5D43dyn1qxOXSHmUnRwCyGaY5ydeu2mb+8L1Btp2q3B7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZSQARCUI; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756451109; x=1787987109;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=34+UGuEf9SYw9G3LAd6Gu8SfI59VORc81JlNCNUiiTk=;
  b=ZSQARCUIXswxONOHwAuxQjc6SE/UKNVPMZz35fUrzoo1bWG83KCnw0Yj
   +zMoLCANv/J3MM9Wmyab4HXTu5RG//slkq4YJ5WwyTqjVtMSAg2Qj83GG
   yMbHP+6gkt3hxaIi398kzMJpdbkTz4tnxQTd6jkluWZEpnZONmc4raiiR
   BXGUrdnpcEyediIF5Z+7oxWom/Abj93H7AtsMgGSrIE7qbP1TAKCKeUN8
   SA9HWL6D5jie1STUsHZQLGKOT/+0mPmvX7dxD87FhRDv2oZ1ZRDGjCIDL
   GyQaqQIYAmhG3bFjeTtoF6Rgk84is/KTehaY9gn/mvEbATcLDc1zJUhqQ
   g==;
X-CSE-ConnectionGUID: 283hBx7KQdW1rDLTeI5nJQ==
X-CSE-MsgGUID: r7E4JH0cTnKlZdEdPPUo3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="69007121"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="69007121"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 00:05:09 -0700
X-CSE-ConnectionGUID: 4tZ59cbCTU+1mnWd//ov4w==
X-CSE-MsgGUID: UDR5m9woStyAxjxbubq0HA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="170212672"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 00:05:04 -0700
Message-ID: <3eedb2f8-4356-45e9-87d6-579ca30aaa35@intel.com>
Date: Fri, 29 Aug 2025 15:05:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 04/21] KVM: x86: Initialize kvm_caps.supported_xss
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 john.allen@amd.com, mingo@redhat.com, minipli@grsecurity.net,
 mlevitsk@redhat.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com,
 seanjc@google.com, tglx@linutronix.de, weijiang.yang@intel.com,
 x86@kernel.org, xin@zytor.com
References: <20250821133132.72322-1-chao.gao@intel.com>
 <20250821133132.72322-5-chao.gao@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250821133132.72322-5-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/2025 9:30 PM, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Set original kvm_caps.supported_xss to (host_xss & KVM_SUPPORTED_XSS) if
> XSAVES is supported. host_xss contains the host supported xstate feature
> bits for thread FPU context switch, KVM_SUPPORTED_XSS includes all KVM
> enabled XSS feature bits, the resulting value represents the supervisor
> xstates that are available to guest and are backed by host FPU framework
> for swapping {guest,host} XSAVE-managed registers/MSRs.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
>   arch/x86/kvm/x86.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 75b7a29721bb..6b01c6e9330e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -220,6 +220,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>   				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>   				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>   
> +#define KVM_SUPPORTED_XSS     0
> +
>   bool __read_mostly allow_smaller_maxphyaddr = 0;
>   EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
>   
> @@ -9793,14 +9795,17 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>   		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
>   		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
>   	}
> +
> +	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
> +		rdmsrq(MSR_IA32_XSS, kvm_host.xss);
> +		kvm_caps.supported_xss = kvm_host.xss & KVM_SUPPORTED_XSS;
> +	}

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

Btw, since we now have KVM_SUPPORTED_XSS to cap the supported bits, it 
seems we can remove the

	kvm_caps.supported_xss = 0;

in both vmx_set_cpu_caps() and svm_set_cpu_caps().

>   	kvm_caps.supported_quirks = KVM_X86_VALID_QUIRKS;
>   	kvm_caps.inapplicable_quirks = KVM_X86_CONDITIONAL_QUIRKS;
>   
>   	rdmsrq_safe(MSR_EFER, &kvm_host.efer);
>   
> -	if (boot_cpu_has(X86_FEATURE_XSAVES))
> -		rdmsrq(MSR_IA32_XSS, kvm_host.xss);
> -
>   	kvm_init_pmu_capability(ops->pmu_ops);
>   
>   	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))


