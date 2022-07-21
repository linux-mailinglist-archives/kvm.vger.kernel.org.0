Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56E057C1FF
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 03:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiGUBxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 21:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiGUBxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 21:53:06 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE0013F05;
        Wed, 20 Jul 2022 18:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658368385; x=1689904385;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=tGWGfwBrrt8UdqC+U1T2NmOyIOrjudQI99sr5Oth/Wg=;
  b=XcUd9Dz5obYDABPIm9iQSaC/UVvoYjgde+OSN3I00pXjOIv+D5pdCTPY
   psHHcojqsF53k+XyTnnWwCszxlj1vsUmI96V8UkDEwl98kWMEa0xa4Gtk
   uMz9CbAPL82UOfPBlF35e1hockVnXE63VRrPdxbbmRPe0L9r1oozj0FuF
   EwA+lh0zGl0TlxkvBQlrnr7YbxBtM7vF6sxbGQ4kG+h5DqMJu5Ob+UT9E
   LGuZ/q8JI7KxxVxMz+znvtnQiRSD3IMsJKyE18iO8UGbUWLcV+OKNUXTr
   IuJa3NmkOcVdZG0IL0G6c6a9NMTQ3owwR52bVfriclJL3Xflhs0LgnGY0
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="286935809"
X-IronPort-AV: E=Sophos;i="5.92,288,1650956400"; 
   d="scan'208";a="286935809"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 18:53:05 -0700
X-IronPort-AV: E=Sophos;i="5.92,288,1650956400"; 
   d="scan'208";a="548588706"
Received: from mprillw-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.182.177])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 18:53:01 -0700
Message-ID: <0b20f1878d31658a9e3cd3edaf3826fe8731346e.camel@intel.com>
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
Date:   Thu, 21 Jul 2022 13:52:59 +1200
In-Reply-To: <978c3d37-97c9-79b9-426a-2c27db34c38a@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <095e6bbc57b4470e1e9a9104059a5238c9775f00.1655894131.git.kai.huang@intel.com>
         <069a062e-a4a6-09af-7b74-7f4929f2ec0b@intel.com>
         <5ce7ebfe54160ea35e432bf50207ebed32db31fc.camel@intel.com>
         <84e93539-a2f9-f68e-416a-ea3d8fc725af@intel.com>
         <6bef368ccc68676e4acaecc4b6dc52f598ea7f2f.camel@intel.com>
         <ea03e55499f556388c0a5f9ed565e72e213c276f.camel@intel.com>
         <978c3d37-97c9-79b9-426a-2c27db34c38a@intel.com>
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

On Wed, 2022-07-20 at 09:48 -0700, Dave Hansen wrote:
> On 7/20/22 03:18, Kai Huang wrote:
> > Try to close on how to handle memory hotplug.  After discussion, below =
will be
> > architectural behaviour of TDX in terms of ACPI memory hotplug:
> >=20
> > 1) During platform boot, CMRs must be physically present. MCHECK verifi=
es all
> > CMRs are physically present and are actually TDX convertible memory.
>=20
> I doubt this is strictly true.  This makes it sound like MCHECK is doing
> *ACTUAL* verification that the memory is, in practice, convertible.
> That would mean actually writing to it, which would take a long time for
> a large system.

The "verify" is used in many places in the specs.  In the public TDX module
spec, it is also used:

Table 1.1: Intel TDX Glossary
CMR: A range of physical memory configured by BIOS and verified by MCHECK

I guess to verify, MCHECK doesn't need to actually write something to memor=
y.=20
For example, when memory is present, it can know what type it is so it can
determine.

>=20
> Does it *ACTUALLY* verify this?

Yes.  This is what spec says.  And this is what Intel colleagues said.

>=20
> Also, it's very odd to say that "CMRs must be physically present".  A
> CMR itself is a logical construct.  The physical memory *backing* a CMR
> is, something else entirely.

OK.  But I think it is easy to interpret this actually means the physical m=
emory
*backing* a CMR.

>=20
> > 2) CMRs are static after platform boots and don't change at runtime. =
=C2=A0TDX
> > architecture doesn't support hot-add or hot-removal of CMR memory.
> > 3) TDX architecture doesn't forbid non-CMR memory hotplug.
> >=20
> > Also, although TDX doesn't trust BIOS in terms of security, a non-buggy=
 BIOS
> > should prevent CMR memory from being hot-removed.  If kernel ever recei=
ves such
> > event, it's a BIOS bug, or even worse, the BIOS is compromised and unde=
r attack.
> >=20
> > As a result, the kernel should also never receive event of hot-add CMR =
memory.=20
> > It is very much likely TDX is under attack (physical attack) in such ca=
se, i.e.
> > someone is trying to physically replace any CMR memory.
> >=20
> > In terms of how to handle ACPI memory hotplug, my thinking is -- ideall=
y, if the
> > kernel can get the CMRs during kernel boot when detecting whether TDX i=
s enabled
> > by BIOS, we can do below:
> >=20
> > - For memory hot-removal, if the removed memory falls into any CMR, the=
n kernel
> > can speak loudly it is a BIOS bug.  But when this happens, the hot-remo=
val has
> > been handled by BIOS thus kernel cannot actually prevent, so kernel can=
 either
> > BUG(), or just print error message.  If the removed memory doesn't fall=
 into
> > CMR, we do nothing.
>=20
> Hold on a sec.  Hot-removal is a two-step process.  The kernel *MUST*
> know in advance that the removal is going to occur. =C2=A0It follows that=
 up
> with evacuating the memory, giving the "all clear", then the actual
> physical removal can occur.

After looking more, looks "the hot-removal has been handled by BIOS" is wro=
ng.=20
And you are right there's a previous step must be done (it is device offlin=
e).=20
But the "kernel cannot actually prevent" means in the device removal callba=
ck,
the kernel cannot prevent it from being removed.

This is my understanding by reading the ACPI spec and the code:

Firstly, the BIOS will send a "Eject Request" notification to the kernel. U=
pon
receiving this event, the kernel will firstly try to offline the device (wh=
ich
can fail due to -EBUSY, etc).  If offline is successful, the kernel will ca=
ll
device's remove callback to remove the device.  But this remove callback do=
esn't
return error code (which means it doesn't fail).  Instead, after the remove
callback is done, the kernel calls _EJ0 ACPI method to actually do the ejec=
tion.

>=20
> I'm not sure what you're getting at with the "kernel cannot actually
> prevent" bit.  No sane system actively destroys perfect good memory
> content and tells the kernel about it after the fact.

The kernel will offline the device first.  This guarantees all good memory
content has been migrated.

>=20
> > - For memory hot-add, if the new memory falls into any CMR, then kernel=
 should
> > speak loudly it is a BIOS bug, or even say "TDX is under attack" as thi=
s is only
> > possible when CMR memory has been previously hot-removed.
>=20
> I don't think this is strictly true.  It's totally possible to get a
> hot-add *event* for memory which is in a CMR.  It would be another BIOS
> bug, of course, but hot-remove is not a prerequisite purely for an event.

OK.

>=20
> > And kernel should
> > reject the new memory for security reason.  If the new memory doesn't f=
all into
> > any CMR, then we (also) just reject the new memory, as we want to guara=
ntee all
> > memory in page allocator are TDX pages.  But this is basically due to k=
ernel
> > policy but not due to TDX architecture.
>=20
> Agreed.
>=20
> > BUT, since as the first step, we cannot get the CMR during kernel boot =
(as it
> > requires additional code to put CPU into VMX operation), I think for no=
w we can
> > handle ACPI memory hotplug in below way:
> >=20
> > - For memory hot-removal, we do nothing.
>=20
> This doesn't seem right to me.  *If* we get a known-bogus hot-remove
> event, we need to reject it.  Remember, removal is a two-step process.

If so, we need to reject the (CMR) memory offline.  Or we just BUG() in the=
 ACPI
memory removal  callback?

But either way this will requires us to get the CMRs during kernel boot.

Do you think we need to add this support in the first series?

>=20
> > - For memory hot-add, we simply reject the new memory when TDX is enabl=
ed by
> > BIOS.  This not only prevents the potential "physical attack of replaci=
ng any
> > CMR memory",
>=20
> I don't think there's *any* meaningful attack mitigation here.  Even if
> someone managed to replace the physical address space that backed some
> private memory, the integrity checksums won't match.  Memory integrity
> mitigates physical replacement, not software.

My thinking is rejecting the new memory is a more aggressive defence than
waiting until integrity checksum failure.

Btw, the integrity checksum support isn't a mandatory requirement for TDX
architecture.  In fact, TDX also supports a mode which doesn't require inte=
grity
check (for instance, TDX on client machines).

>=20
> > but also makes sure no non-CMR memory will be added to page
> > allocator during runtime via ACPI memory hot-add.
>=20
> Agreed.  This one _is_ important and since it supports an existing
> policy, it makes sense to enforce this in the kernel.
>=20
> > We can improve this in next stage when we can get CMRs during kernel bo=
ot.
> >=20
> > For the concern that on a TDX BIOS enabled system, people may not want =
to use
> > TDX at all but just use it as normal system, as I replied to Dan regard=
ing to
> > the driver-managed memory hotplug, we can provide a kernel commandline,=
 i.e.
> > use_tdx=3D{on|off}, to allow user to *choose* between TDX and memory ho=
tplug.=20
> > When use_tdx=3Doff, we continue to allow memory hotplug and driver-mana=
ged hotplug
> > as normal but refuse to initialize TDX module.
>=20
> That doesn't sound like a good resolution to me.
>=20
> It conflates pure "software" hotplug operations like transitioning
> memory ownership from the core mm to a driver (like device DAX).
>=20
> TDX should not have *ANY* impact on purely software operations.  Period.

The hard requirement is: Once TDX module gets initialized, we cannot add an=
y
*new* memory to core-mm.

But if some memory block is included to TDX memory when the module gets
initialized, then we should be able to move it from core-mm to driver or vi=
ce
versa.  In this case, we can select all memory regions that the kernel want=
s to
use as TDX memory at some point (during kernel boot I guess). =C2=A0

Adding any non-selected-TDX memory regions to core-mm should always be reje=
cted
(therefore there's no removal of them from core-mm either), although it is
"software" hotplug.  If user wants this, he/she cannot use TDX.  This is wh=
at I
mean we can provide command line to allow user to *choose*.

Also, if I understand correctly above, your suggestion is we want to preven=
t any
CMR memory going offline so it won't be hot-removed (assuming we can get CM=
Rs
during boot).  This looks contradicts to the requirement of being able to a=
llow
moving memory from core-mm to driver.  When we offline the memory, we canno=
t
know whether the memory will be used by driver, or later hot-removed.
