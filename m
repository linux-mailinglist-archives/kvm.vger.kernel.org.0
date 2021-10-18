Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB995430E8E
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 06:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhJREQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 00:16:15 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:51613 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhJREQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 00:16:13 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HXk5j62wkz4xd9; Mon, 18 Oct 2021 15:14:01 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1634530441;
        bh=4MetBvlI1yBgJfQgm7BUePN3YwoW4eyxNbbP0ENobvI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NjsMn+ipSdbXnOpa8y+a/46qJwRt12wAkdnosTD+WL3GE06JJJpZyTJqyG0WdfSYG
         /maRtN6lNWDqx52u3l2aP2rlHr/pL93jgyspjb7kEnop7i1qIHHDTyjGJeML4Kdd89
         YXucAAAUyt342YFNeLRS+E396JiuF7TCbXnqpKkI=
Date:   Mon, 18 Oct 2021 14:50:54 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        hch@lst.de, jasowang@redhat.com, joro@8bytes.org,
        jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@linux.intel.com, jun.j.tian@intel.com, hao.wu@intel.com,
        dave.jiang@intel.com, jacob.jun.pan@linux.intel.com,
        kwankhede@nvidia.com, robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        nicolinc@nvidia.com
Subject: Re: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Message-ID: <YWzvHsm7YMYS2sP3@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <YVanJqG2pt6g+ROL@yekko>
 <20211001122225.GK964074@nvidia.com>
 <YWPTWdHhoI4k0Ksc@yekko>
 <20211011184914.GQ2744544@nvidia.com>
 <YWe3zS4lIn8cj6su@yekko>
 <20211014145208.GR2744544@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="a7l7VEHFVCCcxjvj"
Content-Disposition: inline
In-Reply-To: <20211014145208.GR2744544@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--a7l7VEHFVCCcxjvj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 14, 2021 at 11:52:08AM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 14, 2021 at 03:53:33PM +1100, David Gibson wrote:
>=20
> > > My feeling is that qemu should be dealing with the host !=3D target
> > > case, not the kernel.
> > >=20
> > > The kernel's job should be to expose the IOMMU HW it has, with all
> > > features accessible, to userspace.
> >=20
> > See... to me this is contrary to the point we agreed on above.
>=20
> I'm not thinking of these as exclusive ideas.
>=20
> The IOCTL interface in iommu can quite happily expose:
>  Create IOAS generically
>  Manipulate IOAS generically
>  Create IOAS with IOMMU driver specific attributes
>  HW specific Manipulate IOAS
>=20
> IOCTL commands all together.
>=20
> So long as everything is focused on a generic in-kernel IOAS object it
> is fine to have multiple ways in the uAPI to create and manipulate the
> objects.
>=20
> When I speak about a generic interface I mean "Create IOAS
> generically" - ie a set of IOCTLs that work on most IOMMU HW and can
> be relied upon by things like DPDK/etc to always work and be portable.
> This is why I like "hints" to provide some limited widely applicable
> micro-optimization.
>=20
> When I said "expose the IOMMU HW it has with all features accessible"
> I mean also providing "Create IOAS with IOMMU driver specific
> attributes".
>=20
> These other IOCTLs would allow the IOMMU driver to expose every
> configuration knob its HW has, in a natural HW centric language.
> There is no pretense of genericness here, no crazy foo=3DA, foo=3DB hidden
> device specific interface.
>=20
> Think of it as a high level/low level interface to the same thing.

Ok, I see what you mean.

> > Those are certainly wrong, but they came about explicitly by *not*
> > being generic rather than by being too generic.  So I'm really
> > confused aso to what you're arguing for / against.
>=20
> IMHO it is not having a PPC specific interface that was the problem,
> it was making the PPC specific interface exclusive to the type 1
> interface. If type 1 continued to work on PPC then DPDK/etc would
> never learned PPC specific code.

Ok, but the reason this happened is that the initial version of type 1
*could not* be used on PPC.  The original Type 1 implicitly promised a
"large" IOVA range beginning at IOVA 0 without any real way of
specifying or discovering how large that range was.  Since ppc could
typically only give a 2GiB range at IOVA 0, that wasn't usable.

That's why I say the problem was not making type1 generic enough.  I
believe the current version of Type1 has addressed this - at least
enough to be usable in common cases.  But by this time the ppc backend
is already out there, so no-one's had the capacity to go back and make
ppc work with Type1.

> For iommufd with the high/low interface each IOMMU HW should ask basic
> questions:
>=20
>  - What should the generic high level interface do on this HW?
>    For instance what should 'Create IOAS generically' do for PPC?
>    It should not fail, it should create *something*
>    What is the best thing for DPDK?
>    I guess the 64 bit window is most broadly useful.

Right, which means the kernel must (at least in the common case) have
the capcity to choose and report a non-zero base-IOVA.

Hrm... which makes me think... if we allow this for the common
kernel-managed case, do we even need to have capcity in the high-level
interface for reporting IO holes?  If the kernel can choose a non-zero
base, it could just choose on x86 to place it's advertised window
above the IO hole.

>  - How to accurately describe the HW in terms of standard IOAS objects
>    and where to put HW specific structs to support this.
>=20
>    This is where PPC would decide how best to expose a control over
>    its low/high window (eg 1,2,3 IOAS). Whatever the IOMMU driver
>    wants, so long as it fits into the kernel IOAS model facing the
>    connected device driver.
>=20
> QEMU would have IOMMU userspace drivers. One would be the "generic
> driver" using only the high level generic interface. It should work as
> best it can on all HW devices. This is the fallback path you talked
> of.
>=20
> QEMU would also have HW specific IOMMU userspace drivers that know how
> to operate the exact HW. eg these drivers would know how to use
> userspace page tables, how to form IOPTEs and how to access the
> special features.
>=20
> This is how QEMU could use an optimzed path with nested page tables,
> for instance.

The concept makes sense in general.  The devil's in the details, as usual.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--a7l7VEHFVCCcxjvj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFs7x4ACgkQbDjKyiDZ
s5Jymg/+KRvVDzFvMbhDCTkJPaf2NZRQdvidTMzm7+ooHyhl+ffuWtYzaPvLOG/e
s1GU9SaDYHIfJmjo1SucgKbmEt8mqxDaJuK+8Jc1lq8EIUxR9WN356MNSv4BtJ9d
xFyUO7sPIG4Bei5yPvqkhI7UBgnihfSyDjwax+tcLvyH7d6Iltq7cc7mR+4c8pVv
XRGpyHhKH2YtwswloQ1mQYnlEHGMRpg4CVpfmpFqpnbkZ9ePziK62j8bAFbq08ml
aWBzHbnVHtIRdMShh0Sd9xZqbma9cVFTvTgenUM1T+b0iZw8WujA9SWrf0dpMDt8
fZ0Jb8u3ohT9UjivfAVfNRGgUXCfwPVdJIVZNA/CAH3xVWAa8ISOmik3l9rcdOfm
s5eTIAFpusZGHcYVRSc9OJtnrTAGwcxFHLfqri/TtfatoELFqdcY4uzPX9rtIdAz
rxya6LN+CPypr+N8qK1BGSMAginSIUU9Rxc6ZWJseo0OCKx0mSxplpcUKEz3iAR4
+bA7TF/6JD193K4EGdgA7kgz6CYQhrV4zNMbbOtjrV0gS+ORbH2L8ozbrDbYLDaF
TLSncL4HcLHvn3GxOJKi0NmmbpZtcBA7xBNeiBuyUxPJb0LzqWIKc+oHaLM/AlDV
SkD3RKtcLXa+wa8J/LY7qrhZwsFGvWLjhZmX3nLXfiDj9A1Bc5I=
=e3U1
-----END PGP SIGNATURE-----

--a7l7VEHFVCCcxjvj--
