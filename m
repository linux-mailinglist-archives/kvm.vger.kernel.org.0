Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4106319A466
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 06:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgDAEjv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 1 Apr 2020 00:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgDAEjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 00:39:51 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 203923] Running a nested freedos on AMD Athlon i686-pae results
 in NULL pointer dereference in L0 (kvm_mmu_load)
Date:   Wed, 01 Apr 2020 04:39:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: andersk@mit.edu
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-203923-28872-AS0dA0De57@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203923-28872@https.bugzilla.kernel.org/>
References: <bug-203923-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203923

Anders Kaseorg (andersk@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |andersk@mit.edu

--- Comment #8 from Anders Kaseorg (andersk@mit.edu) ---
The second patch was committed as v5.4-rc1~138^2~6.

I found this while staring at a similar-looking kvm_mmu_load NULL dereference
on the hardware kernel while starting a nested VM on an AMD Ryzen 7 1800X,
kernel 5.4.28.  Should I try to expand this into a full report, or does your
original recipe still reproduce?

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 0 P4D 0 
Oops: 0002 [#1] SMP NOPTI
CPU: 5 PID: 1994 Comm: CPU 7/KVM Tainted: P           OE     5.4.28 #1-NixOS
Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./AB350M Pro4, BIOS
P5.90 07/03/2019
RIP: 0010:kvm_mmu_load+0x2e6/0x5b0 [kvm]
Code: 2b 0d 46 c7 0c fa 83 40 50 01 49 8b 3f c6 07 00 0f 1f 40 00 49 8b 87 68
03 00 00 48 01 ca 48 0b 54 24 08 48 8b 80 b8 00 00 00 <4a> 89 14 30 e9 57 ff ff
ff 48 c1 e8 0c 4c 89 ff 48 89 c6 49 89 c5
RSP: 0018:ffffbc2883aefcc8 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00006355c0000000
RDX: 00000007b954a027 RSI: ffffbc2883aefc68 RDI: ffffbc2883ab1000
RBP: 0000000000000000 R08: ffffbc2883ab1000 R09: ffffbc2883aefbf0
R10: ffffbc2883aefc68 R11: ffff9cb05e950008 R12: 0000000000000000
R13: 00000000000290a3 R14: 0000000000000000 R15: ffff9cb15c0c38f0
FS:  0000000000000000(0000) GS:ffff9cb1be940000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000079fda4000 CR4: 00000000003406e0
Call Trace:
 kvm_arch_vcpu_ioctl_run+0xfe4/0x1d60 [kvm]
 ? _copy_to_user+0x28/0x30
 ? kvm_vm_ioctl+0x7ab/0x8e0 [kvm]
 kvm_vcpu_ioctl+0x215/0x5c0 [kvm]
 ? __seccomp_filter+0x7b/0x670
 do_vfs_ioctl+0x3fe/0x660
 ksys_ioctl+0x5e/0x90
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x4e/0x120
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f4a959ba147
Code: 00 00 90 48 8b 05 39 9d 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff
c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01
c3 48 8b 0d 09 9d 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007f4a79ffa508 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f4a959ba147
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000022
RBP: 00005563acc09d00 R08: 00005563aab57b90 R09: 00000000000000ff
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 00005563ab1ba980 R14: 0000000000000001 R15: 0000000000000000
Modules linked in: fuse vhost_net vhost ip6table_mangle ebtable_filter ebtables
iptable_mangle xt_CHECKSUM xt_comment xt_MASQUERADE nf_conntrack_netlink
nfnetlink xfrm_user xfrm_algo xt_addrtype br_netfilter msr ip6table_nat
iptable_nat nf_nat xt_conntrack nf_conntrack nf_defrag_ipv4 ip6t_rpfilter
ipt_rpfilter ip6table_raw iptable_raw xt_pkttype nf_log_ipv6 nf_log_ipv4
nf_log_common xt_LOG ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4
xt_tcpudp ip6table_filter ip6_tables iptable_filter sch_fq_codel nls_iso8859_1
nls_cp437 vfat snd_hda_codec_hdmi fat snd_hda_codec_realtek wmi_bmof
nvidia_drm(POE) snd_hda_codec_generic ledtrig_audio drm_kms_helper edac_mce_amd
nvidia_modeset(POE) snd_hda_intel edac_core snd_intel_nhlt nvidia_uvm(OE) drm
joydev snd_hda_codec evdev mousedev mac_hid deflate efi_pstore crct10dif_pclmul
pstore agpgart sp5100_tco snd_hda_core crc32_pclmul fb_sys_fops watchdog
syscopyarea efivars sysfillrect snd_hwdep ghash_clmulni_intel i2c_piix4
sysimgblt
 k10temp gpio_amdpt pinctrl_amd gpio_generic wmi button acpi_cpufreq
nvidia(POE) ipmi_devintf ipmi_msghandler i2c_core snd_pcm_oss snd_mixer_oss
snd_pcm snd_timer snd soundcore atkbd libps2 serio loop cpufreq_ondemand tap
macvlan bridge stp llc tun efivarfs ip_tables x_tables ipv6 nf_defrag_ipv6
crc_ccitt autofs4 dm_crypt algif_skcipher af_alg input_leds led_class sd_mod
hid_generic usbhid hid xhci_pci ahci xhci_hcd libahci libata usbcore
aesni_intel scsi_mod crypto_simd cryptd glue_helper usb_common rtc_cmos
af_packet dm_mod btrfs libcrc32c crc32c_generic crc32c_intel xor
zstd_decompress zstd_compress raid6_pq kvm_amd kvm irqbypass r8169 realtek
libphy
CR2: 0000000000000000
---[ end trace d6db99b9073bce58 ]---
RIP: 0010:kvm_mmu_load+0x2e6/0x5b0 [kvm]
Code: 2b 0d 46 c7 0c fa 83 40 50 01 49 8b 3f c6 07 00 0f 1f 40 00 49 8b 87 68
03 00 00 48 01 ca 48 0b 54 24 08 48 8b 80 b8 00 00 00 <4a> 89 14 30 e9 57 ff ff
ff 48 c1 e8 0c 4c 89 ff 48 89 c6 49 89 c5
RSP: 0018:ffffbc2883aefcc8 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00006355c0000000
RDX: 00000007b954a027 RSI: ffffbc2883aefc68 RDI: ffffbc2883ab1000
RBP: 0000000000000000 R08: ffffbc2883ab1000 R09: ffffbc2883aefbf0
R10: ffffbc2883aefc68 R11: ffff9cb05e950008 R12: 0000000000000000
R13: 00000000000290a3 R14: 0000000000000000 R15: ffff9cb15c0c38f0
FS:  0000000000000000(0000) GS:ffff9cb1be940000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000079fda4000 CR4: 00000000003406e0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
