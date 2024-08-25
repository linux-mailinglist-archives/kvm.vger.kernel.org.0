Return-Path: <kvm+bounces-25002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 704F195E325
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 13:44:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E7381F218DE
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 11:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEDBB140384;
	Sun, 25 Aug 2024 11:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KBOji6BH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A7B13CFA5
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 11:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724586250; cv=none; b=ZsXpc6TkoYTuADZGFon/KrXOuZ6ey/W3HvHk9AC4T7MlgnNKWZqkDxYoVNRROz5n+i2Z+uTMetFcfOBrxaVEKfu3+5OZ7vyVyctAGQ4WiBYAlLRQbH1nGe9sVR4cn0tq42ua6EjYqZ9JlqTgRxTNFPo+dLvW8GIJizNJNBZid30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724586250; c=relaxed/simple;
	bh=wRFqNitGN8Seah87Br2Xo5Y9xw6VHQ/pzeZ2IMaMVbk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Hlcv8yx5BI3pCXLmdkoOnwKONa9arA30AInXbT3+KgOPDpHzOk/VhGyMy4FyJN0fdzxkYoS9OUOIGZp4PN9gKnFcvl4BzhxdqDauD4hMGyCWwQpgbKqKKar2lzjtYkY/ElbsPQQhDrIhuVuJKDNs0PDkb+e4Y5MmBgdlDkYKLEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KBOji6BH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 949E1C4AF13
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 11:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724586249;
	bh=wRFqNitGN8Seah87Br2Xo5Y9xw6VHQ/pzeZ2IMaMVbk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=KBOji6BHCy+EgwqSDAvVq1aMPiDIG4DF38HhYI6MGPxR8WIw/gKPZaxKcbCNWZYIl
	 VmEcnYqLcq6CgRBBllrlap3AxGWrOoRa4ORRH4Tl/RRL8bnWIBpH38SWN6HP8eIaLM
	 5rsUeWB+RHA3BtljNmc7jHKU9pqxx5p3agkXrETR0bGZKs5fxfDfcZJul4Th2MOUAZ
	 K8t7nxv/mgf6qpBa2EjY6ijxge4v+L1wbFJI5MEhpMVsg9dPGVqMOoRMRDQ1U0uD7F
	 jLDlkhqaRVmOAuV8ISO3gxIO1pDY87+I8uN95L082ELvUCBokmXq2mGKprYZ+WcApn
	 cU6EsjoKixQNg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8F106C53B50; Sun, 25 Aug 2024 11:44:09 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Sun, 25 Aug 2024 11:44:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: michal.litwinczuk@op.pl
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-pSBGLKqtVc@https.bugzilla.kernel.org/>
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

--- Comment #7 from h4ck3r (michal.litwinczuk@op.pl) ---
Update - aspm does not work, thou it decreased chance of random reboot.
Issue might be related to memory addressing method used in zen4.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

