Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54F95A8DB3
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 07:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbiIAFyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 01:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbiIAFyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 01:54:50 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E03399;
        Wed, 31 Aug 2022 22:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662011685; x=1693547685;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Qshrz0MZX4bPw+/3Fxn3+/3CS6Rlp5Ib/DcDLDhZZdM=;
  b=N2K32Yi2z1tLhY3BZayZ4V6zIVqjPxYdTfDPN/zHIzq/rmroHn0yo5ze
   EpU3lgLKvmja6LC4c7msPKQCwlOCbp+YjQd5Iaxl8aNs1sWxlgMK1eaie
   NA795MEY2Fwu52qL70UNkYmOGQbSLt0QU669TGSIE5GustsqkT3HdqWDR
   6ZxhLB3Ma3zfmfvdF52mAonScJhn0kFGAq12Hi85rod1vb42FP1RZBrQi
   fdqQeswICSBQR+SGnMx3+TUclhn2vk2W7mED/Q6TdoPr8NRc+0g7mJHOj
   BbzZDi3pXH15YPj9kKxV/hU4TGcM0BvryZDjsMQDTmB4ZtTsUNpgT3meI
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="278641392"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="278641392"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 22:54:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="642180744"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga008.jf.intel.com with ESMTP; 31 Aug 2022 22:54:41 -0700
Date:   Thu, 1 Sep 2022 13:54:41 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 033/103] KVM: x86/mmu: Track shadow MMIO value/mask on
 a per-VM basis
Message-ID: <20220901055441.nefl6qzitpbwerbs@yy-desk-7060>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <c734925961e4c0b93125c4af81e887df531305c7.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c734925961e4c0b93125c4af81e887df531305c7.1659854790.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 07, 2022 at 03:01:18PM -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> TDX will use a different shadow PTE entry value for MMIO from VMX.  Add
> members to kvm_arch and track value for MMIO per-VM instead of global
> variables.  By using the per-VM EPT entry value for MMIO, the existing VMX
> logic is kept working.  To untangle the logic to initialize
> shadow_mmio_access_mask, introduce a separate setter function.
>
> At the same time, disallow MMIO emulation path for protected guest because
> VMM can't parse instructions in protected guest memory.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  4 +++
>  arch/x86/kvm/mmu.h              |  3 ++-
>  arch/x86/kvm/mmu/mmu.c          |  9 ++++---
>  arch/x86/kvm/mmu/spte.c         | 45 +++++++++------------------------
>  arch/x86/kvm/mmu/spte.h         | 10 +++-----
>  arch/x86/kvm/mmu/tdp_mmu.c      | 13 +++++++---
>  arch/x86/kvm/svm/svm.c          | 11 +++++---
>  arch/x86/kvm/vmx/vmx.c          | 26 +++++++++++++++++++
>  arch/x86/kvm/vmx/x86_ops.h      |  1 +
>  9 files changed, 70 insertions(+), 52 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6787d5214fd8..3c4051d4512b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1157,6 +1157,10 @@ struct kvm_arch {
>  	 */
>  	spinlock_t mmu_unsync_pages_lock;
>
> +	bool enable_mmio_caching;
> +	u64 shadow_mmio_value;
> +	u64 shadow_mmio_mask;
> +
>  	struct list_head assigned_dev_head;
>  	struct iommu_domain *iommu_domain;
>  	bool iommu_noncoherent;
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index df9f79ee07d4..dea9f2ed0177 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -98,7 +98,8 @@ static inline u8 kvm_get_shadow_phys_bits(void)
>  	return boot_cpu_data.x86_phys_bits;
>  }
>
> -void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
> +void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value, u64 mmio_mask);
> +void kvm_mmu_set_mmio_access_mask(u64 mmio_access_mask);
>  void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
>  void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 216708a433e7..88fc2218fcc3 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2418,7 +2418,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
>  				return kvm_mmu_prepare_zap_page(kvm, child,
>  								invalid_list);
>  		}
> -	} else if (is_mmio_spte(pte)) {
> +	} else if (is_mmio_spte(kvm, pte)) {
>  		mmu_spte_clear_no_track(spte);
>  	}
>  	return 0;
> @@ -3222,7 +3222,8 @@ static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fau
>  		 * and only if L1's MAXPHYADDR is inaccurate with respect to
>  		 * the hardware's).
>  		 */
> -		if (unlikely(!enable_mmio_caching) ||
> +		if (unlikely(!vcpu->kvm->arch.enable_mmio_caching &&
> +			     !kvm_gfn_shared_mask(vcpu->kvm)) ||
>  		    unlikely(fault->gfn > kvm_mmu_max_gfn()))
>  			return RET_PF_EMULATE;
>  	}
> @@ -4074,7 +4075,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>  	if (WARN_ON(reserved))
>  		return -EINVAL;
>
> -	if (is_mmio_spte(spte)) {
> +	if (is_mmio_spte(vcpu->kvm, spte)) {
>  		gfn_t gfn = get_mmio_spte_gfn(spte);
>  		unsigned int access = get_mmio_spte_access(spte);
>
> @@ -4529,7 +4530,7 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
>  static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
>  			   unsigned int access)
>  {
> -	if (unlikely(is_mmio_spte(*sptep))) {
> +	if (unlikely(is_mmio_spte(vcpu->kvm, *sptep))) {
>  		if (gfn != get_mmio_spte_gfn(*sptep)) {
>  			mmu_spte_clear_no_track(sptep);
>  			return true;
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 24cba35570ae..3ad16124eeeb 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -29,8 +29,6 @@ u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
>  u64 __read_mostly shadow_user_mask;
>  u64 __read_mostly shadow_accessed_mask;
>  u64 __read_mostly shadow_dirty_mask;
> -u64 __read_mostly shadow_mmio_value;
> -u64 __read_mostly shadow_mmio_mask;
>  u64 __read_mostly shadow_mmio_access_mask;
>  u64 __read_mostly shadow_present_mask;
>  u64 __read_mostly shadow_memtype_mask;
> @@ -60,10 +58,10 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
>  	u64 spte = generation_mmio_spte_mask(gen);
>  	u64 gpa = gfn << PAGE_SHIFT;
>
> -	WARN_ON_ONCE(!shadow_mmio_value);
> +	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value);
>
>  	access &= shadow_mmio_access_mask;
> -	spte |= shadow_mmio_value | access;
> +	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
>  	spte |= gpa | shadow_nonpresent_or_rsvd_mask;
>  	spte |= (gpa & shadow_nonpresent_or_rsvd_mask)
>  		<< SHADOW_NONPRESENT_OR_RSVD_MASK_LEN;
> @@ -335,9 +333,8 @@ u64 mark_spte_for_access_track(u64 spte)
>  	return spte;
>  }
>
> -void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
> +void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value, u64 mmio_mask)
>  {
> -	BUG_ON((u64)(unsigned)access_mask != access_mask);
>  	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
>
>  	if (!enable_mmio_caching)
> @@ -364,12 +361,9 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
>  	    WARN_ON(mmio_value && (REMOVED_SPTE & mmio_mask) == mmio_value))
>  		mmio_value = 0;
>
> -	if (!mmio_value)
> -		enable_mmio_caching = false;
> -
> -	shadow_mmio_value = mmio_value;
> -	shadow_mmio_mask  = mmio_mask;
> -	shadow_mmio_access_mask = access_mask;
> +	kvm->arch.enable_mmio_caching = !!mmio_value;
> +	kvm->arch.shadow_mmio_value = mmio_value;
> +	kvm->arch.shadow_mmio_mask = mmio_mask;
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
>
> @@ -404,20 +398,12 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
>  	shadow_acc_track_mask	= VMX_EPT_RWX_MASK;
>  	shadow_host_writable_mask = EPT_SPTE_HOST_WRITABLE;
>  	shadow_mmu_writable_mask  = EPT_SPTE_MMU_WRITABLE;
> -
> -	/*
> -	 * EPT Misconfigurations are generated if the value of bits 2:0
> -	 * of an EPT paging-structure entry is 110b (write/execute).
> -	 */
> -	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE,
> -				   VMX_EPT_RWX_MASK, 0);
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_set_ept_masks);
>
>  void kvm_mmu_reset_all_pte_masks(void)
>  {
>  	u8 low_phys_bits;
> -	u64 mask;
>
>  	shadow_phys_bits = kvm_get_shadow_phys_bits();
>
> @@ -464,18 +450,11 @@ void kvm_mmu_reset_all_pte_masks(void)
>
>  	shadow_host_writable_mask = DEFAULT_SPTE_HOST_WRITABLE;
>  	shadow_mmu_writable_mask  = DEFAULT_SPTE_MMU_WRITABLE;
> +}
>
> -	/*
> -	 * Set a reserved PA bit in MMIO SPTEs to generate page faults with
> -	 * PFEC.RSVD=1 on MMIO accesses.  64-bit PTEs (PAE, x86-64, and EPT
> -	 * paging) support a maximum of 52 bits of PA, i.e. if the CPU supports
> -	 * 52-bit physical addresses then there are no reserved PA bits in the
> -	 * PTEs and so the reserved PA approach must be disabled.
> -	 */
> -	if (shadow_phys_bits < 52)
> -		mask = BIT_ULL(51) | PT_PRESENT_MASK;
> -	else
> -		mask = 0;
> -
> -	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
> +void kvm_mmu_set_mmio_access_mask(u64 mmio_access_mask)
> +{
> +	BUG_ON((u64)(unsigned)mmio_access_mask != mmio_access_mask);
> +	shadow_mmio_access_mask = mmio_access_mask;
>  }
> +EXPORT_SYMBOL(kvm_mmu_set_mmio_access_mask);
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 30f456e59e58..824ab5490d5c 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -5,8 +5,6 @@
>
>  #include "mmu_internal.h"
>
> -extern bool __read_mostly enable_mmio_caching;
> -
>  /*
>   * A MMU present SPTE is backed by actual memory and may or may not be present
>   * in hardware.  E.g. MMIO SPTEs are not considered present.  Use bit 11, as it
> @@ -156,8 +154,6 @@ extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
>  extern u64 __read_mostly shadow_user_mask;
>  extern u64 __read_mostly shadow_accessed_mask;
>  extern u64 __read_mostly shadow_dirty_mask;
> -extern u64 __read_mostly shadow_mmio_value;
> -extern u64 __read_mostly shadow_mmio_mask;
>  extern u64 __read_mostly shadow_mmio_access_mask;
>  extern u64 __read_mostly shadow_present_mask;
>  extern u64 __read_mostly shadow_memtype_mask;
> @@ -231,10 +227,10 @@ static inline int spte_index(u64 *sptep)
>   */
>  extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
>
> -static inline bool is_mmio_spte(u64 spte)
> +static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
>  {
> -	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
> -	       likely(enable_mmio_caching);
> +	return (spte & kvm->arch.shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
> +		likely(kvm->arch.enable_mmio_caching || kvm_gfn_shared_mask(kvm));
>  }
>
>  static inline bool is_shadow_present_pte(u64 pte)
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index af510dd31ebc..8bc3a8d1803e 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -569,8 +569,8 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>  		 * impact the guest since both the former and current SPTEs
>  		 * are nonpresent.
>  		 */
> -		if (WARN_ON(!is_mmio_spte(old_spte) &&
> -			    !is_mmio_spte(new_spte) &&
> +		if (WARN_ON(!is_mmio_spte(kvm, old_spte) &&
> +			    !is_mmio_spte(kvm, new_spte) &&
>  			    !is_removed_spte(new_spte)))
>  			pr_err("Unexpected SPTE change! Nonpresent SPTEs\n"
>  			       "should not be replaced with another,\n"
> @@ -1094,7 +1094,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>  	}
>
>  	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
> -	if (unlikely(is_mmio_spte(new_spte))) {
> +	if (unlikely(is_mmio_spte(vcpu->kvm, new_spte))) {
>  		vcpu->stat.pf_mmio_spte_created++;
>  		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
>  				     new_spte);
> @@ -1863,6 +1863,13 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
>
>  	*root_level = vcpu->arch.mmu->root_role.level;
>
> +	/*
> +	 * mmio page fault isn't supported for protected guest because
> +	 * instructions in protected guest memory can't be parsed by VMM.
> +	 */
> +	if (WARN_ON(kvm_gfn_shared_mask(vcpu->kvm)))
> +		return leaf;
> +
>  	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
>  		leaf = iter.level;
>  		sptes[leaf] = iter.old_spte;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8aa3c95e8b6e..07829be93c93 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -229,6 +229,7 @@ module_param(dump_invalid_vmcb, bool, 0644);
>  bool intercept_smi = true;
>  module_param(intercept_smi, bool, 0444);
>
> +static u64 __read_mostly svm_shadow_mmio_mask;
>
>  static bool svm_gp_erratum_intercept = true;
>
> @@ -4729,6 +4730,9 @@ static bool svm_is_vm_type_supported(unsigned long type)
>
>  static int svm_vm_init(struct kvm *kvm)
>  {
> +	kvm_mmu_set_mmio_spte_mask(kvm, svm_shadow_mmio_mask,
> +				   svm_shadow_mmio_mask);
> +
>  	if (!pause_filter_count || !pause_filter_thresh)
>  		kvm->arch.pause_in_guest = true;
>
> @@ -4878,7 +4882,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  static __init void svm_adjust_mmio_mask(void)
>  {
>  	unsigned int enc_bit, mask_bit;
> -	u64 msr, mask;
> +	u64 msr;
>
>  	/* If there is no memory encryption support, use existing mask */
>  	if (cpuid_eax(0x80000000) < 0x8000001f)
> @@ -4905,9 +4909,8 @@ static __init void svm_adjust_mmio_mask(void)
>  	 *
>  	 * If the mask bit location is 52 (or above), then clear the mask.
>  	 */
> -	mask = (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : 0;
> -
> -	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
> +	svm_shadow_mmio_mask = (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : 0;
> +	kvm_mmu_set_mmio_access_mask(PT_WRITABLE_MASK | PT_USER_MASK);
>  }
>
>  static __init void svm_set_cpu_caps(void)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0bce352f81b8..ec2bd4df0684 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -141,6 +141,8 @@ module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
>  extern bool __read_mostly allow_smaller_maxphyaddr;
>  module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
>
> +u64 __ro_after_init vmx_shadow_mmio_mask;

I see only vmx.c uses it, it's possible to make it static
if no other users out of vmx.c, looks it's variable to
pass some decision made in vmx_init() to vmx_vm_init()
for per VM.

> +
>  #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
>  #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR0_NE
>  #define KVM_VM_CR0_ALWAYS_ON				\
> @@ -7359,6 +7361,17 @@ int vmx_vm_init(struct kvm *kvm)
>  	if (!ple_gap)
>  		kvm->arch.pause_in_guest = true;
>
> +	/*
> +	 * EPT Misconfigurations can be generated if the value of bits 2:0
> +	 * of an EPT paging-structure entry is 110b (write/execute).
> +	 */
> +	if (enable_ept)
> +		kvm_mmu_set_mmio_spte_mask(kvm, VMX_EPT_MISCONFIG_WX_VALUE,
> +					   VMX_EPT_RWX_MASK);
> +	else
> +		kvm_mmu_set_mmio_spte_mask(kvm, vmx_shadow_mmio_mask,
> +					   vmx_shadow_mmio_mask);
> +
>  	if (boot_cpu_has(X86_BUG_L1TF) && enable_ept) {
>  		switch (l1tf_mitigation) {
>  		case L1TF_MITIGATION_OFF:
> @@ -8357,6 +8370,19 @@ int __init vmx_init(void)
>  	if (!enable_ept)
>  		allow_smaller_maxphyaddr = true;
>
> +	/*
> +	 * Set a reserved PA bit in MMIO SPTEs to generate page faults with
> +	 * PFEC.RSVD=1 on MMIO accesses.  64-bit PTEs (PAE, x86-64, and EPT
> +	 * paging) support a maximum of 52 bits of PA, i.e. if the CPU supports
> +	 * 52-bit physical addresses then there are no reserved PA bits in the
> +	 * PTEs and so the reserved PA approach must be disabled.
> +	 */
> +	if (kvm_get_shadow_phys_bits() < 52)
> +		vmx_shadow_mmio_mask = BIT_ULL(51) | PT_PRESENT_MASK;
> +	else
> +		vmx_shadow_mmio_mask = 0;
> +	kvm_mmu_set_mmio_access_mask(0);
> +
>  	return 0;
>  }
>
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index b4ffa1590d41..62f1d1cdd44b 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -13,6 +13,7 @@ void hv_vp_assist_page_exit(void);
>  void __init vmx_init_early(void);
>  int __init vmx_init(void);
>  void vmx_exit(void);
> +extern u64 __ro_after_init vmx_shadow_mmio_mask;

Ditto.

>
>  __init int vmx_cpu_has_kvm_support(void);
>  __init int vmx_disabled_by_bios(void);
> --
> 2.25.1
>
