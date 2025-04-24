Return-Path: <kvm+bounces-44109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1187A9A78A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 11:18:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27BA44421A1
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 09:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F33FE20C02A;
	Thu, 24 Apr 2025 09:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DZumLill"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FFCD528
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 09:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745486314; cv=none; b=Bf8JtDgjTF3yYGIC+HPLkmfqnG4TELtuzo/J3C76/e7OvC5Motr9cdx1XOL2c5DJyVk9M8635JX41hR38iu7/Hb1dJvKhqadFa3og5GcZgF9xjdBBldS8gTDz0qJ9zwicSQvpuAGilwFjqyYps6J+LQRewBoCY3T9fFK7bnW53w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745486314; c=relaxed/simple;
	bh=hB2CNfkCvaHACzXnyYXCpWh9DPQM+mtemGcXrmpDwMg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dkXVYpDZUh6lnf+40DuDT8USArQDqInDNxRI/ZZc1GbdI2zDxIIkSycSvwKp051luo97CmEAY7XZX2ygSxfebi3f+GxY65arsgjWnetP9w0d3f6E4hoibJhvIdFv9jRRJbJAcuPrX6OpyQj+uC7+t/2Ymu8IxtjNkpfgqYxUXIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DZumLill; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745486313; x=1777022313;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hB2CNfkCvaHACzXnyYXCpWh9DPQM+mtemGcXrmpDwMg=;
  b=DZumLillSyAYhHv7b1ZnMldt3YzSAtGzMhrQrKgDWJdM4ljrnmmxcp2N
   8Yie4G2utfYdgq3Bd027gDyWkp2eKa3kcLed3FztWGPhy3iwtr3v63iKp
   9Od0g7ixkZYte6rXQHO0Ieev/YaOB29WW1nH6KJKlRSykrRKVQQMsuKK0
   vDoP6mLnjqAyGZHiUPUuB9C1tnKi+9lcR+z0txsWlM9nFsKH1FAM7UdBO
   ayDKmmbg7DFoGZWfAcjkzbmPiv8QBGMCkSTIaQjrCNMkyxGRoFhZwXLnT
   VZfC30ExhqBTrbUZuwzJC1MEGNbTwt31CvvHJsvQgCwNHCJ3J9dBK39no
   Q==;
X-CSE-ConnectionGUID: MU/7g9X7Tv2LETNYV/ZlkQ==
X-CSE-MsgGUID: RTUlpHXNQa6cewW0nZeOlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="64639050"
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="64639050"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 02:18:32 -0700
X-CSE-ConnectionGUID: DP0TMbNqQ72bgug7nWTHwg==
X-CSE-MsgGUID: LVmWOP/iSVW6wm4IRBmA5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="132406339"
Received: from unknown (HELO [10.238.12.140]) ([10.238.12.140])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 02:18:29 -0700
Message-ID: <2c070dfe-5e50-4dbf-a52a-6b5e3a1da9ff@linux.intel.com>
Date: Thu, 24 Apr 2025 17:18:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Drop "KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall"
To: Paolo Bonzini <pbonzini@redhat.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Shutemov, Kirill" <kirill.shutemov@intel.com>,
 "Wu, Binbin" <binbin.wu@intel.com>
References: <da3e2f6bdc67b1b02d99a6b57ffc9df48a0f4743.camel@intel.com>
 <5e7e8cb7-27b2-416d-9262-e585034327be@redhat.com>
 <86730ddd2e0cd8d3a901ffbb8117d897211a9cd4.camel@intel.com>
 <CABgObfaMRjeyhnP+QvTcZ+jKb6q-opCQ_a_MBFbj3AYF0ZDewg@mail.gmail.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <CABgObfaMRjeyhnP+QvTcZ+jKb6q-opCQ_a_MBFbj3AYF0ZDewg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/23/2025 10:09 PM, Paolo Bonzini wrote:
> On Sat, Apr 19, 2025 at 12:16 AM Edgecombe, Rick P
> <rick.p.edgecombe@intel.com> wrote:
>> TDG.VP.VMCALL<INSTRUCTION.WBINVD> - Missing
>> TDG.VP.VMCALL<INSTRUCTION.PCONFIG> - Missing
> WBINVD and PCONFIG need to be implemented (PCONFIG can be a stub).
>
>> TDG.VP.VMCALL<Service.Query> - Missing
>> TDG.VP.VMCALL<Service.MigTD> - Missing
> Service needs to be implemented and return Unsupported (0xFFFFFFFE)
> for all services.
>
>> TDG.VP.VMCALL<GETQUOTE> - Have patches, but missing
>> TDG.VP.VMCALL<SETUPEVENTNOTIFYINTERRUPT> - Have patches, but missing
> These two need to be supported by userspace and one could say that
> (therefore) GetTdVmCallInfo would also have to be implemented by
> userspace. This probably is a good idea in general to leave the door
> open to more GetTdVmCallInfo leaves.
>
> In order to make it easy for userspace to implement GetQuote, it would
> be nice to have a status for Unsupported
> listed for GetQuote, because they need to add it anyway for future tdvcalls
>
> SetupEventNotifyInterrupt can be a stub if GetQuote is unsupported;
> therefore it's also trivial for userspace to implement it if the specs
> adds the "unsupported" return code for GetQuote.

IIUC, there are two things:
1. Add a "unsupported" status code to GHCI spec and list "unsupported" as the
    possible return code for GetQuote.
2. Userspace still needs handle the exit reason due to GetQuote and
    SetupEventNotifyInterrupt. But Userspace has two choices:
    - To have a full implementation for GetQuote, and also a full implementation
      for SetupEventNotifyInterrupt.
    - Just return "unsupported" for GetQuote, and the handling for
      SetupEventNotifyInterrupt can be a stub.

It is correct?

>
>> Xiaoyao was tossing around the idea of adding a dedicated "not implemented"
>> return code too. It could make it simpler to evolve the GHCI spec vs the all or
>> nothing approach. To me, the main finding here is that we need to have more
>> clarity on how the GHCI will evolve going forward.
> I agree that both of these are independently useful, the main action
> item for KVM being to move TdVmCallInfo to userspace

Implementing GetTdVmCallInfo in userspace is helpful only when there is GHCI
spec update, i.e., userspace is able to return the bitmaps for supported
TDVMCALLs, right?

Before the GHCI is changed, can we just leave the implementation of
GetTdVmCallInfo as it is or we want the userspace to implement GetTdVmCallInfo
now?


>   and add support
> for the other two userspace TDCALLs.
>
> Adding WBINVD/PCONFIG/Service is also something that has to be done,
> but less urgent since nobody is using them.
>
>
> Paolo
>
>


