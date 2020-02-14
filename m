Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2C215D1B4
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 06:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgBNFga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 00:36:30 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:35057 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgBNFga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 00:36:30 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 48JhvH4G3Qz9sRN; Fri, 14 Feb 2020 16:36:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1581658587;
        bh=zNdoB9TvN56rRqasUcuUJ/reZPQdWn4eEGEbEQxhf7g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xq4sSZ6yevHWgo7eyJ1ryOK/ibr0X/T3CGbch9K+3d9L0fY9I3uttzAelX1yBn7qU
         yQgy3rwNZHik1vXlUfyHex04RdUf4MX7H3BSoAy5QLSYs6O+TunsyBEoQZsazSKx1Y
         YBAni/lQhFydDEh8axlaW+3rPC2aS27BnZYOQ6HE=
Date:   Fri, 14 Feb 2020 16:36:20 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Peter Xu <peterx@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v3 03/25] hw/iommu: introduce IOMMUContext
Message-ID: <20200214053620.GR124369@umbus.fritz.box>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-4-git-send-email-yi.l.liu@intel.com>
 <20200131040644.GG15210@umbus.fritz.box>
 <A2975661238FB949B60364EF0F2C25743A199306@SHSMSX104.ccr.corp.intel.com>
 <20200211165843.GG984290@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A1BA4D8@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="teKjxxMjPsACTz/N"
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A1BA4D8@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--teKjxxMjPsACTz/N
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2020 at 07:15:13AM +0000, Liu, Yi L wrote:
> Hi Peter,
>=20
> > From: Peter Xu <peterx@redhat.com>
> > Sent: Wednesday, February 12, 2020 12:59 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [RFC v3 03/25] hw/iommu: introduce IOMMUContext
> >=20
> > On Fri, Jan 31, 2020 at 11:42:13AM +0000, Liu, Yi L wrote:
> > > > I'm not very clear on the relationship betwen an IOMMUContext and a
> > > > DualStageIOMMUObject.  Can there be many IOMMUContexts to a
> > > > DualStageIOMMUOBject?  The other way around?  Or is it just
> > > > zero-or-one DualStageIOMMUObjects to an IOMMUContext?
> > >
> > > It is possible. As the below patch shows, DualStageIOMMUObject is per=
 vfio
> > > container. IOMMUContext can be either per-device or shared across dev=
ices,
> > > it depends on vendor specific vIOMMU emulators.
> >=20
> > Is there an example when an IOMMUContext can be not per-device?
>=20
> No, I don=E2=80=99t have such example so far. But as IOMMUContext is got =
=66rom
> pci_device_iommu_context(),  in concept it possible to be not per-device.
> It is kind of leave to vIOMMU to decide if different devices could share a
> single IOMMUContext.

On the "pseries" machine the vIOMMU only has one set of translations
for a whole virtual PCI Host Bridge (vPHB).  So if you attach multiple
devices to a single vPHB, I believe you'd get multiple devices in an
IOMMUContext.  Well.. if we did the PASID stuff, which we don't at the
moment.

Note that on pseries on the other hand it's routine to create multiple
vPHBs, rather than multiple PCI roots being an oddity as it is on x86.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--teKjxxMjPsACTz/N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl5GMdQACgkQbDjKyiDZ
s5IT8hAAnJ3xZrpCbLQPvNZEpIYEhNe6qkpg2XIs9Wqs17VvHamJfhvLtB7rRaxq
bwvkgKRWB971L16f3nnY4IH85UZDRcNLHmsNE4eQJ7s+emgnboH6hXpTeJO0i/8M
7cL2zF6HtG7hNyCxGJgJw3qmz2ejik/jDUdlf4NFi+sOjl3y0TW6urTCXFXVRGSZ
eXhA1TrQCgdDVsPeXize3n4GZNkbI91lVX1Si6TKtIDmmwanWPZD1vZ1Oq42jlPt
Yqm7IeWuEf983d0PUC4QTZei/vbbPknNsMSX7fWCRtjgtz5Lf8flHY2Cns6VYoXu
TvqDIA4xOOG1vcehBFC4cuPAxvyvtw4OqkTyMoQCDQ6z/kN15MmCVzmOEw0Dedhj
z98Eb74lEycq3ppjp01XmFCyJWr3wAiz5pCRIYz78Hw+YREODi0jirdcJm4KtdOd
98AjHzTRjqNHVXTcCE8o0XiM7iBPzcZLHma9N3+Re1csdyRzkh+so315eqpGHlM8
pmPnMfKuipI0Fe9l8P02/rLlDhBz/rKJl94qAb3Gk4fCwC+lZpvziqgFVOrQVZbt
yv05tqcHoPheIYjlKlR6uxO6Ro2aTExHr2WEGXTUlnljcoudCaDzk3xiFPQ0nQcE
Xcul1RsnD/5mKDzEllr5LIP4F9cHPAM8jNfecK7nE8s4iAg9Bpo=
=JD+i
-----END PGP SIGNATURE-----

--teKjxxMjPsACTz/N--
