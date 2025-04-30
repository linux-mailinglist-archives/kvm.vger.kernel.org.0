Return-Path: <kvm+bounces-44841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E4F2AA3FB4
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 02:44:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F3DA188B9DE
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 00:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDF3BA921;
	Wed, 30 Apr 2025 00:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPUWrRPl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0011263B9
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 00:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745973667; cv=none; b=Bxv7Y6XPp4G13mf1o7GY0c1RcK0Icjmhf3C32ufKIgRVw2lAMfrE5xK5iCETMeyTaIA0WcdH+1a0KdUd0Q8VHH3VWOYkrHtJLjnIOJk/Tob3tlc95nknG0c47WX6C76SpWUy/1ToFtKQffq6PcpoDB8Gjz4ebnN9GaUK2PiTeLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745973667; c=relaxed/simple;
	bh=qIqOtOVb8bEN3h7hbFQvnbaUahgdntKI763sbtfD9wU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GLscMf3zypWQT9wMkonR5Y8Ui/a3ZwbmLXEKYoym7Hk7liOoGUZg40JLfN/4sLVhWFEmyKArM7c2aeYlHW+2SFWHwFQczqNAikkuJMKh3E/DVJzVIv27upwSTV7ZuT52rarwENPONmMz3/w2I1Fe6wLtQIR2f4Z++z+hz7qx8t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZPUWrRPl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5750CC4CEED
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 00:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745973666;
	bh=qIqOtOVb8bEN3h7hbFQvnbaUahgdntKI763sbtfD9wU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZPUWrRPli/nNeHHRYMfGsWZKrXovV7tcdGm7xMe4MXKP2FqtqRSxLbkMffC5YsSoW
	 9qA7S6cvL1FRX1ns6sKV1yJDMN4H77oEqxKZVdf9dPeJnfuBOEgQj8ySTRd91XRMOw
	 WRre2ZhL6JfXq3BO1Knenqr+IagFDkf+raXWWJLNaw5ESV1uKeDJABDp3l3Z8Pi8UP
	 +CDmbc9jgunYK/IAzUGYBzHMn+zeTS57hS8qt19T8D/g3np3mNuGNJ68mZTRDJd8tK
	 rHcezIZg4/bqVeA043mltim1zx6B9tydLsXPbuiakkny+sd0itOAKtTtDNCu35Qqbi
	 ypPq23IT82+ag==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 49192C3279F; Wed, 30 Apr 2025 00:41:06 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Wed, 30 Apr 2025 00:41:05 +0000
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
Message-ID: <bug-220057-28872-sBeZbwbt6s@https.bugzilla.kernel.org/>
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

--- Comment #36 from Alex Williamson (alex.williamson@redhat.com) ---
Please make sure the vfio-pci module is already loaded before issuing the
dynamic debug command, I fought with this some myself, ie. modprobe vfio-pc=
i.=20
There should be vfio_pci_mmap_huge_fault lines in the log.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

