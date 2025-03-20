Return-Path: <kvm+bounces-41574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 345B2A6A946
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 16:01:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE372188B942
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F07DC1E1022;
	Thu, 20 Mar 2025 14:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aT7+tXaF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264131876
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 14:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742482367; cv=none; b=c84GX0xg93eNYoegSIpNDMh4CO9eB8YDRmBLJPZXHu7Oa/g6hrYGulPcHCIFb3zc5lJBEilqXKiF0GM+nVDU3HkW/+xQpfKN7ycjE2HmvijxAvaB5zAXeAGB2UZeKXGn2FcifnQREXOJPlLMNgNjaqdShLCQcrpw4PhZBvBLDCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742482367; c=relaxed/simple;
	bh=4Mtsi1lUPZWMOHsLE5nqVh7xD1VC5GF56Dq25rn3zMc=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=jdBrQvaxQUW7+P35ZdOLq56oXftyt0PzRLbTjauEzGkrslV73XL2Xv4ttI3gMxme72jjG9U6O/fT2T2M0zHGJonUQl4/OBrVlnb3da+9dCBJiUhKn+P9mFTxtz8Ptoap2HFDzQlTUQPlEohoWqCElnapbQPqmzDanjLBgpvXY/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aT7+tXaF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98716C4CEE7
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 14:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742482366;
	bh=4Mtsi1lUPZWMOHsLE5nqVh7xD1VC5GF56Dq25rn3zMc=;
	h=From:To:Subject:Date:From;
	b=aT7+tXaFJAItMA4FlKRpZ+NY0xNDAxtn+jmneNyLoM5DlPHQ+Nr9zMCAgumkruJ2x
	 c3TiNEG2Aj7vUKm3qzOl9sil3UqxDx5FGafoaRoSOj93+eBOVFSsjBjihwyKmJZpxv
	 U24N7kdhgvn3ygN2YpGw31dITq690Oq+stzGI3V7BkYRFp0lbeQzlFMhBMegQ8klZa
	 vC4HzHVg6ZXRhFxqCu3QQnYuEbRZ3u1ByzcsSg9s125296zrVxHysb+thIxfY8q3+W
	 w3iuVNwbCWYYx1ioGU6QbOyOrutIWJj2YrEPfByqiR2aLtrQZz9c7Ri7EHhuGxh751
	 N2Hg3oEF6xh2g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 850A5C433E1; Thu, 20 Mar 2025 14:52:46 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219900] New: Guest kernel hit kernel panic when used some
 virtio-net options
Date: Thu, 20 Mar 2025 14:52:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: leiyang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219900-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219900

            Bug ID: 219900
           Summary: Guest kernel hit kernel panic when used some
                    virtio-net options
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: low
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: leiyang@redhat.com
        Regression: No

1. Boot up guest with some qemu options
/usr/libexec/qemu-kvm \
-M q35 \
-m 16G \
-smp 12 \
-cpu host \
-device VGA,bus=3Dpcie.0,addr=3D0x2 \
-drive file=3D//home/L1.qcow2,media=3Ddisk,if=3Dvirtio \
-device
virtio-net-pci,id=3Dnet0,netdev=3Dhostnet0,ctrl_vq=3Doff,ctrl_rx=3Doff,ctrl=
_vlan=3Doff,ctrl_mac_addr=3Doff,guest_announce=3Doff,guest_csum=3Doff,bus=
=3Dpcie.0,addr=3D0x5
\
-netdev tap,id=3Dhostnet0 \
-serial unix:/tmp/monitor1,server,nowait \
-vnc :0  \
-monitor stdio \

2. Guest can not boot up and hit kernel call trace=EF=BC=88Sometimes this p=
roblem need
to reboot then reproduced=EF=BC=89
[   12.048169] BUG: kernel NULL pointer dereference, address: 0000000000000=
010
[   12.049665] #PF: supervisor write access in kernel mode
[   12.050707] [drm] Initialized bochs-drm 1.0.0 20130925 for 0000:00:02.0 =
on
minor 0
[   12.050732] #PF: error_code(0x0002) - not-present page
[   12.050735] PGD 0 P4D 0=20
[   12.054129] Oops: 0002 [#1] PREEMPT SMP PTI
[   12.055931] CPU: 4 PID: 702 Comm: (udev-worker) Not tainted 6.3.0-rc7 #3
[   12.058052] Hardware name: Red Hat KVM/RHEL, BIOS 1.16.1-1.el9 04/01/2014
[   12.058056] RIP: 0010:virtnet_set_guest_offloads+0x4c/0xc0 [virtio_net]
[   12.058090] Code: 48 8b 87 f8 00 00 00 48 c7 04 24 00 00 00 00 48 c7 44 =
24
08 00 00 00 00 48 c7 44 24 10 00 00 00 00 48 c7 44 24 18 00 00 00 00 <48> 8=
9 70
10 48 8b 87 f8 00 00 00 48 89 e7 48 8d 70 10 e8 dd f5 0a
[   12.058093] RSP: 0018:ffffb41ac07d7a88 EFLAGS: 00010246
[   12.058097] RAX: 0000000000000000 RBX: ffff8e553d27c9c0 RCX:
0000000000000000
[   12.058102] RDX: 0000000000000008 RSI: 0000000000000000 RDI:
ffff8e553d27c9c0
[   12.058104] RBP: 0000000000174829 R08: ffffffffb6eabb60 R09:
ffff8e553d27c0a0
[   12.058106] R10: 0000000000000008 R11: 0000000000000000 R12:
ffff8e553d27c9c0
[   12.058108] R13: 0000000000000000 R14: 0000000000000000 R15:
ffff8e55029d2800
[   12.058110] FS:  00007f3d05923b40(0000) GS:ffff8e586fb00000(0000)
knlGS:0000000000000000
[   12.058113] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.058115] CR2: 0000000000000010 CR3: 000000013a41c001 CR4:
0000000000170ee0
[   12.058120] Call Trace:
[   12.058131]  <TASK>
[   12.058135]  virtnet_set_features+0x64/0xd0 [virtio_net]
[   12.058148]  __netdev_update_features+0x2a7/0xb70
[   12.058164]  ? preempt_count_add+0x6a/0xa0
[   12.058173]  ? _raw_spin_unlock_irq+0x1b/0x40
[   12.058182]  ? pm_runtime_set_memalloc_noio+0x5e/0xa0
[   12.058189]  register_netdevice+0x426/0x670
[   12.058195]  virtnet_probe+0x5b8/0xca0 [virtio_net]
[   12.058208]  virtio_dev_probe+0x1af/0x260
[   12.058219]  really_probe+0x1a2/0x400
[   12.058226]  ? __pfx___driver_attach+0x10/0x10
[   12.058230]  __driver_probe_device+0x78/0x170
[   12.058233]  driver_probe_device+0x1f/0x90
[   12.058237]  __driver_attach+0xce/0x1c0
[   12.058241]  bus_for_each_dev+0x84/0xd0
[   12.058244]  bus_add_driver+0x112/0x210
[   12.058248]  driver_register+0x55/0x100
[   12.058252]  ? __pfx_init_module+0x10/0x10 [virtio_net]
[   12.058263]  virtio_net_driver_init+0x8a/0xff0 [virtio_net]
[   12.058273]  ? __pfx_init_module+0x10/0x10 [virtio_net]
[   12.058282]  do_one_initcall+0x59/0x230
[   12.058292]  do_init_module+0x4a/0x210
[   12.058300]  __do_sys_finit_module+0xac/0x120
[   12.058306]  do_syscall_64+0x5b/0x80
[   12.058355]  ? syscall_exit_to_user_mode+0x17/0x40
[   12.058360]  ? do_syscall_64+0x67/0x80
[   12.058362]  ? do_syscall_64+0x67/0x80
[   12.058364]  ? do_syscall_64+0x67/0x80
[   12.058365]  ? exc_page_fault+0x70/0x170
[   12.058369]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[   12.058379] fbcon: bochs-drmdrmfb (fb0) is primary device
[   12.058380] RIP: 0033:0x7f3d0632792d
[   12.058385] Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89
f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3=
d 01
f0 ff ff 73 01 c3 48 8b 0d d3 e4 0c 00 f7 d8 64 89 01 48
[   12.058388] RSP: 002b:00007fffc444e2f8 EFLAGS: 00000246 ORIG_RAX:
0000000000000139
[   12.058391] RAX: ffffffffffffffda RBX: 00005617f91e4f50 RCX:
00007f3d0632792d
[   12.058393] RDX: 0000000000000000 RSI: 00007f3d06826453 RDI:
000000000000000e
[   12.058395] RBP: 00007f3d06826453 R08: 0000000000000000 R09:
00007fffc444e420
[   12.058397] R10: 000000000000000e R11: 0000000000000246 R12:
0000000000020000
[   12.058400] R13: 00005617f91e45d0 R14: 0000000000000000 R15:
00005617f91e5f90
[   12.058403]  </TASK>
[   12.058405] Modules linked in: intel_cstate(+) intel_uncore(-) virtio_ne=
t(+)
bochs(+) joydev drm_vram_helper net_failover i2c_i801 drm_ttm_helper failov=
er
ttm i2c_smbus pcspkr acpi_cpufreq(-) lpc_ich fuse loop zram crct10dif_pclmul
crc32_pclmul crc32c_intel polyval_clmulni polyval_generic ghash_clmulni_int=
el
sha512_ssse3 serio_raw virtio_blk qemu_fw_cfg
[   12.058451] CR2: 0000000000000010
[   12.058516] ---[ end trace 0000000000000000 ]---
[   12.058519] RIP: 0010:virtnet_set_guest_offloads+0x4c/0xc0 [virtio_net]
[   12.058530] Code: 48 8b 87 f8 00 00 00 48 c7 04 24 00 00 00 00 48 c7 44 =
24
08 00 00 00 00 48 c7 44 24 10 00 00 00 00 48 c7 44 24 18 00 00 00 00 <48> 8=
9 70
10 48 8b 87 f8 00 00 00 48 89 e7 48 8d 70 10 e8 dd f5 0a
[   12.058532] RSP: 0018:ffffb41ac07d7a88 EFLAGS: 00010246
[   12.058535] RAX: 0000000000000000 RBX: ffff8e553d27c9c0 RCX:
0000000000000000
[   12.058537] RDX: 0000000000000008 RSI: 0000000000000000 RDI:
ffff8e553d27c9c0
[   12.058538] RBP: 0000000000174829 R08: ffffffffb6eabb60 R09:
ffff8e553d27c0a0
[   12.058541] R10: 0000000000000008 R11: 0000000000000000 R12:
ffff8e553d27c9c0
[   12.058543] R13: 0000000000000000 R14: 0000000000000000 R15:
ffff8e55029d2800
[   12.058545] FS:  00007f3d05923b40(0000) GS:ffff8e586fb00000(0000)
knlGS:0000000000000000
[   12.058547] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.058548] CR2: 0000000000000010 CR3: 000000013a41c001 CR4:
0000000000170ee0
[   12.065375] Adding 8388604k swap on /dev/zram0.  Priority:100 extents:1
across:8388604k SSDscFS

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

