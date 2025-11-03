Return-Path: <kvm+bounces-61801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 09907C2AB54
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 10:21:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 730F9348CA8
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 09:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6E9F2E8B73;
	Mon,  3 Nov 2025 09:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hbH5BANH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85C72E8882
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 09:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762161698; cv=none; b=MMVzmaBStoK1aoBxLTHUVsBQ+8unitLMBm7bfr1kKoxMX4g80GQu7Vqd7WyTZFWR0NgZ3VqlewF6ulkLkCkYboTug5L52/qCn20E+r2tTCktp3SfAFBDZcMw+EleKCxdBmvzWxjU5WZD147PvnfEjKPgibeHLZON26ZaFsOcKac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762161698; c=relaxed/simple;
	bh=x56ROdi8S1Tr2huP93sZZhjkA/5DW6FgMBp/T2BDPKM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qU33oXfZCI89jX/IlujErWCSueQ7C58bL/soP3PhbPJfljVG6wu/5T6TvJUlJ9B5L3jrXXKpyXo6dosTuBUPvfZzp8HSiOolC72MUTSSX0K1g28pFmyoWS4muz2yOV+Yyxqe/J4XeY/5eaBLSzufZLD+tX7cqbHYmC683LQphvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hbH5BANH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B4B5C116D0
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 09:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762161697;
	bh=x56ROdi8S1Tr2huP93sZZhjkA/5DW6FgMBp/T2BDPKM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hbH5BANHxLwK1rc+q8oqm1SYfqFW45Q5EerrBDA8ftA2Qwn1ciC+sSXB4GxTVa0gv
	 /8Cz4Kap0zvFlcljR9xt1CKUnSukWOUI1ce9JpWMQ4cRV1GvBBMe8l0tCSdk5S7wNX
	 bC+qypxL7UxWRTh7F6VsXxc9TxNMRTJ3SCB73P4eXth9Kkp3lHQ/YNRlxV8WvrO56s
	 Q3H2foiM8UemQNSvYRAGHmacF7BkVYs7fKXgZayMMZGLDmevtcCYJ8oxD5JxlLJ79A
	 xM0J7fulxt4SLYOQ+ilTDVLKSNqOicKp4qvJ5/Dat+avqg/PxniGrgUTp736LXz12D
	 4rXUGZklKVovg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 71ABFC3279F; Mon,  3 Nov 2025 09:21:37 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220019] Host call trace and crash after boot guest with perf
 kvm stat record
Date: Mon, 03 Nov 2025 09:21:37 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-220019-28872-yoGEMJJqw0@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220019-28872@https.bugzilla.kernel.org/>
References: <bug-220019-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220019

Chen, Fan (farrah.chen@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

