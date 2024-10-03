Return-Path: <kvm+bounces-27851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25BFC98F211
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 17:05:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 861F52832F0
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 15:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 733FD1A00F4;
	Thu,  3 Oct 2024 15:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ALHb59g1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E32F823C3
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 15:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727967909; cv=none; b=KXl6cZwa3TA1Gr30vyINhKJPSbJEXCXfEnNx89FGdkQp6UmzeQYy2Wfx01QLPGx4un8y/sXGiWpmvCv+QXmu52k68UT6IrzIlEcKCJn3lHN3urPChrUdiop8AhXJWaPN6LH7KGG4Ct2V49FkuIZKJBZT2Qx6EvVVvSLb2Nv0Jk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727967909; c=relaxed/simple;
	bh=rQAaQjQ2fmeAuzKTdbLKPvZDI5kebVsyVVGosvSNoo4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qTZj/5s+WaOKhADXeMqQI8cPIRNjETR7TgiN3VtybnevUJMMqG76vhQMrS/EZPM+eqv3kobpGsIsgCZ2pV2KHiEdzOLJNf+GIMOJqin85+2NeEPRDAke1V65vJybpAESDd2PPYeTLTfZREVlpb7ftUGFOmMc4Djhtp1dIrxpmpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ALHb59g1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 342C9C4CEC7
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 15:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727967909;
	bh=rQAaQjQ2fmeAuzKTdbLKPvZDI5kebVsyVVGosvSNoo4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ALHb59g15pZBWYXNvW+kcxyv/DabcSmSqpQsDF8ANCErdeCQ1No0vnimibIT3OBOt
	 3akJKb/9tK0WM3z6gnqMBufW/9nenTHTnRv3qG6XBLuRvVzsxbnY9RtMWzjj/ThO3V
	 +Q2A+6cMtmowWj3EhGZYlTJy0f8OzAAW9YG2uhjdsQwrfUGh/6cLp/r+iw5y4LBFNg
	 KQKgxNMZ6mX06IoWWuI11KjB5gMceuZfy0yPFVtgjTiTeOJrvkm7MokbRngVY3gGUg
	 qCsFswiDdlXHb9bq/ptIyORKzHBv6LOMlAtCkDROarXXNqOjCBea+cdlKBGrI3O7kX
	 zXvvpRkyNKYPg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 2B7FBC53BC7; Thu,  3 Oct 2024 15:05:09 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Thu, 03 Oct 2024 15:05:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-NZcjB9whG8@https.bugzilla.kernel.org/>
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

--- Comment #22 from mlevitsk@redhat.com ---
I mean avic=3D0

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

