Return-Path: <kvm+bounces-44604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C6F4A9FBFE
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 23:13:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C5D1463E93
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 21:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1DD31E282D;
	Mon, 28 Apr 2025 21:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kblqe0+H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FE61E4BE
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 21:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745874706; cv=none; b=aoHAuPKCAc0SMik0q5E616JCKwc2GozxcOZvjrDYsnKy7CVjN1atIWO0UxuU2Uel3mVUeZ2dQhHrEqOngUZe7+pEn0wR0uj356yrlhWhT2CUar795t1CsaAQysfYREIhY/geiD+1lQew9355xsabtzedG8uqNLAASRIZ16CiwYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745874706; c=relaxed/simple;
	bh=oGSbJ4PUVVpv5E7Vn2EefTonxammwbO5t3/gscI1dbU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aWrrzbbGhDSGyx+vRo9zYD2C4oE2+S0Ii6DOxYgpDNhqO/g677o0ssFrp69mzDIcFgwUZMB1+EerSGPk0dJbHi6Lf//kRPvG7ahQopGle3rzbfTkLq6UG4kQdr1iADTq3a04xNnZUvP/dln5I+xiHNEXYjgIsvmfQy2O350cc5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kblqe0+H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 584A5C4CEED
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 21:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745874706;
	bh=oGSbJ4PUVVpv5E7Vn2EefTonxammwbO5t3/gscI1dbU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Kblqe0+HW1pwa3YWDELVQKdZRJ/9foEqqezOhq4FXeOSTMY/lfonb+RJLEHusqfQl
	 9dACowN9hNVa0zLMvtkYIhW/056/yPSTE2dx7fC/L7ZcYT2k7dZuYrZChbVq9mY87P
	 1vs6OJ96+GOGjyU0G38XJETTUFfwh+oKB+QL3UBjLp2aZPq0hwsw+fGeIs0SW76z2b
	 jd8/mH9pUaKnKPiVQAlXG5/ideWrtQfuWqdzhjY+lf6rxVDEcqdfpUlXoR44BHm6SU
	 kAm6yJ0PsTTMIEsNJZ/vt7tRBnzxkhihU7ygxyTkeeB5Ivk0UTSg4jiU/ExffVpwWX
	 GrizyB1IJPpsg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 4DA18C53BC5; Mon, 28 Apr 2025 21:11:46 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 21:11:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: alex.williamson@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220057-28872-eArWFnYXM9@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220057-28872@https.bugzilla.kernel.org/>
References: <bug-220057-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220057

--- Comment #8 from Alex Williamson (alex.williamson@redhat.com) ---
(In reply to Adolfo from comment #7)

> 13900 ,z790 chipset, 128GB ram.
> Guest set to Q35. Cpu set to host. qemu 9.2. Guest is using nvidia driver.
> Crash happen on both a 4060ti and 5060ti.
>=20
> Other report but with AMD 9070 XT.
>=20
> https://forum.proxmox.com/threads/opt-in-linux-6-14-kernel-for-proxmox-ve=
-8-
> available-on-test-no-subscription.164497/page-5#post-763760

I'm not able to access the attachments of this report without a proxmox
subscription key, so I can't make any conclusions whether this is related. =
 I
do note the post is originally dated April 14th, so it's not based on v6.14=
.4,
it might be based on a kernel with broken bus reset support that was revert=
ed
in v6.14.4.

I don't see any similar issues running a stock 6.14.4 kernel, qemu 9.2, Lin=
ux
guest (6.14.3) running nvidia 570.144, youtube playback in chromium.

Please provide full VM XML or libvirt log, host 'sudo dmesg', host 'sudo ls=
pci
-vvv', guest nvidia driver version.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

