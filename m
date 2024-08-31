Return-Path: <kvm+bounces-25629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6C42967167
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 13:52:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A54601C212A3
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 11:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9EAF17E009;
	Sat, 31 Aug 2024 11:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="exZat5YY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C36717C231
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 11:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725105115; cv=none; b=AZUhwHPM6v+xCRmnh9OaUw6l6AA7lNIWbPps+EQWOvTRe90tW4StfNns4DOkobrZsLz13tgWAO+oduX+cCHwJUVtQQx0quOr1LbRz8Oi4Ai/oDoXrSjZRwmwo5+hXFnA4JkkpgyvxgUbwY0+iyjMKWWmdw0Y30vIOBLk/g+Xu3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725105115; c=relaxed/simple;
	bh=gpM1CtmWuNMOXSGXVGwSiz+lR+l2EveFSpViRe4OSMc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZfHkfx0C22UvBieRdSc/9KZHctnQI1Y9V9ZYXAsF89hjlueu0JPc+KEGGBPB6U0S09fn/VY64XTwoP4+ChN6cuIZvvloCAmknaThvo79DNqbWSG0IOoTF/AVE/buin1qs8rkjOtgA9V8pSlnbnl2bKFuEcv/tQFNbg7gHyy1lrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=exZat5YY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80CB8C4CECC
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 11:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725105114;
	bh=gpM1CtmWuNMOXSGXVGwSiz+lR+l2EveFSpViRe4OSMc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=exZat5YYGUdi8F9EH2lg0hS5UEmgXbjbkooxKYuJcIUkCIHHIaYxszsDqn9LrJJmT
	 WffzwMVmwyvWCmgY2G5UYljW0UbnRB0aIw4oM79uQXTrMdlglKgEhckoPFS6M1+FZ4
	 2/Og5V8V8GI1uy1CUInH9pPO9KkWcQ7debAsroATlm3Cjt8kktYEyth4jPDkEr46P+
	 IPSqwxbOm2O45dmfbjtng/CnOluj6a1XQaRNCnlgv75Hg6gtTC7Ygo0/vonCOGQaeN
	 GSLq/rD27a8COlx7cj000ho5gOCv/bK6BUlRAt4X5gxJWXEqMuL9SooxfnVh/dPUd1
	 t4112V/9U6TFw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 779C2C53BB9; Sat, 31 Aug 2024 11:51:54 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Sat, 31 Aug 2024 11:51:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: michal.litwinczuk@op.pl
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-n5owb2fPUX@https.bugzilla.kernel.org/>
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

--- Comment #14 from h4ck3r (michal.litwinczuk@op.pl) ---
(In reply to blake from comment #13)
> I recently experienced this. I built a proxmox cluster with 7950x. Every
> node that I tested on would hard reset with no logs when a VM was doing
> nested virtualization.
>=20
> Our CI testing uses VMs, and putting the CI in a VM itself makes it pretty
> easy to reproduce, just takes some time.
>=20
> Setting kvm_amd.vls=3D0 seems to have resolved the issue, we had zero node
> resets today and I was trying to force them.
>=20
> Kernel is Proxmox's 6.8.12-1-pve.
>=20
> Thanks,
> Blake

Disabling vls does help with crashes, but has too much performance penalty.
In my case it would lock gpu utilization at 40% max. (proxmox win10/11 hype=
rv
enabled)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

