Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A60529D0C
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 10:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244207AbiEQI5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 04:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243868AbiEQI5B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 04:57:01 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F24B04;
        Tue, 17 May 2022 01:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652777820; x=1684313820;
  h=message-id:date:mime-version:subject:from:to:references:
   cc:in-reply-to:content-transfer-encoding;
  bh=Epa/HjVJt8okWhnmRizBqofCDQRjqWnebAitXUqQmog=;
  b=iTqRwwTnsyhhuxpdrcHkhn5AiMhcwFNZ+lioEqUawiFonRo2g30aqujW
   x1Lrg7uTciWGhqadfXtOlzpMcucUe1Yhj8OjRm9n/l8ZNQlr0nscLx1YY
   YrbpUWFE1mFQak1OCu8novtXHtxz8E2fSyFgaZgtr2BlFzsTiE8UmlO0H
   VNu+1GG0lCINhpbYaTjWfRyq592QcegiWtRbcnfIE8NsS98AuVRmJCp7g
   fKC2l3ctwYSor+8kf66/qdQWa2XeYrJLWhKkLkn4LjULckn6vrESEjgPS
   O9B9DYFbUZhkswL8e/HwGMATL9HDGuBWBwxZjzw6dvOSWOc3QLPQADs4m
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="296392260"
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="296392260"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 01:56:46 -0700
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="597024044"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.255.31.115]) ([10.255.31.115])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 01:56:43 -0700
Message-ID: <d68f61ab-d122-809b-913e-4eaf89b337c4@intel.com>
Date:   Tue, 17 May 2022 16:56:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v11 14/16] KVM: x86/vmx: Flip Arch LBREn bit on guest
 state change
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
References: <20220506033305.5135-1-weijiang.yang@intel.com>
 <20220506033305.5135-15-weijiang.yang@intel.com>
 <9f19a5eb-3eb0-58a2-e4ee-612f3298ba82@redhat.com>
 <9e2b5e9f-25a2-b724-c6d7-282dc987aa99@intel.com>
 <8a15c4b4-cabe-7bc3-bd98-bd669d586616@redhat.com>
 <5f264701-b6d5-8660-55ae-a5039d6a9d3a@intel.com>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <5f264701-b6d5-8660-55ae-a5039d6a9d3a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/13/2022 12:02 PM, Yang, Weijiang wrote:
>
> On 5/12/2022 9:18 PM, Paolo Bonzini wrote:
>> On 5/11/22 09:43, Yang, Weijiang wrote:
>>>> Instead of using flip_arch_lbr_ctl, SMM should save the value of 
>>>> the MSR
>>>> in kvm_x86_ops->enter_smm, and restore it in kvm_x86_ops->leave_smm
>>>> (feel free to do it only if guest_cpuid_has(vcpu, X86_FEATURE_LM), 
>>>> i.e.
>>>> the 32-bit case can be ignored).
>>> In the case of migration in SMM, I assume kvm_x86_ops->enter_smm()
>>> called in source side
>>>
>>> and kvm_x86_ops->leave_smm() is called at destination, then should the
>>> saved LBREn be transferred
>>>
>>> to destination too? The destination can rely on the bit to defer 
>>> setting
>>> LBREn bit in
>> Hi, it's transferred automatically if the MSR is saved in the SMM save
>> state area.  Both enter_smm and leave_smm can access the save state 
>> area.
>>
>> The enter_smm callback is called after saving "normal" state, and it has
>> to save the state + clear the bit; likewise, the leave_smm callback is
>> called before saving "normal" state and will restore the old value of
>> the MSR.
>
> Hi, I  modified this patch to consolidate your suggestion above, see 
> below patch.
>
> I added more things to ease migration handling in SMM because: 1) qemu 
> checks
>
> LBREn before transfer Arch LBR MSRs. 2)Perf event is created when 
> LBREn is being
>
> set.  Two things are not certain: 1) IA32_LBR_CTL doesn't have 
> corresponding slot in
>
> SMRAM,not sure if we need to rely on it to transfer the MSR. 2) I 
> chose 0x7f10 as
>
> the offset(CET takes 0x7f08) for storage, need you double check if 
> it's free or used.
>
> Thanks a lot!

Hi, Paolo,

I found there're some rebase conflicts between this series and your kvm 
queue branch

due to PEBS patches, I can re-post a new version based on your queue 
branch if necessary.

Waiting for your comments on this patch...

>
> ====================================================================
>
> From ceba1527fd87cdc789b38fce454058fca6582b0a Mon Sep 17 00:00:00 2001
> From: Yang Weijiang <weijiang.yang@intel.com>
> Date: Thu, 5 Aug 2021 20:48:39 +0800
> Subject: [PATCH] KVM: x86/vmx: Flip Arch LBREn bit on guest state change
>
> Per spec:"IA32_LBR_CTL.LBREn is saved and cleared on #SMI, and restored
> on RSM. On a warm reset, all LBR MSRs, including IA32_LBR_DEPTH, have 
> their
> values preserved. However, IA32_LBR_CTL.LBREn is cleared to 0, disabling
> LBRs." Given migration in SMM, use a reserved bit(63) of the MSR to 
> mirror
> LBREn bit, it facilitates Arch LBR specific handling during live 
> migration
> because user space will check LBREn to decide whether it's necessary to
> migrate the Arch LBR related MSRs. When the mirrored bit and LBREn bit 
> are
> both set, it means Arch LBR was active in SMM, so only create perf event
> and defer the LBREn bit restoring to leave_smm callback.
> Also clear LBREn at warm reset.
>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 16 +++++++++++++---
>  arch/x86/kvm/vmx/vmx.c       | 29 +++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.h       |  1 +
>  3 files changed, 43 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 038fdb788ccd..652601ad99ea 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -373,6 +373,8 @@ static bool arch_lbr_depth_is_valid(struct 
> kvm_vcpu *vcpu, u64 depth)
>      return (depth == pmu->kvm_arch_lbr_depth);
>  }
>
> +#define ARCH_LBR_IN_SMM    BIT(63)
> +
>  static bool arch_lbr_ctl_is_valid(struct kvm_vcpu *vcpu, u64 ctl)
>  {
>      struct kvm_cpuid_entry2 *entry;
> @@ -380,7 +382,7 @@ static bool arch_lbr_ctl_is_valid(struct kvm_vcpu 
> *vcpu, u64 ctl)
>      if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
>          return false;
>
> -    if (ctl & ~KVM_ARCH_LBR_CTL_MASK)
> +    if (ctl & ~(KVM_ARCH_LBR_CTL_MASK | ARCH_LBR_IN_SMM))
>          goto warn;
>
>      entry = kvm_find_cpuid_entry(vcpu, 0x1c, 0);
> @@ -425,6 +427,10 @@ static int intel_pmu_get_msr(struct kvm_vcpu 
> *vcpu, struct msr_data *msr_info)
>          return 0;
>      case MSR_ARCH_LBR_CTL:
>          msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
> +        if (to_vmx(vcpu)->lbr_in_smm) {
> +            msr_info->data |= ARCH_LBR_CTL_LBREN;
> +            msr_info->data |= ARCH_LBR_IN_SMM;
> +        }
>          return 0;
>      default:
>          if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
> @@ -501,11 +507,15 @@ static int intel_pmu_set_msr(struct kvm_vcpu 
> *vcpu, struct msr_data *msr_info)
>          if (!arch_lbr_ctl_is_valid(vcpu, data))
>              break;
>
> -        vmcs_write64(GUEST_IA32_LBR_CTL, data);
> -
>          if (intel_pmu_lbr_is_enabled(vcpu) && !lbr_desc->event &&
>              (data & ARCH_LBR_CTL_LBREN))
>              intel_pmu_create_guest_lbr_event(vcpu);
> +
> +        if (data & ARCH_LBR_IN_SMM) {
> +            data &= ~ARCH_LBR_CTL_LBREN;
> +            data &= ~ARCH_LBR_IN_SMM;
> +        }
> +        vmcs_write64(GUEST_IA32_LBR_CTL, data);
>          return 0;
>      default:
>          if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6d6ee9cf82f5..f754b9400151 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4543,6 +4543,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu 
> *vcpu, bool init_event)
>
>      vmx->rmode.vm86_active = 0;
>      vmx->spec_ctrl = 0;
> +    vmx->lbr_in_smm = false;
>
>      vmx->msr_ia32_umwait_control = 0;
>
> @@ -4593,6 +4594,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu 
> *vcpu, bool init_event)
>      if (!init_event) {
>          if (static_cpu_has(X86_FEATURE_ARCH_LBR))
>              vmcs_write64(GUEST_IA32_LBR_CTL, 0);
> +    } else {
> +        flip_arch_lbr_ctl(vcpu, false);
>      }
>  }
>
> @@ -7695,6 +7698,8 @@ static int vmx_smi_allowed(struct kvm_vcpu 
> *vcpu, bool for_injection)
>
>  static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
>  {
> +    struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
> +    struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>      struct vcpu_vmx *vmx = to_vmx(vcpu);
>
>      vmx->nested.smm.guest_mode = is_guest_mode(vcpu);
> @@ -7704,12 +7709,26 @@ static int vmx_enter_smm(struct kvm_vcpu 
> *vcpu, char *smstate)
>      vmx->nested.smm.vmxon = vmx->nested.vmxon;
>      vmx->nested.vmxon = false;
>      vmx_clear_hlt(vcpu);
> +
> +    if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
> +        test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use) &&
> +        lbr_desc->event && guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
> +        u64 ctl = vmcs_read64(GUEST_IA32_LBR_CTL);
> +
> +        put_smstate(u64, smstate, 0x7f10, ctl);
> +        vmcs_write64(GUEST_IA32_LBR_CTL, ctl & ~ARCH_LBR_CTL_LBREN);
> +        vmx->lbr_in_smm = true;
> +    }
> +
>      return 0;
>  }
>
>  static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>  {
> +    struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
> +    struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>      struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
>      int ret;
>
>      if (vmx->nested.smm.vmxon) {
> @@ -7725,6 +7744,16 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, 
> const char *smstate)
>          vmx->nested.nested_run_pending = 1;
>          vmx->nested.smm.guest_mode = false;
>      }
> +
> +    if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
> +        test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use) &&
> +        lbr_desc->event && guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
> +        u64 ctl = GET_SMSTATE(u64, smstate, 0x7f10);
> +
> +        vmcs_write64(GUEST_IA32_LBR_CTL, ctl | ARCH_LBR_CTL_LBREN);
> +        vmx->lbr_in_smm = false;
> +    }
> +
>      return 0;
>  }
>
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index b98c7e96697a..a227fe8bf288 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -351,6 +351,7 @@ struct vcpu_vmx {
>
>      struct pt_desc pt_desc;
>      struct lbr_desc lbr_desc;
> +    bool lbr_in_smm;
>
>      /* Save desired MSR intercept (read: pass-through) state */
>  #define MAX_POSSIBLE_PASSTHROUGH_MSRS    15
