Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32B26FEE90
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 11:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237680AbjEKJTu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 05:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237513AbjEKJTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 05:19:21 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15E07EF4;
        Thu, 11 May 2023 02:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683796717; x=1715332717;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=izGf/Vn8cCPgVluQqzhpqULCCQz7JRVql9Rar4he6Vc=;
  b=gyDEXZGM8AKXPMdIIne8wjN0eC5GF4b+QSC3zyAmgmReGhheetCXHRMK
   u37FTty7DzZHRh6PMk+yvaQZMMEOTdyQF27hGXPGyK6CBOpYVJl6DWEQq
   GllqOsixhvusDOSlopjsIhfH8TszUNgh2qBQeLik986Kl201IxI33BlJm
   wpTJfEwUt8scIFvzKMJ6bxN+KX0grF01r7rgEbq8X4SB1o+PQxomagwKX
   r721ASgx8Qu6JAdW0rZESVeiu6UqVrXrXUKFkxG1erAA+PV3b+xbqIdwf
   3ILSjNRrwIVpFwayR9fIhoE7zGsmFOZhAnnM8Pi9EUSOhI25XDRSbGvyy
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="330070872"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="330070872"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 02:18:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="699650061"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="699650061"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.90]) ([10.238.8.90])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 02:18:33 -0700
Message-ID: <a2ef5302-d27d-945e-3c67-0bc9855fc4a6@linux.intel.com>
Date:   Thu, 11 May 2023 17:18:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v8 4/6] KVM: x86: Introduce untag_addr() in kvm_x86_ops
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, kai.huang@intel.com,
        robert.hu@linux.intel.com
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
 <20230510060611.12950-5-binbin.wu@linux.intel.com>
 <ZFyFPOo2Fp+yVU2n@chao-email>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZFyFPOo2Fp+yVU2n@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/11/2023 2:03 PM, Chao Gao wrote:
> On Wed, May 10, 2023 at 02:06:09PM +0800, Binbin Wu wrote:
>> Introduce a new optional interface untag_addr() to kvm_x86_ops to untag
>> the metadata from linear address. Implement LAM version in VMX.
>>
>> When enabled feature like Intel Linear Address Masking or AMD Upper
>> Address Ignore, linear address may be tagged with metadata. Linear
>> address should be checked for modified canonicality and untagged in
>> instruction emulations or VMExit handlers if LAM or UAI is applicable.
>>
>> Introduce untag_addr() to kvm_x86_ops to hide the vendor specific code.
>> Pass the 'flags' to avoid distinguishing processor vendor in common emulator
>> path for the cases whose untag policies are different in the future.
>>
>
>> For VMX, LAM version is implemented.
>> LAM has a modified canonical check when applicable:
>> * LAM_S48                : [ 1 ][ metadata ][ 1 ]
>>                              63               47
>> * LAM_U48                : [ 0 ][ metadata ][ 0 ]
>>                              63               47
>> * LAM_S57                : [ 1 ][ metadata ][ 1 ]
>>                              63               56
>> * LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
>>                              63               56
>> * LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
>>                              63               56..47
>> LAM identification of an address as user or supervisor is based solely on
>> the value of pointer bit 63.
>> If LAM is applicable to certain address, untag the metadata bits by
>> sign-extending the value of bit 47 (LAM48) or bit 56 (LAM57). Later
>> the untagged address will do legacy canonical check. So that LAM canonical
>> check and mask can be covered by "untag + legacy canonical check".
> Do you think it is better to remove such details from the changelog and
> instead document them in comments e.g.,
>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>> ---
>> arch/x86/include/asm/kvm-x86-ops.h |  1 +
>> arch/x86/include/asm/kvm_host.h    |  2 ++
>> arch/x86/kvm/kvm_emulate.h         |  1 +
>> arch/x86/kvm/vmx/vmx.c             | 50 ++++++++++++++++++++++++++++++
>> arch/x86/kvm/vmx/vmx.h             |  2 ++
>> 5 files changed, 56 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
>> index 13bc212cd4bc..c0cebe671d41 100644
>> --- a/arch/x86/include/asm/kvm-x86-ops.h
>> +++ b/arch/x86/include/asm/kvm-x86-ops.h
>> @@ -52,6 +52,7 @@ KVM_X86_OP(cache_reg)
>> KVM_X86_OP(get_rflags)
>> KVM_X86_OP(set_rflags)
>> KVM_X86_OP(get_if_flag)
>> +KVM_X86_OP_OPTIONAL(untag_addr)
>> KVM_X86_OP(flush_tlb_all)
>> KVM_X86_OP(flush_tlb_current)
>> KVM_X86_OP_OPTIONAL(flush_remote_tlbs)
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 46471dd9cc1b..bfccc0e19bf2 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1588,6 +1588,8 @@ struct kvm_x86_ops {
>> 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
>> 	bool (*get_if_flag)(struct kvm_vcpu *vcpu);
>>
>> +	void (*untag_addr)(struct kvm_vcpu *vcpu, u64 *la, u32 flags);
>> +
>> 	void (*flush_tlb_all)(struct kvm_vcpu *vcpu);
>> 	void (*flush_tlb_current)(struct kvm_vcpu *vcpu);
>> 	int  (*flush_remote_tlbs)(struct kvm *kvm);
>> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
>> index 5b9ec610b2cb..c2091e24a6b9 100644
>> --- a/arch/x86/kvm/kvm_emulate.h
>> +++ b/arch/x86/kvm/kvm_emulate.h
>> @@ -91,6 +91,7 @@ struct x86_instruction_info {
>> /* x86-specific emulation flags */
>> #define X86EMUL_F_FETCH			BIT(0)
>> #define X86EMUL_F_WRITE			BIT(1)
>> +#define X86EMUL_F_SKIPLAM		BIT(2)
>>
>> struct x86_emulate_ops {
>> 	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 9c80048ca30c..b52e44758a4e 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -8134,6 +8134,54 @@ static void vmx_vm_destroy(struct kvm *kvm)
>> 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
>> }
>>
>> +#define LAM_S57_EN_MASK (X86_CR4_LAM_SUP | X86_CR4_LA57)
>> +static int lam_sign_extend_bit(struct kvm_vcpu *vcpu, bool user)
> we can let this function take an address ...
>
>> +{
>> +	u64 cr3, cr4;
>> +
> then it is natural to add the comment -- "LAM identification ...", like
>
> 	/*
> 	 * The LAM identification of a pointer as user or supervisor is
> 	 * based solely on the value of pointer bit 63.
> 	 */
> 	if (!(addr >> 63)) {
OK.

>
>> +	if (user) {
>> +		cr3 = kvm_read_cr3(vcpu);
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
>> +	}
>> +	return -1;
>> +}
>> +
>> +/*
>> + * Only called in 64-bit mode.
>> + *
>> + * Metadata bits are [62:48] in LAM48 and [62:57] in LAM57. Mask metadata in
>> + * pointers by sign-extending the value of bit 47 (LAM48) or 56 (LAM57).
>> + * The resulting address after untagging isn't guaranteed to be canonical.
>> + * Callers should perform the original canonical check and raise #GP/#SS if the
>> + * address is non-canonical.
> To document the difference between KVM's emulation of LAM and real hardware
> behavior:
>
>     *
>     * Note that KVM masks the metadata in addresses, performs the (original)
>     * canonicality checking and then walks page table. This is slightly
>     * different from hardware behavior but achieves the same effect.
>     * Specifically, if LAM is enabled, the processor performs a modified
>     * canonicality checking where the metadata are ignored instead of
>     * masked. After the modified canonicality checking, the processor masks
>     * the metadata before passing addresses for paging translation.
>     */
OK.


>
>> + */
>> +void vmx_untag_addr(struct kvm_vcpu *vcpu, u64 *la, u32 flags)
> 						  ^
> 					nit: "gla" or "gva" is slightly better.
> 					It may be hard to immediately
> 					connect "la" with "linear address".
>
> 					or even better, use "gva_t gva"?
Will update it to use "gva_t gva", thanks.

>> +{
>> +	int sign_ext_bit;
>> +
>> +	/*
>> +	 * Check LAM_U48 in cr3_ctrl_bits to avoid guest_cpuid_has().
>> +	 * If not set, vCPU doesn't supports LAM.
>> +	 */
>> +	if (!(vcpu->arch.cr3_ctrl_bits & X86_CR3_LAM_U48) ||
>> +	    (flags & X86EMUL_F_SKIPLAM) || WARN_ON_ONCE(!is_64_bit_mode(vcpu)))
>> +		return;
>> +
>> +	sign_ext_bit = lam_sign_extend_bit(vcpu, !(*la >> 63));
>> +	if (sign_ext_bit > 0)
>> +		*la = (sign_extend64(*la, sign_ext_bit) & ~BIT_ULL(63)) |
>> +		       (*la & BIT_ULL(63));
> nit: curly braces are needed.
Even if it's only one statement (although splited to two lines), curly 
braces are needed?

>
> Overall the patch looks good to me, so
>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
>
> (regardless of whether you choose to make the suggested changes to the
> changelog/comments)
>
>> +}
>> +
>> static struct kvm_x86_ops vmx_x86_ops __initdata = {
>> 	.name = KBUILD_MODNAME,
>>
>> @@ -8182,6 +8230,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>> 	.set_rflags = vmx_set_rflags,
>> 	.get_if_flag = vmx_get_if_flag,
>>
>> +	.untag_addr = vmx_untag_addr,
>> +
>> 	.flush_tlb_all = vmx_flush_tlb_all,
>> 	.flush_tlb_current = vmx_flush_tlb_current,
>> 	.flush_tlb_gva = vmx_flush_tlb_gva,
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index 9e66531861cf..e1e6d2e03b61 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -433,6 +433,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
>> u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
>> u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
>>
>> +void vmx_untag_addr(struct kvm_vcpu *vcpu, u64 *la, u32 flags);
>> +
>> static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
>> 					     int type, bool value)
>> {
>> -- 
>> 2.25.1
>>

