Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4CE4ED3BD
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 08:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbiCaGKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 02:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiCaGKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 02:10:40 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECE137BDC;
        Wed, 30 Mar 2022 23:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648706933; x=1680242933;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/ge1MLpUpTSzccOgc9ys/TIcqiCk7bYjVPKcxqO0AKU=;
  b=kjIs7w8MhB7PZ02MQOwvVU05S0eyq1l24efcU89rkIcLXTAroh24S488
   o5lJxWxQasFRvbgnl9yB4aBctNnOEMjP8pg9JSqa8u/E1mQ9oJLcKANmb
   ReeAdT3mkAc+5vrDtb/79/cBWuRbi79zPq9GhsQ6Uax0BblBKl8Nherm6
   MIzbtLN/54lG+oweyWQbtQf/ieU+ZhlQ9gjmO2WuJ7WWctLGC7bC4+ALi
   qpUHAOZ2s2xDa3ACcOt9ujExmXE1rUTbc2Z3eJuI3fobZK5GP6rOFGcRA
   8v4CEaUgarL7dl0b1Y7emN5mjnFTarswNeNNGeew8Viwe8olybpQn8hOb
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="239657254"
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="239657254"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 23:08:52 -0700
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="566176320"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.249.172.223]) ([10.249.172.223])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 23:08:48 -0700
Message-ID: <086558b3-2dc4-9126-8d3f-7c2cfec917cb@intel.com>
Date:   Thu, 31 Mar 2022 14:08:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v6 7/7] KVM: VMX: Enable PKS for nested VM
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220221080840.7369-1-chenyi.qiang@intel.com>
 <20220221080840.7369-8-chenyi.qiang@intel.com> <YkTP7uztERLwynAN@google.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <YkTP7uztERLwynAN@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/31/2022 5:47 AM, Sean Christopherson wrote:
> On Mon, Feb 21, 2022, Chenyi Qiang wrote:
>> PKS MSR passes through guest directly. Configure the MSR to match the
>> L0/L1 settings so that nested VM runs PKS properly.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 38 ++++++++++++++++++++++++++++++++++++--
>>   arch/x86/kvm/vmx/vmcs12.c |  2 ++
>>   arch/x86/kvm/vmx/vmcs12.h |  4 ++++
>>   arch/x86/kvm/vmx/vmx.c    |  1 +
>>   arch/x86/kvm/vmx/vmx.h    |  2 ++
>>   5 files changed, 45 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index f235f77cbc03..c42a1df385ef 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -252,6 +252,10 @@ static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
>>   	dest->ds_sel = src->ds_sel;
>>   	dest->es_sel = src->es_sel;
>>   #endif
>> +	if (unlikely(src->pkrs != dest->pkrs)) {
>> +		vmcs_write64(HOST_IA32_PKRS, src->pkrs);
>> +		dest->pkrs = src->pkrs;
>> +	}
> 
> It's worth adding a helper for this, a la vmx_set_host_fs_gs(), though this one
> can probably be an inline in vmx.h.  E.g. to yield
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bfa37c7665a5..906a2913a886 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -252,10 +252,7 @@ static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
>          dest->ds_sel = src->ds_sel;
>          dest->es_sel = src->es_sel;
>   #endif
> -       if (unlikely(src->pkrs != dest->pkrs)) {
> -               vmcs_write64(HOST_IA32_PKRS, src->pkrs);
> -               dest->pkrs = src->pkrs;
> -       }
> +       vmx_set_host_pkrs(dest, src->pkrs);
>   }
> 
>   static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 35fee600fae7..b6b5f1a46544 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1157,10 +1157,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>           */
>          if (vm_exit_controls_get(vmx) & VM_EXIT_LOAD_IA32_PKRS) {
>                  host_pkrs = get_current_pkrs();
> -               if (unlikely(host_pkrs != host_state->pkrs)) {
> -                       vmcs_write64(HOST_IA32_PKRS, host_pkrs);
> -                       host_state->pkrs = host_pkrs;
> -               }
> +               vmx_set_host_pkrs(host_state, host_pkrs);
>          }
> 
>   #ifdef CONFIG_X86_64
> 
> 

Will do.

>>   }
>>   
>>   static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
>> @@ -685,6 +689,9 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>>   	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>>   					 MSR_IA32_PRED_CMD, MSR_TYPE_W);
>>   
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_PKRS, MSR_TYPE_RW);
>> +
>>   	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
>>   
>>   	vmx->nested.force_msr_bitmap_recalc = false;
>> @@ -2433,6 +2440,10 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>>   		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
>>   		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>>   			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
>> +
>> +		if (vmx->nested.nested_run_pending &&
>> +		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS))
>> +			vmcs_write64(GUEST_IA32_PKRS, vmcs12->guest_ia32_pkrs);
>>   	}
>>   
>>   	if (nested_cpu_has_xsaves(vmcs12))
>> @@ -2521,6 +2532,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>>   	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
>>   	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
>>   		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
>> +	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
>> +	    (!vmx->nested.nested_run_pending ||
>> +	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS)))
>> +		vmcs_write64(GUEST_IA32_PKRS, vmx->nested.vmcs01_guest_pkrs);
>> +
>>   	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
>>   
>>   	/* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the
>> @@ -2897,6 +2913,10 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>>   					   vmcs12->host_ia32_perf_global_ctrl)))
>>   		return -EINVAL;
>>   
>> +	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PKRS) &&
>> +		CC(!kvm_pkrs_valid(vmcs12->host_ia32_pkrs)))
> 
> Please align the indentation:
> 
> 	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PKRS) &&
> 	    CC(!kvm_pkrs_valid(vmcs12->host_ia32_pkrs)))
> 		return -EINVAL;
> 

Fixed.

>> +		return -EINVAL;
>> +
>>   #ifdef CONFIG_X86_64
>>   	ia32e = !!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE);
>>   #else
>> @@ -3049,6 +3069,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>>   	if (nested_check_guest_non_reg_state(vmcs12))
>>   		return -EINVAL;
>>   
>> +	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS) &&
>> +	    CC(!kvm_pkrs_valid(vmcs12->guest_ia32_pkrs)))
>> +		return -EINVAL;
>> +
>>   	return 0;
>>   }
>>   
>> @@ -3377,6 +3401,9 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>>   	if (kvm_mpx_supported() &&
>>   		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>>   		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
>> +	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
>> +	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS))
> 
> This needs read the current PKRS if from_vmentry == false, e.g.
> 
> 	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
> 	    (!from_vmentry ||
> 	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS)))
> 
> because in the migration case, if nested state is set after MSR state, the value
> needs to come from the current MSR value, which was propagated to vmc02 (which
> this calls vmcs01, but whatever).
> 
> Note, I'm pretty sure the GUEST_BNDCFGS code is broken, surprise surprise.
> 

Yes, I miss the migration case and know your point here. Will fix it and 
also the GUEST_BNDCFGS code in a separate patch.

>> +		vmx->nested.vmcs01_guest_pkrs = vmcs_read64(GUEST_IA32_PKRS);
>>   
>>   	/*
>>   	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
>> @@ -4022,6 +4049,7 @@ static bool is_vmcs12_ext_field(unsigned long field)
>>   	case GUEST_IDTR_BASE:
>>   	case GUEST_PENDING_DBG_EXCEPTIONS:
>>   	case GUEST_BNDCFGS:
>> +	case GUEST_IA32_PKRS:
>>   		return true;
>>   	default:
>>   		break;
>> @@ -4073,6 +4101,8 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
>>   		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
>>   	if (kvm_mpx_supported())
>>   		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
>> +	if (guest_cpuid_has(vcpu, X86_FEATURE_PKS))
> 
> This needs to check vmx->nested.msrs.entry_ctls_* (I can never remember if it's
> the high or low part...).  The SDM states PKRS is saved "if the processor supports
> the 1-setting of the 'load PKRS' VM-entry control", which is different than PKRS
> being supported in CPUID.  Also, guest CPUID is userspace controlled, e.g. userspace
> could induce a failed VMREAD by giving a garbage CPUID model, where vmx->nested.msrs
> can only be restricted by userspace, i.e. is trusted.
> 
> Happyily, checking vmx->nested.msrs is also a performance win, as guest_cpuid_has()
> can require walking a large array.

Make sense. Checking vmx->nested.msrs.entry_ctls_high is more accurate.

