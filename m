Return-Path: <kvm+bounces-58361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38423B8F4CB
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 09:31:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AB3B3B01DF
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 07:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26E582F5A3F;
	Mon, 22 Sep 2025 07:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gHjmUyjD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821C72DA755;
	Mon, 22 Sep 2025 07:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758526303; cv=none; b=hFvG+txaYuPLVK2yEryn8kdQN3dhtNVkkY7c413vFNBg4xvI3XcdTjIfWSTEq8d9hFXh+9Njuk5BjIM4adQf5OxdlSPt+lIczLNWpxd8Riv1yCVQLFLUFHm4o0ouJJup4uqUTB+EFCVGfpYx5m235cP/WyyD9K+/exep+lxiUV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758526303; c=relaxed/simple;
	bh=2zXwsAvFZkIWX22XaZ31IeMWHmWvxUAHMvVhmsGWwo8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fsfnvXRbJ4WK1wIRIGcyA8x7XZKvbVNsynX1PUct0PbjihaxOUAbqSofLF26ko/zQo4U8W2+QZTEV7c0ljXjEP/oLshYFHkE9R+oGSim5dwwZZIjYG4qmR6hqYybOGJlQMX5P26igrE2Y25NSFdXIWTQrsShU8hdIIhQNlqQ+w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gHjmUyjD; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758526302; x=1790062302;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2zXwsAvFZkIWX22XaZ31IeMWHmWvxUAHMvVhmsGWwo8=;
  b=gHjmUyjDl36lv83oa7As003IjPyiYzqdJ4Y1VhuKhVQkPA2/cvPc3UOg
   ea6OJnpP1WOfDYKTGRSJ4Bsa0z4ozxB4mXslZ8dgRPkhiIsK7IGaNUAXn
   8fonzfoD8EBYThyp44PC32gm37xOsAZAKw7ZDdgIuK3qbYHdofKeRujdT
   SxanKTTvR36GScBc9rq+TSsTK8r/p95fWaRwBAPhyYZBAMoNi33ghjmud
   HBr+xtCI2oNBBkmw16S65+X32zSo/oXjn8VTeSRiDKcWfUkDbgnHR6PxO
   xvMZSJqSXIxj5SVYPcMARAE29pNkHN95zdx6LU7SPXVt/Nj2iLoD4Lu9L
   A==;
X-CSE-ConnectionGUID: etyXoZwsRLOQMPwGhw7Wew==
X-CSE-MsgGUID: aEzVUDNZRvO3efGgh8T6NA==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="59820734"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="59820734"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 00:31:41 -0700
X-CSE-ConnectionGUID: HOhqTXWIRXaLIunMmzA9zQ==
X-CSE-MsgGUID: nchSdi7bQVmC+UYXVIS4YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="176320293"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 00:31:38 -0700
Message-ID: <bebd47e3-2434-4b0d-953e-166150decdec@linux.intel.com>
Date: Mon, 22 Sep 2025 15:31:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 25/51] KVM: x86: Add XSS support for CET_KERNEL and
 CET_USER
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-26-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-26-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
>
> Add CET_KERNEL and CET_USER to KVM's set of supported XSS bits when IBT
> *or* SHSTK is supported.  Like CR4.CET, XFEATURE support for IBT and SHSTK
> are bundle together under the CET umbrella, and thus prone to
> virtualization holes if KVM or the guest supports only one of IBT or SHSTK,
> but hardware supports both.  However, again like CR4.CET, such
> virtualization holes are benign from the host's perspective so long as KVM
> takes care to always honor the "or" logic.
>
> Require CET_KERNEL and CET_USER to come as a pair, and refuse to support
> IBT or SHSTK if one (or both) features is missing, as the (host) kernel
> expects them to come as a pair, i.e. may get confused and corrupt state if
> only one of CET_KERNEL or CET_USER is supported.
>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> [sean: split to separate patch, write changelog, add XFEATURE_MASK_CET_ALL]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/x86.c | 18 +++++++++++++++---
>   1 file changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 40596fc5142e..4a0ff0403bb2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -220,13 +220,14 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>   				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>   				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>   
> +#define XFEATURE_MASK_CET_ALL	(XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)
>   /*
>    * Note, KVM supports exposing PT to the guest, but does not support context
>    * switching PT via XSTATE (KVM's PT virtualization relies on perf; swapping
>    * PT via guest XSTATE would clobber perf state), i.e. KVM doesn't support
>    * IA32_XSS[bit 8] (guests can/must use RDMSR/WRMSR to save/restore PT MSRs).
>    */
> -#define KVM_SUPPORTED_XSS     0
> +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_ALL)
>   
>   bool __read_mostly allow_smaller_maxphyaddr = 0;
>   EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
> @@ -10104,6 +10105,16 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>   	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>   		kvm_caps.supported_xss = 0;
>   
> +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> +		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
> +
> +	if ((kvm_caps.supported_xss & XFEATURE_MASK_CET_ALL) != XFEATURE_MASK_CET_ALL) {
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
> +	}
> +
>   	if (kvm_caps.has_tsc_control) {
>   		/*
>   		 * Make sure the user can only configure tsc_khz values that
> @@ -12775,10 +12786,11 @@ static void kvm_xstate_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	/*
>   	 * On INIT, only select XSTATE components are zeroed, most components
>   	 * are unchanged.  Currently, the only components that are zeroed and
> -	 * supported by KVM are MPX related.
> +	 * supported by KVM are MPX and CET related.
>   	 */
>   	xfeatures_mask = (kvm_caps.supported_xcr0 | kvm_caps.supported_xss) &
> -			 (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
> +			 (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR |
> +			  XFEATURE_MASK_CET_ALL);
>   	if (!xfeatures_mask)
>   		return;
>   


