Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889C8589A44
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 12:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238660AbiHDKGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 06:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiHDKGV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 06:06:21 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8341144A;
        Thu,  4 Aug 2022 03:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659607580; x=1691143580;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=6LzfFaMcibOIFh7i21tihe87Mm/yg4T+Qwrw9BpYauo=;
  b=lOp1D+Op7RAfv6xZlk2wLfpM9kHsbdx40SrGiKnv98x9vhx9vKxypALQ
   4JCkv0szEWjsYNjpKHaGpT7ZD7LaPYnQAhmL34Eh8BS4Wb71z6G95hCip
   ZGYlbLDi0Tl9C+PcXfcq/BjQqSsmEKyUQmtvTkysnFNhrZsE8NUk3ERoe
   O7nv0i0tAlXoCpe0usFSkfV9zU4jZOyhhTaZyJx1xmncCD8TMxeU0IVdU
   qP/jxNdNzWKDTaVuLyuA7hpg7EjZUx9/7lQ7LKIG8krZGzk5607/5Wpsz
   Tn7v/AhWw8Eg4nxO54JUrFxSVTwBYe9DuUs4jL5UjyzMzxdfoQYrZ27vd
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10428"; a="290671289"
X-IronPort-AV: E=Sophos;i="5.93,215,1654585200"; 
   d="scan'208";a="290671289"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 03:06:19 -0700
X-IronPort-AV: E=Sophos;i="5.93,215,1654585200"; 
   d="scan'208";a="599954926"
Received: from bshamoun-mobl4.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.8.236])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 03:06:16 -0700
Message-ID: <7e4bdbf988addfa811e3317e6da7ef691bd46c3a.camel@intel.com>
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
Date:   Thu, 04 Aug 2022 22:06:13 +1200
In-Reply-To: <28ece806443e4de04d7e587d7e678d58259f9c5b.camel@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <095e6bbc57b4470e1e9a9104059a5238c9775f00.1655894131.git.kai.huang@intel.com>
         <069a062e-a4a6-09af-7b74-7f4929f2ec0b@intel.com>
         <5ce7ebfe54160ea35e432bf50207ebed32db31fc.camel@intel.com>
         <84e93539-a2f9-f68e-416a-ea3d8fc725af@intel.com>
         <6bef368ccc68676e4acaecc4b6dc52f598ea7f2f.camel@intel.com>
         <ea03e55499f556388c0a5f9ed565e72e213c276f.camel@intel.com>
         <978c3d37-97c9-79b9-426a-2c27db34c38a@intel.com>
         <0b20f1878d31658a9e3cd3edaf3826fe8731346e.camel@intel.com>
         <c96a78c6a8caf25b01e450f139c934688d1735b0.camel@intel.com>
         <54cf3e98-49d3-81f5-58e6-ca62671ab457@intel.com>
         <28ece806443e4de04d7e587d7e678d58259f9c5b.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-08-04 at 10:35 +1200, Kai Huang wrote:
> On Wed, 2022-08-03 at 07:20 -0700, Dave Hansen wrote:
> > On 8/2/22 19:37, Kai Huang wrote:
> > > On Thu, 2022-07-21 at 13:52 +1200, Kai Huang wrote:
> > > > Also, if I understand correctly above, your suggestion is we want t=
o prevent any
> > > > CMR memory going offline so it won't be hot-removed (assuming we ca=
n get CMRs
> > > > during boot).=C2=A0 This looks contradicts to the requirement of be=
ing able to allow
> > > > moving memory from core-mm to driver.=C2=A0 When we offline the mem=
ory, we cannot
> > > > know whether the memory will be used by driver, or later hot-remove=
d.
> > > Hi Dave,
> > >=20
> > > The high level flow of device hot-removal is:
> > >=20
> > > acpi_scan_hot_remove()
> > > 	-> acpi_scan_try_to_offline()
> > > 		-> acpi_bus_offline()
> > > 			-> device_offline()
> > > 				-> memory_subsys_offline()
> > > 	-> acpi_bus_trim()
> > > 		-> acpi_memory_device_remove()
> > >=20
> > >=20
> > > And memory_subsys_offline() can also be triggered via /sysfs:
> > >=20
> > > 	echo 0 > /sys/devices/system/memory/memory30/online
> > >=20
> > > After the memory block is offline, my understanding is kernel can the=
oretically
> > > move it to, i.e. ZONE_DEVICE via memremap_pages().
> > >=20
> > > As you can see memory_subsys_offline() is the entry point of memory d=
evice
> > > offline (before it the code is generic for all ACPI device), and it c=
annot
> > > distinguish whether the removal is from ACPI event, or from /sysfs, s=
o it seems
> > > we are unable to refuse to offline memory in  memory_subsys_offline()=
 when it is
> > > called from ACPI event.
> > >=20
> > > Any comments?
> >=20
> > I suggest refactoring the code in a way that makes it possible to
> > distinguish the two cases.
> >=20
> > It's not like you have some binary kernel.  You have the source code fo=
r
> > the whole thing and can propose changes *ANYWHERE* you need.  Even bett=
er:
> >=20
> > $ grep -A2 ^ACPI\$ MAINTAINERS
> > ACPI
> > M:	"Rafael J. Wysocki" <rafael@kernel.org>
> > R:	Len Brown <lenb@kernel.org>
> >=20
> > The maintainer of ACPI works for our employer.  Plus, he's a nice
> > helpful guy that you can go ask how you might refactor this or
> > approaches you might take.  Have you talked to Rafael about this issue?
>=20
> Rafael once also suggested to set hotplug.enabled to 0 as your code shows=
 below,
> but we just got the TDX architecture behaviour of memory hotplug clarifie=
d from
> Intel TDX guys recently.=20
>=20
> > Also, from a two-minute grepping session, I noticed this:
> >=20
> > > static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void=
 *data,
> > >                                     void **ret_p)
> > > {
> > ...
> > >         if (device->handler && !device->handler->hotplug.enabled) {
> > >                 *ret_p =3D &device->dev;
> > >                 return AE_SUPPORT;
> > >         }
> >=20
> > It looks to me like if you simply set:
> >=20
> > 	memory_device_handler->hotplug.enabled =3D false;
> >=20
> > you'll get most of the behavior you want.  ACPI memory hotplug would no=
t
> > work and the changes would be confined to the ACPI world.  The
> > "lower-level" bus-based hotplug would be unaffected.
> >=20
> > Now, I don't know what kind of locking would be needed to muck with a
> > global structure like that.  But, it's a start.
>=20
> This has two problems:
>=20
> 1) This approach cannot distinguish non-CMR memory hotplug and CMR memory
> hotplug, as it disables ACPI memory hotplug for all.  But this is fine as=
 we
> want to reject non-CMR memory hotplug anyway.  We just need to explain cl=
early
> in changelog.
>=20
> 2) This won't allow the kernel to speak out "BIOS  bug" when CMR memory h=
otplug
> actually happens.  Instead, we can only print out "hotplug is disabled du=
e to
> TDX is enabled by BIOS." when we set hotplug.enable to false.
>=20
> Assuming above is OK, I'll explore this option.  I'll also do some resear=
ch to
> see if it's still possible to speak out "BIOS bug" in this approach but i=
t's not
> a mandatory requirement to me now.
>=20
> Also, if print out "BIOS bug" for CMR memory hotplug isn't mandatory, the=
n we
> can just detect TDX during kernel boot, and disable hotplug when TDX is e=
nabled
> by BIOS, but don't need to use "winner-take-all" approach.  The former is
> clearer and easier to implement.  I'll go with the former approach if I d=
on't
> hear objection from you.
>=20
> And ACPI CPU hotplug can also use the same way.
>=20
> Please let me know any comments.  Thanks!
>=20

One more reason why "winner-take-all" approach doesn't work:=C2=A0

If we allow ACPI memory hotplug to happen but choose to disable it in the
handler using "winner-take-all", then at the beginning the ACPI code will
actually create a /sysfs entry for hotplug.enabled to allow userspace to ch=
ange
it:

	/sys/firmware/acpi/hotplug/memory/enabled

Which means even we set hotplug.enabled to false at some point, userspace c=
an
turn it on again.  The only way is to not create this /sysfs entry at the
beginning.

With "winner-take-all" approach, I don't think we should avoid creating the
/sysfs entry.  Nor we should introduce arch-specific hook to, i.e. prevent
/sysfs entry being changed by userspace.

So instead of "winner-take-all" approach, I'll introduce a new kernel comma=
nd
line to allow user to choose between ACPI CPU/memory hotplug vs TDX.  This
command line should not impact the "software" CPU/memory hotplug even when =
user
choose to use TDX.  In this case, this is similar to "winner-take-all" anyw=
ay.
