Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7C142D240
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 08:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhJNGYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 02:24:40 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:56251 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhJNGYh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 02:24:37 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HVK7r23g8z4xbX; Thu, 14 Oct 2021 17:22:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1634192552;
        bh=ZjbiQlJIXJMoYEFn9YS8ZY2I4WMOysFPmdFgHdCC4bk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bnu5pnv1agQiV9iOQmNVRreuQOZUbrPFJUc9qZoDrD5bci44q3xFm0xecwh6tepQU
         z0PRsRWB5HYaSr4KQx5u3QLB4/Krs5lFuLYwboFRxudY8MxVGd11wkcFEiYqUYo+gu
         YyWs+sArvD4TvxUdsbQ4i5V8rGgNNrz1ojnYLPx0=
Date:   Thu, 14 Oct 2021 15:38:37 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Liu Yi L <yi.l.liu@intel.com>,
        alex.williamson@redhat.com, hch@lst.de, jasowang@redhat.com,
        joro@8bytes.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@linux.intel.com, jun.j.tian@intel.com, hao.wu@intel.com,
        dave.jiang@intel.com, jacob.jun.pan@linux.intel.com,
        kwankhede@nvidia.com, robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        nicolinc@nvidia.com
Subject: Re: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Message-ID: <YWe0TXqEm6uWH695@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <YVanJqG2pt6g+ROL@yekko>
 <20211001122225.GK964074@nvidia.com>
 <YWPTWdHhoI4k0Ksc@yekko>
 <YWP6tblC2+/2RQtN@myrica>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6dLb7we/5OKQdVbz"
Content-Disposition: inline
In-Reply-To: <YWP6tblC2+/2RQtN@myrica>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--6dLb7we/5OKQdVbz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 11, 2021 at 09:49:57AM +0100, Jean-Philippe Brucker wrote:
> On Mon, Oct 11, 2021 at 05:02:01PM +1100, David Gibson wrote:
> > qemu wants to emulate a PAPR vIOMMU, so it says (via interfaces yet to
> > be determined) that it needs an IOAS where things can be mapped in the
> > range 0..2GiB (for the 32-bit window) and 2^59..2^59+1TiB (for the
> > 64-bit window).
> >=20
> > Ideally the host /dev/iommu will say "ok!", since both those ranges
> > are within the 0..2^60 translated range of the host IOMMU, and don't
> > touch the IO hole.  When the guest calls the IO mapping hypercalls,
> > qemu translates those into DMA_MAP operations, and since they're all
> > within the previously verified windows, they should work fine.
>=20
> Seems like we don't need the negotiation part?  The host kernel
> communicates available IOVA ranges to userspace including holes (patch
> 17), and userspace can check that the ranges it needs are within the IOVA
> space boundaries. That part is necessary for DPDK as well since it needs
> to know about holes in the IOVA space where DMA wouldn't work as expected
> (MSI doorbells for example). And there already is a negotiation happening,
> when the host kernel rejects MAP ioctl outside the advertised area.

The problem with the approach where the kernel advertises and
userspace selects based on that, is that it locks us into a specific
representation of what's possible.  If we get new hardware with new
weird constraints that can't be expressed with the representation we
chose, we're kind of out of stuffed.  Userspace will have to change to
accomodate the new extension and have any chance of working on the new
hardware.

With the model where userspace requests, and the kernel acks or nacks,
we can still support existing userspace if the only things it requests
can still be accomodated in the new constraints.  That's pretty likely
if the majority of userspaces request very simple things (say a single
IOVA block where it doesn't care about the base address).

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--6dLb7we/5OKQdVbz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFntE0ACgkQbDjKyiDZ
s5IfiQ//ZhlukeW5UG20W/811MuwXc1bzTOsyL5lBR7JUPze3jwwNHOyDcVvG3bE
lcVXb6jOX3m4jdp1CARvSYiuLHRHbr3yXhz5e1Kzl8lYrGz2OCK99Aa4IVZsWe0W
vg8BORYBNzKhtbLXjYyYG00UPYpTqd3fsMc5HZOmhl4KDKFnMhxk093OcveJAyEz
U7QNQU9t5aCmGYesbGeFpLHjAMUVbxp2fPDmqwazo2BmJX7QMYO7S5/99cwC+uJ2
huezzVUkGRzRX8M1Vn+7SXX/VEZS+Qxg4hvMtHuyEMpft0ECzF+8RsTY2pX0RkUP
fox84HDo/JvRQFbP61C3bIz5PIHbZ5/MFpJ2UJ0ispkm/30v0hM4AcKTDYOMy1fi
pPd3lZoOvTWOfLX5GHYdDAONCt+4vOE868LJHIblRGGmnwZ6Z4M/5oJlgWBSkpzb
czVxyIPADRLUWtaTkLTuWmhyw6aGWMCmqSWJRQQ2y62vQScLQFEq3ReXpwq/tu4U
WRczYt41+LxQaRTySLmmNQq08/caNf/z6CpkvmD6Nm69isY1HpJaDyS4oymffvjW
tgNeITcmxVFvTD4G5qFVar6qZHOlIXYB0PPbOm3z31bxgKGJXvo4CFw5g0KTS2IC
keIgE7F4OQDg8CVFU4SwJwWMiSCS2cUrqT58Km8XGq2eZxDSwjg=
=0DMk
-----END PGP SIGNATURE-----

--6dLb7we/5OKQdVbz--
