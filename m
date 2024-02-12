Return-Path: <kvm+bounces-8548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A435851293
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 12:47:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EFAE1C20F89
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 11:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76D9F39AD7;
	Mon, 12 Feb 2024 11:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kRFO39h3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B471F39859;
	Mon, 12 Feb 2024 11:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707738450; cv=none; b=nQr/y9jJBKwbVcUO3bYc/Vt+fu1j3b8+rOjgW/rafYsaPz1WpoTFUAzHLUJf0/7cgtO25cuyUsPXbAnAI6VCQY6WCpXDuZjNp7gyp+Zk4RO2huqG+C2FPghMVp1gkZCCbaFWDU+V5z/IlxCr5jNnoa/KHM2SVv8uzu7NABVJtEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707738450; c=relaxed/simple;
	bh=qlzqXd3E8EN9sGyZ5zlZscBBy3a7+JL3uMmODD1BNa0=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=KyppGbCIDoJVlP0AV0H0VchTepF92I9NI4TqQoZTfpEJ9Cdy2Tw9HQ/bOuFONM33FMd+QMlsbz9nmao6GiKfu+YBC6Km7nYCThbVG7aDwcfShGUem/hq831gIjjoWGhx48C8ttqb1cs8Y1coUQGGkbWXj6mlAMeE2lRfKI9qdE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kRFO39h3; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707738448; x=1739274448;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=qlzqXd3E8EN9sGyZ5zlZscBBy3a7+JL3uMmODD1BNa0=;
  b=kRFO39h3EAp2KcpdJsox+3/AUQOiWtcZEuRw3eK158CIwRNfIuAM/ngV
   0fecrquCzUP4hvZIKF/DzB5VxgHd0e9X7ylOUJadt9u2PHzApHcz7d+vf
   cVzoGy58KpnQd2cH9pKLc3FiL7VMHvJQclXyP88dAej4SADvR02hMqy9X
   6nJClK6Cpxj6kRworZTtRBJ5CX4ifoaoKX5IyIovw8mLk7Zrc9yQQpT/6
   ljZLS80nSaeh7c6DSt+YAxVk6Ml0M5TvqOwmMDBD4uWa2rWAyjZUk++BX
   ujQXCAtQWuIIpjQHBeDRxahRHKsH+ydnVtzKZ4XWplwckb5004bSVcu5Y
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10981"; a="2054877"
X-IronPort-AV: E=Sophos;i="6.06,263,1705392000"; 
   d="scan'208";a="2054877"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2024 03:47:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10981"; a="911459436"
X-IronPort-AV: E=Sophos;i="6.06,263,1705392000"; 
   d="scan'208";a="911459436"
Received: from ijarvine-desk1.ger.corp.intel.com (HELO localhost) ([10.246.49.160])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2024 03:47:20 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 12 Feb 2024 13:47:14 +0200 (EET)
To: Lukas Wunner <lukas@wunner.de>
cc: Bjorn Helgaas <helgaas@kernel.org>, David Howells <dhowells@redhat.com>, 
    David Woodhouse <dwmw2@infradead.org>, 
    Herbert Xu <herbert@gondor.apana.org.au>, 
    "David S. Miller" <davem@davemloft.net>, 
    Alex Williamson <alex.williamson@redhat.com>, linux-pci@vger.kernel.org, 
    linux-cxl@vger.kernel.org, linux-coco@lists.linux.dev, 
    keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
    kvm@vger.kernel.org, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    linuxarm@huawei.com, David Box <david.e.box@intel.com>, 
    Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
    "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>, 
    Alistair Francis <alistair.francis@wdc.com>, 
    Wilfred Mallawa <wilfred.mallawa@wdc.com>, 
    Alexey Kardashevskiy <aik@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
    Sean Christopherson <seanjc@google.com>, Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 07/12] spdm: Introduce library to authenticate devices
In-Reply-To: <20240209203204.GA5850@wunner.de>
Message-ID: <5de3ae38-023f-0a3f-d750-fbfa1af7a8ee@linux.intel.com>
References: <cover.1695921656.git.lukas@wunner.de> <89a83f42ae3c411f46efd968007e9b2afd839e74.1695921657.git.lukas@wunner.de> <5d0e75-993c-3978-8ccf-60bfb7cac10@linux.intel.com> <20240209203204.GA5850@wunner.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-136259284-1707737012=:1013"
Content-ID: <fd482b13-2b88-f6d9-c1f8-18cb38ef1b33@linux.intel.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-136259284-1707737012=:1013
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <ea362b92-2407-d2f9-8869-a76532c7362f@linux.intel.com>

On Fri, 9 Feb 2024, Lukas Wunner wrote:

> On Tue, Oct 03, 2023 at 01:35:26PM +0300, Ilpo J=E4rvinen wrote:
> > On Thu, 28 Sep 2023, Lukas Wunner wrote:
> > > +typedef int (spdm_transport)(void *priv, struct device *dev,
> > > +                          const void *request, size_t request_sz,
> > > +                          void *response, size_t response_sz);
> >=20
> > This returns a length or an error, right? If so return ssize_t instead.
> >=20
> > If you make this change, alter the caller types too.
>=20
> Alright, I've changed the types in __spdm_exchange() and spdm_exchange().
>=20
> However the callers of those functions assign the result to an "rc" varia=
ble
> which is also used to receive an "int" return value.
> E.g. spdm_get_digests() assigns the ssize_t result of spdm_exchange() to =
rc
> but also the int result of crypto_shash_update().
>=20
> It feels awkward to change the type of "rc" to "ssize_t" in those
> functions, so I kept "int".

Using ssize_t type variable for return values is not that uncommon (kernel=
=20
wide). Obviously that results in int -> ssize_t conversion if they call=20
any function that only needs to return an int. But it seems harmless.

crypto_shash_update() doesn't input size_t like (spdm_transport)() does.

> > > +struct spdm_error_rsp {
> > > +=09u8 version;
> > > +=09u8 code;
> > > +=09enum spdm_error_code error_code:8;
> > > +=09u8 error_data;
> > > +
> > > +=09u8 extended_error_data[];
> > > +} __packed;
> >=20
> > Is this always going to produce the layout you want given the alignment=
=20
> > requirements for the storage unit for u8 and enum are probably differen=
t?
>=20
> Yes, the __packed attribute forces the compiler to avoid padding.

Okay, so I assume compiler is actually able put enum with u8, seemingly=20
bitfield code generation has gotten better than it used to be.

With how little is promised wordings in the spec (unless there is later=20
update I've not seen), I'd suggest you still add a static_assert for the=20
sizeof of the struct to make sure it is always of correct size.=20
Mislayouting is much easier to catch on build time.

> > > +static int spdm_negotiate_algs(struct spdm_state *spdm_state,
> > > +=09=09=09       void *transcript, size_t transcript_sz)
> > > +{
> > > +=09struct spdm_req_alg_struct *req_alg_struct;
> > > +=09struct spdm_negotiate_algs_req *req;
> > > +=09struct spdm_negotiate_algs_rsp *rsp;
> > > +=09size_t req_sz =3D sizeof(*req);
> > > +=09size_t rsp_sz =3D sizeof(*rsp);
> > > +=09int rc, length;
> > > +
> > > +=09/* Request length shall be <=3D 128 bytes (SPDM 1.1.0 margin no 1=
85) */
> > > +=09BUILD_BUG_ON(req_sz > 128);
> >=20
> > I don't know why this really has to be here? This could be static_asser=
t()
> > below the struct declaration.
>=20
> A follow-on patch to add key exchange support increases req_sz based on
> an SPDM_MAX_REQ_ALG_STRUCT macro defined here in front of the function
> where it's used.  That's the reason why the size is checked here as well.

Okay, understood. I didn't go that in my analysis so I missed the later=20
addition.

> > > +static int spdm_get_certificate(struct spdm_state *spdm_state, u8 sl=
ot)
> > > +{
> > > +=09struct spdm_get_certificate_req req =3D {
> > > +=09=09.code =3D SPDM_GET_CERTIFICATE,
> > > +=09=09.param1 =3D slot,
> > > +=09};
> > > +=09struct spdm_get_certificate_rsp *rsp;
> > > +=09struct spdm_cert_chain *certs =3D NULL;
> > > +=09size_t rsp_sz, total_length, header_length;
> > > +=09u16 remainder_length =3D 0xffff;
> >=20
> > 0xffff in this function should use either U16_MAX or SZ_64K - 1.
>=20
> The SPDM spec uses 0xffff so I'm deliberately using that as well
> to make the connection to the spec obvious.

It's not obvious when somebody is reading 0xffff. If you want to make the=
=20
connection obvious, you create a proper #define + add a comment where its=
=20
defined with the spec ref.

> > > +static void spdm_create_combined_prefix(struct spdm_state *spdm_stat=
e,
> > > +=09=09=09=09=09const char *spdm_context, void *buf)
> > > +{
> > > +=09u8 minor =3D spdm_state->version & 0xf;
> > > +=09u8 major =3D spdm_state->version >> 4;
> > > +=09size_t len =3D strlen(spdm_context);
> > > +=09int rc, zero_pad;
> > > +
> > > +=09rc =3D snprintf(buf, SPDM_PREFIX_SZ + 1,
> > > +=09=09      "dmtf-spdm-v%hhx.%hhx.*dmtf-spdm-v%hhx.%hhx.*"
> > > +=09=09      "dmtf-spdm-v%hhx.%hhx.*dmtf-spdm-v%hhx.%hhx.*",
> > > +=09=09      major, minor, major, minor, major, minor, major, minor);
> >=20
> > Why are these using s8 formatting specifier %hhx ??
>=20
> I don't quite follow, "%hhx" is an unsigned char, not a signed char.
>=20
> spdm_state->version may contain e.g. 0x12 which is converted to
> "dmtf-spdm-v1.2.*" here.
>=20
> The question is what happens if the major or minor version goes beyond 9.
> The total length of the prefix is hard-coded by the spec, hence my
> expectation is that 1.10 will be represented as "dmtf-spdm-v1.a.*"
> to not exceed the length.  The code follows that expectation.

It's actually fine.

I just got tunnel vision when looking what that %hhx is in the first=20
place, in Documentation/core-api/printk-formats.rst there's this list:

=09        signed char             %d or %hhx
                unsigned char           %u or %x

But of course %hhx is just as valid for unsigned.

--=20
 i.
--8323328-136259284-1707737012=:1013--

