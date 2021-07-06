Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6EBA3BC748
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 09:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhGFHgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 03:36:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:54950 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230274AbhGFHgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jul 2021 03:36:47 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10036"; a="196236943"
X-IronPort-AV: E=Sophos;i="5.83,328,1616482800"; 
   d="scan'208";a="196236943"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2021 00:33:54 -0700
X-IronPort-AV: E=Sophos;i="5.83,328,1616482800"; 
   d="scan'208";a="486033596"
Received: from liujing-mobl.ccr.corp.intel.com (HELO [10.238.130.207]) ([10.238.130.207])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2021 00:33:52 -0700
Subject: Re: [PATCH RFC 2/7] kvm: x86: Introduce XFD MSRs as passthrough to
 guest
To:     Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-3-jing2.liu@linux.intel.com>
 <YKwd5OTXr97Fxfok@google.com>
 <d6e7328d-335f-b244-48d7-4ffe8b04fb05@intel.com>
 <3c63438b-2a42-0b81-f002-b937095570e1@linux.intel.com>
 <895e41d7-b64c-e398-c4e2-6309c747068d@intel.com>
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Message-ID: <7a59f745-6ffa-ae5f-fd66-9fca9ae95533@linux.intel.com>
Date:   Tue, 6 Jul 2021 15:33:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <895e41d7-b64c-e398-c4e2-6309c747068d@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/30/2021 1:58 AM, Dave Hansen wrote:
> On 6/27/21 7:00 PM, Liu, Jing2 wrote:
>> On 6/24/2021 1:50 AM, Dave Hansen wrote:
>>> On 5/24/21 2:43 PM, Sean Christopherson wrote:
>>>> On Sun, Feb 07, 2021, Jing Liu wrote:
>>>>> Passthrough both MSRs to let guest access and write without vmexit.
>>>> Why?  Except for read-only MSRs, e.g. MSR_CORE_C1_RES,
>>>> passthrough MSRs are costly to support because KVM must context
>>>> switch the MSR (which, by the by, is completely missing from the
>>>> patch).
>>>>
>>>> In other words, if these MSRs are full RW passthrough, guests
>>>> with XFD enabled will need to load the guest value on entry, save
>>>> the guest value on exit, and load the host value on exit.  That's
>>>> in the neighborhood of a 40% increase in latency for a single
>>>> VM-Enter/VM-Exit roundtrip (~1500 cycles =>
>>>>> 2000 cycles).
>>> I'm not taking a position as to whether these _should_ be passthrough or
>>> not.  But, if they are, I don't think you strictly need to do the
>>> RDMSR/WRMSR at VM-Exit time.
>> Hi Dave,
>>
>> Thanks for reviewing the patches.
>>
>> When vmexit, clearing XFD (because KVM thinks guest has requested AMX) can
>> be deferred to the time when host does XSAVES, but this means need a new
>> flag in common "fpu" structure or a common macro per thread which works
>> only dedicated for KVM case, and check the flag in 1) switch_fpu_prepare()
>> 2) kernel_fpu_begin() . This is the concern to me.
> Why is this a concern?  You're worried about finding a single bit worth
> of space somewhere?
A bit of flag can be found so far though the space is somehow nervous. 
What I
am worrying about is, we introduce a flag per thread and add the check 
in core
place like softirq path and context switch path, to handle a case only 
for KVM
thread + XFD=1 + AMX usage in guest. This is not a quite frequent case 
but we
need check every time for every thread.

I am considering using XGETBV(1) (~24 cycles) to detect if KVM really need
wrmsr(0) to clear XFD for guest AMX state when vmexit. And this is not a 
quite
frequent case I think. Only one concern is, does/will kernel check 
somewhere that
thread's memory fpu buffer is already large but thread's XFD=1? (I 
believe not)

Thanks,
Jing

>   

