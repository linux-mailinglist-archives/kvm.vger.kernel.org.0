Return-Path: <kvm+bounces-39266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA538A45A95
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:50:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB758172BF4
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:50:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 114A6238172;
	Wed, 26 Feb 2025 09:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uuv/YtZl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C19323814D
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 09:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740563422; cv=none; b=DteUo+pvs4kNH4n+RT7nhtexgsz8GKm4/rHI9+gUqKOdUj8rfth+vnjMn0IOqCwWpoUrq+Cn2Gt4YqLceJD6JA/mmh/51Gf430PhnFbFC5YWMu5h+2wGq1zY/S+nLyROZy6nkciLANduNBUFWLm22niICfhaumMVDR7jJIuh96g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740563422; c=relaxed/simple;
	bh=G83Jwu0nvoM6PGrBR8GYYByw3gSz7rZfi8USNVsZTMA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pD8LXfkfI8N0BEXpC1qY3BhCdw0V3Ayq7DT280PK/W6ZXQcrVxSUw19e+PzcsASGI4cs+xt7kOKk/rb8vBH1F1+aXabVFU6rrL4XV1Phgqrq1+a3RMkWb+KqIv1ZTxAC7xL548K4SyaiJ2r5ZqSS5KqRqUka+PFTPRjsN68YFhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uuv/YtZl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2741C4CEE7
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 09:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740563421;
	bh=G83Jwu0nvoM6PGrBR8GYYByw3gSz7rZfi8USNVsZTMA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Uuv/YtZlu4Ob6bl1SSe7dodAmteNGI67yJBvzFoDocBe1D8FzExhdWM3IMX19johs
	 f+iroWXmNKOz6CDY6bjTdRF0jcNgJZMWXDm0N+pXLpJRtxfrr5Y7rObVZ75sfQJ5D9
	 1WQSC6UnrhnHZZicqidBZucX9a9tNX2vj50gAyMhIoG66HIsPP4Rzn/qWiLxtjO6cO
	 azVNpCB5VHw/QZsXnN9bZGT4SLBs2H9ElelbgPOgU+bwCG145CXIUfqGIpWfbH3Jk8
	 4hwMWHuBOnPsEavs5sVWZ5Sinw8e3xQ403vVeFEr9qAiKQoLg3XUExLDPA7WN3sc5W
	 uA6MyCtenKHGw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A5DE3C3279F; Wed, 26 Feb 2025 09:50:21 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Wed, 26 Feb 2025 09:50:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: chaefeli@angband.ch
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-RaUvhhHo2u@https.bugzilla.kernel.org/>
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

--- Comment #49 from Christian Haefeli (chaefeli@angband.ch) ---
(In reply to Ben Hirlston from comment #48)
> I haven't had issues with this since 6.11 6.12 fixed this for me. for
> context I have an Ryzen 9 7900X3D

Yes you most likely own an affected CPU. This in-kernel change fixes the
stabiliy issue you have encountered but at the cost of performance. And for
people like me, whose CPUs are not affected it is even worse. We lose
performance for just nothing. IMHO the proper way would be if AMD would off=
er
a CPU swap for affected customers.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

