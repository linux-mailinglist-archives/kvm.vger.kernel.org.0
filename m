Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72281589496
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 01:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbiHCW77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 18:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237090AbiHCW7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 18:59:54 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00310186FC;
        Wed,  3 Aug 2022 15:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659567593; x=1691103593;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=8fiq1XsVw/tB1TlcpSmU9962fV891+nSfOAoV0JkGQs=;
  b=Zm0a4+/WxHqwOBL2Dz/dt+sW4h+acBX5gNPY4M+ZxsjAOle4MojsTmm7
   NldB/UWl0jyQMYD/Vxoaeayzj0SiLsEvyCT+QU6HkGgBFSVvjapkQdBYz
   1pJKR075bPKGHoZveqF0ns/38JznJYupl1oq6EQcW9m1HMomqB2Uk1EfQ
   CGXriobEfZbCGTsTbj1ZujSnuSxfRL67Nd5W2pU8tgi7uGNPGiS2XbZ2l
   huA+S852AHG+0PIHPRvd7pTjKsLA75Ps/9c4PL3OS/Uw1wZ7QGmdNgjSu
   McP4fi2PptwLAD+EPv83vTSh0DQINSI/kKQWLDfFbdArFJsP9pxAfr7dM
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10428"; a="287356137"
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="287356137"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 15:59:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="779153724"
Received: from bshamoun-mobl4.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.8.236])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 15:59:50 -0700
Message-ID: <d924ec235d9b0fb27f80cb03b02b5c7d8466fec1.camel@intel.com>
Subject: Re: [PATCH v2 2/3] KVM: x86/mmu: Fully re-evaluate MMIO caching
 when SPTE masks change
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Date:   Thu, 04 Aug 2022 10:59:48 +1200
In-Reply-To: <20220803224957.1285926-3-seanjc@google.com>
References: <20220803224957.1285926-1-seanjc@google.com>
         <20220803224957.1285926-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-03 at 22:49 +0000, Sean Christopherson wrote:
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
> Tested-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Kai Huang <kai.huang@intel.com>

One Nit below...

> ---
>  arch/x86/kvm/mmu/mmu.c  |  4 ++++
>  arch/x86/kvm/mmu/spte.c | 19 +++++++++++++++++++
>  arch/x86/kvm/mmu/spte.h |  1 +
>  3 files changed, 24 insertions(+)
>=20
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index bf808107a56b..48f34016cb0b 100644
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

... Perhaps 'use_mmio_caching' or 'want_mmio_caching' is better as it refle=
cts
userspace's desire? Anyway let you decide.

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
>  	if (!enable_mmio_caching)
>  		mmio_value =3D 0;
> =20
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index cabe3fbb4f39..26b144ffd146 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -450,6 +450,7 @@ static inline u64 restore_acc_track_spte(u64 spte)
> =20
>  u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_p=
fn);
> =20
> +void __init kvm_mmu_spte_module_init(void);
>  void kvm_mmu_reset_all_pte_masks(void);
> =20
>  #endif

