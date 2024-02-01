Return-Path: <kvm+bounces-7706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA0E84594F
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 14:51:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E94831F218A0
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 13:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C71035D48D;
	Thu,  1 Feb 2024 13:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ORYm901G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F308E5D474
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 13:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706795465; cv=none; b=lQSwqJf45jPYHXHjjd3HRo25kheve045P6BoppEr0ftnvMHk0RyeEJNDNpUO03eZK5L/pzrTbSsTljfGlB7ORxR1PMElndoi8Hq8/tNfab140UyLBxf6M7aj/UG5sHBuXyyYIIyDGQVCk8aZmpEd4c17Jj8nch9snZp1OWn4uSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706795465; c=relaxed/simple;
	bh=v/Ou3niPEfbcvn5BHjAVtFCTt1ddhpLsUW2SrXKSj/s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dnDtKpYIjkqVHcz2H4P71N3nmv9hPhQAkQEAzmHxw3XG3PkWZ/JB6Jubs8x/ptsZ3ZYDXMC4TbRU93jeHlwTgdKJPCrXzc+hvaRLXtJzAETI2CUWY/EQjv9hv1JtPLkWssDGvGdlveBWoaUhR5a447zEsVxEBHrEqgeUGVgYBFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ORYm901G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81EA9C433F1
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 13:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706795464;
	bh=v/Ou3niPEfbcvn5BHjAVtFCTt1ddhpLsUW2SrXKSj/s=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ORYm901Gw9TOvUFC7U3VGDv83+wZJBvt4rfXDSGw0UlTDH52Ku74JNXbBOo4oxl+l
	 yeNYC6narD5CJNzzCewTR3hcqfyj4GSfbv5mw8dWu5TZtzHVmcgDt9cGB3nXixZdLT
	 /JVpnmtNYEITaEDGLT0NjuJ8mQdWUpRX/JCd+iQm3+TZfP83bACSc4G5ke8R+H8B9R
	 hBt3PqdRRR362BjtYz8p4QXAssIopd68MhR9SsbWJF/9NbJu5gMnFhpQTGnrfnmK+3
	 s7LC8JflvMKXUGz6OlIifABJi+QWdtxuyPw5jlNYNZ8Wq5VadR52NWgjiMJa/TUsbv
	 HMb7u9m0xVRhw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 724A8C53BC6; Thu,  1 Feb 2024 13:51:04 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date: Thu, 01 Feb 2024 13:51:03 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mgabriel@inett.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199727-28872-nRUlhRssoC@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

--- Comment #23 from Marco Gabriel (mgabriel@inett.de) ---
(In reply to Roland Kletzing from comment #13)
> hello, thanks - aio=3Dio_uring is no better, the only real way to get to a
> stable system is virtio-scsi-single/iothreads=3D1/aio=3Dthreads
>=20
> the question is why aio=3Dnative and io_uring has issues and threads has =
not...

Just for reference: Using aio=3Dthreads doesn't help on our lab and customer
setups (Proxmox/Ceph HCI) - we still see vm freezes after several minutes w=
hen
I/O load is high.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

