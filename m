Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C71DE038E
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 14:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388812AbfJVMAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 08:00:42 -0400
Received: from mga04.intel.com ([192.55.52.120]:54384 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388106AbfJVMAm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 08:00:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 05:00:41 -0700
X-IronPort-AV: E=Sophos;i="5.67,327,1566889200"; 
   d="scan'208";a="191438120"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.255.31.145]) ([10.255.31.145])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 22 Oct 2019 05:00:39 -0700
Subject: Re: [PATCH v3 6/6] KVM: x86/vPMU: Add lazy mechanism to release
 perf_event per vPMC
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     peterz@infradead.org, like.xu@intel.com,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com, wei.w.wang@intel.com,
        kan.liang@intel.com
References: <20191021160651.49508-1-like.xu@linux.intel.com>
 <20191021160651.49508-7-like.xu@linux.intel.com>
 <c17a9d77-2c30-b3c0-4652-57f0b9252f3b@redhat.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <7d46a902-43eb-4693-f481-1c2efd397fbd@linux.intel.com>
Date:   Tue, 22 Oct 2019 20:00:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c17a9d77-2c30-b3c0-4652-57f0b9252f3b@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,
On 2019/10/22 18:47, Paolo Bonzini wrote:
> On 21/10/19 18:06, Like Xu wrote:
>>   
>> +		__set_bit(INTEL_PMC_IDX_FIXED + i, pmu->pmc_in_use);
>>   		reprogram_fixed_counter(pmc, new_ctrl, i);
>>   	}
>>   
>> @@ -329,6 +330,11 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>   	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
>>   	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM)))
>>   		pmu->reserved_bits ^= HSW_IN_TX|HSW_IN_TX_CHECKPOINTED;
>> +
>> +	bitmap_set(pmu->all_valid_pmc_idx,
>> +		0, pmu->nr_arch_gp_counters);
>> +	bitmap_set(pmu->all_valid_pmc_idx,
>> +		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
> 
> The offset needs to be INTEL_PMC_IDX_FIXED for GP counters, and 0 for
> fixed counters, otherwise pmc_in_use and all_valid_pmc_idx are not in sync.
> 

First, the bitmap_set is declared as:

	static __always_inline void bitmap_set(unsigned long *map,
	unsigned int start, unsigned int nbits)

Second, the structure of pmu->pmc_in_use is in the following format:

   Intel: [0 .. INTEL_PMC_MAX_GENERIC-1] <=> gp counters
        	 [INTEL_PMC_IDX_FIXED .. INTEL_PMC_IDX_FIXED + 2] <=> fixed
   AMD:   [0 .. AMD64_NUM_COUNTERS-1] <=> gp counters

Then let me translate your suggestion to the following code:

	bitmap_set(pmu->all_valid_pmc_idx, 0,
		   pmu->nr_arch_fixed_counters);
	bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED,
		   pmu->nr_arch_gp_counters);

and the above code doesn't pass the following verification patch:

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a8793f965941..0a73bc8c587d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -469,6 +469,7 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)

         /* release events for unmarked vPMCs in the last sched time 
slice */
         for_each_set_bit(i, bitmask, X86_PMC_IDX_MAX) {
+               pr_info("%s, do cleanup check for i = %d", __func__, i);
                 pmc = kvm_x86_ops->pmu_ops->pmc_idx_to_pmc(pmu, i);

                 if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))

The print message would never stop after the guest user finishes the
perf command and it's checking the invalid idx for i = 35 unexpectedly.

However, my code does work just as you suggest.

By the way, how about other kvm patches?

> Paolo
> 
> 

