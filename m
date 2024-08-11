Return-Path: <kvm+bounces-23816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B68EE94E177
	for <lists+kvm@lfdr.de>; Sun, 11 Aug 2024 15:34:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F0518B20F1E
	for <lists+kvm@lfdr.de>; Sun, 11 Aug 2024 13:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A3CF1494B3;
	Sun, 11 Aug 2024 13:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z6c9NatI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6620E1494A4
	for <kvm@vger.kernel.org>; Sun, 11 Aug 2024 13:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723383251; cv=none; b=MeQ7ks9kAtt1G7Uy96gGkri2NvwwgyKTiJKxzY3lokNcD3cNWVkWQClm7gHp1jvigfUwRUy4bPE3rrLM7TwgBUbTg1AGFYQDTjwMLv8cDXf2a1wRe2M9zh8MTYzS13AXfVZi2nU/kDkb8IUIjttrCaObnUL60I1e0NKmwSD4wao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723383251; c=relaxed/simple;
	bh=j/uFFdk5Jf+zE90xwtATZ5qpjuQg6amSJTG4kIjJJR8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WZrNMHa7IdkRL00WXpoq7dAz+CopJ2QQaXZI0/46WUYXTK5bPtDEKpXDSTevYtUR0eCcgn9zd75UxexxJqg8wNEAPtriJ7i1AroSThtp6w0nNQ822+Zhe8dZyOZPP0amAu8BV0OyhpDbz37hMeBsaAt2e3v03mI9LrB0T6HdSDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z6c9NatI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37659C4AF12
	for <kvm@vger.kernel.org>; Sun, 11 Aug 2024 13:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723383251;
	bh=j/uFFdk5Jf+zE90xwtATZ5qpjuQg6amSJTG4kIjJJR8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Z6c9NatIlBUTcnqC7di1wUdm+wJzed5qm2+j1c1eyToyGC4JFIxrGqJZV64xboqof
	 MIWzDXGC5KCqeOcSwXKMabTfLHIQq5atSKzXaoTk9hhqnXu4Ja5Sez+RwRHFbxxM8A
	 OYbbOygIivvu3n2E6KofHN4ShUJNNa/sshA7dY0MWDvaLFbq5Gdm2ifObriPQQfM0J
	 6o5Gd7N6jodb4BIckSw3MdbdYtayBWHGr7xQsUcrx1UL/MiYuZItUQlDRCC+MNs/U/
	 7RG0CvE8jPUJAri5R0yYHRKA8YJSy9qKHvfSbmVMPAuzNwG7abG1/Eh24Hyg9lVpNd
	 yLDEdhfeGS5+A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 2F8BAC53BB9; Sun, 11 Aug 2024 13:34:11 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219129] virtio net performance degradation between Windows and
 Linux guest in kernel 6.10.3
Date: Sun, 11 Aug 2024 13:34:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernel@clark.bz
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219129-28872-Zyrhgoy492@https.bugzilla.kernel.org/>
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

--- Comment #2 from Thomas Clark (kernel@clark.bz) ---
Any idea when this fix will show up in a released kernel?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

