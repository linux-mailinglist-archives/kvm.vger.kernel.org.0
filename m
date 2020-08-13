Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C023E2433AC
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 07:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgHMFmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 01:42:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:38244 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgHMFmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 01:42:31 -0400
IronPort-SDR: 8rj2DNYUa5pX/AJsfTOcIuxKj9u7GLW4cjVLIAsl4lzYb41Qt6Crxw72qo0laXVX/qphOHS+ja
 j4rUKaOONuyA==
X-IronPort-AV: E=McAfee;i="6000,8403,9711"; a="172208396"
X-IronPort-AV: E=Sophos;i="5.76,307,1592895600"; 
   d="scan'208";a="172208396"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2020 22:42:28 -0700
IronPort-SDR: UAu1nWg8cg0oe32jLfPDU535WAJwe6w+2OZ6jYpW2ZjiEYt4U7q2a5sCruWPKMNx2/f/g/uImF
 lBlrpy/ymLKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,307,1592895600"; 
   d="scan'208";a="325304257"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.2.93]) ([10.238.2.93])
  by orsmga008.jf.intel.com with ESMTP; 12 Aug 2020 22:42:26 -0700
Subject: Re: [RFC 2/7] KVM: VMX: Expose IA32_PKRS MSR
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
 <20200807084841.7112-3-chenyi.qiang@intel.com>
 <CALMp9eQiyRxJ0jkvVi+fWMZcDQbvyCcuTwH1wrYV-u_E004Bhg@mail.gmail.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <34b083be-b9d5-fd85-b42d-af0549e3b002@intel.com>
Date:   Thu, 13 Aug 2020 13:42:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQiyRxJ0jkvVi+fWMZcDQbvyCcuTwH1wrYV-u_E004Bhg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/13/2020 5:21 AM, Jim Mattson wrote:
> On Fri, Aug 7, 2020 at 1:46 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>>
>> Protection Keys for Supervisor Pages (PKS) uses IA32_PKRS MSR (PKRS) at
>> index 0x6E1 to allow software to manage supervisor protection key
>> rights. For performance consideration, PKRS intercept will be disabled
>> so that the guest can access the PKRS without VM exits.
>> PKS introduces dedicated control fields in VMCS to switch PKRS, which
>> only does the retore part. In addition, every VM exit saves PKRS into
>> the guest-state area in VMCS, while VM enter won't save the host value
>> due to the expectation that the host won't change the MSR often. Update
>> the host's value in VMCS manually if the MSR has been changed by the
>> kernel since the last time the VMCS was run.
>> The function get_current_pkrs() in arch/x86/mm/pkeys.c exports the
>> per-cpu variable pkrs_cache to avoid frequent rdmsr of PKRS.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
> 
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 11e4df560018..df2c2e733549 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -289,6 +289,7 @@ static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
>>          dest->ds_sel = src->ds_sel;
>>          dest->es_sel = src->es_sel;
>>   #endif
>> +       dest->pkrs = src->pkrs;
> 
> Why isn't this (and other PKRS code) inside the #ifdef CONFIG_X86_64?
> PKRS isn't usable outside of long mode, is it?
> 

Yes, I'm also thinking about whether to put all pks code into 
CONFIG_X86_64. The kernel implementation also wrap its pks code inside 
CONFIG_ARCH_HAS_SUPERVISOR_PKEYS which has dependency with CONFIG_X86_64.
However, maybe this can help when host kernel disable PKS but the guest 
enable it. What do you think about this?


>>   }
>>
>>   static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
>> diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
>> index 7a3675fddec2..39ec3d0c844b 100644
>> --- a/arch/x86/kvm/vmx/vmcs.h
>> +++ b/arch/x86/kvm/vmx/vmcs.h
>> @@ -40,6 +40,7 @@ struct vmcs_host_state {
>>   #ifdef CONFIG_X86_64
>>          u16           ds_sel, es_sel;
>>   #endif
>> +       u32           pkrs;
> 
> One thing that does seem odd throughout is that PKRS is a 64-bit
> resource, but we store and pass around only 32-bits. Yes, the top 32
> bits are currently reserved, but the same can be said of, say, cr4, a
> few lines above this. Yet, we store and pass around cr4 as 64-bits.
> How do we decide?
> 

IMO, If the high part of PKRS is zero-reserved, it's OK to use u32. I 
define it as u32 just to follow the definition pkrs_cache in kernel code.

>>   };
>>
>>   struct vmcs_controls_shadow {
> 
>> @@ -1163,6 +1164,20 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>>           */
>>          host_state->ldt_sel = kvm_read_ldt();
>>
>> +       /*
>> +        * Update the host pkrs vmcs field before vcpu runs.
>> +        * The setting of VM_EXIT_LOAD_IA32_PKRS can ensure
>> +        * kvm_cpu_cap_has(X86_FEATURE_PKS) &&
>> +        * guest_cpuid_has(vcpu, X86_FEATURE_VMX).
>> +        */
>> +       if (vm_exit_controls_get(vmx) & VM_EXIT_LOAD_IA32_PKRS) {
>> +               host_pkrs = get_current_pkrs();
>> +               if (unlikely(host_pkrs != host_state->pkrs)) {
>> +                       vmcs_write64(HOST_IA32_PKRS, host_pkrs);
>> +                       host_state->pkrs = host_pkrs;
>> +               }
>> +       }
>> +
>>   #ifdef CONFIG_X86_64
>>          savesegment(ds, host_state->ds_sel);
>>          savesegment(es, host_state->es_sel);
>> @@ -1951,6 +1966,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>                  else
>>                          msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>>                  break;
>> +       case MSR_IA32_PKRS:
>> +               if (!kvm_cpu_cap_has(X86_FEATURE_PKS) ||
>> +                   (!msr_info->host_initiated &&
>> +                   !guest_cpuid_has(vcpu, X86_FEATURE_PKS)))
> 
> Could this be simplified if we required
> kvm_cpu_cap_has(X86_FEATURE_PKS) as a prerequisite for
> guest_cpuid_has(vcpu, X86_FEATURE_PKS)? If not, what is the expected
> behavior if guest_cpuid_has(vcpu, X86_FEATURE_PKS) is true and
> kvm_cpu_cap_has(X86_FEATURE_PKS)  is false?
> 

Yes, kvm_cpu_cap_has() is a prerequisite for guest_cpuid_has() as we 
have done the check in vmx_cpuid_update(). Here I add the 
kvm_cpu_cap_has() check to ensure the vmcs_read(GUEST_IA32_PKRS) can 
execute correctly in case of the userspace access.

>> +                       return 1;
>> +               msr_info->data = vmcs_read64(GUEST_IA32_PKRS);
>> +               break;
>>          case MSR_TSC_AUX:
>>                  if (!msr_info->host_initiated &&
>>                      !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> 
>> @@ -7230,6 +7267,26 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>>                  vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>>   }
>>
>> +static void vmx_update_pkrs_cfg(struct kvm_vcpu *vcpu)
>> +{
>> +       struct vcpu_vmx *vmx = to_vmx(vcpu);
>> +       unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
>> +       bool pks_supported = guest_cpuid_has(vcpu, X86_FEATURE_PKS);
>> +
>> +       /*
>> +        * set intercept for PKRS when the guest doesn't support pks
>> +        */
>> +       vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PKRS, MSR_TYPE_RW, !pks_supported);
>> +
>> +       if (pks_supported) {
>> +               vm_entry_controls_setbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
>> +               vm_exit_controls_setbit(vmx, VM_EXIT_LOAD_IA32_PKRS);
>> +       } else {
>> +               vm_entry_controls_clearbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
>> +               vm_exit_controls_clearbit(vmx, VM_EXIT_LOAD_IA32_PKRS);
>> +       }
>> +}
> 
> Not just your change, but it is unclear to me what the expected
> behavior is when CPUID bits are modified while the guest is running.
> For example, it seems that this code results in immediate behavioral
> changes for an L1 guest; however, if an L2 guest is active, then there
> are no behavioral changes until the next emulated VM-entry from L1 to
> L2. Is that right?
> 

I don't know if there is a way to deal with the CPUID modification in 
KVM while the guest is running. Some CPUID modification like 
X86_FEATURE_OSPKE happens when the guest sets CR4_PKE. But I'm not 
familiar with your case.

Paolo

What's your opinion?


> On a more general note, do you have any kvm-unit-tests that exercise
> the new code?
> 

Yes, I'll attach the kvm-unit-tests in next version.
