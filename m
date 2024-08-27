Return-Path: <kvm+bounces-25155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D354960E07
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 16:44:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FEC91C23299
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 14:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FD201C68A1;
	Tue, 27 Aug 2024 14:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5VwfK61"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F611C4EE2
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 14:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769847; cv=none; b=nsNieMJdpxm86nCq5zDOsSPOdgQEbZBl2WoUSJcrR8Qf78aQZt0MojSokxf4mgZ6T/6dPp/q3K/ogdiezYS34BoD9Rmm5iMPsCZNTcc6z7blBrxHqmY/3p6QavbXN09051Kkftzh84aH18D987ElTxdyxjadVcAjLz87BXE4g64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769847; c=relaxed/simple;
	bh=WDySIKdcWtEKb27c2xosLRw5SsAsml7tt8gJLVDhfDg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FGcVEDkPStmUlaFWpUH8DZ/HS+qXKVmebbOz80Dq9VBvBA6yHJA9g7Sq3UpKpMjpS3mHktqDXabhcYuhv/BeWeaQofbfR9rN3yFE12FPYPSdrmQMF8w8lZi9MpIqJxz1AXX4FzfjJg5iMSsGDV5KjLMdpHQzC8r0dBKckU4os40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q5VwfK61; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C6ABC6106D
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 14:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724769847;
	bh=WDySIKdcWtEKb27c2xosLRw5SsAsml7tt8gJLVDhfDg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Q5VwfK616sP7dR2p/PNnjkvLHGyk5Td9fCubD9mcwaIPMSsHqXPmTfibQs6yoOWMB
	 02rRxkOglU/eN+l2SKwu8Gph5zGmpyGC2M4f3GyIv/qNcGZ/wFaOCD5+tT0cgUVWrU
	 pdTvOLa/z0Zu4Sy/brWxIKlrntLnCy+NuBKfP07QFhOrKiEG22oSd9jcIzcelswXTm
	 Va/WyvOAE8tw9ps11Mf+aJi4gkOf37HcCKwN3WZHLKbf4/0ZpG9bMfVLKFTeTXk6SD
	 pyIV0o5dE4B0zBsjFjNxDbSbMY8jy/CAkr9kYBKKf0VULiOno6Ja9zfq0iK00FM2W/
	 RjcYUkkW2XVAw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7640BC53B73; Tue, 27 Aug 2024 14:44:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219129] virtio net performance degradation between Windows and
 Linux guest in kernel 6.10.3
Date: Tue, 27 Aug 2024 14:44:06 +0000
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
Message-ID: <bug-219129-28872-LjYyTap7bp@https.bugzilla.kernel.org/>
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

--- Comment #12 from Christian Heusel (christian@heusel.eu) ---
Fix is queued up for 6.1 now aswell, thanks @carnil!

https://lore.kernel.org/all/2024082741-crease-mug-f658@gregkh

https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tre=
e/queue-6.1/net-drop-bad-gso-csum_start-and-offset-in-virtio_net_hdr.patch

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

