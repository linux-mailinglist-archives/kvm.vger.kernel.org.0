Return-Path: <kvm+bounces-38644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78333A3D210
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 08:22:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A2773A70DA
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 07:21:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9552E1EB18D;
	Thu, 20 Feb 2025 07:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bPWEqI23"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1CE1EA7D7
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 07:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740035455; cv=none; b=mKX4NLbAYBkSPPKS6Y4HHxm6D2h34xNRxz1rLShpkrDDVCYheZJr0upinb9u9ql98jGrXLCHcY+62wdgVehCkhXlJr5vFarbz2DCCgV/fU0mJ6rLlCDCbdCJPKr3dir+8n/xW2S0NXVridqu1uhNv/qBAlufO/8bBaAp0LddC20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740035455; c=relaxed/simple;
	bh=HbdPPT4Tu+8coU6MEBToH5JHRAkXZDVftuU+uj363u4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sHVRGtSZfbNveis+mNN4goBIQzJRnv3pw0LVkEVazDHiHaRCQgLKiBO1s1jrfhfCt+qjhx/1JZjRGrJFJEbxv0/Ylg4AUhskxWdeJlHPslf0O5cL4A97mC8fwmWuBX7Gl+cKvb2YIuWqAmR/+IXmy0yOomnyu8FsXmoqOpkrEKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bPWEqI23; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2CC5BC4CEE6
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 07:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740035455;
	bh=HbdPPT4Tu+8coU6MEBToH5JHRAkXZDVftuU+uj363u4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=bPWEqI23VQ5S8jgzCPbamAx7L+ioasfLnG+4NVlVrm+pUbMkSTI8C7dbdLXR4On39
	 tlg69wgfTWapGSRqncSlyEMgvsnLkSBlvpp4BPj90OVPCAZJ4WUPTGOwMdT8q9D2xu
	 B6l/DKYikr0a0DB4Makefy20zXI7dwakbnYVrQe/E6HCcNooqJYHRb9lwAgRP+8on7
	 zyuf2CAmRudaEja/u0bq9zRqELS4nXY6qQUT0Q46a7yUIL946l8r1ShMd+XVEpSKhC
	 ch3amAOYTThDuh2BE0R0gA8BacqfGm65NesElDZVIMByY6738PJ0xt9XGiY/Fjw4wW
	 LQzi2H5bngwcA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 2458AC53BBF; Thu, 20 Feb 2025 07:10:55 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Thu, 20 Feb 2025 07:10:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: rangemachine@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219787-28872-Buv2FGa6sL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219787-28872@https.bugzilla.kernel.org/>
References: <bug-219787-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219787

--- Comment #4 from rangemachine@gmail.com ---
(In reply to Sean Christopherson from comment #2)
> Are you able to bisect to an exact commit?  There are significant KVM
> changes in 6.13, but they're almost all related to memory management.  I
> can't think of anything that would manifest as an unexpected single step
> #DB, especially not with any consistency.
>=20
> And just to double check, the only difference in the setup is that the ho=
st
> kernel was upgraded from v6.12 =3D> v6.13?  E.g. there was no QEMU update=
 or
> guest-side changes?

I was not able to bisect yet, sorry. And yes, I double checked, the only ch=
ange
is kernel upgraded from v6.12.10 to v6.13.2 (did not checked v6.13.3 yet, b=
ut
rc version had some behaviour).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

