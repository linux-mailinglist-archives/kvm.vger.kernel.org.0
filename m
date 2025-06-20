Return-Path: <kvm+bounces-50004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 667B7AE10EF
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 04:10:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26754189FDFA
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 02:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A3A136996;
	Fri, 20 Jun 2025 02:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TQeEgBwb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCBB1B960;
	Fri, 20 Jun 2025 02:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750385448; cv=none; b=bpQHydcRUIA8JgMvs7eviQbhq0nyZFmxwDXEbYOwgVBkKlcE5rM3ofJhP1nIoZ2dEs5qWY8/pC+PoOPfw6T/KyhdGrXoM1UB4CTzJxyMt5AES4Qk6tBx7AIEQZZf1hli4Ezntdc/d49PEaNNcIz+BBR29B4lz9W9irW3mpARt4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750385448; c=relaxed/simple;
	bh=rpzwXgI/wdC7PukYCLNNXUJc379rvolsooYpGoXrrOY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ce6KIabed3YY5BOhjrzf02W+ZatNYEfCy1xJYdP9OKSOOB+M4WWONvwxoHY/tJEQNyF6gymNDu/UIdvJXUbN1xXtxJil4SXA3wNzcD8p3bJX/XVeYrMqJLpSPilMEya9IRgejZMjKkuFLNjnJkMQ7dlvC4slSWn54wzffmTRADU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TQeEgBwb; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750385446; x=1781921446;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rpzwXgI/wdC7PukYCLNNXUJc379rvolsooYpGoXrrOY=;
  b=TQeEgBwbop3+wL3nC8o+qxZuuYGnxOviqJSXzBWCtT0qEWpT29hIQ1OZ
   8VAC10q84Hru2dwSbJzlFXMhKryMTKYn8Xi6xSfHzTtZsmaLOKSxUWU+B
   UPeRBDcDZxNN51v731Jya0myGaZislXOSW+dkAvSIXHy/2f+f5KEZQKPH
   wmDVOqV7XeL3V80toAGfqoZEdUyWDODU2zsSLLBCM4v2NpIung+QUaWmN
   XO+0VB9wYPtDvvX5OV2r3uE+d1hlLJpBlkRQn66WcyNjpCj30BoLYk2F7
   LhWuybnodv48kGoKuG0qyv9GS4VH8VFzChFwhq+lr4PYL7ksD5rSI3Trm
   A==;
X-CSE-ConnectionGUID: gKKL4bELSouQHZHrbFuY5Q==
X-CSE-MsgGUID: KUw4jjH7QyeRoTy2KnAoUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="70206496"
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="70206496"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 19:10:45 -0700
X-CSE-ConnectionGUID: AvN2NqDvTuGjkDIam9sXCA==
X-CSE-MsgGUID: jXyP6gc6RP2Bo7n7WapLvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="151321290"
Received: from unknown (HELO [10.238.0.239]) ([10.238.0.239])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 19:10:43 -0700
Message-ID: <e6cbc907-92bd-4101-8eca-190bcfadb69f@linux.intel.com>
Date: Fri, 20 Jun 2025 10:10:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] TDX attestation support and GHCI fixup
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com,
 mikko.ylinen@linux.intel.com, kirill.shutemov@intel.com, jiewen.yao@intel.com
References: <20250619180159.187358-1-pbonzini@redhat.com>
 <3133d5e9-18d3-499a-a24d-170be7fb8357@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <3133d5e9-18d3-499a-a24d-170be7fb8357@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/20/2025 9:30 AM, Xiaoyao Li wrote:
> On 6/20/2025 2:01 AM, Paolo Bonzini wrote:
>> This is a refresh of Binbin's patches with a change to the userspace
>> API.  I am consolidating everything into a single KVM_EXIT_TDX and
>> adding to the contract that userspace is free to ignore it *except*
>> for having to reenter the guest with KVM_RUN.
>>
>> If in the future this does not work, it should be possible to introduce
>> an opt-in interface.  Hopefully that will not be necessary.
>
> For <GetTdVmCallInfo> exit, I think KVM still needs to report which TDVMCALL leaf will exit to userspace, to differentiate between different KVMs.

Yes, I planned a v2 to expose the bitmap of TDVMCALLs that KVM will exit to
userspace VMM for handling via KVM_TDX_CAPABILITIES.

>
> But it's not a must for current <GetQuote> since it exits to userspace from day 0. So that we can leave the report interface until KVM needs to support user exit of another TDVMCALL leaf.

Agree. This report interface can be added later when needed.

About the compatibility:
Since <GetQuote> is the only optional TDVMCALL for now and KVM always exit to
userspace for <GetQuote>, a userspace VMM can always set the bit for <GetQuote>
if it's supported in userspace.
Then
- First KVM release + new userspace VMM release with report interface.
   Userspace will see nothing reported by the interface, and it always sets
   <GetQuote> , which is expected.
- New KVM release with report interface + first userspace VMM release
   Userspace doesn't know the report interface and it only sets <GetQuote>, which
   is expected.

>
>> Paolo
>>
>> Binbin Wu (3):
>>    KVM: TDX: Add new TDVMCALL status code for unsupported subfuncs
>>    KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
>>    KVM: TDX: Exit to userspace for GetTdVmCallInfo
>>
>>   Documentation/virt/kvm/api.rst    | 62 ++++++++++++++++++++++++-
>>   arch/x86/include/asm/shared/tdx.h |  1 +
>>   arch/x86/kvm/vmx/tdx.c            | 77 ++++++++++++++++++++++++++++---
>>   include/uapi/linux/kvm.h          | 22 +++++++++
>>   4 files changed, 154 insertions(+), 8 deletions(-)
>>
>


