Return-Path: <kvm+bounces-69687-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eIleJwFzfGmAMwIAu9opvQ
	(envelope-from <kvm+bounces-69687-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 09:59:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 09DCDB8ACD
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 09:59:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 744E7301484A
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 08:59:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D6A346E75;
	Fri, 30 Jan 2026 08:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k1AD1xHd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6456918A6D4;
	Fri, 30 Jan 2026 08:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769763578; cv=none; b=A0gx+j5aitGS3rxXoFpHEoPSoXSuq0h8NCx9hXz5KCzAJXVFJUUjxhhCLmzmEw2hsM3ml3lG3SA8ldHXj57Kr/R+gfH4uwAzrGuWizzyL1QgqtJYoiYUGtJngtdfl5Pb+m35A74JrP9g+tAIOfLOVzer/ABH+twAySUiW1D5Cq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769763578; c=relaxed/simple;
	bh=oNJRvp6gSJTomQlpvqH9I/ZhJfQzNojwK75SzxOQABQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b+XSa+LsVOgiAilzXxVk2uQlqbEqOiLHFSAbMW6Fykj9oLNAsO3ac7/jMFA3gU/ZJPJfH/9AV93BhcE0PkAJUnEAAuZ9PhzXObByhUQpCx4DC7LgUMDErbwHMOiGjYeYRK7Jbq/c4s8J/QM/zPKeKByPjLTv2llJ0bPcU7dM9xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k1AD1xHd; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769763578; x=1801299578;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oNJRvp6gSJTomQlpvqH9I/ZhJfQzNojwK75SzxOQABQ=;
  b=k1AD1xHdnQBlJtUGJu7HSMggd+Z1hBjeY9/rFYyv9afpyP9zdoPotba1
   K0zfT24s58wUYdNuMkhZJbfHSZL5UzhX9PdWtJDiraMs+6HZFZ7h9Usqi
   DeAIvJlrifwYO9ssjqkU2/3FoRqrt9XBTHozhc05O1G8kTOXLaVBxUwg6
   UULFp8Fzb5PxZOZxuWoUAO0jObF5AHO304vTtBQEVrifSfksC5AQQ8jyc
   iBqCizYE8U5ff9lUCDiKdxPyaYE55esG/BuHm1H9OOUDcgEBuA0Lx+JBX
   9LTUupMBA8ufhFklQK4Qh2I18hlO61QTqtfy2TZIFRlCUasw0e1pq36+q
   g==;
X-CSE-ConnectionGUID: dikoRg1TRn2F7AYxgaC4CQ==
X-CSE-MsgGUID: sC4XQUfTTJqlAZvGGohQ6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="70731204"
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="70731204"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 00:59:37 -0800
X-CSE-ConnectionGUID: VeRaHbPWSs2I8KLfmoZdUQ==
X-CSE-MsgGUID: O6Kn1MIOT7ef2RzJmNU93w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="207933207"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 00:59:31 -0800
Message-ID: <a6028500-167a-4900-8ed4-e3d7851969e4@linux.intel.com>
Date: Fri, 30 Jan 2026 16:59:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] KVM: x86: Harden against unexpected adjustments to
 kvm_cpu_caps
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mathias Krause <minipli@grsecurity.net>,
 John Allen <john.allen@amd.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Jim Mattson <jmattson@google.com>
References: <20260128014310.3255561-1-seanjc@google.com>
 <20260128014310.3255561-3-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260128014310.3255561-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69687-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.intel.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: 09DCDB8ACD
X-Rspamd-Action: no action



On 1/28/2026 9:43 AM, Sean Christopherson wrote:
> Add a flag to track when KVM is actively configuring its CPU caps, and
> WARN if a cap is set or cleared if KVM isn't in its configuration stage.
> Modifying CPU caps after {svm,vmx}_set_cpu_caps() can be fatal to KVM, as
> vendor setup code expects the CPU caps to be frozen at that point, e.g.
> will do additional configuration based on the caps.
> 
> Rename kvm_set_cpu_caps() to kvm_initialize_cpu_caps() to pair with the
> new "finalize", and to make it more obvious that KVM's CPU caps aren't
> fully configured within the function.
> 

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c   | 10 ++++++++--
>  arch/x86/kvm/cpuid.h   | 12 +++++++++++-
>  arch/x86/kvm/svm/svm.c |  4 +++-
>  arch/x86/kvm/vmx/vmx.c |  4 +++-
>  4 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 575244af9c9f..7fe4e58a6ebf 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -36,6 +36,9 @@
>  u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_cpu_caps);
>  
> +bool kvm_is_configuring_cpu_caps __read_mostly;
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_is_configuring_cpu_caps);
> +
>  struct cpuid_xstate_sizes {
>  	u32 eax;
>  	u32 ebx;
> @@ -826,10 +829,13 @@ do {									\
>  /* DS is defined by ptrace-abi.h on 32-bit builds. */
>  #undef DS
>  
> -void kvm_set_cpu_caps(void)
> +void kvm_initialize_cpu_caps(void)
>  {
>  	memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));
>  
> +	WARN_ON_ONCE(kvm_is_configuring_cpu_caps);
> +	kvm_is_configuring_cpu_caps = true;
> +
>  	BUILD_BUG_ON(sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)) >
>  		     sizeof(boot_cpu_data.x86_capability));
>  
> @@ -1289,7 +1295,7 @@ void kvm_set_cpu_caps(void)
>  		kvm_cpu_cap_clear(X86_FEATURE_RDPID);
>  	}
>  }
> -EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_cpu_caps);
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_initialize_cpu_caps);
>  
>  #undef F
>  #undef SCATTERED_F
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index d3f5ae15a7ca..039b8e6f40ba 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -8,7 +8,15 @@
>  #include <uapi/asm/kvm_para.h>
>  
>  extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
> -void kvm_set_cpu_caps(void);
> +extern bool kvm_is_configuring_cpu_caps __read_mostly;
> +
> +void kvm_initialize_cpu_caps(void);
> +
> +static inline void kvm_finalize_cpu_caps(void)
> +{
> +	WARN_ON_ONCE(!kvm_is_configuring_cpu_caps);
> +	kvm_is_configuring_cpu_caps = false;
> +}
>  
>  void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
>  struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(struct kvm_cpuid_entry2 *entries,
> @@ -188,6 +196,7 @@ static __always_inline void kvm_cpu_cap_clear(unsigned int x86_feature)
>  {
>  	unsigned int x86_leaf = __feature_leaf(x86_feature);
>  
> +	WARN_ON_ONCE(!kvm_is_configuring_cpu_caps);
>  	kvm_cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
>  }
>  
> @@ -195,6 +204,7 @@ static __always_inline void kvm_cpu_cap_set(unsigned int x86_feature)
>  {
>  	unsigned int x86_leaf = __feature_leaf(x86_feature);
>  
> +	WARN_ON_ONCE(!kvm_is_configuring_cpu_caps);
>  	kvm_cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
>  }
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c00a696dacfc..5f0136dbdde6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5305,7 +5305,7 @@ static __init void svm_adjust_mmio_mask(void)
>  
>  static __init void svm_set_cpu_caps(void)
>  {
> -	kvm_set_cpu_caps();
> +	kvm_initialize_cpu_caps();
>  
>  	kvm_caps.supported_perf_cap = 0;
>  
> @@ -5389,6 +5389,8 @@ static __init void svm_set_cpu_caps(void)
>  	kvm_cpu_cap_clear(X86_FEATURE_MSR_IMM);
>  
>  	kvm_setup_xss_caps();
> +
> +	kvm_finalize_cpu_caps();
>  }
>  
>  static __init int svm_hardware_setup(void)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9f85c3829890..93ec1e6181e4 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8173,7 +8173,7 @@ static __init u64 vmx_get_perf_capabilities(void)
>  
>  static __init void vmx_set_cpu_caps(void)
>  {
> -	kvm_set_cpu_caps();
> +	kvm_initialize_cpu_caps();
>  
>  	/* CPUID 0x1 */
>  	if (nested)
> @@ -8232,6 +8232,8 @@ static __init void vmx_set_cpu_caps(void)
>  	}
>  
>  	kvm_setup_xss_caps();
> +
> +	kvm_finalize_cpu_caps();
>  }
>  
>  static bool vmx_is_io_intercepted(struct kvm_vcpu *vcpu,


