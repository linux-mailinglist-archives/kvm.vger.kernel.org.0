Return-Path: <kvm+bounces-57187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82F77B51266
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 11:23:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A18D4E3337
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 09:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1FA831328E;
	Wed, 10 Sep 2025 09:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EZ3SgC95"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706742C21DE;
	Wed, 10 Sep 2025 09:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757496208; cv=none; b=qhgTjdnDUZs4tAW1CDIVxl99Fue3KEE7q3qtHAgnYBmLrrfOBYHpE33Qd0MbZk0hCncW5D5jRiOBqhAVSQu3GLCPZ83K+sOe6sBThAT6lX/CmTi/UPnPLqRTJ8U7K8u14l2Myj2igWMr8I1jvS7JQtaFp+EaETcjdQFi2vw6laA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757496208; c=relaxed/simple;
	bh=OWqK1fNIxz74fbD5C825NvD1zunFGKKo4hQp3TrKVBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qAl/4IKNDGCi6nRQSSl2C2KKm1+/gTn2rPSQrB7rRBonkwFYVOVRV4veKXwS5Ft8pIIBhyEYfW3h9MVnTW8tvRPwapnDY1OfvhSWhsKfB2W3zEhaq2xSSiPMeZiucmwEJgJVkEESF1F0yPY/rP0vNhTzAvv7sc8pw9ibWPLKWa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EZ3SgC95; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757496206; x=1789032206;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OWqK1fNIxz74fbD5C825NvD1zunFGKKo4hQp3TrKVBc=;
  b=EZ3SgC95uf8W0WHAfq8APN+g4ShF1VWHCqnksfImWHFhL/Hu1tj/1iyq
   yz5gMAkb/6eAEZXDMQAhWGukqYeblj9W6eT7qDc/YRxnsA7Q0XzngIAV8
   KH7rC6bwt/ilMS3m9wy9LAPKAMHMJwMATGlilLHNWRFgsfYE9/GRZZBQi
   PeKkwx4M0AZ/Fg9wLh1dUS73affpv6CL50yybH5sqr0WeqPkwg1oYqsYR
   u7TMS2CBqCPh4Cab0D+cOyWjUpkxqWFKSUeO/NMdgb93JnGh3Ap9//lcn
   YE/KxyQp5n1hzDV1LI3fYIxL31EDR1gqrvP3/l84XAyWtTkSoQkctsQv7
   Q==;
X-CSE-ConnectionGUID: sxGkwBpXS8KaVNtGLKdiqA==
X-CSE-MsgGUID: Tpa8bGEIQgucMjCBaLeMzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="77256444"
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="77256444"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 02:23:26 -0700
X-CSE-ConnectionGUID: dDCRoZBQS12sI/CsIQAR1g==
X-CSE-MsgGUID: h56gYN/hQ+yx/GGHMTg4IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="204103643"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 02:23:21 -0700
Message-ID: <ad6a3c7c-92df-421a-aee2-f9fe6afda8e9@intel.com>
Date: Wed, 10 Sep 2025 17:23:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 04/22] KVM: x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: acme@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, john.allen@amd.com, mingo@kernel.org, mingo@redhat.com,
 minipli@grsecurity.net, mlevitsk@redhat.com, namhyung@kernel.org,
 pbonzini@redhat.com, prsampat@amd.com, rick.p.edgecombe@intel.com,
 seanjc@google.com, shuah@kernel.org, tglx@linutronix.de,
 weijiang.yang@intel.com, x86@kernel.org, xin@zytor.com
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-5-chao.gao@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250909093953.202028-5-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/2025 5:39 PM, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Update CPUID.(EAX=0DH,ECX=1).EBX to reflect current required xstate size
> due to XSS MSR modification.
> CPUID(EAX=0DH,ECX=1).EBX reports the required storage size of all enabled
> xstate features in (XCR0 | IA32_XSS). The CPUID value can be used by guest
> before allocate sufficient xsave buffer.
> 
> Note, KVM does not yet support any XSS based features, i.e. supported_xss
> is guaranteed to be zero at this time.
> 
> Opportunistically skip CPUID updates if XSS value doesn't change.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/cpuid.c | 3 ++-
>   arch/x86/kvm/x86.c   | 2 ++
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 46cf616663e6..b5f87254ced7 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -316,7 +316,8 @@ static void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>   	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 1);
>   	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>   		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
> -		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
> +		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
> +						 vcpu->arch.ia32_xss, true);
>   }
>   
>   static bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6c167117018c..bbae3bf405c7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4020,6 +4020,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		 */
>   		if (data & ~vcpu->arch.guest_supported_xss)
>   			return 1;
> +		if (vcpu->arch.ia32_xss == data)
> +			break;
>   		vcpu->arch.ia32_xss = data;
>   		vcpu->arch.cpuid_dynamic_bits_dirty = true;
>   		break;


