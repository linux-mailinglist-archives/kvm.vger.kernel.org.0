Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D65B6C8E1
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 07:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfGRFpW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 01:45:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:11144 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbfGRFpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 01:45:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 22:45:21 -0700
X-IronPort-AV: E=Sophos;i="5.64,276,1559545200"; 
   d="scan'208";a="161970970"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.239.196.90]) ([10.239.196.90])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 17 Jul 2019 22:45:20 -0700
Subject: Re: [PATCH] KVM: x86/vPMU: refine kvm_pmu err msg when event creation
 failed
To:     Joe Perches <joe@perches.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Avi Kivity <avi@scylladb.com>
Cc:     kvm@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        like.xu@linux.inetl.com, linux-kernel@vger.kernel.org
References: <20190718044914.35631-1-like.xu@linux.intel.com>
 <9eda0e29f524275a217411ea81352271b782baa4.camel@perches.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <1f865724-999d-89a7-c246-acfe9cb08d54@linux.intel.com>
Date:   Thu, 18 Jul 2019 13:45:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <9eda0e29f524275a217411ea81352271b782baa4.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Joe,

On 2019/7/18 13:18, Joe Perches wrote:
> On Thu, 2019-07-18 at 12:49 +0800, Like Xu wrote:
>> If a perf_event creation fails due to any reason of the host perf
>> subsystem, it has no chance to log the corresponding event for guest
>> which may cause abnormal sampling data in guest result. In debug mode,
>> this message helps to understand the state of vPMC and we should not
>> limit the number of occurrences.
> []
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> []
>> @@ -131,8 +131,8 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>>   						 intr ? kvm_perf_overflow_intr :
>>   						 kvm_perf_overflow, pmc);
>>   	if (IS_ERR(event)) {
>> -		printk_once("kvm_pmu: event creation failed %ld\n",
>> -			    PTR_ERR(event));
>> +		pr_debug("kvm_pmu: event creation failed %ld\n for pmc->idx = %d",
>> +			    PTR_ERR(event), pmc->idx);
> 
> Perhaps this was written as printk_once to avoid
> spamming the log with repeated messages.

The spamming case in practice from this messages is very rare but it's 
logically possible.

> 
> Maybe this should use pr_debug_ratelimited.
> (and it should also have a \n termination like:)

Thanks and it's my mistake, agree on '\n' usage.

> 
> 		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
> 				     PTR_ERR(event), pmc->idx);
> 
> Perhaps Avi Kivity remembers why he wrote it this way.
> https://lore.kernel.org/kvm/1305129333-7456-6-git-send-email-avi@redhat.com >>
> 

