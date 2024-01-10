Return-Path: <kvm+bounces-6014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 324E582A22D
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 21:22:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B37DB1F227D9
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 20:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 985154EB3A;
	Wed, 10 Jan 2024 20:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lpi5yb2P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E514E1C6
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 20:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50C70C43394
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 20:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704918099;
	bh=i2U1F3RRftz6Phbfy3DCuYl4Or5IB1O1lrTDAx07Yco=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Lpi5yb2PcsYcT2Y2/7Sb947YKoxrZpSR4avrKgoskkQjyluCAsQB/pIJmx1Rjonsh
	 KyqjJaIJ3KTAThiv52GGMTVVKJQKLAcw3GDNbzpF06UCZcHyTh4H/t502gN6ylqr8O
	 NW5lGbhEG2bgdVzSN2GPCRU4WXck8YIsr87WPTEeqostVE406VsHbnpRxzFZwOCOPk
	 3Jlij9pNpp7aQILK2RqWlggAtA9atN6uermlygc1mVCJo4GMq7Zc5qZTraSsRXDGhz
	 M6ADwbAy8/KRAQUvMDOIpzQD5vB0sHQXC3UKkW+rKU2lu4V9msHB/jpZQrxEr2ukI7
	 fXzl771TtFErg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3AE95C53BC6; Wed, 10 Jan 2024 20:21:39 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218339] kernel goes unresponsive if single-stepping over an
 instruction which writes to an address for which a hardware read/write
 watchpoint has been set
Date: Wed, 10 Jan 2024 20:21:39 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218339-28872-2dlgPAo3mz@https.bugzilla.kernel.org/>
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

--- Comment #4 from Anthony L. Eden (anthony.louis.eden@gmail.com) ---
>> I tried on my side but can't reproducce it, logs below. Any steps I miss=
ed ?

Nope, it looks like you did everything right.



I spent a little more time investigating this, since for me it's trivial to
reproduce. I was able to get the guest kernel vmlinux *with* debugging
information from the linux-image-6.1.0-15-amd64-dbg debian package.

After entering the final `stepi` within gdb, which is when the guest goes
totally unresponsive, in htop I see qemu-system-x86_64 is taking up 100% CP=
U.
Like I said, the thread call stacks in the qemu process look typical.

I used the qemu monitor command 'dump-guest-memory -p /root/linux.core' thr=
ee
separate times after the guest went unresponsive, and all three of the core
file backtraces look like this:

#0  pv_native_set_debugreg (regno=3D7, val=3D0) at
arch/x86/include/asm/debugreg.h:92
#1  0xffffffff81a21533 in set_debugreg (reg=3D7, val=3D0) at
arch/x86/include/asm/paravirt.h:129
#2  local_db_save () at arch/x86/include/asm/debugreg.h:127
#3  exc_debug_kernel (dr6=3D0, regs=3D0xfffffe0000010f58) at
arch/x86/kernel/traps.c:1038
#4  exc_debug (regs=3D0xfffffe0000010f58) at arch/x86/kernel/traps.c:1175
#5  0xffffffff81c00c6a in asm_exc_debug () at
/build/reproducible-path/linux-6.1.66/arch/x86/include/asm/idtentry.h:606
#6  0x0000000000000000 in ?? ()



My VM was in a self-contained folder with its own run script on the host so=
 I
made a tarball of it. It is available for download here (~9 GB):

https://drive.google.com/file/d/1r3tlrw8kG17vFwXzP6ETv76ptNhbLYjt/view?usp=
=3Dsharing

Usage:

$ tar xvSf deb-vm-x86_64.tar
$ cd deb-vm-x86_64/
$ ./run.sh

In another terminal,

$ screen /dev/pts/23 115200
$ login as user 'root' with password 'root'

Once inside,

$ gdb /usr/bin/ls
$ starti
...


Oh and by the way, the version of qemu-system-x86_64 on my host is 7.2.7
(Debian 1:7.2+dfsg-7+deb12u3).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

