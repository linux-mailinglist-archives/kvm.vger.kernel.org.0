Return-Path: <kvm+bounces-24027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 43C4D95095B
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 17:46:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C13B6B26B7A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 15:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43CDE1A071F;
	Tue, 13 Aug 2024 15:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mDAtOi+u"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D28F49654
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 15:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723563961; cv=none; b=lX6uo1JuGo5A8tlb9gwC2k7CiXY1FML2eXD7RsFa/kC7ow6+8kS7RtpDge6mc4fH0NIaVVZTuU81TcXeHm+UmYMCeC0UUKJRrswsvVZTvYwHTSmMRkY7bfNjbHj3+FQzWFW1vgqSgLfeDA8D4bw9K4Y2Z4BX7paexvHwLnkwy9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723563961; c=relaxed/simple;
	bh=HcuWH6ZJ+x+CkbMHJznoY6Lf6yboNUiXtFY2KW46u+Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RPqBL4l871XJyOjSNVMgNud4EIGa5oN7hF14n6muBi6hMI8R4isQoV50mHPGVyR1d0IN3hiGrmq4ZRhcH4YaSlj+oL4KqlCj1b7rxORBXQ/x68tDXQNmpH/RAbXYAL30evorlEJ1EHn9HLCLv15fq2WDGRcHsWedzgOuOs+SP+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mDAtOi+u; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D1BFC4AF16
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 15:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723563961;
	bh=HcuWH6ZJ+x+CkbMHJznoY6Lf6yboNUiXtFY2KW46u+Q=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=mDAtOi+udZxgSwAHEBnd+m8l6Gb57u/ZrC7LnCGykFa6VQpAP/twCr5hFRyjDOP07
	 seN4wqz8ICyoN+gMp96SjAMT+SSL5dZ0aw+TyfgbEhvF/5T2BbaY50jnGVXASdXTfZ
	 S30PA/qCv7g6Awh2kszYCGRTDKql15rEk/Z1K62jcbRSh3MhftgahEbku2TQNr+uv0
	 W8pZZv7Xp4mTRO0dQoWf7BLobZf6nWxCbC6zlj95ppjlT+qAJfhhrzGYCp+Cwdi5JJ
	 YT1zzdwXKPkul35fW6v3RohQQ/vKe7z2N3SFi7TnK3pwTl+SrBxR3F+JbF6B1A67xt
	 Pu397DHUJy6LQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 44990C433E5; Tue, 13 Aug 2024 15:46:01 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219129] virtio net performance degradation between Windows and
 Linux guest in kernel 6.10.3
Date: Tue, 13 Aug 2024 15:46:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: alexucu@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219129-28872-qOpIPNXq95@https.bugzilla.kernel.org/>
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

--- Comment #4 from alexucu@gmail.com ---
This doesn't seem to be fixed in 6.10.4 just yet, at least on Arch's default
kernel variant.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

