Return-Path: <kvm+bounces-5660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC7558246BE
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 17:54:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE9371C224C6
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 16:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19E9B286BB;
	Thu,  4 Jan 2024 16:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VO0LKzHB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD67286B2
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 16:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4539C433C9
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 16:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704387250;
	bh=oWCOQlkv0fcdWmMXkx+YFpSZaglqfWVO7zyJ9vTsnZY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=VO0LKzHBaty6YEAK3862iCPZCQ8PHsm86SIWeSo75m6chENW22J9rGAiNTEJm7Pi8
	 2KbB6PPwF/arIpnwHz9WS+5d0wa3LmId6OKxC24D7erGdYorWDea8D5t4wQrGvlKgJ
	 S1ef28MAQeKeYfmuVGpSRoF9ULo9MPNcRa+B+12f6KTgNRO4wswobesImzh3Ebf9Rl
	 f+e86HY71MakGs1KKKAkvRnOJu/YuG4vaT9xGFy6YNvcwa+o7kBJOgKmlSJ/l9YzvG
	 HG/XM7NVR+f45xtwc/BiEIHjMofuM3KnIeHNjGT5H/RMq/L9LwdQTHdsTjqD30VSmp
	 s6X/X20ZJUMCQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id ACC5AC53BD3; Thu,  4 Jan 2024 16:54:10 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218339] kernel goes unresponsive if single-stepping over an
 instruction which writes to an address for which a hardware read/write
 watchpoint has been set
Date: Thu, 04 Jan 2024 16:54:10 +0000
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
Message-ID: <bug-218339-28872-xDSc9njndE@https.bugzilla.kernel.org/>
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

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
On Thu, Jan 04, 2024, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218339
>=20
>             Bug ID: 218339
>            Summary: kernel goes unresponsive if single-stepping over an
>                     instruction which writes to an address for which a
>                     hardware read/write watchpoint has been set
>            Product: Virtualization
>            Version: unspecified
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: anthony.louis.eden@gmail.com
>         Regression: No
>=20
> In a debian QEMU/KVM virtual machine, run `gdb` on any executable (e.g.
> `/usr/bin/ls`). Run the program by typing `starti`. Proceed to `_dl_start`
> (i.e. `break _dl_start`, `continue`). When you get there disassemble the
> function (i.e. `disas`). Find an instruction that's going to be executed =
for
> which you can compute the address in memory it will write to. Run the pro=
gram
> to that instruction (i.e. `break *0xINSN`, `continue`). When you're on th=
at
> instruction, set a read/write watchpoint on the address it will write to,
> then
> single-step (i.e. `stepi`) and the kernel will go unresponsive.

By "the kernel", I assume you mean the guest kernel?

> >(gdb) x/1i $pc
> >=3D> 0x7ffff7fe6510 <_dl_start+48>:      mov    %rdi,-0x88(%rbp)
> >(gdb) x/1wx $rbp-0x88
> >0x7fffffffec28:        0x00000000
> >(gdb) awatch *0x7fffffffec28
> >Hardware access (read/write) watchpoint 2: *0x7fffffffec28
> >(gdb) stepi
>=20
>=20
> Looking with `journalctl`, I cannot find anything printed to dmesg.
>=20
> The kernel of the guest inside the virtual machine is Debian 6.1.0-15-amd=
64.
> The kernel of the host running qemu-system-x86_64 is Archlinux 6.6.7-arch=
1-1.
> gdb is version 13.1.

Is this a regression or something that has always been broken?  I.e. did th=
is
work
on previous host kernels?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

