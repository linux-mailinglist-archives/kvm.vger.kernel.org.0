Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228392F7052
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 03:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731783AbhAOCDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 21:03:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:41689 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbhAOCDW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 21:03:22 -0500
IronPort-SDR: w4KzUmdIYdseMJ8coAYNU19BFvQe+h4f7c9UujcooAWCnlAFGBmPjpqMMw7aAczrbL2BZwl20k
 sanzuWtfr+6A==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="178630248"
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="178630248"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 18:02:34 -0800
IronPort-SDR: ZybZusIeeGT/ROQ196thNhuyAZ3XlNt9AJ6RYG+thqmWhh3Bq2i9y1UubOleplFvsa8fpbkNkk
 e1+vbdPwpt/A==
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="354116708"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 18:02:31 -0800
Subject: Re: [PATCH v3 00/17] KVM: x86/pmu: Add support to enable Guest PEBS
 via DS
To:     Sean Christopherson <seanjc@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <YACXQwBPI8OFV1T+@google.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <f8a8e4e2-e0b1-8e68-81d4-044fb62045d5@intel.com>
Date:   Fri, 15 Jan 2021 10:02:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YACXQwBPI8OFV1T+@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

Thanks for your comments !

On 2021/1/15 3:10, Sean Christopherson wrote:
> On Mon, Jan 04, 2021, Like Xu wrote:
>> 2) Slow path (part 3, patch 0012-0017)
>>
>> This is when the host assigned physical PMC has a different index
>> from the virtual PMC (e.g. using physical PMC1 to emulate virtual PMC0)
>> In this case, KVM needs to rewrite the PEBS records to change the
>> applicable counter indexes to the virtual PMC indexes, which would
>> otherwise contain the physical counter index written by PEBS facility,
>> and switch the counter reset values to the offset corresponding to
>> the physical counter indexes in the DS data structure.
>>
>> Large PEBS needs to be disabled by KVM rewriting the
>> pebs_interrupt_threshold filed in DS to only one record in
>> the slow path.  This is because a guest may implicitly drain PEBS buffer,
>> e.g., context switch. KVM doesn't get a chance to update the PEBS buffer.
> Are the PEBS record write, PEBS index update, and subsequent PMI atomic with
> respect to instruction execution?  If not, doesn't this approach still leave a
> window where the guest could see the wrong counter?

First, KVM would limit/rewrite guest DS pebs_interrupt_threshold to one 
record before vm-entry,
(see patch [PATCH v3 14/17] KVM: vmx/pmu: Limit pebs_interrupt_threshold in 
the guest DS area)
which means once a PEBS record is written into the guest pebs buffer,
a PEBS PMI will be generated immediately and thus vm-exit.

Second, KVM would complete the PEBS record rewriting, PEBS index update, 
and inject vPMI
before the next vm-entry (we deal with these separately in patches 15-17 
for easy review).

After the updated PEBS record(s) are (atomically?) prepared, guests will be 
notified via PMI
and there is no window for vcpu to check whether there is a PEBS record due 
to vm-exit.

> The virtualization hole is also visible if the guest is reading the PEBS records
> from a different vCPU, though I assume no sane kernel does that?

I have checked the guest PEBS driver behavior for Linux and Windows, and 
they're sane.

Theoretically, it's true for busy-poll PBES buffer readers from other vCPUs
and to fix it, making all vCPUs vm-exit is onerous for a large-size guest
and I don't think you would accept this or do we have a better idea ?

In fact, we don't think it's a hole or vulnerability because the motivation for
correcting the counter index(s) is to help guest PEBS reader understand their
PEBS records correctly and provide the same sampling accuracy as the non-cross
mapped case, instead of providing a new attack interface from guest to host.

PeterZ commented on the V1 version and insisted that the host perf allows 
the guest
counter to be assigned a cross-mapped back-end counter. In this case, the 
slow path
patches (13-17) are introduced to ensure that from the guest counter 
perspective,
the PEBS records are also correct. We do not want these records to be 
invalid and
ignored, which would undermine the accuracy of PEBS.

In the practical use, the slow patch rarely happens and
we're glad to see if the fast patch could be upstream
and the cross-mapped case is teamprily disabled
until we're on the same page for the cross mapped case.

In actual use, slow path rarely occur. As a first step,
we propose to upstream the quick patches (patch 01-12) with your help.
The guest PEBS would been disabled temporarily when guest PEBS counters
are cross-mapped until we figure out a satisfactory cross-mapping solution.

---
thx,likexu

>
>> The physical PMC index will confuse the guest. The difficulty comes
>> when multiple events get rescheduled inside the guest. Hence disabling
>> large PEBS in this case might be an easy and safe way to keep it corrects
>> as an initial step here.

