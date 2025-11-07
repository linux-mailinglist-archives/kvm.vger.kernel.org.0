Return-Path: <kvm+bounces-62267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C8C5FC3E711
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 05:21:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 42B344E3DFA
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 04:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5E91269B1C;
	Fri,  7 Nov 2025 04:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OHb31Pyz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8381E5205;
	Fri,  7 Nov 2025 04:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762489302; cv=none; b=OawhBHlQIFQZSzcMn39U+LwICyE3Hq66Ozx8gGZ2YbmoAQlJm8MAY7B+6lfvxO97YHEFMpo4l7QuKx9s3ESucDtyWNuL94dXZB52/84cjTFbHi6hvwX/kxyKRgS5gVRmJ0wsuV7XmmS7TVkudtF6Jn8W6oSO88+3gRXyLBt2Loc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762489302; c=relaxed/simple;
	bh=dZoLS+7V1h/k1eViXOZOBE1tBLiJPUsDAgsuaRt2Bt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YAKh+EWEUdmuOlZogi0Ce2uJhkF9tf5GhISTRQsXTe6tI9F0m5hsZWdIrdkWbo0Gyz9MXsVCCbRp30SvfiwTt49gnigq7PubRjBVBtSr5M83lRmAvYtY8vOo5JXFjLqWZzaZA9KYTUQBe+YCUHahzqBLGBx/BgCtOqVGU2gTGPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OHb31Pyz; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762489300; x=1794025300;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dZoLS+7V1h/k1eViXOZOBE1tBLiJPUsDAgsuaRt2Bt8=;
  b=OHb31PyzGtz8KPdoL7FwD7OAAZU3WXuRR3LN4qMx5K6DZGMv/FRjJRzC
   FFJh29NPH3dUnOZ1/21zW/FgKJ+k2fGhQMRC4cLQHi5AHlv8uzRPaU6Wu
   G+1Hrn4TG9SuKWc8EaYixjE3Anq2HIMscXhZBaqC1P/86laFYrskfgufU
   uLf/C4NuhgQCoMnL/Cc7IF3qjUTyNyJyD2vw/TZzTqNpSnvNgY9lLTih4
   PJZuQNrpRlBBo4nh62Yud9YEibkF8kXGd9cMzPRw3HIJZcV4M9JQKWHZU
   cnVWvxQkcd5ON7I0sdY3GJyYapDpbFKdrowWUIWYDcS89ag71k4S6Fp00
   A==;
X-CSE-ConnectionGUID: GHcTq23tSYKO90IUAdtg4w==
X-CSE-MsgGUID: 1y7V2A6JRLCiLSp42kxMrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11605"; a="75990516"
X-IronPort-AV: E=Sophos;i="6.19,285,1754982000"; 
   d="scan'208";a="75990516"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 20:21:39 -0800
X-CSE-ConnectionGUID: 3PFtc6aMRMCaFogMpBTC8A==
X-CSE-MsgGUID: X8qcnzcQRiOEnX5XHSJXCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,285,1754982000"; 
   d="scan'208";a="211387851"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 20:21:37 -0800
Message-ID: <599eb00e-a034-4809-8f5a-893597016133@linux.intel.com>
Date: Fri, 7 Nov 2025 12:21:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Add a help to dedup loading guest/host XCR0 and
 XSS
To: Chao Gao <chao.gao@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251106101138.2756175-1-binbin.wu@linux.intel.com>
 <aQ1kG5u8GPdEwoEy@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aQ1kG5u8GPdEwoEy@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/7/2025 11:14 AM, Chao Gao wrote:
> s/help/helper in the subject.
>
> On Thu, Nov 06, 2025 at 06:11:38PM +0800, Binbin Wu wrote:
>> Add and use a helper, kvm_load_xfeatures(), to dedup the code that loads
>> guest/host xfeatures by passing XCR0 and XSS values accordingly.
>>
>> No functional change intended.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
>
> <snip>
>
>> @@ -11406,7 +11391,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>> 	vcpu->mode = OUTSIDE_GUEST_MODE;
>> 	smp_wmb();
>>
>> -	kvm_load_host_xfeatures(vcpu);
>> +	kvm_load_xfeatures(vcpu, kvm_host.xcr0, kvm_host.xss);
> Nit: given that xcr0/xss are either guest or host values, would it be slightly
> better for this helper to accept a boolean (e.g., bool load_guest) to convey
> that the API loads guest (or host) values rather than arbitrary xcr0/xss
> values? like fpu_swap_kvm_fpstate().

Make sense.

>
> static void kvm_load_xfeatures(struct kvm_vcpu *vcpu, bool load_guest)
> {
> 	u64 xcr0 = load_guest ? vcpu->arch.xcr0 : kvm_host.xcr0;
> 	u64 xss  = load_guest ? vcpu->arch.ia32_xss : kvm_host.xss;

Since they are only used once, I even want to open code them as:

static void kvm_load_xfeatures(struct kvm_vcpu *vcpu, bool load_guest)
{
         if (vcpu->arch.guest_state_protected)
                 return;

         if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
                 if (vcpu->arch.xcr0 != kvm_host.xcr0)
                         xsetbv(XCR_XFEATURE_ENABLED_MASK,
                                load_guest ? vcpu->arch.xcr0 : kvm_host.xcr0);

                 if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
                     vcpu->arch.ia32_xss != kvm_host.xss)
                         wrmsrq(MSR_IA32_XSS,
                                load_guest ? vcpu->arch.ia32_xss : kvm_host.xss);
         }
}

>
> 	if (vcpu->arch.guest_state_protected)
> 		return;
>
>> 	/*
>> 	 * Sync xfd before calling handle_exit_irqoff() which may
>>
>> base-commit: a996dd2a5e1ec54dcf7d7b93915ea3f97e14e68a
>> prerequisite-patch-id: 9aafd634f0ab2033d7b032e227d356777469e046
>> prerequisite-patch-id: 656ce1f5aa97c77a9cf6125713707a5007b2c7ba
>> prerequisite-patch-id: d6328b8c0fdb8593bb534ab7378821edcf9f639d
>> prerequisite-patch-id: c7f36d1cedc4ae6416223d2225460944629b3d4f
>> -- 
>> 2.46.0
>>
>>


