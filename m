Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E2F3CF130
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 03:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348807AbhGTAc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 20:32:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:17054 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356817AbhGTA1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 20:27:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10050"; a="208041870"
X-IronPort-AV: E=Sophos;i="5.84,253,1620716400"; 
   d="scan'208";a="208041870"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2021 18:07:42 -0700
X-IronPort-AV: E=Sophos;i="5.84,253,1620716400"; 
   d="scan'208";a="509573965"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.238.0.133]) ([10.238.0.133])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2021 18:07:37 -0700
Subject: Re: [PATCH 6/6] KVM: VMX: enable IPI virtualization
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
References: <20210716064808.14757-1-guang.zeng@intel.com>
 <20210716064808.14757-7-guang.zeng@intel.com>
 <8aed2541-082d-d115-09ac-e7fcc05f96dc@redhat.com>
 <89f240cb-cb3a-c362-7ded-ee500cc12dc3@intel.com>
 <0d6f7852-95b3-d628-955b-f44d88a86478@redhat.com>
 <949abcb7-5f24-2107-a089-5e6c1bee8cf2@intel.com>
 <223af27a-2412-40f6-f4a6-e0a662041855@redhat.com>
From:   Zeng Guang <guang.zeng@intel.com>
Message-ID: <f1bcb885-d083-c260-d156-41fdc5db515a@intel.com>
Date:   Tue, 20 Jul 2021 09:07:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <223af27a-2412-40f6-f4a6-e0a662041855@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/19/2021 9:58 PM, Paolo Bonzini wrote:
> On 19/07/21 14:38, Zeng Guang wrote:
>>> Understood, but in practice all uses of vmx->ipiv_active are
>>> guarded by kvm_vcpu_apicv_active so they are always reached with
>>> vmx->ipiv_active == enable_ipiv.
>>>
>>> The one above instead seems wrong and should just use enable_ipiv.
>> enable_ipiv associate with "IPI virtualization" setting in tertiary
>> exec controls and enable_apicv which depends on cpu_has_vmx_apicv().
>> kvm_vcpu_apicv_active still can be false even if enable_ipiv is true,
>> e.g. in case irqchip not emulated in kernel.
> Right, kvm_vcpu_apicv_active *is* set in init_vmcs.  But there's an
>       "if (kvm_vcpu_apicv_active(&vmx->vcpu))" above.  You can just stick
>
> 	if (enable_ipicv)
> 		install_pid(vmx);
Ok, got your point now. I will revise to remove vmx->ipiv_active. Thanks.
> inside there.  As to the other occurrences of vmx->ipiv_active, look here:
>
>> +	if (!kvm_vcpu_apicv_active(vcpu))
>> +		return;
>> +
>> +	if ((!kvm_arch_has_assigned_device(vcpu->kvm) ||
>> +		!irq_remapping_cap(IRQ_POSTING_CAP)) &&
>> +		!to_vmx(vcpu)->ipiv_active)
>>   		return;
>>   
> This one can be enable_ipiv because APICv must be active.
>
>> +	if (!kvm_vcpu_apicv_active(vcpu))
>> +		return 0;
>> +
>> +	/* Put vCPU into a list and set NV to wakeup vector if it is
>> +	 * one of the following cases:
>> +	 * 1. any assigned device is in use.
>> +	 * 2. IPI virtualization is enabled.
>> +	 */
>> +	if ((!kvm_arch_has_assigned_device(vcpu->kvm) ||
>> +		!irq_remapping_cap(IRQ_POSTING_CAP)) && !to_vmx(vcpu)->ipiv_active)
>>   		return 0;
> This one can be !enable_ipiv because APICv must be active.
>
>> @@ -3870,6 +3877,8 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu, u8 mode)
>>   		vmx_enable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_RW);
>>   		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
>>   		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
>> +		vmx_set_intercept_for_msr(vcpu, X2APIC_MSR(APIC_ICR),
>> +				MSR_TYPE_RW, !to_vmx(vcpu)->ipiv_active);
>>   	}
>>   }
> Is inside "if (mode & MSR_BITMAP_MODE_X2APIC_APICV)" so APICv must be
> activ; so it can be enable_ipiv as well.
>
> In conclusion, you do not need vmx->ipiv_active.
>
> Paolo
>
