Return-Path: <kvm+bounces-44822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E538AA1BD4
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 22:09:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04B2346786A
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 20:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60406262FCE;
	Tue, 29 Apr 2025 20:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="adbels28"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AB325A2DE
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 20:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745957384; cv=none; b=PTBtK61hU53XYfvUvaLLEDRIF601Hjey12S1MXrsF6BuBaOqtwPf0o7wCKlb4vn7I9vCHV17QzedM+J4bYD2/odt6ZXu36Yjf6Wp/9SL1fmh6EpHpZJ/o7XFsLpv7K6vTzzJTs0kN7/NvY5wOzA3SbLPvCrIVCWy6sqDgth7+kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745957384; c=relaxed/simple;
	bh=3n/PtDgB2onBSES0qoj+Ua+aF20RbqTidAeZF8RngAY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=meU/12IWDwLHO1WDbSNEOIzycysrvy8jJGYe4m83fn9AW6aJ64A5/f9rw9euSY1SYGkSpKO4TlEBStfTseRihiu6v+biU26kJRljeA6e2trUicjg6sS1wTxcG54RbyG5yUV+x5wmpL2yMl7YTvoqC/7M2w5V4h5BsBukzA4JwaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=adbels28; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05E4FC4CEEA
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 20:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745957384;
	bh=3n/PtDgB2onBSES0qoj+Ua+aF20RbqTidAeZF8RngAY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=adbels28N7UdklG5sNL1wlaZTqAjv/n3yXqTRx+X2kFzjbZ9tToysM+L1vW+L9C87
	 HdZHVaEgkbqdt3NYrjTO7yookP09fTw23/kWv9gbfpJPqPw8t1tQD1Xvwlv7cYxYsT
	 hZL+sc53KGLDGqrUnwzmCxqIy5j1Xyj9jjO4ej62WRuVkC+sfvB9EMGYVAo0aDbYtf
	 aXydyr2kYqYqrTwfXsW+YPTFgYUwGsk3TmZla1pV36MbHbehzxOJw94ZXLP3g97faj
	 4zQMcE89wk2RXV/dQE90/QKK7PUuYIIwBPa97go87/tRUrzwdWzQey3NQv+a1Ro+6S
	 Vu+rEPKnbqTkg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id F3E48C53BC5; Tue, 29 Apr 2025 20:09:43 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Tue, 29 Apr 2025 20:09:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: alex.williamson@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220057-28872-HY932JhpcZ@https.bugzilla.kernel.org/>
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

--- Comment #34 from Alex Williamson (alex.williamson@redhat.com) ---
Please run the following in the host before starting the guest and attach t=
he
resulting host dmesg logs after running the guest:

# echo "func vfio_pci_mmap_huge_fault +p" > /proc/dynamic_debug/control

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

