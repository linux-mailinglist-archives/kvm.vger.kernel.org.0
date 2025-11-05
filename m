Return-Path: <kvm+bounces-62050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08938C3525F
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 11:42:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60079562E12
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 10:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528D43054F7;
	Wed,  5 Nov 2025 10:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LiPDoa+d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E77304BD4;
	Wed,  5 Nov 2025 10:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762339330; cv=none; b=Tm4oBw+Lq0QkYf2XnCDL0wik1oHRD+/NusU4t6SsVgqyGtZD0WI4BGMGZhPoyK9Fmrv2ApphKZlARwGf35gjanwcEoENitQEnqO8s0c+wSVZCFBwaaBtiQ2ZCzxqDQA3o0ptiRxFwdow7qLZkofZr968pLvDFtaE4bgwl61wVXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762339330; c=relaxed/simple;
	bh=1ViRHw8lx988HaKq8748rY8eBv1qH6oDXHX338eSFtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oRDyma0fa6/8uon6gqjdxOmwmoe+sIjSIaVSo1cr+8DzlcBHnI7BbT+2BPRCDOUriT67vrfU01eZ6OY6epuYPhLw4bafeDN513re2v6YqsXn4R4ReDmROu6XKUBmonT13WmW3+bSjL4L3uYpzDtmbf+k2miarfAChA48LUsWoVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LiPDoa+d; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762339329; x=1793875329;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1ViRHw8lx988HaKq8748rY8eBv1qH6oDXHX338eSFtQ=;
  b=LiPDoa+dXu1mWf9v6XBpNmmN1O0pTAnJyJLZ8cVs0cawL+vVjKYaiI+I
   3DBc/BUIglQIX6z9cgz/A40vHLUjjZOqYl+39vqr5OeFvIJnkT0M11GmX
   QQGg2wGbQiH4lepJjIlB6f1JdHQIGUHPMsRRS0gT8P+9fPpxeqe2kVCzQ
   qgk0h4pIxXEitpE5GzjMfPQA4fmyxs1H2yjk7o5IFeVHeBgzC3K9llOD/
   Sonr7B5Zx5UXxTSQcQHOzdnXfRirghbfccaadedhp4C+dQ5TaVekaRLB9
   Hz4HDixVY1dnKc3UglPLXAtTauhwX2bbWpCQc2IIxKCTBworppCGjyWcw
   w==;
X-CSE-ConnectionGUID: dsEmGMWMQFOWFWUdV8/j7Q==
X-CSE-MsgGUID: Q7T/VMsoSEK+NfjKPOvxnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="64145557"
X-IronPort-AV: E=Sophos;i="6.19,281,1754982000"; 
   d="scan'208";a="64145557"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 02:42:09 -0800
X-CSE-ConnectionGUID: IgVkqlvMQd6bQciLaUzw0g==
X-CSE-MsgGUID: WXzQ1lwKRUOpBcGYcCeFWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,281,1754982000"; 
   d="scan'208";a="188147446"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 02:42:07 -0800
Message-ID: <88404ae2-fa4b-4357-918b-fd949dd2521a@linux.intel.com>
Date: Wed, 5 Nov 2025 18:42:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] KVM: x86: Load guest/host XCR0 and XSS outside of the
 fastpath run loop
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jon Kohler <jon@nutanix.com>
References: <20251030224246.3456492-1-seanjc@google.com>
 <20251030224246.3456492-4-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030224246.3456492-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/31/2025 6:42 AM, Sean Christopherson wrote:
[...]
>   
> -void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
> +static void kvm_load_guest_xfeatures(struct kvm_vcpu *vcpu)
>   {
>   	if (vcpu->arch.guest_state_protected)
>   		return;
>   
>   	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
> -
>   		if (vcpu->arch.xcr0 != kvm_host.xcr0)
>   			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
>   
> @@ -1217,6 +1216,27 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>   		    vcpu->arch.ia32_xss != kvm_host.xss)
>   			wrmsrq(MSR_IA32_XSS, vcpu->arch.ia32_xss);
>   	}
> +}
> +
> +static void kvm_load_host_xfeatures(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu->arch.guest_state_protected)
> +		return;
> +
> +	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
> +		if (vcpu->arch.xcr0 != kvm_host.xcr0)
> +			xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
> +
> +		if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
> +		    vcpu->arch.ia32_xss != kvm_host.xss)
> +			wrmsrq(MSR_IA32_XSS, kvm_host.xss);
> +	}
> +}

kvm_load_guest_xfeatures() and kvm_load_host_xfeatures() are almost the same
except for the guest values VS. host values to set.
I am wondering if it is worth adding a helper to dedup the code, like:

static void kvm_load_xfeatures(struct kvm_vcpu *vcpu, u64 xcr0, u64 xss)
{
         if (vcpu->arch.guest_state_protected)
                 return;

         if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
                 if (vcpu->arch.xcr0 != kvm_host.xcr0)
                         xsetbv(XCR_XFEATURE_ENABLED_MASK, xcr0);

                 if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
                     vcpu->arch.ia32_xss != kvm_host.xss)
                         wrmsrq(MSR_IA32_XSS, xss);
         }
}



