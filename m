Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83DC6561957
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 13:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbiF3Lhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 07:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbiF3LhU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 07:37:20 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B715A44F;
        Thu, 30 Jun 2022 04:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656589039; x=1688125039;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=cJOc9pifRuPqoq93Kxnv9kcuAQi7B+at/0gDeNXNrbw=;
  b=g/VEfy35U6moKwPaE49uV1lTfha11Ef4GJbu6GYXAAhXp43mPUm5S5Tu
   ZO0kv1LZapu2FcPlltrw58uNGkO2r4U33eANz7N936XOYS+SV7GGNgs/r
   FfasxhulYmjrGHoV+hvN8rw2AsPhnMxZ0TylisBxVbneeVQTPJtgvayT1
   qhJvc/mfuAYlLOmWFFySLsyjWQth+4lSPXs1H1cIACkt40SevffzdpNV1
   I5Kmv28gbSOUwMO69fsbe1D42eBoIBhnCRwqqTVrbB/ZgwjwrK/6c7aAk
   gGONoUlYSKQLGino2tweJIW7QitegZq3bkBwcZ9l3KSIPSEH2FjOaZMfD
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="262121654"
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="262121654"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 04:37:19 -0700
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="617947907"
Received: from zhihuich-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.49.124])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 04:37:17 -0700
Message-ID: <cfeb3b8b02646b073d5355495ec8842ac33aeae5.camel@intel.com>
Subject: Re: [PATCH v7 035/102] KVM: x86/mmu: Explicitly check for MMIO spte
 in fast page fault
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Thu, 30 Jun 2022 23:37:15 +1200
In-Reply-To: <71e4c19d1dff8135792e6c5a17d3a483bc99875b.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <71e4c19d1dff8135792e6c5a17d3a483bc99875b.1656366338.git.isaku.yamahata@intel.com>
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
> Explicitly check for an MMIO spte in the fast page fault flow.  TDX will
> use a not-present entry for MMIO sptes, which can be mistaken for an
> access-tracked spte since both have SPTE_SPECIAL_MASK set.

SPTE_SPECIAL_MASK has been removed in latest KVM code.  The changelog needs
update.

In fact, if I understand correctly, I don't think this changelog is correct=
:

The existing code doesn't check is_mmio_spte() because:

1) If MMIO caching is enabled, MMIO fault is always handled in
handle_mmio_page_fault() before reaching here;=20

2) If MMIO caching is disabled, is_shadow_present_pte() always returns fals=
e for
MMIO spte, and is_mmio_spte() also always return false for MMIO spte, so th=
ere's
no need check here.

"A non-present entry for MMIO spte" doesn't necessarily mean
is_shadow_present_pte() will return true for it, and there's no explanation=
 at
all that for TDX guest a MMIO spte could reach here and is_shadow_present_p=
te()
returns true for it.

If this patch is ever needed, it should come with or after the patch (patch=
es)
that handles MMIO fault for TD guest.

Hi Sean, Paolo,

Did I miss anything?

>=20
> MMIO sptes are handled in handle_mmio_page_fault for non-TDX VMs, so this
> patch does not affect them.  TDX will handle MMIO emulation through a
> hypercall instead.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 17252f39bd7c..51306b80f47c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3163,7 +3163,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, s=
truct kvm_page_fault *fault)
>  		else
>  			sptep =3D fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
> =20
> -		if (!is_shadow_present_pte(spte))
> +		if (!is_shadow_present_pte(spte) || is_mmio_spte(spte))
>  			break;
> =20
>  		sp =3D sptep_to_sp(sptep);

