Return-Path: <kvm+bounces-14115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DE2989F01F
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 12:45:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43FBB1F23116
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 10:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2808C159578;
	Wed, 10 Apr 2024 10:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G69cY/SA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398531581E5
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 10:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712745893; cv=none; b=UmXvXDwdAAqvWADX4mFQK7fZi04OF3DLUhcyXinp8Lt21qmG+hLJxFo37pgfNp4gQEK/5sf+zrH3tyF8tbSnMMZIL0E4GktaVEWnbLg3on8bGbsHwl6vW00WYl3Ia4CvmBTEp4wCBUnMwTXO6hRs0Qo8qg0/ELEUU3YSFBdR6TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712745893; c=relaxed/simple;
	bh=E2qRccl6FePjXOJpIrk4XJsvl5r5/THJNaRGiYJ34JQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I5qejORyCBAjiYAMd6nu0iIcuM+GYTfvHe8DdoSyT8mPRcac/386+NEeIhxPLCeRt+nExvLQ0SmwiogTSZ1BCvKUkCD+vrI1oq9Nd/0oEZT6d4Loo67FMlzYp5V1kaIXog+jz1Q4U88HaWLzAOswFMmEYPU3PCBnG794c7fj670=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G69cY/SA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14C70C433A6
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 10:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712745893;
	bh=E2qRccl6FePjXOJpIrk4XJsvl5r5/THJNaRGiYJ34JQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=G69cY/SAJ3Xn2MqAk6p60ueyouKSEn0Ybe8g1mpemxSojnATge+wA9dqhpzWUjglw
	 eWI+diUI9iqK0lB5XvKr3DuYbi0TwSmso0cuuzKPXYRndjHwkillY8mgWOVGWVaWDt
	 MUNR8op590WK+woM8Qd8Rs4pitB/FgaZFjd1/vzBOYXQwNfOCcK5PTqfYUapx43S5S
	 sjQP3TZyWSd5wPsMclLm0yINZJ19Rd1YuwuJpl6k9J2s8TINtNdngnwL3vVybbIFIL
	 qTIyJ5lRD3g/A/VRjwJOWt+/+oqkfjzbhSiFKD6CXF5yhroJYAy8n83tYiJPkryLOd
	 p0WnuFVj87FzA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id EDB72C53BDA; Wed, 10 Apr 2024 10:44:52 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218684] CPU soft lockups in KVM VMs on kernel 6.x after
 switching hypervisor from C8S to C9S
Date: Wed, 10 Apr 2024 10:44:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: frantisek@sumsal.cz
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: PATCH_ALREADY_AVAILABLE
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218684-28872-TK3CVGqmgj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218684-28872@https.bugzilla.kernel.org/>
References: <bug-218684-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218684

--- Comment #4 from Frantisek Sumsal (frantisek@sumsal.cz) ---
(In reply to Sean Christopherson from comment #3)
> Given that 6.7 is still broken, my money is on commit d02c357e5bfa ("KVM:
> x86/mmu: Retry fault before acquiring mmu_lock if mapping is changing").=
=20
> Ugh, which I neglected to mark for stable.
>=20
> Note, if that's indeed what's to blame, there's also a bug in the kernel's
> preemption model logic that is contributing to the problems.
> https://lore.kernel.org/all/20240110214723.695930-1-seanjc@google.com

You're absolutely right. I took the C9S kernel RPM (5.14.0-436), slapped
d02c357e5bfa on top of it, and after running the same tests as in previous
cases all the soft lockups seem to be magically gone. Thanks a lot!

I'll run a couple more tests and if they pass I'll go ahead and sum this up=
 in
a RHEL report, so the necessary patches make it to C9S/RHEL9.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

