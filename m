Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E961570F4E
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 03:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiGLBNT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 21:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbiGLBNP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 21:13:15 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07F9509E0;
        Mon, 11 Jul 2022 18:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657588394; x=1689124394;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=T2p2PDep+Jk58poJbivNq6gYM425mMNK9DXK1/lNMbk=;
  b=O1klND3sQ5G+JenV/YWfV4N6Zx0By/DRQn4SSIKsqguUwg0WAQhSasN6
   SaBNilchfloBHcFUdd+Gm81FlzA2CifhTvcmdJ2TVDHSLn/HZdL82x/fI
   wckOX8y/0M38LTUJ0vQ/h4+rt+WVfU6jnQrr8EpkiJV2p4CT1cN5mbd4S
   0Vdo9PDFd9KMc2rO6QRzZO3NntN+bfE+XIDnjSJPxluGZUtR6IBkH2OwK
   gz4VMNdfoMdq8IG4LLrP/XrfniYK50MtdFPsUG8kJg+3N2WBySAFd9zIH
   CWg4eU91E8u+Ieepa1Njwx+V8kWCYUkSvSxAVGzD58eq0/gaS9hHnKCNs
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="267848276"
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="267848276"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 18:13:14 -0700
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="595103198"
Received: from snaskant-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.60.27])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 18:13:12 -0700
Message-ID: <d495a777f31df86271f1c4511b2f521adfa867d1.camel@intel.com>
Subject: Re: [PATCH v7 011/102] KVM: TDX: Initialize TDX module when loading
 kvm_intel.ko
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Tue, 12 Jul 2022 13:13:10 +1200
In-Reply-To: <20220712004640.GD1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <d933e5f16ff8cb58020f1479b7af35196f0ef61e.1656366338.git.isaku.yamahata@intel.com>
         <81ea5068b890400ca4064781f7d2221826701020.camel@intel.com>
         <20220712004640.GD1379820@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-07-11 at 17:46 -0700, Isaku Yamahata wrote:
> On Tue, Jun 28, 2022 at 04:31:35PM +1200,
> Kai Huang <kai.huang@intel.com> wrote:
>=20
> > On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > >=20
> > > To use TDX functionality, TDX module needs to be loaded and initializ=
ed.
> > > A TDX host patch series[1] implements the detection of the TDX module=
,
> > > tdx_detect() and its initialization, tdx_init().
> >=20
> > "A TDX host patch series[1]" really isn't a commit message material.  Y=
ou can
> > put it to the cover letter, but not here.
> >=20
> > Also tdx_detect() is removed in latest code.
>=20
> How about the followings?
>=20
>     KVM: TDX: Initialize TDX module when loading kvm_intel.ko

Personally don't like kvm_intel.ko in title (or changelog), but will leave =
to
maintainers.

>    =20
>     To use TDX functionality, TDX module needs to be loaded and initializ=
ed.
>     This patch is to call a function, tdx_init(), when loading kvm_intel.=
ko.

Could you add explain why we need to init TDX module when loading KVM modul=
e?

You don't have to say "call a function, tdx_init()", which can be easily se=
en in
the code. =20

>    =20
>     Add a hook, kvm_arch_post_hardware_enable_setup, to module initializa=
tion
>     while hardware is enabled, i.e. after hardware_enable_all() and befor=
e
>     hardware_disable_all().  Because TDX requires all present CPUs to ena=
ble
>     VMX (VMXON).

Please explicitly say it is a replacement of the default __weak version, so
people can know there's already a default one.  Otherwise people may wonder=
 why
this isn't called in this patch (i.e. I skipped patch 03 as it looks not
directly related to TDX).

That being said, why cannot you send out that patch separately but have to
include it into TDX series?

Looking at it, the only thing that is related to TDX is an empty
kvm_arch_post_hardware_enable_setup() with a comment saying TDX needs to do
something there.  This logic has nothing to do with the actual job in that
patch.=20

So why cannot we introduce that __weak version in this patch, so that the r=
est
of it can be non-TDX related at all and can be upstreamed separately?

>=20
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 30af2bd0b4d5..fb7a33fbc136 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -11792,6 +11792,14 @@ int kvm_arch_hardware_setup(void *opaque)
> > >  	return 0;
> > >  }
> > > =20
> > > +int kvm_arch_post_hardware_enable_setup(void *opaque)
> > > +{
> > > +	struct kvm_x86_init_ops *ops =3D opaque;
> > > +	if (ops->post_hardware_enable_setup)
> > > +		return ops->post_hardware_enable_setup();
> > > +	return 0;
> > > +}
> > > +
> >=20
> > Where is this kvm_arch_post_hardware_enable_setup() called?
> >=20
> > Shouldn't the code change which calls it be part of this patch?
>=20
> The patch of "4/102 KVM: Refactor CPU compatibility check on module
> initialiization" introduces it.  Because the patch affects multiple archs
> (mips, x86, poerpc, s390, and arm), I deliberately put it in early.

It's patch 03, but not 04.  And see above.
