Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CA3304A17
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 21:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730974AbhAZFPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:15:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:46033 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbhAYMJm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 07:09:42 -0500
IronPort-SDR: sBqxBS27qKLr5Zl5bFMoXs6jGc1V8tOpoEKo4R0oLeHZKysFwDPMD7UMJZLcxN2Gq7nuXYE03Z
 KvNMRgB5CUOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="198490980"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="198490980"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 04:07:15 -0800
IronPort-SDR: srAIfgl2Dd3Ozn5+UAs0t1kA2kq44zNVb3giqtvLPBtuWJo5JEGWkpORWEHVYU1o5wtWZC1bj3
 Ae6NZFtFqLWA==
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="387338811"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.168.247]) ([10.249.168.247])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 04:07:10 -0800
Subject: Re: [PATCH v3 00/17] KVM: x86/pmu: Add support to enable Guest PEBS
 via DS
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <YACXQwBPI8OFV1T+@google.com>
 <f8a8e4e2-e0b1-8e68-81d4-044fb62045d5@intel.com>
 <YAHXlWmeR9p6JZm2@google.com>
 <20210115182700.byczztx3vjhsq3p3@two.firstfloor.org>
 <YAHkOiQsxMfOMYvp@google.com>
 <YAqhPPkexq+dQ5KD@hirez.programming.kicks-ass.net>
 <eb30d86f-6492-d6e3-3a24-f58c724f68fd@linux.intel.com>
 <YA6nxuM5Stlolk5x@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <076a5c7b-de2e-daf9-e6c0-5a42fb38aaa3@intel.com>
Date:   Mon, 25 Jan 2021 20:07:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YA6nxuM5Stlolk5x@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/25 19:13, Peter Zijlstra wrote:
> On Mon, Jan 25, 2021 at 04:08:22PM +0800, Like Xu wrote:
>> Hi Peter,
>>
>> On 2021/1/22 17:56, Peter Zijlstra wrote:
>>> On Fri, Jan 15, 2021 at 10:51:38AM -0800, Sean Christopherson wrote:
>>>> On Fri, Jan 15, 2021, Andi Kleen wrote:
>>>>>> I'm asking about ucode/hardare.  Is the "guest pebs buffer write -> PEBS PMI"
>>>>>> guaranteed to be atomic?
>>>>> Of course not.
>>>> So there's still a window where the guest could observe the bad counter index,
>>>> correct?
>>> Guest could do a hypercall to fix up the DS area before it tries to read
>>> it I suppose. Or the HV could expose the index mapping and have the
>>> guest fix up it.
>> A weird (malicious) guest would read unmodified PEBS records in the
>> guest PEBS buffer from other vCPUs without the need for hypercall or
>> index mapping from HV.
>>
>> Do you see any security issues on this host index leak window?
>>
>>> Adding a little virt crud on top shouldn't be too hard.
>>>
>> The patches 13-17 in this version has modified the guest PEBS buffer
>> to correct the index mapping information in the guest PEBS records.
> Right, but given there is no atomicity between writing the DS area and
> triggering the PMI (as already established earlier in this thread), a
> malicious guest can already access this information, no?
>

So under the premise that counter cross-mapping is allowed,
how can hypercall help fix it ?

Personally,  I think it is acceptable at the moment, and
no security issues based on this have been defined and found.
