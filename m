Return-Path: <kvm+bounces-18278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 691E58D35A0
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 13:36:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99DA21C22DED
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 11:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A6FF180A90;
	Wed, 29 May 2024 11:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHkvBFF8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6729813DDB1
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 11:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716982537; cv=none; b=TQWHC4QOvCMdbX562lPuV69sDM9Z4ovfXVlV6xUHyprU8aBPlYL9fZlNf0Rtk3VhW4KrkDi/62xhDH3BCWWjPRxREBcu1MKY1WB6S8ShlLROUN5aPMxEVnWsUBw/N5LxPC+4hIBodXP9x9WdTblpW1qO47GfxUBR41MCucYn/sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716982537; c=relaxed/simple;
	bh=PS4K33D0WHcEmTAAI0g6+zGIYghhgTvhlhs3rTomv1c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rkelGzCWER+mXsA8/mQvVe6Z8oQa3SX6MdhICD0w3NY59DVZICUYM53GEJ7nYU5opM89Xe6MOFL+vRngAmKC6JJuSI6ACv9CX8kQCDlxeAwpBejjugss6hd3Bd8Dxi6cF4kQmC8F9wQR5+QwWDWz16lKV5AsV3bpl2v+nwAeSq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHkvBFF8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 040EEC4AF09
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 11:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716982537;
	bh=PS4K33D0WHcEmTAAI0g6+zGIYghhgTvhlhs3rTomv1c=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dHkvBFF8O5aimX8iF462aAvhqEJaQ4FojpZKgF84kpSTX9bYx8Ht/CF80f9IKgrDB
	 jDMtAziHoBl9uq9ULYF8v35Z64fxrxRApqkZh/WTaNFcMMfq9F9kwKH0rCx/2gRlpr
	 +UkO2pCsZKappLfBDnZmlv3Qi2i0z0N9x1wKW9mz+CIjI3yDJGZ2IR/RtsobcOv+09
	 fvjH5LP4xI7RjIccfzja3ttXEHxUUIqAdzCsH0rxy0Z+RTewDHbr4zKbNIT32eniwL
	 1i+42qfFeJ+/Dsc4XmOG6CWUE8Gf3r53Qn3Q2eVEvbu/ceSB6cEvYg3iCeH5N60bVx
	 0OosHk4NPyn2A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id F198BC53BB8; Wed, 29 May 2024 11:35:36 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218876] PCIE device crash when trying to pass through USB PCIe
 Card to virtual machine
Date: Wed, 29 May 2024 11:35:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dan@danalderman.co.uk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218876-28872-BcD5SvU0nn@https.bugzilla.kernel.org/>
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

--- Comment #11 from Dan Alderman (dan@danalderman.co.uk) ---
Just tried with the new card:

02:00.0 USB controller: ASMedia Technology Inc. ASM2142/ASM3142 USB 3.1 Host
Controller

I added it to the VM in virt-manager and I get the same error when I launch=
 it.

[snip]

kernel: pcieport 0000:00:09.0: broken device, retraining non-functional
downstream link at 2.5GT/s

[snip]

vfio-pci 0000:02:00.0: not ready 4095ms after bus reset; waiting

Thanks.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

