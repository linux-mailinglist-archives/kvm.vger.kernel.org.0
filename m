Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A54D601A4
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 09:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbfGEHoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 03:44:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727638AbfGEHoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 03:44:23 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7CC43308792D;
        Fri,  5 Jul 2019 07:44:23 +0000 (UTC)
Received: from localhost (ovpn-117-133.ams2.redhat.com [10.36.117.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29FE580DA9;
        Fri,  5 Jul 2019 07:44:18 +0000 (UTC)
Date:   Fri, 5 Jul 2019 08:44:18 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
Message-ID: <20190705074418.GB10995@stefanha-x1.localdomain>
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-2-pbonzini@redhat.com>
 <760164a0-589d-d9fa-fb63-79b5e0899c00@suse.de>
 <aaa344bf-af29-0485-4e83-5442331a2c9c@redhat.com>
 <afea12a1-47b3-0ebe-a3c2-6adc615bbddf@redhat.com>
 <c1d16dbf-713d-3528-78d7-a3f49c056f74@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WhfpMioaduB5tiZL"
Content-Disposition: inline
In-Reply-To: <c1d16dbf-713d-3528-78d7-a3f49c056f74@suse.de>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 05 Jul 2019 07:44:23 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 05, 2019 at 09:12:37AM +0200, Hannes Reinecke wrote:
> On 7/4/19 3:19 PM, Paolo Bonzini wrote:
> > On 19/06/19 12:31, Paolo Bonzini wrote:
> >>> I'm a bit unsure if 'bd->last' is always set; it's quite obvious that
> >>> it's present if set, but what about requests with 'bd->last =3D=3D fa=
lse' ?
> >>> Is there a guarantee that they will _always_ be followed with a reque=
st
> >>> with bd->last =3D=3D true?
> >>> And if so, is there a guarantee that this request is part of the same=
 batch?
> >> It's complicated.  A request with bd->last =3D=3D false _will_ always =
be
> >> followed by a request with bd->last =3D=3D true in the same batch.  Ho=
wever,
> >> due to e.g. errors it may be possible that the last request is not sen=
t.
> >>  In that case, the block layer sends commit_rqs, as documented in the
> >> comment above, to flush the requests that have been sent already.
> >>
> >> So, a driver that obeys bd->last (or SCMD_LAST) but does not implement
> >> commit_rqs is bound to have bugs, which is why this patch was not split
> >> further.
> >>
> >> Makes sense?
> >=20
> > Hannes, can you provide your Reviewed-by?
> >=20
> Well ... since you asked for it:
>=20
> Where is the 'commit_rqs' callback actually used?
> I seem to be going blind, but I can't find it; should be somewhere in
> the first patch, no?
> As per description:
>=20
>  * The commit_rqs function is used to trigger a hardware
>  * doorbell after some requests have been queued with
>  * queuecommand, when an error is encountered before sending
>  * the request with SCMD_LAST set.
>=20
> So it should be somewhere in the error path, probably scsi_error or
> something. But I don't seem to be able to find it ...

The block layer calls scsi_mq_ops->commit_rqs() from
blk_mq_dispatch_rq_list() and blk_mq_try_issue_list_directly().

Stefan

--WhfpMioaduB5tiZL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0e/9EACgkQnKSrs4Gr
c8gcuAf+L9+6J3YL2JMDEmzjMxBNccFWDSQLa8t3UldgHfeuhjx7j8wBfOf0qsNg
lzMe8d2pRHUaTsvf0w+1d+Hum1sRRu7K+y/9YbHwUXE6nXK/oNEcXhTIb34qXbLQ
YlBOzy3dBJEkq2iQyuoyUYoDGxdwDmY/KRucckUun2XDjBQDOJUsVsyanwhgnEJ9
//zmCwkWO4rTuyt5wMl+VL0/6BLsdlW5ANIfCzI7B6r/jnC3drk5gVerQMCkpbZV
fHb5/JZCErpwHzxdrE1I3EXpC/mWmxswvfA5D1EX/BNFrgA6MHM6jddGoC54J3wQ
AIyt0SIB5KssCEJM1KbIiX+U5kuNGw==
=sq7S
-----END PGP SIGNATURE-----

--WhfpMioaduB5tiZL--
