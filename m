Return-Path: <kvm+bounces-27855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5864E98F4ED
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 19:14:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A1EB1C211CE
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 17:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C630E1A7AE3;
	Thu,  3 Oct 2024 17:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CA9I3OoE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6801A7271
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 17:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727975640; cv=none; b=HExYGKCxAUOPzbvclSMFdKweXYkeOzjzJb2NqoseTf8lsF5osUIiN8m/y4TMkHK9wanRyiLWsRO+XBlUGO+wpXSgS5Ie7Z2GteORmheouyd8AiugprfjUpffXDpFX0BtvJyDf+e8fRIj/8FPprtt1Gw6IA4h4Dq0csLHxgDGIbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727975640; c=relaxed/simple;
	bh=NUitEZMIuZKYuKyP1zGGCR40XD4UeK6mFsEZXJFaihQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qxNjvZoT0XRYFIkN/FZ/o2bisKRAQs5bNl2c5GWrxsotbnTy+EQHQwK0RtZ5lYaLmU34BZbddVWwzvaBzcfd5Yr1btbLF9Q6D79QXzhDabTr6RcQsf3A6sSTLdRB0ukih6SLbi5yofATjoDHy/J9qlLcKO3UpTXG9mgZBS8oqQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CA9I3OoE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92BC8C4CED4
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 17:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727975639;
	bh=NUitEZMIuZKYuKyP1zGGCR40XD4UeK6mFsEZXJFaihQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CA9I3OoEDbP7KlPMueUG/qyPH2sobBMMMEsElazUZ9i+Hd8/CJ/LpAyvyJRzq9o94
	 LPbTHT+kyqrqRk57E2VpzQImN1pStPfr197gHx32lXwQrmwImBqrKv8bel7i7ixygD
	 purYQKtwF5XvBM0qe/chJsRTlZVB8Q5cFJBrHvJseoD6qH/f5YUI+7WVdCFmRZA+4H
	 QIZsaVe7tCjp693aV21K9omHVHCANAZoPnYikTEGsqqCauCt535aZkagwmEz8zSc0t
	 SpzNQyGE0xXeZj/LDTiVnGrH5oJ0pqdjLcGYuMDxTMZHJILAov2F7rl+moMteQIKKn
	 Um8zTITjuFgEA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8F069C53BBF; Thu,  3 Oct 2024 17:13:59 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Thu, 03 Oct 2024 17:13:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: zaltys@natrix.lt
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-mp4F6XP8xP@https.bugzilla.kernel.org/>
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

--- Comment #24 from =C5=BDilvinas =C5=BDaltiena (zaltys@natrix.lt) ---
Disabling avic does not help. I and some other people tried that a few mont=
hs
ago.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

