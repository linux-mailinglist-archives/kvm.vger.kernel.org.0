Return-Path: <kvm+bounces-23170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD102946A32
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2024 16:59:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BDAA1F21686
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2024 14:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4136A1537D1;
	Sat,  3 Aug 2024 14:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DfuD9R4I"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1761537A4
	for <kvm@vger.kernel.org>; Sat,  3 Aug 2024 14:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722697178; cv=none; b=ITDatX95y1IxTmMDxwr1+7h19R7E71hPurAYLQ9vjcdrJbXvvXEljR4oVmWycfi+wvm7ZC/N8KgYZQOe1gwDyQYKCeV6U54oii9qZ6pzS4Yts1xWwVG8q0rRKUbTPQKv+Du62L+zG2bW4CkhYWs8ywZTlLJtGWcTjzxJ9krBTcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722697178; c=relaxed/simple;
	bh=oPZsENcS7tnkhlqvMOVLv2SZP91BKUAo7axDR5AVBhs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W/Vol5U0xOzpnsoB52f1sg/nw07Wa40KMOWDnPE/WPQmv8OkgulutwwLNmhrFrEfhJP0nv+m7bpdC/AtKe4MASJqo7/FvxNmRdk2EWxm9rW4WIESIsQkVLbtvoM440+khG8evIwE/IjH/025owAYZNSzL22BOzF2wsxQsUpO5+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DfuD9R4I; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B82AC4AF09
	for <kvm@vger.kernel.org>; Sat,  3 Aug 2024 14:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722697178;
	bh=oPZsENcS7tnkhlqvMOVLv2SZP91BKUAo7axDR5AVBhs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=DfuD9R4IOMqE9z19KcGWKNhimMv1p+s7vZjbMp/iQe6UjPXmP6hIQ+8/6jZ77sYRO
	 IGDyyHJRQ5zy473ED/pWX60lezXbIeCki7DD/usc42BPKsHCe3oyo9QymiKLirqin4
	 cckm71q74yVImYoPfq56jZx9cwxuwS0mOUPq5qxlAk4ZL6SMCUReVCtX8p2V/XxaYC
	 v0gvfhTO9cVXjetFj2GlBmcO5hJKvI/o1n1tpT6QFOpqn98ys40NF6+squh3ZvDnVI
	 Gbg07HDtMHSaKfTefzw7v0WRfj+ChFs6qDu9EEWcrLbpSruWUdIyNoxKNtzIu/4k+F
	 Kk1cSpfhE+J/A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3E231C53BB9; Sat,  3 Aug 2024 14:59:38 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Sat, 03 Aug 2024 14:59:37 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219009-28872-BUO8aWHuJL@https.bugzilla.kernel.org/>
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

h4ck3r (michal.litwinczuk@op.pl) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |michal.litwinczuk@op.pl

--- Comment #1 from h4ck3r (michal.litwinczuk@op.pl) ---
To all Zen4 users!!!

I'm now experimenting with different settings and found way to enable nested
virtualization with host cpu type and no performance penalty.

Disabling aspm in bios does fix it for win11 guest. (proxmox, hyperv enable=
d)
Further testing is required, so anyone having this issue can contribute by
testing other guest operating systems.

For now it's best solution until fix from AMD arrives.
Unless its irreparable with just microcode update...

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

