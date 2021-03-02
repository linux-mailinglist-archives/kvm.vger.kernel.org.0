Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DC132A700
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1838985AbhCBPzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:55:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1382690AbhCBJmV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 04:42:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614678054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h+mfFjr1hz54KHd0gEhFg6xvfLQMHcjeSW8geqvaMSw=;
        b=A1vJDgdCFCpc7GtMV0T2GZazz4hfHKAiRc4J1/Avrkk3QS3gcUvGd5K0E0ScegfkPWg/rh
        9fVE89Ihsw9nuNFqjMDW0yvLQvGn0ABLLjhEf0lQRre+bpQSlEhVO6IbkIMP8gpdepFPKs
        GnpD0oXrSFmRm1andZsf+xX2NfpGkvA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-AgGsTijYOYqsHLhEOSgOKw-1; Tue, 02 Mar 2021 04:40:51 -0500
X-MC-Unique: AgGsTijYOYqsHLhEOSgOKw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18047195D565;
        Tue,  2 Mar 2021 09:40:50 +0000 (UTC)
Received: from localhost (ovpn-114-138.ams2.redhat.com [10.36.114.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A027560BFA;
        Tue,  2 Mar 2021 09:40:49 +0000 (UTC)
Date:   Tue, 2 Mar 2021 09:40:48 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Subject: Re: [RFC PATCH kvm-unit-tests] x86: add ioregionfd fast PIO test
Message-ID: <YD4IILn07Aejp6Wc@stefanha-x1.localdomain>
References: <20210301183319.12370-1-eafanasova@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hDkImovCFG9lypPZ"
Content-Disposition: inline
In-Reply-To: <20210301183319.12370-1-eafanasova@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--hDkImovCFG9lypPZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 01, 2021 at 09:33:19PM +0300, Elena Afanasova wrote:
> @@ -159,6 +166,8 @@ function run()
>          print_result "FAIL" $testname "$summary"
>      fi
> =20
> +    [ -n "${fifo}" ] && rm -rf $fifo

Is there a guarantee that $helper_cmd has terminated? If not then it
would be good to store its pid and invoke kill $helper_cmd_pid here
(maybe with an error message indicating helper_cmd hung).

> diff --git a/x86/ioregionfd-test.c b/x86/ioregionfd-test.c
> new file mode 100644
> index 0000000..5ea5e57
> --- /dev/null
> +++ b/x86/ioregionfd-test.c
> @@ -0,0 +1,84 @@

Please add a comment describing the purpose of this program.

> +	pollfd.fd =3D read_fd;
> +	pollfd.events =3D POLLIN;
> +
> +	for (;;) {
> +		ret =3D poll(&pollfd, 1, -1);
> +		if (ret < 0) {
> +			close(read_fd);
> +			if (write_fd > 0)
> +				close(write_fd);
> +			err_exit("poll\n");
> +		}

Is poll() necessary? I think a blocking read(read_fd) would have the
same effect and simplify the code?

> diff --git a/x86/ioregionfd_pio.c b/x86/ioregionfd_pio.c
> new file mode 100644
> index 0000000..eaf8aad
> --- /dev/null
> +++ b/x86/ioregionfd_pio.c
> @@ -0,0 +1,24 @@

Please add a comment explaining the purpose of this test.

--hDkImovCFG9lypPZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmA+CCAACgkQnKSrs4Gr
c8gjmgf/W1ZsuZkTsF49xZkFlY2e4dKs4B6OfPk73Y0La4U1fcLivq7tWnInvUSF
vUCvn1p+zKiuZhqrixdG9ioNC2/GBvA42UMtDr144KzpUTXteo31OP7WHV//sANE
dbrxhC6bSnHEjLNPfZBb14m4f4WBueNRVK4sUTG0EuuVYxNOf7LuJmCm+A8YV0l6
gFt8kIyB9/AoxxDf/4LBHzO0GbKoaN7jS18fvz6lsa9nIdq2QfTGsiZGD+ZpOdPj
I1XMuwCmAYY2UTzl4Rh+099dWS+eqcCKWXHtWo8a+pOyRQqTS7ncHCHFk6LD37Yg
zloj2r7VoqBnnyN0GWtYKtyBmwU54g==
=TjOa
-----END PGP SIGNATURE-----

--hDkImovCFG9lypPZ--

