Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB3720998D
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 07:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389600AbgFYFrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 01:47:32 -0400
Received: from ozlabs.org ([203.11.71.1]:60719 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389367AbgFYFrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 01:47:31 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49spv468Qqz9sSy; Thu, 25 Jun 2020 15:47:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1593064048;
        bh=QESinVtHA3WjWaRveH+RITe1nVtNFNsNWPr1TKchI0c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=irPTrlQCu8Nlhsv8YkSuWo3Qhxcl1bqL+EufmEonT98Woup90bhBgnS5hfPOiG3xP
         Z7zlc879J6YzNYL/ErnDHCRWqKkGQq1DjP69tEwKF3hd/acX7bJPnrMkpi7otcl8W2
         YYRP97nesMIYxmdCIvi+q72lK/b/GAovgFtFwttE=
Date:   Thu, 25 Jun 2020 15:25:18 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pair@us.ibm.com, pbonzini@redhat.com,
        dgilbert@redhat.com, frankja@linux.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, qemu-ppc@nongnu.org, mst@redhat.com,
        mdroth@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>,
        pasic@linux.ibm.com, Eduardo Habkost <ehabkost@redhat.com>,
        qemu-s390x@nongnu.org
Subject: Re: [PATCH v3 0/9] Generalize memory encryption models
Message-ID: <20200625052518.GD172395@umbus.fritz.box>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <e045e202-cd56-4ddc-8c1d-a2fe5a799d32@redhat.com>
 <20200619114526.6a6f70c6.cohuck@redhat.com>
 <79890826-f67c-2228-e98d-25d2168be3da@redhat.com>
 <20200619120530.256c36cb.cohuck@redhat.com>
 <358d48e5-4c57-808b-50da-275f5e2a352c@redhat.com>
 <20200622140254.0dbe5d8c.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="T7mxYSe680VjQnyC"
Content-Disposition: inline
In-Reply-To: <20200622140254.0dbe5d8c.cohuck@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--T7mxYSe680VjQnyC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 22, 2020 at 02:02:54PM +0200, Cornelia Huck wrote:
> On Fri, 19 Jun 2020 12:10:13 +0200
> David Hildenbrand <david@redhat.com> wrote:
>=20
> > On 19.06.20 12:05, Cornelia Huck wrote:
> > > On Fri, 19 Jun 2020 11:56:49 +0200
> > > David Hildenbrand <david@redhat.com> wrote:
> > >  =20
> > >>>>> For now this series covers just AMD SEV and POWER PEF.  I'm hopin=
g it
> > >>>>> can be extended to cover the Intel and s390 mechanisms as well,
> > >>>>> though.     =20
> > >>>>
> > >>>> The only approach on s390x to not glue command line properties to =
the
> > >>>> cpu model would be to remove the CPU model feature and replace it =
by the
> > >>>> command line parameter. But that would, of course, be an incompati=
ble break.   =20
> > >>>
> > >>> Yuck.
> > >>>
> > >>> We still need to provide the cpu feature to the *guest* in any case=
, no?   =20
> > >>
> > >> Yeah, but that could be wired up internally. Wouldn't consider it cl=
ean,
> > >> though (I second the "overengineered" above). =20
> > >=20
> > > Could an internally wired-up cpu feature be introspected? Also, what =
=20
> >=20
> > Nope. It would just be e.g., a "machine feature" indicated to the guest
> > via the STFL interface/instruction. I was tackling the introspect part
> > when asking David how to sense from upper layers. It would have to be
> > sense via a different interface as it would not longer be modeled as
> > part of CPU features in QEMU.
> >=20
> > > happens if new cpu features are introduced that have a dependency on =
or
> > > a conflict with this one? =20
> >=20
> > Conflict: bail out in QEMU when incompatible options are specified.
> > Dependency: warn and continue/fixup (e.g., mask off?)
>=20
> Masking off would likely be surprising to the user.
>=20
> > Not clean I think.
>=20
> I agree.
>=20
> Still unsure how to bring this new machine property and the cpu feature
> together. Would be great to have the same interface everywhere, but
> having two distinct command line objects depend on each other sucks.

Kinda, but the reality is that hardware - virtual and otherwise -
frequently doesn't have entirely orthogonal configuration for each of
its components.  This is by no means new in that regard.

> Automatically setting the feature bit if pv is supported complicates
> things further.

AIUI, on s390 the "unpack" feature is available by default on recent
models.  In that case you could do this:

 * Don't modify either cpu or HTL options based on each other
 * Bail out if the user specifies a non "unpack" secure CPU along with
   the HTL option

Cases of note:
 - User specifies an old CPU model + htl
   or explicitly sets unpack=3Doff + htl
	=3D> fails with an error, correctly
 - User specifies modern/default cpu + htl, with secure aware guest
 	=3D> works as a secure guest
 - User specifies modern/default cpu + htl, with non secure aware guest
	=3D> works, though not secure (and maybe slower than neccessary)
 - User specifies modern/default cpu, no htl, with non-secure guest
 	=3D> works, "unpack" feature is present but unused
 - User specifies modern/default cpu, no htl, secure guest
  	=3D> this is the worst one.  It kind of works by accident if
	   you've also  manually specified whatever virtio (and
	   anything else) options are necessary. Ugly, but no
	   different from the situation right now, IIUC

> (Is there any requirement that the machine object has been already set
> up before the cpu features are processed? Or the other way around?)

CPUs are usually created by the machine, so I believe we can count on
the machine object being there first.

> Does this have any implications when probing with the 'none' machine?

I'm not sure.  In your case, I guess the cpu bit would still show up
as before, so it would tell you base feature availability, but not
whether you can use the new configuration option.

Since the HTL option is generic, you could still set it on the "none"
machine, though it wouldn't really have any effect.  That is, if you
could create a suitable object to point it at, which would depend on
=2E.. details.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--T7mxYSe680VjQnyC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl70NTwACgkQbDjKyiDZ
s5IEJw//Q3blGapB6G59qbzf4DGYZafe8dSyr3kKvUrTarEftg931msWvmzqwnlp
P6tVVx60exm1x4RSYWYdEZQL5tdBdkvZ+YB7Vk8OLFcPf0ObtNBckImmfJoxeQdC
fsPSoFSjdcSBbOwExw3rh+DB3lLHlkpup1GDGlPszpN3ek3Wp+NIF5jyA31Ojrau
PukGQe+Xf9eIgRrYGFD9iJGaewFFf753vOOUlRi5aX87KlXtqxwZ0HA2tnVSKreq
jGR2ibH/KODsBqZPDmkm+FNdq0VQgC85/otmR3cKDDmPyjnKyhbV9oSjIgXO/SLb
675nG/KBfXSSKBZS0T8BZxy6FB7Z7wn89oLYzBRHmU5OffdjkGuEgEWk2QQDS1fY
GpyrNJstGppcr2fglatDo4wzQKoUXnb7U7Itq2wMfRNlKQ7IhsfthaGRpafTmtLN
ip0oYOz9fRAvag4A3JEuB+Xwkf3XDBNxXzZjy47rUtgSwC9HQZuXcrmM0qRxo+kp
UHAUEaTUNCpyo/suuVzv1CotbDYa0gEt6pi9HMA5nigkZD/5Eb0b2sL6JbqlCgkm
743jSXNVbyXDFz/81siiv16q5vhU7MHCvxJ1uTk+RriMBsoMwfIMtNIQHwtvPvBA
aUeEqFAwDmst6/SNma6xMHnb2WZX62gC60+Ns2kaeNEdvu79wH8=
=o5AP
-----END PGP SIGNATURE-----

--T7mxYSe680VjQnyC--
