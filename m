Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4622F40E5
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 02:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbhAMBBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 20:01:37 -0500
Received: from ozlabs.org ([203.11.71.1]:46279 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727195AbhAMBBe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 20:01:34 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DFpz56P01z9sWg; Wed, 13 Jan 2021 12:00:49 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610499649;
        bh=92/N6i8vV03mgk9R8qy3lR/WI943eBY5tTiajLTE7Gw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zk1pyaUXGEYi8EzACgTYGPKYvQwWBtOYKPY8MDru3bgBQ8lRdVLUDnenCEK7/GI6s
         k8fxnRUtKkXVVw7ez1OjFbh3RmIBnI6PdHFxR/jASB4rABqHPggMylUcrVaPNlVzgd
         qWNYu1b0+hH5TXi2DybbZRR8z6Xcsts4s7oxL31c=
Date:   Wed, 13 Jan 2021 11:56:02 +1100
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
Subject: Re: [PATCH v6 10/13] spapr: Add PEF based confidential guest support
Message-ID: <20210113005602.GC435587@yekko.fritz.box>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
 <20210112044508.427338-11-david@gibson.dropbear.id.au>
 <20210112122750.5dcd995c@bahia.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
Content-Disposition: inline
In-Reply-To: <20210112122750.5dcd995c@bahia.lan>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Izn7cH1Com+I3R9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 12, 2021 at 12:27:50PM +0100, Greg Kurz wrote:
> On Tue, 12 Jan 2021 15:45:05 +1100
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > Some upcoming POWER machines have a system called PEF (Protected
> > Execution Facility) which uses a small ultravisor to allow guests to
> > run in a way that they can't be eavesdropped by the hypervisor.  The
> > effect is roughly similar to AMD SEV, although the mechanisms are
> > quite different.
> >=20
> > Most of the work of this is done between the guest, KVM and the
> > ultravisor, with little need for involvement by qemu.  However qemu
> > does need to tell KVM to allow secure VMs.
> >=20
> > Because the availability of secure mode is a guest visible difference
> > which depends on having the right hardware and firmware, we don't
> > enable this by default.  In order to run a secure guest you need to
> > create a "pef-guest" object and set the confidential-guest-support
> > property to point to it.
> >=20
> > Note that this just *allows* secure guests, the architecture of PEF is
> > such that the guest still needs to talk to the ultravisor to enter
> > secure mode.  Qemu has no directl way of knowing if the guest is in
> > secure mode, and certainly can't know until well after machine
> > creation time.
> >=20
> > To start a PEF-capable guest, use the command line options:
> >     -object pef-guest,id=3Dpef0 -machine confidential-guest-support=3Dp=
ef0
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  docs/confidential-guest-support.txt |   2 +
> >  docs/papr-pef.txt                   |  30 ++++++++
> >  hw/ppc/meson.build                  |   1 +
> >  hw/ppc/pef.c                        | 115 ++++++++++++++++++++++++++++
> >  hw/ppc/spapr.c                      |  10 +++
> >  include/hw/ppc/pef.h                |  26 +++++++
> >  target/ppc/kvm.c                    |  18 -----
> >  target/ppc/kvm_ppc.h                |   6 --
> >  8 files changed, 184 insertions(+), 24 deletions(-)
> >  create mode 100644 docs/papr-pef.txt
> >  create mode 100644 hw/ppc/pef.c
> >  create mode 100644 include/hw/ppc/pef.h
> >=20
> > diff --git a/docs/confidential-guest-support.txt b/docs/confidential-gu=
est-support.txt
> > index 2790425b38..d466aa79d5 100644
> > --- a/docs/confidential-guest-support.txt
> > +++ b/docs/confidential-guest-support.txt
> > @@ -40,4 +40,6 @@ Currently supported confidential guest mechanisms are:
> >  AMD Secure Encrypted Virtualization (SEV)
> >      docs/amd-memory-encryption.txt
> > =20
> > +POWER Protected Execution Facility (PEF)
>=20
> Maybe add:
>=20
>     /docs/papr-pef.txt

Good idea, added.

> > +
> >  Other mechanisms may be supported in future.
> > diff --git a/docs/papr-pef.txt b/docs/papr-pef.txt
> > new file mode 100644
> > index 0000000000..798e39f3ed
> > --- /dev/null
> > +++ b/docs/papr-pef.txt
> > @@ -0,0 +1,30 @@
> > +POWER (PAPR) Protected Execution Facility (PEF)
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Protected Execution Facility (PEF), also known as Secure Guest support
> > +is a feature found on IBM POWER9 and POWER10 processors.
> > +
> > +If a suitable firmware including an Ultravisor is installed, it adds
> > +an extra memory protection mode to the CPU.  The ultravisor manages a
> > +pool of secure memory which cannot be accessed by the hypervisor.
> > +
> > +When this feature is enabled in qemu, a guest can use ultracalls to
> > +enter "secure mode".  This transfers most of its memory to secure
> > +memory, where it cannot be eavesdropped by a compromised hypervisor.
> > +
> > +Launching
> > +---------
> > +
> > +To launch a guest which will be permitted to enter PEF secure mode:
> > +
> > +# ${QEMU} \
> > +    -object pef-guest \
>=20
> Add missing id=3Dpef0

Done.

> > +    -machine confidential-guest-support=3Dpef0 \
> > +    ...
> > +
> > +Live Migration
> > +----------------
> > +
> > +Live migration is not yet implemented for PEF guests.  For
> > +consistency, we currently prevent migration if the PEF feature is
> > +enabled, whether or not the guest has actuall entered secure mode.
>=20
> actually

Fixed, thanks.

>=20
> > diff --git a/hw/ppc/meson.build b/hw/ppc/meson.build
> > index ffa2ec37fa..218631c883 100644
> > --- a/hw/ppc/meson.build
> > +++ b/hw/ppc/meson.build
> > @@ -27,6 +27,7 @@ ppc_ss.add(when: 'CONFIG_PSERIES', if_true: files(
> >    'spapr_nvdimm.c',
> >    'spapr_rtas_ddw.c',
> >    'spapr_numa.c',
> > +  'pef.c',
> >  ))
> >  ppc_ss.add(when: 'CONFIG_SPAPR_RNG', if_true: files('spapr_rng.c'))
> >  ppc_ss.add(when: ['CONFIG_PSERIES', 'CONFIG_LINUX'], if_true: files(
> > diff --git a/hw/ppc/pef.c b/hw/ppc/pef.c
> > new file mode 100644
> > index 0000000000..b227dc6905
> > --- /dev/null
> > +++ b/hw/ppc/pef.c
> > @@ -0,0 +1,115 @@
> > +/*
> > + * PEF (Protected Execution Facility) for POWER support
> > + *
> > + * Copyright David Gibson, Redhat Inc. 2020
> > + *
> > + * This work is licensed under the terms of the GNU GPL, version 2 or =
later.
> > + * See the COPYING file in the top-level directory.
> > + *
> > + */
> > +
> > +#include "qemu/osdep.h"
> > +
> > +#include "qapi/error.h"
> > +#include "qom/object_interfaces.h"
> > +#include "sysemu/kvm.h"
> > +#include "migration/blocker.h"
> > +#include "exec/confidential-guest-support.h"
> > +#include "hw/ppc/pef.h"
> > +
> > +#define TYPE_PEF_GUEST "pef-guest"
> > +#define PEF_GUEST(obj)                                  \
> > +    OBJECT_CHECK(PefGuestState, (obj), TYPE_PEF_GUEST)
> > +
> > +typedef struct PefGuestState PefGuestState;
> > +
>=20
> Maybe convert to:
>=20
> #define TYPE_PEF_GUEST "pef-guest"
> OBJECT_DECLARE_SIMPLE_TYPE(PefGuestState, PEF_GUEST);

Right, I wasn't previously aware of those helper macros, so I need to
use them in a bunch of places.

> > +/**
> > + * PefGuestState:
> > + *
> > + * The PefGuestState object is used for creating and managing a PEF
> > + * guest.
> > + *
> > + * # $QEMU \
> > + *         -object pef-guest,id=3Dpef0 \
> > + *         -machine ...,confidential-guest-support=3Dpef0
> > + */
> > +struct PefGuestState {
> > +    Object parent_obj;
> > +};
> > +
> > +#ifdef CONFIG_KVM
> > +static int kvmppc_svm_init(Error **errp)
> > +{
> > +    if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURE_GUEST)) {
> > +        error_setg(errp,
> > +                   "KVM implementation does not support Secure VMs (is=
 an ultravisor running?)");
> > +        return -1;
> > +    } else {
> > +        int ret =3D kvm_vm_enable_cap(kvm_state, KVM_CAP_PPC_SECURE_GU=
EST, 0, 1);
> > +
> > +        if (ret < 0) {
> > +            error_setg(errp,
> > +                       "Error enabling PEF with KVM");
> > +            return -1;
> > +        }
> > +    }
> > +
> > +    return 0;
> > +}
> > +
> > +/*
> > + * Don't set error if KVM_PPC_SVM_OFF ioctl is invoked on kernels
> > + * that don't support this ioctl.
> > + */
> > +void kvmppc_svm_off(Error **errp)
> > +{
> > +    int rc;
> > +
> > +    if (!kvm_enabled()) {
> > +        return;
> > +    }
> > +
> > +    rc =3D kvm_vm_ioctl(KVM_STATE(current_accel()), KVM_PPC_SVM_OFF);
> > +    if (rc && rc !=3D -ENOTTY) {
> > +        error_setg_errno(errp, -rc, "KVM_PPC_SVM_OFF ioctl failed");
> > +    }
> > +}
> > +#else
> > +static int kvmppc_svm_init(Error **errp)
> > +{
> > +    g_assert_not_reached();
> > +}
> > +#endif
> > +
> > +int pef_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
> > +{
> > +    if (!object_dynamic_cast(OBJECT(cgs), TYPE_PEF_GUEST)) {
> > +        return 0;
> > +    }
> > +
> > +    if (!kvm_enabled()) {
> > +        error_setg(errp, "PEF requires KVM");
> > +        return -1;
> > +    }
> > +
> > +    return kvmppc_svm_init(errp);
> > +}
> > +
> > +static const TypeInfo pef_guest_info =3D {
> > +    .parent =3D TYPE_OBJECT,
> > +    .name =3D TYPE_PEF_GUEST,
> > +    .instance_size =3D sizeof(PefGuestState),
> > +    .interfaces =3D (InterfaceInfo[]) {
> > +        { TYPE_CONFIDENTIAL_GUEST_SUPPORT },
> > +        { TYPE_USER_CREATABLE },
> > +        { }
> > +    }
> > +};
> > +
> > +static void
> > +pef_register_types(void)
> > +{
> > +    type_register_static(&pef_guest_info);
> > +}
> > +
> > +type_init(pef_register_types);
> > diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
> > index 2c403b574e..5d0009cae7 100644
> > --- a/hw/ppc/spapr.c
> > +++ b/hw/ppc/spapr.c
> > @@ -83,6 +83,7 @@
> >  #include "hw/ppc/spapr_tpm_proxy.h"
> >  #include "hw/ppc/spapr_nvdimm.h"
> >  #include "hw/ppc/spapr_numa.h"
> > +#include "hw/ppc/pef.h"
> > =20
> >  #include "monitor/monitor.h"
> > =20
> > @@ -2657,6 +2658,15 @@ static void spapr_machine_init(MachineState *mac=
hine)
> >      long load_limit, fw_size;
> >      char *filename;
> >      Error *resize_hpt_err =3D NULL;
> > +    Error *local_err =3D NULL;
> > +
> > +    /*
> > +     * if Secure VM (PEF) support is configured, then initialize it
> > +     */
> > +    if (pef_kvm_init(machine->cgs, &local_err) < 0) {
> > +        error_report_err(local_err);
> > +        exit(1);
>=20
> It looks like you just need to pass &error_fatal to pef_kvm_init().

Good point, fixed.

> > +    }
> > =20
> >      msi_nonbroken =3D true;
> > =20
> > diff --git a/include/hw/ppc/pef.h b/include/hw/ppc/pef.h
> > new file mode 100644
> > index 0000000000..7c92391177
> > --- /dev/null
> > +++ b/include/hw/ppc/pef.h
> > @@ -0,0 +1,26 @@
> > +/*
> > + * PEF (Protected Execution Facility) for POWER support
> > + *
> > + * Copyright David Gibson, Redhat Inc. 2020
> > + *
> > + * This work is licensed under the terms of the GNU GPL, version 2 or =
later.
> > + * See the COPYING file in the top-level directory.
> > + *
> > + */
> > +
> > +#ifndef HW_PPC_PEF_H
> > +#define HW_PPC_PEF_H
> > +
> > +int pef_kvm_init(ConfidentialGuestSupport *cgs, Error **errp);
> > +
> > +#ifdef CONFIG_KVM
> > +void kvmppc_svm_off(Error **errp);
> > +#else
> > +static inline void kvmppc_svm_off(Error **errp)
> > +{
> > +}
> > +#endif
> > +
> > +
> > +#endif /* HW_PPC_PEF_H */
> > +
> > diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> > index daf690a678..0c5056dd5b 100644
> > --- a/target/ppc/kvm.c
> > +++ b/target/ppc/kvm.c
> > @@ -2929,21 +2929,3 @@ void kvmppc_set_reg_tb_offset(PowerPCCPU *cpu, i=
nt64_t tb_offset)
> >          kvm_set_one_reg(cs, KVM_REG_PPC_TB_OFFSET, &tb_offset);
> >      }
> >  }
> > -
> > -/*
> > - * Don't set error if KVM_PPC_SVM_OFF ioctl is invoked on kernels
> > - * that don't support this ioctl.
> > - */
> > -void kvmppc_svm_off(Error **errp)
> > -{
> > -    int rc;
> > -
> > -    if (!kvm_enabled()) {
> > -        return;
> > -    }
> > -
> > -    rc =3D kvm_vm_ioctl(KVM_STATE(current_accel()), KVM_PPC_SVM_OFF);
> > -    if (rc && rc !=3D -ENOTTY) {
> > -        error_setg_errno(errp, -rc, "KVM_PPC_SVM_OFF ioctl failed");
> > -    }
> > -}
> > diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
> > index 73ce2bc951..989f61ace0 100644
> > --- a/target/ppc/kvm_ppc.h
> > +++ b/target/ppc/kvm_ppc.h
> > @@ -39,7 +39,6 @@ int kvmppc_booke_watchdog_enable(PowerPCCPU *cpu);
> >  target_ulong kvmppc_configure_v3_mmu(PowerPCCPU *cpu,
> >                                       bool radix, bool gtse,
> >                                       uint64_t proc_tbl);
> > -void kvmppc_svm_off(Error **errp);
> >  #ifndef CONFIG_USER_ONLY
> >  bool kvmppc_spapr_use_multitce(void);
> >  int kvmppc_spapr_enable_inkernel_multitce(void);
> > @@ -216,11 +215,6 @@ static inline target_ulong kvmppc_configure_v3_mmu=
(PowerPCCPU *cpu,
> >      return 0;
> >  }
> > =20
> > -static inline void kvmppc_svm_off(Error **errp)
> > -{
> > -    return;
> > -}
> > -
> >  static inline void kvmppc_set_reg_ppc_online(PowerPCCPU *cpu,
> >                                               unsigned int online)
> >  {
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/+RSIACgkQbDjKyiDZ
s5KAAxAAuqJsdHJRcqPwwDt0uelosJ+CP8vuXoe5FY4TJOpRGc025OohHBNo5M34
5EvVYyKCR6fPrRhOqssP1hBbVvtWd5yJCjX/aasKSyhI9K7DH2x8N5hdLhBXgEQi
9wT3T2LdY/gjTpm3atLYdr79v3Mg++DxbcnddzgjKRYBJ0Tmsr90LRN+uG3b8jD8
nWb/tZeChadm9+Xr8FFBoxyXrCrBbNaUqIVDn/CjgsUHPTRzyP+CRq8e3WCQzr2W
QbV5CZPEpvQEVlICco1Js1NJrCmTTYk3xSfDkHVw2JFMPzODq1F1cJoBa7T1I+t1
uACmXOYhXHyBeHsSebrJbueKi05aB8f8MToY544bXK/DJbTbvG+ygdoUVApVaaWp
grblPS2deGyTR+Ll54h3flaDxXl89s90Dv8ZD0bIDKPtPwGq34+wJ6KAy2PWRYn6
ln9eto1q8O3ZqWr4la/+2m47d1Ao1h/ZE4sWfaaIgruWV+WuT6B/1w05tAvzpMRo
7WH2kf03eiOzoo8ftLI41avWSUzCaxiwGRl/LDwdIXesyGV5yyYiMtBDmbXq7t0U
WQWj1yB4muL76GcowSV7KLU+v9uGTWTUCvReIn1CQOfUZb3NYNf2a7jFWVvr6h10
AHVhpZceFR/u2Ctg3GU3IrMxjhuWQXKhGM/aqyG6d2McnG8PNJA=
=rHSn
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--
