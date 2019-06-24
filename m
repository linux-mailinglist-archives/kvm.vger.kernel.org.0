Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46E4F51B39
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 21:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbfFXTJr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 24 Jun 2019 15:09:47 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59250 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725881AbfFXTJr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jun 2019 15:09:47 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A5F9028BAC
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2019 19:09:45 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 9964F28B7B; Mon, 24 Jun 2019 19:09:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203979] New: kvm_spurious_fault in L1 when running a nested kvm
 instance on AMD i686-pae
Date:   Mon, 24 Jun 2019 19:09:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jpalecek@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-203979-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203979

            Bug ID: 203979
           Summary: kvm_spurious_fault in L1 when running a nested kvm
                    instance on AMD i686-pae
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.2-rc6
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: jpalecek@web.de
        Regression: No

Hello,

when I try to run a freedos nested in linux kvm guest on kernel 5.2-rc6, I get
this message in L1 guest:

debian login: [   13.291265] FS-Cache: Loaded
[   13.295627] 9p: Installing v9fs 9p2000 file system support
[   13.296946] FS-Cache: Netfs '9p' registered for caching
[   19.200271] ------------[ cut here ]------------
[   19.201265] kernel BUG at arch/x86/kvm/x86.c:358!
[   19.202069] invalid opcode: 0000 [#1] SMP NOPTI
[   19.202850] CPU: 0 PID: 270 Comm: qemu-system-i38 Not tainted
5.2.0-rc6-bughunt+ #1
[   19.203568] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.12.0-1 04/01/2014
[   19.203568] EIP: kvm_spurious_fault+0x8/0x10 [kvm]
[   19.203568] Code: 08 ff 75 18 ff 75 14 ff 75 10 ff 75 0c 57 56 e8 5e 09 3d
fa 83 c4 30 8d 65 f8 5e 5f 5d c3 8d 74 26 00 0f 1f 44 00 00 55 89 e5 <0f> 0b 8d
b6 00 00 00 00 0f 1f 44 00 00 55 89 e5 57 56 53 83 ec 04
[   19.203568] EAX: 0004c000 EBX: 00000000 ECX: 00000000 EDX: 00000663
[   19.203568] ESI: 00000000 EDI: 00000000 EBP: c0037da4 ESP: c0037da4
[   19.203568] DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068 EFLAGS: 00210246
[   19.203568] CR0: 80050033 CR2: 00cd813b CR3: 04e7f820 CR4: 000006f0
[   19.203568] Call Trace:
[   19.203568]  svm_vcpu_run+0x1a5/0x650 [kvm_amd]
[   19.203568]  ? kvm_ioapic_scan_entry+0x62/0xe0 [kvm]
[   19.203568]  ? kvm_arch_vcpu_ioctl_run+0x596/0x1a80 [kvm]
[   19.203568]  ? _cond_resched+0x17/0x30
[   19.203568]  ? kvm_vcpu_ioctl+0x214/0x590 [kvm]
[   19.203568]  ? kvm_vcpu_ioctl+0x214/0x590 [kvm]
[   19.203568]  ? __bpf_trace_kvm_async_pf_nopresent_ready+0x20/0x20 [kvm]
[   19.203568]  ? do_vfs_ioctl+0x9a/0x6c0
[   19.203568]  ? tomoyo_path_chmod+0x20/0x20
[   19.203568]  ? tomoyo_file_ioctl+0x19/0x20
[   19.203568]  ? security_file_ioctl+0x30/0x50
[   19.203568]  ? ksys_ioctl+0x56/0x80
[   19.203568]  ? sys_ioctl+0x16/0x20
[   19.203568]  ? do_fast_syscall_32+0x87/0x1df
[   19.203568]  ? entry_SYSENTER_32+0x6b/0xbe
[   19.203568] Modules linked in: 9p fscache ppdev edac_mce_amd kvm_amd
9pnet_virtio kvm bochs_drm 9pnet irqbypass ttm snd_pcm snd_timer snd
drm_kms_helper soundcore joydev pcspkr evdev serio_raw drm sg parport_pc
parport button ip_tables x_tables autofs4 ext4 crc32c_generic crc16 mbcache
jbd2 sr_mod cdrom sd_mod ata_generic ata_piix libata psmouse virtio_pci
virtio_ring virtio e1000 scsi_mod i2c_piix4 floppy
[   19.203568] ---[ end trace c0c327b925400cd6 ]---
[   19.203568] EIP: kvm_spurious_fault+0x8/0x10 [kvm]
[   19.203568] Code: 08 ff 75 18 ff 75 14 ff 75 10 ff 75 0c 57 56 e8 5e 09 3d
fa 83 c4 30 8d 65 f8 5e 5f 5d c3 8d 74 26 00 0f 1f 44 00 00 55 89 e5 <0f> 0b 8d
b6 00 00 00 00 0f 1f 44 00 00 55 89 e5 57 56 53 83 ec 04
[   19.203568] EAX: 0004c000 EBX: 00000000 ECX: 00000000 EDX: 00000663
[   19.203568] ESI: 00000000 EDI: 00000000 EBP: c0037da4 ESP: c3a71dfc
[   19.203568] DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068 EFLAGS: 00210246
[   19.203568] CR0: 80050033 CR2: 00cd813b CR3: 04e7f820 CR4: 000006f0

svm_vcpu_run+0x1a5 is the vmsave instruction. The bug seems to be only
dependent on the L0 host, where version 5.1 works, but 5.2 fails. Linux version
of the L1 guest doesn't seem to matter. (I'm running a pae system but didn't
actually test if it has anything to do with pae)

Any ideas about what could have caused it?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
