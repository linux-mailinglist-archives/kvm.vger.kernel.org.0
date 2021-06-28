Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033FA3B5715
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 04:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhF1CDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Jun 2021 22:03:06 -0400
Received: from mga05.intel.com ([192.55.52.43]:6569 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231678AbhF1CDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Jun 2021 22:03:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10028"; a="293510292"
X-IronPort-AV: E=Sophos;i="5.83,304,1616482800"; 
   d="scan'208";a="293510292"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2021 19:00:37 -0700
X-IronPort-AV: E=Sophos;i="5.83,304,1616482800"; 
   d="scan'208";a="418995167"
Received: from unknown (HELO [10.238.130.181]) ([10.238.130.181])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2021 19:00:35 -0700
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
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Message-ID: <3c63438b-2a42-0b81-f002-b937095570e1@linux.intel.com>
Date:   Mon, 28 Jun 2021 10:00:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <d6e7328d-335f-b244-48d7-4ffe8b04fb05@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/24/2021 1:50 AM, Dave Hansen wrote:
> On 5/24/21 2:43 PM, Sean Christopherson wrote:
>> On Sun, Feb 07, 2021, Jing Liu wrote:
>>> Passthrough both MSRs to let guest access and write without vmexit.
>> Why?  Except for read-only MSRs, e.g. MSR_CORE_C1_RES, passthrough MSRs are
>> costly to support because KVM must context switch the MSR (which, by the by, is
>> completely missing from the patch).
>>
>> In other words, if these MSRs are full RW passthrough, guests with XFD enabled
>> will need to load the guest value on entry, save the guest value on exit, and
>> load the host value on exit.  That's in the neighborhood of a 40% increase in
>> latency for a single VM-Enter/VM-Exit roundtrip (~1500 cycles => >2000 cycles).
> I'm not taking a position as to whether these _should_ be passthrough or
> not.  But, if they are, I don't think you strictly need to do the
> RDMSR/WRMSR at VM-Exit time.
Hi Dave,

Thanks for reviewing the patches.

When vmexit, clearing XFD (because KVM thinks guest has requested AMX) can
be deferred to the time when host does XSAVES, but this means need a new
flag in common "fpu" structure or a common macro per thread which works
only dedicated for KVM case, and check the flag in 1) switch_fpu_prepare()
2) kernel_fpu_begin() . This is the concern to me.

Thanks,
Jing
> Just like the "FPU", XFD isn't be used in normal kernel code.  This is
> why we can be lazy about FPU state with TIF_NEED_FPU_LOAD.  I _suspect_
> that some XFD manipulation can be at least deferred to the same place
> where the FPU state is manipulated: places like switch_fpu_return() or
> kernel_fpu_begin().
>
> Doing that would at least help the fast VM-Exit/VM-Enter paths that
> really like TIF_NEED_FPU_LOAD today.
>
> I guess the nasty part is that you actually need to stash the old XFD
> MSR value in the vcpu structure and that's not available at
> context-switch time.  So, maybe this would only allow deferring the
> WRMSR.  That's better than nothing I guess.

