Return-Path: <kvm+bounces-26660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D8D03976347
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:48:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53A441F21611
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15AA218E03A;
	Thu, 12 Sep 2024 07:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ILOn3MUG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2220615C3;
	Thu, 12 Sep 2024 07:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726127308; cv=none; b=DEmsmr+lMhRGjbreiL+apwlLLbW74ZG/xjryQIXZToh/P3u+ph9wRMifv1NEJnwh6XkhmgvEhG+nI0uFkBt96DVjxzghG3o6K3T/GKDAXh1cv8vS4OVFMItCCfLk8szLSedboiNZ3url0luPZJdaywVo9zEIP1aW8tME6ADj1qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726127308; c=relaxed/simple;
	bh=o7YZ5R5ikHnxGwwWzt//sosmSE0QWYPasAHL1+K8Jo8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TemBCm23CKOQZv1UIRaq136aANvth0/i5Ovzse9CFo7X8gwx/tFZ7hGv2TXY0HjfBehxUq6XwhgFwY6FPcMfw7iwx0ClUMu39CotqnnlBsgLLQGOndMKlF/+Ss503tz0ZHIlXroYZ3d0fkyXz2OJ3epmvwW5p0bnyNBjCr0TP8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ILOn3MUG; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726127307; x=1757663307;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=o7YZ5R5ikHnxGwwWzt//sosmSE0QWYPasAHL1+K8Jo8=;
  b=ILOn3MUGt2EF0vzKpBbbaS5b3vQ2pBY5fwrgCul0wwpNwMzQ5zXVpbn4
   TUgJgW8xBMqnkOZQS3SsoXOKCQyRV9lCk9oRu2+caGINVXwrLVZfn/Prl
   4mhDih+Q5UK2i5tpPTynvERX+wj5T2hDoo+yeIwa8o8PwNcdldTM5cxXD
   0+Rti4Tracy4h9qZ3ctTAK8EHiviWYQMggbbBboW1GjFS5yfhBIj0Eazm
   pmcDHZWtlFoRHJOXQekAOs20r8TRRINCZ8i3D8YEi59F6t2ORY/slhC8a
   Ehgig+H8D4Zrl6IJmGOV9tH1gtTwdEzdu4Xvo2QtGsCmmJBJJlP4RpUQQ
   w==;
X-CSE-ConnectionGUID: ua7AgBrHSh+VdRxVgQJOUQ==
X-CSE-MsgGUID: 47qI3wC5Ste1ULP+LQtaXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11192"; a="28740906"
X-IronPort-AV: E=Sophos;i="6.10,222,1719903600"; 
   d="scan'208";a="28740906"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 00:48:26 -0700
X-CSE-ConnectionGUID: gXKpiGR/RweT09NKGn0rXQ==
X-CSE-MsgGUID: 2x0Y9fuMQ66afoUYLucpoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,222,1719903600"; 
   d="scan'208";a="67455410"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.38]) ([10.124.224.38])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 00:48:23 -0700
Message-ID: <cd236026-0bc9-424c-8d49-6bdc9daf5743@intel.com>
Date: Thu, 12 Sep 2024 15:48:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
To: Paolo Bonzini <pbonzini@redhat.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com>
 <05cf3e20-6508-48c3-9e4c-9f2a2a719012@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <05cf3e20-6508-48c3-9e4c-9f2a2a719012@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/11/2024 1:52 AM, Paolo Bonzini wrote:
> On 8/13/24 00:48, Rick Edgecombe wrote:
>> Originally, the plan was to filter the directly configurable CPUID bits
>> exposed by KVM_TDX_CAPABILITIES, and the final configured bit values
>> provided by KVM_TDX_GET_CPUID. However, several issues were found with
>> this. Both the filtering done with KVM_TDX_CAPABILITIES and
>> KVM_TDX_GET_CPUID had the issue that the get_supported_cpuid() provided
>> default values instead of supported masks for multi-bit fields (i.e. 
>> those
>> encoding a multi-bit number).
>>
>> For KVM_TDX_CAPABILITIES, there was also the problem of bits that are
>> actually supported by KVM, but missing from get_supported_cpuid() for one
>> reason or another. These include X86_FEATURE_MWAIT, X86_FEATURE_HT and
>> X86_FEATURE_TSC_DEADLINE_TIMER. This is currently worked around in 
>> QEMU by
>> adjusting which features are expected. 

I'm not sure what issuee/problem can be worked around in QEMU.

QEMU doesn't expect these bit are reported by KVM as supported for TDX. 
QEMU just accepts the result reported by KVM.

The problem is, TDX module and the hardware allow these bits be 
configured for TD guest, but KVM doesn't allow. It leads to users cannot 
create a TD with these bits on.

QEMU cannot work around this problem.

>> Some of these are going to be 
>> added
>> to get_supported_cpuid(), and that is probably the right long term fix.
> 
> There are several cases here:
> 
> - MWAIT is hidden because it's hard to virtualize its C-state parameters
> 
> - HT is hidden because it depends on the topology, and cannot be added 
> blindly.
> 
> - TSC_DEADLINE_TIMER is queried with KVM_CHECK_EXTENSION for historical 
> reasons
> 
> There are basically two kinds of userspace:
> 
> - those that fetch KVM_GET_SUPPORED_CPUID and pass it blindly to 
> KVM_SET_CPUID2.  These mostly work, though they may miss a feature or 
> three (e.g. the TSC deadline timer).
> 
> - those that know each bit and make an informed decision on what to 
> enable; for those, KVM_GET_SUPPORTED_CPUID is just guidance.
> 
> Because of this, KVM_GET_SUPPORTED_CPUID doesn't return bits that are 
> one; it returns a mix of:
> 
> - maximum supported values (e.g. CPUID[7,0].EAX)
> 
> - values from the host (e.g. FMS or model name)
> 
> - supported features
> 
> It's an awfully defined API but it is easier to use than it sounds (some 
> of the quirks are being documented in 
> Documentation/virt/kvm/x86/errata.rst and 
> Documentation/virt/kvm/x86/api.rst).  The idea is that, if userspace 
> manages individual CPUID bits, it already knows what can be one anyway.
> 
> This is the kind of API that we need to present for TDX, even if the 
> details on how to get the supported CPUID are different.  Not because 
> it's a great API, but rather because it's a known API.

However there are differences for TDX. For legacy VMs, the result of 
KVM_GET_SUPPORTED_CPUID isn't used to filter the input of KVM_SET_CPUID2.

But for TDX, it needs to filter the input of KVM_TDX_VM_INIT.CPUID[] 
because TDX module only allows the bits that are reported as 
configurable to be set to 1.

> The difference between this and KVM_GET_SUPPORTED_CPUID are small, but 
> the main one is X86_FEATURE_HYPERVISOR (I am not sure whether to make it 
> different with respect to X86_FEATURE_TSC_DEADLINE_TIMER; leaning 
> towards no).
> 
> We may also need a second ioctl specifically to return the fixed-1 bits. 
>   Asking Xiaoyao for input with regard to what he'd like to have in QEMU.

With current designed API, QEMU can only know which bits are 
configurable before KVM_TDX_VM_INIT, i.e., which bits can be set to 1 or 
0 freely.

For other bits not reported as configurable, QEMU can know the exact 
value of them via KVM_TDX_GET_CPUID, after KVM_TDX_VM_INIT and before 
TD's running. With it, QEMU can validate the return value is matched 
with what QEMU wants to set that determined by users input. If not 
matched, QEMU can provide some warnings like what for legacy VMs:

   - TDX doesn't support requested feature: CPUID.01H.ECX.tsc-deadline 
[bit 24]
   - TDX forcibly sets features: CPUID.01H:ECX.hypervisor [bit 31]

If there are ioctls to report the fixed0 bits and fixed1 bits for TDX, 
QEMU can validate the user's configuration earlier.

>> +    entry = kvm_find_cpuid_entry2((*cpuid)->entries, (*cpuid)->nent, 
>> 0x0, 0);
>> +    if (WARN_ON(!entry))
>> +        goto err;
>> +    /* Fixup of maximum basic leaf */
>> +    entry->eax |= 0x000000FF;
>> +
>> +    entry = kvm_find_cpuid_entry2((*cpuid)->entries, (*cpuid)->nent, 
>> 0x1, 0);
>> +    if (WARN_ON(!entry))
>> +        goto err;
>> +    /* Fixup of FMS */
>> +    entry->eax |= 0x0fff3fff;
>> +    /* Fixup of maximum logical processors per package */
>> +    entry->ebx |= 0x00ff0000;
>> +
> 
> I see now why you could blindly AND things in patch 24.
> 
> However, the right mode of operation is still to pick manually which 
> bits to AND.
> 
> Paolo
> 


