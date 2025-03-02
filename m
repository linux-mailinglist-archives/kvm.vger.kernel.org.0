Return-Path: <kvm+bounces-39816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4397AA4B3B4
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 18:11:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 728EC7A3287
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 17:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9630F1EB1B5;
	Sun,  2 Mar 2025 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j7RueSmB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D196078F47;
	Sun,  2 Mar 2025 17:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740935484; cv=none; b=RTe0JWtdvOiMvoQjlQoa2CLvIY/2uxprVzk1248H1QhP2Yok3/6yi9YwU9c0aX8/vaMe7olznG//11sNAruBauF25lh6VH8A1h9x9QDv5tdgROcIMZO/Va7pnJ1gfHdvZhsPf3JHicjFrG4O1IKytzpNpPGhQi1tS81tRUMYypQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740935484; c=relaxed/simple;
	bh=cY56oMVd5StSHs5W6r0N1+BxcX+XDxS56uxaCqQRrYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fmk6Sd+qxH/0giV1OGGG8TzXf39TYUY6OEKzItbERRLHEYuLGzvb+AHCCWUpCN8Op3rWvot422ywmcrVTKM27els6hauov5uE1XDh1+KIPRq40EML8+8CRdgVixNExTtIRjK51z9wie4keGbeUL0A7eIPYbGbSvviAzU5cAlM5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j7RueSmB; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740935484; x=1772471484;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cY56oMVd5StSHs5W6r0N1+BxcX+XDxS56uxaCqQRrYY=;
  b=j7RueSmBS6u73N1hE/9yX/cwQ2jyolkg7bs7frkBvmBrMC9qnGPB8hCr
   5GamsV2IQ2IPw6LemzN2YFQJSz3MXR7LxuIK9xpgQ1mcPF2Fo/gzGrQeP
   pqSDq2+Uzlquws7gcgYnaM4UVt0yKwfgpQu3uqP17QpH/idyNnx6Qt6Rs
   jveOsjJWDNzX1Y8uflpIKHUjvvLKS5NLdwyKeJ6FOCrvgKa2bz6m07B6a
   IkUofRAmOozIJ6rNN2XWUsScQ3oZzu9skO/TLoh4WTMPNHPL3zzS4Hx+r
   n8TMbWXQNLv9QyKqzeRDDG7TUwhGJQU/aZ3TxZXbYL0TN6VwKi6eErOLq
   g==;
X-CSE-ConnectionGUID: XaiEK7pNQK+kTzfr5UdwQw==
X-CSE-MsgGUID: gSK5/j5GS2Sh9ZzsGiwUSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="41840466"
X-IronPort-AV: E=Sophos;i="6.13,327,1732608000"; 
   d="scan'208";a="41840466"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 09:11:23 -0800
X-CSE-ConnectionGUID: 1dhRHMAhRBOzCxMHB0c9MA==
X-CSE-MsgGUID: SVee1Z+KQxSQHnWrEj5iSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,327,1732608000"; 
   d="scan'208";a="117822215"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 09:11:20 -0800
Message-ID: <e6a4f4a2-f635-40a4-912c-6ecd5490099f@intel.com>
Date: Mon, 3 Mar 2025 01:11:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] KVM: x86: Allow vendor code to disable quirks
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, yan.y.zhao@intel.com
References: <20250301073428.2435768-1-pbonzini@redhat.com>
 <20250301073428.2435768-2-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250301073428.2435768-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/2025 3:34 PM, Paolo Bonzini wrote:
> In some cases, the handling of quirks is split between platform-specific
> code and generic code, or it is done entirely in generic code, but the
> relevant bug does not trigger on some platforms; for example,
> KVM_X86_QUIRK_CD_NW_CLEARED is only applicable to AMD systems.  In that
> case, allow unaffected vendor modules to disable handling of the quirk.
> 
> The quirk remains available in KVM_CAP_DISABLE_QUIRKS2, because that API
> tells userspace that KVM *knows* that some of its past behavior was bogus
> or just undesirable.  In other words, it's plausible for userspace to
> refuse to run if a quirk is not listed by KVM_CAP_DISABLE_QUIRKS2.

I think it's just for existing quirks for backwards compatibilities 
reason. For new quirk bit that is vendor specific, 
KVM_CAP_DISABLE_QUIRKS2 is OK to enumerate different value.

> In kvm_check_has_quirk(), in addition to checking if a quirk is not
> explicitly disabled by the user, also verify if the quirk applies to
> the hardware.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

This is inconsistent with the Author.

> Message-ID: <20250224070832.31394-1-yan.y.zhao@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/vmx.c |  1 +
>   arch/x86/kvm/x86.c     |  1 +
>   arch/x86/kvm/x86.h     | 12 +++++++-----
>   3 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 486fbdb4365c..75df4caea2f7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8506,6 +8506,7 @@ __init int vmx_hardware_setup(void)
>   
>   	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
>   
> +	kvm_caps.inapplicable_quirks = KVM_X86_QUIRK_CD_NW_CLEARED;

Suggest to make inapplicable_quirks per VM, as I comments in patch 4:

https://lore.kernel.org/all/338901b6-4d10-480d-bd0a-0db8ec4afad5@intel.com/https://lore.kernel.org/all/338901b6-4d10-480d-bd0a-0db8ec4afad5@intel.com/

>   	return r;
>   }
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 856ceeb4fb35..fd0a44e59314 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9775,6 +9775,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>   		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
>   		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
>   	}
> +	kvm_caps.inapplicable_quirks = 0;
>   
>   	rdmsrl_safe(MSR_EFER, &kvm_host.efer);
>   
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 8ce6da98b5a2..9af199c8e5c8 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -34,6 +34,7 @@ struct kvm_caps {
>   	u64 supported_xcr0;
>   	u64 supported_xss;
>   	u64 supported_perf_cap;
> +	u64 inapplicable_quirks;
>   };
>   
>   struct kvm_host_values {
> @@ -354,11 +355,6 @@ static inline void kvm_register_write(struct kvm_vcpu *vcpu,
>   	return kvm_register_write_raw(vcpu, reg, val);
>   }
>   
> -static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
> -{
> -	return !(kvm->arch.disabled_quirks & quirk);
> -}
> -
>   void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
>   
>   u64 get_kvmclock_ns(struct kvm *kvm);
> @@ -394,6 +390,12 @@ extern struct kvm_host_values kvm_host;
>   
>   extern bool enable_pmu;
>   
> +static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
> +{
> +	u64 disabled_quirks = kvm_caps.inapplicable_quirks | kvm->arch.disabled_quirks;
> +	return !(disabled_quirks & quirk);
> +}
> +
>   /*
>    * Get a filtered version of KVM's supported XCR0 that strips out dynamic
>    * features for which the current process doesn't (yet) have permission to use.


