Return-Path: <kvm+bounces-28146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6509E99560B
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 19:53:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C8651F21C13
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 17:53:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94FFA20CCE2;
	Tue,  8 Oct 2024 17:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FzFBVFdV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B270020C498
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 17:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728409998; cv=none; b=ePReutqzUan/7gPNEvXJ1RZHP/Qgc7anPI7vNtJwXFQfsAgOPWcUY6TbtFLjtMtOTL2fzAA9KHn/cT/6nOtGZs+CGRtJE73AJa8wACRrOYVFiwI+QqOrZNxmHnWj96XpKlNSld07g2Ha1xT0vRDLpUCBrdnf7B3GJ7+9Iph3t/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728409998; c=relaxed/simple;
	bh=8vgspOVFqAJb1rDggXE6eLTWvC8F3PE+7oS1otFN9Go=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P1Vqvk6A0gGnwXC3YYrXRzwHvqSE8wUsH2cxq8qdxc0Ph77IJ/kCDN3l7BPbbVHoWEFnbR2RLYCIF/I15x3Yagqd+HDrOm3seuYhCO2+64CHxUUm/akTqv19s2DSzwQMOdr5J3XvUy5hqiyyyAFmgOP8AQUG+isxF+4aGBuKSXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FzFBVFdV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40F58C4CED4
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 17:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728409998;
	bh=8vgspOVFqAJb1rDggXE6eLTWvC8F3PE+7oS1otFN9Go=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FzFBVFdViDNYDFYsB4/nkkWayhdYhhLCE+7KxscQ6aIbAf8lfFtgpGa3d1DVDM6VU
	 7otBQ2uM0+dVKVzFTR/HwcossXnyH3mBc+nHdjpvptrAGFfHHB3LpIaHCyr1R4FEvJ
	 /i/GQa2aj5arDFN/9UJS48hYplSE/8oOUxV7nmu6eoZJEcGnVdzbjV2ymtMYxAFYkI
	 WSBhY+KQ1P6ytmm+PQKJ6VztSy7928nyA2OMHO8fF/SrhJG7RG7yrHd5LEcZ1n2oNu
	 haFr0J4ScHa4+f91nxRjIsUqH1PC81R3uVSMBSzOO9iuIfS83j7yRCQTp9PxEeKjHM
	 ofRxG7eBrG+Kg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3851CC53BC1; Tue,  8 Oct 2024 17:53:18 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Tue, 08 Oct 2024 17:53:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: zaltys@natrix.lt
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-5pbVb6zpR0@https.bugzilla.kernel.org/>
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

--- Comment #27 from =C5=BDilvinas =C5=BDaltiena (zaltys@natrix.lt) ---
(In reply to blake from comment #13)
> I recently experienced this. I built a proxmox cluster with 7950x. Every
> node that I tested on would hard reset with no logs when a VM was doing
> nested virtualization.
>=20
> Our CI testing uses VMs, and putting the CI in a VM itself makes it pretty
> easy to reproduce, just takes some time.

Blake, what OS is used in your VMs ?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

