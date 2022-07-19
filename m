Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69F557AA5B
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 01:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiGSXRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 19:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiGSXRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 19:17:13 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3342B60A;
        Tue, 19 Jul 2022 16:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658272631; x=1689808631;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=HD9K4kO1aSr5zMvgPfRlBtIsq4Yg9noasa5ZnGE3i6M=;
  b=Ae0rOJB94fNUFTJS6PrYc4DBrIfFgshxgj2Vd9zYCNix1L5KRulFIr9N
   EqJMOUyDcFYlXl/OUP2qD7toG2HJnahzImphCSK4TGVd1jmcBmFdF4ziV
   NVDdHq7OfVwj9Qbe3Cy+eRFcDyNSjiD+3ocdoPwW75o1lfv5kEGiRx/+t
   DfLK1rJV1i0wOIVckzPAIBvNTDEF4jqAQ25a3MPdjWz7DQoGBgFwVhcI6
   lYlgQlaEPcuhkHq6xas3W1H/l+Jy0DsBcG3+e7PcVDTt273SUl4+DxiYU
   kRRBu8L221Fs/fDgBpgJvnTccSUzRY8+lMmK32RlfRr5by6UChqjQYlgy
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="312321681"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="312321681"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 16:17:11 -0700
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="655996309"
Received: from ecurtis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.162.137])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 16:17:10 -0700
Message-ID: <9e5f3f52ccfe0a0a00f390718df6969615853586.camel@intel.com>
Subject: Re: [PATCH v7 040/102] KVM: x86/mmu: Zap only leaf SPTEs for
 deleted/moved memslot for private mmu
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Wed, 20 Jul 2022 11:17:08 +1200
In-Reply-To: <20220719110616.GW1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <27acc4b2957e1297640d1d8b2a43f7c08e3885d5.1656366338.git.isaku.yamahata@intel.com>
         <a0c4d1fdd132fa0767cd27b9c21d3e04857f7598.camel@intel.com>
         <20220719110616.GW1379820@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-07-19 at 04:06 -0700, Isaku Yamahata wrote:
> On Fri, Jul 01, 2022 at 10:41:08PM +1200,
> Kai Huang <kai.huang@intel.com> wrote:
>=20
> > On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > >=20
> > > For kvm mmu that has shared bit mask, zap only leaf SPTEs when
> > > deleting/moving a memslot.  The existing kvm_mmu_zap_memslot() depend=
s on
> >=20
> > Unless I am mistaken, I don't see there's an 'existing' kvm_mmu_zap_mem=
slot().
>=20
> Oops. it should be kvm_tdp_mmu_invalidate_all_roots().
>=20
>=20
> > > role.invalid with read lock of mmu_lock so that other vcpu can operat=
e on
> > > kvm mmu concurrently.=C2=A0
> > >=20
> >=20
> > > Mark the root page table invalid, unlink it from page
> > > table pointer of CPU, process the page table. =C2=A0
> > >=20
> >=20
> > Are you talking about the behaviour of existing code, or the change you=
 are
> > going to make?  Looks like you mean the latter but I believe it's the f=
ormer.
>=20
>=20
> The existing code.  The should "It marks ...".
>=20
>=20
> > > It doesn't work for private
> > > page table to unlink the root page table because it requires all SPTE=
 entry
> > > to be non-present.=20
> > >=20
> >=20
> > I don't think we can truly *unlink* the private root page table from se=
cure
> > EPTP, right?  The EPTP (root table) is fixed (and hidden) during TD's r=
untime.
> >=20
> > I guess you are trying to say: removing/unlinking one secure-EPT page r=
equires
> > removing/unlinking all its children first?=20
>=20
> That's right. I'll update it as follows.
>                          =20
>=20
> > So the reason to only zap leaf is we cannot truly unlink the private ro=
ot page
> > table, correct?  Sorry your changelog is not obvious to me.
>=20
> The reason is, to unlink a page table from the parent's SPTE, all SPTEs o=
f the
> page table need to be non-present.
>=20
> Here is the updated commit message.
>=20
> KVM: x86/mmu: Zap only leaf SPTEs for deleted/moved memslot for private m=
mu|
> For kvm mmu that has shared bit mask, zap only leaf SPTEs when           =
  |
> deleting/moving a memslot.  The existing kvm_tdp_mmu_invalidate_all_roots=
()|
> depends on role.invalid with read lock of mmu_lock so that other vcpu can=
  |
> operate on kvm mmu concurrently.  It marks the root page table invalid,  =
  |
> zaps SPTEs of the root page tables.                                      =
  |
>                                                                          =
  |
> It doesn't work to unlink a private page table from the parent's SPTE ent=
ry|
> because it requires all SPTE entry of the page table to be non-present.  =
  |

AFAICT this isn't the real reason that you cannot mark private root table a=
s
invalid, and do the same zapping as you mentioned above.  There might be so=
me
change to support "zapping all children before zapping the parent for priva=
te
table" (currently the actual page table is freed after RCU grace period, bu=
t not
at unlink time), but I don't see how this cannot be supported, or at least =
the
changelog doesn't explain why it cannot be supported.

The true reason is, if I understand correctly, you cannot truly unlink the
private root page table from the hardware and then, i.e. allocate a new one=
 for
it.  So just zap the leafs.

> Instead, with write-lock of mmu_lock and zap only leaf SPTEs for kvm mmu =
  |
> with shared bit mask. =20
>=20
> > > Instead, with write-lock of mmu_lock and zap only leaf
> > > SPTEs for kvm mmu with shared bit mask.
> > >=20
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 35 ++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 34 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 80d7c7709af3..c517c7bca105 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -5854,11 +5854,44 @@ static bool kvm_has_zapped_obsolete_pages(str=
uct kvm *kvm)
> > >  	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_page=
s));
> > >  }
> > > =20
> > > +static void kvm_mmu_zap_memslot(struct kvm *kvm, struct kvm_memory_s=
lot *slot)
> > > +{
> > > +	bool flush =3D false;
> > > +
> > > +	write_lock(&kvm->mmu_lock);
> > > +
> > > +	/*
> > > +	 * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, w=
orst
> > > +	 * case scenario we'll have unused shadow pages lying around until =
they
> > > +	 * are recycled due to age or when the VM is destroyed.
> > > +	 */
> > > +	if (is_tdp_mmu_enabled(kvm)) {
> > > +		struct kvm_gfn_range range =3D {
> > > +		      .slot =3D slot,
> > > +		      .start =3D slot->base_gfn,
> > > +		      .end =3D slot->base_gfn + slot->npages,
> > > +		      .may_block =3D false,
> > > +		};
> > > +
> > > +		flush =3D kvm_tdp_mmu_unmap_gfn_range(kvm, &range, flush);
> >=20
> >=20
> > It appears you only unmap private GFNs (because the base_gfn doesn't ha=
ve shared
> > bit)?  I think shared mapping in this slot must be zapped too? =C2=A0
> >=20
> > How is this done?  Or the kvm_tdp_mmu_unmap_gfn_range() also zaps share=
d
> > mappings?
>=20
> kvm_tdp_mmu_unmap_gfn_range() handles both private gfn and shared gfn as
> they are alias. =20
>=20
>=20
> > It's hard to review if one patch's behaviour/logic depends on further p=
atches.
>=20
> I'll add a comment on the call.
>=20

I don't think adding a comment is enough.  The correctness of one patch nee=
ds to
depend on future patch doesn't seem right.  Please also consider patch
reorganize/reorder.

