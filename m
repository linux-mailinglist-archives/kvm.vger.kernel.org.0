Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FB52F576F
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 04:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbhANB7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:59:51 -0500
Received: from mga05.intel.com ([192.55.52.43]:52821 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729378AbhANB7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 20:59:47 -0500
IronPort-SDR: YsryFXQNNo40CS64TKDr93tsFvQdfRTUCg+X3rz/uq6zVQ55p7imKzJ2nbB8neU5XtUHX09ADf
 zJgD9yWwW1gg==
X-IronPort-AV: E=McAfee;i="6000,8403,9863"; a="263086146"
X-IronPort-AV: E=Sophos;i="5.79,345,1602572400"; 
   d="scan'208";a="263086146"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2021 17:58:59 -0800
IronPort-SDR: KROhvZylfWMrAJyjWdB9MBI6G5CCmZmiATzs+GnldWjGPwXsvos6tq/eauIXuMzjSsNgMONA+b
 DSFG90SkgDVQ==
X-IronPort-AV: E=Sophos;i="5.79,345,1602572400"; 
   d="scan'208";a="353704460"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2021 17:58:54 -0800
Subject: Re: [PATCH v3 03/17] KVM: x86/pmu: Introduce the ctrl_mask value for
 fixed counter
To:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu@linux.intel.com>
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
 <20210104131542.495413-4-like.xu@linux.intel.com>
 <X/82nCHfFH0TVur2@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <cb73b122-47f8-d3fa-232a-e865920a8bee@intel.com>
Date:   Thu, 14 Jan 2021 09:58:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <X/82nCHfFH0TVur2@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/14 2:06, Peter Zijlstra wrote:
> On Mon, Jan 04, 2021 at 09:15:28PM +0800, Like Xu wrote:
>> @@ -327,6 +328,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>   	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
>>   	pmu->version = 0;
>>   	pmu->reserved_bits = 0xffffffff00200000ull;
>> +	pmu->fixed_ctr_ctrl_mask = ~0ull;
> All 1s
>
>>   
>>   	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
>>   	if (!entry)
>> @@ -358,6 +360,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>   			((u64)1 << edx.split.bit_width_fixed) - 1;
>>   	}
>>   
>> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
>> +		pmu->fixed_ctr_ctrl_mask |= (0xbull << (i * 4));
> With some extra 1s on top

You're right, I think it should be:

     pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));

w/o invertion and I will fix it in the next version.

>
>> +	pmu->fixed_ctr_ctrl_mask = ~pmu->fixed_ctr_ctrl_mask;
> Inverted is all 0s, always.
>
>>   	pmu->global_ctrl = ((1ull << pmu->nr_arch_gp_counters) - 1) |
>>   		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED);
>>   	pmu->global_ctrl_mask = ~pmu->global_ctrl;
>> -- 
>> 2.29.2
>>

