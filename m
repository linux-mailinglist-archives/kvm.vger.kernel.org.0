Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB61A57AA75
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 01:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238810AbiGSX2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 19:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238173AbiGSX2M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 19:28:12 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0CA62A50;
        Tue, 19 Jul 2022 16:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658273291; x=1689809291;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=T4kVmJLpu7UE0MsPr1RXmKdo4hskRHKOMDrvdsxMDDI=;
  b=LqWNtAmrvtEZ1mxcuXoYi517jBhmQ1mC5DyM22Duu8Re1FAaaiExqAwx
   rIHJR1vpMMQjfWbaXyS2JawtRi7Bwr0huOhClD1vIW2d0fBOhfMOFiKQE
   peMx1Ofhtks/bGimLjk3j2PcHQ8ybO0Hajp5W5AQlbfDqwn/dZvTgQ8TC
   p1Klhj9FwRJNkWTT4WFna+13AnJ2LH1uuE4ebTxVGMc0XFMPgOg7wik9C
   FTQzD8vrJk+IonA0AhIXpmKQaJx2AJ/nbX24McKCC1xW/Xb7FmFwfeFpb
   BaPq8jTLUqJ88wqhYjTjvUGWnJg0H4eY7OYRaakL0NhMCNnERaIwuqeZR
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="287787413"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="287787413"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 16:28:10 -0700
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="665640633"
Received: from ecurtis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.162.137])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 16:28:07 -0700
Message-ID: <e8cd46df9e3ea5c8c97397a2e89057f521e9eb66.camel@intel.com>
Subject: Re: [PATCH v5 07/22] x86/virt/tdx: Implement SEAMCALL function
From:   Kai Huang <kai.huang@intel.com>
To:     Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, peterz@infradead.org,
        ak@linux.intel.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Wed, 20 Jul 2022 11:28:05 +1200
In-Reply-To: <62d7085729358_97b64294f2@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1655894131.git.kai.huang@intel.com>
         <095e6bbc57b4470e1e9a9104059a5238c9775f00.1655894131.git.kai.huang@intel.com>
         <069a062e-a4a6-09af-7b74-7f4929f2ec0b@intel.com>
         <5ce7ebfe54160ea35e432bf50207ebed32db31fc.camel@intel.com>
         <84e93539-a2f9-f68e-416a-ea3d8fc725af@intel.com>
         <6bef368ccc68676e4acaecc4b6dc52f598ea7f2f.camel@intel.com>
         <62d7085729358_97b64294f2@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-07-19 at 12:39 -0700, Dan Williams wrote:
> Kai Huang wrote:
> > On Mon, 2022-06-27 at 13:58 -0700, Dave Hansen wrote:
> > > On 6/26/22 22:23, Kai Huang wrote:
> > > > On Fri, 2022-06-24 at 11:38 -0700, Dave Hansen wrote:
> > > > > On 6/22/22 04:16, Kai Huang wrote:
> > > > > > SEAMCALL instruction causes #GP when SEAMRR isn't enabled, and =
#UD when
> > > > > > CPU is not in VMX operation.  The TDX_MODULE_CALL macro doesn't=
 handle
> > > > > > SEAMCALL exceptions.  Leave to the caller to guarantee those co=
nditions
> > > > > > before calling __seamcall().
> > > > >=20
> > > > > I was trying to make the argument earlier that you don't need *AN=
Y*
> > > > > detection for TDX, other than the ability to make a SEAMCALL.
> > > > > Basically, patch 01/22 could go away.
> > > ...
> > > > > So what does patch 01/22 buy us?  One EXTABLE entry?
> > > >=20
> > > > There are below pros if we can detect whether TDX is enabled by BIO=
S during boot
> > > > before initializing the TDX Module:
> > > >=20
> > > > 1) There are requirements from customers to report whether platform=
 supports TDX
> > > > and the TDX keyID numbers before initializing the TDX module so the=
 userspace
> > > > cloud software can use this information to do something.  Sorry I c=
annot find
> > > > the lore link now.
> > >=20
> > > <sigh>
> > >=20
> > > Never listen to customers literally.  It'll just lead you down the wr=
ong
> > > path.  They told you, "we need $FOO in dmesg" and you ran with it
> > > without understanding why.  The fact that you even *need* to find the
> > > lore link is because you didn't bother to realize what they really ne=
eded.
> > >=20
> > > dmesg is not ABI.  It's for humans.  If you need data out of the kern=
el,
> > > do it with a *REAL* ABI.  Not dmesg.
> >=20
> > Showing in the dmesg is the first step, but later we have plan to expos=
e keyID
> > info via /sysfs.  Of course, it's always arguable customer's such requi=
rement is
> > absolutely needed, but to me it's still a good thing to have code to de=
tect TDX
> > during boot.  The code isn't complicated as you can see.
> >=20
> > >=20
> > > > 2) As you can see, it can be used to handle ACPI CPU/memory hotplug=
 and driver
> > > > managed memory hotplug.  Kexec() support patch also can use it.
> > > >=20
> > > > Particularly, in concept, ACPI CPU/memory hotplug is only related t=
o whether TDX
> > > > is enabled by BIOS, but not whether TDX module is loaded, or the re=
sult of
> > > > initializing the TDX module.  So I think we should have some code t=
o detect TDX
> > > > during boot.
> > >=20
> > > This is *EXACTLY* why our colleagues at Intel needs to tell us about
> > > what the OS and firmware should do when TDX is in varying states of d=
ecay.
> >=20
> > Yes I am working on it to make it public.
> >=20
> > >=20
> > > Does the mere presence of the TDX module prevent hotplug? =C2=A0
> > >=20
> >=20
> > For ACPI CPU hotplug, yes.  The TDX module even doesn't need to be load=
ed.=20
> > Whether SEAMRR is enabled determines.
> >=20
> > For ACPI memory hotplug, in practice yes.  For architectural behaviour,=
 I'll
> > work with others internally to get some public statement.
> >=20
> > > Or, if a
> > > system has the TDX module loaded but no intent to ever use TDX, why
> > > can't it just use hotplug like a normal system which is not addled wi=
th
> > > the TDX albatross around its neck?
> >=20
> > I think if a machine has enabled TDX in the BIOS, the user of the machi=
ne very
> > likely has intention to actually use TDX.
> >=20
> > Yes for driver-managed memory hotplug, it makes sense if user doesn't w=
ant to
> > use TDX, it's better to not disable it.  But to me it's also not a disa=
ster if
> > we just disable driver-managed memory hotplug if TDX is enabled by BIOS=
.
>=20
> No, driver-managed memory hotplug is how Linux handles "dedicated
> memory" management. The architecture needs to comprehend that end users
> may want to move address ranges into and out of Linux core-mm management
> independently of whether those address ranges are also covered by a SEAM
> range.

But to avoid GFP_TDX (and ZONE_TDX) staff, we need to guarantee all memory =
pages
in page allocator are TDX pages.  To me it's at least quite fair that user =
needs
to *choose* to use driver-managed memory hotplug or TDX.

If automatically disable driver-managed memory hotplug on a TDX BIOS enable=
d
platform isn't desired, how about we introduce a kernel command line (i.e.
use_tdx=3D{on|off}) to let user to choose?

If user specifies use_tdx=3Don, then user cannot use driver-managed memory
hotplug.  if use_tdx=3Doff, then user cannot use TDX even it is enabled by =
BIOS.

