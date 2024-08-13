Return-Path: <kvm+bounces-24033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CC79950A0C
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 18:22:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDD9E28204F
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:22:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FD821A0B07;
	Tue, 13 Aug 2024 16:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LlokC4V1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5447F1A0709
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 16:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723566121; cv=none; b=Fm7G+E733WrFPKK1lXOxQvb6JsKsqkczNn5B0GezRh2xB5zHYaU5Qc8e5L7A8DaiK0tPd/5v6Zd/ROxX0jMPQuaOB0b2oZGyOXo3Lzhw3Edl+atTVGn4+AEQ/CdwPOlmBrg3a86Vz1JIJqY5SbsalIEnFsSwuMLK/jxH+ntDICI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723566121; c=relaxed/simple;
	bh=X/YaeVuUrU2WM+f/ZhDjmBGyPRA89Tc4vZ8CIKoygO4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ovG5uhWk0GyHLruk1AsDjrLR8T6WrPdGz5+Q+MjCTybmyBxmOcTUUMYYivOs4YwXGLPyxo2BFSzBB5R7jrcbe5yysJYRloaVgqO9h5jQuRRPxG3rLeCSAWGvNCI2qPyYfe+dOtQSE68ac0wolfG/1SYqdYrBrUCjNwG+AeD8yU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LlokC4V1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16F08C4AF16
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 16:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723566121;
	bh=X/YaeVuUrU2WM+f/ZhDjmBGyPRA89Tc4vZ8CIKoygO4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LlokC4V1I72WIoEFfC3e56l6avEosKIf9Iyzo26LBwEq9D+VUhlr3MBgqAgkNsQzE
	 uHMy0o9WYKRK0VevW3YW2VOYD+ExMDrI/JXZQPR6QuG339dKJiDe2UhMZVB0LCetML
	 S6DuweaAtzglK5AjKQhcWEyQ/kIfVNCoKOFZHLLw5xytxrkWOQ4sATnJXi7pkXjhVs
	 kEHjC6LxSPdcE5G9OkNc6H2bT8Kliut2RoaZVBRf+Xzl1L3C0plyCX58C2kg9JnCPe
	 UICcTy67CBUtqWs+HhU7mbWzDUEwyRtEgc42pJ0mHdbyr2lTLkEyv186QD7fizwXH3
	 YOclGQmU+1HFg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0E78AC53B73; Tue, 13 Aug 2024 16:22:01 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219129] virtio net performance degradation between Windows and
 Linux guest in kernel 6.10.3
Date: Tue, 13 Aug 2024 16:22:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: christian@heusel.eu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219129-28872-76MvxpEpOH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219129-28872@https.bugzilla.kernel.org/>
References: <bug-219129-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219129

--- Comment #5 from Christian Heusel (christian@heusel.eu) ---
Yes this is expected as the patch has not yet been included in the stable
series =F0=9F=98=85
I'll wait for a bit and poke the thread again.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

