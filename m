Return-Path: <kvm+bounces-20284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2211491273C
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 16:05:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41BD51C23315
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B7D418C19;
	Fri, 21 Jun 2024 14:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oET6lsg4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17789134BC;
	Fri, 21 Jun 2024 14:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718978693; cv=none; b=s7c4VEvPlOkHSIlSr0kdwfirUyLzUlpEqx53abY8ZjBJ4ITWSg2xspRFxVHcI5T95RglxHBnFjqowziiB8rTRqqo8J2DCYUkYslmoamdGc2MxFnrrAZsLACbfoafO97G4BjcW/abZiwC9qR6eDXxBkRLaRlTdYq3WTWusYoEU/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718978693; c=relaxed/simple;
	bh=KWONXLjIDswlsmFvy16KVHeYndfVYsx2KlAtEwqZ4dU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F+P/js4kTaRCtkOTkHb5ZfQSAGdmLSXEZ7V6nlNxMm8oqyLMTGsSCptvP4xwXoVlalsYNVAp3YLxYiuMKrfu27+E/JudzS80glmL25c2IkAAEpOcN2nEzpbE8A3d1E7uTaUPJ5p9xBzoUYnU5azqEO1V7Sl5IFSNo1S71CsEg7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oET6lsg4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62082C2BBFC;
	Fri, 21 Jun 2024 14:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718978692;
	bh=KWONXLjIDswlsmFvy16KVHeYndfVYsx2KlAtEwqZ4dU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oET6lsg4mKcAgsDQrC0hA/Q3BbSXRXajfx26T9gI1bPB+UEUoBLFKq0YJtFNV70ib
	 it2BQbNLzutOEjK5w/r3P5dr9QY+/gTjWGaaXIqAH/c2LpcUadIMkDteFkgUgJT28y
	 ouTaof7EjAYOAzigL2dMMuULJSeqz1nlvxvPcnsjByat4Aj5l8JwqKEj19MV/6kYGp
	 /+k8rqlLbjvtXPNgI1SfldUVWYTvQo58LlkKEhOV5AapBu0FcpZmrcpGLfgFgr7zBp
	 DEHmoG3Fr2iu+l6EJjXKRHZPJ3Gffo2pHdoOKaJi3IcIZnocKH1X/iVdzF3wenjO0Q
	 bRtpPlwegkcdQ==
Date: Fri, 21 Jun 2024 15:04:47 +0100
From: Conor Dooley <conor@kernel.org>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	Conor Dooley <conor.dooley@microchip.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
	greentime.hu@sifive.com, vincent.chen@sifive.com,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
Message-ID: <20240621-glutton-platonic-2ec41021b81b@spud>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-3-yongxuan.wang@sifive.com>
 <20240605-atrium-neuron-c2512b34d3da@spud>
 <CAK9=C2XH7-RdVpojX8GNW-WFTyChW=sTOWs8_kHgsjiFYwzg+g@mail.gmail.com>
 <40a7d568-3855-48fb-a73c-339e1790f12f@ghiti.fr>
 <20240621-viewless-mural-f5992a247992@wendy>
 <edcd3957-0720-4ab4-bdda-58752304a53a@ghiti.fr>
 <20240621-9bf9365533a2f8f97cbf1f5e@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="qd/Kua9U59FyvKVK"
Content-Disposition: inline
In-Reply-To: <20240621-9bf9365533a2f8f97cbf1f5e@orel>


--qd/Kua9U59FyvKVK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2024 at 03:15:10PM +0200, Andrew Jones wrote:
> On Fri, Jun 21, 2024 at 02:42:15PM GMT, Alexandre Ghiti wrote:
> >=20
> > On 21/06/2024 12:17, Conor Dooley wrote:
> > > On Fri, Jun 21, 2024 at 10:37:21AM +0200, Alexandre Ghiti wrote:
> > > > On 20/06/2024 08:25, Anup Patel wrote:
> > > > > On Wed, Jun 5, 2024 at 10:25=E2=80=AFPM Conor Dooley <conor@kerne=
l.org> wrote:
> > > > > > On Wed, Jun 05, 2024 at 08:15:08PM +0800, Yong-Xuan Wang wrote:
> > > > > > > Add entries for the Svade and Svadu extensions to the riscv,i=
sa-extensions
> > > > > > > property.
> > > > > > >=20
> > > > > > > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > > > > > > ---
> > > > > > >    .../devicetree/bindings/riscv/extensions.yaml | 30 +++++++=
++++++++++++
> > > > > > >    1 file changed, 30 insertions(+)
> > > > > > >=20
> > > > > > > diff --git a/Documentation/devicetree/bindings/riscv/extensio=
ns.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > > > > index 468c646247aa..1e30988826b9 100644
> > > > > > > --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > > > > +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > > > > > > @@ -153,6 +153,36 @@ properties:
> > > > > > >                ratified at commit 3f9ed34 ("Add ability to ma=
nually trigger
> > > > > > >                workflow. (#2)") of riscv-time-compare.
> > > > > > >=20
> > > > > > > +        - const: svade
> > > > > > > +          description: |
> > > > > > > +            The standard Svade supervisor-level extension fo=
r raising page-fault
> > > > > > > +            exceptions when PTE A/D bits need be set as rati=
fied in the 20240213
> > > > > > > +            version of the privileged ISA specification.
> > > > > > > +
> > > > > > > +            Both Svade and Svadu extensions control the hard=
ware behavior when
> > > > > > > +            the PTE A/D bits need to be set. The default beh=
avior for the four
> > > > > > > +            possible combinations of these extensions in the=
 device tree are:
> > > > > > > +            1. Neither svade nor svadu in DT: default to sva=
de.
> > > > > > I think this needs to be expanded on, as to why nothing means s=
vade.
> > > > > Actually if both Svade and Svadu are not present in DT then
> > > > > it is left to the platform and OpenSBI does nothing.
> > > > >=20
> > > > > > > +            2. Only svade in DT: use svade.
> > > > > > That's a statement of the obvious, right?
> > > > > >=20
> > > > > > > +            3. Only svadu in DT: use svadu.
> > > > > > This is not relevant for Svade.
> > > > > >=20
> > > > > > > +            4. Both svade and svadu in DT: default to svade =
(Linux can switch to
> > > > > > > +               svadu once the SBI FWFT extension is availabl=
e).
> > > > > > "The privilege level to which this devicetree has been provided=
 can switch to
> > > > > > Svadu if the SBI FWFT extension is available".
> > > > > >=20
> > > > > > > +        - const: svadu
> > > > > > > +          description: |
> > > > > > > +            The standard Svadu supervisor-level extension fo=
r hardware updating
> > > > > > > +            of PTE A/D bits as ratified at commit c1abccf ("=
Merge pull request
> > > > > > > +            #25 from ved-rivos/ratified") of riscv-svadu.
> > > > > > > +
> > > > > > > +            Both Svade and Svadu extensions control the hard=
ware behavior when
> > > > > > > +            the PTE A/D bits need to be set. The default beh=
avior for the four
> > > > > > > +            possible combinations of these extensions in the=
 device tree are:
> > > > > > @Anup/Drew/Alex, are we missing some wording in here about it o=
nly being
> > > > > > valid to have Svadu in isolation if the provider of the devicet=
ree has
> > > > > > actually turned on Svadu? The binding says "the default behavio=
ur", but
> > > > > > it is not the "default" behaviour, the behaviour is a must AFAI=
CT. If
> > > > > > you set Svadu in isolation, you /must/ have turned it on. If yo=
u set
> > > > > > Svadu and Svade, you must have Svadu turned off?
> > > > > Yes, the wording should be more of requirement style using
> > > > > must or may.
> > > > >=20
> > > > > How about this ?
> > > > > 1) Both Svade and Svadu not present in DT =3D> Supervisor may
> > > > >       assume Svade to be present and enabled or it can discover
> > > > >       based on mvendorid, marchid, and mimpid.
> > > > > 2) Only Svade present in DT =3D> Supervisor must assume Svade
> > > > >       to be always enabled. (Obvious)
> > > > > 3) Only Svadu present in DT =3D> Supervisor must assume Svadu
> > > > >       to be always enabled. (Obvious)
> > > >=20
> > > > I agree with all of that, but the problem is how can we guarantee t=
hat
> > > > openSBI actually enabled svadu?
> > > Conflation of an SBI implementation and OpenSBI aside, if the devicet=
ree
> > > property is defined to mean that "the supervisor must assume svadu to=
 be
> > > always enabled", then either it is, or the firmware's description of =
the
> > > hardware is broken and it's not the supervisor's problem any more. It=
's
> > > not the kernel's job to validate that the devicetree matches the
> > > hardware.
> > >=20
> > > > This is not the case for now.
> > > What "is not the case for now"? My understanding was that, at the
> > > moment, nothing happens with Svadu in OpenSBI. In turn, this means th=
at
> > > there should be no devicetrees containing Svadu (per this binding's
> > > description) and therefore no problem?
> >=20
> >=20
> > What prevents a dtb to be passed with svadu to an old version of opensbi
> > which does not support the enablement of svadu? The svadu extension wil=
l end
> > up being present in the kernel but not enabled right?

If you'll allow me use of my high horse, relying on undocumented
(or deprecated I suppose in this case) devicetree properties is always
going to leave people exposed to issues like this. If the property isn't
documented, then you shouldn't be passing it to the kernel.

> I understand the concern; old SBI implementations will leave svadu in the
> DT but not actually enable it. Then, since svade may not be in the DT if
> the platform doesn't support it or it was left out on purpose, Linux will
> only see svadu and get unexpected exceptions. This is something we could
> force easily with QEMU and an SBI implementation which doesn't do anything
> for svadu. I hope vendors of real platforms, which typically provide their
> own firmware and DTs, would get this right, though, especially since Linux
> should fail fast in their testing when they get it wrong.

I'll admit, I wasn't really thinking here about something like QEMU that
puts extensions into the dtb before their exact meanings are decided
upon. I almost only ever think about "real" systems, and in those cases
I would expect that if you can update the representation of the hardware
provided to (or by the firmware to Linux) with new properties, then updating
the firmware itself should be possible.

Does QEMU have the this exact problem at the moment? I know it puts
Svadu in the max cpu, but does it enable the behaviour by default, even
without the SBI implementation asking for it?

Sorta on a related note, I'm completely going head-in-sand here for ACPI,
cos I have no idea how that is being dealt with - other than that Linux
assumes that all ACPI properties have the same meaning as the DT ones. I
don't really think that that is sustainable, but it is what we are doing
at present. Maybe I should put that in boot.rst or in acpi.rst?

Also on the ACPI side of things, and I am going an uber devil's advocate
here, the version of the spec that we documented as defining our parsing
rules never mentions svade or svadu, so is it even valid to use them on
ACPI systems?




--qd/Kua9U59FyvKVK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZnWIfwAKCRB4tDGHoIJi
0q/dAP4kNGqCQqfmua36oZyQabQDESU4lnBPcaNqz4EP05qYHwEAv0/Przk2eqiW
eKknt2R9xQc1PxpjjybKTm7K30FMVAU=
=WPCG
-----END PGP SIGNATURE-----

--qd/Kua9U59FyvKVK--

