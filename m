Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6B61EDCFE
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 08:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgFDGMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 02:12:32 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42847 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726923AbgFDGMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 02:12:31 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49cwRc5N6Gz9sSg; Thu,  4 Jun 2020 16:12:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591251148;
        bh=VcPwwAahOtzyb0wSvzANjCC0ktdZ8BLG3bTS8qQVeOc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lDvRbU4TsyExXhaxpQsSEEw3ar0FHenhGQc6/WnUwmKVG7H61zqZwOWQ9X3z+0a/E
         qHZQrzXWNi2Bs8LxoPasrLaPK9bD/AB3gMgu3316MYoZOL8rTB9weDEjjskYMhQLNf
         e4G3I8n+w4BUgZ92/7RPsbEJjwUoNbw9MH+R82CI=
Date:   Thu, 4 Jun 2020 13:15:59 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC v2 04/18] target/i386: sev: Embed SEVState in SevGuestState
Message-ID: <20200604031559.GC228651@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-5-david@gibson.dropbear.id.au>
 <f6c47bd0-0213-743a-801d-6f90c033854c@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="69pVuxX8awAiJ7fD"
Content-Disposition: inline
In-Reply-To: <f6c47bd0-0213-743a-801d-6f90c033854c@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 29, 2020 at 11:09:41AM +0200, Philippe Mathieu-Daud=E9 wrote:
> On 5/21/20 5:42 AM, David Gibson wrote:
> > Currently SevGuestState contains only configuration information.  For
> > runtime state another non-QOM struct SEVState is allocated separately.
> >=20
> > Simplify things by instead embedding the SEVState structure in
> > SevGuestState.
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  target/i386/sev.c | 54 +++++++++++++++++++++++++----------------------
> >  1 file changed, 29 insertions(+), 25 deletions(-)
> >=20
> > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > index b6ed719fb5..b4ab9720d6 100644
> > --- a/target/i386/sev.c
> > +++ b/target/i386/sev.c
> > @@ -35,6 +35,22 @@
> > =20
> >  typedef struct SevGuestState SevGuestState;
> > =20
> > +struct SEVState {
> > +    uint8_t api_major;
> > +    uint8_t api_minor;
> > +    uint8_t build_id;
> > +    uint32_t policy;
> > +    uint64_t me_mask;
> > +    uint32_t cbitpos;
> > +    uint32_t reduced_phys_bits;
> > +    uint32_t handle;
> > +    int sev_fd;
> > +    SevState state;
> > +    gchar *measurement;
> > +};
> > +
> > +typedef struct SEVState SEVState;
>=20
> Maybe typedef & declaration altogether.

I'd prefer not - this makes it clearer that it's a pure code motion.
It's going to go away in a few patches time in any case.

> > +
> >  /**
> >   * SevGuestState:
> >   *
> > @@ -48,6 +64,7 @@ typedef struct SevGuestState SevGuestState;
> >  struct SevGuestState {
> >      Object parent_obj;
> > =20
> > +    /* configuration parameters */
> >      char *sev_device;
> >      uint32_t policy;
> >      uint32_t handle;
> > @@ -55,25 +72,11 @@ struct SevGuestState {
> >      char *session_file;
> >      uint32_t cbitpos;
> >      uint32_t reduced_phys_bits;
> > -};
> > =20
> > -struct SEVState {
> > -    SevGuestState *sev_info;
> > -    uint8_t api_major;
> > -    uint8_t api_minor;
> > -    uint8_t build_id;
> > -    uint32_t policy;
> > -    uint64_t me_mask;
> > -    uint32_t cbitpos;
> > -    uint32_t reduced_phys_bits;
> > -    uint32_t handle;
> > -    int sev_fd;
> > -    SevState state;
> > -    gchar *measurement;
> > +    /* runtime state */
> > +    SEVState state;
> >  };
> > =20
> > -typedef struct SEVState SEVState;
> > -
> >  #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
> >  #define DEFAULT_SEV_DEVICE      "/dev/sev"
> > =20
> > @@ -506,12 +509,12 @@ sev_read_file_base64(const char *filename, guchar=
 **data, gsize *len)
> >  }
> > =20
> >  static int
> > -sev_launch_start(SEVState *s)
> > +sev_launch_start(SevGuestState *sev)
> >  {
> > +    SEVState *s =3D &sev->state;
> >      gsize sz;
> >      int ret =3D 1;
> >      int fw_error, rc;
> > -    SevGuestState *sev =3D s->sev_info;
> >      struct kvm_sev_launch_start *start;
> >      guchar *session =3D NULL, *dh_cert =3D NULL;
> > =20
> > @@ -686,6 +689,7 @@ sev_vm_state_change(void *opaque, int running, RunS=
tate state)
> >  void *
> >  sev_guest_init(const char *id)
> >  {
> > +    SevGuestState *sev;
> >      SEVState *s;
> >      char *devname;
> >      int ret, fw_error;
> > @@ -693,27 +697,27 @@ sev_guest_init(const char *id)
> >      uint32_t host_cbitpos;
> >      struct sev_user_data_status status =3D {};
> > =20
> > -    sev_state =3D s =3D g_new0(SEVState, 1);
> > -    s->sev_info =3D lookup_sev_guest_info(id);
> > -    if (!s->sev_info) {
> > +    sev =3D lookup_sev_guest_info(id);
> > +    if (!sev) {
> >          error_report("%s: '%s' is not a valid '%s' object",
> >                       __func__, id, TYPE_SEV_GUEST);
> >          goto err;
> >      }
> > =20
> > +    sev_state =3D s =3D &sev->state;
>=20
> I was going to suggest to clean that, but I see your next patch already
> does the cleanup :)
>=20
> Reviewed-by: Philippe Mathieu-Daud=E9 <philmd@redhat.com>
>=20
> >      s->state =3D SEV_STATE_UNINIT;
> > =20
> >      host_cpuid(0x8000001F, 0, NULL, &ebx, NULL, NULL);
> >      host_cbitpos =3D ebx & 0x3f;
> > =20
> > -    s->cbitpos =3D object_property_get_int(OBJECT(s->sev_info), "cbitp=
os", NULL);
> > +    s->cbitpos =3D object_property_get_int(OBJECT(sev), "cbitpos", NUL=
L);
> >      if (host_cbitpos !=3D s->cbitpos) {
> >          error_report("%s: cbitpos check failed, host '%d' requested '%=
d'",
> >                       __func__, host_cbitpos, s->cbitpos);
> >          goto err;
> >      }
> > =20
> > -    s->reduced_phys_bits =3D object_property_get_int(OBJECT(s->sev_inf=
o),
> > +    s->reduced_phys_bits =3D object_property_get_int(OBJECT(sev),
> >                                          "reduced-phys-bits", NULL);
> >      if (s->reduced_phys_bits < 1) {
> >          error_report("%s: reduced_phys_bits check failed, it should be=
 >=3D1,"
> > @@ -723,7 +727,7 @@ sev_guest_init(const char *id)
> > =20
> >      s->me_mask =3D ~(1UL << s->cbitpos);
> > =20
> > -    devname =3D object_property_get_str(OBJECT(s->sev_info), "sev-devi=
ce", NULL);
> > +    devname =3D object_property_get_str(OBJECT(sev), "sev-device", NUL=
L);
> >      s->sev_fd =3D open(devname, O_RDWR);
> >      if (s->sev_fd < 0) {
> >          error_report("%s: Failed to open %s '%s'", __func__,
> > @@ -754,7 +758,7 @@ sev_guest_init(const char *id)
> >          goto err;
> >      }
> > =20
> > -    ret =3D sev_launch_start(s);
> > +    ret =3D sev_launch_start(sev);
> >      if (ret) {
> >          error_report("%s: failed to create encryption context", __func=
__);
> >          goto err;
> >=20
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--69pVuxX8awAiJ7fD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7YZ28ACgkQbDjKyiDZ
s5I6jhAAwYwVeXHrhw9982c6LHdXG90x5jVtyHsJSuRF2dc1azUXXpAF1M3Rbu8M
RpmwYVkDpCHtFGSlhTar4Iv8bVtZDJ19jsWZLt1PlPXr1MjscbWI//gb35QDye0D
ILDk5twZl6izgZAAUQ2FGertNowlAob8CI9R+IAgO6gXHR9lFnXESV0i2He0VrNJ
8PbiITV2nbrYudbDiIH/GbLMqCQLimLycyVY+BC2iREj9GR7+3JO7FMe0P3BYgWs
QCG2r5dKS8g7N/t9qBs3O5Z3AvCrpkctJ7LHqAQSwGChnItUC8W+4zsfqZRHmXAM
kc+dM0FZr1zrmJmNQM/h7TGqtjidVE5SRAP2m1ME24PycVFZIff7PivWnQahK1l0
6sHrRzyUQZf1ey92+HyZoGA+BtUYPXp4FRbG9c0VMOeAFsAmQNZRGQOSBdH4SUmY
61YonwXuPNO90I8kJgOyoqj9NkSy5V6qCmXrfxNnCKVKwBH5M5hwg6yQEWDwABBj
V6qQnOQ5Ee5lOPoqzWcINAT+0zrxY/kBdJ+bdfVlqCs+nL+D0C82hV7DniRjHTrQ
ASCiwsla/hPA17Ah+70h3HlQU6Yae4SB3OHDFtMLdsVVljCWPamse8EDgpOCxRFW
/Ccqkq3hY3WbzXnFs3aJwMEzgJgvNsOGXF355uYfu67MP0UkM0Q=
=2uDu
-----END PGP SIGNATURE-----

--69pVuxX8awAiJ7fD--
