Return-Path: <kvm+bounces-38844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03C53A3F270
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 11:48:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B006116E288
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 10:48:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE13C2080D5;
	Fri, 21 Feb 2025 10:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p/gdJdja"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F00207DE3
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 10:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740134887; cv=none; b=S6qvE2YW11Pzzh5UKDZ1daVG+Q61XcfqW5HmjI3ATPVev/J3cfXmG19zp0l+IJfW3pGeFfuFrMC2rukgcUcd8t8DjV7EmFRIyXdrFDfJmrjEWAuMhdHobH42t5D2j5JJd/R6AmqKh6IdzBpYAiWBGAOXOlW5gpBcrZDw3PpNenw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740134887; c=relaxed/simple;
	bh=1ztdSi9y2Ql4SAg1DfcqwwI/xzhMaqj1mvT27e3u+tE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JNacwsioRahBHf2mWp8i80FgXEsl+/+31v1V59pfBVST/2o6G14kns9yacc9809Rma5ob2RVzB8BC+SaBYr40jHXo1KZsXbmyDfS8zkEy2VVhEZ/jtCXEDk6m7NjQkqQ/Csm0EQGAV4qzH03+QKmyBzrNxDvZ3IGAyDF9TfK6bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p/gdJdja; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D5D3C4CED6
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 10:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740134886;
	bh=1ztdSi9y2Ql4SAg1DfcqwwI/xzhMaqj1mvT27e3u+tE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=p/gdJdjaQOVeQI7pPHkS1r3RoHLgqrMAT3zU8OJN2GZJKbjXzfKUnFHrcTSt+0x0u
	 E77fZJq7SVsGYmfiuEaFcCl8ij7mF69j5p0CIltja+KpWo7FqBH8iBrWUnmyVHqNCB
	 bzf16basw242IRWwV1wL5mbRmHYZAo+lnT89pzuWaq6+Y7ncMh9LGelXs9MDOeKClb
	 wYWw7bTS/UTLlXgxhmExp0AXq8a6XM1dYBK5eVdqBn6o8wMKeoyTsVBkiCND2i6AN4
	 Ld8NNm5T3pECHYsitA3A8YKj+ne9smoEEhBTFRo5HBD4/4pNNiLP5IK3o/pjxYrtNy
	 acoC8J/R+bX+A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 804CCC41606; Fri, 21 Feb 2025 10:48:06 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Fri, 21 Feb 2025 10:48:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ravi.bangoria@amd.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219787-28872-33Oq8bKb9r@https.bugzilla.kernel.org/>
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

Ravi Bangoria (ravi.bangoria@amd.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ravi.bangoria@amd.com

--- Comment #12 from Ravi Bangoria (ravi.bangoria@amd.com) ---
Thanks for the bug report. This is what is probably happening:

BusLockTrap is controlled through DEBUGCTL MSR and currently DEBUGCTL MSR is
saved/restored on guest entry/exit only if LBRV is enabled. So, if BusLockT=
rap
is enabled on the host, it will remain enabled even after guest entry and t=
hus,
if some process inside the guest causes a BusLock, KVM will inject #DB from
host to the guest.

I had a KVM patch[1] but couldn't get back to work on it. Let me try to
spend some time and respin it.

[1] https://lore.kernel.org/all/20240808062937.1149-5-ravi.bangoria@amd.com

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

