Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD67723588
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 04:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbjFFC5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 22:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjFFC5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 22:57:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548ED187;
        Mon,  5 Jun 2023 19:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686020249; x=1717556249;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=F+vkV+jfb5o4EuHJj2V27tXZPhI2wJN8JMR+LPb/mNE=;
  b=NjCLVRkzAHHf7KH2MLO1pbkKAwsoTpkZG83+oGXI8lU3B6OptHTpjREd
   yAFOsyygdw0hD5fSqWYTTJgZKUwPh+Rf4wZ6El63PLuyayZc4SeyhS9nr
   R3nX7CJ+rilXzABCrNCYqeI3x9C0DLfgUjNB+b9LmKOEObbNq0nisKK8S
   ghEBo1pFt2UGyneLARPc79OrrSS9wJljcPwniBTtpgdoYMt4bH/Y17Kef
   RU4lQO9dSOdg1AbD6T9Zx0fO7CPVJptJ+faBTgzpIn12Xcl+rgkzXllTZ
   0i5hSlVz6RuPEBcWirilDBUGUYr6HsS//UEZnlCNXfl9ohPEFBIQ0/uCi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="354042102"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="354042102"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 19:57:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="1039008219"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="1039008219"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.210.225]) ([10.254.210.225])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 19:57:25 -0700
Message-ID: <c60f77df-4d29-f063-ba75-ce7dd818b2fb@linux.intel.com>
Date:   Tue, 6 Jun 2023 10:57:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v1 3/6] KVM: VMX: Add new ops in kvm_x86_ops for LASS
 violation check
To:     Zeng Guang <guang.zeng@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20230601142309.6307-1-guang.zeng@intel.com>
 <20230601142309.6307-4-guang.zeng@intel.com>
 <3b3d9106-9e4f-8a76-30ee-29540b06022a@linux.intel.com>
 <20230605205342.00000e41.zhi.wang.linux@gmail.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230605205342.00000e41.zhi.wang.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/5/2023 8:53 PM, Zhi Wang wrote:
> On Mon, 5 Jun 2023 11:31:48 +0800
> Binbin Wu <binbin.wu@linux.intel.com> wrote:
>
>>
>> On 6/1/2023 10:23 PM, Zeng Guang wrote:
>>> Intel introduces LASS (Linear Address Separation) feature providing
>>                         ^
>>    missing "Space" here
>>> an independent mechanism to achieve the mode-based protection.
>>>
>>> LASS partitions 64-bit linear address space into two halves, user-mode
>>> address (LA[bit 63]=0) and supervisor-mode address (LA[bit 63]=1). It
>>> stops any code execution or conditional data access[1]
>>>       1. from user mode to supervisor-mode address space
>>>       2. from supervisor mode to user-mode address space
>>> and generates LASS violation fault accordingly.
>>>
>>> [1]A supervisor mode data access causes a LASS violation only if supervisor
>>> mode access protection is enabled (CR4.SMAP = 1) and either RFLAGS.AC = 0
>>> or the access implicitly accesses a system data structure.
>>>
>>> Following are the rules of LASS violation check on the linear address(LA).
>>> User access to supervisor-mode address space:
>>>       LA[bit 63] && (CPL == 3)
>>> Supervisor access to user-mode address space:
>>>       Instruction fetch: !LA[bit 63] && (CPL < 3)
>>>       Data access: !LA[bit 63] && (CR4.SMAP==1) && ((RFLAGS.AC == 0 &&
>>>                    CPL < 3) || Implicit supervisor access)
>>>
>>> Add new ops in kvm_x86_ops to do LASS violation check.
>>>
>>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>>> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>>> ---
>>>    arch/x86/include/asm/kvm-x86-ops.h |  3 +-
>>>    arch/x86/include/asm/kvm_host.h    |  2 ++
>>>    arch/x86/kvm/kvm_emulate.h         |  1 +
>>>    arch/x86/kvm/vmx/vmx.c             | 47 ++++++++++++++++++++++++++++++
>>>    arch/x86/kvm/vmx/vmx.h             |  2 ++
>>>    5 files changed, 54 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
>>> index 13bc212cd4bc..8980a3bfa687 100644
>>> --- a/arch/x86/include/asm/kvm-x86-ops.h
>>> +++ b/arch/x86/include/asm/kvm-x86-ops.h
>>> @@ -132,7 +132,8 @@ KVM_X86_OP_OPTIONAL(migrate_timers)
>>>    KVM_X86_OP(msr_filter_changed)
>>>    KVM_X86_OP(complete_emulated_msr)
>>>    KVM_X86_OP(vcpu_deliver_sipi_vector)
>>> -KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>>> +KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons)
>>> +KVM_X86_OP_OPTIONAL_RET0(check_lass)
>>>    
>>>    #undef KVM_X86_OP
>>>    #undef KVM_X86_OP_OPTIONAL
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index 92d8e65fe88c..98666d1e7727 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -1731,6 +1731,8 @@ struct kvm_x86_ops {
>>>    	 * Returns vCPU specific APICv inhibit reasons
>>>    	 */
>>>    	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
>>> +
>>> +	bool (*check_lass)(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 flags);
>>>    };
>>>    
>>>    struct kvm_x86_nested_ops {
>>> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
>>> index 5b9ec610b2cb..f1439ab7c14b 100644
>>> --- a/arch/x86/kvm/kvm_emulate.h
>>> +++ b/arch/x86/kvm/kvm_emulate.h
>>> @@ -91,6 +91,7 @@ struct x86_instruction_info {
>>>    /* x86-specific emulation flags */
>>>    #define X86EMUL_F_FETCH			BIT(0)
>>>    #define X86EMUL_F_WRITE			BIT(1)
>>> +#define X86EMUL_F_SKIPLASS		BIT(2)
>>>    
>>>    struct x86_emulate_ops {
>>>    	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index a33205ded85c..876997e8448e 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -8130,6 +8130,51 @@ static void vmx_vm_destroy(struct kvm *kvm)
>>>    	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
>>>    }
>>>    
>>> +/*
>>> + * Determine whether an access to the linear address causes a LASS violation.
>>> + * LASS protection is only effective in long mode. As a prerequisite, caller
>>> + * should make sure vCPU running in long mode and invoke this api to do LASS
>>> + * violation check.
>>> + */
>>> +bool vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 flags)
>>> +{
>>> +	bool user_mode, user_as, rflags_ac;
>>> +
>>> +	if (!!(flags & X86EMUL_F_SKIPLASS) ||
>>> +	    !kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS))
>>> +		return false;
>>> +
>>> +	WARN_ON_ONCE(!is_long_mode(vcpu));
>> IMHO, it's better to skip the following checks and return false if it is
>> out of long mode.
>>
> The check of long mode is in the caller implemented in in the next patch. :)
>
> +	if (!is_long_mode(vcpu))
> +		return false;
I know the callers have checked the mode, however, IMHO, it's better as 
following:

+	if (!!(flags & X86EMUL_F_SKIPLASS) ||
+	    !kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS) || WARN_ON_ONCE(!is_long_mode(vcpu)))
+		return false;



>>> +
>>> +	user_as = !(la >> 63);
>> It's better to describe how LASS treat linear address in compatibility
>> mode in changelog or/and in comment,
>> i.e. for a linear address with only 32 bits (or 16 bits), the processor
>> treats bit 63 as if it were 0.
>>
>>
>>> +
>>> +	/*
>>> +	 * An access is a supervisor-mode access if CPL < 3 or if it implicitly
>>> +	 * accesses a system data structure. For implicit accesses to system
>>> +	 * data structure, the processor acts as if RFLAGS.AC is clear.
>>> +	 */
>>> +	if (access & PFERR_IMPLICIT_ACCESS) {
>>> +		user_mode = false;
>>> +		rflags_ac = false;
>>> +	} else {
>>> +		user_mode = vmx_get_cpl(vcpu) == 3;
>>> +		if (!user_mode)
>>> +			rflags_ac = !!(kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
>>> +	}
>>> +
>>> +	if (user_mode == user_as)
>>> +		return false;
>>> +
>>> +	/*
>>> +	 * Supervisor-mode _data_ accesses to user address space
>>> +	 * cause LASS violations only if SMAP is enabled.
>>> +	 */
>>> +	if (!user_mode && !(access & PFERR_FETCH_MASK))
>>> +		return kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP) && !rflags_ac;
>>> +
>>> +	return true;
>>> +}
>>> +
>>>    static struct kvm_x86_ops vmx_x86_ops __initdata = {
>>>    	.name = KBUILD_MODNAME,
>>>    
>>> @@ -8269,6 +8314,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>>>    	.complete_emulated_msr = kvm_complete_insn_gp,
>>>    
>>>    	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
>>> +
>>> +	.check_lass = vmx_check_lass,
>>>    };
>>>    
>>>    static unsigned int vmx_handle_intel_pt_intr(void)
>>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>>> index 9e66531861cf..f2e775b9849b 100644
>>> --- a/arch/x86/kvm/vmx/vmx.h
>>> +++ b/arch/x86/kvm/vmx/vmx.h
>>> @@ -433,6 +433,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
>>>    u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
>>>    u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
>>>    
>>> +bool vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 flags);
>>> +
>>>    static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
>>>    					     int type, bool value)
>>>    {

