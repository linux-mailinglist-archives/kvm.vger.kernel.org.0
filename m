Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F9030230C
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 09:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbhAYI6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 03:58:41 -0500
Received: from mga18.intel.com ([134.134.136.126]:6125 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbhAYIl5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 03:41:57 -0500
IronPort-SDR: Nkcf3k0VB3i9oL8GLtTcasCPxzZvIqI28JAjnyptGYc83wKlpjajBLGIrdxvMmTLXeLCbd3xr9
 QKqXF/iwbtDw==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="167358140"
X-IronPort-AV: E=Sophos;i="5.79,372,1602572400"; 
   d="scan'208";a="167358140"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 00:08:30 -0800
IronPort-SDR: +yed1xN/jKxYgQSYnlV82Hldq/lmX9jM0EfNi8kT917T/sfidv4AAiqvN61YAqMDp2sAgl/AF+
 ucNkTjPGuIeg==
X-IronPort-AV: E=Sophos;i="5.79,372,1602572400"; 
   d="scan'208";a="387230072"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 00:08:26 -0800
Subject: Re: [PATCH v3 00/17] KVM: x86/pmu: Add support to enable Guest PEBS
 via DS
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Andi Kleen <andi@firstfloor.org>
Cc:     "Xu, Like" <like.xu@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <YACXQwBPI8OFV1T+@google.com>
 <f8a8e4e2-e0b1-8e68-81d4-044fb62045d5@intel.com>
 <YAHXlWmeR9p6JZm2@google.com>
 <20210115182700.byczztx3vjhsq3p3@two.firstfloor.org>
 <YAHkOiQsxMfOMYvp@google.com>
 <YAqhPPkexq+dQ5KD@hirez.programming.kicks-ass.net>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <eb30d86f-6492-d6e3-3a24-f58c724f68fd@linux.intel.com>
Date:   Mon, 25 Jan 2021 16:08:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YAqhPPkexq+dQ5KD@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 2021/1/22 17:56, Peter Zijlstra wrote:
> On Fri, Jan 15, 2021 at 10:51:38AM -0800, Sean Christopherson wrote:
>> On Fri, Jan 15, 2021, Andi Kleen wrote:
>>>> I'm asking about ucode/hardare.  Is the "guest pebs buffer write -> PEBS PMI"
>>>> guaranteed to be atomic?
>>>
>>> Of course not.
>>
>> So there's still a window where the guest could observe the bad counter index,
>> correct?
> 
> Guest could do a hypercall to fix up the DS area before it tries to read
> it I suppose. Or the HV could expose the index mapping and have the
> guest fix up it.

A weird (malicious) guest would read unmodified PEBS records in the
guest PEBS buffer from other vCPUs without the need for hypercall or
index mapping from HV.

Do you see any security issues on this host index leak window?

> 
> Adding a little virt crud on top shouldn't be too hard.
> 

The patches 13-17 in this version has modified the guest PEBS buffer
to correct the index mapping information in the guest PEBS records.

---
thx,likexu
