Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1143048E50C
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 08:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbiANHwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 02:52:49 -0500
Received: from mga07.intel.com ([134.134.136.100]:6282 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230143AbiANHwt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 02:52:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642146769; x=1673682769;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sZsuATNg4UqU09w85XSeP9EMzdFomxr5c2hmtcLk0uo=;
  b=h9qPf8E1+aSJopqTRquuyg8Y5hn4ac83HkLFN/uhHwJedE5GdrdVqmTr
   fWE02H3XVY1BtDiePcFFFN59AsCdPSytvHldB3fbRC1FiNYLkNlaSw22i
   ZAmM6JMV7FaRFuGGsTaxO4Xp36Tlr2mm3g6DNWV7K6+EgKnJCqg92cigd
   0teP7DFta9Uu1bGcVo5dsTtd2AHXMEZMU4Ab8RPf1qVp1rmJTL9mLJsLj
   PVwgPHaFhGsmZPYRttGWhpL2cZ4aYbk6BGuGgnzFJ5L4V393Jx8unJ9/y
   sqOex1O6Gu1Ow1YydkJ7FY5/yHBPCPWYN8HKyoj2UXEnzhNw9pLAz+29Y
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="307545209"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="307545209"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 23:52:48 -0800
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="530117601"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.254.212.142]) ([10.254.212.142])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 23:52:43 -0800
Message-ID: <ec578526-989d-0913-e40e-9e463fb85a8f@intel.com>
Date:   Fri, 14 Jan 2022 15:52:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.4.1
Subject: Re: [PATCH v5 5/8] KVM: x86: Support interrupt dispatch in x2APIC
 mode with APIC-write VM exit
Content-Language: en-US
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
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-6-guang.zeng@intel.com> <YeCZpo+qCkvx5l5m@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <YeCZpo+qCkvx5l5m@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/14/2022 5:29 AM, Sean Christopherson wrote:
> On Fri, Dec 31, 2021, Zeng Guang wrote:
>> In VMX non-root operation, new behavior applies to
> "new behavior" is ambiguous, it's not clear if it refers to new hardware behavior,
> new KVM behavior, etc...
>
>> virtualize WRMSR to vICR in x2APIC mode. Depending
> Please wrap at ~75 chars, this is too narrow.
>
>> on settings of the VM-execution controls, CPU would
>> produce APIC-write VM-exit following the 64-bit value
>> written to offset 300H on the virtual-APIC page(vICR).
>> KVM needs to retrieve the value written by CPU and
>> emulate the vICR write to deliver an interrupt.
>>
>> Current KVM doesn't consider to handle the 64-bit setting
>> on vICR in trap-like APIC-write VM-exit. Because using
>> kvm_lapic_reg_write() to emulate writes to APIC_ICR requires
>> the APIC_ICR2 is already programmed correctly. But in the
>> above APIC-write VM-exit, CPU writes the whole 64 bits to
>> APIC_ICR rather than program higher 32 bits and lower 32
>> bits to APIC_ICR2 and APIC_ICR respectively. So, KVM needs
>> to retrieve the whole 64-bit value and program higher 32 bits
>> to APIC_ICR2 first.
> I think this is simply saying:
>
>    Upcoming Intel CPUs will support virtual x2APIC MSR writes to the vICR,
>    i.e. will trap and generate an APIC-write VM-Exit instead of intercepting
>    the WRMSR.  Add support for handling "nodecode" x2APIC writes, which were
>    previously impossible.
>
>    Note, x2APIC MSR writes are 64 bits wide.
>
> and then the shortlog can be:
>
>    KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode
>
> The "interrupt dispatch" part is quite confusing because it's not really germane
> to the change; yes, the vICR write does (eventually) dispatch an IRQ, but that
> has nothing to do with the code being modified.

I would take commit message as you suggested. Thanks.

>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>> ---
>>   arch/x86/kvm/lapic.c | 12 +++++++++---
>>   arch/x86/kvm/lapic.h |  5 +++++
>>   2 files changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index f206fc35deff..3ce7142ba00e 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -2186,15 +2186,21 @@ EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);
>>   /* emulate APIC access in a trap manner */
>>   void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>>   {
>> -	u32 val = 0;
>> +	struct kvm_lapic *apic = vcpu->arch.apic;
>> +	u64 val = 0;
>>   
>>   	/* hw has done the conditional check and inst decode */
>>   	offset &= 0xff0;
>>   
>> -	kvm_lapic_reg_read(vcpu->arch.apic, offset, 4, &val);
>> +	/* exception dealing with 64bit data on vICR in x2apic mode */
>> +	if ((offset == APIC_ICR) && apic_x2apic_mode(apic)) {
> Sorry, I failed to reply to your response in the previous version.  I suggested
> a WARN_ON(offset != APIC_ICR), but you were concerned that apic_x2apic_mode()
> would be expensive to check before @offset.  I don't think that's a valid concern
> as apic_x2apic_mode() is simply:
>
> 	apic->vcpu->arch.apic_base & X2APIC_ENABLE
>
> And is likely well-predicted by the CPU, especially in single tenant or pinned
> scenarios where the pCPU is running a single VM/vCPU, i.e. will amost never see
> X2APIC_ENABLE toggling.
>
> So I stand behind my previous feedback[*] that we should split on x2APIC.
>
>> +		val = kvm_lapic_get_reg64(apic, offset);
>> +		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(val>>32));
>> +	} else
>> +		kvm_lapic_reg_read(apic, offset, 4, &val);
> Needs curly braces.  But again, I stand behind my previous feedback that this
> would be better written as:
>
>          if (apic_x2apic_mode(apic)) {
>                  if (WARN_ON_ONCE(offset != APIC_ICR))
>                          return 1;
>
>                  kvm_lapic_reg_read(apic, offset, 8, &val);
>                  kvm_lapic_reg_write64(apic, offset, val);
>          } else {
>                  kvm_lapic_reg_read(apic, offset, 4, &val);
>                  kvm_lapic_reg_write(apic, offset, val);
>          }
>
> after a patch (provided in earlier feedback) to introduce kvm_lapic_reg_write64().
>
> [*] https://lore.kernel.org/all/YTvcJZSd1KQvNmaz@google.com

kvm_lapic_reg_read() is limited to read up to 4 bytes. It needs extension to support 64bit
read. And another concern is here getting reg value only specific from vICR(no other regs
need take care), going through whole path on kvm_lapic_reg_read() could be time-consuming
unnecessarily. Is it proper that calling kvm_lapic_get_reg64() to retrieve vICR value directly?

The change could be like follows:

         if (apic_x2apic_mode(apic)) {
                 if (WARN_ON_ONCE(offset != APIC_ICR))
                         return 1;

                 val = kvm_lapic_get_reg64(apic, offset);
                 kvm_lapic_reg_write64(apic, offset, val);
         } else {
                 kvm_lapic_reg_read(apic, offset, 4, &val);
                 kvm_lapic_reg_write(apic, offset, val);
         }

  

>>   	/* TODO: optimize to just emulate side effect w/o one more write */
>> -	kvm_lapic_reg_write(vcpu->arch.apic, offset, val);
>> +	kvm_lapic_reg_write(apic, offset, (u32)val);
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_apic_write_nodecode);
>>   
