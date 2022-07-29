Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E978A5849DB
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 04:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbiG2CjT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 22:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiG2CjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 22:39:15 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B214D63912;
        Thu, 28 Jul 2022 19:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659062354; x=1690598354;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=PiRg+aaDRE7LJ4ZDIgMS6KsS5g8de4CkxLlzNPF5WyU=;
  b=mr6WN698IfaWnERXLAa6mc0cg8QZXHQ8orB7B2oNEOGdhropwnHJVrXb
   jNW5vS9J8+vxgACpH8sRVLR2Df56rftxZ6bYa8OfeT2p6Qv9QNt342PTX
   QOH4zQnoie3fyXosZ2taJyiQsa4i13GjXQsUpgeEcBehpVYYhmyN5zRo1
   aOaEex47QZSYfc9dQ6hGdzThxJAftMtjrwrmt+HcYIq2Vc1atCSffRoGG
   J8YGC7sW8UutKosZlGguhWiX6go4ZCBXraQSH0w239L/jo0TuKLu0xG0G
   OtYufrQKdGGFxEEa1VP7xIU0Um0a9ZEcu7sNfMvn7OBfyGJzoH0KmjaOS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="314470851"
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="314470851"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 19:39:14 -0700
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="743384460"
Received: from mdharmap-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.28.140])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 19:39:12 -0700
Message-ID: <9104e22da628fef86a6e8a02d9d2e81814a9d598.camel@intel.com>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Fully re-evaluate MMIO caching when
 SPTE masks change
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Date:   Fri, 29 Jul 2022 14:39:10 +1200
In-Reply-To: <20220728221759.3492539-3-seanjc@google.com>
References: <20220728221759.3492539-1-seanjc@google.com>
         <20220728221759.3492539-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-28 at 22:17 +0000, Sean Christopherson wrote:
> Fully re-evaluate whether or not MMIO caching can be enabled when SPTE
> masks change; simply clearing enable_mmio_caching when a configuration
> isn't compatible with caching fails to handle the scenario where the
> masks are updated, e.g. by VMX for EPT or by SVM to account for the C-bit
> location, and toggle compatibility from false=3D>true.
>=20
> Snapshot the original module param so that re-evaluating MMIO caching
> preserves userspace's desire to allow caching.  Use a snapshot approach
> so that enable_mmio_caching still reflects KVM's actual behavior.
>=20
> Fixes: 8b9e74bfbf8c ("KVM: x86/mmu: Use enable_mmio_caching to track if M=
MIO caching is enabled")
> Reported-by: Michael Roth <michael.roth@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c  |  4 ++++
>  arch/x86/kvm/mmu/spte.c | 19 +++++++++++++++++++
>  arch/x86/kvm/mmu/spte.h |  1 +
>  3 files changed, 24 insertions(+)
>=20
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 2975fcb14c86..660f58928252 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6699,11 +6699,15 @@ static int set_nx_huge_pages(const char *val, con=
st struct kernel_param *kp)
>  /*
>   * nx_huge_pages needs to be resolved to true/false when kvm.ko is loade=
d, as
>   * its default value of -1 is technically undefined behavior for a boole=
an.
> + * Forward the module init call to SPTE code so that it too can handle m=
odule
> + * params that need to be resolved/snapshot.
>   */
>  void __init kvm_mmu_x86_module_init(void)
>  {
>  	if (nx_huge_pages =3D=3D -1)
>  		__set_nx_huge_pages(get_nx_auto_mode());
> +
> +	kvm_mmu_spte_module_init();
>  }
> =20
>  /*
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 7314d27d57a4..66f76f5a15bd 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -20,6 +20,7 @@
>  #include <asm/vmx.h>
> =20
>  bool __read_mostly enable_mmio_caching =3D true;
> +static bool __ro_after_init allow_mmio_caching;
>  module_param_named(mmio_caching, enable_mmio_caching, bool, 0444);
> =20
>  u64 __read_mostly shadow_host_writable_mask;
> @@ -43,6 +44,18 @@ u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_=
mask;
> =20
>  u8 __read_mostly shadow_phys_bits;
> =20
> +void __init kvm_mmu_spte_module_init(void)
> +{
> +	/*
> +	 * Snapshot userspace's desire to allow MMIO caching.  Whether or not
> +	 * KVM can actually enable MMIO caching depends on vendor-specific
> +	 * hardware capabilities and other module params that can't be resolved
> +	 * until the vendor module is loaded, i.e. enable_mmio_caching can and
> +	 * will change when the vendor module is (re)loaded.
> +	 */
> +	allow_mmio_caching =3D enable_mmio_caching;
> +}
> +
>  static u64 generation_mmio_spte_mask(u64 gen)
>  {
>  	u64 mask;
> @@ -340,6 +353,12 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 =
mmio_mask, u64 access_mask)
>  	BUG_ON((u64)(unsigned)access_mask !=3D access_mask);
>  	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
> =20
> +	/*
> +	 * Reset to the original module param value to honor userspace's desire
> +	 * to (dis)allow MMIO caching.  Update the param itself so that
> +	 * userspace can see whether or not KVM is actually using MMIO caching.
> +	 */
> +	enable_mmio_caching =3D allow_mmio_caching;

I think the problem comes from MMIO caching mask/value are firstly set in
kvm_mmu_reset_all_pte_masks() (which calls kvm_mmu_set_mmio_spte_mask() and=
 may
change enable_mmio_caching), and later vendor specific code _may_ or _may_n=
ot_
call kvm_mmu_set_mmio_spte_mask() again to adjust the mask/value.  And when=
 it
does, the second call from vendor specific code shouldn't depend on the
'enable_mmio_caching' value calculated in the first call in=20
kvm_mmu_reset_all_pte_masks().

Instead of using 'allow_mmio_caching', should we just remove
kvm_mmu_set_mmio_spte_mask() in kvm_mmu_reset_all_pte_masks() and enforce v=
endor
specific code to always call kvm_mmu_set_mmio_spte_mask() depending on what=
ever
hardware feature the vendor uses?

I am suggesting this way because in Isaku's TDX patch

[PATCH v7 037/102] KVM: x86/mmu: Track shadow MMIO value/mask on a per-VM b=
asis

we will enable per-VM MMIO mask/value, which will remove global
shadow_mmio_mask/shadow_mmio_value, and I am already suggesting something
similar:

https://lore.kernel.org/all/20220719084737.GU1379820@ls.amr.corp.intel.com/

