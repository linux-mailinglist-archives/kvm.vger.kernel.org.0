Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2416E03C3
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 03:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDMBgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 21:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDMBgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 21:36:38 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3C440C4
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 18:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681349796; x=1712885796;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=biaxn7tSTN5sAui43tuSDdDeoPYS/uRSa2Y7Kn2zS3A=;
  b=J6AhtJXVh05EdIM8KbI3Nax0hk8MTbNi/Y3ogzSe7/4CBV22ZkLuevjC
   HFqDaEiQK5hmROsaBZkJGVJ7og/iQ9qgZqapX0nla+Qgev37Ut+RORX8m
   oA0qVh4rcQ3LUkFXfxpc8WsvGS9pU7W0/Ji8hOHNln9ATgF1KABh5Y2Mp
   5xk9FZtTXXdFCKMZv+FaPt2izrE5XFP6QBGQ2N2zSo7TL65T7y/b0NLlZ
   ErXtC9i40kNTdJOAH/jrWYz6oZCoAqhDmBp3mfa9Ws7Uoyp0rBMdo/vhQ
   Yl6lE6X2T76m4d1jgiFbKidACMuGezD1lnzIQXxhBebs8YbSISxhdD+Y9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="371914264"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="371914264"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 18:36:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="639446679"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="639446679"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.125]) ([10.238.8.125])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 18:36:34 -0700
Message-ID: <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
Date:   Thu, 13 Apr 2023 09:36:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Cc:     "Guo, Xuelian" <xuelian.guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-3-binbin.wu@linux.intel.com>
 <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/12/2023 7:58 PM, Huang, Kai wrote:
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -729,6 +729,12 @@ struct kvm_vcpu_arch {
>>   	unsigned long cr0_guest_owned_bits;
>>   	unsigned long cr2;
>>   	unsigned long cr3;
>> +	/*
>> +	 * Bits in CR3 used to enable certain features. These bits are allowed
>> +	 * to be set in CR3 when vCPU supports the features. When shadow paging
>> +	 * is used, these bits should be kept as they are in the shadow CR3.
>> +	 */
> I don't quite follow the second sentence.  Not sure what does "these bits should
> be kept" mean.
>
> Those control bits are not active bits in guest's CR3 but all control bits that
> guest is allowed to set to CR3. And those bits depends on guest's CPUID but not
> whether guest is using shadow paging or not.
>
> I think you can just remove the second sentence.

Yes, you are right. The second sentenc is confusing.

How about this:

+	/*
+	 * Bits in CR3 used to enable certain features. These bits are allowed
+	 * to be set in CR3 when vCPU supports the features, and they are used
+	 * as the mask to get the active control bits to form a new guest CR3.
+	 */


>
>> +	u64 cr3_ctrl_bits;
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
>> +{
>> +	return !((cr3 & vcpu->arch.reserved_gpa_bits) & ~vcpu->arch.cr3_ctrl_bits);
>> +}
>> +
>>   static inline bool kvm_vcpu_is_legal_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
>>   {
>>   	return !(gpa & vcpu->arch.reserved_gpa_bits);
>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>> index 168c46fd8dd1..29985eeb8e12 100644
>> --- a/arch/x86/kvm/mmu.h
>> +++ b/arch/x86/kvm/mmu.h
>> @@ -142,6 +142,11 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
>>   	return kvm_get_pcid(vcpu, kvm_read_cr3(vcpu));
>>   }
>>   
>> +static inline u64 kvm_get_active_cr3_ctrl_bits(struct kvm_vcpu *vcpu)
>> +{
>> +	return kvm_read_cr3(vcpu) & vcpu->arch.cr3_ctrl_bits;
>> +}
>> +
>>   static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>>   {
>>   	u64 root_hpa = vcpu->arch.mmu->root.hpa;
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index c8ebe542c565..de2c51a0b611 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -3732,7 +3732,11 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>>   	hpa_t root;
>>   
>>   	root_pgd = mmu->get_guest_pgd(vcpu);
>> -	root_gfn = root_pgd >> PAGE_SHIFT;
>> +	/*
>> +	* The guest PGD has already been checked for validity, unconditionally
>> +	* strip non-address bits when computing the GFN.
>> +	*/

The comment here is to call out that the set non-address bit(s) have 
been checked for legality
before, it is safe to strip these bits.


> Don't quite follow this comment either.  Can we just say:
>
> 	/*
> 	 * Guest's PGD may contain additional control bits.  Mask them off
> 	 * to get the GFN.
> 	 */
>
> Which explains why it has "non-address bits" and needs mask off?

How about merge this comment?


>
>> +	root_gfn = (root_pgd & __PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
> Or, should we explicitly mask vcpu->arch.cr3_ctrl_bits?  In this way, below
> mmu_check_root() may potentially catch other invalid bits, but in practice there
> should be no difference I guess.

In previous version, vcpu->arch.cr3_ctrl_bits was used as the mask.

However, Sean pointed out that the return value of 
mmu->get_guest_pgd(vcpu) could be
EPTP for nested case, so it is not rational to mask to CR3 bit(s) from EPTP.

Since the guest pgd has been check for valadity, for both CR3 and EPTP, 
it is safe to mask off
non-address bits to get GFN.

Maybe I should add this CR3 VS. EPTP part to the changelog to make it 
more undertandable.



>
>>   
>>   	if (mmu_check_root(vcpu, root_gfn))
>>   		return 1;
>> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
>> index cc58631e2336..c0479cbc2ca3 100644
>> --- a/arch/x86/kvm/mmu/mmu_internal.h
>> +++ b/arch/x86/kvm/mmu/mmu_internal.h
>> @@ -21,6 +21,7 @@ extern bool dbg;
>>   #endif
>>   
>>   /* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
>> +#define __PT_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
>>   #define __PT_LEVEL_SHIFT(level, bits_per_level)	\
>>   	(PAGE_SHIFT + ((level) - 1) * (bits_per_level))
>>   #define __PT_INDEX(address, level, bits_per_level) \
>> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
>> index 57f0b75c80f9..88351ba04249 100644
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
>> @@ -324,6 +324,10 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>>   	trace_kvm_mmu_pagetable_walk(addr, access);
>>   retry_walk:
>>   	walker->level = mmu->cpu_role.base.level;
>> +	/*
>> +	 * No need to mask cr3_ctrl_bits, gpte_to_gfn() will strip
>> +	 * non-address bits.
>> +	 */
> I guess it will be helpful if we actually call out that guest's PGD may contain
> control bits here.

OK.


>
> Also, I am not sure whether it's better to just explicitly mask control bits off
> here.

Same reason as mention above.


>
>>   	pte           = mmu->get_guest_pgd(vcpu);
>>   	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
>>   
>>
> [...]
