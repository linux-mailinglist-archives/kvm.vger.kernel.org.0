Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B004D742034
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 08:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbjF2GMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 02:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjF2GMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 02:12:34 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2F61BC3;
        Wed, 28 Jun 2023 23:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688019152; x=1719555152;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yf+fYjG28gCGti2Jv4VQ+aICiUpwirP4kbsfLmOgn54=;
  b=bfqhs03NNji4H8KL7huPeMmrC4rAjwyXuOWy6v/EyrtanKugM4yU9gU7
   5aKuu3y8nMMevmD583w09023l10MONGu09E0KvNnL+Bdjp/kPzCKlTi5H
   lvJhT8cYE9V8LdXUe8yzQjQ+3VWtmsji3LfeN+oDjkzIhQZYzQhgE/xvk
   JZdX83i1ohByN+IcbK0MPXdRFtJThxk362NX/r66GoyAG61PEnmEAZ0bm
   +DLL4lgUbtOY3oJPG/dMxL/jPR7eq6dsS9NAntzHpZD3q/CPCRk2gwyV/
   2wXSO8xBU8wAK4kjKO9qknmTU/xsyEB6QlsqmkJhxg5Lkwcp2YEPa7jth
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="360884049"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="360884049"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 23:12:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="1047674675"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="1047674675"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.9.27]) ([10.238.9.27])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 23:12:30 -0700
Message-ID: <bf5ef935-b676-4f2a-7df3-271eff24e6bb@linux.intel.com>
Date:   Thu, 29 Jun 2023 14:12:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v9 4/6] KVM: x86: Introduce untag_addr() in kvm_x86_ops
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
 <20230606091842.13123-5-binbin.wu@linux.intel.com>
 <ZJt7vud/2FJtcGjV@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZJt7vud/2FJtcGjV@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/28/2023 8:15 AM, Sean Christopherson wrote:
> On Tue, Jun 06, 2023, Binbin Wu wrote:
>> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
>> index 5b9ec610b2cb..c2091e24a6b9 100644
>> --- a/arch/x86/kvm/kvm_emulate.h
>> +++ b/arch/x86/kvm/kvm_emulate.h
>> @@ -91,6 +91,7 @@ struct x86_instruction_info {
>>   /* x86-specific emulation flags */
>>   #define X86EMUL_F_FETCH			BIT(0)
>>   #define X86EMUL_F_WRITE			BIT(1)
>> +#define X86EMUL_F_SKIPLAM		BIT(2)
> See my comments in the LASS series about describing the access, not dictating
> the end behavior.

The suggestion do decouple the code to specific feature in common 
emulator code, thanks.

>
>>   
>>   struct x86_emulate_ops {
>>   	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 52dcf3c00bb8..82a225d1000e 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -8133,6 +8133,77 @@ static void vmx_vm_destroy(struct kvm *kvm)
>>   	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
>>   }
>>   
>> +#define LAM_S57_EN_MASK (X86_CR4_LAM_SUP | X86_CR4_LA57)
>> +static int lam_sign_extend_bit(struct kvm_vcpu *vcpu, gva_t addr)
>> +{
>> +	u64 cr3, cr4;
>> +
>> +	/*
>> +	 * The LAM identification of a pointer as user or supervisor is
>> +	 * based solely on the value of pointer bit 63.
>> +	 */
>> +	if (!(addr >> 63)) {
> BIT_ULL(63)
>
>> +		cr3 = kvm_read_cr3(vcpu);
> Use the perfectly good helper added earlier in the series:
>
> 		cr3_lam = kvm_get_active_lam_bits();
Good suggestion. Thanks.

>
> That has the added bonus of avoiding a VMREAD of CR3 when LAM is disabled in CR4.
Why? I don't get the point.

>
>> +		if (cr3 & X86_CR3_LAM_U57)
>> +			return 56;
>> +		if (cr3 & X86_CR3_LAM_U48)
>> +			return 47;
>> +	} else {
>> +		cr4 = kvm_read_cr4_bits(vcpu, LAM_S57_EN_MASK);
>> +		if (cr4 == LAM_S57_EN_MASK)
>> +			return 56;
>> +		if (cr4 & X86_CR4_LAM_SUP)
>> +			return 47;
> This is way too complicated for a simple thing.  Burying multiple bits in a #define
> and then relying on specific bits being in the mask is unnecessarily subtle.
>
> And this whole helper shouldn't exist.  There's one caller, and will only ever
> be one caller.  Defining magic numbers, i.e. using -1 to signal "disabled", makes
> it that much harder to read the code.
>
> More below.
>
>> +	}
>> +	return -1;
>> +}
>> +
>> +/*
>> + * Only called in 64-bit mode.
>> + *
>> + * LAM has a modified canonical check when applicable:
>> + * LAM_S48                : [ 1 ][ metadata ][ 1 ]
>> + *                            63               47
>> + * LAM_U48                : [ 0 ][ metadata ][ 0 ]
>> + *                            63               47
>> + * LAM_S57                : [ 1 ][ metadata ][ 1 ]
>> + *                            63               56
>> + * LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
>> + *                            63               56
>> + * LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
>> + *                            63               56..47
>> + *
>> + * Untag the metadata bits by sign-extending the value of bit 47 (LAM48) or
>> + * bit 56 (LAM57). The resulting address after untag isn't guaranteed to be
>> + * canonical. Callers should perform the original canonical check and raise
>> + * #GP/#SS if the address is non-canonical.
>> + *
>> + * Note that KVM masks the metadata in addresses, performs the (original)
>> + * canonicality checking and then walks page table. This is slightly
>> + * different from hardware behavior but achieves the same effect.
>> + * Specifically, if LAM is enabled, the processor performs a modified
>> + * canonicality checking where the metadata are ignored instead of
>> + * masked. After the modified canonicality checking, the processor masks
>> + * the metadata before passing addresses for paging translation.
>> + */
>> +void vmx_untag_addr(struct kvm_vcpu *vcpu, gva_t *gva, u32 flags)
> Rather than modify the pointer, return the untagged address.  That's more flexible
> as it allows using the result in if-statements and whatnot.  That might not ever
> come into play, but there's no good reason to use an in/out param in a void
> function.
In earlier version, it did return the untagged address.
In this version, I changed it as an in/out param to make the interface 
conditional and avoid to add a dummy one in SVM.
Is it can be a reason?


>
>> +{
>> +	int sign_ext_bit;
>> +
>> +	/*
>> +	 * Check LAM_U48 in cr3_ctrl_bits to avoid guest_cpuid_has().
>> +	 * If not set, vCPU doesn't supports LAM.
>> +	 */
>> +	if (!(vcpu->arch.cr3_ctrl_bits & X86_CR3_LAM_U48) ||
> This is unnecessary, KVM should never allow the LAM bits in CR3 to be set if LAM
> isn't supported.

OK.
>
>> +	    (flags & X86EMUL_F_SKIPLAM) || WARN_ON_ONCE(!is_64_bit_mode(vcpu)))
> Same comments as the LASS series, don't WARN, just put the check here.
OK.

>
>> +		return;
>> +
>> +	sign_ext_bit = lam_sign_extend_bit(vcpu, *gva);
>> +	if (sign_ext_bit > 0)
>> +		*gva = (sign_extend64(*gva, sign_ext_bit) & ~BIT_ULL(63)) |
>> +		       (*gva & BIT_ULL(63));
>
> Something like this?  The early return in the user path is a bit forced, e.g. it
> could also be:
>
> 	if (cr3 & X86_CR3_LAM_U57)
> 		lam_bit = 56;
> 	else if (X86_CR3_LAM_U48)
> 		lam_bit = 48;
> 	else
> 		return gva;
>
> but IMO making the CR3 and CR4 paths somewhat symmetrical is valuable.
>
> gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva,
> 			    unsigned int flags)
> {
> 	unsigned long cr3_bits, cr4_bits;
> 	int lam_bit;
>
> 	if (flags & (X86EMUL_F_FETCH | X86EMUL_F_BRANCH_INVLPG | X86EMUL_F_IMPLICIT))
Thanks for the suggestion. Overall, it looks good to me.

Suppose "X86EMUL_F_BRANCH_INVLPG "  should be two flags for branch and 
invlpg, right？

And for LAM, X86EMUL_F_IMPLICIT will not be used because in the implicit 
access to memory management registers or descriptors,
the linear base addresses still need to be canonical and no hooks will 
be added to untag the addresses in these pathes.
So I probably will remove the check for X86EMUL_F_IMPLICIT here.

> 		return gva;
>
> 	if (!is_64_bit_mode(vcpu))
> 		return gva;
>
> 	/*
> 	 * Bit 63 determines if the address should be treated as user address
> 	 * or a supervisor address.
> 	 */
> 	if (!(gva & BIT_ULL(63))) {
> 		cr3_bits = kvm_get_active_lam_bits(vcpu);
> 		if (!(cr3 & (X86_CR3_LAM_U57 | X86_CR3_LAM_U48))
> 			return gva;
>
> 		/* LAM_U48 is ignored if LAM_U57 is set. */
> 		lam_bit = cr3_bits & X86_CR3_LAM_U57 ? 56 : 47;
> 	} else {
> 		if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_LAM_SUP_BIT))
> 			return gva;
>
> 		lam_bit = kvm_is_cr4_bit_set(vcpu, X86_CR4_LA57) ? 56 : 47;
> 	}
> 	return (sign_extend64(gva, lam_bit) & ~BIT_ULL(63)) | (gva & BIT_ULL(63));
> }
>

