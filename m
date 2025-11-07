Return-Path: <kvm+bounces-62273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F1EC4C3E9B3
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 07:18:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 323DC4E4035
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 06:18:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66FF1279327;
	Fri,  7 Nov 2025 06:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SfShe/kq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C7B28E0F;
	Fri,  7 Nov 2025 06:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762496282; cv=none; b=pYbl5PZ3tWNQFyWEBqCCzZrXQvyagFVa0/dzEqx/PWhRvimjIM4ahmZP1BRU4FUCgQtjSdNmxqCLdMb4Dt/XixzuXXzhuERXFxQfeg8BcSVwu4wfobhj3Ckb6eOQbWhMSJdsH179rXRV2t/bozzAvSYJJcWfrpWjHEW0qX6D5lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762496282; c=relaxed/simple;
	bh=Gc2DcugMerleuLdTzEOs7wom9vBWWElMe7aSSbZk8pE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hP4bYgQnDmFD8ohmwf8Q6Bi4M1ymqHZcxmVo9li0yxU699cHIg3VrhslBqYaNzKkgwU2ituodvWEMdx2msMdAbHSI8xfJhHfCtQxF+lm7cwy6qkItAvYKRIQ47C+yCYzGba99OlpWzhqGLBu/LahQYru8vpNcaclxE2vMZlFqCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SfShe/kq; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762496281; x=1794032281;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Gc2DcugMerleuLdTzEOs7wom9vBWWElMe7aSSbZk8pE=;
  b=SfShe/kqZb9gdD4fN20EBCUDAf1Dt4UuDAFPzmujSRrdKljBtjAYRh3f
   TWqPhrZKDEHgilp5Z/LyJ7Ir17A+PzYAeAhEeTwXV8IY/kj0MVi1MDZ2H
   fsm9pAWAsGYNyHyy4H0ckmH/BZkk/FzJQIOJbpVAucHs6JVhI8KYFGNYf
   OjgYKm3fDEgaiN5I6ctaZ4Sx4kxRSI4eohnJytJdNKe3eeEYvcv/NA2Ys
   hCSZ3eUmLr6Vnbza0nmARnp1TSnrZzHq7Ta4J9277Jlb0FiCDxp8Lp6HD
   c6DIDWjQcPUxVczK17fh7bexkdHJJolWE9E0XkshS+7aWEpIn1x6rE/VV
   A==;
X-CSE-ConnectionGUID: YTevIMWeRy25MAFFnjhBdg==
X-CSE-MsgGUID: XBEYtbcFSiKjPIbCZwMAGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11605"; a="64527388"
X-IronPort-AV: E=Sophos;i="6.19,286,1754982000"; 
   d="scan'208";a="64527388"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 22:18:01 -0800
X-CSE-ConnectionGUID: qxQtCjk9Spuq1kbAWsoU0Q==
X-CSE-MsgGUID: 9dAMnShkRY+ph1PB/oK2Qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,286,1754982000"; 
   d="scan'208";a="187908005"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.49]) ([10.124.240.49])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 22:17:59 -0800
Message-ID: <e071595c-f038-4118-9686-61dae28d4814@intel.com>
Date: Fri, 7 Nov 2025 14:17:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Add a help to dedup loading guest/host XCR0 and
 XSS
To: Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251106101138.2756175-1-binbin.wu@linux.intel.com>
 <aQ1kG5u8GPdEwoEy@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aQ1kG5u8GPdEwoEy@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

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
> 
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
> 
> Nit: given that xcr0/xss are either guest or host values, would it be slightly
> better for this helper to accept a boolean (e.g., bool load_guest) to convey
> that the API loads guest (or host) values rather than arbitrary xcr0/xss
> values? like fpu_swap_kvm_fpstate().

This really is a good idea!

Allow arbitrary input but skip the write when vcpu->arch.{xcr0,ia32_xss} 
== kvm_host.{xcr0,ia32_xss} does introduce confusion.

> static void kvm_load_xfeatures(struct kvm_vcpu *vcpu, bool load_guest)
> {
> 	u64 xcr0 = load_guest ? vcpu->arch.xcr0 : kvm_host.xcr0;
> 	u64 xss  = load_guest ? vcpu->arch.ia32_xss : kvm_host.xss;
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
> 


