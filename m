Return-Path: <kvm+bounces-60870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 764C5BFF4AB
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 07:59:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 62A6A4F3ED2
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 05:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6350525A331;
	Thu, 23 Oct 2025 05:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ap4UG8tu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CD924A063;
	Thu, 23 Oct 2025 05:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761199170; cv=none; b=DgVcVB9IkSu2Yf5oy+7kINB1K793ioa1GjigxkGeN07sRYg/HIVn4dZgcnTY4goGpMmkwlHm2UeDikzMsyi1fTguMDq6lSLOLu9sRhQxrvLD8sIHLaDRHt596TOgWZSTnkLj7apCcIHsl0zmo3y+p0M8+YBbjPQ0RLFmos0Rb9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761199170; c=relaxed/simple;
	bh=cQKtmMLln2r2V73OaQzHU0YMnXqjNo3aclJ5YFW6/Jc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MNxWyVlu8fw3eYBuA+oDhhG3Asp6HUXUaBZsXdjGtrT3mV15JDo1YXipcgUMvruFqosILL3OtMgHFMD5FkMrXPW9l7nSHNOKsNLitZF3P0J3cgGBmDfnU0rZBjiPqqfSWxiE4p+IjV5P1rosuNuR9bstzQOhAGTB6skLSKjHNWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ap4UG8tu; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761199168; x=1792735168;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cQKtmMLln2r2V73OaQzHU0YMnXqjNo3aclJ5YFW6/Jc=;
  b=ap4UG8tuQJ2Vzi9IUKQxufJ7upJHQ/P9WoT4OWsjwXF15p8iPM6LsmGi
   KymDHs6JAMP/V1PVJw0YLy1x5YhF3qXZujAo1Jm9VPK/IR1vJq48OOhix
   CpjTfP3r8IEltl2I/4JFYiAZ4Z/dJh9Fj3amUDar2YAJbuJXaLpREIddZ
   0aZgEMOEhygyBcRAg8aBsLzpx65GnFuV7MdQtiCxhHZU0rfHfpJOg3nB9
   y+o0d5xQuknA1tGzlSNKo5c4kYyF9wJVxyyGLWk07/vNm0AL7s8MfT+KH
   pEv7yh4QBRfnUHcpOC7k6/tpQIM1f3faHcSvxAbL0YHpjBABmY1268nEa
   w==;
X-CSE-ConnectionGUID: eu5+KMdySbmPwPSm/ZM1zw==
X-CSE-MsgGUID: 2SPqO7dsQ42Fmmk7fpaxsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="73963785"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="73963785"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 22:59:27 -0700
X-CSE-ConnectionGUID: uUuAAGBLSKGSnjI//pIM4w==
X-CSE-MsgGUID: jxp103nrTOi3Syhy8GB6tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="183667094"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 22:59:24 -0700
Message-ID: <28073044-5aa2-49b2-b789-70728d1cce7d@intel.com>
Date: Thu, 23 Oct 2025 13:59:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] KVM: TDX: Synchronize user-return MSRs immediately
 after VP.ENTER
To: Sean Christopherson <seanjc@google.com>,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, "x86@kernel.org"
 <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Yan Y Zhao <yan.y.zhao@intel.com>, wenlong hou
 <houwenlong.hwl@antgroup.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
References: <20251016222816.141523-1-seanjc@google.com>
 <20251016222816.141523-2-seanjc@google.com>
 <e16f198e6af0b03fb0f9cfcc5fd4e7a9047aeee1.camel@intel.com>
 <d1628f0e-bbe9-48b0-8881-ad451d4ce9c5@intel.com>
 <aPehbDzbMHZTEtMa@google.com>
 <38df6c8bfd384e5fefa8eb6fbc27c35b99c685ed.camel@intel.com>
 <aPfgJjcuMgkXfe51@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aPfgJjcuMgkXfe51@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/22/2025 3:33 AM, Sean Christopherson wrote:
> On Tue, Oct 21, 2025, Rick P Edgecombe wrote:
>> On Tue, 2025-10-21 at 08:06 -0700, Sean Christopherson wrote:
>>>   I think we should be synchronizing only after a successful VP.ENTER with a real
>>>>> TD exit, but today instead we synchronize after any attempt to VP.ENTER.
>>>
>>> Well this is all completely @#($*#.  Looking at the TDX-Module source, if the
>>> TDX-Module synthesizes an exit, e.g. because it suspects a zero-step attack, it
>>> will signal a "normal" exit but not "restore" VMM state.
>>
>> Oh yea, good point. So there is no way to tell from the return code if the
>> clobbering happened.
>>
>>>
>>>> If the MSR's do not get clobbered, does it matter whether or not they get
>>>> restored.
>>>
>>> It matters because KVM needs to know the actual value in hardware.  If KVM thinks
>>> an MSR is 'X', but it's actually 'Y', then KVM could fail to write the correct
>>> value into hardware when returning to userspace and/or when running a different
>>> vCPU.
>>>
>>> Taking a step back, the entire approach of updating the "cache" after the fact is
>>> ridiculous.  TDX entry/exit is anything but fast; avoiding _at most_ 4x WRMSRs at
>>> the start of the run loop is a very, very premature optimization.  Preemptively
>>> load hardware with the value that the TDX-Module _might_ set and call it good.
>>>
>>> I'll replace patches 1 and 4 with this, tagged for stable@.
>>
>> Seems reasonable to me in concept, but there is a bug. It looks like some
>> important MSR isn't getting restored right and the host gets into a bad state.
>> The first signs start with triggering this:
>>
>> asmlinkage __visible noinstr struct pt_regs *fixup_bad_iret(struct pt_regs
>> *bad_regs)
>> {
>> 	struct pt_regs tmp, *new_stack;
>>
>> 	/*
>> 	 * This is called from entry_64.S early in handling a fault
>> 	 * caused by a bad iret to user mode.  To handle the fault
>> 	 * correctly, we want to move our stack frame to where it would
>> 	 * be had we entered directly on the entry stack (rather than
>> 	 * just below the IRET frame) and we want to pretend that the
>> 	 * exception came from the IRET target.
>> 	 */
>> 	new_stack = (struct pt_regs *)__this_cpu_read(cpu_tss_rw.x86_tss.sp0) -
>> 1;
>>
>> 	/* Copy the IRET target to the temporary storage. */
>> 	__memcpy(&tmp.ip, (void *)bad_regs->sp, 5*8);
>>
>> 	/* Copy the remainder of the stack from the current stack. */
>> 	__memcpy(&tmp, bad_regs, offsetof(struct pt_regs, ip));
>>
>> 	/* Update the entry stack */
>> 	__memcpy(new_stack, &tmp, sizeof(tmp));
>>
>> 	BUG_ON(!user_mode(new_stack)); <---------------HERE
>>
>> Need to debug.
> 
> /facepalm
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 63abfa251243..cde91a995076 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -801,8 +801,8 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>           * state.
>           */
>          for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
> -               kvm_set_user_return_msr(i, tdx_uret_msrs[i].slot,
> -                                       tdx_uret_msrs[i].defval);
> +               kvm_set_user_return_msr(tdx_uret_msrs[i].slot,
> +                                       tdx_uret_msrs[i].defval, -1ull);
>   }
>   
>   static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)

with the above fix, the whole diff/implementation works. It passes our 
internal TDX CI.

