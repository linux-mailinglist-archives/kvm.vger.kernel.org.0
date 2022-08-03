Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0CA588522
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 02:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbiHCA26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 20:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiHCA24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 20:28:56 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994EB1EC60;
        Tue,  2 Aug 2022 17:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659486535; x=1691022535;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=TfQo5e0rtAyCyb4NV08DshIcOTwVxaVMa7Lp5tjW1KA=;
  b=NcLk9nQ0M21TKVnBrVwX77W4kfl63BxU5TunBUwIJ84NH8PArCfkpPxy
   WmIsTLiy9xX066ICL+q1BiF5YjUousGKqt+HqS+WDcxUMnx1Inyp01gug
   vNaDKUC1p0JFX/UbjkcLNyEsW1v55irY9OA5oKCyzwjBPa93jB0wbCdnC
   thVwvhJCtRrEdawi1pcfPF3SqaArzd8CYZPUWgL73tNZfFITm5uDq8Qfh
   jUtRsa8G2lxt0gB1kayuzYkRjXhBKmV7iT8ED+5agBYj0/Xksb5ONMGTo
   R/MkcQVyMg5SHeKZl7/CT7Quj3pAfw0xeDaZiBJrwiaGsa7/EJneNYi32
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="375849543"
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="375849543"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 17:28:55 -0700
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="606205339"
Received: from gvenka2-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.85.17])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 17:28:53 -0700
Message-ID: <39fd60434e0f4bac4c7c59b7983f16752924c932.camel@intel.com>
Subject: Re: [RFC PATCH v6 036/104] KVM: x86/mmu: Explicitly check for MMIO
 spte in fast page fault
From:   Kai Huang <kai.huang@intel.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "erdemaktas@google.com" <erdemaktas@google.com>,
        Sagi Shahar <sagis@google.com>
Date:   Wed, 03 Aug 2022 12:28:51 +1200
In-Reply-To: <CALzav=esHsBL7XL91HmqT89+VBeAhR3avSbdUWk-OScD=eoymQ@mail.gmail.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
         <d1a1da631b44f425d929767fda74c90de2d87a8d.1651774250.git.isaku.yamahata@intel.com>
         <YuhTPxZNhxFs+xjc@google.com> <YuhheIdg47zCDiNi@google.com>
         <29929897856941e0896954011d0ecc34@intel.com>
         <CALzav=esHsBL7XL91HmqT89+VBeAhR3avSbdUWk-OScD=eoymQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-08-02 at 09:34 -0700, David Matlack wrote:
> On Mon, Aug 1, 2022 at 6:46 PM Huang, Kai <kai.huang@intel.com> wrote:
> >=20
> > > On Mon, Aug 01, 2022, David Matlack wrote:
> > > > On Thu, May 05, 2022 at 11:14:30AM -0700, isaku.yamahata@intel.com =
wrote:
> > > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > >=20
> > > > > Explicitly check for an MMIO spte in the fast page fault flow.  T=
DX
> > > > > will use a not-present entry for MMIO sptes, which can be mistake=
n
> > > > > for an access-tracked spte since both have SPTE_SPECIAL_MASK set.
> > > > >=20
> > > > > MMIO sptes are handled in handle_mmio_page_fault for non-TDX VMs,=
 so
> > > > > this patch does not affect them.  TDX will handle MMIO emulation
> > > > > through a hypercall instead.
> > > > >=20
> > > > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.c=
om>
> > > > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > > ---
> > > > >  arch/x86/kvm/mmu/mmu.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >=20
> > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c inde=
x
> > > > > d1c37295bb6e..4a12d862bbb6 100644
> > > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > > @@ -3184,7 +3184,7 @@ static int fast_page_fault(struct kvm_vcpu =
*vcpu,
> > > struct kvm_page_fault *fault)
> > > > >           else
> > > > >                   sptep =3D fast_pf_get_last_sptep(vcpu, fault->a=
ddr,
> > > &spte);
> > > > >=20
> > > > > -         if (!is_shadow_present_pte(spte))
> > > > > +         if (!is_shadow_present_pte(spte) || is_mmio_spte(spte))
> > > >=20
> > > > I wonder if this patch is really necessary. is_shadow_present_pte()
> > > > checks if SPTE_MMU_PRESENT_MASK is set (which is bit 11, not
> > > > shadow_present_mask). Do TDX VMs set bit 11 in MMIO SPTEs?
> > >=20
> > > This patch should be unnecessary, TDX's not-present SPTEs was one of =
my
> > > motivations
> > > for adding MMU_PRESENT.   Bit 11 most definitely must not be set for =
MMIO
> > > SPTEs.
> >=20
> > As we already discussed, Isaku will drop this patch.
>=20
> Ah, I missed that discussion. Can you share a link so I can catch up?

Sure.  Isaku has sent out v7 of this series:

https://lore.kernel.org/lkml/20220727220456.GA3669189@ls.amr.corp.intel.com=
/T/#m8d2229ce31b9bcd084cc43e3478154f5f24d7506

For this particular patch, see here:

https://lore.kernel.org/lkml/20220727220456.GA3669189@ls.amr.corp.intel.com=
/T/#mcdb118103460c55f8b850e784d1ed57724c0fe2f

--=20
Thanks,
-Kai


