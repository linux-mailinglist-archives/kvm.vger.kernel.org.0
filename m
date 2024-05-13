Return-Path: <kvm+bounces-17308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F62F8C3FC7
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 13:23:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEF3E283330
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 11:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCB4614C5A4;
	Mon, 13 May 2024 11:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MQy4hSje"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D71146A8B
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 11:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715599365; cv=none; b=C4WHYhO6ErHfu+Gs51U21xDffXo7gOXBHnLOSBZOvoazDbE9jtfBDggwwqDRnWTXH6Z6AVIbjuSOLDPCWPuyMLkFXedl62DqszM880Mv+/PMXTB815ENZOq6+yl7VzQAyDc6pRh134wKVweeDE955PNoRYjG8+l/szpAP5TNECs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715599365; c=relaxed/simple;
	bh=O9L/ictdTLb7v2b3rYdfKd3/caBGPnSM7dAbdgWrO9s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kwnPUOwK1lvFlPMYfYUfI4pkY1bh4x9yAM/0GDKH909MtvYh3jwISzqymDtBvNT0OpPiNuWyAg0khKG+4jq+ucOFS6uqcJufbnitry/N4jlFd/uROb98DYPVU+Ep1S8cK0QIMogUXdjQmnk0TeMrgRunFaWJSDqvxCfg8a6HcXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MQy4hSje; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88815C4AF09
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 11:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715599364;
	bh=O9L/ictdTLb7v2b3rYdfKd3/caBGPnSM7dAbdgWrO9s=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MQy4hSjerKwKcQy6KQtRrO/H6fOkMrm6CKOlEyRolnIXf5Tia9yQfz6Fnd6onaQoh
	 t5NPlDEHHu4/jB0zMG0FdwS0bLD/qxGMuvNQinFGQ72MqwWYdP7j1zUV1amGgkzZHr
	 +pJ98DDkqPZN6myqtVSaaPtBZSXIChVTnvZWsS08LGuZ6gJKdU7OnQI+MU+qpSiibd
	 BoKOFUsNOn44Uc7XTiiqxvfZ5mNijR+djqr/Ws+wZTZo8/kL5fsDlg90OFco3jEq1c
	 0Az7flbE+PmNtXphMVA0woMono1oGTrxUOF2nKw4SfIOpwLZGleMXcoab3Z4MFwCRF
	 ynsYrMM9/GRmQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7F664C433DE; Mon, 13 May 2024 11:22:44 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218684] CPU soft lockups in KVM VMs on kernel 6.x after
 switching hypervisor from C8S to C9S
Date: Mon, 13 May 2024 11:22:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: imammedo@redhat.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: PATCH_ALREADY_AVAILABLE
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218684-28872-yil1IOyecI@https.bugzilla.kernel.org/>
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

Igor Mammedov (imammedo@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |imammedo@redhat.com

--- Comment #5 from Igor Mammedov (imammedo@redhat.com) ---
(In reply to Frantisek Sumsal from comment #4)
> (In reply to Sean Christopherson from comment #3)
> > Given that 6.7 is still broken, my money is on commit d02c357e5bfa ("KV=
M:
> > x86/mmu: Retry fault before acquiring mmu_lock if mapping is changing")=
.=20
> > Ugh, which I neglected to mark for stable.
> >=20
> > Note, if that's indeed what's to blame, there's also a bug in the kerne=
l's
> > preemption model logic that is contributing to the problems.
> > https://lore.kernel.org/all/20240110214723.695930-1-seanjc@google.com
>=20
> You're absolutely right. I took the C9S kernel RPM (5.14.0-436), slapped
> d02c357e5bfa on top of it, and after running the same tests as in previous
> cases all the soft lockups seem to be magically gone. Thanks a lot!
>=20
> I'll run a couple more tests and if they pass I'll go ahead and sum this =
up
> in a RHEL report, so the necessary patches make it to C9S/RHEL9.

Thanks for reporting it upstream, as for C9S it should be fixed in
kernel-5.14.0-444.el9
https://issues.redhat.com/browse/RHEL-17714

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

