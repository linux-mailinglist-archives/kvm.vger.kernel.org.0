Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E409C4508BF
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 16:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236620AbhKOPnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 10:43:12 -0500
Received: from mga06.intel.com ([134.134.136.31]:17960 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230101AbhKOPmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 10:42:39 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="294281954"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="294281954"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 07:39:32 -0800
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="505960929"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.29.112]) ([10.255.29.112])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 07:39:23 -0800
Message-ID: <3fecedbb-7867-ba32-1326-7252d47dbf43@intel.com>
Date:   Mon, 15 Nov 2021 23:39:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.0
Subject: Re: [PATCH 04/11] KVM: x86: Disable MCE related stuff for TDX
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, Kai Huang <kai.huang@intel.com>
References: <20211112153733.2767561-1-xiaoyao.li@intel.com>
 <20211112153733.2767561-5-xiaoyao.li@intel.com> <YY6d57pWU8iJg/i+@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <YY6d57pWU8iJg/i+@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/13/2021 1:01 AM, Sean Christopherson wrote:
> On Fri, Nov 12, 2021, Xiaoyao Li wrote:
>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>
>> MCE is not supported for TDX VM and KVM cannot inject #MC to TDX VM.
>>
>> Introduce kvm_guest_mce_disallowed() which actually reports the MCE
>> availability based on vm_type. And use it to guard all the MCE related
>> CAPs and IOCTLs.
>>
>> Note: KVM_X86_GET_MCE_CAP_SUPPORTED is KVM scope so that what it reports
>> may not match the behavior of specific VM (e.g., here for TDX VM). The
>> same for KVM_CAP_MCE when queried from /dev/kvm. To qeuery the precise
>> KVM_CAP_MCE of the VM, it should use VM's fd.
>>
>> [ Xiaoyao: Guard MCE related CAPs ]
>>
>> Co-developed-by: Kai Huang <kai.huang@linux.intel.com>
>> Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   arch/x86/kvm/x86.c | 10 ++++++++++
>>   arch/x86/kvm/x86.h |  5 +++++
>>   2 files changed, 15 insertions(+)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index b02088343d80..2b21c5169f32 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4150,6 +4150,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>   		break;
>>   	case KVM_CAP_MCE:
>>   		r = KVM_MAX_MCE_BANKS;
>> +		if (kvm)
>> +			r = kvm_guest_mce_disallowed(kvm) ? 0 : r;
> 
> 		r = KVM_MAX_MCE_BANKS;
> 		if (kvm && kvm_guest_mce_disallowed(kvm))
> 			r = 0;
> 
> or
> 
> 		r = (kvm && kvm_guest_mce_disallowed(kvm)) ? 0 : KVM_MAX_MCE_BANKS;

I will use this one in next submission.

>>   		break;
>>   	case KVM_CAP_XCRS:
>>   		r = boot_cpu_has(X86_FEATURE_XSAVE);
>> @@ -5155,6 +5157,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>   	case KVM_X86_SETUP_MCE: {
>>   		u64 mcg_cap;
>>   
>> +		r = EINVAL;
>> +		if (kvm_guest_mce_disallowed(vcpu->kvm))
>> +			goto out;
>> +
>>   		r = -EFAULT;
>>   		if (copy_from_user(&mcg_cap, argp, sizeof(mcg_cap)))
>>   			goto out;
>> @@ -5164,6 +5170,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>   	case KVM_X86_SET_MCE: {
>>   		struct kvm_x86_mce mce;
>>   
>> +		r = EINVAL;
>> +		if (kvm_guest_mce_disallowed(vcpu->kvm))
>> +			goto out;
>> +
>>   		r = -EFAULT;
>>   		if (copy_from_user(&mce, argp, sizeof(mce)))
>>   			goto out;
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index a2813892740d..69c60297bef2 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -441,6 +441,11 @@ static __always_inline bool kvm_irq_injection_disallowed(struct kvm_vcpu *vcpu)
>>   	return vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM;
>>   }
>>   
>> +static __always_inline bool kvm_guest_mce_disallowed(struct kvm *kvm)
> 
> The "guest" part is potentially confusing and incosistent with e.g.
> kvm_irq_injection_disallowed.  And given the current ridiculous spec, CR4.MCE=1
> is _required_, so saying "mce disallowed" is arguably wrong from that perspective.
> 
> kvm_mce_injection_disallowed() would be more appropriate.

Good advice, I'll rename to it.

>> +{
>> +	return kvm->arch.vm_type == KVM_X86_TDX_VM;
>> +}
>> +
>>   void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
>>   void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
>>   int kvm_spec_ctrl_test_value(u64 value);
>> -- 
>> 2.27.0
>>

