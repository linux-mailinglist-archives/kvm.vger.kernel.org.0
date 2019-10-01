Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06C5AC3412
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 14:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387744AbfJAMSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 08:18:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:42627 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732706AbfJAMSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 08:18:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 05:18:49 -0700
X-IronPort-AV: E=Sophos;i="5.64,571,1559545200"; 
   d="scan'208";a="185165068"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.172.165]) ([10.249.172.165])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 01 Oct 2019 05:18:46 -0700
Subject: Re: [PATCH 2/3] KVM: x86/vPMU: Reuse perf_event to avoid unnecessary
 pmc_reprogram_counter
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
References: <20190930072257.43352-1-like.xu@linux.intel.com>
 <20190930072257.43352-3-like.xu@linux.intel.com>
 <20191001082218.GK4519@hirez.programming.kicks-ass.net>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <e6beb99d-3073-b03a-3e30-449fc79cd203@linux.intel.com>
Date:   Tue, 1 Oct 2019 20:18:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191001082218.GK4519@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 2019/10/1 16:22, Peter Zijlstra wrote:
> On Mon, Sep 30, 2019 at 03:22:56PM +0800, Like Xu wrote:
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 46875bbd0419..74bc5c42b8b5 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -140,6 +140,35 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>>   	clear_bit(pmc->idx, (unsigned long*)&pmc_to_pmu(pmc)->reprogram_pmi);
>>   }
>>   
>> +static void pmc_pause_counter(struct kvm_pmc *pmc)
>> +{
>> +	if (!pmc->perf_event)
>> +		return;
>> +
>> +	pmc->counter = pmc_read_counter(pmc);
>> +
>> +	perf_event_disable(pmc->perf_event);
>> +
>> +	/* reset count to avoid redundant accumulation */
>> +	local64_set(&pmc->perf_event->count, 0);
> 
> Yuck, don't frob in data structures you don't own.

Yes, it's reasonable. Thanks.

> 
> Just like you exported the IOC_PERIOD thing, so too is there a
> IOC_RESET.
> 
> Furthermore; wth do you call pmc_read_counter() _before_ doing
> perf_event_disable() ? Doing it the other way around is much cheaper,
> even better, you can use perf_event_count() after disable.

Yes, it's much better and let me apply this.

> 
>> +}
>> +
>> +static bool pmc_resume_counter(struct kvm_pmc *pmc)
>> +{
>> +	if (!pmc->perf_event)
>> +		return false;
>> +
>> +	/* recalibrate sample period and check if it's accepted by perf core */
>> +	if (perf_event_period(pmc->perf_event,
>> +			(-pmc->counter) & pmc_bitmask(pmc)))
>> +		return false;
> 
> I'd do the reset here, but then you have 3 function in a row that do
> perf_event_ctx_lock()+perf_event_ctx_unlock(), which is rather
> expensive.

Calling pmc_pause_counter() is not always followed by calling 
pmc_resume_counter(). The former may be called multiple times before the 
later is called, so if we do not reset event->count in the 
pmc_pause_counter(), it will be repeatedly accumulated into pmc->counter 
which is a functional error.

> 
>> +
>> +	/* reuse perf_event to serve as pmc_reprogram_counter() does*/
>> +	perf_event_enable(pmc->perf_event);
>> +	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
>> +	return true;
>> +}
> 

