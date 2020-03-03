Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5887C177303
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 10:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgCCJtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 04:49:12 -0500
Received: from goliath.siemens.de ([192.35.17.28]:55287 "EHLO
        goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbgCCJtM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 04:49:12 -0500
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by goliath.siemens.de (8.15.2/8.15.2) with ESMTPS id 0239mh4H025629
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Mar 2020 10:48:43 +0100
Received: from [167.87.29.4] ([167.87.29.4])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 0239mg1F019125;
        Tue, 3 Mar 2020 10:48:43 +0100
Subject: Re: [PATCH 3/6] KVM: x86: Add dedicated emulator helper for grabbing
 CPUID.maxphyaddr
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-4-sean.j.christopherson@intel.com>
 <de2ed4e9-409a-6cb1-e295-ea946be11e82@redhat.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <617748ab-0edd-2ccc-e86b-b86b0adf9d3b@siemens.com>
Date:   Tue, 3 Mar 2020 10:48:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <de2ed4e9-409a-6cb1-e295-ea946be11e82@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.03.20 09:48, Paolo Bonzini wrote:
> On 02/03/20 20:57, Sean Christopherson wrote:
>> Add a helper to retrieve cpuid_maxphyaddr() instead of manually
>> calculating the value in the emulator via raw CPUID output.  In addition
>> to consolidating logic, this also paves the way toward simplifying
>> kvm_cpuid(), whose somewhat confusing return value exists purely to
>> support the emulator's maxphyaddr calculation.
>>
>> No functional change intended.
> 
> I don't think this is a particularly useful change.  Yes, it's not
> intuitive but is it more than a matter of documentation (and possibly
> moving the check_cr_write snippet into a separate function)?

Besides the non obvious return value of the current function, this 
approach also avoids leaving cpuid traces for querying maxphyaddr, which 
is also not very intuitive IMHO.

Jan

> 
> Paolo
> 
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> ---
>>   arch/x86/include/asm/kvm_emulate.h |  1 +
>>   arch/x86/kvm/emulate.c             | 10 +---------
>>   arch/x86/kvm/x86.c                 |  6 ++++++
>>   3 files changed, 8 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
>> index bf5f5e476f65..ded06515d30f 100644
>> --- a/arch/x86/include/asm/kvm_emulate.h
>> +++ b/arch/x86/include/asm/kvm_emulate.h
>> @@ -222,6 +222,7 @@ struct x86_emulate_ops {
>>   
>>   	bool (*get_cpuid)(struct x86_emulate_ctxt *ctxt, u32 *eax, u32 *ebx,
>>   			  u32 *ecx, u32 *edx, bool check_limit);
>> +	int (*get_cpuid_maxphyaddr)(struct x86_emulate_ctxt *ctxt);
>>   	bool (*guest_has_long_mode)(struct x86_emulate_ctxt *ctxt);
>>   	bool (*guest_has_movbe)(struct x86_emulate_ctxt *ctxt);
>>   	bool (*guest_has_fxsr)(struct x86_emulate_ctxt *ctxt);
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index dd19fb3539e0..bf02ed51e90f 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -4244,16 +4244,8 @@ static int check_cr_write(struct x86_emulate_ctxt *ctxt)
>>   
>>   		ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
>>   		if (efer & EFER_LMA) {
>> -			u64 maxphyaddr;
>> -			u32 eax, ebx, ecx, edx;
>> +			int maxphyaddr = ctxt->ops->get_cpuid_maxphyaddr(ctxt);
>>   
>> -			eax = 0x80000008;
>> -			ecx = 0;
>> -			if (ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx,
>> -						 &edx, false))
>> -				maxphyaddr = eax & 0xff;
>> -			else
>> -				maxphyaddr = 36;
>>   			rsvd = rsvd_bits(maxphyaddr, 63);
>>   			if (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_PCIDE)
>>   				rsvd &= ~X86_CR3_PCID_NOFLUSH;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index ddd1d296bd20..5467ee71c25b 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -6209,6 +6209,11 @@ static bool emulator_get_cpuid(struct x86_emulate_ctxt *ctxt,
>>   	return kvm_cpuid(emul_to_vcpu(ctxt), eax, ebx, ecx, edx, check_limit);
>>   }
>>   
>> +static int emulator_get_cpuid_maxphyaddr(struct x86_emulate_ctxt *ctxt)
>> +{
>> +	return cpuid_maxphyaddr(emul_to_vcpu(ctxt));
>> +}
>> +
>>   static bool emulator_guest_has_long_mode(struct x86_emulate_ctxt *ctxt)
>>   {
>>   	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_LM);
>> @@ -6301,6 +6306,7 @@ static const struct x86_emulate_ops emulate_ops = {
>>   	.fix_hypercall       = emulator_fix_hypercall,
>>   	.intercept           = emulator_intercept,
>>   	.get_cpuid           = emulator_get_cpuid,
>> +	.get_cpuid_maxphyaddr= emulator_get_cpuid_maxphyaddr,
>>   	.guest_has_long_mode = emulator_guest_has_long_mode,
>>   	.guest_has_movbe     = emulator_guest_has_movbe,
>>   	.guest_has_fxsr      = emulator_guest_has_fxsr,
>>
> 

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
