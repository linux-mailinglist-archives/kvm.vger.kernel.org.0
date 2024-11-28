Return-Path: <kvm+bounces-32717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 978B29DB1DB
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 04:24:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5ABB428250F
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 03:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 934FE12F399;
	Thu, 28 Nov 2024 03:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gpLkhLdC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE498126F0A;
	Thu, 28 Nov 2024 03:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732764245; cv=none; b=dSsy3miVJMUoE4XKBzKI2BOdtGfyt63Ssif5uZAlPhvCCIAQr+9Epe/465BOD2SyY2zJtI0Eb61HekK49ZSzvBAT/a+9YA7/lzWuCtnKmA97+FcNWtgshfoPX4/Gk+n8LtiXV0P0F2MigZ4HNZYNWouM8ouwW3ydSE4PKTitfk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732764245; c=relaxed/simple;
	bh=8oOZitgJdcH9/Dm4t/T1QgCesKBzEwPFfH0uoQ5CfcI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fKqJH4QxfolQclOPhfBCgH9TTB/wfgBShI1uSMTl3N0SKyHHS2G53kP1/cPwB14AX1J7cCMYj89k6ce2mszVpw6H0i2fb1y4LfaGh1feIFkj94PcHYCFuyrbx/EMGjaRYf8Rq90LNK89BlWdmjdZ67LS5uCdAB/LDV1s2vpFris=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gpLkhLdC; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732764244; x=1764300244;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8oOZitgJdcH9/Dm4t/T1QgCesKBzEwPFfH0uoQ5CfcI=;
  b=gpLkhLdCVehGLQovHKR26oYY4w9VLrS/JXuqGNq75cf0LB8fwLe6m1Ll
   o5UzloNIJ9UtmPzuUT8k5jQbMsyyzbmC8Llh0kUk/ICubh+aDFEeV1oAK
   e+iIln0a2+Vq1vFpCbOclxY/vUTGMqD3SuZO6NiyiUlFKKI0P6q24NXAU
   fsM0CjEh3ERQUQo3Ji016Bvv0L7kThtWgZPkpUmK4D4pzoC8HkJ3oIf9K
   77sQOb+LCIOuVUgFWq9TxMzBAqZz2gX6JWT9vhnOdzeZCnlF6O8VUnYYq
   uhZfe1a8D+i4UUsMh2nWsMAq53swn8xebAErr2R5WFN8uR1kHU8pX+bUE
   g==;
X-CSE-ConnectionGUID: P3TP1trQToGXcBFOwM46Gw==
X-CSE-MsgGUID: xhtlGgk2QkO5kHkQUI324w==
X-IronPort-AV: E=McAfee;i="6700,10204,11269"; a="55480560"
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="55480560"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 19:24:04 -0800
X-CSE-ConnectionGUID: KNVbFLKtSruAFp7sxXze3w==
X-CSE-MsgGUID: 2kSKPRIhSYiYZ28oagRcFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="97069322"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 19:23:59 -0800
Message-ID: <f60007d8-88b5-448c-b24b-5ad9abb6fa44@intel.com>
Date: Thu, 28 Nov 2024 11:23:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] KVM: x86: Move "emulate hypercall" function
 declarations to x86.h
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>, Binbin Wu
 <binbin.wu@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
 Kai Huang <kai.huang@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-4-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241128004344.4072099-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/28/2024 8:43 AM, Sean Christopherson wrote:
> Move the declarations for the hypercall emulation APIs to x86.h.  While
> the helpers are exported, they are intended to be consumed only KVM vendor
> modules, i.e. don't need to exposed to the kernel at-large.
> 
> No functional change intended.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 6 ------
>   arch/x86/kvm/x86.h              | 6 ++++++
>   2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e159e44a6a1b..c1251b371421 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2181,12 +2181,6 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
>   	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
>   }
>   
> -unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> -				      unsigned long a0, unsigned long a1,
> -				      unsigned long a2, unsigned long a3,
> -				      int op_64_bit, int cpl);
> -int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
> -
>   int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>   		       void *insn, int insn_len);
>   void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 45dd53284dbd..6db13b696468 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -617,4 +617,10 @@ static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
>   	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
>   }
>   
> +unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> +				      unsigned long a0, unsigned long a1,
> +				      unsigned long a2, unsigned long a3,
> +				      int op_64_bit, int cpl);
> +int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
> +
>   #endif


