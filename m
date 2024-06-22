Return-Path: <kvm+bounces-20323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 976029133A3
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 14:01:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4320C1F21FFF
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 12:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E95AC5A788;
	Sat, 22 Jun 2024 12:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CWaCrU20"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1135A14B955;
	Sat, 22 Jun 2024 12:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719057696; cv=none; b=HjRwwDyNMV/xLVKWWZHxpY9xA0XW2k9OfJ8VncvT+5FLQ4iVhQfJL1l9ha4EJOtH0eyku+oL0b8m6ZLL3lhtXMpKCpMVFm6c0QUB+aTXn9Dcqt7LJR/v7Hp/IvMMYmJetqPpMCzKXcGJX8YQOgcIRAMWqQqk3MkqNPw4bKUsyOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719057696; c=relaxed/simple;
	bh=4IxETGVg4/bc2jI5lLzgI9phYpsgH2CfHaJhgcXMNNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=agtkYSQ2fxrIUFd+Lmeg+eTYzDG+yc86A3BXRSD59xAUPAzjUdZIz/FwGhFaC9GRU+0uyBa0ka5NTNSaNt5+0m+73CBnQ1FpEWdo7vSjr3Ju4CnoYYyqGiCHnVAHkZx5Cjox2xRTcVrH+3WOb2bqV9YF5zRxkO1/c75YYvBCXc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CWaCrU20; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FC5C3277B;
	Sat, 22 Jun 2024 12:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719057695;
	bh=4IxETGVg4/bc2jI5lLzgI9phYpsgH2CfHaJhgcXMNNU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CWaCrU20NmFrhv6fqL/qkygH4JAUO+yFKNXsfDcsn8YVtQwHKMpnzvSgUL42gzMw8
	 b9/0E3260B7BoLTOVfteBcG5GSp/r9EyCKp2jGjTJR3PsV6z72mAAZwDiLHVyTXSck
	 roeyXDyEv3JSguVA/7Y5gs4GEijb0XRfhT7m+egXGEfPh3MTf1/M11Hq7du9vowcfM
	 3PcNurM9jRoV9lTnqr8IaKHpBieoaCcodDWTk4KHjE6pLF6C2bBshrpWMlTcncfITL
	 D7nq/FipswdGKwtnj/EbcoF36LV7GN1u9w9Lpo+sCNBOjqGwa+NaKeZYZwx28oFt3J
	 9TnNnYdNoaZYw==
Date: Sat, 22 Jun 2024 13:01:30 +0100
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
Message-ID: <20240622-stride-unworn-6e3270a326e5@spud>
References: <20240605-atrium-neuron-c2512b34d3da@spud>
 <CAK9=C2XH7-RdVpojX8GNW-WFTyChW=sTOWs8_kHgsjiFYwzg+g@mail.gmail.com>
 <40a7d568-3855-48fb-a73c-339e1790f12f@ghiti.fr>
 <20240621-viewless-mural-f5992a247992@wendy>
 <edcd3957-0720-4ab4-bdda-58752304a53a@ghiti.fr>
 <20240621-9bf9365533a2f8f97cbf1f5e@orel>
 <20240621-glutton-platonic-2ec41021b81b@spud>
 <20240621-a56e848050ebbf1f7394e51f@orel>
 <20240621-surging-flounder-58a653747e1d@spud>
 <20240621-8422c24612ae40600f349f7c@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ZMOCsO9fyo4yCpOo"
Content-Disposition: inline
In-Reply-To: <20240621-8422c24612ae40600f349f7c@orel>


--ZMOCsO9fyo4yCpOo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2024 at 05:08:01PM +0200, Andrew Jones wrote:
> On Fri, Jun 21, 2024 at 03:58:18PM GMT, Conor Dooley wrote:
> > On Fri, Jun 21, 2024 at 04:52:09PM +0200, Andrew Jones wrote:
> > > On Fri, Jun 21, 2024 at 03:04:47PM GMT, Conor Dooley wrote:
> > > > On Fri, Jun 21, 2024 at 03:15:10PM +0200, Andrew Jones wrote:
> > > > > On Fri, Jun 21, 2024 at 02:42:15PM GMT, Alexandre Ghiti wrote:
> >=20
> > > > > I understand the concern; old SBI implementations will leave svad=
u in the
> > > > > DT but not actually enable it. Then, since svade may not be in th=
e DT if
> > > > > the platform doesn't support it or it was left out on purpose, Li=
nux will
> > > > > only see svadu and get unexpected exceptions. This is something w=
e could
> > > > > force easily with QEMU and an SBI implementation which doesn't do=
 anything
> > > > > for svadu. I hope vendors of real platforms, which typically prov=
ide their
> > > > > own firmware and DTs, would get this right, though, especially si=
nce Linux
> > > > > should fail fast in their testing when they get it wrong.
> > > >=20
> > > > I'll admit, I wasn't really thinking here about something like QEMU=
 that
> > > > puts extensions into the dtb before their exact meanings are decided
> > > > upon. I almost only ever think about "real" systems, and in those c=
ases
> > > > I would expect that if you can update the representation of the har=
dware
> > > > provided to (or by the firmware to Linux) with new properties, then=
 updating
> > > > the firmware itself should be possible.
> > > >=20
> > > > Does QEMU have the this exact problem at the moment? I know it puts
> > > > Svadu in the max cpu, but does it enable the behaviour by default, =
even
> > > > without the SBI implementation asking for it?
> > >=20
> > > Yes, because QEMU has done hardware A/D updating since it first start=
ed
> > > supporting riscv, which means it did svadu when neither svadu nor sva=
de
> > > were in the DT. The "fix" for that was to ensure we have svadu and !s=
vade
> > > by default, which means we've perfectly realized Alexandre's concern.=
=2E.
> > > We should be able to change the named cpu types that don't support sv=
adu
> > > to only have svade in their DTs, since that would actually be fixing =
those
> > > cpu types, but we'll need to discuss how to proceed with the generic =
cpu
> > > types like 'max'.
> >=20
> > Correct me please, since I think I am misunderstanding: At the moment
> > QEMU does A/D updating whether or not the SBI implantation asks for it,
> > with the max CPU. The SBI implementation doesn't understand Svadu and
> > won't strip it. The kernel will get a DT with Svadu in it, but Svadu wi=
ll
> > be enabled, so it is not a problem.
>=20
> Oh, of course you're right! I managed to reverse things some odd number of
> times (more than once!) in my head and ended up backwards...

I mean, I've been really confused about this whole thing the entire
time, so ye..

Speaking of QEMU, what happens if I try to turn on svade and svadu in
QEMU? It looks like there's some handling of it that does things
conditionally based !svade && svade, but I couldn't tell if it would do
what we are describing in this thread.

--ZMOCsO9fyo4yCpOo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZna9GgAKCRB4tDGHoIJi
0h3EAQCEzS530QLTXXBLPksl2mQ8sX+WkbvTcdwou3zq2avSrgEA6hNFxVSOme2f
3YECDPsNJ8996blTH6mu6XZ5ht3fRAg=
=pKba
-----END PGP SIGNATURE-----

--ZMOCsO9fyo4yCpOo--

