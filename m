Return-Path: <kvm+bounces-38318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F658A373AD
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2025 10:54:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70A7F3AC2B2
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2025 09:53:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A143818DB02;
	Sun, 16 Feb 2025 09:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljD4ONa+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61B1290F
	for <kvm@vger.kernel.org>; Sun, 16 Feb 2025 09:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739699639; cv=none; b=YwZ3+prP4SGaZLIqhCjMIX7fziPpKPB2rre3p6pl06Oqe0qHm+5ld//0U8kxlil+6MbPpPtTSNc8Q3rP/fh10Lpj8993HfOSuqr7b0FB+mylXsyM/Q6lFKa13oh0nRW/8L+pBaGlMgz7hZKsWxHbYftkZZ9NUu09YOYql2PFSmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739699639; c=relaxed/simple;
	bh=P++F8f4O1/gc7hKqM8FRhSAQls3Y3bfnclJIK5xzNlM=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=cODIzOu6YCYFB4kcvMQ1v89+egYHgPMZq+5rhQ9TTU4VMTf0y0+UF3b6oW+0Th0cW4wRZZKjoZqjg7yg9YI0NWjfIp1sWvwTj0bBxjW/yMLZsfR3Zo419seddSeBZ38/8wPnIL+bk9NpXJNmTfiXMrozSkjybRRfeKENrUsln/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljD4ONa+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36D62C4CEE9
	for <kvm@vger.kernel.org>; Sun, 16 Feb 2025 09:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739699639;
	bh=P++F8f4O1/gc7hKqM8FRhSAQls3Y3bfnclJIK5xzNlM=;
	h=From:To:Subject:Date:From;
	b=ljD4ONa+lBfBW6P67ohkqeFUhBwC4fuSgOPwxlV3P32BG/JGHim3Fste+o1YrziJR
	 Vl5SzsOGMu6XdNiXM2hYaSxCECrzaq2qnLy1ScabU1plAYRELr1igK4xXj9CNtw4P8
	 CrCeW0vGT/J84uG2abO5MOxQxpNz8Jk90zxjyUSM1tgKIoF7r/ck2hDZLWvJj/Yvz2
	 k5zZyOql88kk4IKc1+LGAeRFK4daXVPvaeVnS5E+mzzaICt65dhO7kDk9o7UvAUmYw
	 DsaJgfjIe4MP0889D8ow6+mGdefBBS/3e5Lx6Oz9qYNEWUdeAODlPQJtoA2BN751dm
	 bmDLHB/xMUZHA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 2DE49C41612; Sun, 16 Feb 2025 09:53:59 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] New: Guest's applications crash with
 EXCEPTION_SINGLE_STEP (0x80000004)
Date: Sun, 16 Feb 2025 09:53:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: rangemachine@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-219787-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219787

            Bug ID: 219787
           Summary: Guest's applications crash with EXCEPTION_SINGLE_STEP
                    (0x80000004)
           Product: Virtualization
           Version: unspecified
          Hardware: AMD
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: rangemachine@gmail.com
        Regression: No

Created attachment 307665
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D307665&action=3Dedit
Debugger attached to Steam.exe

Overview
=3D=3D=3D=3D=3D=3D=3D=3D
Linux 6.13 update introduced problem with Windows guest's applications on A=
MD
processors. Several applications crash with EXCEPTION_SINGLE_STEP (0x800000=
04).
The list of confirmed software: CrystalDiskMark, Visual Studio Code, Steam,
Looking Glass server, Windows Tweaker.=20
It never happened prior 6.13 update. I also checked 6.13.3rc and 6.14.1rc
updates, problem persists there too. I did quick check differences in KVM/S=
VM
between 6.12 and 6.13 and did not found anything that could set trapflag, so
problem could be somewhere deeper inside kernel.

Steps to reproduce
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Run VM with Windows guest, launch any software from the list.

Hardware
=3D=3D=3D=3D=3D=3D=3D=3D
CPU: AMD Ryzen 7 9800X3D (16) @ 5.27 GHz
MB: TUF GAMING X870-PLUS WIFI

Additional Information
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Steam crashes when downloading game, Looking Glass crashes on WinAPI
QueryPerformanceCountrer call. Tested on Window 11 22H2/23H2/24H2.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

