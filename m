Return-Path: <kvm+bounces-56240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92133B3B118
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 04:43:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 677E4582CD2
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C730821FF3B;
	Fri, 29 Aug 2025 02:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MmWPmJ88"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B771E3769;
	Fri, 29 Aug 2025 02:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756435372; cv=none; b=Q7l2o08yJOCDfz7W4HWChf9FOkqyoOBDqMgzLzuDUOCguopw/lRzU8oTT1qnegs7VJbyJ0YPFD7gw+wP3qM4JMMyiuxDG8RGeUYT/jdG+bMVACaLtWx+ngj1zOEpyYdNEqHArRCp/ncpMjJzGABSBZHUxIMI/J7UjQ/KugjaZRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756435372; c=relaxed/simple;
	bh=VQnbS4/0Q9xrW5O9dpJn6/Yu/aUbWlvNwhMOn3XT+dU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sopVwT6XXJGYN07sNn1JclqAR/1Z+2QCXUsEa8mlcs0ZVZ1OmTz2B1uVldfBBNJT4+biQq8RdBCTeBV/CLIVFBeVdvz2MzhQBLmQpFxiEzceTCQFhGwJEkZ/4qmt6MfXenczAjZdAJIyDyFjLBtwXjvgJh8LAt4tGuLXqTFOOcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MmWPmJ88; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756435370; x=1787971370;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VQnbS4/0Q9xrW5O9dpJn6/Yu/aUbWlvNwhMOn3XT+dU=;
  b=MmWPmJ88UFWeAi2ln4vcu/DvtPNU+JO3/3XiwfbU+pmzopu2oh7/v/ZW
   lqNjBDWcC69opt3ixp76+26jqWeZs4uJ0yCZQUYTxXBYopwk9P6BMiC+F
   QYaCpqdHXbd2TgYu2cja42iOG20J33qoc09ppCNHNPhUgMsPmnAX60pPN
   TvbuS/h70JoahhGv5EWTdCWQABiW1U7cE0qPimyl1DlSuouWaJJUIUEGL
   rOqkELXjUJtpkr0lQok4fP2JoQfKTxnigZPIvMn0oJMBzQxVIt7qZCsPd
   tXVy2H0f6uYR4yk7keAHnaiZq3S/UXiFKJWOtOrnsg6YpfX2vCIaiHbyC
   A==;
X-CSE-ConnectionGUID: pTYWSRviSX6qruYYsaXC5w==
X-CSE-MsgGUID: gUljXIsWQ8aD6y0ZsmP/cA==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="76170495"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="76170495"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 19:42:50 -0700
X-CSE-ConnectionGUID: pxi3wMtTRgeCJHEM2IFA4w==
X-CSE-MsgGUID: HMUrB66JSMGaVNPXlzPHlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="207411686"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.233.111]) ([10.124.233.111])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 19:42:45 -0700
Message-ID: <dd31f894-9f89-42da-bbcd-1be859ef1fcf@linux.intel.com>
Date: Fri, 29 Aug 2025 10:42:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Annapurve, Vishal" <vannapurve@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "michael.roth@amd.com" <michael.roth@amd.com>,
 "Weiny, Ira" <ira.weiny@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-10-seanjc@google.com>
 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com> <aK9Xqy0W1ghonWUL@google.com>
 <aK/sdr2OQqYv9DBZ@yzhao56-desk.sh.intel.com> <aLCJ0UfuuvedxCcU@google.com>
 <fcfafa17b29cd24018c3f18f075a9f83b7f2f6e6.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <fcfafa17b29cd24018c3f18f075a9f83b7f2f6e6.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/29/2025 2:52 AM, Edgecombe, Rick P wrote:
> On Thu, 2025-08-28 at 10:00 -0700, Sean Christopherson wrote:
>> On Thu, Aug 28, 2025, Yan Zhao wrote:
[...]
>>>
>>> 3. Unexpected zaps (such as kvm_zap_gfn_range()).
>> Side topic related to kvm_zap_gfn_range(), the KVM_BUG_ON() in vt_refresh_apicv_exec_ctrl()
>> is flawed.  If kvm_recalculate_apic_map() fails to allocate an optimized map, KVM
>> will mark APICv as inhibited, i.e. the associated WARN_ON_ONCE() is effectively
>> user-triggerable.
>>
>> Easiest thing would be to mark the vCPU as dead (though we obviously need
>> "KVM: Never clear KVM_REQ_VM_DEAD from a vCPU's requests" for that to be robust).
>>
>>
>>
> I'm going need to look up the related apic discussions from the base series and
> circle back.
There was an analysis about the inhibit reasons for TDX.
https://lore.kernel.org/lkml/e3a2e8fa-b496-4010-9a8c-bfeb131bc43b@linux.intel.com/

As Sean mentioned, if kvm_recalculate_apic_map() fails to allocate the memory
for optimized map, it will trigger the KVM_BUG_ON() in
vt_refresh_apicv_exec_ctrl(). And kvzalloc() failure should not be treated as
KVM bug.

As talking about user-triggerable, the kvzalloc() failure path could be
triggered by KVM_CREATE_VCPU and KVM_TDX_INIT_VCPU for TD. After
KVM_TDX_INIT_VCPU, the mapping is not allowed to be changed.

Sean's suggested code change looks good to me.



