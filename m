Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3028751E38D
	for <lists+kvm@lfdr.de>; Sat,  7 May 2022 04:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445352AbiEGCgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 22:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237643AbiEGCgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 22:36:07 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5361707B;
        Fri,  6 May 2022 19:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651890742; x=1683426742;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=vFqRJouxaNfchEl9DmTu7VLsnysJ8DcCYP4XHQXH47w=;
  b=j7TKRMpQwI6LL0mIcLA8c53oVmKz8eudjeGVQGa6RRDAmfz6uloossNP
   qgyVjzjXpi9Co1s5qFQwjBIg4bDYeJRWWCVx7No5Tq81GOBDlcZG2pW87
   K0X+XfJGBgyzLcrdhWPwrIiqfWX4zhuHTH1+/FmzMQh/2FRwbeuEBnARD
   0r3qgusBrHM5MISPgF095Pbs9QGl+2PKXOo7mOtkO4IB3frSvIpKI3ScH
   HpF+VFpGDDZ2uWUzE95pXv9GrtiX5zAILEu/KaM1z62k0TE55WELYwVwo
   Z1fLllvvKp0z08j7NmboXAngpEsNNfbMhdAXXGyg8x2g06jxnWwYB+bAZ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="355068986"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="355068986"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 19:32:22 -0700
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="586314735"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.170.118]) ([10.249.170.118])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 19:32:18 -0700
Message-ID: <d2e14530-f3c1-53c9-dd03-95ea2c1bf3f1@intel.com>
Date:   Sat, 7 May 2022 10:32:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v11 08/16] KVM: x86/pmu: Refactor code to support guest
 Arch LBR
Content-Language: en-US
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
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
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ce4fe0e1-357c-9e8d-67f7-f065ccbe3851@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/6/2022 11:03 PM, Liang, Kan wrote:
> On 5/5/2022 11:32 PM, Yang Weijiang wrote:
>
>    bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
> @@ -199,12 +203,20 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
>    		return ret;
>    	}
>    
> -	ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS) ||
> -		(index >= records->from && index < records->from + records->nr) ||
> -		(index >= records->to && index < records->to + records->nr);
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
> +		ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS);
> +
> Shouldn't we return immediately if (ret == true)?
> Keep checking if (!ret) looks uncommon.
>
> Actually we probably don't need the ret in this function.
>
> 	if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) &&
> 	    ((index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS)))
> 		return true;
>
>> +	if (!ret) {
>> +		ret = (index >= records->from &&
>> +		       index < records->from + records->nr) ||
>> +		      (index >= records->to &&
>> +		       index < records->to + records->nr);
>> +	}
> 	if ((index >= records->from &&
> 	    index < records->from + records->nr) ||
> 	    (index >= records->to &&
> 	    index < records->to + records->nr))
> 		return true;
>
>>    
>> -	if (!ret && records->info)
>> -		ret = (index >= records->info && index < records->info + records->nr);
>> +	if (!ret && records->info) {
>> +		ret = (index >= records->info &&
>> +		       index < records->info + records->nr);
>> +	}
> 	if (records->info &&
> 	    (index >= records->info && index < records->info + records->nr)
> 		return true;
>
> 	return false;
> Sorry, I didn't notice it in the previous review.

Thanks Kan, so I'll modify this function as below (keeping other part 
unchanged):

From 642d5e05e8a8578e75531632d714cec5976ab9ac Mon Sep 17 00:00:00 2001
From: Yang Weijiang <weijiang.yang@intel.com>
Date: Thu, 8 Jul 2021 23:51:02 +0800
Subject: [PATCH] KVM: x86/pmu: Refactor code to support guest Arch LBR

Take account of Arch LBR when do sanity checks before program
vPMU for guest. Pass through Arch LBR recording MSRs to guest
to gain better performance. Note, Arch LBR and Legacy LBR support
are mutually exclusive, i.e., they're not both available on one
platform.

Co-developed-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
  arch/x86/kvm/vmx/pmu_intel.c | 47 +++++++++++++++++++++++++-----------
  arch/x86/kvm/vmx/vmx.c       |  3 +++
  2 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index aa36d2072b91..306ce7ac9934 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -170,12 +170,16 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct 
kvm_pmu *pmu, u32 msr)

  bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
  {
+       if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+               return guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
+
         /*
          * As a first step, a guest could only enable LBR feature if its
          * cpu model is the same as the host because the LBR registers
          * would be pass-through to the guest and they're model specific.
          */
-       return boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
+       return !boot_cpu_has(X86_FEATURE_ARCH_LBR) &&
+               boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
  }

  bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
@@ -188,25 +192,28 @@ bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
  static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
  {
         struct x86_pmu_lbr *records = vcpu_to_lbr_records(vcpu);
-       bool ret = false;

         if (!intel_pmu_lbr_is_enabled(vcpu))
-               return ret;
+               return false;

         if (index == MSR_ARCH_LBR_DEPTH || index == MSR_ARCH_LBR_CTL) {
-               if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
-                       ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
-               return ret;
+               return kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
+                      guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
         }

-       ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS) ||
-               (index >= records->from && index < records->from + 
records->nr) ||
-               (index >= records->to && index < records->to + records->nr);
+       if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) &&
+           (index == MSR_LBR_SELECT || index == MSR_LBR_TOS))
+               return true;

-       if (!ret && records->info)
-               ret = (index >= records->info && index < records->info + 
records->nr);
+       if ((index >= records->from && index < records->from + 
records->nr) ||
+           (index >= records->to && index < records->to + records->nr))
+               return true;

-       return ret;
+       if (records->info && index >= records->info &&
+           index < records->info + records->nr)
+               return true;
+
+       return false;
  }

  static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
@@ -742,6 +749,9 @@ static void vmx_update_intercept_for_lbr_msrs(struct 
kvm_vcpu *vcpu, bool set)
                         vmx_set_intercept_for_msr(vcpu, lbr->info + i, 
MSR_TYPE_RW, set);
         }

+       if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+               return;
+
         vmx_set_intercept_for_msr(vcpu, MSR_LBR_SELECT, MSR_TYPE_RW, set);
         vmx_set_intercept_for_msr(vcpu, MSR_LBR_TOS, MSR_TYPE_RW, set);
  }
@@ -782,10 +792,13 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
  {
         struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
         struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+       bool lbr_enable = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) ?
+               (vmcs_read64(GUEST_IA32_LBR_CTL) & ARCH_LBR_CTL_LBREN) :
+               (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);

         if (!lbr_desc->event) {
                 vmx_disable_lbr_msrs_passthrough(vcpu);
-               if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
+               if (lbr_enable)
                         goto warn;
                 if (test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use))
                         goto warn;
@@ -802,13 +815,19 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
         return;

  warn:
+       if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+               wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
         pr_warn_ratelimited("kvm: vcpu-%d: fail to passthrough LBR.\n",
                 vcpu->vcpu_id);
  }

  static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
  {
-       if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
+       bool lbr_enable = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) ?
+               (vmcs_read64(GUEST_IA32_LBR_CTL) & ARCH_LBR_CTL_LBREN) :
+               (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);
+
+       if (!lbr_enable)
                 intel_pmu_release_guest_lbr_event(vcpu);
  }

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b6bc7d97e4b4..98e56a909c01 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -573,6 +573,9 @@ static bool is_valid_passthrough_msr(u32 msr)
         case MSR_LBR_NHM_TO ... MSR_LBR_NHM_TO + 31:
         case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
         case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
+       case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
+       case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
+       case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
                 /* LBR MSRs. These are handled in 
vmx_update_intercept_for_lbr_msrs() */
                 return true;
         }
--
2.27.0

> Thanks,
> Kan
>
