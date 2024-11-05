Return-Path: <kvm+bounces-30580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C76BB9BC201
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 01:27:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52E15B218F7
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 00:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 190CAC148;
	Tue,  5 Nov 2024 00:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ho0LwMjh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E92B8F62
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 00:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730766421; cv=none; b=Gm6bc+hZTGBy/emTq5lAj0hEgvlhdR5gB+xFmqYSXzTZBSYu5OnKVq7YzO7U3T6xpMjyUDe4fWZEYwFIZ0WxrURJEnh4PPvvsCOFWVh5txL5RVjgQUqjkxIhPjFoQETD7Oni3J8JLIO4KbS5lRxWRStw8XVXvRoxPjUhZYuzIzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730766421; c=relaxed/simple;
	bh=JSCeqLmVUbIJ47X2eTgvjIGJkFajg3lw6BtlFuCMq6E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K9eNRxF8QPfNNr+3A4aHQOl3uFJSpU0nlNvjJBFRD4S0gZlYTAEffWASsILaCGr1qKZMu+Beljip8RdkeGr0uVLfzJjjsCos0LWjnk4s4LIUambb2jfnoYXLZrB4O375BAj1mNlrpWWU7H1PHarpAH4bU3ZMf9CuXy2O5VQcALU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ho0LwMjh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC0A0C4CED5
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 00:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730766420;
	bh=JSCeqLmVUbIJ47X2eTgvjIGJkFajg3lw6BtlFuCMq6E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Ho0LwMjhN5IOqUN47vBzMPe0eMH7TmnShDx17FB6gc0lEfVvx2t37xYN6YPVNOGMr
	 88kLAL8Pv2ELLVpw7j/hqFfX4qd198nJ3tcXCZ6MViLCODAQWqnrEZPe9Rbma6YNd5
	 oyBD0ET2+NnWRqEVw/Quhxvgy0NBZ5SVNuWUot8oaU1hWUs6kMO5yXu3hNGE0Oc6Tz
	 IbKdo1Dy9xXIeDrXMcy206KNmSNLRsxUFDVLcl4x9L/nX5F9R/3tSYf6QpcQq4v52f
	 0MZXLHiS+cCNYtXTdBE6ISAN+/LMDwNyoucee4soRYZiywaN8hQiLy5DN0xly3h10q
	 MrsN0egcHwC2w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B3D87C53BCA; Tue,  5 Nov 2024 00:27:00 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218259] High latency in KVM guests
Date: Tue, 05 Nov 2024 00:27:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: devzero@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218259-28872-jmjVhMitYD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218259-28872@https.bugzilla.kernel.org/>
References: <bug-218259-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218259

Roland Kletzing (devzero@web.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |devzero@web.de

--- Comment #12 from Roland Kletzing (devzero@web.de) ---
also keep an eye on https://bugzilla.kernel.org/show_bug.cgi?id=3D199727 , =
as I/O
also may be the cause for severe VM latency

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

