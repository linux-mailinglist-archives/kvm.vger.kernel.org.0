Return-Path: <kvm+bounces-21774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7171E933E1D
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 16:00:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B772281687
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 14:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC18180A90;
	Wed, 17 Jul 2024 14:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TUiKmoNY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA1057CBE;
	Wed, 17 Jul 2024 14:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721224840; cv=none; b=NV/INcrzsDuKVnEKce/7C6K7HZeUrWmVsLAp/AuB2mZ5FJz6w4PKrQpOFpLezBp1zdNip0HmKBnuhbrmzJsY7+I6T2/Z/qfzC28C98m/wNyLUHnI745UL3xZk5/NM5zHElqlpW4F2SVWOk/uEaDaukG2H9CMdX2qY1RXV3ODxYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721224840; c=relaxed/simple;
	bh=E+FhYuxmNkP3RZDL/N0m140+nk3hN68k0YFGrWbX+s8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EoA3KrV6jATlw/cvrAUUe3BaVA+Y9d38I1lJJTNCeJjwxjzYBUrFDP+akqrK0AS2YIyCtTY3t4+MaaU9QQVhU/Y2xhgqXQATEOfuy047qpHAq7Yo9nrjNjd5j7nkCZNQMqdAjbpHWcVMAgZSMZrsTtKHFdndjPgKYK6YHAHHivU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TUiKmoNY; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721224838; x=1752760838;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=E+FhYuxmNkP3RZDL/N0m140+nk3hN68k0YFGrWbX+s8=;
  b=TUiKmoNY0bAlr9jXNK7AUOBtMyBEy+LcwlkAMAKqI/KpojIXGeriZUMH
   LAqXNAEqFae/jjsN1mXu7L2GDGtZHG+MA9ZBnugtC0UDOEe4UTPI1ZAYZ
   Os9VvQ3ds8uxc4kLXwcOevHlIMCyMSmg+kJooU+4r+XBY6JFMim62EJH9
   r6P0DSdrSO1YIzMlWdN1fNW/aDAr1Z081q1wXc4fl6r77Nuzv4A6zgQP5
   zSOoEw1T0tqCnurcm6qMlrb+r/OQZJ2a4LpNXA6k+RS+YYfTdtVmu9/GL
   rLLjnM7YeAUxWH6C3Yyk0uw2fdCFv/rXZIlrZs4N5rt6UfWItOQNqY0q6
   w==;
X-CSE-ConnectionGUID: Q0seOagRStSJsxWXpobwaQ==
X-CSE-MsgGUID: Ydyt0NseSEiVsY+ddQZSrA==
X-IronPort-AV: E=McAfee;i="6700,10204,11136"; a="18541819"
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="18541819"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 07:00:38 -0700
X-CSE-ConnectionGUID: 26aK0OAyTY+G8/R+yIbgdw==
X-CSE-MsgGUID: sUrvdMyPSAu1kwoM8ZXrdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="50189660"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.247.52]) ([10.125.247.52])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 07:00:34 -0700
Message-ID: <bd0006c9-2386-4d81-9147-f262262d70ce@intel.com>
Date: Wed, 17 Jul 2024 22:00:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/49] KVM: x86: Handle kernel- and KVM-defined CPUID
 words in a single helper
To: Sean Christopherson <seanjc@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>,
 Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>,
 Binbin Wu <binbin.wu@linux.intel.com>,
 Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
References: <20240517173926.965351-1-seanjc@google.com>
 <20240517173926.965351-24-seanjc@google.com>
 <7bf9838f2df676398f7b22f793b3478addde6ff0.camel@redhat.com>
 <ZoxXur7da11tP3aO@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZoxXur7da11tP3aO@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/2024 5:18 AM, Sean Christopherson wrote:
> On Thu, Jul 04, 2024, Maxim Levitsky wrote:
>> On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
>>> Merge kvm_cpu_cap_init() and kvm_cpu_cap_init_kvm_defined() into a single
>>> helper.  The only advantage of separating the two was to make it somewhat
>>> obvious that KVM directly initializes the KVM-defined words, whereas using
>>> a common helper will allow for hardening both kernel- and KVM-defined
>>> CPUID words without needing copy+paste.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

>>> ---
>>>   arch/x86/kvm/cpuid.c | 44 +++++++++++++++-----------------------------
>>>   1 file changed, 15 insertions(+), 29 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index f2bd2f5c4ea3..8efffd48cdf1 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -622,37 +622,23 @@ static __always_inline u32 raw_cpuid_get(struct cpuid_reg cpuid)
>>>   	return *__cpuid_entry_get_reg(&entry, cpuid.reg);
>>>   }
>>>   
>>> -/* Mask kvm_cpu_caps for @leaf with the raw CPUID capabilities of this CPU. */
>>> -static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
>>> +static __always_inline void kvm_cpu_cap_init(u32 leaf, u32 mask)
>>>   {
>>>   	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
>>>   
>>> -	reverse_cpuid_check(leaf);
>>> +	/*
>>> +	 * For kernel-defined leafs, mask the boot CPU's pre-populated value.
>>> +	 * For KVM-defined leafs, explicitly set the leaf, as KVM is the one
>>> +	 * and only authority.
>>> +	 */
>>> +	if (leaf < NCAPINTS)
>>> +		kvm_cpu_caps[leaf] &= mask;
>>> +	else
>>> +		kvm_cpu_caps[leaf] = mask;
>>
>> Hi,
>>
>> I have an idea, how about we just initialize the kvm only leafs to 0xFFFFFFFF
>> and then treat them exactly in the same way as kernel regular leafs?
>>
>> Then the user won't have to figure out (assuming that the user doesn't read
>> the comment, who does?) why we use mask as init value.
>>
>> But if you prefer to leave it this way, I won't object either.
> 
> Huh, hadn't thought of that.  It's a small code change, but I'm leaning towards
> keeping the current code as we'd still need a comment to explain why KVM sets
> all bits by default.  

> And in the unlikely case that we royally screw up and fail
> to call kvm_cpu_cap_init() on a word, starting with 0xff would result in all
> features in the uninitialized word being treated as supported.

+1

> For posterity...
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 18ded0e682f2..6fcfb0fa4bd6 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -762,11 +762,7 @@ do {                                                                       \
>          u32 kvm_cpu_cap_emulated = 0;                                   \
>          u32 kvm_cpu_cap_synthesized = 0;                                \
>                                                                          \
> -       if (leaf < NCAPINTS)                                            \
> -               kvm_cpu_caps[leaf] &= (mask);                           \
> -       else                                                            \
> -               kvm_cpu_caps[leaf] = (mask);                            \
> -                                                                       \
> +       kvm_cpu_caps[leaf] &= (mask);                                   \
>          kvm_cpu_caps[leaf] &= (raw_cpuid_get(cpuid) |                   \
>                                 kvm_cpu_cap_synthesized);                \
>          kvm_cpu_caps[leaf] |= kvm_cpu_cap_emulated;                     \
> @@ -780,7 +776,7 @@ do {                                                                        \
>   
>   void kvm_set_cpu_caps(void)
>   {
> -       memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));
> +       memset(kvm_cpu_caps, 0xff, sizeof(kvm_cpu_caps));
>   
>          BUILD_BUG_ON(sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)) >
>                       sizeof(boot_cpu_data.x86_capability));
> 


