Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C0F57B45C
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 12:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbiGTKSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 06:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiGTKSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 06:18:18 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1629FD2;
        Wed, 20 Jul 2022 03:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658312297; x=1689848297;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=zJGqHdShaBf2frYWeGAD4nc3U4rFK1l2uN03UPQgUCE=;
  b=H6/2PtEmhd0oZmOZ7L8aCpH5M+JVpeMCicV+Pc7AWTEl+PwgdDZaUsOu
   XDCydLQ2m5pzzBGSn2l2wDlyELqj39ertDDyZfFnOvsv/89QNQkkWSlAn
   p2PkD8tHlCFviMUBn2o0eAsGN6pME9BrnLAvlPuXrEEazLDYU0F4fU4qs
   y6fsl+v/jXcm10ZCe/EmHOvXjfI3K6CyA2BCR4o+5v1om5Ti1nM8y4xJa
   m6dsHwX/eiQz+A58cLusRBtUXmcB6pX4AwPAac5mz78RiLRKkseuveuqv
   lvBsIcdMaWSo08LpDMWXM3xOrUSMb7SVOxiZHgEKdajtrmHpc7Y8dUywi
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="284297351"
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="284297351"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 03:18:17 -0700
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="843994786"
Received: from ecurtis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.162.137])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 03:18:14 -0700
Message-ID: <ea03e55499f556388c0a5f9ed565e72e213c276f.camel@intel.com>
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
Date:   Wed, 20 Jul 2022 22:18:12 +1200
In-Reply-To: <6bef368ccc68676e4acaecc4b6dc52f598ea7f2f.camel@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <095e6bbc57b4470e1e9a9104059a5238c9775f00.1655894131.git.kai.huang@intel.com>
         <069a062e-a4a6-09af-7b74-7f4929f2ec0b@intel.com>
         <5ce7ebfe54160ea35e432bf50207ebed32db31fc.camel@intel.com>
         <84e93539-a2f9-f68e-416a-ea3d8fc725af@intel.com>
         <6bef368ccc68676e4acaecc4b6dc52f598ea7f2f.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-28 at 10:10 +1200, Kai Huang wrote:
> On Mon, 2022-06-27 at 13:58 -0700, Dave Hansen wrote:
> > On 6/26/22 22:23, Kai Huang wrote:
> > > On Fri, 2022-06-24 at 11:38 -0700, Dave Hansen wrote:
> > > > On 6/22/22 04:16, Kai Huang wrote:
> > > > > SEAMCALL instruction causes #GP when SEAMRR isn't enabled, and #U=
D when
> > > > > CPU is not in VMX operation.  The TDX_MODULE_CALL macro doesn't h=
andle
> > > > > SEAMCALL exceptions.  Leave to the caller to guarantee those cond=
itions
> > > > > before calling __seamcall().
> > > >=20
> > > > I was trying to make the argument earlier that you don't need *ANY*
> > > > detection for TDX, other than the ability to make a SEAMCALL.
> > > > Basically, patch 01/22 could go away.
> > ...
> > > > So what does patch 01/22 buy us?  One EXTABLE entry?
> > >=20
> > > There are below pros if we can detect whether TDX is enabled by BIOS =
during boot
> > > before initializing the TDX Module:
> > >=20
> > > 1) There are requirements from customers to report whether platform s=
upports TDX
> > > and the TDX keyID numbers before initializing the TDX module so the u=
serspace
> > > cloud software can use this information to do something.  Sorry I can=
not find
> > > the lore link now.
> >=20
> > <sigh>
> >=20
> > Never listen to customers literally.  It'll just lead you down the wron=
g
> > path.  They told you, "we need $FOO in dmesg" and you ran with it
> > without understanding why.  The fact that you even *need* to find the
> > lore link is because you didn't bother to realize what they really need=
ed.
> >=20
> > dmesg is not ABI.  It's for humans.  If you need data out of the kernel=
,
> > do it with a *REAL* ABI.  Not dmesg.
>=20
> Showing in the dmesg is the first step, but later we have plan to expose =
keyID
> info via /sysfs.  Of course, it's always arguable customer's such require=
ment is
> absolutely needed, but to me it's still a good thing to have code to dete=
ct TDX
> during boot.  The code isn't complicated as you can see.
>=20
> >=20
> > > 2) As you can see, it can be used to handle ACPI CPU/memory hotplug a=
nd driver
> > > managed memory hotplug.  Kexec() support patch also can use it.
> > >=20
> > > Particularly, in concept, ACPI CPU/memory hotplug is only related to =
whether TDX
> > > is enabled by BIOS, but not whether TDX module is loaded, or the resu=
lt of
> > > initializing the TDX module.  So I think we should have some code to =
detect TDX
> > > during boot.
> >=20
> > This is *EXACTLY* why our colleagues at Intel needs to tell us about
> > what the OS and firmware should do when TDX is in varying states of dec=
ay.
>=20
> Yes I am working on it to make it public.
>=20
> >=20
> > Does the mere presence of the TDX module prevent hotplug? =C2=A0
> >=20
>=20
> For ACPI CPU hotplug, yes.  The TDX module even doesn't need to be loaded=
.=20
> Whether SEAMRR is enabled determines.
>=20
> For ACPI memory hotplug, in practice yes.  For architectural behaviour, I=
'll
> work with others internally to get some public statement.
>=20
> > Or, if a
> > system has the TDX module loaded but no intent to ever use TDX, why
> > can't it just use hotplug like a normal system which is not addled with
> > the TDX albatross around its neck?
>=20
> I think if a machine has enabled TDX in the BIOS, the user of the machine=
 very
> likely has intention to actually use TDX.
>=20
> Yes for driver-managed memory hotplug, it makes sense if user doesn't wan=
t to
> use TDX, it's better to not disable it.  But to me it's also not a disast=
er if
> we just disable driver-managed memory hotplug if TDX is enabled by BIOS.
>=20
> For ACPI memory hotplug, I think in practice we can treat it as BIOS bug,=
 but
> I'll get some public statement around this.
>=20

Hi Dave,

Try to close on how to handle memory hotplug.  After discussion, below will=
 be
architectural behaviour of TDX in terms of ACPI memory hotplug:

1) During platform boot, CMRs must be physically present. MCHECK verifies a=
ll
CMRs are physically present and are actually TDX convertible memory.
2) CMRs are static after platform boots and don't change at runtime. =C2=A0=
TDX
architecture doesn't support hot-add or hot-removal of CMR memory.
3) TDX architecture doesn't forbid non-CMR memory hotplug.

Also, although TDX doesn't trust BIOS in terms of security, a non-buggy BIO=
S
should prevent CMR memory from being hot-removed.  If kernel ever receives =
such
event, it's a BIOS bug, or even worse, the BIOS is compromised and under at=
tack.

As a result, the kernel should also never receive event of hot-add CMR memo=
ry.=20
It is very much likely TDX is under attack (physical attack) in such case, =
i.e.
someone is trying to physically replace any CMR memory.

In terms of how to handle ACPI memory hotplug, my thinking is -- ideally, i=
f the
kernel can get the CMRs during kernel boot when detecting whether TDX is en=
abled
by BIOS, we can do below:

- For memory hot-removal, if the removed memory falls into any CMR, then ke=
rnel
can speak loudly it is a BIOS bug.  But when this happens, the hot-removal =
has
been handled by BIOS thus kernel cannot actually prevent, so kernel can eit=
her
BUG(), or just print error message.  If the removed memory doesn't fall int=
o
CMR, we do nothing.

- For memory hot-add, if the new memory falls into any CMR, then kernel sho=
uld
speak loudly it is a BIOS bug, or even say "TDX is under attack" as this is=
 only
possible when CMR memory has been previously hot-removed.  And kernel shoul=
d
reject the new memory for security reason.  If the new memory doesn't fall =
into
any CMR, then we (also) just reject the new memory, as we want to guarantee=
 all
memory in page allocator are TDX pages.  But this is basically due to kerne=
l
policy but not due to TDX architecture.

BUT, since as the first step, we cannot get the CMR during kernel boot (as =
it
requires additional code to put CPU into VMX operation), I think for now we=
 can
handle ACPI memory hotplug in below way:

- For memory hot-removal, we do nothing.
- For memory hot-add, we simply reject the new memory when TDX is enabled b=
y
BIOS.  This not only prevents the potential "physical attack of replacing a=
ny
CMR memory", but also makes sure no non-CMR memory will be added to page
allocator during runtime via ACPI memory hot-add.

We can improve this in next stage when we can get CMRs during kernel boot.

For the concern that on a TDX BIOS enabled system, people may not want to u=
se
TDX at all but just use it as normal system, as I replied to Dan regarding =
to
the driver-managed memory hotplug, we can provide a kernel commandline, i.e=
.
use_tdx=3D{on|off}, to allow user to *choose* between TDX and memory hotplu=
g.=20
When use_tdx=3Doff, we continue to allow memory hotplug and driver-managed =
hotplug
as normal but refuse to initialize TDX module.

Any comments?


=20


