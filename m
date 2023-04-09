Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7686DBFAB
	for <lists+kvm@lfdr.de>; Sun,  9 Apr 2023 13:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjDILgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Apr 2023 07:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDILgw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Apr 2023 07:36:52 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96D040E9
        for <kvm@vger.kernel.org>; Sun,  9 Apr 2023 04:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681040210; x=1712576210;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=97Hk01mJUaoJLqEwiP1id/k88Z4ABr1sydW7Py4AgBs=;
  b=FRvAJsmTzMcDyz+pE3yWZHacGSuAn7bKePcH9cj6oRrmLhRlf1XucoAv
   pdQOglwxZvqG3DNbG+kaM5IvoTslRB5afzNv2IfGmZAfd5WKin4el5TsS
   lapC8uftOESVAprMg4mxZubJfrfsqxOUsnx4ce/3WVGM7ivVSR7qnrC+Q
   LQuDJGT5pIea767YEIdA/20jb0HWB9NNct/sCogfM6WLNWtiW1Pe1TBWu
   I9HayEMCAdvUYkHjj6tBGFZfkBAHjvhFmXXzcFTAHURIq4lPi+MGOWQ+q
   uHZtCZaJ3qVpRSgTfv9YcnNjkoYyklCNWp/GTxelW6VULrf8bMULhbt6u
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10674"; a="408350823"
X-IronPort-AV: E=Sophos;i="5.98,331,1673942400"; 
   d="scan'208";a="408350823"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2023 04:36:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10674"; a="757189718"
X-IronPort-AV: E=Sophos;i="5.98,331,1673942400"; 
   d="scan'208";a="757189718"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.215.45]) ([10.254.215.45])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2023 04:36:48 -0700
Message-ID: <99f7b894-ff4b-0a6d-be58-a0966d30e622@linux.intel.com>
Date:   Sun, 9 Apr 2023 19:36:46 +0800
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
 <c3f62d20ac624f36723d41438b8eefedc413eb62.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <c3f62d20ac624f36723d41438b8eefedc413eb62.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/6/2023 8:57 PM, Huang, Kai wrote:
> On Tue, 2023-04-04 at 21:09 +0800, Binbin Wu wrote:
>> From: Robert Hoo <robert.hu@linux.intel.com>
>>
>> LAM uses CR3.LAM_U48 (bit 62) and CR3.LAM_U57 (bit 61) to configure LAM
>> masking for user mode pointers.
>>
>> When EPT is on:
>> CR3 is fully under control of guest, guest LAM is thus transparent to KVM.
>>
>> When EPT is off (shadow paging):
>> - KVM needs to handle guest CR3.LAM_U48 and CR3.LAM_U57 toggles.
>>    The two bits are allowed to be set in CR3 if vCPU supports LAM.
>>    The two bits should be kept as they are in the shadow CR3.
>> - Perform GFN calculation from guest CR3/PGD generically by extracting the
>>    maximal base address mask since the validity has been checked already.
>> - Leave LAM bits in root.pgd to force a new root for a CR3+LAM combination.
>>    It could potentially increase root cache misses and mmu reload, however,
>>    it's very rare to turn off EPT when performace matters.
>>
>> To be generic, introduce a field 'cr3_ctrl_bits' in kvm_vcpu_arch to record
>> the bits used to control supported features related to CR3 (e.g. LAM).
>> - Supported control bits are set to cr3_ctrl_bits after set cpuid.
>> - Add kvm_vcpu_is_legal_cr3() to validate CR3, tp allow setting of control
> 						 ^
> 						 to ?
> Could you run spell check for all patches?


OK, thanks for your advice.

>
>>    bits for the supported features.
>> - Add kvm_get_active_cr3_ctrl_bits() to get the active control bits to form
>>    a new guest CR3 (in vmx_load_mmu_pgd()).
> KVM handles #PF for shadow MMU, and for TDP (EPT) there's also a case that KVM
> will trap the #PF (see allow_smaller_maxphyaddr).  Do we need any handling to
> the linear address in the #PF, i.e. stripping metadata off while walking page
> table?
>
> I guess it's already done automatically?  Anyway, IMO it would be better if you
> can add one or two sentences in the changelog to clarify whether such handling
> is needed, and if not, why.

LAM masking applies before paging, so the faulting linear address 
doesn't contain the metadata.
It has been mentioned in cover letter, but to be clear, I will add the 
clarification in the changelog
of patch 4.

Thanks.


>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>> Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h | 6 ++++++
>>   arch/x86/kvm/cpuid.h            | 5 +++++
>>   arch/x86/kvm/mmu.h              | 5 +++++
>>   arch/x86/kvm/mmu/mmu.c          | 6 +++++-
>>   arch/x86/kvm/mmu/mmu_internal.h | 1 +
>>   arch/x86/kvm/mmu/paging_tmpl.h  | 6 +++++-
>>   arch/x86/kvm/mmu/spte.h         | 2 +-
>>   arch/x86/kvm/vmx/nested.c       | 4 ++--
>>   arch/x86/kvm/vmx/vmx.c          | 6 +++++-
>>   arch/x86/kvm/x86.c              | 4 ++--
>>   10 files changed, 37 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index ba594f9ea414..498d2b5e8dc1 100644
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
>> +	root_gfn = (root_pgd & __PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
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
>>   	pte           = mmu->get_guest_pgd(vcpu);
>>   	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
>>   
>> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
>> index 1279db2eab44..777f7d443e3b 100644
>> --- a/arch/x86/kvm/mmu/spte.h
>> +++ b/arch/x86/kvm/mmu/spte.h
>> @@ -36,7 +36,7 @@ static_assert(SPTE_TDP_AD_ENABLED == 0);
>>   #ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
>>   #define SPTE_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
>>   #else
>> -#define SPTE_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
>> +#define SPTE_BASE_ADDR_MASK __PT_BASE_ADDR_MASK
>>   #endif
>>   
>>   #define SPTE_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask \
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 1bc2b80273c9..d35bda9610e2 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -1079,7 +1079,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
>>   			       bool nested_ept, bool reload_pdptrs,
>>   			       enum vm_entry_failure_code *entry_failure_code)
>>   {
>> -	if (CC(kvm_vcpu_is_illegal_gpa(vcpu, cr3))) {
>> +	if (CC(!kvm_vcpu_is_legal_cr3(vcpu, cr3))) {
>>   		*entry_failure_code = ENTRY_FAIL_DEFAULT;
>>   		return -EINVAL;
>>   	}
>> @@ -2907,7 +2907,7 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>>   
>>   	if (CC(!nested_host_cr0_valid(vcpu, vmcs12->host_cr0)) ||
>>   	    CC(!nested_host_cr4_valid(vcpu, vmcs12->host_cr4)) ||
>> -	    CC(kvm_vcpu_is_illegal_gpa(vcpu, vmcs12->host_cr3)))
>> +	    CC(!kvm_vcpu_is_legal_cr3(vcpu, vmcs12->host_cr3)))
>>   		return -EINVAL;
>>   
>>   	if (CC(is_noncanonical_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 42f163862a0f..4d329ee9474c 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -3388,7 +3388,8 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>>   			update_guest_cr3 = false;
>>   		vmx_ept_load_pdptrs(vcpu);
>>   	} else {
>> -		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu);
>> +		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu) |
>> +		            kvm_get_active_cr3_ctrl_bits(vcpu);
>>   	}
>>   
>>   	if (update_guest_cr3)
>> @@ -7763,6 +7764,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>   		vmx->msr_ia32_feature_control_valid_bits &=
>>   			~FEAT_CTL_SGX_LC_ENABLED;
>>   
>> +	if (guest_cpuid_has(vcpu, X86_FEATURE_LAM))
>> +		vcpu->arch.cr3_ctrl_bits |= X86_CR3_LAM_U48 | X86_CR3_LAM_U57;
>> +
>>   	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>>   	vmx_update_exception_bitmap(vcpu);
>>   }
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 7713420abab0..aca255e69d0d 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1260,7 +1260,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>>   	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
>>   	 * the current vCPU mode is accurate.
>>   	 */
>> -	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
>> +	if (!kvm_vcpu_is_legal_cr3(vcpu, cr3))
>>   		return 1;
>>   
>>   	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
>> @@ -11349,7 +11349,7 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>>   		 */
>>   		if (!(sregs->cr4 & X86_CR4_PAE) || !(sregs->efer & EFER_LMA))
>>   			return false;
>> -		if (kvm_vcpu_is_illegal_gpa(vcpu, sregs->cr3))
>> +		if (!kvm_vcpu_is_legal_cr3(vcpu, sregs->cr3))
>>   			return false;
>>   	} else {
>>   		/*
