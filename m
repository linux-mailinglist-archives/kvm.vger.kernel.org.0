Return-Path: <kvm+bounces-44616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F222A9FD3B
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 00:46:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10E6E3AFF93
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 22:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC27C212D7C;
	Mon, 28 Apr 2025 22:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iI5vYC/A"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D500C184E
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745880371; cv=none; b=WfexQNg5Kr8T9NxmZjYGvXkJbgZF/rJeZsfKoG7ozCKgZMS96+EG9N5gpLU1GdlVUJzFvbOWOJ8O6RLrYq4QB4tKnJW6uKwuPfvcvUg9NJUNKB8FYMhh8dk5Zakh3D25a6m2j0VqpmCw6f+92bP2CyKx7Bp/f09hfRFf0TQmMSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745880371; c=relaxed/simple;
	bh=jU17GLq6S6yqjF3hN3CTfiSp96XdY27u3/1Fve9LrLs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YxON+1tY/QXTCBm0e7L2PzMZJCYryV+E2uuvF6J0pz8idmTfDX6K/cMwCPtN0wTjJ+rYh/k8nk1Uc5BaYatru+XPtVlFi0G74VeALzzGfBws8Wax8dazGR2b5DSb5Yohj3hjSnFx6ZIW7Se6lOmqJrasdjHQKSCvO0V2iDO2dhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iI5vYC/A; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42D40C4CEEF
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745880371;
	bh=jU17GLq6S6yqjF3hN3CTfiSp96XdY27u3/1Fve9LrLs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=iI5vYC/APzhDqbqWOZ3bpSsmwWQZ7GONju04lYlwMol0culC2RpE7iS2fgn2ByCOt
	 Q0XW0avFApLgpavle43nkhgU83OKNoxUCpwdNm7aoleSWpFn1DOLk0WgsNVgH3XsDG
	 zqzewGz+KvrE1clDPc+vCv36Lj2tUBbwwq/j3PECIIYJmUJbd7N0FV01bL9r1cfUXf
	 SVTJh3ZnMd/ziWd+wCqz/k8P1oYJhXtuK9d1qjHST2yLEU3HokOep6mPcCfo8GRyeA
	 vEVkIxfodX1Kfg7Djr8+g9zNgqSeBle6b3DSFcwDgy5Dn8P2MsXdcgAzrCks6ZgzT0
	 J/5SXFvbGSROw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3A508C4160E; Mon, 28 Apr 2025 22:46:11 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 22:46:10 +0000
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
Message-ID: <bug-220057-28872-X8NnUW52zd@https.bugzilla.kernel.org/>
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

--- Comment #19 from Alex Williamson (alex.williamson@redhat.com) ---
(In reply to Adolfo from comment #16)
>
> Doesn't seam to do anything, no.
>=20
> ----
> cores: 8
> cpu: host,flags=3D+pdpe1gb,phys-bits=3D39
> cpuunits: 200
> efidisk0: local-lvm:vm-200-disk-0,efitype=3D4m,pre-enrolled-keys=3D1,size=
=3D4
> ...

I'm getting that option from here:
https://pve.proxmox.com/wiki/Manual:_qm.conf

Can you find the QEMU command line in ps while the VM is running? ex. `ps a=
ux |
grep qemu`  There should be a difference in the QEMU command line proxmox is
using with the option, and it should at least change the addresses based at
0x380000000000 in the logs.

I think the issue with the failed mappings is that you CPU physical address
width is 46-bits:

Address sizes: 46 bits physical, 48 bits virtual

But the host IOMMU width is 39-bits:

[    0.341856] DMAR: Host address width 39

Therefore the VM is giving the devices an IOVA that cannot be mapped by the
host IOMMU.  I don't know if ultimately that contributes to the issue you're
reporting, but it might.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

