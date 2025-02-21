Return-Path: <kvm+bounces-38823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A55A3EA0D
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 02:31:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF03817FF63
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 01:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 972EF1420DD;
	Fri, 21 Feb 2025 01:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CHb0oMms"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16228F6C
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 01:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740101468; cv=none; b=bULyaXvIRvgXo74hP2DRc5Ta82rmdz4ulJ/ooPZL8awzPXgrhsWMehz2sI0Guk0PPx4qO3UBtnXa7DYXx2y1vRZAZfmyBH81v7o+S+WkKsjSfpnIyN1Ljp8WE1pS1WSqWKuBSqtVMes60POXNy6L5KeH/BZJZbN38DaaIHEigio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740101468; c=relaxed/simple;
	bh=EDBR5XVj3GwwceBn9RBEkum5pEdDL8ZaNVMBQhH/1Zs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=is3YSe80dQ4CLQZu0emttimmQM+XnenBWoR+SqxWAKDmgs1kALJL21WCZRN/QEc1GbO3kr/3qgZ5iyxX/Y4375AEOfurIRDp2iPIKB7vUoCyKYfSsJmUg3mDBBwMmLAFFWoPPZ62iv3itAhH5LsdJXgVKtFvIhXRKNQ/aVSIT4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CHb0oMms; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F129C4CEE6
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 01:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740101468;
	bh=EDBR5XVj3GwwceBn9RBEkum5pEdDL8ZaNVMBQhH/1Zs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CHb0oMms1kZRRZ0MhmKiIVySw5hDPEV4G/wxyCe7Uay498AalkDZ0DEMlue5A3SD8
	 9ShO0YFaGyYDgfbbQGmXrAr0eIYFEP3V0XMRTkMdR4TY9nN9+8Bu7x7fb2juEpM0tu
	 pnT30MgsEkDS7bJiOaVI0nh8rGD/TUt35/u6ZBADN/dR6NBItevyvBDUzvyFSjreqY
	 i5wF/Rsoid/mCXxdpeTzBBgW9wI3w0vMzBQ2uE9cKs1PMInQKZV1SkGtCZ2HX1LUhR
	 JgKmZQ+YeaFwa/kG4OWqBRhIIenGLp+W/tmDpu8//dTZgy7VKUre5MH1IvVz0Q42VF
	 7MH/aN+CxWI/w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 95862C3279F; Fri, 21 Feb 2025 01:31:08 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Fri, 21 Feb 2025 01:31:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: rangemachine@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-219787-28872-JbcMqcTKTm@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219787-28872@https.bugzilla.kernel.org/>
References: <bug-219787-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219787

--- Comment #9 from rangemachine@gmail.com ---
Created attachment 307690
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D307690&action=3Dedit
bisection-log

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

