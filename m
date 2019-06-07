Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1739D3914A
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 17:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbfFGP5w convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 7 Jun 2019 11:57:52 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:48684 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729509AbfFGP5w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jun 2019 11:57:52 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 64F5228B7F
        for <kvm@vger.kernel.org>; Fri,  7 Jun 2019 15:57:51 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 631D328BBC; Fri,  7 Jun 2019 15:57:51 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203845] New: Can't run qemu/kvm on 5.0.0 kernel (NULL pointer
 dereference)
Date:   Fri, 07 Jun 2019 15:57:49 +0000
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
Message-ID: <bug-203845-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=203845

            Bug ID: 203845
           Summary: Can't run qemu/kvm on 5.0.0 kernel (NULL pointer
                    dereference)
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.0.0
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

I can't start a linux system (for autopkgtest testing) using kvm on an AMD
system. The qemu process is just killed after ioctl(..., KVM_RUN). In dmesg, I
see:

[54998.896817] BUG: unable to handle kernel NULL pointer dereference at
00000000
[54998.896823] #PF error: [WRITE]
[54998.896826] *pdpt = 0000000011b11001 *pde = 0000000000000000 
[54998.896831] Oops: 0002 [#9] SMP NOPTI
[54998.896836] CPU: 0 PID: 5289 Comm: qemu-system-i38 Tainted: P      D    OE  
  5.0.0-trunk-686-pae #1 Debian 5.0.2-1~exp1
[54998.896839] Hardware name: System manufacturer System Product Name/M4N68T-M,
BIOS 1301    07/05/2011
[54998.896864] EIP: kvm_mmu_load+0xbc/0x4b0 [kvm]
[54998.896868] Code: 81 c1 00 00 00 40 c6 00 00 0f 1f 00 8b 87 60 02 00 00 8b
55 e8 83 c9 01 81 c3 00 00 04 00 83 d6 00 83 c4 10 8b 80 88 00 00 00 <89> 0c 10
c7 44 10 04 00 00 00 00 83 c2 08 89 55 e8 83 fa 20 75 89
[54998.896871] EAX: 00000000 EBX: 00040000 ECX: 0dc1d001 EDX: 00000000
[54998.896874] ESI: 00000000 EDI: cdf58000 EBP: cf811de0 ESP: cf811dbc
[54998.896876] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00210282
[54998.896878] CR0: 80050033 CR2: 00000000 CR3: 22de02e0 CR4: 000006f0
[54998.896880] Call Trace:
[54998.896900]  ? kvm_ioapic_scan_entry+0x62/0xe0 [kvm]
[54998.896919]  kvm_arch_vcpu_ioctl_run+0x105f/0x1a20 [kvm]
[54998.896925]  ? _cond_resched+0x17/0x30
[54998.896943]  kvm_vcpu_ioctl+0x214/0x590 [kvm]
[54998.896959]  ? kvm_vcpu_ioctl+0x214/0x590 [kvm]
[54998.896964]  ? do_futex+0xae/0xa70
[54998.896969]  ? __fpu__restore_sig+0x265/0x500
[54998.896985]  ? __bpf_trace_kvm_async_pf_nopresent_ready+0x20/0x20 [kvm]
[54998.896988]  do_vfs_ioctl+0x9a/0x6c0
[54998.896993]  ? __audit_syscall_entry+0xb4/0xf0
[54998.896997]  ? syscall_trace_enter+0x1da/0x240
[54998.897000]  ksys_ioctl+0x56/0x80
[54998.897002]  sys_ioctl+0x16/0x20
[54998.897005]  do_fast_syscall_32+0x81/0x184
[54998.897009]  entry_SYSENTER_32+0x6b/0xbe
[54998.897011] EIP: 0xb7f49881
[54998.897014] Code: 8b 98 58 cd ff ff 89 c8 85 d2 74 02 89 0a 5b 5d c3 8b 04
24 c3 8b 14 24 c3 8b 34 24 c3 8b 3c 24 c3 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59
c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90 8d 76
[54998.897016] EAX: ffffffda EBX: 0000000e ECX: 0000ae80 EDX: 00000000
[54998.897018] ESI: 0261b080 EDI: 00000000 EBP: b51cf000 ESP: b30fdc98
[54998.897021] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00200292
[54998.897024] Modules linked in: cfg80211 nfnetlink_queue nfnetlink_log
nfnetlink bluetooth drbg ansi_cprng ecdh_generic rfkill snd_hrtimer
snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device
cpufreq_powersave cpufreq_userspace cpufreq_conservative binfmt_misc
nvidia_drm(POE) drm_kms_helper drm nvidia_modeset(POE) nvidia(POE) fuse
snd_hda_codec_via nls_iso8859_2 nls_cp437 vfat snd_hda_codec_generic
snd_hda_codec_hdmi ledtrig_audio fat snd_hda_intel edac_mce_amd snd_hda_codec
kvm_amd snd_hda_core snd_hwdep kvm snd_pcm_oss sr_mod snd_mixer_oss snd_pcm
cdrom snd_timer sg irqbypass snd k10temp soundcore pcspkr asus_atk0110 ohci_pci
ohci_hcd pcc_cpufreq sata_nv ehci_pci forcedeth acpi_cpufreq i2c_nforce2
ehci_hcd button ipmi_devintf ipmi_msghandler usblp usbcore usb_common
parport_pc ppdev lp parport ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2
crc32c_generic fscrypto ecb crypto_simd cryptd aes_i586 sd_mod pata_amd
ata_generic libata psmouse evdev serio_raw scsi_mod
[54998.897072] CR2: 0000000000000000
[54998.897075] ---[ end trace a515b8f5e69d047e ]---
[54998.897093] EIP: kvm_mmu_load+0xbc/0x4b0 [kvm]
[54998.897096] Code: 81 c1 00 00 00 40 c6 00 00 0f 1f 00 8b 87 60 02 00 00 8b
55 e8 83 c9 01 81 c3 00 00 04 00 83 d6 00 83 c4 10 8b 80 88 00 00 00 <89> 0c 10
c7 44 10 04 00 00 00 00 83 c2 08 89 55 e8 83 fa 20 75 89
[54998.897098] EAX: 00000000 EBX: 00040000 ECX: 0facd001 EDX: 00000000
[54998.897100] ESI: 00000000 EDI: cd06b0c0 EBP: cd227de0 ESP: d4a59dfc
[54998.897102] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00210282
[54998.897104] CR0: 80050033 CR2: 00000000 CR3: 22de02e0 CR4: 000006f0

debian:~# uname -a
Linux debian 5.0.0-trunk-686-pae #1 SMP Debian 5.0.2-1~exp1 (2019-03-18) i686
GNU/Linux

The processor of the host is AMD Athlon(tm) II X2 245

This particular VM worked previously, but I will have to look into whether it
is the kernel or maybe qemu that broke it. However, a null pointer dereference
should still not happen IMHO.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
