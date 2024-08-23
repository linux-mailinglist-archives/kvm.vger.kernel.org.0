Return-Path: <kvm+bounces-24944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A5FA95D7F8
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 22:45:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE11C1C229D3
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 20:45:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6B2A1953B0;
	Fri, 23 Aug 2024 20:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bPt6EYzY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD60148FED
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 20:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724445920; cv=none; b=pvSTFfHgZBgFX9dpHF+H1qZaMZAWOon00yz1O7H2eexjopAm6GuiXGtORJkomqI/QMu676aVkbqxk/t2bZLLwPu5gCLBH2syoa1/dJ+rhnBO8Eiadl88aI+WYg1XwTGJFK4cxXb4pJET1MJy6O4UmGHJxAv9nG6s7Zq6jyiDnBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724445920; c=relaxed/simple;
	bh=oOCdyBfgfGFtCPXjPMVwNzHuMhKDryjaQhuTNQZWmFA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pgGKnzzt3a+Od4tZ16SdtBRNt6R5h2L+P3jXYe3pjjtNemwmA2Y2h3vVwBl/+JFwAs2rnkAAXlgEl/NGgm9wE7KHSIbMDkyiS4GzeO1TgGsw1GQSq1mQTM6V+4vDyqsrTpYDtljYYgldd5roHe9Zm5iNUyM4qpjmwaLRVIp/ZUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bPt6EYzY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97269C4AF11
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 20:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724445919;
	bh=oOCdyBfgfGFtCPXjPMVwNzHuMhKDryjaQhuTNQZWmFA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=bPt6EYzYGf3msqE2W0aHS5F13TwU+lF1cE6TMFSXLbg1AcH7ODBCAZcgH4WFf7DC5
	 6c4aLnlp8ldVGFFb29MWoQvv2LESdEuI+nxtIJ0HrAEw9gxFJuCsX+EiqpBNe9okCM
	 109/FKPTA7BwJx2U40ueNmsok3OmUJXUzmA1iy6vNAkJPvXsupLJqYNGpwgRAxHUWJ
	 xm9473XrO73cxz8Nk8Y4PczIpNMoBTnqiFgIlbCSgfkWP0uxOK5zzwKG+YWg5RnwBM
	 yubhK1q/R1p0aQb36c8UaSXKdp+ukYB3K4TT1zTmYilhcIbZi4v5S7C4wjbma3pGfg
	 cMJkEjbHxr/Fw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8FF20C53BA7; Fri, 23 Aug 2024 20:45:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Fri, 23 Aug 2024 20:45:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ozonehelix@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-YDlthjv2UI@https.bugzilla.kernel.org/>
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

--- Comment #4 from Ben Hirlston (ozonehelix@gmail.com) ---
(In reply to Ben Hirlston from comment #3)
> (In reply to Ben Hirlston from comment #2)
> > I can confirm on my Ryzen 9 7900X30 system disabling aspm helps. kind of
> > relieved this is a bug. I was having this issue on my Ryzen 7 5700G sys=
tem
> > but to a lessor extent and it got worse when I upgraded to Ryzen 7000
> series
>=20
> there is a typo I meant 7900X3D sorry about that

no I had to do kvm_amd.vls=3D0 the hit to performance wasn't as bad as I th=
ought
but disabling aspm didn't help I was wrong

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

