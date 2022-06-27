Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C3755D0C8
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242115AbiF0WKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 18:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238131AbiF0WKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 18:10:37 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91E213D39;
        Mon, 27 Jun 2022 15:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656367836; x=1687903836;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=3r3oxJCGBnkJZuklf2qLlNGuTGcw7hPnJG3vvORYXOc=;
  b=hCIzg0LXLT0ammDZPvC36vSbxXistTud33Ld/fuUBnqXJJt0p21PQRYi
   wvt8jGpPElAEQrQCVwkXewtErguTsnTWw4BWpQ3UQTEQ6qmzq0Eu9++4S
   sXbacdMWi7+vCrwrLsbaK7udDQqrZy8/Xel7+PjORmniY8mMYnxhTOXql
   s/i5LJnI5sjWs4ttyUOTEeRPXB2H+c06/4clyGWeRjnY51T91uBeJ2uGx
   Fr8h1r5/UoDKPTaxbVeC3kQMYI/MatVIfMku2OKXAhjwc27vS81f4Umvk
   tctJa+86QwREnBbrXs1gT2xMlCfOl8/+eV/XroriJ5rEXmR+8x+MX5xAc
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="307051943"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="307051943"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 15:10:32 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657868295"
Received: from iiturbeo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.89.183])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 15:10:29 -0700
Message-ID: <6bef368ccc68676e4acaecc4b6dc52f598ea7f2f.camel@intel.com>
Subject: Re: [PATCH v5 07/22] x86/virt/tdx: Implement SEAMCALL function
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Tue, 28 Jun 2022 10:10:27 +1200
In-Reply-To: <84e93539-a2f9-f68e-416a-ea3d8fc725af@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <095e6bbc57b4470e1e9a9104059a5238c9775f00.1655894131.git.kai.huang@intel.com>
         <069a062e-a4a6-09af-7b74-7f4929f2ec0b@intel.com>
         <5ce7ebfe54160ea35e432bf50207ebed32db31fc.camel@intel.com>
         <84e93539-a2f9-f68e-416a-ea3d8fc725af@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 13:58 -0700, Dave Hansen wrote:
> On 6/26/22 22:23, Kai Huang wrote:
> > On Fri, 2022-06-24 at 11:38 -0700, Dave Hansen wrote:
> > > On 6/22/22 04:16, Kai Huang wrote:
> > > > SEAMCALL instruction causes #GP when SEAMRR isn't enabled, and #UD =
when
> > > > CPU is not in VMX operation.  The TDX_MODULE_CALL macro doesn't han=
dle
> > > > SEAMCALL exceptions.  Leave to the caller to guarantee those condit=
ions
> > > > before calling __seamcall().
> > >=20
> > > I was trying to make the argument earlier that you don't need *ANY*
> > > detection for TDX, other than the ability to make a SEAMCALL.
> > > Basically, patch 01/22 could go away.
> ...
> > > So what does patch 01/22 buy us?  One EXTABLE entry?
> >=20
> > There are below pros if we can detect whether TDX is enabled by BIOS du=
ring boot
> > before initializing the TDX Module:
> >=20
> > 1) There are requirements from customers to report whether platform sup=
ports TDX
> > and the TDX keyID numbers before initializing the TDX module so the use=
rspace
> > cloud software can use this information to do something.  Sorry I canno=
t find
> > the lore link now.
>=20
> <sigh>
>=20
> Never listen to customers literally.  It'll just lead you down the wrong
> path.  They told you, "we need $FOO in dmesg" and you ran with it
> without understanding why.  The fact that you even *need* to find the
> lore link is because you didn't bother to realize what they really needed=
.
>=20
> dmesg is not ABI.  It's for humans.  If you need data out of the kernel,
> do it with a *REAL* ABI.  Not dmesg.

Showing in the dmesg is the first step, but later we have plan to expose ke=
yID
info via /sysfs.  Of course, it's always arguable customer's such requireme=
nt is
absolutely needed, but to me it's still a good thing to have code to detect=
 TDX
during boot.  The code isn't complicated as you can see.

>=20
> > 2) As you can see, it can be used to handle ACPI CPU/memory hotplug and=
 driver
> > managed memory hotplug.  Kexec() support patch also can use it.
> >=20
> > Particularly, in concept, ACPI CPU/memory hotplug is only related to wh=
ether TDX
> > is enabled by BIOS, but not whether TDX module is loaded, or the result=
 of
> > initializing the TDX module.  So I think we should have some code to de=
tect TDX
> > during boot.
>=20
> This is *EXACTLY* why our colleagues at Intel needs to tell us about
> what the OS and firmware should do when TDX is in varying states of decay=
.

Yes I am working on it to make it public.

>=20
> Does the mere presence of the TDX module prevent hotplug? =C2=A0
>=20

For ACPI CPU hotplug, yes.  The TDX module even doesn't need to be loaded.=
=20
Whether SEAMRR is enabled determines.

For ACPI memory hotplug, in practice yes.  For architectural behaviour, I'l=
l
work with others internally to get some public statement.

> Or, if a
> system has the TDX module loaded but no intent to ever use TDX, why
> can't it just use hotplug like a normal system which is not addled with
> the TDX albatross around its neck?

I think if a machine has enabled TDX in the BIOS, the user of the machine v=
ery
likely has intention to actually use TDX.

Yes for driver-managed memory hotplug, it makes sense if user doesn't want =
to
use TDX, it's better to not disable it.  But to me it's also not a disaster=
 if
we just disable driver-managed memory hotplug if TDX is enabled by BIOS.

For ACPI memory hotplug, I think in practice we can treat it as BIOS bug, b=
ut
I'll get some public statement around this.

>=20
> > Also, it seems adding EXTABLE to TDX_MODULE_CALL doesn't have significa=
ntly less
> > code comparing to detecting TDX during boot:
>=20
> It depends on a bunch of things.  It might only be a line or two of
> assembly.
>=20
> If you actually went and tried it, you might be able to convince me it's
> a bad idea.

The code I showed is basically the patch we need to call SEAMCALL at runtim=
e w/o
detecting TDX at first.  #GP must be handled as it is what SEAMCALL trigger=
s if
TDX is not enabled.  #UD happens when CPU isn't in VMX operation, and we sh=
ould
distinguish it from #GP if we already want to handle #GP.


--=20
Thanks,
-Kai


