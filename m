Return-Path: <kvm+bounces-38824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16010A3EA0E
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 02:32:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4113F3AE04D
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 01:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E94341760;
	Fri, 21 Feb 2025 01:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OxY5YK7w"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FDA125B9
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 01:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740101510; cv=none; b=i6ScdpobtUT8047VY+htookGmYdCBVq+0+JaG7L/u4nKq/9ZM2RbxzjjNBUW1uV6uuXjCjEcHEtODtQjyR7mn9+V7w8A3AjtHME/Bi84jeNlr+du+qJmIvqJipNen40NUsO9XJ/mKtcjP8ySlUidUODhCByAYKq9XzoHgOqSyAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740101510; c=relaxed/simple;
	bh=YZGQUA6A9EdAu4S3ugymIiiJ0SRmPoCz2dEKYxo904U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a6KNNKNjTV99ZrA0nf6FA591Wass6AI4LXfNqMhS4EAX6MSdXNCoPtmsas2cjfkK9wov9QkH+xvfa9WhLrKKbxXzeP7/Bt1QNTMfCxHU6sgc5mX0LQH4GDSuRaAYD4+k9oK1J4z94u4qezFX3NQyVW3VLgNgjsBWBn9SdUSLaIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OxY5YK7w; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 114AAC4CEE8
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 01:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740101510;
	bh=YZGQUA6A9EdAu4S3ugymIiiJ0SRmPoCz2dEKYxo904U=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OxY5YK7wZNXosSO15rfnikLxtmv5aCpFURxgiIj99pp5xB4AJmd81YNlsGqhlyEAj
	 7F8SGAYpRFlMrs50hvwg+iGphfu3UlVxdHJkaFfXBu6cZJxgwR4gFoH4mg9pD9GA9R
	 pg9kqaHoiwC15Jh6V+IniZOM9XTb2hWfo5n6gsIH0qex0GXQHrMwSrcJV6zcd6sFHt
	 HQJ+2r+eWoo3EH8fOTrC2RYRAPtK8amZaBiuANwji+0FLqunIo/Wn9O6JLwmm8qwxf
	 wHimYa06CrNt5Co+v+9D0h48bV40qKnXS1QnHv5+JpsZbWpJ7HGbWkZxnbFptEP4vV
	 E/1l7auNwbLgA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 07D79C3279F; Fri, 21 Feb 2025 01:31:50 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Fri, 21 Feb 2025 01:31:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-219787-28872-JRvIzBFXYb@https.bugzilla.kernel.org/>
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

--- Comment #10 from rangemachine@gmail.com ---
Created attachment 307691
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D307691&action=3Dedit
bisection-config-culprit

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

