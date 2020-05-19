Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E7F1D8E09
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 05:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgESDIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 23:08:48 -0400
Received: from mga12.intel.com ([192.55.52.136]:47219 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgESDIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 23:08:47 -0400
IronPort-SDR: 8jSU3MrGz4qQdBslgq1HhH9Uyn5Eq8+GSqxh6PO04igOhxuDuxjt//dedSVDov8yq+yTlUfagS
 NbPmXy99M8uw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 20:08:47 -0700
IronPort-SDR: UNiJIVy9L3nV2FcocPuxfstsqx+jvmEZPZEtOpRSyRido8uPiQibjcdRaYo50vrue0pb82YSU7
 4O82+YOsRyoQ==
X-IronPort-AV: E=Sophos;i="5.73,408,1583222400"; 
   d="scan'208";a="439459187"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.141]) ([10.238.4.141])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 20:08:43 -0700
Subject: Re: [PATCH v11 05/11] perf/x86: Keep LBR stack unchanged in host
 context for guest LBR event
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
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
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <dd6b0ab0-0209-e1e5-550c-24e2ad101b15@linux.intel.com>
Date:   Tue, 19 May 2020 11:08:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200518120205.GF277222@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

Thanks for the clear attitude and code refinement.

On 2020/5/18 20:02, Peter Zijlstra wrote:
> On Thu, May 14, 2020 at 04:30:48PM +0800, Like Xu wrote:
>> @@ -544,7 +562,12 @@ void intel_pmu_lbr_enable_all(bool pmi)
>>   {
>>   	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>>   
>> -	if (cpuc->lbr_users)
>> +	/*
>> +	 * When the LBR hardware is scheduled for a guest LBR event,
>> +	 * the guest will dis/enables LBR itself at the appropriate time,
>> +	 * including configuring MSR_LBR_SELECT.
>> +	 */
>> +	if (cpuc->lbr_users && !cpuc->guest_lbr_enabled)
>>   		__intel_pmu_lbr_enable(pmi);
>>   }
> 
> No!, that should be done through perf_event_attr::exclude_host, as I
> believe all the other KVM event do it.
> 

Sure, I could reuse cpuc->intel_ctrl_guest_mask to rewrite this part:

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index d788edb7c1f9..f1243e8211ca 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2189,7 +2189,8 @@ static void intel_pmu_disable_event(struct perf_event 
*event)
         } else if (idx == INTEL_PMC_IDX_FIXED_BTS) {
                 intel_pmu_disable_bts();
                 intel_pmu_drain_bts_buffer();
-       }
+       } else if (idx == INTEL_PMC_IDX_FIXED_VLBR)
+               intel_clear_masks(event, idx);

         /*
          * Needs to be called after x86_pmu_disable_event,
@@ -2271,7 +2272,8 @@ static void intel_pmu_enable_event(struct perf_event 
*event)
                 if (!__this_cpu_read(cpu_hw_events.enabled))
                         return;
                 intel_pmu_enable_bts(hwc->config);
-       }
+       } else if (idx == INTEL_PMC_IDX_FIXED_VLBR)
+               intel_set_masks(event, idx);
  }

  static void intel_pmu_add_event(struct perf_event *event)
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index b8dabf1698d6..1b30c76815dd 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -552,11 +552,19 @@ void intel_pmu_lbr_del(struct perf_event *event)
         perf_sched_cb_dec(event->ctx->pmu);
  }

+static inline bool vlbr_is_enabled(void)
+{
+       struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+
+       return test_bit(INTEL_PMC_IDX_FIXED_VLBR,
+               (unsigned long *)&cpuc->intel_ctrl_guest_mask);
+}
+
  void intel_pmu_lbr_enable_all(bool pmi)
  {
         struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);

-       if (cpuc->lbr_users)
+       if (cpuc->lbr_users && !vlbr_is_enabled())
                 __intel_pmu_lbr_enable(pmi);
  }

@@ -564,7 +572,7 @@ void intel_pmu_lbr_disable_all(void)
  {
         struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);

-       if (cpuc->lbr_users)
+       if (cpuc->lbr_users && !vlbr_is_enabled())
                 __intel_pmu_lbr_disable();
  }

@@ -706,7 +714,8 @@ void intel_pmu_lbr_read(void)
          * This could be smarter and actually check the event,
          * but this simple approach seems to work for now.
          */
-       if (!cpuc->lbr_users || cpuc->lbr_users == cpuc->lbr_pebs_users)
+       if (!cpuc->lbr_users || vlbr_is_enabled() ||
+               cpuc->lbr_users == cpuc->lbr_pebs_users)
                 return;

         if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)

Is this acceptable to you ?

If you have more comments on the patchset, please let me know.

Thanks,
Like Xu
