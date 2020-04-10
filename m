Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221B81A3E98
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 05:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgDJDKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 23:10:44 -0400
Received: from mga17.intel.com ([192.55.52.151]:3010 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgDJDKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 23:10:44 -0400
IronPort-SDR: ZcahRtawOFDT6eFMABk0RReiRug2Yq0kp88YdayXVAa9NYDSWnrWi7qm3Bot3M+UmMA0Yic6cT
 bA+jZlaX8osw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2020 20:10:44 -0700
IronPort-SDR: HXq/IUet9O+rMRtfb71iu/Z5PWBJGwtw0CRzb5s1veEmdOt3EU6LBZS6yZixcyw8nrJgJPodv1
 heD13yhYH3AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,364,1580803200"; 
   d="scan'208";a="270283308"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.236]) ([10.238.4.236])
  by orsmga002.jf.intel.com with ESMTP; 09 Apr 2020 20:10:39 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH v9 04/10] perf/x86: Keep LBR stack unchanged on the host
 for guest LBR event
To:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Liang Kan <kan.liang@linux.intel.com>,
        Wei Wang <wei.w.wang@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
References: <20200313021616.112322-1-like.xu@linux.intel.com>
 <20200313021616.112322-5-like.xu@linux.intel.com>
 <20200409164545.GE20713@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <97059994-cf3c-2991-a0e2-02d02c344f1f@intel.com>
Date:   Fri, 10 Apr 2020 11:10:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200409164545.GE20713@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/4/10 0:45, Peter Zijlstra wrote:
> On Fri, Mar 13, 2020 at 10:16:10AM +0800, Like Xu wrote:
>> When a guest wants to use the LBR stack, its hypervisor creates a guest
>> LBR event and let host perf schedules it. A new 'int guest_lbr_enabled'
>> field in the "struct cpu_hw_events", is marked as true when perf adds
>> a guest LBR event and false on deletion.
>>
>> The LBR stack msrs are accessible to the guest when its guest LBR event
>> is scheduled in by the perf subsystem. Before scheduling out the event,
>> we should avoid host changes on IA32_DEBUGCTLMSR or LBR_SELECT. Otherwise,
>> some unexpected branch operations may interfere with guest behavior,
>> pollute LBR records, and even cause host branch data leakage. In addition,
>> the intel_pmu_lbr_read() on the host is also avoidable for guest usage.
>>
>> On v4 PMU or later, the LBR stack are frozen on the overflowed condition
>> if Freeze_LBR_On_PMI is true and resume recording via acking LBRS_FROZEN
>> to global status msr instead of re-enabling IA32_DEBUGCTL.LBR. So when a
>> guest LBR event is running, the host PMI handler has to keep LBRS_FROZEN
>> bit set (thus LBR being frozen) until the guest enables it. Otherwise,
>> when the guest enters non-root mode, the LBR will start recording and
>> the guest PMI handler code will also pollute the LBR stack.
>>
>> To ensure that guest LBR records are not lost during the context switch,
>> the BRANCH_CALL_STACK flag should be configured in the 'branch_sample_type'
>> for a guest LBR event because a callstack event could save/restore guest
>> unread records with the help of intel_pmu_lbr_sched_task() naturally.
>>
>> However, the regular host LBR perf event doesn't save/restore LBR_SELECT,
>> because it's configured in the LBR_enable() based on branch_sample_type.
>> So when a guest LBR is running, the guest LBR_SELECT may changes for its
>> own use and we have to add the LBR_SELECT save/restore to ensure what the
>> guest LBR_SELECT value doesn't get lost during the context switching.
> I had to read the patch before that made sense; I think it's mostly
> there, but it can use a little help.
Ah, thanks for your patient. This is good news for me that
you did read the main part of the proposal changes in this version.

>
>
>> @@ -691,8 +714,12 @@ void intel_pmu_lbr_read(void)
>>   	 *
>>   	 * This could be smarter and actually check the event,
>>   	 * but this simple approach seems to work for now.
>> +	 *
>> +	 * And there is no need to read lbr here if a guest LBR event
> There's 'lbr' and 'LBR' in the same sentence
Yes, l'll fix it.
>
>> +	 * is using it, because the guest will read them on its own.
>>   	 */
>> -	if (!cpuc->lbr_users || cpuc->lbr_users == cpuc->lbr_pebs_users)
>> +	if (!cpuc->lbr_users || cpuc->guest_lbr_enabled ||
>> +		cpuc->lbr_users == cpuc->lbr_pebs_users)
> indent fail
Yes, l'll fix it.
>
>>   		return;
>>   
>>   	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)

