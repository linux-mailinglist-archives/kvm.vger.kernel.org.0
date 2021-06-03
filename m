Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55644399AB0
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 08:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhFCGaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 02:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhFCGaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 02:30:09 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97ABC061756;
        Wed,  2 Jun 2021 23:28:24 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FwbYy4cPTz9s5R; Thu,  3 Jun 2021 16:28:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1622701702;
        bh=IEEiXT5ukbF9bVCRBbDqCX5LlE3sy5L+2Kdn6s28K58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KIR+GzyhRu27toheHJDd50KhCPCJbP3gDGUuXZldNPxbTzZf7XO7iP7Va6FbAKtVw
         oMW2lSGDSJAAs3IwkPuecVOEzpLPFN5RrCse9tETBTjAv5q7b8inQprCzFkEGGT/7I
         jm7CC6cD+WQ8xfciulygEFE9O20QtHmyjblCEgeA=
Date:   Thu, 3 Jun 2021 15:23:17 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <YLhnRbJJqPUBiRwa@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com>
 <MWHPR11MB1886A17F36CF744857C531148C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601175643.GQ1002214@nvidia.com>
 <YLcr8B7EPDCejlWZ@yekko>
 <20210602163753.GZ1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ct7l8sovhYah/GNA"
Content-Disposition: inline
In-Reply-To: <20210602163753.GZ1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ct7l8sovhYah/GNA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 02, 2021 at 01:37:53PM -0300, Jason Gunthorpe wrote:
> On Wed, Jun 02, 2021 at 04:57:52PM +1000, David Gibson wrote:
>=20
> > I don't think presence or absence of a group fd makes a lot of
> > difference to this design.  Having a group fd just means we attach
> > groups to the ioasid instead of individual devices, and we no longer
> > need the bookkeeping of "partial" devices.
>=20
> Oh, I think we really don't want to attach the group to an ioasid, or
> at least not as a first-class idea.
>=20
> The fundamental problem that got us here is we now live in a world
> where there are many ways to attach a device to an IOASID:

I'm not seeing that that's necessarily a problem.

>  - A RID binding
>  - A RID,PASID binding
>  - A RID,PASID binding for ENQCMD

I have to admit I haven't fully grasped the differences between these
modes.  I'm hoping we can consolidate at least some of them into the
same sort of binding onto different IOASIDs (which may be linked in
parent/child relationships).

>  - A SW TABLE binding
>  - etc
>=20
> The selection of which mode to use is based on the specific
> driver/device operation. Ie the thing that implements the 'struct
> vfio_device' is the thing that has to select the binding mode.

I thought userspace selected the binding mode - although not all modes
will be possible for all devices.

> group attachment was fine when there was only one mode. As you say it
> is fine to just attach every group member with RID binding if RID
> binding is the only option.
>=20
> When SW TABLE binding was added the group code was hacked up - now the
> group logic is choosing between RID/SW TABLE in a very hacky and mdev
> specific way, and this is just a mess.

Sounds like it.  What do you propose instead to handle backwards
compatibility for group-based VFIO code?

> The flow must carry the IOASID from the /dev/iommu to the vfio_device
> driver and the vfio_device implementation must choose which binding
> mode and parameters it wants based on driver and HW configuration.
>=20
> eg if two PCI devices are in a group then it is perfectly fine that
> one device uses RID binding and the other device uses RID,PASID
> binding.

Uhhhh... I don't see how that can be.  They could well be in the same
group because their RIDs cannot be distinguished from each other.

> The only place I see for a "group bind" in the uAPI is some compat
> layer for the vfio container, and the implementation would be quite
> different, we'd have to call each vfio_device driver in the group and
> execute the IOASID attach IOCTL.
>=20
> > > I would say no on the container. /dev/ioasid =3D=3D the container, ha=
ving
> > > two competing objects at once in a single process is just a mess.
> >=20
> > Right.  I'd assume that for compatibility, creating a container would
> > create a single IOASID under the hood with a compatiblity layer
> > translating the container operations to iosaid operations.
>=20
> It is a nice dream for sure
>=20
> /dev/vfio could be a special case of /dev/ioasid just with a different
> uapi and ending up with only one IOASID. They could be interchangable
> from then on, which would simplify the internals of VFIO if it
> consistently delt with these new ioasid objects everywhere. But last I
> looked it was complicated enough to best be done later on
>=20
> Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--ct7l8sovhYah/GNA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC4Z0UACgkQbDjKyiDZ
s5JVmBAAvFLHQONjTSmYF0VpXWkFjszZDezpbL/wjXpuJp+d8d/JHfGH1jaP+UeJ
dBm4x2+wg5ObhI1DY/Q8OTrTKud71LvN8FayexQ0SKkqzaFTyXvEzP2vr30N2Svc
qzxReZfDkXPneWNb/IqdVO5KgxVgtNR+tgIlCiFAndJdOcjTPfC38zr3ceNbKn7Q
kofsipS61OUwkj7X7mUEuzajdYDDQ3yfPGbuI6XY2dJbQd1+Bgv9yfA71yruIw3L
5JenqmBlO9oJcvU09Db8wZe7iT27Jh5Jl/LAAzSoaVOb8lZkVRKLETgKHRx9SfDf
xwsIDCpOQ5jtClK4qpGmpATkNgd2q6S7uqb8GsXTXCVxV4GMHKLaDRTGCK4m3hx0
XPmTZDS3NDShGjeUVvrGNosIriXb0UaWzugtLpvGyRe6U53p9tL8khNUIUKZysrX
uHH0SxwwK8+4ke8+zPVn48Y6CE1IYWKVHb3oeLmgYLF28W4Qo2FmoVHlO+Go+Z4C
kh1yKIIm6phXqwIxVn4pFIi5A5u/pnsSVdod3Ll93xTf/Th3fmjAeAeOy9XU3Wf8
Qp9RmpMopPQARqDDY74Scbg2IxlzM/ks3rqGcKg/aUTaQl5Fhxzan7F5daKsHf1e
92Ou5VpiV0KKg4FDe160et4u4x/qAjq+ROSkB8I+HoGyZSw6Nsk=
=6Lix
-----END PGP SIGNATURE-----

--ct7l8sovhYah/GNA--
