Return-Path: <kvm+bounces-24999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B0BF95E26F
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 09:29:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AE871C2092F
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 07:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F5C5B5D6;
	Sun, 25 Aug 2024 07:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sPEdMIlY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D222352F62
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 07:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724570971; cv=none; b=hXEg7RYzTuwnrugjFVGMCQHFge2D86vHZXhuOO5khQ9hNJMPhvuaQpluxHQnmjwy2kmenMMSZq142L7m0QP5IVkBO+inV+UHAnynjVq/64URpq8rEgC2eLmRN9JVH3wE6FHNLV4F+dMtg01QiAOwYU7W2EL0pX1FDU0tmZwvQ78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724570971; c=relaxed/simple;
	bh=S/+qsYk3Dv2lj5KouDjzQfz+Unvyq86oMrneEZCK0NY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PvT0iJwa4LK9eHP91l/O8lDvdG7hjCPMaUJJcTMNXrIFztiAyThj7GsxsQVtj0XK/oafnpekkKqCkbUA7F5WLaFcXCVIh2W+rG231Qq4V9kJWFkLCwzgruPqhnpJlZs0eVWmahRwpJqlM6tgez6smS74vsgHOmb4nlJuG+35WmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sPEdMIlY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D7DDC4AF19
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 07:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724570971;
	bh=S/+qsYk3Dv2lj5KouDjzQfz+Unvyq86oMrneEZCK0NY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=sPEdMIlYVPw5mJ+0hqiA9vG9D/m6AB5oAM6FoZgaASNUyPCtvEF3Lz1p9OGAMkiXf
	 +0sVVXkTEx75oAbBpp6TLMdgina/e7YZTGrQbZ7rdbNRuysp0wgIHu0qH7RLFDzBF5
	 4H4n8SEVC6aEulumeymKVE9SVz1xvdK6ajPbQJgrdElUlgbDnZPY0wVfKhjiPvhFvy
	 5Xji08mO/UPVQENWOGTFtse+kymyEThfGvUYAE6tPGDX6OvUInxueo2UTFfMfuyJVA
	 RA8Atqtu3HZ+0f5HanjSyytighzVgfHBnqIsXgSc4r+XYZWWKwI9hqmbBZxYW0Lp27
	 i/57P6nTM3vBw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 38F8FC53B7E; Sun, 25 Aug 2024 07:29:31 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date: Sun, 25 Aug 2024 07:29:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: info@binarus.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-199727-28872-nO6TtTksKI@https.bugzilla.kernel.org/>
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

Binarus (info@binarus.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |info@binarus.de

--- Comment #25 from Binarus (info@binarus.de) ---
I am by far not at a level that would allow me to really contribute somethi=
ng
useful to this discussion. However, we also suffer from this situation since
several years, and I hope I may ask a few questions:

First, as far as I have understood, the bug is in QEMU / KVM. Has it been f=
ixed
in the meantime? If yes, which QEMU and which Kernel / KVM version do we ne=
ed
to use to enjoy the fix?

Second, we are normally using device virtio-blk-pci. But in the comments ab=
ove,
everybody uses device virtio-scsi-pci. If we already have cache=3Dnone,
aio=3Dthreads and define and use iothread objects, do we still need to swit=
ch
from virtio-blk-pci to virtio-scsi-pci to circumvent the problem?

Thanks a lot in advance!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

