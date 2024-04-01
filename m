Return-Path: <kvm+bounces-13260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4233089382B
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 08:01:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B06BB281943
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 06:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4EBA8F7A;
	Mon,  1 Apr 2024 06:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ewo7Chvp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9CB8F44;
	Mon,  1 Apr 2024 06:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711951253; cv=none; b=vGwOspbYb/YVV/GHmypZnWteBfd9qgW25AAaXq1eDh+JfEspH4kbJsi13IfANF21/Mcxp4+o3fFM4/95lumwkQ5t8tyBhpJWkl7tFlVNAUb2ikDovLpTqtUyRsPHqISkVI7w6K4YHc1abNa+LOhr+7hp/qFvhrYNQgMQXEXpX4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711951253; c=relaxed/simple;
	bh=vN4Xt0Wi8wvR6CuyiTLuOstOetSx95WHL6i9bBHaWkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g/j9m6oEiJiikG2FESpenFRdG0n2aIr8OHYdIlPZpZykP7LhDYhvzds7yQ8Zbt+FQXMEuqg9TQqXqoZbYmPQmChj8EWJk4AnQOwccEfFcjJSxDYiowJwuSUvi+CAQaBUmaePTsw92QaOlWqePCNjUE7HMIsHPwwHCEK9TV7F2nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ewo7Chvp; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711951251; x=1743487251;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vN4Xt0Wi8wvR6CuyiTLuOstOetSx95WHL6i9bBHaWkI=;
  b=Ewo7ChvpZQnV4RfnaphX/gjCSita/47shJYji7wL9ZMl8Pc/wTqAOfaz
   K87LVM0WgBXsl6TV+ogtOy6+gX4PgtejvtTB+wNpqloM3LJkbR87hDH6K
   YU57C0MA3dTsNXY6PFw+uIaFB+kQgqRk+R/ZlNJVsnrGKsrU4fy/2MgPJ
   YraXXJTOp9SILGVMns1RDn3AdShp8mCwkHeP9wq2KXanNfnc7sU2ewdkF
   5mLYbw50/1OwgwmaH+wUCFoK9yIFguZXfbf98Ttl84vCqCTBg7H5oDf76
   CoZTwBbS9pCfJte/RLpTCM3quwMwB548/3H5vlZYmQE4qr+0d3TwDcvfH
   A==;
X-CSE-ConnectionGUID: JN++k4l9Ql6PV1A00+x14w==
X-CSE-MsgGUID: HA+55pWsRx6Wxt8pft2Cpw==
X-IronPort-AV: E=McAfee;i="6600,9927,11030"; a="17636903"
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="17636903"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2024 23:00:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="18009099"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2024 23:00:25 -0700
Message-ID: <b0a3ebe8-c69e-47f7-9dcd-021d60c36111@intel.com>
Date: Mon, 1 Apr 2024 14:00:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/9] KVM: x86: Stuff vCPU's PAT with default value at
 RESET, not creation
To: Sean Christopherson <seanjc@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xin Li <xin3.li@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
 <20240309012725.1409949-4-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240309012725.1409949-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/9/2024 9:27 AM, Sean Christopherson wrote:
> Move the stuffing of the vCPU's PAT to the architectural "default" value
> from kvm_arch_vcpu_create() to kvm_vcpu_reset(), guarded by !init_event,
> to better capture that the default value is the value "Following Power-up
> or Reset".  E.g. setting PAT only during creation would break if KVM were
> to expose a RESET ioctl() to userspace (which is unlikely, but that's not
> a good reason to have unintuitive code).
> 
> No functional change.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/x86.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 66c4381460dc..eac97b1b8379 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12134,8 +12134,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
>   	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
>   
> -	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
> -
>   	kvm_async_pf_hash_reset(vcpu);
>   
>   	vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
> @@ -12302,6 +12300,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	if (!init_event) {
>   		vcpu->arch.smbase = 0x30000;
>   
> +		vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
> +
>   		vcpu->arch.msr_misc_features_enables = 0;
>   		vcpu->arch.ia32_misc_enable_msr = MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL |
>   						  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL;


