Return-Path: <kvm+bounces-38826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07EE0A3EA7B
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 03:02:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E8B2169688
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 02:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B571CF7AF;
	Fri, 21 Feb 2025 02:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNmxHqFR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3FC2AF10
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 02:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740103238; cv=none; b=rwjkKNZUTsC5x5EiLyDJmNHVK5Dd62b0/wqXYnurEjTvZWFUwhtVjaUZu2fAlS2zo2nHTy466P344OZaR4JNZmttynYoj+K8DGjJUlhJNjOlffquF75OCrckMh9XhbDr8y7LyNTpHJcDU7Vd2dlfCm+mg3x/bY8AwyXG8/TEjR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740103238; c=relaxed/simple;
	bh=ErHMBYL9tFv2x3jaYCPsDte7VpnywTygAWkF7qCjud0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eDET8NbbI/jG87C3bcNbRogNZQFaWm3xqWVMH5G55KHSEHwU89/+NZBB+lmX4F4gAtTGBKYb1cbEQWB1/IIOtE1EPx8cFmdvWpIcA6gUbCbbWhG+BkovdEml9PPLsvAIXW+XM6pcx3lHEV8JlK3k93Xe4whzVqJzXGy6QKKlgzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNmxHqFR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD40BC4CED1
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 02:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740103237;
	bh=ErHMBYL9tFv2x3jaYCPsDte7VpnywTygAWkF7qCjud0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=mNmxHqFRn5xilkwggJ/rMi98EMJO93O+fr1eTUDSzAFjjCz8MpW8apC9iT6JWGREC
	 F/sgj31EWd4XF0MgzKw3AhyhXyo1cfkIQcpMUS/n0L2wnEFdYqQLTI83l2z7FVTiEx
	 jCOB9QWaJ8O79uM2eAnhS+NToJQ4cnQWb656k6har6byOADRIDOUBiPSxJIwz1cwb1
	 9iFAXfcEPTs2++0y1x2GjyJXHOUrYQGK4sAikq0wo227yws5OolRP213GctMuWyxyh
	 LkJNqQlotGXkRDg85YDDoL5+QphtP+s2GeVzz5ECiNgkwCndJZBvxywPC4i0+ZiOWw
	 GjIz70BDRVndw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D4D90C41614; Fri, 21 Feb 2025 02:00:37 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Fri, 21 Feb 2025 02:00:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: chaefeli@angband.ch
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219009-28872-ZlM2EY4ltk@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219009-28872@https.bugzilla.kernel.org/>
References: <bug-219009-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219009

Christian Haefeli (chaefeli@angband.ch) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |chaefeli@angband.ch

--- Comment #45 from Christian Haefeli (chaefeli@angband.ch) ---
(In reply to Mario Limonciello (AMD) from comment #38)
> Thanks everyone for your feedback and testing.
>=20
> The following change will go into 6.12 and back to the stable kernels to =
fix
> this issue.  It is essentially doing the same effect that kvm_amd.vls=3D0=
 did.
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=3Dx=
86/
> urgent&id=3Da5ca1dc46a6b610dd4627d8b633d6c84f9724ef0

Hello
I would prefer the more flexible solution via kvm_amd module parameter.
I am not having this issue with an Epyc 4244p but am now losing performance
due to this hard coded workaround. Does my CPU also qualify as a 'Zen4 Clie=
nt
SoC?=20


Regards
Christian

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

