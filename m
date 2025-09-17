Return-Path: <kvm+bounces-57826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8611DB7CC5B
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:10:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F1911C00DCE
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 08:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A35293093AD;
	Wed, 17 Sep 2025 08:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DU3PJZHd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF051C84B2;
	Wed, 17 Sep 2025 08:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758097953; cv=none; b=bBsgesPYZ3/o5bMKH/NVXynjSzGrXW03o0h5uvkIU+uYR9TG3LhFSKmgq+cGuAm4/kvX5+fLUeb5KV6BaUOdSHpJbRgkgclYnwrMhQNj2uo+qvQmvy85oClDvrV+ANvYpgP+o9mLcfqlYyjRaO17pz5iV6BSpMJHd4fVdB31L+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758097953; c=relaxed/simple;
	bh=yK+fpi+YCg3Em7+WVxTKXNM3K9lgx/Xg+UOZdBCfGHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DjDXv6K8xuvBhoVi7quoK9I9lNV7+vnASufqEHecq5Hir3oPZTjBN+ToV5omjSiRRWOwxmojye0I0ht9iTyGg4Bhzgwa3ASlEYJ2hFdHf/pgoU56NJrhQDWWhWcCxwHbS1RphlNwljkX4zGLVIihVqO6Avs1fjcHsyQo1O6D02w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DU3PJZHd; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758097952; x=1789633952;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yK+fpi+YCg3Em7+WVxTKXNM3K9lgx/Xg+UOZdBCfGHg=;
  b=DU3PJZHdDd/pBMP03CW9ZmAFsWAICFE3gmktOg5uBdxgcsejuWv9AMoR
   X7J6LoKFkCReyxMyxV9JmOSYnGoTg/RIDKDxel4MG43pzqh/ZmCRX+Vut
   6hlcvEleO4H6tINm8XHzyFkImrtRD/mm8U4uDrwH4mW4+XCijoFrI8Thk
   acz7Sm0R1+IxU2A37VW0u9AEWtrYJgFjdB7PgELdTvR92yomxF77wjqx5
   9lDvWO8M+UYVOvmiXSiY//dMQr0M/kdNC/DjBWFPR726e6qDw26u/OLli
   eISz4mPyRHa7A2lUtJfa1XqHAAO1+D6g3Guf7vikaoYPYMx/bw8PIKiaz
   Q==;
X-CSE-ConnectionGUID: hRMt2ybqSYiM/i0f2Awndw==
X-CSE-MsgGUID: lgS4efPgTJmk+PR9uAyl/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="78003056"
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="78003056"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 01:32:31 -0700
X-CSE-ConnectionGUID: Tj0Lz4gmR0G9QfM760SH4w==
X-CSE-MsgGUID: 6iXjYK52See01YtvSp5v+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="206134021"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 01:32:28 -0700
Message-ID: <52cc9795-970e-4940-80d1-490daed636c4@linux.intel.com>
Date: Wed, 17 Sep 2025 16:32:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 16/41] KVM: VMX: Set up interception for CET MSRs
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-17-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250912232319.429659-17-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
>
> Enable/disable CET MSRs interception per associated feature configuration.
>
> Pass through CET MSRs that are managed by XSAVE, as they cannot be
> intercepted without also intercepting XSAVE. However, intercepting XSAVE
> would likely cause unacceptable performance overhead.
Here may be a bit confusing about the description of "managed by XSAVE" because
KVM has a function is_xstate_managed_msr(), and MSR_IA32_S_CET is not xstate
managed in it.

Otherwise,
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> MSR_IA32_INT_SSP_TAB is not managed by XSAVE, so it is intercepted.
>
> Note, this MSR design introduced an architectural limitation of SHSTK and
> IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
> to guest from architectural perspective since IBT relies on subset of SHSTK
> relevant MSRs.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4fc1dbba2eb0..adf5af30e537 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4101,6 +4101,8 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
>   
>   void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>   {
> +	bool intercept;
> +
>   	if (!cpu_has_vmx_msr_bitmap())
>   		return;
>   
> @@ -4146,6 +4148,23 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>   		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
>   					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
>   
> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> +		intercept = !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
> +
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, intercept);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, intercept);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, intercept);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, intercept);
> +	}
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) || kvm_cpu_cap_has(X86_FEATURE_IBT)) {
> +		intercept = !guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) &&
> +			    !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
> +
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET, MSR_TYPE_RW, intercept);
> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, intercept);
> +	}
> +
>   	/*
>   	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
>   	 * filtered by userspace.


