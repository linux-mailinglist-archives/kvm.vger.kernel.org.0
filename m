Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B788020ABEB
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 07:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgFZFmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 01:42:54 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40479 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbgFZFmy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 01:42:54 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49tQlJ01lyz9sSc; Fri, 26 Jun 2020 15:42:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1593150172;
        bh=iD16IXZFAh5RfUbHS6Y8juImA3EwRSNNnBkAvImyly8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jnCzMNrl9l+rYL0vvU4apLkftlDgf4oR3XP9LeauFpGiSGevGFzoZbmbH9ArEW5zm
         nMpFsHUCAoXadFvTJPPuUu2P+DiFS2+c58GA3qqftCN29Vham5qzeKyAqFVBGsDIVT
         RTpOMcUvnbfnSb/RjChs9xSPU2MmB5o/rKWz/jXM=
Date:   Fri, 26 Jun 2020 14:42:59 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     David Hildenbrand <david@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pair@us.ibm.com, pbonzini@redhat.com,
        dgilbert@redhat.com, frankja@linux.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, qemu-ppc@nongnu.org, mst@redhat.com,
        mdroth@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>,
        pasic@linux.ibm.com, Eduardo Habkost <ehabkost@redhat.com>,
        qemu-s390x@nongnu.org
Subject: Re: [PATCH v3 0/9] Generalize memory encryption models
Message-ID: <20200626044259.GK172395@umbus.fritz.box>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <e045e202-cd56-4ddc-8c1d-a2fe5a799d32@redhat.com>
 <20200619114526.6a6f70c6.cohuck@redhat.com>
 <79890826-f67c-2228-e98d-25d2168be3da@redhat.com>
 <20200619120530.256c36cb.cohuck@redhat.com>
 <358d48e5-4c57-808b-50da-275f5e2a352c@redhat.com>
 <20200622140254.0dbe5d8c.cohuck@redhat.com>
 <20200625052518.GD172395@umbus.fritz.box>
 <025fb54b-60b7-a58b-e3d7-1bbaad152c5c@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8tUgZ4IE8L4vmMyh"
Content-Disposition: inline
In-Reply-To: <025fb54b-60b7-a58b-e3d7-1bbaad152c5c@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--8tUgZ4IE8L4vmMyh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2020 at 09:06:05AM +0200, David Hildenbrand wrote:
> >> Still unsure how to bring this new machine property and the cpu feature
> >> together. Would be great to have the same interface everywhere, but
> >> having two distinct command line objects depend on each other sucks.
> >=20
> > Kinda, but the reality is that hardware - virtual and otherwise -
> > frequently doesn't have entirely orthogonal configuration for each of
> > its components.  This is by no means new in that regard.
> >=20
> >> Automatically setting the feature bit if pv is supported complicates
> >> things further.
> >=20
> > AIUI, on s390 the "unpack" feature is available by default on recent
> > models.  In that case you could do this:
> >=20
> >  * Don't modify either cpu or HTL options based on each other
> >  * Bail out if the user specifies a non "unpack" secure CPU along with
> >    the HTL option
> >=20
> > Cases of note:
> >  - User specifies an old CPU model + htl
> >    or explicitly sets unpack=3Doff + htl
> > 	=3D> fails with an error, correctly
> >  - User specifies modern/default cpu + htl, with secure aware guest
> >  	=3D> works as a secure guest
> >  - User specifies modern/default cpu + htl, with non secure aware guest
> > 	=3D> works, though not secure (and maybe slower than neccessary)
> >  - User specifies modern/default cpu, no htl, with non-secure guest
> >  	=3D> works, "unpack" feature is present but unused
> >  - User specifies modern/default cpu, no htl, secure guest
> >   	=3D> this is the worst one.  It kind of works by accident if
> > 	   you've also  manually specified whatever virtio (and
> > 	   anything else) options are necessary. Ugly, but no
> > 	   different from the situation right now, IIUC
> >=20
> >> (Is there any requirement that the machine object has been already set
> >> up before the cpu features are processed? Or the other way around?)
> >=20
> > CPUs are usually created by the machine, so I believe we can count on
> > the machine object being there first.
>=20
> CPU model initialization is one of the first things machine
> initialization code does on s390x.

As it is for most platforms, but still, the values of machine
properties are available to you at this point.

> static void ccw_init(MachineState *machine)
> {
>     [... memory init ...]
>     s390_sclp_init();
>     s390_memory_init(machine->ram);
>     /* init CPUs (incl. CPU model) early so s390_has_feature() works */
>     s390_init_cpus(machine);
>     [...]
> }
>=20
> >=20
> >> Does this have any implications when probing with the 'none' machine?
> >=20
> > I'm not sure.  In your case, I guess the cpu bit would still show up
> > as before, so it would tell you base feature availability, but not
> > whether you can use the new configuration option.
> >=20
> > Since the HTL option is generic, you could still set it on the "none"
> > machine, though it wouldn't really have any effect.  That is, if you
> > could create a suitable object to point it at, which would depend on
> > ... details.
> >=20
>=20
> The important point is that we never want the (expanded) host cpu model
> look different when either specifying or not specifying the HTL
> property.

Ah, yes, I see your point.  So my current suggestion will satisfy
that, basically it is:

cpu has unpack (inc. by default) && htl specified
	=3D> works (allowing secure), as expected

!cpu has unpack && htl specified
	=3D> bails out with an error

!cpu has unpack && !htl specified
	=3D> works for a non-secure guest, as expected
	=3D> guest will fail if it attempts to go secure

cpu has unpack && !htl specified
	=3D> works as expected for a non-secure guest (unpack feature is
	   present, but unused)
	=3D> secure guest may work "by accident", but only if all virtio
	   properties have the right values, which is the user's
	   problem

That last case is kinda ugly, but I think it's tolerable.

> We don't want to run into issues where libvirt probes and gets
> host model X, but when using that probed model (automatically) for a
> guest domain, we suddenly cannot run X anymore.
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--8tUgZ4IE8L4vmMyh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl71fNMACgkQbDjKyiDZ
s5Jn7g/7B85dO80x9MKReXN358gRZcNMYr3LcZ+HlyE7pMOyKFQ7vvFKN8BSEmYP
Y6MOR0P+i4kusGH5Y/HfKMBintgZoljg/ibJ/Nhpt2x9g2jrBai4heJ1IIY9MMjs
HxDTXLZCxIauYIL3HYHOf7UAjdWnnrvQGX2cqY6vCKS4J7RrAs5+DPI+xHhpBh66
/+8gkZbcEdz7l55rjSsJ2h238hMzFmCNzu3pJlx/CviQNp1ScSu3aOT9LkRFfIBL
TlSCey5xnudp5uQSHhsEZjMflJUqlZtQ1zOyqFmOEQ5QpBnU9oLZqRY2SenJumps
05Imr/lJg1EeRw2hZXugcc1o1G5rQkfJXAgQd5ikxGxtCGC1ly5xsWepyjGaEw5Y
d5VDo2g/al3lLm07V6xJ0MSHpTWxksX23S4P0iH6iPFLxA1yqLjU2rqNhcpZ9X3q
n59CEam7H8kPo5xsS+4TkpGGB0bgXX4/uRNv4L+nYQ5z6p7ruhTbt4EeTCphbqR1
9JAB0gIkXZzWpDyW8gTXPs86lT+04619xQKK1QuAmRgqDadYmPt8/NefbX7qGbln
MrL7wPHP9vH2Ei1xeVg2QSPGYCLk4kIQknktwPScVq1sVQm4QFbmFaS3ug8dAjWB
DCGZ4aUGyqgIFVDNgmX7mydhH1YZUnOn406Jd8Pa11SA25GMJoU=
=86Td
-----END PGP SIGNATURE-----

--8tUgZ4IE8L4vmMyh--
