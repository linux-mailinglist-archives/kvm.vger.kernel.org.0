Return-Path: <kvm+bounces-21237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 950D692C4FF
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 22:49:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C630D1C21CC7
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 20:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 045871534FB;
	Tue,  9 Jul 2024 20:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CiNJmiJW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287ED146D74
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 20:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720558155; cv=none; b=UP4E1PVDj+F3DWtXgqUuyjDtCzAehRYBh/s7T003tICNP0IlpHidJ5R25CHEUf0zEB2405OqHqBtSB3Hoiwrl7K9cAIP2DtxrIbDoyK64T+d2KQuWIhr85hbPXXDVjtWDpX4s7F6eGP8HiMM2Enwn1RmYHV1yQUuRFn6i2IosXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720558155; c=relaxed/simple;
	bh=ld7RMSVq7cBj3Cd4euTER599d3SkITMTxakvvPo/QEE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LeIZ/wmA/5HLH/3/sLKOC/eK/HLfx1xnXpFJMaBEAeTiX4i/Z+6w35TZn9OujjOO7f4A/Q9aITPrmNE3HJNkmwyK5rpb4GVKfiOFYY2CNNRWcXPmnD+PWSWuN4xZEtuq0uwMnRraXe27Spc7OE1PCd/mJb5R9I/gTfk7ICIDRbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CiNJmiJW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0385C4AF0C
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 20:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720558154;
	bh=ld7RMSVq7cBj3Cd4euTER599d3SkITMTxakvvPo/QEE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CiNJmiJWGeyAxn7nqKhiAf/uLXCBN7g/7+UgMZx++OUPbhumsuQEJwzNHm6cUd+Jp
	 UFtIyiAgErJnE2Eed2xV91xS3I+5eP30XdETB3bY0DsyHlFYKmKwv1FwC8yc5549ZW
	 vLU+FqWZmIlgDHWJSU7wr/2XT5j6Ac8flasJ8NW3jN2BP7dqO+Jc7vLEprKGOjCrMk
	 uSliLoWKGMyjw/rY4M585ViNgl8evJUurB0P8CkSEOZ/yGjgNp7MBfQa9YklQ7PUzB
	 ax1+GiKQDZifH15tRM9EyGomyBIMmrN6A0715kCpkNjgHqL1zg0dcXdRslDDy+Fan+
	 EABUp/jYSaJRg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A6F76C53B7E; Tue,  9 Jul 2024 20:49:14 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219010] [REGRESSION][VFIO] kernel 6.9.7 causing qemu crash
 because of "Collect hot-reset devices to local buffer"
Date: Tue, 09 Jul 2024 20:49:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zaltys@natrix.lt
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219010-28872-K77I1WzEsi@https.bugzilla.kernel.org/>
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

--- Comment #5 from =C5=BDilvinas =C5=BDaltiena (zaltys@natrix.lt) ---
(In reply to Liu, Yi L from comment #3)
> It appears that the count is used without init.. And it does not happen
> with other devices as they have FLR, hence does not trigger the hotreset
> info path. Please try below patch to see if it works.
>=20

Patch fixes the problem on my system.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

