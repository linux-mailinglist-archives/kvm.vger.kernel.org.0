Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D860581F08
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 06:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240373AbiG0Eig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 00:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbiG0Eif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 00:38:35 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD0E3D5B3;
        Tue, 26 Jul 2022 21:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658896714; x=1690432714;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=YMhXWeVMk+UkhxXqNppHdouIOblrChcF2IrAL1cV3hc=;
  b=eljJLS3ZU4+czZKZB2raD/R9jw6xT+DeYhSK40m4U1xZmcRm4NykGBGO
   /VxkQ59dDX4y6xYrxwQdaJnlcd2+uYpuKErIMLsP6cfgorpwcWpMLuRa1
   E0GQOnvvJUJ7dSKUqJtmXAKQskE8LoIBgNRQye7SSvIppEDgwbrKXJEDD
   Lhex/pXwaj3laOZNeHfjvayjO+ZCFHHTOrxq/ZEnw84b8nwM2KjdjrGoc
   c3oOXWrs5gra0Xme+l6nPXonR0hr1DI+mEqvW5gDAvjuKXv+0z91Mk9Cf
   hSrzoX0m7EN3bqRg4uMpqXUnBIMGuqjAiEoaLY4mZA2WDAHA9BHcjqcwp
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="352136439"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="352136439"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 21:38:34 -0700
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="726800762"
Received: from jlseahol-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.1.35])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 21:38:32 -0700
Message-ID: <14c534e33cd45feba6a9a79ec442631f0a36418a.camel@intel.com>
Subject: Re: [PATCH v7 011/102] KVM: TDX: Initialize TDX module when loading
 kvm_intel.ko
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Wed, 27 Jul 2022 16:38:30 +1200
In-Reply-To: <20220727003938.GG1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <d933e5f16ff8cb58020f1479b7af35196f0ef61e.1656366338.git.isaku.yamahata@intel.com>
         <81ea5068b890400ca4064781f7d2221826701020.camel@intel.com>
         <20220712004640.GD1379820@ls.amr.corp.intel.com>
         <d495a777f31df86271f1c4511b2f521adfa867d1.camel@intel.com>
         <20220727003938.GG1379820@ls.amr.corp.intel.com>
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

On Tue, 2022-07-26 at 17:39 -0700, Isaku Yamahata wrote:
> On Tue, Jul 12, 2022 at 01:13:10PM +1200,
> Kai Huang <kai.huang@intel.com> wrote:
>=20
> > >     To use TDX functionality, TDX module needs to be loaded and initi=
alized.
> > >     This patch is to call a function, tdx_init(), when loading kvm_in=
tel.ko.
> >=20
> > Could you add explain why we need to init TDX module when loading KVM m=
odule?
>=20
> Makes sense. Added a paragraph for it.
>=20
>=20
> > >     Add a hook, kvm_arch_post_hardware_enable_setup, to module initia=
lization
> > >     while hardware is enabled, i.e. after hardware_enable_all() and b=
efore
> > >     hardware_disable_all().  Because TDX requires all present CPUs to=
 enable
> > >     VMX (VMXON).
> >=20
> > Please explicitly say it is a replacement of the default __weak version=
, so
> > people can know there's already a default one.  Otherwise people may wo=
nder why
> > this isn't called in this patch (i.e. I skipped patch 03 as it looks no=
t
> > directly related to TDX).
> >=20
> > That being said, why cannot you send out that patch separately but have=
 to
> > include it into TDX series?
> >=20
> > Looking at it, the only thing that is related to TDX is an empty
> > kvm_arch_post_hardware_enable_setup() with a comment saying TDX needs t=
o do
> > something there.  This logic has nothing to do with the actual job in t=
hat
> > patch.=20
> >=20
> > So why cannot we introduce that __weak version in this patch, so that t=
he rest
> > of it can be non-TDX related at all and can be upstreamed separately?
>=20
> The patch that adds weak kvm_arch_post_hardware_enable_setup() doesn't ma=
ke
> sense without the hook because it only enable_hardware and then disable h=
ardware
> immediately.

It's not a disaster if you describe the reason to do so in the changelog, b=
ut no
strong opinion here.

But I do think you need a comment to explain why disable hardware is called
immediately.  Is it because we want to maintain the current behaviour that =
we
want to allow out-of-tree driver, i.e. virtualbox to be loaded when KVM is
loaded?

=20
> The patch touches multiple kvm arch.  and I split out TDX specific part i=
n this
> patch.  Ideally those two patch should be near. But I move it early to dr=
aw
> attention for reviewers from multiple kvm arch.

Explicitly say this is the replacement of the default __weak version is fin=
e.

>=20
> Here is the updated version.
>=20
>     KVM: TDX: Initialize the TDX module when loading the KVM intel kernel=
 module
>    =20
>     To use TDX, the TDX module needs to be loaded and initialized.  This =
patch
>     is to call a function to initialize the TDX module when loading KVM i=
ntel
>     kernel module.
>    =20
>     There are several options on when to initialize the TDX module.  A.)
>     kernel boot time as builtin, B.) kernel module loading time, C.) the =
first
>     guest TD creation time.  B.) was chosen.  A.) causes unnecessary over=
head
>     (boot time and memory) even when TDX isn't used.  With C.), a user ma=
y hit
>     an error of the TDX initialization when trying to create the first gu=
est
>     TD.  The machine that fails to initialize the TDX module can't boot a=
ny
>     guest TD further.  Such failure is undesirable.  B.) has a good balan=
ce
>     between them.

You don't need to mention A.  When this patch is merged, the host series mu=
st
have been merged already.  In another words, this is already a fact, but no=
t an
option.

>    =20
>     Add a hook, kvm_arch_post_hardware_enable_setup, to module initializa=
tion
>     while hardware is enabled, i.e. after hardware_enable_all() and befor=
e
>     hardware_disable_all(). =C2=A0
>=20

You don't need to say "add a hook ..., i.e. after hardware_enable_all() and
before hardware_disable_all()".  Where the function is called is already a =
fact.
We have a __weak version already.


> Because TDX requires all present CPUs to enable
>     VMX (VMXON).  The x86 specific kvm_arch_post_hardware_enable_setup ov=
errides
>     the existing weak symbol of kvm_arch_post_hardware_enable_setup which=
 is
>     called at the KVM module initialization.
>=20

