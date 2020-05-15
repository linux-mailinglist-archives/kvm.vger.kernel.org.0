Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015B71D433F
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 03:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgEOBxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 21:53:16 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40123 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbgEOBxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 21:53:16 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49NWdj4nlDz9sSk; Fri, 15 May 2020 11:53:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1589507593;
        bh=8+HDl0+Mb9/gGf6aZeh8gPCrbogAfW1EuRBO8TNJsC0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DwlwBHhbmTR7yM2M4GNJQvX6qrk/w6o5PEueg45XJz8SY/EMZ3vfjYeFo41AlRAZe
         /dyqWsHcySTMELY2rdCKIlO/t2WBjowTZH845N4COQ22qcj8SLuQn7hqDnwKUcLQpx
         jk3TZeTfwWBeqFvC6FJgvBruouH16jU+pbSXefbQ=
Date:   Fri, 15 May 2020 10:20:46 +1000
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
Message-ID: <20200515002046.GG2183@umbus.fritz.box>
References: <20200514064120.449050-1-david@gibson.dropbear.id.au>
 <20200514064120.449050-17-david@gibson.dropbear.id.au>
 <20200514170808.GS2787@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oPYnW2SrAqZUvu4n"
Content-Disposition: inline
In-Reply-To: <20200514170808.GS2787@work-vm>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--oPYnW2SrAqZUvu4n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 14, 2020 at 06:09:46PM +0100, Dr. David Alan Gilbert wrote:
> * David Gibson (david@gibson.dropbear.id.au) wrote:
[snip]
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

Oops, fixed.  I'm not really familiar with the g_autofree stuff as
yet, so, maybe?

I also entirely forgot to write a non-placeholder commit message for
this patch.  Oops.

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

--oPYnW2SrAqZUvu4n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl694F4ACgkQbDjKyiDZ
s5Ld6RAAjjnTBYvSoeB8OguHxaf+Op4h3GWm9edsFHpqqsdGRwW/1Hfn+MvCi24F
iV0iUPhksKarxOnsgmfbKDNe0onkjiQf3CmwmhNLX6urRkpDj5H+k2fWQuVa7dTe
jdkIrcNdVWPuEU1GgNbWSSMGWMfQ2XmIJxvgVPMGYgvDoH2gwjN8oVprVcOw9NO/
HF7hCGwwZs22x1qLXmrvBPQOeOQ2lh4s38DBGoeJJPIsivumdoJNac9TrHxAetDc
/Rqy//xMtLFtB8lvDxDLJsvrZvX+yjdLTjqtV4U4WXEpTXA4+nWbFyTndgcdCVkH
RB+IAdVEXAReCyrSc8JL25rgB41j18xb9lSCLKlh6Hel9Q6jUQzLN8xudAdfigBT
9akUvOW/8FWT8fjKfoBjwfcG5Qo2FbomEsX453Qg9jFpJopJ0eKucomxiKb3jbrR
IrvjPU+8H+m0lREMQp+2IrVABT5GUunMQzrIxx0UjNSGqjafjSaRdb9ylmebPSni
NgAIf1Q1RFHVzHLLXFR8PD/i09Z3W3QMBVBcOR8LR8SjH/sRcwZA67kKD9zcOrn1
x2o9PEZ4dOBhIS7ANBzqlIRbJK2tiQ79tijUbQLLvbQHhEtvm3kKyUcp+361V+lS
T5C6gTaO1R1zZf68S/lXPO3w6ftT+2RCyC5DiXg3ObHRpY7eUqQ=
=z7mk
-----END PGP SIGNATURE-----

--oPYnW2SrAqZUvu4n--
