Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA50260DB1
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 10:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgIHIhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 04:37:21 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37275 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729564AbgIHIhV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 04:37:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599554239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wJoP8WNH4YEsHOSFQhOCbA/eHmTxNrmUtf+foyTusYc=;
        b=UbnBeDZLTCWYMv+lzIdDFZWVz1HF0t27vhreTa+O5h+iz4CJKq7Zvv4ylKqVlCJBUbK4Hx
        +yXGxy4RVjlD3IOcDVUtK4zK/Nt3XuBgjLVWAL6q6yj2VPbxbFWxxuLulyQgZIQk2xgFX5
        /Kehq4WPmqDynacv12/R6pUC4Btddo8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-xwSTiHpvOSGL0sxwrFdpVA-1; Tue, 08 Sep 2020 04:37:16 -0400
X-MC-Unique: xwSTiHpvOSGL0sxwrFdpVA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39A0E18B9EEC;
        Tue,  8 Sep 2020 08:37:15 +0000 (UTC)
Received: from gondolin (ovpn-112-243.ams2.redhat.com [10.36.112.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CF2260C0F;
        Tue,  8 Sep 2020 08:37:10 +0000 (UTC)
Date:   Tue, 8 Sep 2020 10:36:50 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v2] KVM: s390: Introduce storage key removal facility
Message-ID: <20200908103650.0c8cf352.cohuck@redhat.com>
In-Reply-To: <cd3ce2d9-99a5-5bb5-9b13-62d378274265@linux.ibm.com>
References: <b34e559a-8292-873f-8d33-1e7ce819f4d5@de.ibm.com>
        <20200907143352.96618-1-frankja@linux.ibm.com>
        <20200907183030.07333af7.cohuck@redhat.com>
        <cd3ce2d9-99a5-5bb5-9b13-62d378274265@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=cohuck@redhat.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; boundary="Sig_/TTGqsGHzVXO8j5+YVamdOf4";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/TTGqsGHzVXO8j5+YVamdOf4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 8 Sep 2020 09:52:48 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 9/7/20 6:30 PM, Cornelia Huck wrote:
> > On Mon,  7 Sep 2020 10:33:52 -0400
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >  =20
> >> The storage key removal facility makes skey related instructions
> >> result in special operation program exceptions. It is based on the
> >> Keyless Subset Facility.
> >>
> >> The usual suspects are iske, sske, rrbe and their respective
> >> variants. lpsw(e), pfmf and tprot can also specify a key and essa with
> >> an ORC of 4 will consult the change bit, hence they all result in
> >> exceptions.
> >>
> >> Unfortunately storage keys were so essential to the architecture, that
> >> there is no facility bit that we could deactivate. That's why the
> >> removal facility (bit 169) was introduced which makes it necessary,
> >> that, if active, the skey related facilities 10, 14, 66, 145 and 149
> >> are zero. Managing this requirement and migratability has to be done
> >> in userspace, as KVM does not check the facilities it receives to be
> >> able to easily implement userspace emulation.
> >>
> >> Removing storage key support allows us to circumvent complicated
> >> emulation code and makes huge page support tremendously easier.
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> ---
> >>
> >> v2:
> >> =09* Removed the likely
> >> =09* Updated and re-shuffeled the comments which had the wrong informa=
tion
> >>
> >> ---
> >>  arch/s390/kvm/intercept.c | 40 ++++++++++++++++++++++++++++++++++++++=
-
> >>  arch/s390/kvm/kvm-s390.c  |  5 +++++
> >>  arch/s390/kvm/priv.c      | 26 ++++++++++++++++++++++---
> >>  3 files changed, 67 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> >> index e7a7c499a73f..983647ea2abe 100644
> >> --- a/arch/s390/kvm/intercept.c
> >> +++ b/arch/s390/kvm/intercept.c
> >> @@ -33,6 +33,7 @@ u8 kvm_s390_get_ilen(struct kvm_vcpu *vcpu)
> >>  =09case ICPT_OPEREXC:
> >>  =09case ICPT_PARTEXEC:
> >>  =09case ICPT_IOINST:
> >> +=09case ICPT_KSS:
> >>  =09=09/* instruction only stored for these icptcodes */
> >>  =09=09ilen =3D insn_length(vcpu->arch.sie_block->ipa >> 8);
> >>  =09=09/* Use the length of the EXECUTE instruction if necessary */
> >> @@ -565,7 +566,44 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcp=
u)
> >>  =09=09rc =3D handle_partial_execution(vcpu);
> >>  =09=09break;
> >>  =09case ICPT_KSS:
> >> -=09=09rc =3D kvm_s390_skey_check_enable(vcpu);
> >> +=09=09if (!test_kvm_facility(vcpu->kvm, 169)) {
> >> +=09=09=09rc =3D kvm_s390_skey_check_enable(vcpu);
> >> +=09=09} else { =20
> >=20
> > <bikeshed>Introduce a helper function? This is getting a bit hard to
> > read.</bikeshed>
> >  =20
> >> +=09=09=09/*
> >> +=09=09=09 * Storage key removal facility emulation.
> >> +=09=09=09 *
> >> +=09=09=09 * KSS is the same priority as an instruction
> >> +=09=09=09 * interception. Hence we need handling here
> >> +=09=09=09 * and in the instruction emulation code.
> >> +=09=09=09 *
> >> +=09=09=09 * KSS is nullifying (no psw forward), SKRF
> >> +=09=09=09 * issues suppressing SPECIAL OPS, so we need
> >> +=09=09=09 * to forward by hand.
> >> +=09=09=09 */
> >> +=09=09=09switch (vcpu->arch.sie_block->ipa) {
> >> +=09=09=09case 0xb2b2:
> >> +=09=09=09=09kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
> >> +=09=09=09=09rc =3D kvm_s390_handle_b2(vcpu);
> >> +=09=09=09=09break;
> >> +=09=09=09case 0x8200: =20
> >=20
> > Can we have speaking names? I can only guess that this is an lpsw... =
=20
>=20
> You can only guess from the kvm_s390_handle_lpsw() call below? ;-)
>=20
> I'd be happy to put this into an own function and add some comments to
> the cases where we lack them. However, I don't really want to define
> constants for speaking names.

Well, I can guess the lpsw here :) but not the b2b2 above. Maybe add a
comment like /* handle lpsw/lpswe */?

>=20
> >  =20
> >> +=09=09=09=09kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
> >> +=09=09=09=09rc =3D kvm_s390_handle_lpsw(vcpu);
> >> +=09=09=09=09break;
> >> +=09=09=09case 0:
> >> +=09=09=09=09/*
> >> +=09=09=09=09 * Interception caused by a key in a
> >> +=09=09=09=09 * exception new PSW mask. The guest
> >> +=09=09=09=09 * PSW has already been updated to the
> >> +=09=09=09=09 * non-valid PSW so we only need to
> >> +=09=09=09=09 * inject a PGM.
> >> +=09=09=09=09 */
> >> +=09=09=09=09rc =3D kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATIO=
N);
> >> +=09=09=09=09break;
> >> +=09=09=09default:
> >> +=09=09=09=09kvm_s390_forward_psw(vcpu, kvm_s390_get_ilen(vcpu));
> >> +=09=09=09=09rc =3D kvm_s390_inject_program_int(vcpu, PGM_SPECIAL_OPER=
ATION);
> >> +=09=09=09}
> >> +=09=09}
> >>  =09=09break;
> >>  =09case ICPT_MCHKREQ:
> >>  =09case ICPT_INT_ENABLE: =20
> >  =20
>=20
>=20


--Sig_/TTGqsGHzVXO8j5+YVamdOf4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl9XQqIACgkQ3s9rk8bw
L69eKg/7Bl30IMFTiXaiYS0kULqKKgFw0wJh97qaZQIO1e/J26IXcwdzq8yy2Di0
HQ/UzClK+vMv9/pL0xfrXrZGjErDp1cCq6ZPDoqqk/CSbmoAsK6mz4rZ8PwVUFm7
85B2kRBbFBMhNxxfPNMhcA66KPNXj+POVs5plZ1eK2L2hR4vgveOfBEPoAfIwb1Y
lVgpn6g+kRzLO53QTar94NH/tmYkMG6aDDuQYMvFhYBEuGlbpl4O9lsEc86snWLM
DXzWXyZCjysEP/MXAVzDcQpY3QBqwGU1Ru7ha76vDgG/KjKWLyFsXlPotIL/HhIG
r66bPRlxY9xcEVZkz/lnEXFTTgjsfZ9D4384MR2KP26/pu/D5NhzKWwKtOXdIKW6
Q3xaadWy1dpiC7gcfsJ3PANs3QUPJTkXP7R/gWu4l5XN8xJMevriUYXCe4enNZRA
kKQ+N6kYBL5++HJJcdnU/d0HT1sbv1p5NcOwuA2R0NRpNknKNL7OuqqaUySbc66V
BisRE9qmy1MCWJnHPLnxEF6Ue5rKoAhOCUSS6Uye/MGoRm+7v3fmw7TTYn0yxcrp
PnHlXKd5si1xFOxxDO9tdL3Ig8qTdIYgYeKl/NKQpbYsiJLJ/O5Y+4KtOPEc06/V
AmEXxZ/e49+BbnLUdR9PzmdeAVlcZG5ge4Vp3TmLm2drFswhD1c=
=C02h
-----END PGP SIGNATURE-----

--Sig_/TTGqsGHzVXO8j5+YVamdOf4--

