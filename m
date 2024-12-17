Return-Path: <kvm+bounces-33995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B33C9F55E2
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 19:19:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D75F4164C00
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 18:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E4781F8AD9;
	Tue, 17 Dec 2024 18:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b="DlxnkylK"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zeus03.de (zeus03.de [194.117.254.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A001F8691
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 18:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.117.254.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734459502; cv=none; b=Y8vA8+UxMWOZOw/cE0wPB2T5wxbGjrJwQUdlTBepD/E1t6huNNzNFJ50c2pcnd+zTc2K4rkDj+wXWhcLcMlTce8mwkJLPcyaTzv2DyaZ24pAo4/IuaUblkPtPh5JegV7j2pb4vXlDWTNFEJJKkiBt5vKhugztm/L7wH86mZKXAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734459502; c=relaxed/simple;
	bh=7z5UD01m+BMZRZdko2viTt+Edc9+VFcuJb9yDHIzrgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ENhfo3sSKiITV/o4+4TmwHeoEm7vUxCra1TEUIiIzWVgcsA15KSh1Z5si6Zsg1ZQF3lZyq8a/ye44pw2V5EThz0UXmDTMFMYMX/AHUme/B6116jCI798b2Mjtvs9cv8Nl6z+igZFj8rnEOiGaaYzexj4Hy18ik1ptpnWMT3ITtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com; spf=pass smtp.mailfrom=sang-engineering.com; dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b=DlxnkylK; arc=none smtp.client-ip=194.117.254.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sang-engineering.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	sang-engineering.com; h=date:from:to:cc:subject:message-id
	:references:mime-version:content-type:in-reply-to; s=k1; bh=y9lH
	6rj0++VWbw14s+yHgf4Y2V3DFMzP2Oa4flb5k0o=; b=DlxnkylKrScDpOtpacem
	sSZzh2U2rL9X+2Mnqmxth8WDbvATJvAr62gAQse0tGlQFnw+njIcbfA1xNoBy7Pg
	zqWq2ibHRkfCd3u54Dy1xR0g0sUFZPqRs6B5TPB847TePwmndkw7HFpesG2XehZR
	ODA1byktlaccsE/IQYvYwDnbggMPpCtpkjI38PfZNOyThy8b0k+giRLqezp/MLlR
	XQ6Y+hFYsPcX3npibQR73RTagAVhjQD/bKdOUYkYA9me4fUmpLN5zM8JmvLiv2/d
	uO9cg0k7uiITEGcASPqfUpwLJV/bQyWx5jpaPclmCZ7s7NEVMVUXX0VVPJ0CMln6
	AA==
Received: (qmail 4172729 invoked from network); 17 Dec 2024 19:18:11 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 17 Dec 2024 19:18:11 +0100
X-UD-Smtp-Session: l3s3148p1@FwHfUXsp2rkujnsY
Date: Tue, 17 Dec 2024 19:18:11 +0100
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH] KVM: VMX: don't include '<linux/find.h>' directly
Message-ID: <Z2HAY3rDzUMVmGZW@shikoro>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
References: <20241217070539.2433-2-wsa+renesas@sang-engineering.com>
 <Z2Goxx27WL-G-13y@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="o97KPok2X6w3MXQH"
Content-Disposition: inline
In-Reply-To: <Z2Goxx27WL-G-13y@google.com>


--o97KPok2X6w3MXQH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Sean,

> I definitely don't object to the KVM change, but the if y'all expect developers
> to actually honor the "rule", it needs to have teeth.  As evidenced by a similar
> rule in arch/x86/include/asm/bitops.h that also gets ignored, an #error that's
> buried under an include guard and triggers on a macro that's never #undef'd is
> quite useless.

I went for the minimal change here. But if agreed, we could change
bitmap.h to the pattern spinlock.h is using. Similar to your suggestion,
yet with more readable names IMHO:

#define __LINUX_INSIDE_SPINLOCK_H

...

#undef __LINUX_INSIDE_SPINLOCK_H

Happy hacking,

   Wolfram


--o97KPok2X6w3MXQH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmdhwF8ACgkQFA3kzBSg
KbaosA/+IQZ34X/KeM5qWpQfbE/EOZqrjrnixGoL6kBfYn8LMjMLdRWMf42GuRYQ
QTlQ/qPYma4fhV0bL5c27YSszvxQi85/SbvXnVSnDED75890loGGlfwDf/Wo5w5W
27gbogs8LEMBiw6Mtv8IN1aqRbw+Geg4jfo60cf684EwR4X79BZnjcUXBRec1jIJ
/6Pv245ecFCn3Dca0gL2eI7ziTzkXzYHp4bAw+bNbc3pwLpaKUpci87OkwY32SXN
XN9nMhrXzMGoTUK3Blqc4C6IGMWqJ7gaOFJmIcgGVM9u+/Oy8NCcGmxH/+l7K1im
f10GdaHmaGkDv1H8Tt/mZ9WyuNV0rqi00BzdfSH/9b2Jb+KG0tNXNMIwxGzd/fpL
ZKJIm1s7UGtHi+EvLKZ0adxRwmgTJRuP8OjiTtXAeBw1KYa09WhIEiWgWjcaIK2r
+Mqicw1H0uAsVBEBavmI9tcO3sSjkmZmk50EtM4syk2+7EuUaTlwWT6teU5hzEyZ
ioelFfQOGrjVnlrEx09UmDvGdwL/aMi5UG58cRvNYtve5jS82mX0iVEWFYsXYEzZ
+LWoPPMmekqXzISO/QeT78cvw7v4dpp+hRbBLr8HsTD//deKJeI0zulFaXQKkKUm
Yw2YbUiIA7cI+SUEyCR9/iadZuU6hsFguTNqHRN8J0QiAyRXn8E=
=bo/a
-----END PGP SIGNATURE-----

--o97KPok2X6w3MXQH--

