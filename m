Return-Path: <kvm+bounces-67655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E9E24D0DB47
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 20:20:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D7B93301DE23
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 19:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7ABC279DAE;
	Sat, 10 Jan 2026 19:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lm3r+a/r"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5E242050
	for <kvm@vger.kernel.org>; Sat, 10 Jan 2026 19:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768072813; cv=none; b=gsZQywM2eO3zRcPdFmWdIz2mBYwaXzKuuuZrsp89q18aScqYRh0oW4MgiMS+7fN7mz0bFTALrPtrF/gxQZjttObcxyv6vljXib3gxc8pQ1ZMRXaL5gK2YoxV0V/bU3jdeBDVd19TK79fkGMypAUAbm007ShBla6Bawt4xpKHDY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768072813; c=relaxed/simple;
	bh=BghVDzRm9L3OSgvc6xNDqhK7BZmK5RSYHiAWpXmqvBM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uuK89U1+X/Td8DVoQ5FIQR3yiM/EUZ0up4fGB9b5LdJ9BjyofcjYP3s6mjNqXOAYHv2sIgP4/BYpVdFDRH2jurzXey5kkxQOyj4MRU/VQ4PQkbZjzTRR4bFpIP2dwOgCIHI9jNeChRB/8+FVVCvPucK+1OVx+kbo0w/w/VeOhak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lm3r+a/r; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73F24C16AAE
	for <kvm@vger.kernel.org>; Sat, 10 Jan 2026 19:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768072812;
	bh=BghVDzRm9L3OSgvc6xNDqhK7BZmK5RSYHiAWpXmqvBM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=lm3r+a/rpWoKqjx46omgiDcehdUdrRMExT8CVV7cwxMjVeQb52y8CSDG/uETSkSnA
	 XaA3hnNR1kCUKNKZPlFN1AUDuKUOGcvOUFc1oTvfvyRGmPIH8QsezbqWogyVwLBQsa
	 sGOOAaj42e2UO2kz3lwN69jQ5zavknvgeSKINXEVhoDSURFRxbEI6MFBjvvsngM3n0
	 1gpzJEbLaHp8R35P6bDBlc2Ql6xjg2NspO5hOBNUA4zlsQleW3N+zExFUi7L5lqnfV
	 upa8AF325Jdb4RtnIK85sG4ea+3Ji+i7/r+V5JPQoOCLpzbJWBWiqQAFHjhSnZzcMn
	 99s4NYOJF5AoA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6A15FC53BC5; Sat, 10 Jan 2026 19:20:12 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 204175] nVMX: incorrect segment base calculation in VMX
Date: Sat, 10 Jan 2026 19:20:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: max@m00nbsd.net
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution short_desc
Message-ID: <bug-204175-28872-o4HxAT2oD8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204175-28872@https.bugzilla.kernel.org/>
References: <bug-204175-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D204175

Maxime Villard (max@m00nbsd.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX
            Summary|Segmentation: incorrect     |nVMX: incorrect segment
                   |base calculation in VMX     |base calculation in VMX

--- Comment #1 from Maxime Villard (max@m00nbsd.net) ---
This commit fixed the bug: 6694e48012826351036fd10fc506ca880023e25f.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

