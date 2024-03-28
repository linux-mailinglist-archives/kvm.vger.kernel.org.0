Return-Path: <kvm+bounces-12916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8A6988F3AA
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:26:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D93821C32533
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 00:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9436B14277;
	Thu, 28 Mar 2024 00:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WcRTjBq6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA044FBF0;
	Thu, 28 Mar 2024 00:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711585401; cv=none; b=ZeSXFThYtPXlQ8ZuxcMq85RsS3ADXyGAgawxtdczaLy2h+Qce3RrufO4egSQ9dNWKsLV1RjnryV6cOdmvQ/+i6qhNHtYlZQqhjtJLo8JEClsuJ8mI1bmzDTeoBf9HlgZail5zHhAmzaZwTyTj1oQZCubFJLAVTS3fJ4BUbRu97Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711585401; c=relaxed/simple;
	bh=adqtvT35VWw2tK6LKPCT9cc6amygwx8QBJXdyBFlnOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dSIuCEVxv5cl90zLYJ4MRp1pRiYY7qqMqmPxm4GB0S0oSHftt+4q4GJKl+rkLorjknJ5ztZeHySbzEYRtYgZV+W6NVMubzZiTlJSnmm9U/CNK33u5uU7lCDUqXAfH9vOzsqgo3QpamqyFn2jDLoXFDBQYp++wXcEY4Y6QspQIPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WcRTjBq6; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711585400; x=1743121400;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=adqtvT35VWw2tK6LKPCT9cc6amygwx8QBJXdyBFlnOg=;
  b=WcRTjBq6Z08n4Q5+kDlJxD1pb5P7vpmfKSYaumjjNN6a3jm2sMRZQ96r
   e2Pm5/o2h41ks2Eu6RWIGFhF2r/iixkNYkz04lIeFkPRAWKHnvi7yqxqE
   KymllMhTX7umzGdtFGDtjvPzab71anFlhwHfUKAhy+N8O4yqPkIP4zbbQ
   JpErv86abRpAeIprQQpNeFRgX3otv0+LZxnhs7Sgo3WzLPq7nXdAQdLX6
   khwypgxXnHgX/AUMbB3zVALs07VFJAckGOK533P+PtvrgtI+0wLFLaXjw
   szmJWKRY//CQo/kYdysc2wDIEg+xEuTkTy5mLn0S7fNRDyljk0TqkFufY
   w==;
X-CSE-ConnectionGUID: HIR7DxGmTSS7AnDdQe6Hvg==
X-CSE-MsgGUID: DMbFAspsT/KhgjvHtQsidQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="10501379"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="10501379"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 17:23:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="21183889"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 17:23:15 -0700
Message-ID: <8fd5caa9-c606-49e1-90a0-bfc407f0c016@intel.com>
Date: Thu, 28 Mar 2024 08:23:12 +0800
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
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
Cc: "Zhang, Tina" <tina.zhang@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, "Chen, Bo2"
 <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "Yuan, Hang" <hang.yuan@intel.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1ed955a44cd81738b498fe52823766622d8ad57f.1708933498.git.isaku.yamahata@intel.com>
 <618614fa6c62a232d95da55546137251e1847f48.camel@intel.com>
 <20240319235654.GC1994522@ls.amr.corp.intel.com>
 <1c2283aab681bd882111d14e8e71b4b35549e345.camel@intel.com>
 <f63d19a8fe6d14186aecc8fcf777284879441ef6.camel@intel.com>
 <20240321225910.GU1994522@ls.amr.corp.intel.com>
 <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
 <20240325190525.GG2357401@ls.amr.corp.intel.com>
 <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/26/2024 3:55 AM, Edgecombe, Rick P wrote:
> On Mon, 2024-03-25 at 12:05 -0700, Isaku Yamahata wrote:
>> Right, the guest has to accept it on VE.  If the unmap was intentional by guest,
>> that's fine.  The unmap is unintentional (with vMTRR), the guest doesn't expect
>> VE with the GPA.
>>
>>
>>> But, I guess we should punt to userspace is the guest tries to use
>>> MTRRs, not that userspace can handle it happening in a TD...  But it
>>> seems cleaner and safer then skipping zapping some pages inside the
>>> zapping code.
>>>
>>> I'm still not sure if I understand the intention and constraints fully.
>>> So please correct. This (the skipping the zapping for some operations)
>>> is a theoretical correctness issue right? It doesn't resolve a TD
>>> crash?
>>
>> For lapic, it's safe guard. Because TDX KVM disables APICv with
>> APICV_INHIBIT_REASON_TDX, apicv won't call kvm_zap_gfn_range().
> Ah, I see it:
> https://lore.kernel.org/lkml/38e2f8a77e89301534d82325946eb74db3e47815.1708933498.git.isaku.yamahata@intel.com/
> 
> Then it seems a warning would be more appropriate if we are worried there might be a way to still
> call it. If we are confident it can't, then we can just ignore this case.
> 
>>
>> For MTRR, the purpose is to make the guest boot (without the guest kernel
>> command line like clearcpuid=mtrr) .
>> If we can assume the guest won't touch MTRR registers somehow, KVM can return an
>> error to TDG.VP.VMCALL<RDMSR, WRMSR>(MTRR registers). So it doesn't call
>> kvm_zap_gfn_range(). Or we can use KVM_EXIT_X86_{RDMSR, WRMSR} as you suggested.
> 
> My understanding is that Sean prefers to exit to userspace when KVM can't handle something, versus
> making up behavior that keeps known guests alive. So I would think we should change this patch to
> only be about not using the zapping roots optimization. Then a separate patch should exit to
> userspace on attempt to use MTRRs. And we ignore the APIC one.

Certainly no. If exit to userspace, what is the exit reason and what is 
expected for userspace to do? userspace can do nothing, except either 
kill the TD or eat the RDMSR/WRMSR.

There is nothing to do with userspace. MTRR is virtualized as fixed1 for 
TD (by current TDX architecture). Userspace can do nothing on it and 
it's not userspace's fault to let TD guest manipulate on MTRR MSRs.

This is the bad design of current TDX, what KVM should do is return 
error to TD on TDVMCALL of WR/RDMSR on MTRR MSRs. This should be a known 
flaw of TDX that MTRR is not supported though TD guest reads the MTRR 
CPUID as 1.

This flaw should be fixed by TDX architecture that making MTRR 
configurable. At that time, userspace is responsible to set MSR filter 
on MTRR MSRs if it wants to configure the MTRR CPUID to 1.

> This is trying to guess what maintainers would want here. I'm less sure what Paolo prefers.


