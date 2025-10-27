Return-Path: <kvm+bounces-61157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AB07C0D1E2
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 12:16:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23BB919A4F4D
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 11:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5610526463A;
	Mon, 27 Oct 2025 11:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T0uh1+4p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC57223ABA9
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 11:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761563769; cv=none; b=S4e0MMPqDSFi9q0D/WMMvZRHccoiIljkBobJvvdAIOPuwzqxeyc8VS2USSSIdGzOEWSdFes7eFyqnA0D4MobgskXmnnnvwVDfAsDCp533MU+iY9yJY0EsgwiWRe1fx2zpTJG3C3mGlU5GRuoCaU5U8Z52BVjIwPgHaGr6+XuGxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761563769; c=relaxed/simple;
	bh=RSOrVX31vGcWfeQGlrfg+xZrYHFOOXx25gDBBxP1nsw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vo8YkP1B9U2MsZUxijjZ6+RORz94JTSKSllSQiwyyAJYATQ55kfHEJNq6U3kO1vZE/tGtqGN1oyWzCFVPIbREyujdgeThIIRYjevBQLRSkEbSpCcROCKGo5cxKTmJNjiNlsp+kdS/PhwUmn9qdQcrV6gBfSwszhAgd3/1lkqduw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T0uh1+4p; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761563767; x=1793099767;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RSOrVX31vGcWfeQGlrfg+xZrYHFOOXx25gDBBxP1nsw=;
  b=T0uh1+4pNV40+IWyTd0mUymTBLkN8JQ1N2R9RNVyGZSui6bdeFk/nL7S
   Z43dik12nHJwNzBiY4tgbgDgfK9ml636LLhQKMOgsALnm8KxL2HEmVXoT
   EXtd/dZ+3IP4iSYvbPNc8JnRqo7MALgvyKfA7sPZ1E8T4Atz2u8rsALrI
   04y2X9cWLgR8/IkHrGm5UhsMQfdGySuh6WR2yGraJUuzPXkh4RZYPs3A1
   ZB0Tvfqqk9AvBGe5z4E5HWrGAIUAHdno/TlyWnFF/MKe+KWBpGRXjbRkA
   ORH0izzTzzLDPqDSTVipMx5s00xNmM6BlslLyl7HA3NUGhGeoZWMHhwow
   g==;
X-CSE-ConnectionGUID: fp5tJYFGQB++rqh4jyl7dw==
X-CSE-MsgGUID: mLdPfP83T4moOfbDOaeeOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="67504107"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="67504107"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 04:16:05 -0700
X-CSE-ConnectionGUID: AWHDKMlCTMayMuuVaaROYA==
X-CSE-MsgGUID: TmDYxUY7SRau8PqAYyj0LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184636872"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 04:16:02 -0700
Message-ID: <b70c5b82-815b-4c4d-a1c6-f3f011d951f9@intel.com>
Date: Mon, 27 Oct 2025 19:15:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/20] i386/cpu: Reorganize dependency check for arch
 lbr state
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-8-zhao1.liu@intel.com>
 <d34f682a-c6c0-4609-96e8-2a0b76585c7d@intel.com> <aP9FfUKoP2azthS8@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aP9FfUKoP2azthS8@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/2025 6:12 PM, Zhao Liu wrote:
>>>    * XSAVES feature bit (CPUID 0xD.0x1.EAX[bit 3]):
>>>
>>>      Arch lbr state is a supervisor state, which requires the XSAVES
>>>      feature support. Enumerate supported supervisor state based on XSAVES
>>>      feature bit in x86_cpu_enable_xsave_components().
>>>
>>>      Then it's safe to drop the check on XSAVES feature support during
>>>      CPUID 0XD encoding.
> 
> ...
> 
>>> +++ b/target/i386/cpu.c
>>> @@ -8174,16 +8174,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>>>                *ebx = xsave_area_size(xstate, true);
>>>                *ecx = env->features[FEAT_XSAVE_XSS_LO];
>>>                *edx = env->features[FEAT_XSAVE_XSS_HI];
>>> -            if (kvm_enabled() && cpu->enable_pmu &&
>>> -                (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR) &&
>>> -                (*eax & CPUID_XSAVE_XSAVES)) {
>>> -                *ecx |= XSTATE_ARCH_LBR_MASK;
>>> -            } else {
>>> -                *ecx &= ~XSTATE_ARCH_LBR_MASK;
>>> -            }
>>
>>> -        } else if (count == 0xf && cpu->enable_pmu
>>> -                   && (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
>>> -            x86_cpu_get_supported_cpuid(0xD, count, eax, ebx, ecx, edx);
>>
>> This chunk needs to be a separate patch. It's a functional change.
> 
> Already mentioned this in commit message.

Before this patch, if pmu is enabled and ARCH_LBR is configured, the 
leaf (0xd, 0xf) is constructed by

	x86_cpu_get_supported_cpuid()

after this patch, it's constructed to

	*eax = esa->size;
	*ebx = 0;
         *ecx = 1;

I'm not sure which part of the commit message mention it and clarify it.


