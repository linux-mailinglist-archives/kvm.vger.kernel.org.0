Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA50D5631B3
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 12:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbiGAKlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 06:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbiGAKlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 06:41:16 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C939B7BD1A;
        Fri,  1 Jul 2022 03:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656672072; x=1688208072;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=LBKPz83Z97Cs9jEltHfk0izER6lkhedYAl3XqeVkfos=;
  b=ZOI2YKrQtkfSLYiRGe3nctMX7/GwzUoq8hiSDg/KWwoN4vVnFCYpA+LU
   rao5qiimMqkTz8QdtbOlmbrjGO2fTtY8UfYg7w1tGPVZU9CX72RgiRzB1
   /N6fP42YVP+fBAqhkkhehBFos5m1vq57NMGNras7EvxjNnC7R5h0kqtD1
   F3q1Xrvwr2Du7hCrHkCrZWn41R1nq1hM3Dwdg2BSUUfirjjJgmaiU/0Ou
   olGrpM+9jTCgjrisofU1ZJEN6iPZYshGOd/bNqZRdRtdsalaHkqhvHXDB
   sqw8pbxj8OJb4nhVJ6DG7BkIoC5PajqAA7wS3s2tTMbJ5CvITkasSLZEG
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="368940947"
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="368940947"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 03:41:12 -0700
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="838001396"
Received: from sanketpa-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.86.143])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 03:41:11 -0700
Message-ID: <a0c4d1fdd132fa0767cd27b9c21d3e04857f7598.camel@intel.com>
Subject: Re: [PATCH v7 040/102] KVM: x86/mmu: Zap only leaf SPTEs for
 deleted/moved memslot for private mmu
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Fri, 01 Jul 2022 22:41:08 +1200
In-Reply-To: <27acc4b2957e1297640d1d8b2a43f7c08e3885d5.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <27acc4b2957e1297640d1d8b2a43f7c08e3885d5.1656366338.git.isaku.yamahata@intel.com>
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

On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>=20
> For kvm mmu that has shared bit mask, zap only leaf SPTEs when
> deleting/moving a memslot.  The existing kvm_mmu_zap_memslot() depends on

Unless I am mistaken, I don't see there's an 'existing' kvm_mmu_zap_memslot=
().

> role.invalid with read lock of mmu_lock so that other vcpu can operate on
> kvm mmu concurrently.=C2=A0
>=20

> Mark the root page table invalid, unlink it from page
> table pointer of CPU, process the page table. =C2=A0
>=20

Are you talking about the behaviour of existing code, or the change you are
going to make?  Looks like you mean the latter but I believe it's the forme=
r.=20

> It doesn't work for private
> page table to unlink the root page table because it requires all SPTE ent=
ry
> to be non-present. =C2=A0
>=20

I don't think we can truly *unlink* the private root page table from secure
EPTP, right?  The EPTP (root table) is fixed (and hidden) during TD's runti=
me.

I guess you are trying to say: removing/unlinking one secure-EPT page requi=
res
removing/unlinking all its children first?=20

So the reason to only zap leaf is we cannot truly unlink the private root p=
age
table, correct?  Sorry your changelog is not obvious to me.

> Instead, with write-lock of mmu_lock and zap only leaf
> SPTEs for kvm mmu with shared bit mask.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 80d7c7709af3..c517c7bca105 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5854,11 +5854,44 @@ static bool kvm_has_zapped_obsolete_pages(struct =
kvm *kvm)
>  	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
>  }
> =20
> +static void kvm_mmu_zap_memslot(struct kvm *kvm, struct kvm_memory_slot =
*slot)
> +{
> +	bool flush =3D false;
> +
> +	write_lock(&kvm->mmu_lock);
> +
> +	/*
> +	 * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
> +	 * case scenario we'll have unused shadow pages lying around until they
> +	 * are recycled due to age or when the VM is destroyed.
> +	 */
> +	if (is_tdp_mmu_enabled(kvm)) {
> +		struct kvm_gfn_range range =3D {
> +		      .slot =3D slot,
> +		      .start =3D slot->base_gfn,
> +		      .end =3D slot->base_gfn + slot->npages,
> +		      .may_block =3D false,
> +		};
> +
> +		flush =3D kvm_tdp_mmu_unmap_gfn_range(kvm, &range, flush);


It appears you only unmap private GFNs (because the base_gfn doesn't have s=
hared
bit)?  I think shared mapping in this slot must be zapped too? =C2=A0

How is this done?  Or the kvm_tdp_mmu_unmap_gfn_range() also zaps shared
mappings?

It's hard to review if one patch's behaviour/logic depends on further patch=
es.

> +	} else {
> +		flush =3D slot_handle_level(kvm, slot, kvm_zap_rmapp, PG_LEVEL_4K,
> +					  KVM_MAX_HUGEPAGE_LEVEL, true);
> +	}
> +	if (flush)
> +		kvm_flush_remote_tlbs(kvm);
> +
> +	write_unlock(&kvm->mmu_lock);
> +}
> +
>  static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
>  			struct kvm_memory_slot *slot,
>  			struct kvm_page_track_notifier_node *node)
>  {
> -	kvm_mmu_zap_all_fast(kvm);
> +	if (kvm_gfn_shared_mask(kvm))
> +		kvm_mmu_zap_memslot(kvm, slot);
> +	else
> +		kvm_mmu_zap_all_fast(kvm);
>  }
> =20
>  int kvm_mmu_init_vm(struct kvm *kvm)

