Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7650760D9FE
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 05:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiJZDkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 23:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiJZDkn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 23:40:43 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F525757F;
        Tue, 25 Oct 2022 20:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666755640; x=1698291640;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=m1J819reqM48jm228hcMX4Esd+oOKdedmDl84tOWAEI=;
  b=fX3HwDKbfNdmpWiEV3tBvezPG+cWaEfkzk5EFxmzprpeDBtScO50leSB
   mCOI4n8rRo+3L0+wcZBUxsYerOKkpIYbUUnbbr1VjFhfBd+wJ5L+vPUJs
   TtnXqitRNHdeyL75e4mpdMr5AzXGn8yAVz7lJM6pdNciDh8FhV7xinXN3
   urX4YuYXg/pPh2VJk/gL12K1IRZ5v99qwtKlyhmMK35+keueBwzSbiNW1
   JTfECMfRG1KPpm03TJ7AsC3C2xQLKAwQ395XerTPLmfK+2a7cPvaay9tD
   kTAv0lzmSGgRdGRJwuAMidHRj2GGS4RX7R5JILeGe2KqHJk8BWNWKm9mF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="305466337"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="305466337"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 20:40:39 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="626655402"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="626655402"
Received: from jiaxiche-mobl.ccr.corp.intel.com (HELO [10.238.2.23]) ([10.238.2.23])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 20:40:33 -0700
Message-ID: <cce514da-32b4-3b84-cfad-67a05705bc9f@linux.intel.com>
Date:   Wed, 26 Oct 2022 11:40:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH 1/6] x86: KVM: Enable CMPccXADD CPUID and expose it to
 guest
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, jane.malalane@citrix.com, nathan@kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
 <20221019084734.3590760-2-jiaxi.chen@linux.intel.com>
 <Y1AUhlwWjIkKfZHA@google.com>
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
In-Reply-To: <Y1AUhlwWjIkKfZHA@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/19/2022 11:15 PM, Sean Christopherson wrote:
> For all the shortlogs, "expose it to guest" is technically wrong.  Adding
> recognition in kvm/cpuid.c advertises KVM support to host userspace.  Whether or
> not a feature is exposed to the guest is up to the userspace VMM.
> 
> On Wed, Oct 19, 2022, Jiaxi Chen wrote:
>> CMPccXADD is a new set of instructions in the latest Intel platform Sierra
>> Forest. It includes a semaphore operation that can compare and add the
> 
> In general, avoid pronouns in changelogs, it's not clear what "it" refers to here.
> 
> And for all of these changelogs, please explicitly state that there are no VMX
> controls for these instructions, assuming that's actually true.  From a KVM
> perspective, that's far more interesting than the details of the instruction(s).
> 
>> operands if condition is met, which can improve database performance.
>>
>> The bit definition:
>> CPUID.(EAX=7,ECX=1):EAX[bit 7]
>>
>> This patch enables this CPUID in the kernel feature bits and expose it to
>> guest OS.
> 
> Same thing here, KVM doesn't decide whether or not to expose the feature to the
> guest.
> 
>> Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
>> ---
>>  arch/x86/include/asm/cpufeatures.h | 1 +
>>  arch/x86/kvm/cpuid.c               | 2 +-
>>  2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index ef4775c6db01..445626cb5779 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -308,6 +308,7 @@
>>  /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
>>  #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
>>  #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
>> +#define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* CMPccXADD instructions */
> 
> Boris,
> 
> What do you think about moving CPUID_7_1_EAX to be a KVM-only leaf too?  AFAICT,
> KVM passthrough is the only reason the existing features are defined.
Boris,

Since CPUID_7_1_EAX has only 5 features now, it is a big waste, should we move it to 
KVM-only leaf as Sean suggested. What's your opinion about this? 
-- 
Regards,
Jiaxi
