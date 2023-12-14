Return-Path: <kvm+bounces-4414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AAEE8812550
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 03:32:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BE751F21A46
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 02:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2F6FA52;
	Thu, 14 Dec 2023 02:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AElfrpSC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78896BD
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702521166; x=1734057166;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cuMEPDC6iOcSuYLCnaEqkUs2dUvtb3vqUC6bEIFYrF0=;
  b=AElfrpSCg48qWUmPfMCuWt6phfgeUIupbzNhzGklAFm57mXZviZYbyaM
   QGZm3rC36KlDIFCurhn3rQ8ZhQi5GUC0N0un8owxXKQERyHf7ZIWylIKC
   Yucy1HNHwaqxSPkG1FMs0dcu/BMxCAsSuJG3nf8+fb3YQQ265uKdBf02Y
   S3Tp7BWgwiAHXodZcRW5bqQ/ubHgBzaLrXfxcgHjp9s7HEk2+zG4X3a9e
   mB9TteJ6EwwxVBbJ1bwBx5g++/UabOQpfnEneHYjLtBpk4h1LmBpTej6v
   d8NTLWWfUiEpjSfsPHsTEE5vgzGgcMj2AQ/Gj2ifyY+CfaYah8eeY1VPy
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="1876934"
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="1876934"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 18:32:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10923"; a="864854775"
X-IronPort-AV: E=Sophos;i="6.04,274,1695711600"; 
   d="scan'208";a="864854775"
Received: from danwu1-mobl.ccr.corp.intel.com (HELO [10.238.4.153]) ([10.238.4.153])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 18:32:44 -0800
Message-ID: <64899538-a99b-41bf-8924-5506fc70bf7d@intel.com>
Date: Thu, 14 Dec 2023 10:32:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v1 0/3] x86: fix async page fault issues
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, xiaoyao.li@intel.com
References: <20231212062708.16509-1-dan1.wu@intel.com>
 <ZXh5fJonSWLcHmkN@google.com>
 <67f29426-7af4-4b07-a22e-fdf89a7b452c@intel.com>
 <ZXn10V63oCZ2NicV@google.com>
From: "Wu, Dan1" <dan1.wu@intel.com>
In-Reply-To: <ZXn10V63oCZ2NicV@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 12/14/2023 2:20 AM, Sean Christopherson wrote:
> On Wed, Dec 13, 2023, Dan1 Wu wrote:
>> On 12/12/2023 11:17 PM, Sean Christopherson wrote:
>>> On Tue, Dec 12, 2023, Dan Wu wrote:
>>>> When running asyncpf test, it gets skipped without a clear reason:
>>>>
>>>>       ./asyncpf
>>>>
>>>>       enabling apic
>>>>       smp: waiting for 0 APs
>>>>       paging enabled
>>>>       cr0 = 80010011
>>>>       cr3 = 107f000
>>>>       cr4 = 20
>>>>       install handler
>>>>       enable async pf
>>>>       alloc memory
>>>>       start loop
>>>>       end loop
>>>>       start loop
>>>>       end loop
>>>>       SUMMARY: 0 tests
>>>>       SKIP asyncpf (0 tests)
>>>>
>>>> The reason is that KVM changed to use interrupt-based 'page-ready' notification
>>>> and abandoned #PF-based 'page-ready' notification mechanism. Interrupt-based
>>>> 'page-ready' notification requires KVM_ASYNC_PF_DELIVERY_AS_INT to be set as well
>>>> in MSR_KVM_ASYNC_PF_EN to enable asyncpf.
>>>>
>>>> This series tries to fix the problem by separating two testcases for different mechanisms.
>>>>
>>>> - For old #PF-based notification, changes current asyncpf.c to add CPUID check
>>>>     at the beginning. It checks (KVM_FEATURE_ASYNC_PF && !KVM_FEATURE_ASYNC_PF_INT),
>>>>     otherwise it gets skipped.
>>>>
>>>> - For new interrupt-based notification, add a new test, asyncpf-int.c, to check
>>>>     (KVM_FEATURE_ASYNC_PF && KVM_FEATURE_ASYNC_PF_INT) and implement interrupt-based
>>>>     'page-ready' handler.
>>> Using #PF to deliver page-ready is completely dead, no?  Unless I'm mistaken, let's
>>> just drop the existing support and replace it with the interrupted-based mechanism.
>>> I see no reason to continue maintaining the old crud.  If someone wants to verify
>>> an old, broken KVM, then they can use the old version of  KUT.
>> Yes, since Linux v5.10 the feature asyncpf is deprecated.
>>
>> So, just drop asyncpf.c and add asyncpf_int.c is enough, right?
> I would rather not add asyncpf_int.c, and instead keep asyncpf.c and modify it to
> use ASYNC_PF_INT.  It _might_ be a bit more churn, but modifying the existing code
> instead of dropping in a new file will better preserve the history, and may also
> allow for finer grained patches (not sure on that one).

ok, I will modify it in the next version. Thanks for your review.


