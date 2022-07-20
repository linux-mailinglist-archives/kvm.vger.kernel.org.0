Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670BB57AF95
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 05:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237723AbiGTDqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 23:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiGTDqG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 23:46:06 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A72031212;
        Tue, 19 Jul 2022 20:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658288763; x=1689824763;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=7ni2O4SEEkVS10T2Oui2zP2BYV4O65F3DqEg6IQMFZU=;
  b=avojXjZmMQnpB9jw5capXoadkqt4dw3ZhgCJxd45cLOq9Hk6tZUdpHVb
   PrLm2MYtWqJPyDcc/xYRX6NSSW7vrF06116Jr8TKwZ/uNDUEjdgWrja+R
   ZY0YaZtETyfQMS1+EnWanOT1lMA1mbWt5aeeFMoEnEfqAxqZZi+IcsAyz
   iIVxGT5T2ibkCE5oQWjDswjxiY4wWLR8PUEkgBxehfmcjot+iPadQDZzf
   tvi9MR1mI858RnJcgRfCpwFsLtURX/VN0FR3RWDGjKqwV/VBOygP0hhXG
   kC9W4SoCb0pmk3K17rYC8sczHZAkaNTgRySDXBHl/YkZnbjQ6WXLgh+w2
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="267070176"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="267070176"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 20:46:03 -0700
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="656079791"
Received: from ecurtis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.162.137])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 20:46:01 -0700
Message-ID: <c9d7f7e0665358f7352e95a7028a8779fd0531c6.camel@intel.com>
Subject: Re: [PATCH v7 037/102] KVM: x86/mmu: Track shadow MMIO value/mask
 on a per-VM basis
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>, isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Wed, 20 Jul 2022 15:45:59 +1200
In-Reply-To: <20220719084737.GU1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <242df8a7164b593d3702b9ba94889acd11f43cbb.1656366338.git.isaku.yamahata@intel.com>
         <20220719084737.GU1379820@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-07-19 at 01:47 -0700, Isaku Yamahata wrote:
> Here is the updated one. The changes are
> - removed hunks that should be a part of other patches.
> - removed shadow_default_mmio_mask
> - trimed down commit messages.
>=20
> From ed6b4a076e515550878b069596cf156a1bc33514 Mon Sep 17 00:00:00 2001
> Message-Id: <ed6b4a076e515550878b069596cf156a1bc33514.1658220363.git.isak=
u.yamahata@intel.com>
> In-Reply-To: <3941849bf08a55cfbbe69b222f0fd0dac7c5ee53.1658220363.git.isa=
ku.yamahata@intel.com>
> References: <3941849bf08a55cfbbe69b222f0fd0dac7c5ee53.1658220363.git.isak=
u.yamahata@intel.com>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> Date: Wed, 10 Jun 2020 15:46:38 -0700
> Subject: [PATCH 036/306] KVM: x86/mmu: Track shadow MMIO value/mask on a
>  per-VM basis
>=20
> TDX will use a different shadow PTE entry value for MMIO from VMX.  Add
> members to kvm_arch and track value for MMIO per-VM instead of global
> variables.  By using the per-VM EPT entry value for MMIO, the existing VM=
X
> logic is kept working.  To untangle the logic to initialize
> shadow_mmio_access_mask, introduce a setter function.

introduce a separate setter function for it.

>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  4 +++
>  arch/x86/kvm/mmu.h              |  3 ++-
>  arch/x86/kvm/mmu/mmu.c          |  8 +++---
>  arch/x86/kvm/mmu/spte.c         | 45 +++++++++------------------------
>  arch/x86/kvm/mmu/spte.h         | 10 +++-----
>  arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++---
>  arch/x86/kvm/svm/svm.c          | 11 +++++---
>  arch/x86/kvm/vmx/tdx.c          |  4 +++
>  arch/x86/kvm/vmx/vmx.c          | 26 +++++++++++++++++++
>  arch/x86/kvm/vmx/x86_ops.h      |  1 +
>  10 files changed, 66 insertions(+), 52 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 2c47aab72a1b..39215daa8576 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1161,6 +1161,10 @@ struct kvm_arch {
>  	 */
>  	spinlock_t mmu_unsync_pages_lock;
> =20
> +	bool enable_mmio_caching;
> +	u64 shadow_mmio_value;
> +	u64 shadow_mmio_mask;
> +
>  	struct list_head assigned_dev_head;
>  	struct iommu_domain *iommu_domain;
>  	bool iommu_noncoherent;
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index ccf0ba7a6387..cfa3e658162c 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -108,7 +108,8 @@ static inline u8 kvm_get_shadow_phys_bits(void)
>  	return boot_cpu_data.x86_phys_bits;
>  }
> =20
> -void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 acces=
s_mask);
> +void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value, u64 mmi=
o_mask);
> +void kvm_mmu_set_mmio_access_mask(u64 mmio_access_mask);
>  void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
>  void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
> =20
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5bfccfa0f50e..34240fcc45de 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2298,7 +2298,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct=
 kvm_mmu_page *sp,
>  				return kvm_mmu_prepare_zap_page(kvm, child,
>  								invalid_list);
>  		}
> -	} else if (is_mmio_spte(pte)) {
> +	} else if (is_mmio_spte(kvm, pte)) {
>  		mmu_spte_clear_no_track(spte);
>  	}
>  	return 0;
> @@ -3079,7 +3079,7 @@ static int handle_abnormal_pfn(struct kvm_vcpu *vcp=
u, struct kvm_page_fault *fau
>  		 * and only if L1's MAXPHYADDR is inaccurate with respect to
>  		 * the hardware's).
>  		 */
> -		if (unlikely(!enable_mmio_caching) ||
> +		if (unlikely(!vcpu->kvm->arch.enable_mmio_caching) ||
>  		    unlikely(fault->gfn > kvm_mmu_max_gfn()))
>  			return RET_PF_EMULATE;
>  	}
> @@ -3918,7 +3918,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *=
vcpu, u64 addr, bool direct)
>  	if (WARN_ON(reserved))
>  		return -EINVAL;
> =20
> -	if (is_mmio_spte(spte)) {
> +	if (is_mmio_spte(vcpu->kvm, spte)) {
>  		gfn_t gfn =3D get_mmio_spte_gfn(spte);
>  		unsigned int access =3D get_mmio_spte_access(spte);
> =20
> @@ -4361,7 +4361,7 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
>  static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
>  			   unsigned int access)
>  {
> -	if (unlikely(is_mmio_spte(*sptep))) {
> +	if (unlikely(is_mmio_spte(vcpu->kvm, *sptep))) {
>  		if (gfn !=3D get_mmio_spte_gfn(*sptep)) {
>  			mmu_spte_clear_no_track(sptep);
>  			return true;
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 92968e5605fc..9a130dd3d6a3 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -29,8 +29,6 @@ u64 __read_mostly shadow_x_mask; /* mutual exclusive wi=
th nx_mask */
>  u64 __read_mostly shadow_user_mask;
>  u64 __read_mostly shadow_accessed_mask;
>  u64 __read_mostly shadow_dirty_mask;
> -u64 __read_mostly shadow_mmio_value;
> -u64 __read_mostly shadow_mmio_mask;
>  u64 __read_mostly shadow_mmio_access_mask;
>  u64 __read_mostly shadow_present_mask;
>  u64 __read_mostly shadow_me_value;
> @@ -62,10 +60,10 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, un=
signed int access)
>  	u64 spte =3D generation_mmio_spte_mask(gen);
>  	u64 gpa =3D gfn << PAGE_SHIFT;
> =20
> -	WARN_ON_ONCE(!shadow_mmio_value);
> +	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value);
> =20
>  	access &=3D shadow_mmio_access_mask;
> -	spte |=3D shadow_mmio_value | access;
> +	spte |=3D vcpu->kvm->arch.shadow_mmio_value | access;
>  	spte |=3D gpa | shadow_nonpresent_or_rsvd_mask;
>  	spte |=3D (gpa & shadow_nonpresent_or_rsvd_mask)
>  		<< SHADOW_NONPRESENT_OR_RSVD_MASK_LEN;
> @@ -337,9 +335,8 @@ u64 mark_spte_for_access_track(u64 spte)
>  	return spte;
>  }
> =20
> -void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 acces=
s_mask)
> +void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value, u64 mmi=
o_mask)
>  {
> -	BUG_ON((u64)(unsigned)access_mask !=3D access_mask);
>  	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
> =20
>  	if (!enable_mmio_caching)
> @@ -366,12 +363,9 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 =
mmio_mask, u64 access_mask)
>  	    WARN_ON(mmio_value && (__REMOVED_SPTE & mmio_mask) =3D=3D mmio_valu=
e))
>  		mmio_value =3D 0;
> =20
> -	if (!mmio_value)
> -		enable_mmio_caching =3D false;
> -
> -	shadow_mmio_value =3D mmio_value;
> -	shadow_mmio_mask  =3D mmio_mask;
> -	shadow_mmio_access_mask =3D access_mask;
> +	kvm->arch.enable_mmio_caching =3D !!mmio_value;

KVM has a global enable_mmio_caching boolean, and I think we should honor i=
t
here (in this patch) by doing below first:

	if (enabling_mmio_caching)
		mmio_value =3D 0;

For TD guest, the logic around enable_mmio_caching doesn't make sense anymo=
re,
so perhaps we can later tweak it by doing something like:

	/*
	 * Treat mmio_caching is false for TD guest, or true for it, depending
	 * on how you define it.
	 */
	if (kvm_gfn_shared_mask(kvm))
		kvm->arch.enable_mmio_caching =3D false;	/* or true? */
	else {
		if (!enable_mmio_caching)
			mmio_value =3D 0;
		kvm->arch.enable_mmio_caching =3D !!mmio_value;
	}

> +	kvm->arch.shadow_mmio_value =3D mmio_value;
> +	kvm->arch.shadow_mmio_mask =3D mmio_mask;
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
> =20
> @@ -399,20 +393,12 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool h=
as_exec_only)
>  	shadow_acc_track_mask	=3D VMX_EPT_RWX_MASK;
>  	shadow_host_writable_mask =3D EPT_SPTE_HOST_WRITABLE;
>  	shadow_mmu_writable_mask  =3D EPT_SPTE_MMU_WRITABLE;
> -
> -	/*
> -	 * EPT Misconfigurations are generated if the value of bits 2:0
> -	 * of an EPT paging-structure entry is 110b (write/execute).
> -	 */
> -	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE,
> -				   VMX_EPT_RWX_MASK, 0);
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_set_ept_masks);
> =20
>  void kvm_mmu_reset_all_pte_masks(void)
>  {
>  	u8 low_phys_bits;
> -	u64 mask;
> =20
>  	shadow_phys_bits =3D kvm_get_shadow_phys_bits();
> =20
> @@ -452,18 +438,11 @@ void kvm_mmu_reset_all_pte_masks(void)
> =20
>  	shadow_host_writable_mask =3D DEFAULT_SPTE_HOST_WRITABLE;
>  	shadow_mmu_writable_mask  =3D DEFAULT_SPTE_MMU_WRITABLE;
> +}
> =20
> -	/*
> -	 * Set a reserved PA bit in MMIO SPTEs to generate page faults with
> -	 * PFEC.RSVD=3D1 on MMIO accesses.  64-bit PTEs (PAE, x86-64, and EPT
> -	 * paging) support a maximum of 52 bits of PA, i.e. if the CPU supports
> -	 * 52-bit physical addresses then there are no reserved PA bits in the
> -	 * PTEs and so the reserved PA approach must be disabled.
> -	 */
> -	if (shadow_phys_bits < 52)
> -		mask =3D BIT_ULL(51) | PT_PRESENT_MASK;
> -	else
> -		mask =3D 0;
> -
> -	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
> +void kvm_mmu_set_mmio_access_mask(u64 mmio_access_mask)
> +{
> +	BUG_ON((u64)(unsigned)mmio_access_mask !=3D mmio_access_mask);
> +	shadow_mmio_access_mask =3D mmio_access_mask;
>  }
> +EXPORT_SYMBOL(kvm_mmu_set_mmio_access_mask);
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index f5fd22f6bf5f..99bce92b596e 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -5,8 +5,6 @@
> =20
>  #include "mmu_internal.h"
> =20
> -extern bool __read_mostly enable_mmio_caching;
> -

Here you removed the ability to control enable_mmio_caching globally.  It's=
 not
something you stated to do in the changelog.  Perhaps we should still keep =
it,
and enforce it in kvm_mmu_set_mmio_spte_mask() as commented above.

And in upstream KVM, it is a module parameter.  What happens to it?

>  /*
>   * A MMU present SPTE is backed by actual memory and may or may not be p=
resent
>   * in hardware.  E.g. MMIO SPTEs are not considered present.  Use bit 11=
, as it
> @@ -160,8 +158,6 @@ extern u64 __read_mostly shadow_x_mask; /* mutual exc=
lusive with nx_mask */
>  extern u64 __read_mostly shadow_user_mask;
>  extern u64 __read_mostly shadow_accessed_mask;
>  extern u64 __read_mostly shadow_dirty_mask;
> -extern u64 __read_mostly shadow_mmio_value;
> -extern u64 __read_mostly shadow_mmio_mask;
>  extern u64 __read_mostly shadow_mmio_access_mask;
>  extern u64 __read_mostly shadow_present_mask;
>  extern u64 __read_mostly shadow_me_value;
> @@ -228,10 +224,10 @@ static inline bool is_removed_spte(u64 spte)
>   */
>  extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
> =20
> -static inline bool is_mmio_spte(u64 spte)
> +static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
>  {
> -	return (spte & shadow_mmio_mask) =3D=3D shadow_mmio_value &&
> -	       likely(enable_mmio_caching);
> +	return (spte & kvm->arch.shadow_mmio_mask) =3D=3D kvm->arch.shadow_mmio=
_value &&
> +		likely(kvm->arch.enable_mmio_caching);
>  }
> =20
>  static inline bool is_shadow_present_pte(u64 pte)
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 2ca03ec3bf52..82f1bfac7ee6 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -569,8 +569,8 @@ static void __handle_changed_spte(struct kvm *kvm, in=
t as_id, gfn_t gfn,
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
> @@ -1108,7 +1108,7 @@ static int tdp_mmu_map_handle_target_level(struct k=
vm_vcpu *vcpu,
>  	}
> =20
>  	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
> -	if (unlikely(is_mmio_spte(new_spte))) {
> +	if (unlikely(is_mmio_spte(vcpu->kvm, new_spte))) {
>  		vcpu->stat.pf_mmio_spte_created++;
>  		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
>  				     new_spte);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f01821f48bfd..0f63257161a6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -198,6 +198,7 @@ module_param(dump_invalid_vmcb, bool, 0644);
>  bool intercept_smi =3D true;
>  module_param(intercept_smi, bool, 0444);
> =20
> +static u64 __read_mostly svm_shadow_mmio_mask;
> =20
>  static bool svm_gp_erratum_intercept =3D true;
> =20
> @@ -4685,6 +4686,9 @@ static bool svm_is_vm_type_supported(unsigned long =
type)
> =20
>  static int svm_vm_init(struct kvm *kvm)
>  {
> +	kvm_mmu_set_mmio_spte_mask(kvm, svm_shadow_mmio_mask,
> +				   svm_shadow_mmio_mask);
> +
>  	if (!pause_filter_count || !pause_filter_thresh)
>  		kvm->arch.pause_in_guest =3D true;
> =20
> @@ -4834,7 +4838,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata =
=3D {
>  static __init void svm_adjust_mmio_mask(void)
>  {
>  	unsigned int enc_bit, mask_bit;
> -	u64 msr, mask;
> +	u64 msr;
> =20
>  	/* If there is no memory encryption support, use existing mask */
>  	if (cpuid_eax(0x80000000) < 0x8000001f)
> @@ -4861,9 +4865,8 @@ static __init void svm_adjust_mmio_mask(void)
>  	 *
>  	 * If the mask bit location is 52 (or above), then clear the mask.
>  	 */
> -	mask =3D (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : =
0;
> -
> -	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK)=
;
> +	svm_shadow_mmio_mask =3D (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT=
_PRESENT_MASK : 0;
> +	kvm_mmu_set_mmio_access_mask(PT_WRITABLE_MASK | PT_USER_MASK);
>  }
> =20
>  static __init void svm_set_cpu_caps(void)
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 36d2127cb7b7..52fb54880f9b 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -7,6 +7,7 @@
>  #include "x86_ops.h"
>  #include "tdx.h"
>  #include "x86.h"
> +#include "mmu.h"
> =20
>  #undef pr_fmt
>  #define pr_fmt(fmt) "tdx: " fmt
> @@ -276,6 +277,9 @@ int tdx_vm_init(struct kvm *kvm)
>  	int ret, i;
>  	u64 err;
> =20
> +	kvm_mmu_set_mmio_spte_mask(kvm, vmx_shadow_mmio_mask,
> +				   vmx_shadow_mmio_mask);
> +

I prefer to split this chunk out to another patch so this patch can be pure=
ly
infrastructural.   In this way you can even move this patch around easily i=
n
this series.

>  	/* vCPUs can't be created until after KVM_TDX_INIT_VM. */
>  	kvm->max_vcpus =3D 0;
> =20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e129ee663498..88e893fdffe8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -141,6 +141,8 @@ module_param_named(preemption_timer, enable_preemptio=
n_timer, bool, S_IRUGO);
>  extern bool __read_mostly allow_smaller_maxphyaddr;
>  module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
> =20
> +u64 __ro_after_init vmx_shadow_mmio_mask;
> +
>  #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
>  #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR0_NE
>  #define KVM_VM_CR0_ALWAYS_ON				\
> @@ -7359,6 +7361,17 @@ int vmx_vm_init(struct kvm *kvm)
>  	if (!ple_gap)
>  		kvm->arch.pause_in_guest =3D true;
> =20
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
> @@ -8358,6 +8371,19 @@ int __init vmx_init(void)
>  	if (!enable_ept)
>  		allow_smaller_maxphyaddr =3D true;
> =20
> +	/*
> +	 * Set a reserved PA bit in MMIO SPTEs to generate page faults with
> +	 * PFEC.RSVD=3D1 on MMIO accesses.  64-bit PTEs (PAE, x86-64, and EPT
> +	 * paging) support a maximum of 52 bits of PA, i.e. if the CPU supports
> +	 * 52-bit physical addresses then there are no reserved PA bits in the
> +	 * PTEs and so the reserved PA approach must be disabled.
> +	 */
> +	if (kvm_get_shadow_phys_bits() < 52)
> +		vmx_shadow_mmio_mask =3D BIT_ULL(51) | PT_PRESENT_MASK;
> +	else
> +		vmx_shadow_mmio_mask =3D 0;
> +	kvm_mmu_set_mmio_access_mask(0);
> +
>  	return 0;
>  }
> =20
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 7e38c7b756d4..279e5360c555 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -13,6 +13,7 @@ void hv_vp_assist_page_exit(void);
>  void __init vmx_init_early(void);
>  int __init vmx_init(void);
>  void vmx_exit(void);
> +extern u64 __ro_after_init vmx_shadow_mmio_mask;
> =20
>  __init int vmx_cpu_has_kvm_support(void);
>  __init int vmx_disabled_by_bios(void);
> --=20
> 2.25.1
>=20
>=20

