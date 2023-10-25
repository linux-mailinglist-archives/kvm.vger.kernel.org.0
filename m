Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A097D6A09
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 13:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbjJYL0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 07:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234703AbjJYL0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 07:26:48 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21596137;
        Wed, 25 Oct 2023 04:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698233207; x=1729769207;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=U898RgRa9XJVhqUowGUXC2Jsf0LatDtgPXZQS2KdZeI=;
  b=iF14QKz2tDt3iZ9VMp7u6bPtqI2PKFZ6iuO80l5FkwGmIYI8WswE6qTB
   FZIeCqHOQeThBq06dQBBEuVzToKhozWDjWegTH8y2CkfZBOOn0CR9G2RU
   X+Nj/3jL/SKOMrhSwxnPzedmay5eVjXwoMFz5PZAEfCQ9ovTrwK6BEUBO
   XHyQIPLOGZ8Bo2bWHE6W64pkI0QMjRSZMgvwikgOKkuVAiQ10e0UrvSTE
   LCkDWFZefRMA4GyEdrZYqQW7+Nr0C6T6/L+d2dt50pXR2/ZcHDp5B51IN
   kIgOuRXJ8TJExh9fSe5oo+mYvsy1ogxkBu5duhqHbcmooOHGPzSv7XhZN
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="8846492"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="8846492"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 04:26:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="6812800"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.25.165]) ([10.93.25.165])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 04:26:36 -0700
Message-ID: <305f1ee4-a8c3-48eb-9368-531329e5266e@linux.intel.com>
Date:   Wed, 25 Oct 2023 19:26:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch 4/5] x86: pmu: Support validation for Intel
 PMU fixed counter 3
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Mingwei Zhang <mizhang@google.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Dapeng Mi <dapeng1.mi@intel.com>
References: <20231024075748.1675382-1-dapeng1.mi@linux.intel.com>
 <20231024075748.1675382-5-dapeng1.mi@linux.intel.com>
 <CALMp9eSQyyihzEz+xpB0QCZ4=WqQ9TGiSwMYiFob0D_Z7OY7mg@mail.gmail.com>
From:   "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CALMp9eSQyyihzEz+xpB0QCZ4=WqQ9TGiSwMYiFob0D_Z7OY7mg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/25/2023 3:05 AM, Jim Mattson wrote:
> On Tue, Oct 24, 2023 at 12:51 AM Dapeng Mi <dapeng1.mi@linux.intel.com> wrote:
>> Intel CPUs, like Sapphire Rapids, introduces a new fixed counter
>> (fixed counter 3) to counter/sample topdown.slots event, but current
>> code still doesn't cover this new fixed counter.
>>
>> So add code to validate this new fixed counter.
> Can you explain how this "validates" anything?


I may not describe the sentence clearly. This would validate the fixed 
counter 3 can count the slots event and get a valid count in a 
reasonable range. Thanks.


>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>   x86/pmu.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index 1bebf493d4a4..41165e168d8e 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -46,7 +46,8 @@ struct pmu_event {
>>   }, fixed_events[] = {
>>          {"fixed 1", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
>>          {"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
>> -       {"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
>> +       {"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N},
>> +       {"fixed 4", MSR_CORE_PERF_FIXED_CTR0 + 3, 1*N, 100*N}
>>   };
>>
>>   char *buf;
>> --
>> 2.34.1
>>
