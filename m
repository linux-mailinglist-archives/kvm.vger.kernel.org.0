Return-Path: <kvm+bounces-13012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48D5688FFFC
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 14:22:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C2ADB225E5
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 13:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1AD63D387;
	Thu, 28 Mar 2024 13:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cfl2+mhk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3C47D3E7;
	Thu, 28 Mar 2024 13:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711632106; cv=none; b=Gypjxh3rLhDstSfg6al+ChMCdNtKq7An7obG2LpBWcvHmZ26v0GqVLrElfl8BKczjCgVgLep6eFVizbCbdaSvhABaBCpRgtpvQcSGOno1irJub5snEPTr8v7mWh6ck24UVfl9o+uonGbetqiR5UFUyZJTvyE6wl9fzl/Y7b+NRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711632106; c=relaxed/simple;
	bh=b3jNS8gEcTwmueSbmAZyxea0/9+2+uixNOONc4qQGxU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eDmOBPge6cep/4t9T1P2YCs0gDJLQvMHaGU17wPIstfT2winzIqJsc8GmB/3nHVghDMK/0CiU1vxiaeCyeU+sf+pUFHO0h3CpzXLLZEZEZFgqFmMXLiVp1sxcNwNJax+wRLjDmrC0F2czcq9W2g7i1OY+Vc8tcgfu2H5fNX8Fes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cfl2+mhk; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711632105; x=1743168105;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=b3jNS8gEcTwmueSbmAZyxea0/9+2+uixNOONc4qQGxU=;
  b=Cfl2+mhkym1UcEw5K7kU+kEVpqDUov1Basqp2dcQn4bY+Tww4Msr6t+Q
   jDk7Fendal8fBukXzOwCAQv125vb9i+0GoZZ+O+3gP+G3ESn2UMazFgre
   nn7jwDJxpoifgvNZVtmjOtxHIZIfjpPgkRwZxIr7hswTgNVoD5OdKogMn
   x0CHoSyu9+v/cqwDRP15TGjTtaRPAZJ/j7LgnCYYINqFd6slHHr/yFC11
   vKwcY5wyOXhZD3D1lAwQBQaad0SJ0EcuYt2dUSI4kS+d57fNoqKZm8HKd
   DD79OVzbTbS1ffBPow8BNbSxb6VqTmlht59nGp+tHDGvP6O0XL+wEY/4V
   A==;
X-CSE-ConnectionGUID: AYHDKjCNToWhQKjlL0N9gA==
X-CSE-MsgGUID: sl/2rkjPQ2S+EjmHJvYXEg==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="7382977"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="7382977"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 06:21:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="21294611"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 06:21:41 -0700
Message-ID: <234c9998-c314-44bb-ad96-6af2cece7465@intel.com>
Date: Thu, 28 Mar 2024 21:21:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
To: Chao Gao <chao.gao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
 <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
 "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, "Yuan, Hang"
 <hang.yuan@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20240326174859.GB2444378@ls.amr.corp.intel.com>
 <481141ba-4bdf-40f3-9c32-585281c7aa6f@intel.com>
 <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
 <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>
 <e0ac83c57da3c853ffc752636a4a50fe7b490884.camel@intel.com>
 <5f07dd6c-b06a-49ed-ab16-24797c9f1bf7@intel.com>
 <d7a0ed833909551c24bf1c2c52b8955d75359249.camel@intel.com>
 <20ef977a-75e5-4bbc-9acf-fa1250132138@intel.com>
 <783d85acd13fedafc6032a82f202eb74dc2bd214.camel@intel.com>
 <f499ee87-0ce3-403e-bad6-24f82933903a@intel.com>
 <ZgVDvCePGwKWv0wd@chao-email>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZgVDvCePGwKWv0wd@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/2024 6:17 PM, Chao Gao wrote:
> On Thu, Mar 28, 2024 at 11:40:27AM +0800, Xiaoyao Li wrote:
>> On 3/28/2024 11:04 AM, Edgecombe, Rick P wrote:
>>> On Thu, 2024-03-28 at 09:30 +0800, Xiaoyao Li wrote:
>>>>> The current ABI of KVM_EXIT_X86_RDMSR when TDs are created is nothing. So I don't see how this
>>>>> is
>>>>> any kind of ABI break. If you agree we shouldn't try to support MTRRs, do you have a different
>>>>> exit
>>>>> reason or behavior in mind?
>>>>
>>>> Just return error on TDVMCALL of RDMSR/WRMSR on TD's access of MTRR MSRs.
>>>
>>> MTRR appears to be configured to be type "Fixed" in the TDX module. So the guest could expect to be
>>> able to use it and be surprised by a #GP.
>>>
>>>           {
>>>             "MSB": "12",
>>>             "LSB": "12",
>>>             "Field Size": "1",
>>>             "Field Name": "MTRR",
>>>             "Configuration Details": null,
>>>             "Bit or Field Virtualization Type": "Fixed",
>>>             "Virtualization Details": "0x1"
>>>           },
>>>
>>> If KVM does not support MTRRs in TDX, then it has to return the error somewhere or pretend to
>>> support it (do nothing but not return an error). Returning an error to the guest would be making up
>>> arch behavior, and to a lesser degree so would ignoring the WRMSR.
>>
>> The root cause is that it's a bad design of TDX to make MTRR fixed1. When
>> guest reads MTRR CPUID as 1 while getting #VE on MTRR MSRs, it already breaks
>> the architectural behavior. (MAC faces the similar issue , MCA is fixed1 as
> 
> I won't say #VE on MTRR MSRs breaks anything. Writes to other MSRs (e.g.
> TSC_DEADLINE MSR) also lead to #VE. If KVM can emulate the MSR accesses, #VE
> should be fine.
> 
> The problem is: MTRR CPUID feature is fixed 1 while KVM/QEMU doesn't know how
> to virtualize MTRR especially given that KVM cannot control the memory type in
> secure-EPT entries.

yes, I partly agree on that "#VE on MTRR MSRs breaks anything". #VE is 
not a problem, the problem is if the #VE is opt-in or unconditional.

For the TSC_DEADLINE_MSR, #VE is opt-in actually. 
CPUID(1).EXC[24].TSC_DEADLINE is configurable by VMM. Only when VMM 
configures the bit to 1, will the TD guest get #VE. If VMM configures it 
to 0, TD guest just gets #GP. This is the reasonable design.

>> well while accessing MCA related MSRs gets #VE. This is why TDX is going to
>> fix them by introducing new feature and make them configurable)
>>
>>> So that is why I lean towards
>>> returning to userspace and giving the VMM the option to ignore it, return an error to the guest or
>>> show an error to the user.
>>
>> "show an error to the user" doesn't help at all. Because user cannot fix it,
>> nor does QEMU.
> 
> The key point isn't who can fix/emulate MTRR MSRs. It is just KVM doesn't know
> how to handle this situation and ask userspace for help.
> 
> Whether or how userspace can handle the MSR writes isn't KVM's problem. It may be
> better if KVM can tell userspace exactly in which cases KVM will exit to
> userspace. But there is no such an infrastructure.
> 
> An example is: in KVM CET series, we find it is complex for KVM instruction
> emulator to emulate control flow instructions when CET is enabled. The
> suggestion is also to punt to userspace (w/o any indication to userspace that
> KVM would do this).

Please point me to decision of CET? I'm interested in how userspace can 
help on that.

>>
>>> If KVM can't support the behavior, better to get an actual error in
>>> userspace than a mysterious guest hang, right?
>> What behavior do you mean?
>>
>>> Outside of what kind of exit it is, do you object to the general plan to punt to userspace?
>>>
>>> Since this is a TDX specific limitation, I guess there is KVM_EXIT_TDX_VMCALL as a general category
>>> of TDVMCALLs that cannot be handled by KVM.
> 
> Using KVM_EXIT_TDX_VMCALL looks fine.
> 
> We need to explain why MTRR MSRs are handled in this way unlike other MSRs.
> 
> It is better if KVM can tell userspace that MTRR virtualization isn't supported
> by KVM for TDs. Then userspace should resolve the conflict between KVM and TDX
> module on MTRR. But to report MTRR as unsupported, we need to make
> GET_SUPPORTED_CPUID a vm-scope ioctl. I am not sure if it is worth the effort.

My memory is that Sean dislike the vm-scope GET_SUPPORTED_CPUID for TDX 
when he was at Intel.

Anyway, we can provide TDX specific interface to report SUPPORTED_CPUID 
in KVM_TDX_CAPABILITIES, if we really need it.

> 
>>
>> I just don't see any difference between handling it in KVM and handling it in
>> userspace: either a) return error to guest or b) ignore the WRMSR.


