Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779EB3AAD57
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 09:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhFQHYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 03:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhFQHYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 03:24:18 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A32AC061760;
        Thu, 17 Jun 2021 00:22:11 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4G5D5W5TCzz9sW7; Thu, 17 Jun 2021 17:22:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1623914527;
        bh=SOP0ABK+iUiJMHZ7HHdWKegAXFZNs1FMpwMu7wdh2Vk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=asxABNpKVjGvMtPoB/4lZ/JTHY+ovIMWCaskss412VS4kabClUi1J85yuPDLfOjEg
         PTwWhn5bIcy9l7eIPQhlEjZHF94PehVquR9HHFuu20tNQiTA6KISIjNpfqloJAd/ws
         bNN4vp+/190EVPl/FPqallzEXYZ1fHC52e7xW6SM=
Date:   Thu, 17 Jun 2021 13:47:36 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
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
Message-ID: <YMrF2BV0goTIPbrN@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528200311.GP1002214@nvidia.com>
 <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601162225.259923bc.alex.williamson@redhat.com>
 <YL7X0FKj+r6lIHQZ@yekko>
 <20210608131756.GF1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="j3oeW5Y91uLYui5m"
Content-Disposition: inline
In-Reply-To: <20210608131756.GF1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--j3oeW5Y91uLYui5m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 08, 2021 at 10:17:56AM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 08, 2021 at 12:37:04PM +1000, David Gibson wrote:
>=20
> > > The PPC/SPAPR support allows KVM to associate a vfio group to an IOMMU
> > > page table so that it can handle iotlb programming from pre-registered
> > > memory without trapping out to userspace.
> >=20
> > To clarify that's a guest side logical vIOMMU page table which is
> > partially managed by KVM.  This is an optimization - things can work
> > without it, but it means guest iomap/unmap becomes a hot path because
> > each map/unmap hypercall has to go
> > 	guest -> KVM -> qemu -> VFIO
> >=20
> > So there are multiple context transitions.
>=20
> Isn't this overhead true of many of the vIOMMUs?

Yes, but historically it bit much harder on POWER for a couple of reasons:

1) POWER guests *always* have a vIOMMU - the platform has no concept
   of passthrough mode.  We therefore had a vIOMMU implementation some
   time before the AMD or Intel IOMMUs were implemented as vIOMMUs in
   qemu.

2) At the time we were implementing this the supported IOVA window for
   the paravirtualized IOMMU was pretty small (1G, I think) making
   vIOMMU maps and unmaps a pretty common operation.

> Can the fast path be
> generalized?

Not really.  This is a paravirtualized guest IOMMU, so it's a platform
specific group of hypercalls that's being interpreted by KVM and
passed through to the IOMMU side using essentially the same backend
that that the userspace implementation would eventually get to after a
bunch more context switches.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--j3oeW5Y91uLYui5m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDKxdYACgkQbDjKyiDZ
s5Ih/A//YE3M7mMfFiKum31pHFC6pkSqy9q9fAc/ME7yP9WGeJuLNv4ONxJMsgDj
mE/9QC/SsU+6o+Vp1pLOVtUHHE/siI5G+cbKX7HA0dWbgn1faPT/C51NjpeVho6x
z/MsgI8zuDEXQpzJjncfTvCZh8j8uZYwUTiZU1QlwJ5Gr70LLCb+fnKvFDRjDhDa
N3SjUvfrUeknOz9tmnpETy/Ju0E6njTeyssXH/VCwZGcqV7p5LMbACsZ3Np9s5Fq
uRUYAIOhDCCucTdEwgggd2xIrVvfUBA/dm7vp31okvqHRfL0gCiLHtATlop3p/ZO
GZDtkJFXYB2nEw5DNbK4Rr2uDt76PjIU2U0WztLpzZW7bblr8eM7uURallS8QHhr
mMDRsjTXb3CTt4gPLbq7xayffp8Jc/AG5XzSutHgBXY0v8JeGM7MxhGv25NRkifS
ebJ+QyC6uxMSPhnlg4XLJ8MFzrSnMRUUuiit7FH71oEdu2AH4w5IuuG1SDg2A5PW
jgj0kOKiVg7JO+ZIXY8j9x08oT5s2tdAcfxfoqjrr9AmVBa/W6zk/wCjfYVnep+0
cJPh3VUC2zmkRvlizuU6HbP0vOdFcrIxqpSk67xAH4pgx2Sh+DLDWOpmZX5jJawH
pHiHepB/VJU1+zpvUNMEymFrgZUZ3+tSp3+qf7LkMRhMkrg4QE4=
=pfJz
-----END PGP SIGNATURE-----

--j3oeW5Y91uLYui5m--
