Return-Path: <kvm+bounces-27704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5D4498ABC6
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 20:16:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23E7D1C2190E
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 18:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 720D51991C8;
	Mon, 30 Sep 2024 18:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bKsM05iy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979F3CA62;
	Mon, 30 Sep 2024 18:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727720148; cv=none; b=Pq07mfb+MghBUVngSoPLhCwxmtJg9yJZWcdpclJkJ5rGrHgGy0isH1pKmD3EzPKpMlSDQU/MdJ9W7eg5Ssc9dorTJWL9UXnGMwz6tS6qzopsoGh1kzRYVw0QnJyJCjJ6E8b/tL+elm/Cq/EGVJyNl7DzGVB3o4HEyDbwrZ2u89Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727720148; c=relaxed/simple;
	bh=8w6aemunhl1GcKeGEbidxWOmKwoFjJ23FEHAaLFPSm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I0cW0MfNzW4xr9UVk9msVOypGaBNKh+aMh2R2Dtfo4pR0fwjxaNh6+LUVixxe8EX47nFfprKuC4sYK52mzZCIW9gXDic3YPODo1FDpemtOlIVCN1rZ/Kl2ku6pdoFJyRndYr/47i4CweMcAtEeQDToeESj2GKGdmERHtCrsRo60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bKsM05iy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41ED3C4CECE;
	Mon, 30 Sep 2024 18:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727720148;
	bh=8w6aemunhl1GcKeGEbidxWOmKwoFjJ23FEHAaLFPSm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bKsM05iy6LwXedFlNA9P88AZMUa8dOWjBMdv3qLzB/+Rw5Z+Aupi82hzvRLTaRt/B
	 DG+3+oeJ3b4ROVePYcFHva+uStHF60trz2IvYhwBKEtD5nvlKhBzTLOlu2OsLzmXNA
	 10grlOx9xQAjiUasA+WXMOt2qp3xXYgkZPU9V+7yHkqoksTw13zbllDiMqwF0CtByG
	 vhuEGN8988XyaU15kmXyEnRpIcYCBF628evstqoZpYrzLJjpR7FelIhhm+VYnWEsUw
	 OKrdLqAkxbmYuHV1pOiIHVikIrFi35gPqz2yaRQdjFzMr0bGE/yHtLt2hDnisxetlh
	 Ce/LBRw8bP7RQ==
Date: Mon, 30 Sep 2024 19:15:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>, rick.p.edgecombe@intel.com,
	kai.huang@intel.com, isaku.yamahata@intel.com, dmatlack@google.com,
	sagis@google.com, erdemaktas@google.com, graf@amazon.com,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	torvalds@linux-foundation.org
Subject: Re: [PATCH v2 3/4] KVM: selftests: Allow slot modification stress
 test with quirk disabled
Message-ID: <0398a8b5-2d7b-4a85-8452-0e2f51a4fde4@sirena.org.uk>
References: <20240703020921.13855-1-yan.y.zhao@intel.com>
 <20240703021206.13923-1-yan.y.zhao@intel.com>
 <b9367e1c-f339-46e1-8c44-d20f112a857a@arm.com>
 <ZvNckKjlieCN56th@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="apOrv3T8X8gNzi94"
Content-Disposition: inline
In-Reply-To: <ZvNckKjlieCN56th@yzhao56-desk.sh.intel.com>
X-Cookie: My EARS are GONE!!


--apOrv3T8X8gNzi94
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2024 at 08:42:56AM +0800, Yan Zhao wrote:
> On Tue, Sep 24, 2024 at 01:26:20PM +0100, Aishwarya TCV wrote:
> > On 03/07/2024 03:12, Yan Zhao wrote:

> > > Add a new user option to memslot_modification_stress_test to allow te=
sting
> > > with slot zap quirk KVM_X86_QUIRK_SLOT_ZAP_ALL disabled.

> > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

> > When building kselftest-kvm config against next-20240924 kernel with
> > Arm64 an error "'KVM_X86_QUIRK_SLOT_ZAP_ALL' undeclared" is observed.

> Ah, I forgot to hide =20

>   "TEST_REQUIRE(kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2) &
>                        KVM_X86_QUIRK_SLOT_ZAP_ALL)"
> inside "#ifdef __x86_64__" when parsing opts though it's done in run_test=
().

This bug, which Aishwarya originally reported against -next, is now
present in mainline:

   https://storage.kernelci.org/mainline/master/v6.12-rc1/arm64/defconfig+k=
selftest/gcc-12/logs/kselftest.log

I couldn't find a fix being posted so I sent:

   https://lore.kernel.org/r/20240930-kvm-build-breakage-v1-1-866fad3cc164@=
kernel.org=20

which also fixes the same issue in memslot_perf_test.c.

--apOrv3T8X8gNzi94
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmb66s0ACgkQJNaLcl1U
h9Cpvwf9F6p+I5rne9eBrOGO2/lCR5D/LKNMoUdlgLWT4orWtOZtsAmnYqwVEiY1
Rg4GN0Bw3C79CXNQN/+queNelSrK/60MMX7C3Rcsez6EAgyhEWg7SWiG+JoEOsF5
gVzTA5kwHZwD6Q8Ld6v0QRnrEjRVqh5EbP7JvGF+XSBT90UjOifAP06yIbzokbZW
W9v6EcAsKqgQ17YzmcUNJ4pSNc3xXt0J1zoVT43uG7NVX53eDefdxGbdZP9afPOy
P/vL1ezzRJ3K3nxX1mDyPbxO6Y5XWOHtEMhvCBDXi3/oRSxkieQO/eloosHZLstC
a+eu6WCs5IZ11Tk4fMoR5LSnU8qjog==
=gwu6
-----END PGP SIGNATURE-----

--apOrv3T8X8gNzi94--

