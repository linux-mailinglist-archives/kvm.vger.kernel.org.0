Return-Path: <kvm+bounces-25632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55A5D96730F
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 20:58:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE0FB1F2234A
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 18:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CE3414C5A9;
	Sat, 31 Aug 2024 18:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K2iC+i7x"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4704C1CD0C
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 18:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725130688; cv=none; b=JMIwsqomKEFCINLE7JzRqjgyAtnRshFmpN5HQJSNkuWFiitlPRsjU1rzIBnD4qLcSgHRiDCDBZ7D7g38jlQpZs0+WFWCy3tnFJgAFaK+l3FR5MWmue8g2XN9ubS0E4ICS9FRg9gqDPE0zDR+P/Kkw1pb9+y+HKPFsF1VjDJOlK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725130688; c=relaxed/simple;
	bh=TQ7ScrkNWPA8AieQ4UjOk59HM8F3XCQcyGIz2uuyF9k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=png5SmSLKwocSuXr3NkySiNraMBYU+oBOqVTgzmhNOJ0LbgR2i9jrGg2Q0HlQIvDHgSpmdJLGhrg3XCSGAckgW8Kcb9wmLJ+YXkqNa+Lt2rZgAs8PNzeWpRXtY34Zyg0eErKGGb4Tb4l0lV//dO1dWrbUcBeS0C3ctw13wEzCG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K2iC+i7x; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA810C4CECC
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 18:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725130687;
	bh=TQ7ScrkNWPA8AieQ4UjOk59HM8F3XCQcyGIz2uuyF9k=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=K2iC+i7x+obwEXDfILCXmxzgRAueX75fUkXCFBdgpS1XwGfFjnMI2EA0moUNZXOZe
	 1dgQulby4F9tr8R9gAd4gjwQs1UOY9D/849y0zKuuGw5z/g9EXTY6peqYf6Tx03o8F
	 8WHyF3OaAtsWeQHWxOq8mUKaIpDOkmuSyvw/8krPvLiIyWef8Oa91baUkC2Kg7vw5P
	 jz0T2OB5t/0czjINCAh5WKyxyfw6sa4TYDqFp6cleYuvgDi+60Q4tqxIx0kA7+cXgi
	 A2Ah3qZlwTFjqzt2DU45W+eby8/3axA42JRdjrLtoEICVz54iDTNMLz8/xozs2Dse6
	 wRLTyp+rizyBw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B58E0C53BB9; Sat, 31 Aug 2024 18:58:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Sat, 31 Aug 2024 18:58:07 +0000
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
Message-ID: <bug-219009-28872-4yh5e9i0hC@https.bugzilla.kernel.org/>
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

--- Comment #15 from Ben Hirlston (ozonehelix@gmail.com) ---
the kernel I am running for reference is 6.10.6-zen1-1-zen and I have a Ryz=
en 9
7900X3D

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

