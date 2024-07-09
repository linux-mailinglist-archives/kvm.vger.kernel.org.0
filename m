Return-Path: <kvm+bounces-21204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3520C92BCCE
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 16:24:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3C01280B91
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 14:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A8E418FC6E;
	Tue,  9 Jul 2024 14:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uvOo2+a5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9633132112
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 14:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720535062; cv=none; b=Ni11o1CVUh7W8PpjkYKwvBB9LRbv4FHXuOH86jdVsItzfAXofAn37sX9SBu76Ka3tx5NEDWT/AynTlE2IFyPTELPhO5Z6SHWCPac23r0Od8RLOQsRFn6tgjZE7J5T2Zi54hf6Uwvmplh9+DYaOyBYteJvAErVs1nINXO5OZrwvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720535062; c=relaxed/simple;
	bh=4jcXth86ZQwInF0KDKB92335h2AtCh+ywa8o7uBO2/s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LDyoY2y+sFHt/UwbV+5qAPcAXfkSu0kGoLAxShPxCpaixOqVZ9ghdyJu7920Nqh1uCeeGcnNgwPdagDTxhCq9W4itE+fiEsFOmJ3UEmvVZF83btVxaMi5eHe7JW6YdggoFGxNoBo+kRe/8wT10aAuAiy/plsrpjoZ1OdmG6UXQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uvOo2+a5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92333C4AF1C
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 14:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720535062;
	bh=4jcXth86ZQwInF0KDKB92335h2AtCh+ywa8o7uBO2/s=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=uvOo2+a5qb60hUpe9wROqFJASUAledh8btbLQlmFoctS7hgbGVhnWSrex6u7K0MXF
	 +pGX7Ky9ljmHNGzvKQW3Lqno5vNcD+CNTjCoM5cmJy9YXrsY91AMCVSQmRaqwJt/EW
	 zCvc9yR7PNU0R4MBibwKBr+8Ghy1r/PQxgPJalB2LeHlWQ32zIFSWRsusOzTsbm3QW
	 9ZDZqZHWJalObgCYa+UmVC9B8qpCBDXRNJQCvar/cjf9w7NGs7hilC1u1erlCkB1WY
	 TjZSy5Q3AktxsToZOTr1XPnQCYlS33WN9A9vTkWGv8bASSPdNsN5aPkZICMoCOuf92
	 mVk24FZ0E+4Cw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8A5A3C433E5; Tue,  9 Jul 2024 14:24:22 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219010] [REGRESSION][VFIO] kernel 6.9.7 causing qemu crash
 because of "Collect hot-reset devices to local buffer"
Date: Tue, 09 Jul 2024 14:24:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: beldzhang@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219010-28872-CHuAQWDN5a@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219010-28872@https.bugzilla.kernel.org/>
References: <bug-219010-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219010

Beld Zhang (beldzhang@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |beldzhang@gmail.com

--- Comment #4 from Beld Zhang (beldzhang@gmail.com) ---
after manual modify source code:
testing pass, that crash is not occurs again.

nv 3060ti on dell precision T7920
kernel 6.6.38
qemu 8.2.4

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

