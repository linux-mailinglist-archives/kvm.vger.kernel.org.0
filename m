Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7F5589482
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 00:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbiHCWqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 18:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiHCWqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 18:46:37 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC0713E1D;
        Wed,  3 Aug 2022 15:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659566796; x=1691102796;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=O2lm8iq861J8S5ZjofA71G3tBNxjYu/xDjOElTDHnb0=;
  b=FaF6rcIgP6qvk5JhVwa0WgjagHAswkgccLyx5i5HZB7yjBBFVnTjZhQw
   kw7GpUXMi0qdkHvwkfumZKLqj+fSsMuENrwtixKQ+U4056Mtpr9uQ2//M
   gIVKG+/rubvlbC/re9SeFjQtdOYRK6p70Gs12rZTAnT2dPoHTUZ4+ZHaA
   bYlsGWD8vY4H1/jnny9DH9sfOQGJsI151bKbVRM8+oTy0wYiWwyIcT6HV
   7oErIaejovk526S+eDsWvB+JPdT9JXHOnhhF7EzudGmdFdFHB/k2XBGou
   /9aXCueiJKwIAFCCz6XU7FIwtamQtUTsx7hK7dGvS7BEc94dvgTgl8qlL
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10428"; a="315663552"
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="315663552"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 15:46:36 -0700
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="553494140"
Received: from bshamoun-mobl4.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.8.236])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 15:46:34 -0700
Message-ID: <be0767a74a80cf8d749003cc73a9aa316ab49821.camel@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add sanity check that MMIO SPTE mask
 doesn't overlap gen
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 04 Aug 2022 10:46:32 +1200
In-Reply-To: <20220803213354.951376-1-seanjc@google.com>
References: <20220803213354.951376-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-03 at 21:33 +0000, Sean Christopherson wrote:
> Add compile-time and init-time sanity checks to ensure that the MMIO SPTE
> mask doesn't overlap the MMIO SPTE generation.  The generation currently
> avoids using bit 63, but that's as much coincidence as it is strictly
> necessarly.  That will change in the future, as TDX support will require
> setting bit 63 (SUPPRESS_VE) in the mask.  Explicitly carve out the bits
> that are allowed in the mask so that any future shuffling of SPTE MMIO
> bits doesn't silently break MMIO caching.

Reviwed-by: Kai Huang <kai.huang@intel.com>

Btw, should you also check SPTE_MMU_PRESENT_MASK (or in another patch)?

>=20
> Suggested-by: Kai Huang <kai.huang@intel.com>

Thanks for giving me the credit as I don't feel I deserve it.

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/spte.c | 8 ++++++++
>  arch/x86/kvm/mmu/spte.h | 9 +++++++++
>  2 files changed, 17 insertions(+)
>=20
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 7314d27d57a4..08e8c46f3037 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -343,6 +343,14 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 =
mmio_mask, u64 access_mask)
>  	if (!enable_mmio_caching)
>  		mmio_value =3D 0;
> =20
> +	/*
> +	 * The mask must contain only bits that are carved out specifically for
> +	 * the MMIO SPTE mask, e.g. to ensure there's no overlap with the MMIO
> +	 * generation.
> +	 */
> +	if (WARN_ON(mmio_mask & ~SPTE_MMIO_ALLOWED_MASK))
> +		mmio_value =3D 0;
> +
>  	/*
>  	 * Disable MMIO caching if the MMIO value collides with the bits that
>  	 * are used to hold the relocated GFN when the L1TF mitigation is
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index cabe3fbb4f39..6cd3936cbe1f 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -125,6 +125,15 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_T=
RACK_SAVED_MASK));
>  static_assert(!(SPTE_MMU_PRESENT_MASK &
>  		(MMIO_SPTE_GEN_LOW_MASK | MMIO_SPTE_GEN_HIGH_MASK)));
> =20
> +/*
> + * The SPTE MMIO mask is allowed to use "present" bits (i.e. all EPT RWX=
 bits),
> + * all physical address bits (additional checks ensure the mask doesn't =
overlap
> + * legal PA bits), and bit 63 (carved out for future usage, e.g. SUPPRES=
S_VE).
> + */
> +#define SPTE_MMIO_ALLOWED_MASK (BIT_ULL(63) | GENMASK_ULL(51, 12) | GENM=
ASK_ULL(2, 0))
> +static_assert(!(SPTE_MMIO_ALLOWED_MASK &
> +		(MMIO_SPTE_GEN_LOW_MASK | MMIO_SPTE_GEN_HIGH_MASK)));
> +
>  #define MMIO_SPTE_GEN_LOW_BITS		(MMIO_SPTE_GEN_LOW_END - MMIO_SPTE_GEN_L=
OW_START + 1)
>  #define MMIO_SPTE_GEN_HIGH_BITS		(MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN=
_HIGH_START + 1)
> =20
>=20
> base-commit: 93472b79715378a2386598d6632c654a2223267b

