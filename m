Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E904F0217
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 15:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355500AbiDBNgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Apr 2022 09:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiDBNgG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Apr 2022 09:36:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA5813F4A;
        Sat,  2 Apr 2022 06:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648906455; x=1680442455;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qgScYmdRz1TKabV+htsOCqYKdWAFLBIHTuv08g3bPCM=;
  b=LiRedP4fW9rtOAzL50HuuK2ngs06/cBgAdtu/Fyyn6pGRedQvSiB9aCQ
   xp0uruW9vwsEmjnWy59raJ//VH8RpShIei/AazX28TZ5Dva/J9FyYtgFI
   AA0MVezOj2xNMYOAuE2XWPzTZZ12mlrZWyKgniaau2GTibEW/ofyLn0gn
   YclbxXowA3UxYWo4jHVqJmGhtjfKcgXCqhAII6qAiHiCpNFdZ0vB5uMPb
   jYtAIAeHShZDsb3SGYOHmBT5+474gE62OwYb+oqotZxeoWeqdfMNKW/CR
   I8IQkbCv1zIullBx9dbhqm6vvKFERHXhvDWyHdzYeik0YaRUQIXD3SmqI
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="285240650"
X-IronPort-AV: E=Sophos;i="5.90,230,1643702400"; 
   d="scan'208";a="285240650"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2022 06:34:14 -0700
X-IronPort-AV: E=Sophos;i="5.90,230,1643702400"; 
   d="scan'208";a="548138059"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.254.208.38]) ([10.254.208.38])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2022 06:34:09 -0700
Message-ID: <ce0261c0-a8f2-a9b8-6d99-88a33556d7cb@intel.com>
Date:   Sat, 2 Apr 2022 21:33:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v7 5/8] KVM: x86: Add support for vICR APIC-write VM-Exits
 in x2APIC mode
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
References: <20220304080725.18135-1-guang.zeng@intel.com>
 <20220304080725.18135-6-guang.zeng@intel.com> <YkY0MvAIPiISfk4u@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <YkY0MvAIPiISfk4u@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/1/2022 7:07 AM, Sean Christopherson wrote:
> On Fri, Mar 04, 2022, Zeng Guang wrote:
>> Upcoming Intel CPUs will support virtual x2APIC MSR writes to the vICR,
>> i.e. will trap and generate an APIC-write VM-Exit instead of intercepting
>> the WRMSR.  Add support for handling "nodecode" x2APIC writes, which
>> were previously impossible.
>>
>> Note, x2APIC MSR writes are 64 bits wide.
>>
>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>> ---
>>   arch/x86/kvm/lapic.c | 22 +++++++++++++++++++---
>>   1 file changed, 19 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index 629c116b0d3e..22929b5b3f9b 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -67,6 +67,7 @@ static bool lapic_timer_advance_dynamic __read_mostly;
>>   #define LAPIC_TIMER_ADVANCE_NS_MAX     5000
>>   /* step-by-step approximation to mitigate fluctuation */
>>   #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
>> +static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
>>   
>>   static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
>>   {
>> @@ -2227,10 +2228,25 @@ EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);
>>   /* emulate APIC access in a trap manner */
>>   void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>>   {
>> -	u32 val = kvm_lapic_get_reg(vcpu->arch.apic, offset);
>> +	struct kvm_lapic *apic = vcpu->arch.apic;
>> +	u64 val;
>> +
>> +	if (apic_x2apic_mode(apic)) {
>> +		/*
>> +		 * When guest APIC is in x2APIC mode and IPI virtualization
>> +		 * is enabled, accessing APIC_ICR may cause trap-like VM-exit
>> +		 * on Intel hardware. Other offsets are not possible.
>> +		 */
>> +		if (WARN_ON_ONCE(offset != APIC_ICR))
>> +			return;
>>   
>> -	/* TODO: optimize to just emulate side effect w/o one more write */
>> -	kvm_lapic_reg_write(vcpu->arch.apic, offset, val);
>> +		kvm_lapic_msr_read(apic, offset, &val);
>> +		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
> This needs to clear the APIC_ICR_BUSY bit.  It'd also be nice to trace this write.
> The easiest thing is to use kvm_x2apic_icr_write().  Kinda silly as it'll generate
> an extra write, but on the plus side the TODO comment doesn't have to move :-D
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index c4c3155d98db..58bf296ee313 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2230,6 +2230,7 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>          struct kvm_lapic *apic = vcpu->arch.apic;
>          u64 val;
>
> +       /* TODO: optimize to just emulate side effect w/o one more write */
>          if (apic_x2apic_mode(apic)) {
>                  /*
>                   * When guest APIC is in x2APIC mode and IPI virtualization
> @@ -2240,10 +2241,9 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>                          return;
>
>                  kvm_lapic_msr_read(apic, offset, &val);
> -               kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
> +               kvm_x2apic_icr_write(apic, val);

As SDM section 10.12.9 "ICR Operation in X2APIC mode" says "Delivery status
bit is removed since it is not needed in x2APIC mode" , so that's not 
necessary
to clear the APIC_ICR_BUSY bit here. Alternatively we can add trace to 
this write
by hardware.


>          } else {
>                  val = kvm_lapic_get_reg(apic, offset);
> -               /* TODO: optimize to just emulate side effect w/o one more write */
>                  kvm_lapic_reg_write(apic, offset, (u32)val);
>          }
>   }
>
>
>> +	} else {
>> +		val = kvm_lapic_get_reg(apic, offset);
>> +		/* TODO: optimize to just emulate side effect w/o one more write */
>> +		kvm_lapic_reg_write(apic, offset, (u32)val);
>> +	}
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_apic_write_nodecode);
>>   
>> -- 
>> 2.27.0
>>
