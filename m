Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656581D9632
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 14:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbgESMYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 08:24:43 -0400
Received: from mga03.intel.com ([134.134.136.65]:25136 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgESMYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 08:24:42 -0400
IronPort-SDR: 496qYSdewMGhLUJgzF22dMFgIYgDXyLavxGIjOPvu462z31+XdfR1qv5ovBQgLU4odrg7fLgO3
 CtlKTN0X5LFQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 05:24:42 -0700
IronPort-SDR: uXcqt5cgS8vziQXjvTsLjF60PBfq6Ka4H9MGh3uVo2aJdrct40suUlGS/XoeJbWge4pX/d/ycB
 QBf/rUZ/rccQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,410,1583222400"; 
   d="scan'208";a="288940600"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.171.98]) ([10.249.171.98])
  by fmsmga004.fm.intel.com with ESMTP; 19 May 2020 05:24:38 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH v11 08/11] KVM: x86/pmu: Emulate LBR feature via guest LBR
 event
To:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu@linux.intel.com>
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
 <20200514083054.62538-9-like.xu@linux.intel.com>
 <20200519110011.GG279861@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <1fd08161-b3d2-1731-37c5-6c9fe0e06233@intel.com>
Date:   Tue, 19 May 2020 20:24:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200519110011.GG279861@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/5/19 19:00, Peter Zijlstra wrote:
> On Thu, May 14, 2020 at 04:30:51PM +0800, Like Xu wrote:
>> +static inline bool event_is_oncpu(struct perf_event *event)
>> +{
>> +	return event && event->oncpu != -1;
>> +}
>
>> +/*
>> + * It's safe to access LBR msrs from guest when they have not
>> + * been passthrough since the host would help restore or reset
>> + * the LBR msrs records when the guest LBR event is scheduled in.
>> + */
>> +static bool intel_pmu_access_lbr_msr(struct kvm_vcpu *vcpu,
>> +				     struct msr_data *msr_info, bool read)
>> +{
>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +	u32 index = msr_info->index;
>> +
>> +	if (!intel_is_valid_lbr_msr(vcpu, index))
>> +		return false;
>> +
>> +	if (!msr_info->host_initiated && !pmu->lbr_event)
>> +		intel_pmu_create_lbr_event(vcpu);
>> +
>> +	/*
>> +	 * Disable irq to ensure the LBR feature doesn't get reclaimed by the
>> +	 * host at the time the value is read from the msr, and this avoids the
>> +	 * host LBR value to be leaked to the guest. If LBR has been reclaimed,
>> +	 * return 0 on guest reads.
>> +	 */
>> +	local_irq_disable();
>> +	if (event_is_oncpu(pmu->lbr_event)) {
>> +		if (read)
>> +			rdmsrl(index, msr_info->data);
>> +		else
>> +			wrmsrl(index, msr_info->data);
>> +	} else if (read)
>> +		msr_info->data = 0;
>> +	local_irq_enable();
>> +
>> +	return true;
>> +}
> So this runs in the vCPU thread in host context to emulate the MSR
> access, right?
Yes, it's called to emulate MSR accesses when the guest LBR event is
scheduled on while the LBR stack MSRs have not been passthrough to the vCPU.

Thanks,
Like Xu
>

