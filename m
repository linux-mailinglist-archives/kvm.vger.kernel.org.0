Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424AB2B89A6
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 02:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgKSBhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 20:37:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:61754 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbgKSBhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Nov 2020 20:37:07 -0500
IronPort-SDR: 4EKHJrWXJn2fkDKXZqNN04xK0UzxEsWIOrSMtZsHAuiIGikqHnkobqkQu6fnW9hSHHn63NWsaZ
 iKTw3HpCKM/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="158248476"
X-IronPort-AV: E=Sophos;i="5.77,489,1596524400"; 
   d="scan'208";a="158248476"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 17:37:06 -0800
IronPort-SDR: P4LrGHN2rkdRihzcxWzIhnaa1U7Tz1T69KmlJXQfZAc3XAYtQ7CKAp9u4MJ73kEBXnPBz4ksPT
 0cDy/SV/fQXQ==
X-IronPort-AV: E=Sophos;i="5.77,489,1596524400"; 
   d="scan'208";a="544794488"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.107]) ([10.238.4.107])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 17:37:01 -0800
Subject: Re: [PATCH v2 04/17] perf: x86/ds: Handle guest PEBS overflow PMI and
 inject it to guest
To:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, wei.w.wang@intel.com,
        Tony Luck <tony.luck@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
References: <20201109021254.79755-1-like.xu@linux.intel.com>
 <20201109021254.79755-5-like.xu@linux.intel.com>
 <20201117143529.GJ3121406@hirez.programming.kicks-ass.net>
 <b2c3f889-44dd-cadb-f225-a4c5db3a4447@linux.intel.com>
 <20201118180721.GA3121392@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <7b47b5c5-8e38-ce73-d905-47176734b1d8@intel.com>
Date:   Thu, 19 Nov 2020 09:36:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118180721.GA3121392@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/11/19 2:07, Peter Zijlstra wrote:
> On Thu, Nov 19, 2020 at 12:15:09AM +0800, Like Xu wrote:
>
>>> ISTR there was lots of fail trying to virtualize it earlier. What's
>>> changed? There's 0 clues here.
>> Ah, now we have EPT-friendly PEBS facilities supported since Ice Lake
>> which makes guest PEBS feature possible w/o guest memory pinned.
> OK.
>
>>> Why are the host and guest DS area separate, why can't we map them to
>>> the exact same physical pages?
>> If we map both guest and host DS_AREA to the exact same physical pages,
>> - the guest can access the host PEBS records, which means that the host
>> IP maybe leaked, because we cannot predict the time guest drains records and
>> it would be over-designed to clean it up before each vm-entry;
>> - different tasks/vcpus on the same pcpu cannot share the same PEBS DS
>> settings from the same physical page. For example, some require large
>> PEBS and reset values, while others do not.
>>
>> Like many guest msrs, we use the separate guest DS_AREA for the guest's
>> own use and it avoids mutual interference as little as possible.
> OK, but the code here wanted to inspect the guest DS from the host. It
> states this is somehow complicated/expensive.
Yes, it's expensive to inspect guest DS in the NMI handler and also
unsafe to call sleepable EPT page fault handler in the NMI context.

So in this version, we propose to move this complicated part to the KVM
and I think the overhead is acceptable for the cross-mapped cases.

The bad thing is we will not be able to distinguish whether PEBS PMI is from
guest or host once there's a host PEBS counter enabled on the same CPU
and we may fix it later w/ your ideas.

> But surely we can at the
> very least map the first guest DS page somewhere so we can at least
> access the control bits without too much magic.
I am not sure whether the first mapped guest DS page can help
the guest PEBS to keep working from beginning to end since
later host may not map guest DS page on the physical one
and currently KVM couldn't control it fine-grained.

This version could also avoid attacks from malicious guests
by keeping its control bits in its guest space.

Thanks,
Like Xu

