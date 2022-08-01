Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2D55866D8
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 11:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiHAJal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 05:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiHAJaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 05:30:39 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372C065B4;
        Mon,  1 Aug 2022 02:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659346238; x=1690882238;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=C8YblhqhN/uSfav0qF4yvWV9Y2WAR2UMOGikZhiqDFA=;
  b=AJINPCRcgJj/AgYeo7+6vhomBd6cRSWNclo8zAYCR+IMYGr4u4T+QCj7
   NXdJ7PHiYQGbNgiinMANdWLNspGHfvU4u5iSIUj0+gE/tgDhRZn9mReJd
   lzmLl799gOR6BkkOvPlHgZuO/0S3nJ36d9Es+02LiShgE60LsYZV3PBRa
   spoL8e9d1fTdGUwAJhV3zrOdkBtNfhnYvr5oplBlusGaWXEem2s+ZIYwH
   0nYR7kBKveZmmL40uu/9ONkUgsKdC5xUkm8LhCNyk7i/XDEI3g9se2ZmG
   cFWvPIgtyNDBoyKE96Laf9F+YKH99tGcM5Re9OxD8vUdgJieLtiOlUQ6Y
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10425"; a="268869539"
X-IronPort-AV: E=Sophos;i="5.93,206,1654585200"; 
   d="scan'208";a="268869539"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 02:30:37 -0700
X-IronPort-AV: E=Sophos;i="5.93,206,1654585200"; 
   d="scan'208";a="691401619"
Received: from dmikhail-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.187.210])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 02:30:36 -0700
Message-ID: <610ba489b8c0c03f7ac004049e10972bf01de927.camel@intel.com>
Subject: Re: [PATCH 4/4] KVM: SVM: Disable SEV-ES support if MMIO caching is
 disable
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Date:   Mon, 01 Aug 2022 21:30:34 +1200
In-Reply-To: <YuP66QVxyeT4wd5H@google.com>
References: <20220728221759.3492539-1-seanjc@google.com>
         <20220728221759.3492539-5-seanjc@google.com>
         <d09972481dede743dd0a77409cd8ecaecdbf86b3.camel@intel.com>
         <YuP66QVxyeT4wd5H@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-29 at 15:21 +0000, Sean Christopherson wrote:
> On Fri, Jul 29, 2022, Kai Huang wrote:
> > On Thu, 2022-07-28 at 22:17 +0000, Sean Christopherson wrote:
> > > Disable SEV-ES if MMIO caching is disabled as SEV-ES relies on MMIO S=
PTEs
> > > generating #NPF(RSVD), which are reflected by the CPU into the guest =
as
> > > a #VC.  With SEV-ES, the untrusted host, a.k.a. KVM, doesn't have acc=
ess
> > > to the guest instruction stream or register state and so can't direct=
ly
> > > emulate in response to a #NPF on an emulated MMIO GPA.  Disabling MMI=
O
> > > caching means guest accesses to emulated MMIO ranges cause #NPF(!PRES=
ENT),
> > > and those flavors of #NPF cause automatic VM-Exits, not #VC.
> > >=20
> > > Fixes: b09763da4dd8 ("KVM: x86/mmu: Add module param to disable MMIO =
caching (for testing)")
> > > Reported-by: Michael Roth <michael.roth@amd.com>
> > > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
>=20
> ...
>=20
> > > +	/*
> > > +	 * SEV-ES requires MMIO caching as KVM doesn't have access to the g=
uest
> > > +	 * instruction stream, i.e. can't emulate in response to a #NPF and
> > > +	 * instead relies on #NPF(RSVD) being reflected into the guest as #=
VC
> > > +	 * (the guest can then do a #VMGEXIT to request MMIO emulation).
> > > +	 */
> > > +	if (!enable_mmio_caching)
> > > +		goto out;
> > > +
> > >=20
> >=20
> > I am not familiar with SEV, but looks it is similar to TDX -- they both=
 causes
> > #VE to guest instead of faulting into KVM. =C2=A0And they both require =
explicit call
> > from guest to do MMIO.
> >=20
> > In this case, does existing MMIO caching logic still apply to them?
>=20
> Yes, because TDX/SEV-ES+ need to generate #VE/#VC on emulated MMIO so tha=
t legacy
> (or intentionally unenlightened) software in the guest doesn't simply han=
g/die on
> memory accesses to emulated MMIO (as opposed to direct TDVMCALL/#VMGEXIT)=
.
>=20
> > Should we still treat SEV and TDX's MMIO handling as MMIO caching being
> > enabled?  Or perhaps another variable?
>=20
> I don't think a separate variable is necesary.  At its core, KVM is still=
 caching
> MMIO GPAs via magic SPTE values.  The fact that it's required for functio=
nality
> doesn't make the name wrong.

OK.

>=20
> SEV-ES+ in particular doesn't have a strong guarantee that inducing #VC v=
ia #NPF(RSVD)
> is always possible.  Theoretically, an SEV-ES+ capable CPU could ship wit=
h an effective
> MAXPHYADDR=3D51 (after reducing the raw MAXPHYADDR) and C-bit=3D51, in wh=
ich case there are
> no resered PA bits and thus no reserved PTE bits at all.  That's obviousl=
y unlikely to
> happen, but if it does come up, then disabling SEV-ES+ due to MMIO cachin=
g not being
> possible is the desired behavior, e.g. either the CPU configuration is ba=
d or KVM is
> lacking support for a newfangled way to support emulated MMIO (in a futur=
e theoretical
> SEV-* product).

I bet AMD will see this (your) response and never ship such chips :)

--=20
Thanks,
-Kai


