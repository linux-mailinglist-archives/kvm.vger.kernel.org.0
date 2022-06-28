Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7284B55C29A
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243464AbiF1DnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 23:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbiF1DnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 23:43:05 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2DFC53;
        Mon, 27 Jun 2022 20:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656387784; x=1687923784;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=aSlpQmaqRYVz05C6ZYir6FFaaZREMYtKlRt5Uu+Gijo=;
  b=O2jdAxrvWNNe9rbV9UX0ObzVEgRJRpXVfZlceX67qb6BaovgqBogy5h3
   R/SxG7ZNc57WCp3KiiOKPfLFeHcW0AgWsLyHokmwiks4wVFah9l1DlYpn
   Mn/rCnAkJN797nvbuP0Wi9UAWvcJHRzf8GmS//7aBAobEtKVgjcHlBAzR
   +z+NyUvQMLElOp0N/e2Dt/CiDId3oIfWzit3TG7rc9cmxK4CKtnpTZWUF
   rJusDg99MLA673bnUcsLBe3CixTB4DM+aY6ek/w8osMCF4frN1ofWq/jv
   yMhKe2t+2jDBlAHEzHJH8nbLJ9e4i+vBVBXgcDurfGNUDnSuh73f2qz5/
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="345622564"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="345622564"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 20:43:03 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="717291084"
Received: from eachuh-x1-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.72.164])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 20:43:02 -0700
Message-ID: <e1d91a805be75384e9caa76f4196a2feb4709dc1.camel@intel.com>
Subject: Re: [PATCH v7 006/102] KVM: TDX: Detect CPU feature on kernel
 module initialization
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 28 Jun 2022 15:43:00 +1200
In-Reply-To: <85209122d5af1a3185ff58d13528284d91035100.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <85209122d5af1a3185ff58d13528284d91035100.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:52 -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>=20
> TDX requires several initialization steps for KVM to create guest TDs.
> Detect CPU feature, enable VMX (TDX is based on VMX), detect TDX module
> availability, and initialize TDX module.  This patch implements the first
> step to detect CPU feature.  Because VMX isn't enabled yet by VMXON
> instruction on KVM kernel module initialization, defer further
> initialization step until VMX is enabled by hardware_enable callback.

Not clear why you need to split into multiple patches.  If we put all
initialization into one patch, it's much easier to see why those steps are =
done
in whatever way.

>=20
> Introduce a module parameter, enable_tdx, to explicitly enable TDX KVM
> support.  It's off by default to keep same behavior for those who don't u=
se
> TDX.  Implement CPU feature detection at KVM kernel module initialization
> as hardware_setup callback to check if CPU feature is available and get
> some CPU parameters.
>=20
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/Makefile      |  1 +
>  arch/x86/kvm/vmx/main.c    | 18 ++++++++++++++++-
>  arch/x86/kvm/vmx/tdx.c     | 40 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/x86_ops.h |  6 ++++++
>  4 files changed, 64 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/kvm/vmx/tdx.c
>=20
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index ee4d0999f20f..e2c05195cb95 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -24,6 +24,7 @@ kvm-$(CONFIG_KVM_XEN)	+=3D xen.o
>  kvm-intel-y		+=3D vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
>  			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o vmx/main.o
>  kvm-intel-$(CONFIG_X86_SGX_KVM)	+=3D vmx/sgx.o
> +kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+=3D vmx/tdx.o
> =20
>  kvm-amd-y		+=3D svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.=
o svm/sev.o
> =20
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 636768f5b985..fabf5f22c94f 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -6,6 +6,22 @@
>  #include "nested.h"
>  #include "pmu.h"
> =20
> +static bool __read_mostly enable_tdx =3D IS_ENABLED(CONFIG_INTEL_TDX_HOS=
T);
> +module_param_named(tdx, enable_tdx, bool, 0444);
> +
> +static __init int vt_hardware_setup(void)
> +{
> +	int ret;
> +
> +	ret =3D vmx_hardware_setup();
> +	if (ret)
> +		return ret;
> +
> +	enable_tdx =3D enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
> +
> +	return 0;
> +}
> +
>  struct kvm_x86_ops vt_x86_ops __initdata =3D {
>  	.name =3D "kvm_intel",
> =20
> @@ -147,7 +163,7 @@ struct kvm_x86_ops vt_x86_ops __initdata =3D {
>  struct kvm_x86_init_ops vt_init_ops __initdata =3D {
>  	.cpu_has_kvm_support =3D vmx_cpu_has_kvm_support,
>  	.disabled_by_bios =3D vmx_disabled_by_bios,
> -	.hardware_setup =3D vmx_hardware_setup,
> +	.hardware_setup =3D vt_hardware_setup,
>  	.handle_intel_pt_intr =3D NULL,
> =20
>  	.runtime_ops =3D &vt_x86_ops,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> new file mode 100644
> index 000000000000..c12e61cdddea
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -0,0 +1,40 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/cpu.h>
> +
> +#include <asm/tdx.h>
> +
> +#include "capabilities.h"
> +#include "x86_ops.h"
> +
> +#undef pr_fmt
> +#define pr_fmt(fmt) "tdx: " fmt
> +
> +static u64 hkid_mask __ro_after_init;
> +static u8 hkid_start_pos __ro_after_init;
> +
> +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> +{
> +	u32 max_pa;
> +
> +	if (!enable_ept) {
> +		pr_warn("Cannot enable TDX with EPT disabled\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!platform_tdx_enabled()) {
> +		pr_warn("Cannot enable TDX on TDX disabled platform\n");
> +		return -ENODEV;
> +	}
> +
> +	/* Safe guard check because TDX overrides tlb_remote_flush callback. */
> +	if (WARN_ON_ONCE(x86_ops->tlb_remote_flush))
> +		return -EIO;

To me it's better to move this chunk to the patch which actually implements=
 how
to flush TLB foro private pages.  W/o some background, it's hard to tell wh=
y TDX
needs to overrides tlb_remote_flush callback.  Otherwise it's quite hard to
review here.

For instance, even if it must be replaced, I am wondering why it must be em=
pty
at the beginning?  For instance, assuming it has an original version which =
does
something:

	x86_ops->tlb_remote_flush =3D vmx_remote_flush;

Why cannot it be replaced with vt_tlb_remote_flush():

	int vt_tlb_remote_flush(struct kvm *kvm)
	{
		if (is_td(kvm))
			return tdx_tlb_remote_flush(kvm);

		return vmx_remote_flush(kvm);
	}

?

> +
> +	max_pa =3D cpuid_eax(0x80000008) & 0xff;
> +	hkid_start_pos =3D boot_cpu_data.x86_phys_bits;
> +	hkid_mask =3D GENMASK_ULL(max_pa - 1, hkid_start_pos);
> +	pr_info("kvm: TDX is supported. hkid start pos %d mask 0x%llx\n",
> +		hkid_start_pos, hkid_mask);

Again, I think it's better to introduce those in the patch where you actual=
ly
need those.  It will be more clear if you introduce those with the code whi=
ch
actually uses them.

For instance, I think both hkid_start_pos and hkid_mask are not necessary. =
 If
you want to apply one keyid to an address, isn't below enough?

	u64 phys |=3D ((keyid) << boot_cpu_data.x86_phys_bits);

> +
> +	return 0;
> +}
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 0f8a8547958f..0a5967a91e26 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -122,4 +122,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
>  #endif
>  void vmx_setup_mce(struct kvm_vcpu *vcpu);
> =20
> +#ifdef CONFIG_INTEL_TDX_HOST
> +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
> +#else
> +static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { retu=
rn 0; }
> +#endif

I think if you introduce a "tdx_ops.h", or "tdx_x86_ops.h", and you can onl=
y
include it when CONFIG_INTEL_TDX_HOST is true, then in tdx_ops.h you don't =
need
those stubs.

Makes sense?

> +
>  #endif /* __KVM_X86_VMX_X86_OPS_H */

