Return-Path: <kvm+bounces-50995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31265AEB8B7
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 15:20:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F3793BB8C6
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 13:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E520B2D9ED4;
	Fri, 27 Jun 2025 13:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q+oPq9Hy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ECF2D97A9
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 13:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751030399; cv=none; b=cTscULnQRShxLNJY/kPm3/0pS+6ldXi2eKLtuVtdLeAD/2GqsETgaHbe6PnfjR9PBXWzEGnu7hjZS27oaqW8fmSQ9b62bHUqHf0vuUOOiKBuYLNIbLneu6uI4YBJZAHpLUKdN+h5Axv28bik290VBK/c+cXOxVjGeHF2RdVvihc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751030399; c=relaxed/simple;
	bh=s1DJ3kuAUYeWP8KWD3Uo4A8yz6L4b0LAoQcuHrJ0kYo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FwW+/GJM9f4EEqNjcSfdffoLYMC9z+G2hnEBWks0bOdF+f9Z/CIjXIXE5ogLrJC2G56ld4m71CIq6YZezW8qOUaoiyjvlNgjkgEi8q4Or07r/gyG/8+FydPPg5PujBqVMLhS1kWx5glWTOxBJ8uznN1N+O+7seMb6hanj5laxLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q+oPq9Hy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86CD1C4CEF8
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 13:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751030398;
	bh=s1DJ3kuAUYeWP8KWD3Uo4A8yz6L4b0LAoQcuHrJ0kYo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=q+oPq9HyX62hhKM5CAKU97EGvjUzFMGbE9gnmoyPEef4T1PMw7b9NwFIln9KKR7Jz
	 m+pfppRh/mnz4WciNtylIo2YbCdZSyDSEXYGGSL8vQp1LGPqyAsmBuRN9IDOqTwT4E
	 XQUHELDKLGauigrXv49fuLdQbtbd91ie7x7JNTJ+l/4uyT3l78SxDy7pkmt5z7BrKt
	 +vLVY9Pw/m9TK+rO7c9AWXf6qTNtIGmvIwa6d9LCkvl18tLn1NtsrGmOqNbdMWQavY
	 5nACo2WQXheADjDd2Sta6FshBGKqkmlkWNcL4p3mnwnzqbSohIXfcrhMnu7MA6Upih
	 4OEBzpRhNZ77A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7F730C53BC7; Fri, 27 Jun 2025 13:19:58 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Fri, 27 Jun 2025 13:19:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: maps@knutsson.it
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219787-28872-sl6pOjGOBR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219787-28872@https.bugzilla.kernel.org/>
References: <bug-219787-28872@https.bugzilla.kernel.org/>
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

Brian (maps@knutsson.it) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |maps@knutsson.it

--- Comment #19 from Brian (maps@knutsson.it) ---
I can confirm I have the same problem.

CPU is AMD 9950 X3D, and I have the problem both in Virtual Box, and VMware
Workstation.

Can anyone point to a guide to get around this problem now? I have been run=
ning
Linux for many years, but it almost just as many years since I compiled my =
own
kernel.

I am running Ubuntu 25.04

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

