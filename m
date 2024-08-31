Return-Path: <kvm+bounces-25634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 120059673D9
	for <lists+kvm@lfdr.de>; Sun,  1 Sep 2024 00:54:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA6D61F21B08
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 22:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D90218309C;
	Sat, 31 Aug 2024 22:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ucrY76mL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80F910A3D
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 22:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725144851; cv=none; b=PFRomFcUhSBeALqw9sxINl4iKzNWaKc9koCW02LTCrUFVYYM/FO1IY1u+Dg1Wat0txdW30tw9aTpVNvE/RXX/QrtBnEgA1pj7ZR+jNr3fQ9llz6bVK0xTVc1jkRJXN+ezW/Pujksqrbfl/22GWx/JwGKFDuHPTexgST0eW7DSAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725144851; c=relaxed/simple;
	bh=BBKK4GYpSs99XkvqJ300NfG1L1GhElNcojfzOQ9XiNY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k0pGYv7ny3/757lbKmdG/M628bl6bnzvUGeeffoJRfAW1c6oOaH9HYQkic0kigGMRcYNi+kxMcEu9J49sotjEJEH2z4tsni8hudFqk8YXNcCPlseYSnazK45JNGZlMgTS5WDKSCKIme9hb96t0L7HgzPtzRzt4fOR12177Lm0DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ucrY76mL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C3F1C4CECB
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 22:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725144851;
	bh=BBKK4GYpSs99XkvqJ300NfG1L1GhElNcojfzOQ9XiNY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ucrY76mL9C00XsKtpVqmVxqciT1wny7/stWa+y9R7ocEcgJjkbUOrJWYwj3l43Jww
	 6srMVx8MpPKYzC42YWn3tyzyAYRc0B1V9oEktMM2uNnpXpQu8lTL2qjdzQnZiEhDCT
	 ipe1W77SaVbUyz9D8fXmefFBYIpJekahEQ4XTjR3vZi46IvOP5y59pBHxrYfSd06Ws
	 R6QERAuafdhsyejJ0oBzmXwHZDirzPxGYGdCsUSBuT+Zih8boSVbcPE8wns9w4j3UO
	 Nxf94Sr3tlXBZnIzr/6EGIyGN4ZFClXDhzSvlXIdYl6EUIGEBmj10LZYJ3NsqxAnO+
	 PNol/zVV0vsbw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 46BC3C53B73; Sat, 31 Aug 2024 22:54:11 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Sat, 31 Aug 2024 22:54:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ozonehelix@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-sQyqBWiuxN@https.bugzilla.kernel.org/>
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

--- Comment #17 from Ben Hirlston (ozonehelix@gmail.com) ---
(In reply to blake from comment #16)
> Created attachment 306799 [details]
> attachment-12508-0.html
>=20
> At least for me, I haven't noticed any performance hit. These systems are
> all headless though.
>=20
> On Sat, Aug 31, 2024, at 6:51 AM, bugzilla-daemon@kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D219009
> >=20
> > --- Comment #14 from h4ck3r (michal.litwinczuk@op.pl) ---
> > (In reply to blake from comment #13)
> > > I recently experienced this. I built a proxmox cluster with 7950x. Ev=
ery
> > > node that I tested on would hard reset with no logs when a VM was doi=
ng
> > > nested virtualization.
> > >=20
> > > Our CI testing uses VMs, and putting the CI in a VM itself makes it
> pretty
> > > easy to reproduce, just takes some time.
> > >=20
> > > Setting kvm_amd.vls=3D0 seems to have resolved the issue, we had zero=
 node
> > > resets today and I was trying to force them.
> > >=20
> > > Kernel is Proxmox's 6.8.12-1-pve.
> > >=20
> > > Thanks,
> > > Blake
> >=20
> > Disabling vls does help with crashes, but has too much performance pena=
lty.
> > In my case it would lock gpu utilization at 40% max. (proxmox win10/11
> hyperv
> > enabled)
> >=20
> > --=20
> > You may reply to this email to add a comment.
> >=20
> > You are receiving this mail because:
> > You are on the CC list for the bug.

the performance hit for me hasn't been that bad but disabling vls is the sa=
me
as disabling svm for the vm its more like telling the VM the CPU is incapab=
le
of nested virtualization that is what I observed

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

