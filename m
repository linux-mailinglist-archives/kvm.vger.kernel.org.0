Return-Path: <kvm+bounces-14136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 091ED89FBDB
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 17:41:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 752131F215FA
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 15:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24CD916EC1C;
	Wed, 10 Apr 2024 15:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ClXrfD2q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3181E878
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 15:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712763661; cv=none; b=V8+LI+0W4rrkivR2nIqR/iba/mjrdZ5RHOoO0E+z/BrDQMw0rvLbFMpDx20ENVDFixsP7TJCxTcNxODXdAScinbo48jIo/VqIPy0dCgzVo3CnjgCUjMLD0Qoe0SdIGsE5CilOQ+4+N2Znr47pSGJxRfHJkJbVicwG7s7m/or+gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712763661; c=relaxed/simple;
	bh=AFhOrALeaBEU0R7cq6xOvXPmlesCmZaBC0HJ42Bn1oo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qtgV5eAyTkC/dqBS6zloKQrW5SXKAuIqb0b1mxNChQsf4nL5SyO7PoAD7qaMFbP3qjRmkF2IWu6EzlcZ6R6IrIikwIhWXQBbgzWEfQm/5Q7Pi0uX652czpEEXZdtQt6XqIdoVeiQtpq8RjgvUeK8Ge95Iv5fMZoUnVnsUh8QO2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ClXrfD2q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4F87C433A6
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 15:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712763660;
	bh=AFhOrALeaBEU0R7cq6xOvXPmlesCmZaBC0HJ42Bn1oo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ClXrfD2qlIg9pi3R9idBk1aduyg3B6rWBEe1hZeBPqajDImWn4QKJaX7Id7CPZKLt
	 ie3cSWCZQwnxLOSQAqWhcsN3ly0ZirAhh4JG69f3YWukYHLY9OABVE6ZmrI6ezkkT7
	 agjVtFLyH0+cjjZYxyDI8zzd28ERYdVlePyJm402X4ANrFYbPi1ZQ5H4KUWpN5jG1W
	 7Mfwp+xKy6OcO6Yor4MnQunvRhydZq9ljwZAVSivF8kIPPZsz1lsZddVASHRxFFb+p
	 YotP4TuZzl2TvZNVDzZCzUEEFZrR0vopji1jsSrHhreqvr6K66C8joVyk97SZoZRSI
	 93VTjL2H2A8aQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B138CC53BD3; Wed, 10 Apr 2024 15:41:00 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218698] Kernel panic on adding vCPU to guest in Linux 6.9-rc2
Date: Wed, 10 Apr 2024 15:40:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dongli.zhang@oracle.com
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218698-28872-TQgPX5dlSs@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218698-28872@https.bugzilla.kernel.org/>
References: <bug-218698-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218698

Dongli Zhang (dongli.zhang@oracle.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dongli.zhang@oracle.com

--- Comment #4 from Dongli Zhang (dongli.zhang@oracle.com) ---
I can reproduce as well. But the callstack is different. It finally reaches=
 at
topo_set_cpuids().

/home/zhang/kvm/qemu-8.2.0/build/qemu-system-x86_64 \
-hda disk.qcow2 -m 8G -smp 4,maxcpus=3D128 -vnc :5 -enable-kvm -cpu host \
-netdev user,id=3Duser0,hostfwd=3Dtcp::5025-:22 \
-device
virtio-net-pci,netdev=3Duser0,id=3Dnet0,mac=3D12:14:10:12:14:16,bus=3Dpci.0=
,addr=3D0x3 \
-kernel /home/zhang/img/debug/mainline-linux/arch/x86_64/boot/bzImage \
-append "root=3D/dev/sda3 init=3D/sbin/init text loglevel=3D7 console=3Dtty=
S0" \
-monitor stdio

(qemu) device_add driver=3Dhost-x86_64-cpu,socket-id=3D0,core-id=3D4,thread=
-id=3D0


[   27.060885] BUG: unable to handle page fault for address: ffffffff83a697=
78
[   27.061954] #PF: supervisor write access in kernel mode
[   27.062604] #PF: error_code(0x0003) - permissions violation
[   27.063286] PGD 40c49067 P4D 40c49067 PUD 40c4a063 PMD 102213063 PTE
8000000040a69021
[   27.064273] Oops: 0003 [#1] PREEMPT SMP PTI
[   27.064799] CPU: 2 PID: 39 Comm: kworker/u256:1 Not tainted 6.9.0-rc3 #1
[   27.065611] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[   27.066992] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[   27.067669] RIP: 0010:topo_set_cpuids+0x26/0x70
[   27.068242] Code: 90 90 90 90 48 8b 05 d9 bd da 01 48 85 c0 74 31 89 ff =
48
8d 04 b8 89 30 48 8b 05 bd bd da 01 48 85 c0 74 3c 48 8d 04 b8 89 10 <f0> 4=
8 0f
ab 3d 79 9e 97 01 f0 48 0f ab 3d 40 03 df 01 c3 cc cc cc
[   27.070471] RSP: 0018:ffffc3980034bc28 EFLAGS: 00010286
[   27.071130] RAX: ffffa0bbb6f15160 RBX: 0000000000000004 RCX:
0000000000000040
[   27.072004] RDX: 0000000000000004 RSI: 0000000000000004 RDI:
0000000000000004
[   27.072858] RBP: ffffa0ba80d68540 R08: 000000000001d4c0 R09:
0000000000000001
[   27.073713] R10: 0000000000000001 R11: 0000000000000000 R12:
0000000000000004
[   27.074565] R13: ffffa0ba883b6c10 R14: ffffa0ba809a9040 R15:
0000000000000000
[   27.075418] FS:  0000000000000000(0000) GS:ffffa0bbb6e80000(0000)
knlGS:0000000000000000
[   27.076424] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   27.077121] CR2: ffffffff83a69778 CR3: 000000010f946006 CR4:
0000000000370ef0
[   27.077976] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   27.078830] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[   27.079685] Call Trace:
[   27.080031]  <TASK>
[   27.080341]  ? __die+0x1f/0x70
[   27.080755]  ? page_fault_oops+0x17b/0x490
[   27.081305]  ? search_exception_tables+0x37/0x50
[   27.081897]  ? exc_page_fault+0xba/0x160
[   27.082402]  ? asm_exc_page_fault+0x26/0x30
[   27.082929]  ? topo_set_cpuids+0x26/0x70
[   27.083432]  topology_hotplug_apic+0x54/0xa0
[   27.083979]  acpi_map_cpu+0x1c/0x80
[   27.084437]  acpi_processor_add+0x361/0x630
[   27.084968]  acpi_bus_attach+0x151/0x230
[   27.085473]  ? __pfx_acpi_dev_for_one_check+0x10/0x10
[   27.086091]  device_for_each_child+0x68/0xb0
[   27.086638]  acpi_dev_for_each_child+0x37/0x60
[   27.087197]  ? __pfx_acpi_bus_attach+0x10/0x10
[   27.087757]  acpi_bus_attach+0x89/0x230
[   27.088251]  acpi_bus_scan+0x77/0x1f0
[   27.088753]  acpi_scan_rescan_bus+0x3c/0x70
[   27.089300]  acpi_device_hotplug+0x3a3/0x480
[   27.089840]  acpi_hotplug_work_fn+0x19/0x30
[   27.090369]  process_one_work+0x14c/0x360
[   27.090880]  worker_thread+0x2c5/0x3d0
[   27.091387]  ? __pfx_worker_thread+0x10/0x10
[   27.091941]  kthread+0xd3/0x100
[   27.092361]  ? __pfx_kthread+0x10/0x10
[   27.092843]  ret_from_fork+0x2f/0x50
[   27.093309]  ? __pfx_kthread+0x10/0x10
[   27.093788]  ret_from_fork_asm+0x1a/0x30
[   27.094293]  </TASK>
[   27.094601] Modules linked in:
[   27.095007] CR2: ffffffff83a69778
[   27.095444] ---[ end trace 0000000000000000 ]---
[   27.096018] RIP: 0010:topo_set_cpuids+0x26/0x70
[   27.096590] Code: 90 90 90 90 48 8b 05 d9 bd da 01 48 85 c0 74 31 89 ff =
48
8d 04 b8 89 30 48 8b 05 bd bd da 01 48 85 c0 74 3c 48 8d 04 b8 89 10 <f0> 4=
8 0f
ab 3d 79 9e 97 01 f0 48 0f ab 3d 40 03 df 01 c3 cc cc cc
[   27.098808] RSP: 0018:ffffc3980034bc28 EFLAGS: 00010286
[   27.099452] RAX: ffffa0bbb6f15160 RBX: 0000000000000004 RCX:
0000000000000040
[   27.100305] RDX: 0000000000000004 RSI: 0000000000000004 RDI:
0000000000000004
[   27.101153] RBP: ffffa0ba80d68540 R08: 000000000001d4c0 R09:
0000000000000001
[   27.102141] R10: 0000000000000001 R11: 0000000000000000 R12:
0000000000000004
[   27.102995] R13: ffffa0ba883b6c10 R14: ffffa0ba809a9040 R15:
0000000000000000
[   27.103851] FS:  0000000000000000(0000) GS:ffffa0bbb6e80000(0000)
knlGS:0000000000000000
[   27.104857] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   27.105559] CR2: ffffffff83a69778 CR3: 000000010f946006 CR4:
0000000000370ef0
[   27.106411] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   27.107264] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400

----------------------

I am not able to reproduce with the below:

x86/topology: Don't update cpu_possible_map in topo_set_cpuids()
https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=3Dx86=
/urgent&id=3Da9025cd1c673a8d6eefc79d911075b8b452eba8f

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

