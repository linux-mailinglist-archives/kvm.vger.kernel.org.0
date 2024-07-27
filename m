Return-Path: <kvm+bounces-22456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76D9C93E035
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 18:43:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A899F1C21126
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 16:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EB6E186E39;
	Sat, 27 Jul 2024 16:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b="JMi3OFRV"
X-Original-To: kvm@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8581E12C46D
	for <kvm@vger.kernel.org>; Sat, 27 Jul 2024 16:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722098625; cv=none; b=jvopiGhf8Pg0CjALv6nIFFAC3yATAPnktCotZuU0a/GgmULui5COb2/OrXuRCHWEHT+ManCpC5bv9bqR7Fajp4L/I6WQ7o45byd5j+CD1lHwuOcfP/ozv44MzJmAFYzQ3UzcfGrdO/eqRxuKpeqZByR0+2XGW+PsUSXRT0rix5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722098625; c=relaxed/simple;
	bh=oPv8hgTn1bpa9RBFxBQ06uy2Ght26uoFx4kYSnS8bG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z1sYgDxmHkE/DVuW53B+FCHKmRo2upBhc/iGYPc13M+c2w1E/o0P/8CPNArAr8FD0mYHRg9hCBeM+QDKMGb+4vuP5sG7JQRP+uHhJhTBQ/iud/RUWDRHlxk3eCrRy//kDDU1+HTcwWirKJyoYFYNaPnqQET9UZ5JtVZP2z0CTRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=j.neuschaefer@gmx.net header.b=JMi3OFRV; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1722098617; x=1722703417; i=j.neuschaefer@gmx.net;
	bh=HnA7bt3Q3lvgwH3ZXezU9aJkq5laoJAwTswH/IEzw7I=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=JMi3OFRVpheFwXzj6ObtkIJyTNYrMwEGAOtFU6JfkrYsMaKSIrafLl1CgBxOTsZq
	 1032Zy3S0l6BvdkLiNcMsLUdTRRxVsDw7y4PfvKDlOKwgUwwTMk1DqlZkhx71KMGC
	 Ha53FO1I2Yr9GmsKd9xGh6+PgueeoLmCuDvTypWPt+KWFOghRu1BjYOqAK/u7V8J+
	 Gj9uqOxG+SyGG5ngiwwwKdeDd/h0/O1Jma7Gmm3qzu0fR76woZ/GF9SLph4nJSrWN
	 zSIrMg+LWRXoUN0nJlsE1r6DKFZBq0p/6eU7/3WO7lgj8DNtWxHpE7vL05H/arE+o
	 QC8auQN7uxK87zmjEg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from probook ([89.1.58.183]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MnJhU-1rol7F2vie-00fJQu; Sat, 27
 Jul 2024 18:43:37 +0200
Date: Sat, 27 Jul 2024 18:43:36 +0200
From: =?utf-8?Q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Alyssa Ross <hi@alyssa.is>
Cc: =?utf-8?Q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool 1/2] Get basename() from <libgen.h> for musl
 compat
Message-ID: <ZqUjuObD_cTdgP3V@probook>
References: <20240727-musl-v1-0-35013d2f97a0@gmx.net>
 <20240727-musl-v1-1-35013d2f97a0@gmx.net>
 <b43mil7j4t5zc2l33vtrixc2puyxm5546fdnsefci7z2sditwa@z7h7jo3jgols>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HZodAlBAn50lA2PN"
Content-Disposition: inline
In-Reply-To: <b43mil7j4t5zc2l33vtrixc2puyxm5546fdnsefci7z2sditwa@z7h7jo3jgols>
X-Provags-ID: V03:K1:ADg7kjXmojTFUku87v1kkw0YfuuIAUG//kcaJsECCx9Bv+9MT7N
 p3xQTrvS4ltJbEcVrrxqhxTTRSFe3dTfw3d/HK7Hk/Y5QtApJrDe/rwQ1PisjzHTHfkPjgE
 I5KkI4F1ORrG2KbX35T1qRIgnwaHigGgn+MbN1rnwPsQ4MhGpgPzpN197pyTJlk7yJVMYEw
 0sRYddozaWEcoE9L2rEWw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:+W/oJaSDRBs=;O4m8/j38I1P61cxk7tbCC98fqOS
 drSr/BfEKTQvbvtWdnLPwrigwfm+An5zHAtUYbASCtqYy8fUl1fJQWXMS6fuXBEitXwVu0ovg
 sRyuSJZDWyxfp9GYDr2kQCp8OMUt2MZBSsmGwKfICrxbzEPgopluYQmbLG6LwnLoMy1gJwg/G
 sEB7Vpiq7y80E+2JzPQAJFqozCZwj/XUzs96srNDcWMsoXtGpsUr7yW0DdOTUTTccgp6AIsMf
 jDphHmvX2kP/5TgTrrkc0y8RL9A7W3EXjvIFEHpN8eNAEObkRS5O7xF+1dL2W94eB+cCoNaMk
 SyDobsZdO7O8isVLpNptb4Fn9LXzMIH5vYfHB0NNv/ki5POirK6IxW2KkbvX9NgvYjYy4sWP4
 K4jAkfdHZPxPhbKljOY7gx0rupJrYgK5nRK987FCX4q2sqXlMAEepeU3ghu4sCnkFCSQeZbhg
 HJIpSWt8mcCVXWkCg9B0+fkyHroQRLm0O/KvfPmeQ/drM6CYcX4sqABqYMp6YJmMC/Cb/uzWf
 67st2OTlytjzjmv51/gXNvr1WDIa6mtIm1pazAFlOcnF9iQ2jI4mu04SIz66vHHt3RpXjbrcf
 nYpu2CMwlqoFbBBj5au6N7/KLgyxQZxhLzYnaVy/3AQ9ZGe9jzDD/AD8SFLwDYucto+3ljprK
 uQKMxxdfT6TtYouEXizPzZb8wodtu9XWIbFpUnrhUeT4yq+2GoraUjGeInKq+fBM4CR2Jx5KY
 kVuKNq0GX/W7+aA4+T4YjunXmDxlaMnOy/5SxsmW9JkuawhovK1njFCEN/B5CfCksvQsBdf5t
 ZMV6ojVLqRKkvZpd6LaRdZTg==


--HZodAlBAn50lA2PN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 27, 2024 at 12:58:37PM +0200, Alyssa Ross wrote:
> On Sat, Jul 27, 2024 at 10:11:14AM GMT, J. Neusch=C3=A4fer wrote:
> > According to the manpage, basename is defined in <libgen.h>.
> > Not including it results in a compilation failure on musl-libc:
>=20
> That's not quite what the man page says =E2=80=94 there are two versions =
of
> basename, the POSIX version and the GNU version, with differing
> behaviour.

Right, thanks for catching that!

> > vfio/core.c:538:22: error: implicit declaration of function 'basename' =
[-Werror=3Dimplicit-function-declaration]
> >   538 |         group_name =3D basename(group_path);
> >       |                      ^~~~~~~~
>=20
> In this case, it should be safe to switch to the POSIX version, because
> group_path is writeable and not used after this, so
>=20
> Reviewed-by: Alyssa Ross <hi@alyssa.is>
>=20
> but it would be nicer if the commit message was clearer, because it
> currently reads like it's just including a missing header, rather than
> changing the behaviour of the function.

I'll update and respin.


-- jn

--HZodAlBAn50lA2PN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEvHAHGBBjQPVy+qvDCDBEmo7zX9sFAmalI5YACgkQCDBEmo7z
X9v4kQ/+Oxahz8erDmxZtI2Cu/j3PC5mqMuOW2D2LRAHOmvZduFSraL+mUUxOtqV
7b4gItq5/Uw3Hwu/Cso895MCWFVhFGJbkcHdaYy4toc4yUE4JXrSeaxyzNn58pDO
XiqxRXenz/9rQVhEgZi0OHptJyL9F2yJYt0CsQc7Q4JuKhku4nkW/iuuGc0IAsWi
8cfNocfV13uLNrujgsPF5GiDZzmsyTJ1eSRJoDbrqlhnhphYuX3DI3ZU7sfI+8bR
4dEpy82kkauj6F51+V1B+rl92HKj6FumAWxqtqLEJ3KdgE72mjDHAL4s544ZvHhN
Z+//krr8NOq1HSOkQlTXXpe9hAn6rqydjG4zE+qSejVFOqMKBPYncHK0shxTJ9Sa
OKkY68g93bu/Wl2pMIgQyhLDBvnJVzSj15R7maiEJuLfa0mVUMSBQm9KmnyNKVbD
4n5G8tMsrMNcpWi/42U6qqX6GXutIf3NxpXrTkyqoWqIDIEbelRiaBAGAfWdwblM
mR63JyWg1X4Kr5sLShKx8nLEoRxzYLA/DKad3dAoVnNwklCfkxsDHHTXRrG/fZCP
LhKuD7/tZZ83cNwV60AGZlQCE6NBvnYQyiPUdhrccNsqFVPONHf3hcMKVjp66K4/
kZzUwq2U8V9nSRPYI6T1ccOt+VLYqHEBbrT7QE9aonYfxxU8MhE=
=6bEi
-----END PGP SIGNATURE-----

--HZodAlBAn50lA2PN--

