Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2387F1DB9
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 19:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfKFSov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 13:44:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37621 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726713AbfKFSov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 13:44:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573065889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tk8NP5oJkP1ayojcAeI2fzJUo6qXcKjAW36aDbrwl8k=;
        b=grel1btJ+tx/gUcGbPJcFH+4i98e4IPerzTg4tmTg4VjAN4rEy5bujnCJUTjYxFlO+tKmV
        BlKWesyH4AyyL3HqykFNZ9jrgA9XkipQoiQX82KUBM/2Lix8wV7iGBkcrKBsjvIrqQZVm3
        k2n/QP7YeUh8s35IUz+1Z98XOzxuTQw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-jF4Qn4fvPlOh-RZM8mG0Uw-1; Wed, 06 Nov 2019 13:44:46 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 029818017E0;
        Wed,  6 Nov 2019 18:44:45 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB0475C3FA;
        Wed,  6 Nov 2019 18:44:40 +0000 (UTC)
Date:   Wed, 6 Nov 2019 11:44:40 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>, kvm@vger.kernel.org,
        kwankhede@nvidia.com, cohuck@redhat.com,
        Libvirt Devel <libvir-list@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        Jonathon Jongsma <jjongsma@redhat.com>
Subject: Re: [PATCH 0/6] VFIO mdev aggregated resources handling
Message-ID: <20191106114440.7314713e@x1.home>
In-Reply-To: <20191106042031.GJ1769@zhen-hp.sh.intel.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
        <20191105141042.17dd2d7d@x1.home>
        <20191106042031.GJ1769@zhen-hp.sh.intel.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: jF4Qn4fvPlOh-RZM8mG0Uw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Nov 2019 12:20:31 +0800
Zhenyu Wang <zhenyuw@linux.intel.com> wrote:

> On 2019.11.05 14:10:42 -0700, Alex Williamson wrote:
> > On Thu, 24 Oct 2019 13:08:23 +0800
> > Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
> >  =20
> > > Hi,
> > >=20
> > > This is a refresh for previous send of this series. I got impression =
that
> > > some SIOV drivers would still deploy their own create and config meth=
od so
> > > stopped effort on this. But seems this would still be useful for some=
 other
> > > SIOV driver which may simply want capability to aggregate resources. =
So here's
> > > refreshed series.
> > >=20
> > > Current mdev device create interface depends on fixed mdev type, whic=
h get uuid
> > > from user to create instance of mdev device. If user wants to use cus=
tomized
> > > number of resource for mdev device, then only can create new mdev typ=
e for that
> > > which may not be flexible. This requirement comes not only from to be=
 able to
> > > allocate flexible resources for KVMGT, but also from Intel scalable I=
O
> > > virtualization which would use vfio/mdev to be able to allocate arbit=
rary
> > > resources on mdev instance. More info on [1] [2] [3].
> > >=20
> > > To allow to create user defined resources for mdev, it trys to extend=
 mdev
> > > create interface by adding new "aggregate=3Dxxx" parameter following =
UUID, for
> > > target mdev type if aggregation is supported, it can create new mdev =
device
> > > which contains resources combined by number of instances, e.g
> > >=20
> > >     echo "<uuid>,aggregate=3D10" > create
> > >=20
> > > VM manager e.g libvirt can check mdev type with "aggregation" attribu=
te which
> > > can support this setting. If no "aggregation" attribute found for mde=
v type,
> > > previous behavior is still kept for one instance allocation. And new =
sysfs
> > > attribute "aggregated_instances" is created for each mdev device to s=
how allocated number. =20
> >=20
> > Given discussions we've had recently around libvirt interacting with
> > mdev, I think that libvirt would rather have an abstract interface via
> > mdevctl[1].  Therefore can you evaluate how mdevctl would support this
> > creation extension?  It seems like it would fit within the existing
> > mdev and mdevctl framework if aggregation were simply a sysfs attribute
> > for the device.  For example, the mdevctl steps might look like this:
> >=20
> > mdevctl define -u UUID -p PARENT -t TYPE
> > mdevctl modify -u UUID --addattr=3Dmdev/aggregation --value=3D2
> > mdevctl start -u UUID
> >=20
> > When mdevctl starts the mdev, it will first create it using the
> > existing mechanism, then apply aggregation attribute, which can consume
> > the necessary additional instances from the parent device, or return an
> > error, which would unwind and return a failure code to the caller
> > (libvirt).  I think the vendor driver would then have freedom to decide
> > when the attribute could be modified, for instance it would be entirely
> > reasonable to return -EBUSY if the user attempts to modify the
> > attribute while the mdev device is in-use.  Effectively aggregation
> > simply becomes a standardized attribute with common meaning.  Thoughts?
> > [cc libvirt folks for their impression] Thanks, =20
>=20
> I think one problem is that before mdevctl start to create mdev you
> don't know what vendor attributes are, as we apply mdev attributes
> after create. You may need some lookup depending on parent.. I think
> making aggregation like other vendor attribute for mdev might be the
> simplest way, but do we want to define its behavior in formal? e.g
> like previous discussed it should show maxium instances for aggregation, =
etc.

Yes, we'd still want to standardize how we enable and discover
aggregation since we expect multiple users.  Even if libvirt were to
use mdevctl as it's mdev interface, higher level tools should have an
introspection mechanism available.  Possibly the sysfs interfaces
proposed in this series remains largely the same, but I think perhaps
the implementation of them moves out to the vendor driver.  In fact,
perhaps the only change to mdev core is to define the standard.  For
example, the "aggregation" attribute on the type is potentially simply
a defined, optional, per type attribute, similar to "name" and
"description".  For "aggregated_instances" we already have the
mdev_attr_groups of the mdev_parent_ops, we could define an
attribute_group with .name =3D "mdev" as a set of standardized
attributes, such that vendors could provide both their own vendor
specific attributes and per device attributes with a common meaning and
semantic defined in the mdev ABI.

> The behavior change for driver is that previously aggregation is
> handled at create time, but for sysfs attr it should handle any
> resource allocation before it's really in-use. I think some SIOV
> driver which already requires some specific config should be ok,
> but not sure for other driver which might not be explored in this before.
> Would that be a problem? Kevin?

Right, I'm assuming the aggregation could be modified until the device
is actually opened, the driver can nak the aggregation request by
returning an errno to the attribute write.  I'm trying to anticipate
whether this introduces new complications, for instances races with
contiguous allocations.  I think these seem solvable within the vendor
drivers, but please note it if I'm wrong.  Thanks,

Alex

