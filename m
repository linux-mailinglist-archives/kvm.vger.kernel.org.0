Return-Path: <kvm+bounces-13959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0786289D091
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 04:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A7741C23EC3
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 02:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21AA754756;
	Tue,  9 Apr 2024 02:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TCU140FY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EAD4F1E2;
	Tue,  9 Apr 2024 02:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712631483; cv=none; b=bufssHwE0lnvEqGSfbp/enUkQb0w3giTqSUInk6e+MaHELdKAVp3uxQ1UrZfHHdAGkpiX6bSiU9QqemnUMj242Pn72IXZPZY8Llr+ONU75MScFW0NIue/yY4aS382OQKWyHAG/1rn3Am4OtqlTAgxuvOyFJ8nI3h3/ph4X8pFxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712631483; c=relaxed/simple;
	bh=ftu17EFideu85zcIBzW3FSNHlVABHCz50AEW+QGwWko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gQU400CXy0zGja+gEnTA4dl+dnUdFEIaKI0MkSuZWcAs9BAroVoFyAWKpDtMoU3byIHCviw7M0obWm5FbBor0es0BZH4cHWXjtm6ti2zfAWpIV+SSFkAorJCK5IaadVPz4pSVuyXUpjgs0xQwLRGiglGho3Q0qXYVMtOwM9WMIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TCU140FY; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712631481; x=1744167481;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ftu17EFideu85zcIBzW3FSNHlVABHCz50AEW+QGwWko=;
  b=TCU140FYUfC4YXq+lnCrZWCBZIqZ779yUi9wFWMr5Ydr4o7IEUQRWlBb
   xMqx3YAHtjDYNgzlClCWPZeqW3B4hl7yDuMAVAjAJQTGxZLWXbOFT4X5A
   nYtRi1+vWvWfS7Zpt05JEi+vonAT2QUsyhOAsiFNBeUEeYH12VW8JTfBn
   pJqxR52XGYWhhYr3nU6ihq4GkuYmpHCpfOgcWui/Af8G4ck0AHeyDxh6n
   oylJQ9+kJgrAdfn15WzMhwxx1/YJ80U9fHbkeV258zweDXIRxLxr/1s+V
   4H08fHo/Us35Y4wHhf4qRpByHeSxbe/S0C7jAFaJVd7sv/nwqnJ/XQUaT
   Q==;
X-CSE-ConnectionGUID: MYpvSYlJRJmMRzAgdF3tnw==
X-CSE-MsgGUID: spjFH/WoQZ+WeG459AgE6w==
X-IronPort-AV: E=McAfee;i="6600,9927,11038"; a="8037583"
X-IronPort-AV: E=Sophos;i="6.07,188,1708416000"; 
   d="scan'208";a="8037583"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 19:58:01 -0700
X-CSE-ConnectionGUID: xQ091zZ+QKyya+YLrz1kew==
X-CSE-MsgGUID: M//Z3gSlSCW+KqWX2Cv3og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,188,1708416000"; 
   d="scan'208";a="19999474"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 19:57:58 -0700
Message-ID: <24c80d16-733b-4036-8057-075a0dab3b4d@intel.com>
Date: Tue, 9 Apr 2024 10:57:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Wei W Wang
 <wei.w.wang@intel.com>, David Skidmore <davidskidmore@google.com>,
 Steve Rutherford <srutherford@google.com>,
 Pankaj Gupta <pankaj.gupta@amd.com>
References: <20240405165844.1018872-1-seanjc@google.com>
 <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
 <ZhQZYzkDPMxXe2RN@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZhQZYzkDPMxXe2RN@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/2024 12:20 AM, Sean Christopherson wrote:
> On Sun, Apr 07, 2024, Xiaoyao Li wrote:
>> On 4/6/2024 12:58 AM, Sean Christopherson wrote:
>>>    - For guest MAXPHYADDR vs. GPAW, rely on KVM_GET_SUPPORTED_CPUID to enumerate
>>>      the usable MAXPHYADDR[2], and simply refuse to enable TDX if the TDX Module
>>>      isn't compatible.  Specifically, if MAXPHYADDR=52, 5-level paging is enabled,
>>>      but the TDX-Module only allows GPAW=0, i.e. only supports 4-level paging.
>>
>> So userspace can get supported GPAW from usable MAXPHYADDR, i.e.,
>> CPUID(0X8000_0008).eaxx[23:16] of KVM_GET_SUPPORTED_CPUID:
>>   - if usable MAXPHYADDR == 52, supported GPAW is 0 and 1.
>>   - if usable MAXPHYADDR <= 48, supported GPAW is only 0.
>>
>> There is another thing needs to be discussed. How does userspace configure
>> GPAW for TD guest?
>>
>> Currently, KVM uses CPUID(0x8000_0008).EAX[7:0] in struct
>> kvm_tdx_init_vm::cpuid.entries[] of IOCTL(KVM_TDX_INIT_VM) to deduce the
>> GPAW:
>>
>> 	int maxpa = 36;
>> 	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x80000008, 0);
>> 	if (entry)
>> 		max_pa = entry->eax & 0xff;
>>
>> 	...
>> 	if (!cpu_has_vmx_ept_5levels() && max_pa > 48)
>> 		return -EINVAL;
>> 	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
>> 		td_params->eptp_controls |= VMX_EPTP_PWL_5;
>> 		td_params->exec_controls |= TDX_EXEC_CONTROL_MAX_GPAW;
>> 	} else {
>> 		td_params->eptp_controls |= VMX_EPTP_PWL_4;
>> 	}
>>
>> The code implies that KVM allows the provided CPUID(0x8000_0008).EAX[7:0] to
>> be any value (when 5level ept is supported). when it > 48, configure GPAW of
>> TD to 1, otherwise to 0.
>>
>> However, the virtual value of CPUID(0x8000_0008).EAX[7:0] inside TD is
>> always the native value of hardware (for current TDX).
>>
>> So if we want to keep this behavior, we need to document it somewhere that
>> CPUID(0x8000_0008).EAX[7:0] in struct kvm_tdx_init_vm::cpuid.entries[] of
>> IOCTL(KVM_TDX_INIT_VM) is only for configuring GPAW, not for userspace to
>> configure virtual CPUID value for TD VMs.
>>
>> Another option is that, KVM doesn't allow userspace to configure
>> CPUID(0x8000_0008).EAX[7:0]. Instead, it provides a gpaw field in struct
>> kvm_tdx_init_vm for userspace to configure directly.
>>
>> What do you prefer?
> 
> Hmm, neither.  I think the best approach is to build on Gerd's series to have KVM
> select 4-level vs. 5-level based on the enumerated guest.MAXPHYADDR, not on
> host.MAXPHYADDR.

I see no difference between using guest.MAXPHYADDR (EAX[23:16]) and 
using host.MAXPHYADDR (EAX[7:0]) to determine the GPAW (and EPT level) 
for TD guest. The case for TDX diverges from what for non TDX VMs. The 
value of them passed from userspace can only be used to configure GPAW 
and EPT level for TD, but won't be reflected in CPUID inside TD.

So I take it as you prefer the former option than dedicated GPAW field.

> With a moderate amount of refactoring, cache/compute guest_maxphyaddr as:
> 
> 	static void kvm_vcpu_refresh_maxphyaddr(struct kvm_vcpu *vcpu)
> 	{
> 		struct kvm_cpuid_entry2 *best;
> 
> 		best = kvm_find_cpuid_entry(vcpu, 0x80000000);
> 		if (!best || best->eax < 0x80000008)
> 			goto not_found;
> 
> 		best = kvm_find_cpuid_entry(vcpu, 0x80000008);
> 		if (!best)
> 			goto not_found;
> 
> 		vcpu->arch.maxphyaddr = best->eax & GENMASK(7, 0);
> 
> 		if (best->eax & GENMASK(15, 8))
> 			vcpu->arch.guest_maxphyaddr = (best->eax & GENMASK(15, 8)) >> 8;
> 		else
> 			vcpu->arch.guest_maxphyaddr = vcpu->arch.maxphyaddr;
> 
> 		return;
> 
> 	not_found:
> 		vcpu->arch.maxphyaddr = KVM_X86_DEFAULT_MAXPHYADDR;
> 		vcpu->arch.guest_maxphyaddr = KVM_X86_DEFAULT_MAXPHYADDR;
> 	}
> 
> and then use vcpu->arch.guest_maxphyaddr instead of vcpu->arch.maxphyaddr when
> selecting the TDP level.
> 
> 	static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
> 	{
> 		/* tdp_root_level is architecture forced level, use it if nonzero */
> 		if (tdp_root_level)
> 			return tdp_root_level;
> 
> 		/*
> 		* Use 5-level TDP if and only if it's useful/necessary.  Definitely a
> 		* more verbose comment here.
> 		*/
> 		if (max_tdp_level == 5 && vcpu->arch.guest_maxphyaddr <= 48)
> 			return 4;
> 
> 		return max_tdp_level;
> 	}
> 
> The only question is whether or not the behavior needs to be opt-in via a new
> capability, e.g. in case there is some weird usage where userspace enumerates
> guest.MAXPHYADDR < host.MAXPHYADDR but still wants/needs 5-level paging.  I highly
> doubt such a use case exists though.
> 
> I'll get Gerd's series applied, and will post a small series to implement the
> above later this week.


