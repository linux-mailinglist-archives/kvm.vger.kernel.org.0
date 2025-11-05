Return-Path: <kvm+bounces-62034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EF9BBC336F0
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 01:03:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 77BFC34DEB9
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 00:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 181B11B87F2;
	Wed,  5 Nov 2025 00:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6nDeiTH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AC119E7E2
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 00:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762300983; cv=none; b=u6idEhVQIfPSonssdaA3qVxbA2b2KI3G7RUzw7Qn2/1qLPs0Dahd2QNtgVlRmBOcEnWaUEcdkAJp9Yh3pQpQtsUVOJbt2vmFR6zBAyfJe8QkhD30AZXb5vRqn5zTKJRj9+HxmO7OJ8gTZp6av/fKqGClCar4srbRtYoVIiNPaSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762300983; c=relaxed/simple;
	bh=mw/JkC7Rw+9eec8IbwLymvX1pCZY7TXzkGMdhZgmVPM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mF2BYi1At2DrdwVvg+QQ3CBy75TfK8eRvUzksYvTYl9tdJcbtibzTadYgbNeSoGemJ7W6GKTYPplcPFz531f01NewvnJWBuGkYE58C6A7Efq3cZguSgT8nSqYqIFoUr+DDTfo23YGpn4hfh/2Nzrz1dXI5HBPPw1uqaK0x1aCog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6nDeiTH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B0EBC4CEF8
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 00:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762300983;
	bh=mw/JkC7Rw+9eec8IbwLymvX1pCZY7TXzkGMdhZgmVPM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=f6nDeiTH8vOEzwiJljzzLoZHv2DplpOOwefQeCHu+cgNqb2NEetbn66Ug6pGjRtxT
	 kaYAdu8m4jIObPYTusEWLlVMiP3r0817O9qHROxD9UnCOEQ9xl4VjOpgqWCpkXfxTD
	 GuaYrOzTd8YXCzBKJbzfmRvpQTn6mm5poRs3NhzArhQzgsg9COiVwJgR3Toq2Vxav0
	 ECUB83Yng//ZQ6pmXAmK2clXOyU4Bvs6vM9YHf59D3rLpkT6uZRccaSSgfNu2aD+Oa
	 FNqH/Np/mL3Zl/gjyyA4DkbfyTHIYVIf6ez5JaXTDVpDuCezged7Vcmg+dPIk9XjSS
	 iFaI9u8BDyyMA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 13CB1C41612; Wed,  5 Nov 2025 00:03:03 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220740] Host crash when do PF passthrough to KVM guest with
 some devices
Date: Wed, 05 Nov 2025 00:03:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: alex.l.williamson@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220740-28872-OFut6o5vJZ@https.bugzilla.kernel.org/>
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

--- Comment #5 from Alex Williamson (alex.l.williamson@gmail.com) ---
I have an X710, but not a system that can reproduce the issue.

Also I need to correct my previous statement after untangling the headers.=
=20
This commit did introduce 8-byte access support for archs including x86_64
where they don't otherwise defined a ioread/write64 support.  This access u=
ses
readq/writeq, where previously we'd use pairs or readl/writel.  The expecta=
tion
is that we're more closely matching the access by the guest.

I'm curious how we're getting into this code for an X710 though, mine shows
BARs as:

03:00.0 Ethernet controller: Intel Corporation Ethernet Controller X710 for
10GbE SFP+ (rev 01)
        Region 0: Memory at 380000000000 (64-bit, prefetchable) [size=3D8M]
        Region 3: Memory at 380001800000 (64-bit, prefetchable) [size=3D32K]

Those would typically be mapped directly into the KVM address space and not
fault through QEMU to trigger access through this code.  The MSI-X capabili=
ty
lands in BAR3:

        Capabilities: [70] MSI-X: Enable- Count=3D129 Masked-
                Vector table: BAR=3D3 offset=3D00000000
                PBA: BAR=3D3 offset=3D00001000

Ideally the device follows the PCIe recommendation not to place registers in
the same page as the vector and pba tables, not doing so could cause this
access though.  If it were such an access, QEMU could virtualize the MSI-X
tables on a different BAR with the option x-msix-relocation=3Dbar5 (or bar2=
).

If QEMU were using x-no-mmap=3Don then we could expect this code would be u=
sed,
but that's not specified in the example.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

