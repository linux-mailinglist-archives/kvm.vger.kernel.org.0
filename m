Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74612F0DB3
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 05:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfKFEUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 23:20:51 -0500
Received: from mga07.intel.com ([134.134.136.100]:10800 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbfKFEUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 23:20:51 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 20:20:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,272,1569308400"; 
   d="asc'?scan'208";a="205206893"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.13.116])
  by orsmga003.jf.intel.com with ESMTP; 05 Nov 2019 20:20:48 -0800
Date:   Wed, 6 Nov 2019 12:20:31 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Zhenyu Wang <zhenyuw@linux.intel.com>, kvm@vger.kernel.org,
        kwankhede@nvidia.com, kevin.tian@intel.com, cohuck@redhat.com,
        Libvirt Devel <libvir-list@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        Jonathon Jongsma <jjongsma@redhat.com>
Subject: Re: [PATCH 0/6] VFIO mdev aggregated resources handling
Message-ID: <20191106042031.GJ1769@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
 <20191105141042.17dd2d7d@x1.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dWJ7k1c3mh7Yseyi"
Content-Disposition: inline
In-Reply-To: <20191105141042.17dd2d7d@x1.home>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--dWJ7k1c3mh7Yseyi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019.11.05 14:10:42 -0700, Alex Williamson wrote:
> On Thu, 24 Oct 2019 13:08:23 +0800
> Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
>=20
> > Hi,
> >=20
> > This is a refresh for previous send of this series. I got impression th=
at
> > some SIOV drivers would still deploy their own create and config method=
 so
> > stopped effort on this. But seems this would still be useful for some o=
ther
> > SIOV driver which may simply want capability to aggregate resources. So=
 here's
> > refreshed series.
> >=20
> > Current mdev device create interface depends on fixed mdev type, which =
get uuid
> > from user to create instance of mdev device. If user wants to use custo=
mized
> > number of resource for mdev device, then only can create new mdev type =
for that
> > which may not be flexible. This requirement comes not only from to be a=
ble to
> > allocate flexible resources for KVMGT, but also from Intel scalable IO
> > virtualization which would use vfio/mdev to be able to allocate arbitra=
ry
> > resources on mdev instance. More info on [1] [2] [3].
> >=20
> > To allow to create user defined resources for mdev, it trys to extend m=
dev
> > create interface by adding new "aggregate=3Dxxx" parameter following UU=
ID, for
> > target mdev type if aggregation is supported, it can create new mdev de=
vice
> > which contains resources combined by number of instances, e.g
> >=20
> >     echo "<uuid>,aggregate=3D10" > create
> >=20
> > VM manager e.g libvirt can check mdev type with "aggregation" attribute=
 which
> > can support this setting. If no "aggregation" attribute found for mdev =
type,
> > previous behavior is still kept for one instance allocation. And new sy=
sfs
> > attribute "aggregated_instances" is created for each mdev device to sho=
w allocated number.
>=20
> Given discussions we've had recently around libvirt interacting with
> mdev, I think that libvirt would rather have an abstract interface via
> mdevctl[1].  Therefore can you evaluate how mdevctl would support this
> creation extension?  It seems like it would fit within the existing
> mdev and mdevctl framework if aggregation were simply a sysfs attribute
> for the device.  For example, the mdevctl steps might look like this:
>=20
> mdevctl define -u UUID -p PARENT -t TYPE
> mdevctl modify -u UUID --addattr=3Dmdev/aggregation --value=3D2
> mdevctl start -u UUID
>=20
> When mdevctl starts the mdev, it will first create it using the
> existing mechanism, then apply aggregation attribute, which can consume
> the necessary additional instances from the parent device, or return an
> error, which would unwind and return a failure code to the caller
> (libvirt).  I think the vendor driver would then have freedom to decide
> when the attribute could be modified, for instance it would be entirely
> reasonable to return -EBUSY if the user attempts to modify the
> attribute while the mdev device is in-use.  Effectively aggregation
> simply becomes a standardized attribute with common meaning.  Thoughts?
> [cc libvirt folks for their impression] Thanks,

I think one problem is that before mdevctl start to create mdev you
don't know what vendor attributes are, as we apply mdev attributes
after create. You may need some lookup depending on parent.. I think
making aggregation like other vendor attribute for mdev might be the
simplest way, but do we want to define its behavior in formal? e.g
like previous discussed it should show maxium instances for aggregation, et=
c.

The behavior change for driver is that previously aggregation is
handled at create time, but for sysfs attr it should handle any
resource allocation before it's really in-use. I think some SIOV
driver which already requires some specific config should be ok,
but not sure for other driver which might not be explored in this before.
Would that be a problem? Kevin?

Thanks

>=20
> Alex
>=20
> [1] https://github.com/mdevctl/mdevctl
>=20
> > References:
> > [1] https://software.intel.com/en-us/download/intel-virtualization-tech=
nology-for-directed-io-architecture-specification
> > [2] https://software.intel.com/en-us/download/intel-scalable-io-virtual=
ization-technical-specification
> > [3] https://schd.ws/hosted_files/lc32018/00/LC3-SIOV-final.pdf
> >=20
> > Zhenyu Wang (6):
> >   vfio/mdev: Add new "aggregate" parameter for mdev create
> >   vfio/mdev: Add "aggregation" attribute for supported mdev type
> >   vfio/mdev: Add "aggregated_instances" attribute for supported mdev
> >     device
> >   Documentation/driver-api/vfio-mediated-device.rst: Update for
> >     vfio/mdev aggregation support
> >   Documentation/ABI/testing/sysfs-bus-vfio-mdev: Update for vfio/mdev
> >     aggregation support
> >   drm/i915/gvt: Add new type with aggregation support
> >=20
> >  Documentation/ABI/testing/sysfs-bus-vfio-mdev | 24 ++++++
> >  .../driver-api/vfio-mediated-device.rst       | 23 ++++++
> >  drivers/gpu/drm/i915/gvt/gvt.c                |  4 +-
> >  drivers/gpu/drm/i915/gvt/gvt.h                | 11 ++-
> >  drivers/gpu/drm/i915/gvt/kvmgt.c              | 53 ++++++++++++-
> >  drivers/gpu/drm/i915/gvt/vgpu.c               | 56 ++++++++++++-
> >  drivers/vfio/mdev/mdev_core.c                 | 36 ++++++++-
> >  drivers/vfio/mdev/mdev_private.h              |  6 +-
> >  drivers/vfio/mdev/mdev_sysfs.c                | 79 ++++++++++++++++++-
> >  include/linux/mdev.h                          | 19 +++++
> >  10 files changed, 294 insertions(+), 17 deletions(-)
> >=20
>=20

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--dWJ7k1c3mh7Yseyi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXcJKDwAKCRCxBBozTXgY
J1CdAKCO1WyGM9C6s6VOHIxnQiieIzDJ3QCfQtozNpS6OvS1MGtV9LElKcUeSyo=
=mcEH
-----END PGP SIGNATURE-----

--dWJ7k1c3mh7Yseyi--
