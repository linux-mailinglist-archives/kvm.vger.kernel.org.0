Return-Path: <kvm+bounces-44598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C338A9F9C9
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 21:41:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2130460C75
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 19:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B30FD2973D1;
	Mon, 28 Apr 2025 19:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DOGTcAsZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB33142AA6
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 19:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745869292; cv=none; b=GK+B03ztM0SDowhUmN28AV2RgYifC3HKVnUed+kLPuxQahXcTdSeClbULzCGxfU/yc367AzgVIixPF/dBOLPSNAqNTH3vF5pRknzXR5IHSBKfntOB6m9j4au0uth+nAc9fzrJryOcP9MQTxaTq4W75IfaJO9TefhUqR6+Wv2Pwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745869292; c=relaxed/simple;
	bh=dR9X1Esou3p9M/yBMN2zTiH/q2Ay1yX+2u/fSbflQdY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=joMyTl7hs3BcuT7NNRQCEVDtxPgHyZLFJ4Zg4g2x236ZGjf8H9VgJMCdx6IAZfSDWkWcX/78gHF96r4nDOqRvVK7fisWSVTtgmtu/D4dg5KmhIuyOwPQsBED6mT5pTEDUYpjunY2g+QvzeBRR2+mWKTNyY6ROSZcz3SBQvPrUYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DOGTcAsZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57838C4CEEF
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 19:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745869292;
	bh=dR9X1Esou3p9M/yBMN2zTiH/q2Ay1yX+2u/fSbflQdY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=DOGTcAsZ2wk2LW1QJt6dCVhvdtk8EY4wwuqGdQkZVf8/xlcvISr3srj4rZJyOdmWn
	 u7sxjLcaruDjfvBWSiEs85krdj4sESdr+JNlDDfviMt7H3y3lAHi9hM1+UVzAT+JjB
	 oHdMsfT8EcJ1xV7ahIP1VZ0zrIkwLrDdGD4zDPDaX6lOMfsgAuK6ozBhU9kMdj13wT
	 cjXWrBSyMGBYl8E+nYutBPLVMFREJ0Zp1vnzY+Tlg176uV76tuIHsRsVIKxs9zZBq9
	 iB3d6wdbXBJYNB2XQqo+vdd2Gf+XIDUmlJUNH+MiOI+oSESd4fm/Owf1tlGHpJu4Jg
	 a0SprAX7bf+GQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 4E6A9C53BC5; Mon, 28 Apr 2025 19:41:32 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 19:41:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: adolfotregosa@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220057-28872-SRsGLNENGl@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220057-28872@https.bugzilla.kernel.org/>
References: <bug-220057-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220057

--- Comment #7 from Adolfo (adolfotregosa@gmail.com) ---
(In reply to Alex Williamson from comment #6)
> What's the VM configuration? The GPU assigned?  The host CPU?  The QEMU
> version?  Is the guest using novueau or the nvidia driver?  Please link t=
he
> other report of this issue.

13900 ,z790 chipset, 128GB ram.
Guest set to Q35. Cpu set to host. qemu 9.2. Guest is using nvidia driver.
Crash happen on both a 4060ti and 5060ti.

Other report but with AMD 9070 XT.

https://forum.proxmox.com/threads/opt-in-linux-6-14-kernel-for-proxmox-ve-8=
-available-on-test-no-subscription.164497/page-5#post-763760

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

