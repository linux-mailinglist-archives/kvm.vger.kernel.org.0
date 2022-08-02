Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C6C587526
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 03:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbiHBBqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 21:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235381AbiHBBqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 21:46:07 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E548F2CC93;
        Mon,  1 Aug 2022 18:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659404763; x=1690940763;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NMx64uu3tfB/sonO6+Y4Jhq2cdqqthbeEamTh9NctIY=;
  b=RW1zLBHZio70X0Aj+/ob+MqqcgS95ZKOVX8etN5N1AFQmIJuPmGhE75s
   bgXEy+gLIVf/Ij6XD9dSDLLQWTSg7muu4V8dIZtpsf7p0ZpshBTOVgu+v
   wMWD7rTlGq2pSasqVDjYYm5x7scBD6nvZ60bAnwPPOuBLO0i2JKsNrBwY
   sb83KgUCN0FVi3jN2vSdvXBnzFXQ0Nnhbklgg6ReG7Gx7wsa7/75URb4h
   X67/zSUVUov9lGG5Xody61V/0mnfe/DusNpHp3L1sFEGpgHeC6YZJoLs/
   Z1/20SveKq5oE4RLKggYNVE6s/pfYX0fzNSM049cY4EmllbCtDUcVI2Mf
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="272339442"
X-IronPort-AV: E=Sophos;i="5.93,209,1654585200"; 
   d="scan'208";a="272339442"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 18:46:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,209,1654585200"; 
   d="scan'208";a="670263141"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 01 Aug 2022 18:46:02 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 1 Aug 2022 18:46:02 -0700
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15]) by
 ORSMSX602.amr.corp.intel.com ([10.22.229.15]) with mapi id 15.01.2375.028;
 Mon, 1 Aug 2022 18:46:02 -0700
From:   "Huang, Kai" <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
CC:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "erdemaktas@google.com" <erdemaktas@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: RE: [RFC PATCH v6 036/104] KVM: x86/mmu: Explicitly check for MMIO
 spte in fast page fault
Thread-Topic: [RFC PATCH v6 036/104] KVM: x86/mmu: Explicitly check for MMIO
 spte in fast page fault
Thread-Index: AQHYYKy8azwiJuklDUG/yOxG/u6D0q2bn66AgAAQ9AD//7EkAA==
Date:   Tue, 2 Aug 2022 01:46:02 +0000
Message-ID: <29929897856941e0896954011d0ecc34@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <d1a1da631b44f425d929767fda74c90de2d87a8d.1651774250.git.isaku.yamahata@intel.com>
 <YuhTPxZNhxFs+xjc@google.com> <YuhheIdg47zCDiNi@google.com>
In-Reply-To: <YuhheIdg47zCDiNi@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Mon, Aug 01, 2022, David Matlack wrote:
> > On Thu, May 05, 2022 at 11:14:30AM -0700, isaku.yamahata@intel.com wrot=
e:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > >
> > > Explicitly check for an MMIO spte in the fast page fault flow.  TDX
> > > will use a not-present entry for MMIO sptes, which can be mistaken
> > > for an access-tracked spte since both have SPTE_SPECIAL_MASK set.
> > >
> > > MMIO sptes are handled in handle_mmio_page_fault for non-TDX VMs, so
> > > this patch does not affect them.  TDX will handle MMIO emulation
> > > through a hypercall instead.
> > >
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c index
> > > d1c37295bb6e..4a12d862bbb6 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -3184,7 +3184,7 @@ static int fast_page_fault(struct kvm_vcpu *vcp=
u,
> struct kvm_page_fault *fault)
> > >  		else
> > >  			sptep =3D fast_pf_get_last_sptep(vcpu, fault->addr,
> &spte);
> > >
> > > -		if (!is_shadow_present_pte(spte))
> > > +		if (!is_shadow_present_pte(spte) || is_mmio_spte(spte))
> >
> > I wonder if this patch is really necessary. is_shadow_present_pte()
> > checks if SPTE_MMU_PRESENT_MASK is set (which is bit 11, not
> > shadow_present_mask). Do TDX VMs set bit 11 in MMIO SPTEs?
>=20
> This patch should be unnecessary, TDX's not-present SPTEs was one of my
> motivations
> for adding MMU_PRESENT.   Bit 11 most definitely must not be set for MMIO
> SPTEs.

As we already discussed, Isaku will drop this patch.
