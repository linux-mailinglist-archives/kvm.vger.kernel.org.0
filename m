Return-Path: <kvm+bounces-22064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D59319393E0
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 20:51:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 908FD281B14
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 18:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1455F170850;
	Mon, 22 Jul 2024 18:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ONwYK+5Y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0AD16EBF0
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 18:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721674300; cv=none; b=qXBte5IWRP0qZ5sy2GMOO5fdJ/soJ4K8e5zZOkpZtQOjq16XIFt291nq33/TwWbAinseH2VdhA7HvN3WQcPDmreFRgzVo2N1snonDAMXB9+YK43cA078Jw2q9tTQCJf7WmQ/eLTvpFC1zxWSGKKMQIOTzz2pz2boogt52LG7cSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721674300; c=relaxed/simple;
	bh=pRaoj5YOmLUoZ5F9Nfu57Xvcd6KI2/jAQHB/geb0vgU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Fvc33lx0ZRBP9PluUIa6p+me6i6OS3rWKUfIMiHSqxk2DHtHlb/YV6Lo3iO8v0b/LlyjW9yRndPfAL/XN2JIyCr8WZutvSPRyAukXdgCvkhZGHi2NRj7ECQR3FTPWEuqMVYSaHQ5Bx8HBgoLvMmDlxIjNIhMl4Bs2PlKruCUeNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ONwYK+5Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1B10C4AF0D
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 18:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721674299;
	bh=pRaoj5YOmLUoZ5F9Nfu57Xvcd6KI2/jAQHB/geb0vgU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ONwYK+5YbWRlKQQqiHZxpHmWEmoEOrphXSstaU2eYscAwaWVOaVnbb8MKKOcFTo7P
	 IsiTTajGnbpwX6n7oO4nRgr3az173/FdSzElry1PSXbl4+rs6da90qPGvUjZH2u6cv
	 ja8JO4JiMDxHhpGvU1/MtS3a+ij/w2Yjzo+OEJHfoISDdh53Lyr9pGRXvHv1OOAD92
	 C7FQMaqk0jctO0NyQ0FWE+rjETeXc76Kb6X2w+cqp9reh8Gl0mc/z5kvWAcCYVWdVH
	 aK6VbBfYjvhVTowbzpm+3V9zxwDn0fYX9e32ecn3hhL0noUz6mvD4OQasT8japzefa
	 Oh9rBjKybdCyQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B91ACC53BBF; Mon, 22 Jul 2024 18:51:39 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219085] kvm_spurious_fault in L1 when running a nested kvm
 instance on AMD Opteron_G5_qemu L0
Date: Mon, 22 Jul 2024 18:51:39 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ununpta@mailto.plus
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-219085-28872-rkpfI82Xfp@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219085-28872@https.bugzilla.kernel.org/>
References: <bug-219085-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219085

ununpta@mailto.plus changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|                            |6.10.0

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

