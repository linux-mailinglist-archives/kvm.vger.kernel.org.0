Return-Path: <kvm+bounces-46021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1857AB0B47
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:11:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42A757BAF3C
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 07:09:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CBB426FD91;
	Fri,  9 May 2025 07:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BM4szcjD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6358526D4C4
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 07:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746774655; cv=none; b=jQz6ocuFftJF4bmSzLQUoaLvSOQ+Z0i51K80FnQ/6Jhqd65RODcNHGGj70QWIeWbagsqkuXRy0jw2UZSokZNOpsJWjB1AUeSpdelkx57se6q0mq7NTO266RX6tbG30B+yTaF3xVjR9nafi+QkP21VOKWsx4FAJ07argnJFpUaMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746774655; c=relaxed/simple;
	bh=jGN2fhvXBfGqeRvDlhq2Be/P1nICsEFj6dqQKUeMk2Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mNN0+Zt4O4wPah/W5EMcXH3d++sHLFc4J/RANY1QIZD7+kGMfSWQ/CDRutTkoziCgILU4IFNjGNMmRLsDJFbbhYXXICYuYNz4R4v/A0KdrFqXgZwqU736TBMUz7gLNF7mDjeD7rWT5PDoBmpif3RJvrBsh242zSAFQX/fJRpsxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BM4szcjD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFD89C4CEF9
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 07:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746774654;
	bh=jGN2fhvXBfGqeRvDlhq2Be/P1nICsEFj6dqQKUeMk2Q=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BM4szcjDHMa47mAAsCqjYZH5xFkFetCN6KW+4a1NzJRA1F3cLun677iTCrEmtSEW0
	 1ZOLbEplN8ijRVpsxAPYBjmOBZWnG+Eh/zhO06lMVIZiNlNTIZmtYiCJ8FAM9D55sK
	 pMNqITFrpzeb1pPzKyJj+sFzwLbAalf4y1TdiPY/MwuNXsrI26xPNZRO7qaPYomeXC
	 TRDopGFQL5cKZgIVNWmA0LyQlmGil7dClxUyRNBIGPv7ad3fyRu7X6tsPdHBxHBy6c
	 +Y2pUeoZfK4RYebkgmcQVPDAPusuSI9erwzu9YTsTVDu91MPjxKHjbLxzx8rKvHKmi
	 iMxZSUSl6nXFw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C9CE7C41616; Fri,  9 May 2025 07:10:54 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date: Fri, 09 May 2025 07:10:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: justincase@yopmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-199727-28872-Mxxs72PqUd@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

Yill Din (justincase@yopmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |justincase@yopmail.com

--- Comment #28 from Yill Din (justincase@yopmail.com) ---
Issue is still present in 2025 with io_uring, kernel version needs to be bu=
mped
to  6.x

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

