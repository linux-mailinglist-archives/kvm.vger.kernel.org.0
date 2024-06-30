Return-Path: <kvm+bounces-20739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB9391D4AC
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 00:48:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A20701C20C49
	for <lists+kvm@lfdr.de>; Sun, 30 Jun 2024 22:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2266C80623;
	Sun, 30 Jun 2024 22:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A00n2zD4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2E27D412
	for <kvm@vger.kernel.org>; Sun, 30 Jun 2024 22:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719787681; cv=none; b=sOTiU+8ZV+xg7cOrJ9bsPLDXjZ2+6wQhr7HLlteQlyjUrz144XxwLnV0MbKWjum4yyb17xyDP6Dd7rwNlkMm2zU3rSa9qQc9WfJ6xyUL99Ztxalk29Y72TILJUARAIhQZ4QvbMBGG/8VuBxjGSJWSv7HjiuvnJ1ROdhcB0Ri7GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719787681; c=relaxed/simple;
	bh=wt5aR31zxUsTQvSRrGtacuHOI8sD97la6oONKTjtlzc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gRJYDxZ4XQiClWTX21qW9P5uNDdMN26z0iN5ubRCHqRi38+vMm6IKMml9JSYDVl9bQDnVh/p0/N+FBGLkJoKbS1zr4ZwEAW1LXel5Q2WcuaaxDIsng2hiBl25shtY4grw+wrSw167pWjqHu8tzN5geyP4Bmptk5e4jbjo+eBr8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A00n2zD4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 128C0C4AF0B
	for <kvm@vger.kernel.org>; Sun, 30 Jun 2024 22:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719787681;
	bh=wt5aR31zxUsTQvSRrGtacuHOI8sD97la6oONKTjtlzc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=A00n2zD4ohYU0+U6f9uXx9c4+uR/qm0xDIMFtk1+3Tf7N2lbPCWQlozbWUG2nT8ih
	 PY1pvrqXYhaB3xN6BNXx11EtwmFailbTWVBhO7AVF6Zhb6yT5lWmzSLHjEZIbXRVOM
	 d5K0JO9zdKQMvlhklTonS12QHvtkdn+Z3G3g39+VCEvSC4ea1L6tomS3wz1cSw4BWR
	 EzoDngRGf8jpb03iDS66guZM5czYalUeGGN5+bQPunAXnxw9SFF/kbmjahEtz0YxgN
	 giLTah/s3+Q3G2DjLHLwJ1Odl2AuAJKgnHp4vuYgsA0FUPadr/H45bPJVOo+TDUUae
	 3EvkFb+SUQVNA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 09C86C433E5; Sun, 30 Jun 2024 22:48:01 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218980] [VM boot] Guest Kernel hit BUG: kernel NULL pointer
 dereference, address: 0000000000000010 and WARNING: CPU: 0 PID: 218 at
 arch/x86/kernel/fpu/core.c:57 x86_task_fpu+0x17/0x20
Date: Sun, 30 Jun 2024 22:48:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218980-28872-X7eXPOq73e@https.bugzilla.kernel.org/>
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

--- Comment #6 from Luis Chamberlain (mcgrof@kernel.org) ---
On Sun, Jun 30, 2024 at 03:21:10PM -0700, Luis Chamberlain wrote:
>   [   16.785424]  ? fpstate_free+0x5/0x30

Bisecting leads so far to next-20240619 as good and next-20240624 as bad.

  Luis

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

