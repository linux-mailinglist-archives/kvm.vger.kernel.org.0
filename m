Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DD22F40E7
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 02:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbhAMBCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 20:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbhAMBBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 20:01:47 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F57C061794
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 17:01:06 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DFpz53FMHz9sVr; Wed, 13 Jan 2021 12:00:48 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610499649;
        bh=wkBYY9xj6Bfrq3fJ0mt//edwkHa6ngCQWYkWyJl5XII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gtrf8rVO2ElF3N8dB2VzaklFBgj0rLV5fHE1H9KVPIFy5Vm/oN8+tZM6/lVOm1oee
         Y7c9KIF+BxVkl3s/JZmykU2Gkji7hg3+Gtpd5mAarDPl8QPGzRJGkytnIh0OkdiCFa
         CRaZLRkAUNLPNZRM7qbVcKYqyCmFDsWtvnLROR/k=
Date:   Wed, 13 Jan 2021 11:52:36 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc:     pasic@linux.ibm.com, brijesh.singh@amd.com, pair@us.ibm.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org, andi.kleen@intel.com,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>, frankja@linux.ibm.com,
        thuth@redhat.com, Christian Borntraeger <borntraeger@de.ibm.com>,
        mdroth@linux.vnet.ibm.com, richard.henderson@linaro.org,
        kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, mst@redhat.com,
        qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
Subject: Re: [PATCH v6 10/13] spapr: Add PEF based confidential guest support
Message-ID: <20210113005236.GB435587@yekko.fritz.box>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
 <20210112044508.427338-11-david@gibson.dropbear.id.au>
 <20210112095612.GE1360503@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <20210112095612.GE1360503@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 12, 2021 at 09:56:12AM +0000, Daniel P. Berrang=E9 wrote:
> On Tue, Jan 12, 2021 at 03:45:05PM +1100, David Gibson wrote:
> > Some upcoming POWER machines have a system called PEF (Protected
> > Execution Facility) which uses a small ultravisor to allow guests to
> > run in a way that they can't be eavesdropped by the hypervisor.  The
> > effect is roughly similar to AMD SEV, although the mechanisms are
> > quite different.
> >=20
> > Most of the work of this is done between the guest, KVM and the
> > ultravisor, with little need for involvement by qemu.  However qemu
> > does need to tell KVM to allow secure VMs.
> >=20
> > Because the availability of secure mode is a guest visible difference
> > which depends on having the right hardware and firmware, we don't
> > enable this by default.  In order to run a secure guest you need to
> > create a "pef-guest" object and set the confidential-guest-support
> > property to point to it.
> >=20
> > Note that this just *allows* secure guests, the architecture of PEF is
> > such that the guest still needs to talk to the ultravisor to enter
> > secure mode.  Qemu has no directl way of knowing if the guest is in
> > secure mode, and certainly can't know until well after machine
> > creation time.
> >=20
> > To start a PEF-capable guest, use the command line options:
> >     -object pef-guest,id=3Dpef0 -machine confidential-guest-support=3Dp=
ef0
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  docs/confidential-guest-support.txt |   2 +
> >  docs/papr-pef.txt                   |  30 ++++++++
> >  hw/ppc/meson.build                  |   1 +
> >  hw/ppc/pef.c                        | 115 ++++++++++++++++++++++++++++
> >  hw/ppc/spapr.c                      |  10 +++
> >  include/hw/ppc/pef.h                |  26 +++++++
> >  target/ppc/kvm.c                    |  18 -----
> >  target/ppc/kvm_ppc.h                |   6 --
> >  8 files changed, 184 insertions(+), 24 deletions(-)
> >  create mode 100644 docs/papr-pef.txt
> >  create mode 100644 hw/ppc/pef.c
> >  create mode 100644 include/hw/ppc/pef.h
> >=20
>=20
> > +static const TypeInfo pef_guest_info =3D {
> > +    .parent =3D TYPE_OBJECT,
> > +    .name =3D TYPE_PEF_GUEST,
> > +    .instance_size =3D sizeof(PefGuestState),
> > +    .interfaces =3D (InterfaceInfo[]) {
> > +        { TYPE_CONFIDENTIAL_GUEST_SUPPORT },
> > +        { TYPE_USER_CREATABLE },
> > +        { }
> > +    }
> > +};
>=20
> IIUC, the earlier patch defines TYPE_CONFIDENTIAL_GUEST_SUPPORT
> as a object, but you're using it as an interface here. The later
> s390 patch uses it as a parent, which makes more sense given it
> is a declared as an object.

Oops, that's a holdover from an earlier version that used an
interface.  Fixed.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/+RFMACgkQbDjKyiDZ
s5LvuxAAyRTJWPRlsPZk3Z6TVqLINqqoS5zKxrOn/BMIT2+NrEmgtvGCUOKYJyPY
nZsQU+TADx1pUsw/TLJZb4k54gCwh7/M4R0Tm6NQQSibmHGT+kbD+DUsj54R8T3v
w43iiuD8tra5hRAlj7Z6sySENUEeZ9+op30SpSiNL74TNsB/w/yh2jOlAYOxtf1x
c6rcFtFLhaI2iRJZfIRmRKDfSkUue5a0gUYgVbp2/MG5bWPqp6bLHmxO7o6JPhJ4
CsWoKT/YBXgCw6SZRmrhrSC4+S3aEPtbOKGuiaXn1yP3XGYZ1Cw3iysRDt5U6mst
vwX2DDrPtxcAaQjl7qBrNsJz71Tm1lXHigqq3J0cWt//K1qEy1DGXBK9BZTvfLWT
NOffzPverudTufv0qj2PP5LTyjFKeg8MIEXMaKl66yZk2b+cDCaykF4vZl4vNcYF
nDZSNxisXImkUZPc1SDzzjmKc+jBuqFeSjf/5l11w9Gq73ZZ42onBxTJL6kGYT8c
B7NPyBWF0Agjf3QI6PYqmKrtB6nAKlb8giU+gmPYmd+YyhjUgWI82TTUL9ckM0Rk
k3QpXLFSStOJwbOzn5qCwK0FbbsC4T64aeuC13XlnTH8pqvnfVPRCoOG5Y3/zkc0
La3DA49Gponwrx7n0gYQIkxNPn3kbVyb9Npr5X6y7eZMQj8qcs8=
=I5Rq
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
