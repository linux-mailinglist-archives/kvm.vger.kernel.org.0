Return-Path: <kvm+bounces-4277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DB0A8107BB
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 02:38:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E3AF1C20E42
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 01:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FFAA1C2F;
	Wed, 13 Dec 2023 01:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R/2yqKYC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880B6B7
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 17:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702431484; x=1733967484;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=E5bo38G9wSrHW4X6lsQVsL4jEOOuwQSDXNiS3Q5rqh8=;
  b=R/2yqKYCi71oTOpGRhy2tHKmBajXhU6hBt7laNgrlEtyhLXAvX1r84z7
   xCwW2HSYAAaOQtkaxJSFqbqvrlXgw4psMJD6pRuQjyqC8uhbk5an51jYv
   Rqvpz3eXZcQcXvnGQzBVnJvozeOQ/yDYMpkbP+Bv8PS9VbAxdo/jrjhdc
   3ielszfLskUEx+nmBnSnYgPB2U9aKoOzjbHkQyb81zpcwMiHJrz6+efxz
   PI5ksg0gQ7zmSNsOWSAdGQTHmQrK+6b9PqDpDs/qGW5rGd2kL1YqlG+Ru
   SLvDy7Vs6RoWfwP+oHyqXkCIgQtnvanVXIukkGDhMN+l1x9LnEdNM+gdV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="1743024"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="1743024"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 17:38:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="807988078"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="807988078"
Received: from danwu1-mobl.ccr.corp.intel.com (HELO [10.238.4.153]) ([10.238.4.153])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 17:38:02 -0800
Message-ID: <67f29426-7af4-4b07-a22e-fdf89a7b452c@intel.com>
Date: Wed, 13 Dec 2023 09:36:56 +0800
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
From: "Wu, Dan1" <dan1.wu@intel.com>
In-Reply-To: <ZXh5fJonSWLcHmkN@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 12/12/2023 11:17 PM, Sean Christopherson wrote:
> On Tue, Dec 12, 2023, Dan Wu wrote:
>> When running asyncpf test, it gets skipped without a clear reason:
>>
>>      ./asyncpf
>>
>>      enabling apic
>>      smp: waiting for 0 APs
>>      paging enabled
>>      cr0 = 80010011
>>      cr3 = 107f000
>>      cr4 = 20
>>      install handler
>>      enable async pf
>>      alloc memory
>>      start loop
>>      end loop
>>      start loop
>>      end loop
>>      SUMMARY: 0 tests
>>      SKIP asyncpf (0 tests)
>>
>> The reason is that KVM changed to use interrupt-based 'page-ready' notification
>> and abandoned #PF-based 'page-ready' notification mechanism. Interrupt-based
>> 'page-ready' notification requires KVM_ASYNC_PF_DELIVERY_AS_INT to be set as well
>> in MSR_KVM_ASYNC_PF_EN to enable asyncpf.
>>
>> This series tries to fix the problem by separating two testcases for different mechanisms.
>>
>> - For old #PF-based notification, changes current asyncpf.c to add CPUID check
>>    at the beginning. It checks (KVM_FEATURE_ASYNC_PF && !KVM_FEATURE_ASYNC_PF_INT),
>>    otherwise it gets skipped.
>>
>> - For new interrupt-based notification, add a new test, asyncpf-int.c, to check
>>    (KVM_FEATURE_ASYNC_PF && KVM_FEATURE_ASYNC_PF_INT) and implement interrupt-based
>>    'page-ready' handler.
> Using #PF to deliver page-ready is completely dead, no?  Unless I'm mistaken, let's
> just drop the existing support and replace it with the interrupted-based mechanism.
> I see no reason to continue maintaining the old crud.  If someone wants to verify
> an old, broken KVM, then they can use the old version of  KUT.

Yes, since Linux v5.10 the feature asyncpf is deprecated.

So, just drop asyncpf.c and add asyncpf_int.c is enough, right?

>

