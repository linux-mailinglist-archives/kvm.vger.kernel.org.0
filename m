Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD002F40E8
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 02:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbhAMBCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 20:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728163AbhAMBBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 20:01:47 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D0BC061786
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 17:01:06 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DFpz46T7nz9sVy; Wed, 13 Jan 2021 12:00:48 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610499649;
        bh=tHyp3lLQuiadcdd7kmXJVsnCWsUjem1K5rL1oXG0wIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ebb3uB1Kz2exZ1qXiKaI9B9IJWt/WOQcxgxHm3xCy1B8WlqOz2obkF94qQWN1e0lp
         e2bwJ+DY6Te8sVM2N9J/YmkLqJVl5+cRP1V0Auoms3LChsTcVWjcEbWi8zKDTqxu0y
         wHm2J/F3trbwNRCWvC67H5YLoS3CjA385Ox+Vk2Q=
Date:   Wed, 13 Jan 2021 11:50:32 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Greg Kurz <groug@kaod.org>
Cc:     pasic@linux.ibm.com, brijesh.singh@amd.com, pair@us.ibm.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org, andi.kleen@intel.com,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, frankja@linux.ibm.com,
        thuth@redhat.com, Christian Borntraeger <borntraeger@de.ibm.com>,
        mdroth@linux.vnet.ibm.com, richard.henderson@linaro.org,
        kvm@vger.kernel.org,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, mst@redhat.com,
        qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
Subject: Re: [PATCH v6 05/13] confidential guest support: Rework the
 "memory-encryption" property
Message-ID: <20210113005032.GA435587@yekko.fritz.box>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
 <20210112044508.427338-6-david@gibson.dropbear.id.au>
 <20210112115959.2c042dbb@bahia.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <20210112115959.2c042dbb@bahia.lan>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 12, 2021 at 11:59:59AM +0100, Greg Kurz wrote:
> On Tue, 12 Jan 2021 15:45:00 +1100
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > Currently the "memory-encryption" property is only looked at once we
> > get to kvm_init().  Although protection of guest memory from the
> > hypervisor isn't something that could really ever work with TCG, it's
> > not conceptually tied to the KVM accelerator.
> >=20
> > In addition, the way the string property is resolved to an object is
> > almost identical to how a QOM link property is handled.
> >=20
> > So, create a new "confidential-guest-support" link property which sets
> > this QOM interface link directly in the machine.  For compatibility we
> > keep the "memory-encryption" property, but now implemented in terms of
> > the new property.
>=20
> Do we really want to keep "memory-encryption" in the long term ? If
> not, then maybe engage the deprecation process and add a warning in
> machine_set_memory_encryption() ?

Hmm.. I kind of think that's up to the SEV people to decide on the
timetable (if any) for deprecation - it's their existing option.  In
any case I'd prefer to leave that to a separate patch.

Dave (Gilbert), any opinions?

> Apart from that, LGTM:
>=20
> Reviewed-by: Greg Kurz <groug@kaod.org>
>=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  accel/kvm/kvm-all.c  |  5 +++--
> >  accel/kvm/sev-stub.c |  5 +++--
> >  hw/core/machine.c    | 43 +++++++++++++++++++++++++++++++++++++------
> >  include/hw/boards.h  |  2 +-
> >  include/sysemu/sev.h |  2 +-
> >  target/i386/sev.c    | 32 ++------------------------------
> >  6 files changed, 47 insertions(+), 42 deletions(-)
> >=20
> > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> > index 260ed73ffe..28ab126f70 100644
> > --- a/accel/kvm/kvm-all.c
> > +++ b/accel/kvm/kvm-all.c
> > @@ -2181,8 +2181,9 @@ static int kvm_init(MachineState *ms)
> >       * if memory encryption object is specified then initialize the me=
mory
> >       * encryption context.
> >       */
> > -    if (ms->memory_encryption) {
> > -        ret =3D sev_guest_init(ms->memory_encryption);
> > +    if (ms->cgs) {
> > +        /* FIXME handle mechanisms other than SEV */
> > +        ret =3D sev_kvm_init(ms->cgs);
> >          if (ret < 0) {
> >              goto err;
> >          }
> > diff --git a/accel/kvm/sev-stub.c b/accel/kvm/sev-stub.c
> > index 5db9ab8f00..3d4787ae4a 100644
> > --- a/accel/kvm/sev-stub.c
> > +++ b/accel/kvm/sev-stub.c
> > @@ -15,7 +15,8 @@
> >  #include "qemu-common.h"
> >  #include "sysemu/sev.h"
> > =20
> > -int sev_guest_init(const char *id)
> > +int sev_kvm_init(ConfidentialGuestSupport *cgs)
> >  {
> > -    return -1;
> > +    /* SEV can't be selected if it's not compiled */
> > +    g_assert_not_reached();
> >  }
> > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > index 8909117d80..94194ab82d 100644
> > --- a/hw/core/machine.c
> > +++ b/hw/core/machine.c
> > @@ -32,6 +32,7 @@
> >  #include "hw/mem/nvdimm.h"
> >  #include "migration/global_state.h"
> >  #include "migration/vmstate.h"
> > +#include "exec/confidential-guest-support.h"
> > =20
> >  GlobalProperty hw_compat_5_2[] =3D {};
> >  const size_t hw_compat_5_2_len =3D G_N_ELEMENTS(hw_compat_5_2);
> > @@ -427,16 +428,37 @@ static char *machine_get_memory_encryption(Object=
 *obj, Error **errp)
> >  {
> >      MachineState *ms =3D MACHINE(obj);
> > =20
> > -    return g_strdup(ms->memory_encryption);
> > +    if (ms->cgs) {
> > +        return g_strdup(object_get_canonical_path_component(OBJECT(ms-=
>cgs)));
> > +    }
> > +
> > +    return NULL;
> >  }
> > =20
> >  static void machine_set_memory_encryption(Object *obj, const char *val=
ue,
> >                                          Error **errp)
> >  {
> > -    MachineState *ms =3D MACHINE(obj);
> > +    Object *cgs =3D
> > +        object_resolve_path_component(object_get_objects_root(), value=
);
> > +
> > +    if (!cgs) {
> > +        error_setg(errp, "No such memory encryption object '%s'", valu=
e);
> > +        return;
> > +    }
> > =20
> > -    g_free(ms->memory_encryption);
> > -    ms->memory_encryption =3D g_strdup(value);
> > +    object_property_set_link(obj, "confidential-guest-support", cgs, e=
rrp);
> > +}
> > +
> > +static void machine_check_confidential_guest_support(const Object *obj,
> > +                                                     const char *name,
> > +                                                     Object *new_targe=
t,
> > +                                                     Error **errp)
> > +{
> > +    /*
> > +     * So far the only constraint is that the target has the
> > +     * TYPE_CONFIDENTIAL_GUEST_SUPPORT interface, and that's checked
> > +     * by the QOM core
> > +     */
> >  }
> > =20
> >  static bool machine_get_nvdimm(Object *obj, Error **errp)
> > @@ -836,6 +858,15 @@ static void machine_class_init(ObjectClass *oc, vo=
id *data)
> >      object_class_property_set_description(oc, "suppress-vmdesc",
> >          "Set on to disable self-describing migration");
> > =20
> > +    object_class_property_add_link(oc, "confidential-guest-support",
> > +                                   TYPE_CONFIDENTIAL_GUEST_SUPPORT,
> > +                                   offsetof(MachineState, cgs),
> > +                                   machine_check_confidential_guest_su=
pport,
> > +                                   OBJ_PROP_LINK_STRONG);
> > +    object_class_property_set_description(oc, "confidential-guest-supp=
ort",
> > +                                          "Set confidential guest sche=
me to support");
> > +
> > +    /* For compatibility */
> >      object_class_property_add_str(oc, "memory-encryption",
> >          machine_get_memory_encryption, machine_set_memory_encryption);
> >      object_class_property_set_description(oc, "memory-encryption",
> > @@ -1158,9 +1189,9 @@ void machine_run_board_init(MachineState *machine)
> >                      cc->deprecation_note);
> >      }
> > =20
> > -    if (machine->memory_encryption) {
> > +    if (machine->cgs) {
> >          /*
> > -         * With memory encryption, the host can't see the real
> > +         * With confidential guests, the host can't see the real
> >           * contents of RAM, so there's no point in it trying to merge
> >           * areas.
> >           */
> > diff --git a/include/hw/boards.h b/include/hw/boards.h
> > index 17b1f3f0b9..1acd662fa5 100644
> > --- a/include/hw/boards.h
> > +++ b/include/hw/boards.h
> > @@ -270,7 +270,7 @@ struct MachineState {
> >      bool iommu;
> >      bool suppress_vmdesc;
> >      bool enable_graphics;
> > -    char *memory_encryption;
> > +    ConfidentialGuestSupport *cgs;
> >      char *ram_memdev_id;
> >      /*
> >       * convenience alias to ram_memdev_id backend memory region
> > diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
> > index 7335e59867..3b5b1aacf1 100644
> > --- a/include/sysemu/sev.h
> > +++ b/include/sysemu/sev.h
> > @@ -16,7 +16,7 @@
> > =20
> >  #include "sysemu/kvm.h"
> > =20
> > -int sev_guest_init(const char *id);
> > +int sev_kvm_init(ConfidentialGuestSupport *cgs);
> >  int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
> >  int sev_inject_launch_secret(const char *hdr, const char *secret,
> >                               uint64_t gpa, Error **errp);
> > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > index 2a4b2187d6..5399a136ad 100644
> > --- a/target/i386/sev.c
> > +++ b/target/i386/sev.c
> > @@ -335,26 +335,6 @@ static const TypeInfo sev_guest_info =3D {
> >      }
> >  };
> > =20
> > -static SevGuestState *
> > -lookup_sev_guest_info(const char *id)
> > -{
> > -    Object *obj;
> > -    SevGuestState *info;
> > -
> > -    obj =3D object_resolve_path_component(object_get_objects_root(), i=
d);
> > -    if (!obj) {
> > -        return NULL;
> > -    }
> > -
> > -    info =3D (SevGuestState *)
> > -            object_dynamic_cast(obj, TYPE_SEV_GUEST);
> > -    if (!info) {
> > -        return NULL;
> > -    }
> > -
> > -    return info;
> > -}
> > -
> >  bool
> >  sev_enabled(void)
> >  {
> > @@ -682,10 +662,9 @@ sev_vm_state_change(void *opaque, int running, Run=
State state)
> >      }
> >  }
> > =20
> > -int
> > -sev_guest_init(const char *id)
> > +int sev_kvm_init(ConfidentialGuestSupport *cgs)
> >  {
> > -    SevGuestState *sev;
> > +    SevGuestState *sev =3D SEV_GUEST(cgs);
> >      char *devname;
> >      int ret, fw_error;
> >      uint32_t ebx;
> > @@ -698,13 +677,6 @@ sev_guest_init(const char *id)
> >          return -1;
> >      }
> > =20
> > -    sev =3D lookup_sev_guest_info(id);
> > -    if (!sev) {
> > -        error_report("%s: '%s' is not a valid '%s' object",
> > -                     __func__, id, TYPE_SEV_GUEST);
> > -        goto err;
> > -    }
> > -
> >      sev_guest =3D sev;
> >      sev->state =3D SEV_STATE_UNINIT;
> > =20
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/+Q9YACgkQbDjKyiDZ
s5Itqg//dvbFemq8fGIAOo6kUOxQMboUPav00y5lzKkXkhToC8W3++z1mihjKge5
K1CkwtChyudBrhIO7mNbwZdWMkW+7BWzxmJgMw5u8mgeyPiA96RYnTZOKqI8Mmgs
7hCr1LJsWOQjuN+fvXM92u/ePxzdAVeeKtWYxvBANKXb6Ez3KzpxlfiW7/wmDrIc
T6Kk8ZZipjFIbMihbl/wt80BoMQEiyAvngx0mGgHoF9XnICPqjVXxqtQaSSqSEOU
DNpz3NCxSQJG3LVZvRGBiDA6E8Vw/cHrEPtb1tjkCRgBWz0UvhoN4uRirXaKYrL2
wXKpmgbbZtN5fov1R96YXSyfvXE6byWOpwJ448kwvKdFlMTWMJMYDtZMcKtjZ1Xz
5HSyzz2NAqMtCDxNkBvTSD7SYl1pMSjJ1aZ0UuvW2hN8pBZ90pi0Al2ksjq6Pj8J
ZrZC6mPEQ4wXGx10wqY14vAYsH35GcupffOmoNigAKr0ZT8CudDDgb4jGHTQR1Zm
mdEW724C95/CtqWeDhIknmLLpvTOziVyszc2g0SZ7PlJ1yrQZdGSAA9n8M5H4/ji
Bp/sRMWLDibOETZYzeK9OtXHG+xgTDYrMYnrpOxn85aJ0B9h+N2bEutT8olVtlyp
6Eengd4+E38O0ZlY02plbor/UK2fJIkGW9xFjBF+SK4o3Db6EOw=
=SS0Y
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
