Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F5657AE1B
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 04:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240068AbiGTCpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 22:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238035AbiGTCpI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 22:45:08 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BDC6247;
        Tue, 19 Jul 2022 19:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658285103; x=1689821103;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=HBOe4ViHeXc6d40CW7gmigWgzEtcInGPzxG/0qygljs=;
  b=NyRIIVW5if0m1muuWC7DeXaltaovO7ChS4TsF9Vc9tyEt6RvUqRAuE9W
   +ZbHAJCZ9XyWifJrsao9TVH2r4Vm9KkGfVGi0fSxVF+nsEltHLJkB+xP2
   t8qM3nQ+SbIYHQ6vIwkuGOsEFqey+zE4h+0zPl848sNGc+gDs8S0O7GNr
   6SRe6s+mlSKBVDTkIc6p5vhH6VZmULx+p2D9DoMq+A/Zi4qnV6RD5zoL+
   NF+NPRF6DKLpwR0Ps/hyhaqIMsCdSOFRpZm5B+3PU8kL2Rjkc19HppuRN
   ABn4aZc5lyAb7qoipXCBavVzzrHa6+7VHN57mNKv13nIvTw9xCsteRB6C
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="372963481"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="372963481"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 19:45:02 -0700
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="656062968"
Received: from ecurtis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.162.137])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 19:45:01 -0700
Message-ID: <ba933bcd69891b868915f3b1ab83084195bad92e.camel@intel.com>
Subject: Re: [PATCH v7 036/102] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>, isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Date:   Wed, 20 Jul 2022 14:44:59 +1200
In-Reply-To: <20220714184111.GT1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <f74b05eca8815744ce1ad672c66033101be7369c.1656366338.git.isaku.yamahata@intel.com>
         <20220714184111.GT1379820@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-14 at 11:41 -0700, Isaku Yamahata wrote:
> Thanks for review. Now here is the updated version.
>=20
> From f1ee540d62ba13511b2c7d3db7662e32bd263e48 Mon Sep 17 00:00:00 2001
> Message-Id: <f1ee540d62ba13511b2c7d3db7662e32bd263e48.1657823906.git.isak=
u.yamahata@intel.com>
> In-Reply-To: <3941849bf08a55cfbbe69b222f0fd0dac7c5ee53.1657823906.git.isa=
ku.yamahata@intel.com>
> References: <3941849bf08a55cfbbe69b222f0fd0dac7c5ee53.1657823906.git.isak=
u.yamahata@intel.com>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> Date: Mon, 29 Jul 2019 19:23:46 -0700
> Subject: [PATCH 036/304] KVM: x86/mmu: Allow non-zero value for non-prese=
nt
>  SPTE
>=20
> TDX introduced a new ETP, Secure-EPT, in addition to the existing EPT.
> Secure-EPT maps protected guest memory, which is called private. Since
> Secure-EPT page tables is also protected, those page tables is also calle=
d
> private.  The existing EPT is often called shared EPT to distinguish from
> Secure-EPT.  And also page tables for shared EPT is also called shared.

AFAICT secure-EPT isn't quite directly related here, so I don't think you s=
hould
spend the paragraph on it.  The first paragraph should state the problem an=
d
catch reviewer's eyeball.

>=20
> TDX module enables #VE injection by setting "EPT-violation #VE" in
> secondary processor-based VM-execution controls of TD VMCS.  It also sets
> "suppress #VE" bit in Secure-EPT so that EPT violation on Secure-EPT caus=
es
> exit to VMM.
>=20
> Because guest memory is protected with TDX, VMM can't parse instructions =
in
> the guest memory.  Instead, MMIO hypercall is used for guest TD to pass
> necessary information to VMM.  To make unmodified device driver work, gue=
st
> TD expects #VE on accessing shared GPA for MMIO. The #VE handler of guest
> TD converts MMIO access into MMIO hypercall.  To trigger #VE in guest TD,
> VMM needs to clear "suppress #VE" bit in shared EPT entry that correspond=
s
> to MMIO address.
>=20
> So the execution flow related for MMIO is as follows
>=20
> - TDX module sets "EPT-violation #VE" in secondary processor-based
>   VM-execution controls of TD VMCS.
> - Allocate page for shared EPT PML4E page. Shared EPT entries are
>   initialized with suppress #VE bit set.  Update the EPTP pointer.
> - TD accesses a GPA for MMIO to trigger EPT violation.  It exits to VMM w=
ith
>   EPT violation due to suppress #VE bit of EPT entries of PML4E page.
> - VMM figures out the faulted GPA is for MMIO
> - start shared EPT page table walk.
> - Allocate non-leaf EPT pages for the shared EPT.
> - Allocate leaf EPT page for the shared EPT and initialize EPT entries wi=
th
>   suppress #VE bit set.
> - VMM clears the suppress #VE bit for faulted GPA for MMIO.
>   Please notice the leaf EPT page has 512 SPTE and other 511 SPTE entries
>   need to keep "suppress #VE" bit set because GPAs for those SPTEs are no=
t
>   known to be MMIO. (It requires further lookups.)
>   If GPA is a guest page, link the guest page from the leaf SPTE entry.
> - resume TD vcpu.
> - Guest TD gets #VE, and converts MMIO access into MMIO hypercall.
> - If the GPA maps guest memory, VMM resolves it with guest pages.

Too many details IMHO.

Also, you forgot to mention the non-zero value for non-present SPTE is not =
just
for MMIO, but also for shared memory.

How about below?

For TD guest, the current way to emulate MMIO doesn't work any more, as KVM=
 is
not able to access the private memory of TD guest and do the emulation.=20
Instead, TD guest expects to receive #VE when it accesses the MMIO and then=
 it
can explicitly makes hypercall to KVM to get the expected information.

To achieve this, the TDX module always enables "EPT-violation #VE" in the V=
MCS
control.  And accordingly, KVM needs to configure the MMIO spte to trigger =
EPT
violation (instead of misconfiguration) and at the same time, also clear th=
e
"suppress #VE" bit so the TD guest can get the #VE instead of causing actua=
l EPT
violation to KVM.

In order for KVM to be able to have chance to set up the correct SPTE for M=
MIO
for TD guest, the default non-present SPTE must have the "suppress #VE" bit=
 set
so KVM can get a real EPT violation for the first time when TD guest access=
es
the MMIO.

Also, when TD guest accesses the actual shared memory, it should continue t=
o
trigger EPT violation to the KVM instead of receiving the #VE  (the TDX mod=
ule
guarantees KVM will receive EPT violation for private memory access).  This
means for the shared memory, the SPTE also must have the "suppress #VE" bit=
 set
for the non-present SPTE.

Add support to allow a non-zero value for the non-present SPTE (i.e. when t=
he
page table is firstly allocated, and when the SPTE is zapped) to allow sett=
ing
"suppress #VE" bit for the non-present SPTE.

Introduce a new macro SHADOW_NONPRESENT_VALUE to be the "suppress #VE" bit.=
=20
Unconditionally set the "suppress #VE" bit (which is bit 63) for both AMD a=
nd
Intel as: 1) AMD hardware doesn't use this bit; 2) for normal VMX guest, KV=
M
never enables the "EPT-violation #VE" in VMCS control and "suppress #VE" bi=
t is
ignored by hardware.

(if you want to set SHADOW_NONPRESENT_VALUE only for TDP MMU then continue =
to
describe, but I don't see this is done in your below patch)

>=20
> SPTEs for shared EPT need suppress #VE" bit set initially when it
> is allocated or zapped, therefore non-zero non-present value for SPTE
> needs to be allowed.
>=20
> TDP MMU uses REMOVED_SPTE =3D 0x5a0ULL as special constant to indicate th=
e
> intermediate value to indicate one thread is operating on it and the valu=
e
> should be semi-arbitrary value.  For TDX (more exactly to use #VE), the
> value should include suppress #VE bit.  Rename REMOVED_SPTE to
> __REMOVED_SPTE and define REMOVED_SPTE as (REMOVED_SPTE | "suppress #VE")
> bit.

IMHO REMOVED_SPTE is implementation details so it's OK to not mention in
changelog.

>=20
> For simplicity, "suppress #VE" bit is set unconditionally for X86_64 for
> non-present SPTE.  Because "suppress #VE" bit (bit position of 63) for
> non-present SPTE is ignored for non-TD case (AMD CPUs or Intel VMX case
> with "EPT-violation #VE" cleared), the functionality shouldn't change.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 71 ++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/mmu/paging_tmpl.h |  3 +-
>  arch/x86/kvm/mmu/spte.c        |  5 ++-
>  arch/x86/kvm/mmu/spte.h        | 28 +++++++++++++-
>  arch/x86/kvm/mmu/tdp_mmu.c     | 23 +++++++----
>  5 files changed, 116 insertions(+), 14 deletions(-)
>=20
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 51306b80f47c..992f31458f94 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -668,6 +668,55 @@ static void walk_shadow_page_lockless_end(struct kvm=
_vcpu *vcpu)
>  	}
>  }
> =20
> +#ifdef CONFIG_X86_64
> +static inline void kvm_init_shadow_page(void *page)
> +{
> +	int ign;
> +
> +	/*
> +	 * AMD: "suppress #VE" bit is ignored
> +	 * Intel non-TD(VMX): "suppress #VE" bit is ignored because
> +	 *   EPT_VIOLATION_VE isn't set.
> +	 * guest TD: TDX module sets EPT_VIOLATION_VE
> +	 *   conventional SEPT: "suppress #VE" bit must be set to get EPT viola=
tion
> +	 *   private SEPT: "suppress #VE" bit is ignored.  CPU doesn't walk it
> +	 *
> +	 * For simplicity, unconditionally initialize SPET to set "suppress #VE=
".
> +	 */
> +	asm volatile ("rep stosq\n\t"
> +		      : "=3Dc"(ign), "=3DD"(page)
> +		      : "a"(SHADOW_NONPRESENT_VALUE), "c"(4096/8), "D"(page)
> +		      : "memory"
> +	);
> +}
> +
> +static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_mmu_memory_cache *mc =3D &vcpu->arch.mmu_shadow_page_cache;
> +	int start, end, i, r;
> +
> +	start =3D kvm_mmu_memory_cache_nr_free_objects(mc);
> +	r =3D kvm_mmu_topup_memory_cache(mc, PT64_ROOT_MAX_LEVEL);
> +
> +	/*
> +	 * Note, topup may have allocated objects even if it failed to allocate
> +	 * the minimum number of objects required to make forward progress _at
> +	 * this time_.  Initialize newly allocated objects even on failure, as
> +	 * userspace can free memory and rerun the vCPU in response to -ENOMEM.
> +	 */
> +	end =3D kvm_mmu_memory_cache_nr_free_objects(mc);
> +	for (i =3D start; i < end; i++)
> +		kvm_init_shadow_page(mc->objects[i]);
> +	return r;
> +}
> +#else
> +static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_mmu_topup_memory_cache(vcpu->arch.mmu_shadow_page_cache,
> +					  PT64_ROOT_MAX_LEVEL);
> +}
> +#endif /* CONFIG_X86_64 */
> +
>  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_ind=
irect)
>  {
>  	int r;
> @@ -677,8 +726,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *v=
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
> @@ -5654,7 +5702,24 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mmu_page_header_cache.kmem_cache =3D mmu_page_header_cache;
>  	vcpu->arch.mmu_page_header_cache.gfp_zero =3D __GFP_ZERO;
> =20
> -	vcpu->arch.mmu_shadow_page_cache.gfp_zero =3D __GFP_ZERO;
> +	/*
> +	 * When X86_64, initial SEPT entries are initialized with
> +	 * SHADOW_NONPRESENT_VALUE.  Otherwise zeroed.  See
> +	 * mmu_topup_shadow_page_cache().
> +	 *
> +	 * Shared EPTEs need to be initialized with SUPPRESS_VE=3D1, otherwise
> +	 * not-present EPT violations would be reflected into the guest by
> +	 * hardware as #VE exceptions.  This is handled by initializing page
> +	 * allocations via kvm_init_shadow_page() during cache topup.
> +	 * In that case, telling the page allocation to zero-initialize the pag=
e
> +	 * would be wasted effort.
> +	 *
> +	 * The initialization is harmless for S-EPT entries because KVM's copy
> +	 * of the S-EPT isn't consumed by hardware, and because under the hood
> +	 * S-EPT entries should never #VE.
> +	 */
> +	if (!IS_ENABLED(X86_64))
> +		vcpu->arch.mmu_shadow_page_cache.gfp_zero =3D __GFP_ZERO;
> =20
>  	vcpu->arch.mmu =3D &vcpu->arch.root_mmu;
>  	vcpu->arch.walk_mmu =3D &vcpu->arch.root_mmu;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmp=
l.h
> index fe35d8fd3276..964ec76579f0 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -1031,7 +1031,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, =
struct kvm_mmu_page *sp)
>  		gpa_t pte_gpa;
>  		gfn_t gfn;
> =20
> -		if (!sp->spt[i])
> +		/* spt[i] has initial value of shadow page table allocation */
> +		if (sp->spt[i] !=3D SHADOW_NONPRESENT_VALUE)
>  			continue;
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
> index 0127bb6e3c7d..f5fd22f6bf5f 100644
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
> @@ -178,16 +191,27 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_=
mask;
>   * non-present intermediate value. Other threads which encounter this va=
lue
>   * should not modify the SPTE.
>   *
> + * For X86_64 case, SHADOW_NONPRESENT_VALUE, "suppress #VE" bit, is set =
because
> + * "EPT violation #VE" in the secondary VM execution control may be enab=
led.
> + * Because TDX module sets "EPT violation #VE" for TD, "suppress #VE" bi=
t for
> + * the conventional EPT needs to be set.
> + *
>   * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-pre=
sent on
>   * bot AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create=
 a L1TF
>   * vulnerability.  Use only low bits to avoid 64-bit immediates.
>   *
>   * Only used by the TDP MMU.
>   */
> -#define REMOVED_SPTE	0x5a0ULL
> +#define __REMOVED_SPTE	0x5a0ULL
> =20
>  /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
> -static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
> +static_assert(!(__REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
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

Since you also always set SHADOW_NONPRESENT_VALUE to SPTE for legacy MMU wh=
en
the page table is firstly allocated, it also makes sense to set it when SPT=
E is
zapped for legacy MMU.

This part is missing in this patch.

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
> --=20
> 2.25.1
>=20
>=20
>=20

