Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B726EDAA1
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 05:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbjDYD1V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 23:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbjDYD1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 23:27:01 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D22AF17;
        Mon, 24 Apr 2023 20:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682393211; x=1713929211;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MykIHyOnFBYvjtTNVdllwAiFmLXXR+pbIjotFGUpHJg=;
  b=STY44/0tER/dmOvP3H/XaGjIEqGGIAmHIYlaFxDRGnzZBdZZnykEJ9ju
   YD0d9nFVITvjPxoXw5QnlRFnPEO4su409Tyomq2gRuiMxkgN78odi/C0Q
   CeRpkNeGFHWH2Pvjup8jHYYdxx62EW6imOCvnNR6yzFzlNVQqUK8+++FW
   Z5V3l1CyOZ9x6N20RrxZdmCb2V+JhUroBxiUw1x5m303l9eUE5S5SheyT
   DKz/2UKeWKvIx7txPbF1WIweFwNG7sJtYgOfZnaVpBzxTnnmkF5fkRT+K
   MkLfko4X5vvWCROwQzGEvS8dM9DpoAD57FtJviBx4vWjZl4BmvFaxQ3ey
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="346656800"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="346656800"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 20:26:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="837253766"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="837253766"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.238.0.183]) ([10.238.0.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 20:26:47 -0700
Message-ID: <040a4d50-d25b-c6b9-960a-a85dda30b857@intel.com>
Date:   Tue, 25 Apr 2023 11:26:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/6] KVM: VMX: Add new ops in kvm_x86_ops for LASS
 violation check
Content-Language: en-US
To:     Binbin Wu <binbin.wu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20230420133724.11398-1-guang.zeng@intel.com>
 <20230420133724.11398-3-guang.zeng@intel.com>
 <735e3259-26d4-33f1-0e59-8171d1e832e9@linux.intel.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <735e3259-26d4-33f1-0e59-8171d1e832e9@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/24/2023 3:43 PM, Binbin Wu wrote:
>
> On 4/20/2023 9:37 PM, Zeng Guang wrote:
>> Intel introduce LASS (Linear Address Separation) feature providing
> /s/introduce/introduces
OK.
>
>> an independent mechanism to achieve the mode-based protection.
>>
>> LASS partitions 64-bit linear address space into two halves, user-mode
>> address (LA[bit 63]=0) and supervisor-mode address (LA[bit 63]=1). It
>> stops any code execution or data access
>>       1. from user mode to supervisor-mode address space
>>       2. from supervisor mode to user-mode address space
>> and generates LASS violation fault accordingly.
> IMO, the description of the point 2 may be misleading that LASS stops
> any data access from supervisor mode to user mode address space,
> although the description following adds the conditions.

May change to " It stops any code execution or conditional data access". 
The condition
is illustrated in next paragraph.

>
>> A supervisor mode data access causes a LASS violation only if supervisor
>> mode access protection is enabled (CR4.SMAP = 1) and either RFLAGS.AC = 0
>> or the access implicitly accesses a system data structure.
>>
>> Following are the rule of LASS violation check on the linear address(LA).
> /s/rule/rules
OK.
>> User access to supervisor-mode address space:
>>       LA[bit 63] && (CPL == 3)
>> Supervisor access to user-mode address space:
>>       Instruction fetch: !LA[bit 63] && (CPL < 3)
>>       Data access: !LA[bit 63] && (CR4.SMAP==1) && ((RFLAGS.AC == 0 &&
>> 		 CPL < 3) || Implicit supervisor access)
>>
>> Add new ops in kvm_x86_ops to do LASS violation check.
>>
>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>> ---
>>    arch/x86/include/asm/kvm-x86-ops.h |  1 +
>>    arch/x86/include/asm/kvm_host.h    |  5 +++
>>    arch/x86/kvm/vmx/vmx.c             | 55 ++++++++++++++++++++++++++++++
>>    arch/x86/kvm/vmx/vmx.h             |  2 ++
>>    4 files changed, 63 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
>> index abccd51dcfca..f76c07f2674b 100644
>> --- a/arch/x86/include/asm/kvm-x86-ops.h
>> +++ b/arch/x86/include/asm/kvm-x86-ops.h
>> @@ -131,6 +131,7 @@ KVM_X86_OP(msr_filter_changed)
>>    KVM_X86_OP(complete_emulated_msr)
>>    KVM_X86_OP(vcpu_deliver_sipi_vector)
>>    KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>> +KVM_X86_OP_OPTIONAL_RET0(check_lass);
>>    
>>    #undef KVM_X86_OP
>>    #undef KVM_X86_OP_OPTIONAL
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 8ff89a52ef66..31fb8699a1ff 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -69,6 +69,9 @@
>>    #define KVM_X86_NOTIFY_VMEXIT_VALID_BITS	(KVM_X86_NOTIFY_VMEXIT_ENABLED | \
>>    						 KVM_X86_NOTIFY_VMEXIT_USER)
>>    
>> +/* x86-specific emulation flags */
>> +#define KVM_X86_EMULFLAG_SKIP_LASS	_BITULL(1)
> Do you use the flag outside of emulator?
> For LAM patch, it's planned to move the flags inside emulator.
IMO, the detailed flag is implementation specific. Is it necessary to 
bind with emulator
though it's only used inside emulator ?
>> +
>>    /* x86-specific vcpu->requests bit members */
>>    #define KVM_REQ_MIGRATE_TIMER		KVM_ARCH_REQ(0)
>>    #define KVM_REQ_REPORT_TPR_ACCESS	KVM_ARCH_REQ(1)
>> @@ -1706,6 +1709,8 @@ struct kvm_x86_ops {
>>    	 * Returns vCPU specific APICv inhibit reasons
>>    	 */
>>    	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
>> +
>> +	bool (*check_lass)(struct kvm_vcpu *vcpu, u64 access, u64 la, u64 flags);
> The flags may be dropped if the caller knows to skip it or not.
Probably I don't get you right. Do you mean it need define another 
function without flags ?

>>    };
>>    
>>    struct kvm_x86_nested_ops {
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index c923d7599d71..581327ede66a 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -8070,6 +8070,59 @@ static void vmx_vm_destroy(struct kvm *kvm)
>>    	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
>>    }
>>    
>> +/*
>> + * Determine whether an access to the linear address causes a LASS violation.
>> + * LASS protection is only effective in long mode. As a prerequisite, caller
>> + * should make sure VM
> Should be vCPU？
Similar meaning, I think. :)
>> running in long mode and invoke this api to do LASS
>> + * violation check.
>> + */
>> +bool __vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u64 flags)
>> +{
>> +	bool user_mode, user_as, rflags_ac;
>> +
>> +	if (!!(flags & KVM_X86_EMULFLAG_SKIP_LASS) ||
>> +	    !kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS))
>> +		return false;
>> +
>> +	WARN_ON_ONCE(!is_long_mode(vcpu));
>> +
>> +	user_as = !(la >> 63);
>> +
>> +	/*
>> +	 * An access is a supervisor-mode access if CPL < 3 or if it implicitly
>> +	 * accesses a system data structure. For implicit accesses to system
>> +	 * data structure, the processor acts as if RFLAGS.AC is clear.
>> +	 */
>> +	if (access & PFERR_IMPLICIT_ACCESS) {
>> +		user_mode = false;
>> +		rflags_ac = false;
>> +	} else {
>> +		user_mode = vmx_get_cpl(vcpu) == 3;
>> +		if (!user_mode)
>> +			rflags_ac = !!(kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
>> +	}
>> +
>> +	if (user_mode != user_as) {
>> +		/*
>> +		 * Supervisor-mode _data_ accesses to user address space
>> +		 * cause LASS violations only if SMAP is enabled.
>> +		 */
>> +		if (!user_mode && !(access & PFERR_FETCH_MASK)) {
>> +			return kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP) &&
>> +			       !rflags_ac;
>> +		} else {
>> +			return true;
>> +		}
>> +	}
>> +
>> +	return false;
>> +}
>> +
>> +static bool vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u64 flags)
>> +{
>> +	return is_long_mode(vcpu) && __vmx_check_lass(vcpu, access, la, flags);
>> +}
>> +
>>    static struct kvm_x86_ops vmx_x86_ops __initdata = {
>>    	.name = "kvm_intel",
>>    
>> @@ -8207,6 +8260,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>>    	.complete_emulated_msr = kvm_complete_insn_gp,
>>    
>>    	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
>> +
>> +	.check_lass = vmx_check_lass,
>>    };
>>    
>>    static unsigned int vmx_handle_intel_pt_intr(void)
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index a3da84f4ea45..6569385a5978 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -433,6 +433,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
>>    u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
>>    u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
>>    
>> +bool __vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u64 flags);
>> +
>>    static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
>>    					     int type, bool value)
>>    {
