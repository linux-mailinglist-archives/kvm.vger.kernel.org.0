Return-Path: <kvm+bounces-19144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1B4790184B
	for <lists+kvm@lfdr.de>; Sun,  9 Jun 2024 23:27:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D69761C20976
	for <lists+kvm@lfdr.de>; Sun,  9 Jun 2024 21:27:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9252550249;
	Sun,  9 Jun 2024 21:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPd5D5JP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAFB4DA0C
	for <kvm@vger.kernel.org>; Sun,  9 Jun 2024 21:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717968445; cv=none; b=uKGfI4W1B1c69mPmacIToBOON2lYOeRIgJUV8ZMWPp8zHd2/Wj7fXoWOqmqa61uJi/svGhxXjHgsrGF5KDdDGLsa9Bv+kEDv8PO40xSTHaOSHd8GKmvRYwCx2/Sd4nBksaqiHOUupY78rdX7D2fgjo1lXfKmps/XZMVY6ZTzqy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717968445; c=relaxed/simple;
	bh=If1bhvO3Y9Z5Gs8QUAyMh4SR5rxxOnQUmer64UJoU7Y=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=dN2f3t8Tb8xClw7ohbsVUQKPAz+8JGSRs5I+EOzwoYDkt1CrNEja44bpKQtUAVOznzmC0C2LjMgHCPzajiE2V397YTyixMeFzBvHTqY7wl9hHPCagv2162Wpu905+ImKcUxkQpls7SQFBMw1o/e8Tr1gpf7uyjsRwsavjLNERo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPd5D5JP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B3B3C4AF1C
	for <kvm@vger.kernel.org>; Sun,  9 Jun 2024 21:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717968445;
	bh=If1bhvO3Y9Z5Gs8QUAyMh4SR5rxxOnQUmer64UJoU7Y=;
	h=From:To:Subject:Date:From;
	b=mPd5D5JPKLZNs1VA68JMZXBt4OmBJhTSjb1GH4B6EmmzxQWicSafP/AVFPzhsEk9k
	 md8h/6SCvCjtG25gb2HNrqWc8PmuDzFn/z2vXX0KSkUEhrxkkot+DBf/tB4gEsYXr2
	 ikBZpXSHmZcaB6lywPsoeMRL5U0HPU2pnmnifxvl55u9FjMXONB8mCX63CZ8KlbD+B
	 ZNA9SAWH0/ypBC2/pK6ylcfB1Nd8MpCpFjCgRX2I4Z3aYGuy1Ty9LSOjmN6quECe4z
	 A12JIa1s4jRm9ECdaAZuUR0IDj6QeZr4McNEp1byuSZT94v7FJ+/roF6KxzEdU+FpJ
	 sq2rN1SpUx9Qg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1F494C53BB8; Sun,  9 Jun 2024 21:27:25 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218949] New: Kernel panic after upgrading to 6.10-rc2
Date: Sun, 09 Jun 2024 21:27:24 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: badouri.g@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-218949-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218949

            Bug ID: 218949
           Summary: Kernel panic after upgrading to 6.10-rc2
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: badouri.g@gmail.com
        Regression: No

Created attachment 306446
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D306446&action=3Dedit
full logfile (zipped)

I've decided to try out 6.10-rc2 on my proxmox machine running on a Zen2
Threadripiper because of all the amd-pstate improvements.
During bootup I notice it prints a lot of kernel panics in the logs.

They mostly look like this:

Jun 09 23:11:23 pve kernel: ------------[ cut here ]------------
Jun 09 23:11:23 pve kernel: WARNING: CPU: 9 PID: 1870 at
include/linux/rwsem.h:85 remap_pfn_range_notrack+0x4a5/0x590
Jun 09 23:11:23 pve kernel: Modules linked in: rpcsec_gss_krb5 auth_rpcgss
nfsv4 nfs lockd grace netfs veth ebtable_filter ebtables ip_set ip6table_raw
iptable_raw ip6table_filter ip6_tables iptable_filter scsi_transport_iscsi
nf_tables bonding tls softdog sunrpc nfnetl>
Jun 09 23:11:23 pve kernel:  xhci_hcd i2c_piix4 wmi
Jun 09 23:11:23 pve kernel: CPU: 9 PID: 1870 Comm: CPU 0/KVM Tainted: G=20=
=20=20=20=20=20=20
W  OE      6.10.0-rc2 #3
Jun 09 23:11:23 pve kernel: Hardware name: ASUS System Product Name/ROG ZEN=
ITH
II EXTREME, BIOS 2102 02/16/2024
Jun 09 23:11:23 pve kernel: RIP: 0010:remap_pfn_range_notrack+0x4a5/0x590
Jun 09 23:11:23 pve kernel: Code: 45 31 d2 45 31 db e9 2a f2 d2 00 48 8b 7d=
 b8
48 89 c6 e8 ce 95 ff ff 85 c0 0f 84 66 fe ff ff eb a6 0f 0b b9 ea ff ff ff =
eb
a2 <0f> 0b e9 e9 fb ff ff 0f 0b 48 8b 7d b8 4c 89 fa 4c 89 ce 4c 89 4d
Jun 09 23:11:23 pve kernel: RSP: 0018:ffffb640c103f900 EFLAGS: 00010246
Jun 09 23:11:23 pve kernel: RAX: 000000802d0644fb RBX: ffff9485c89ea730 RCX:
0000000000100000
Jun 09 23:11:23 pve kernel: RDX: 0000000000000000 RSI: ffff9485e489bc80 RDI:
ffff9485c89ea730
Jun 09 23:11:23 pve kernel: RBP: ffffb640c103f9b8 R08: 8000000000000037 R09:
0000000000000000
Jun 09 23:11:23 pve kernel: R10: 0000000000000000 R11: 0000000000000000 R12:
00000000000c2100
Jun 09 23:11:23 pve kernel: R13: 00007f8a50200000 R14: 8000000000000037 R15:
00007f8a50100000
Jun 09 23:11:23 pve kernel: FS:  00007f8a4aa006c0(0000)
GS:ffff94a47dc80000(0000) knlGS:0000000000000000
Jun 09 23:11:23 pve kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000800500=
33
Jun 09 23:11:23 pve kernel: CR2: 00007f8a352ae000 CR3: 0000000117588000 CR4:
0000000000350ef0
Jun 09 23:11:23 pve kernel: Call Trace:
Jun 09 23:11:23 pve kernel:  <TASK>
Jun 09 23:11:23 pve kernel:  ? show_regs+0x6c/0x80
Jun 09 23:11:23 pve kernel:  ? __warn+0x88/0x140
Jun 09 23:11:23 pve kernel:  ? remap_pfn_range_notrack+0x4a5/0x590
Jun 09 23:11:23 pve kernel:  ? report_bug+0x182/0x1b0
Jun 09 23:11:23 pve kernel:  ? handle_bug+0x46/0x90
Jun 09 23:11:23 pve kernel:  ? exc_invalid_op+0x18/0x80
Jun 09 23:11:23 pve kernel:  ? asm_exc_invalid_op+0x1b/0x20
Jun 09 23:11:23 pve kernel:  ? remap_pfn_range_notrack+0x4a5/0x590
Jun 09 23:11:23 pve kernel:  ? track_pfn_remap+0x139/0x140
Jun 09 23:11:23 pve kernel:  ? down_write+0x12/0x80
Jun 09 23:11:23 pve kernel:  remap_pfn_range+0x5c/0xc0
Jun 09 23:11:23 pve kernel:  ? srso_return_thunk+0x5/0x5f
Jun 09 23:11:23 pve kernel:  vfio_pci_mmap_fault+0xb1/0x180 [vfio_pci_core]
Jun 09 23:11:23 pve kernel:  __do_fault+0x3b/0x130
Jun 09 23:11:23 pve kernel:  do_fault+0xc5/0x490
Jun 09 23:11:23 pve kernel:  ? srso_return_thunk+0x5/0x5f
Jun 09 23:11:23 pve kernel:  __handle_mm_fault+0x842/0x1100
Jun 09 23:11:23 pve kernel:  handle_mm_fault+0x197/0x340
Jun 09 23:11:23 pve kernel:  fixup_user_fault+0x91/0x1e0
Jun 09 23:11:23 pve kernel:  vaddr_get_pfns+0x10e/0x280 [vfio_iommu_type1]
Jun 09 23:11:23 pve kernel:  vfio_pin_pages_remote+0x39f/0x520
[vfio_iommu_type1]
Jun 09 23:11:23 pve kernel:  ? srso_return_thunk+0x5/0x5f
Jun 09 23:11:23 pve kernel:  ? alloc_pages_mpol_noprof+0xd9/0x1f0
Jun 09 23:11:23 pve kernel:  vfio_iommu_type1_ioctl+0x10ad/0x1ad0
[vfio_iommu_type1]
Jun 09 23:11:23 pve kernel:  vfio_fops_unl_ioctl+0x6b/0x380 [vfio]
Jun 09 23:11:23 pve kernel:  __x64_sys_ioctl+0xa3/0xf0
Jun 09 23:11:23 pve kernel:  x64_sys_call+0xa68/0x24d0
Jun 09 23:11:23 pve kernel:  do_syscall_64+0x70/0x160
Jun 09 23:11:23 pve kernel:  ? srso_return_thunk+0x5/0x5f
Jun 09 23:11:23 pve kernel:  ? irqentry_exit+0x43/0x50
Jun 09 23:11:23 pve kernel:  ? srso_return_thunk+0x5/0x5f
Jun 09 23:11:23 pve kernel:  ? exc_page_fault+0x93/0x1b0
Jun 09 23:11:23 pve kernel:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
Jun 09 23:11:23 pve kernel: RIP: 0033:0x7f8a5cb8cc5b
Jun 09 23:11:23 pve kernel: Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7=
 04
24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 =
0f
05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
Jun 09 23:11:23 pve kernel: RSP: 002b:00007f8a4a9faa40 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
Jun 09 23:11:23 pve kernel: RAX: ffffffffffffffda RBX: 0000560ed91739b0 RCX:
00007f8a5cb8cc5b
Jun 09 23:11:23 pve kernel: RDX: 00007f8a4a9faaa0 RSI: 0000000000003b71 RDI:
000000000000003e
Jun 09 23:11:23 pve kernel: RBP: 0000000081c00000 R08: 0000000000000000 R09:
0000000000000000
Jun 09 23:11:23 pve kernel: R10: 00000000000fe000 R11: 0000000000000246 R12:
00000000000fe000
Jun 09 23:11:23 pve kernel: R13: 00000000000fe000 R14: 00007f8a4a9faaa0 R15:
00007f8a4a9fabf0
Jun 09 23:11:23 pve kernel:  </TASK>
Jun 09 23:11:23 pve kernel: ---[ end trace 0000000000000000 ]---

But I've attached a full log containing all the panics.
The systems seems to run stable otherwise.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

