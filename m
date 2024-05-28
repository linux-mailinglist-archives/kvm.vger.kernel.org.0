Return-Path: <kvm+bounces-18240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 385A38D26ED
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 23:16:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6171A1C25FAD
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 21:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1250E17B437;
	Tue, 28 May 2024 21:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXtGt9FV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C96517E8EB
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 21:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716930973; cv=none; b=bS+sNaE7JgCtr1SzlNOrjl7UsvKCKro28XR66CPry/MKVWj4vIoUiMsNh/TXmd0DEuBElb3W5k/mLMuHTk42aL658TGgAD00UvUrbVjvCo/1kMro3MTSbfJwrBHW/1J4MgaIO6GbxqE9M93Gw9K41rbJm//E6dkNpXmu2raFDJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716930973; c=relaxed/simple;
	bh=D9l/myHZPjPGWZpGxcOSaUCRmM96Yj69AYudMjAh4Ys=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W5el1s36hXj8em27EMpGI+dPOKF7e6rwMyudHXXlm09sBA0+GN/Mg2HizBEZ11Nkbo6kiAH5rU2Q2H5hr0skPZWE6okYHRA0mHj218Pw4NFFJLuHibxHE72+Y+WBUyQg8HezOaGCjZv21Yuc1j9lxz1FFP0mmdw08XELUTTlCvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aXtGt9FV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1AB6C4AF08
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 21:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716930972;
	bh=D9l/myHZPjPGWZpGxcOSaUCRmM96Yj69AYudMjAh4Ys=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=aXtGt9FV3EPMgDCNf+iSRqM+hGKMaAQ4wrlYlzYf5lQXfCDcOOEfMSjB+uuf6r42N
	 zeLFfj60ngl+PIuyDZZP6lDeT3jPeZGZyr0dcGTQooA94eRDCHzedbA2p1fapogtSM
	 BC5yn5RuAgkF6YQpTAKy3H6WpwRaUiH65ycy9ihRVbNdfZuvk2H7aHmQa5jh1qUg7h
	 qH+jhuxHHPQ/XWOoL/kw8qqYFGOhCE2PyvVIP8jjr42pvu43xoftlVxp8ioFhM2jsN
	 +0V+YGuI6w2nUVFtHYHl9EnzHhmghomMGJ16C8N2fV6HGYDadQ8WeJ50+c8QF89H3y
	 jzPUDZDUybx/A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B9EC0C53B50; Tue, 28 May 2024 21:16:12 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218876] PCIE device crash when trying to pass through USB PCIe
 Card to virtual machine
Date: Tue, 28 May 2024 21:16:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: alex.williamson@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218876-28872-pmN0dnGr2r@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218876-28872@https.bugzilla.kernel.org/>
References: <bug-218876-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218876

Alex Williamson (alex.williamson@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alex.williamson@redhat.com

--- Comment #9 from Alex Williamson (alex.williamson@redhat.com) ---
(In reply to TJ from comment #2)
> This could be a power management issue:
>=20
>   vfio-pci 0000:02:00.0: Unable to change power state from D3cold to D0,
> device inaccessible

I wouldn't rule out a power management issue, but I think the device has
already disappeared by the time we're seeing these error logs.  We're hitti=
ng
the timeouts waiting for the device after bus reset and we trigger quirks t=
hat
are trying to retrain the link at a reduced rate.  Unfortunately this device
only supports bus reset.

Is it possible to test assigning another single function device installed in
this slot?  We'd want to make sure that the reset_method is still "bus", wh=
ich
can be selected via the same sysfs file if the other device supports more r=
eset
mechanism.

If it is a power management issue, we can also restrict vfio-pci use of pow=
er
management by passing the disable_idle_d3=3D1 module option when loading the
vfio-pci driver.  If that works, we might want to quirk the ID for this old=
 NEC
controller to avoid D3 states.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

