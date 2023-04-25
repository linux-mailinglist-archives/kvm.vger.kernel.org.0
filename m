Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E087C6EDCAE
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 09:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbjDYHdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 03:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbjDYHc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 03:32:27 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD7EC15E;
        Tue, 25 Apr 2023 00:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682407897; x=1713943897;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=y/RZvHBERPsLIxfsgLVfCS8XF5HdzYTULcEBpzqy1jo=;
  b=Huy4ajQ3vFQLXlr6JVVjjqFFSoOZfxWFpz4uqAMJr4BWR3p3JQuOpVPx
   VtEXB7FKobYY51kwqUYK3XAiYLL7DILqwC8G9Btl7OOtdryjZH9h1qEML
   lE8qIeb0EKjpwTSKir4A1CaUMxke32JzyoralpN8qA9BhT6nuq4T8BT4X
   O8rAlkGnG3uNSifP5SASexWYP9zxZhHArGmL1PGNgh1n7CxKBfn/+o+Dd
   Hr4a2PY3m2iC2cUoJxurWsNDh5at6CUrYIW7K8z+H4USseIlWUK3px6Lf
   yE1Q49JNuXgMciJGx/RrkNbqDbaWIYdcREULTYou+tsLUzZKTrP7yuFH0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="432951773"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="432951773"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 00:31:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="670784623"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="670784623"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.238.0.183]) ([10.238.0.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 00:31:34 -0700
Message-ID: <1a66053c-8ece-8ffd-1e33-c301c53c4d45@intel.com>
Date:   Tue, 25 Apr 2023 15:31:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/6] KVM: VMX: Add new ops in kvm_x86_ops for LASS
 violation check
Content-Language: en-US
To:     "Gao, Chao" <chao.gao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230420133724.11398-1-guang.zeng@intel.com>
 <20230420133724.11398-3-guang.zeng@intel.com> <ZEdEmHFgHut2tDwf@chao-email>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <ZEdEmHFgHut2tDwf@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/25/2023 11:10 AM, Gao, Chao wrote:
> On Thu, Apr 20, 2023 at 09:37:20PM +0800, Zeng Guang wrote:
>> +/*
>> + * Determine whether an access to the linear address causes a LASS violation.
>> + * LASS protection is only effective in long mode. As a prerequisite, caller
>> + * should make sure VM running in long mode and invoke this api to do LASS
>> + * violation check.
> Could you place the comment above vmx_check_lass()?
>
> And for __vmx_check_lass(), just add:
>
> A variant of vmx_check_lass() without the check for long mode.
>
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
>
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
> to reduce one level of indentation, how about:
>
> 	if (user_mode == user_as)
> 		return false;
>
> 	/*
> 	 * Supervisor-mode _data_ accesses to user address space
> 	 * cause LASS violations only if SMAP is enabled.
> 	 */
> 	if (!user_mode && !(access & PFERR_FETCH_MASK)) {
> 		return kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP) && !rflags_ac;
>
> 	return true;
>
Looks better.


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
> Why not request all callers to check if vcpu is in long mode?
>
> e.g.,
> 	return is_long_mode(vcpu) && static_call(kvm_x86_check_lass)(...);
>
> then you can rename __vmx_check_lass() to vmx_check_lass() and drop the
> original one.
By design, __vmx_check_lass() is standalone to be used for checking LASS
violation only. In some cases, cpu mode is already identified prior to 
performing
LASS protection. please refer to patch 4. So we provide two interfaces,
vmx_check_lass() with cpu mode check wrapped for other modules usage, e.g.
kvm emulator and __vmx_check_lass() dedicated for VMX.

I would check the feasibility to re-organize code to be more optimal.

Thanks.
>> +}
>> +
>> static struct kvm_x86_ops vmx_x86_ops __initdata = {
>> 	.name = "kvm_intel",
>>
>> @@ -8207,6 +8260,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>> 	.complete_emulated_msr = kvm_complete_insn_gp,
>>
>> 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
>> +
>> +	.check_lass = vmx_check_lass,
>> };
>>
>> static unsigned int vmx_handle_intel_pt_intr(void)
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index a3da84f4ea45..6569385a5978 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -433,6 +433,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
>> u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
>> u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
>>
>> +bool __vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u64 flags);
>> +
> no one uses this function. You can defer exporting it to when the first
> external caller is added.
>
>> static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
>> 					     int type, bool value)
>> {
>> -- 
>> 2.27.0
>>
