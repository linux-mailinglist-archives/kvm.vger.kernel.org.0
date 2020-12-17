Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C402DCC4A
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 07:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgLQGBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 01:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbgLQGBK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 01:01:10 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6C9C061282
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 22:00:30 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4CxLvJ1MvKz9sVl; Thu, 17 Dec 2020 17:00:28 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1608184828;
        bh=SCdFG7wfWEGj/VqMV6BsCwsSGbljQ30coTR6aK96sAM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=akc8pY1Z5OFnMwwr6cKU2dcfvFDNTa+1K2yaA6Ru4wcl14uIXqnXcm0NnuZL/p6w0
         b2ZewdH/P0dKHnt+VdtZV5D5Ygc1dPbFxwlRJ1Ri+01qOF2VDiobOvYrai8u2fTwvA
         p1oFmf5vPtP2yOq4Aczi60ux/wMuBsF/2EjONU8M=
Date:   Thu, 17 Dec 2020 16:54:42 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        borntraeger@de.ibm.com, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        pasic@linux.ibm.com
Subject: Re: [for-6.0 v5 13/13] s390: Recognize securable-guest-memory option
Message-ID: <20201217055442.GJ310465@yekko.fritz.box>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <20201204054415.579042-14-david@gibson.dropbear.id.au>
 <20201215124526.7c33dc8d.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Xssso5lpTBgMxDfe"
Content-Disposition: inline
In-Reply-To: <20201215124526.7c33dc8d.cohuck@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Xssso5lpTBgMxDfe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 15, 2020 at 12:45:26PM +0100, Cornelia Huck wrote:
> On Fri,  4 Dec 2020 16:44:15 +1100
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > At least some s390 cpu models support "Protected Virtualization" (PV),
> > a mechanism to protect guests from eavesdropping by a compromised
> > hypervisor.
> >=20
> > This is similar in function to other mechanisms like AMD's SEV and
> > POWER's PEF, which are controlled bythe "securable-guest-memory" machine
>=20
> s/bythe/by the/
>=20
> > option.  s390 is a slightly special case, because we already supported
> > PV, simply by using a CPU model with the required feature
> > (S390_FEAT_UNPACK).
> >=20
> > To integrate this with the option used by other platforms, we
> > implement the following compromise:
> >=20
> >  - When the securable-guest-memory option is set, s390 will recognize i=
t,
> >    verify that the CPU can support PV (failing if not) and set virtio
> >    default options necessary for encrypted or protected guests, as on
> >    other platforms.  i.e. if securable-guest-memory is set, we will
> >    either create a guest capable of entering PV mode, or fail outright
>=20
> s/outright/outright./
>=20
> >=20
> >  - If securable-guest-memory is not set, guest's might still be able to
>=20
> s/guest's/guests/

All those corrected, thanks.

> >    enter PV mode, if the CPU has the right model.  This may be a
> >    little surprising, but shouldn't actually be harmful.
> >=20
> > To start a guest supporting Protected Virtualization using the new
> > option use the command line arguments:
> >     -object s390-pv-guest,id=3Dpv0 -machine securable-guest-memory=3Dpv0
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  hw/s390x/pv.c         | 58 +++++++++++++++++++++++++++++++++++++++++++
> >  include/hw/s390x/pv.h |  1 +
> >  target/s390x/kvm.c    |  3 +++
> >  3 files changed, 62 insertions(+)
> >=20
>=20
> Modulo any naming changes etc., I think this should work for s390. I
> don't have the hardware to test this, however, and would appreciate
> someone with a PV setup giving this a go.

Makes sense.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Xssso5lpTBgMxDfe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/a8qIACgkQbDjKyiDZ
s5JVKA/+NUxCSZI+jxu/gNKssDK/SZQeOXadmUeqtIYB0ZQqhxgvSz1kbihCShI7
8jRD/oFQfZ7oI4NU3EVQmSwQhU1iZ4z7nnDtXZSQrGzTU1TjDD8t4kuHWpQ6btQd
y7fVsFjZGacWUFEY2OVsjRhAuf3hWtj8lWAoDFGjIhYTnxXdIWgG3cxIf5AZnMqO
xAOwqP4cFjPBuHUBdrZv3nYwzz3saACOYFP4DLK8TB5oEIF3X8cBC46pK/ayiSIx
3QNn5tXf2Kl316ljawMc+dIp0apOd/TB1Kx8PT8Bdt8F9evHINoRqOo6/9kMKvB/
fALgfaVlWNwIWJpHy2RqqmHzs7HxXOPdlAhOWgkQd7+zvrEH6WGgLfHYNaMpSVVP
aq0x0RjiEitC4UHLGy84cWtQNpJD7vqZMdMsSN9YwQswBJ3YQM30KblFSjGg6Zzs
vtXf0qzLoW2A4XXOVk2m1UrstUaJJKDeIZH3YYh75fepifIoOyK2s79bk5YaBbCf
BIdOX918mn2ewOlDxtt0QkrLD9+tWAwHa+WUqdXIq0PW31TKpjZO4T17ItJoo1KL
q3DV1RBZ7IUTGXkENH4sR22ljOkhE0ko3RLlZqZHY7XpjsskgPTI+ChOe1JzRL1o
m7Yw1UT29HoiMZcwAn4PMe/s3AHNSEBO/016jPo+H2psNK55h1w=
=lYOB
-----END PGP SIGNATURE-----

--Xssso5lpTBgMxDfe--
