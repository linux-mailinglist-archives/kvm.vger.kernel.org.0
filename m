Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F7E5670B1
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 16:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbiGEOOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 10:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbiGEONF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 10:13:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B1DBE33;
        Tue,  5 Jul 2022 07:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657030064; x=1688566064;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=zeZpdX7gwMqp9yiDW+FI+GnJcGGtkses+Ne4GHyi6w4=;
  b=Z37BUohlj8AYbjiPN9kOqnc0HxLGMT6QUNlGrW9ZYQ4fOSRw0I4bBcD0
   2dW4HRlnkHP3n5AkRJzO/BwmgxceKonL560NgbQ7kRj3QxhI7d8if5RC5
   /FIBOURZrBrooKfRQ4wUKmzONu+GWj/2lKIfzMJ+deq3Iod/6b6HvzKXD
   S1J2i4RvzmEf4Gy2vQhiGI/Ve+8ZgH431FpB1loauMikSQkTUyNoSGlrV
   hQVVn8NWpkmfd4FPcIPeyNjLaP53N8TyD8H/KBMZvJw/4hXikMR84Wb3k
   JJaDMvULz+nhw7Ubm1OXA29YUgr9S3mzP2ok51ISBIfxLVy2ejxEwKKlx
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="282117376"
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="282117376"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 07:06:31 -0700
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="597304965"
Received: from atornero-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.166.122])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 07:06:29 -0700
Message-ID: <4c59eddd8f1d5029be8eeac84fbb75131b984568.camel@intel.com>
Subject: Re: [PATCH v7 037/102] KVM: x86/mmu: Track shadow MMIO value/mask
 on a per-VM basis
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Wed, 06 Jul 2022 02:06:27 +1200
In-Reply-To: <242df8a7164b593d3702b9ba94889acd11f43cbb.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <242df8a7164b593d3702b9ba94889acd11f43cbb.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>=20
> TDX will use a different shadow PTE entry value for MMIO from VMX.  Add
> members to kvm_arch and track value for MMIO per-VM instead of global
> variables.  By using the per-VM EPT entry value for MMIO, the existing VM=
X
> logic is kept working.
>=20
> In the case of VMX VM case, the EPT entry for MMIO is non-present PTE
> (present bit cleared) without backing guest physical address (on EPT
> violation, KVM searches backing guest memory and it finds there is no
> backing guest page.) or the value to trigger EPT misconfiguration.  Once
> MMIO is triggered on the EPT entry, the EPT entry is updated to trigger E=
PT
> misconfiguration for the future MMIO on the same GPA.  It allows KVM to
> understand the memory access is for MMIO without searching backing guest
> pages.). And then KVM parses guest instruction to figure out
> address/value/width for MMIO.
>=20
> In the case of the guest TD, the guest memory is protected so that VMM
> can't parse guest instruction to understand the value and access width fo=
r
> MMIO.  Instead, VMM sets up (Shared) EPT to trigger #VE by clearing
> the VE-suppress bit.  When the guest TD issues MMIO, #VE is injected.  Gu=
est VE
> handler converts MMIO access into MMIO hypercall to pass
> address/value/width for MMIO to VMM. (or directly paravirtualize MMIO int=
o
> hypercall.)  Then VMM can handle the MMIO hypercall without parsing guest
> instructions.

To me only first paragraph is needed.  It already describes _why_ we need t=
his
patch and _how_ you are going to implement. =C2=A0

The last two paragraphs only elaborate the _why_ in the first paragraph, bu=
t
they does not say this patch will do more.  And they have been explained in
previous patches so looks they are not mandatory here.

>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  4 ++++
>  arch/x86/include/asm/vmx.h      |  1 +
>  arch/x86/kvm/mmu.h              |  4 +++-
>  arch/x86/kvm/mmu/mmu.c          | 20 ++++++++++++----
>  arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
>  arch/x86/kvm/mmu/spte.c         | 41 +++++++++++++++------------------
>  arch/x86/kvm/mmu/spte.h         | 11 ++++-----
>  arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++---
>  arch/x86/kvm/svm/svm.c          |  2 +-
>  arch/x86/kvm/vmx/vmx.c          |  8 +++++++
>  10 files changed, 59 insertions(+), 40 deletions(-)
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
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index c371ef695fcc..6231ef005a50 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -511,6 +511,7 @@ enum vmcs_field {
>  #define VMX_EPT_IPAT_BIT    			(1ull << 6)
>  #define VMX_EPT_ACCESS_BIT			(1ull << 8)
>  #define VMX_EPT_DIRTY_BIT			(1ull << 9)
> +#define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)

Both the patch title and the changelog say this patch only does per-VM MMIO
value/mask tracking.  Why do we need this bit here?

>  #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |=
       \
>  						 VMX_EPT_WRITABLE_MASK |       \
>  						 VMX_EPT_EXECUTABLE_MASK)
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index ccf0ba7a6387..9ba60fd79d33 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -108,7 +108,9 @@ static inline u8 kvm_get_shadow_phys_bits(void)
>  	return boot_cpu_data.x86_phys_bits;
>  }
> =20
> -void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 acces=
s_mask);
> +void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value, u64 mmi=
o_mask,
> +				u64 access_mask);
> +void kvm_mmu_set_default_mmio_spte_mask(u64 mask);
>  void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
>  void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
> =20
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f239b6cb5d53..496d0d30839b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2287,7 +2287,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct=
 kvm_mmu_page *sp,
>  				return kvm_mmu_prepare_zap_page(kvm, child,
>  								invalid_list);
>  		}
> -	} else if (is_mmio_spte(pte)) {
> +	} else if (is_mmio_spte(kvm, pte)) {
>  		mmu_spte_clear_no_track(spte);
>  	}
>  	return 0;
> @@ -3067,8 +3067,13 @@ static int handle_abnormal_pfn(struct kvm_vcpu *vc=
pu, struct kvm_page_fault *fau
>  		 * by L0 userspace (you can observe gfn > L1.MAXPHYADDR if
>  		 * and only if L1's MAXPHYADDR is inaccurate with respect to
>  		 * the hardware's).
> +		 *
> +		 * Excludes the INTEL TD guest.  Because TD memory is
> +		 * protected, the instruction can't be emulated.  Instead, use
> +		 * SPTE value without #VE suppress bit cleared
> +		 * (kvm->arch.shadow_mmio_value =3D 0).
>  		 */

Again, I don't think this chunk should be in this patch.  It's out-of-scope=
 of
what the patch claims to do.

I see you will make below code change in later patch (couple of patches lat=
er):

-		if (unlikely(!vcpu->kvm->arch.enable_mmio_caching) ||
+		if (unlikely(!vcpu->kvm->arch.enable_mmio_caching &&
+			     !kvm_gfn_shared_mask(vcpu->kvm)) ||
 		    unlikely(fault->gfn > kvm_mmu_max_gfn()))
 			return RET_PF_EMULATE;

So why not putting the comment and the code change together?

> -		if (unlikely(!enable_mmio_caching) ||
> +		if (unlikely(!vcpu->kvm->arch.enable_mmio_caching) ||
>  		    unlikely(fault->gfn > kvm_mmu_max_gfn()))
>  			return RET_PF_EMULATE;
>  	}
> @@ -3200,7 +3205,8 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, s=
truct kvm_page_fault *fault)
>  		else
>  			sptep =3D fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
> =20
> -		if (!is_shadow_present_pte(spte) || is_mmio_spte(spte))
> +		if (!is_shadow_present_pte(spte) ||
> +		    is_mmio_spte(vcpu->kvm, spte))
>  			break;
> =20
>  		sp =3D sptep_to_sp(sptep);
> @@ -3907,7 +3913,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *=
vcpu, u64 addr, bool direct)
>  	if (WARN_ON(reserved))
>  		return -EINVAL;
> =20
> -	if (is_mmio_spte(spte)) {
> +	if (is_mmio_spte(vcpu->kvm, spte)) {
>  		gfn_t gfn =3D get_mmio_spte_gfn(spte);
>  		unsigned int access =3D get_mmio_spte_access(spte);
> =20
> @@ -4350,7 +4356,7 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
>  static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
>  			   unsigned int access)
>  {
> -	if (unlikely(is_mmio_spte(*sptep))) {
> +	if (unlikely(is_mmio_spte(vcpu->kvm, *sptep))) {
>  		if (gfn !=3D get_mmio_spte_gfn(*sptep)) {
>  			mmu_spte_clear_no_track(sptep);
>  			return true;
> @@ -5864,6 +5870,10 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>  	node->track_write =3D kvm_mmu_pte_write;
>  	node->track_flush_slot =3D kvm_mmu_invalidate_zap_pages_in_memslot;
>  	kvm_page_track_register_notifier(kvm, node);
> +	kvm_mmu_set_mmio_spte_mask(kvm, shadow_default_mmio_mask,
> +				   shadow_default_mmio_mask,
> +				   ACC_WRITE_MASK | ACC_USER_MASK);
> +

This (along with shadow_default_mmio_mask) looks a little bit weird.  Pleas=
e
also see comments below.
=20
>  	return 0;
>  }
> =20
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmp=
l.h
> index ee2fb0c073f3..62ae590d4e5b 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -1032,7 +1032,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, =
struct kvm_mmu_page *sp)
>  		gfn_t gfn;
> =20
>  		if (!is_shadow_present_pte(sp->spt[i]) &&
> -		    !is_mmio_spte(sp->spt[i]))
> +		    !is_mmio_spte(vcpu->kvm, sp->spt[i]))
>  			continue;
> =20
>  		pte_gpa =3D first_pte_gpa + i * sizeof(pt_element_t);
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index bd441458153f..5194aef60c1f 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -29,8 +29,7 @@ u64 __read_mostly shadow_x_mask; /* mutual exclusive wi=
th nx_mask */
>  u64 __read_mostly shadow_user_mask;
>  u64 __read_mostly shadow_accessed_mask;
>  u64 __read_mostly shadow_dirty_mask;
> -u64 __read_mostly shadow_mmio_value;
> -u64 __read_mostly shadow_mmio_mask;
> +u64 __read_mostly shadow_default_mmio_mask;

This shadow_default_mmio_mask looks a little bit weird.  Please also see be=
low.

>  u64 __read_mostly shadow_mmio_access_mask;
>  u64 __read_mostly shadow_present_mask;
>  u64 __read_mostly shadow_me_value;
> @@ -62,10 +61,11 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, un=
signed int access)
>  	u64 spte =3D generation_mmio_spte_mask(gen);
>  	u64 gpa =3D gfn << PAGE_SHIFT;
> =20
> -	WARN_ON_ONCE(!shadow_mmio_value);
> +	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value &&
> +		     !kvm_gfn_shared_mask(vcpu->kvm));

Chunk shouldn't belong to  this patch.

> =20
>  	access &=3D shadow_mmio_access_mask;
> -	spte |=3D shadow_mmio_value | access;
> +	spte |=3D vcpu->kvm->arch.shadow_mmio_value | access;
>  	spte |=3D gpa | shadow_nonpresent_or_rsvd_mask;
>  	spte |=3D (gpa & shadow_nonpresent_or_rsvd_mask)
>  		<< SHADOW_NONPRESENT_OR_RSVD_MASK_LEN;
> @@ -337,7 +337,8 @@ u64 mark_spte_for_access_track(u64 spte)
>  	return spte;
>  }
> =20
> -void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 acces=
s_mask)
> +void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value, u64 mmi=
o_mask,
> +				u64 access_mask)
>  {
>  	BUG_ON((u64)(unsigned)access_mask !=3D access_mask);
>  	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
> @@ -366,11 +367,9 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 =
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
> +	kvm->arch.enable_mmio_caching =3D !!mmio_value;
> +	kvm->arch.shadow_mmio_value =3D mmio_value;
> +	kvm->arch.shadow_mmio_mask =3D mmio_mask;
>  	shadow_mmio_access_mask =3D access_mask;
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
> @@ -393,24 +392,18 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool h=
as_exec_only)
>  	shadow_dirty_mask	=3D has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
>  	shadow_nx_mask		=3D 0ull;
>  	shadow_x_mask		=3D VMX_EPT_EXECUTABLE_MASK;
> -	shadow_present_mask	=3D has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
> +	/* VMX_EPT_SUPPRESS_VE_BIT is needed for W or X violation. */
> +	shadow_present_mask	=3D
> +		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | VMX_EPT_SUPPRESS_VE_B=
IT;

Again, this chunk shouldn't be in this patch.

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
> @@ -459,9 +452,13 @@ void kvm_mmu_reset_all_pte_masks(void)
>  	 * PTEs and so the reserved PA approach must be disabled.
>  	 */
>  	if (shadow_phys_bits < 52)
> -		mask =3D BIT_ULL(51) | PT_PRESENT_MASK;
> +		shadow_default_mmio_mask =3D BIT_ULL(51) | PT_PRESENT_MASK;
>  	else
> -		mask =3D 0;
> +		shadow_default_mmio_mask =3D 0;
> +}

Shadow_default_mmio_mask alone looks a little bit weird with per-VM MMIO
tracking.  I think it can be removed by moving this code to vmx_vm_init(), =
and
call it as VM's MMIO mask/value for non-EPT case.  If EPT is enabled, it ca=
n
override using new mask/value.

> =20
> -	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
> +void kvm_mmu_set_default_mmio_spte_mask(u64 mask)
> +{
> +	shadow_default_mmio_mask =3D mask;
>  }
> +EXPORT_SYMBOL_GPL(kvm_mmu_set_default_mmio_spte_mask);
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 1bfedbe0585f..96312ab4fffb 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -5,8 +5,6 @@
> =20
>  #include "mmu_internal.h"
> =20
> -extern bool __read_mostly enable_mmio_caching;
> -
>  /*
>   * A MMU present SPTE is backed by actual memory and may or may not be p=
resent
>   * in hardware.  E.g. MMIO SPTEs are not considered present.  Use bit 11=
, as it
> @@ -160,8 +158,7 @@ extern u64 __read_mostly shadow_x_mask; /* mutual exc=
lusive with nx_mask */
>  extern u64 __read_mostly shadow_user_mask;
>  extern u64 __read_mostly shadow_accessed_mask;
>  extern u64 __read_mostly shadow_dirty_mask;
> -extern u64 __read_mostly shadow_mmio_value;
> -extern u64 __read_mostly shadow_mmio_mask;
> +extern u64 __read_mostly shadow_default_mmio_mask;
>  extern u64 __read_mostly shadow_mmio_access_mask;
>  extern u64 __read_mostly shadow_present_mask;
>  extern u64 __read_mostly shadow_me_value;
> @@ -233,10 +230,10 @@ static inline bool is_removed_spte(u64 spte)
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
> +		likely(kvm->arch.enable_mmio_caching || kvm_gfn_shared_mask(kvm));
>  }

This chunk (checking kvm_gfn_shared_mask(kvm)) should not be in this patch.=
=20

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
> index 815a07c594f1..0abc43d6a115 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4870,7 +4870,7 @@ static __init void svm_adjust_mmio_mask(void)
>  	 */
>  	mask =3D (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : =
0;
> =20
> -	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK)=
;
> +	kvm_mmu_set_default_mmio_spte_mask(mask);

SVM doesn't need shadow_default_mmio_mask.  Instead, it can define a local
variable in svm.c, and call kvm_mmu_set_mmio_spte_mask(mask, mask,
PT_WRITABLE_MASK | PT_USER_MASK) in svm_vm_init().

>  }
> =20
>  static __init void svm_set_cpu_caps(void)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1d87885245cc..e2415ac55317 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7289,6 +7289,14 @@ int vmx_vm_init(struct kvm *kvm)
>  	if (!ple_gap)
>  		kvm->arch.pause_in_guest =3D true;
> =20
> +	/*
> +	 * EPT Misconfigurations can be generated if the value of bits 2:0
> +	 * of an EPT paging-structure entry is 110b (write/execute).
> +	 */
> +	if (enable_ept)
> +		kvm_mmu_set_mmio_spte_mask(kvm, VMX_EPT_MISCONFIG_WX_VALUE,
> +					   VMX_EPT_RWX_MASK, 0);
> +

As commented above, I think we can remove shadow_default_mmio_mask by movin=
g the
logic in kvm_mmu_reset_all_pte_mask() here.

Or use SVM similar way, use a local variable 'mask' in vmx.c, calculate the
'mask' during hardware_setup(), and use it here for non-EPT case.


>  	if (boot_cpu_has(X86_BUG_L1TF) && enable_ept) {
>  		switch (l1tf_mitigation) {
>  		case L1TF_MITIGATION_OFF:

