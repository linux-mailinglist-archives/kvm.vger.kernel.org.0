Return-Path: <kvm+bounces-20232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71FED912229
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:20:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27F2C287846
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 10:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967AB17106F;
	Fri, 21 Jun 2024 10:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="BFvmdqp/"
X-Original-To: kvm@vger.kernel.org
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA02172BC4;
	Fri, 21 Jun 2024 10:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718965125; cv=none; b=hGPE/R0WQ2wW9+QT/5643YY0A1xir6BfZBD+kie3qewPo+cXKKsjlDCFbtMAWc9q29cxDMGPSbI+UuPbgS1CsHlxAoVA4v0nKlFDKzrveYTsClnTYnRMeMl4PaHui9vZohuKbFPbSY1DbvwiIgtEXtkl7yPgxGiyf7pAIy03Huk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718965125; c=relaxed/simple;
	bh=N1yo7secwogxuEPVHJ5Vld6lZEvYNi5oKI8TVPWuc8g=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVjF9VI8c5+RaeYUtIbP1G+yUDtI79EaOKY1bi7ILtrsUO5KF40vyjvPFFl3cdjI3aZ+mv8IzYFrgOb4iperLoOeHx/h9bXGkQ0ZIzNR6WSh0Kdx/kb4AfFS3l8kaX24SBN6BayjprtycpupcKJ0JVxiUgw0MhE/ge9SFkXakY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=BFvmdqp/; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1718965124; x=1750501124;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N1yo7secwogxuEPVHJ5Vld6lZEvYNi5oKI8TVPWuc8g=;
  b=BFvmdqp/zlHshCSNpDaGQ5mSlnXuO0KIX1YzXPweEtwYYfvIoKWAW5Jm
   91T2uBcCZVbi90IlBx78OVFSaA6hS2cJCHU9AloDQMel6QZrdTiymCj8J
   e0VcGfZJL2Nf//vXJaGyNXO1TmjFseM/FsVTrsVP5AWod5/n5XLLBSwFc
   0m/yuuLr0NYXvuG8X4yw2eQWbvKfR5Icm0tDeKuITzSDO8ybGmnt1G+0o
   V/Lt7nSIzJzFKu+8TWL5FjFLuCI7+UR+8O4E5rgCNO/aeMUfgXeCeGn2S
   73Kkxcg7mM6f226t33BjpB/7XxEu1x34CGRVgVN0EvAQ/vWz5m/C60F1R
   g==;
X-CSE-ConnectionGUID: HFkKWv5gQi6XJez7y6X/8g==
X-CSE-MsgGUID: D4+6zTj7RaSh21uL4J0goA==
X-IronPort-AV: E=Sophos;i="6.08,254,1712646000"; 
   d="asc'?scan'208";a="28968692"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Jun 2024 03:18:42 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 21 Jun 2024 03:18:15 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex02.mchp-main.com (10.10.85.144)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Fri, 21 Jun 2024 03:18:12 -0700
Date: Fri, 21 Jun 2024 11:17:53 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Alexandre Ghiti <alex@ghiti.fr>
CC: Anup Patel <apatel@ventanamicro.com>, Conor Dooley <conor@kernel.org>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>, <linux-kernel@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>, <kvm-riscv@lists.infradead.org>,
	<kvm@vger.kernel.org>, <ajones@ventanamicro.com>, <greentime.hu@sifive.com>,
	<vincent.chen@sifive.com>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski
	<krzk+dt@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, Palmer
 Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
	<devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Message-ID: <20240621-viewless-mural-f5992a247992@wendy>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-3-yongxuan.wang@sifive.com>
 <20240605-atrium-neuron-c2512b34d3da@spud>
 <CAK9=C2XH7-RdVpojX8GNW-WFTyChW=sTOWs8_kHgsjiFYwzg+g@mail.gmail.com>
 <40a7d568-3855-48fb-a73c-339e1790f12f@ghiti.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/Q/JsluL++EEkeZ1"
Content-Disposition: inline
In-Reply-To: <40a7d568-3855-48fb-a73c-339e1790f12f@ghiti.fr>

--/Q/JsluL++EEkeZ1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2024 at 10:37:21AM +0200, Alexandre Ghiti wrote:
> On 20/06/2024 08:25, Anup Patel wrote:
> > On Wed, Jun 5, 2024 at 10:25=E2=80=AFPM Conor Dooley <conor@kernel.org>=
 wrote:
> > > On Wed, Jun 05, 2024 at 08:15:08PM +0800, Yong-Xuan Wang wrote:
> > > > Add entries for the Svade and Svadu extensions to the riscv,isa-ext=
ensions
> > > > property.
> > > >=20
> > > > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > > > ---
> > > >   .../devicetree/bindings/riscv/extensions.yaml | 30 ++++++++++++++=
+++++
> > > >   1 file changed, 30 insertions(+)
> > > >=20
> > > > diff --git a/Documentation/devicetree/bindings/riscv/extensions.yam=
l b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > index 468c646247aa..1e30988826b9 100644
> > > > --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > @@ -153,6 +153,36 @@ properties:
> > > >               ratified at commit 3f9ed34 ("Add ability to manually =
trigger
> > > >               workflow. (#2)") of riscv-time-compare.
> > > >=20
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
> > > I think this needs to be expanded on, as to why nothing means svade.
> > Actually if both Svade and Svadu are not present in DT then
> > it is left to the platform and OpenSBI does nothing.
> >=20
> > > > +            2. Only svade in DT: use svade.
> > > That's a statement of the obvious, right?
> > >=20
> > > > +            3. Only svadu in DT: use svadu.
> > > This is not relevant for Svade.
> > >=20
> > > > +            4. Both svade and svadu in DT: default to svade (Linux=
 can switch to
> > > > +               svadu once the SBI FWFT extension is available).
> > > "The privilege level to which this devicetree has been provided can s=
witch to
> > > Svadu if the SBI FWFT extension is available".
> > >=20
> > > > +        - const: svadu
> > > > +          description: |
> > > > +            The standard Svadu supervisor-level extension for hard=
ware updating
> > > > +            of PTE A/D bits as ratified at commit c1abccf ("Merge =
pull request
> > > > +            #25 from ved-rivos/ratified") of riscv-svadu.
> > > > +
> > > > +            Both Svade and Svadu extensions control the hardware b=
ehavior when
> > > > +            the PTE A/D bits need to be set. The default behavior =
for the four
> > > > +            possible combinations of these extensions in the devic=
e tree are:
> > > @Anup/Drew/Alex, are we missing some wording in here about it only be=
ing
> > > valid to have Svadu in isolation if the provider of the devicetree has
> > > actually turned on Svadu? The binding says "the default behaviour", b=
ut
> > > it is not the "default" behaviour, the behaviour is a must AFAICT. If
> > > you set Svadu in isolation, you /must/ have turned it on. If you set
> > > Svadu and Svade, you must have Svadu turned off?
> > Yes, the wording should be more of requirement style using
> > must or may.
> >=20
> > How about this ?
> > 1) Both Svade and Svadu not present in DT =3D> Supervisor may
> >      assume Svade to be present and enabled or it can discover
> >      based on mvendorid, marchid, and mimpid.
> > 2) Only Svade present in DT =3D> Supervisor must assume Svade
> >      to be always enabled. (Obvious)
> > 3) Only Svadu present in DT =3D> Supervisor must assume Svadu
> >      to be always enabled. (Obvious)
>=20
>=20
> I agree with all of that, but the problem is how can we guarantee that
> openSBI actually enabled svadu?=20
Conflation of an SBI implementation and OpenSBI aside, if the devicetree
property is defined to mean that "the supervisor must assume svadu to be
always enabled", then either it is, or the firmware's description of the
hardware is broken and it's not the supervisor's problem any more. It's
not the kernel's job to validate that the devicetree matches the
hardware.

> This is not the case for now.

What "is not the case for now"? My understanding was that, at the
moment, nothing happens with Svadu in OpenSBI. In turn, this means that
there should be no devicetrees containing Svadu (per this binding's
description) and therefore no problem?

Thanks,
Conor.

--/Q/JsluL++EEkeZ1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZnVTUQAKCRB4tDGHoIJi
0umAAP9Ky5jmwL/vxKQCCEHnHdguojF9KRICh/OKTjjNr83q0QD+M27FYa47s7qx
aJWtzNZgU73VI8rgfcbj5zSeT7XqZQQ=
=l7ge
-----END PGP SIGNATURE-----

--/Q/JsluL++EEkeZ1--

