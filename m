Return-Path: <kvm+bounces-38884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBD1AA3FEA6
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 19:23:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B25111887C42
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 18:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A06762512D9;
	Fri, 21 Feb 2025 18:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ItOPGM/X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BC71FBCA9
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 18:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740162177; cv=none; b=RlQwmUfeCoZ5y8EdtPN2NgH67hGMQRaBb/VpwTLTelTrljN+BbMStmYj9zojH70evHl1lJXbkxHCC3pLNxSOhKyoKnZ6ZIkE4KpT0xp1z9CQzi3jjDSUDfHqjoxz2JOpLkPU0UOMqKhFN/Exxd8++WPI5VFELEH6sdAk44nF/kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740162177; c=relaxed/simple;
	bh=wz25kfubU5VHFD2Nah2khCiApvHOLZFU4UigCELnRA4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MzGd7wyDB67x6reLBZwHixqTcva4d0lIgqNfl31hr40y0r5maa4BK0U0ZCRVYGajA0f/Wuhks4lqfzKaX9vo5/cClhMgMXtk7Y1aJwk9q3WIQTp867LKlDqvntedg7IELkuKkyeHVs5YSQ8JL2UOYykS2jlMt+8PUh9iShbEJOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ItOPGM/X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4349FC4CEEA
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 18:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740162177;
	bh=wz25kfubU5VHFD2Nah2khCiApvHOLZFU4UigCELnRA4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ItOPGM/XF4WV8J8gkrjc+cCOEFo+cmh5McI+lWHP1EECZH9vrsTjMGzSXmw8YiBpr
	 V99kkGFLvmgPz5ROHucQSFd3OjiTIbNwYz7MUBuayqfrQx+H7WIywrgL4ifh3P19p+
	 SKuJfsice117JsJGKnpMtbaa7PLPSoQfGj/+d2TQgVoeGbD2FmlpZHWYuZpMQXOWE2
	 9bYn4xelMaRvjRWlpHe4HcqVCmFZRUJDeJjm5eIvl43QT2EHrNHTlQQ+Pjp0lK20dh
	 oMCTTdW4PNEV9KQEMFkz1FaVrFURlgtSbuTbSqb87Ek3QMHbLUDR3IQsZTAeAiak9a
	 Dud2UJQEFmsSg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3C21DC41615; Fri, 21 Feb 2025 18:22:57 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Fri, 21 Feb 2025 18:22:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219787-28872-wcb7MhkccO@https.bugzilla.kernel.org/>
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

--- Comment #13 from Sean Christopherson (seanjc@google.com) ---
On Fri, Feb 21, 2025, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D219787
>=20
> Ravi Bangoria (ravi.bangoria@amd.com) changed:
>=20
>            What    |Removed                     |Added
> -------------------------------------------------------------------------=
---
>                  CC|                            |ravi.bangoria@amd.com
>=20
> --- Comment #12 from Ravi Bangoria (ravi.bangoria@amd.com) ---
> Thanks for the bug report. This is what is probably happening:
>=20
> BusLockTrap is controlled through DEBUGCTL MSR and currently DEBUGCTL MSR=
 is
> saved/restored on guest entry/exit only if LBRV is enabled. So, if
> BusLockTrap
> is enabled on the host, it will remain enabled even after guest entry and
> thus,
> if some process inside the guest causes a BusLock, KVM will inject #DB fr=
om
> host to the guest.

*sigh*

Bluntly, that's horrific architecture.  Why on earth isn't debugctl
automatically
context switched when BusLockTrap is supported?

And does AMD do _any_ testing?  This doesn't even require a full reproducer,
e.g. the existing debug KVM-Unit-Test fails on my system (Turin) without ev=
er
generating a split/bus lock.  AFAICT, the CPU is reporting bus locks in DR6=
 on
#DBs that are most definitely not due to bus locks.

> I had a KVM patch[1] but couldn't get back to work on it. Let me try to
> spend some time and respin it.
>=20
> [1] https://lore.kernel.org/all/20240808062937.1149-5-ravi.bangoria@amd.c=
om

Virtualizing BusLockTrap won't do a damn thing.  If the guest isn't using L=
BRs
or BusLockTrap, then KVM won't enable LBR virtualization and so will run the
guest with the host's DEBUGCTL.

Furthermore, running with the host's DEBUGCTL is a bug irrespective of
BusLockTrap.  It just happens to be fatal with BusLockTrap, but running with
BTF=3D1 and whatever other bits may be enabled in the host most definitely =
isn't
correct.

Bug reporters, can you test the attached patches?  I have a reproducer in t=
he
form of a KVM test, but I haven't actually tested a Windows guest.  Assuming
squashing DEBUGCTL remedies the issue, I'll post patches after I've done a =
bit
more testing.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

