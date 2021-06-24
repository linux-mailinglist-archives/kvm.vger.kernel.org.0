Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23E73B268E
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 06:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhFXEy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 00:54:59 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35245 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230121AbhFXEyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 00:54:51 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4G9SRT5RZJz9t1s; Thu, 24 Jun 2021 14:52:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1624510341;
        bh=CUOvolS00mt6fsyyOcaBeHpDD1l35MwCPi+iWoJuI20=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e+t14wM8FUhdgZVe3bPvZMI676YD8wnW8ic6Am/0whGW4VYhlxJ2x750ZLghvljKa
         pYU9Vmqh+k0qSi+vs9n+kCUu6e4pjtqwaMMUw1A0otHxPj0N10CtjgTB4tg+0kutjy
         TWZMThky96oa00b4SxnlTGrcqPApbZCJf2wwIb5E=
Date:   Thu, 24 Jun 2021 14:50:45 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
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
Message-ID: <YNQPJfNixs23RaJm@yekko>
References: <YMDjfmJKUDSrbZbo@8bytes.org>
 <20210609101532.452851eb.alex.williamson@redhat.com>
 <20210609102722.5abf62e1.alex.williamson@redhat.com>
 <20210609184940.GH1002214@nvidia.com>
 <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
 <BN6PR11MB187579A2F88C77ED2131CEF08C349@BN6PR11MB1875.namprd11.prod.outlook.com>
 <20210611153850.7c402f0b.alex.williamson@redhat.com>
 <MWHPR11MB1886C2A0A8AA3000EBD5F8E18C319@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210614133819.GH1002214@nvidia.com>
 <MWHPR11MB1886A6B3AC4AD249405E5B178C309@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eoUsj9hAKr/fBY8i"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886A6B3AC4AD249405E5B178C309@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--eoUsj9hAKr/fBY8i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 15, 2021 at 01:21:35AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Monday, June 14, 2021 9:38 PM
> >=20
> > On Mon, Jun 14, 2021 at 03:09:31AM +0000, Tian, Kevin wrote:
> >=20
> > > If a device can be always blocked from accessing memory in the IOMMU
> > > before it's bound to a driver or more specifically before the driver
> > > moves it to a new security context, then there is no need for VFIO
> > > to track whether IOASIDfd has taken over ownership of the DMA
> > > context for all devices within a group.
> >=20
> > I've been assuming we'd do something like this, where when a device is
> > first turned into a VFIO it tells the IOMMU layer that this device
> > should be DMA blocked unless an IOASID is attached to
> > it. Disconnecting an IOASID returns it to blocked.
>=20
> Or just make sure a device is in block-DMA when it's unbound from a
> driver or a security context.

So I'm not entirely clear here if you're envisaging putting the device
into no-DMA mode by altering the IOMMU setup or by quiescing it at the
register level (e.g. by resetting it).  But, neither approach allows
you to safely put a device into no-DMA mode if users have access to
another device in the group.

The IOMMU approach doesn't work, because the IOMMU may not be able to
distinguish the two devices from each other.

The register approach doesn't work, because even if you successfully
quiesce the device, the user could poke it indirectly via the other
device in the group, pulling it out of quiescent mode.

> Then no need to explicitly tell IOMMU layer=20
> to do so when it's bound to a new driver.
>=20
> Currently the default domain type applies even when a device is not
> bound. This implies that if iommu=3Dpassthrough a device is always=20
> allowed to access arbitrary system memory with or without a driver.
> I feel the current domain type (identity, dma, unmanged) should apply
> only when a driver is loaded...

A whole group has to be in the same DMA context at the same time.
That's the definition of a group.

> > > If this works I didn't see the need for vfio to keep the sequence.
> > > VFIO still keeps group fd to claim ownership of all devices in a
> > > group.
> >=20
> > As Alex says you still have to deal with the problem that device A in
> > a group can gain control of device B in the same group.
>=20
> There is no isolation in the group then how could vfio prevent device
> A from gaining control of device B? for example when both are attached
> to the same GPA address space with device MMIO bar included, devA
> can do p2p to devB. It's all user's policy how to deal with devices within
> the group.=20
>=20
> >=20
> > This means device A and B can not be used from to two different
> > security contexts.
>=20
> It depends on how the security context is defined. From iommu layer
> p.o.v, an IOASID is a security context which isolates a device from
> the rest of the system (but not the sibling in the same group). As you
> suggested earlier, it's completely sane if an user wants to attach
> devices in a group to different IOASIDs. Here I just talk about this fact.
>=20
> >=20
> > If the /dev/iommu FD is the security context then the tracking is
> > needed there.
> >=20
>=20
> As I replied to Alex, my point is that VFIO doesn't need to know the
> attaching status of each device in a group before it can allow user to
> access a device. As long as a device in a group either in block DMA
> or switch to a new address space created via /dev/iommu FD, there's
> no problem to allow user accessing it. User cannot do harm to the
> world outside of the group. User knows there is no isolation within
> the group. that is it.
>=20
> Thanks
> Kevin
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--eoUsj9hAKr/fBY8i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDUDyMACgkQbDjKyiDZ
s5KjaA/9EPMEsLemYo6QFgWL2LNDDKTanMJQkWieLTfB4rSTop8+qdgEyXKOIOZu
Iv8nkPNdJy3ylIYKWWYi2mxMNaTR+qHDGFRLc9WK1m++oqM3Q7laNOt39QZ5Uy1P
VCDc9dYIvKz+XAL9ihYV/i07LDHhec/0CvbEC7EDRnCQRoTZTEaPW7zsQmB4juR/
X3WLPrrvQJKIT9s49MJd7ZSLwBVn9+sdXU+DjqmhuZZBTyFTdesNvGCd5lpbCM9D
vKDKufOB8jRe1CyXuVfFPiIWpj5y8ixRvgOpGvt2DPODwurIWl0yDhLHAezyhoW7
6igINNFVQhk0cVEHuyBUFUknzLg4gdoxgcGeNhYRkRsGLbFyiCIyxzTLVPQJ5/NS
EQvt7zAIMjgYIFVL8QDimf+QZbD3NtGr8DiDMYGJtb2LCDpdbHQ8BG4Zk7D1Gdd0
M1Dw5xiuUHsOVr+FLal2KUybESDq104z432KhmPo2Cj3zUrjp57M9FmrN3CWmXAG
/+Gu6O+k2xvQwR4tFag7dGtAr4BlxUf4ja2DThPGVkmTe/EKYaRZ5YEWuozI62oR
rJSJLbR4mnqf8mcQzawrBwp37SJlypo2m/1FtgYnuPHUjUJf21uvGHw3v4KD9rO/
iX5lcN/pPE+j7WvY0WfK9tv9HlTbLn57EoQm97z9k3j7s6Az0oY=
=log0
-----END PGP SIGNATURE-----

--eoUsj9hAKr/fBY8i--
