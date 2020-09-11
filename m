Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828E2265628
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 02:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725613AbgIKAsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 20:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgIKAsp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 20:48:45 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD8BC061573
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 17:48:44 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4BncZK4ls8z9sVD; Fri, 11 Sep 2020 10:48:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1599785321;
        bh=ecH29wFHn7fDBKuWTIFIR7OnasRWCj9Prh0xecXMRTk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MiCHd9SlCXqSnYeoNWJqW+wNvLDa9CeQzk36UP+UshrL0Pq9d/z2e6zv7c9nnIQ6D
         musbknKQseEZ0syGNn1K79f824cFu9OX69L07eHrfuerTIELlpkv5SP9XDTlpwo8HW
         Ui7IppjTl8lNkjFjR7Z3IRp45gayu92RHQVRff5I=
Date:   Fri, 11 Sep 2020 10:07:18 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, dgilbert@redhat.com,
        frankja@linux.ibm.com, pair@us.ibm.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, brijesh.singh@amd.com, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, "Michael S. Tsirkin" <mst@redhat.com>,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        mdroth@linux.vnet.ibm.com, Thomas Huth <thuth@redhat.com>
Subject: Re: [for-5.2 v4 10/10] s390: Recognize host-trust-limitation option
Message-ID: <20200911000718.GF66834@yekko.fritz.box>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
 <20200724025744.69644-11-david@gibson.dropbear.id.au>
 <20200907172253.0a51f5f7.pasic@linux.ibm.com>
 <20200910133609.4ac88c25.cohuck@redhat.com>
 <20200910202924.3616935a.pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/aVve/J9H4Wl5yVO"
Content-Disposition: inline
In-Reply-To: <20200910202924.3616935a.pasic@linux.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--/aVve/J9H4Wl5yVO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2020 at 08:29:24PM +0200, Halil Pasic wrote:
> On Thu, 10 Sep 2020 13:36:09 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
>=20
> > On Mon, 7 Sep 2020 17:22:53 +0200
> > Halil Pasic <pasic@linux.ibm.com> wrote:
> >=20
> > > On Fri, 24 Jul 2020 12:57:44 +1000
> > > David Gibson <david@gibson.dropbear.id.au> wrote:
> > >=20
> > > > At least some s390 cpu models support "Protected Virtualization" (P=
V),
> > > > a mechanism to protect guests from eavesdropping by a compromised
> > > > hypervisor.
> > > >=20
> > > > This is similar in function to other mechanisms like AMD's SEV and
> > > > POWER's PEF, which are controlled bythe "host-trust-limitation"
> > > > machine option.  s390 is a slightly special case, because we already
> > > > supported PV, simply by using a CPU model with the required feature
> > > > (S390_FEAT_UNPACK).
> > > >=20
> > > > To integrate this with the option used by other platforms, we
> > > > implement the following compromise:
> > > >=20
> > > >  - When the host-trust-limitation option is set, s390 will recognize
> > > >    it, verify that the CPU can support PV (failing if not) and set
> > > >    virtio default options necessary for encrypted or protected gues=
ts,
> > > >    as on other platforms.  i.e. if host-trust-limitation is set, we
> > > >    will either create a guest capable of entering PV mode, or fail
> > > >    outright =20
> > >=20
> > > Shouldn't we also fail outright if the virtio features are not PV
> > > compatible (invalid configuration)?
> > >=20
> > > I would like to see something like follows as a part of this series.
> > > ----------------------------8<--------------------------
> > > From: Halil Pasic <pasic@linux.ibm.com>
> > > Date: Mon, 7 Sep 2020 15:00:17 +0200
> > > Subject: [PATCH] virtio: handle host trust limitation
> > >=20
> > > If host_trust_limitation_enabled() returns true, then emulated virtio
> > > devices must offer VIRTIO_F_ACCESS_PLATFORM, because the device is not
> > > capable of accessing all of the guest memory. Otherwise we are in
> > > violation of the virtio specification.
> > >=20
> > > Let's fail realize if we detect that VIRTIO_F_ACCESS_PLATFORM feature=
 is
> > > obligatory but missing.
> > >=20
> > > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > > ---
> > >  hw/virtio/virtio.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >=20
> > > diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> > > index 5bd2a2f621..19b4b0a37a 100644
> > > --- a/hw/virtio/virtio.c
> > > +++ b/hw/virtio/virtio.c
> > > @@ -27,6 +27,7 @@
> > >  #include "hw/virtio/virtio-access.h"
> > >  #include "sysemu/dma.h"
> > >  #include "sysemu/runstate.h"
> > > +#include "exec/host-trust-limitation.h"
> > > =20
> > >  /*
> > >   * The alignment to use between consumer and producer parts of vring.
> > > @@ -3618,6 +3619,12 @@ static void virtio_device_realize(DeviceState =
*dev, Error **errp)
> > >      /* Devices should either use vmsd or the load/save methods */
> > >      assert(!vdc->vmsd || !vdc->load);
> > > =20
> > > +    if (host_trust_limitation_enabled(MACHINE(qdev_get_machine()))
> > > +        && !virtio_host_has_feature(vdev, VIRTIO_F_IOMMU_PLATFORM)) {
> > > +        error_setg(&err, "devices without VIRTIO_F_ACCESS_PLATFORM a=
re not compatible with host trust imitation");
> > > +        error_propagate(errp, err);
> > > +        return;
> >=20
> > How can we get here? I assume only if the user explicitly turned the
> > feature off while turning HTL on, as otherwise patch 9 should have
> > taken care of it?
> >=20
>=20
> Yes, we can get here only if iommu_platform is explicitly turned off.

Right.. my assumption was that if you really want to specify
contradictory options, you get to keep both pieces.  Or, more
seriously, there might be some weird experimental cases where this
combination could do something useful if you really know what you're
doing, and explicitly telling qemu to do this implies you know what
you're doing.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--/aVve/J9H4Wl5yVO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl9av7QACgkQbDjKyiDZ
s5KUdA//eTOLAq2vCeftME7tezJbgx3MkmP7eAQdwQNSnnlozRafbKEbRqgrnX9h
5mwHktZAnL085yz/UVaHQ8TM+OdE3qcdZAMbSCPLr+p8WiP81J/Tw8jFt8FjQO/G
eBJrs/tiaR1EMhmRB40N7cEJL2FPI4l9EZoffESbkoowlOPw9vhlW7SCL/yOicI+
+KwViTJpUtAdTfPifgkbshCUk2Hv87KcueXYpCbMZAc5pt/1nwQqgr+VP/MFpsgU
lZ3fgj1Zd8hi+VaJzW2ckcZaCPlyGF8df+21sqV9q5XzjWizhyykCwt8XUB2CmTU
WhWpwrQwYYFRgRCbALT/bp6m8BiQ1J2RKVTXsbqI/TVYzIZRUcoV90iUdYFUGrsK
TW2h+CvOa2uY1MPuQxxI7VV73B4TQ7rfDpuHjmHdbqF/PmgooZLFcNzJ8j1mHdit
th6oy9kOoosfMCvoBLWwNM8IY34Ox0q60Ero5TeByToslwgHUOdflzpVyXVHZz55
UYUx+n84DCsv6fKE49ch5zd1S1AJEYYIoHhsBph9ByDvSKDsaEqdfcad6eq7tD24
Vgo3uFiuQahG4xX0vWCNVe8Y2KEAGlKaxnxaK8FK5wujBFL5bTsz+z77G9qUTMZs
ywkTlryy4of0u1murp4lLaM2sBq1XFec+ILMgm3QYTxSpFtStro=
=QrIg
-----END PGP SIGNATURE-----

--/aVve/J9H4Wl5yVO--
