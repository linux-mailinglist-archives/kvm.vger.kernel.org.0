Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6965924336B
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 06:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgHMEy3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 00:54:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:63538 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgHMEy3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 00:54:29 -0400
IronPort-SDR: ImVL/sZbYaeo8e+K5Gan+SNc3rBEUb0Pmp1dx1YGNNaLnp2gOE6LcZwgjhOWaccP58PKAQp/zg
 T6wCV+nxhDug==
X-IronPort-AV: E=McAfee;i="6000,8403,9711"; a="142001557"
X-IronPort-AV: E=Sophos;i="5.76,307,1592895600"; 
   d="scan'208";a="142001557"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2020 21:54:28 -0700
IronPort-SDR: mLOlVFMGG1+lMAWVCHxdsWhNcEll08QkHk3MO5+6k0H92Vp3SeZE22GlGR040akuQfCvqJSkkL
 nZxkCWHafZxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,307,1592895600"; 
   d="scan'208";a="325296166"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.2.93]) ([10.238.2.93])
  by orsmga008.jf.intel.com with ESMTP; 12 Aug 2020 21:54:26 -0700
Subject: Re: [RFC 7/7] KVM: VMX: Enable PKS for nested VM
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
 <20200807084841.7112-8-chenyi.qiang@intel.com>
 <CALMp9eTAo3WO5Vk_LptTDZLzymJ_96=UhRipyzTXXLxWJRGdXg@mail.gmail.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <1481a482-c20b-5531-736c-de0c5d3d611c@intel.com>
Date:   Thu, 13 Aug 2020 12:52:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eTAo3WO5Vk_LptTDZLzymJ_96=UhRipyzTXXLxWJRGdXg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/11/2020 8:05 AM, Jim Mattson wrote:
> On Fri, Aug 7, 2020 at 1:47 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>>
>> PKS MSR passes through guest directly. Configure the MSR to match the
>> L0/L1 settings so that nested VM runs PKS properly.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 32 ++++++++++++++++++++++++++++++++
>>   arch/x86/kvm/vmx/vmcs12.c |  2 ++
>>   arch/x86/kvm/vmx/vmcs12.h |  6 +++++-
>>   arch/x86/kvm/vmx/vmx.c    | 10 ++++++++++
>>   arch/x86/kvm/vmx/vmx.h    |  1 +
>>   5 files changed, 50 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index df2c2e733549..1f9823d21ecd 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -647,6 +647,12 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>>                                          MSR_IA32_PRED_CMD,
>>                                          MSR_TYPE_W);
>>
>> +       if (!msr_write_intercepted_l01(vcpu, MSR_IA32_PKRS))
>> +               nested_vmx_disable_intercept_for_msr(
>> +                                       msr_bitmap_l1, msr_bitmap_l0,
>> +                                       MSR_IA32_PKRS,
>> +                                       MSR_TYPE_R | MSR_TYPE_W);
> 
> What if L1 intercepts only *reads* of MSR_IA32_PKRS?
> 
>>          kvm_vcpu_unmap(vcpu, &to_vmx(vcpu)->nested.msr_bitmap_map, false);
>>
>>          return true;
> 
>> @@ -2509,6 +2519,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>>          if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
>>              !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
>>                  vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
>> +
>> +       if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
> 
> Is the above check superfluous? I would assume that the L1 guest can't
> set VM_ENTRY_LOAD_IA32_PKRS unless this is true.
> 

I enforce this check to ensure vmcs_write to the Guest_IA32_PKRS without 
error. if deleted, vmcs_write to GUEST_IA32_PKRS may executed when PKS 
is unsupported.

>> +           (!vmx->nested.nested_run_pending ||
>> +            !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS)))
>> +               vmcs_write64(GUEST_IA32_PKRS, vmx->nested.vmcs01_guest_pkrs);
> 
> This doesn't seem right to me. On the target of a live migration, with
> L2 active at the time the snapshot was taken (i.e.,
> vmx->nested.nested_run_pending=0), it looks like we're going to try to
> overwrite the current L2 PKRS value with L1's PKRS value (except that
> in this situation, vmx->nested.vmcs01_guest_pkrs should actually be
> 0). Am I missing something?
> 

We overwrite the L2 PKRS with L1's value when L2 doesn't support PKS. 
Because the L1's VM_ENTRY_LOAD_IA32_PKRS is off, we need to migrate L1's 
PKRS to L2.

>>          vmx_set_rflags(vcpu, vmcs12->guest_rflags);
>>
>>          /* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the
> 
> 
>> @@ -3916,6 +3943,8 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
>>                  vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
>>          if (kvm_mpx_supported())
>>                  vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
>> +       if (kvm_cpu_cap_has(X86_FEATURE_PKS))
> 
> Shouldn't we be checking to see if the *virtual* CPU supports PKS
> before writing anything into vmcs12->guest_ia32_pkrs?
> 

Yes, It's reasonable.

>> +               vmcs12->guest_ia32_pkrs = vmcs_read64(GUEST_IA32_PKRS);
>>
>>          vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
>>   }
