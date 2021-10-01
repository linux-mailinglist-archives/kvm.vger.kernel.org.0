Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C2B41E787
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 08:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352222AbhJAGc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 02:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352211AbhJAGc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 02:32:27 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53173C06176A;
        Thu, 30 Sep 2021 23:30:44 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HLKxG5GSnz4xbT; Fri,  1 Oct 2021 16:30:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1633069842;
        bh=tuj7Sx6SMNyzgf92S3PRjpvS8Ufz0Db3Xwwl9IFP8Hs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TKQL9PMTi9o+MuKwqWHkZGuaAPcT+9o70w+u+0FgZXxwuwMWkOdTxnrShioro6Hd2
         9yWdYkETPDD2hMFDTPbpfeyWr81rou1I+aq00UZmnqNaG17L9vFkpGKzqpN06d2iEM
         1SJP15auciJg6X/+m4KF1IizBOwGs0UE4GmBIeoc=
Date:   Fri, 1 Oct 2021 16:13:58 +1000
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
Message-ID: <YVanJqG2pt6g+ROL@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JTmojUz8JowWR2jU"
Content-Disposition: inline
In-Reply-To: <20210921174438.GW327412@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--JTmojUz8JowWR2jU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 21, 2021 at 02:44:38PM -0300, Jason Gunthorpe wrote:
> On Sun, Sep 19, 2021 at 02:38:39PM +0800, Liu Yi L wrote:
> > This patch adds IOASID allocation/free interface per iommufd. When
> > allocating an IOASID, userspace is expected to specify the type and
> > format information for the target I/O page table.
> >=20
> > This RFC supports only one type (IOMMU_IOASID_TYPE_KERNEL_TYPE1V2),
> > implying a kernel-managed I/O page table with vfio type1v2 mapping
> > semantics. For this type the user should specify the addr_width of
> > the I/O address space and whether the I/O page table is created in
> > an iommu enfore_snoop format. enforce_snoop must be true at this point,
> > as the false setting requires additional contract with KVM on handling
> > WBINVD emulation, which can be added later.
> >=20
> > Userspace is expected to call IOMMU_CHECK_EXTENSION (see next patch)
> > for what formats can be specified when allocating an IOASID.
> >=20
> > Open:
> > - Devices on PPC platform currently use a different iommu driver in vfi=
o.
> >   Per previous discussion they can also use vfio type1v2 as long as the=
re
> >   is a way to claim a specific iova range from a system-wide address sp=
ace.
> >   This requirement doesn't sound PPC specific, as addr_width for pci de=
vices
> >   can be also represented by a range [0, 2^addr_width-1]. This RFC hasn=
't
> >   adopted this design yet. We hope to have formal alignment in v1 discu=
ssion
> >   and then decide how to incorporate it in v2.
>=20
> I think the request was to include a start/end IO address hint when
> creating the ios. When the kernel creates it then it can return the
> actual geometry including any holes via a query.

So part of the point of specifying start/end addresses is that
explicitly querying holes shouldn't be necessary: if the requested
range crosses a hole, it should fail.  If you didn't really need all
that range, you shouldn't have asked for it.

Which means these aren't really "hints" but optionally supplied
constraints.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--JTmojUz8JowWR2jU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFWpyUACgkQbDjKyiDZ
s5IGlg//alLq8rOP9c6VW4SoUf7Dw0IUnMOnXGk0Bq4d3IOxACK9H4AxImJ8KVHo
LxiFw8PLJbd+ZoSZEjBhDx4p1i01UuBQDEOJL6tXkeZuIIhBjsgDdGdGRa44pDrD
HajXTrRUoelS8W+v721yYDMHti4WQRx5/drW0t8GrxmcS5lP9rc+zlvSze28WTsv
WZcfLDHTq5pSij8bGRWMeTonXf5jtHh7IGk7AnsFYaMraHyRTc3xD0rrpogbW03f
9BSPm1jbbqagdL0vsd5Nake1Ko/7Y1eRD3SxkL1KT2wEKQJhyOV6UwToXjKlLLLn
2DIDpGXoFcb9jTbmDaRyfwFWVsq40QWz1x+BBBmiw0zQ2x+Si+nIXU3QC0dGfxKm
QqHaC1MmS4EHToeOCAQoi9dvXSG+rgdW6/d8JzLbjnt+nJKVajUYybP1v7fCacYr
ZWobUX9ONlgMUrPCPU8SVX/J+ykWsYWzJGGwZmv5CYEs4tTzovV62LK2yTf6P4RN
tfq4gSCAHkS03eYgZt2znel63WQTIagm0+XiXjR45e7c+EnUeP+GIiAC1s7+agE8
OrEC3YHn/c34TTlgzIwPj++PHrKndEsT3+IDzadnKhWtz3Auqv6I8sX772nvtqaS
72zLbSgadyOLJDjrCATWXQD6r4xGN/V6w29KG6G8sioYn9DsPuA=
=erif
-----END PGP SIGNATURE-----

--JTmojUz8JowWR2jU--
