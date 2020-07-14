Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5556521FED2
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 22:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgGNUrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 16:47:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28890 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726442AbgGNUrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 16:47:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594759648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8umdrM37U6a6XZjrgtkvMu3RYrDH+UAXw+egZm/UTKQ=;
        b=g4CqDRB06M2Zz10eNNer555hKWXEr1/av+JCB3VBom9R54WJ/NIBC0IlfmYHwHAakN/jev
        GDJg2oeUO52VoZ5UKsMEbYkfuksgD6SHR0yI+KVNC3tCs3CSc8dZvf+IKwdDshAQAW0gGE
        YBKwRwKSstvPfZVFDhD03oMXx6aPFd0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-9NN1jPDHMCiBgYKFXjPtBA-1; Tue, 14 Jul 2020 16:47:27 -0400
X-MC-Unique: 9NN1jPDHMCiBgYKFXjPtBA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B6171080;
        Tue, 14 Jul 2020 20:47:24 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59FC31992D;
        Tue, 14 Jul 2020 20:47:16 +0000 (UTC)
Date:   Tue, 14 Jul 2020 14:47:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, devel@ovirt.org,
        openstack-discuss@lists.openstack.org, libvir-list@redhat.com,
        intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, smooney@redhat.com, eskultet@redhat.com,
        cohuck@redhat.com, dinechin@redhat.com, corbet@lwn.net,
        kwankhede@nvidia.com, dgilbert@redhat.com, eauger@redhat.com,
        jian-feng.ding@intel.com, hejie.xu@intel.com, kevin.tian@intel.com,
        zhenyuw@linux.intel.com, bao.yumeng@zte.com.cn,
        xin-ran.wang@intel.com, shaohe.feng@intel.com
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200714144715.0ef70074@x1.home>
In-Reply-To: <20200714164722.GL25187@redhat.com>
References: <20200713232957.GD5955@joy-OptiPlex-7040>
        <20200714102129.GD25187@redhat.com>
        <20200714101616.5d3a9e75@x1.home>
        <20200714164722.GL25187@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Jul 2020 17:47:22 +0100
Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:

> On Tue, Jul 14, 2020 at 10:16:16AM -0600, Alex Williamson wrote:
> > On Tue, 14 Jul 2020 11:21:29 +0100
> > Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:
> >  =20
> > > On Tue, Jul 14, 2020 at 07:29:57AM +0800, Yan Zhao wrote: =20
> > > >=20
> > > > The string read from migration_version attribute is defined by devi=
ce vendor
> > > > driver and is completely opaque to the userspace.
> > > > for a Intel vGPU, string format can be defined like
> > > > "parent device PCI ID" + "version of gvt driver" + "mdev type" + "a=
ggregator count".
> > > >=20
> > > > for an NVMe VF connecting to a remote storage. it could be
> > > > "PCI ID" + "driver version" + "configured remote storage URL"
> > > >=20
> > > > for a QAT VF, it may be
> > > > "PCI ID" + "driver version" + "supported encryption set".
> > > >=20
> > > > (to avoid namespace confliction from each vendor, we may prefix a d=
river name to
> > > > each migration_version string. e.g. i915-v1-8086-591d-i915-GVTg_V5_=
8-1) =20
> >=20
> > It's very strange to define it as opaque and then proceed to describe
> > the contents of that opaque string.  The point is that its contents
> > are defined by the vendor driver to describe the device, driver version,
> > and possibly metadata about the configuration of the device.  One
> > instance of a device might generate a different string from another.
> > The string that a device produces is not necessarily the only string
> > the vendor driver will accept, for example the driver might support
> > backwards compatible migrations. =20
>=20
>=20
> > > IMHO there needs to be a mechanism for the kernel to report via sysfs
> > > what versions are supported on a given device. This puts the job of
> > > reporting compatible versions directly under the responsibility of the
> > > vendor who writes the kernel driver for it. They are the ones with the
> > > best knowledge of the hardware they've built and the rules around its
> > > compatibility. =20
> >=20
> > The version string discussed previously is the version string that
> > represents a given device, possibly including driver information,
> > configuration, etc.  I think what you're asking for here is an
> > enumeration of every possible version string that a given device could
> > accept as an incoming migration stream.  If we consider the string as
> > opaque, that means the vendor driver needs to generate a separate
> > string for every possible version it could accept, for every possible
> > configuration option.  That potentially becomes an excessive amount of
> > data to either generate or manage.
> >=20
> > Am I overestimating how vendors intend to use the version string? =20
>=20
> If I'm interpreting your reply & the quoted text orrectly, the version
> string isn't really a version string in any normal sense of the word
> "version".
>=20
> Instead it sounds like string encoding a set of features in some arbitrary
> vendor specific format, which they parse and do compatibility checks on
> individual pieces ? One or more parts may contain a version number, but
> its much more than just a version.
>=20
> If that's correct, then I'd prefer we didn't call it a version string,
> instead call it a "capability string" to make it clear it is expressing
> a much more general concept, but...

I'd agree with that.  The intent of the previous proposal was to
provide and interface for reading a string and writing a string back in
where the result of that write indicated migration compatibility with
the device.  So yes, "version" is not the right term.
=20
> > We'd also need to consider devices that we could create, for instance
> > providing the same interface enumeration prior to creating an mdev
> > device to have a confidence level that the new device would be a valid
> > target.
> >=20
> > We defined the string as opaque to allow vendor flexibility and because
> > defining a common format is hard.  Do we need to revisit this part of
> > the discussion to define the version string as non-opaque with parsing
> > rules, probably with separate incoming vs outgoing interfaces?  Thanks,=
 =20
>=20
> ..even if the huge amount of flexibility is technically relevant from the
> POV of the hardware/drivers, we should consider whether management apps
> actually want, or can use, that level of flexibility.
>=20
> The task of picking which host to place a VM on has alot of factors to
> consider, and when there are a large number of hosts, the total amount
> of information to check gets correspondingly large.  The placement
> process is also fairly performance critical.
>=20
> Running complex algorithmic logic to check compatibility of devices
> based on a arbitrary set of rules is likely to be a performance
> challenge. A flat list of supported strings is a much simpler
> thing to check as it reduces down to a simple set membership test.
>=20
> IOW, even if there's some complex set of device type / vendor specific
> rules to check for compatibility, I fear apps will ignore them and
> just define a very simplified list of compatible string, and ignore
> all the extra flexibility.

There's always the "try it and see if it works" interface, which is
essentially what we have currently.  With even a simple version of what
we're trying to accomplish here, there's still a risk that a management
engine might rather just ignore it and restrict themselves to 1:1 mdev
type matches, with or without knowing anything about the vendor driver
version, relying on the migration to fail quickly if the devices are
incompatible.  If the complexity of the interface makes it too
complicated or time consuming to provide sufficient value above such an
algorithm, there's not much point to implementing it, which is why Yan
has included so many people in this discussion.

> I'm sure OpenStack maintainers can speak to this more, as they've put
> alot of work into their scheduling engine to optimize the way it places
> VMs largely driven from simple structured data reported from hosts.

I think we've weeded out that our intended approach is not worthwhile,
testing a compatibility string at a device is too much overhead, we
need to provide enough information to the management engine to predict
the response without interaction beyond the initial capability probing.

As you've identified above, we're really dealing with more than a
simple version, we need to construct a compatibility string and we need
to start defining what goes into that.

The first item seems to be that we're defining compatibility relative
to a vfio migration stream, vfio devices have a device API, such as
vfio-pci, so the first attribute might simply define the device API.
Once we have a class of devices we might then be able to use bus
specific attributes, for example the PCI vendor and device ID (other
bus types TBD).

We probably also need driver version numbers, so we need to include
both the driver name as well as version major and minor numbers.  Rules
need to be put in place around what we consider to be viable version
matches, potentially as Sean described.  For example, does the major
version require a match?  Do we restrict to only formward, ie.
increasing, minor number matches within that major verison?

Do we then also have section that includes any required device
attributes to result in a compatible device.  This would be largely
focused on mdev, but I wouldn't rule out others.  For example if an
aggregation parameter is required to maintain compatibility, we'd want
to specify that as a required attribute.

So maybe we end up with something like:

{
  "device_api": "vfio-pci",
  "vendor": "vendor-driver-name",
  "version": {
    "major": 0,
    "minor": 1
  },
  "vfio-pci": { // Based on above device_api
    "vendor": 0x1234, // Values for the exposed device
    "device": 0x5678,
      // Possibly further parameters for a more specific match
  }
  "mdev_attrs": [
    { "attribute0": "VALUE" }
  ]
}

The sysfs interface would return an array containing one or more of
these for each device supported.  I'm trying to account for things like
aggregation via the mdev_attrs section, but I haven't really put it all
together yet.  I think Intel folks want to be able to say mdev type
foo-3 is compatible with mdev type foo-1 so long as foo-1 is created
with an aggregation attribute value of 3, but I expect both foo-1 and
foo-3 would have the same user visible PCI vendor:device IDs  If we
use mdev type rather than the resulting device IDs, then we introduce
an barrier to phys<->mdev migration.  We could specify the subsystem
values though, for example foo-1 might correspond to subsystem IDs
8086:0001 and foo3 8086:0003, then we can specify that creating an
foo-1 from this device doesn't require any attributes, but creating a
foo-3 does.  I'm nervous how that scales though.

NB. I'm also considering how portions of this might be compatible with
mdevctl such that we could direct mdevctl to create a compatible device
using information from this compatibility interface.

Thanks,
Alex

