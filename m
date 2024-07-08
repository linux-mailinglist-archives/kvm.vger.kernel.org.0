Return-Path: <kvm+bounces-21135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 588BB92AB86
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 23:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89CC51C2194F
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 21:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 398EA14F9D2;
	Mon,  8 Jul 2024 21:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HvvDV+F2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBA314EC43
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 21:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720475774; cv=none; b=iGy4sc31zONjosLTimKgcoaYFtum3hiFFA4aoHMPRDpeGshrFm0UrW4k3aq6B7KRY9KPc0VuZbaGi3y9Ur/AWGhqHJ+fY74kycPKAjUASGmr1rjwaNNkq4YSQ8wUilG8fefYbO2C0P+41LoeWEFHRgsJe5fFftkSvvbrH3O4PlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720475774; c=relaxed/simple;
	bh=cNZwSY2b9UehE5ooaiUfLy7z9PVNqnUbA5uCt1sl53Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P1Pu0jZwNo96FpHLQPzABfPIoRVxqLM3e+y+58+4g7QmppOcW60M70DucIkwRw3FTSsWCqaHwkBod9Ikk1wffsMyf0r1Y3hPrpJqVWVY6aw+70MsunLCHn82bNC0l7dfSbcOm8Ar9/wpbH61JwfRvZnCAC2chavFMaQVxnyIbDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HvvDV+F2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED117C4AF0D
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 21:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720475774;
	bh=cNZwSY2b9UehE5ooaiUfLy7z9PVNqnUbA5uCt1sl53Q=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HvvDV+F2OXoOGZd6WZkjpfKivxsbXAczmdXmf9ijj3Y5ge3g+Q96LhwcgpWgy1FY2
	 dom41u065jbACeHgzlvjUmQFMJSlm+XljvnCEfVjFnDOllukpnboFV1aZVUU+m7+fm
	 NRLlbk9CiADqtd78NqORaOQquk/MjXHT2nIlrB1mHxTcN2MSvMVMlZ6yP3ptpK7NgC
	 MWzB8kU+1Rf8ziRkcoWXi9IfWE190IZo04nGioImaeOJ+82AdRnsqyobntaye691ID
	 t358vVAYtIkllqJEC53XCgz0ntbNTWXzIlXV86uyGhGL9+ZR0FG04XTBSEPjcD0+B9
	 MFxdTTfC6R4Rw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E303AC53BB9; Mon,  8 Jul 2024 21:56:13 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218980] [VM boot] Guest Kernel hit BUG: kernel NULL pointer
 dereference, address: 0000000000000010 and WARNING: CPU: 0 PID: 218 at
 arch/x86/kernel/fpu/core.c:57 x86_task_fpu+0x17/0x20
Date: Mon, 08 Jul 2024 21:56:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218980-28872-5hRdopLeUh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218980-28872@https.bugzilla.kernel.org/>
References: <bug-218980-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218980

--- Comment #7 from Luis Chamberlain (mcgrof@kernel.org) ---
On Sun, Jun 30, 2024 at 03:47:57PM -0700, Luis Chamberlain wrote:
> On Sun, Jun 30, 2024 at 03:21:10PM -0700, Luis Chamberlain wrote:
> >   [   16.785424]  ? fpstate_free+0x5/0x30
>=20
> Bisecting leads so far to next-20240619 as good and next-20240624 as bad.

Either way, this is now fixed on next-20240703.

  Luis

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

