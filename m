Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4604C7408C6
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 05:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjF1DFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 23:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjF1DFO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 23:05:14 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BD8198D;
        Tue, 27 Jun 2023 20:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687921513; x=1719457513;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Zaq3OOsIpwxFD0duGvBwzCZgmKFZL5Qq3Hg4+ACKgtE=;
  b=VnnTvE7iQHpBjmY/XLbr1kHSzVW6YrTX/XrwyrqCoh8LubmEHRhyzHKZ
   IATvAW3UwgmAsq6/U1S7gLiBpB54bEIRFNOJ8i8yZAh2i7Uv6nRN3R2b8
   FoZSP2Ce5joPIMw7in6qC/xQ4T+Ln9HacVrmH3O8a+laiWlxZBHIqMbbb
   GQ+Z5FXceEDbnX+Orx+zsDd9NpACLS10pm+ON89afIKnSjiMC25hRuB44
   5EIsto1SU3atQuArRofSiVa/751nuZCBf9Xds9SoqS6sfLn8OvwEg8Otd
   5gdVpb9tAJZ/vvxHMLTeirmAYAlJpflieNx7F/LOjrDtx0wA2dop97GYp
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="425407031"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="425407031"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 20:05:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="840908142"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="840908142"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.9.27]) ([10.238.9.27])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 20:05:09 -0700
Message-ID: <e11e348c-3763-8eda-281d-c8d965cd52b6@linux.intel.com>
Date:   Wed, 28 Jun 2023 11:05:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v9 3/6] KVM: x86: Virtualize CR3.LAM_{U48,U57}
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
 <20230606091842.13123-4-binbin.wu@linux.intel.com>
 <ZJtzdftocuwTvp67@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZJtzdftocuwTvp67@google.com>
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



On 6/28/2023 7:40 AM, Sean Christopherson wrote:
> On Tue, Jun 06, 2023, Binbin Wu wrote:
>> Opportunistically use GENMASK_ULL() to define __PT_BASE_ADDR_MASK.
> This are not the type of changes to do opportunstically.   Opportunstic changes
> are things like fixing comment typos, dropping unnecessary semi-colons, fixing
> coding styles violations, etc.

OK, thanks for the education.
>
>> Opportunistically use kvm_vcpu_is_legal_cr3() to check CR3 in SVM nested code,
>> to provide a clear distinction b/t CR3 and GPA checks.
> This *shouldn't* be an opportunsitic thing.  That you felt compelled to call it
> out is a symptom of this patch doing too much.
>
> In short, split this into three patches:
>
>    1. Do the __PT_BASE_ADDR_MASK() changes
>    2. Add and use kvm_vcpu_is_legal_cr3()
>    3. Add support for CR3.LAM bits
Will do that, thanks.

>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>> Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>> Reviewed-by: Kai Huang <kai.huang@intel.com>
>> Reviewed-by: Chao Gao <chao.gao@intel.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h | 5 +++++
>>   arch/x86/kvm/cpuid.h            | 5 +++++
>>   arch/x86/kvm/mmu.h              | 5 +++++
>>   arch/x86/kvm/mmu/mmu.c          | 8 +++++++-
>>   arch/x86/kvm/mmu/mmu_internal.h | 1 +
>>   arch/x86/kvm/mmu/paging_tmpl.h  | 3 ++-
>>   arch/x86/kvm/mmu/spte.h         | 2 +-
>>   arch/x86/kvm/svm/nested.c       | 4 ++--
>>   arch/x86/kvm/vmx/nested.c       | 4 ++--
>>   arch/x86/kvm/vmx/vmx.c          | 8 +++++++-
>>   arch/x86/kvm/x86.c              | 4 ++--
>>   11 files changed, 39 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index c6f03d151c31..46471dd9cc1b 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -727,6 +727,11 @@ struct kvm_vcpu_arch {
>>   	unsigned long cr0_guest_owned_bits;
>>   	unsigned long cr2;
>>   	unsigned long cr3;
>> +	/*
>> +	 * CR3 non-address feature control bits.
>> +	 * Guest CR3 may contain any of those bits at runtime.
>> +	 */
>> +	u64 cr3_ctrl_bits;
> This should be an "unsigned long".
>
> Hmm, "ctrl_bits" is unnecessarily generic at this point.  It's also arguably wrong,
> because X86_CR3_PCID_NOFLUSH is also a control bit, it's just allowed in CR3 itself.
>
> I think I'd prefer to drop this field and avoid bikeshedding the name entirely.  The
> only reason to effectively cache "X86_CR3_LAM_U48 | X86_CR3_LAM_U57" is because
> guest_cpuid_has() is slow, and I'd rather solve that problem with the "governed
> feature" framework.
Thanks for the suggestion.

Is the below patch the lastest patch of "governed feature" framework 
support?
https://lore.kernel.org/kvm/20230217231022.816138-2-seanjc@google.com/

Do you have plan to apply it to kvm-x86 repo?

>
> More below.
>
>>   	unsigned long cr4;
>>   	unsigned long cr4_guest_owned_bits;
>>   	unsigned long cr4_guest_rsvd_bits;
>> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
>> index b1658c0de847..ef8e1b912d7d 100644
>> --- a/arch/x86/kvm/cpuid.h
>> +++ b/arch/x86/kvm/cpuid.h
>> @@ -42,6 +42,11 @@ static inline int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
>>   	return vcpu->arch.maxphyaddr;
>>   }
>>   
>> +static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> Heh, I think it makes sense to wrap this one.  I'll probably tell you differently
> tomorrow, but today, let's wrap.
>
>> +{
>> +	return !((cr3 & vcpu->arch.reserved_gpa_bits) & ~vcpu->arch.cr3_ctrl_bits);
> Don't open code something for which there is a perfect helper, i.e. use
> kvm_vcpu_is_legal_gpa().
I didn't use the helper because after masking the control bits (LAM 
bits), CR3 is not  a GPA conceptally,
i.e, it contains PCID or PWT/PCD in lower bits.
But maybe this is my overthinking？Will use the helper instead.

>
> If we go the governed feature route, this becomes:
>
> static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu,
> 					 unsigned long cr3)
> {
> 	if (guest_can_use(vcpu, X86_FEATURE_LAM))
> 		cr3 &= ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
>
> 	return kvm_vcpu_is_legal_gpa(cr3);
> }
>
>> +}
>> +
>>   static inline bool kvm_vcpu_is_legal_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
>>   {
>>   	return !(gpa & vcpu->arch.reserved_gpa_bits);
>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>> index 92d5a1924fc1..81d8a433dae1 100644
>> --- a/arch/x86/kvm/mmu.h
>> +++ b/arch/x86/kvm/mmu.h
>> @@ -144,6 +144,11 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
>>   	return kvm_get_pcid(vcpu, kvm_read_cr3(vcpu));
>>   }
>>   
>> +static inline u64 kvm_get_active_cr3_ctrl_bits(struct kvm_vcpu *vcpu)
> And then this becomes:
>
> static inline u64 kvm_get_active_cr3_lam_bits(struct kvm_vcpu *vcpu)
> {
> 	if (!guest_can_use(vcpu, X86_FEATURE_LAM))
> 		return 0;
>
> 	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
> }
>
>> +{
>> +	return kvm_read_cr3(vcpu) & vcpu->arch.cr3_ctrl_bits;
>> +}
>> +
>>   static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>>   {
>>   	u64 root_hpa = vcpu->arch.mmu->root.hpa;
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index c8961f45e3b1..deea9a9f0c75 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -3812,7 +3812,13 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>>   	hpa_t root;
>>   
>>   	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
>> -	root_gfn = root_pgd >> PAGE_SHIFT;
>> +	/*
>> +	 * Guest PGD can be CR3 or EPTP (for nested EPT case). CR3 may contain
>> +	 * additional control bits (e.g. LAM control bits). To be generic,
>> +	 * unconditionally strip non-address bits when computing the GFN since
>> +	 * the guest PGD has already been checked for validity.
>> +	 */
> Drop this comment, the code is self-explanatory, and the comment is incomplete,
> e.g. it can also be nCR3.
I was trying to use CR3 for both nested/non-nested cases. Sorry for the 
confusion.
Anyway, will drop the comment.


>
>> +	root_gfn = (root_pgd & __PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
>>   
>>   	if (mmu_check_root(vcpu, root_gfn))
>>   		return 1;
>> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
>> index d39af5639ce9..7d2105432d66 100644
>> --- a/arch/x86/kvm/mmu/mmu_internal.h
>> +++ b/arch/x86/kvm/mmu/mmu_internal.h
>> @@ -21,6 +21,7 @@ extern bool dbg;
>>   #endif
>>   
>>   /* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
>> +#define __PT_BASE_ADDR_MASK GENMASK_ULL(51, 12)
>>   #define __PT_LEVEL_SHIFT(level, bits_per_level)	\
>>   	(PAGE_SHIFT + ((level) - 1) * (bits_per_level))
>>   #define __PT_INDEX(address, level, bits_per_level) \
>> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
>> index 0662e0278e70..394733ac9088 100644
>> --- a/arch/x86/kvm/mmu/paging_tmpl.h
>> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
>> @@ -62,7 +62,7 @@
>>   #endif
>>   
>>   /* Common logic, but per-type values.  These also need to be undefined. */
>> -#define PT_BASE_ADDR_MASK	((pt_element_t)(((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1)))
>> +#define PT_BASE_ADDR_MASK	((pt_element_t)__PT_BASE_ADDR_MASK)
>>   #define PT_LVL_ADDR_MASK(lvl)	__PT_LVL_ADDR_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
>>   #define PT_LVL_OFFSET_MASK(lvl)	__PT_LVL_OFFSET_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
>>   #define PT_INDEX(addr, lvl)	__PT_INDEX(addr, lvl, PT_LEVEL_BITS)
>> @@ -324,6 +324,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>>   	trace_kvm_mmu_pagetable_walk(addr, access);
>>   retry_walk:
>>   	walker->level = mmu->cpu_role.base.level;
>> +	/* gpte_to_gfn() will strip non-address bits. */
> Drop this comment too, it's not relevant to the immediate code, i.e. it'd be
> better suited about this code:
>
> 	table_gfn = gpte_to_gfn(pte);
>
> but IMO that code is quite self-explanatory too.

OK, thanks.
>
>> @@ -7740,6 +7741,11 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>   		vmx->msr_ia32_feature_control_valid_bits &=
>>   			~FEAT_CTL_SGX_LC_ENABLED;
>>   
>> +	if (guest_cpuid_has(vcpu, X86_FEATURE_LAM))
> This is wrong, KVM needs to check that the host supports LAM too, otherwise KVM
> will allow userspace to shove garbage into guest CR3 and induce VM-Entry failures
> and whatnot.
Right, will fix it.

>    If we go the guest_can_use() route, this problem solves itself.

