Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082E622AF60
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 14:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgGWMbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 08:31:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50194 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726521AbgGWMbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 08:31:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595507464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hFNWIHOIU+uuRiJhq/KM3YnMDRgv79jvgdv4/8Ovz2s=;
        b=WAS/W7xoCkaaW8QYnCN0mzLWKkhSG0PBbwWQLau0gheqPtembyCivBNjppwFQ4Z/HYQMn/
        g0fUQH3U35v1gl6KoaGMCHQjVtF+piQgheSnzKrmDlaiZ6aExRQN+8d/mDy6Rteb+ByYSa
        xaNqLVaYjR8AP+mCvebg+ABx4TBpc9o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-LwVxGiw6N_aqZioAHg7Jow-1; Thu, 23 Jul 2020 08:31:01 -0400
X-MC-Unique: LwVxGiw6N_aqZioAHg7Jow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86608102C81C;
        Thu, 23 Jul 2020 12:30:59 +0000 (UTC)
Received: from gondolin (ovpn-112-228.ams2.redhat.com [10.36.112.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BD8469327;
        Thu, 23 Jul 2020 12:30:32 +0000 (UTC)
Date:   Thu, 23 Jul 2020 14:30:15 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/3] s390x: Add custom pgm cleanup
 function
Message-ID: <20200723143015.5b4a027f.cohuck@redhat.com>
In-Reply-To: <8a7c9e38-8d92-0353-b883-368c2dcdec04@linux.ibm.com>
References: <20200717145813.62573-1-frankja@linux.ibm.com>
        <20200717145813.62573-2-frankja@linux.ibm.com>
        <20200723140112.6525ddba.cohuck@redhat.com>
        <8a7c9e38-8d92-0353-b883-368c2dcdec04@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; boundary="Sig_/JnLfsJX0zJJ=2KtzFF3XR2C";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/JnLfsJX0zJJ=2KtzFF3XR2C
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Jul 2020 14:23:48 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 7/23/20 2:01 PM, Cornelia Huck wrote:
> > On Fri, 17 Jul 2020 10:58:11 -0400
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >  =20
> >> Sometimes we need to do cleanup which we don't necessarily want to add
> >> to interrupt.c, so lets add a way to register a cleanup function. =20
> >=20
> > s/lets/let's/ :)
> >  =20
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> ---
> >>  lib/s390x/asm/interrupt.h | 1 +
> >>  lib/s390x/interrupt.c     | 9 +++++++++
> >>  2 files changed, 10 insertions(+)
> >>
> >> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> >> index 4cfade9..b2a7c83 100644
> >> --- a/lib/s390x/asm/interrupt.h
> >> +++ b/lib/s390x/asm/interrupt.h
> >> @@ -15,6 +15,7 @@
> >>  #define EXT_IRQ_EXTERNAL_CALL=090x1202
> >>  #define EXT_IRQ_SERVICE_SIG=090x2401
> >> =20
> >> +void register_pgm_int_func(void (*f)(void));
> >>  void handle_pgm_int(void);
> >>  void handle_ext_int(void);
> >>  void handle_mcck_int(void);
> >> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> >> index 243b9c2..36ba720 100644
> >> --- a/lib/s390x/interrupt.c
> >> +++ b/lib/s390x/interrupt.c
> >> @@ -16,6 +16,7 @@
> >> =20
> >>  static bool pgm_int_expected;
> >>  static bool ext_int_expected;
> >> +static void (*pgm_int_func)(void);
> >>  static struct lowcore *lc;
> >> =20
> >>  void expect_pgm_int(void)
> >> @@ -51,8 +52,16 @@ void check_pgm_int_code(uint16_t code)
> >>  =09       lc->pgm_int_code);
> >>  }
> >> =20
> >> +void register_pgm_int_func(void (*f)(void))
> >> +{
> >> +=09pgm_int_func =3D f;
> >> +}
> >> +
> >>  static void fixup_pgm_int(void)
> >>  {
> >> +=09if (pgm_int_func)
> >> +=09=09return (*pgm_int_func)();
> >> + =20
> >=20
> > Maybe rather call this function, if set, instead of fixup_pgm_int() in
> > handle_pgm_int()? Feels a bit cleaner to me. =20
>=20
> Well it's currently a cleanup function so it should be in
> fixup_pgm_int() because it fixes up.
>=20
> I don't need a handler here like Pierre with his IO changes.
>=20
> So it might more sense to change the name of the function ptr and
> registration function:
>=20
> register_pgm_cleanup_func()
> static void (*pgm_cleanup_func)(void);

Sounds good.

But doesn't that cleanup func run instead of the 'normal' cleanup func?
I think making that distinction in handle_pgm_int() is clearer.

>=20
> > =09=09 =20
> >>  =09switch (lc->pgm_int_code) {
> >>  =09case PGM_INT_CODE_PRIVILEGED_OPERATION:
> >>  =09=09/* Normal operation is in supervisor state, so this exception =
=20
> >  =20
>=20
>=20


--Sig_/JnLfsJX0zJJ=2KtzFF3XR2C
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl8ZgtcACgkQ3s9rk8bw
L69zzw//ZornbWhNu6SEmXBSwgq2SjQGwPsTWAQDiyFStirF59a89s9VLLvxclxM
loYg0H8mR3AjQWt4scIoVROqzXyDpxW5/JzqTmKgHZXmTEQBvd/peH2uykEPRTxZ
T9BwtE0yp9mHAqORWHinPSoTfFT1IUQsx6x2jkmfd3+oy09Xesupz7guyEAp0q7Y
sxfVuVZaeBRyM58e58flg7E7NQM1CU87bmx6UNWc9jsw3FlcH7YZ4ttOVBqA3eZX
pp92CiSMWnn9eYWu2qUinG9tIxQ4fNYTzevk9EEuhteGXb4Wr7yQ/4+jVQmYJAoq
IZrQZvvrE7tH2F88rfkG42FmPJaSlR38rxn/Lv3U4DbBpaABPHVwZrd6gThzB3I+
/bqE/k8meEYbP1rpppNeh8gsLPLOJ14gtWfgK6/IArcSx5wJwfygxhV6kDQSUyoO
O2j5iksKFYIGJf2CItO4DkT8Lw+SInv/Ln89rfSXZ2RCsJmvKsa+IjS/QZFJrnmV
WxCdFuKuRL8MGVJsF0l+mBUoWnb104DxmTusPS6syWJBnhQDd0vy0IWYrsxdD3te
342NmJ8qVH1uXVHObc/irMmB5VwEJROSfxp78VbZOhbWjNL4DvCEb2sUpjkGIc/b
1cFY2Q5SAPzgonUMloMF/JL65ZfJ0EyQtbOgebEbsGjAgeLdxjs=
=XrEj
-----END PGP SIGNATURE-----

--Sig_/JnLfsJX0zJJ=2KtzFF3XR2C--

