Return-Path: <kvm+bounces-62044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F332C34682
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 09:14:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 656D74F571D
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 08:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6860B2C3262;
	Wed,  5 Nov 2025 08:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CavuJiIs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D53318BC3D
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 08:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762330366; cv=none; b=h/80M/YxbOUlu90XGs50+JlsnMXbuwWN/uFpsZooSOGejOsDWoLMS17q2GqVYV9iU369w8IoJnf7YHfybspTswMlykaZZxdraOQPPNi2DjsCX5/OP3AH4WC4k29XBAqJvsjnw4ox86oaZzPiYiXok02zbmvWuGjyWL/zeWs/kpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762330366; c=relaxed/simple;
	bh=WzP9TA7rkcTTmy1+CQgBMEIEhhwDV2NmFZ+FdqHDFWA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ENhLqrwmJjgjU7Cx8v9CUewpm1qfMlNvzXiB3QDAwqkRwIx8QsN/5wm/DplXCsKye8kcgSqTAEV+li5AJ7dKomiSGPm0Cxl+umL6KjOu7ie9pV/HkRMEXwpxjMbJra2lCRgHPiT2UoDkSNDbRKjKaC2pogTD6rCH8SP2NYDycgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CavuJiIs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 157D2C19423
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 08:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762330366;
	bh=WzP9TA7rkcTTmy1+CQgBMEIEhhwDV2NmFZ+FdqHDFWA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CavuJiIs++abvRoHHyM0TgDaou4MaFOQckzK2UFa77MLSi/iR4s9IWtjrGBLnkqgd
	 uDyYuTMgA1UxNMG0NOi3rjfyOHRaSgCERMVJ35dcOn/8bwVKNIEoFCsIV5Ejdjr5m7
	 kSr1wQMTkboowq2oXcVWeALRQ4bNiSt6gyFSjms3w79aiSWg5Fgj3tVozTrr2LwLR+
	 96hhF40oSjsyw+X4SND42pz/SdZtnvKJCrPAdAM1f5ImfPej+jaKbAZj4bDqyCFuVI
	 wSihikR8amkgTvhHBwfKcu8y7wso2Q1ea3YGPM/AxnsceKSsPakLu2HhE412E7xHJA
	 5JcyB4Z+s720Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0D0BDC53BC5; Wed,  5 Nov 2025 08:12:46 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220740] Host crash when do PF passthrough to KVM guest with
 some devices
Date: Wed, 05 Nov 2025 08:12:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220740-28872-HofMZ1UwTT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220740-28872@https.bugzilla.kernel.org/>
References: <bug-220740-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220740

--- Comment #7 from Chen, Fan (farrah.chen@intel.com) ---
I also tried the option you mentioned "x-msix-relocation=3Dbar5", still the=
 same
result, host crash.

In addition, according to the host serial log in description, the error dev=
ices
is b7:00.04 and b7:02.00, and the BDF of my X710 is b8:00.0.
I checked pcie topology of my system:
 +-[0000:b7]-+-00.0
 |           +-00.1
 |           +-00.2
 |           +-00.4
 |           \-02.0-[b8]--+-00.0
 |                        \-00.1

So the AER errors are reported on the bridge (b7:02.0) of the assigned devi=
ce
(b8:00.0), and a device (b7:00.4) sibling to the bridge.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

