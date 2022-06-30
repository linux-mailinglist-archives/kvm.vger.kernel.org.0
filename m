Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6741F5618AF
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 13:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbiF3LED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 07:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbiF3LEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 07:04:02 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04587403F1;
        Thu, 30 Jun 2022 04:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656587041; x=1688123041;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=zBkQVD1l3klVmreBbrNvATuDUwnRV2Z8rRl2L41UUkE=;
  b=XN52xjCeHGE9K0dIZFwL4ma2aTXGP2SkkkD9hp/JNHANVMNnDqLjiTrZ
   ERBlMkXJnKRktkdgWL9pWC61wiiWpJ85t3T0dg7Y6zjryFXIWKhfhzM96
   DyqCl+Oz1v19u7CoJtG3mDUwX1u33WfslDhI41DJJtV0M39uy1HkbqLMf
   VzH7430VYmPF2ub+4C29rBG+fSxvpFEyujy6Pu0Ff3B3WNqE/feOGYwP9
   CTYTirj1MwBrf8JQfW9owM9Fdn+xqNf390ZV8b2lbWmBoAbWvVxXgO15t
   jStSi0Eprb5DudmfcC7b9rMV7FuFeupvssyiRLrP7kcRJaxcxEJwIk5+Q
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="262115866"
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="262115866"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 04:04:00 -0700
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="680933124"
Received: from zhihuich-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.49.124])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 04:03:59 -0700
Message-ID: <9340e6e23a2564d971786207773134507cb3db4e.camel@intel.com>
Subject: Re: [PATCH v7 036/102] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Thu, 30 Jun 2022 23:03:56 +1200
In-Reply-To: <f74b05eca8815744ce1ad672c66033101be7369c.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <f74b05eca8815744ce1ad672c66033101be7369c.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>=20
> TDX introduced a new ETP, Secure-EPT, in addition to the existing EPT.
> Secure-EPT maps protected guest memory, which is called private. Since
> Secure-EPT page tables is also protected, those page tables is also calle=
d
> private.  The existing EPT is often called shared EPT to distinguish from
> Secure-EPT.  And also page tables for share EPT is also called shared.

Does this patch has anything to do with secure-EPT?

>=20
> Virtualization Exception, #VE, is a new processor exception in VMX non-ro=
ot

#VE isn't new.  It's already in pre-TDX public spec AFAICT.

> operation.  In certain virtualizatoin-related conditions, #VE is injected
> into guest instead of exiting from guest to VMM so that guest is given a
> chance to inspect it.  One important one is EPT violation.  When
> "ETP-violation #VE" VM-execution is set, "#VE suppress bit" in EPT entry
> is cleared, #VE is injected instead of EPT violation.

We already know such fact based on pre-TDX public spec.  Instead of repeati=
ng it
here, why not focusing on saying what's new in TDX, so your below paragraph=
 of
setting a non-zero value for non-present SPTE can be justified?

>=20
> Because guest memory is protected with TDX, VMM can't parse instructions
> in the guest memory.  Instead, MMIO hypercall is used for guest to pass
> necessary information to VMM.
>=20
> To make unmodified device driver work, guest TD expects #VE on accessing
> shared GPA.  The #VE handler converts MMIO access into MMIO hypercall wit=
h
> the EPT entry of enabled "#VE" by clearing "suppress #VE" bit.  Before VM=
M
> enabling #VE, it needs to figure out the given GPA is for MMIO by EPT
> violation. =C2=A0
>=20

As I said above, before here, you need to explain in TDX VMCS is controlled=
 by
the TDX module and it always sets the "EPT-violation #VE" in execution cont=
rol
bit.

> So the execution flow looks like
>=20
> - Allocate unused shared EPT entry with suppress #VE bit set.
> - EPT violation on that GPA.
> - VMM figures out the faulted GPA is for MMIO.
> - VMM clears the suppress #VE bit.
> - Guest TD gets #VE, and converts MMIO access into MMIO hypercall.
> - If the GPA maps guest memory, VMM resolves it with guest pages.
>=20
> For both cases, SPTE needs suppress #VE" bit set initially when it
> is allocated or zapped, therefore non-zero non-present value for SPTE
> needs to be allowed.
>=20
> This change requires to update FNAME(sync_page) for shadow EPT.
> "if(!sp->spte[i])" in FNAME(sync_page) means that the spte entry is the
> initial value.  With the introduction of shadow_nonpresent_value which ca=
n
> be non-zero, it doesn't hold any more. Replace zero check with
> "!is_shadow_present_pte() && !is_mmio_spte()".

I don't think you need to mention above paragraph.  It's absolutely unclear=
 how
is_mmio_spte() will be impacted by this patch by reading above paragraphs.

From the "execution flow" you mentioned above, you will change MMIO fault f=
rom
EPT misconfiguration to EPT violation (in order to get #VE), so theoretical=
ly
you may effectively disable MMIO caching, in which case, if I understand
correctly, is_mmio_spte() always returns false.

I guess you can just change to check:

	if (sp->spte[i] !=3D shadow_nonpresent_value)

Anyway, IMO you can just comment in the code.

After all, what is shadow_nonpresent_value, given you haven't explained wha=
t it
is?

>=20
> When "if (!spt[i])" doesn't hold, but the entry value is
> shadow_nonpresent_value, the entry is wrongly synchronized from non-prese=
nt
> to non-present with (wrongly) pfn changed and tries to remove rmap wrongl=
y
> and BUG_ON() is hit.

Ditto.

>=20
> TDP MMU uses REMOVED_SPTE =3D 0x5a0ULL as special constant to indicate th=
e
> intermediate value to indicate one thread is operating on it and the valu=
e
> should be semi-arbitrary value.  For TDX (more correctly to use #VE), the
> value should include suppress #VE value which is SHADOW_NONPRESENT_VALUE.

What is SHADOW_NONPRESENT_VALUE?

> Rename REMOVED_SPTE to __REMOVED_SPTE and define REMOVED_SPTE as
> SHADOW_NONPRESENT_VALUE | REMOVED_SPTE to set suppress #VE bit.

Ditto. IMHO you don't even need to mention REMOVED_SPTE in changelog.

>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 55 ++++++++++++++++++++++++++++++----
>  arch/x86/kvm/mmu/paging_tmpl.h |  3 +-
>  arch/x86/kvm/mmu/spte.c        |  5 +++-
>  arch/x86/kvm/mmu/spte.h        | 37 ++++++++++++++++++++---
>  arch/x86/kvm/mmu/tdp_mmu.c     | 23 +++++++++-----
>  5 files changed, 105 insertions(+), 18 deletions(-)
>=20
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 51306b80f47c..f239b6cb5d53 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -668,6 +668,44 @@ static void walk_shadow_page_lockless_end(struct kvm=
_vcpu *vcpu)
>  	}
>  }
> =20
> +static inline void kvm_init_shadow_page(void *page)
> +{
> +#ifdef CONFIG_X86_64
> +	int ign;
> +
> +	WARN_ON_ONCE(shadow_nonpresent_value !=3D SHADOW_NONPRESENT_VALUE);
> +	asm volatile (
> +		"rep stosq\n\t"
> +		: "=3Dc"(ign), "=3DD"(page)
> +		: "a"(SHADOW_NONPRESENT_VALUE), "c"(4096/8), "D"(page)
> +		: "memory"
> +	);
> +#else
> +	BUG();
> +#endif
> +}
> +
> +static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_mmu_memory_cache *mc =3D &vcpu->arch.mmu_shadow_page_cache;
> +	int start, end, i, r;
> +	bool is_tdp_mmu =3D is_tdp_mmu_enabled(vcpu->kvm);
> +
> +	if (is_tdp_mmu && shadow_nonpresent_value)
> +		start =3D kvm_mmu_memory_cache_nr_free_objects(mc);
> +
> +	r =3D kvm_mmu_topup_memory_cache(mc, PT64_ROOT_MAX_LEVEL);
> +	if (r)
> +		return r;
> +
> +	if (is_tdp_mmu && shadow_nonpresent_value) {
> +		end =3D kvm_mmu_memory_cache_nr_free_objects(mc);
> +		for (i =3D start; i < end; i++)
> +			kvm_init_shadow_page(mc->objects[i]);
> +	}

I think you can just extend this to legacy MMU too, but not only TDP MMU.

After all, before this patch, where have you declared that TDX only support=
s TDP
MMU?  This is only enforced in:

	[PATCH v7 043/102] KVM: x86/mmu: Focibly use TDP MMU for TDX

Which is 7 patches later.

Also, shadow_nonpresent_value is only used in couple of places, while
SHADOW_NONPRESENT_VALUE is used directly in more places.  Does it make more
sense to always use shadow_nonpresent_value, instead of using
SHADOW_NONPRESENT_VALUE?

Similar to other shadow values, we can provide a function to let caller
(VMX/SVM) to decide whether it wants to use non-zero for non-present SPTE.

	void kvm_mmu_set_non_present_value(u64 value)
	{
		shadow_nonpresent_value =3D value;
	}


> +	return 0;
> +}
> +
>  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_ind=
irect)
>  {
>  	int r;
> @@ -677,8 +715,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *v=
cpu, bool maybe_indirect)
>  				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
>  	if (r)
>  		return r;
> -	r =3D kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> -				       PT64_ROOT_MAX_LEVEL);
> +	r =3D mmu_topup_shadow_page_cache(vcpu);
>  	if (r)
>  		return r;
>  	if (maybe_indirect) {
> @@ -5521,9 +5558,16 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_fo=
rced_root_level,
>  	 * what is used by the kernel for any given HVA, i.e. the kernel's
>  	 * capabilities are ultimately consulted by kvm_mmu_hugepage_adjust().
>  	 */
> -	if (tdp_enabled)
> +	if (tdp_enabled) {
> +		/*
> +		 * For TDP MMU, always set bit 63 for TDX support. See the
> +		 * comment on SHADOW_NONPRESENT_VALUE.
> +		 */
> +#ifdef CONFIG_X86_64
> +		shadow_nonpresent_value =3D SHADOW_NONPRESENT_VALUE;
> +#endif

'tdp_enabled' doesn't mean TDP MMU, right?=20

>  		max_huge_page_level =3D tdp_huge_page_level;
> -	else if (boot_cpu_has(X86_FEATURE_GBPAGES))
> +	} else if (boot_cpu_has(X86_FEATURE_GBPAGES))
>  		max_huge_page_level =3D PG_LEVEL_1G;
>  	else
>  		max_huge_page_level =3D PG_LEVEL_2M;
> @@ -5654,7 +5698,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mmu_page_header_cache.kmem_cache =3D mmu_page_header_cache;
>  	vcpu->arch.mmu_page_header_cache.gfp_zero =3D __GFP_ZERO;
> =20
> -	vcpu->arch.mmu_shadow_page_cache.gfp_zero =3D __GFP_ZERO;
> +	if (!(is_tdp_mmu_enabled(vcpu->kvm) && shadow_nonpresent_value))
> +		vcpu->arch.mmu_shadow_page_cache.gfp_zero =3D __GFP_ZERO;
> =20
>  	vcpu->arch.mmu =3D &vcpu->arch.root_mmu;
>  	vcpu->arch.walk_mmu =3D &vcpu->arch.root_mmu;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmp=
l.h
> index fe35d8fd3276..ee2fb0c073f3 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -1031,7 +1031,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, =
struct kvm_mmu_page *sp)
>  		gpa_t pte_gpa;
>  		gfn_t gfn;
> =20
> -		if (!sp->spt[i])
> +		if (!is_shadow_present_pte(sp->spt[i]) &&
> +		    !is_mmio_spte(sp->spt[i]))
>  			continue;

As I said in the changelog, I don't think this is correct.

I guess you can just change to check:

	if (sp->spte[i] !=3D shadow_nonpresent_value)

> =20
>  		pte_gpa =3D first_pte_gpa + i * sizeof(pt_element_t);
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index cda1851ec155..bd441458153f 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -36,6 +36,9 @@ u64 __read_mostly shadow_present_mask;
>  u64 __read_mostly shadow_me_value;
>  u64 __read_mostly shadow_me_mask;
>  u64 __read_mostly shadow_acc_track_mask;
> +#ifdef CONFIG_X86_64
> +u64 __read_mostly shadow_nonpresent_value;
> +#endif
> =20
>  u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
>  u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
> @@ -360,7 +363,7 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 m=
mio_mask, u64 access_mask)
>  	 * not set any RWX bits.
>  	 */
>  	if (WARN_ON((mmio_value & mmio_mask) !=3D mmio_value) ||
> -	    WARN_ON(mmio_value && (REMOVED_SPTE & mmio_mask) =3D=3D mmio_value)=
)
> +	    WARN_ON(mmio_value && (__REMOVED_SPTE & mmio_mask) =3D=3D mmio_valu=
e))
>  		mmio_value =3D 0;
> =20
>  	if (!mmio_value)
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 0127bb6e3c7d..1bfedbe0585f 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -140,6 +140,19 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS =3D=3D 8 && MMI=
O_SPTE_GEN_HIGH_BITS =3D=3D 11);
> =20
>  #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SP=
TE_GEN_HIGH_BITS - 1, 0)
> =20
> +/*
> + * non-present SPTE value for both VMX and SVM for TDP MMU.
> + * For SVM NPT, for non-present spte (bit 0 =3D 0), other bits are ignor=
ed.
> + * For VMX EPT, bit 63 is ignored if #VE is disabled.
> + *              bit 63 is #VE suppress if #VE is enabled.
> + */
> +#ifdef CONFIG_X86_64
> +#define SHADOW_NONPRESENT_VALUE	BIT_ULL(63)
> +static_assert(!(SHADOW_NONPRESENT_VALUE & SPTE_MMU_PRESENT_MASK));
> +#else
> +#define SHADOW_NONPRESENT_VALUE	0ULL
> +#endif
> +
>  extern u64 __read_mostly shadow_host_writable_mask;
>  extern u64 __read_mostly shadow_mmu_writable_mask;
>  extern u64 __read_mostly shadow_nx_mask;
> @@ -154,6 +167,12 @@ extern u64 __read_mostly shadow_present_mask;
>  extern u64 __read_mostly shadow_me_value;
>  extern u64 __read_mostly shadow_me_mask;
> =20
> +#ifdef CONFIG_X86_64
> +extern u64 __read_mostly shadow_nonpresent_value;
> +#else
> +#define shadow_nonpresent_value	0ULL
> +#endif
> +
>  /*
>   * SPTEs in MMUs without A/D bits are marked with SPTE_TDP_AD_DISABLED_M=
ASK;
>   * shadow_acc_track_mask is the set of bits to be cleared in non-accesse=
d
> @@ -174,9 +193,12 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_m=
ask;
> =20
>  /*
>   * If a thread running without exclusive control of the MMU lock must pe=
rform a
> - * multi-part operation on an SPTE, it can set the SPTE to REMOVED_SPTE =
as a
> + * multi-part operation on an SPTE, it can set the SPTE to __REMOVED_SPT=
E as a
>   * non-present intermediate value. Other threads which encounter this va=
lue
> - * should not modify the SPTE.
> + * should not modify the SPTE.  For the case that TDX is enabled,
> + * SHADOW_NONPRESENT_VALUE, which is "suppress #VE" bit set because TDX =
module
> + * always enables "EPT violation #VE".  The bit is ignored by non-TDX ca=
se as
> + * present bit (bit 0) is cleared.
>   *
>   * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-pre=
sent on
>   * bot AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create=
 a L1TF
> @@ -184,10 +206,17 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_=
mask;
>   *
>   * Only used by the TDP MMU.
>   */
> -#define REMOVED_SPTE	0x5a0ULL
> +#define __REMOVED_SPTE	0x5a0ULL
> =20
>  /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
> -static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
> +static_assert(!(__REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
> +static_assert(!(__REMOVED_SPTE & SHADOW_NONPRESENT_VALUE));

I don't think you need this.  My understanding of the reason REMOVED_SPTE i=
s
checked against SPTE_MMU_PRESENT_MASK is because they both at low 12 bits.=
=20
SHADOW_NONPRESENT_VALUE is bit 63 so it's not possible to conflict with
REMOVED_SPTE, which by comment only uses low bits.

> +
> +/*
> + * See above comment around __REMOVED_SPTE.  REMOVED_SPTE is the actual
> + * intermediate value set to the removed SPET.  it sets the "suppress #V=
E" bit.
> + */
> +#define REMOVED_SPTE	(SHADOW_NONPRESENT_VALUE | __REMOVED_SPTE)
> =20
>  static inline bool is_removed_spte(u64 spte)
>  {
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7b9265d67131..2ca03ec3bf52 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -692,8 +692,16 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm=
 *kvm,
>  	 * overwrite the special removed SPTE value. No bookkeeping is needed
>  	 * here since the SPTE is going from non-present to non-present.  Use
>  	 * the raw write helper to avoid an unnecessary check on volatile bits.
> +	 *
> +	 * Set non-present value to SHADOW_NONPRESENT_VALUE, rather than 0.
> +	 * It is because when TDX is enabled, TDX module always
> +	 * enables "EPT-violation #VE", so KVM needs to set
> +	 * "suppress #VE" bit in EPT table entries, in order to get
> +	 * real EPT violation, rather than TDVMCALL.  KVM sets
> +	 * SHADOW_NONPRESENT_VALUE (which sets "suppress #VE" bit) so it
> +	 * can be set when EPT table entries are zapped.
>  	 */
> -	__kvm_tdp_mmu_write_spte(iter->sptep, 0);
> +	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
> =20
>  	return 0;
>  }
> @@ -870,8 +878,8 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struc=
t kvm_mmu_page *root,
>  			continue;
> =20
>  		if (!shared)
> -			tdp_mmu_set_spte(kvm, &iter, 0);
> -		else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0))
> +			tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
> +		else if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
>  			goto retry;
>  	}
>  }
> @@ -927,8 +935,9 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_m=
mu_page *sp)
>  	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
>  		return false;
> =20
> -	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
> -			   sp->gfn, sp->role.level + 1, true, true);
> +	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
> +			   SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1,
> +			   true, true);
> =20
>  	return true;
>  }
> @@ -965,7 +974,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct=
 kvm_mmu_page *root,
>  		    !is_last_spte(iter.old_spte, iter.level))
>  			continue;
> =20
> -		tdp_mmu_set_spte(kvm, &iter, 0);
> +		tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
>  		flush =3D true;
>  	}
> =20
> @@ -1330,7 +1339,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct td=
p_iter *iter,
>  	 * invariant that the PFN of a present * leaf SPTE can never change.
>  	 * See __handle_changed_spte().
>  	 */
> -	tdp_mmu_set_spte(kvm, iter, 0);
> +	tdp_mmu_set_spte(kvm, iter, SHADOW_NONPRESENT_VALUE);
> =20
>  	if (!pte_write(range->pte)) {
>  		new_spte =3D kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,

