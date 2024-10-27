Return-Path: <kvm+bounces-29764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D03AA9B1E02
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 15:06:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 984EB281B4D
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 14:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7E63165EFC;
	Sun, 27 Oct 2024 14:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T9M0HXc6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6D9566A;
	Sun, 27 Oct 2024 14:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730037987; cv=none; b=kwA5fKcRqzxxpGFFU5kUN9sX91EtYBrnfNc/Tm6Wyg1Jn5mieE136JnXgT6spkVXuzTvZeUUyVIcYS0g0alHuY5KmOCCmVv5qw3xhiJ7FK4fFTGKQE8wpP3SjPKw0trOAbf2gOM1uoiCD0AyhRBQSXXIqCzGHg0lw0aZLZtaVB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730037987; c=relaxed/simple;
	bh=+w719NZeWpJQATCySgxL+7T4ydNQQFE6MvtDCIXUBKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m9S/awnY49yehIdYtCQa01Gf9LGgRONeQ8yUUp1YLeMwlSzmMBCEONQy6kCHbsuGQ+2b72gwjjeFr2nSeL7iBWb9V2EibjL0AhdpFAALyl4wb4LZMp4G+WndO9GDjIqjZ7JR+m9qIp29ah9mJMwWr4dnZZhNnhHN7LRwi546tm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T9M0HXc6; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730037986; x=1761573986;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+w719NZeWpJQATCySgxL+7T4ydNQQFE6MvtDCIXUBKQ=;
  b=T9M0HXc6lrLj68rO1BTdTOWZ1cg9iIofxL3Gr8u/kNlkc8HtcvPnZnsA
   QDTMSXWukIhQGKhRbuG394swDAtKowEIHTGKpZ1rthCLieK5IOmLrdqYu
   mzo0yaAXinhtGI6LRaKEYyIoAPgqf+U3/5wbcHsaGxNiQF0Dvk7OqfAsK
   mzYAlM3QqWk/hbMeST9vK41jpKahuzXpE/fowIs52RWDN60h/7gGoql1Q
   xeb6Qgx4i+8WItZmJy53LJeseuMS/r5QCkj5NjLJAeB244I+I7nhdYpCX
   cfTXYb8uHHrrbWwgwkPb/+04il1YHHGZM9HXWWCpNOyAMOI0W63HRbcUg
   w==;
X-CSE-ConnectionGUID: kUXigcBfRZW5A77hlKN4Cg==
X-CSE-MsgGUID: 7fxoS/A6RCS0GL/21w96eA==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="33557709"
X-IronPort-AV: E=Sophos;i="6.11,237,1725346800"; 
   d="scan'208";a="33557709"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2024 07:06:25 -0700
X-CSE-ConnectionGUID: n8a56hwLS8+he2G/BxEBOw==
X-CSE-MsgGUID: tuaZi8akSUKfju80jbQPCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,237,1725346800"; 
   d="scan'208";a="81323263"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.172]) ([10.124.227.172])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2024 07:06:21 -0700
Message-ID: <81e6604b-fa84-4b74-b9e6-2a37e8076fd7@intel.com>
Date: Sun, 27 Oct 2024 22:06:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] KVM: kvm-coco-queue: Support protected TSC
To: Marcelo Tosatti <mtosatti@redhat.com>, "Nikunj A. Dadhania"
 <nikunj@amd.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
 pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>,
 chao.gao@intel.com, rick.p.edgecombe@intel.com, yan.y.zhao@intel.com,
 linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
 Tom Lendacky <thomas.lendacky@amd.com>
References: <cover.1728719037.git.isaku.yamahata@intel.com>
 <c4df36dc-9924-e166-ec8b-ee48e4f6833e@amd.com> <ZxvGPZDQmqmoT0Sj@tpad>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZxvGPZDQmqmoT0Sj@tpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/26/2024 12:24 AM, Marcelo Tosatti wrote:
> On Mon, Oct 14, 2024 at 08:17:19PM +0530, Nikunj A. Dadhania wrote:
>> Hi Isaku,
>>
>> On 10/12/2024 1:25 PM, Isaku Yamahata wrote:
>>> This patch series is for the kvm-coco-queue branch.  The change for TDX KVM is
>>> included at the last.  The test is done by create TDX vCPU and run, get TSC
>>> offset via vCPU device attributes and compare it with the TDX TSC OFFSET
>>> metadata.  Because the test requires the TDX KVM and TDX KVM kselftests, don't
>>> include it in this patch series.
>>>
>>>
>>> Background
>>> ----------
>>> X86 confidential computing technology defines protected guest TSC so that the
>>> VMM can't change the TSC offset/multiplier once vCPU is initialized and the
>>> guest can trust TSC.  The SEV-SNP defines Secure TSC as optional.  TDX mandates
>>> it.  The TDX module determines the TSC offset/multiplier.  The VMM has to
>>> retrieve them.
>>>
>>> On the other hand, the x86 KVM common logic tries to guess or adjust the TSC
>>> offset/multiplier for better guest TSC and TSC interrupt latency at KVM vCPU
>>> creation (kvm_arch_vcpu_postcreate()), vCPU migration over pCPU
>>> (kvm_arch_vcpu_load()), vCPU TSC device attributes (kvm_arch_tsc_set_attr()) and
>>> guest/host writing to TSC or TSC adjust MSR (kvm_set_msr_common()).
>>>
>>>
>>> Problem
>>> -------
>>> The current x86 KVM implementation conflicts with protected TSC because the
>>> VMM can't change the TSC offset/multiplier.  Disable or ignore the KVM
>>> logic to change/adjust the TSC offset/multiplier somehow.
>>>
>>> Because KVM emulates the TSC timer or the TSC deadline timer with the TSC
>>> offset/multiplier, the TSC timer interrupts are injected to the guest at the
>>> wrong time if the KVM TSC offset is different from what the TDX module
>>> determined.
>>>
>>> Originally the issue was found by cyclic test of rt-test [1] as the latency in
>>> TDX case is worse than VMX value + TDX SEAMCALL overhead.  It turned out that
>>> the KVM TSC offset is different from what the TDX module determines.
>>
>> Can you provide what is the exact command line to reproduce this problem ?
> 
> Nikunj,
> 
> Run cyclictest, on an isolated CPU, in a VM. For the maximum latency
> metric, rather than 50us, one gets 500us at times.
> 
>> Any links to this reported issue ?
> 
> This was not posted publically. But its not hard to reproduce.
> 
>>> Solution
>>> --------
>>> The solution is to keep the KVM TSC offset/multiplier the same as the value of
>>> the TDX module somehow.  Possible solutions are as follows.
>>> - Skip the logic
>>>    Ignore (or don't call related functions) the request to change the TSC
>>>    offset/multiplier.
>>>    Pros
>>>    - Logically clean.  This is similar to the guest_protected case.
>>>    Cons
>>>    - Needs to identify the call sites.
>>>
>>> - Revert the change at the hooks after TSC adjustment
>>>    x86 KVM defines the vendor hooks when the TSC offset/multiplier are
>>>    changed.  The callback can revert the change.
>>>    Pros
>>>    - We don't need to care about the logic to change the TSC offset/multiplier.
>>>    Cons:
>>>    - Hacky to revert the KVM x86 common code logic.
>>>
>>> Choose the first one.  With this patch series, SEV-SNP secure TSC can be
>>> supported.
>>
>> I am not sure how will this help SNP Secure TSC, as the GUEST_TSC_OFFSET and
>> GUEST_TSC_SCALE are only available to the guest.
> 
> Nikunj,
> 
> FYI:
> 
> SEV-SNP processors (at least the one below) do not seem affected by this problem.

Did you apply Secure TSC patches of (guest kernel, KVM and QEMU) 
manualy? because none of them are merged. Otherwise, I think SNP guest 
is still using KVM emulated TSC.

> At least this one:
> 
> vendor_id	: AuthenticAMD
> cpu family	: 25
> model		: 17
> model name	: AMD EPYC 9124 16-Core Processor
> 
> 


