Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62AA23A0B4
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 10:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgHCIPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 04:15:08 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40461 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbgHCIPI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 04:15:08 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4BKrKP23qKz9sTY; Mon,  3 Aug 2020 18:15:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1596442505;
        bh=fnfi8ddiHUnN4M8bcu+YiZECf3oSERrbt8OzoBipdTA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=njK4XxE90+mqXqr67odz8kv/vPaZ2ogH/lCKsMpbNAGp0mIUp9ykvOCEhU3/9a5jl
         c8lwc0ju0hGh7nN38TwhHpYobnbUhXuWYtfgpOF6tDaKvF1TGWBRW1SJTSEAkCavRK
         XeZxJ1PUaklNMawJSh42y7eQO6rhGGr5uOpeENU0=
Date:   Mon, 3 Aug 2020 18:14:57 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     dgilbert@redhat.com, pair@us.ibm.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, brijesh.singh@amd.com,
        Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        ehabkost@redhat.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        mdroth@linux.vnet.ibm.com, pasic@linux.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [for-5.2 v4 10/10] s390: Recognize host-trust-limitation option
Message-ID: <20200803081457.GE7553@yekko.fritz.box>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
 <20200724025744.69644-11-david@gibson.dropbear.id.au>
 <8be75973-65bc-6d15-99b0-fbea9fe61c80@linux.ibm.com>
 <20200803075459.GC7553@yekko.fritz.box>
 <d8168c58-7935-99e7-dfe5-d97f22766bf7@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Dzs2zDY0zgkG72+7"
Content-Disposition: inline
In-Reply-To: <d8168c58-7935-99e7-dfe5-d97f22766bf7@linux.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Dzs2zDY0zgkG72+7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 03, 2020 at 10:07:42AM +0200, Janosch Frank wrote:
> On 8/3/20 9:54 AM, David Gibson wrote:
> > On Mon, Aug 03, 2020 at 09:49:42AM +0200, Janosch Frank wrote:
> >> On 7/24/20 4:57 AM, David Gibson wrote:
> >>> At least some s390 cpu models support "Protected Virtualization" (PV),
> >>> a mechanism to protect guests from eavesdropping by a compromised
> >>> hypervisor.
> >>>
> >>> This is similar in function to other mechanisms like AMD's SEV and
> >>> POWER's PEF, which are controlled bythe "host-trust-limitation"
> >>> machine option.  s390 is a slightly special case, because we already
> >>> supported PV, simply by using a CPU model with the required feature
> >>> (S390_FEAT_UNPACK).
> >>>
> >>> To integrate this with the option used by other platforms, we
> >>> implement the following compromise:
> >>>
> >>>  - When the host-trust-limitation option is set, s390 will recognize
> >>>    it, verify that the CPU can support PV (failing if not) and set
> >>>    virtio default options necessary for encrypted or protected guests,
> >>>    as on other platforms.  i.e. if host-trust-limitation is set, we
> >>>    will either create a guest capable of entering PV mode, or fail
> >>>    outright
> >>>
> >>>  - If host-trust-limitation is not set, guest's might still be able to
> >>>    enter PV mode, if the CPU has the right model.  This may be a
> >>>    little surprising, but shouldn't actually be harmful.
> >>
> >> As I already explained, they have to continue to work without any chan=
ge
> >> to the VM's configuration.
> >=20
> > Yes.. that's what I'm saying will happen.
> >=20
> >> Our users already expect PV to work without HTL. This feature is alrea=
dy
> >> being used and the documentation has been online for a few months. I've
> >> already heard enough complains because users found small errors in our
> >> documentation. I'm not looking forward to complains because suddenly we
> >> need to specify new command line arguments depending on the QEMU versi=
on.
> >>
> >> @Cornelia: QEMU is not my expertise, am I missing something here?
> >=20
> > What I'm saying here is that you don't need a new option.  I'm only
> > suggesting we make the new option the preferred way for future
> > upstream releases.  (the new option has the advantage that you *just*
> > need to specify it, and any necessary virtio or other options to be
> > compatible should be handled for you).
> >=20
> > But existing configurations should work as is (I'm not sure they do
> > with the current patch, because I'm not familiar with the s390 code
> > and have no means to test PV, but that can be sorted out before
> > merge).
> >=20
> OK, should and might are two different things so I was a bit concerned.
> That's fine then, thanks for the answer.

Well, the "should" and "might" are covering different things.
Existing working command lines should continue to work.  But those
command lines must already have the necessary tweaks to make virtio
work properly.  If you try to make a new command line for a PV guest
with a virtio device - or anything else that introduces extra PV
complications - then just chosing a CPU model with UNPACK might not be
enough.  By contrast, if you set host-trust-limitation, then it should
work and be PV capable with an arbitrary set of devices, or else fail
immediately with a meaningful error.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Dzs2zDY0zgkG72+7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl8nx4EACgkQbDjKyiDZ
s5IFHw/+Mlo1GETZ4M0/8tRfMOQ1ICrq1FoOEO9EYWxfzl/KMFmTcPuCNOyDF4Up
XD/I2Kv6iL/VYzgXuxIR6e2s2zJfcUWDSeQA5Sg4p4EARFs1HlWhuC6ojhiy8ubL
w4+mG27ewtYHxWFH6N8LmlZkUN/HmfwpbPXZzkgs8Dr8ZDI6uFfpvOJ1JceZWM8F
xy9INXKy9YEHMF7wcESXZTuCIdA17IxI2W9j4p02DWSntTpnWj0xL8V3eZyIougb
9FoTLRoWA+VVdzSUQoFlIL+QIVrKLM3cwTKzwnBVdHBriPWVULxeh3a88V0Qt20c
bTWowPbqmxKe29jR94XA9dyXuGNdAall7GaUWlcaYtKvXXcTnMoJct5p/1PAnIwQ
cj1MeyZn83DZwU1dKhr5jl1KxwcqMg+Zec2gfxx3PmD3A19VrqyF4oP5jpyEyuEe
+7qByz+f3hCbgHsdo3cySNN4CKQFxTDBIpJGrBhqfX3SCIo3wXSqZK2w3+oDkdvP
YhkXHa6RGxhtf9wAxo8td0Vc+6a4eEAYmNOUkZKLfEbZxxf+SxHOHQ/Jpb42W90F
nXjdoTWTKQ11QjNEjNFGPq+MaUGXFLWQ8WEjttcZk2HxOc0drmSlDojPS4NiHSV1
0IqcncQ/DH4cy8IRSpvXLuhgX4WSQbxKfySW4VUG6fAJd2nkf4o=
=WkqB
-----END PGP SIGNATURE-----

--Dzs2zDY0zgkG72+7--
