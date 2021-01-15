Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C6A2F7F91
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 16:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732692AbhAOPaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 10:30:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:4719 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731683AbhAOPaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 10:30:09 -0500
IronPort-SDR: xthGdTZlG4BvzfTAX0ZJhQY69vCRu9XcuPlfVP/Gm4rRaimJkQBa9S/bW20YDFM0WPvV1o8PTQ
 hVjj4ODyOuMg==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="175058065"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="175058065"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 07:29:29 -0800
IronPort-SDR: Ixg0JjW8VZZZzXk+jB1PStwoRSX9tGBJLAATnjowIqeKWkevJpQ6ocy0moGpwOtqUM7r0REw7l
 uF8thNaTqmDg==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="382699941"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.174.174]) ([10.249.174.174])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 07:29:24 -0800
Subject: Re: [PATCH v3 06/17] KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation
 for extended PEBS
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-7-like.xu@linux.intel.com>
 <YAGqrIqTxNU/PMxo@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <ff0ccfdd-e5e5-1a6d-57ff-9117a44a30b2@intel.com>
Date:   Fri, 15 Jan 2021 23:29:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YAGqrIqTxNU/PMxo@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/15 22:46, Peter Zijlstra wrote:
> On Mon, Jan 04, 2021 at 09:15:31PM +0800, Like Xu wrote:
>
>> +	if (cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask) {
>> +		arr[1].msr = MSR_IA32_PEBS_ENABLE;
>> +		arr[1].host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask;
>> +		arr[1].guest = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
>> +		/*
>> +		 * The guest PEBS will be disabled once the host PEBS is enabled
>> +		 * since the both enabled case may brings a unknown PMI to
>> +		 * confuse host and the guest PEBS overflow PMI would be missed.
>> +		 */
>> +		if (arr[1].host)
>> +			arr[1].guest = 0;
>> +		arr[0].guest |= arr[1].guest;
>> +		*nr = 2;
> Elsewhere you write:
>
>> When we have a PEBS PMI due to guest workload and vm-exits,
>> the code path from vm-exit to the host PEBS PMI handler may also
>> bring PEBS PMI and mark the status bit. The current PMI handler
>> can't distinguish them and would treat the later one as a suspicious
>> PMI and output a warning.
> So the reason isn't that spurious PMIs are tedious, but that the
> hardware is actually doing something weird.
>
> Or am I not reading things straight?

I think the PEBS facility works as expected because in the both enabled case,
the first PEBS PMI is generated from host counter 1 based on guest 
interrupt_threshold
and the later PEBS PMI could be generated from host counter 2 based on host 
interrupt_threshold.

Therefore, if we adjust the overflow value to a small value, so that the 
number of
instructions from vm-exit to global ctrl disabling could be enough big to 
trigger PEBS PMI.

Do you think this is weird, or do you see other possibilities ?
