Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466E2359609
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 09:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhDIHH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 03:07:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:45714 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231630AbhDIHH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 03:07:57 -0400
IronPort-SDR: yYuBZGPB74CDNSu4TP17Fc9TLjesoP9jjy+Mz4e+nTEwIMCWzGLe4X/7+i7z1l7qk2KwSXflq6
 tNaxdDAG6owg==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="193819433"
X-IronPort-AV: E=Sophos;i="5.82,208,1613462400"; 
   d="scan'208";a="193819433"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 00:07:44 -0700
IronPort-SDR: NvnqZbMIt4bbgLmNxOtZ6ggslg6Nofws6gwwAVSc3fq/eZ7SLJ4YzN7pPNbosdt7aY/criDkU4
 wPB9AO+9SDGA==
X-IronPort-AV: E=Sophos;i="5.82,208,1613462400"; 
   d="scan'208";a="416145833"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 00:07:41 -0700
Subject: Re: [PATCH v4 08/16] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to
 manage guest DS buffer
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Like Xu <like.xu@linux.intel.com>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
 <20210329054137.120994-9-like.xu@linux.intel.com>
 <YG3SPsiFJPeXQXhq@hirez.programming.kicks-ass.net>
 <610bfd14-3250-0542-2d93-cbd15f2b4e16@intel.com>
 <YG62VBBix2WVy3XA@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <8695f271-9da9-f16d-15f2-e2757186db65@intel.com>
Date:   Fri, 9 Apr 2021 15:07:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YG62VBBix2WVy3XA@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 2021/4/8 15:52, Peter Zijlstra wrote:
>> This is because in the early part of this function, we have operations:
>>
>>      if (x86_pmu.flags & PMU_FL_PEBS_ALL)
>>          arr[0].guest &= ~cpuc->pebs_enabled;
>>      else
>>          arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
>>
>> and if guest has PEBS_ENABLED, we need these bits back for PEBS counters:
>>
>>      arr[0].guest |= arr[1].guest;

I can't keep up with you on this comment and would you explain more ?

> I don't think that's right, who's to say they were set in the first
> place? The guest's GLOBAL_CTRL could have had the bits cleared at VMEXIT
> time. You can't unconditionally add PEBS_ENABLED into GLOBAL_CTRL,
> that's wrong.
>

To address your previous comments, does the code below look good to you?

static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
{
     struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
     struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
     struct debug_store *ds = __this_cpu_read(cpu_hw_events.ds);
     struct kvm_pmu *pmu = (struct kvm_pmu *)data;
     u64 pebs_mask = (x86_pmu.flags & PMU_FL_PEBS_ALL) ?
             cpuc->pebs_enabled : (cpuc->pebs_enabled & PEBS_COUNTER_MASK);
     int i = 0;

     arr[i].msr = MSR_CORE_PERF_GLOBAL_CTRL;
     arr[i].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
     arr[i].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
     arr[i].guest &= ~pebs_mask;

     if (!x86_pmu.pebs)
         goto out;

     /*
      * If PMU counter has PEBS enabled it is not enough to
      * disable counter on a guest entry since PEBS memory
      * write can overshoot guest entry and corrupt guest
      * memory. Disabling PEBS solves the problem.
      *
      * Don't do this if the CPU already enforces it.
      */
     if (x86_pmu.pebs_no_isolation) {
         i++;
         arr[i].msr = MSR_IA32_PEBS_ENABLE;
         arr[i].host = cpuc->pebs_enabled;
         arr[i].guest = 0;
         goto out;
     }

     if (!pmu || !x86_pmu.pebs_vmx)
         goto out;

     i++;
     arr[i].msr = MSR_IA32_DS_AREA;
     arr[i].host = (unsigned long)ds;
     arr[i].guest = pmu->ds_area;

     if (x86_pmu.intel_cap.pebs_baseline) {
         i++;
         arr[i].msr = MSR_PEBS_DATA_CFG;
         arr[i].host = cpuc->pebs_data_cfg;
         arr[i].guest = pmu->pebs_data_cfg;
     }

     i++;
     arr[i].msr = MSR_IA32_PEBS_ENABLE;
     arr[i].host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask;
     arr[i].guest = pebs_mask & ~cpuc->intel_ctrl_host_mask;

     if (arr[i].host) {
         /* Disable guest PEBS if host PEBS is enabled. */
         arr[i].guest = 0;
     } else {
         /* Disable guest PEBS for cross-mapped PEBS counters. */
         arr[i].guest &= ~pmu->host_cross_mapped_mask;
         arr[0].guest |= arr[i].guest;
     }

out:
     *nr = ++i;
     return arr;
}
