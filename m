Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49D961940CA
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 15:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgCZODO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 10:03:14 -0400
Received: from mga18.intel.com ([134.134.136.126]:21527 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727738AbgCZODO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 10:03:14 -0400
IronPort-SDR: I97fcWokmN/hogqLRjM58bWJ4LcZsjay+skELlvk51d9ptb9ha835dYJpBZWzRd5/xTOFUOC3W
 qxhvIIQEokLw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 07:03:13 -0700
IronPort-SDR: 2xMnfKiNNIribQHyU99+kqBuFzEPshilBpp4VmLjGKBP0/Yb9ogFvu8RtCBDvmiHzPKA1aWgxt
 JemivmV5wg7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,308,1580803200"; 
   d="scan'208";a="271181383"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga004.fm.intel.com with ESMTP; 26 Mar 2020 07:03:11 -0700
Received: from [10.254.68.166] (kliang2-mobl.ccr.corp.intel.com [10.254.68.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 3CC085803E3;
        Thu, 26 Mar 2020 07:03:09 -0700 (PDT)
Subject: Re: [PATCH v1 01/11] perf/x86/core: Support KVM to assign a dedicated
 counter for guest PEBS
From:   "Liang, Kan" <kan.liang@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Luwei Kang <luwei.kang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, tglx@linutronix.de, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        like.xu@linux.intel.com
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
 <1583431025-19802-2-git-send-email-luwei.kang@intel.com>
 <20200306135317.GD12561@hirez.programming.kicks-ass.net>
 <b72cb68e-1a0a-eeff-21b4-ce412e939cfd@linux.intel.com>
 <20200309100443.GG12561@hirez.programming.kicks-ass.net>
 <97ce1ba4-d75a-8db2-ea2f-7d334942b4e6@linux.intel.com>
 <20200309150526.GI12561@hirez.programming.kicks-ass.net>
 <45a1a575-9363-f778-b5f5-bcdf28d3e34b@linux.intel.com>
Message-ID: <e4a97965-5e57-56c5-1610-b84cf349e466@linux.intel.com>
Date:   Thu, 26 Mar 2020 10:03:07 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <45a1a575-9363-f778-b5f5-bcdf28d3e34b@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 3/9/2020 3:28 PM, Liang, Kan wrote:
> 
> 
> On 3/9/2020 11:05 AM, Peter Zijlstra wrote:
>>> In the new proposal, KVM user is treated the same as other host 
>>> events with
>>> event constraint. The scheduler is free to choose whether or not to 
>>> assign a
>>> counter for it.
>> That's what it does, I understand that. I'm saying that that is creating
>> artificial contention.
>>
>>
>> Why is this needed anyway? Can't we force the guest to flush and then
>> move it over to a new counter?
>

Current perf scheduling is pure software behavior. KVM only traps the 
MSR access. It’s impossible for KVM to impact the guest’s scheduling 
with current implementation.

To address the concern regarding to 'artificial contention', we have two 
proposals.
Could you please take a look, and share your thoughts?

Proposal 1:
Reject the guest request, if host has to use the counter which occupied 
by guest. At the meantime, host prints a warning.
I still think the contention should rarely happen in practical.
Personally, I prefer this proposal.


Proposal 2:
Add HW advisor for the scheduler in guest.
Starts from Architectural Perfmon Version 4, IA32_PERF_GLOBAL_INUSE MSR 
is introduced. It provides an “InUse” bit for each programmable 
performance counter and fixed counter in the processor.

In perf, the scheduler will read the MSR and mask the “in used” 
counters. I think we can use X86_FEATURE_HYPERVISOR to limit the check 
in guest. For non-virtualization usage and host, nothing changed for 
scheduler.

But there is still a problem for this proposal. Host may request a 
counter later, which has been used by guest.
We can only do multiplexing or grab the counter just like proposal 1.


What do you think?

Thanks,
Kan

> KVM only traps the MSR access. There is no MSR access during the 
> scheduling in guest.
> KVM/host only knows the request counter, when guest tries to enable the 
> counter. It's too late for guest to start over.
> 
> Regarding to the artificial contention, as my understanding, it should 
> rarely happen in practical.
> Cloud vendors have to explicitly set pebs option in qemu to enable PEBS 
> support for guest. They knows the environment well. They can avoid the 
> contention. (We may implement some patches for qemu/KVM later to 
> temporarily disable PEBS in runtime if they require.)
> 
> For now, I think we may print a warning when both host and guest require 
> the same counter. Host can get a clue from the warning.
> 
> Thanks,
> Kan
