Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735922F40E6
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 02:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbhAMBCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 20:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbhAMBBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 20:01:47 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0D0C061575
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 17:01:06 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DFpz61Clgz9sj5; Wed, 13 Jan 2021 12:00:49 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610499650;
        bh=iN/1tBP7XcnEnLSGX4Z2fu1vc1PYRuAZwRjtQ+j+2C8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QkcvbYWGUJnkeJogctx6aoZIzy8MTNjmP/wL3xYIa+HQCTpYyhAa98D157bbj3EuH
         Wm0TROZVqOQnUtsWC9LZPV2/vCJ1/STkrOwbjAY2of/YjWJdGZUwFCxUCqU9URDJuG
         mz+j+taQlmTWKtM1hu3nbO0+Qsiv/xeHhSUsKgGo=
Date:   Wed, 13 Jan 2021 11:57:48 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        pasic@linux.ibm.com, brijesh.singh@amd.com, pair@us.ibm.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org, andi.kleen@intel.com,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>, frankja@linux.ibm.com,
        thuth@redhat.com, mdroth@linux.vnet.ibm.com,
        richard.henderson@linaro.org, kvm@vger.kernel.org,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        mst@redhat.com, qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
Subject: Re: [PATCH v6 13/13] s390: Recognize confidential-guest-support
 option
Message-ID: <20210113005748.GD435587@yekko.fritz.box>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
 <20210112044508.427338-14-david@gibson.dropbear.id.au>
 <fcafba03-3701-93af-8eb7-17bd0d14d167@de.ibm.com>
 <20210112123607.39597e3d.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HWvPVVuAAfuRc6SZ"
Content-Disposition: inline
In-Reply-To: <20210112123607.39597e3d.cohuck@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--HWvPVVuAAfuRc6SZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 12, 2021 at 12:36:07PM +0100, Cornelia Huck wrote:
65;6201;1c> On Tue, 12 Jan 2021 09:15:26 +0100
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>=20
> > On 12.01.21 05:45, David Gibson wrote:
> > > At least some s390 cpu models support "Protected Virtualization" (PV),
> > > a mechanism to protect guests from eavesdropping by a compromised
> > > hypervisor.
> > >=20
> > > This is similar in function to other mechanisms like AMD's SEV and
> > > POWER's PEF, which are controlled by the "confidential-guest-support"
> > > machine option.  s390 is a slightly special case, because we already
> > > supported PV, simply by using a CPU model with the required feature
> > > (S390_FEAT_UNPACK).
> > >=20
> > > To integrate this with the option used by other platforms, we
> > > implement the following compromise:
> > >=20
> > >  - When the confidential-guest-support option is set, s390 will
> > >    recognize it, verify that the CPU can support PV (failing if not)
> > >    and set virtio default options necessary for encrypted or protected
> > >    guests, as on other platforms.  i.e. if confidential-guest-support
> > >    is set, we will either create a guest capable of entering PV mode,
> > >    or fail outright.
> > >=20
> > >  - If confidential-guest-support is not set, guests might still be
> > >    able to enter PV mode, if the CPU has the right model.  This may be
> > >    a little surprising, but shouldn't actually be harmful.
> > >=20
> > > To start a guest supporting Protected Virtualization using the new
> > > option use the command line arguments:
> > >     -object s390-pv-guest,id=3Dpv0 -machine confidential-guest-suppor=
t=3Dpv0 =20
> >=20
> >=20
> > This results in
> >=20
> > [cborntra@t35lp61 qemu]$ qemu-system-s390x -enable-kvm -nographic -m 2G=
 -kernel ~/full.normal=20
> > **
> > ERROR:../qom/object.c:317:type_initialize: assertion failed: (parent->i=
nstance_size <=3D ti->instance_size)
> > Bail out! ERROR:../qom/object.c:317:type_initialize: assertion failed: =
(parent->instance_size <=3D ti->instance_size)
> > Aborted (core dumped)
> >=20
>=20
> > > +static const TypeInfo s390_pv_guest_info =3D {
> > > +    .parent =3D TYPE_CONFIDENTIAL_GUEST_SUPPORT,
> > > +    .name =3D TYPE_S390_PV_GUEST,
> > > +    .instance_size =3D sizeof(S390PVGuestState),
> > > +    .interfaces =3D (InterfaceInfo[]) {
> > > +        { TYPE_USER_CREATABLE },
> > > +        { }
> > > +    }
> > > +};
>=20
> I think this needs TYPE_OBJECT in .parent and
> TYPE_CONFIDENTIAL_GUEST_SUPPORT as an interface to fix the crash.

No, that was true of an earlier revision, but parent is correct in the
current version.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--HWvPVVuAAfuRc6SZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/+RYwACgkQbDjKyiDZ
s5KbWA/+M3AIG++0nTrqi4hWo4jTQx4KE9/yIGXlbfcN/MH/ziivMWcKrCIFPbiP
Pk9pzdVDKy4sg5Mxw0zYPlo/iAiUuOge8tSYSyQSwsCLOVB7VYG9ArBBsd957sF4
7kFnq8joiiTza9RHbrzCms3xFJmy4kJEqq0ucrA39Httb+IgaOJfusRG/POjLfEa
WHB74CHfO0L/V47VLmV2yC+l2lRgZm04uCABlZ7MNQq87wIdzEUHco6YA89dhPTm
4zjQl4K6P+/WrZ+6a5SSDgpcDe1qAd9IY+atnANo2XkYcUQEVMWnJMiVzD15Zy9L
FdYK+f8e28j3LJIoDPLXHca9gpKyY02CTtDS55OhWrfUloRjapMQbct72f1bPsMy
JxHTGKY8sKEFnecma3Tlc+qjovODHav4KgRr29KPHPrjAqNvZFAMK2tR2ge976Ld
7nvqiznT4kwbJLRJ1w9V64+FC1z22o2OEkxeVjOvwtx0PpE9WJqQNInfmPfS2YVL
4IAVyillo5stvE/SOcNzD3XpyZ/RaTd8A/ue8F84DZWsaJF4Q7NlL2sRPLkrFDt3
mH9+x8ul+HoNrz+ynK0dykr4H2R0YvsILuny+imnPc5q2Sc7lUKKpnWMofwloIYY
sM0h9vdXnAVhMa6vQm/avOC0M8on1GW0fJMf4Cymv+a/zsi7SK0=
=+4Rz
-----END PGP SIGNATURE-----

--HWvPVVuAAfuRc6SZ--
