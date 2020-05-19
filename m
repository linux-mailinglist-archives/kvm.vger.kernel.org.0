Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0842B1D979B
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 15:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgESNZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 09:25:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:11209 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbgESNZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 09:25:23 -0400
IronPort-SDR: 5Q8tIsJJzmBNuIVVVTrtGDrHwfVrP9x/D78gpwU5FEwAHi/NwJS8kl3u2MxxEj9CBwd/JdquYa
 3/TwnT7L2fSA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 06:25:23 -0700
IronPort-SDR: ygC8FheXCko5FrqcyaE3hSIgTJ7LBEHVRVYW0GvyhhXvfIB4PI6oWD0B+XrVlGuDlTSidP3CYb
 EHYu+zCKFJZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,410,1583222400"; 
   d="scan'208";a="288955373"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.171.98]) ([10.249.171.98])
  by fmsmga004.fm.intel.com with ESMTP; 19 May 2020 06:25:20 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH v11 05/11] perf/x86: Keep LBR stack unchanged in host
 context for guest LBR event
To:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com
References: <20200514083054.62538-1-like.xu@linux.intel.com>
 <20200514083054.62538-6-like.xu@linux.intel.com>
 <20200518120205.GF277222@hirez.programming.kicks-ass.net>
 <dd6b0ab0-0209-e1e5-550c-24e2ad101b15@linux.intel.com>
 <20200519104520.GE279861@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <71d38733-bb96-99b0-5484-f7110410a8c5@intel.com>
Date:   Tue, 19 May 2020 21:25:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200519104520.GE279861@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 2020/5/19 18:45, Peter Zijlstra wrote:
> On Tue, May 19, 2020 at 11:08:41AM +0800, Like Xu wrote:
>
>> Sure, I could reuse cpuc->intel_ctrl_guest_mask to rewrite this part:
>>
>> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
>> index d788edb7c1f9..f1243e8211ca 100644
>> --- a/arch/x86/events/intel/core.c
>> +++ b/arch/x86/events/intel/core.c
>> @@ -2189,7 +2189,8 @@ static void intel_pmu_disable_event(struct perf_event
>> *event)
>>          } else if (idx == INTEL_PMC_IDX_FIXED_BTS) {
>>                  intel_pmu_disable_bts();
>>                  intel_pmu_drain_bts_buffer();
>> -       }
>> +       } else if (idx == INTEL_PMC_IDX_FIXED_VLBR)
>> +               intel_clear_masks(event, idx);
>>
>>          /*
>>           * Needs to be called after x86_pmu_disable_event,
>> @@ -2271,7 +2272,8 @@ static void intel_pmu_enable_event(struct perf_event
>> *event)
>>                  if (!__this_cpu_read(cpu_hw_events.enabled))
>>                          return;
>>                  intel_pmu_enable_bts(hwc->config);
>> -       }
>> +       } else if (idx == INTEL_PMC_IDX_FIXED_VLBR)
>> +               intel_set_masks(event, idx);
>>   }
> This makes me wonder if we can pull intel_{set,clear}_masks() out of
> that if()-forest, but that's something for later...
>
>>   static void intel_pmu_add_event(struct perf_event *event)
>> diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
>> index b8dabf1698d6..1b30c76815dd 100644
>> --- a/arch/x86/events/intel/lbr.c
>> +++ b/arch/x86/events/intel/lbr.c
>> @@ -552,11 +552,19 @@ void intel_pmu_lbr_del(struct perf_event *event)
>>          perf_sched_cb_dec(event->ctx->pmu);
>>   }
>>
>> +static inline bool vlbr_is_enabled(void)
>> +{
>> +       struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>> +
>> +       return test_bit(INTEL_PMC_IDX_FIXED_VLBR,
>> +               (unsigned long *)&cpuc->intel_ctrl_guest_mask);
>> +}
> Maybe call this: vlbr_exclude_host() ?
Sure, I'll apply it.
>
>> +
>>   void intel_pmu_lbr_enable_all(bool pmi)
>>   {
>>          struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>>
>> -       if (cpuc->lbr_users)
>> +       if (cpuc->lbr_users && !vlbr_is_enabled())
>>                  __intel_pmu_lbr_enable(pmi);
>>   }
>>
>> @@ -564,7 +572,7 @@ void intel_pmu_lbr_disable_all(void)
>>   {
>>          struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>>
>> -       if (cpuc->lbr_users)
>> +       if (cpuc->lbr_users && !vlbr_is_enabled())
>>                  __intel_pmu_lbr_disable();
>>   }
>>
>> @@ -706,7 +714,8 @@ void intel_pmu_lbr_read(void)
>>           * This could be smarter and actually check the event,
>>           * but this simple approach seems to work for now.
>>           */
>> -       if (!cpuc->lbr_users || cpuc->lbr_users == cpuc->lbr_pebs_users)
>> +       if (!cpuc->lbr_users || vlbr_is_enabled() ||
>> +               cpuc->lbr_users == cpuc->lbr_pebs_users)
>>                  return;
>>
>>          if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
>>
>> Is this acceptable to you ?
> Yeah, looks about right. Let me stare at the rest.
Uh, thanks for your warmly comments on the rest KVM part.

Let me assume we do not have any blocking issues
on the host perf changes to enable LBR feature for guests.

Thanks,
Like Xu

