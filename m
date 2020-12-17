Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014112DD04F
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 12:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgLQL0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 06:26:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725871AbgLQL0t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 06:26:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608204322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lxpRQsHZQY7Zhu3tHDp4QojWc4yaEKZVUewR/UonSok=;
        b=htDZB9NlajgA4XWKifDKQl+3SJ8LvvJd9KFOfbDC5JfEHyblbCNtN8TcMcKXPyPkDsIn1q
        CcKzxAjTVr13a1sUDCwPNz+JjH+9cja/POgMiBGDS51h0ZwAzHcQ+IVqnxXXRy2o4TPRLw
        5fiBHy3NVEV+ZtkDFvqoFW11dSMrijM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-0m8KPQnMPVORYFAcIXnkGw-1; Thu, 17 Dec 2020 06:25:18 -0500
X-MC-Unique: 0m8KPQnMPVORYFAcIXnkGw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3FC4809DCD;
        Thu, 17 Dec 2020 11:25:16 +0000 (UTC)
Received: from gondolin (ovpn-113-176.ams2.redhat.com [10.36.113.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75A36100164C;
        Thu, 17 Dec 2020 11:25:03 +0000 (UTC)
Date:   Thu, 17 Dec 2020 12:24:35 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
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
Subject: Re: [for-6.0 v5 08/13] securable guest memory: Introduce sgm
 "ready" flag
Message-ID: <20201217122435.5d7513fe.cohuck@redhat.com>
In-Reply-To: <20201217053820.GG310465@yekko.fritz.box>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
        <20201204054415.579042-9-david@gibson.dropbear.id.au>
        <20201214180036.3837693e.cohuck@redhat.com>
        <20201217053820.GG310465@yekko.fritz.box>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/wsLjr2rTq1uwHIhjnWRYsmX";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/wsLjr2rTq1uwHIhjnWRYsmX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Dec 2020 16:38:20 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> On Mon, Dec 14, 2020 at 06:00:36PM +0100, Cornelia Huck wrote:
> > On Fri,  4 Dec 2020 16:44:10 +1100
> > David Gibson <david@gibson.dropbear.id.au> wrote:
> >  =20
> > > The platform specific details of mechanisms for implementing securable
> > > guest memory may require setup at various points during initializatio=
n.
> > > Thus, it's not really feasible to have a single sgm initialization ho=
ok,
> > > but instead each mechanism needs its own initialization calls in arch=
 or
> > > machine specific code.
> > >=20
> > > However, to make it harder to have a bug where a mechanism isn't prop=
erly
> > > initialized under some circumstances, we want to have a common place,
> > > relatively late in boot, where we verify that sgm has been initialize=
d if
> > > it was requested.
> > >=20
> > > This patch introduces a ready flag to the SecurableGuestMemory base t=
ype
> > > to accomplish this, which we verify just before the machine specific
> > > initialization function.
> > >=20
> > > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > > ---
> > >  hw/core/machine.c                     | 8 ++++++++
> > >  include/exec/securable-guest-memory.h | 2 ++
> > >  target/i386/sev.c                     | 2 ++
> > >  3 files changed, 12 insertions(+)
> > >=20
> > > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > > index 816ea3ae3e..a67a27d03c 100644
> > > --- a/hw/core/machine.c
> > > +++ b/hw/core/machine.c
> > > @@ -1155,6 +1155,14 @@ void machine_run_board_init(MachineState *mach=
ine)
> > >      }
> > > =20
> > >      if (machine->sgm) {
> > > +        /*
> > > +         * Where securable guest memory is initialized depends on the
> > > +         * specific mechanism in use.  But, we need to make sure it's
> > > +         * ready by now.  If it isn't, that's a bug in the
> > > +         * implementation of that sgm mechanism.
> > > +         */
> > > +        assert(machine->sgm->ready); =20
> >=20
> > Under which circumstances might we arrive here with 'ready' not set?
> >=20
> > - programming error, setup is happening too late -> assert() seems
> >   appropriate =20
>=20
> Yes, this is designed to catch programming errors.  In particular I'm
> concerned about:
>   * Re-arranging the init code, and either entirely forgetting the sgm
>     setup, or accidentally moving it too late
>   * The sgm setup is buried in the machine setup code, conditional on
>     various things, and changes mean we no longer either call it or
>     (correctly) fail
>   * User has specified an sgm scheme designed for a machine type other
>     than the one they selected.  The arch/machine init code hasn't
>     correctly accounted for that possibility and ignores it, instead
>     of correctly throwing an error
> =20
> > - we tried to set it up, but some error happened -> should we rely on
> >   the setup code to error out first? (i.e. we won't end up here, unless
> >   there's a programming error, in which case the assert() looks
> >   fine) =20
>=20
> Yes, that's my intention.
>=20
> >   Is there a possible use case for "we could not set it up, but we
> >   support an unsecured guest (as long as it is clear what happens)"? =20
>=20
> I don't think so.  My feeling is that if you specify that you want the
> feature, qemu needs to either give it to you, or fail, not silently
> degrade the features presented to the guest.

Yes, that should align with what QEMU is doing elsewhere.

>=20
> >   Likely only for guests that transition themselves, but one could
> >   argue that QEMU should simply be invoked a second time without the
> >   sgm stuff being specified in the error case. =20
>=20
> Right - I think whatever error we give here is likely to be easier to
> diagnose than the guest itself throwing an error when it fails to
> transition to secure mode (plus we should catch it always, rather than
> only if we run a guest which tries to go secure).

Yes, that makes sense.

--Sig_/wsLjr2rTq1uwHIhjnWRYsmX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl/bP/MACgkQ3s9rk8bw
L6/uTw//S3IbdBwx0BYRCbCnGHnICuCmlQmt5o41nd86PMCiN1dQ6egtoQf6j2RY
fkRrd0AmD/5QtfO7KYUJnaIy9W3uSDgFQTIfGey0J7SvoY0BIxEW5gSMl31othxI
jAkxrC6JRc4/SgpuvdWUTTf1NBph+v5LycOTjLfih6UvVrSLCsrAtt+X4opPx1ti
reDAsF1qmeCaIUll9JgF3seJzsjl794hmW69DycTv9qLcLOdBHjwDhUnfh5Ttd0Y
3Tf9wPBJDs3Wpdmxx5G6un+4n79MCZ+13QnFcrPObo21jn4+Tm2lVViPJrjKGhxc
XQ8nJlaGRMaqtfpi9HEI1bxi7+2Js6oHudpWavXMKjOydtbmT5kI9/NjIKasnXLK
tRN2ropRKxYUmSA8L2sStv1zUig1yp2A8Ih6r2CCnaCBJK7ls2o7vXF6ytwI7m7u
+Rh+Xg871P0b+vtFW+TCSzcNBT2K9yFM4BDkWn3vsnJi72Z2bPku2o7wZJQx5GJJ
DpBmroXYVLpwrgjjYmZHYpXKRNZIdfsGDkH1xj9hYoAqUFp0lwjvqmKRPjAIT92E
ip6ejIcl4+rPUzn7b0tYH7EtNebYV2yzKvlDi7POdWoidFpmUzPCG9b8tmGpz+Os
2N84KaCwSFn2PBDqUnR1uKXlViE1qitO+mUozNgyafFaaTmZpR8=
=L1lU
-----END PGP SIGNATURE-----

--Sig_/wsLjr2rTq1uwHIhjnWRYsmX--

