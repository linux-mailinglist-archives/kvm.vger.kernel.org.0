Return-Path: <kvm+bounces-12922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5017488F44A
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:05:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B006AB21D16
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:04:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA25B1BF2A;
	Thu, 28 Mar 2024 01:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cj/wRyZG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C902386;
	Thu, 28 Mar 2024 01:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711587889; cv=none; b=XYsesrF3tQ5qGcvgJH6wAg+3JCAs01wXzmYBKm2KRUFhsCGNMnTkisk6S4mDlmn+bT7ix05ivkWX1StODf6V4I0ONPhiXclzu956J5LDr/31fDeItoq6jNIOiyJi0EGSXJcWbky4M7FxxaxAUJ0/YEKV8hxbnCx3zaG/RBwOgzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711587889; c=relaxed/simple;
	bh=ODTY/+5GEj70aq4Me3Q78wpIvSHWibrd9gcFfA1okEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=owntYpJepqaq/F6A0xKF13amSvrA02SqEx4DbAU7sbNp3+2N3rLUIZfxVukTM96a538meG4TAhiYj46VdSuCq48oYbKqQjIPufplwcQZHn1BUhaEW6NAT9o0WgfYBsDy9IG9Yp++s6gpUDIbzMHRParHpOOU2DEirfjUcJG81bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cj/wRyZG; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711587887; x=1743123887;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ODTY/+5GEj70aq4Me3Q78wpIvSHWibrd9gcFfA1okEk=;
  b=cj/wRyZGiYQkFzNLNGOgzZnl9CVrRQUKMSt1IWjVHPR6iCxUAQeBgvR+
   5PPWVmYUnG7labxm+DIbjH19TiSnuOZcgOIEAhQj5GJ11bOow/bgsWtb6
   EeVzE5Oe3n9fY1kkCNljcGmNgppwgW+evDTxFeDFgN7l4gQ8LqFH98HAI
   h72+o6tqrjefBumI7mvTqbgqKmncFZTB5q0ht8V4OR5sBROjl9LLcNceQ
   YCNvNhpzvt2zxScVcQ9teGjeBpNC3AXxGAQkiGSpZub/PnUXgFv7KUqwf
   ZoGFtqHe8wKbf4Bcg8AtNRjeSf4K9gc90VERvZxfWyCD2KS1ewOv7gze9
   g==;
X-CSE-ConnectionGUID: OzRFaG3gScmnXe2pBlHxsg==
X-CSE-MsgGUID: y9g6QfNJQ5qzNfW/0UNbDw==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6579149"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="6579149"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 18:04:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="47685904"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 18:04:42 -0700
Message-ID: <494b2a74-1351-49f6-9d2e-57eda908c2b5@intel.com>
Date: Thu, 28 Mar 2024 09:04:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Gao, Chao" <chao.gao@intel.com>, "Zhang, Tina" <tina.zhang@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
 "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yuan, Hang"
 <hang.yuan@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <20240325231058.GP2357401@ls.amr.corp.intel.com>
 <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
 <20240325233528.GQ2357401@ls.amr.corp.intel.com>
 <ZgIzvHKobT2K8LZb@chao-email>
 <20db87741e356e22a72fadeda8ab982260f26705.camel@intel.com>
 <ZgKt6ljcmnfSbqG/@chao-email>
 <20240326174859.GB2444378@ls.amr.corp.intel.com>
 <481141ba-4bdf-40f3-9c32-585281c7aa6f@intel.com>
 <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
 <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>
 <20240328003637.GM2444378@ls.amr.corp.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240328003637.GM2444378@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/28/2024 8:36 AM, Isaku Yamahata wrote:
> On Thu, Mar 28, 2024 at 08:06:53AM +0800,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> On 3/28/2024 1:36 AM, Edgecombe, Rick P wrote:
>>> On Wed, 2024-03-27 at 10:54 +0800, Xiaoyao Li wrote:
>>>>>> If QEMU doesn't configure the msr filter list correctly, KVM has to handle
>>>>>> guest's MTRR MSR accesses. In my understanding, the
>>>>>> suggestion is KVM zap private memory mappings.
>>
>> TDX spec states that
>>
>>    18.2.1.4.1 Memory Type for Private and Opaque Access
>>
>>    The memory type for private and opaque access semantics, which use a
>>    private HKID, is WB.
>>
>>    18.2.1.4.2 Memory Type for Shared Accesses
>>
>>    Intel SDM, Vol. 3, 28.2.7.2 Memory Type Used for Translated Guest-
>>    Physical Addresses
>>
>>    The memory type for shared access semantics, which use a shared HKID,
>>    is determined as described below. Note that this is different from the
>>    way memory type is determined by the hardware during non-root mode
>>    operation. Rather, it is a best-effort approximation that is designed
>>    to still allow the host VMM some control over memory type.
>>      • For shared access during host-side (SEAMCALL) flows, the memory
>>        type is determined by MTRRs.
>>      • For shared access during guest-side flows (VM exit from the guest
>>        TD), the memory type is determined by a combination of the Shared
>>        EPT and MTRRs.
>>        o If the memory type determined during Shared EPT walk is WB, then
>>          the effective memory type for the access is determined by MTRRs.
>>        o Else, the effective memory type for the access is UC.
>>
>> My understanding is that guest MTRR doesn't affect the memory type for
>> private memory. So we don't need to zap private memory mappings.
> 
> So, there is no point to (try to) emulate MTRR.  The direction is, don't
> advertise MTRR to the guest (new TDX module is needed.) or enforce
> the guest to not use MTRR (guest command line clearcpuid=mtrr).  

Ideally, it would be better if TD guest learns to disable/not use MTRR 
itself.

> KVM will
> simply return error to guest access to MTRR related registers.
> 
> QEMU or user space VMM can use the MSR filter if they want.
> 
> 
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
>>> I'm ok just always doing the exit to userspace on attempt to use MTRRs in a TD, and not rely on the
>>> MSR list. At least I don't see the problem.
>>
>> What is the exit reason in vcpu->run->exit_reason? KVM_EXIT_X86_RDMSR/WRMSR?
>> If so, it breaks the ABI on KVM_EXIT_X86_RDMSR/WRMSR.
> 
> It's only when the user space requested it with the MSR filter.

right. But userspace has no reason to filter them because userspace can 
do nothing except 1) either kill the TD, or 2) eat the instruction.

