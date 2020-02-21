Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 836B6166D35
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 03:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgBUC72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 21:59:28 -0500
Received: from mga07.intel.com ([134.134.136.100]:33230 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729268AbgBUC71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 21:59:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 18:59:26 -0800
X-IronPort-AV: E=Sophos;i="5.70,466,1574150400"; 
   d="scan'208";a="229702755"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.174.151]) ([10.249.174.151])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 20 Feb 2020 18:59:23 -0800
Subject: Re: [PATCH v2 1/3] KVM: x86: Add EMULTYPE_PF when emulation is
 triggered by a page fault
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200218230310.29410-1-sean.j.christopherson@intel.com>
 <20200218230310.29410-2-sean.j.christopherson@intel.com>
 <7d564331-9a77-d59a-73d3-a7452fd7b15f@intel.com>
 <20200220201145.GI3972@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <cd6d5d20-c533-009c-35ba-9f1777a4ec5d@intel.com>
Date:   Fri, 21 Feb 2020 10:59:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200220201145.GI3972@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/21/2020 4:11 AM, Sean Christopherson wrote:
> On Wed, Feb 19, 2020 at 05:01:41PM +0800, Xiaoyao Li wrote:
>> On 2/19/2020 7:03 AM, Sean Christopherson wrote:
>>> Add a new emulation type flag to explicitly mark emulation related to a
>>> page fault.  Move the propation of the GPA into the emulator from the
>>> page fault handler into x86_emulate_instruction, using EMULTYPE_PF as an
>>> indicator that cr2 is valid.  Similarly, don't propagate cr2 into the
>>> exception.address when it's *not* valid.
>>>
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> ---
>>>   arch/x86/include/asm/kvm_host.h | 12 +++++++++---
>>>   arch/x86/kvm/mmu/mmu.c          | 10 ++--------
>>>   arch/x86/kvm/x86.c              | 25 +++++++++++++++++++------
>>>   3 files changed, 30 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index 4dffbc10d3f8..10c1e8f472b6 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -1370,8 +1370,9 @@ extern u64 kvm_mce_cap_supported;
>>>    *		   decode the instruction length.  For use *only* by
>>>    *		   kvm_x86_ops->skip_emulated_instruction() implementations.
>>>    *
>>> - * EMULTYPE_ALLOW_RETRY - Set when the emulator should resume the guest to
>>> - *			  retry native execution under certain conditions.
>>> + * EMULTYPE_ALLOW_RETRY_PF - Set when the emulator should resume the guest to
>>> + *			     retry native execution under certain conditions,
>>> + *			     Can only be set in conjunction with EMULTYPE_PF.
>>>    *
>>>    * EMULTYPE_TRAP_UD_FORCED - Set when emulating an intercepted #UD that was
>>>    *			     triggered by KVM's magic "force emulation" prefix,
>>> @@ -1384,13 +1385,18 @@ extern u64 kvm_mce_cap_supported;
>>>    *			backdoor emulation, which is opt in via module param.
>>>    *			VMware backoor emulation handles select instructions
>>>    *			and reinjects the #GP for all other cases.
>>> + *
>>> + * EMULTYPE_PF - Set when emulating MMIO by way of an intercepted #PF, in which
>>> + *		 case the CR2/GPA value pass on the stack is valid.
>>>    */
>>>   #define EMULTYPE_NO_DECODE	    (1 << 0)
>>>   #define EMULTYPE_TRAP_UD	    (1 << 1)
>>>   #define EMULTYPE_SKIP		    (1 << 2)
>>> -#define EMULTYPE_ALLOW_RETRY	    (1 << 3)
>>> +#define EMULTYPE_ALLOW_RETRY_PF	    (1 << 3)
>>
>> How about naming it as EMULTYPE_PF_ALLOW_RETRY and exchanging the bit
>> position with EMULTYPE_PF ?
> 
> Hmm, EMULTYPE_PF_ALLOW_RETRY does sound better.  I'm on the fence regarding
> shuffling the bits.  If I were to shuffle the bits, I'd do a more thorough
> reorder so that the #UD and #PF types are consecutive, e.g.
> 
> 	#define EMULTYPE_NO_DECODE	    (1 << 0)
> 	#define EMULTYPE_TRAP_UD	    (1 << 1)
> 	#define EMULTYPE_TRAP_UD_FORCED	    (1 << 2)
> 	#define EMULTYPE_SKIP		    (1 << 3)
> 	#define EMULTYPE_VMWARE_GP	    (1 << 4)
> 	#define EMULTYPE_PF		    (1 << 5)
> 	#define EMULTYPE_PF_ALLOW_RETRY	    (1 << 6)
> 
> Part of me really wants to do that, the other part of me thinks it's
> unnecessary thrash.
>

I'm fine with thorough reorder, it helps read the codes.
It's up to Paolo, anyway.

>>>   #define EMULTYPE_TRAP_UD_FORCED	    (1 << 4)
>>>   #define EMULTYPE_VMWARE_GP	    (1 << 5)
>>> +#define EMULTYPE_PF		    (1 << 6)
>>> +
>>>   int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
>>>   int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
>>>   					void *insn, int insn_len);
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index 7011a4e54866..258624d46588 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -5416,18 +5416,12 @@ EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page_virt);
>>>   int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>>>   		       void *insn, int insn_len)
>>>   {
>>> -	int r, emulation_type = 0;
>>> +	int r, emulation_type = EMULTYPE_PF;
>>>   	bool direct = vcpu->arch.mmu->direct_map;
>>>   	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
>>>   		return RET_PF_RETRY;
>>> -	/* With shadow page tables, fault_address contains a GVA or nGPA.  */
>>> -	if (vcpu->arch.mmu->direct_map) {
>>> -		vcpu->arch.gpa_available = true;
>>> -		vcpu->arch.gpa_val = cr2_or_gpa;
>>> -	}
>>> -
>>>   	r = RET_PF_INVALID;
>>>   	if (unlikely(error_code & PFERR_RSVD_MASK)) {
>>>   		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
>>> @@ -5472,7 +5466,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>>>   	 * for L1 isn't going to magically fix whatever issue cause L2 to fail.
>>>   	 */
>>>   	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
>>> -		emulation_type = EMULTYPE_ALLOW_RETRY;
>>> +		emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
>>>   emulate:
>>>   	/*
>>>   	 * On AMD platforms, under certain conditions insn_len may be zero on #NPF.
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index fbabb2f06273..92af6c5a69e3 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -6483,10 +6483,11 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>>>   	gpa_t gpa = cr2_or_gpa;
>>>   	kvm_pfn_t pfn;
>>> -	if (!(emulation_type & EMULTYPE_ALLOW_RETRY))
>>> +	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
>>>   		return false;
>>> -	if (WARN_ON_ONCE(is_guest_mode(vcpu)))
>>> +	if (WARN_ON_ONCE(is_guest_mode(vcpu)) ||
>>> +	    WARN_ON_ONCE(!(emulation_type & EMULTYPE_PF)))
>>>   		return false;
>>>   	if (!vcpu->arch.mmu->direct_map) {
>>> @@ -6574,10 +6575,11 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
>>>   	 */
>>>   	vcpu->arch.last_retry_eip = vcpu->arch.last_retry_addr = 0;
>>> -	if (!(emulation_type & EMULTYPE_ALLOW_RETRY))
>>> +	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
>>>   		return false;
>>> -	if (WARN_ON_ONCE(is_guest_mode(vcpu)))
>>> +	if (WARN_ON_ONCE(is_guest_mode(vcpu)) ||
>>> +	    WARN_ON_ONCE(!(emulation_type & EMULTYPE_PF)))
>>>   		return false;
>>>   	if (x86_page_table_writing_insn(ctxt))
>>> @@ -6830,8 +6832,19 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>>>   	}
>>>   restart:
>>> -	/* Save the faulting GPA (cr2) in the address field */
>>> -	ctxt->exception.address = cr2_or_gpa;
>>> +	if (emulation_type & EMULTYPE_PF) {
>>> +		/* Save the faulting GPA (cr2) in the address field */
>>> +		ctxt->exception.address = cr2_or_gpa;
>>> +
>>> +		/* With shadow page tables, cr2 contains a GVA or nGPA. */
>>> +		if (vcpu->arch.mmu->direct_map) {
>>> +			vcpu->arch.gpa_available = true;
>>> +			vcpu->arch.gpa_val = cr2_or_gpa;
>>> +		}
>>> +	} else {
>>> +		/* Sanitize the address out of an abundance of paranoia. */
>>> +		ctxt->exception.address = 0;
>>> +	}
>>>   	r = x86_emulate_insn(ctxt);
>>>
>>

