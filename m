Return-Path: <kvm+bounces-60669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD183BF6F09
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 16:00:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2FC7189A902
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 14:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C8AF33971D;
	Tue, 21 Oct 2025 14:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aFcoZ9Dl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84C523E334;
	Tue, 21 Oct 2025 14:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761055236; cv=none; b=FaacOzaw4YmUsju0BV/0+4DWFWgEhybc2flt0MgPaZciJ0s9c2COn3KZOmWCVHTwBK5MRMr91DPFw1I4zuY9MZ8/G6oI2ruc/je/3bhA3EPjrzUEYTlVBImTf7/4TnDkf5SaXzxEPTQzmzpAtzxoCaUtx3/b2GY/jWzy1Be3sks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761055236; c=relaxed/simple;
	bh=EFS2ou0OHQmiqS5lDgkHKShR4QgnzFyZtuGoeF4ARw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T7V0Yna3X9O9TY0Sc/UFWVEkHfJf73QYvXBgvRbFGNxxgdaoXX4vZU/XmxWzybHMSDK8/rTTcPCY/KFBIGOrRRgUdscmTzZf3MCYAvZzm4VUA++vXWj5K1nUtIMYLxWTiqpu5FQwjZm2ZbTPBBske+Jq8LSYpIhTq5lC4scG8OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aFcoZ9Dl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EE7C4CEF1;
	Tue, 21 Oct 2025 14:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761055236;
	bh=EFS2ou0OHQmiqS5lDgkHKShR4QgnzFyZtuGoeF4ARw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aFcoZ9Dl87h0IzZkohYqVR7bDWTyKIXo7EPZD3N/CLgJb1V3GCrrsNDs1BlQl8CO8
	 4zNuXSJfFA240hc5FqfSrzndQpdxW7cSjCuHuZY9WkhzhsD6upUrZCdHKQ1oEviAD4
	 jCMLUnq4T2h/vpePY2Ei1czit5VlKa0U32SjzLMwmHZ4JdDKgdW7eopcJ7uDJt/Xmp
	 spK37robToBy+pQTmGcyFsBTu11wevxnSKZsGYIFMeopxHJsCJTYrhjGbEt06pFz1y
	 I+QZErFW5h8SWEG+IhIq0ity34oQ9tOYp3SFpOpWLvWHtnb7vbBoltQpmF2LnBA7hq
	 HNsj1K8TbFsIw==
Date: Tue, 21 Oct 2025 15:00:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Sascha Bischoff <Sascha.Bischoff@arm.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Aishwarya.TCV@arm.com
Subject: Re: [PATCH] KVM: arm64: gic-v3: Only set ICH_HCR traps for v2-on-v3
 or v3 guests
Message-ID: <78b0297c-4622-4b75-bcae-45c144c92c45@sirena.org.uk>
References: <20251007160704.1673584-1-sascha.bischoff@arm.com>
 <23072856-6b8c-41e2-93d1-ea8a240a7079@sirena.org.uk>
 <86frbcwv5t.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wfhFGhe94Stv3FFn"
Content-Disposition: inline
In-Reply-To: <86frbcwv5t.wl-maz@kernel.org>
X-Cookie: Accordion, n.:


--wfhFGhe94Stv3FFn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 21, 2025 at 08:50:22AM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > It didn't appear in -next since the arm64 KVM fixes tree is not directly
> > in -next and it was only pulled into Paolo's tree on Saturday, a few
> > hours before Paolo sent his pull request to Linus, so there was no
> > opportunity for it to be picked up.  As I've previously suggested it
> > does seem like it would be a good idea to include the fixes branches for
> > the KVM arch trees in -next (s390 is there, but I don't see the others),

> As I explained to you more than once, the answer is still no. We keep
> the two branches separate for good reasons -- for a start, they are
> manager by different people.

You do keep saying that but I am still unable to understand your
reasoning here.  Having two separate branches is very standard, it is
the normal pattern for fixes branches in -next and does not generally
present any problems that I am aware of.  A bit more than a third of the
branches merged by -next are fixes branches.  As I said in my earlier
reply to Sean it can be an advantage to have the fixes in -next
separately since this allows the fixes to go into pending-fixes, helping
spot unintended dependencies on work that's targeting the merge window
and ensure coverage continues even when there is breakage in development
code.

As I understand it the management of the KVM arm64 tree is very similar
to that for the arm64 architecture tree.  That has the separate feature and
fixes branches in -next, each managed by different people and both of
which are in -next.  So far as I am aware this hasn't been causing Will
and Catalin any problems, I don't know what would be different about the
KVM arm64 tree here.

The only thing I can think of is that you are objecting to the idea of
having the KVM arm64 tree merge it's fixes branch into it's development
branch.  That is not what I am suggesting, I am suggesting putting the
fixes branch itself directly into -next to be merged by Stephen.  I am
not proposing any change to the content of the KVM arm64 branches.

> If you want to manage a -fixes tree, go for it. If you want to take
> the -fixes branch in your CI, I have no objection.  Do I support this?
> Absolutely not.

There is no need for anyone to create a -fixes tree since we already
have pending-fixes, created as part of building -next.  The merge for
-next pulls in all the fixes branches first, publishes that as
next/pending-fixes, and then merges the new feature branches on top of
that to publish as next/master.

--wfhFGhe94Stv3FFn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmj3kf0ACgkQJNaLcl1U
h9Dktwf/am3z/Hk2mvzO9eubv9A1vucrl5ffURTfbc37wQsUD3LS3VXXO/mRbU5b
KEV+tQJZ0p9ZmNbOo2QhOV+9W4SiKZero5lHYMfyFQd2oBxCV8D2mOtZVtLi7neS
3EJLxL/88s80PhIq7cQCFBPIn8VcBnH98e9a6KsUtI8t2LrU+ZMkb7eO1RfzQK2Q
4WF/YxBgXPRqpERIJuy58ETpwGDTJ04i76XmboOvuv1d/sLQMgZCp3ovI+IFsgCX
G+DKm5ydY/bnmuonDatzFCVVt2ifddsDzSiObpDyOGERP2MTp5jm+3bn7B7Z9Y2h
/hL9bcd+3moRsEiRl8MIJ1YyKdDndQ==
=Trde
-----END PGP SIGNATURE-----

--wfhFGhe94Stv3FFn--

