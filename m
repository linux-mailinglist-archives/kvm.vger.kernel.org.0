Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8FC1EDD01
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 08:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgFDGMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 02:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgFDGMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 02:12:31 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4621C05BD43
        for <kvm@vger.kernel.org>; Wed,  3 Jun 2020 23:12:31 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49cwRc61BPz9sSn; Thu,  4 Jun 2020 16:12:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591251148;
        bh=4mNWXeeVJLVrbIApFBHif9Uyd9pGvH80LiEsHxKqPgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bX1JNvJIns8y/4pX9fXsAZ40jYzgTI7SVDtXXbtimebDad1WlJYbl6njjBNhZ0ckX
         tjPi2UTLbdkAvRqN2ACWNd+p1qYp3htSLaezhwFAM5ZyirzRhl9onHj+X2TuV3y9ho
         r00s8jeDFMO1RpzInRknVUurFfstf4QOpeCMHGvg=
Date:   Thu, 4 Jun 2020 13:27:51 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Greg Kurz <groug@kaod.org>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC v2 11/18] guest memory protection: Handle memory encrption
 via interface
Message-ID: <20200604032751.GD228651@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-12-david@gibson.dropbear.id.au>
 <20200525122655.0488cc3d@bahia.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5gxpn/Q6ypwruk0T"
Content-Disposition: inline
In-Reply-To: <20200525122655.0488cc3d@bahia.lan>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--5gxpn/Q6ypwruk0T
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 25, 2020 at 12:26:55PM +0200, Greg Kurz wrote:
>=20
> s/encrption/encryption

Fixed.

> On Thu, 21 May 2020 13:42:57 +1000
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > At the moment AMD SEV sets a special function pointer, plus an opaque
> > handle in KVMState to let things know how to encrypt guest memory.
> >=20
> > Now that we have a QOM interface for handling things related to guest
> > memory protection, use a QOM method on that interface, rather than a ba=
re
> > function pointer for this.
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  accel/kvm/kvm-all.c                    | 23 +++----
> >  accel/kvm/sev-stub.c                   |  5 --
> >  include/exec/guest-memory-protection.h |  2 +
> >  include/sysemu/sev.h                   |  6 +-
> >  target/i386/sev.c                      | 84 ++++++++++++++------------
> >  5 files changed, 63 insertions(+), 57 deletions(-)
> >=20
> > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> > index d06cc04079..40997de38c 100644
> > --- a/accel/kvm/kvm-all.c
> > +++ b/accel/kvm/kvm-all.c
> > @@ -45,6 +45,7 @@
> >  #include "qapi/qapi-types-common.h"
> >  #include "qapi/qapi-visit-common.h"
> >  #include "sysemu/reset.h"
> > +#include "exec/guest-memory-protection.h"
> > =20
> >  #include "hw/boards.h"
> > =20
> > @@ -119,8 +120,7 @@ struct KVMState
> >      QLIST_HEAD(, KVMParkedVcpu) kvm_parked_vcpus;
> > =20
> >      /* memory encryption */
> > -    void *memcrypt_handle;
> > -    int (*memcrypt_encrypt_data)(void *handle, uint8_t *ptr, uint64_t =
len);
> > +    GuestMemoryProtection *guest_memory_protection;
> > =20
> >      /* For "info mtree -f" to tell if an MR is registered in KVM */
> >      int nr_as;
> > @@ -172,7 +172,7 @@ int kvm_get_max_memslots(void)
> > =20
> >  bool kvm_memcrypt_enabled(void)
> >  {
> > -    if (kvm_state && kvm_state->memcrypt_handle) {
> > +    if (kvm_state && kvm_state->guest_memory_protection) {
> >          return true;
> >      }
> > =20
> > @@ -181,10 +181,13 @@ bool kvm_memcrypt_enabled(void)
> > =20
> >  int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
> >  {
> > -    if (kvm_state->memcrypt_handle &&
> > -        kvm_state->memcrypt_encrypt_data) {
> > -        return kvm_state->memcrypt_encrypt_data(kvm_state->memcrypt_ha=
ndle,
> > -                                              ptr, len);
> > +    GuestMemoryProtection *gmpo =3D kvm_state->guest_memory_protection;
> > +
> > +    if (gmpo) {
> > +        GuestMemoryProtectionClass *gmpc =3D
> > +            GUEST_MEMORY_PROTECTION_GET_CLASS(gmpo);
> > +
> > +        return gmpc->encrypt_data(gmpo, ptr, len);
> >      }
> > =20
> >      return 1;
> > @@ -2101,13 +2104,11 @@ static int kvm_init(MachineState *ms)
> >       * encryption context.
> >       */
> >      if (ms->memory_encryption) {
> > -        kvm_state->memcrypt_handle =3D sev_guest_init(ms->memory_encry=
ption);
> > -        if (!kvm_state->memcrypt_handle) {
> > +        kvm_state->guest_memory_protection =3D sev_guest_init(ms->memo=
ry_encryption);
> > +        if (!kvm_state->guest_memory_protection) {
> >              ret =3D -1;
> >              goto err;
> >          }
> > -
> > -        kvm_state->memcrypt_encrypt_data =3D sev_encrypt_data;
> >      }
> > =20
> >      ret =3D kvm_arch_init(ms, s);
> > diff --git a/accel/kvm/sev-stub.c b/accel/kvm/sev-stub.c
> > index 4f97452585..4a5cc5569e 100644
> > --- a/accel/kvm/sev-stub.c
> > +++ b/accel/kvm/sev-stub.c
> > @@ -15,11 +15,6 @@
> >  #include "qemu-common.h"
> >  #include "sysemu/sev.h"
> > =20
> > -int sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
> > -{
> > -    abort();
> > -}
> > -
> >  void *sev_guest_init(const char *id)
> >  {
> >      return NULL;
>=20
> This requires some extra care:
>=20
> accel/kvm/sev-stub.c:18:7: error: conflicting types for =E2=80=98sev_gues=
t_init=E2=80=99
>  void *sev_guest_init(const char *id)
>        ^~~~~~~~~~~~~~
> In file included from accel/kvm/sev-stub.c:16:0:
> include/sysemu/sev.h:21:24: note: previous declaration of =E2=80=98sev_gu=
est_init=E2=80=99 was here
>  GuestMemoryProtection *sev_guest_init(const char *id);
>                         ^~~~~~~~~~~~~~
> rules.mak:69: recipe for target 'accel/kvm/sev-stub.o' failed

Oops, that's embarrassing - I forgot to do a build on ppc.

Fixed now.

> > diff --git a/include/exec/guest-memory-protection.h b/include/exec/gues=
t-memory-protection.h
> > index 38e9b01667..eb712a5804 100644
> > --- a/include/exec/guest-memory-protection.h
> > +++ b/include/exec/guest-memory-protection.h
> > @@ -30,6 +30,8 @@ typedef struct GuestMemoryProtection GuestMemoryProte=
ction;
> > =20
> >  typedef struct GuestMemoryProtectionClass {
> >      InterfaceClass parent;
> > +
> > +    int (*encrypt_data)(GuestMemoryProtection *, uint8_t *, uint64_t);
> >  } GuestMemoryProtectionClass;
> > =20
> >  #endif /* QEMU_GUEST_MEMORY_PROTECTION_H */
> > diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
> > index 98c1ec8d38..7735a7942e 100644
> > --- a/include/sysemu/sev.h
> > +++ b/include/sysemu/sev.h
> > @@ -16,6 +16,8 @@
> > =20
> >  #include "sysemu/kvm.h"
> > =20
> > -void *sev_guest_init(const char *id);
> > -int sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len);
> > +typedef struct GuestMemoryProtection GuestMemoryProtection;
> > +
> > +GuestMemoryProtection *sev_guest_init(const char *id);
> > +
> >  #endif
> > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > index d273174ad3..986c2fee51 100644
> > --- a/target/i386/sev.c
> > +++ b/target/i386/sev.c
> > @@ -28,6 +28,7 @@
> >  #include "sysemu/runstate.h"
> >  #include "trace.h"
> >  #include "migration/blocker.h"
> > +#include "exec/guest-memory-protection.h"
> > =20
> >  #define TYPE_SEV_GUEST "sev-guest"
> >  #define SEV_GUEST(obj)                                          \
> > @@ -281,26 +282,6 @@ sev_guest_set_sev_device(Object *obj, const char *=
value, Error **errp)
> >      sev->sev_device =3D g_strdup(value);
> >  }
> > =20
> > -static void
> > -sev_guest_class_init(ObjectClass *oc, void *data)
> > -{
> > -    object_class_property_add_str(oc, "sev-device",
> > -                                  sev_guest_get_sev_device,
> > -                                  sev_guest_set_sev_device);
> > -    object_class_property_set_description(oc, "sev-device",
> > -            "SEV device to use");
> > -    object_class_property_add_str(oc, "dh-cert-file",
> > -                                  sev_guest_get_dh_cert_file,
> > -                                  sev_guest_set_dh_cert_file);
> > -    object_class_property_set_description(oc, "dh-cert-file",
> > -            "guest owners DH certificate (encoded with base64)");
> > -    object_class_property_add_str(oc, "session-file",
> > -                                  sev_guest_get_session_file,
> > -                                  sev_guest_set_session_file);
> > -    object_class_property_set_description(oc, "session-file",
> > -            "guest owners session parameters (encoded with base64)");
> > -}
> > -
> >  static void
> >  sev_guest_instance_init(Object *obj)
> >  {
> > @@ -319,20 +300,6 @@ sev_guest_instance_init(Object *obj)
> >                                     OBJ_PROP_FLAG_READWRITE);
> >  }
> > =20
> > -/* sev guest info */
> > -static const TypeInfo sev_guest_info =3D {
> > -    .parent =3D TYPE_OBJECT,
> > -    .name =3D TYPE_SEV_GUEST,
> > -    .instance_size =3D sizeof(SevGuestState),
> > -    .instance_finalize =3D sev_guest_finalize,
> > -    .class_init =3D sev_guest_class_init,
> > -    .instance_init =3D sev_guest_instance_init,
> > -    .interfaces =3D (InterfaceInfo[]) {
> > -        { TYPE_USER_CREATABLE },
> > -        { }
> > -    }
> > -};
> > -
> >  static SevGuestState *
> >  lookup_sev_guest_info(const char *id)
> >  {
> > @@ -670,7 +637,7 @@ sev_vm_state_change(void *opaque, int running, RunS=
tate state)
> >      }
> >  }
> > =20
> > -void *
> > +GuestMemoryProtection *
> >  sev_guest_init(const char *id)
> >  {
> >      SevGuestState *sev;
> > @@ -748,16 +715,16 @@ sev_guest_init(const char *id)
> >      qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
> >      qemu_add_vm_change_state_handler(sev_vm_state_change, sev);
> > =20
> > -    return sev;
> > +    return GUEST_MEMORY_PROTECTION(sev);
> >  err:
> >      sev_guest =3D NULL;
> >      return NULL;
> >  }
> > =20
> > -int
> > -sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
> > +static int
> > +sev_encrypt_data(GuestMemoryProtection *opaque, uint8_t *ptr, uint64_t=
 len)
> >  {
> > -    SevGuestState *sev =3D handle;
> > +    SevGuestState *sev =3D SEV_GUEST(opaque);
> > =20
> >      assert(sev);
> > =20
> > @@ -769,6 +736,45 @@ sev_encrypt_data(void *handle, uint8_t *ptr, uint6=
4_t len)
> >      return 0;
> >  }
> > =20
> > +static void
> > +sev_guest_class_init(ObjectClass *oc, void *data)
> > +{
> > +    GuestMemoryProtectionClass *gmpc =3D GUEST_MEMORY_PROTECTION_CLASS=
(oc);
> > +
> > +    object_class_property_add_str(oc, "sev-device",
> > +                                  sev_guest_get_sev_device,
> > +                                  sev_guest_set_sev_device);
> > +    object_class_property_set_description(oc, "sev-device",
> > +        "SEV device to use");
> > +    object_class_property_add_str(oc, "dh-cert-file",
> > +                                  sev_guest_get_dh_cert_file,
> > +                                  sev_guest_set_dh_cert_file);
> > +    object_class_property_set_description(oc, "dh-cert-file",
> > +        "guest owners DH certificate (encoded with base64)");
> > +    object_class_property_add_str(oc, "session-file",
> > +                                  sev_guest_get_session_file,
> > +                                  sev_guest_set_session_file);
> > +    object_class_property_set_description(oc, "session-file",
> > +        "guest owners session parameters (encoded with base64)");
> > +
> > +    gmpc->encrypt_data =3D sev_encrypt_data;
> > +}
> > +
> > +/* sev guest info */
> > +static const TypeInfo sev_guest_info =3D {
> > +    .parent =3D TYPE_OBJECT,
> > +    .name =3D TYPE_SEV_GUEST,
> > +    .instance_size =3D sizeof(SevGuestState),
> > +    .instance_finalize =3D sev_guest_finalize,
> > +    .class_init =3D sev_guest_class_init,
> > +    .instance_init =3D sev_guest_instance_init,
> > +    .interfaces =3D (InterfaceInfo[]) {
> > +        { TYPE_GUEST_MEMORY_PROTECTION },
> > +        { TYPE_USER_CREATABLE },
> > +        { }
> > +    }
> > +};
> > +
> >  static void
> >  sev_register_types(void)
> >  {
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--5gxpn/Q6ypwruk0T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7YajQACgkQbDjKyiDZ
s5LcVxAA3Fgzwvs7wQwUbjt6B+5U8qYfHBnYRsADRO/UVuOTJA/1pfPww4uElLIh
nL2u3R7+lQ9i4K4zHc5IgMYZQgIZOPhvTd59DiW9uKq/OuTRXqEgi4u3s5dy741g
BYGZaB7uVjA254RAEi1DJ1dXRpaZQZ4NFhySO0oq50WannYEKKR0NPIWgktexoCG
3r7AGy9t1dClE1iEpFJCmw8ziu8ZIWLNzQBLK9dDi2tAnycqYnjIn+cG8seBeSXn
U4exIFpYq4MbLPN/QbulFzZkUyZcN/t6U4zrEvjJ6JmZmqRuDJbmioWN3wr6evui
DxRbTyUxAawyaiv0t7/mI5XdKncZ1FwKq+gwlAm9aa4RFMU0XyX6N0nhdGt66HYe
KW6c70+ySDkYyokX9mGxl0+3gLE5RfjCWHyTzEzU/t0EeRoF5qcKNFIK0iaTvd/d
Lr2dJHAMGBLXLKssp7+yTPjPxXJj6VKLqp0yrd2tCMK6t9KwsqLTlKAQsAU49Bdo
SUDUrAVGl6bMAfuk6PAGw/WZvYHlhgOlXGt3pPh2o1SAUy9CXme9tlByVqIR6u4R
Ci+M1SF4iVemcV7BPqDNtGN4SAJVE1AAJ9X8jOxGGbPlqcO+oUWpn86QzB3vYtB7
FpW4Fj5Zj11ijUGr8FtL8lRwfISwwe599BmHW22rjO8eG3nhtJo=
=6yZ0
-----END PGP SIGNATURE-----

--5gxpn/Q6ypwruk0T--
