Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04ACF52460F
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 08:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350465AbiELGo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 02:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240920AbiELGoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 02:44:25 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6712F1EEE16;
        Wed, 11 May 2022 23:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652337864; x=1683873864;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=kKwgAreJSdfHAkuA2uaxBda68QBsFTbWvbSU3ueTaFY=;
  b=B8EzTfuqeKEzBCxVOr/RhpQleOEBsaEW46fTJ29qZBAnXYsPkK8JvI3s
   2cUCZVpsCWoHI3Vq0uGcOeRTiYV0Pep4C+88KOIPgX5+qnAAjgiId+K71
   f8ZIxU44JZcINWQIJwNU8wapMPc7jjzLY3sqxB3E80/dPaiGI53i0aXQF
   JwQ9DN6IeTQfqUscEmPZFMAghyCYrg0BfVavjO4bZ95FcrHZa4E/RCEEQ
   e8FDmZ0HLbJx8u4eFnhy/dsd6WXOQQz3NMU1VvrrMLuLshnWwr84fXGao
   JyahyX7deDRh2MnCpO8MCi+4Kj6adt9ggXnL7+/MCchANkaYAxmo8IvMj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="257457140"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="257457140"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 23:44:23 -0700
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="594523203"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.255.28.40]) ([10.255.28.40])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 23:44:20 -0700
Message-ID: <d2e55a12-02d8-8c7c-24de-f049c6e0e445@intel.com>
Date:   Thu, 12 May 2022 14:44:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v11 14/16] KVM: x86/vmx: Flip Arch LBREn bit on guest
 state change
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220506033305.5135-1-weijiang.yang@intel.com>
 <20220506033305.5135-15-weijiang.yang@intel.com>
 <9f19a5eb-3eb0-58a2-e4ee-612f3298ba82@redhat.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <9f19a5eb-3eb0-58a2-e4ee-612f3298ba82@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/10/2022 11:51 PM, Paolo Bonzini wrote:
> On 5/6/22 05:33, Yang Weijiang wrote:
>> Per spec:"IA32_LBR_CTL.LBREn is saved and cleared on #SMI, and restored
>> on RSM. On a warm reset, all LBR MSRs, including IA32_LBR_DEPTH, have their
>> values preserved. However, IA32_LBR_CTL.LBREn is cleared to 0, disabling
>> LBRs." So clear Arch LBREn bit on #SMI and restore it on RSM manully, also
>> clear the bit when guest does warm reset.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>    arch/x86/kvm/vmx/vmx.c | 4 ++++
>>    1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 6d6ee9cf82f5..b38f58868905 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -4593,6 +4593,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>    	if (!init_event) {
>>    		if (static_cpu_has(X86_FEATURE_ARCH_LBR))
>>    			vmcs_write64(GUEST_IA32_LBR_CTL, 0);
>> +	} else {
>> +		flip_arch_lbr_ctl(vcpu, false);
>>    	}
>>    }
>>    
>> @@ -7704,6 +7706,7 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
>>    	vmx->nested.smm.vmxon = vmx->nested.vmxon;
>>    	vmx->nested.vmxon = false;
>>    	vmx_clear_hlt(vcpu);
>> +	flip_arch_lbr_ctl(vcpu, false);
>>    	return 0;
>>    }
>>    
>> @@ -7725,6 +7728,7 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>>    		vmx->nested.nested_run_pending = 1;
>>    		vmx->nested.smm.guest_mode = false;
>>    	}
>> +	flip_arch_lbr_ctl(vcpu, true);
>>    	return 0;
>>    }
>>    
> This is incorrect, you hare not saving/restoring the actual value of
> LBREn (which is "lbr_desc->event != NULL").  Therefore, a migration
> while in SMM would lose the value of LBREn = true.
>
> Instead of using flip_arch_lbr_ctl, SMM should save the value of the MSR
> in kvm_x86_ops->enter_smm, and restore it in kvm_x86_ops->leave_smm
> (feel free to do it only if guest_cpuid_has(vcpu, X86_FEATURE_LM), i.e.
> the 32-bit case can be ignored).

Hi, Paolo,

I re-factored this patch as below to enclose your above suggestion, 
could you

kindly check? If it's OK then I'll refresh this series with v12, thanks!

======================================================================

 From dad3abc7fe96022dd3dcee8f958960bbd4f68b95 Mon Sep 17 00:00:00 2001
From: Yang Weijiang <weijiang.yang@intel.com>
Date: Thu, 5 Aug 2021 20:48:39 +0800
Subject: [PATCH] KVM: x86/vmx: Flip Arch LBREn bit on guest state change

Per spec:"IA32_LBR_CTL.LBREn is saved and cleared on #SMI, and restored
on RSM. On a warm reset, all LBR MSRs, including IA32_LBR_DEPTH, have their
values preserved. However, IA32_LBR_CTL.LBREn is cleared to 0, disabling
LBRs." Use a reserved bit(63) of the MSR to hide LBREn bit on #SMI and
restore it to LBREn on RSM manully, also clear the bit when guest does
warm reset.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
  arch/x86/kvm/vmx/pmu_intel.c | 16 +++++++++++++---
  arch/x86/kvm/vmx/vmx.c       | 24 ++++++++++++++++++++++++
  arch/x86/kvm/vmx/vmx.h       |  1 +
  3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 038fdb788ccd..652601ad99ea 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -373,6 +373,8 @@ static bool arch_lbr_depth_is_valid(struct kvm_vcpu 
*vcpu, u64 depth)
      return (depth == pmu->kvm_arch_lbr_depth);
  }

+#define ARCH_LBR_IN_SMM    BIT(63)
+
  static bool arch_lbr_ctl_is_valid(struct kvm_vcpu *vcpu, u64 ctl)
  {
      struct kvm_cpuid_entry2 *entry;
@@ -380,7 +382,7 @@ static bool arch_lbr_ctl_is_valid(struct kvm_vcpu 
*vcpu, u64 ctl)
      if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
          return false;

-    if (ctl & ~KVM_ARCH_LBR_CTL_MASK)
+    if (ctl & ~(KVM_ARCH_LBR_CTL_MASK | ARCH_LBR_IN_SMM))
          goto warn;

      entry = kvm_find_cpuid_entry(vcpu, 0x1c, 0);
@@ -425,6 +427,10 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, 
struct msr_data *msr_info)
          return 0;
      case MSR_ARCH_LBR_CTL:
          msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
+        if (to_vmx(vcpu)->lbr_in_smm) {
+            msr_info->data |= ARCH_LBR_CTL_LBREN;
+            msr_info->data |= ARCH_LBR_IN_SMM;
+        }
          return 0;
      default:
          if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
@@ -501,11 +507,15 @@ static int intel_pmu_set_msr(struct kvm_vcpu 
*vcpu, struct msr_data *msr_info)
          if (!arch_lbr_ctl_is_valid(vcpu, data))
              break;

-        vmcs_write64(GUEST_IA32_LBR_CTL, data);
-
          if (intel_pmu_lbr_is_enabled(vcpu) && !lbr_desc->event &&
              (data & ARCH_LBR_CTL_LBREN))
              intel_pmu_create_guest_lbr_event(vcpu);
+
+        if (data & ARCH_LBR_IN_SMM) {
+            data &= ~ARCH_LBR_CTL_LBREN;
+            data &= ~ARCH_LBR_IN_SMM;
+        }
+        vmcs_write64(GUEST_IA32_LBR_CTL, data);
          return 0;
      default:
          if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6d6ee9cf82f5..eadad24a68e6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4543,6 +4543,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, 
bool init_event)

      vmx->rmode.vm86_active = 0;
      vmx->spec_ctrl = 0;
+    vmx->lbr_in_smm = false;

      vmx->msr_ia32_umwait_control = 0;

@@ -4593,6 +4594,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, 
bool init_event)
      if (!init_event) {
          if (static_cpu_has(X86_FEATURE_ARCH_LBR))
              vmcs_write64(GUEST_IA32_LBR_CTL, 0);
+    } else {
+        flip_arch_lbr_ctl(vcpu, false);
      }
  }

@@ -7695,6 +7698,8 @@ static int vmx_smi_allowed(struct kvm_vcpu *vcpu, 
bool for_injection)

  static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
  {
+    struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+    struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
      struct vcpu_vmx *vmx = to_vmx(vcpu);

      vmx->nested.smm.guest_mode = is_guest_mode(vcpu);
@@ -7704,12 +7709,21 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, 
char *smstate)
      vmx->nested.smm.vmxon = vmx->nested.vmxon;
      vmx->nested.vmxon = false;
      vmx_clear_hlt(vcpu);
+
+    if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
+        test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use) &&
+        lbr_desc->event)
+        vmx->lbr_in_smm = true;
+
      return 0;
  }

  static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
  {
+    struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+    struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
      struct vcpu_vmx *vmx = to_vmx(vcpu);
+
      int ret;

      if (vmx->nested.smm.vmxon) {
@@ -7725,6 +7739,16 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, 
const char *smstate)
          vmx->nested.nested_run_pending = 1;
          vmx->nested.smm.guest_mode = false;
      }
+
+    if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
+        test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use) &&
+        lbr_desc->event && vmx->lbr_in_smm) {
+        u64 ctl = vmcs_read64(GUEST_IA32_LBR_CTL);
+
+        vmcs_write64(GUEST_IA32_LBR_CTL, ctl | ARCH_LBR_CTL_LBREN);
+        vmx->lbr_in_smm = false;
+    }
+
      return 0;
  }

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index b98c7e96697a..a227fe8bf288 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -351,6 +351,7 @@ struct vcpu_vmx {

      struct pt_desc pt_desc;
      struct lbr_desc lbr_desc;
+    bool lbr_in_smm;

      /* Save desired MSR intercept (read: pass-through) state */
  #define MAX_POSSIBLE_PASSTHROUGH_MSRS    15
-- 
2.27.0

>
> Paolo
