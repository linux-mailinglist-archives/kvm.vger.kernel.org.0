Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D9F2912CC
	for <lists+kvm@lfdr.de>; Sat, 17 Oct 2020 17:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437802AbgJQP7g convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 17 Oct 2020 11:59:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437772AbgJQP7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Oct 2020 11:59:35 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209253] Loss of connectivity on guest after important host <->
 guest traffic
Date:   Sat, 17 Oct 2020 15:59:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kdev@mb706.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-209253-28872-LSL4VMiteM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209253-28872@https.bugzilla.kernel.org/>
References: <bug-209253-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209253

Martin (kdev@mb706.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kdev@mb706.com

--- Comment #2 from Martin (kdev@mb706.com) ---
I am having problems possibly related to Clement's, and likely related to
Ian's. 
I am running KVM on a dual Nvidia GPU machine, passing one GPU through to the
KVM guest (Ubuntu 20.04.1).
The setup ran stable for quite a while on Fedora 31 (5.7.15-100). After
upgrading to Fedora 32 (5.8.13), the system tends to run well for a few hours
after rebooting, and then produces oopses (below). After the oops, VirtIO
drives, VirtIO network cards, and PCIe passthrough tend to hang indefinitely
within minutes of rebooting the guest, usually making the guest inoperable
(unless only non-VirtIO devices and no GPU passthrough are used). Rebooting the
host makes things work again for a few hours until the next oops happens. I am
on 5.8.14 now with the same problem.

Oops 1 (I saw this twice, once on 5.8.13-200 and once on 5.8.14-200):

WARNING: CPU: 28 PID: 17651 at fs/eventfd.c:74 eventfd_signal+0x88/0xa0
Modules linked in: vhost_net vhost tap vhost_iotlb v4l2loopback(OE) xt_nat
xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_nat_tftp nft_objref
nf_conntrack_tftp tun bridge stp llc evdi(OE) vboxnetadp(OE) vboxnetflt(OE)
vboxdrv(OE) nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet
nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_tables
ebtable_nat ebtable_broute ip6table_nat ip6table_mangle ip6table_raw
ip6table_security iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
iptable_mangle iptable_raw iptable_security ip_set nfnetlink ebtable_filter
ebtables ip6table_filter ip6_tables iptable_filter sunrpc ucsi_ccg typec_ucsi
nvidia_drm(POE) typec nvidia_modeset(POE) snd_hda_codec_realtek nvidia_uvm(OE)
snd_hda_codec_generic ledtrig_audio snd_hda_codec_hdmi btusb edac_mce_amd btrtl
btbcm snd_hda_intel uvcvideo iwlmvm snd_intel_dspcfg kvm_amd btintel
snd_usb_audio snd_hda_codec videobuf2_vmalloc videobuf2_memops snd_usbmidi_lib
mac80211
 nvidia(POE) kvm bluetooth snd_hda_core videobuf2_v4l2 snd_rawmidi snd_hwdep
videobuf2_common libarc4 snd_seq iwlwifi videodev joydev rapl snd_seq_device
ecdh_generic wmi_bmof pcspkr cfg80211 mc ecc snd_pcm drm_kms_helper snd_timer
sp5100_tco k10temp snd i2c_piix4 rfkill soundcore cec i2c_nvidia_gpu gpio_amdpt
gpio_generic acpi_cpufreq drm ip_tables dm_crypt hid_lenovo mxm_wmi
crct10dif_pclmul crc32_pclmul crc32c_intel nvme ghash_clmulni_intel nvme_core
igb wacom ccp uas dca usb_storage i2c_algo_bit wmi pinctrl_amd vfio_pci
irqbypass vfio_virqfd vfio_iommu_type1 vfio fuse
CPU: 28 PID: 17651 Comm: CPU 5/KVM Tainted: P           OE    
5.8.13-200.fc32.x86_64 #1
Hardware name: Gigabyte Technology Co., Ltd. X399 DESIGNARE EX/X399 DESIGNARE
EX-CF, BIOS F12 12/11/2019
RIP: 0010:eventfd_signal+0x88/0xa0
Code: 03 00 00 00 4c 89 f7 e8 26 16 db ff 65 ff 0d 3f f3 ca 4b 4c 89 ee 4c 89
f7 e8 34 8e 7f 00 4c 89 e0 5b 5d 41 5c 41 5d 41 5e c3 <0f> 0b 45 31 e4 5b 5d 4c
89 e0 41 5c 41 5d 41 5e c3 0f 1f 80 00 00
RSP: 0018:ffffab10c8db7bb0 EFLAGS: 00010286
RAX: 00000000ffffffff RBX: ffff9a71e16b8000 RCX: 0000000000000004
RDX: 00000000c8088704 RSI: 0000000000000001 RDI: ffff9a8335656580
RBP: ffffab10c8db7c18 R08: ffff9a72f7d120a0 R09: 00000000c8088708
R10: 0000000000000000 R11: 0000000000000014 R12: 0000000000000001
R13: ffff9a72a3153448 R14: ffff9a72f7d120a0 R15: ffff9a72a3153448
FS:  0000000000000000(0000) GS:ffff9a7e7f280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f64e403f024 CR3: 000000041b5f4000 CR4: 00000000003406e0
Call Trace:
 ioeventfd_write+0x51/0x80 [kvm]
 __kvm_io_bus_write+0x88/0xb0 [kvm]
 kvm_io_bus_write+0x43/0x60 [kvm]
 write_mmio+0x70/0xf0 [kvm]
 emulator_read_write_onepage+0x11e/0x330 [kvm]
 emulator_read_write+0xca/0x180 [kvm]
 segmented_write.isra.0+0x4a/0x60 [kvm]
 x86_emulate_insn+0x850/0xe60 [kvm]
 x86_emulate_instruction+0x2c7/0x780 [kvm]
 ? kvm_set_cr8+0x1e/0x40 [kvm]
 kvm_arch_vcpu_ioctl_run+0xeb9/0x1770 [kvm]
 ? x86_pmu_enable+0x106/0x2f0
 ? __switch_to_xtra+0x495/0x500
 kvm_vcpu_ioctl+0x209/0x590 [kvm]
 ksys_ioctl+0x82/0xc0
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x4d/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f5f6a84f3bb
Code: 0f 1e fa 48 8b 05 dd aa 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff
c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01
c3 48 8b 0d ad aa 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007f5f527fb668 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000055c459b6f1f0 RCX: 00007f5f6a84f3bb
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000022
RBP: 00007f5f6bcca000 R08: 000055c45750abf0 R09: 000000003b9aca00
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007f5f6bccb004 R14: 0000000000000000 R15: 000055c4579a4a00

Oops 2 (saw this once on 5.8.14-200):

WARNING: CPU: 24 PID: 0 at fs/eventfd.c:74 eventfd_signal+0x88/0xa0
Modules linked in: v4l2loopback(OE) nfnetlink_queue nfnetlink_log vhost_net
vhost tap vhost_iotlb xt_nat xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT
nf_nat_tftp nft_objref nf_conntrack_tftp tun bridge stp llc vboxnetadp(OE)
vboxnetflt(OE) vboxdrv(OE) nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat
nf_tables ebtable_nat ebtable_broute ip6table_nat ip6table_mangle ip6table_raw
ip6table_security iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
iptable_mangle iptable_raw iptable_security ip_set nfnetlink ebtable_filter
ebtables ip6table_filter ip6_tables iptable_filter sunrpc nvidia_drm(POE)
nvidia_modeset(POE) iwlmvm nvidia_uvm(OE) snd_hda_codec_realtek ucsi_ccg
typec_ucsi mac80211 typec edac_mce_amd snd_hda_codec_generic ledtrig_audio
snd_hda_codec_hdmi uvcvideo btusb btrtl btbcm nvidia(POE) snd_hda_intel
videobuf2_vmalloc libarc4 kvm_amd btintel videobuf2_memops snd_intel_dspcfg
 snd_hda_codec videobuf2_v4l2 kvm bluetooth videobuf2_common snd_usb_audio
iwlwifi snd_hda_core videodev snd_usbmidi_lib snd_hwdep snd_seq snd_rawmidi
joydev rapl snd_seq_device ecdh_generic mc pcspkr wmi_bmof ecc cfg80211 snd_pcm
drm_kms_helper snd_timer snd sp5100_tco i2c_piix4 k10temp rfkill soundcore cec
i2c_nvidia_gpu gpio_amdpt gpio_generic acpi_cpufreq drm ip_tables dm_crypt
mxm_wmi crct10dif_pclmul crc32_pclmul crc32c_intel nvme ghash_clmulni_intel igb
nvme_core wacom uas dca hid_lenovo ccp usb_storage i2c_algo_bit wmi pinctrl_amd
vfio_pci irqbypass vfio_virqfd vfio_iommu_type1 vfio fuse
CPU: 24 PID: 0 Comm: swapper/24 Tainted: P           OE    
5.8.14-200.fc32.x86_64 #1
Hardware name: Gigabyte Technology Co., Ltd. X399 DESIGNARE EX/X399 DESIGNARE
EX-CF, BIOS F12 12/11/2019
RIP: 0010:eventfd_signal+0x88/0xa0
Code: 03 00 00 00 4c 89 f7 e8 a6 14 db ff 65 ff 0d bf f1 ca 78 4c 89 ee 4c 89
f7 e8 b4 9c 7f 00 4c 89 e0 5b 5d 41 5c 41 5d 41 5e c3 <0f> 0b 45 31 e4 5b 5d 4c
89 e0 41 5c 41 5d 41 5e c3 0f 1f 80 00 00
RSP: 0018:ffffb5e2c6d2cf38 EFLAGS: 00010002
RAX: 0000000000000001 RBX: ffff894a2a1f1480 RCX: 000000000000001f
RDX: ffff89423920ce00 RSI: 0000000000000001 RDI: ffff894929afc580
RBP: ffff89423920cea4 R08: ffffb5e2c6d2cff8 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000000a1
R13: 0000000000000000 R14: ffffb5e2c6d2cfb4 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89423f180000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055ae44aa8990 CR3: 0000000797204000 CR4: 00000000003406e0
Call Trace:
 <IRQ>
 vfio_msihandler+0x12/0x20 [vfio_pci]
 __handle_irq_event_percpu+0x42/0x180
 handle_irq_event+0x47/0x8a
 handle_edge_irq+0x87/0x220
 asm_call_irq_on_stack+0x12/0x20
 </IRQ>
 common_interrupt+0xb2/0x140
 asm_common_interrupt+0x1e/0x40
RIP: 0010:cpuidle_enter_state+0xb6/0x3f0
Code: 90 a5 6b 78 e8 5b be 7b ff 49 89 c7 0f 1f 44 00 00 31 ff e8 2c d7 7b ff
80 7c 24 0f 00 0f 85 d4 01 00 00 fb 66 0f 1f 44 00 00 <45> 85 e4 0f 88 e0 01 00
00 49 63 d4 4c 2b 7c 24 10 48 8d 04 52 48
RSP: 0018:ffffb5e2c0337e88 EFLAGS: 00000246
RAX: ffff89423f1aa2c0 RBX: ffff89423366e400 RCX: 000000000000001f
RDX: 0000000000000000 RSI: 000000002abf3055 RDI: 0000000000000000
RBP: ffffffff88b78940 R08: 00000a86556fd237 R09: 0000000000000018
R10: 0000000000002358 R11: 0000000000000781 R12: 0000000000000002
R13: ffff89423366e400 R14: 0000000000000002 R15: 00000a86556fd237
 ? cpuidle_enter_state+0xa4/0x3f0
 cpuidle_enter+0x29/0x40
 do_idle+0x1d5/0x2a0
 cpu_startup_entry+0x19/0x20
 start_secondary+0x144/0x170
 secondary_startup_64+0xb6/0xc0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
