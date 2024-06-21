Return-Path: <kvm+bounces-20230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EC3F9121F9
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:16:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF4FE1C2230F
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 10:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C975A17B43C;
	Fri, 21 Jun 2024 10:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="lPa50+kF"
X-Original-To: kvm@vger.kernel.org
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B115171648;
	Fri, 21 Jun 2024 10:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718964772; cv=none; b=L/64TbsCggDh/Be0hW7dpuwQTFYzEUeWwd2qO7rR+nXEqHLlqHAOG9uEJlP3ewvGQ6JftQIDEAHVPZjID1rBtBUtC2npOv6452dFJH5Fx/Oy6f8BQPrt9pdUimw8ged5FMaBaV/426PtPIFbd8bcwKS/SzVIZcr+WoRTHwhqros=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718964772; c=relaxed/simple;
	bh=qIPAKUsfdrunLjZpUxB95w4pFXbAFx7meVdFYH0CVL0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ty8bP+ZUXESJO5KBmuI4GElS/e7/aOp5gm0wzkuWhf4Ch3AFZ6/xFDodGZz4B1ostpEsyAcCFihMXEunM5HR1tJA7GTGCdR7tt8b5hfCyxpYptgu5BK+2g0T7kbAXcS4GPIXjgVuPKVzXfEgiO77HUpkHvGA+rh0ZoSQ4CSgf0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=lPa50+kF; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1718964770; x=1750500770;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qIPAKUsfdrunLjZpUxB95w4pFXbAFx7meVdFYH0CVL0=;
  b=lPa50+kFeslLsy49zPO6gdpc/lko+oHrlou8TIYUM/N9yvxFcY7p1dXe
   X+ihXtVwbphsbef+wNKrAqcsZDZTTY+3Rb8t91IBPvMI2htHjsY/sXL+W
   ThOOSWOWjipuL0k/7W07K6xQNEtizdCyko6tuspW5zpyzL4gQZ6HDfwqp
   3sY8mTRaG6P9Ae4tzB+iau62PmIu1aMin7yj35a+FZbjpfT3Woc+vNbqy
   Vy0Yb/WNs+s6dSKR65/jc1GivtP9mvgfbCqXxMto1htEpukEUVQ+j2CC5
   u1G6Utt5fPbH1yX8jDCwR1z27Nz5Cd7eciCMLRF+n7z6g8NVhSBdqvCPk
   g==;
X-CSE-ConnectionGUID: +aZhim/bRGe+fZL72SyFNQ==
X-CSE-MsgGUID: nsaDAPolS1GA6r4yoC3nFw==
X-IronPort-AV: E=Sophos;i="6.08,254,1712646000"; 
   d="asc'?scan'208";a="28315238"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Jun 2024 03:12:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 21 Jun 2024 03:12:17 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex03.mchp-main.com (10.10.85.151)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Fri, 21 Jun 2024 03:12:14 -0700
Date: Fri, 21 Jun 2024 11:11:56 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Andrew Jones <ajones@ventanamicro.com>
CC: Anup Patel <apatel@ventanamicro.com>, Conor Dooley <conor@kernel.org>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>, <linux-kernel@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>, <kvm-riscv@lists.infradead.org>,
	<kvm@vger.kernel.org>, <alex@ghiti.fr>, <greentime.hu@sifive.com>,
	<vincent.chen@sifive.com>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski
	<krzk+dt@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, Palmer
 Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
	<devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Message-ID: <20240621-flanking-twiddling-c3b6c9108438@wendy>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-3-yongxuan.wang@sifive.com>
 <20240605-atrium-neuron-c2512b34d3da@spud>
 <CAK9=C2XH7-RdVpojX8GNW-WFTyChW=sTOWs8_kHgsjiFYwzg+g@mail.gmail.com>
 <20240621-10d503a9a2e7d54e67db102c@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uIOl3MGYsZNkzbCU"
Content-Disposition: inline
In-Reply-To: <20240621-10d503a9a2e7d54e67db102c@orel>

--uIOl3MGYsZNkzbCU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2024 at 10:33:03AM +0200, Andrew Jones wrote:
> On Thu, Jun 20, 2024 at 11:55:44AM GMT, Anup Patel wrote:
> > On Wed, Jun 5, 2024 at 10:25=E2=80=AFPM Conor Dooley <conor@kernel.org>=
 wrote:
> > >
> > > On Wed, Jun 05, 2024 at 08:15:08PM +0800, Yong-Xuan Wang wrote:
> > > > Add entries for the Svade and Svadu extensions to the riscv,isa-ext=
ensions
> > > > property.
> > > >
> > > > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > > > ---
> > > >  .../devicetree/bindings/riscv/extensions.yaml | 30 +++++++++++++++=
++++
> > > >  1 file changed, 30 insertions(+)
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/riscv/extensions.yam=
l b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > index 468c646247aa..1e30988826b9 100644
> > > > --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > @@ -153,6 +153,36 @@ properties:
> > > >              ratified at commit 3f9ed34 ("Add ability to manually t=
rigger
> > > >              workflow. (#2)") of riscv-time-compare.
> > > >
> > > > +        - const: svade
> > > > +          description: |
> > > > +            The standard Svade supervisor-level extension for rais=
ing page-fault
> > > > +            exceptions when PTE A/D bits need be set as ratified i=
n the 20240213
> > > > +            version of the privileged ISA specification.
> > > > +
> > > > +            Both Svade and Svadu extensions control the hardware b=
ehavior when
> > > > +            the PTE A/D bits need to be set. The default behavior =
for the four
> > > > +            possible combinations of these extensions in the devic=
e tree are:
> > > > +            1. Neither svade nor svadu in DT: default to svade.
> > >
> > > I think this needs to be expanded on, as to why nothing means svade.
> >=20
> > Actually if both Svade and Svadu are not present in DT then
> > it is left to the platform and OpenSBI does nothing.
>=20
> This is a good point, and maybe it's worth integrating something that
> states this case is technically unknown into the final text. (Even though
> historically this has been assumed to mean svade.)

If that is assumed to mean svade at the moment, then that's what it has
to mean going forwards also.

--uIOl3MGYsZNkzbCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZnVR7AAKCRB4tDGHoIJi
0oVHAP4siHUZEfCCwMM83p0CPjCOAJEGoNcOdr0nkhPzLVIczAD/Q7yiuanMfYXr
nzrBjtDPUd3Y5QR0QzLeGN78fexxmAw=
=728p
-----END PGP SIGNATURE-----

--uIOl3MGYsZNkzbCU--

