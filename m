Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1BD40FD76
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 18:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243112AbhIQQCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 12:02:11 -0400
Received: from mga06.intel.com ([134.134.136.31]:26283 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhIQQCL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 12:02:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="283831898"
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="283831898"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 09:00:29 -0700
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="546471724"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.254.208.219]) ([10.254.208.219])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 09:00:24 -0700
Subject: Re: [PATCH v4 5/6] KVM: x86: Support interrupt dispatch in x2APIC
 mode with APIC-write VM exit
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
References: <20210809032925.3548-1-guang.zeng@intel.com>
 <20210809032925.3548-6-guang.zeng@intel.com> <YTvcJZSd1KQvNmaz@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
Message-ID: <1d40cec2-d3ea-f5f8-d889-52026aea85de@intel.com>
Date:   Sat, 18 Sep 2021 00:00:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YTvcJZSd1KQvNmaz@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/11/2021 6:28 AM, Sean Christopherson wrote:
> On Mon, Aug 09, 2021, Zeng Guang wrote:
>> Since IA x86 platform introduce features of IPI virtualization and
>> User Interrupts, new behavior applies to the execution of WRMSR ICR
> What do User Interrupts have to do with anything?

User interrupt will also use APIC-Write VM exit to emulate the MSR write 
process on vICR register.
May be better here to give a general description rather than list 
detailed feature samples.  Actually
this new behavior start to be common implementation in Intel platform now.

>> register that causes APIC-write VM exit instead of MSR-write VM exit
>> in x2APIC mode.
> Please lead with what support is actually being added, and more directly state
> what the new behavior actually is, e.g. when should KVM expect these types of
> traps.  The shortlog helps a bit, but APIC-write is somewhat ambiguous without
> the context that it refers to the trap-like exits, not exception-like exits on
> the WRMSR itself.

IIUC, APIC-write is always trap-like exits. I would give more clear and 
accurate description here as you suggested.

> Peeking ahead, this probably should be squashed with the next patch that adds
> IPI virtualizatio support.  Without that patch's code that disables ICR MSR
> intercepts for IPIv, this patch makes zero sense.
>
> I'm not totally opposed to splitting IPIv support into two patches, I just don't
> like splitting out this tiny subset that makes zero sense without the IPIv
> code/context.  I assume you took this approach so that the shortlog could be
> "KVM: VMX:" for the IPIv code.  IMO it's perfectly ok to keep that shortlog even
> though there are minor changes outside of vmx/.  VMX is the only user of
> kvm_apic_write_nodecode(), so it's not wrong to say it affects only VMX.

IMO, this patch targets to solve the mishandling in APIC-write VM exit 
if it presents 64-bit value writing to vICR in x2APIC mode.
Since Intel hardware with some new features will support such function, 
KVM have to enhance its solution and also be backward-compatible with
previous platform. I think it could be an independent fix patch.

>> This requires KVM to emulate writing 64-bit value to offset 300H on
>> the virtual-APIC page(VICR) for guest running in x2APIC mode when
> Maybe stylize that as vICR to make it stand out as virtual ICR?
OK.
>> APIC-wrtie VM exit occurs. Prevoisely KVM doesn't consider this
>         ^^^^^                 ^^^^^^^^^^
>         write                 Previously
Thanks for correction.
>> situation as CPU never produce APIC-write VM exit in x2APIC mode before.
>>
>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>> ---
>>   arch/x86/kvm/lapic.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index ba5a27879f1d..0b0f0ce96679 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -2188,7 +2188,14 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>>   	/* hw has done the conditional check and inst decode */
>>   	offset &= 0xff0;
>>   
>> -	kvm_lapic_reg_read(vcpu->arch.apic, offset, 4, &val);
> Probably worth snapshotting vcpu->arch.apic.
>
>> +	if (apic_x2apic_mode(vcpu->arch.apic) && (offset == APIC_ICR)) {
>
> A comment here would be _extremely_ helpful.  IIUC, this path is reached when IPIv
> is enabled for all ICR writes that can't be virtualized, e.g. broadcast IPIs.
>
> And I'm tempted to say this should WARN and do nothing if KVM gets an exit on
> anything except ICR writes.
>
>> +		u64 icr_val = *((u64 *)(vcpu->arch.apic->regs + offset));
> Maybe just bump "val" to a u64?
>
> Rather than open code this, can't this be:
>
> 		kvm_lapic_reg_read(apic, offset, 8, &val);
>> +
>> +		kvm_lapic_reg_write(vcpu->arch.apic, APIC_ICR2, (u32)(icr_val>>32));
>> +		val = (u32)icr_val;
> Hmm, this is the third path that open codes the ICR2:ICR split.  I think it's
> probably worth adding a helper (patch below), and this can become:
>
> void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
> {
> 	struct kvm_lapic *apic = vcpu->arch.apic;
> 	u64 val = 0;
>
> 	/* hw has done the conditional check and inst decode */
> 	offset &= 0xff0;
>
> 	/* TODO: optimize to just emulate side effect w/o one more write */
> 	if (apic_x2apic_mode(apic)) {
> 		if (WARN_ON_ONCE(offset != APIC_ICR))
> 			return 1;
>
> 		kvm_lapic_reg_read(apic, offset, 8, &val);
> 		kvm_lapic_reg_write64(apic, offset, val);
> 	} else {
> 		kvm_lapic_reg_read(apic, offset, 4, &val);
> 		kvm_lapic_reg_write(apic, offset, val);
> 	}
> }
>
> There is some risk my idea will backfire if the CPU traps other WRMSRs, but even
> then the pedant in me thinks the code for that should be:
>
>
> 	if (apic_x2apic_mode(apic)) {
> 		int size = offset == APIC_ICR ? 8 : 4;
>
> 		kvm_lapic_reg_read(apic, offset, size, &val);
> 		kvm_lapic_reg_write64(apic, offset, val);
> 	} else {
> 		...
> 	}
>
> or worst case scenario, move the APIC_ICR check back so that the non-ICR path
> back to "if (apic_x2apic_mode(vcpu->arch.apic) && (offset == APIC_ICR))" so that
> it naturally falls into the 4-byte read+write.
Only vICR in x2APIC mode is an exception to process 64-bit data 
instead.  That could be expensive to use
kvm_lapic_reg_read which will do many check unnecessarily specific for 
vICR, especially in case there are
intensive interrupts arising. Besides, kvm_lapic_reg_write64() requires 
caller to ensure 64-bit data containing
right ICR2 and ICR value along with respective apic mode. Otherwise it 
will corrupt APIC_ICR2 setting.

Probably it's better to optimize code as below. How do you think?

void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
{
	struct kvm_lapic *apic = vcpu->arch.apic;
	u64 val = 0;

	/* hw has done the conditional check and inst decode */
	offset &= 0xff0;

	/* TODO: optimize to just emulate side effect w/o one more write */
	if ((offset == APIC_ICR) && apic_x2apic_mode(apic)) {
		val = *((u64 *)(apic->regs + offset));
		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(val>>32));
	 } else {
		kvm_lapic_reg_read(apic, offset, 4, &val);
	}
		
	kvm_lapic_reg_write(apic, offset, (u32)val);
  }

+ } else {
>> +		kvm_lapic_reg_read(vcpu->arch.apic, offset, 4, &val);
>> +	}
>>   
>>   	/* TODO: optimize to just emulate side effect w/o one more write */
>>   	kvm_lapic_reg_write(vcpu->arch.apic, offset, val);
>> -- 
>> 2.25.1
>
>  From c7641cf0c2ea2a1c5e6dda4007f8d285595ff82d Mon Sep 17 00:00:00 2001
> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 10 Sep 2021 15:07:57 -0700
> Subject: [PATCH] KVM: x86: Add a helper to handle 64-bit APIC writes to ICR
>
> Add a helper to handle 64-bit APIC writes, e.g. for x2APIC WRMSR, to
> deduplicate the handling of ICR writes, which KVM needs to emulate as
> back-to-back writes to ICR2 and then ICR.  Future support for IPI
> virtualization will add yet another path where KVM must handle a 64-bit
> APIC write.
>
> Opportunistically fix the comment; ICR2 holds the destination (if there's
> no shorthand), not the vector.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/lapic.c | 18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 76fb00921203..5f526ee10301 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2183,6 +2183,14 @@ void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu)
>   }
>   EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);
>
> +static int kvm_lapic_reg_write64(struct kvm_lapic *apic, u32 reg, u64 data)
> +{
> +	/* For 64-bit ICR writes, set ICR2 (dest) before ICR (command). */
> +	if (reg == APIC_ICR)
> +		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
> +	return kvm_lapic_reg_write(apic, reg, (u32)data);
> +}
> +
>   /* emulate APIC access in a trap manner */
>   void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>   {
> @@ -2794,10 +2802,7 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>   	if (reg == APIC_ICR2)
>   		return 1;
>
> -	/* if this is ICR write vector before command */
> -	if (reg == APIC_ICR)
> -		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
> -	return kvm_lapic_reg_write(apic, reg, (u32)data);
> +	return kvm_lapic_reg_write64(apic, reg, data);
>   }
>
>   int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
> @@ -2828,10 +2833,7 @@ int kvm_hv_vapic_msr_write(struct kvm_vcpu *vcpu, u32 reg, u64 data)
>   	if (!lapic_in_kernel(vcpu))
>   		return 1;
>
> -	/* if this is ICR write vector before command */
> -	if (reg == APIC_ICR)
> -		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
> -	return kvm_lapic_reg_write(apic, reg, (u32)data);
> +	return kvm_lapic_reg_write64(apic, reg, data);
>   }
>
>   int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 reg, u64 *data)
> --
>
