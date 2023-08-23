Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3D9784EA9
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 04:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbjHWCWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 22:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbjHWCWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 22:22:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D88CD3;
        Tue, 22 Aug 2023 19:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692757367; x=1724293367;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=E2DY2rZ63Jkob00d6HBggLmef15UJ2Y9YFk0LbPi1i8=;
  b=BCZ84vwnBF/m+vesZFYaUHWDLo5JzlBXg43TAs2k6cWUSZOAhksrXdoh
   ZPu2FuqEsZz+yoMjI4KLxs35tY6Sq46G7h1/QXJuhIMokH7TL4b9FqZL8
   kI+Sx3AM/3MOCoFWZrYkaeWdbHwWKvsX/BOcHa//mfF5qTyEfrW9th9CG
   QSeUIaS+PQQBY0qg6EVgqw/0C0uh/48rfkU7WJOS/9oma2u9IJN9Phnwg
   MNbIz+7ho3bziZaN1R+dgFCdUZJHsCLB0hXuAHjryuQNtrOabgv9YSgjc
   IzaE0ukRmM9vemTYkQk1g8Sr8dfOnjNzu+R7CYtq7gYkGMWp877w7lyr9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="372931310"
X-IronPort-AV: E=Sophos;i="6.01,194,1684825200"; 
   d="scan'208";a="372931310"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 19:22:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="765961314"
X-IronPort-AV: E=Sophos;i="6.01,194,1684825200"; 
   d="scan'208";a="765961314"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.5.53]) ([10.93.5.53])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 19:22:43 -0700
Message-ID: <18e606ba-d6b2-02f0-1511-d949c4c1e6ed@linux.intel.com>
Date:   Wed, 23 Aug 2023 10:22:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v2] KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with
 macros
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>
References: <20230815032849.2929788-1-dapeng1.mi@linux.intel.com>
 <305fa208-e1d6-7e22-3156-11fd551a8dd1@gmail.com>
From:   "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <305fa208-e1d6-7e22-3156-11fd551a8dd1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/21/2023 4:05 PM, Like Xu wrote:
> On 15/8/2023 11:28 am, Dapeng Mi wrote:
>> Magic numbers are used to manipulate the bit fields of
>> FIXED_CTR_CTRL MSR. This is not read-friendly and use macros to replace
>> these magic numbers to increase the readability.
>
> More, reuse INTEL_FIXED_0_* macros for pmu->fixed_ctr_ctrl_mask, pls.

Sure. Thanks.
>
>>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>   arch/x86/kvm/pmu.c | 10 +++++-----
>>   arch/x86/kvm/pmu.h |  6 ++++--
>>   2 files changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index edb89b51b383..fb4ef2da3e32 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -420,11 +420,11 @@ static void reprogram_counter(struct kvm_pmc *pmc)
>>       if (pmc_is_fixed(pmc)) {
>>           fixed_ctr_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl,
>>                             pmc->idx - INTEL_PMC_IDX_FIXED);
>> -        if (fixed_ctr_ctrl & 0x1)
>> +        if (fixed_ctr_ctrl & INTEL_FIXED_0_KERNEL)
>>               eventsel |= ARCH_PERFMON_EVENTSEL_OS;
>> -        if (fixed_ctr_ctrl & 0x2)
>> +        if (fixed_ctr_ctrl & INTEL_FIXED_0_USER)
>>               eventsel |= ARCH_PERFMON_EVENTSEL_USR;
>> -        if (fixed_ctr_ctrl & 0x8)
>> +        if (fixed_ctr_ctrl & INTEL_FIXED_0_ENABLE_PMI)
>>               eventsel |= ARCH_PERFMON_EVENTSEL_INT;
>>           new_config = (u64)fixed_ctr_ctrl;
>>       }
>> @@ -749,8 +749,8 @@ static inline bool cpl_is_matched(struct kvm_pmc 
>> *pmc)
>>       } else {
>>           config = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl,
>>                         pmc->idx - INTEL_PMC_IDX_FIXED);
>> -        select_os = config & 0x1;
>> -        select_user = config & 0x2;
>> +        select_os = config & INTEL_FIXED_0_KERNEL;
>> +        select_user = config & INTEL_FIXED_0_USER;
>>       }
>>         return (static_call(kvm_x86_get_cpl)(pmc->vcpu) == 0) ? 
>> select_os : select_user;
>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>> index 7d9ba301c090..ffda2ecc3a22 100644
>> --- a/arch/x86/kvm/pmu.h
>> +++ b/arch/x86/kvm/pmu.h
>> @@ -12,7 +12,8 @@
>>                         MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
>>     /* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
>> -#define fixed_ctrl_field(ctrl_reg, idx) (((ctrl_reg) >> ((idx)*4)) & 
>> 0xf)
>> +#define fixed_ctrl_field(ctrl_reg, idx) \
>> +    (((ctrl_reg) >> ((idx) * INTEL_FIXED_BITS_STRIDE)) & 
>> INTEL_FIXED_BITS_MASK)
>>     #define VMWARE_BACKDOOR_PMC_HOST_TSC        0x10000
>>   #define VMWARE_BACKDOOR_PMC_REAL_TIME        0x10001
>> @@ -165,7 +166,8 @@ static inline bool pmc_speculative_in_use(struct 
>> kvm_pmc *pmc)
>>         if (pmc_is_fixed(pmc))
>>           return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
>> -                    pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
>> +                    pmc->idx - INTEL_PMC_IDX_FIXED) &
>> +                    (INTEL_FIXED_0_KERNEL | INTEL_FIXED_0_USER);
>>         return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
>>   }
>>
>> base-commit: 240f736891887939571854bd6d734b6c9291f22e
