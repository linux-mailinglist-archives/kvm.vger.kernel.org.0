Return-Path: <kvm+bounces-6391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63643830788
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 15:04:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A2871C21433
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 14:04:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21DB620312;
	Wed, 17 Jan 2024 14:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TJbDLewz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4722A200DD
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 14:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705500294; cv=none; b=XFxaXKzScrmhYg/gxqEi7K/LbBtAEV7U4SILU+w7DBd3soNfwEu3KMSgVSloHjMx0lwYzYN27dyixLbFiZeHZ3xR4qijpUZ+wo6ry1O8FDG/hXm3KGzsyYdqkRL++DnBFTypTolWnbGtop5EHtgSp7HAtdyctdeloLk0vZV0v5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705500294; c=relaxed/simple;
	bh=fOKrHUGu8kLnE4tSTOiVzAgIRoXkUzEACT6PQCzj4yQ=;
	h=Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-Bugzilla-URL:Auto-Submitted:
	 MIME-Version; b=WVxxeUOMe1bEP4c4VzAVGD3nMC+HCP5FiSc8Urou8Z+MPmyUvmDqN+rg37B2Yr0Dq6Jd0AXmFH2SLB4i8P3FYs34brqaMY3zFIsH4JwvbGCASLHKIJp3LQ/U3XvklfDBJq0xiB4ev5RL8ZrWjVdt5aDQy9UwwnE6wEJXqdPO6+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TJbDLewz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id C185CC43399
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 14:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705500293;
	bh=fOKrHUGu8kLnE4tSTOiVzAgIRoXkUzEACT6PQCzj4yQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=TJbDLewzMO3pregGIW2Qkdch8cesUCzW4zntA48vjJWggPhqebu8UgQPq8gEO9G3I
	 1kuyPexHL4nqg7oL+6Tv200DbnrAxMTA2InOcHRhnDkEQYblI73e2TVuHHw/A+rne9
	 nv1nQ1Y2qWCVbkOjJLgekbIQprIdDrnc2IgJnY2H/LEeDA2x51ksSekDyOV108dIBn
	 fLImlqIp5zM0i/t4aKVqLzNkX9TckYVSBpBnSxILikeI+bN9ldyVkyuzxQ5imBeHj1
	 mHh9L6Qapyb0La9/X5pUC6Y0u9wynC5We0YPV2M96sLcb3Z6NKMEy3Y7mZhGdRM+ut
	 ANwpyH2JswgcQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id ABB4FC53BC6; Wed, 17 Jan 2024 14:04:53 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218259] High latency in KVM guests
Date: Wed, 17 Jan 2024 14:04:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: f.weber@proxmox.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218259-28872-1bq9x6eX7E@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218259-28872@https.bugzilla.kernel.org/>
References: <bug-218259-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218259

Friedrich Weber (f.weber@proxmox.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |f.weber@proxmox.com

--- Comment #11 from Friedrich Weber (f.weber@proxmox.com) ---
For the record: I was seeing a variant of this issue in combination with KS=
M,
see [1] for more details and reproducer.

[1]
https://lore.kernel.org/kvm/832697b9-3652-422d-a019-8c0574a188ac@proxmox.co=
m/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

