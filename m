Return-Path: <kvm+bounces-20737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F1CD91D466
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 00:21:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2197F1C208D2
	for <lists+kvm@lfdr.de>; Sun, 30 Jun 2024 22:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 472D07C086;
	Sun, 30 Jun 2024 22:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJH/iP/u"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA8078C63
	for <kvm@vger.kernel.org>; Sun, 30 Jun 2024 22:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719786075; cv=none; b=b+yXPJWKOsFnsOJNhlnTKcqBlJp+fjdqQWguN1dfG/DVjpwwUxMq62ejFZsZ0EASC1nfQe7CIlbyJZqYnGs4Ecuk9I2Iik8PmEVQOMUI6c9ZPU9PksaISpyoA+2cTUVnS9457XeozoHCTo/CVBfQd/fWyMrWni7fG5QfuaFb4og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719786075; c=relaxed/simple;
	bh=VLDM9ULpCJi7dqyOnoTC7SJdfnrckfHXgcIiVbqjviM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UgNpPf9azikseFXfiZFCkemyVNyvVwMUzMitNla106M1yy6F7jLtBWQ9kSptwy2pAe8tUbNoYtzrpEndegZ4BwGNn6Did7KcJW4Isgn0LW7ViqudEL/NS8lFDJjyuFNGLGzPbpo0R1lb7NwDJ8PnpyzG17ZF5m3PAlVDt+FuHDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJH/iP/u; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF95EC4AF0E
	for <kvm@vger.kernel.org>; Sun, 30 Jun 2024 22:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719786074;
	bh=VLDM9ULpCJi7dqyOnoTC7SJdfnrckfHXgcIiVbqjviM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kJH/iP/ulAkWyFl+Z9nTGUoOmZF0Q97WhCUBQU+iHvj63cR/E6rF/9059hqKfyybA
	 zP7M1dLj0n5IByfDheWcEzZ9tHsq2drTdboLrMY/ilhLsL/leo1MuvBC7GX/8xFG5b
	 xKzW6D4iRFgKZ8pg8/CAuAzRL5+xJ03Ri5PCr+aBGQ/vu5HrN1BNBpBW8MopB2BFV+
	 PY1tGgyz4tcHoy6LPYQizfRaL6YbpQulKOvuqOZ3kPvcr6Rp/+UdnmSbwyVwezBAXW
	 7B+/d+D0mZj3TjNHI7W9N+IAsyJ1xQKy58JOEAtBuiERBfhPxAh6NVvWqIkA/NfMt7
	 8+5QdODyXiUDg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id CCC84C53BB7; Sun, 30 Jun 2024 22:21:14 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218980] [VM boot] Guest Kernel hit BUG: kernel NULL pointer
 dereference, address: 0000000000000010 and WARNING: CPU: 0 PID: 218 at
 arch/x86/kernel/fpu/core.c:57 x86_task_fpu+0x17/0x20
Date: Sun, 30 Jun 2024 22:21:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218980-28872-nBCD6tPERO@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218980-28872@https.bugzilla.kernel.org/>
References: <bug-218980-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218980

--- Comment #5 from Luis Chamberlain (mcgrof@kernel.org) ---
On Mon, Jun 24, 2024 at 06:43:54AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218980
>=20
>             Bug ID: 218980
>            Summary: [VM boot] Guest Kernel hit BUG: kernel NULL pointer
>                     dereference, address: 0000000000000010 and WARNING:
>                     CPU: 0 PID: 218 at arch/x86/kernel/fpu/core.c:57
>                     x86_task_fpu+0x17/0x20
>            Product: Virtualization
>            Version: unspecified
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: hongyu.ning@intel.com
>         Regression: No
>=20
> Created attachment 306485
>   --> https://bugzilla.kernel.org/attachment.cgi?id=3D306485&action=3Dedit
> WARNING/BUG and Call Trace info in dmesg
>=20
> in an regular linux-next guest kernel regression test setup, recently hit
> following BUG and WARNING, likely related to x86/fpu.

> [    1.962383]  ? fpstate_free+0x5/0x30

Yeah we run into the same thing on *all* boots on linux-next on kdevops
as well, Cc'ing kdevops list so folks are aware linux-next is broken
right now.

[   16.785349] BUG: kernel NULL pointer dereference, address:
0000000000000010
[   16.785353] #PF: supervisor read access in kernel mode
[  OK  ] Found device[   16.785354] #PF: error_code(0x0000) -
not-present page
 dev-disk-by\x2dlabel-=E2=80=A6evice - QEMU NVMe Ctrl sparsefiles.
 [   16.785356] PGD 0 P4D 0
 [   16.785358] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
 [   16.785361] CPU: 1 UID: 0 PID: 528 Comm: modprobe Tainted: G
 W          6.10.0-rc5-next-20240628+ #8
 [   16.785365] Tainted: [W]=3DWARN
 [   16.785366] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
 1.16.3-debian-1.16.3-2 04/01/2014
 [   16.785367] RIP: 0010:fpstate_free+0x5/0x30
 [   16.785373] Code: 41 5c 41 5d 41 5e c3 cc cc cc cc 66 2e 0f 1f 84 00
 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00
 00 <48> 8b 47 10 48 85 c0 74 11 48 83 c7 40 48
  39 f8 74 08 48 89 c7 e9
  [   16.785374] RSP: 0000:ffffb4dd80673e48 EFLAGS: 00010246
  [   16.785376] RAX: 0000000000000000 RBX: ffff8eca5fdd0000 RCX:
  00000000801c0012
  [   16.785378] RDX: ffff8eca54bef500 RSI: ffffffff8aa9b92d RDI:
  0000000000000000
  [   16.785379] RBP: ffff8ecabbc72840 R08: ffff8eca54bed100 R09:
  00000000801c0012
  [   16.785380] R10: 00000000801c0012 R11: 0000000000000001 R12:
  ffff8eca605dc800
  [   16.785381] R13: 0000000000030bc8 R14: ffff8ecabbc728b8 R15:
  0000000000000004
  [   16.785382] FS:  00007f26f73a35c0(0000) GS:ffff8ecabbc40000(0000)
  knlGS:0000000000000000
  [   16.785383] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [   16.785385] CR2: 0000000000000010 CR3: 00000001175b6006 CR4:
  0000000000770ef0
  [   16.785389] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
  0000000000000000
  [   16.785390] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7:
  0000000000000400
  [   16.785391] PKRU: 55555554
  [   16.785392] Call Trace:
  [   16.785394]  <TASK>
  [   16.785396]  ? __die+0x1f/0x60
  [   16.785401]  ? page_fault_oops+0x158/0x460
  [   16.785406]  ? x86_task_fpu+0x17/0x20
  [   16.785410]  ? do_user_addr_fault+0x63/0x6c0
  [   16.785413]  ? exc_page_fault+0x79/0x190
  [   16.785417]  ? asm_exc_page_fault+0x22/0x30
  [   16.785420]  ? free_task+0x2d/0x70
  [   16.785424]  ? fpstate_free+0x5/0x30
  [   16.785427]  ? arch_release_task_struct+0x27/0x30
  [   16.785429]  free_task+0x35/0x70
  [   16.785432]  rcu_core+0x499/0x7d0
  [   16.785436]  ? rcu_core+0x434/0x7d0
  [   16.785440]  handle_softirqs+0xf9/0x300
  [   16.785444]  __irq_exit_rcu+0x6e/0xc0
  [   16.785446]  sysvec_apic_timer_interrupt+0x51/0xc0
  [   16.785450]  asm_sysvec_apic_timer_interrupt+0x16/0x20
  [   16.785452] RIP: 0033:0x7f26f74d0858

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

