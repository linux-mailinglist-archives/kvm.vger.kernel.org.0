Return-Path: <kvm+bounces-13767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4512B89A753
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 00:32:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 753281C215CC
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 22:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF6B42E647;
	Fri,  5 Apr 2024 22:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FL3HQ02l"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182032C1BA
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 22:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712356348; cv=none; b=lZh7MCOGXEMPL2HX/tjSuY6GpOHYqwGbj4zzjIaRpeJk11LlSu/F/th42LItnbSx4BUdBVUdiqbH2ofd8bCeZVoLkneU0MR4blUloz68xAZslMFz3ZDlEGl60MAABQ57DKWElmgDtagyPlJRkdqEW9cI1mzye3Io9XufpA6HDVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712356348; c=relaxed/simple;
	bh=v7FYanK49ntsPI2I2yIGr/qCDUl5kVy9ZelUW0LGan8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FDtdMTkwEtcuJSmK/sivTxEVrwMt/UdOFovW4fr9yfFmbfaEGHjkL9y0NaNdNijkuWsNwE+mI/5Ta85U5dsoAh+zTMv8fblT+pRVuKyJ9tpKhWV2aVkrvoN/UHGY2bXgtO3dZ1PKpb8YEg0aaGIb+udFr53bZbfpt4ecoaU1E+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FL3HQ02l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9AD57C433F1
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 22:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712356347;
	bh=v7FYanK49ntsPI2I2yIGr/qCDUl5kVy9ZelUW0LGan8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FL3HQ02lzVvIxi5DKI2OHMZqSiiYYKSpdjdw/We2izQ4mygn69OJYB17imkaNCTwf
	 B1YKrAFttsdZSHxcgogTQvHXMyZrDOrStiasZKg0dloxT+BqnLpKgNVW03o9BmcRMf
	 A8DBirTIKJ2wIz5LP1H8EfoCZj4GUZyafg2xWwM1kt1mTI1EbGVgR7SFszSCLmnLrM
	 Ns5/o7THMYNWaqfJ/JJiWW76r6/NLj20FZqN3Aj0iAg+TJUjVyfVqMEw34nVGoY1cn
	 gySqMVbFhnk54fVZot2MVFC8B7N3jDvRB5AHTduOfDH5PqXOWZvROFc/8DgRY29x3G
	 Hm5aTR9Wv7CrA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8F3C3C53BD2; Fri,  5 Apr 2024 22:32:27 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218684] CPU soft lockups in KVM VMs on kernel 6.x after
 switching hypervisor from C8S to C9S
Date: Fri, 05 Apr 2024 22:32:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218684-28872-pIbJ7cOPtK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218684-28872@https.bugzilla.kernel.org/>
References: <bug-218684-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218684

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
On Fri, Apr 05, 2024, bugzilla-daemon@kernel.org wrote:
> I'm currently in the middle of moving some of our hypervisors for upstream
> systemd CI from CentOS Stream 8 to CentOS Stream 9 (as the former will go=
 EOL
> soon), and started hitting soft lockups on the guest machines (Arch Linux,
> both
> with "stock" kernel and mainline one).
>=20
> The hypervisors are AWS EC2 C5n Metal instances [0] running CentOS Stream,
> which then run Arch Linux (KVM) VMs (using libvirt via Vagrant) - cpuinfo
> from
> one of the guests is at [1].
>=20
> The "production" hypervisors currently run CentOS Stream 8 (kernel
> 4.18.0-548.el8.x86_64) and everything is fine. However, after trying to
> upgrade
> a couple of them to CentOS Stream 9 (kernel 5.14.0-432.el9.x86_64) the gu=
ests
> started exhibiting frequent soft lockups when running just the systemd un=
it
> test suite.

...

> [   75.796414] kernel: RIP: 0010:pv_native_safe_halt+0xf/0x20
v> [   75.796421] kernel: Code: 22 d7 c3 cc cc cc cc 0f 1f 40 00 90 90 90 9=
0 90
90
> 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 23 db 24 00 fb f4
> <c3>

...

> [   75.796447] kernel: Call Trace:
> [   75.796450] kernel:  <IRQ>
> [   75.800549] kernel:  ? watchdog_timer_fn+0x1dd/0x260
> [   75.800553] kernel:  ? __pfx_watchdog_timer_fn+0x10/0x10
> [   75.800556] kernel:  ? __hrtimer_run_queues+0x10f/0x2a0
> [   75.800560] kernel:  ? hrtimer_interrupt+0xfa/0x230
> [   75.800563] kernel:  ? __sysvec_apic_timer_interrupt+0x55/0x150
> [   75.800567] kernel:  ? sysvec_apic_timer_interrupt+0x6c/0x90
> [   75.800569] kernel:  </IRQ>
> [   75.800569] kernel:  <TASK>
> [   75.800571] kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [   75.800590] kernel:  ? pv_native_safe_halt+0xf/0x20
> [   75.800593] kernel:  default_idle+0x9/0x20
> [   75.800596] kernel:  default_idle_call+0x30/0x100
> [   75.800598] kernel:  do_idle+0x1cb/0x210
> [   75.800603] kernel:  cpu_startup_entry+0x29/0x30
> [   75.800606] kernel:  start_secondary+0x11c/0x140
> [   75.800610] kernel:  common_startup_64+0x13e/0x141
> [   75.800616] kernel:  </TASK>

Hmm, the vCPU is stuck in the idle HLT loop, which suggests that the vCPU i=
sn't
waking up when it should.  But it does obviously get the hrtimer interrupt,=
 so
it's not completely hosed.

Are you able to test custom kernels?  If so, bisecting the host kernel is
likely
the easiest way to figure out what's going on.  It might not be the _fastes=
t_,
but it should be straightforward, and shouldn't require much KVM expertise,
i.e.
won't require lengthy back-and-forth discussions if no one immediately spot=
s a
bug.

And before bisecting, it'd be worth seeing if an upstream host kernel has t=
he
same problem, e.g. if upstream works, it might be easier/faster to bisect t=
o a
fix, than to bisect to a bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

