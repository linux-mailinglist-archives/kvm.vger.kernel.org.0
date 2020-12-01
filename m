Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658532C99B3
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 09:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgLAIkI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 1 Dec 2020 03:40:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:52454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbgLAIkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 03:40:08 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209867] CPU soft lockup/stall with nested KVM and SMP
Date:   Tue, 01 Dec 2020 08:39:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: taz.007@zoho.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-209867-28872-QWakeYcUJK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209867-28872@https.bugzilla.kernel.org/>
References: <bug-209867-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209867

taz.007@zoho.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |taz.007@zoho.com

--- Comment #6 from taz.007@zoho.com ---
I've got a similar stack trace, but with a completely different context. This
is a small htpc box, no kvm involved, Intel CPU, 32bits.

déc 01 05:01:20 Aspire kernel: watchdog: BUG: soft lockup - CPU#2 stuck for
22s! [sshd:20874]
déc 01 05:01:20 Aspire kernel: Modules linked in: mptcp_diag tcp_diag udp_diag
raw_diag inet_diag rpcsec_gss_krb5 md4 cmac nls_utf8 cifs libdes dns_resolver
fscache fuse hwmon_vid nouveau ath5k snd_hda_codec_hdmi ath mxm_wmi ttm
snd_hda_codec_realtek mac80211 snd_hda_codec_generic drm_kms_helper
ledtrig_audio snd_hda_intel cfg80211 snd_intel_dspcfg mousedev cec input_leds
snd_hda_codec rc_core snd_hda_core syscopyarea rfkill hid_generic sysfillrect
snd_hwdep wmi_bmof libarc4 snd_pcm sysimgblt snd_timer fb_sys_fops coretemp
usbhid uas hid pcspkr i2c_algo_bit usb_storage snd nv_tco soundcore forcedeth
i2c_nforce2 wmi evdev nfsd auth_rpcgss tcp_bbr nfs_acl lockd grace sunrpc sg
drm nfs_ssc agpgart ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2
ohci_pci ehci_pci ehci_hcd ohci_hcd
déc 01 05:01:20 Aspire kernel: CPU: 2 PID: 20874 Comm: sshd Tainted: G      D  
        5.9.9-arch1-1 #1
déc 01 05:01:20 Aspire kernel: Hardware name: Acer Aspire R3610/FMCP7A-ION-LE,
BIOS P01-A4 11/03/2009
déc 01 05:01:20 Aspire kernel: EIP: queued_spin_lock_slowpath+0x42/0x200
déc 01 05:01:20 Aspire kernel: Code: 8b 01 0f b6 d2 c1 e2 08 30 e4 09 d0 a9 00
01 ff ff 0f 85 21 01 00 00 85 c0 74 15 8b 01 84 c0 74 0f 8d b4 26 00 00 00 00
f3 90 <8b> 01 84 c0 75 f8 b8 01 00 00 00 66 89 01 64 ff 05 c0 1e bd c6 c3
déc 01 05:01:20 Aspire kernel: EAX: 00000101 EBX: df4f1ea4 ECX: c6bf5e68 EDX:
00000000
déc 01 05:01:20 Aspire kernel: ESI: 00000001 EDI: df4f1e58 EBP: df4f1dcc ESP:
df4f1dc8
déc 01 05:01:20 Aspire kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
EFLAGS: 00000202
déc 01 05:01:20 Aspire kernel: CR0: 80050033 CR2: 0048a107 CR3: 218a8000 CR4:
000006d0
déc 01 05:01:20 Aspire kernel: Call Trace:
déc 01 05:01:20 Aspire kernel:  ? _raw_spin_lock+0x2c/0x30
déc 01 05:01:20 Aspire kernel:  __change_page_attr_set_clr+0x45/0x740
déc 01 05:01:20 Aspire kernel:  ? _vm_unmap_aliases.part.0+0x114/0x130
déc 01 05:01:20 Aspire kernel:  change_page_attr_set_clr+0xd0/0x2a0
déc 01 05:01:20 Aspire kernel:  set_memory_ro+0x1b/0x20
déc 01 05:01:20 Aspire kernel:  bpf_prog_select_runtime+0x16c/0x1b0
déc 01 05:01:20 Aspire kernel:  bpf_migrate_filter+0xe2/0x130
déc 01 05:01:20 Aspire kernel:  bpf_prog_create_from_user+0x147/0x190
déc 01 05:01:20 Aspire kernel:  ? hardlockup_detector_perf_cleanup+0x70/0x70
déc 01 05:01:20 Aspire kernel:  do_seccomp+0x22d/0x9a0
déc 01 05:01:20 Aspire kernel:  ? security_task_prctl+0x38/0x90
déc 01 05:01:20 Aspire kernel:  prctl_set_seccomp+0x27/0x40
déc 01 05:01:20 Aspire kernel:  __ia32_sys_prctl+0x87/0x4f0
déc 01 05:01:20 Aspire kernel:  __do_fast_syscall_32+0x40/0x70
déc 01 05:01:20 Aspire kernel:  do_fast_syscall_32+0x29/0x60
déc 01 05:01:20 Aspire kernel:  do_SYSENTER_32+0x15/0x20
déc 01 05:01:20 Aspire kernel:  entry_SYSENTER_32+0x9f/0xf2
déc 01 05:01:20 Aspire kernel: EIP: 0xb7fd0549
déc 01 05:01:20 Aspire kernel: Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01
10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34
cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90 8d 76
déc 01 05:01:20 Aspire kernel: EAX: ffffffda EBX: 00000016 ECX: 00000002 EDX:
004f4d5c
déc 01 05:01:20 Aspire kernel: ESI: 00000000 EDI: 00000001 EBP: b7b6ae1c ESP:
bffff6ec
déc 01 05:01:20 Aspire kernel: DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
EFLAGS: 00000292

kernel 5.9.9-arch1-1

Feel free to report if it's non related and I'll open a new bug report about
it.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
