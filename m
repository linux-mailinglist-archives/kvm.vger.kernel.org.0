Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05486387AA4
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 16:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349770AbhEROHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 10:07:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:40327 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244785AbhEROHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 10:07:22 -0400
IronPort-SDR: mvIvGkY4EEkezmry0/mCOpQuXV/sOyXe8+pbjk92ACcuoLEK0O0mZ33Jlozy8Wy2POcAh7oUFw
 nmHmIEkOs32Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="200413209"
X-IronPort-AV: E=Sophos;i="5.82,310,1613462400"; 
   d="scan'208";a="200413209"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 07:06:04 -0700
IronPort-SDR: jC8sz1bNPimczh67OzWbwHkgHhSoGhxg1bBGuokQrEIPj/pXy9uCtGfPMd3vFO3xrxh9YSCeJE
 1HmNRlU2Nmrg==
X-IronPort-AV: E=Sophos;i="5.82,310,1613462400"; 
   d="scan'208";a="472969079"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.255.30.127]) ([10.255.30.127])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 07:06:00 -0700
Subject: Re: [PATCH v6 07/16] KVM: x86/pmu: Reprogram PEBS event to emulate
 guest PEBS counter
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-8-like.xu@linux.intel.com>
 <YKIz/J1HoOvbmR42@hirez.programming.kicks-ass.net>
 <2d874bce-2823-13b4-0714-3de5b7c475f0@intel.com>
 <YKPCxnKc1MGqXsJ4@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <6f4061ef-1a3e-b21c-2dd1-051bb93c846f@intel.com>
Date:   Tue, 18 May 2021 22:05:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YKPCxnKc1MGqXsJ4@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/18 21:36, Peter Zijlstra wrote:
> On Tue, May 18, 2021 at 09:28:52PM +0800, Xu, Like wrote:
>
>>> How would pebs && !intr be possible?
>> I don't think it's possible.
> And yet you keep that 'intr||pebs' weirdness :/
>
>>> Also; wouldn't this be more legible
>>> when written like:
>>>
>>> 	perf_overflow_handler_t ovf = kvm_perf_overflow;
>>>
>>> 	...
>>>
>>> 	if (intr)
>>> 		ovf = kvm_perf_overflow_intr;
>>>
>>> 	...
>>>
>>> 	event = perf_event_create_kernel_counter(&attr, -1, current, ovf, pmc);
>>>
>> Please yell if you don't like this:
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 711294babb97..a607f5a1b9cd 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -122,6 +122,8 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc,
>> u32 type,
>>                  .config = config,
>>          };
>>          bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
>> +       perf_overflow_handler_t ovf = (intr || pebs) ?
>> +               kvm_perf_overflow_intr : kvm_perf_overflow;
> This, that's exactly the kind of code I wanted to get rid of. ?: has
> it's place I suppose, but you're creating dense ugly code for no reason.
>
> 	perf_overflow_handle_t ovf = kvm_perf_overflow;
>
> 	if (intr)
> 		ovf = kvm_perf_overflow_intr;
>
> Is so much easier to read. And if you really worry about that pebs
> thing; you can add:
>
> 	WARN_ON_ONCE(pebs && !intr);
>

Thanks!  Glad you could review my code.
As a new generation, we do appreciate your patient guidance on your taste 
in code.

