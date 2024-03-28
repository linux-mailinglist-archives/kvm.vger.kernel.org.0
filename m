Return-Path: <kvm+bounces-12921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26F1E88F442
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:58:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E20428FD87
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 00:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7135A1BC49;
	Thu, 28 Mar 2024 00:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jIo4pkPm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C641A17758;
	Thu, 28 Mar 2024 00:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711587512; cv=none; b=S7dLyocJ76TqM5wgwZBlijbHapwmoNCmGVcSL5nzBnhy7XXw3UaZjRLH0IxfutRt2tMAuATI3v2BplkhkKPxA21TVL+RSLdJ/C0bpGQlbPZU6ZhNkGVLF6tUOR5TFpo4KzX6M24NUHgSemjXRTm3CKWbTSaGxMhg4Wp6tXR7RGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711587512; c=relaxed/simple;
	bh=SaZQQW6MmOO+CINOodd7ihqukTJxZLgHrUGwNq9UnDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EwpbNEE0ursg9GFMOfUhc9gIXaYf7S3AIg/Y4vN8B5Xqa9egyA+V/3dC2ygIj0C0vet2q/llJUZBM5R/PT0UQkll4U/3uUJAT7za36/5OHVOBXwNOTOJ4uTj8FYX5VTGmJ/4YSpUOYXH41Vvkty3+VKG4/CbHr/MC/h1rx3y4Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jIo4pkPm; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711587511; x=1743123511;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SaZQQW6MmOO+CINOodd7ihqukTJxZLgHrUGwNq9UnDw=;
  b=jIo4pkPmMbd4ky5c9bsKO7zAlcnlcdF6ezcWyYHY3JBGMpDAyxiiNb/N
   gRMQAO51YSUT5DIaiNyuEoHSn/WxrID6fvkNezHQ22BUUZcUS+qqnkkDH
   W/mrR/GE/X/UOD1Usrx9AXRVq+Kaq2XsxFAY2QmiJieYJTZxkaPK2V729
   cA1UMZW+RK/WUYsnGJv0Ih2qZVsOoFmLLIpd4lExje6nktWjyuupfdxY7
   jqH+nora2lb27oZjf2vYGN85mUgAuMfJ2yLabxqHxsDA+I7J+LqpWDdV1
   T884JbF4Rr2Nc2twlC9/wRrtpLn13n6egvHobQglf8mjoabGg5arYo9s5
   g==;
X-CSE-ConnectionGUID: WwrfVXMDTv2Csf98KF/4jQ==
X-CSE-MsgGUID: WDtP6H45Qj2pz0td4s/u7g==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6835008"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="6835008"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 17:58:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="21162930"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 17:58:27 -0700
Message-ID: <5f07dd6c-b06a-49ed-ab16-24797c9f1bf7@intel.com>
Date: Thu, 28 Mar 2024 08:58:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Gao, Chao" <chao.gao@intel.com>, "Yamahata, Isaku"
 <isaku.yamahata@intel.com>
Cc: "Zhang, Tina" <tina.zhang@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, "Chen, Bo2"
 <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yuan, Hang"
 <hang.yuan@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
References: <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
 <20240325190525.GG2357401@ls.amr.corp.intel.com>
 <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
 <20240325221836.GO2357401@ls.amr.corp.intel.com>
 <20240325231058.GP2357401@ls.amr.corp.intel.com>
 <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
 <20240325233528.GQ2357401@ls.amr.corp.intel.com>
 <ZgIzvHKobT2K8LZb@chao-email>
 <20db87741e356e22a72fadeda8ab982260f26705.camel@intel.com>
 <ZgKt6ljcmnfSbqG/@chao-email>
 <20240326174859.GB2444378@ls.amr.corp.intel.com>
 <481141ba-4bdf-40f3-9c32-585281c7aa6f@intel.com>
 <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
 <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>
 <e0ac83c57da3c853ffc752636a4a50fe7b490884.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <e0ac83c57da3c853ffc752636a4a50fe7b490884.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/28/2024 8:45 AM, Edgecombe, Rick P wrote:
> On Thu, 2024-03-28 at 08:06 +0800, Xiaoyao Li wrote:
>>
>> TDX spec states that
>>
>>     18.2.1.4.1 Memory Type for Private and Opaque Access
>>
>>     The memory type for private and opaque access semantics, which use a
>>     private HKID, is WB.
>>
>>     18.2.1.4.2 Memory Type for Shared Accesses
>>
>>     Intel SDM, Vol. 3, 28.2.7.2 Memory Type Used for Translated Guest-
>>     Physical Addresses
>>
>>     The memory type for shared access semantics, which use a shared HKID,
>>     is determined as described below. Note that this is different from the
>>     way memory type is determined by the hardware during non-root mode
>>     operation. Rather, it is a best-effort approximation that is designed
>>     to still allow the host VMM some control over memory type.
>>       • For shared access during host-side (SEAMCALL) flows, the memory
>>         type is determined by MTRRs.
>>       • For shared access during guest-side flows (VM exit from the guest
>>         TD), the memory type is determined by a combination of the Shared
>>         EPT and MTRRs.
>>         o If the memory type determined during Shared EPT walk is WB, then
>>           the effective memory type for the access is determined by MTRRs.
>>         o Else, the effective memory type for the access is UC.
>>
>> My understanding is that guest MTRR doesn't affect the memory type for
>> private memory. So we don't need to zap private memory mappings.
> 
> Right, KVM can't zap the private side.
> 
> But why does KVM have to support a "best effort" MTRR virtualization for TDs? Kai pointed me to this
> today and I haven't looked through it in depth yet:
> https://lore.kernel.org/kvm/20240309010929.1403984-1-seanjc@google.com/
> 
> An alternative could be to mirror that behavior, but normal VMs have to work with existing userspace
> setup. KVM doesn't support any TDs yet, so we can take the opportunity to not introduce weird
> things.

Not to provide any MTRR support for TD is what I prefer.

>>
>>>>>> But guests won't accept memory again because no one
>>>>>> currently requests guests to do this after writes to MTRR MSRs. In this case,
>>>>>> guests may access unaccepted memory, causing infinite EPT violation loop
>>>>>> (assume SEPT_VE_DISABLE is set). This won't impact other guests/workloads on
>>>>>> the host. But I think it would be better if we can avoid wasting CPU resource
>>>>>> on the useless EPT violation loop.
>>>>>
>>>>> Qemu is expected to do it correctly.  There are manyways for userspace to go
>>>>> wrong.  This isn't specific to MTRR MSR.
>>>>
>>>> This seems incorrect. KVM shouldn't force userspace to filter some
>>>> specific MSRs. The semantic of MSR filter is userspace configures it on
>>>> its own will, not KVM requires to do so.
>>>
>>> I'm ok just always doing the exit to userspace on attempt to use MTRRs in a TD, and not rely on
>>> the
>>> MSR list. At least I don't see the problem.
>>
>> What is the exit reason in vcpu->run->exit_reason?
>> KVM_EXIT_X86_RDMSR/WRMSR? If so, it breaks the ABI on
>> KVM_EXIT_X86_RDMSR/WRMSR.
> 
> How so? Userspace needs to learn to create a TD first.

The current ABI of KVM_EXIT_X86_RDMSR/WRMSR is that userspace itself 
sets up MSR fitler at first, then it will get such EXIT_REASON when 
guest accesses the MSRs being filtered.

If you want to use this EXIT reason, then you need to enforce userspace 
setting up the MSR filter. How to enforce? If not enforce, but exit with 
KVM_EXIT_X86_RDMSR/WRMSR no matter usersapce sets up MSR filter or not. 
Then you are trying to introduce divergent behavior in KVM.

