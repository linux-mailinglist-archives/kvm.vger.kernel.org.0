Return-Path: <kvm+bounces-21483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70D7092F6F3
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 10:31:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A24EA1C22662
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 08:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC16A13E02C;
	Fri, 12 Jul 2024 08:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e8JMTw7L"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A09AD52
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720773095; cv=none; b=ZSjF3Op5p+rKQ1zGt/8I7kPMXDymMc+xjSwe5dSSw3+vuNA1VjWZp9XkBkhfx+e5TlMmDi92AK1v0j6hsK7RjrHfoFjjYF9pfUJz0gIReOaz25ylJFasleASaqPwXApfAxvgeaEKJskgVJw41W9Ky7A28fo6yd75JygK1O0XdXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720773095; c=relaxed/simple;
	bh=hSr90kx8AvvhSy9fEf4IWdMgJ6xEpbToBPtPat84b9c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dIDwozN5/nrII9zfMHTnSJtw8h3R9ux11UUPWsRc5yLYX2jhWfEFQjPiPPoCvbjye56M+S0YLSWZllZrVwJ6RDRDjHyBZSG0BTlX6fiq2Ex7/RNm6qasEIpUl8OT1wOykH/vhqJukt6FwJEVnnPjqQl8B3Ps2yDgrtlt7DvSNHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e8JMTw7L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 544ACC4AF09
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720773094;
	bh=hSr90kx8AvvhSy9fEf4IWdMgJ6xEpbToBPtPat84b9c=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=e8JMTw7LnQR8UArKqvIdJJZBVe5FrmJIVF17fT+za5726k/VK8QK1/fFail3lksFz
	 JdsAFurk1r8fvo+JFAB5pNNLnkY37HNSe8UGt1fu2Kug5oiq+lyc+Zuc0gXkqIQbCd
	 FyilkBOM6VHQTQ+hZDuohOx1mzXppeu1aS8lzJjCH+Ee89S0vYKqzCpZgVlzIgsH7P
	 A8EPter0zMtq4w7QBOKNesPHpftPcLu0FsTz7oqLKc5QU6TQCC1nXAswjNoOT+jm4s
	 s+Chj0xtGqIzE+TisxjoljXOAQdOBB+k2O3RrO21tNhJSm2VwdKcuF8FCLgxtRV4F1
	 RBBgi/bpyEt3A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 49C25C53BB8; Fri, 12 Jul 2024 08:31:34 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218419] kvm-unit-tests asyncpf is skipped with no reason
Date: Fri, 12 Jul 2024 08:31:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: xiaoling.song@intel.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-218419-28872-eiyuAYYOSX@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218419-28872@https.bugzilla.kernel.org/>
References: <bug-218419-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218419

xiaoling.song@intel.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #2 from xiaoling.song@intel.com ---
This issue cannot be reproduced with below version.
kvm-unit-tests commit: 201b9e8bdc84c6436dd53b45d93a60c681b92719
Host kernel: 6.10.0-rc2
Kernel commit: 02b0d3b9
QEMU commit: b9ee1387

Close it.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

