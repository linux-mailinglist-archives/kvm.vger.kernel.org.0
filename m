Return-Path: <kvm+bounces-14120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95A7889F8D8
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 15:53:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28FFA1F31F18
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 13:53:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA720177984;
	Wed, 10 Apr 2024 13:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XMCEm+MQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AFB15FA8B
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 13:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712756577; cv=none; b=AVOjP8iCy8qIFZXjxTRsDeS18r73Vs3oXMsOGrjtB5SNCTDcpYkaPoVbV4n0ekJlUakb50kVSlZerLLwsKLAoV9HAo3DoXTw/VHyGQvAM2qxHqTl/D5hIIjCprvJnQJU0npUsQuu5/tTJ7yl9mhVQSrn/Dka4N4Tb74uLp8wru0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712756577; c=relaxed/simple;
	bh=7P7fe6SD/3YHfk5ywPqY+ltR+lR3u7XYrtywd235yak=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FkfIOTKfAKKbqq1DJxyQOoneT20TCk9PVEGLMN3wmU8zVCQddYakDQn4Av0Lbozd/xqpYa1Pyr1zftZY7UaEjISO0S7yfbc/Zi8qDWo45vYukVT3WRnHpwUx2Ga1Op06XXbACXi2tmwWTbUl4RSNItrJ56bpow6XPa+i17RNxfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XMCEm+MQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94227C43394
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 13:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712756576;
	bh=7P7fe6SD/3YHfk5ywPqY+ltR+lR3u7XYrtywd235yak=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XMCEm+MQiSDza++Z7sl9SyP6VxEyKvHkAuvZ1Jsj1AjnZhZCep7trCh85TJ0WmRZ5
	 y1um/fCXa2PMTGibLpCADC0WWvWPS4UYuQ4p1NVEXQtXIJm4gH1rDuZTMFoH9An3iU
	 rqdy26qgBOpStZCGRoM872T5zLW6cBdZQYvga2yjFq2WbZ0d9P4mkDu0fm97QlLs3L
	 FFzljkzQ0aAumTuXg2zpSlA5x9tOo8cAN++9E9dJlYLYlEvxkxTkqKTi6RDjpUkrdM
	 /GvG5PKSmuIwxVehuarfoHulmJRD8eVucEgk9b247G3c822oXSTKSS4/Z9ubwdB43f
	 +tJQwSyv2Y4pw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8788EC53BDB; Wed, 10 Apr 2024 13:42:56 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218698] Kernel panic on adding vCPU to guest in Linux 6.9-rc2
Date: Wed, 10 Apr 2024 13:42:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218698-28872-shQ4S73JSY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218698-28872@https.bugzilla.kernel.org/>
References: <bug-218698-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218698

--- Comment #3 from The Linux kernel's regression tracker (Thorsten Leemhui=
s) (regressions@leemhuis.info) ---
Like fixed in rc4, see https://lore.kernel.org/all/87bk6h49tq.ffs@tglx/

Side note: Artem reassigned this to Virtualization, I don't think that was
wise, but whatever, I don't care bout bugzilla.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

