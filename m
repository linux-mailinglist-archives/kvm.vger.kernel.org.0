Return-Path: <kvm+bounces-38639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E5FAA3CFC1
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 04:00:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3870C3BC69C
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 02:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFD3E1DE3AA;
	Thu, 20 Feb 2025 02:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gjb8oBzg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B0013A3ED
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 02:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740020252; cv=none; b=D0PARcSun4L1kgWj5crKa9YG7D4wI6DORfuHaW6elU5U7LljApka7FHOODPBtYDGIo7cKG1N3XqbJLBqP2mtfqvYYChYlJ99lUljzXme9KqUsA7+ux7FouxSI1WE82WT31llJvA9YFe0ogqL6Knp4KxvmNri14FpFwruvcq0C+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740020252; c=relaxed/simple;
	bh=P48ZZPBPg7Y7CVB/l19P2YlM3QFa8DrNADPDYmqQ9Es=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lzJ3vyBq8LEWu4075eG6v0LfJK1n31gKorYXPVJ/5Sog+gV+hTOBBpmLObs0hSEgBbRYJT8LAxUkngDPpjlEqdHVfE4mIgrL1zNdLAQP4UQHm1Mrqe8jsaDd/5O09CHi5I16hiUy13TqZGFxObUnf7D+qJ2ism8sD6FSTXK3MSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gjb8oBzg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90137C4CEE8
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 02:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740020251;
	bh=P48ZZPBPg7Y7CVB/l19P2YlM3QFa8DrNADPDYmqQ9Es=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gjb8oBzg6ZvGTqD4AZuam5Ptph5XKnREfz/4DQ5AsfiOW4Tkp0+JUMTsZqyfsjoKh
	 0N7IUbRqfq9Gufex6RGGvzf4VfWvt04lMnn+97+qG1PgvHzV2Y5YTlELHKsxxPefAm
	 Ga9KnZboAFasvZXM42QrztxzTNN2ctFWWMBXzrYegTY1y6sc8urNJPrbA0mxq7Mnc3
	 XKp/slxQ0w3IXEU89KYFdpELe3CIaVaURVV7f22Z3EQX/lp23o/7EVacM4ldDyyNlD
	 EGrc6YoWjUUGvcXfehXiZwLu+5udbybge4vpyht1yJHE1gnKM5mVVLygyb+bURZMzF
	 OlmyedSyIGPzA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 89726C41606; Thu, 20 Feb 2025 02:57:31 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Thu, 20 Feb 2025 02:57:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: whanos@sergal.fun
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219787-28872-1JniK28vj2@https.bugzilla.kernel.org/>
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

whanos@sergal.fun changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |whanos@sergal.fun

--- Comment #3 from whanos@sergal.fun ---
I have been able to reproduce this bug too on Linux 6.13.3 - Specifically
whilst attempting to download/install any game via Steam in a GPU passthrou=
gh
enabled Windows KVM guest.

Downgrading to Linux 6.12.9 - with no other changes made, immediately resol=
ves
the issue for me.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

