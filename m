Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B04B2F9809
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 04:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbhARDFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 22:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbhARDFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jan 2021 22:05:18 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E902EC061573
        for <kvm@vger.kernel.org>; Sun, 17 Jan 2021 19:04:37 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DJxTZ20N5z9sVS; Mon, 18 Jan 2021 14:04:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610939074;
        bh=19ZhsKQRbEsGZBpmPQe7yoYh0jntDutUTZZSvePFwCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KeIVG9Z/nYNzUqbirHqkRt+kNHEH4qezfYP8nuriF6TClzIm58BdbOc7YCFXTRi/T
         njBmZD7YnAEPDUjW+WfMsOU91k5mOXP8vXJiGFDsamjk7I6MrwCZNkl4lUcZN/IjN1
         3Wy3Jj2N84/D1B1i32MBg0JxpB/PsxmgncCWYDRY=
Date:   Mon, 18 Jan 2021 14:03:08 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        pasic@linux.ibm.com, qemu-devel@nongnu.org,
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
Subject: Re: [PATCH v7 08/13] confidential guest support: Move SEV
 initialization into arch specific code
Message-ID: <20210118030308.GG2089552@yekko.fritz.box>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
 <20210113235811.1909610-9-david@gibson.dropbear.id.au>
 <20210115142425.540b6126.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1XWsVB21DFCvn2e8"
Content-Disposition: inline
In-Reply-To: <20210115142425.540b6126.cohuck@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--1XWsVB21DFCvn2e8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 15, 2021 at 02:24:25PM +0100, Cornelia Huck wrote:
> On Thu, 14 Jan 2021 10:58:06 +1100
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > While we've abstracted some (potential) differences between mechanisms =
for
> > securing guest memory, the initialization is still specific to SEV.  Gi=
ven
> > that, move it into x86's kvm_arch_init() code, rather than the generic
> > kvm_init() code.
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  accel/kvm/kvm-all.c   | 14 --------------
> >  accel/kvm/sev-stub.c  |  4 ++--
> >  target/i386/kvm/kvm.c | 12 ++++++++++++
> >  target/i386/sev.c     |  7 ++++++-
> >  4 files changed, 20 insertions(+), 17 deletions(-)
> >=20
>=20
> (...)
>=20
> > @@ -2135,6 +2136,17 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
> >      uint64_t shadow_mem;
> >      int ret;
> >      struct utsname utsname;
> > +    Error *local_err =3D NULL;
> > +
> > +    /*
> > +     * if memory encryption object is specified then initialize the
> > +     * memory encryption context (no-op otherwise)
> > +     */
> > +    ret =3D sev_kvm_init(ms->cgs, &local_err);
>=20
> Maybe still leave a comment here, as the code will still need to be
> modified to handle non-SEV x86 mechanisms?

Uh.. I'm confused.. this hunk is adding a comment, not removing one..

>=20
> > +    if (ret < 0) {
> > +        error_report_err(local_err);
> > +        return ret;
> > +    }
> > =20
> >      if (!kvm_check_extension(s, KVM_CAP_IRQ_ROUTING)) {
> >          error_report("kvm: KVM_CAP_IRQ_ROUTING not supported by KVM");
> > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > index 3d94635397..aa79cacabe 100644
> > --- a/target/i386/sev.c
> > +++ b/target/i386/sev.c
> > @@ -664,13 +664,18 @@ sev_vm_state_change(void *opaque, int running, Ru=
nState state)
> > =20
> >  int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
> >  {
> > -    SevGuestState *sev =3D SEV_GUEST(cgs);
> > +    SevGuestState *sev
> > +        =3D (SevGuestState *)object_dynamic_cast(OBJECT(cgs), TYPE_SEV=
_GUEST);
>=20
> This looks a bit ugly; maybe we want the generic code to generate a
> separate version of the cast macro that doesn't assert? Just cosmetics,
> though.

I tend to the view that the clunkiness of this textually is
outweighted by using object_dynamic_cast() which has well known
semantics, rather than requiring someone reading the code to
understand another intermediate macro.

> >      char *devname;
> >      int ret, fw_error;
> >      uint32_t ebx;
> >      uint32_t host_cbitpos;
> >      struct sev_user_data_status status =3D {};
> > =20
> > +    if (!sev) {
> > +        return 0;
> > +    }
> > +
> >      ret =3D ram_block_discard_disable(true);
> >      if (ret) {
> >          error_report("%s: cannot disable RAM discard", __func__);
>=20
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--1XWsVB21DFCvn2e8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmAE+mwACgkQbDjKyiDZ
s5JmlQ//TxCrs3vQHpA/Vy+qnAXlrIP8nw9BCkEPRSFJUEy8MpuZ8UTtpgdCHvRg
jqnJV0w+ybDGxk6gllJAGmHALhNyoLVIPdM/WpCHlyWzHW4Nqn2L/Hm2OLRgJi2X
TfQiDiDwTfrasx9bledF15VojdBSQkeeLagCx19F7pK5YaquzMKcytD1evb2ADk5
quFxpmlX8QtMR6EjTI/GAxBk8vcZmNPvW7OuOQ4QiMCaozwRuku8nOQ/NnmQPTDh
Iqp6isqO2DtXZb1IN9S8qwozMBoyS5HUjsBRT2JbV2MpaIxhkDiBfxeDo7YRHxVz
OmfgaUbqCDrFa8Mkbl8yKSlW9+Rb87B5fg0/M1JCsaIKLHHDIMGyXKCpXjRDeDMw
AxfuF9oYzXP+6/DvxgaT2QFdA2v7VBFjhViwlu6XSi3eRhIhokypt+R3MmWvjAYO
EL/5g0py6oBNL3hcQRcREaOD7bCtwTrEK3CD3P0MeSaRKWEC7crmeCYH/LacnfRF
6YF2vvQwpBbZPgLeHmjqwSY0RpSt1uOhI0SLjHWpwn5TGqxnak0GqbYBBdXt/o+V
kqK2aMPiHcL5fWmkSo//2ANJHGSxZKjSMRU5C0mc47xY8HYoZQDdhebwYemZFbqx
Rj+lLwpduJow5zDW8jqBjIy0fKWa97npooF5mO85v9W/3neUcgw=
=Dpic
-----END PGP SIGNATURE-----

--1XWsVB21DFCvn2e8--
