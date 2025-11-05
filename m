Return-Path: <kvm+bounces-62041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78323C33EB7
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 05:06:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF3AE189C8DF
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 04:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 853551F4262;
	Wed,  5 Nov 2025 04:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RwWYtfnD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E5D1F75A6
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 04:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762315574; cv=none; b=SXeWM8KCbgoJKBMijxVNv9r/11CBH7f1F8xhjQMQwPy2TFMcggOhETsPunm24YF2qOiTN12xCDfKrEEgGnS1s36U/XSyLQSBltsnHo042GVR0xNTG86dza2Y3pWkka8RVscOgwyaYU1kDEG89E+wjjwFp07SB/KDhA8E4+zEJmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762315574; c=relaxed/simple;
	bh=lILX7SIVIK5X4ToxPZotSkKk0ogsIy/SL4ZSUC7s1Mo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Kfdsa6CW3MH3laoX5eLmAnjdHKyqYYY+2CsHw63lg1EFNi8MTM88f4nASgpfro6mINV9abnV4/yEziIM95ujkpkAeLqK6Nc4zya7g7dMs5mFkfRZsIawwbLXeRE7tGTIU6cn6boYPmZ5SPyLLENovtikbNq+SW+v08umJPSbLBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RwWYtfnD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A908C19422
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 04:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762315574;
	bh=lILX7SIVIK5X4ToxPZotSkKk0ogsIy/SL4ZSUC7s1Mo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=RwWYtfnDBQqBZ2xMS5XIqyvFVaIm+k0pCthMu2KwcNuXduZLCdUj4p8uQeUyLErbp
	 fkOXhMmC+CNJb4Y/R+nnaUS9WQWNKEigl68RxPGN+UDogGJkVaBLZxeZn6NbL5joXo
	 sfjwAPJoA7V5ON7tljbpQgDsrxIT9diQj4CQh39yfnJ9yWt8zAgSNDe/ZBm6WTK08q
	 AO07EBxSEuVHyNbQkMJcj3pZPTu/wIymUyQUpcqRUVxVjjAK8KIcal/0Kfi8PAK/0H
	 iMTCUiCLq/gVZ8BqlTaS4alusVVdmdHCWQUKAH/Q+VGTHm05TLhvYpedPQfek7BhYe
	 nRjfBWshxkRKQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 23CFEC41613; Wed,  5 Nov 2025 04:06:14 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220740] Host crash when do PF passthrough to KVM guest with
 some devices
Date: Wed, 05 Nov 2025 04:06:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220740-28872-7l93hq0yr0@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220740-28872@https.bugzilla.kernel.org/>
References: <bug-220740-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220740

--- Comment #6 from Chen, Fan (farrah.chen@intel.com) ---
(In reply to Alex Williamson from comment #5)
> I have an X710, but not a system that can reproduce the issue.
>=20
> Also I need to correct my previous statement after untangling the headers=
.=20
> This commit did introduce 8-byte access support for archs including x86_64
> where they don't otherwise defined a ioread/write64 support.  This access
> uses readq/writeq, where previously we'd use pairs or readl/writel.  The
> expectation is that we're more closely matching the access by the guest.
>=20
> I'm curious how we're getting into this code for an X710 though, mine sho=
ws
> BARs as:
>=20
> 03:00.0 Ethernet controller: Intel Corporation Ethernet Controller X710 f=
or
> 10GbE SFP+ (rev 01)
>         Region 0: Memory at 380000000000 (64-bit, prefetchable) [size=3D8=
M]
>         Region 3: Memory at 380001800000 (64-bit, prefetchable) [size=3D3=
2K]
>=20
> Those would typically be mapped directly into the KVM address space and n=
ot
> fault through QEMU to trigger access through this code.  The MSI-X
> capability lands in BAR3:
>=20
>         Capabilities: [70] MSI-X: Enable- Count=3D129 Masked-
>                 Vector table: BAR=3D3 offset=3D00000000
>                 PBA: BAR=3D3 offset=3D00001000
>=20

Not sure if it is related, but on my systems, different from yours, the MSI=
-X
capability is "Enable+":
        Capabilities: [70] MSI-X: Enable+ Count=3D129 Masked-
                Vector table: BAR=3D3 offset=3D00000000
                PBA: BAR=3D3 offset=3D00001000

And if without this commit(reset to previous commit), I can passthrough X710
successfully with below log in host dmesg:
gnr-sp-2s-605 login: [  129.819630] i40e 0000:b8:00.0: i40e_ptp_stop: remov=
ed
PHC on ens26f0np0
[  143.509906] vfio-pci 0000:b8:00.0: resetting
[  143.619051] vfio-pci 0000:b8:00.0: reset done
[  143.624135] vfio-pci 0000:b8:00.0: Masking broken INTx support
[  143.669167] vfio-pci 0000:b8:00.0: resetting
[  143.779059] vfio-pci 0000:b8:00.0: reset done
[  144.392971] vfio-pci 0000:b8:00.0: vfio_bar_restore: reset recovery -
restoring BARs


> Ideally the device follows the PCIe recommendation not to place registers=
 in
> the same page as the vector and pba tables, not doing so could cause this
> access though.  If it were such an access, QEMU could virtualize the MSI-X
> tables on a different BAR with the option x-msix-relocation=3Dbar5 (or ba=
r2).
>=20
> If QEMU were using x-no-mmap=3Don then we could expect this code would be
> used, but that's not specified in the example.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

