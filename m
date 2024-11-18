Return-Path: <kvm+bounces-32020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3912D9D15BE
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 17:50:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA0EA1F21266
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 16:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D4AB1C1F2D;
	Mon, 18 Nov 2024 16:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o9jRIdS4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE9F1C07FB
	for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 16:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731948487; cv=none; b=M+PBskzA0jhCW9p3sjioigssTEcJ/YSmqE2OXopKKDQ/CjI/LsnvDmWMsF+zZq95n8JTXkTv80GC4KYVgbw/BlZ4uzAium1H9EVmkHhiaDwRz1mC+WPpEWLh9Fe5ynBHGHxz5hjR1uZYvv/MJupboMjixKuqs6yoex1iBEiuYMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731948487; c=relaxed/simple;
	bh=TbeXG2On2QfHL2/AcI0UErRHNXBOfze1dGLy0xZRgaU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TqK2pVHd0dE7oNF7qwes2ozsoCUBVpWXWKsaAg6pqwWQMnt3HZLjHLfCWZJfzenb4nX+mGYPg+qVmWCp8g8FLEYXAHtZfSiUy1wxPo8cplswv49l1AwauV/88Jsj2Yr4o9TzzJ4/TxRGqp2gD9x1MD4t1SHzj1BpnkV52InjlcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o9jRIdS4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id DBD38C4CEDE
	for <kvm@vger.kernel.org>; Mon, 18 Nov 2024 16:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731948486;
	bh=TbeXG2On2QfHL2/AcI0UErRHNXBOfze1dGLy0xZRgaU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=o9jRIdS4cJIgonbO7W53oi/iqWYnJrmbEUqHsqRO6NGl72Zqe+Zzp1LGBISqpwNCo
	 yaflTmdG2TBLuGlaQ5uyoEPFdAzUWuPoE8zf74Gn48OkzgPgUsWcB7blYhJ0AA36Rm
	 rSXPz8am3U+7CuE5Bdghg1BCoBg2HuaLsVgtpHl31ifNe0ApFm1K048y2bn4qsGOOv
	 IEibXpF3V93wMTPpsEBsx0AIUrohM5oQ+kbl8lR4K4K/PD9CwX0c+dS5LQvqzs2VPw
	 9uC2qemub/AE3Bp2N1/ZpRwD7w+D896AL7DFbtpWvmQ/g/HEniw6mmsP14LisvizzJ
	 ybdHZxLxutAEg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D6628C53BC5; Mon, 18 Nov 2024 16:48:06 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Mon, 18 Nov 2024 16:48:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mario.limonciello@amd.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-NzN8ksA97l@https.bugzilla.kernel.org/>
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

--- Comment #40 from Mario Limonciello (AMD) (mario.limonciello@amd.com) ---
It sounds like you have a separate stability issue, it should be brought in=
to
it's own bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

