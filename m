Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF34146040
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 02:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgAWBWG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 20:22:06 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:34351 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgAWBWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 20:22:06 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4834Hv6lljz9sS3; Thu, 23 Jan 2020 12:22:03 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1579742524;
        bh=z/eRlm5KI2ojpKo1UKbpG9UI1ViifmpZ99+o9Yw0RjI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fdFVs/v0G2DHapiOPKY8nmHmFpgJnZvR3OdGZnhf1HhNYLeBixibnp64txklSZguB
         LF2Q5wQl1yneEtaKDPjiPPDHkyZi4XfDOn1yqG5gzYpic4HzCeQsgiHH78q/Mro6cw
         FEEaCJmGBs+apnM3Wke8RtYu6fLRcXZW1gDcsqGY=
Date:   Thu, 23 Jan 2020 12:17:30 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        Alistair Popple <alistair@popple.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Oliver O'Halloran <oohall@gmail.com>
Subject: Re: [PATCH kernel RFC 0/4] powerpc/powenv/ioda: Allow huge DMA
 window at 4GB
Message-ID: <20200123011730.GL2347@umbus.fritz.box>
References: <20191202015953.127902-1-aik@ozlabs.ru>
 <002b30d2-a9e4-da11-2423-b003288ce8f3@ozlabs.ru>
 <9423b5e0-75e9-4a7a-7e65-818879d52d48@ozlabs.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tv2SIFopg1r47n4a"
Content-Disposition: inline
In-Reply-To: <9423b5e0-75e9-4a7a-7e65-818879d52d48@ozlabs.ru>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--tv2SIFopg1r47n4a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 23, 2020 at 11:53:32AM +1100, Alexey Kardashevskiy wrote:
> Anyone, ping?

Sorry, I've totally lost track of this one.  I think you'll need to
repost.


>=20
>=20
> On 10/01/2020 15:18, Alexey Kardashevskiy wrote:
> >=20
> >=20
> > On 02/12/2019 12:59, Alexey Kardashevskiy wrote:
> >> Here is an attempt to support bigger DMA space for devices
> >> supporting DMA masks less than 59 bits (GPUs come into mind
> >> first). POWER9 PHBs have an option to map 2 windows at 0
> >> and select a windows based on DMA address being below or above
> >> 4GB.
> >>
> >> This adds the "iommu=3Diommu_bypass" kernel parameter and
> >> supports VFIO+pseries machine - current this requires telling
> >> upstream+unmodified QEMU about this via
> >> -global spapr-pci-host-bridge.dma64_win_addr=3D0x100000000
> >> or per-phb property. 4/4 advertises the new option but
> >> there is no automation around it in QEMU (should it be?).
> >>
> >> For now it is either 1<<59 or 4GB mode; dynamic switching is
> >> not supported (could be via sysfs).
> >>
> >> This is based on sha1
> >> a6ed68d6468b Linus Torvalds "Merge tag 'drm-next-2019-11-27' of git://=
anongit.freedesktop.org/drm/drm".
> >>
> >> Please comment. Thanks.
> >=20
> >=20
> > David, Alistair, ping? Thanks,
>=20
>=20
> >=20
> >=20
> >>
> >>
> >>
> >> Alexey Kardashevskiy (4):
> >>   powerpc/powernv/ioda: Rework for huge DMA window at 4GB
> >>   powerpc/powernv/ioda: Allow smaller TCE table levels
> >>   powerpc/powernv/phb4: Add 4GB IOMMU bypass mode
> >>   vfio/spapr_tce: Advertise and allow a huge DMA windows at 4GB
> >>
> >>  arch/powerpc/include/asm/iommu.h              |   1 +
> >>  arch/powerpc/include/asm/opal-api.h           |  11 +-
> >>  arch/powerpc/include/asm/opal.h               |   2 +
> >>  arch/powerpc/platforms/powernv/pci.h          |   1 +
> >>  include/uapi/linux/vfio.h                     |   2 +
> >>  arch/powerpc/platforms/powernv/opal-call.c    |   2 +
> >>  arch/powerpc/platforms/powernv/pci-ioda-tce.c |   4 +-
> >>  arch/powerpc/platforms/powernv/pci-ioda.c     | 219 ++++++++++++++----
> >>  drivers/vfio/vfio_iommu_spapr_tce.c           |  10 +-
> >>  9 files changed, 202 insertions(+), 50 deletions(-)
> >>
> >=20
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--tv2SIFopg1r47n4a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl4o9CoACgkQbDjKyiDZ
s5IoBRAAxW76DPH88n1mYxAySWeYWKFjnlj2Ux3ZK8149IQJ6BRRsoUp/LytS+TC
IaCJECsiFjyy6RnxKr4YffqLCYNgjWKfDe/GfKfdUHuhWXOQg5W1qLyMOcmHmE7a
SojAlmouKYalFzuziIuXzlrD+7Evbzwc+oEs2Hh/vM8AAWzjgpExPrmvrv98DRAV
fTikygE92DE+iDJX0UiW88sdI7+MfSsGQWBM/Zq841d9CHDx7rnZFMmoFFttuw/I
tUPT9XX0o0R3xFveaG+KUwUeEb+s0OMZ+Q99rsa/erh9Yu0sSjgtH7NmsDL6OaM7
GqDmncC4KGeCUKTG/L8dgq+50cBTIgdZc3/+j3MFZ5Kz1P1wh+JRFBwNS8XlZ7vq
zzxw5c3pVntwHahQZOCHAKS3yp+X9Inc7h5KkKUmylQaGanB4U8McxQG0ZblJJhW
PA6T7qFAP53OkoJkSb4wrGW0au0lH5q6aoWpxcq3Fr/L20qdP5Cp8TMV86mI8Mws
2J1R5lH/gHkyatyVPu+2DBm5ZQaeKWITtgnm7x9lpXLz7dPsfVJd9HwllaTW5ZgQ
6CELRA/yE8VOsFwl4Qm4Pimxt8Jv5J+9Fb1JWgxIC0O7Izp34LOr7jFRR7hlbDRU
VG7w5wILBAmzdm+2ZAtEei08WIhvzDxgY8MG/HriUqQBRajWwzQ=
=fRHa
-----END PGP SIGNATURE-----

--tv2SIFopg1r47n4a--
