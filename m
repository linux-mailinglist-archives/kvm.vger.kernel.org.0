Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F0844A679
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 06:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240780AbhKIF5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 00:57:23 -0500
Received: from mga07.intel.com ([134.134.136.100]:42959 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240634AbhKIF5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 00:57:22 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10162"; a="295822729"
X-IronPort-AV: E=Sophos;i="5.87,219,1631602800"; 
   d="scan'208";a="295822729"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 21:54:26 -0800
X-IronPort-AV: E=Sophos;i="5.87,219,1631602800"; 
   d="scan'208";a="451756053"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.2.71]) ([10.238.2.71])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 21:54:23 -0800
Message-ID: <85414ca6-e135-2371-cbce-0f595a7b7a26@intel.com>
Date:   Tue, 9 Nov 2021 13:54:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.0
Subject: Re: [PATCH v5 3/7] KVM: X86: Expose IA32_PKRS MSR
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210811101126.8973-1-chenyi.qiang@intel.com>
 <20210811101126.8973-4-chenyi.qiang@intel.com> <YYliC1kdT9ssX/f7@google.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <YYliC1kdT9ssX/f7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/9/2021 1:44 AM, Sean Christopherson wrote:
> On Wed, Aug 11, 2021, Chenyi Qiang wrote:
>> +	u32           pkrs;
> 
> ...
> 
>> @@ -1115,6 +1117,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>>   #endif
>>   	unsigned long fs_base, gs_base;
>>   	u16 fs_sel, gs_sel;
>> +	u32 host_pkrs;
> 
> As mentioned in the previosu patch, I think it makes sense to track this as a u64
> so that the only place in KVM that deas with the u64<=>u32 conversion is the below
> 
> 	host_pkrs = get_current_pkrs();
> 
>>   	int i;
>>   
>>   	vmx->req_immediate_exit = false;
>> @@ -1150,6 +1153,20 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>>   	 */
>>   	host_state->ldt_sel = kvm_read_ldt();
>>   
>> +	/*
>> +	 * Update the host pkrs vmcs field before vcpu runs.
>> +	 * The setting of VM_EXIT_LOAD_IA32_PKRS can ensure
>> +	 * kvm_cpu_cap_has(X86_FEATURE_PKS) &&
>> +	 * guest_cpuid_has(vcpu, X86_FEATURE_PKS)
>> +	 */
>> +	if (vm_exit_controls_get(vmx) & VM_EXIT_LOAD_IA32_PKRS) {
>> +		host_pkrs = get_current_pkrs();
>> +		if (unlikely(host_pkrs != host_state->pkrs)) {
>> +			vmcs_write64(HOST_IA32_PKRS, host_pkrs);
>> +			host_state->pkrs = host_pkrs;
>> +		}
>> +	}
>> +
>>   #ifdef CONFIG_X86_64
>>   	savesegment(ds, host_state->ds_sel);
>>   	savesegment(es, host_state->es_sel);
>> @@ -1371,6 +1388,15 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>>   		vmx->emulation_required = emulation_required(vcpu);
>>   }
>>   
>> +static void vmx_set_pkrs(struct kvm_vcpu *vcpu, u64 pkrs)
>> +{
> 
> Hrm.  Ideally this would be open coded in vmx_set_msr().  Long term, the RESET/INIT
> paths should really treat MSR updates as "normal" host_initiated writes instead of
> having to manually handle every MSR.
> 
> That would be a bit gross to handle in vmx_vcpu_reset() since it would have to
> create a struct msr_data (because __kvm_set_msr() isn't exposed to vendor code),
> but since vcpu->arch.pkrs is relevant to the MMU I think it makes sense to
> initiate the write from common x86.
> 
> E.g. this way there's not out-of-band special code, vmx_vcpu_reset() is kept clean,
> and if/when SVM gains support for PKRS this particular path Just Works.  And it would
> be an easy conversion for my pipe dream plan of handling MSRs at RESET/INIT via a
> list of MSRs+values.
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ac83d873d65b..55881d13620f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11147,6 +11147,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>          kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
>          kvm_rip_write(vcpu, 0xfff0);
> 
> +       if (kvm_cpu_cap_has(X86_FEATURE_PKS))
> +               __kvm_set_msr(vcpu, MSR_IA32_PKRS, 0, true);
> +

Got it. In addition, is it necessary to add on-INIT check? like:

if (kvm_cpu_cap_has(X86_FEATURE_PKS) && !init_event)
	__kvm_set_msr(vcpu, MSR_IA32_PKRS, 0, true);

PKRS should be preserved on INIT, not cleared. The SDM doesn't make this 
clear either.

>          vcpu->arch.cr3 = 0;
>          kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> 
>> +	if (kvm_cpu_cap_has(X86_FEATURE_PKS)) {
>> +		vcpu->arch.pkrs = pkrs;
>> +		kvm_register_mark_available(vcpu, VCPU_EXREG_PKRS);
>> +		vmcs_write64(GUEST_IA32_PKRS, pkrs);
>> +	}
>> +}
