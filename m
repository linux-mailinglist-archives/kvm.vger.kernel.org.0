Return-Path: <kvm+bounces-24872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 761D195C6B0
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 09:38:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3191C2860D4
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 07:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D83F13D610;
	Fri, 23 Aug 2024 07:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MaOafHKw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A436813D521
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 07:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724398652; cv=none; b=O5V5jb+X2zaxLmOKUEAiINOon/eWpPI1NxQJdkbc108Tl4EpPWtsv95uF/CMERWGcEHmynD39+psiIr+0KdPxJj+cIQ2p+xj1r7TIGs+mgznQk23ScuZtaZPei9BsdKSEIChRhUVvCr7vlauo7AvpyTwydpxm86Fv1033tJ9ygM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724398652; c=relaxed/simple;
	bh=iewNyCaHY0gX6CX7O07F/JdOT+ugWH0EOnC0ugBJpJ0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P8uVqAXIdwov0QSSo4r4lkeujwi+szMOIsD9kk3Vs0JicLCJXMd5T4FYi3LdmROkJEYPKiIx5/emtmGXWmnDGiUrGhb1HYzSZI6NOXWsDXCcR2Dn5t7GcP/nmjAKZy04DlUAU465Jptd4UB1ZMwIQv5ObvcOSooX1hpC47Dqun8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MaOafHKw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C8C1C4AF12
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 07:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724398652;
	bh=iewNyCaHY0gX6CX7O07F/JdOT+ugWH0EOnC0ugBJpJ0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MaOafHKwPf9be02FhrnqPAcjmr4L3s/F02evQtj7Upg6MLWJC8rY99BGF81/iMxjY
	 cnAIJaMweOaZ2qLK89ibXi0uQ+p+Nx/vweinadqjRrIRqnDh1clMm/G7lQfJtYvTdf
	 SAZyh6Hx8nFuDDbOsTIr5XUII+PON6bnoXEZcYvI62lNhPRV1ZTvGzwRAGn7FabqNd
	 Tocm07r4vTX3D0q7xkvObLIrl2I19Hnn7dv4WroUrcuacIdf6gduWszzVPkyUO8Rgj
	 ymKKGk7AtZut89z1MrfJ/S3WRJMXSiUBIS+kwTt8k122jeNm3EFAx1QPM6i3+yTt5g
	 fswXyuuXU4zyw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 45465C53B7E; Fri, 23 Aug 2024 07:37:32 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Fri, 23 Aug 2024 07:37:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ozonehelix@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-lBpDRJwesQ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219009-28872@https.bugzilla.kernel.org/>
References: <bug-219009-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219009

--- Comment #3 from Ben Hirlston (ozonehelix@gmail.com) ---
(In reply to Ben Hirlston from comment #2)
> I can confirm on my Ryzen 9 7900X30 system disabling aspm helps. kind of
> relieved this is a bug. I was having this issue on my Ryzen 7 5700G system
> but to a lessor extent and it got worse when I upgraded to Ryzen 7000 ser=
ies

there is a typo I meant 7900X3D sorry about that

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

