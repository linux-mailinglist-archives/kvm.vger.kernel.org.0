Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158834F622A
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 16:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbiDFOlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 10:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235088AbiDFOlS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 10:41:18 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8715430B95A;
        Wed,  6 Apr 2022 04:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649243207; x=1680779207;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mrG88DdRkJ/2p6d0oy+HVw3bRzDS4LgGSi8ANEQz+mg=;
  b=i8W7j4TawJGFKPRaVhM151Fk1FTq8poMa6dBkjBuBz+qA2fqW4r0YgDm
   Wny2WT1AYW112AI3zbRzaKQJf9UGAnjRYBi4jIcOmeLrPleri4uZNO/ne
   jEmTAc5nHLwLDGRhCck4mQCYCa9svMZxKsMFBVZ7tZW2k3Oz85V0LKlJr
   GBL2bSoZxc2497Xm2326UPvBNd4Xkokn+LYZ15qQdy4uAn3vyjmxOqKSu
   ntgRzUM9qOaVnPT0/yKJgENiVVXubduQ8wLWOgm4orEnp8y69kGKLZqt3
   ooyCl4a833+2xWaA4BNpBV26qyRUhT9BS32Yfuwl5kW+3vVToU7EL0y8+
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="259853113"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="259853113"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 04:06:47 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="570466795"
Received: from yyan2-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.54.206])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 04:06:44 -0700
Message-ID: <1c7710a87eed650e4423935012e27747fb8c9dd8.camel@intel.com>
Subject: Re: [RFC PATCH v5 042/104] KVM: x86/mmu: Track shadow MMIO
 value/mask on a per-VM basis
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Wed, 06 Apr 2022 23:06:41 +1200
In-Reply-To: <b494b94bf2d6a5d841cb76e63e255d4cff906d83.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <b494b94bf2d6a5d841cb76e63e255d4cff906d83.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Define the EPT Violation #VE control bit, #VE info VMCS fields, and the
> suppress #VE bit for EPT entries.

It appears only the last one is introduced in this patch.

> 
> TDX will use a different shadow PTE entry value for MMIO from VMX.  Add
> members to kvm_arch and track value for MMIO per-VM.  By using per-VM EPT
> entry value for MMIO, the existing VMX logic is kept working.
> 
> In the case of VMX VM case, the EPT entry for MMIO is non-present PTE
> (present bit cleared) without backing guest physical address (on EPT
> violation, KVM seaching backing guest memory and it finds there is no
> backing guest page.) or the value to trigger EPT misconfiguration.  For
> fast path. Once MMIO is triggered on the EPT entry, the EPT entry is
> updated for the future MMIO.  It allows KVM to understand the memory access
> is for MMIO without searching backing guest pages.). And then KVM parses
> guest instruction to figure out address/value/width for MMIO.

What does "For fast path." meaning?

There are also grammar issues in above paragraph.

> 
> In the case of the guest TD, the guest memory is protected so that VMM
> can't parse guest instruction to trigger EPT violation.  
> 

Even VMM can parse guest instruction, it cannot trigger EPT violatoin.  Only
guest can trigger EPT violation.

> Instead VMM sets
> up (Shared) EPT to trigger #VE.  When the guest TD issues MMIO, #VE is
> injected.  guest VE handler converts MMIO access into MMIO hypercall to
> pass address/value/width for MMIO to VMM. (or directly paravirtualize MMIO
> into hypercall.)  Then VMM can handle the MMIO hypercall without parsing
> guest instruction.

There are couple of grammar issues in above two paragraphs.

> 
> When the guest accesses GPA if "the EPT Violation #VE" control bit is set
> and EPT SUPPRESS VE bit in EPT entry is cleared, #VE, virtualization
> exception, is injected into the guest.  Because the TDX guest vCPU state
> and memory are protected, a VMM can't emulate MMIO by the TDX guest on EPT
> violation by snooping vCPU state and parsing instruction to figure out MMIO
> address and value.  Instead, PV MMIO (MMIO hypercall) is adapted.  On EPT
> violation, CPU injects #VE to guest and the guest converts MMIO instruction
> into PV MMIO.  Or guest directly issues MMIO hypercall.

Isn't this paragraph kinda duplicated with above paragraph?

> 
> The existing VMX code uses zero as an initial value for EPT entry.  TDX
> will enable EPT-violation #VE VM-execution control and requires suppress VE
> bit cleared in shared EPT entry to inject #VE into the TDX guest.  To keep
> the same behavior for VMX, suppress VE bit needs to be set.  Allow to
> specify an initial value for EPT entry and if TDX is enabled, set initial
> EPT entry value to suppress VE bit set.  EPT-violation #VE VM-execution
> control will be enabled, and For TDX shared EPT suppress VE bit will be
> cleared for TDX shared EPT entry.

Isn't the last paragraph talking about the same thing as you did in patch 37
"KVM: x86/mmu: Allow non-zero init value for shadow PTE"?  That patch has
already done the thing to set a non-zero initial PTE.

Btw, please put this patch and patch 37 together since they are handling similar
thing (now there are couple of unrelated patches in the middle).

This patch talks about changing MMIO value/mask from global to per-VM tracking.
Please focus on explaining the rational behind this -- i.e. unlike to legacy VMX
VM (and AMD legacy VMs), TD guest requires different MMIO value/mask in order to
configure MMIO EPT entry to not generate EPT misconfiguration, but instead to
inject #VE by setting up a non-present SPTE which causes EPT violation but with
"Suppress #VE" bit clear.


> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 +++
>  arch/x86/include/asm/vmx.h      |  1 +
>  arch/x86/kvm/mmu.h              |  6 ++++--
>  arch/x86/kvm/mmu/mmu.c          | 19 +++++++++++------
>  arch/x86/kvm/mmu/spte.c         | 38 ++++++++++++++++-----------------
>  arch/x86/kvm/mmu/spte.h         |  9 ++++----
>  arch/x86/kvm/mmu/tdp_mmu.c      |  6 +++---
>  arch/x86/kvm/svm/svm.c          |  2 +-
>  arch/x86/kvm/vmx/main.c         |  7 ++++--
>  arch/x86/kvm/vmx/tdx.c          |  2 +-
>  arch/x86/kvm/vmx/tdx.h          |  2 ++
>  arch/x86/kvm/vmx/vmx.c          |  8 +++++++
>  12 files changed, 63 insertions(+), 40 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d33d79f2af2d..fcab2337819c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1069,6 +1069,9 @@ struct kvm_arch {
>  	 */
>  	spinlock_t mmu_unsync_pages_lock;
>  
> +	u64 shadow_mmio_value;
> +	u64 shadow_mmio_mask;
> +
>  	struct list_head assigned_dev_head;
>  	struct iommu_domain *iommu_domain;
>  	bool iommu_noncoherent;
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 0ffaa3156a4e..88d9b8cc7dde 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -498,6 +498,7 @@ enum vmcs_field {
>  #define VMX_EPT_IPAT_BIT    			(1ull << 6)
>  #define VMX_EPT_ACCESS_BIT			(1ull << 8)
>  #define VMX_EPT_DIRTY_BIT			(1ull << 9)
> +#define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
>  #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
>  						 VMX_EPT_WRITABLE_MASK |       \
>  						 VMX_EPT_EXECUTABLE_MASK)
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 650989c37f2e..b49841e4faaa 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -64,8 +64,10 @@ static __always_inline u64 rsvd_bits(int s, int e)
>  	return ((2ULL << (e - s)) - 1) << s;
>  }
>  
> -void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
> -void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
> +void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value, u64 mmio_mask,
> +				u64 access_mask);
> +void kvm_mmu_set_default_mmio_spte_mask(u64 mask);
> +void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only, u64 init_value);
>  void kvm_mmu_set_spte_init_value(u64 init_value);
>  
>  void kvm_init_mmu(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d8c1505155b0..6e9847b1124b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2336,7 +2336,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
>  				return kvm_mmu_prepare_zap_page(kvm, child,
>  								invalid_list);
>  		}
> -	} else if (is_mmio_spte(pte)) {
> +	} else if (is_mmio_spte(kvm, pte)) {
>  		mmu_spte_clear_no_track(spte);
>  	}
>  	return 0;
> @@ -3069,9 +3069,12 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
>  		/*
>  		 * If MMIO caching is disabled, emulate immediately without
>  		 * touching the shadow page tables as attempting to install an
> -		 * MMIO SPTE will just be an expensive nop.
> +		 * MMIO SPTE will just be an expensive nop, but excludes the
> +		 * INTEL TD guest due to it also uses shadow_mmio_value = 0
> +		 * to emulating MMIO access.

The comment seems is not accurate.  If I read correctly, for a TD guest,
shadow_mmio_value is initialized to shadow_default_mmio_mask, which isn't always
0.  See changes to kvm_mmu_reset_all_pte_masks().

>  		 */
> -		if (unlikely(!shadow_mmio_value)) {
> +		if (unlikely(!vcpu->kvm->arch.shadow_mmio_value)
> +		    && !kvm_gfn_stolen_mask(vcpu->kvm)) {

I don't like using kvm_gfn_stolen_mask() here.  Similar to below comment related
to is_mmio_spte().

>  			*ret_val = RET_PF_EMULATE;
>  			return true;
>  		}
> @@ -3209,7 +3212,8 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  			break;
>  
>  		sp = sptep_to_sp(sptep);
> -		if (!is_last_spte(spte, sp->role.level) || is_mmio_spte(spte))
> +		if (!is_last_spte(spte, sp->role.level) ||
> +			is_mmio_spte(vcpu->kvm, spte))
>  			break;
>  
>  		/*
> @@ -3892,7 +3896,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>  	if (WARN_ON(reserved))
>  		return -EINVAL;
>  
> -	if (is_mmio_spte(spte)) {
> +	if (is_mmio_spte(vcpu->kvm, spte)) {
>  		gfn_t gfn = get_mmio_spte_gfn(spte);
>  		unsigned int access = get_mmio_spte_access(spte);
>  
> @@ -4294,7 +4298,7 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
>  static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
>  			   unsigned int access)
>  {
> -	if (unlikely(is_mmio_spte(*sptep))) {
> +	if (unlikely(is_mmio_spte(vcpu->kvm, *sptep))) {
>  		if (gfn != get_mmio_spte_gfn(*sptep)) {
>  			mmu_spte_clear_no_track(sptep);
>  			return true;
> @@ -5791,6 +5795,9 @@ void kvm_mmu_init_vm(struct kvm *kvm)
>  	kvm_page_track_register_notifier(kvm, node);
>  
>  	kvm->arch.tdp_max_page_level = KVM_MAX_HUGEPAGE_LEVEL;
> +	kvm_mmu_set_mmio_spte_mask(kvm, shadow_default_mmio_mask,
> +				   shadow_default_mmio_mask,
> +				   ACC_WRITE_MASK | ACC_USER_MASK);
>  }
>  
>  void kvm_mmu_uninit_vm(struct kvm *kvm)
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 5071e8332db2..ea83927b9231 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -29,8 +29,7 @@ u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
>  u64 __read_mostly shadow_user_mask;
>  u64 __read_mostly shadow_accessed_mask;
>  u64 __read_mostly shadow_dirty_mask;
> -u64 __read_mostly shadow_mmio_value;
> -u64 __read_mostly shadow_mmio_mask;
> +u64 __read_mostly shadow_default_mmio_mask;
>  u64 __read_mostly shadow_mmio_access_mask;
>  u64 __read_mostly shadow_present_mask;
>  u64 __read_mostly shadow_me_mask;
> @@ -59,10 +58,11 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
>  	u64 spte = generation_mmio_spte_mask(gen);
>  	u64 gpa = gfn << PAGE_SHIFT;
>  
> -	WARN_ON_ONCE(!shadow_mmio_value);
> +	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value &&
> +		     !kvm_gfn_stolen_mask(vcpu->kvm));
>  
>  	access &= shadow_mmio_access_mask;
> -	spte |= shadow_mmio_value | access;
> +	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
>  	spte |= gpa | shadow_nonpresent_or_rsvd_mask;
>  	spte |= (gpa & shadow_nonpresent_or_rsvd_mask)
>  		<< SHADOW_NONPRESENT_OR_RSVD_MASK_LEN;
> @@ -279,7 +279,8 @@ u64 mark_spte_for_access_track(u64 spte)
>  	return spte;
>  }
>  
> -void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
> +void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value, u64 mmio_mask,
> +				u64 access_mask)
>  {
>  	BUG_ON((u64)(unsigned)access_mask != access_mask);
>  	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
> @@ -308,39 +309,32 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
>  	    WARN_ON(mmio_value && (REMOVED_SPTE & mmio_mask) == mmio_value))
>  		mmio_value = 0;
>  
> -	shadow_mmio_value = mmio_value;
> -	shadow_mmio_mask  = mmio_mask;
> +	kvm->arch.shadow_mmio_value = mmio_value;
> +	kvm->arch.shadow_mmio_mask = mmio_mask;
>  	shadow_mmio_access_mask = access_mask;
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
>  
> -void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
> +void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only, u64 init_value)
>  {
>  	shadow_user_mask	= VMX_EPT_READABLE_MASK;
>  	shadow_accessed_mask	= has_ad_bits ? VMX_EPT_ACCESS_BIT : 0ull;
>  	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
>  	shadow_nx_mask		= 0ull;
>  	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
> -	shadow_present_mask	= has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
> +	shadow_present_mask	=
> +		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | init_value;

This change doesn't seem make any sense.  Why should "Suppress #VE" bit be set
for a present PTE?

>  	shadow_acc_track_mask	= VMX_EPT_RWX_MASK;
>  	shadow_me_mask		= 0ull;
>  
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
> @@ -389,9 +383,13 @@ void kvm_mmu_reset_all_pte_masks(void)
>  	 * PTEs and so the reserved PA approach must be disabled.
>  	 */
>  	if (shadow_phys_bits < 52)
> -		mask = BIT_ULL(51) | PT_PRESENT_MASK;
> +		shadow_default_mmio_mask = BIT_ULL(51) | PT_PRESENT_MASK;

Hmm...  Not related to this patch, but it seems there's a bug here.  On a MKTME
enabled system (but not TDX) with 52 physical bits, the shadow_phys_bits will be
set to < 52 (depending on how many MKTME KeyIDs are configured by BIOS).  In
this case, bit 51 is set, but actually bit 51 isn't a reserved bit in this case.
Instead, it is a MKTME KeyID bit.  Therefore, above setting won't cause #PF, but
will use a non-zero MKTME keyID to access the physical address.

Paolo/Sean, any comments here?

>  	else
> -		mask = 0;
> +		shadow_default_mmio_mask = 0;
> +}
>  
> -	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
> +void kvm_mmu_set_default_mmio_spte_mask(u64 mask)
> +{
> +	shadow_default_mmio_mask = mask;
>  }
> +EXPORT_SYMBOL_GPL(kvm_mmu_set_default_mmio_spte_mask);
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 8e13a35ab8c9..bde843bce878 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -165,8 +165,7 @@ extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
>  extern u64 __read_mostly shadow_user_mask;
>  extern u64 __read_mostly shadow_accessed_mask;
>  extern u64 __read_mostly shadow_dirty_mask;
> -extern u64 __read_mostly shadow_mmio_value;
> -extern u64 __read_mostly shadow_mmio_mask;
> +extern u64 __read_mostly shadow_default_mmio_mask;
>  extern u64 __read_mostly shadow_mmio_access_mask;
>  extern u64 __read_mostly shadow_present_mask;
>  extern u64 __read_mostly shadow_me_mask;
> @@ -229,10 +228,10 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
>   */
>  extern u8 __read_mostly shadow_phys_bits;
>  
> -static inline bool is_mmio_spte(u64 spte)
> +static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
>  {
> -	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
> -	       likely(shadow_mmio_value);
> +	return (spte & kvm->arch.shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
> +		likely(kvm->arch.shadow_mmio_value || kvm_gfn_stolen_mask(kvm));

I don't like using kvm_gfn_stolen_mask() to check whether SPTE is MMIO. 
kvm_gfn_stolen_mask() really doesn't imply anything regarding to setting up the
value of MMIO SPTE.  At least, I guess we can use some is_protected_vm() sort of
things since it implies guest memory is protected therefore legacy way handling
of MMIO doesn't work (i.e. you cannot parse MMIO instruction).

>  }
>  
>  static inline bool is_shadow_present_pte(u64 pte)
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index bc9e3553fba2..ebd0a02620e8 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -447,8 +447,8 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
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
> @@ -927,7 +927,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>  	}
>  
>  	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
> -	if (unlikely(is_mmio_spte(new_spte))) {
> +	if (unlikely(is_mmio_spte(vcpu->kvm, new_spte))) {
>  		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
>  				     new_spte);
>  		ret = RET_PF_EMULATE;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 778075b71dc3..c7eec23e9ebe 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4704,7 +4704,7 @@ static __init void svm_adjust_mmio_mask(void)
>  	 */
>  	mask = (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : 0;
>  
> -	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
> +	kvm_mmu_set_default_mmio_spte_mask(mask);
>  }
>  
>  static __init void svm_set_cpu_caps(void)
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 51aaafe6b432..b242a9dc9e29 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -23,9 +23,12 @@ static __init int vt_hardware_setup(void)
>  
>  	tdx_hardware_setup(&vt_x86_ops);
>  
> -	if (enable_ept)
> +	if (enable_ept) {
> +		const u64 init_value = enable_tdx ? VMX_EPT_SUPPRESS_VE_BIT : 0ull;
>  		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
> -				      cpu_has_vmx_ept_execute_only());
> +				      cpu_has_vmx_ept_execute_only(), init_value);
> +		kvm_mmu_set_spte_init_value(init_value);
> +	}
>  
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index f86a257dd71b..c3434b33c452 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -11,7 +11,7 @@
>  #undef pr_fmt
>  #define pr_fmt(fmt) "tdx: " fmt
>  
> -static bool __read_mostly enable_tdx = true;
> +bool __read_mostly enable_tdx = true;
>  module_param_named(tdx, enable_tdx, bool, 0644);
>  
>  #define TDX_MAX_NR_CPUID_CONFIGS					\
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 4ce7fcab6f64..b32e068c51b4 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -6,6 +6,7 @@
>  
>  #include "tdx_ops.h"
>  
> +extern bool __read_mostly enable_tdx;
>  int tdx_module_setup(void);
>  
>  struct tdx_td_page {
> @@ -166,6 +167,7 @@ static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 fiel
>  }
>  
>  #else
> +#define enable_tdx false
>  static inline int tdx_module_setup(void) { return -ENODEV; };
>  
>  struct kvm_tdx;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 07fd892768be..00f88aa25047 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7065,6 +7065,14 @@ int vmx_vm_init(struct kvm *kvm)
>  	if (!ple_gap)
>  		kvm->arch.pause_in_guest = true;
>  
> +	/*
> +	 * EPT Misconfigurations can be generated if the value of bits 2:0
> +	 * of an EPT paging-structure entry is 110b (write/execute).
> +	 */
> +	if (enable_ept)
> +		kvm_mmu_set_mmio_spte_mask(kvm, VMX_EPT_MISCONFIG_WX_VALUE,
> +					   VMX_EPT_MISCONFIG_WX_VALUE, 0);

Should be:

	kvm_mmu_set_mmio_spte_mask(kvm, VMX_EPT_MISCONFIG_WX_VALUE,
				   	VMX_EPT_RWX_MASK, 0);

> +
>  	if (boot_cpu_has(X86_BUG_L1TF) && enable_ept) {
>  		switch (l1tf_mitigation) {
>  		case L1TF_MITIGATION_OFF:

