Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F25B1D433E
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 03:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgEOBxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 21:53:16 -0400
Received: from ozlabs.org ([203.11.71.1]:33181 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726241AbgEOBxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 21:53:16 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49NWdj47plz9sT3; Fri, 15 May 2020 11:53:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1589507593;
        bh=FLSavr2k+dPhn4Iws+dt37Fq2Ke/r20PWURrZZ69k/0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YFR8SBa/VyeTSNpHJ83SEmcSLQg5fdRswc7Pzy5BVcxXTmf+vTzDI2ZthO7DaIABQ
         J/zP7QMsU8BLn5Mwg2yTc9MjMbBO2eM9AveYPBeRVEwBxM9zwK2PGB/buW2GsVKs2R
         c3dOCS2+cbT+Oh/nqWybuBsYyh7FR58Bw8qrAkbs=
Date:   Fri, 15 May 2020 10:14:06 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     frankja@linux.ibm.com, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        mdroth@linux.vnet.ibm.com
Subject: Re: [RFC 16/18] use errp for gmpo kvm_init
Message-ID: <20200515001406.GF2183@umbus.fritz.box>
References: <20200514064120.449050-1-david@gibson.dropbear.id.au>
 <20200514064120.449050-17-david@gibson.dropbear.id.au>
 <20200514170808.GS2787@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xnH/NIbSm9ew9GxF"
Content-Disposition: inline
In-Reply-To: <20200514170808.GS2787@work-vm>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--xnH/NIbSm9ew9GxF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 14, 2020 at 06:09:46PM +0100, Dr. David Alan Gilbert wrote:
> Dave:
>   You've got some screwy mail headers here, the qemu-devel@nongnu.-rg is
> the best one anmd the pair@us.redhat.com is weird as well.

Yeah, apparently I forgot how to type when I entered my git-publish
command line :/.

>=20
> * David Gibson (david@gibson.dropbear.id.au) wrote:
> > ---
> >  accel/kvm/kvm-all.c                    |  4 +++-
> >  include/exec/guest-memory-protection.h |  2 +-
> >  target/i386/sev.c                      | 32 +++++++++++++-------------
> >  3 files changed, 20 insertions(+), 18 deletions(-)
> >=20
> > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> > index 5451728425..392ab02867 100644
> > --- a/accel/kvm/kvm-all.c
> > +++ b/accel/kvm/kvm-all.c
> > @@ -2045,9 +2045,11 @@ static int kvm_init(MachineState *ms)
> >      if (ms->gmpo) {
> >          GuestMemoryProtectionClass *gmpc =3D
> >              GUEST_MEMORY_PROTECTION_GET_CLASS(ms->gmpo);
> > +        Error *local_err =3D NULL;
> > =20
> > -        ret =3D gmpc->kvm_init(ms->gmpo);
> > +        ret =3D gmpc->kvm_init(ms->gmpo, &local_err);
> >          if (ret < 0) {
> > +            error_report_err(local_err);
> >              goto err;
> >          }
> >      }
> > diff --git a/include/exec/guest-memory-protection.h b/include/exec/gues=
t-memory-protection.h
> > index 7d959b4910..2a88475136 100644
> > --- a/include/exec/guest-memory-protection.h
> > +++ b/include/exec/guest-memory-protection.h
> > @@ -32,7 +32,7 @@ typedef struct GuestMemoryProtection GuestMemoryProte=
ction;
> >  typedef struct GuestMemoryProtectionClass {
> >      InterfaceClass parent;
> > =20
> > -    int (*kvm_init)(GuestMemoryProtection *);
> > +    int (*kvm_init)(GuestMemoryProtection *, Error **);
> >      int (*encrypt_data)(GuestMemoryProtection *, uint8_t *, uint64_t);
> >  } GuestMemoryProtectionClass;
> > =20
> > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > index 2051fae0c1..82f16b2f3b 100644
> > --- a/target/i386/sev.c
> > +++ b/target/i386/sev.c
> > @@ -617,7 +617,7 @@ sev_vm_state_change(void *opaque, int running, RunS=
tate state)
> >      }
> >  }
> > =20
> > -static int sev_kvm_init(GuestMemoryProtection *gmpo)
> > +static int sev_kvm_init(GuestMemoryProtection *gmpo, Error **errp)
> >  {
> >      SevGuestState *sev =3D SEV_GUEST(gmpo);
> >      char *devname;
> > @@ -633,14 +633,14 @@ static int sev_kvm_init(GuestMemoryProtection *gm=
po)
> >      host_cbitpos =3D ebx & 0x3f;
> > =20
> >      if (host_cbitpos !=3D sev->cbitpos) {
> > -        error_report("%s: cbitpos check failed, host '%d' requested '%=
d'",
> > -                     __func__, host_cbitpos, sev->cbitpos);
> > +        error_setg(errp, "%s: cbitpos check failed, host '%d' requeste=
d '%d'",
> > +                   __func__, host_cbitpos, sev->cbitpos);
> >          goto err;
> >      }
> > =20
> >      if (sev->reduced_phys_bits < 1) {
> > -        error_report("%s: reduced_phys_bits check failed, it should be=
 >=3D1,"
> > -                     " requested '%d'", __func__, sev->reduced_phys_bi=
ts);
> > +        error_setg(errp, "%s: reduced_phys_bits check failed, it shoul=
d be >=3D1,"
> > +                   " requested '%d'", __func__, sev->reduced_phys_bits=
);
> >          goto err;
> >      }
> > =20
> > @@ -649,20 +649,20 @@ static int sev_kvm_init(GuestMemoryProtection *gm=
po)
> >      devname =3D object_property_get_str(OBJECT(sev), "sev-device", NUL=
L);
> >      sev->sev_fd =3D open(devname, O_RDWR);
> >      if (sev->sev_fd < 0) {
> > -        error_report("%s: Failed to open %s '%s'", __func__,
> > -                     devname, strerror(errno));
> > -    }
> > -    g_free(devname);
> > -    if (sev->sev_fd < 0) {
> > +        g_free(devname);
> > +        error_setg(errp, "%s: Failed to open %s '%s'", __func__,
> > +                   devname, strerror(errno));
> > +        g_free(devname);
>=20
> You seem to have double free'd devname - would g_autofree work here?
>=20
> other than that, looks OK to me.
>=20
> Dave
>=20
> >          goto err;
> >      }
> > +    g_free(devname);
> > =20
> >      ret =3D sev_platform_ioctl(sev->sev_fd, SEV_PLATFORM_STATUS, &stat=
us,
> >                               &fw_error);
> >      if (ret) {
> > -        error_report("%s: failed to get platform status ret=3D%d "
> > -                     "fw_error=3D'%d: %s'", __func__, ret, fw_error,
> > -                     fw_error_to_str(fw_error));
> > +        error_setg(errp, "%s: failed to get platform status ret=3D%d "
> > +                   "fw_error=3D'%d: %s'", __func__, ret, fw_error,
> > +                   fw_error_to_str(fw_error));
> >          goto err;
> >      }
> >      sev->build_id =3D status.build;
> > @@ -672,14 +672,14 @@ static int sev_kvm_init(GuestMemoryProtection *gm=
po)
> >      trace_kvm_sev_init();
> >      ret =3D sev_ioctl(sev->sev_fd, KVM_SEV_INIT, NULL, &fw_error);
> >      if (ret) {
> > -        error_report("%s: failed to initialize ret=3D%d fw_error=3D%d =
'%s'",
> > -                     __func__, ret, fw_error, fw_error_to_str(fw_error=
));
> > +        error_setg(errp, "%s: failed to initialize ret=3D%d fw_error=
=3D%d '%s'",
> > +                   __func__, ret, fw_error, fw_error_to_str(fw_error));
> >          goto err;
> >      }
> > =20
> >      ret =3D sev_launch_start(sev);
> >      if (ret) {
> > -        error_report("%s: failed to create encryption context", __func=
__);
> > +        error_setg(errp, "%s: failed to create encryption context", __=
func__);
> >          goto err;
> >      }
> > =20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--xnH/NIbSm9ew9GxF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl693soACgkQbDjKyiDZ
s5JCbg/9GLsG4LhOE/SngRccOLYEj5CiJe9Ks9rgE8sadpscDWpvGnONin6rruwD
pyKoXo7W89nnSFCPhVUf/uCBxicB7GaiseEs1Xe68ni/fHXQUFm/Oxla4yoCpguA
xLTLYrqMT1lLfXE7pGfYhgN4UI6CBcAYkvspauPfIVNJZDanmP8DJdmwbBzzl5XS
TSJrnSqqxnZPebWwCWA/CGsJ36I1hjeietTZLsV7tA04ajz8cIql3EYtgst8Bor1
RHz396gkP6pqLcrYvtq2UdU4flO1g9JIE7XQf8MENyyP+C2PqLUYPCZ158nENvgJ
9bEoJIXujne10vNFmzRuzZ1n4SQ1Au3WnH+MnqHh425o5eXgrwy1WfgLwENE/wYO
GeH+VTQ1BHoEeTMXPaUxOr+p3jol5dYRLtrwrAaH7Ha10nfXLpXsUWdM1z9SSUoa
0mCZVmnsIJa4Ror+OlhIGl83YkKb+m0bBUNG7A1J63adGmVbAWMkp5NtHeZ+Ho8T
OWZX6IDFAYV70xYz5NBZAhY3HFqaLJ7c3czpE0HUkIUqAkr9nAhourPMtLTSz1SU
3mgLFixTMmlKxQsP9t00FWfr9/x8WKZzy3yBJy81U4XGpsziUm4PTTRXqQMWFMFp
knguUYn2Z6BqJhihuuO8lGlvi6ZzjT8j2z6xW4cI1nwXOVMuqD0=
=37SX
-----END PGP SIGNATURE-----

--xnH/NIbSm9ew9GxF--
