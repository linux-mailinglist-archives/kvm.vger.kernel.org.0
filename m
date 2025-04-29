Return-Path: <kvm+bounces-44711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E816AA03CC
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:54:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F93F462D42
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11E82274FF8;
	Tue, 29 Apr 2025 06:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yl0z9Ed7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3271024EAB3
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 06:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745909664; cv=none; b=ca8Do/9MfQmJnbneCzsKxZnL8H7hi7ZrVMc6ARKyvTc+QNvYXH2gCyy1tYq1UwRzXmidQiF63hLYEE9TZREyJ2A0fDSNlbqgJnsXgfSxiM4f3ArEcgMLOVT8AB8a1U1W7seM77aSwDnncOds+8IZCeqT4yCI4nc9NUscYTgLnCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745909664; c=relaxed/simple;
	bh=u3XkUrRfQKxZfoqKhudp7vzJTR4vV2gfy8WtgO4y2DI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SUhsEttvvsTmGk39nRHFii2z6Ni60z+m+gJ4QAmF92fSYOBEzbazgXmh50LG12dE38MspcrLNqEasSJQ5tE72JSEmHtgrMinyH9EbYPOu+KvZGTX/YzgGcuXstLigw9wAk6wuXFxqkcpgbokmeHJAe21k1ptUKfYzkzwOCsPtkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yl0z9Ed7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9FC5EC4CEE3
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 06:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745909663;
	bh=u3XkUrRfQKxZfoqKhudp7vzJTR4vV2gfy8WtgO4y2DI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Yl0z9Ed7MVzqiT1GrRNlIsSdkMDCbBxtY1eL7IS4rVOxweT2231q7u0Ea4DqpirdM
	 FZVh3HzE/zq+B0oNLJvJs4iddpRxUeuOiOZryVvQLRu6SetNY14tQikjhM2N0xsG+u
	 SRRmDziRxJnqRAoKXMcDopolrHJmtGQp9jeCJXHt2NH1buAokqKovX9rO9z41EPJSN
	 FYA4c9+qvNU1SNK3D9W3bihhtJqDvnLSFOyzohYJ4kdeCN+aJJOCL6alYY12tZqFtu
	 aczAXhI6pNC09usOSFSSkBhT7j55KkI6JhA5nW2jaT/Th5l4Rd592so7v47eTnk/y7
	 aVcrwywBQx5xQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 86442C433E1; Tue, 29 Apr 2025 06:54:23 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Tue, 29 Apr 2025 06:54:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: f.gruenbichler@proxmox.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-220057-28872-1YXGqXpycs@https.bugzilla.kernel.org/>
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

Fabian Gr=C3=BCnbichler (f.gruenbichler@proxmox.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |f.gruenbichler@proxmox.com

--- Comment #21 from Fabian Gr=C3=BCnbichler (f.gruenbichler@proxmox.com) -=
--
FWIW, you can get the full QEMU commandline for a given VM on PVE with "qm
showcmd XXX --pretty". you can also use this to verify whether config chang=
es
have the desired effect ;)

our kernels are based on Ubuntu's, but since it seems you can also reproduce
the issue with a plain upstream kernel, I'll not go into too much detail ab=
out
that, unless you want me to.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

