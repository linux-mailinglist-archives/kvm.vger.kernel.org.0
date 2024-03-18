Return-Path: <kvm+bounces-12016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB2C387EFC9
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 19:31:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 008B1B22D59
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 18:31:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30C22381CB;
	Mon, 18 Mar 2024 18:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cOAfzFmg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2CE256A;
	Mon, 18 Mar 2024 18:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710786687; cv=none; b=g32WIedCDQwFvhvsqkI6AQX6xYGDWfM+V2huARRQEfaap2ap5+Gi8bt4aLf0u3x0RneDuVPyIr/9ny2yz/mv+IEP1NNnzZpSAcBZoWkMGvh46+AqKOY8eYpoNyqq0dU0wU7oX3bRrk02AV/n5P5ZxmuHsbjiudzaSegbrp9DDag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710786687; c=relaxed/simple;
	bh=iHwyRG9+4juuu7c1xOvb0pqniSl3V2wL2xGVwaxzr2w=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u2VYYqx8jwlq5EHtSMg3xSpfoP2Fv+VNGu10RXNpt7ua9NvhxrokUVbMk/mttGq+3TwkD25/Naqucckwx151gzDcYT7OgkWlnUIekqYFtqO4vJM7ceF6nMFp/r1VWBrGDsUUyYIkXrSRS2gseUdQOAX3kLmvNZ3DMV7K6WOoPxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cOAfzFmg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E13C433F1;
	Mon, 18 Mar 2024 18:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710786686;
	bh=iHwyRG9+4juuu7c1xOvb0pqniSl3V2wL2xGVwaxzr2w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cOAfzFmgwlp06nEqpw2itw5KdTa31ENQTTXwa083LVxo5Oek20CJJ64XAMGbgsrpT
	 8KtbJ18f/T0r/T/O4BQLjJ1lrldmr6KM9Q+chf7YvLgd9eLZli0int+roNHuG8vris
	 /JUj4rDZXEHYKPSbF7sJ1gfRQKuKmHbIn/kdK9Mt1cA1NMUBlwhKE429e8gWSGjbXD
	 991iH+rV7SWJPLXWe/wS++JWX929Ze7JoMBx+5G797DEX5ayAkLBlqGXbTJ9P9sezB
	 2sFwxRWnloWbPxOKf5ateWvZhAb7/6TjEBZUD872/IeOqoAOW25Ot8fzm2K/KRIlG9
	 XKNOXgsPc/yjQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rmHlc-00DM2p-GK;
	Mon, 18 Mar 2024 18:31:24 +0000
Date: Mon, 18 Mar 2024 18:31:24 +0000
Message-ID: <86plvrz91f.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Paolo Bonzini
 <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Oliver Upton
 <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K
 Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi
 <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown
 <len.brown@intel.com>,
	Pavel Machek <pavel@ucw.cz>,
	Mostafa Saleh
 <smostafa@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] arm64: Add PSCI v1.3 SYSTEM_OFF2 support for hibernation
In-Reply-To: <5d8394e6c2c77093eca0ecaf355da77eba710dc1.camel@infradead.org>
References: <20240318164646.1010092-1-dwmw2@infradead.org>
	<86wmpzzdep.wl-maz@kernel.org>
	<eb9215850e8231ab8ef75f523925be671cc6f5a0.camel@infradead.org>
	<86ttl3zbd3.wl-maz@kernel.org>
	<5d8394e6c2c77093eca0ecaf355da77eba710dc1.camel@infradead.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/29.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: dwmw2@infradead.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, lpieralisi@kernel.org, rafael@kernel.org, len.brown@intel.com, pavel@ucw.cz, smostafa@google.com, jean-philippe@linaro.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, linux-pm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 18 Mar 2024 18:15:36 +0000,
David Woodhouse <dwmw2@infradead.org> wrote:
>=20
> [1  <text/plain; UTF-8 (quoted-printable)>]
> On Mon, 2024-03-18 at 17:41 +0000, Marc Zyngier wrote:
> > On Mon, 18 Mar 2024 17:26:07 +0000,
> > David Woodhouse <dwmw2@infradead.org> wrote:
> > >=20
> > > [1=C2=A0 <text/plain; UTF-8 (quoted-printable)>]
> > > On Mon, 2024-03-18 at 16:57 +0000, Marc Zyngier wrote:
> > > >=20
> > > > >=20
> > > > > There *is* a way for a VMM to opt *out* of newer PSCI versions...=
 by=20
> > > > > setting a per-vCPU "special" register that actually ends up setti=
ng the=20
> > > > > PSCI version KVM-wide. Quite why this isn't just a simple KVM_CAP=
, I=20
> > > > > have no idea.
> > > >=20
> > > > Because the expectations are that the VMM can blindly save/restore =
the
> > > > guest's state, including the PSCI version, and restore that blindly.
> > > > KVM CAPs are just a really bad design pattern for this sort of thin=
gs.
> > >=20
> > > Hm, am I missing something here? Does the *guest* get to set the PSCI
> > > version somehow, and opt into the latest version that it understands
> > > regardless of what the firmware/host can support?
> >=20
> > No. The *VMM* sets the PSCI version by writing to a pseudo register.
> > It means that when the guest migrates, the VMM saves and restores that
> > version, and the guest doesn't see any change.
>=20
> And when you boot a guest image which has been working for years under
> a new kernel+KVM, your guest suddenly experiences a new PSCI version.
> As I said that's not just new optional functions; it's potentially even
> returning new error codes to the functions that said guest was already
> using.

If you want to stick to a given PSCI version, you write the version
you want.

>=20
> And when you *hibernate* a guest and then launch it again under a newer
> kernel+KVM, it experiences the same incompatibility.
>=20
> Unless the VMM realises this problem and opts *out* of the newer KVM
> behaviour, of course. This is very much unlike how we *normally* expose
> new KVM capabilities.

This was discussed at length 5 or 6 years ago (opt-in vs opt-out).

The feedback from QEMU (which is the only public VMM that does
anything remotely useful with this) was that opt-out was a better
model, specially as PSCI is the conduit for advertising the Spectre
mitigations and users (such as certain cloud vendors) were pretty keen
on guests seeing the mitigations advertised *by default*.

And if you can spot any form of "normality" in the KVM interface, I'll
buy you whatever beer you want. It is all inconsistent crap, so I
think we're in pretty good company here.

>=20
> > > I don't think we ever aspired to be able to hand an arbitrary KVM fd =
to
> > > a userspace VMM and have the VMM be able to drive that VM without
> > > having any a priori context, did we?
> >=20
> > Arbitrary? No. This is actually very specific and pretty well
> > documented.
> >=20
> > Also, to answer your question about why we treat 0.1 differently from
> > 0.2+: 0.1 didn't specify the PSCI SMC/HCR encoding, meaning that KVM
> > implemented something that was never fully specified. The VMM has to
> > provide firmware tables that describe that. With 0.2+, there is a
> > standard encoding for all functions, and the VMM doesn't have to
> > provide the encoding to the guest.
>=20
> Gotcha. So for that case we were *forced* to do things correctly and
> allow userspace to opt-in to the capability. While for 0.2 onwards we
> got away with this awfulness of silently upgrading the version without
> VMM consent.
>=20
> I was hoping to just follow the existing model of SYSTEM_RESET2 and not
> have to touch this awfulness with a barge-pole, but sure, whatever you
> want.

Unless I'm reading the whole thing wrong (which isn't impossible given
that I'm jet-lagged to my eyeballs), SYSTEM_RESET2 doesn't have any
form of configuration. If PSCI 1.1 is selected, SYSTEM_RESET2 is
available. So that'd be the model to follow.

	M.

--=20
Without deviation from the norm, progress is not possible.

