Return-Path: <kvm+bounces-35928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C11FAA164B0
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 01:38:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5072718852BF
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 00:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E72198F5B;
	Mon, 20 Jan 2025 00:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iuP/au/3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB094DDC5;
	Mon, 20 Jan 2025 00:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737333488; cv=none; b=urIhKEDtnyRiulLzYZDrl/OT8ekYxQIcVVgSdgdbovYFkTulNhTVJuiIy3U/ysJGlM+FHrRBuVVlF+qHlfncDtReh5WbJbnWHjkhm/DXLliCMW4mC8OS/D/zKaNGyTSG6LmUonYxcoLW7LIRtVFU2EULa2Ig++cahNhQBm/LNNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737333488; c=relaxed/simple;
	bh=hmlAlXFdf7hWfysyngcfGdHcDLc8ogIhGBpmTNWP3lY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jr/gfq3+gSP1kuTtHqAeRyIdf0ymwsWdtv0KtiWPXS+klp9k45HhRp194LbnkPXgsALsPVGAAUSM47UpbVHUfxCJKQ4Cq4zeOwRgkbYyZy0wkJQKHn27Q4+j/cMcuGgj3K2fdZK235eyDpXLTIpwPiNSERg+a4wtz9anx67FeYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iuP/au/3; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737333487; x=1768869487;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hmlAlXFdf7hWfysyngcfGdHcDLc8ogIhGBpmTNWP3lY=;
  b=iuP/au/3WZo9IuzrW4rkYnZNPELysjprQHR9umWaQGEPtgm2B19XOzob
   QuoFpqj7j6ENxqhfQ1TLc8eBPJCLHoNtOC53AX071ZuNoXcQlsF93p0J1
   ZFlhOws3gL2/vlUIuNF5lB7pkVJ7vepAUM6PdjErjs4YH2C8rYs2RqKSD
   oX6H88w3TlttnRZoVIdPTt3QZaAQlXqaS6fJJlkzFeawBzfV0Q1z9D7ag
   VLx28urq+9RMErFDVgJPE1I/C3RbTeOU3XNko4rT4pVOXJgzkyIhGLKmW
   bgc5dk/m6Db5zaDl4J8kG70uyNFu49o8MRRWnLfKZexECgYKgSqqpVfDB
   g==;
X-CSE-ConnectionGUID: 49XGtLLUSxWGOZS00TpVyA==
X-CSE-MsgGUID: e7epICIyRd+7bjlPgSGBug==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="37797576"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="37797576"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2025 16:38:03 -0800
X-CSE-ConnectionGUID: 6vmTYk4GTS6kjdOUQMM7Kw==
X-CSE-MsgGUID: k+pT2GDiTcanWRxQrvfeFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="129588649"
Received: from junyanfe-mobl.ccr.corp.intel.com (HELO [10.124.241.228]) ([10.124.241.228])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2025 16:38:01 -0800
Message-ID: <5718f02c-59e7-402b-91ee-b4b7b43f887a@linux.intel.com>
Date: Mon, 20 Jan 2025 08:37:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/6] KVM: x86: Prep KVM hypercall handling for TDX
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Adrian Hunter <adrian.hunter@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <173457537849.3292936.8364596188659598507.b4-ty@google.com>
 <67f0292e-6eea-4788-977c-50af51910945@linux.intel.com>
 <Z4qv9VTs0CZ0zoxW@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z4qv9VTs0CZ0zoxW@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 1/18/2025 3:31 AM, Sean Christopherson wrote:
> On Wed, Jan 15, 2025, Binbin Wu wrote:
>> On 12/19/2024 10:40 AM, Sean Christopherson wrote:
>>> On Wed, 27 Nov 2024 16:43:38 -0800, Sean Christopherson wrote:
>>>> Effectively v4 of Binbin's series to handle hypercall exits to userspace in
>>>> a generic manner, so that TDX
>>>>
>>>> Binbin and Kai, this is fairly different that what we last discussed.  While
>>>> sorting through Binbin's latest patch, I stumbled on what I think/hope is an
>>>> approach that will make life easier for TDX.  Rather than have common code
>>>> set the return value, _and_ have TDX implement a callback to do the same for
>>>> user return MSRs, just use the callback for all paths.
>>>>
>>>> [...]
>>> Applied patch 1 to kvm-x86 fixes.  I'm going to hold off on the rest until the
>>> dust settles on the SEAMCALL interfaces, e.g. in case TDX ends up marshalling
>>> state into the "normal" GPRs.
>> Hi Sean, Based on your suggestions in the link
>> https://lore.kernel.org/kvm/Z1suNzg2Or743a7e@google.com, the v2 of "KVM: TDX:
>> TDX hypercalls may exit to userspace" is planned to morph the TDG.VP.VMCALL
>> with KVM hypercall to EXIT_REASON_VMCALL and marshall r10~r14 from
>> vp_enter_args in struct vcpu_tdx to the appropriate x86 registers for KVM
>> hypercall handling.
> ...
>
>> To test TDX, I made some modifications to your patch
>> "KVM: x86: Refactor __kvm_emulate_hypercall() into a macro"
>> Are the following changes make sense to you?
> Yes, but I think we can go a step further and effectively revert the bulk of commit
> e913ef159fad ("KVM: x86: Split core of hypercall emulation to helper function"),
> i.e. have ____kvm_emulate_hypercall() read the GPRs instead of passing them in
> via the macro.

Sure.

Are you OK if I sent the change (as a prep patch) along with v2 of
"TDX hypercalls may exit to userspace"?

>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index a2198807290b..2c5df57ad799 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10088,9 +10088,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>          if (kvm_hv_hypercall_enabled(vcpu))
>>                  return kvm_hv_hypercall(vcpu);
>> -       return __kvm_emulate_hypercall(vcpu, rax, rbx, rcx, rdx, rsi,
>> -                                      is_64_bit_hypercall(vcpu),
>> -                                      kvm_x86_call(get_cpl)(vcpu),
>> +       return __kvm_emulate_hypercall(vcpu, kvm_x86_call(get_cpl)(vcpu),
>>                                         complete_hypercall_exit);
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index b00ecbfef000..989bed5b48b0 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -623,19 +623,18 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>>                                int op_64_bit, int cpl,
>>                                int (*complete_hypercall)(struct kvm_vcpu *));
>> -#define __kvm_emulate_hypercall(_vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl, complete_hypercall) \
>> -({                                                                                             \
>> -       int __ret;                                                                              \
>> -                                                                                               \
>> -       __ret = ____kvm_emulate_hypercall(_vcpu,                                                \
>> -                                         kvm_##nr##_read(_vcpu), kvm_##a0##_read(_vcpu),       \
>> -                                         kvm_##a1##_read(_vcpu), kvm_##a2##_read(_vcpu),       \
>> -                                         kvm_##a3##_read(_vcpu), op_64_bit, cpl,               \
>> -                                         complete_hypercall);                                  \
>> -                                                                                               \
>> -       if (__ret > 0)                                                                          \
>> -               __ret = complete_hypercall(_vcpu);                                              \
>> -       __ret;                                                                                  \
>> +#define __kvm_emulate_hypercall(_vcpu, cpl, complete_hypercall)                                \
>> +({                                                                                     \
>> +       int __ret;                                                                      \
>> +       __ret = ____kvm_emulate_hypercall(_vcpu, kvm_rax_read(_vcpu),                   \
>> +                                         kvm_rbx_read(_vcpu), kvm_rcx_read(_vcpu),     \
>> +                                         kvm_rdx_read(_vcpu), kvm_rsi_read(_vcpu),     \
>> +                                         is_64_bit_hypercall(_vcpu), cpl,              \
>> +                                         complete_hypercall);                          \
>> +                                                                                       \
>> +       if (__ret > 0)                                                                  \
>> +               __ret = complete_hypercall(_vcpu);                                      \
>> +       __ret;                                                                          \
>>   })
>>   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
>>
>>


