Return-Path: <kvm+bounces-25633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7BBB967362
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 23:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2536C1C2107B
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 21:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E680B2263A;
	Sat, 31 Aug 2024 21:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uFYxxDnR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B62A15E81
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 21:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725141111; cv=none; b=lWYeacufdwWOhMGgLRO7AEAYR2dMSlCOvgMrpp/VJ1PuaH57jux9l7LezubWrFM/HxR4sFCrO3OkonHNLdrgQIbuCG9R48hACSJB2SeVdMYKQtkZJQixqCSU6UNMDjRnDT6BQQ+oyjFFeatopWp4XpGBlxDIQ3mR7dr0KuM0W9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725141111; c=relaxed/simple;
	bh=9+l/rVvQY/OfidVskTpiafliG/52ebU4YD96yZyGCYM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fmR+b5vIunJyiarlGFVLTuAVFn5Tm3X60p0gam0TJ+aQ7xs6sZTD0M+iv0W2887tzEtFE257Neap54HJobkdasdaET2wJimKVvtkpNS7/9U7X02T/Z5yiyiFW8tyKr4xhu0oCKH1gUBhIA5MPRDCbhx6MyagFwsgUypqJhP3ThY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uFYxxDnR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98EC1C4CECC
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 21:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725141110;
	bh=9+l/rVvQY/OfidVskTpiafliG/52ebU4YD96yZyGCYM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=uFYxxDnRz6EL79HmDA3roYvsFPxu7sxmWtdvoFtPJF6y7Ubi3CIwUhHZmzTfIuiaq
	 TmUnIQTAMCEbvdxZ8mc8g9KjrAGM/lzl55OrQjXREyAIGa50x4MPseAQ3K0OxZR086
	 +U5YZnFhIcikw1IaIniqat7/jgeOHehIpa7thiLpam7NIEj8wS0xciHUBQ++1Ic2ih
	 YQvpKhduNztBGeVIX7dm0pGr1ebM9p3Pqru11s4E/L6WtGHakDIZsAqn2jiSoj+Byb
	 j5zj4M/xr7ynkk3OTzg+JSM3hpBjcPvnBbQjI4+vbCZcLF2rtTGtn9l2CHzcpTZ7AL
	 7g5FOOSLu3zYw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 92C83C53BC4; Sat, 31 Aug 2024 21:51:50 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Sat, 31 Aug 2024 21:51:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: blake@volian.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-L8taT5OzzN@https.bugzilla.kernel.org/>
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

--- Comment #16 from blake (blake@volian.org) ---
At least for me, I haven't noticed any performance hit. These systems are a=
ll
headless though.

On Sat, Aug 31, 2024, at 6:51 AM, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D219009
>=20
> --- Comment #14 from h4ck3r (michal.litwinczuk@op.pl) ---
> (In reply to blake from comment #13)
> > I recently experienced this. I built a proxmox cluster with 7950x. Every
> > node that I tested on would hard reset with no logs when a VM was doing
> > nested virtualization.
> >=20
> > Our CI testing uses VMs, and putting the CI in a VM itself makes it pre=
tty
> > easy to reproduce, just takes some time.
> >=20
> > Setting kvm_amd.vls=3D0 seems to have resolved the issue, we had zero n=
ode
> > resets today and I was trying to force them.
> >=20
> > Kernel is Proxmox's 6.8.12-1-pve.
> >=20
> > Thanks,
> > Blake
>=20
> Disabling vls does help with crashes, but has too much performance penalt=
y.
> In my case it would lock gpu utilization at 40% max. (proxmox win10/11 hy=
perv
> enabled)
>=20
> --=20
> You may reply to this email to add a comment.
>=20
> You are receiving this mail because:
> You are on the CC list for the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

