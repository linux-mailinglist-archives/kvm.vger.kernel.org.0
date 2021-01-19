Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29572FBC5E
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 17:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730834AbhASQ0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 11:26:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59012 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729404AbhASQ0j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 11:26:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611073513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wl/5nIBwEay43kL1RbyW7Gc1aMFOi0iRK9un5o4y7wg=;
        b=DHe63LFGwzBdig8Z/O4VOuGfSLid/XiUBQ3FGJVjOlysWl7PCbsxhd2l8dAooaLtGo4jm2
        wUDmxGa0GmsVMuqzdjA9ZZR2XmZed7faGafVNUaeHp8b2n4ZKPlOOxnjKREMqrFKvI99zn
        +adMNIXGnf9DVqVgYP66W5iiMg5Y9wg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-usAWjBxGNAOp6uC2ckuKSw-1; Tue, 19 Jan 2021 11:25:08 -0500
X-MC-Unique: usAWjBxGNAOp6uC2ckuKSw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 173AF800D55;
        Tue, 19 Jan 2021 16:25:07 +0000 (UTC)
Received: from gondolin (ovpn-113-246.ams2.redhat.com [10.36.113.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FB9B60C69;
        Tue, 19 Jan 2021 16:24:59 +0000 (UTC)
Date:   Tue, 19 Jan 2021 17:24:48 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thuth@redhat.com, david@redhat.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, gor@linux.ibm.com,
        mihajlov@linux.ibm.com
Subject: Re: [PATCH 2/2] s390: mm: Fix secure storage access exception
 handling
Message-ID: <20210119172448.7fb3d7df.cohuck@redhat.com>
In-Reply-To: <4de19c74-65dc-5a29-76c7-99c600012fdf@linux.ibm.com>
References: <20210119100402.84734-1-frankja@linux.ibm.com>
        <20210119100402.84734-3-frankja@linux.ibm.com>
        <3e1978c6-4462-1de6-e1aa-e664ffa633c1@de.ibm.com>
        <4de19c74-65dc-5a29-76c7-99c600012fdf@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/_Ei7KtOMbvWaVZIUWbFuXiz";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/_Ei7KtOMbvWaVZIUWbFuXiz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Jan 2021 11:38:10 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 1/19/21 11:25 AM, Christian Borntraeger wrote:
> >=20
> >=20
> > On 19.01.21 11:04, Janosch Frank wrote: =20
> >> Turns out that the bit 61 in the TEID is not always 1 and if that's
> >> the case the address space ID and the address are
> >> unpredictable. Without an address and it's address space ID we can't
> >> export memory and hence we can only send a SIGSEGV to the process or
> >> panic the kernel depending on who caused the exception.
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> Fixes: 084ea4d611a3d ("s390/mm: add (non)secure page access exceptions=
 handlers")
> >> Cc: stable@vger.kernel.org =20
> >=20
> > Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com> =20
>=20
> Thanks!
>=20
> >=20
> > some small things to consider (or to reject)
> >  =20
> >> ---
> >>  arch/s390/mm/fault.c | 14 ++++++++++++++
> >>  1 file changed, 14 insertions(+)
> >>
> >> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> >> index e30c7c781172..5442937e5b4b 100644
> >> --- a/arch/s390/mm/fault.c
> >> +++ b/arch/s390/mm/fault.c
> >> @@ -791,6 +791,20 @@ void do_secure_storage_access(struct pt_regs *reg=
s)
> >>  	struct page *page;
> >>  	int rc;
> >> =20
> >> +	/* There are cases where we don't have a TEID. */
> >> +	if (!(regs->int_parm_long & 0x4)) {
> >> +		/*
> >> +		 * Userspace could for example try to execute secure
> >> +		 * storage and trigger this. We should tell it that it
> >> +		 * shouldn't do that. =20
> >=20
> > Maybe something like
> > 		/*
> > 		 * when this happens, userspace did something that it

s/when/When/ :)

> > 		 * was not supposed to do, e.g. branching into secure
> > 		 * secure memory. Trigger a segmentation fault. =20
> >> +		 */ =20
>=20
> Sounds good
>=20
> >> +		if (user_mode(regs)) {
> >> +			send_sig(SIGSEGV, current, 0);
> >> +			return;
> >> +		} else
> >> +			panic("Unexpected PGM 0x3d with TEID bit 61=3D0"); =20
> >=20
> > use BUG instead of panic? That would kill this process, but it allows
> > people to maybe save unaffected data. =20
>=20
> That would make sense, will do

With BUG():

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

--Sig_/_Ei7KtOMbvWaVZIUWbFuXiz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAmAHB9AACgkQ3s9rk8bw
L68FCQ/8C2reWoIDpqXLM65QwexvAh5qXVMDRCQ4duWhFhOcs71p12CKiG4clZ3N
FFlcEgpcg69EwX44+EId2jVN7n+RE/HSiJiwisrR4U4ykH/xOGPaverhwZu0PVAv
byYX1ifefBWrYIzyiHMbhBSv91mrTg/hlioednAOSGag6ifekvwhloKsgm6vo6Ff
yvicIBjU64NSKBaOaS+g9gQv4RZ/4OlK8kieqh03iD431iC7fI8zZjDr4TTiukTZ
TCGRYm6S9xKvgU25gWpRS2fjtdqtVsLTscBnlvALucw5qunrCpENND/UogKccUfS
YrU8nzh1t5DXSGUiGR6AssnH4jiFjYkrVMFMz3JHdWGTt+28ZAx2PvshLfm4Rl7v
UO2xcpZLzlfBd5Ua6LLWSEqeYKiK62NH6tmnK/NJQyX56wjmkhpObIY7uLr06I89
UzBLuXIYy4PQCRRxm3ItAgtDMmSqhQjtLJDx3tdv+lwoIm4TFT8DJKWSG0L+Hyiw
zdx4a/VtipN1iVF//Juyp9D4NMm+vEl3qELEulgISVkFrENCL7ZjwxrpF5B3HUyJ
cpw+ngdVlR7Q53rNKGzS8wKLB8hTmwPkyAtOItJcCagGsfiwJ8uMx4WaLv/ouh7z
nMQDhzk0JpZcZBY1zLYEi+UgKm75st5SKStsbzKkNDKW1btFyuc=
=4MJ8
-----END PGP SIGNATURE-----

--Sig_/_Ei7KtOMbvWaVZIUWbFuXiz--

