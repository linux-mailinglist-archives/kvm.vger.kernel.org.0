Return-Path: <kvm+bounces-57188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6388AB512A2
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 11:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 183083B225F
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 09:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4A3C313E3B;
	Wed, 10 Sep 2025 09:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l6rE4C5k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F111313E06;
	Wed, 10 Sep 2025 09:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757496996; cv=none; b=pIL3PUt/JD/fAJUrBS9HTx6e2VeQT81sRCUJGe7JJE807JKmaVl0Z63M+LJJVYB4BYUm+bkodq2A60ZRdiEJs/PsqzY/nUm0/DN6ZC+cO6eg3F/R9Av1eYrJGMruKm1WIwLTjq/aaYcSnY031PTU6I1zV2uQGiFriTLbJklge80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757496996; c=relaxed/simple;
	bh=z/+g+GEB2fTlcU21x1xJMPkrgQB+GAAhUBhnCe669Zw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pDx1vHRlKGYcwmOSe8JAQ/FoGqX4sAgPHDoN8DLVCjo8YSd3A037q5yWdoYg9hl84u9ymqvT78xI2zjQfDrvduJazdX5gD5sLmnJ0mdXS/2Nh0o8jLSba1SInVc9Veko4sL0bLb3VSSby/0SW4pEcEftr52U525iMOsRrUlsy1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l6rE4C5k; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757496996; x=1789032996;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=z/+g+GEB2fTlcU21x1xJMPkrgQB+GAAhUBhnCe669Zw=;
  b=l6rE4C5kKp4RqsRIQVY8BW5YEHqkETCiKHrXqMDgoSCDDd8vQ6lv5l0J
   uQBLNvg4zGCxI5Q+75U7chShiQGDbF5u5BhhbBJnMVkDz75Tn34oynLES
   8AdJMxW7rAelQU7ufWGNQGR0Zfp7PD0S4DfFs91fXBFE26QtpMOeCS5kc
   G/+XJEa4IY1lKqW/lw5tQaI7RLdt/XeIF0rfan4jrMaDdvJf8AF4iKjn4
   RUrbT7ks+Bf6A0VN+QkOUbkjGrpabyuj6Ms7gK7TzwtSTnkclA9YDpQJ2
   DjeMJYjFUslUYUY7VOMZB4KcrqgdyQCLXRVJpbYiM7VuHITLlraYgmwEt
   w==;
X-CSE-ConnectionGUID: oEWHME/5STGEjYbo2emkbA==
X-CSE-MsgGUID: LLQCRx2oSMqZJbvT2q5uYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="59943747"
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="59943747"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 02:36:35 -0700
X-CSE-ConnectionGUID: QPMmREveTquYP+P5sctZSA==
X-CSE-MsgGUID: dJSyJAs6RW2Wlp+N5p+PFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="204106295"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 02:36:29 -0700
Message-ID: <9197eea9-e8fb-49e7-a74d-ee4e0401074f@intel.com>
Date: Wed, 10 Sep 2025 17:36:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 05/22] KVM: x86: Initialize kvm_caps.supported_xss
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: acme@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, john.allen@amd.com, mingo@kernel.org, mingo@redhat.com,
 minipli@grsecurity.net, mlevitsk@redhat.com, namhyung@kernel.org,
 pbonzini@redhat.com, prsampat@amd.com, rick.p.edgecombe@intel.com,
 seanjc@google.com, shuah@kernel.org, tglx@linutronix.de,
 weijiang.yang@intel.com, x86@kernel.org, xin@zytor.com
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-6-chao.gao@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250909093953.202028-6-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/2025 5:39 PM, Chao Gao wrote:
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
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
>   arch/x86/kvm/x86.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bbae3bf405c7..c15e8c00dc7d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -220,6 +220,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>   				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>   				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>   
> +#define KVM_SUPPORTED_XSS     0
> +

(related to my comment on previous patch)

It seems better to move the comment about Intel PT (IA32_XSS[bit 8]) in 
kvm_set_msr_common() to above KVM_SUPPORTED_XSS.

>   bool __read_mostly allow_smaller_maxphyaddr = 0;
>   EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
>   
> @@ -9789,14 +9791,17 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>   		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
>   		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
>   	}
> +
> +	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
> +		rdmsrq(MSR_IA32_XSS, kvm_host.xss);
> +		kvm_caps.supported_xss = kvm_host.xss & KVM_SUPPORTED_XSS;
> +	}
> +
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


