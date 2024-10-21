Return-Path: <kvm+bounces-29267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 603F39A606F
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 11:43:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21BE1282529
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 09:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC4F1E377E;
	Mon, 21 Oct 2024 09:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gnq9j7he"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9A81E3777
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 09:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729503812; cv=none; b=Lz7vmosV1zSYGyDZnWJ66kUP0nBjABhbZHJCWfMDVEZxXKQ2Y76RAtq+dRzbv21tBnddV79Xwfh0Dr+fe01MMlzFXzmGg78CpbO2z9NvU/vJfMfYaBcCCC/NQMaLyxbrM0CidSHsHJq1TgSKotgU9QUiuI2ugfylXtwiX3o09/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729503812; c=relaxed/simple;
	bh=KAQf4Bh98g93kbolkanvwypP/LQJtuNAQYpyL8yefbI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nboNe01q0ld4oIT+0Xu4vQNZGUbYDWeNBxJMPksNNSkCtDXMPiK0n6ZtZXlmYGsamcIqyHVv3vC4F7Buu5GEa5KFFdKiBciOFkej9Awxytd5IC742ISWTjaNuqZbmjPNyyJ6m0EtHHN4EIesYvJqtlMi/kbIvXdqdIK9YxD4ENs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gnq9j7he; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D585C4CEE9
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 09:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729503812;
	bh=KAQf4Bh98g93kbolkanvwypP/LQJtuNAQYpyL8yefbI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gnq9j7hedSY4+wK3xoKTDHPK2Jg11aC0amP8G8QZRDgcwz3jcMV49FwrY4KL1U5Mh
	 TL8KgcYytSVjb7fpRneB/3bf5m80PRUi0xCWQw5dmve7eXgStgsgwsF3nP3Fh3rHzU
	 IJgder9mkB+FpDhEABGYmnQL4wEwwrTFTLO146tZB+wc56mvEe+sPVjNbTyXkgLnww
	 k/bb8JRQaAvKjztoFgDwE/RMfmZ1djbkFyuR4a1VZPmOBn/vAMnqBrw2nNCE611iTP
	 9tzM9DKD9c3Ls4OhOHG/sWB/sqSIuTdM1jNo6bcWFGz1M7waaCPnTSAsjY+9Xbnaa/
	 73jyDGpodZzGA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 82A09C53BC8; Mon, 21 Oct 2024 09:43:32 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Mon, 21 Oct 2024 09:43:31 +0000
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
Message-ID: <bug-219009-28872-keAiCEkZod@https.bugzilla.kernel.org/>
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

--- Comment #36 from h4ck3r (michal.litwinczuk@op.pl) ---
WSL and hyperv should still work with vls disabled on host cpu type. It will
run much slower thou.

Since there is memory leak on am5 igpus they might contribute to reboots.
That said i have igpu enabled in bios (not connected nor used) and never saw
reboot with vls disabled.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

