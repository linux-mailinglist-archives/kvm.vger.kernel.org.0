Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F19D399AB1
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 08:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhFCGaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 02:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhFCGaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 02:30:10 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F39C06174A;
        Wed,  2 Jun 2021 23:28:26 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FwbYy6bWlz9sX2; Thu,  3 Jun 2021 16:28:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1622701702;
        bh=WIm/yDsJvGo2IyYCrLryCua0Hmg97K2CGLyxXv+Q9ns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MwVFV04b8Vkcxdo2x6dhk0tnzgJz3ut+csIP+RAw6g/HzBXI4c2Pt3c/MbTLsSJAc
         gqqK4HNNn5sS+Zpr1zTxOVzVy5gCqutPE3Jrjj/24F2h5QffnQmiOB/NfMM91P/U7q
         VvtjxMwKhU+oFadGopeloE87r1Xr3yO/qZXs+3oM=
Date:   Thu, 3 Jun 2021 15:54:44 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
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
Message-ID: <YLhupAfUWWiVMDVU@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528233649.GB3816344@nvidia.com>
 <786295f7-b154-cf28-3f4c-434426e897d3@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="e+xYKskxbIIXJ+YF"
Content-Disposition: inline
In-Reply-To: <786295f7-b154-cf28-3f4c-434426e897d3@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--e+xYKskxbIIXJ+YF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 01, 2021 at 07:09:21PM +0800, Lu Baolu wrote:
> Hi Jason,
>=20
> On 2021/5/29 7:36, Jason Gunthorpe wrote:
> > > /*
> > >    * Bind an user-managed I/O page table with the IOMMU
> > >    *
> > >    * Because user page table is untrusted, IOASID nesting must be ena=
bled
> > >    * for this ioasid so the kernel can enforce its DMA isolation poli=
cy
> > >    * through the parent ioasid.
> > >    *
> > >    * Pgtable binding protocol is different from DMA mapping. The latt=
er
> > >    * has the I/O page table constructed by the kernel and updated
> > >    * according to user MAP/UNMAP commands. With pgtable binding the
> > >    * whole page table is created and updated by userspace, thus diffe=
rent
> > >    * set of commands are required (bind, iotlb invalidation, page fau=
lt, etc.).
> > >    *
> > >    * Because the page table is directly walked by the IOMMU, the user
> > >    * must  use a format compatible to the underlying hardware. It can
> > >    * check the format information through IOASID_GET_INFO.
> > >    *
> > >    * The page table is bound to the IOMMU according to the routing
> > >    * information of each attached device under the specified IOASID. =
The
> > >    * routing information (RID and optional PASID) is registered when a
> > >    * device is attached to this IOASID through VFIO uAPI.
> > >    *
> > >    * Input parameters:
> > >    *	- child_ioasid;
> > >    *	- address of the user page table;
> > >    *	- formats (vendor, address_width, etc.);
> > >    *
> > >    * Return: 0 on success, -errno on failure.
> > >    */
> > > #define IOASID_BIND_PGTABLE		_IO(IOASID_TYPE, IOASID_BASE + 9)
> > > #define IOASID_UNBIND_PGTABLE	_IO(IOASID_TYPE, IOASID_BASE + 10)
> > Also feels backwards, why wouldn't we specify this, and the required
> > page table format, during alloc time?
> >=20
>=20
> Thinking of the required page table format, perhaps we should shed more
> light on the page table of an IOASID. So far, an IOASID might represent
> one of the following page tables (might be more):
>=20
>  1) an IOMMU format page table (a.k.a. iommu_domain)
>  2) a user application CPU page table (SVA for example)
>  3) a KVM EPT (future option)
>  4) a VM guest managed page table (nesting mode)
>=20
> This version only covers 1) and 4). Do you think we need to support 2),

Isn't (2) the equivalent of using the using the host-managed pagetable
then doing a giant MAP of all your user address space into it?  But
maybe we should identify that case explicitly in case the host can
optimize it.

> 3) and beyond? If so, it seems that we need some in-kernel helpers and
> uAPIs to support pre-installing a page table to IOASID. From this point
> of view an IOASID is actually not just a variant of iommu_domain, but an
> I/O page table representation in a broader sense.
>=20
> Best regards,
> baolu
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--e+xYKskxbIIXJ+YF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC4bqQACgkQbDjKyiDZ
s5IZ/g/+KfrQ7u5dkP+nHBSnZErWCCHdUTJQSRRNkFuuMXpagfwmkjGvQCUuw1Vg
lwgTWZHnvHUzMEGfyM2uwwk4qZFaUP6K5tjyS6TqF/AEOSL1FGejsdKCLRlWMhlG
vSKE6P1y8UKMpV4deJBNthXeUVqYftrw1hTezsca0c5ZtlUfflP/0vhlM1+Q2FYM
WDvlgdLS9rOlQ9FJvvfnWiu4nlFiok9dXKpC/mMDamUlr9VfWxalmfULAy0VqXSM
pQTdGekWaX4Gn1WLCIBBAxHqIs9w7fZKDBqGw21kE4Q+fOOueoN0EqQLHsW2Gaw0
AD1H7tsuqPqj8WAIaHE406NmlxtZ2yybW3p6LnOAFrewuTRyej3kiA9LWKr1Csik
1lr3N+eNkuFYyUzk/LZHgBPiNSchFfNxLJBzvx/S2e2VC04psM0A8GIJ1Q4ja87Z
3qihYVH6fMWaIpoxsEDEn3Lfkt7sfYpDa0MpHHTF3Dfhxr6Fi+GahrnLCMXsddkO
5Os6wSzQA2saANfLgb4iTTOsQoAftn4r7bC4cZTM/V+U1EcQTmZrW0mAhhRtUiO1
xMoE6Ac2rOh0B8bTrZWwAREXbGvZrepEa9qi5gysA76zOPNWnNJHW3Ox3n9XCafP
XgwTUTjVmzBheuZ5wonf6JWBc+pnxmLekZwCBTzhB1B4k4LXwKA=
=sS9E
-----END PGP SIGNATURE-----

--e+xYKskxbIIXJ+YF--
