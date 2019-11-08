Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF82F41FF
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 09:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbfKHITt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 03:19:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:56314 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbfKHITt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 03:19:49 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 00:19:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,280,1569308400"; 
   d="asc'?scan'208";a="193098351"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.13.116])
  by orsmga007.jf.intel.com with ESMTP; 08 Nov 2019 00:19:46 -0800
Date:   Fri, 8 Nov 2019 16:19:25 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: Re: [PATCH 0/6] VFIO mdev aggregated resources handling
Message-ID: <20191108081925.GH4196@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
 <AM0PR05MB4866CA9B70A8BEC1868AF8C8D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OFj+1YLvsEfSXdCH"
Content-Disposition: inline
In-Reply-To: <AM0PR05MB4866CA9B70A8BEC1868AF8C8D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--OFj+1YLvsEfSXdCH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019.11.07 20:37:49 +0000, Parav Pandit wrote:
> Hi,
>=20
> > -----Original Message-----
> > From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf
> > Of Zhenyu Wang
> > Sent: Thursday, October 24, 2019 12:08 AM
> > To: kvm@vger.kernel.org
> > Cc: alex.williamson@redhat.com; kwankhede@nvidia.com;
> > kevin.tian@intel.com; cohuck@redhat.com
> > Subject: [PATCH 0/6] VFIO mdev aggregated resources handling
> >=20
> > Hi,
> >=20
> > This is a refresh for previous send of this series. I got impression th=
at some
> > SIOV drivers would still deploy their own create and config method so s=
topped
> > effort on this. But seems this would still be useful for some other SIO=
V driver
> > which may simply want capability to aggregate resources. So here's refr=
eshed
> > series.
> >=20
> > Current mdev device create interface depends on fixed mdev type, which =
get
> > uuid from user to create instance of mdev device. If user wants to use
> > customized number of resource for mdev device, then only can create new
> Can you please give an example of 'resource'?
> When I grep [1], [2] and [3], I couldn't find anything related to ' aggre=
gate'.

The resource is vendor device specific, in SIOV spec there's ADI
(Assignable Device Interface) definition which could be e.g queue for
net device, context for gpu, etc. I just named this interface as 'aggregate'
for aggregation purpose, it's not used in spec doc.

Thanks

>=20
> > mdev type for that which may not be flexible. This requirement comes no=
t only
> > from to be able to allocate flexible resources for KVMGT, but also from=
 Intel
> > scalable IO virtualization which would use vfio/mdev to be able to allo=
cate
> > arbitrary resources on mdev instance. More info on [1] [2] [3].
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
> > VM manager e.g libvirt can check mdev type with "aggregation" attribute
> > which can support this setting. If no "aggregation" attribute found for=
 mdev
> > type, previous behavior is still kept for one instance allocation. And =
new sysfs
> > attribute "aggregated_instances" is created for each mdev device to show
> > allocated number.
> >=20
> > References:
> > [1] https://software.intel.com/en-us/download/intel-virtualization-tech=
nology-
> > for-directed-io-architecture-specification
> > [2] https://software.intel.com/en-us/download/intel-scalable-io-virtual=
ization-
> > technical-specification
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
> > --
> > 2.24.0.rc0
>=20

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--OFj+1YLvsEfSXdCH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXcUlDQAKCRCxBBozTXgY
J2/3AJ96SN5mF29Mbj64YZWU7riR85ejhwCeP7kiYKFgJU1ElCDJeerwFrKlGsI=
=3UoA
-----END PGP SIGNATURE-----

--OFj+1YLvsEfSXdCH--
