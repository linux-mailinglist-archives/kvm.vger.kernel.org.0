Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7D27102F9F
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 23:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfKSW6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 17:58:35 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21989 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725978AbfKSW6f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Nov 2019 17:58:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574204314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vl6X1YTc3uGa+6vhgEn2fmyihLBiyuNyfs/ChQQ1ePU=;
        b=inppgh9jP+UYtrndHpmO7U4ayRkuks0IpLTh/a8EXEpZrpnjCAEbT5zpEFJ2CI9kf64mcC
        QU/YLVwBpliTVJ0FKF+KGEWlO+0one8QGSDXMD9O/YS6AEg7yQ//26iBIwuJgNJ4P83dFy
        7n0SdSuGVKfdJmy14XZii8ZCvfAOwwo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-6Q5e-2QMPBm1lcfDB4ZfuA-1; Tue, 19 Nov 2019 17:58:31 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E579477;
        Tue, 19 Nov 2019 22:58:30 +0000 (UTC)
Received: from x1.home (ovpn-116-56.phx2.redhat.com [10.3.116.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E647C5E258;
        Tue, 19 Nov 2019 22:58:26 +0000 (UTC)
Date:   Tue, 19 Nov 2019 15:58:26 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Libvirt Devel" <libvir-list@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        Jonathon Jongsma <jjongsma@redhat.com>
Subject: Re: [PATCH 0/6] VFIO mdev aggregated resources handling
Message-ID: <20191119155826.64558003@x1.home>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D5F69A5@SHSMSX104.ccr.corp.intel.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
        <20191105141042.17dd2d7d@x1.home>
        <20191106042031.GJ1769@zhen-hp.sh.intel.com>
        <20191106114440.7314713e@x1.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D5F69A5@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 6Q5e-2QMPBm1lcfDB4ZfuA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Nov 2019 04:24:35 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson
> > Sent: Thursday, November 7, 2019 2:45 AM
> >=20
> > On Wed, 6 Nov 2019 12:20:31 +0800
> > Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
> >  =20
> > > On 2019.11.05 14:10:42 -0700, Alex Williamson wrote: =20
> > > > On Thu, 24 Oct 2019 13:08:23 +0800
> > > > Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
> > > > =20
> > > > > Hi,
> > > > >
> > > > > This is a refresh for previous send of this series. I got impress=
ion that
> > > > > some SIOV drivers would still deploy their own create and config =
=20
> > method so =20
> > > > > stopped effort on this. But seems this would still be useful for =
some =20
> > other =20
> > > > > SIOV driver which may simply want capability to aggregate resourc=
es. =20
> > So here's =20
> > > > > refreshed series.
> > > > >
> > > > > Current mdev device create interface depends on fixed mdev type, =
=20
> > which get uuid =20
> > > > > from user to create instance of mdev device. If user wants to use=
 =20
> > customized =20
> > > > > number of resource for mdev device, then only can create new mdev=
 =20
> > type for that =20
> > > > > which may not be flexible. This requirement comes not only from t=
o =20
> > be able to =20
> > > > > allocate flexible resources for KVMGT, but also from Intel scalab=
le IO
> > > > > virtualization which would use vfio/mdev to be able to allocate =
=20
> > arbitrary =20
> > > > > resources on mdev instance. More info on [1] [2] [3].
> > > > >
> > > > > To allow to create user defined resources for mdev, it trys to ex=
tend =20
> > mdev =20
> > > > > create interface by adding new "aggregate=3Dxxx" parameter follow=
ing =20
> > UUID, for =20
> > > > > target mdev type if aggregation is supported, it can create new m=
dev =20
> > device =20
> > > > > which contains resources combined by number of instances, e.g
> > > > >
> > > > >     echo "<uuid>,aggregate=3D10" > create
> > > > >
> > > > > VM manager e.g libvirt can check mdev type with "aggregation" =20
> > attribute which =20
> > > > > can support this setting. If no "aggregation" attribute found for=
 mdev =20
> > type, =20
> > > > > previous behavior is still kept for one instance allocation. And =
new =20
> > sysfs =20
> > > > > attribute "aggregated_instances" is created for each mdev device =
to =20
> > show allocated number. =20
> > > >
> > > > Given discussions we've had recently around libvirt interacting wit=
h
> > > > mdev, I think that libvirt would rather have an abstract interface =
via
> > > > mdevctl[1].  Therefore can you evaluate how mdevctl would support =
=20
> > this =20
> > > > creation extension?  It seems like it would fit within the existing
> > > > mdev and mdevctl framework if aggregation were simply a sysfs =20
> > attribute =20
> > > > for the device.  For example, the mdevctl steps might look like thi=
s:
> > > >
> > > > mdevctl define -u UUID -p PARENT -t TYPE
> > > > mdevctl modify -u UUID --addattr=3Dmdev/aggregation --value=3D2
> > > > mdevctl start -u UUID =20
>=20
> Hi, Alex, can you elaborate why a sysfs attribute is more friendly
> to mdevctl? what is the complexity if having mdevctl to pass
> additional parameter at creation time as this series originally=20
> proposed? Just want to clearly understand the limitation of the
> parameter way. :-)

We could also flip this question around, vfio-ap already uses sysfs to
finish composing a device after it's created, therefore why shouldn't
aggregation use this existing mechanism.  Extending the creation
interface is a more fundamental change than simply standardizing an
optional sysfs namespace entry.

> > > >
> > > > When mdevctl starts the mdev, it will first create it using the
> > > > existing mechanism, then apply aggregation attribute, which can =20
> > consume =20
> > > > the necessary additional instances from the parent device, or retur=
n an
> > > > error, which would unwind and return a failure code to the caller
> > > > (libvirt).  I think the vendor driver would then have freedom to de=
cide
> > > > when the attribute could be modified, for instance it would be enti=
rely
> > > > reasonable to return -EBUSY if the user attempts to modify the
> > > > attribute while the mdev device is in-use.  Effectively aggregation
> > > > simply becomes a standardized attribute with common meaning. =20
> > Thoughts? =20
> > > > [cc libvirt folks for their impression] Thanks, =20
> > >
> > > I think one problem is that before mdevctl start to create mdev you
> > > don't know what vendor attributes are, as we apply mdev attributes
> > > after create. You may need some lookup depending on parent.. I think
> > > making aggregation like other vendor attribute for mdev might be the
> > > simplest way, but do we want to define its behavior in formal? e.g
> > > like previous discussed it should show maxium instances for aggregati=
on, =20
> > etc.
> >=20
> > Yes, we'd still want to standardize how we enable and discover
> > aggregation since we expect multiple users.  Even if libvirt were to
> > use mdevctl as it's mdev interface, higher level tools should have an
> > introspection mechanism available.  Possibly the sysfs interfaces
> > proposed in this series remains largely the same, but I think perhaps
> > the implementation of them moves out to the vendor driver.  In fact,
> > perhaps the only change to mdev core is to define the standard.  For
> > example, the "aggregation" attribute on the type is potentially simply
> > a defined, optional, per type attribute, similar to "name" and
> > "description".  For "aggregated_instances" we already have the
> > mdev_attr_groups of the mdev_parent_ops, we could define an
> > attribute_group with .name =3D "mdev" as a set of standardized
> > attributes, such that vendors could provide both their own vendor
> > specific attributes and per device attributes with a common meaning and
> > semantic defined in the mdev ABI. =20
>=20
> such standardization sounds good.
>=20
> >  =20
> > > The behavior change for driver is that previously aggregation is
> > > handled at create time, but for sysfs attr it should handle any
> > > resource allocation before it's really in-use. I think some SIOV
> > > driver which already requires some specific config should be ok,
> > > but not sure for other driver which might not be explored in this bef=
ore.
> > > Would that be a problem? Kevin? =20
> >=20
> > Right, I'm assuming the aggregation could be modified until the device
> > is actually opened, the driver can nak the aggregation request by
> > returning an errno to the attribute write.  I'm trying to anticipate
> > whether this introduces new complications, for instances races with
> > contiguous allocations.  I think these seem solvable within the vendor
> > drivers, but please note it if I'm wrong.  Thanks,
> >  =20
>=20
> So far I didn't see a problem with this way. Regarding to contiguous
> allocations, ideally it should be fine as long as aggregation paths are
> properly locked similar  as creation paths when allocating resources.
> It will introduce some additional work in vendor driver but such
> overhead is worthy if it leads to cleaner uapi.
>=20
> There is one open though. In concept the aggregation feature can
> be used for both increasing and decreasing the resource when=20
> exposing as a sysfs attribute, any time when the device is not in-use.=20
> Increasing resource is possibly fine, but I'm not sure about decreasing
> resource. Is there any vendor driver which cannot afford resource
> decrease once it has ever been used (after deassignment), or require
> at least an explicit reset before decrease? If yes, how do we report
> such special requirement (only-once, multiple-times, multiple-times-
> before-1st-usage) to user space?

It seems like a sloppy vendor driver that couldn't return a device to a
post-creation state, ie. drop and re-initialize the aggregation state.
Userspace would always need to handle an aggregation failure, there
might be multiple processes attempting to allocate resources
simultaneously or the user might simply be requesting more resources
than available.  The vendor driver should make a reasonable attempt to
satisfy the user request or else an insufficient resource error may
appear at the application.  vfio-mdev devices should always be reset
before and after usage.
=20
> It's sort of like what Cornelia commented about standardization
> of post-creation resource configuration. If it may end up to be
> a complex story (or at least take time to understand/standardize
> all kinds of requirements), does it still make sense to support
> creation-time parameter as a quick-path for this aggregation feature? :-)

We're not going to do both, right?  We likely lock ourselves into one
schema when we do it.  Not only is the sysfs approach already in use in
vfio-ap, but it seems more flexible.  Above you raise the issue of
dynamically resizing the aggregation between uses.  We can't do that
with only a creation-time parameter.  With a sysfs parameter the vendor
driver can nak changes, allow changes when idle, potentially even allow
changes while in use.  Connie essentially brings up the question of how
we can introspect sysfs attribute, which is a big question.  Perhaps we
can nibble off a piece of that question by starting with a namespace
per attribute.  For instance, rather than doing:

echo 2 > /sys/bus/mdev/devices/UUID/mdev/aggregation

We could do:

echo 2 > /sys/bus/mdev/devices/UUID/mdev/aggregation/value

This allows us the whole mdev/aggregation/* namespace to describe other
attributes to expose aspects of the aggregation support.  Thanks,

Alex

