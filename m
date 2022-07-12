Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6972570F11
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 02:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbiGLAsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 20:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiGLAsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 20:48:02 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2382726552;
        Mon, 11 Jul 2022 17:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657586881; x=1689122881;
  h=message-id:subject:from:to:cc:in-reply-to:references:
   content-transfer-encoding:mime-version:date;
  bh=nH4mkYUxlZ4NDHjLBgrkPB/rNcQ+2utEYPNIrkpF1t4=;
  b=hi6XlghqFM114sC0e62+CBMGtfNgAXPGV0FV/iPcvR3pFa2jnrpmm9eJ
   cT7BT0GlZDXI/swqszIeVuv3srsoCR96KjWFmWIyU7qcKPwNtp3v3ptF+
   Uh0FfLPw0Pu+XzpxevxfxwTElwcNdFr5GsVJBDjzEkcgMra085ntsp/Qb
   2SOELUETMtG3xySWnFWZTdZwTv5XYgcEx64vL/Zgc5GyLcn9Ad2vcIJaa
   pyFjg8pKCflaE21GIxfK3I6moD8BB418iJRWFfbCTJ3VI6O+TJ1ABhyph
   1hLaij/5I/Otbmd8W6/v2Y98by3YjL9ScEbLwkjTdnCd6PDSv9XHY0lng
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="284832677"
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="284832677"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 17:47:58 -0700
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="569989212"
Received: from snaskant-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.60.27])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 17:47:57 -0700
Message-ID: <c2502234329e267f23c83fde35461cc471648e03.camel@intel.com>
Subject: Re: [PATCH v7 006/102] KVM: TDX: Detect CPU feature on kernel
 module initialization
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220711234853.GA1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <85209122d5af1a3185ff58d13528284d91035100.1656366338.git.isaku.yamahata@intel.com>
         <e1d91a805be75384e9caa76f4196a2feb4709dc1.camel@intel.com>
         <20220711234853.GA1379820@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Date:   Tue, 12 Jul 2022 12:45:26 +1200
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-07-11 at 16:48 -0700, Isaku Yamahata wrote:
> On Tue, Jun 28, 2022 at 03:43:00PM +1200,
> Kai Huang <kai.huang@intel.com> wrote:
>=20
> > On Mon, 2022-06-27 at 14:52 -0700, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > >=20
> > > TDX requires several initialization steps for KVM to create guest TDs=
.
> > > Detect CPU feature, enable VMX (TDX is based on VMX), detect TDX modu=
le
> > > availability, and initialize TDX module.  This patch implements the f=
irst
> > > step to detect CPU feature.  Because VMX isn't enabled yet by VMXON
> > > instruction on KVM kernel module initialization, defer further
> > > initialization step until VMX is enabled by hardware_enable callback.
> >=20
> > Not clear why you need to split into multiple patches.  If we put all
> > initialization into one patch, it's much easier to see why those steps =
are done
> > in whatever way.
>=20
> I moved down this patch before "KVM: TDX: Initialize TDX module when load=
ing
> kvm_intel.ko". So the patch flow is, - detect tdx cpu feature, and then
> - initialize tdx module.

Unable to comment until see the actual patch/code.  My point is this series=
 is
already very big (107 patches!!).  We should avoid splitting code chunks to
small patches when there's no real benefits.  For instance, when the code c=
hange
is an infrastructural patch so logically can and should be separated (also
easier to review).  Or when the patch is too big (thus hard to review) and
splitting "dependencies" into smaller patches that can help to review.

To me this patch (and init TDX module) doesn't belong to any of above.  The=
 only
piece in this patch that makes sense to me is below:

	if (!enable_ept) {
		pr_warn("Cannot enable TDX with EPT disabled\n");
		return -EINVAL;
	}

	if (!platform_tdx_enabled()) {
		pr_warn("Cannot enable TDX on TDX disabled platform\n");
		return -ENODEV;
	}

And I don't see why it cannot be done together with initializing TDX module=
.

Btw, I do see in the init TDX module patch, you did more than tdx_init() su=
ch as
setting up 'tdx_capabilities' etc.  To me it makes more sense to split that=
 part
out (if necessary) with some explanation why we need those 'tdx_capabilitie=
s'
after tdx_init().
=09
>=20
>=20
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > new file mode 100644
> > > index 000000000000..c12e61cdddea
> > > --- /dev/null
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -0,0 +1,40 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +#include <linux/cpu.h>
> > > +
> > > +#include <asm/tdx.h>
> > > +
> > > +#include "capabilities.h"
> > > +#include "x86_ops.h"
> > > +
> > > +#undef pr_fmt
> > > +#define pr_fmt(fmt) "tdx: " fmt
> > > +
> > > +static u64 hkid_mask __ro_after_init;
> > > +static u8 hkid_start_pos __ro_after_init;
> > > +
> > > +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> > > +{
> > > +	u32 max_pa;
> > > +
> > > +	if (!enable_ept) {
> > > +		pr_warn("Cannot enable TDX with EPT disabled\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	if (!platform_tdx_enabled()) {
> > > +		pr_warn("Cannot enable TDX on TDX disabled platform\n");
> > > +		return -ENODEV;
> > > +	}
> > > +
> > > +	/* Safe guard check because TDX overrides tlb_remote_flush callback=
. */
> > > +	if (WARN_ON_ONCE(x86_ops->tlb_remote_flush))
> > > +		return -EIO;
> >=20
> > To me it's better to move this chunk to the patch which actually implem=
ents how
> > to flush TLB foro private pages.  W/o some background, it's hard to tel=
l why TDX
> > needs to overrides tlb_remote_flush callback.  Otherwise it's quite har=
d to
> > review here.
> >=20
> > For instance, even if it must be replaced, I am wondering why it must b=
e empty
> > at the beginning?  For instance, assuming it has an original version wh=
ich does
> > something:
> >=20
> > 	x86_ops->tlb_remote_flush =3D vmx_remote_flush;
> >=20
> > Why cannot it be replaced with vt_tlb_remote_flush():
> >=20
> > 	int vt_tlb_remote_flush(struct kvm *kvm)
> > 	{
> > 		if (is_td(kvm))
> > 			return tdx_tlb_remote_flush(kvm);
> >=20
> > 		return vmx_remote_flush(kvm);
> > 	}
> >=20
> > ?
>=20
> There is a bit tricky part.  Anyway I rewrote to follow this way.  Here i=
s a
> preparation patch to allow such direction.
>=20
> Subject: [PATCH 055/290] KVM: x86/VMX: introduce vmx tlb_remote_flush and
>  tlb_remote_flush_with_range
>=20
> This is preparation for TDX to define its own tlb_remote_flush and
> tlb_remote_flush_with_range.  Currently vmx code defines tlb_remote_flush
> and tlb_remote_flush_with_range defined as NULL by default and only when
> nested hyper-v guest case, they are defined to non-NULL methods.
>=20
> To make TDX code to override those two methods consistently with other
> methods, define vmx_tlb_remote_flush and vmx_tlb_remote_flush_with_range
> as nop and call hyper-v code only when nested hyper-v guest case.

So why put into this patch which does "Detect CPU feature on kernel module
initialization"?

(btw, can you improve patch title to be more specific on which CPU feature =
on
which kernel module initialization?)

Even with your above explanation, it's hard to justify why we need this, be=
cause
you didn't explain _why_ we need to "make TDX code to override those two
methods".

Makes sense?

Skip below code now as I'd like to see that in a separate patch.

>=20
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/kvm_onhyperv.c     |  5 ++++-
>  arch/x86/kvm/kvm_onhyperv.h     |  1 +
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  arch/x86/kvm/svm/svm_onhyperv.h |  1 +
>  arch/x86/kvm/vmx/main.c         |  2 ++
>  arch/x86/kvm/vmx/vmx.c          | 34 ++++++++++++++++++++++++++++-----
>  arch/x86/kvm/vmx/x86_ops.h      |  3 +++
>  7 files changed, 41 insertions(+), 7 deletions(-)
>=20
> diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
> index ee4f696a0782..d43518da1c0e 100644
> --- a/arch/x86/kvm/kvm_onhyperv.c
> +++ b/arch/x86/kvm/kvm_onhyperv.c
> @@ -93,11 +93,14 @@ int hv_remote_flush_tlb(struct kvm *kvm)
>  }
>  EXPORT_SYMBOL_GPL(hv_remote_flush_tlb);
> =20
> +bool hv_use_remote_flush_tlb __ro_after_init;
> +EXPORT_SYMBOL_GPL(hv_use_remote_flush_tlb);
> +
>  void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
>  {
>  	struct kvm_arch *kvm_arch =3D &vcpu->kvm->arch;
> =20
> -	if (kvm_x86_ops.tlb_remote_flush =3D=3D hv_remote_flush_tlb) {
> +	if (hv_use_remote_flush_tlb) {
>  		spin_lock(&kvm_arch->hv_root_tdp_lock);
>  		vcpu->arch.hv_root_tdp =3D root_tdp;
>  		if (root_tdp !=3D kvm_arch->hv_root_tdp)
> diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
> index 287e98ef9df3..9a07a34666fb 100644
> --- a/arch/x86/kvm/kvm_onhyperv.h
> +++ b/arch/x86/kvm/kvm_onhyperv.h
> @@ -10,6 +10,7 @@
>  int hv_remote_flush_tlb_with_range(struct kvm *kvm,
>  		struct kvm_tlb_range *range);
>  int hv_remote_flush_tlb(struct kvm *kvm);
> +extern bool hv_use_remote_flush_tlb __ro_after_init;
>  void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
>  #else /* !CONFIG_HYPERV */
>  static inline void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_t=
dp)
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ef925722ee28..a11c78c8831b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -264,7 +264,7 @@ static void kvm_flush_remote_tlbs_with_range(struct k=
vm *kvm,
>  {
>  	int ret =3D -ENOTSUPP;
> =20
> -	if (range && kvm_x86_ops.tlb_remote_flush_with_range)
> +	if (range && kvm_available_flush_tlb_with_range())
>  		ret =3D static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, range);
> =20
>  	if (ret)
> diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyp=
erv.h
> index e2fc59380465..b3cd61c62305 100644
> --- a/arch/x86/kvm/svm/svm_onhyperv.h
> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
> @@ -36,6 +36,7 @@ static inline void svm_hv_hardware_setup(void)
>  		svm_x86_ops.tlb_remote_flush =3D hv_remote_flush_tlb;
>  		svm_x86_ops.tlb_remote_flush_with_range =3D
>  				hv_remote_flush_tlb_with_range;
> +		hv_use_remote_flush_tlb =3D true;
>  	}
> =20
>  	if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH) {
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 252b7298b230..e52e12b8d49a 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -187,6 +187,8 @@ struct kvm_x86_ops vt_x86_ops __initdata =3D {
> =20
>  	.flush_tlb_all =3D vmx_flush_tlb_all,
>  	.flush_tlb_current =3D vmx_flush_tlb_current,
> +	.tlb_remote_flush =3D vmx_tlb_remote_flush,
> +	.tlb_remote_flush_with_range =3D vmx_tlb_remote_flush_with_range,
>  	.flush_tlb_gva =3D vmx_flush_tlb_gva,
>  	.flush_tlb_guest =3D vmx_flush_tlb_guest,
> =20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5b8d399dd319..dc7ede3706e1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3110,6 +3110,33 @@ void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
>  		vpid_sync_context(vmx_get_current_vpid(vcpu));
>  }
> =20
> +int vmx_tlb_remote_flush(struct kvm *kvm)
> +{
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	if (hv_use_tlb_remote_flush)
> +		return hv_remote_flush_tlb(kvm);
> +#endif
> +	/*
> +	 * fallback to KVM_REQ_TLB_FLUSH.
> +	 * See kvm_arch_flush_remote_tlb() and kvm_flush_remote_tlbs().
> +	 */
> +	return -EOPNOTSUPP;
> +}
> +
> +int vmx_tlb_remote_flush_with_range(struct kvm *kvm,
> +				    struct kvm_tlb_range *range)
> +{
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	if (hv_use_tlb_remote_flush)
> +		return hv_remote_flush_tlb_with_range(kvm, range);
> +#endif
> +	/*
> +	 * fallback to tlb_remote_flush. See
> +	 * kvm_flush_remote_tlbs_with_range()
> +	 */
> +	return -EOPNOTSUPP;
> +}
> +
>  void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
>  {
>  	/*
> @@ -8176,11 +8203,8 @@ __init int vmx_hardware_setup(void)
> =20
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	if (ms_hyperv.nested_features & HV_X64_NESTED_GUEST_MAPPING_FLUSH
> -	    && enable_ept) {
> -		vt_x86_ops.tlb_remote_flush =3D hv_remote_flush_tlb;
> -		vt_x86_ops.tlb_remote_flush_with_range =3D
> -				hv_remote_flush_tlb_with_range;
> -	}
> +	    && enable_ept)
> +		hv_use_tlb_remote_flush =3D true;
>  #endif
> =20
>  	if (!cpu_has_vmx_ple()) {
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index e70f84d29d21..5ecf99170b30 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -90,6 +90,9 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned lon=
g rflags);
>  bool vmx_get_if_flag(struct kvm_vcpu *vcpu);
>  void vmx_flush_tlb_all(struct kvm_vcpu *vcpu);
>  void vmx_flush_tlb_current(struct kvm_vcpu *vcpu);
> +int vmx_tlb_remote_flush(struct kvm *kvm);
> +int vmx_tlb_remote_flush_with_range(struct kvm *kvm,
> +				    struct kvm_tlb_range *range);
>  void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr);
>  void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu);
>  void vmx_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask);
> --=20
> 2.25.1
>=20
>=20
> > > +
> > > +	max_pa =3D cpuid_eax(0x80000008) & 0xff;
> > > +	hkid_start_pos =3D boot_cpu_data.x86_phys_bits;
> > > +	hkid_mask =3D GENMASK_ULL(max_pa - 1, hkid_start_pos);
> > > +	pr_info("kvm: TDX is supported. hkid start pos %d mask 0x%llx\n",
> > > +		hkid_start_pos, hkid_mask);
> >=20
> > Again, I think it's better to introduce those in the patch where you ac=
tually
> > need those.  It will be more clear if you introduce those with the code=
 which
> > actually uses them.
> >=20
> > For instance, I think both hkid_start_pos and hkid_mask are not necessa=
ry.  If
> > you want to apply one keyid to an address, isn't below enough?
> >=20
> > 	u64 phys |=3D ((keyid) << boot_cpu_data.x86_phys_bits);
>=20
> Nice catch.  I removed max_pa, hkid_start_pos and hkid_mask.

Regardless whether you need 'max_pa, hkid_start_pos and hkid_mask', the poi=
nt is
it's better to introduce when you really need them.

They are not big chunk which needs to be separated out to improve readabili=
ty.

>=20
>=20
> > > diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> > > index 0f8a8547958f..0a5967a91e26 100644
> > > --- a/arch/x86/kvm/vmx/x86_ops.h
> > > +++ b/arch/x86/kvm/vmx/x86_ops.h
> > > @@ -122,4 +122,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
> > >  #endif
> > >  void vmx_setup_mce(struct kvm_vcpu *vcpu);
> > > =20
> > > +#ifdef CONFIG_INTEL_TDX_HOST
> > > +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
> > > +#else
> > > +static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { =
return 0; }
> > > +#endif
> >=20
> > I think if you introduce a "tdx_ops.h", or "tdx_x86_ops.h", and you can=
 only
> > include it when CONFIG_INTEL_TDX_HOST is true, then in tdx_ops.h you do=
n't need
> > those stubs.
> >=20
> > Makes sense?
>=20
> main.c includes many tdx_xxx().  If we do so without stubs, many
> CONFIG_INTEL_TDX_HOST in main.c.

OK.

