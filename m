Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85749209991
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 07:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389697AbgFYFrg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 01:47:36 -0400
Received: from ozlabs.org ([203.11.71.1]:57955 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389597AbgFYFre (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 01:47:34 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49spv50fKWz9sTC; Thu, 25 Jun 2020 15:47:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1593064049;
        bh=EEmTbZZVcmzkrdOgtIVLfWGut2RQOlCho8VlMoYE5zc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g6i56VscgZX7GjhhX4rwun/gt9BfGwz8rULD0Of1Yem9eSAGCD3JRxQRsSr5sVy/g
         X9Ep7Sk9lIPTiKxUZL+a6lanNLJh4cSOHUNYI7ik7dCI2AkjbPRa7XZvj+MwgsOSWU
         XyIoT5MaDytwjMhjY9W3lO6E4vtXtMHY8Glrh7T0=
Date:   Thu, 25 Jun 2020 15:47:23 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-devel@nongnu.org, brijesh.singh@amd.com, pair@us.ibm.com,
        pbonzini@redhat.com, dgilbert@redhat.com, frankja@linux.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        mst@redhat.com, david@redhat.com, mdroth@linux.vnet.ibm.com,
        pasic@linux.ibm.com, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v3 0/9] Generalize memory encryption models
Message-ID: <20200625054723.GG172395@umbus.fritz.box>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <2fa7c84a-6929-ef04-1d61-f76a4cac35f5@de.ibm.com>
 <20200624090648.6bdf82bd.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Fnm8lRGFTVS/3GuM"
Content-Disposition: inline
In-Reply-To: <20200624090648.6bdf82bd.cohuck@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Fnm8lRGFTVS/3GuM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 24, 2020 at 09:06:48AM +0200, Cornelia Huck wrote:
> On Mon, 22 Jun 2020 16:27:28 +0200
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>=20
> > On 19.06.20 04:05, David Gibson wrote:
> > > A number of hardware platforms are implementing mechanisms whereby the
> > > hypervisor does not have unfettered access to guest memory, in order
> > > to mitigate the security impact of a compromised hypervisor.
> > >=20
> > > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > > to accomplish this in a different way, using a new memory protection
> > > level plus a small trusted ultravisor.  s390 also has a protected
> > > execution environment.
> > >=20
> > > The current code (committed or draft) for these features has each
> > > platform's version configured entirely differently.  That doesn't seem
> > > ideal for users, or particularly for management layers.
> > >=20
> > > AMD SEV introduces a notionally generic machine option
> > > "machine-encryption", but it doesn't actually cover any cases other
> > > than SEV.
> > >=20
> > > This series is a proposal to at least partially unify configuration
> > > for these mechanisms, by renaming and generalizing AMD's
> > > "memory-encryption" property.  It is replaced by a
> > > "host-trust-limitation" property pointing to a platform specific
> > > object which configures and manages the specific details.
> > >=20
> > > For now this series covers just AMD SEV and POWER PEF.  I'm hoping it
> > > can be extended to cover the Intel and s390 mechanisms as well,
> > > though. =20
> >=20
> > Let me try to summarize what I understand what you try to achieve:
> > one command line parameter for all platforms that=20
> >=20
> > common across all platforms:
> > - disable KSM
> > - by default enables iommu_platform
> >=20
> >=20
> > per platform:
> > - setup the necessary encryption scheme when appropriate
> > - block migration
> > -....
> >=20
> >=20
> > The tricky part is certainly the per platform thing. For example on
> > s390 we just have a cpumodel flag that provides interfaces to the guest
> > to switch into protected mode via the ultravisor. This works perfectly
> > fine with the host model, so no need to configure anything.  The platfo=
rm
> > code then disables KSM _on_switchover_ and not in general. Because the=
=20
> > guest CAN switch into protected, but it does not have to.
> >=20
> > So this feels really hard to do right. Would a virtual BoF on KVM forum
> > be too late? We had a BoF on protected guests last year and that was
> > valuable.
>=20
> Maybe we can do some kind of call to discuss this earlier? (Maybe in
> the KVM call slot on Tuesdays?) I think it would be really helpful if
> everybody would have at least a general understanding about how
> encryption/protection works on the different architectures.

Yes, I think this would be a good idea.  KVM Forum is probably later
than we want, plus since it is virtual, I probably won't be shifting
into the right timezone to attend much of it.

I don't know when that Tuesday KVM call is.  Generally the best
available time for Australia/Europe meetings this time of year is 9am
CET / 5pm AEST.  As a once off I could go somewhat later into my
evening, though.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Fnm8lRGFTVS/3GuM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl70OmsACgkQbDjKyiDZ
s5LT1A/+IwaLiZZ3b7YhAaur+c0t0DHFTO6Kc2RYpqJrHL1qEhm794BeLB7FyFzb
mi1sQs3TzS3fXAzO3Smjd3hJLDXTdz6Ffi8efAI/ftRxzi2Llhd9qaO8u8y+d1Kg
dziTxoe9doUU4Y2WNz+cNKxcNYC/+N3Zv7WurDuQ0lutKs1YE3NN7wcebiZf4RRv
aL1XIyHpBRe827Om1gsNBICkFxzvkXk0vg8IO5KttISNEUMMJly5JC9szcCOTX6h
x1DUKdWS/JK3YNc2M7PN5rwupy1ws9iW9LEIyWwAQXHU7PL3MVrHTUjOJNlhGxUl
tPsPL+SteLhhgmwQVxB3D2WskmJsJ2i37e7TzlbCaZXiO3eiBvz+6pQQ1LVz2/++
bdlHNKlLl7iaHjnIaUtqgamCCy4AXnPJI83IuQGY9spdJHd4PMrqDBiPo3m2xSe3
U4C3KD+Bz5LsfqACaN8HGr91QrIAXIE3ajUf6zqHuTdP9BUeps9rArV64cJ/vhYE
I86ixvvO0Bfyy9eu0AXtG+rupjLvFdF9mWhQ8kIK98+QXYCh8FuN8OEZ6A+eAT04
pRlRFqyx5AJy2CHW1ik0XEw68jY/A404+N5b4GABMjDxdQ0C52j5xDQiuycTUkGJ
vAjWg8x2UrQP3v7qmunRTQnDY6X2pfXbPetCJftbv9ZDQ86UevA=
=CtJc
-----END PGP SIGNATURE-----

--Fnm8lRGFTVS/3GuM--
