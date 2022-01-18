Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03B0491C2F
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 04:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344901AbiARDOI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 22:14:08 -0500
Received: from mga07.intel.com ([134.134.136.100]:37606 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242760AbiARDHJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 22:07:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642475229; x=1674011229;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6EDCrTWoJGrxyaF+nH0zOpujS9YGdyY2LOuNgo9Dpi8=;
  b=NsQv5ShzwWjqk9dVpNID1Vs0LdP4YE2A1z22BRl4z3onfoF5wB/yoBY9
   ezP1gUmWzMGccM9htxD6esQNKhIInr3ADUSmER+h4JGu5mFGj+4hKwTIo
   M3vi3aKlfEo0XyOdSzUcCD0p8fri36LbyiRJx0NJZJX1S2dYDdANN+2V+
   WgxsrFtUMZe8pGpOcpDckovMYy5V7cGNa9FHwSIo0bNXvFAfq4KYvUEsL
   AJlEdII5pd7Mx8jxwZnz5+jvijFXyVII4vmYiRVzQQpRgXmKe0oeK8hwb
   huKBo4Dgp3BL4sP+0DBKl/sW+YbHuj9e8J4u9xyem8BLpwtZajkgNlaqq
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="308066567"
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="308066567"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 19:07:08 -0800
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="531569632"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.238.0.96]) ([10.238.0.96])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 19:07:03 -0800
Message-ID: <a46ce4d0-adfc-b149-e3aa-8b2f39e76e28@intel.com>
Date:   Tue, 18 Jan 2022 11:06:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.4.1
Subject: Re: [PATCH v5 5/8] KVM: x86: Support interrupt dispatch in x2APIC
 mode with APIC-write VM exit
Content-Language: en-US
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-6-guang.zeng@intel.com> <YeCZpo+qCkvx5l5m@google.com>
 <ec578526-989d-0913-e40e-9e463fb85a8f@intel.com>
 <YeG0Fdn/2++phMWs@google.com>
 <8ab5f976-1f3e-e2a5-87f6-e6cf376ead2f@intel.com>
 <20220118004405.po36x3lxi26mkwsz@yy-desk-7060>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <20220118004405.po36x3lxi26mkwsz@yy-desk-7060>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/2022 8:44 AM, Yuan Yao wrote:
> On Sat, Jan 15, 2022 at 10:08:10AM +0800, Zeng Guang wrote:
>> On 1/15/2022 1:34 AM, Sean Christopherson wrote:
>>> On Fri, Jan 14, 2022, Zeng Guang wrote:
>>>> kvm_lapic_reg_read() is limited to read up to 4 bytes. It needs extension to
>>>> support 64bit read.
>>> Ah, right.
>>>
>>>> And another concern is here getting reg value only specific from vICR(no
>>>> other regs need take care), going through whole path on kvm_lapic_reg_read()
>>>> could be time-consuming unnecessarily. Is it proper that calling
>>>> kvm_lapic_get_reg64() to retrieve vICR value directly?
>>> Hmm, no, I don't think that's proper.  Retrieving a 64-bit value really is unique
>>> to vICR.  Yes, the code does WARN on that, but if future architectural extensions
>>> even generate APIC-write exits on other registers, then using kvm_lapic_get_reg64()
>>> would be wrong and this code would need to be updated again.
>> Split on x2apic and WARN on (offset != APIC_ICR) already limit register read
>> to vICR only. Actually
>> we just need consider to deal with 64bit data specific to vICR in APIC-write
>> exits. From this point of
>> view, previous design can be compatible on handling other registers even if
>> future architectural
>> extensions changes. :)
>>> What about tweaking my prep patch from before to the below?  That would yield:
>>>
>>> 	if (apic_x2apic_mode(apic)) {
>>> 		if (WARN_ON_ONCE(offset != APIC_ICR))
>>> 			return 1;
>>>
>>> 		kvm_lapic_msr_read(apic, offset, &val);
>> I think it's problematic to use kvm_lapic_msr_read() in this case. It
>> premises the high 32bit value
>> already valid at APIC_ICR2, while in handling "nodecode" x2APIC writes we
>> need get continuous 64bit
>> data from offset 300H first and prepare emulation of APIC_ICR2 write. At
>> this time, APIC_ICR2 is not
>> ready yet.
> How about combine them, then you can handle the ICR write vmexit for
> IPI virtualization and Sean's patch can still work with code reusing,
> like below:
>
> 	if (apic_x2apic_mode(apic)) {
> 		if (WARN_ON_ONCE(offset != APIC_ICR))
> 			kvm_lapic_msr_read(apic, offset, &val);
> 		else
> 			kvm_lapic_get_reg64(apic, offset, &val);
>
> 		kvm_lapic_msr_write(apic, offset, val);
> 	} else {
> 		kvm_lapic_reg_read(apic, offset, 4, &val);
> 		kvm_lapic_reg_write(apic, offset, val);
> 	}

Alternatively we can merge as this if Sean think it ok to call 
kvm_lapic_get_reg64() retrieving 64bit data from vICR directly.

>>> 		kvm_lapic_msr_write(apic, offset, val);
>>> 	} else {
>>> 		kvm_lapic_reg_read(apic, offset, 4, &val);
>>> 		kvm_lapic_reg_write(apic, offset, val);
>>> 	}
>>>
>>> I like that the above has "msr" in the low level x2apic helpers, and it maximizes
>>> code reuse.  Compile tested only...
>>>
>>> From: Sean Christopherson <seanjc@google.com>
>>> Date: Fri, 14 Jan 2022 09:29:34 -0800
>>> Subject: [PATCH] KVM: x86: Add helpers to handle 64-bit APIC MSR read/writes
>>>
>>> Add helpers to handle 64-bit APIC read/writes via MSRs to deduplicate the
>>> x2APIC and Hyper-V code needed to service reads/writes to ICR.  Future
>>> support for IPI virtualization will add yet another path where KVM must
>>> handle 64-bit APIC MSR reads/write (to ICR).
>>>
>>> Opportunistically fix the comment in the write path; ICR2 holds the
>>> destination (if there's no shorthand), not the vector.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    arch/x86/kvm/lapic.c | 59 ++++++++++++++++++++++----------------------
>>>    1 file changed, 29 insertions(+), 30 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>>> index f206fc35deff..cc4531eb448f 100644
>>> --- a/arch/x86/kvm/lapic.c
>>> +++ b/arch/x86/kvm/lapic.c
>>> @@ -2787,6 +2787,30 @@ int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
>>>    	return 0;
>>>    }
>>>
>>> +static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data)
>>> +{
>>> +	u32 low, high = 0;
>>> +
>>> +	if (kvm_lapic_reg_read(apic, reg, 4, &low))
>>> +		return 1;
>>> +
>>> +	if (reg == APIC_ICR &&
>>> +	    WARN_ON_ONCE(kvm_lapic_reg_read(apic, APIC_ICR2, 4, &high)))
>>> +		return 1;
>>> +
>>> +	*data = (((u64)high) << 32) | low;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data)
>>> +{
>>> +	/* For 64-bit ICR writes, set ICR2 (dest) before ICR (command). */
>>> +	if (reg == APIC_ICR)
>>> +		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
>>> +	return kvm_lapic_reg_write(apic, reg, (u32)data);
>>> +}
>>> +
>>>    int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>>>    {
>>>    	struct kvm_lapic *apic = vcpu->arch.apic;
>>> @@ -2798,16 +2822,13 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>>>    	if (reg == APIC_ICR2)
>>>    		return 1;
>>>
>>> -	/* if this is ICR write vector before command */
>>> -	if (reg == APIC_ICR)
>>> -		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
>>> -	return kvm_lapic_reg_write(apic, reg, (u32)data);
>>> +	return kvm_lapic_msr_write(apic, reg, data);
>>>    }
>>>
>>>    int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
>>>    {
>>>    	struct kvm_lapic *apic = vcpu->arch.apic;
>>> -	u32 reg = (msr - APIC_BASE_MSR) << 4, low, high = 0;
>>> +	u32 reg = (msr - APIC_BASE_MSR) << 4;
>>>
>>>    	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(apic))
>>>    		return 1;
>>> @@ -2815,45 +2836,23 @@ int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
>>>    	if (reg == APIC_DFR || reg == APIC_ICR2)
>>>    		return 1;
>>>
>>> -	if (kvm_lapic_reg_read(apic, reg, 4, &low))
>>> -		return 1;
>>> -	if (reg == APIC_ICR)
>>> -		kvm_lapic_reg_read(apic, APIC_ICR2, 4, &high);
>>> -
>>> -	*data = (((u64)high) << 32) | low;
>>> -
>>> -	return 0;
>>> +	return kvm_lapic_msr_read(apic, reg, data);
>>>    }
>>>
>>>    int kvm_hv_vapic_msr_write(struct kvm_vcpu *vcpu, u32 reg, u64 data)
>>>    {
>>> -	struct kvm_lapic *apic = vcpu->arch.apic;
>>> -
>>>    	if (!lapic_in_kernel(vcpu))
>>>    		return 1;
>>>
>>> -	/* if this is ICR write vector before command */
>>> -	if (reg == APIC_ICR)
>>> -		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
>>> -	return kvm_lapic_reg_write(apic, reg, (u32)data);
>>> +	return kvm_lapic_msr_write(vcpu->arch.apic, reg, data);
>>>    }
>>>
>>>    int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 reg, u64 *data)
>>>    {
>>> -	struct kvm_lapic *apic = vcpu->arch.apic;
>>> -	u32 low, high = 0;
>>> -
>>>    	if (!lapic_in_kernel(vcpu))
>>>    		return 1;
>>>
>>> -	if (kvm_lapic_reg_read(apic, reg, 4, &low))
>>> -		return 1;
>>> -	if (reg == APIC_ICR)
>>> -		kvm_lapic_reg_read(apic, APIC_ICR2, 4, &high);
>>> -
>>> -	*data = (((u64)high) << 32) | low;
>>> -
>>> -	return 0;
>>> +	return kvm_lapic_msr_read(vcpu->arch.apic, reg, data);
>>>    }
>>>
>>>    int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
>>> --
