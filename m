Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4E66E716F
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 05:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbjDSDIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 23:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjDSDIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 23:08:31 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E5E55AC
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 20:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681873705; x=1713409705;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Zs1G9LMBKCjyI/MwbevTCYfqt/5iuxiJhT5qBfEmldQ=;
  b=JxhrKTlcpdsRfrj/XZjflR4xx5+hu1nYsPu/08Kex2elucjKNSRBWyNp
   Is2RE1QTM7xjUBqXZNbjJM181aXfo2BEzmdwCJuSBfRBDdoNqNQPH5CNG
   D6F5GNh1ESmSJS/IJKmPrfxKAzYCzvTSmfWEZeJofWYY19zcTOfC9aDFE
   pzSBEDykxOdYiA1mGCA4WUUrRPitwpHyzmC0YUHmrGOBv7YbKuBibgQfO
   utVKlggwPZxSmk0XEdjnnImuce94EBp2znNoPLfOXdaO2Eq6MNZB5GddT
   Y3Jmh/pek2vF0VmCra0aRh1SQL+jnvorKL7oyVdJUNBEcTNLCUg5l5sVH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="347195447"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="347195447"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 20:08:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="723904436"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="723904436"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.174.176]) ([10.249.174.176])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 20:08:17 -0700
Message-ID: <e572c85a-02d8-9547-f1a5-f986aa6b4e14@linux.intel.com>
Date:   Wed, 19 Apr 2023 11:08:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 3/5] KVM: x86: Introduce untag_addr() in kvm_x86_ops
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        kai.huang@intel.com, xuelian.guo@intel.com,
        robert.hu@linux.intel.com
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-4-binbin.wu@linux.intel.com>
 <ZD9SMgA2h8XUXsBw@chao-env>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZD9SMgA2h8XUXsBw@chao-env>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/19/2023 10:30 AM, Chao Gao wrote:
> On Tue, Apr 04, 2023 at 09:09:21PM +0800, Binbin Wu wrote:
>> Introduce a new interface untag_addr() to kvm_x86_ops to untag the metadata
> >from linear address. Implement LAM version in VMX and dummy version in SVM.
>> When enabled feature like Intel Linear Address Masking or AMD Upper
>> Address Ignore, linear address may be tagged with metadata. Linear
>> address should be checked for modified canonicality and untagged in
>> instrution emulations or vmexit handlings if LAM or UAI is applicable.
>>
>> Introduce untag_addr() to kvm_x86_ops to hide the code related to vendor
>> specific details.
>> - For VMX, LAM version is implemented.
>>   LAM has a modified canonical check when applicable:
>>   * LAM_S48                : [ 1 ][ metadata ][ 1 ]
>>                                63               47
>>   * LAM_U48                : [ 0 ][ metadata ][ 0 ]
>>                                63               47
>>   * LAM_S57                : [ 1 ][ metadata ][ 1 ]
>>                                63               56
>>   * LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
>>                                63               56
>>   * LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
>>                                63               56..47
>>   If LAM is applicable to certain address, untag the metadata bits and
>>   replace them with the value of bit 47 (LAM48) or bit 56 (LAM57). Later
>>   the untagged address will do legacy canonical check. So that LAM canonical
>>   check and mask can be covered by "untag + legacy canonical check".
>>
>>   For cases LAM is not applicable, 'flags' is passed to the interface
>>   to skip untag.
> The "flags" can be dropped. Callers can simply skip the call of .untag_addr().

OK.

The "flags" was added for proof of future if such kind of untag is also 
adopted in svm for AMD.

The cases to skip untag are different on the two vendor platforms.

But still, it is able to get the information in __linearize(), I will 
drop the parameter.



>
>> - For SVM, add a dummy version to do nothing, but return the original
>>   address.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>> ---
>> arch/x86/include/asm/kvm-x86-ops.h |  1 +
>> arch/x86/include/asm/kvm_host.h    |  5 +++
>> arch/x86/kvm/svm/svm.c             |  7 ++++
>> arch/x86/kvm/vmx/vmx.c             | 60 ++++++++++++++++++++++++++++++
>> arch/x86/kvm/vmx/vmx.h             |  2 +
>> 5 files changed, 75 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
>> index 8dc345cc6318..7d63d1b942ac 100644
>> --- a/arch/x86/include/asm/kvm-x86-ops.h
>> +++ b/arch/x86/include/asm/kvm-x86-ops.h
>> @@ -52,6 +52,7 @@ KVM_X86_OP(cache_reg)
>> KVM_X86_OP(get_rflags)
>> KVM_X86_OP(set_rflags)
>> KVM_X86_OP(get_if_flag)
>> +KVM_X86_OP(untag_addr)
>> KVM_X86_OP(flush_tlb_all)
>> KVM_X86_OP(flush_tlb_current)
>> KVM_X86_OP_OPTIONAL(tlb_remote_flush)
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 498d2b5e8dc1..cb674ec826d4 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -69,6 +69,9 @@
>> #define KVM_X86_NOTIFY_VMEXIT_VALID_BITS	(KVM_X86_NOTIFY_VMEXIT_ENABLED | \
>> 						 KVM_X86_NOTIFY_VMEXIT_USER)
>>
>> +/* flags for kvm_x86_ops::untag_addr() */
>> +#define KVM_X86_UNTAG_ADDR_SKIP_LAM	_BITULL(0)
>> +
>> /* x86-specific vcpu->requests bit members */
>> #define KVM_REQ_MIGRATE_TIMER		KVM_ARCH_REQ(0)
>> #define KVM_REQ_REPORT_TPR_ACCESS	KVM_ARCH_REQ(1)
>> @@ -1607,6 +1610,8 @@ struct kvm_x86_ops {
>> 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
>> 	bool (*get_if_flag)(struct kvm_vcpu *vcpu);
>>
>> +	u64 (*untag_addr)(struct kvm_vcpu *vcpu, u64 la, u64 flags);
>> +
>> 	void (*flush_tlb_all)(struct kvm_vcpu *vcpu);
>> 	void (*flush_tlb_current)(struct kvm_vcpu *vcpu);
>> 	int  (*tlb_remote_flush)(struct kvm *kvm);
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 252e7f37e4e2..a6e6bd09642b 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -4696,6 +4696,11 @@ static int svm_vm_init(struct kvm *kvm)
>> 	return 0;
>> }
>>
>> +static u64 svm_untag_addr(struct kvm_vcpu *vcpu, u64 addr, u64 flags)
>> +{
>> +	return addr;
>> +}
>> +
>> static struct kvm_x86_ops svm_x86_ops __initdata = {
>> 	.name = KBUILD_MODNAME,
>>
>> @@ -4745,6 +4750,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>> 	.set_rflags = svm_set_rflags,
>> 	.get_if_flag = svm_get_if_flag,
>>
>> +	.untag_addr = svm_untag_addr,
>> +
>> 	.flush_tlb_all = svm_flush_tlb_current,
>> 	.flush_tlb_current = svm_flush_tlb_current,
>> 	.flush_tlb_gva = svm_flush_tlb_gva,
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 4d329ee9474c..73cc495bd0da 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -8137,6 +8137,64 @@ static void vmx_vm_destroy(struct kvm *kvm)
>> 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
>> }
>>
>> +
>> +#define LAM_S57_EN_MASK (X86_CR4_LAM_SUP | X86_CR4_LA57)
>> +
>> +static inline int lam_sign_extend_bit(bool user, struct kvm_vcpu *vcpu)
> Drop "inline" and let compilers decide whether to inline the function.
>
> And it is better to swap the two parameters to align with the conversion
> in kvm.


OK.

>
>> +{
>> +	u64 cr3, cr4;
>> +
>> +	if (user) {
>> +		cr3 = kvm_read_cr3(vcpu);
>> +		if (!!(cr3 & X86_CR3_LAM_U57))
> It is weird to use double negation "!!" in if statements. I prefer to drop it.

OK.

Have a check on the current code, there are such usages in some driver 
code, but no such usage in kvm-x86 code.

Will drop it.


>
>> +			return 56;
>> +		if (!!(cr3 & X86_CR3_LAM_U48))
>> +			return 47;
>> +	} else {
>> +		cr4 = kvm_read_cr4_bits(vcpu, LAM_S57_EN_MASK);
>> +		if (cr4 == LAM_S57_EN_MASK)
>> +			return 56;
>> +		if (!!(cr4 & X86_CR4_LAM_SUP))
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
>> + */
>> +u64 vmx_untag_addr(struct kvm_vcpu *vcpu, u64 addr, u64 flags)
>> +{
>> +	int sign_ext_bit;
>> +
>> +	/*
>> +	 * Instead of calling relatively expensive guest_cpuid_has(), just check
>> +	 * LAM_U48 in cr3_ctrl_bits. If not set, vCPU doesn't supports LAM.
>> +	 */
>> +	if (!(vcpu->arch.cr3_ctrl_bits & X86_CR3_LAM_U48) ||
>> +	    !!(flags & KVM_X86_UNTAG_ADDR_SKIP_LAM))
>> +		return addr;
>> +
>> +	if(!is_64_bit_mode(vcpu)){
>> +		WARN_ONCE(1, "Only be called in 64-bit mode");
> use WARN_ON_ONCE() in case it can be triggered by guests, i.e.,
>
> if (WARN_ON_ONCE(!is_64_bit_mode(vcpu))
> 	return addr;


OK.

>
>> +		return addr;
>> +	}
>> +
>> +	sign_ext_bit = lam_sign_extend_bit(!(addr >> 63), vcpu);
>> +
>> +	if (sign_ext_bit < 0)
>> +		return addr;
>> +
>> +	return (sign_extend64(addr, sign_ext_bit) & ~BIT_ULL(63)) |
>> +	       (addr & BIT_ULL(63));
>> +}
>> +
>> static struct kvm_x86_ops vmx_x86_ops __initdata = {
>> 	.name = KBUILD_MODNAME,
>>
>> @@ -8185,6 +8243,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>> 	.set_rflags = vmx_set_rflags,
>> 	.get_if_flag = vmx_get_if_flag,
>>
>> +	.untag_addr = vmx_untag_addr,
>> +
>> 	.flush_tlb_all = vmx_flush_tlb_all,
>> 	.flush_tlb_current = vmx_flush_tlb_current,
>> 	.flush_tlb_gva = vmx_flush_tlb_gva,
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index 2acdc54bc34b..79855b9a4aca 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -433,6 +433,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
>> u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
>> u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
>>
>> +u64 vmx_untag_addr(struct kvm_vcpu *vcpu, u64 addr, u64 flags);
>> +
>> static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
>> 					     int type, bool value)
>> {
>> -- 
>> 2.25.1
>>
