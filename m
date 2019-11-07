Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC20F2EC4
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 14:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388575AbfKGNDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 08:03:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47639 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726810AbfKGNDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 08:03:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573131783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NYV/HqW11IchAkKbU99u3QT421+tCm1HBtHrVYYJgHY=;
        b=Gnp1hTswh1qrO5DINb95w+TRTAIQMLkqQG8yK2d4Y5uJWikIZj7Kysf53bFIbJugLRAI32
        qyjjrQrTdxKruyGRAgivIq0a5BomVzaZv0N68GqspktKNsZvw/nvr/MmeJdCIBJT6TATpG
        BJKWlMducg55Ojeg0/vnVesdkhwf5u8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-Fb3yS6m8MjuylUfXgr3R0Q-1; Thu, 07 Nov 2019 08:03:01 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76E1F800C61;
        Thu,  7 Nov 2019 13:03:00 +0000 (UTC)
Received: from gondolin (ovpn-117-222.ams2.redhat.com [10.36.117.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C9BF61074;
        Thu,  7 Nov 2019 13:02:58 +0000 (UTC)
Date:   Thu, 7 Nov 2019 14:02:55 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, kvm@vger.kernel.org,
        kwankhede@nvidia.com, Libvirt Devel <libvir-list@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        Jonathon Jongsma <jjongsma@redhat.com>
Subject: Re: [PATCH 0/6] VFIO mdev aggregated resources handling
Message-ID: <20191107140255.7dbca025.cohuck@redhat.com>
In-Reply-To: <20191106114440.7314713e@x1.home>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
        <20191105141042.17dd2d7d@x1.home>
        <20191106042031.GJ1769@zhen-hp.sh.intel.com>
        <20191106114440.7314713e@x1.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: Fb3yS6m8MjuylUfXgr3R0Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Nov 2019 11:44:40 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Wed, 6 Nov 2019 12:20:31 +0800
> Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
>=20
> > On 2019.11.05 14:10:42 -0700, Alex Williamson wrote: =20
> > > On Thu, 24 Oct 2019 13:08:23 +0800
> > > Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
> > >    =20
> > > > Hi,
> > > >=20
> > > > This is a refresh for previous send of this series. I got impressio=
n that
> > > > some SIOV drivers would still deploy their own create and config me=
thod so
> > > > stopped effort on this. But seems this would still be useful for so=
me other
> > > > SIOV driver which may simply want capability to aggregate resources=
. So here's
> > > > refreshed series.
> > > >=20
> > > > Current mdev device create interface depends on fixed mdev type, wh=
ich get uuid
> > > > from user to create instance of mdev device. If user wants to use c=
ustomized
> > > > number of resource for mdev device, then only can create new mdev t=
ype for that
> > > > which may not be flexible. This requirement comes not only from to =
be able to
> > > > allocate flexible resources for KVMGT, but also from Intel scalable=
 IO
> > > > virtualization which would use vfio/mdev to be able to allocate arb=
itrary
> > > > resources on mdev instance. More info on [1] [2] [3].
> > > >=20
> > > > To allow to create user defined resources for mdev, it trys to exte=
nd mdev
> > > > create interface by adding new "aggregate=3Dxxx" parameter followin=
g UUID, for
> > > > target mdev type if aggregation is supported, it can create new mde=
v device
> > > > which contains resources combined by number of instances, e.g
> > > >=20
> > > >     echo "<uuid>,aggregate=3D10" > create
> > > >=20
> > > > VM manager e.g libvirt can check mdev type with "aggregation" attri=
bute which
> > > > can support this setting. If no "aggregation" attribute found for m=
dev type,
> > > > previous behavior is still kept for one instance allocation. And ne=
w sysfs
> > > > attribute "aggregated_instances" is created for each mdev device to=
 show allocated number.   =20
> > >=20
> > > Given discussions we've had recently around libvirt interacting with
> > > mdev, I think that libvirt would rather have an abstract interface vi=
a
> > > mdevctl[1].  Therefore can you evaluate how mdevctl would support thi=
s
> > > creation extension?  It seems like it would fit within the existing
> > > mdev and mdevctl framework if aggregation were simply a sysfs attribu=
te
> > > for the device.  For example, the mdevctl steps might look like this:
> > >=20
> > > mdevctl define -u UUID -p PARENT -t TYPE
> > > mdevctl modify -u UUID --addattr=3Dmdev/aggregation --value=3D2
> > > mdevctl start -u UUID
> > >=20
> > > When mdevctl starts the mdev, it will first create it using the
> > > existing mechanism, then apply aggregation attribute, which can consu=
me
> > > the necessary additional instances from the parent device, or return =
an
> > > error, which would unwind and return a failure code to the caller
> > > (libvirt).  I think the vendor driver would then have freedom to deci=
de
> > > when the attribute could be modified, for instance it would be entire=
ly
> > > reasonable to return -EBUSY if the user attempts to modify the
> > > attribute while the mdev device is in-use.  Effectively aggregation
> > > simply becomes a standardized attribute with common meaning.  Thought=
s?
> > > [cc libvirt folks for their impression] Thanks,   =20
> >=20
> > I think one problem is that before mdevctl start to create mdev you
> > don't know what vendor attributes are, as we apply mdev attributes
> > after create. You may need some lookup depending on parent.. I think
> > making aggregation like other vendor attribute for mdev might be the
> > simplest way, but do we want to define its behavior in formal? e.g
> > like previous discussed it should show maxium instances for aggregation=
, etc. =20
>=20
> Yes, we'd still want to standardize how we enable and discover
> aggregation since we expect multiple users.  Even if libvirt were to
> use mdevctl as it's mdev interface, higher level tools should have an
> introspection mechanism available.  Possibly the sysfs interfaces
> proposed in this series remains largely the same, but I think perhaps
> the implementation of them moves out to the vendor driver.  In fact,
> perhaps the only change to mdev core is to define the standard.  For
> example, the "aggregation" attribute on the type is potentially simply
> a defined, optional, per type attribute, similar to "name" and
> "description".  For "aggregated_instances" we already have the
> mdev_attr_groups of the mdev_parent_ops, we could define an
> attribute_group with .name =3D "mdev" as a set of standardized
> attributes, such that vendors could provide both their own vendor
> specific attributes and per device attributes with a common meaning and
> semantic defined in the mdev ABI.

+1 to standardizing this. While not every vendor driver will support
aggregation, providing a common infrastructure to ensure those that do
use the same approach is a good idea.

>=20
> > The behavior change for driver is that previously aggregation is
> > handled at create time, but for sysfs attr it should handle any
> > resource allocation before it's really in-use. I think some SIOV
> > driver which already requires some specific config should be ok,
> > but not sure for other driver which might not be explored in this befor=
e.
> > Would that be a problem? Kevin? =20
>=20
> Right, I'm assuming the aggregation could be modified until the device
> is actually opened, the driver can nak the aggregation request by
> returning an errno to the attribute write.  I'm trying to anticipate
> whether this introduces new complications, for instances races with
> contiguous allocations.  I think these seem solvable within the vendor
> drivers, but please note it if I'm wrong.  Thanks,
>=20
> Alex

FWIW, the ap driver does this post-creation configuration stuff
already. The intended workflow is create->add adapters/domains->start
vm with assigned device. Do we want to do some standardization as to
how post-creation configuration is supposed to work (like, at which
point in time is it fine to manipulate the attribute)? I'm not sure how
much of this is vendor-driver specific.

