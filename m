Return-Path: <kvm+bounces-44799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F01DAA1056
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 17:22:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECA8A46049B
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43051221547;
	Tue, 29 Apr 2025 15:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fd5H6YwO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF5C220686
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 15:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745940153; cv=none; b=rPpQAhvu12fPhBIhhGwWQkJ5mSORQmFVP6LYDtYQspKCP3E5DSlpl4zXPh7IJjbvUQnk4ioTBd6FqnHOJuohycbgZMUTOAK5Nbxcx59dv44vFRndA9tyiNr1iTqrQU5yLk123efh2vI9E0ub015TYrxz/IWk2RI6EtTF1noIvJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745940153; c=relaxed/simple;
	bh=kSU9vYMQ/OvIXs36oIq4XTe5iMgR7MZ9iHcp8znLEWE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k4INQUYT+aUVNN6E1MC+AE0uaGts/1p0GSYVzzDESi5/Yx9zihd5idU+6/ClQWc3z7lVq/Jm/RecqpI64JRR8O7J7A+yB6e6s3+YYU4yv7/OT9qIAMA9854+W4K2VLvu3HovdfaQZqB5qDVRhPs94OpDjodJTB3NbhZXp4F+e4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fd5H6YwO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDEB1C4CEF1
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 15:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745940152;
	bh=kSU9vYMQ/OvIXs36oIq4XTe5iMgR7MZ9iHcp8znLEWE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Fd5H6YwOYLvKnN0vZGnccuVRCXUbJCV14SPqWKJoYemsmnWWk6VxFhzSIYPmdsBDC
	 oPwIz3NiF6FSOxwVSBobx+SnKGocH4IzSmD0VG03NAUY8CnfMFNWQugr7Bf9QTCGOz
	 SDNF22yFOTmKs1Y5Sj7ku+UoTEHsG2BOFLK9VxJ7LhAy66flWbAWB/NXVrfpJZB7S7
	 abnavvzQBDniemqaAQbUrVvBJGfh0bXFRfemEILWJYt2OI5Lljoiv/3bVNAVVFrE3h
	 8C1AZBJ3aZvbPoxa4No5+8motPSwENcnr/ysE1wuehwCGGL+WrDHUEzTj+YO+Ikqjn
	 alSM0Z27LijwQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B9B31C433E1; Tue, 29 Apr 2025 15:22:32 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Tue, 29 Apr 2025 15:22:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: alex.williamson@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220057-28872-FBbPPmmcRl@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220057-28872@https.bugzilla.kernel.org/>
References: <bug-220057-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D220057

--- Comment #30 from Alex Williamson (alex.williamson@redhat.com) ---
(In reply to Adolfo from comment #29)
> (In reply to Alex Williamson from comment #28)
> > Another option may be to set the cpu as "cpu: kvm64" which is the defau=
lt.=20
> > I noted somewhere this should present a 40-bit physical address space,
> which
> > might be close enough.
>=20
> If I recall correctly, cpu must be set to 'host' for nvidia gpu passthrou=
gh
> to work. That said, I would still prefer to keep the CPU set to 'host'.

kvm64 works just fine with NVIDIA GPU assignment to a Linux guest for me.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

