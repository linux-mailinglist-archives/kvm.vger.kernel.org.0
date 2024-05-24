Return-Path: <kvm+bounces-18116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A8E8CE4C7
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 13:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB9B3282422
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 11:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C0085C7F;
	Fri, 24 May 2024 11:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eSttfw1t"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A089B53E31
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 11:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716549548; cv=none; b=fqBU4D9FO3P1mN7t08Zceoe6IYO6HoNSqQ6ecpDx1vYxGZtJ/9+/dYz+471vQrfB0VOwypCYFraMHOyMZFUIk+I98kfeN8gVxS/lUVKuVu7ayVp0HeSX79j/i7yCk0xbKV1ru2b3TA6Jb7M3S1oYd9P11jPJBGBpRScsZwPlWds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716549548; c=relaxed/simple;
	bh=tWk1AQB+y1gAlzjQUzsiYveRhfvUVBrc+giJZoBybR4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ykuk8wLDq18RsODaYnV6Ll10Ojp5NalHLfAlJVStWYQqTUjYGXtNF5waX3zdoBStck4MtKqBDjH0LxdhJkP4OlYWC0H8VulhVxhOTYwBTMm9u1/cBpqSoJgR/4VigAmcxQqr4TalPzKUvLm4tvBzLS2dg8PK8nqmEYhijB1kx5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eSttfw1t; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 728BDC32786
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 11:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716549548;
	bh=tWk1AQB+y1gAlzjQUzsiYveRhfvUVBrc+giJZoBybR4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=eSttfw1tXRUF7zzMX4RK+ryVfC+prGXDYfletWKGE8iewuT1PtqXfubsG1OILE0ta
	 5qhMQwpH4/rqePTeG/KP/fmcM90bMB8dWF5YwjledlDFyk93l2n+PWFTwboLuh0ni/
	 Wzr6tpznWaDgGffHeSK1fAj+CU4diBu7omuIA3i2keD67WruGJUrMgm7BLwJFsr+x7
	 siGpMduAHmHASE2XUOPhTXBsnhiIpAXW6ZOjZpMcPe/KpqhfaS8u1u2lWfbke63AZO
	 mREhdzjrPuz+Fn2XqZAFTfsQrHT1PrcuOSDomwra0dns2WNAyeRQgwaaI1tkelKo+A
	 6FLcQdnJMn66A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5C4E0C53BB8; Fri, 24 May 2024 11:19:08 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218876] PCIE device crash when trying to pass through USB PCIe
 Card to virtual machine
Date: Fri, 24 May 2024 11:19:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dan@danalderman.co.uk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218876-28872-QVXjATP9nq@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218876-28872@https.bugzilla.kernel.org/>
References: <bug-218876-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218876

--- Comment #5 from Dan Alderman (dan@danalderman.co.uk) ---
In case it's useful, I have tried with pcie_aspm=3Doff but it didn't seem t=
o fix
it, same behaviour.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

