Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2521A60D9EB
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 05:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiJZDeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 23:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbiJZDeG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 23:34:06 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0A980EA5;
        Tue, 25 Oct 2022 20:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666755245; x=1698291245;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CiHzwKChNtskDci/iK98LzhjMC+nlcLra68ozPBmmZA=;
  b=VAHyhMJYsjtd1+zrGGuGX9a/Pjp6b6URhRxGljHw5L5dN+9fQo1h2/1+
   icuEiQ/uF9HHv85UVehHEGG7648RAXa0tr+e4+oCzatplpxFQ4gnYrMmT
   rbGnvg/Brh6itUuvjPVPjseGDMcz1AaxSU2Btkjv8+yqCO2QH2mzsn/O3
   GIG0BYNNp7InooTt25dKFYI4Pw8ZU0tBShDMhQZyt8vipBRu7M+iAzO5B
   aFtUwWpqd3e6cKQQ3oEOQMkGhN4OejonaewAdNiulr296ONGQpBqlfEsj
   K2JMHD/sZBZzpJ07tUmS3XW22HKMEM86OieQ+k7i3ggn5WEVz0X9aE3cw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="306580940"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="306580940"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 20:34:04 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="806901572"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="806901572"
Received: from jiaxiche-mobl.ccr.corp.intel.com (HELO [10.238.2.23]) ([10.238.2.23])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 20:33:58 -0700
Message-ID: <46a493d4-9a2b-ae52-27bf-8e306a85c570@linux.intel.com>
Date:   Wed, 26 Oct 2022 11:33:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH 4/6] x86: KVM: Enable AVX-VNNI-INT8 CPUID and expose it to
 guest
To:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, jane.malalane@citrix.com, nathan@kernel.org,
        linux-kernel@vger.kernel.org
References: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
 <20221019084734.3590760-5-jiaxi.chen@linux.intel.com>
 <Y0+6tJ7MiZWbYK5l@zn.tnic> <Y1AQX3RfM+awULlE@google.com>
 <Y1ATKF2xjERFbspn@google.com>
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
In-Reply-To: <Y1ATKF2xjERFbspn@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/19/2022 11:09 PM, Sean Christopherson wrote:
> On Wed, Oct 19, 2022, Sean Christopherson wrote:
>> On Wed, Oct 19, 2022, Borislav Petkov wrote:
>>> On Wed, Oct 19, 2022 at 04:47:32PM +0800, Jiaxi Chen wrote:
>>>> AVX-VNNI-INT8 is a new set of instructions in the latest Intel platform
>>>> Sierra Forest. It multiplies the individual bytes of two unsigned or
>>>> unsigned source operands, then add and accumulate the results into the
>>>> destination dword element size operand. This instruction allows for the
>>>> platform to have superior AI capabilities.
>>>>
>>>> The bit definition:
>>>> CPUID.(EAX=7,ECX=1):EDX[bit 4]
>>>
>>> For this particular one, use scattered.c instead of adding a new leaf.
>>
>> Unless the kernel wants to use X86_FEATURE_AVX_VNNI_INT8, which seems unlikely,
>> there's no need to create a scattered entry.  This can be handled in KVM by adding
>> a KVM-only leaf entry (which will be needed no matter what), plus a #define for
>> X86_FEATURE_AVX_VNNI_INT8 to direct it to the KVM entry.
>>
>> E.g. 
>>
>> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
>> index a19d473d0184..25e7bfc61607 100644
>> --- a/arch/x86/kvm/reverse_cpuid.h
>> +++ b/arch/x86/kvm/reverse_cpuid.h
>> @@ -13,6 +13,7 @@
>>   */
>>  enum kvm_only_cpuid_leafs {
>>         CPUID_12_EAX     = NCAPINTS,
>> +       CPUID_7_1_EDX,
>>         NR_KVM_CPU_CAPS,
>>  
>>         NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
>> @@ -24,6 +25,16 @@ enum kvm_only_cpuid_leafs {
>>  #define KVM_X86_FEATURE_SGX1           KVM_X86_FEATURE(CPUID_12_EAX, 0)
>>  #define KVM_X86_FEATURE_SGX2           KVM_X86_FEATURE(CPUID_12_EAX, 1)
>>  
>> +#define KVM_X86_FEATURE_AVX_VNNI_INT8  KVM_X86_FEATURE(CPUID_7_1_EDX, 4)
>> +
>> +/*
>> + * Alias X86_FEATURE_* to the KVM variant for features in KVM-only leafs that
>> + * aren't scattered by cpufeatures.h so that X86_FEATURE_* can be used in KVM,
>> + * e.g. to query guest CPUID.  As a bonus, no translation is needed for these
>> + * features in __feature_translate().
>> + */
>> +#define X86_FEATURE_AVX_VNNI_INT8      KVM_X86_FEATURE_AVX_VNNI_INT8
> 
> Actually, there's no need for KVM_X86_FEATURE_AVX_VNNI_INT8 in this case, just
> #define X86_FEATURE_AVX_VNNI_INT8 directly.  The KVM_ prefixed macro exists purely
> to redirect the non-KVM_ version, but that's unnecessary in this case.
> 
> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> index a19d473d0184..38adafb03490 100644
> --- a/arch/x86/kvm/reverse_cpuid.h
> +++ b/arch/x86/kvm/reverse_cpuid.h
> @@ -13,6 +13,7 @@
>   */
>  enum kvm_only_cpuid_leafs {
>         CPUID_12_EAX     = NCAPINTS,
> +       CPUID_7_1_EDX,
>         NR_KVM_CPU_CAPS,
>  
>         NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
> @@ -24,6 +25,13 @@ enum kvm_only_cpuid_leafs {
>  #define KVM_X86_FEATURE_SGX1           KVM_X86_FEATURE(CPUID_12_EAX, 0)
>  #define KVM_X86_FEATURE_SGX2           KVM_X86_FEATURE(CPUID_12_EAX, 1)
>  
> +/*
> + * Omit the KVM_ prefix for features in KVM-only leafs that aren't scattered by
> + * cpufeatures.h so that X86_FEATURE_* can be used in KVM,* e.g. to query guest
> + * CPUID.  As a bonus, no handling in __feature_translate() is needed.
> + */
> +#define X86_FEATURE_AVX_VNNI_INT8      KVM_X86_FEATURE(CPUID_7_1_EDX, 4)
> +
>  struct cpuid_reg {
>         u32 function;
>         u32 index;
> @@ -48,6 +56,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
>         [CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
>         [CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
>         [CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
> +       [CPUID_7_1_EDX]       = {         7, 1, CPUID_EDX},
>  };

Use KVM-only leafs is better for edx in this case. Will follow this suggestion in v2. 
Thanks Sean very much.
-- 
Regards,
Jiaxi
