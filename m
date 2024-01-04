Return-Path: <kvm+bounces-5609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DA9D823AB2
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 03:36:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8F9B1F25BBB
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 02:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A5BD4C90;
	Thu,  4 Jan 2024 02:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FEoprwQb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7094C67
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 02:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 190E3C433C8
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 02:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704335752;
	bh=SLgBlh2F27mzXsF6Ox0JYW30NcCnw3ccYwyKspsYgPE=;
	h=From:To:Subject:Date:From;
	b=FEoprwQbJ73sBGpMr47Ija8Yc3dY3VIS0D1EmjQ5PCpgcuGdYzoBAcpln9aQpWgHE
	 6nhJMXsu6mtHsw9QpRoqTcS+0oP9qulhw4/h80a1NTf5j2bzVHpiOARhsthqkqqXRN
	 K7tf9IEGFu2172rgRTWogz8xKNFwDhxbHyaPf11Q9i/pT61kcnkA0+12Q+ZZVnF8QD
	 NeN7ypHnzJgaTorVK5jqN4nH/1Lf7DwplLMJGPM3knPt56yafosORclp9nD095L9KU
	 DytJFMtukXPgA5TWOvaPmeoDbXTDmyrM5z3C07pQ1Mnw2twWcEcjAq+I/h5bLZfP9l
	 cl3Erc8LhdTeA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id EF69DC53BD2; Thu,  4 Jan 2024 02:35:51 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218339] New: kernel goes unresponsive if single-stepping over
 an instruction which writes to an address for which a hardware read/write
 watchpoint has been set
Date: Thu, 04 Jan 2024 02:35:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: anthony.louis.eden@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-218339-28872@https.bugzilla.kernel.org/>
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

            Bug ID: 218339
           Summary: kernel goes unresponsive if single-stepping over an
                    instruction which writes to an address for which a
                    hardware read/write watchpoint has been set
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: anthony.louis.eden@gmail.com
        Regression: No

In a debian QEMU/KVM virtual machine, run `gdb` on any executable (e.g.
`/usr/bin/ls`). Run the program by typing `starti`. Proceed to `_dl_start`
(i.e. `break _dl_start`, `continue`). When you get there disassemble the
function (i.e. `disas`). Find an instruction that's going to be executed for
which you can compute the address in memory it will write to. Run the progr=
am
to that instruction (i.e. `break *0xINSN`, `continue`). When you're on that
instruction, set a read/write watchpoint on the address it will write to, t=
hen
single-step (i.e. `stepi`) and the kernel will go unresponsive.


>(gdb) x/1i $pc
>=3D> 0x7ffff7fe6510 <_dl_start+48>:      mov    %rdi,-0x88(%rbp)
>(gdb) x/1wx $rbp-0x88
>0x7fffffffec28:        0x00000000
>(gdb) awatch *0x7fffffffec28
>Hardware access (read/write) watchpoint 2: *0x7fffffffec28
>(gdb) stepi


Looking with `journalctl`, I cannot find anything printed to dmesg.

The kernel of the guest inside the virtual machine is Debian 6.1.0-15-amd64.
The kernel of the host running qemu-system-x86_64 is Archlinux 6.6.7-arch1-=
1.
gdb is version 13.1.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

