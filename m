Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240743B2676
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 06:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhFXEyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 00:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbhFXEys (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 00:54:48 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6F0C061574;
        Wed, 23 Jun 2021 21:52:26 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4G9SRT2dt1z9sfG; Thu, 24 Jun 2021 14:52:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1624510341;
        bh=dJmtGU8dyFvnuijTR+utYBYOnB0dad5+eqhQA+Q/4VM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PXvCCED61+4o52RipA/ySvoJHmgY3IsIa02nvqbsk5D9selJjQaQuKaYtSn6toF3F
         TFTyprAcBeH7dZeYLrIyoJFQ6ELtZej0ogUD3HfwY1GamA24IWCXn4J33PvZ18WH9j
         bES4cWqgmH9Pr5GSKZEC9k/Jl5FSMWle2bLobhlQ=
Date:   Thu, 24 Jun 2021 14:07:01 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <YNQE5b+JODrVH/L6@yekko>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMCy48Xnt/aphfh3@8bytes.org>
 <20210609123919.GA1002214@nvidia.com>
 <YMrTeuUoqgzmSplL@yekko>
 <20210617231004.GA1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FVXvcr5GttEpzKAT"
Content-Disposition: inline
In-Reply-To: <20210617231004.GA1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--FVXvcr5GttEpzKAT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 17, 2021 at 08:10:04PM -0300, Jason Gunthorpe wrote:
> On Thu, Jun 17, 2021 at 02:45:46PM +1000, David Gibson wrote:
> > On Wed, Jun 09, 2021 at 09:39:19AM -0300, Jason Gunthorpe wrote:
> > > On Wed, Jun 09, 2021 at 02:24:03PM +0200, Joerg Roedel wrote:
> > > > On Mon, Jun 07, 2021 at 02:58:18AM +0000, Tian, Kevin wrote:
> > > > > -   Device-centric (Jason) vs. group-centric (David) uAPI. David =
is not fully
> > > > >     convinced yet. Based on discussion v2 will continue to have i=
oasid uAPI
> > > > >     being device-centric (but it's fine for vfio to be group-cent=
ric). A new
> > > > >     section will be added to elaborate this part;
> > > >=20
> > > > I would vote for group-centric here. Or do the reasons for which VF=
IO is
> > > > group-centric not apply to IOASID? If so, why?
> > >=20
> > > VFIO being group centric has made it very ugly/difficult to inject
> > > device driver specific knowledge into the scheme.
> > >=20
> > > The device driver is the only thing that knows to ask:
> > >  - I need a SW table for this ioasid because I am like a mdev
> > >  - I will issue TLPs with PASID
> > >  - I need a IOASID linked to a PASID
> > >  - I am a devices that uses ENQCMD and vPASID
> > >  - etc in future
> >=20
> > mdev drivers might know these, but shim drivers, like basic vfio-pci
> > often won't.
>=20
> The generic drivers say 'I will do every kind of DMA possible', which
> is in-of-itself a special kind of information to convey.
>=20
> There are alot of weird corners to think about here, like what if the
> guest asks for a PASID on a mdev that doesn't support PASID, but
> hooked to a RID that does or other quite nonsense combinations. These
> need to be blocked/handled/whatever properly, which is made much
> easier if the common code actually knows detail about what is going
> on.
>=20
> > I still think you're having a tendency to partially conflate several
> > meanings of "group":
> > 	1. the unavoidable hardware unit of non-isolation
> > 	2. the kernel internal concept and interface to it
> > 	3. the user visible fd and interface
>=20
> I think I have those pretty clearly seperated :)
> =20
> > We can't avoid having (1) somewhere, (3) and to a lesser extent (2)
> > are what you object to.
>=20
> I don't like (3) either, and am yet to hear a definitive reason why we
> must have it..

I don't know that there's a "definitive" reason.  My concern (and I
think Alex's as well) is that if there's no (3), it tends to lead to a
lack of (2), and lack of (2) tends to make people sloppily forget
about (1) and lead to breakage.

> > > The current approach has the group try to guess the device driver
> > > intention in the vfio type 1 code.
> >=20
> > I agree this has gotten ugly.  What I'm not yet convinced of is that
> > reworking groups to make this not-ugly necessarily requires totally
> > minimizing the importance of groups.
>=20
> I think it does - we can't have the group in the middle and still put
> the driver in chrage, it doesn't really work.
>=20
> At least if someone can see an arrangement otherwise lets hear it -
> start with how to keep groups and remove the mdev hackery from type1..
>=20
> Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--FVXvcr5GttEpzKAT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDUBOUACgkQbDjKyiDZ
s5KpSxAA3vN27+lMzXDPk2S7zvYdJ4d7zhPTOEnCEKHln4itOdXVtQI0jRsSXrQ+
DFVxgT59hCmxsrXHdpFi4rHAEYFUSEt7oItLnAT9IwtctYN04bQ/1XhaFXht4Kni
D7gxQRDNNnbfJL3jlQxzriy9u8S9pjh5JR4wZodZibtdq6o2c3BecO5Q8h43nmlL
wWhZGdpPnw4h3+htnzZg8Irb5PBzI3Bj0m+NXOJQ8Iz/wb1mrSOjlkuhY4gVG7iw
9ui6DaXYB3iWVhtuK8JdjG4o0ZW62H6L65O12cU5dojfIg4syMsXX1QhK+QuD9yX
YCnP6COhShRNekntOqx8WfemR+RbsDzA2teshdb3CKAw8z1teAImo81BcShG57xh
kO3DwKQvVTxk8DrMsSYDSbhAnexu/tPmqcZMpfZCL4OwTF9+tHgynmTxX2/CaLk9
Aw2TATLwZf350GB3QJfewuWowzOpAkcx5d0/oQj6RiTIQFKdz63sAkH/JoPOd+al
IKQhxghAt/pB1/h60m+MV2xe8PMipNX+NSzxn8PuxQIO7XVG38Kyl+spNjpaPPKP
okYLV9ofNdCN59neveMlffNtmogXYC2Ub1Xrh7B0T31G/mGmBeyqv8LXlpjmuYH9
GjCXzbmHQKam8cq7szI2ILHk3d+ToJPzERxCbu41kPLNpz5Eb1E=
=q9i0
-----END PGP SIGNATURE-----

--FVXvcr5GttEpzKAT--
