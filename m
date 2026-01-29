Return-Path: <kvm+bounces-69517-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sG+eLXUPe2nqAwIAu9opvQ
	(envelope-from <kvm+bounces-69517-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 08:42:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E47C3ACDD8
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 08:42:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AC3163023430
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 537D437AA9D;
	Thu, 29 Jan 2026 07:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ezFCwAVQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CFD37AA75;
	Thu, 29 Jan 2026 07:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769672073; cv=none; b=NWIYA35ir/Pr6opMe0FdKnt1EvsFJGlZsRRUOjbKeVkiJXeVfRxOp6J6Uyz/4kc43bFF58ST7xHjDS1S8J2yR0R1SuK8Kq22g2xtnricfJ4tNqTapOv8FeEcN/a1pFYgu622C1Qb4rHq1BWx6PQQ09CDK2J3i6zVGr02Gq25AfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769672073; c=relaxed/simple;
	bh=fMAM2Ptbace67bnh+e9XNC7RXdmal+j6GaqUtBA5rXs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lQCYpllR9C6cbbti7wKLB/bIMiXB6Pvk+wLajhZKyw5KvO/7vwkhvhGgrvVs7FXMzy7QXxWJ/PyNHRZAFuYFg9eHgXaDb0ThRtCKSR24URPmkuoaPZULKDHf9J4uF5FzJO9JtlcIiQJkkbyQTQzvgLVKvA+Str9nAYWbVbcis/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ezFCwAVQ; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769672069; x=1801208069;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fMAM2Ptbace67bnh+e9XNC7RXdmal+j6GaqUtBA5rXs=;
  b=ezFCwAVQiig6BZj5//pF2xM8C+zf2V/h7iPcVbQuekr9QSQNEFvlweVc
   kTRx3M5xAILHNOp75HgCuKVYE2v+S2F3cZ9fmCLxA4/m8X+ICJWS7zTOZ
   gG+/F0YPQfsgKd68co1O9y0/yLRsPc0ely06vz0XnUZT4Zp4Ry58O7p3X
   YdYtl3woXU0oijykT2PNlkutUmbQRGW7jkv/3J/jCQPncQDRUhtF6VBB7
   k2wlRoSf4CszOAbEZbTGc2w+/7zQ0pF17hDi3L0PAfKDx82xbPN8gRsUH
   uzO8U78QbeeWIyehQN1bd4gdu04DHIMl0Ykqx0qmek3D3zeE8MUQWLg1E
   A==;
X-CSE-ConnectionGUID: phRscrShQj+dFXrra/U7Tg==
X-CSE-MsgGUID: EEQMzHSATE20iKZtePdZRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="70990631"
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="70990631"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 23:34:28 -0800
X-CSE-ConnectionGUID: uZyrDRk0S9adOGFeAmyzTg==
X-CSE-MsgGUID: QNymu16OQDWwgKmY9VlEZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="208737121"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.233]) ([10.124.240.233])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 23:34:25 -0800
Message-ID: <9856fb02-b72a-4626-b34a-16a7adb55fc6@linux.intel.com>
Date: Thu, 29 Jan 2026 15:34:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] KVM: x86: Explicitly configure supported XSS from
 {svm,vmx}_set_cpu_caps()
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mathias Krause <minipli@grsecurity.net>,
 John Allen <john.allen@amd.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Jim Mattson <jmattson@google.com>
References: <20260128014310.3255561-1-seanjc@google.com>
 <20260128014310.3255561-2-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260128014310.3255561-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69517-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[grsecurity.net:email,intel.com:email,intel.com:dkim,amd.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,linux.intel.com:mid]
X-Rspamd-Queue-Id: E47C3ACDD8
X-Rspamd-Action: no action



On 1/28/2026 9:43 AM, Sean Christopherson wrote:
> Explicitly configure KVM's supported XSS as part of each vendor's setup
> flow to fix a bug where clearing SHSTK and IBT in kvm_cpu_caps, e.g. due
> to lack of CET XFEATURE support, makes kvm-intel.ko unloadable when nested
> VMX is enabled, i.e. when nested=1.  The late clearing results in
> nested_vmx_setup_{entry,exit}_ctls() clearing VM_{ENTRY,EXIT}_LOAD_CET_STATE
> when nested_vmx_setup_ctls_msrs() runs during the CPU compatibility checks,
> ultimately leading to a mismatched VMCS config due to the reference config
> having the CET bits set, but every CPU's "local" config having the bits
> cleared.

A bit confuse about the description.

Before this patch:

kvm_x86_vendor_init
| vmx_hardware_setup
|   nested_vmx_hardware_setup
|     nested_vmx_setup_ctls_msrs
| ...
| for_each_online_cpu(cpu)
|   smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &r, 1)
|                                 | kvm_x86_check_processor_compatibility
|                                 |   kvm_x86_call(check_processor_compatibility)()
|                                 |     vmx_check_processor_compatibility
|                                 |       setup_vmcs_config
|                                 |         nested_vmx_setup_ctls_msrs
| ...
| //late clearing of SHSTK and IBT

If we don't consider CPU hotplug case, both the setup of reference VMCS and the
local config are before the late clearing of SHSTK and IBT. They should be
consistent.

So you are referring the mismatch situation during CPU hotplug?

But if it's hotplug case, it shouldn't make kvm-intel.ko unloadable?


> 
> Note, kvm_caps.supported_{xcr0,xss} are unconditionally initialized by
> kvm_x86_vendor_init(), before calling into vendor code, and not referenced
> between ops->hardware_setup() and their current/old location.
> 
> Fixes: 69cc3e886582 ("KVM: x86: Add XSS support for CET_KERNEL and CET_USER")
> Cc: stable@vger.kernel.org
> Cc: Mathias Krause <minipli@grsecurity.net>
> Cc: John Allen <john.allen@amd.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Chao Gao <chao.gao@intel.com>
> Cc: Binbin Wu <binbin.wu@linux.intel.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c |  2 ++
>  arch/x86/kvm/vmx/vmx.c |  2 ++
>  arch/x86/kvm/x86.c     | 30 +++++++++++++++++-------------
>  arch/x86/kvm/x86.h     |  2 ++
>  4 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7803d2781144..c00a696dacfc 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5387,6 +5387,8 @@ static __init void svm_set_cpu_caps(void)
>  	 */
>  	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
>  	kvm_cpu_cap_clear(X86_FEATURE_MSR_IMM);
> +
> +	kvm_setup_xss_caps();
>  }
>  
>  static __init int svm_hardware_setup(void)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 27acafd03381..9f85c3829890 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8230,6 +8230,8 @@ static __init void vmx_set_cpu_caps(void)
>  		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>  		kvm_cpu_cap_clear(X86_FEATURE_IBT);
>  	}
> +
> +	kvm_setup_xss_caps();
>  }
>  
>  static bool vmx_is_io_intercepted(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8acfdfc583a1..cac1d6a67b49 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9965,6 +9965,23 @@ static struct notifier_block pvclock_gtod_notifier = {
>  };
>  #endif
>  
> +void kvm_setup_xss_caps(void)
> +{
> +	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> +		kvm_caps.supported_xss = 0;
> +
> +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> +		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
> +
> +	if ((kvm_caps.supported_xss & XFEATURE_MASK_CET_ALL) != XFEATURE_MASK_CET_ALL) {
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
> +	}
> +}
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_setup_xss_caps);
> +
>  static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
>  {
>  	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
> @@ -10138,19 +10155,6 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	if (!tdp_enabled)
>  		kvm_caps.supported_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
>  
> -	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> -		kvm_caps.supported_xss = 0;
> -
> -	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> -	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> -		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
> -
> -	if ((kvm_caps.supported_xss & XFEATURE_MASK_CET_ALL) != XFEATURE_MASK_CET_ALL) {
> -		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> -		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> -		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
> -	}
> -
>  	if (kvm_caps.has_tsc_control) {
>  		/*
>  		 * Make sure the user can only configure tsc_khz values that
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 70e81f008030..94d4f07aaaa0 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -483,6 +483,8 @@ extern struct kvm_host_values kvm_host;
>  extern bool enable_pmu;
>  extern bool enable_mediated_pmu;
>  
> +void kvm_setup_xss_caps(void);
> +
>  /*
>   * Get a filtered version of KVM's supported XCR0 that strips out dynamic
>   * features for which the current process doesn't (yet) have permission to use.


