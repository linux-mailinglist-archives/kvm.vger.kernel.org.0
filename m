Return-Path: <kvm+bounces-20360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E018B9142F0
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 08:44:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2A3C1C22975
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 06:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3072C38DD2;
	Mon, 24 Jun 2024 06:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kj97fIh3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5637223746
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 06:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719211435; cv=none; b=L1NMqLxUTO1kC/0xaa6T0RRAJ2E9WhrkkJ4BRkbnKApds/RdWGJHWUBQVJsPBcQExk11GaDJJfQGzuLw7MpHW+k5EFuLgmW+FkaKKuRs8MZoY+4oO9g7bMigJPBiPVFlA4RgMdIHK98qL5I/y27oyL5bCy/OC0P6gQGhsb1NBSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719211435; c=relaxed/simple;
	bh=kVceu6gm2TW3/jqBKXlO/qgQ76OjWVBPST+VXSitG/A=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Jj49+OVv6THRoXf+I/trPm1eROkFp+MzzeTIOV/NFoa85bbdmbbVEP3kKUYuN19jfXVER/RdCH45rsPVb5iI9Abzd7ApXoSIaDRTsx6w6XMro2EVSwafFkpHH2JTuOf4tSlZlJsKU9TmQbWcpNAAY5ds9JI2cAXdS6U+gBjv/5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kj97fIh3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0C1CC4AF09
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 06:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719211434;
	bh=kVceu6gm2TW3/jqBKXlO/qgQ76OjWVBPST+VXSitG/A=;
	h=From:To:Subject:Date:From;
	b=Kj97fIh3kBiWI5uxwSMIhdlWrw6ro9iiHnlUMzq166LomjeF3DMABLUVeCzqTDsjw
	 SL/ZinFbqqvrI0mDef0H92Gp30DeoS+g3WXTdFtunUfNXh9Rl7wHTKyeRwEqFDL+Gk
	 HdeHSuPa+azCxFUTw/MzQjghpeUTJBEpBea5Gb8NINMOmr/fEzHDjj3Kw3Q87qCbKd
	 WEGYD5GVgF9nvhl59cG8FyPHFrzH8IZ+rdNo2RdHuYDTQQcKXLJ7O2lJlY74+J/L6S
	 8P0JpCsAsB7KkC0mslIlKF+koXax4yT40HmXqgG3u5b4iLzhLz8DlO06cscEebY/TL
	 yUsM+zaEMJ8bA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C5511C53BB8; Mon, 24 Jun 2024 06:43:54 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218980] New: [VM boot] Guest Kernel hit BUG: kernel NULL
 pointer dereference, address: 0000000000000010 and WARNING: CPU: 0 PID: 218
 at arch/x86/kernel/fpu/core.c:57 x86_task_fpu+0x17/0x20
Date: Mon, 24 Jun 2024 06:43:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hongyu.ning@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-218980-28872@https.bugzilla.kernel.org/>
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

            Bug ID: 218980
           Summary: [VM boot] Guest Kernel hit BUG: kernel NULL pointer
                    dereference, address: 0000000000000010 and WARNING:
                    CPU: 0 PID: 218 at arch/x86/kernel/fpu/core.c:57
                    x86_task_fpu+0x17/0x20
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: hongyu.ning@intel.com
        Regression: No

Created attachment 306485
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D306485&action=3Dedit
WARNING/BUG and Call Trace info in dmesg

in an regular linux-next guest kernel regression test setup, recently hit
following BUG and WARNING, likely related to x86/fpu.

--Test Setup--
KVM+QEMU environment to boot normal VM with latest linux-next guest kernel

--Kconfig of Guest Kernel Compile--
refer to attachment

--Error Kernel Log--
(full log refer to attachment)
[    1.958885] ------------[ cut here ]------------
[    1.958928] WARNING: CPU: 0 PID: 218 at arch/x86/kernel/fpu/core.c:57
x86_task_fpu+0x17/0x20
[    1.959004] Modules linked in:
[    1.959034] CPU: 0 PID: 218 Comm: rpcbind Not tainted
6.10.0-rc4-00234-g859e6ded5e41 #1
[    1.959092] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unk=
nown
2/2/2022
[    1.959147] RIP: 0010:x86_task_fpu+0x17/0x20
[    1.959185] Code: 40 01 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 =
90
0f 1f 44 00 00 f6 47 2e 20 48 8d 87 00 25 00 00 75 05 c3 cc cc cc cc <0f> 0=
b 31
c0 c3 cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90
[    1.959303] RSP: 0000:ffa00000009cfe08 EFLAGS: 00010202
[    1.959340] RAX: ff1100000bcad480 RBX: 0000000000000008 RCX:
0000000000244000
[    1.959394] RDX: 0000000000242000 RSI: ffffffff811368bd RDI:
ff1100000bcaaf80
[    1.959447] RBP: ff1100000bcaaf80 R08: 0000000000000000 R09:
0000000000000000
[    1.959501] R10: ff11000001835a00 R11: 0000000000000300 R12:
ff1100003d231240
[    1.959555] R13: 0000000000000007 R14: 0000000000000000 R15:
ff1100003d2312b8
[    1.959611] FS:  00007fa0908c7dc0(0000) GS:ff1100003d200000(0000)
knlGS:0000000000000000
[    1.959666] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.959715] CR2: 00007f938c6c0a56 CR3: 000000000c926006 CR4:
0000000000771ef0
[    1.959772] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[    1.959826] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7:
0000000000000400
[    1.959886] PKRU: 55555554
[    1.959908] Call Trace:
[    1.959931]  <TASK>
[    1.959953]  ? __warn+0x80/0x120
[    1.959993]  ? x86_task_fpu+0x17/0x20
[    1.960024]  ? report_bug+0x1c3/0x1d0
[    1.960058]  ? handle_bug+0x3c/0x70
[    1.960093]  ? exc_invalid_op+0x14/0x70
[    1.960123]  ? asm_exc_invalid_op+0x16/0x20
[    1.960163]  ? free_task+0x2d/0x70
[    1.960197]  ? x86_task_fpu+0x17/0x20
[    1.960228]  arch_release_task_struct+0x27/0x30
[    1.960272]  free_task+0x35/0x70
[    1.960303]  rcu_do_batch+0x1a5/0x460
[    1.960343]  ? rcu_do_batch+0x13b/0x460
[    1.960374]  ? timerqueue_add+0x9b/0xc0
[    1.960409]  rcu_core+0x148/0x300
[    1.960441]  handle_softirqs+0xfa/0x2f0
[    1.960481]  irq_exit_rcu+0x7a/0xc0
[    1.960513]  sysvec_apic_timer_interrupt+0x53/0xd0
[    1.960552]  asm_sysvec_apic_timer_interrupt+0x16/0x20
[    1.960591] RIP: 0033:0x7fa090d7c2c1
[    1.960628] Code: 83 c4 01 48 89 c2 0f b7 04 41 f6 c4 20 75 ea 84 d2 74 =
32
4c 89 e2 eb 12 90 48 0f be 42 01 48 83 c2 01 84 c0 74 73 0f b7 04 41 <f6> c=
4 20
74 ea 49 39 d4 72 55 0f b6 02 49 89 d4 84 c0 74 07 c6 02
[    1.960745] RSP: 002b:00007ffe6875df10 EFLAGS: 00000246
[    1.960783] RAX: 000000000000c608 RBX: 00007ffe6875e0f0 RCX:
00007fa090d9f3c0
[    1.960837] RDX: 00007ffe6875e5da RSI: 00007ffe6875e600 RDI:
1999999999999999
[    1.960893] RBP: 00007ffe6875e5d0 R08: ffffffffffffff00 R09:
0000000000000000
[    1.960945] R10: 00007fa090d9eac0 R11: 00007fa090d9f3c0 R12:
00007ffe6875e5da
[    1.960999] R13: 00007ffe6875e9c0 R14: 00007ffe6875e600 R15:
00007ffe6875e5c0
[    1.961054]  </TASK>
[    1.961075] ---[ end trace 0000000000000000 ]---
[    1.961114] BUG: kernel NULL pointer dereference, address: 0000000000000=
010
[    1.961158] #PF: supervisor read access in kernel mode
[    1.961196] #PF: error_code(0x0000) - not-present page
[    1.961235] PGD bff8067 P4D 0
[    1.961266] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
[    1.961304] CPU: 0 PID: 218 Comm: rpcbind Tainted: G        W=20=20=20=
=20=20=20=20=20=20
6.10.0-rc4-00234-g859e6ded5e41 #1
[    1.961366] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unk=
nown
2/2/2022
[    1.961412] RIP: 0010:fpstate_free+0x5/0x30
[    1.961441] Code: 41 5c 41 5d 41 5e c3 cc cc cc cc 66 2e 0f 1f 84 00 00 =
00
00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 <4c> 8=
b 47
10 4d 85 c0 74 11 48 83 c7 40 49 39 f8 74 08 4c 89 c7 e9
[    1.961552] RSP: 0000:ffa00000009cfe10 EFLAGS: 00010246
[    1.961589] RAX: 0000000000000000 RBX: 0000000000000008 RCX:
0000000000244000
[    1.961646] RDX: 0000000000242000 RSI: ffffffff811368bd RDI:
0000000000000000
[    1.961700] RBP: ff1100000bcaaf80 R08: 0000000000000000 R09:
0000000000000000
[    1.961755] R10: ff11000001835a00 R11: 0000000000000300 R12:
ff1100003d231240
[    1.961802] R13: 0000000000000007 R14: 0000000000000000 R15:
ff1100003d2312b8
[    1.961849] FS:  00007fa0908c7dc0(0000) GS:ff1100003d200000(0000)
knlGS:0000000000000000
[    1.961911] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.961957] CR2: 0000000000000010 CR3: 000000000c926006 CR4:
0000000000771ef0
[    1.962005] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[    1.962056] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7:
0000000000000400
[    1.962102] PKRU: 55555554
[    1.962118] Call Trace:
[    1.962135]  <TASK>
[    1.962155]  ? __die+0x20/0x70
[    1.962186]  ? page_fault_oops+0x80/0x150
[    1.962216]  ? do_user_addr_fault+0x5f/0x680
[    1.962254]  ? kvm_read_and_reset_apf_flags+0x45/0x60
[    1.962292]  ? exc_page_fault+0x64/0x140
[    1.962322]  ? asm_exc_page_fault+0x22/0x30
[    1.962352]  ? free_task+0x2d/0x70
[    1.962383]  ? fpstate_free+0x5/0x30
[    1.962415]  free_task+0x35/0x70
[    1.962446]  rcu_do_batch+0x1a5/0x460
[    1.962478]  ? rcu_do_batch+0x13b/0x460
[    1.962510]  ? timerqueue_add+0x9b/0xc0
[    1.962540]  rcu_core+0x148/0x300
[    1.962568]  handle_softirqs+0xfa/0x2f0
[    1.962598]  irq_exit_rcu+0x7a/0xc0
[    1.962632]  sysvec_apic_timer_interrupt+0x53/0xd0
[    1.962670]  asm_sysvec_apic_timer_interrupt+0x16/0x20
[    1.962709] RIP: 0033:0x7fa090d7c2c1
[    1.962740] Code: 83 c4 01 48 89 c2 0f b7 04 41 f6 c4 20 75 ea 84 d2 74 =
32
4c 89 e2 eb 12 90 48 0f be 42 01 48 83 c2 01 84 c0 74 73 0f b7 04 41 <f6> c=
4 20
74 ea 49 39 d4 72 55 0f b6 02 49 89 d4 84 c0 74 07 c6 02
[    1.962862] RSP: 002b:00007ffe6875df10 EFLAGS: 00000246
[    1.962899] RAX: 000000000000c608 RBX: 00007ffe6875e0f0 RCX:
00007fa090d9f3c0
[    1.962946] RDX: 00007ffe6875e5da RSI: 00007ffe6875e600 RDI:
1999999999999999
[    1.962992] RBP: 00007ffe6875e5d0 R08: ffffffffffffff00 R09:
0000000000000000
[    1.963045] R10: 00007fa090d9eac0 R11: 00007fa090d9f3c0 R12:
00007ffe6875e5da
[    1.963090] R13: 00007ffe6875e9c0 R14: 00007ffe6875e600 R15:
00007ffe6875e5c0
[    1.963137]  </TASK>
[    1.963158] Modules linked in:
[    1.963189] CR2: 0000000000000010
[    1.963220] ---[ end trace 0000000000000000 ]---
[    1.967997] RIP: 0010:fpstate_free+0x5/0x30
[    1.968033] Code: 41 5c 41 5d 41 5e c3 cc cc cc cc 66 2e 0f 1f 84 00 00 =
00
00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 <4c> 8=
b 47
10 4d 85 c0 74 11 48 83 c7 40 49 39 f8 74 08 4c 89 c7 e9
[    1.968146] RSP: 0000:ffa00000009cfe10 EFLAGS: 00010246
[    1.968183] RAX: 0000000000000000 RBX: 0000000000000008 RCX:
0000000000244000
[    1.968232] RDX: 0000000000242000 RSI: ffffffff811368bd RDI:
0000000000000000
[    1.968287] RBP: ff1100000bcaaf80 R08: 0000000000000000 R09:
0000000000000000
[    1.968335] R10: ff11000001835a00 R11: 0000000000000300 R12:
ff1100003d231240
[    1.968389] R13: 0000000000000007 R14: 0000000000000000 R15:
ff1100003d2312b8
[    1.968436] FS:  00007fa0908c7dc0(0000) GS:ff1100003d200000(0000)
knlGS:0000000000000000
[    1.968490] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.968535] CR2: 0000000000000010 CR3: 000000000c926006 CR4:
0000000000771ef0
[    1.968587] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[    1.968641] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7:
0000000000000400
[    1.968688] PKRU: 55555554
[    1.968705] Kernel panic - not syncing: Fatal exception in interrupt
[    1.968769] Kernel Offset: disabled
[    1.973595] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt ]---

--Notes on Issue Observed--
a. issue seen since linux-next-6.10-rc3-240611
b. issue reproduced on
https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git master branch
c. issue hit around 90% of VM booting cycles, not 100% reproducible
d. git bisect points to
https://lore.kernel.org/all/20240605083557.2051480-4-mingo@kernel.org as bad
commit
e. attachment info:
e1: kconfig.config -> guest kernel kconfig
e2: vm_boot_null_pointer_panic_and_fpu_warning.log -> full guest kernel boo=
ting
log when issue hit
e3: vm_boot_pass.log -> full guest kernel booting log when no issue hit

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

