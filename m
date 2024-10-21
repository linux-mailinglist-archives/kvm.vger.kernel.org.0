Return-Path: <kvm+bounces-29312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A950B9A914C
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 22:34:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 10C5CB215F9
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 20:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DADA41FDFB7;
	Mon, 21 Oct 2024 20:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EY4nDpd3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1DE1494DB;
	Mon, 21 Oct 2024 20:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729542839; cv=none; b=QVRPYM1MnSZtN+4njRT24qQenmLHDqKFiIWwuwxRzfePHlm6UMqaLYVqgmei5QPLBbRF1J1zwzhPsFFAbYPQuoCQFe7s/4Jja+bcSbva7W755eZfhij2WN9UKn6DaUAU5HnrqZWTUOGNmEstkcCPQeO3IsSqM4paw7TCqTDzu94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729542839; c=relaxed/simple;
	bh=PUti+uJWhKGSDKiDdachxwWsPeCcSML5pWVjgslBJJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UCxSaJRmLQ2subMO8oPjT+bxUiPAxwj9SIZlG21wRAVwmmlfe/P8f4hm5YIlzbXaVt6V6dPcgUqDLTXQe+orUDFzOq92xQVILXRkX+nu+Ilmf+smxpgNDEWlENu3kuzNFMe6JLdc2LAK/UIMOxQ0gyGN++2dWcwJlILJTMRLnYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EY4nDpd3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2266FC4CEC7;
	Mon, 21 Oct 2024 20:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729542838;
	bh=PUti+uJWhKGSDKiDdachxwWsPeCcSML5pWVjgslBJJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EY4nDpd32222igTTRgePtEVwvwcoAqF6WMoPkuKlkDZqISe+dyC3vbZKnElrpbuAl
	 y6Gi2G8kyT4EAchk3kWvbXpuOhN0vp0a9MPvwflNKEAsJ+CTXqn+RBadjiyS06saxI
	 +GTHOMRmkJAEMI9iCz+CFxFfxEY2lvD8bcoKemiz0PK+RmlDvMVwKF/dWLktJnVPmt
	 eyFBufV/zHZ0DujGDXyaiRgGpPD38dJ9OUmOjRgrxFk+IccpmmPnpWEVNnItutSjHo
	 FoKdW7YxHv4iIJSYNyxsJWes0qgupDlrGyzkopzLsj0JdAPSxj13/eDg0Y3Ysj69ev
	 aSE0fxF8mnMMw==
Date: Mon, 21 Oct 2024 21:33:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Jan Richter <jarichte@redhat.com>, linux-kernel@vger.kernel.org,
	Aishwarya.TCV@arm.com, torvalds@linux-foundation.org
Subject: Re: [PATCH] KVM: selftests: x86: Avoid using SSE/AVX instructions
Message-ID: <5071a694-150b-4f6f-8e48-8b96998bdd23@sirena.org.uk>
References: <20240920154422.2890096-1-vkuznets@redhat.com>
 <9a160e3d-501b-4759-9067-17cd822617ec@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="b3t00YNSmqbEVgwS"
Content-Disposition: inline
In-Reply-To: <9a160e3d-501b-4759-9067-17cd822617ec@sirena.org.uk>
X-Cookie: Do not write below this line.


--b3t00YNSmqbEVgwS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2024 at 07:32:17PM +0100, Mark Brown wrote:
> On Fri, Sep 20, 2024 at 05:44:22PM +0200, Vitaly Kuznetsov wrote:
>=20
> > Some distros switched gcc to '-march=3Dx86-64-v3' by default and while =
it's
> > hard to find a CPU which doesn't support it today, many KVM selftests f=
ail
> > with
>=20
> This patch, which is queued in -next as 9a400068a1586bc4 targeted as a
> fix, breaks the build on non-x86 architectures:

This patch is now in Linus' tree, having been applied on Sunday and as a
result appeared in -next today.

>=20
> aarch64-linux-gnu-gcc -D_GNU_SOURCE=3D  -Wall -Wstrict-prototypes -Wunini=
tialized=20
> -O2 -g -std=3Dgnu99 -Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCON=
FIG_64BIT
>  -fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset -fno-builtin=
-strnlen -fno-stack-protector -fno-PIE -I/build/stage/linux/tools/testing/s=
elftests/../../../tools/include -I/build/stage/linux/tools/testing/selftest=
s/../../../tools/arch/arm64/include -I/build/stage/linux/tools/testing/self=
tests/../../../usr/include/ -Iinclude -Iaarch64 -Iinclude/aarch64 -I ../rse=
q -I..  -march=3Dx86-64-v2 -isystem /build/stage/build-work/usr/include -I/=
build/stage/linux/tools/testing/selftests/../../../tools/arch/arm64/include=
/generated/   -c aarch64/aarch32_id_regs.c -o /build/stage/build-work/kself=
test/kvm/aarch64/aarch32_id_regs.o
> cc1: error: unknown value =E2=80=98x86-64-v2=E2=80=99 for =E2=80=98-march=
=E2=80=99
>=20
> This is because:
>=20
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selft=
ests/kvm/Makefile
> > index 48d32c5aa3eb..3f1b24ed7245 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -238,6 +238,7 @@ CFLAGS +=3D -Wall -Wstrict-prototypes -Wuninitializ=
ed -O2 -g -std=3Dgnu99 \
> >  	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
> >  	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
> >  	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
> > +	-march=3Dx86-64-v2 \
> >  	$(KHDR_INCLUDES)
> >  ifeq ($(ARCH),s390)
> >  	CFLAGS +=3D -march=3Dz10
>=20
> unconditionally sets an architecture specific flag which is obviously
> not going to work on anything except x86.  This should be set under an
> architecture check like the similar S/390 flag that can be seen in the
> context for the diff.



--b3t00YNSmqbEVgwS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcWurEACgkQJNaLcl1U
h9DDhQf7B0Ld7EHcmwkrKIc7LAI+Xy4en/oQ6RxXnotJq3+hBzI9qNM722BR/j/C
VcFyoodyHy3w2vROFuM1W4luP6gHzAWmP6BxZAKEeZR6oxu/hgJljrDQMrmF/QLF
PeU4Mbj73J4LhfjpGVUgtAbeQ+e3GPfzL96EttpcDxBvpwv7tf9SnK2YvjgPL6Yk
butevDwiCDxkyRn+GJwn3CPU4oFn0dwT9qOQutrc/xC8ie/mr2PXCOniIrJo3dVF
jIJV9/mIEx2hfVRZGLL6RvCglZmHSSsrhRLSpmlVzhOA8DTxsHy/XO8B6sl0rlIC
Chj2rvcnfQEQ79Svu9NBKnpAW3W4dA==
=KcLo
-----END PGP SIGNATURE-----

--b3t00YNSmqbEVgwS--

