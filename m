Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C306751FF21
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 16:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbiEIOKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 10:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236600AbiEIOKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 10:10:05 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D8C15FE0E;
        Mon,  9 May 2022 07:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652105171; x=1683641171;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=UkLhGz8IQfm7ReY4/G4McTKAELe6u5h1t8AUYe2t5BU=;
  b=eFxMes57Aa9JFhMmzsynIQ/P4jdqp7U2t0uhdTbG4OWIWr0HxEzINUto
   RxflbV8z4+d3/xjN18yRgJLU5CUpFhlOXISDsEe1yqeJlJywgWVuNx0ai
   vyHV612s43yj66+6GYMQK+1UTz0dYlEw0RC225tT4Or0AQ9K+uacoEg0T
   G1KNGQJlIlki+Vd+MuMi20Db9xCgwK3nuQB5kPY3A51aAl3pEP0hgeug8
   C+nJ70BWcVFcRlYtkl5Hvg0plSnMk4kIKxrowIo49PRzcmigBdIhfQOCm
   2bxoTjmtYw38qrJ67DgEDWakOEaZanGQwcAMiUkxRwUGKg+WrL5AVxFro
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="256594106"
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="256594106"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 07:06:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="696561273"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 09 May 2022 07:06:10 -0700
Received: from [10.252.208.70] (kliang2-MOBL.ccr.corp.intel.com [10.252.208.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 0F2A85807C8;
        Mon,  9 May 2022 07:06:08 -0700 (PDT)
Message-ID: <59e62b5b-beed-daef-971b-864a41928446@linux.intel.com>
Date:   Mon, 9 May 2022 10:06:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v11 08/16] KVM: x86/pmu: Refactor code to support guest
 Arch LBR
Content-Language: en-US
To:     "Yang, Weijiang" <weijiang.yang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220506033305.5135-1-weijiang.yang@intel.com>
 <20220506033305.5135-9-weijiang.yang@intel.com>
 <ce4fe0e1-357c-9e8d-67f7-f065ccbe3851@linux.intel.com>
 <d2e14530-f3c1-53c9-dd03-95ea2c1bf3f1@intel.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <d2e14530-f3c1-53c9-dd03-95ea2c1bf3f1@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/6/2022 10:32 PM, Yang, Weijiang wrote:
> 
> On 5/6/2022 11:03 PM, Liang, Kan wrote:
>> On 5/5/2022 11:32 PM, Yang Weijiang wrote:
>>
>>    bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
>> @@ -199,12 +203,20 @@ static bool intel_pmu_is_valid_lbr_msr(struct 
>> kvm_vcpu *vcpu, u32 index)
>>            return ret;
>>        }
>> -    ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS) ||
>> -        (index >= records->from && index < records->from + 
>> records->nr) ||
>> -        (index >= records->to && index < records->to + records->nr);
>> +    if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
>> +        ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS);
>> +
>> Shouldn't we return immediately if (ret == true)?
>> Keep checking if (!ret) looks uncommon.
>>
>> Actually we probably don't need the ret in this function.
>>
>>     if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) &&
>>         ((index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS)))
>>         return true;
>>
>>> +    if (!ret) {
>>> +        ret = (index >= records->from &&
>>> +               index < records->from + records->nr) ||
>>> +              (index >= records->to &&
>>> +               index < records->to + records->nr);
>>> +    }
>>     if ((index >= records->from &&
>>         index < records->from + records->nr) ||
>>         (index >= records->to &&
>>         index < records->to + records->nr))
>>         return true;
>>
>>> -    if (!ret && records->info)
>>> -        ret = (index >= records->info && index < records->info + 
>>> records->nr);
>>> +    if (!ret && records->info) {
>>> +        ret = (index >= records->info &&
>>> +               index < records->info + records->nr);
>>> +    }
>>     if (records->info &&
>>         (index >= records->info && index < records->info + records->nr)
>>         return true;
>>
>>     return false;
>> Sorry, I didn't notice it in the previous review.
> 
> Thanks Kan, so I'll modify this function as below (keeping other part 
> unchanged):
> 
>  From 642d5e05e8a8578e75531632d714cec5976ab9ac Mon Sep 17 00:00:00 2001
> From: Yang Weijiang <weijiang.yang@intel.com>
> Date: Thu, 8 Jul 2021 23:51:02 +0800
> Subject: [PATCH] KVM: x86/pmu: Refactor code to support guest Arch LBR
> 
> Take account of Arch LBR when do sanity checks before program
> vPMU for guest. Pass through Arch LBR recording MSRs to guest
> to gain better performance. Note, Arch LBR and Legacy LBR support
> are mutually exclusive, i.e., they're not both available on one
> platform.
> 
> Co-developed-by: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---

This one looks good to me.

Reviewed-by: Kan Liang <kan.liang@linux.intel.com>

Thanks,
Kan
>   arch/x86/kvm/vmx/pmu_intel.c | 47 +++++++++++++++++++++++++-----------
>   arch/x86/kvm/vmx/vmx.c       |  3 +++
>   2 files changed, 36 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index aa36d2072b91..306ce7ac9934 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -170,12 +170,16 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct 
> kvm_pmu *pmu, u32 msr)
> 
>   bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
>   {
> +       if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> +               return guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
> +
>          /*
>           * As a first step, a guest could only enable LBR feature if its
>           * cpu model is the same as the host because the LBR registers
>           * would be pass-through to the guest and they're model specific.
>           */
> -       return boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
> +       return !boot_cpu_has(X86_FEATURE_ARCH_LBR) &&
> +               boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
>   }
> 
>   bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
> @@ -188,25 +192,28 @@ bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
>   static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
>   {
>          struct x86_pmu_lbr *records = vcpu_to_lbr_records(vcpu);
> -       bool ret = false;
> 
>          if (!intel_pmu_lbr_is_enabled(vcpu))
> -               return ret;
> +               return false;
> 
>          if (index == MSR_ARCH_LBR_DEPTH || index == MSR_ARCH_LBR_CTL) {
> -               if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> -                       ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
> -               return ret;
> +               return kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
> +                      guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
>          }
> 
> -       ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS) ||
> -               (index >= records->from && index < records->from + 
> records->nr) ||
> -               (index >= records->to && index < records->to + 
> records->nr);
> +       if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) &&
> +           (index == MSR_LBR_SELECT || index == MSR_LBR_TOS))
> +               return true;
> 
> -       if (!ret && records->info)
> -               ret = (index >= records->info && index < records->info + 
> records->nr);
> +       if ((index >= records->from && index < records->from + 
> records->nr) ||
> +           (index >= records->to && index < records->to + records->nr))
> +               return true;
> 
> -       return ret;
> +       if (records->info && index >= records->info &&
> +           index < records->info + records->nr)
> +               return true;
> +
> +       return false;
>   }
> 
>   static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
> @@ -742,6 +749,9 @@ static void vmx_update_intercept_for_lbr_msrs(struct 
> kvm_vcpu *vcpu, bool set)
>                          vmx_set_intercept_for_msr(vcpu, lbr->info + i, 
> MSR_TYPE_RW, set);
>          }
> 
> +       if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
> +               return;
> +
>          vmx_set_intercept_for_msr(vcpu, MSR_LBR_SELECT, MSR_TYPE_RW, set);
>          vmx_set_intercept_for_msr(vcpu, MSR_LBR_TOS, MSR_TYPE_RW, set);
>   }
> @@ -782,10 +792,13 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>   {
>          struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>          struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
> +       bool lbr_enable = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) ?
> +               (vmcs_read64(GUEST_IA32_LBR_CTL) & ARCH_LBR_CTL_LBREN) :
> +               (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);
> 
>          if (!lbr_desc->event) {
>                  vmx_disable_lbr_msrs_passthrough(vcpu);
> -               if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
> +               if (lbr_enable)
>                          goto warn;
>                  if (test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use))
>                          goto warn;
> @@ -802,13 +815,19 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>          return;
> 
>   warn:
> +       if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> +               wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
>          pr_warn_ratelimited("kvm: vcpu-%d: fail to passthrough LBR.\n",
>                  vcpu->vcpu_id);
>   }
> 
>   static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
>   {
> -       if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
> +       bool lbr_enable = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) ?
> +               (vmcs_read64(GUEST_IA32_LBR_CTL) & ARCH_LBR_CTL_LBREN) :
> +               (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);
> +
> +       if (!lbr_enable)
>                  intel_pmu_release_guest_lbr_event(vcpu);
>   }
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b6bc7d97e4b4..98e56a909c01 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -573,6 +573,9 @@ static bool is_valid_passthrough_msr(u32 msr)
>          case MSR_LBR_NHM_TO ... MSR_LBR_NHM_TO + 31:
>          case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
>          case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
> +       case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
> +       case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
> +       case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
>                  /* LBR MSRs. These are handled in 
> vmx_update_intercept_for_lbr_msrs() */
>                  return true;
>          }
> -- 
> 2.27.0
> 
>> Thanks,
>> Kan
>>
