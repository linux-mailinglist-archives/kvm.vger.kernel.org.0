Return-Path: <kvm+bounces-24946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C7DC95D80B
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 22:49:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58B49283879
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 20:49:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447CE1C7B84;
	Fri, 23 Aug 2024 20:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qPIPyJUf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617E1192B89
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 20:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724446151; cv=none; b=L8SjOA8PmAODZWhKESeNDiIz7EZKuRPjwH0eZ/zZ8dvBNN5ZR3KNJREdwuFl3uXjN91aoWL7QRs6qEhQtHHMTIveb0NNWdaTU6YpUQDohrsIVh3dIvQoqpTdCJ2EWsoLpOqNZPGRB6EIy/vfsm02zbbA8IAQ2AL/xWq7oim2FL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724446151; c=relaxed/simple;
	bh=COBkQFLpeL+29ENMGVDCh9+QXnZetZN0in+PIGH2TG8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JJDF0xIbi5p+ZraNQvIBiHNm+s7rTftiJQVaedhq/97gQnqxBG94hFK/xPv/rBe+CZ0lDTvu4GduTMtfUFd2upxL33pGLKFnbljzV1uCyPRERg2ncihf7X515zxn+TYbfQKI++sv+FQuFgzZ+mgUPOG/Oe+WnHN5Hy5aVTvdXPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qPIPyJUf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF845C4AF11
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 20:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724446151;
	bh=COBkQFLpeL+29ENMGVDCh9+QXnZetZN0in+PIGH2TG8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qPIPyJUf6Sl3HjkPvTM+SyQ8SJFITAqjfvdBdPHIE4Nc7L1UBtn3qM0Rae0D46dh9
	 BQNzKazuUccF8GMq+m9oY0rMK4VmYD11V9iNY6s0icYYg49mAKTa2q372835RN3clz
	 58BJm6BIi0mJ9aMUeNPH5F5B55BJyBIZdyYoilwAvAJ5sYCgvZrttkqfhe7D/iYp00
	 eIRuZxQqw2gx0YGtqe6OXX1VBsiGvJDEJKC9DCFVNcBYiaSqcla00IJAF3xQqK7VKo
	 F1WtZ34mVB/XP9E6oQfPbISNLZifObRLWrT3rzy+ePdLPZz17AG65gFZeOYSAL1B8D
	 2A8UMuEJ7ogGg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E8186C53B73; Fri, 23 Aug 2024 20:49:10 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Fri, 23 Aug 2024 20:49:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sagnik@sagnik.me
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219009-28872-wASCtO2jLg@https.bugzilla.kernel.org/>
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

Sagnik Sasmal (sagnik@sagnik.me) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sagnik@sagnik.me

--- Comment #5 from Sagnik Sasmal (sagnik@sagnik.me) ---
I can confirm the same problem occurring as well on 7950X and 7950X3D CPUs.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

