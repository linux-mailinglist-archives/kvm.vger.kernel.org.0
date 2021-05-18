Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A573879F0
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 15:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349516AbhERNaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 09:30:17 -0400
Received: from mga03.intel.com ([134.134.136.65]:62643 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241144AbhERNaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 09:30:16 -0400
IronPort-SDR: 3lkvxyOP+FLtByc8i4iSl8AN/JYn+dZx5fqs1OrelSkPS/1xnEn54t+3cJl11v7j2q7AAY40RI
 iIi1UoDblarg==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="200766216"
X-IronPort-AV: E=Sophos;i="5.82,310,1613462400"; 
   d="scan'208";a="200766216"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 06:28:58 -0700
IronPort-SDR: aeKhaI0DQgpi0OH/KNuQF3VXO19SH4RCaCpvzuEdK8r54Iz4cIXBt98Ims+NX3c8Lv7yJrcS9r
 zA1hwJ7kwNzQ==
X-IronPort-AV: E=Sophos;i="5.82,310,1613462400"; 
   d="scan'208";a="472955201"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.255.30.127]) ([10.255.30.127])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 06:28:54 -0700
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
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <2d874bce-2823-13b4-0714-3de5b7c475f0@intel.com>
Date:   Tue, 18 May 2021 21:28:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YKIz/J1HoOvbmR42@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/17 17:14, Peter Zijlstra wrote:
> On Tue, May 11, 2021 at 10:42:05AM +0800, Like Xu wrote:
>> @@ -99,6 +109,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>>   				  bool exclude_kernel, bool intr,
>>   				  bool in_tx, bool in_tx_cp)
>>   {
>> +	struct kvm_pmu *pmu = vcpu_to_pmu(pmc->vcpu);
>>   	struct perf_event *event;
>>   	struct perf_event_attr attr = {
>>   		.type = type,
>> @@ -110,6 +121,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>>   		.exclude_kernel = exclude_kernel,
>>   		.config = config,
>>   	};
>> +	bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
>>   
>>   	attr.sample_period = get_sample_period(pmc, pmc->counter);
>>   
>> @@ -124,9 +136,23 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>>   		attr.sample_period = 0;
>>   		attr.config |= HSW_IN_TX_CHECKPOINTED;
>>   	}
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
>>   
>>   	event = perf_event_create_kernel_counter(&attr, -1, current,
>> -						 intr ? kvm_perf_overflow_intr :
>> +						 (intr || pebs) ? kvm_perf_overflow_intr :
>>   						 kvm_perf_overflow, pmc);
> How would pebs && !intr be possible?

I don't think it's possible.

> Also; wouldn't this be more legible
> when written like:
>
> 	perf_overflow_handler_t ovf = kvm_perf_overflow;
>
> 	...
>
> 	if (intr)
> 		ovf = kvm_perf_overflow_intr;
>
> 	...
>
> 	event = perf_event_create_kernel_counter(&attr, -1, current, ovf, pmc);
>

Please yell if you don't like this:

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 711294babb97..a607f5a1b9cd 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -122,6 +122,8 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, 
u32 type,
                 .config = config,
         };
         bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
+       perf_overflow_handler_t ovf = (intr || pebs) ?
+               kvm_perf_overflow_intr : kvm_perf_overflow;

         attr.sample_period = get_sample_period(pmc, pmc->counter);

@@ -151,9 +153,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, 
u32 type,
                 attr.precise_ip = 1;
         }

-       event = perf_event_create_kernel_counter(&attr, -1, current,
-                                                (intr || pebs) ? 
kvm_perf_overflow_intr :
-                                                kvm_perf_overflow, pmc);
+       event = perf_event_create_kernel_counter(&attr, -1, current, ovf, pmc);
         if (IS_ERR(event)) {
                 pr_debug_ratelimited("kvm_pmu: event creation failed %ld 
for pmc->idx = %d\n",
                             PTR_ERR(event), pmc->idx);


