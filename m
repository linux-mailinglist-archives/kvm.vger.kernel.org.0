Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0BB169EDA
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 07:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgBXG4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 01:56:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:43282 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbgBXG4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 01:56:13 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Feb 2020 22:56:13 -0800
X-IronPort-AV: E=Sophos;i="5.70,479,1574150400"; 
   d="scan'208";a="230549576"
Received: from unknown (HELO [10.238.4.82]) ([10.238.4.82])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 23 Feb 2020 22:56:11 -0800
Subject: Re: [PATCH] KVM: x86: Adjust counter sample period after a wrmsr
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Eric Hankland <ehankland@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200222023413.78202-1-ehankland@google.com>
 <9adcb973-7b60-71dd-636d-1e451e664c55@redhat.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <0c66eae3-8983-0632-6d39-fd335620b76a@linux.intel.com>
Date:   Mon, 24 Feb 2020 14:56:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <9adcb973-7b60-71dd-636d-1e451e664c55@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Hankland,

On 2020/2/22 15:34, Paolo Bonzini wrote:
> On 22/02/20 03:34, Eric Hankland wrote:
>> The sample_period of a counter tracks when that counter will
>> overflow and set global status/trigger a PMI. However this currently
>> only gets set when the initial counter is created or when a counter is
>> resumed; this updates the sample period after a wrmsr so running
>> counters will accurately reflect their new value.
>>
>> Signed-off-by: Eric Hankland <ehankland@google.com>
>> ---
>>   arch/x86/kvm/pmu.c           | 4 ++--
>>   arch/x86/kvm/pmu.h           | 8 ++++++++
>>   arch/x86/kvm/vmx/pmu_intel.c | 6 ++++++
>>   3 files changed, 16 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index bcc6a73d6628..d1f8ca57d354 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -111,7 +111,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>>   		.config = config,
>>   	};
>>   
>> -	attr.sample_period = (-pmc->counter) & pmc_bitmask(pmc);
>> +	attr.sample_period = get_sample_period(pmc, pmc->counter);
>>   
>>   	if (in_tx)
>>   		attr.config |= HSW_IN_TX;
>> @@ -158,7 +158,7 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
>>   
>>   	/* recalibrate sample period and check if it's accepted by perf core */
>>   	if (perf_event_period(pmc->perf_event,
>> -			(-pmc->counter) & pmc_bitmask(pmc)))
>> +			      get_sample_period(pmc, pmc->counter)))
>>   		return false;
>>   
>>   	/* reuse perf_event to serve as pmc_reprogram_counter() does*/
>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>> index 13332984b6d5..354b8598b6c1 100644
>> --- a/arch/x86/kvm/pmu.h
>> +++ b/arch/x86/kvm/pmu.h
>> @@ -129,6 +129,15 @@ static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
>>   	return NULL;
>>   }
>>   
>> +static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
>> +{
>> +	u64 sample_period = (-counter_value) & pmc_bitmask(pmc);
>> +
>> +	if (!sample_period)
>> +		sample_period = pmc_bitmask(pmc) + 1;
>> +	return sample_period;
>> +}
>> +
>>   void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
>>   void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
>>   void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index fd21cdb10b79..e933541751fb 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -263,9 +263,15 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   			if (!msr_info->host_initiated)
>>   				data = (s64)(s32)data;
>>   			pmc->counter += data - pmc_read_counter(pmc);
>> +			if (pmc->perf_event)
>> +				perf_event_period(pmc->perf_event,
>> +						  get_sample_period(pmc, data));
>>   			return 0;
>>   		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
>>   			pmc->counter += data - pmc_read_counter(pmc);
>> +			if (pmc->perf_event)
>> +				perf_event_period(pmc->perf_event,
>> +						  get_sample_period(pmc, data));
>>   			return 0;
>>   		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
>>   			if (data == pmc->eventsel)

Although resetting the running counters is allowed,
it is not recommended to do it.

The motivation of this patch looks good to me.

However, it does hurt performance due to more frequent calls to 
perf_event_period() and we just took the perf_event_ctx_lock in the 
perf_event_read_value().

Thanks,
Like Xu

>>
> 
> Queued, thanks.
> 
> Paolo
> 

