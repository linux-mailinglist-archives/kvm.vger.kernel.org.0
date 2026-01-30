Return-Path: <kvm+bounces-69686-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uIDoH2RyfGmAMwIAu9opvQ
	(envelope-from <kvm+bounces-69686-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 09:57:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ABFEB8AAC
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 09:57:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B1E8230166C2
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 08:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B9A5346A10;
	Fri, 30 Jan 2026 08:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NOO3gDMw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E872DE71D;
	Fri, 30 Jan 2026 08:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769763401; cv=none; b=irAazvM0QPtYcDHfSd3YncBGrTZj2VMxpJSXP4q0ywS41qewt1/f8kr8Kpa+Yd4JRgEyVDzjz1wG5i6ipvhPWprVywwf4uK/qsZCD3a/u5HjfKcDqpPrmt0Z9P0ADLle0qQEvX3j0DMNLp3PaVofidfKk6ZeA/oXj8B726grJ6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769763401; c=relaxed/simple;
	bh=0dQWoLY8JRjnsMjhzFQxopb7sB2EafPM0ZYZJywq2HQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TdkzipZaMHpjSJ52Awef0ew6Eci1vf6AluT8WRq/xAlnlaZLFy9BuzUV4EHKjxm4EQ1zXIZ3vsjqVNjXNFtFAjbvYomMhDb5e4qw3oFh5v5IfQwpiPQikgv6olzwWo6K+QGgGIWw+8zSt3l8WHmcHg4N5XnkRix/bBFDdQFlF5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NOO3gDMw; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769763401; x=1801299401;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0dQWoLY8JRjnsMjhzFQxopb7sB2EafPM0ZYZJywq2HQ=;
  b=NOO3gDMwhI2LQSGyqQrcF4OFtfBmlejFdAbS/+KHCwaaNpjM3pxcQdvL
   Joo/jaQRSOFPbqmcho08eOzU8/4WWGQKU8VkA4ciwNC/OFjmN8LnlR8fn
   0rj7B9ts8ha5KoRdIjx/dWJDywpOdxhWMFSh6hVEyx/CiWoNcFPLfrpJl
   depNN65AJ6/FUeOGlDP2E5Kv/axpf4KtZttWmO8SsldbvlXsUBoHu+SYI
   NVTqzh+6OTGYX9Vgn6USFoWXVepGPYr+sR0A/Moc1+0unmZh7E7scX8oo
   kP1pdXnJeCps4YD/VNZM8jlZ7j6LdbeucOis7f1+KqAyBzCe0eMybfZx1
   g==;
X-CSE-ConnectionGUID: iSee0bQvS+yZuutGQ6DPkA==
X-CSE-MsgGUID: pI99Umx3ReWmMVAQddvKPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="70730918"
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="70730918"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 00:56:40 -0800
X-CSE-ConnectionGUID: AIWmFM7MQ4eU6qF3jsUnlw==
X-CSE-MsgGUID: Z0dvYg1eTRiNlag/RCzkJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="207932965"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 00:56:38 -0800
Message-ID: <c2982a9d-155c-4909-b492-8190604d9868@linux.intel.com>
Date: Fri, 30 Jan 2026 16:56:34 +0800
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69686-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.intel.com:mid,intel.com:email,intel.com:dkim,amd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2ABFEB8AAC
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
> 
> Note, kvm_caps.supported_{xcr0,xss} are unconditionally initialized by
> kvm_x86_vendor_init(), before calling into vendor code, and not referenced
> between ops->hardware_setup() and their current/old location.
> 

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

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


