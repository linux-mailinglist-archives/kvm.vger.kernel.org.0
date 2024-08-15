Return-Path: <kvm+bounces-24223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 53593952768
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 03:11:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15C6C284AB7
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 01:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80F0118D647;
	Thu, 15 Aug 2024 01:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="An8UQEIN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C2CA35
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 01:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723684263; cv=none; b=BirVWAxUsEeLjVIPKVYrOs1w+XptLPeoXzBnDfMKLCoP/ks7m3wK4v22DXVxo+eOWzgytzPcX1QG93lLpQ0yzGD+8lATMxYUbsez09bAy5Wu6JORkmbQBHtXQgyj1BgMS203zg8ThPheab2uKB5LAJ8CG2NSwGDJFT78PMbTWgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723684263; c=relaxed/simple;
	bh=mOGfFoSXhgWCA9Fm0mRIfcYhWLEvFdY04MTH22U6eCg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s06dT1ZOwBK0tAdu+XfSCJsdW9Z4BAWom2n8dfPR/vhxrRp+UDO3dT3lxilKrHaMQyI+/e+LFhmU8ohqAKvZ6toU8yLRO5daFdd1fLM8Xh759KcoJ5PMlVBr0u9EsehgCnsQCSFhAIw3tc5gxHpop/edLVqhuSTpg1JPG3ycTP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=An8UQEIN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F9DFC4AF16
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 01:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723684263;
	bh=mOGfFoSXhgWCA9Fm0mRIfcYhWLEvFdY04MTH22U6eCg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=An8UQEIN+nc5KbdbO7l0h/K6yoAFdyMuGGAPcf91kjm2yaMq5aCaAk7JHHB8ixRkr
	 Hu4Uull38Slq9oy/Fjgo+mfTNRr2YXUgGhfpwlOK3DTBpjkJXanUvWZQc0Ie8JNdCo
	 wucRbn3XUkxCOFdSaHtoKrYpKbl8ZmkuTK5VaKsGNHjwt1M2T2uFpvLi+BSMJs6HxI
	 oRt7JC7ZTYt0c+F83lhYd7iSSiURb2q+JdW0Lh4eoK0sP72/kdxgpvyWbNyF0Yxhpg
	 PrxtbkQyYSi2k9voPVfIeHAr/OJ3oQ0yMX0Y+RApQpeVR50ir/Og6DkpXlnazZaRat
	 0RSPfl4P0/dvg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 36795C53BB7; Thu, 15 Aug 2024 01:11:03 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219129] virtio net performance degradation between Windows and
 Linux guest in kernel 6.10.3
Date: Thu, 15 Aug 2024 01:11:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rjgolo@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219129-28872-tHJjCLzwwj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219129-28872@https.bugzilla.kernel.org/>
References: <bug-219129-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219129

Raymond Jay Golo (rjgolo@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |rjgolo@gmail.com

--- Comment #9 from Raymond Jay Golo (rjgolo@gmail.com) ---
I can confirm that performance has been restored with 6.10.5 on my Linode
instance. I was wondering why it was suddenly failing to connect to update
servers due to extremely slow downloads or timeouts and now everything is O=
K.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

