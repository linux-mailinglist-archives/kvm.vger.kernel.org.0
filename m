Return-Path: <kvm+bounces-11067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3104E8728A8
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 21:26:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C67FC1F2C7FE
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 20:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09E1412CDB3;
	Tue,  5 Mar 2024 20:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bEI+hsSj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A9E12881F
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 20:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709670297; cv=none; b=mY2vrrj2A9slzb0sEExeraZrXU30r67Mwyhua+//2/rTd7urZGsbZ2HsRG3VQWfUOSv/fcmmgHWLfXM+BVnsve3i4jlnbk9zrEF06VAwyppiggnc+7JhRUdecN1rxPCqXIBOUlh8mE+hNRsOuRqhqjLzIp3GF2ap/ISbzbn8y7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709670297; c=relaxed/simple;
	bh=mnp0t0u8ChlirDpC8CpabbIf8e0ZQX9Eq0ZPkCFaYbk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pnME/xQZORL0RMenBXoTusQ8Slktqgn/d6iUYiDN16ZZvOEr7h10pA+pDmTPii62FsXDn9r1sVUVYd++C3AhzJE8HkkemgEZAGn/G72Diu+eAiTkXGyyD3stjgvJkgfUD6N7HHuwrwdYDuFkIiPDSC47EKuoYQ1YoHQlaJkyr2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bEI+hsSj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD8D4C43394
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 20:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709670296;
	bh=mnp0t0u8ChlirDpC8CpabbIf8e0ZQX9Eq0ZPkCFaYbk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=bEI+hsSjaU8ze/rmgTisKPSZ+phuqffqD9wEnxawV3G92mgLOkww4nXpRHxI15E+m
	 d0Bm3gUwDn6InjlObAUjpkC3V4KGo//SGR6zHNcOomPOhnrNq/t3HyfbVEEViTHehG
	 f6lwyBlNvDxrOJfpB45dRcp4sKiFuPoYVsKa+KNz8HRfQtAqJMU7EyKx1dBRgm0l9I
	 GD/PmU7GEvMTPBEmxr1ZQKERPdJCtAPHPtLaqQG7DJPUBBEEjQbOm8BqlYi+biqm/e
	 HS5sYY5t1TqDzOSGM5n5jb+2VwIqJ1N4out1iPR1FETJ5eU5RNjTa7fsWdfne57kmE
	 5QnSQ63Dkd6JQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9AF02C53BD3; Tue,  5 Mar 2024 20:24:56 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218339] kernel goes unresponsive if single-stepping over an
 instruction which writes to an address for which a hardware read/write
 watchpoint has been set
Date: Tue, 05 Mar 2024 20:24:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kishen.maloor@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218339-28872-DEbvHtj9rU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218339-28872@https.bugzilla.kernel.org/>
References: <bug-218339-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218339

Kishen Maloor (kishen.maloor@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kishen.maloor@intel.com

--- Comment #6 from Kishen Maloor (kishen.maloor@intel.com) ---
(In reply to Anthony L. Eden from comment #0)
> In a debian QEMU/KVM virtual machine, run `gdb` on any executable (e.g.
> `/usr/bin/ls`). Run the program by typing `starti`. Proceed to `_dl_start`
> (i.e. `break _dl_start`, `continue`). When you get there disassemble the
> function (i.e. `disas`). Find an instruction that's going to be executed =
for
> which you can compute the address in memory it will write to. Run the
> program to that instruction (i.e. `break *0xINSN`, `continue`). When you'=
re
> on that instruction, set a read/write watchpoint on the address it will
> write to, then single-step (i.e. `stepi`) and the kernel will go
> unresponsive.
>=20
>=20
> >(gdb) x/1i $pc
> >=3D> 0x7ffff7fe6510 <_dl_start+48>:      mov    %rdi,-0x88(%rbp)
> >(gdb) x/1wx $rbp-0x88
> >0x7fffffffec28:        0x00000000
> >(gdb) awatch *0x7fffffffec28
> >Hardware access (read/write) watchpoint 2: *0x7fffffffec28
> >(gdb) stepi
>=20

I can reproduce the behavior you describe. But it seems that you're not
invoking KVM at all, because when I add '-accel kvm' or '-enable-kvm' to yo=
ur
qemu command line the problem goes away.

There may be an issue specifically in the handling of hardware watchpoints
on the qemu emulation. If I disable hardware watchpoints in gdb using 'set
can-use-hw-watchpoints 0' and then use 'watch *<ADDR>', that works.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

