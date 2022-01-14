Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A3C48E3C8
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 06:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbiANFga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 00:36:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:64760 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229379AbiANFg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 00:36:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642138589; x=1673674589;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ryTqS1+S+iRpqs97+jZ2Som2dsaw22Q76Q+G4jec8/Q=;
  b=idVpOl6l8k+IzjDUbMDC9lMUBLXfcC9ckHdmCqlnXoENmSi0L3+Fcc6u
   MLd5MI5OYumY8KG0NbxrDEhBz7+DNwkMTCCRkDOEYkbcZr7QSMCZWCJ2G
   iBtVqQqI2bnj1YQR5JV9ste9f60lPWCcvUZtM1DNXH6hW4UhsvR7tdLgi
   ysu9mYwKtzOM2T+kXw9X932qI85DeR6qdBdmyBJcGFh3LJXDz9gSmRGRx
   h0CzmZbb6bLk+YXbrQ+eCsuWVKp9TLWYjIag+PhK38RGvEgQvxXqgjdld
   P3+kTVUecwlcQl+vBr6W6odB1lMEPNkuqlPgH9YOsxGZq1NjcYyUzrnFP
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="241748037"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="241748037"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 21:36:28 -0800
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="530012661"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.254.212.142]) ([10.254.212.142])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 21:36:23 -0800
Message-ID: <b4dd1c1a-3250-98e5-af3b-f14cd08b5548@intel.com>
Date:   Fri, 14 Jan 2022 13:36:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.4.1
Subject: Re: [PATCH v5 6/8] KVM: VMX: enable IPI virtualization
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
 <20211231142849.611-7-guang.zeng@intel.com> <YeCeCYY2UTL/T1Tv@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <YeCeCYY2UTL/T1Tv@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/14/2022 5:47 AM, Sean Christopherson wrote:
> On Fri, Dec 31, 2021, Zeng Guang wrote:
>> +/* Tertiary Processor-Based VM-Execution Controls, word 3 */
>> +#define VMX_FEATURE_IPI_VIRT		(3*32 +  4) /* "" Enable IPI virtualization */
>>   #endif /* _ASM_X86_VMXFEATURES_H */
>> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>> index 38d414f64e61..78b0525dd991 100644
>> --- a/arch/x86/kvm/vmx/capabilities.h
>> +++ b/arch/x86/kvm/vmx/capabilities.h
>> @@ -12,6 +12,7 @@ extern bool __read_mostly enable_ept;
>>   extern bool __read_mostly enable_unrestricted_guest;
>>   extern bool __read_mostly enable_ept_ad_bits;
>>   extern bool __read_mostly enable_pml;
>> +extern bool __read_mostly enable_ipiv;
>>   extern int __read_mostly pt_mode;
>>   
>>   #define PT_MODE_SYSTEM		0
>> @@ -283,6 +284,12 @@ static inline bool cpu_has_vmx_apicv(void)
>>   		cpu_has_vmx_posted_intr();
>>   }
>>   
>> +static inline bool cpu_has_vmx_ipiv(void)
>> +{
>> +	return vmcs_config.cpu_based_3rd_exec_ctrl &
>> +		TERTIARY_EXEC_IPI_VIRT;
> Unnecessary newline, that fits on a single line.

OK.

>> +}
>> +
>>   static inline bool cpu_has_vmx_flexpriority(void)
>>   {
>>   	return cpu_has_vmx_tpr_shadow() &&
>> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
>> index 1c94783b5a54..bd9c9a89726a 100644
>> --- a/arch/x86/kvm/vmx/posted_intr.c
>> +++ b/arch/x86/kvm/vmx/posted_intr.c
>> @@ -85,11 +85,16 @@ static bool vmx_can_use_vtd_pi(struct kvm *kvm)
>>   		irq_remapping_cap(IRQ_POSTING_CAP);
>>   }
>>   
>> +static bool vmx_can_use_ipiv_pi(struct kvm *kvm)
>> +{
>> +	return irqchip_in_kernel(kvm) && enable_apicv && enable_ipiv;
> enable_ipiv should be cleared if !enable_apicv, i.e. the enable_apicv check
> here should be unnecessary.
Right, it's more concise.  Thanks.

>> +}
>> +
>>   void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
>>   {
>>   	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>>   
>> -	if (!vmx_can_use_vtd_pi(vcpu->kvm))
>> +	if (!(vmx_can_use_ipiv_pi(vcpu->kvm) || vmx_can_use_vtd_pi(vcpu->kvm)))
> Purely because I am beyond terrible at reading !(A || B) and !(A && B), can we
> write this as:
>
> 	if (!vmx_can_use_ipiv_pi(vcpu->kvm) && !vmx_can_use_vtd_pi(vcpu->kvm))
> 		return;
>
> Or better, add a helper.  We could even drop vmx_can_use_ipiv_pi() altogether, e.g.
>
> static bool vmx_can_use_posted_interrupts(struct kvm *kvm)
> {
> 	return irqchip_in_kernel(kvm) &&
> 	       (enable_ipiv || vmx_can_use_vtd_pi(kvm));
> }
>
> Or with both helpers:
>
> static bool vmx_can_use_posted_interrupts(struct kvm *kvm)
> {
> 	return vmx_can_use_ipiv_pi(kvm) || vmx_can_use_vtd_pi(kvm);
> }
>
> I don't think I have a strong preference over whether or not to drop
> vmx_can_use_ipiv_pi().  I think it's marginally easier to read with the extra
> helper?

I'd like to add helper without dropping vmx_can_use_ipiv_pi() which 
makes logic clear and independent.

>>   		return;
>>   
>>   	/* Set SN when the vCPU is preempted */
>> @@ -147,7 +152,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>>   	struct pi_desc old, new;
>>   	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>>   
>> -	if (!vmx_can_use_vtd_pi(vcpu->kvm))
>> +	if (!(vmx_can_use_ipiv_pi(vcpu->kvm) || vmx_can_use_vtd_pi(vcpu->kvm)))
>>   		return 0;
>>   
>>   	WARN_ON(irqs_disabled());
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 5716db9704c0..2e65464d6dee 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -104,6 +104,9 @@ module_param(fasteoi, bool, S_IRUGO);
>>   
>>   module_param(enable_apicv, bool, S_IRUGO);
>>   
>> +bool __read_mostly enable_ipiv = true;
>> +module_param(enable_ipiv, bool, 0444);
>> +
>>   /*
>>    * If nested=1, nested virtualization is supported, i.e., guests may use
>>    * VMX and be a hypervisor for its own guests. If nested=0, guests may not
>> @@ -224,6 +227,11 @@ static const struct {
>>   };
>>   
>>   #define L1D_CACHE_ORDER 4
>> +
>> +/* PID(Posted-Interrupt Descriptor)-pointer table entry is 64-bit long */
>> +#define MAX_PID_TABLE_ORDER get_order(KVM_MAX_VCPU_IDS * sizeof(u64))
>> +#define PID_TABLE_ENTRY_VALID 1
>> +
>>   static void *vmx_l1d_flush_pages;
>>   
>>   static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
>> @@ -2504,7 +2512,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>   	}
>>   
>>   	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
>> -		u64 opt3 = 0;
>> +		u64 opt3 = TERTIARY_EXEC_IPI_VIRT;
>>   		u64 min3 = 0;
>>   
>>   		if (adjust_vmx_controls_64(min3, opt3,
>> @@ -3841,6 +3849,8 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
>>   		vmx_enable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_RW);
>>   		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
>>   		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
>> +		vmx_set_intercept_for_msr(vcpu, X2APIC_MSR(APIC_ICR),
>> +				MSR_TYPE_RW, !enable_ipiv);
> Please align this, e.g.
>
> 		vmx_set_intercept_for_msr(vcpu, X2APIC_MSR(APIC_ICR),
> 					  MSR_TYPE_RW, !enable_ipiv);
>
> though I think I'd actually prefer we do:
>
>
> 		if (enable_ipiv)
> 			vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_ICR), MSR_TYPE_RW);
>
> and just let it poke out.  That makes it much more obvious that interception is
> disabled when IPI virtualization is enabled.  Using vmx_set_intercept_for_msr()
> implies that it could go either way, but that's not true as vmx_reset_x2apic_msrs()
> sets the bitmap to intercept all x2APIC MSRs.

Make sense. Will do.

