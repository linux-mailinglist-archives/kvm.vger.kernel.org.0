Return-Path: <kvm+bounces-21610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7B91930C62
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 03:40:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7768D1F21462
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 01:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 910814C7C;
	Mon, 15 Jul 2024 01:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VXGBFsY+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D042572
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 01:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721007634; cv=none; b=fdWgrGt8iRQgYMLnD+YUjBQXNMCtpQxIpm81mj1TxWYkwYb/KmlpUPfSGMmQ4iHkOqxuF/jXSUELj0IkDU6SK4hMJxtYcsn8zWCv/N1QhjSHb2itUYU44aOto5VFoWrr0BG5bX0PJYcx8Yo6ngaIjEkTarA1+ZNiTa+GkSMhkoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721007634; c=relaxed/simple;
	bh=yofS6NfmLoTU5oXqXoM9yEWIFssPZcFaqp3Sz9LXu1Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BCDV6QZU9ki1hQ3So334Mc6akqT3Lv0SMv4y8pFYWJCpqFSg84iQu/XZxNNCZb29cvvt0U4btEdtUIt+lfJLsJpU//iR2j0lnsdFCO2iQiluwfyzESM3vgy55RjTwQdzMdbP/iRd9p390UxRD/7fZHDPND57Y3g+UIdK4yFhTyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VXGBFsY+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2CDC6C4AF0A
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 01:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721007634;
	bh=yofS6NfmLoTU5oXqXoM9yEWIFssPZcFaqp3Sz9LXu1Q=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=VXGBFsY+QZYm2pN5xBVm9flKNpJNwSAW2b94B1g4QTUE8CWwYQ7YGHmVvZ5M/LrSN
	 Hy03lYdwIYGDNGdtOQxvv3Kc8eNgpVByg/FWzi7/rlB8oXnbjSCWJ3yFUntEz3xQTm
	 dZEt3TpY+pcTVxSlRuaz1u70/y2zelJX5bhqYyzJmjcT5Xz4zdhZTx+/C7h/w/779L
	 JGOAtrlzOBH9xxDcEziQ8wyWnK9sQvNqOl1DvtXkeoUQ67ioRHXIKKsQJJVkS+kJZr
	 yL+uf6rP1OZ+CAF/QhNsWJtw4p0H1mz6D8PqhuBl0Bon/MxdpB1rEgP2luhNPt8q0Z
	 GFflmy1+hAKiA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1AF77C53BB9; Mon, 15 Jul 2024 01:40:34 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218980] [VM boot] Guest Kernel hit BUG: kernel NULL pointer
 dereference, address: 0000000000000010 and WARNING: CPU: 0 PID: 218 at
 arch/x86/kernel/fpu/core.c:57 x86_task_fpu+0x17/0x20
Date: Mon, 15 Jul 2024 01:40:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hongyu.ning@intel.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-218980-28872-wxB0DENe2o@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218980-28872@https.bugzilla.kernel.org/>
References: <bug-218980-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218980

hongyuni (hongyu.ning@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #8 from hongyuni (hongyu.ning@intel.com) ---
(In reply to Luis Chamberlain from comment #7)
> On Sun, Jun 30, 2024 at 03:47:57PM -0700, Luis Chamberlain wrote:
> > On Sun, Jun 30, 2024 at 03:21:10PM -0700, Luis Chamberlain wrote:
> > >   [   16.785424]  ? fpstate_free+0x5/0x30
> >=20
> > Bisecting leads so far to next-20240619 as good and next-20240624 as ba=
d.
>=20
> Either way, this is now fixed on next-20240703.
>=20
>   Luis

good to know, on my side, a new issue met and blocked further verify on
original issue: https://bugzilla.kernel.org/show_bug.cgi?id=3D219034

since it's verified by Luis, let's mark it as resolved.

-=3DHongyu

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

