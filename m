Return-Path: <kvm+bounces-60661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83E3CBF61AB
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 13:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D48D480AE7
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 11:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3DDA32E739;
	Tue, 21 Oct 2025 11:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n6700cTO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4AD253B59;
	Tue, 21 Oct 2025 11:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761046793; cv=none; b=PkA1Y+WOgjEIPuwU4LVsDPnZxpzQjkkHXSaYYaTEl8/OgU6l/s/wNXWqBJ4N/XciaqnTzxyevcCIxG4MNGkx5DcivxRjPYEBPZQBiMY4iks+f09qSanRwg8Mnu/oC8lec0RPsrJ9Jk0z4FqoMCjbgcaUBGqfnQSYD7/n6JRrs7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761046793; c=relaxed/simple;
	bh=llPFiZH+aiQPzZXfintNmyQgVxx+gMTiwzDrdBfE+bo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I7sCHw5UGtXF7s6+zVSJ65KHBDvqtwnwQXTyYhyx42ivLAZbdpH0lkuKc9w4N5l9M34WmOAxGkvJzGtsuypp65+lfyoc74CoKaPf3nF4ymOSqaSiZ8gQ4Z/H5W/renYBoP9D7FrMsPdowxL2iAXbb1Gn7emBE6pkBmKaTA3Cf6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n6700cTO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9721EC4CEF5;
	Tue, 21 Oct 2025 11:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761046793;
	bh=llPFiZH+aiQPzZXfintNmyQgVxx+gMTiwzDrdBfE+bo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n6700cTObtZNDOH9FVsMQfq3yzftqps5t8d4UxS4JaixHMiSTTeBGgIoIhWD+I8H+
	 p+diSJ9wQjqcJ7s2cIySx3286tiZc47raTtJmTo0mPhQNn86LT1eLomO9cu5cVNNhx
	 jxwATcEeqwHL8dCGtAChVuW8TSbt8NWd4wAN8V0Pg8tqDBMdE7j80Z8Sqm5RpKaHFZ
	 +kj04UOyaEPUF2j1qexGH1FdihBU5fmKvep4/ONRoSryZdZATUZYxMMGI62e3M5hfx
	 pgWLemmbmWGlex8Sr9bhD/94OM9kctzF0Sc7CSHRpI72+wdz2lkwStHh3Sp57EDdQ6
	 Y6IH9HZvG11hg==
Date: Tue, 21 Oct 2025 12:39:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Sascha Bischoff <Sascha.Bischoff@arm.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Aishwarya.TCV@arm.com
Subject: Re: [PATCH] KVM: arm64: gic-v3: Only set ICH_HCR traps for v2-on-v3
 or v3 guests
Message-ID: <0a381733-6b5d-4aa0-bb3d-15a98a665c1c@sirena.org.uk>
References: <20251007160704.1673584-1-sascha.bischoff@arm.com>
 <23072856-6b8c-41e2-93d1-ea8a240a7079@sirena.org.uk>
 <aPbYuvlLzLENTCcP@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wMof+NrnbH5Ys3bd"
Content-Disposition: inline
In-Reply-To: <aPbYuvlLzLENTCcP@google.com>
X-Cookie: Accordion, n.:


--wMof+NrnbH5Ys3bd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 20, 2025 at 05:50:02PM -0700, Sean Christopherson wrote:
> On Tue, Oct 21, 2025, Mark Brown wrote:

> > hours before Paolo sent his pull request to Linus, so there was no
> > opportunity for it to be picked up.  As I've previously suggested it
> > does seem like it would be a good idea to include the fixes branches for
> > the KVM arch trees in -next (s390 is there, but I don't see the others),

> FWIW, "kvm-x86 fixes" is in -next (unless I've screwed up recently), it just gets
> routed in via "kvm-x86 next" via an octopus merge.

Ah, excellent - I was just checking for separate fixes branches.  It
would still be nice to have your fixes branch in -next directly so that
it can be included in pending-fixes (which merges only fixes branches),
that does get some specific coverage so we notice if there's any
dependencies on -next changes that wasn't noticed (it exists because
there were a few issues with that a while back).  It's very rare for it
to find anything but it doesn't hurt.

--wMof+NrnbH5Ys3bd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmj3cQMACgkQJNaLcl1U
h9A40gf/aaANZDnWqhhx+mSZBlw2rbf8bqMSmgRJ6VFS8ELP0KHboeZabgh045zd
j0xhy3XpKfrCHSwftbmkHp4w3Jrh/R5lRJPMVObbgiBSqyfipHXssSWkNnUXFknn
yUZEsQJM25WgRuz662AosWQHvS/OEvJt21is91pE6cT/OYueZj5hq0MW6NKMurte
7vNjMy66T1FAZtID/Szt+5eY4U4uhrhOKbuAGzfPWurUCp879BVeKx0rkQG9nYeK
p1B2vl94Bvh0HO//lh72KkFpTQn/n6FiZA2qRR+LDOC8+LvydYZadAYvKudbFfcX
GO0ZZdjwgu1wfE6vvHoQIRontp/hpw==
=coCr
-----END PGP SIGNATURE-----

--wMof+NrnbH5Ys3bd--

