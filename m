Return-Path: <kvm+bounces-6015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EE22082A30D
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 22:07:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7DD1CB21549
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 21:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B9EA4F219;
	Wed, 10 Jan 2024 21:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YF3P9sje"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEE74F20D
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 21:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10796C43394
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 21:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704920853;
	bh=gglx1UXFdf2hgP5IzdEAIiWI5k8LOHO4t62Jj6nRhYQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=YF3P9sjeorm/7mH0HKHHlty8m17w8bz1abAIRJVq4TH3Vifuk9myvYhcuZHLrL/Rd
	 0BJL0DNvxooH4owk4SjyciNYNs3Jp+DwdBs4Yamb9TVtftOQ5gZQ4jVP0YfIetQAiT
	 5vV7J2YnVAFwSUrtCshMRgX1QwngyLq2aCINfbnSV+vz+FiRMvCqeeQxFfXTuFZzPS
	 rzk0JPek7uETEroAacDa0NG89DwUx3ZVLmq1mNDJKJbEKjVps3q600UI+hRMm3ahnT
	 wtivLCo87QRhHf1iX6Sf7cEHfgY/hR1O8AQ7wEogMBxot0CYsDMvDJlcKayBevue2Z
	 yTuIQ5ZKUokXg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id EEF28C53BD0; Wed, 10 Jan 2024 21:07:32 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218339] kernel goes unresponsive if single-stepping over an
 instruction which writes to an address for which a hardware read/write
 watchpoint has been set
Date: Wed, 10 Jan 2024 21:07:32 +0000
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
Message-ID: <bug-218339-28872-w3Wy3sXVOl@https.bugzilla.kernel.org/>
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

--- Comment #5 from Anthony L. Eden (anthony.louis.eden@gmail.com) ---
Actually upon closer inspection I'm seeing two distinct call stacks appear =
in
the core files.

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

#0  pv_native_set_debugreg (regno=3D7, val=3D983554) at
arch/x86/include/asm/debugreg.h:92
#1  0xffffffff81a21509 in set_debugreg (reg=3D7, val=3D983554) at
arch/x86/include/asm/paravirt.h:129
#2  local_db_restore (dr7=3D983554) at arch/x86/include/asm/debugreg.h:147
#3  exc_debug_kernel (dr6=3D<optimized out>, regs=3D0xfffffe0000010f58) at
arch/x86/kernel/traps.c:1095
#4  exc_debug (regs=3D0xfffffe0000010f58) at arch/x86/kernel/traps.c:1175
#5  0xffffffff81c00c6a in asm_exc_debug () at
/build/reproducible-path/linux-6.1.66/arch/x86/include/asm/idtentry.h:606
#6  0x0000000000000000 in ?? ()


They are quite similar except in one of them frame #2 is local_db_save() an=
d in
the other trace frame #2 is local_db_restore().

By the way this time I ran the VM under a different, newer version of
qemu-system-x86_64 (8.2.0), and it appears to have made no difference.


Also, concerning the VM in that tarball I linked to, if the run.sh is run a=
s it
is you will be able to ssh into the running guest with 'ssh -p 10024
root@localhost', furthermore the path to the kernel image *with* debug info=
 is
located at /usr/lib/debug/vmlinux-6.1.0-15-amd64.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

