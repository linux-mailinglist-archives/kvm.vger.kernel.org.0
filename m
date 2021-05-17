Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA03F38330A
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 16:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240675AbhEQOxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 10:53:50 -0400
Received: from mga06.intel.com ([134.134.136.31]:27010 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239859AbhEQOvr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 10:51:47 -0400
IronPort-SDR: 0Qj2DUlxvdl7NKWCgHayz7bOM+fHbPjO6uzH+pVV8Qc7SET3ppW4LQdObW9SnX8HBvaYC6+xS/
 BXj4EkW/rzZQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="261716118"
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="261716118"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 07:44:17 -0700
IronPort-SDR: TVBdBiMGJNmPXfpHnBRHEF8hV71He9y0QgOzdumAeYfZ9h3IdrMQsHpWFbOit0M5yV/LqFnWa3
 3ckkIT2XYBaw==
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="410850924"
Received: from akleen-mobl1.amr.corp.intel.com (HELO [10.212.163.36]) ([10.212.163.36])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 07:44:16 -0700
Subject: Re: [PATCH v6 07/16] KVM: x86/pmu: Reprogram PEBS event to emulate
 guest PEBS counter
To:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-8-like.xu@linux.intel.com>
 <YKIrtdbXRcZSiohg@hirez.programming.kicks-ass.net>
From:   Andi Kleen <ak@linux.intel.com>
Message-ID: <ff5a419f-188f-d14c-72c8-4b760052734d@linux.intel.com>
Date:   Mon, 17 May 2021 07:44:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKIrtdbXRcZSiohg@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/17/2021 1:39 AM, Peter Zijlstra wrote:
> On Tue, May 11, 2021 at 10:42:05AM +0800, Like Xu wrote:
>> +	if (pebs) {
>> +		/*
>> +		 * The non-zero precision level of guest event makes the ordinary
>> +		 * guest event becomes a guest PEBS event and triggers the host
>> +		 * PEBS PMI handler to determine whether the PEBS overflow PMI
>> +		 * comes from the host counters or the guest.
>> +		 *
>> +		 * For most PEBS hardware events, the difference in the software
>> +		 * precision levels of guest and host PEBS events will not affect
>> +		 * the accuracy of the PEBS profiling result, because the "event IP"
>> +		 * in the PEBS record is calibrated on the guest side.
>> +		 */
>> +		attr.precise_ip = 1;
>> +	}
> You've just destroyed precdist, no?

precdist can mean multiple things:

- Convert cycles to the precise INST_RETIRED event. That is not 
meaningful for virtualization because "cycles" doesn't exist, just the 
raw events.

- For GLC+ and TNT+ it will force the event to a specific counter that 
is more precise. This would be indeed "destroyed", but right now the 
patch kit only supports Icelake which doesn't support that anyways.

So I think the code is correct for now, but will need to be changed for 
later CPUs. Should perhaps fix the comment though to discuss this.


-Andi


