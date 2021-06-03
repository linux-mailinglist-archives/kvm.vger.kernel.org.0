Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562DA399AA2
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 08:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhFCGaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 02:30:08 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:43315 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhFCGaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 02:30:08 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FwbYy52Pbz9sWQ; Thu,  3 Jun 2021 16:28:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1622701702;
        bh=2xuBQMunr1ZQZ9vbpz6j/qlb//Vd4mU8xLiQkXpqKfg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F06Ckzdx/6BrAumJp7tT3RCKq68mj/DzWQ8iusZcMz+TFQbRAAEd/TsB88vDQfKTp
         7o6qkSbN7B5i77XvnB5qHgzg4J6cI6q1BFMbioTR0h/ePDSw+NJ+rSQ15zwmupX2SL
         3uB0f8Pr1QEVS0iFJLMPIZjsoh6HGgXCxs6I0f78=
Date:   Thu, 3 Jun 2021 15:13:44 +1000
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
Message-ID: <YLhlCINGPGob4Nld@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528173538.GA3816344@nvidia.com>
 <YLcl+zaK6Y0gB54a@yekko>
 <20210602161648.GY1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UwcuFoJaxyrb8B7F"
Content-Disposition: inline
In-Reply-To: <20210602161648.GY1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--UwcuFoJaxyrb8B7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 02, 2021 at 01:16:48PM -0300, Jason Gunthorpe wrote:
> On Wed, Jun 02, 2021 at 04:32:27PM +1000, David Gibson wrote:
> > > I agree with Jean-Philippe - at the very least erasing this
> > > information needs a major rational - but I don't really see why it
> > > must be erased? The HW reports the originating device, is it just a
> > > matter of labeling the devices attached to the /dev/ioasid FD so it
> > > can be reported to userspace?
> >=20
> > HW reports the originating device as far as it knows.  In many cases
> > where you have multiple devices in an IOMMU group, it's because
> > although they're treated as separate devices at the kernel level, they
> > have the same RID at the HW level.  Which means a RID for something in
> > the right group is the closest you can count on supplying.
>=20
> Granted there may be cases where exact fidelity is not possible, but
> that doesn't excuse eliminating fedelity where it does exist..
>=20
> > > If there are no hypervisor traps (does this exist?) then there is no
> > > way to involve the hypervisor here and the child IOASID should simply
> > > be a pointer to the guest's data structure that describes binding. In
> > > this case that IOASID should claim all PASIDs when bound to a
> > > RID.=20
> >=20
> > And in that case I think we should call that object something other
> > than an IOASID, since it represents multiple address spaces.
>=20
> Maybe.. It is certainly a special case.
>=20
> We can still consider it a single "address space" from the IOMMU
> perspective. What has happened is that the address table is not just a
> 64 bit IOVA, but an extended ~80 bit IOVA formed by "PASID, IOVA".

True.  This does complexify how we represent what IOVA ranges are
valid, though.  I'll bet you most implementations don't actually
implement a full 64-bit IOVA, which means we effectively have a large
number of windows from (0..max IOVA) for each valid pasid.  This adds
another reason I don't think my concept of IOVA windows is just a
power specific thing.

> If we are already going in the direction of having the IOASID specify
> the page table format and other details, specifying that the page
> tabnle format is the 80 bit "PASID, IOVA" format is a fairly small
> step.

Well, rather I think userspace needs to request what page table format
it wants and the kernel tells it whether it can oblige or not.

> I wouldn't twist things into knots to create a difference, but if it
> is easy to do it wouldn't hurt either.
>=20
> Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--UwcuFoJaxyrb8B7F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC4ZQgACgkQbDjKyiDZ
s5IM8w//d5632xHIUe/SxdcMgeeL1e5mDxHeFH0h0NOYnXs0b3siioEPgoSzjZi2
eJ5dqCuEkuZ4jMHBZ7xBGhNAYcidi7Ww0e9zCuGHXgUt9OLkf9W5c5eWUugTFzDY
XFI1VYrP4xD2OsXFr+o3yK5EVXCEQkET8rcSRv8LiKxtxurFJyGPYcX4PZ1unbhi
jcAy7GezT1Mq71/r4iofe1i/fIYZKqq0oZYWyoXKVXQ1d2ajCT3DN6RnWpcCj760
ZJlsXUCYNtvb4BqrI6z7pLcJzxxzbcu0TyvrYyOt1VHvHJ+xfgDe38KYTO4qGOBg
9hScch8s7iQCpTzXfwB7rgIl6rxWglvcM551NZxryzzxKh1pvtfSScwQbObGjQha
4s0V9xrl6v+rZn8Uzw7Ys6MSHIbf7JN+lfmr7C/5HmfdWRFEC+EFfgKMo0PLd4ex
PTdzpd3DJbDQA2MYgwKdeKloYtbJ6Nra6OMlPEKMuE9iDeSt88QQ5WBNjYGIP/hl
T0DyFyVsIDLhnkbF9F/xyrdz4iRzb36ecn9xrRPK04istV8UDdK80hFJU6UG/hMY
RYzDI/WYMR+ExTnrGcPkY5oT+3cP2t2bs/K+dFRPyPLm+O3P4GwlyxgpCf1psS2X
QUWBVO91SiYSNxmz4GbaJ7OYTv7VM03wJx9SkFIHs9dTMg+xDOg=
=1QbC
-----END PGP SIGNATURE-----

--UwcuFoJaxyrb8B7F--
