Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458DB589470
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 00:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236278AbiHCWf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 18:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiHCWf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 18:35:26 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6AF6548;
        Wed,  3 Aug 2022 15:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659566125; x=1691102125;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=8uQDDoTajgNNE0ToZaY3VXDgbd7kX/Xr+wrnhNi7pvE=;
  b=BXDxpJA5ZHmu+sj8z7WtQ57ZmXeqsN4p8ghcWs7GAzRfEt53AwiYQ6db
   aRsyqdzX5Rfbn5RzYYRS5tPPlXDqP26L6fy7cgM1JA9qLrgJCjVwTkbVI
   CukHpaR3xwf4dQLZcdQSC8lO3WNRBgyhQXReUwlZeZIo8dHGN/Gnv4zTy
   s9GRStDrp5A9WsJQgXTwkQ4UnLHT3/7BYTuY7W0xz1l/a1WbTenNeBoiK
   1y6UHCLwqksC7WbRvMKcgD5JoOTRZoDkvyamgiqJj7oYQK9/UITjLWY2o
   XjfDTj+25pyWnvoAnSAFV7HXNlOrvY4bUNnpdQuWWrcVEN5NGaDLIqGYx
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10428"; a="287353258"
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="287353258"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 15:35:25 -0700
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="662272541"
Received: from jangus-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.8.236])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 15:35:21 -0700
Message-ID: <28ece806443e4de04d7e587d7e678d58259f9c5b.camel@intel.com>
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
Date:   Thu, 04 Aug 2022 10:35:19 +1200
In-Reply-To: <54cf3e98-49d3-81f5-58e6-ca62671ab457@intel.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-03 at 07:20 -0700, Dave Hansen wrote:
> On 8/2/22 19:37, Kai Huang wrote:
> > On Thu, 2022-07-21 at 13:52 +1200, Kai Huang wrote:
> > > Also, if I understand correctly above, your suggestion is we want to =
prevent any
> > > CMR memory going offline so it won't be hot-removed (assuming we can =
get CMRs
> > > during boot).=C2=A0 This looks contradicts to the requirement of bein=
g able to allow
> > > moving memory from core-mm to driver.=C2=A0 When we offline the memor=
y, we cannot
> > > know whether the memory will be used by driver, or later hot-removed.
> > Hi Dave,
> >=20
> > The high level flow of device hot-removal is:
> >=20
> > acpi_scan_hot_remove()
> > 	-> acpi_scan_try_to_offline()
> > 		-> acpi_bus_offline()
> > 			-> device_offline()
> > 				-> memory_subsys_offline()
> > 	-> acpi_bus_trim()
> > 		-> acpi_memory_device_remove()
> >=20
> >=20
> > And memory_subsys_offline() can also be triggered via /sysfs:
> >=20
> > 	echo 0 > /sys/devices/system/memory/memory30/online
> >=20
> > After the memory block is offline, my understanding is kernel can theor=
etically
> > move it to, i.e. ZONE_DEVICE via memremap_pages().
> >=20
> > As you can see memory_subsys_offline() is the entry point of memory dev=
ice
> > offline (before it the code is generic for all ACPI device), and it can=
not
> > distinguish whether the removal is from ACPI event, or from /sysfs, so =
it seems
> > we are unable to refuse to offline memory in  memory_subsys_offline() w=
hen it is
> > called from ACPI event.
> >=20
> > Any comments?
>=20
> I suggest refactoring the code in a way that makes it possible to
> distinguish the two cases.
>=20
> It's not like you have some binary kernel.  You have the source code for
> the whole thing and can propose changes *ANYWHERE* you need.  Even better=
:
>=20
> $ grep -A2 ^ACPI\$ MAINTAINERS
> ACPI
> M:	"Rafael J. Wysocki" <rafael@kernel.org>
> R:	Len Brown <lenb@kernel.org>
>=20
> The maintainer of ACPI works for our employer.  Plus, he's a nice
> helpful guy that you can go ask how you might refactor this or
> approaches you might take.  Have you talked to Rafael about this issue?

Rafael once also suggested to set hotplug.enabled to 0 as your code shows b=
elow,
but we just got the TDX architecture behaviour of memory hotplug clarified =
from
Intel TDX guys recently.=20

> Also, from a two-minute grepping session, I noticed this:
>=20
> > static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *=
data,
> >                                     void **ret_p)
> > {
> ...
> >         if (device->handler && !device->handler->hotplug.enabled) {
> >                 *ret_p =3D &device->dev;
> >                 return AE_SUPPORT;
> >         }
>=20
> It looks to me like if you simply set:
>=20
> 	memory_device_handler->hotplug.enabled =3D false;
>=20
> you'll get most of the behavior you want.  ACPI memory hotplug would not
> work and the changes would be confined to the ACPI world.  The
> "lower-level" bus-based hotplug would be unaffected.
>=20
> Now, I don't know what kind of locking would be needed to muck with a
> global structure like that.  But, it's a start.

This has two problems:

1) This approach cannot distinguish non-CMR memory hotplug and CMR memory
hotplug, as it disables ACPI memory hotplug for all.  But this is fine as w=
e
want to reject non-CMR memory hotplug anyway.  We just need to explain clea=
rly
in changelog.

2) This won't allow the kernel to speak out "BIOS  bug" when CMR memory hot=
plug
actually happens.  Instead, we can only print out "hotplug is disabled due =
to
TDX is enabled by BIOS." when we set hotplug.enable to false.

Assuming above is OK, I'll explore this option.  I'll also do some research=
 to
see if it's still possible to speak out "BIOS bug" in this approach but it'=
s not
a mandatory requirement to me now.

Also, if print out "BIOS bug" for CMR memory hotplug isn't mandatory, then =
we
can just detect TDX during kernel boot, and disable hotplug when TDX is ena=
bled
by BIOS, but don't need to use "winner-take-all" approach.  The former is
clearer and easier to implement.  I'll go with the former approach if I don=
't
hear objection from you.

And ACPI CPU hotplug can also use the same way.

Please let me know any comments.  Thanks!

--=20
Thanks,
-Kai


