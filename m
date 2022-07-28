Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38654583749
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 05:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237538AbiG1DHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 23:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbiG1DHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 23:07:13 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF665B7B7
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 20:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658977632; x=1690513632;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=4YLrWhF9uuEBQhaQ7fdFVnBU796dQn6pFy8yIK7KDy0=;
  b=ao+EbrStYgb8SJUzoV0cnytQHNBJHzW5exdmTjlXKIv7EOMDOtItgu5n
   qmyq37fsGOgEenL15hn6lboPK4gR7axucnl+LO8/LP9SQ89GfOmjxLpsX
   cfJ4Tfov/S7dd3xc/G412cQ8LzX2cJsfIrND22/mUQ9j1g8LYRQzS2u7a
   lR1+qKiGBemlv19T8u0b/26sicvYWD4eWSbidpgnxOjkbjixCM7LDLOY7
   c+3PAgYmm5tlR5vtp7dZWULPCdAEf4W/jU3KmNj467liI/1gTyNNCZ/85
   bvFhRqKAx+RP7CJcwaygwxn2npCO1Wmr3vQBpWD3sHcpoGIqmlIk8OANF
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="314191607"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="314191607"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 20:07:12 -0700
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="633454290"
Received: from byeongky-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.170.137])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 20:07:11 -0700
Message-ID: <d3894cff1943f3bf81b15815bda4845570d9d3f3.camel@intel.com>
Subject: Re: [PATCH v2] KVM, x86/mmu: Fix the comment around
 kvm_tdp_mmu_zap_leafs()
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, bgardon@google.com
Date:   Thu, 28 Jul 2022 15:07:09 +1200
In-Reply-To: <Ytb/1PuHVGczAujs@google.com>
References: <20220713004452.7631-1-kai.huang@intel.com>
         <Ytb/1PuHVGczAujs@google.com>
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

On Tue, 2022-07-19 at 19:02 +0000, Sean Christopherson wrote:
> On Wed, Jul 13, 2022, Kai Huang wrote:
> > Now kvm_tdp_mmu_zap_leafs() only zaps leaf SPTEs but not any non-root
> > pages within that GFN range anymore, so the comment around it isn't
> > right.
> >=20
> > Fix it by shifting the comment from tdp_mmu_zap_leafs() instead of
> > duplicating it, as tdp_mmu_zap_leafs() is static and is only called by
> > kvm_tdp_mmu_zap_leafs().
> >=20
> > Opportunistically tweak the blurb about SPTEs being cleared to (a) say
> > "zapped" instead of "cleared" because "cleared" will be wrong if/when
> > KVM allows a non-zero value for non-present SPTE (i.e. for Intel TDX),
> > and (b) to clarify that a flush is needed if and only if a SPTE has bee=
n
> > zapped since MMU lock was last acquired.
> >=20
> > Fixes: f47e5bbbc92f ("KVM: x86/mmu: Zap only TDP MMU leafs in zap range=
 and mmu_notifier unmap")
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 10 +++-------
> >  1 file changed, 3 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index f3a430d64975..58b34f7cd0f5 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -924,9 +924,6 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm=
_mmu_page *sp)
> >  }
> > =20
> >  /*
> > - * Zap leafs SPTEs for the range of gfns, [start, end). Returns true i=
f SPTEs
> > - * have been cleared and a TLB flush is needed before releasing the MM=
U lock.
> > - *
> >   * If can_yield is true, will release the MMU lock and reschedule if t=
he
> >   * scheduler needs the CPU or there is contention on the MMU lock. If =
this
> >   * function cannot yield, it will not release the MMU lock or reschedu=
le and
> > @@ -969,10 +966,9 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, str=
uct kvm_mmu_page *root,
> >  }
> > =20
> >  /*
> > - * Tears down the mappings for the range of gfns, [start, end), and fr=
ees the
> > - * non-root pages mapping GFNs strictly within that range. Returns tru=
e if
> > - * SPTEs have been cleared and a TLB flush is needed before releasing =
the
> > - * MMU lock.
> > + * Zap leafs SPTEs for the range of gfns, [start, end), for all roots.=
 Returns
>=20
> s/leafs/leaf (my fault, sorry)
>=20
> With that tweak,
>=20
> Reviewed-by: Sean Christopherson <seanjc@google.com>

I should have checked error too :)

I have sent out v3 with above fixed.  Thanks.

--=20
Thanks,
-Kai


