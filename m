Return-Path: <kvm+bounces-24342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51B5D954008
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 05:26:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 837441C22222
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 03:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BABFB52F62;
	Fri, 16 Aug 2024 03:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V37zA4GU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF5B1877
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 03:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723778781; cv=none; b=iOC6IzrHzHevmBjNP4FCi76Z0ZpRPsUHCDNg3Rwx4bW+o37TySZRdChd3wdOIgV1ommyKI8oxzBYrBvOCvhza81Hozb2AA1p7r7dj1tMgVvSdxkccxxF/sUEf71mgKadEYIDeSVxg4KxePTrd/p31r5d/phtUH2ZDiaZMNi2rDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723778781; c=relaxed/simple;
	bh=8fr5/mxtcsucWSFzNTVu49YAMh2goZ04rIV+0Q8FgKs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bkXv1T8IlU1k1M581dH9uXJBmkx5Kur9BPEoJRkVZvF2FYy2xtexTZdN5VTa96ieKK+oyj030UUKa+TLuh/XuSPQy3wTC3+kwiSyJzrCrI52GiFbNQ8jr03CFABka4NfA7XoVVIsFL2TxuqQwD8K89naAl4KzK1T+F8TFphRCsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V37zA4GU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42585C4AF0D
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 03:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723778781;
	bh=8fr5/mxtcsucWSFzNTVu49YAMh2goZ04rIV+0Q8FgKs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=V37zA4GUpLlehhdwgYastkPg+u/KjDuK1/KnbSqxluZeXOZQyzMyz1VDR7Lfjedte
	 vg2iqPZ4yrvoR/NQGCHuIJf1r6/KcYXbyFC/r68jq7T/p5ot26Bx8rEKaksz1eI2Zq
	 4YvIMWe5OqRnE4cRX3CnRP2y/YnDlk7t4ILoI08cCTzUZns1cZSk7mNoeRmSkGm7qD
	 x5QQmqwhChr8sDQCOZcUhMtw7LtZC8Hnr20PoZsqbrW4yxenZG1pMXZl0A/wxuKCiz
	 NyfEfDo/995C3p2BXhUzYZjoZ10BMBwQ36V0UPM2CmezVGuNjtrvMTPGnUT6UW3I5x
	 SHGCefkCh7AEw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 36635C53BB7; Fri, 16 Aug 2024 03:26:21 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219161] VM with virtio-net doesn't receive large UDP packets
 (e.g 65507 bytes) from host
Date: Fri, 16 Aug 2024 03:26:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: wquan@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219161-28872-tzS4KRL3Vk@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219161-28872@https.bugzilla.kernel.org/>
References: <bug-219161-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219161

--- Comment #2 from wenli quan (wquan@redhat.com) ---
(In reply to Sean Christopherson from comment #1)
> On Thu, Aug 15, 2024, bugzilla-daemon@kernel.org wrote:
> > Large UDP packets (e.g 65507 bytes) are not received in VM using virtio=
-net
> > when sent from host to VM, while smaller packets are received successfu=
lly.=20
> >=20
> > The issue occurs with or without vhost enabled, and can be reproduce wi=
th
> > 6.5.0-rc5+
>=20
> Is this 100% reproducible?  And did it first show up in 6.5-rc5, i.e. does
> everything work as expected in 6.5-rc4?  If so, bisecting will likely get
> you a
> fast root cause and fix, unless someone happens to know a likely suspect.

Yes, it's 100% reproducible. I also tried with a very old version alongside
6.5-rc5, and the issue still occurs. Unfortunately, I'm not sure which vers=
ion
could be good, so I haven't started bisecting yet.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

