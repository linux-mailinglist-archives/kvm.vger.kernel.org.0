Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E933651CC
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 08:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfGKGV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 02:21:28 -0400
Received: from ozlabs.org ([203.11.71.1]:55691 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbfGKGV1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 02:21:27 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 45kmCm5G01z9sNF; Thu, 11 Jul 2019 16:21:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1562826084;
        bh=C09pNryVDcEasgvucopMJO755obTYZIg19F3P5zVW04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EA6kGwLjJnJNreSKh/a29tQPH00GLOZszZK1dmYlhGDeiEEOJ4ugAAfOJzKO4s6HD
         3MNS4Bri3Si9Kl+/cuxG0FrI4oLMJPo+OS7T4Oo78BECDUVPD+A4tV2LUqueWuI6uP
         JVU7H5e8hdg8r3Oviul3hBYblb5+SUy9GEWz3z08=
Date:   Thu, 11 Jul 2019 13:51:51 +1000
From:   "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Peter Xu <zhexu@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v1 03/18] hw/pci: introduce PCIPASIDOps to PCIDevice
Message-ID: <20190711035151.GG13271@umbus.fritz.box>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-4-git-send-email-yi.l.liu@intel.com>
 <20190709021209.GA5178@xz-x1>
 <A2975661238FB949B60364EF0F2C257439F2A5F2@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1XWsVB21DFCvn2e8"
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C257439F2A5F2@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--1XWsVB21DFCvn2e8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2019 at 11:08:15AM +0000, Liu, Yi L wrote:
> > From: Peter Xu [mailto:zhexu@redhat.com]
> > Sent: Tuesday, July 9, 2019 10:12 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [RFC v1 03/18] hw/pci: introduce PCIPASIDOps to PCIDevice
> >=20
> > On Fri, Jul 05, 2019 at 07:01:36PM +0800, Liu Yi L wrote:
> > > +void pci_setup_pasid_ops(PCIDevice *dev, PCIPASIDOps *ops)
> > > +{
> > > +    assert(ops && !dev->pasid_ops);
> > > +    dev->pasid_ops =3D ops;
> > > +}
> > > +
> > > +bool pci_device_is_ops_set(PCIBus *bus, int32_t devfn)
> >=20
> > Name should be "pci_device_is_pasid_ops_set".  Or maybe you can simply
> > drop this function because as long as you check it in helper functions
> > like [1] below always then it seems even unecessary.
>=20
> yes, the name should be "pci_device_is_pasid_ops_set". I noticed your
> comments on the necessity in another, let's talk in that thread. :-)
>=20
> > > +{
> > > +    PCIDevice *dev;
> > > +
> > > +    if (!bus) {
> > > +        return false;
> > > +    }
> > > +
> > > +    dev =3D bus->devices[devfn];
> > > +    return !!(dev && dev->pasid_ops);
> > > +}
> > > +
> > > +int pci_device_request_pasid_alloc(PCIBus *bus, int32_t devfn,
> > > +                                   uint32_t min_pasid, uint32_t max_=
pasid)
> >=20
> > From VT-d spec I see that the virtual command "allocate pasid" does
> > not have bdf information so it's global, but here we've got bus/devfn.
> > I'm curious is that reserved for ARM or some other arch?
>=20
> You are right. VT-d spec doesn=E2=80=99t have bdf info. But we need to pa=
ss the
> allocation request via vfio. So this function has bdf info. In vIOMMU sid=
e,
> it should select a vfio-pci device and invoke this callback when it wants=
 to
> request PASID alloc/free.

That doesn't seem conceptually right.  IIUC, the pasids "belong" to a
sort of SVM context.  It seems to be the alloc should be on that
object - and that object would already have some connection to any
relevant vfio containers.  At the vfio level this seems like it should
be a container operation rather than a device operation.

> > > +{
> > > +    PCIDevice *dev;
> > > +
> > > +    if (!bus) {
> > > +        return -1;
> > > +    }
> > > +
> > > +    dev =3D bus->devices[devfn];
> > > +    if (dev && dev->pasid_ops && dev->pasid_ops->alloc_pasid) {
> >=20
> > [1]
> >=20
> > > +        return dev->pasid_ops->alloc_pasid(bus, devfn, min_pasid, ma=
x_pasid);
>=20
> Thanks,
> Yi Liu

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--1XWsVB21DFCvn2e8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl0mslQACgkQbDjKyiDZ
s5Ll4RAAsJu80EXwInQoQipnmogNk7gVlfZBJqyD+3Ib85mIrnfk2vTqhs+Z/Z0N
ytVwIvKYcHGD12/A8dKCBoJ9Dyr6Xb1veSKSdpcpIePNqWamWs+m2qIrvbP94QCU
OsLS1uwyAm12MB4/tINkCbcoLCXYTFolNOpS10Iy3WB1aARNI1C8h02UbWQfPgGS
lyYEmdjZ178Yh08bR8UYnHQFju8qavJVDmXf9u7bLrmHwwaI8SehNWxV4YBIfgVK
eJUE/2HL4QwNX4pZpu+gKohunNc4pv1ZgQ3t61zFz1TRMW/H1x9K8hIlTgEG83ta
2qcH3eIdrTEaTDtEdjBETTEgAZ2Ig9XeopXb7/HgI1JT3Lpg9xW+fhKXPZp+6Az/
XxPt4zaGZXt1P3QEYSfpTw/Vhk2+9Pna+Cj7WbTK+ahHbZBVRXUGRmRX+jHuPCz/
1YyQuhl+5omobHhUmNpOVestYnWgheq2WACgLtA3Isyo35FmEgLv/nNCPz2CmaLV
+h3CWfXcyBUm03XegPAIJH2TxOumcmsZW9zFvjpjyucvPgb2IhCT5HaSv16nWwTM
VRhL5eLeVRzfoXOS1hI99NsdVGeWP0Xtqj7aQdacMZUfysC9EJR4RzNwlGLyAT2s
XzZ8M946yUCiRhziYCCZUVajA9fsvBxRJBCaFPnIXsnpbA1qV5M=
=ete9
-----END PGP SIGNATURE-----

--1XWsVB21DFCvn2e8--
