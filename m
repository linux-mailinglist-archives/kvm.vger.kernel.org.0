Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D3477FBBC
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 18:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352129AbjHQQPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 12:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353615AbjHQQPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 12:15:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A59B173F;
        Thu, 17 Aug 2023 09:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692288917; x=1723824917;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hf13Ut2uJkIO/L71WppT9mvJtI1cw64HIAJ0Bg2qlUM=;
  b=kof+qXPXMhqI8ynbIyzoJC/kfLZ4PLlMlKzJDghgOayK6KobPS3oZcrP
   78WTrYTgjpFVPbbeRmCLDWhiL2VaCqoprXje0jOnTUPPWzJDjjSulrBFL
   7du8Rhx6yeQHsB+guX22eB6YwgvGgqE1VHd0q3A7o7FtGEJOSUYi8dMKv
   urOVo3GExPF43DpVgwmX5uoWE3uez2rQ72/olDhmGBv+9KkGoMXYmwRK2
   T/1B/dkLyg6fRhrAz4W69pip5tob0IDPrC3kI2j1T/bOYGRD6t3W1mNLg
   MJheEglvsd+I6PvJQz5n13kHMkkwsTr96tRJOUlmngdMYpi2LF5ZR7qlm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="436774871"
X-IronPort-AV: E=Sophos;i="6.01,180,1684825200"; 
   d="scan'208";a="436774871"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 09:15:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="908458058"
X-IronPort-AV: E=Sophos;i="6.01,180,1684825200"; 
   d="scan'208";a="908458058"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.249.171.199]) ([10.249.171.199])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 09:15:12 -0700
Message-ID: <83d3de70-8577-3fb4-4e5f-910c64abf0aa@intel.com>
Date:   Fri, 18 Aug 2023 00:15:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v2 6/8] KVM: VMX: Implement and apply
 vmx_is_lass_violation() for LASS protection
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230719024558.8539-1-guang.zeng@intel.com>
 <20230719024558.8539-7-guang.zeng@intel.com>
 <8c628549-a388-afd5-3c6e-a956fbce7f79@linux.intel.com>
 <ZNwOYdy3AC12MI52@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <ZNwOYdy3AC12MI52@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/16/2023 7:46 AM, Sean Christopherson wrote:
> On Mon, Aug 07, 2023, Binbin Wu wrote:
>> On 7/19/2023 10:45 AM, Zeng Guang wrote:
>>> Implement and wire up vmx_is_lass_violation() in kvm_x86_ops for VMX.
>>>
>>> LASS violation check takes effect in KVM emulation of instruction fetch
>>> and data access including implicit access when vCPU is running in long
>>> mode, and also involved in emulation of VMX instruction and SGX ENCLS
>>> instruction to enforce the mode-based protections before paging.
>>>
>>> But the target memory address of emulation of TLB invalidation and branch
>>> instructions aren't subject to LASS as exceptions.
> Same nit about branch instructions.  And I would explicitly say "linear address"
> instead of "target memory address", the "target" part makes it a bit ambiguous.
>
> How about this?
>
> Linear addresses used for TLB invalidation (INVPLG, INVPCID, and INVVPID) and
> branch targets are not subject to LASS enforcement.

That's much precise and will change as you suggest.
Thanks.

>>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>>> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>>> ---
>>>    arch/x86/kvm/vmx/nested.c |  3 ++-
>>>    arch/x86/kvm/vmx/sgx.c    |  4 ++++
>>>    arch/x86/kvm/vmx/vmx.c    | 35 +++++++++++++++++++++++++++++++++++
>>>    arch/x86/kvm/vmx/vmx.h    |  3 +++
>>>    4 files changed, 44 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>> index e35cf0bd0df9..72e78566a3b6 100644
>>> --- a/arch/x86/kvm/vmx/nested.c
>>> +++ b/arch/x86/kvm/vmx/nested.c
>>> @@ -4985,7 +4985,8 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
>>>    		 * non-canonical form. This is the only check on the memory
>>>    		 * destination for long mode!
>>>    		 */
>>> -		exn = is_noncanonical_address(*ret, vcpu);
>>> +		exn = is_noncanonical_address(*ret, vcpu) ||
>>> +		      vmx_is_lass_violation(vcpu, *ret, len, 0);
>>>    	} else {
>>>    		/*
>>>    		 * When not in long mode, the virtual/linear address is
>>> diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
>>> index 2261b684a7d4..f8de637ce634 100644
>>> --- a/arch/x86/kvm/vmx/sgx.c
>>> +++ b/arch/x86/kvm/vmx/sgx.c
>>> @@ -46,6 +46,10 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
>>>    			((s.base != 0 || s.limit != 0xffffffff) &&
>>>    			(((u64)*gva + size - 1) > s.limit + 1));
>>>    	}
>>> +
>>> +	if (!fault)
>>> +		fault = vmx_is_lass_violation(vcpu, *gva, size, 0);
> At the risk of bleeding details where they don't need to go... LASS is Long Mode
> only, so I believe this chunk can be:
>
> 	if (!IS_ALIGNED(*gva, alignment)) {
> 		fault = true;
> 	} else if (likely(is_64_bit_mode(vcpu))) {
> 		fault = is_noncanonical_address(*gva, vcpu) ||
> 			vmx_is_lass_violation(vcpu, *gva, size, 0);
> 	} else {
> 		*gva &= 0xffffffff;
> 		fault = (s.unusable) ||
> 			(s.type != 2 && s.type != 3) ||
> 			(*gva > s.limit) ||
> 			((s.base != 0 || s.limit != 0xffffffff) &&
> 			(((u64)*gva + size - 1) > s.limit + 1));
> 	}
>
> which IIRC matches some earlier emulator code.
Just as you mentioned, LASS is long mode only, meanwhile "ENCLS" instruction
can be executed in kernel mode in 64bit mode. Thus LASS violation check can
only take into account for 64bit mode.
>>> +
>>>    	if (fault)
>>>    		kvm_inject_gp(vcpu, 0);
>>>    	return fault ? -EINVAL : 0;
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index 44fb619803b8..15a7c6e7a25d 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -8127,6 +8127,40 @@ static void vmx_vm_destroy(struct kvm *kvm)
>>>    	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
>>>    }
>>> +bool vmx_is_lass_violation(struct kvm_vcpu *vcpu, unsigned long addr,
>>> +			   unsigned int size, unsigned int flags)
>>> +{
>>> +	const bool is_supervisor_address = !!(addr & BIT_ULL(63));
>>> +	const bool implicit = !!(flags & X86EMUL_F_IMPLICIT);
>>> +	const bool fetch = !!(flags & X86EMUL_F_FETCH);
>>> +	const bool is_wraparound_access = size ? (addr + size - 1) < addr : false;
> Shouldn't this WARN if size==0?  Ah, the "pre"-fetch fetch to get the max insn
> size passes '0'.  Well that's annoying.
>
Right, it passes size as "0" in instruction pre-fetch implemented in 
emulator. Instruction
fetch could take twice if it straddles two pages. So we consider this 
situation for wraparound
case in LASS violation detection.
> Please don't use a local variable to track if an access wraps.  It's used exactly
> one, and there's zero reason to use a ternary operator at the return.  E.g. this
> is much easier on the eyes:
>
> 	if (size && (addr + size - 1) < addr)
> 		return true;
>
> 	return !is_supervisor_address;
>
> Hrm, and typing that out makes me go "huh?"  Ah, it's the "implicit" thing that
> turned me around.  Can you rename "implicit" to "implicit_supervisor"?  The
> F_IMPLICIT flag is fine, it's just this code:
>
> 	if (!implicit && vmx_get_cpl(vcpu) == 3)
> 		return is_supervisor_address;
>
> where it's easy to miss that "implicit" is "implicit supervisor".
"implicit" does mean implicit supervisor-mode access regardless of CPL.
Using "implicit_supervisor" should be better.
Thanks.

> And one more nit, rather than detect wraparound, I think it would be better to
> detect that bit 63 isn't set.  Functionally, they're the same, but detecting
> wraparound makes it look like wraparound itself is problematic, which isn't
> technically true, it's just the only case where an access can possibly straddle
> user and kernel address spaces.
>
> And I think we should call out that if LAM is supported, @addr has already been
> untagged.  Yeah, it's peeking ahead a bit, but I'd rather have a comment that
> is a bit premature than forget to add the appropriate comment in the LAM series.
>
>>> +
>>> +	if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS) || !is_long_mode(vcpu))
>>> +		return false;
>>> +
>>> +	/*
>>> +	 * INVTLB isn't subject to LASS, e.g. to allow invalidating userspace
>>> +	 * addresses without toggling RFLAGS.AC.  Branch targets aren't subject
>>> +	 * to LASS in order to simplifiy far control transfers (the subsequent
>> s/simplifiy/simplifiy
>>
>>> +	 * fetch will enforce LASS as appropriate).
>>> +	 */
>>> +	if (flags & (X86EMUL_F_BRANCH | X86EMUL_F_INVTLB))
>>> +		return false;
>>> +
>>> +	if (!implicit && vmx_get_cpl(vcpu) == 3)
>>> +		return is_supervisor_address;
>>> +
>>> +	/* LASS is enforced for supervisor-mode access iff SMAP is enabled. */
>> To be more accurate, supervisor-mode data access.
>> Also, "iff" here is not is a typo for "if" or it stands for "if and only
>> if"?
> The latter.
>
>> It is not accureate to use "if and only if" here because beside SMAP, there
>> are other conditions, i.e. implicit or RFLAGS.AC.
> I was trying to avoid a multi-line comment when I suggested the above.  Hmm, and
> I think we could/should consolidate the two if-statements.  This?
>
> 	/*
> 	 * LASS enforcement for supervisor-mode data accesses depends on SMAP
> 	 * being enabled, and like SMAP ignores explicit accesses if RFLAGS.AC=1.
> 	 */
> 	if (!fetch) {
> 		if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP))
> 			return false;
>
> 		if (!implicit && (kvm_get_rflags(vcpu) & X86_EFLAGS_AC))
> 			return false;
> 	}
>
>>> +	if (!fetch && !kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP))
>>> +		return false;
>>> +
>>> +	/* Like SMAP, RFLAGS.AC disables LASS checks in supervisor mode. */
>>> +	if (!fetch && !implicit && (kvm_get_rflags(vcpu) & X86_EFLAGS_AC))
>>> +		return false;
> All in all, this?  (wildly untested)
>
> 	const bool is_supervisor_address = !!(addr & BIT_ULL(63));
> 	const bool implicit_supervisor = !!(flags & X86EMUL_F_IMPLICIT);
> 	const bool fetch = !!(flags & X86EMUL_F_FETCH);
>
> 	if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS) || !is_long_mode(vcpu))
> 		return false;
>
> 	/*
> 	 * INVTLB isn't subject to LASS, e.g. to allow invalidating userspace
> 	 * addresses without toggling RFLAGS.AC.  Branch targets aren't subject
> 	 * to LASS in order to simplifiy far control transfers (the subsequent
> 	 * fetch will enforce LASS as appropriate).
> 	 */
> 	if (flags & (X86EMUL_F_BRANCH | X86EMUL_F_INVTLB))
> 		return false;
>
> 	if (!implicit_supervisor && vmx_get_cpl(vcpu) == 3)
> 		return is_supervisor_address;
>
> 	/*
> 	 * LASS enforcement for supervisor-mode data accesses depends on SMAP
> 	 * being enabled, and like SMAP ignores explicit accesses if RFLAGS.AC=1.
> 	 */
> 	if (!fetch) {
> 		if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP))
> 			return false;
>
> 		if (!implicit_supervisor && (kvm_get_rflags(vcpu) & X86_EFLAGS_AC))
> 			return false;
> 	}
>
> 	/*
> 	 * The entire access must be in the appropriate address space.  Note,
> 	 * if LAM is supported, @addr has already been untagged, so barring a
> 	 * massive architecture change to expand the canonical address range,
> 	 * it's impossible for a user access to straddle user and supervisor
> 	 * address spaces.
> 	 */
> 	if (size && !((addr + size - 1) & BIT_ULL(63)))
> 		return true;
>
> 	return !is_supervisor_address;

OK. I'll adopt all you suggested for next version.
Thanks.

