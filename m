Return-Path: <kvm+bounces-25003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB59195E326
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 13:45:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D9B5B21340
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 11:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C2F14262C;
	Sun, 25 Aug 2024 11:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ABCqI3TS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CB31422D9
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 11:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724586306; cv=none; b=Z/uzDqJL9OhEdh3Dr9rMObv6bq7lL9iHlY3PaXhcTPfiaAAbeGhyT/srrM2bDdRqD3iA+kE0yyin/nC8Hh0Nj9vepPlEqd8lWx9X/ZuBEcYKml2LjTn2bVGtiuxU3xMa1Va/6IchAVnneakVrefQcRJbZwnMSdlx1KrMeN/zX0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724586306; c=relaxed/simple;
	bh=mcQo+jxqqY5DYu5Ugixjs4h3A7J+sGQReSN7C+4hhBU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y2FJupGBOKrOQk+8Jz2yM3ddiOBObawyZCsRLK3Jyi1Sr82/luFxVYBSkni6Yflx8UHybW3WwkenjthW5z3uIlPHXcHgfUcO2+po0xt1nMJAubyCk6PFOiImnJKjzr1PuygTVHYr7dtR05rhNMNhNr5FzBr0oj6g7x3b3xsgZEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ABCqI3TS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D97AC4AF13
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 11:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724586305;
	bh=mcQo+jxqqY5DYu5Ugixjs4h3A7J+sGQReSN7C+4hhBU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ABCqI3TS5POZ8ZnF0TB+hQFKSPUUSYtMxhRIO9SpWQNZbNHLT9M01yOmwfmJbcEJy
	 keQSyLmE7lnYN8X/48ejGc5vx5vmbcAL1/57gjy9KWQ3YvF7f96pGeFb5AnbnD6KgX
	 LrT11L/O4zQoIBY9NRskheCARix2zDkxV/fiUSiW0Ja8ATEwd9H0QfnjI9guXPlL3T
	 7NAr+h9Q68KuUX9JLjpJpaydJO0+Z2syL8gPSmr8pJfajcZuyWVlBLYPEEi34zTR2A
	 tOIHqG5w8qIJRZahRKeseUOalADPcYhZuAovGSSSb4FENPuHpKL5qkTb+7IIlKeI2t
	 yLt+/qSinHcAA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 80157C53B7E; Sun, 25 Aug 2024 11:45:05 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Sun, 25 Aug 2024 11:45:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: michal.litwinczuk@op.pl
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-Zy21PXbRsk@https.bugzilla.kernel.org/>
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

--- Comment #8 from h4ck3r (michal.litwinczuk@op.pl) ---
(In reply to Ben Hirlston from comment #6)
> do we know if Ryzen 9000 has this issue? I know I had this issue on Ryzen
> 5000 but to a lessor extent

Could you elaborate on what was happening with 5000?
(reboots, mce, something other)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

