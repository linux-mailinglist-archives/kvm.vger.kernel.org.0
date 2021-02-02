Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC6030B556
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 03:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhBBCj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 21:39:28 -0500
Received: from ozlabs.org ([203.11.71.1]:42957 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229543AbhBBCjZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 21:39:25 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DV8Bp20vvz9tk1; Tue,  2 Feb 2021 13:38:42 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612233522;
        bh=VXgvdWMjRdzFgeGR7K2WnC88ggaAzrgpmO2vsSLO/VY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bNK7emVyG+ZfmX+8e7APUMwZc8pY34AolqiThi3zak88l53jlqwlShnW+ykJc2inZ
         WBVuLklVO+rO4l6MTssY39e5tofsWUA/9pZkiv/qugN7vNgNngKqPvQoBDt3bZ7mjO
         ZirAOzqUHVWBMC9dK1yS16x+JT25uGZ1XpifCJ4o=
Date:   Tue, 2 Feb 2021 12:41:16 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        brijesh.singh@amd.com, pair@us.ibm.com, pasic@linux.ibm.com,
        qemu-devel@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>, borntraeger@de.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        berrange@redhat.com, andi.kleen@intel.com
Subject: Re: [PATCH v7 07/13] confidential guest support: Introduce cgs
 "ready" flag
Message-ID: <20210202014116.GC2251@yekko.fritz.box>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
 <20210113235811.1909610-8-david@gibson.dropbear.id.au>
 <20210118194730.GH9899@work-vm>
 <20210119091608.34fff5dc.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FsscpQKzF/jJk6ya"
Content-Disposition: inline
In-Reply-To: <20210119091608.34fff5dc.cohuck@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--FsscpQKzF/jJk6ya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 19, 2021 at 09:16:08AM +0100, Cornelia Huck wrote:
> On Mon, 18 Jan 2021 19:47:30 +0000
> "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
>=20
> > * David Gibson (david@gibson.dropbear.id.au) wrote:
> > > The platform specific details of mechanisms for implementing
> > > confidential guest support may require setup at various points during
> > > initialization.  Thus, it's not really feasible to have a single cgs
> > > initialization hook, but instead each mechanism needs its own
> > > initialization calls in arch or machine specific code.
> > >=20
> > > However, to make it harder to have a bug where a mechanism isn't
> > > properly initialized under some circumstances, we want to have a
> > > common place, relatively late in boot, where we verify that cgs has
> > > been initialized if it was requested.
> > >=20
> > > This patch introduces a ready flag to the ConfidentialGuestSupport
> > > base type to accomplish this, which we verify just before the machine
> > > specific initialization function. =20
> >=20
> > You may find you need to define 'ready' and the answer might be a bit
> > variable; for example, on SEV there's a setup bit and then you may end
> > up doing an attestation and receiving some data before you actaully let
> > the guest execute code.   Is it ready before it's received the
> > attestation response or only when it can run code?
> > Is a Power or 390 machine 'ready' before it's executed the magic
> > instruction to enter the confidential mode?
>=20
> I would consider those machines where the guest makes the transition
> itself "ready" as soon as everything is set up so that the guest can
> actually initiate the transition. Otherwise, those machines would never
> be "ready" if the guest does not transition.
>=20
> Maybe we can define "ready" as "the guest can start to execute in
> secure mode", where "guest" includes the bootloader and everything that
> runs in a guest context, and "start to execute" implies that some setup
> may be done only after the guest has kicked it off?

That was pretty much my intention.  I've put a big comment on the
field definition and tweaked things around a bit in the hopes of
making that clearer for the next spin.


--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--FsscpQKzF/jJk6ya
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmAYrboACgkQbDjKyiDZ
s5JsQQ/+KC1HdiParXeiUT8dURc/dB2Vtfg+xLj6xIJTdGjHycSyEDCKZFqZk/6X
eL8lzPkdrQRgwVSQ/ZlfiNUuxElO8v2G3exgcZVB0reEQjoViLpIGlosA4J31uLK
IV/3Jqjrcqpria693CW68Qrw/gSvLuVwRgnsFUk4bQJGX9JmugvK28jm8rAoS/NS
Z1nMOvdxEuTIOsfZiCKY/YNAhy1oPdLcMn2kLgBM3RRPsONfJ58D3FPEUfqla7so
9PPBvhkIDhM3gn1z6fl1r54EhqvBkFUWqE9fuCvBJBlBeWJJkVggGxNgTsIrw/Ow
Q1evkmZb8mx20GS0AcGArDc6XgUQioHnCwet91jTmrPmLqo6NdDhrONAbN/o6Yss
9R6jsgo6KD9e/VyPf15b+MR+TySHxYvlU8yF5YaGxtw/PkA67iaJJKciiGh5MWrg
P4Rp3K1bIjK0dYxow5QHa7h72WZsL/GLVbdP47if5nwaak+FxEWrVXaKU6gNh70H
/pIOxwUTZKxfYAnajz3iIoe3UWZt0YwiEj3uZ485ff04CmJvkwnRgObEsrxpoGeC
qhBr72RHM8Is0LH/307qOxbrhYozQx0TkSItX+QiU9RnoMFcOxMm4DWwh56edkjo
UakZwUywBwb04+eEU5rG2aBP55mh0TZQB7Muw3pVGpnEcoxXTrM=
=2yc6
-----END PGP SIGNATURE-----

--FsscpQKzF/jJk6ya--
