Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50FC44A4AF
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 17:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbfFRPB2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 18 Jun 2019 11:01:28 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50050 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729038AbfFRPB2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jun 2019 11:01:28 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1B31028A73
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 15:01:27 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 0E99F28B17; Tue, 18 Jun 2019 15:01:27 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203923] New: Running a nested freedos results in NULL pointer
 dereference in L0 (kvm_mmu_load)
Date:   Tue, 18 Jun 2019 15:01:25 +0000
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
Message-ID: <bug-203923-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=203923

            Bug ID: 203923
           Summary: Running a nested freedos results in NULL pointer
                    dereference in L0 (kvm_mmu_load)
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.1
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

while I was playing around with kvm and trying nested virtual machines, I got
OOPS on the hardware machine. I ran

$ qemu-system-i386 -enable-kvm -virtfs
local,path=.,security_model=none,mount_tag=hostfs -cpu host
/mnt/extras/src/qemu-image-autopkgtest2

and inside the machine, I ran a freedos install image residing in teh currect
directory (ie. through the virtfs mount). The image is running a 5.2-rc4
kernel; note that when I run a 4.19 kernel as the L1 guest it seems to work. It
crashed very early, before the nested system prints anything to the screen. The
error on L0 was:


[  505.814203] BUG: unable to handle kernel NULL pointer dereference at
00000000
[  505.814208] #PF error: [WRITE]
[  505.814209] *pdpt = 0000000015f1f001 *pde = 0000000000000000 
[  505.814212] Oops: 0002 [#1] SMP NOPTI
[  505.814216] CPU: 1 PID: 2292 Comm: qemu-system-i38 Tainted: P           O   
  5.1.0-bughunt+ #2
[  505.814217] Hardware name: System manufacturer System Product Name/M4N68T-M,
BIOS 1301    07/05/2011
[  505.814234] EIP: kvm_mmu_load+0x292/0x4c0 [kvm]
[  505.814236] Code: 55 e8 e8 d1 f0 ff ff 8b 48 20 ff 40 28 8b 07 81 c1 00 00
00 40 c6 00 00 0f 1f 00 8b 87 68 02 00 00 0b 4d dc 8b 80 88 00 00 00 <89> 0c 30
c7 44 30 04 00 00 00 00 e9 6b ff ff ff 8d b6 00 00 00 00
[  505.814238] EAX: 00000000 EBX: 00000000 ECX: 1267a001 EDX: d30c7d6c
[  505.814239] ESI: 00000000 EDI: d2538000 EBP: d30c7dd0 ESP: d30c7d9c
[  505.814241] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00210202
[  505.814242] CR0: 80050033 CR2: 00000000 CR3: 223e2e40 CR4: 000006f0
[  505.814243] Call Trace:
[  505.814256]  kvm_arch_vcpu_ioctl_run+0xc87/0x1910 [kvm]
[  505.814260]  ? _copy_to_user+0x21/0x30
[  505.814264]  ? tomoyo_path_number_perm+0x5f/0x200
[  505.814274]  kvm_vcpu_ioctl+0x214/0x580 [kvm]
[  505.814284]  ? __bpf_trace_kvm_async_pf_nopresent_ready+0x30/0x30 [kvm]
[  505.814287]  do_vfs_ioctl+0x91/0x6b0
[  505.814290]  ? __audit_syscall_entry+0xb8/0x100
[  505.814292]  ? syscall_trace_enter+0x1e1/0x240
[  505.814294]  ? tomoyo_file_ioctl+0x19/0x20
[  505.814296]  ? security_file_ioctl+0x2a/0x40
[  505.814298]  ksys_ioctl+0x60/0x90
[  505.814300]  sys_ioctl+0x16/0x20
[  505.814302]  do_fast_syscall_32+0x91/0x17c
[  505.814304]  entry_SYSENTER_32+0x6b/0xbe
[  505.814306] EIP: 0xb7f8b83d
[  505.814307] Code: 54 cd ff ff 8b 98 58 cd ff ff 85 d2 89 c8 74 02 89 0a 5b
5d c3 8b 04 24 c3 8b 14 24 c3 8b 3c 24 c3 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59
c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90 8d 76
[  505.814308] EAX: ffffffda EBX: 0000000e ECX: 0000ae80 EDX: 00000000
[  505.814309] ESI: 0224ead0 EDI: 00000000 EBP: b50f6000 ESP: b31bbc98
[  505.814311] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00200292
[  505.814313]  ? nmi+0x8b/0x190
[  505.814314] Modules linked in: snd_hrtimer snd_seq_midi snd_seq_midi_event
snd_rawmidi snd_seq snd_seq_device cpufreq_powersave cpufreq_userspace
cpufreq_conservative nvidia_drm(PO) drm_kms_helper drm fb_sys_fops syscopyarea
sysfillrect sysimgblt nvidia_modeset(PO) nvidia(PO) binfmt_misc fuse
snd_hda_codec_via snd_hda_codec_hdmi snd_hda_codec_generic nls_iso8859_2
nls_cp437 vfat kvm_amd snd_hda_intel fat kvm snd_hda_codec snd_hda_core
snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd ohci_pci irqbypass
ohci_hcd soundcore k10temp ehci_pci ehci_hcd forcedeth i2c_nforce2 sr_mod
sata_nv cdrom sg asus_atk0110 pcc_cpufreq pcspkr acpi_cpufreq button
ipmi_devintf ipmi_msghandler usblp usbcore parport_pc ppdev lp parport
ip_tables x_tables autofs4 ext4 crc32c_generic crc16 mbcache jbd2 sd_mod
psmouse evdev serio_raw ata_generic pata_amd libata scsi_mod
[  505.814341] CR2: 0000000000000000
[  505.814343] ---[ end trace f9a592688c8617bc ]---
[  505.814354] EIP: kvm_mmu_load+0x292/0x4c0 [kvm]
[  505.814355] Code: 55 e8 e8 d1 f0 ff ff 8b 48 20 ff 40 28 8b 07 81 c1 00 00
00 40 c6 00 00 0f 1f 00 8b 87 68 02 00 00 0b 4d dc 8b 80 88 00 00 00 <89> 0c 30
c7 44 30 04 00 00 00 00 e9 6b ff ff ff 8d b6 00 00 00 00
[  505.814357] EAX: 00000000 EBX: 00000000 ECX: 1267a001 EDX: d30c7d6c
[  505.814358] ESI: 00000000 EDI: d2538000 EBP: d30c7dd0 ESP: d6a0d3bc
[  505.814359] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00210202
[  505.814360] CR0: 80050033 CR2: 00000000 CR3: 223e2e40 CR4: 000006f0

The processor on L0 is Athlon II X2 240.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
