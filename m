Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D631168749
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 20:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbgBUTPJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 21 Feb 2020 14:15:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgBUTPJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 14:15:09 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Fri, 21 Feb 2020 19:15:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rmuncrief@humanavance.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206579-28872-4YHBqRYM4k@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206579-28872@https.bugzilla.kernel.org/>
References: <bug-206579-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206579

--- Comment #5 from muncrief (rmuncrief@humanavance.com) ---
(In reply to Suravee Suthikulpanit from comment #4)
> Alex / muncrief,
> 
> I have posted a patch here (https://lkml.org/lkml/2020/2/21/1523)
> 
> Would you please give it a try and see if the issue persists?
> 
> Thanks,
> Suravee

Thank you for diligently addressing this problem Suravee. I have good news and
bad news.

The good news is that the patch works with avic disabled.

But unfortunately there's a different hard crash when I enable avic using
host-passthrough. However if I use EPYC-IBPB as the cpu model there's no crash,
but from what I can see that's because avic is disabled in the qemu
capabilities with a "<blocker name='x2apic'/>" message. I'll tell you what I
tried as succinctly as possible.

First I added "options kvm_amd avic=1" to kvm.conf, executed mkinitcpio, and
rebooted. Then I did my best to see if avic was enabled:

\# dmesg | grep -i AMD-Vi
[    0.910741] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters supported
[    0.912189] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    0.912190] pci 0000:00:00.2: AMD-Vi: Extended features (0x58f77ef22294ade):
[    0.912192] AMD-Vi: Interrupt remapping enabled
[    0.912192] AMD-Vi: Virtual APIC enabled
[    0.912192] AMD-Vi: X2APIC enabled
[    0.912620] AMD-Vi: Lazy IO/TLB flushing enabled
[    0.923298] AMD-Vi: AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>

\# dmesg | grep -i svm
[    1.240049] SVM: AVIC enabled
[    1.240050] SVM: Virtual VMLOAD VMSAVE supported
[    1.240050] SVM: Virtual GIF supported

\# cat /sys/module/kvm_amd/parameters/avic
1

This all looked good. But when I looked in
/var/cache/libvirt/qemu/capabilities/*.xml all AMD CPUs had a message like
this:

  <cpu type='kvm' name='EPYC-IBPB' typename='EPYC-IBPB-x86_64-cpu' usable='no'>
    <blocker name='x2apic'/>
  </cpu>

And like I said when I ran my VM with host-passthrough there was a hard crash,
but if I chose EPYC-IBPB it worked. However I suspect that's because when I use
EPYC avic is actually disabled, but when I use host-passthrough it's enabled.

In any case, following is the relevant dmesg output from the crash. Please let
me know if I'm doing something wrong, or if you need more info or testing.

_---------- Begin dmesg output ----------_

[  564.119840] device vnet0 entered promiscuous mode
[  564.119952] vm_bridge0: port 2(vnet0) entered blocking state
[  564.119953] vm_bridge0: port 2(vnet0) entered listening state
[  566.354740] vfio-pci 0000:08:00.0: vfio_ecap_init: hiding ecap 0x19@0x270
[  566.354744] vfio-pci 0000:08:00.0: vfio_ecap_init: hiding ecap 0x25@0x400
[  566.354746] vfio-pci 0000:08:00.0: vfio_ecap_init: hiding ecap 0x26@0x410
[  566.354749] vfio-pci 0000:08:00.0: vfio_ecap_init: hiding ecap 0x27@0x440
[  566.374852] vfio-pci 0000:0a:00.0: vfio_ecap_init: hiding ecap 0x19@0x270
[  566.374861] vfio-pci 0000:0a:00.0: vfio_ecap_init: hiding ecap 0x1b@0x2d0
[  569.921527] BUG: kernel NULL pointer dereference, address: 0000000000000010
[  569.921533] #PF: supervisor read access in kernel mode
[  569.921535] #PF: error_code(0x0000) - not-present page
[  569.921537] PGD 0 P4D 0 
[  569.921542] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  569.921546] CPU: 7 PID: 7335 Comm: CPU 2/KVM Tainted: P           OE    
5.6.0-rc2-1-mainline #1
[  569.921548] Hardware name: System manufacturer System Product Name/TUF
GAMING X570-PLUS, BIOS 1405 11/19/2019
[  569.921558] RIP: 0010:svm_refresh_apicv_exec_ctrl+0xf4/0x130 [kvm_amd]
[  569.921562] Code: 8b 83 f8 39 00 00 48 39 c5 74 31 48 8b 9b f8 39 00 00 48
39 dd 75 13 eb 23 e8 08 a0 90 f0 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b
10 45 85 e4 75 e6 e8 5e 9f 90 f0 85 c0 74 e6 5b 4c 89 ee
[  569.921565] RSP: 0018:ffffa7a74084fce8 EFLAGS: 00010082
[  569.921568] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffa38f715ce000
[  569.921570] RDX: 0000000000000001 RSI: ffffa38f3c9e1800 RDI:
0000000000000000
[  569.921572] RBP: ffffa38f3ca57408 R08: 0000000000000000 R09:
0000000000000bb8
[  569.921574] R10: 000000849ef65aa1 R11: 00000000000630c0 R12:
0000000000000000
[  569.921576] R13: 0000000000000202 R14: ffffa38f3ca57418 R15:
ffffa38f3ca53a10
[  569.921578] FS:  00007f6b5b5ff700(0000) GS:ffffa3905e9c0000(0000)
knlGS:0000000000000000
[  569.921580] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  569.921582] CR2: 0000000000000010 CR3: 000000032f9ec000 CR4:
0000000000340ee0
[  569.921583] Call Trace:
[  569.921592]  svm_vcpu_unblocking+0x31/0x50 [kvm_amd]
[  569.921613]  kvm_vcpu_block+0xd1/0x340 [kvm]
[  569.921639]  kvm_arch_vcpu_ioctl_run+0x1234/0x1b20 [kvm]
[  569.921645]  ? __seccomp_filter+0xd2/0x6c0
[  569.921665]  kvm_vcpu_ioctl+0x266/0x630 [kvm]
[  569.921671]  ksys_ioctl+0x87/0xc0
[  569.921675]  __x64_sys_ioctl+0x16/0x20
[  569.921678]  do_syscall_64+0x4e/0x150
[  569.921683]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  569.921686] RIP: 0033:0x7f6b607452eb
[  569.921688] Code: 0f 1e fa 48 8b 05 a5 8b 0c 00 64 c7 00 26 00 00 00 48 c7
c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 75 8b 0c 00 f7 d8 64 89 01 48
[  569.921690] RSP: 002b:00007f6b5b5fcea8 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  569.921693] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX:
00007f6b607452eb
[  569.921695] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
000000000000001b
[  569.921696] RBP: 00007f6b5e04ae00 R08: 00005558b88eb110 R09:
0000000000000000
[  569.921698] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[  569.921699] R13: 00007ffd77fa257f R14: 00007f6b5b5fd140 R15:
00007f6b5b5ff700
[  569.921704] Modules linked in: vhost_net vhost tap cpufreq_ondemand
ebtable_filter ebtables tun bridge stp llc uvcvideo videobuf2_vmalloc
videobuf2_memops videobuf2_v4l2 videobuf2_common snd_usb_audio videodev
snd_usbmidi_lib snd_rawmidi nvidia_drm(POE) snd_seq_device mc
nvidia_modeset(POE) nct6775 hwmon_vid nvidia(POE) amdgpu nls_iso8859_1
gpu_sched nls_cp437 vfat radeon fat fuse snd_hda_codec_realtek i2c_algo_bit
snd_hda_codec_generic ttm ledtrig_audio eeepc_wmi snd_hda_codec_hdmi asus_wmi
drm_kms_helper battery sparse_keymap rfkill wmi_bmof snd_hda_intel cec
edac_mce_amd snd_intel_dspcfg snd_hda_codec crct10dif_pclmul drm crc32_pclmul
snd_hda_core ghash_clmulni_intel snd_hwdep ipmi_devintf snd_pcm ipmi_msghandler
aesni_intel r8169 agpgart snd_timer crypto_simd syscopyarea sp5100_tco cryptd
sysfillrect realtek glue_helper joydev sysimgblt input_leds mousedev pcspkr
k10temp snd i2c_piix4 fb_sys_fops libphy soundcore wmi pinctrl_amd evdev
mac_hid acpi_cpufreq nf_log_ipv6 ip6t_REJECT
[  569.921749]  nf_reject_ipv6 xt_hl ip6t_rt nf_log_ipv4 nf_log_common
ipt_REJECT nf_reject_ipv4 xt_LOG xt_multiport xt_limit xt_addrtype xt_tcpudp
xt_conntrack ip6table_filter ip6_tables nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c iptable_filter sg ip_tables x_tables
ext4 crc32c_generic crc16 mbcache jbd2 sr_mod cdrom sd_mod hid_generic usbhid
hid ahci libahci crc32c_intel libata xhci_pci scsi_mod xhci_hcd vfio_pci
vfio_virqfd vfio_iommu_type1 vfio kvm_amd ccp rng_core kvm irqbypass
[  569.921778] CR2: 0000000000000010
[  569.921780] ---[ end trace c5c7ecbc97cc5c9a ]---
[  569.921782] BUG: kernel NULL pointer dereference, address: 0000000000000010
[  569.921784] #PF: supervisor read access in kernel mode
[  569.921786] #PF: error_code(0x0000) - not-present page
[  569.921787] PGD 0 P4D 0 
[  569.921793] RIP: 0010:svm_refresh_apicv_exec_ctrl+0xf4/0x130 [kvm_amd]
[  569.921796] Code: 8b 83 f8 39 00 00 48 39 c5 74 31 48 8b 9b f8 39 00 00 48
39 dd 75 13 eb 23 e8 08 a0 90 f0 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b
10 45 85 e4 75 e6 e8 5e 9f 90 f0 85 c0 74 e6 5b 4c 89 ee
[  569.921797] RSP: 0018:ffffa7a74084fce8 EFLAGS: 00010082
[  569.921801] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffa38f715ce000
[  569.921802] RDX: 0000000000000001 RSI: ffffa38f3c9e1800 RDI:
0000000000000000
[  569.921804] RBP: ffffa38f3ca57408 R08: 0000000000000000 R09:
0000000000000bb8
[  569.921805] R10: 000000849ef65aa1 R11: 00000000000630c0 R12:
0000000000000000
[  569.921806] R13: 0000000000000202 R14: ffffa38f3ca57418 R15:
ffffa38f3ca53a10
[  569.921809] FS:  00007f6b5b5ff700(0000) GS:ffffa3905e9c0000(0000)
knlGS:0000000000000000
[  569.921810] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  569.921812] CR2: 0000000000000010 CR3: 000000032f9ec000 CR4:
0000000000340ee0
[  569.921815] note: CPU 2/KVM[7335] exited with preempt_count 1
[  569.921816] Oops: 0000 [#2] PREEMPT SMP NOPTI
[  569.921819] CPU: 6 PID: 7334 Comm: CPU 1/KVM Tainted: P      D    OE    
5.6.0-rc2-1-mainline #1
[  569.921821] Hardware name: System manufacturer System Product Name/TUF
GAMING X570-PLUS, BIOS 1405 11/19/2019
[  569.921828] RIP: 0010:svm_refresh_apicv_exec_ctrl+0xf4/0x130 [kvm_amd]
[  569.921830] Code: 8b 83 f8 39 00 00 48 39 c5 74 31 48 8b 9b f8 39 00 00 48
39 dd 75 13 eb 23 e8 08 a0 90 f0 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b
10 45 85 e4 75 e6 e8 5e 9f 90 f0 85 c0 74 e6 5b 4c 89 ee
[  569.921832] RSP: 0018:ffffa7a748ecfce8 EFLAGS: 00010082
[  569.921836] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffa39037a67000
[  569.921837] RDX: 0000000000000001 RSI: ffffa38f3c9e1400 RDI:
0000000000000000
[  569.921839] RBP: ffffa38f3ca539f8 R08: 0000000000000000 R09:
0000000000000bb8
[  569.921841] R10: 00000000000000e1 R11: 0000000000000000 R12:
0000000000000000
[  569.921842] R13: 0000000000000202 R14: ffffa38f3ca53a08 R15:
ffffa38f3ca50000
[  569.921845] FS:  00007f6b5c3ff700(0000) GS:ffffa3905e980000(0000)
knlGS:0000000000000000
[  569.921847] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  569.921848] CR2: 0000000000000010 CR3: 000000032f9ec000 CR4:
0000000000340ee0
[  569.921850] Call Trace:
[  569.921858]  svm_vcpu_unblocking+0x31/0x50 [kvm_amd]
[  569.921884]  kvm_vcpu_block+0xd1/0x340 [kvm]
[  569.921911]  kvm_arch_vcpu_ioctl_run+0x1234/0x1b20 [kvm]
[  569.921916]  ? __seccomp_filter+0xd2/0x6c0
[  569.921936]  kvm_vcpu_ioctl+0x266/0x630 [kvm]
[  569.921942]  ksys_ioctl+0x87/0xc0
[  569.921945]  __x64_sys_ioctl+0x16/0x20
[  569.921948]  do_syscall_64+0x4e/0x150
[  569.921951]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  569.921954] RIP: 0033:0x7f6b607452eb
[  569.921956] Code: 0f 1e fa 48 8b 05 a5 8b 0c 00 64 c7 00 26 00 00 00 48 c7
c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 75 8b 0c 00 f7 d8 64 89 01 48
[  569.921958] RSP: 002b:00007f6b5c3fcea8 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  569.921960] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX:
00007f6b607452eb
[  569.921962] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
000000000000001a
[  569.921964] RBP: 00007f6b5e028800 R08: 00005558b88eb110 R09:
0000000000000000
[  569.921965] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[  569.921967] R13: 00007ffd77fa257f R14: 00007f6b5c3fd140 R15:
00007f6b5c3ff700
[  569.921971] Modules linked in: vhost_net vhost tap cpufreq_ondemand
ebtable_filter ebtables tun bridge stp llc uvcvideo videobuf2_vmalloc
videobuf2_memops videobuf2_v4l2 videobuf2_common snd_usb_audio videodev
snd_usbmidi_lib snd_rawmidi nvidia_drm(POE) snd_seq_device mc
nvidia_modeset(POE) nct6775 hwmon_vid nvidia(POE) amdgpu nls_iso8859_1
gpu_sched nls_cp437 vfat radeon fat fuse snd_hda_codec_realtek i2c_algo_bit
snd_hda_codec_generic ttm ledtrig_audio eeepc_wmi snd_hda_codec_hdmi asus_wmi
drm_kms_helper battery sparse_keymap rfkill wmi_bmof snd_hda_intel cec
edac_mce_amd snd_intel_dspcfg snd_hda_codec crct10dif_pclmul drm crc32_pclmul
snd_hda_core ghash_clmulni_intel snd_hwdep ipmi_devintf snd_pcm ipmi_msghandler
aesni_intel r8169 agpgart snd_timer crypto_simd syscopyarea sp5100_tco cryptd
sysfillrect realtek glue_helper joydev sysimgblt input_leds mousedev pcspkr
k10temp snd i2c_piix4 fb_sys_fops libphy soundcore wmi pinctrl_amd evdev
mac_hid acpi_cpufreq nf_log_ipv6 ip6t_REJECT
[  569.922006]  nf_reject_ipv6 xt_hl ip6t_rt nf_log_ipv4 nf_log_common
ipt_REJECT nf_reject_ipv4 xt_LOG xt_multiport xt_limit xt_addrtype xt_tcpudp
xt_conntrack ip6table_filter ip6_tables nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c iptable_filter sg ip_tables x_tables
ext4 crc32c_generic crc16 mbcache jbd2 sr_mod cdrom sd_mod hid_generic usbhid
hid ahci libahci crc32c_intel libata xhci_pci scsi_mod xhci_hcd vfio_pci
vfio_virqfd vfio_iommu_type1 vfio kvm_amd ccp rng_core kvm irqbypass
[  569.922031] CR2: 0000000000000010
[  569.922033] ---[ end trace c5c7ecbc97cc5c9b ]---
[  569.922035] BUG: kernel NULL pointer dereference, address: 0000000000000010
[  569.922037] #PF: supervisor read access in kernel mode
[  569.922039] #PF: error_code(0x0000) - not-present page
[  569.922040] PGD 0 P4D 0 
[  569.922045] RIP: 0010:svm_refresh_apicv_exec_ctrl+0xf4/0x130 [kvm_amd]
[  569.922047] Code: 8b 83 f8 39 00 00 48 39 c5 74 31 48 8b 9b f8 39 00 00 48
39 dd 75 13 eb 23 e8 08 a0 90 f0 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b
10 45 85 e4 75 e6 e8 5e 9f 90 f0 85 c0 74 e6 5b 4c 89 ee
[  569.922048] RSP: 0018:ffffa7a74084fce8 EFLAGS: 00010082
[  569.922051] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffa38f715ce000
[  569.922052] RDX: 0000000000000001 RSI: ffffa38f3c9e1800 RDI:
0000000000000000
[  569.922054] RBP: ffffa38f3ca57408 R08: 0000000000000000 R09:
0000000000000bb8
[  569.922055] R10: 000000849ef65aa1 R11: 00000000000630c0 R12:
0000000000000000
[  569.922057] R13: 0000000000000202 R14: ffffa38f3ca57418 R15:
ffffa38f3ca53a10
[  569.922058] FS:  00007f6b5c3ff700(0000) GS:ffffa3905e980000(0000)
knlGS:0000000000000000
[  569.922060] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  569.922062] CR2: 0000000000000010 CR3: 000000032f9ec000 CR4:
0000000000340ee0
[  569.922064] note: CPU 1/KVM[7334] exited with preempt_count 1
[  569.922066] Oops: 0000 [#3] PREEMPT SMP NOPTI
[  569.922068] CPU: 14 PID: 7340 Comm: CPU 7/KVM Tainted: P      D    OE    
5.6.0-rc2-1-mainline #1
[  569.922071] Hardware name: System manufacturer System Product Name/TUF
GAMING X570-PLUS, BIOS 1405 11/19/2019
[  569.922079] RIP: 0010:svm_refresh_apicv_exec_ctrl+0xf4/0x130 [kvm_amd]
[  569.922082] Code: 8b 83 f8 39 00 00 48 39 c5 74 31 48 8b 9b f8 39 00 00 48
39 dd 75 13 eb 23 e8 08 a0 90 f0 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b
10 45 85 e4 75 e6 e8 5e 9f 90 f0 85 c0 74 e6 5b 4c 89 ee
[  569.922084] RSP: 0018:ffffa7a74882fce8 EFLAGS: 00010082
[  569.922087] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffa38f6de2f000
[  569.922089] RDX: 0000000000000001 RSI: ffffa38f6f9fc100 RDI:
0000000000000000
[  569.922091] RBP: ffffa38f6f3239f8 R08: 0000000000000000 R09:
0000000000000bb8
[  569.922094] R10: 0000000000000078 R11: 0000000000000000 R12:
0000000000000000
[  569.922096] R13: 0000000000000202 R14: ffffa38f6f323a08 R15:
ffffa38f6f320000
[  569.922098] FS:  00007f6b56fff700(0000) GS:ffffa3905eb80000(0000)
knlGS:0000000000000000
[  569.922100] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  569.922102] CR2: 0000000000000010 CR3: 000000032f9ec000 CR4:
0000000000340ee0
[  569.922105] Call Trace:
[  569.922111]  svm_vcpu_unblocking+0x31/0x50 [kvm_amd]
[  569.922130]  kvm_vcpu_block+0xd1/0x340 [kvm]
[  569.922151]  kvm_arch_vcpu_ioctl_run+0x1234/0x1b20 [kvm]
[  569.922154]  ? __seccomp_filter+0xd2/0x6c0
[  569.922171]  kvm_vcpu_ioctl+0x266/0x630 [kvm]
[  569.922176]  ksys_ioctl+0x87/0xc0
[  569.922179]  __x64_sys_ioctl+0x16/0x20
[  569.922181]  do_syscall_64+0x4e/0x150
[  569.922184]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  569.922186] RIP: 0033:0x7f6b607452eb
[  569.922188] Code: 0f 1e fa 48 8b 05 a5 8b 0c 00 64 c7 00 26 00 00 00 48 c7
c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 75 8b 0c 00 f7 d8 64 89 01 48
[  569.922189] RSP: 002b:00007f6b56ffcea8 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  569.922191] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX:
00007f6b607452eb
[  569.922193] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
0000000000000020
[  569.922194] RBP: 00007f6b5e12ba00 R08: 00005558b88eb110 R09:
0000000000000000
[  569.922195] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[  569.922196] R13: 00007ffd77fa257f R14: 00007f6b56ffd140 R15:
00007f6b56fff700
[  569.922200] Modules linked in: vhost_net vhost tap cpufreq_ondemand
ebtable_filter ebtables tun bridge stp llc uvcvideo videobuf2_vmalloc
videobuf2_memops videobuf2_v4l2 videobuf2_common snd_usb_audio videodev
snd_usbmidi_lib snd_rawmidi nvidia_drm(POE) snd_seq_device mc
nvidia_modeset(POE) nct6775 hwmon_vid nvidia(POE) amdgpu nls_iso8859_1
gpu_sched nls_cp437 vfat radeon fat fuse snd_hda_codec_realtek i2c_algo_bit
snd_hda_codec_generic ttm ledtrig_audio eeepc_wmi snd_hda_codec_hdmi asus_wmi
drm_kms_helper battery sparse_keymap rfkill wmi_bmof snd_hda_intel cec
edac_mce_amd snd_intel_dspcfg snd_hda_codec crct10dif_pclmul drm crc32_pclmul
snd_hda_core ghash_clmulni_intel snd_hwdep ipmi_devintf snd_pcm ipmi_msghandler
aesni_intel r8169 agpgart snd_timer crypto_simd syscopyarea sp5100_tco cryptd
sysfillrect realtek glue_helper joydev sysimgblt input_leds mousedev pcspkr
k10temp snd i2c_piix4 fb_sys_fops libphy soundcore wmi pinctrl_amd evdev
mac_hid acpi_cpufreq nf_log_ipv6 ip6t_REJECT
[  569.922229]  nf_reject_ipv6 xt_hl ip6t_rt nf_log_ipv4 nf_log_common
ipt_REJECT nf_reject_ipv4 xt_LOG xt_multiport xt_limit xt_addrtype xt_tcpudp
xt_conntrack ip6table_filter ip6_tables nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c iptable_filter sg ip_tables x_tables
ext4 crc32c_generic crc16 mbcache jbd2 sr_mod cdrom sd_mod hid_generic usbhid
hid ahci libahci crc32c_intel libata xhci_pci scsi_mod xhci_hcd vfio_pci
vfio_virqfd vfio_iommu_type1 vfio kvm_amd ccp rng_core kvm irqbypass
[  569.922250] CR2: 0000000000000010
[  569.922252] ---[ end trace c5c7ecbc97cc5c9c ]---
[  569.922254] BUG: kernel NULL pointer dereference, address: 0000000000000010
[  569.922255] #PF: supervisor read access in kernel mode
[  569.922257] #PF: error_code(0x0000) - not-present page
[  569.922258] PGD 0 P4D 0 
[  569.922262] RIP: 0010:svm_refresh_apicv_exec_ctrl+0xf4/0x130 [kvm_amd]
[  569.922265] Code: 8b 83 f8 39 00 00 48 39 c5 74 31 48 8b 9b f8 39 00 00 48
39 dd 75 13 eb 23 e8 08 a0 90 f0 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b
10 45 85 e4 75 e6 e8 5e 9f 90 f0 85 c0 74 e6 5b 4c 89 ee
[  569.922266] RSP: 0018:ffffa7a74084fce8 EFLAGS: 00010082
[  569.922269] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffa38f715ce000
[  569.922270] RDX: 0000000000000001 RSI: ffffa38f3c9e1800 RDI:
0000000000000000
[  569.922272] RBP: ffffa38f3ca57408 R08: 0000000000000000 R09:
0000000000000bb8
[  569.922273] R10: 000000849ef65aa1 R11: 00000000000630c0 R12:
0000000000000000
[  569.922275] R13: 0000000000000202 R14: ffffa38f3ca57418 R15:
ffffa38f3ca53a10
[  569.922276] FS:  00007f6b56fff700(0000) GS:ffffa3905eb80000(0000)
knlGS:0000000000000000
[  569.922278] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  569.922279] CR2: 0000000000000010 CR3: 000000032f9ec000 CR4:
0000000000340ee0
[  569.922281] note: CPU 7/KVM[7340] exited with preempt_count 1
[  569.922283] Oops: 0000 [#4] PREEMPT SMP NOPTI
[  569.922285] CPU: 13 PID: 7337 Comm: CPU 4/KVM Tainted: P      D    OE    
5.6.0-rc2-1-mainline #1
[  569.922287] Hardware name: System manufacturer System Product Name/TUF
GAMING X570-PLUS, BIOS 1405 11/19/2019
[  569.922292] RIP: 0010:svm_refresh_apicv_exec_ctrl+0xf4/0x130 [kvm_amd]
[  569.922295] Code: 8b 83 f8 39 00 00 48 39 c5 74 31 48 8b 9b f8 39 00 00 48
39 dd 75 13 eb 23 e8 08 a0 90 f0 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b
10 45 85 e4 75 e6 e8 5e 9f 90 f0 85 c0 74 e6 5b 4c 89 ee
[  569.922296] RSP: 0018:ffffa7a741e9fce8 EFLAGS: 00010082
[  569.922300] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffa38f3e68f000
[  569.922302] RDX: 0000000000000001 RSI: ffffa38d90ecb800 RDI:
0000000000000000
[  569.922304] RBP: ffffa38d90eb39f8 R08: 0000000000000000 R09:
0000000000000bb8
[  569.922305] R10: 0000000000000264 R11: 0000000000000000 R12:
0000000000000000
[  569.922307] R13: 0000000000000202 R14: ffffa38d90eb3a08 R15:
ffffa38d90eb0000
[  569.922309] FS:  00007f6b599ff700(0000) GS:ffffa3905eb40000(0000)
knlGS:0000000000000000
[  569.922311] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  569.922312] CR2: 0000000000000010 CR3: 000000032f9ec000 CR4:
0000000000340ee0
[  569.922314] Call Trace:
[  569.922321]  svm_vcpu_unblocking+0x31/0x50 [kvm_amd]
[  569.922338]  kvm_vcpu_block+0xd1/0x340 [kvm]
[  569.922360]  kvm_arch_vcpu_ioctl_run+0x1234/0x1b20 [kvm]
[  569.922364]  ? __seccomp_filter+0xd2/0x6c0
[  569.922382]  kvm_vcpu_ioctl+0x266/0x630 [kvm]
[  569.922387]  ksys_ioctl+0x87/0xc0
[  569.922390]  __x64_sys_ioctl+0x16/0x20
[  569.922393]  do_syscall_64+0x4e/0x150
[  569.922396]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  569.922398] RIP: 0033:0x7f6b607452eb
[  569.922400] Code: 0f 1e fa 48 8b 05 a5 8b 0c 00 64 c7 00 26 00 00 00 48 c7
c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 75 8b 0c 00 f7 d8 64 89 01 48
[  569.922402] RSP: 002b:00007f6b599fcea8 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  569.922404] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX:
00007f6b607452eb
[  569.922405] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
000000000000001d
[  569.922407] RBP: 00007f6b5e0ac480 R08: 00005558b88eb110 R09:
0000000000000000
[  569.922408] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[  569.922409] R13: 00007ffd77fa257f R14: 00007f6b599fd140 R15:
00007f6b599ff700
[  569.922412] Modules linked in: vhost_net vhost tap cpufreq_ondemand
ebtable_filter ebtables tun bridge stp llc uvcvideo videobuf2_vmalloc
videobuf2_memops videobuf2_v4l2 videobuf2_common snd_usb_audio videodev
snd_usbmidi_lib snd_rawmidi nvidia_drm(POE) snd_seq_device mc
nvidia_modeset(POE) nct6775 hwmon_vid nvidia(POE) amdgpu nls_iso8859_1
gpu_sched nls_cp437 vfat radeon fat fuse snd_hda_codec_realtek i2c_algo_bit
snd_hda_codec_generic ttm ledtrig_audio eeepc_wmi snd_hda_codec_hdmi asus_wmi
drm_kms_helper battery sparse_keymap rfkill wmi_bmof snd_hda_intel cec
edac_mce_amd snd_intel_dspcfg snd_hda_codec crct10dif_pclmul drm crc32_pclmul
snd_hda_core ghash_clmulni_intel snd_hwdep ipmi_devintf snd_pcm ipmi_msghandler
aesni_intel r8169 agpgart snd_timer crypto_simd syscopyarea sp5100_tco cryptd
sysfillrect realtek glue_helper joydev sysimgblt input_leds mousedev pcspkr
k10temp snd i2c_piix4 fb_sys_fops libphy soundcore wmi pinctrl_amd evdev
mac_hid acpi_cpufreq nf_log_ipv6 ip6t_REJECT
[  569.922442]  nf_reject_ipv6 xt_hl ip6t_rt nf_log_ipv4 nf_log_common
ipt_REJECT nf_reject_ipv4 xt_LOG xt_multiport xt_limit xt_addrtype xt_tcpudp
xt_conntrack ip6table_filter ip6_tables nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c iptable_filter sg ip_tables x_tables
ext4 crc32c_generic crc16 mbcache jbd2 sr_mod cdrom sd_mod hid_generic usbhid
hid ahci libahci crc32c_intel libata xhci_pci scsi_mod xhci_hcd vfio_pci
vfio_virqfd vfio_iommu_type1 vfio kvm_amd ccp rng_core kvm irqbypass
[  569.922463] CR2: 0000000000000010
[  569.922465] ---[ end trace c5c7ecbc97cc5c9d ]---
[  569.922467] BUG: kernel NULL pointer dereference, address: 0000000000000010
[  569.922469] #PF: supervisor read access in kernel mode
[  569.922470] #PF: error_code(0x0000) - not-present page
[  569.922472] PGD 0 P4D 0 
[  569.922479] RIP: 0010:svm_refresh_apicv_exec_ctrl+0xf4/0x130 [kvm_amd]
[  569.922481] Code: 8b 83 f8 39 00 00 48 39 c5 74 31 48 8b 9b f8 39 00 00 48
39 dd 75 13 eb 23 e8 08 a0 90 f0 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b
10 45 85 e4 75 e6 e8 5e 9f 90 f0 85 c0 74 e6 5b 4c 89 ee
[  569.922483] RSP: 0018:ffffa7a74084fce8 EFLAGS: 00010082
[  569.922486] Oops: 0000 [#5] PREEMPT SMP NOPTI
[  569.922489] CPU: 8 PID: 7336 Comm: CPU 3/KVM Tainted: P      D    OE    
5.6.0-rc2-1-mainline #1
[  569.922491] Hardware name: System manufacturer System Product Name/TUF
GAMING X570-PLUS, BIOS 1405 11/19/2019
[  569.922497] RIP: 0010:svm_refresh_apicv_exec_ctrl+0xf4/0x130 [kvm_amd]
[  569.922500] Code: 8b 83 f8 39 00 00 48 39 c5 74 31 48 8b 9b f8 39 00 00 48
39 dd 75 13 eb 23 e8 08 a0 90 f0 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b
10 45 85 e4 75 e6 e8 5e 9f 90 f0 85 c0 74 e6 5b 4c 89 ee
[  569.922502] RSP: 0018:ffffa7a741d87ce8 EFLAGS: 00010082
[  569.922505] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffa38f715ce000
[  569.922507] RDX: 0000000000000001 RSI: ffffa38f3c9e1800 RDI:
0000000000000000
[  569.922508] RBP: ffffa38f3ca57408 R08: 0000000000000000 R09:
0000000000000bb8
[  569.922510] R10: 000000849ef65aa1 R11: 00000000000630c0 R12:
0000000000000000
[  569.922511] R13: 0000000000000202 R14: ffffa38f3ca57418 R15:
ffffa38f3ca53a10
[  569.922513] FS:  00007f6b599ff700(0000) GS:ffffa3905eb40000(0000)
knlGS:0000000000000000
[  569.922515] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  569.922517] CR2: 0000000000000010 CR3: 000000032f9ec000 CR4:
0000000000340ee0
[  569.922519] note: CPU 4/KVM[7337] exited with preempt_count 1
[  569.922520] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffa38f717f5000
[  569.922522] RDX: 0000000000000001 RSI: ffffa38f3c9e0000 RDI:
0000000000000000
[  569.922523] RBP: ffffa38d90ec7408 R08: 0000000000000000 R09:
0000000000000bb8
[  569.922525] R10: 000000000000022d R11: 000000000006a63c R12:
0000000000000000
[  569.922527] R13: 0000000000000202 R14: ffffa38d90ec7418 R15:
ffffa38d90ec3a10
[  569.922529] FS:  00007f6b5a7ff700(0000) GS:ffffa3905ea00000(0000)
knlGS:0000000000000000
[  569.922531] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  569.922532] CR2: 0000000000000010 CR3: 000000032f9ec000 CR4:
0000000000340ee0
[  569.922534] Call Trace:
[  569.922541]  svm_vcpu_unblocking+0x31/0x50 [kvm_amd]
[  569.922559]  kvm_vcpu_block+0xd1/0x340 [kvm]
[  569.922581]  kvm_arch_vcpu_ioctl_run+0x1234/0x1b20 [kvm]
[  569.922586]  ? __seccomp_filter+0xd2/0x6c0
[  569.922603]  kvm_vcpu_ioctl+0x266/0x630 [kvm]
[  569.922608]  ksys_ioctl+0x87/0xc0
[  569.922611]  __x64_sys_ioctl+0x16/0x20
[  569.922614]  do_syscall_64+0x4e/0x150
[  569.922618]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  569.922620] RIP: 0033:0x7f6b607452eb
[  569.922622] Code: 0f 1e fa 48 8b 05 a5 8b 0c 00 64 c7 00 26 00 00 00 48 c7
c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 75 8b 0c 00 f7 d8 64 89 01 48
[  569.922624] RSP: 002b:00007f6b5a7fcea8 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  569.922626] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX:
00007f6b607452eb
[  569.922627] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
000000000000001c
[  569.922628] RBP: 00007f6b5e07e040 R08: 00005558b88eb110 R09:
0000000000000000
[  569.922629] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[  569.922630] R13: 00007ffd77fa257f R14: 00007f6b5a7fd140 R15:
00007f6b5a7ff700
[  569.922635] Modules linked in: vhost_net vhost tap cpufreq_ondemand
ebtable_filter ebtables tun bridge stp llc uvcvideo videobuf2_vmalloc
videobuf2_memops videobuf2_v4l2 videobuf2_common snd_usb_audio videodev
snd_usbmidi_lib snd_rawmidi nvidia_drm(POE) snd_seq_device mc
nvidia_modeset(POE) nct6775 hwmon_vid nvidia(POE) amdgpu nls_iso8859_1
gpu_sched nls_cp437 vfat radeon fat fuse snd_hda_codec_realtek i2c_algo_bit
snd_hda_codec_generic ttm ledtrig_audio eeepc_wmi snd_hda_codec_hdmi asus_wmi
drm_kms_helper battery sparse_keymap rfkill wmi_bmof snd_hda_intel cec
edac_mce_amd snd_intel_dspcfg snd_hda_codec crct10dif_pclmul drm crc32_pclmul
snd_hda_core ghash_clmulni_intel snd_hwdep ipmi_devintf snd_pcm ipmi_msghandler
aesni_intel r8169 agpgart snd_timer crypto_simd syscopyarea sp5100_tco cryptd
sysfillrect realtek glue_helper joydev sysimgblt input_leds mousedev pcspkr
k10temp snd i2c_piix4 fb_sys_fops libphy soundcore wmi pinctrl_amd evdev
mac_hid acpi_cpufreq nf_log_ipv6 ip6t_REJECT
[  569.922671]  nf_reject_ipv6 xt_hl ip6t_rt nf_log_ipv4 nf_log_common
ipt_REJECT nf_reject_ipv4 xt_LOG xt_multiport xt_limit xt_addrtype xt_tcpudp
xt_conntrack ip6table_filter ip6_tables nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c iptable_filter sg ip_tables x_tables
ext4 crc32c_generic crc16 mbcache jbd2 sr_mod cdrom sd_mod hid_generic usbhid
hid ahci libahci crc32c_intel libata xhci_pci scsi_mod xhci_hcd vfio_pci
vfio_virqfd vfio_iommu_type1 vfio kvm_amd ccp rng_core kvm irqbypass
[  569.922694] CR2: 0000000000000010
[  569.922696] ---[ end trace c5c7ecbc97cc5c9e ]---
[  569.922697] BUG: kernel NULL pointer dereference, address: 0000000000000010
[  569.922699] #PF: supervisor read access in kernel mode
[  569.922700] #PF: error_code(0x0000) - not-present page
[  569.922701] PGD 0 P4D 0 
[  569.922707] RIP: 0010:svm_refresh_apicv_exec_ctrl+0xf4/0x130 [kvm_amd]
[  569.922709] Code: 8b 83 f8 39 00 00 48 39 c5 74 31 48 8b 9b f8 39 00 00 48
39 dd 75 13 eb 23 e8 08 a0 90 f0 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b
10 45 85 e4 75 e6 e8 5e 9f 90 f0 85 c0 74 e6 5b 4c 89 ee
[  569.922710] RSP: 0018:ffffa7a74084fce8 EFLAGS: 00010082
[  569.922713] Oops: 0000 [#6] PREEMPT SMP NOPTI
[  569.922715] CPU: 9 PID: 7338 Comm: CPU 5/KVM Tainted: P      D    OE    
5.6.0-rc2-1-mainline #1
[  569.922717] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffa38f715ce000
[  569.922718] RDX: 0000000000000001 RSI: ffffa38f3c9e1800 RDI:
0000000000000000
[  569.922719] RBP: ffffa38f3ca57408 R08: 0000000000000000 R09:
0000000000000bb8
[  569.922720] R10: 000000849ef65aa1 R11: 00000000000630c0 R12:
0000000000000000
[  569.922721] R13: 0000000000000202 R14: ffffa38f3ca57418 R15:
ffffa38f3ca53a10
[  569.922723] FS:  00007f6b5a7ff700(0000) GS:ffffa3905ea00000(0000)
knlGS:0000000000000000
[  569.922724] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  569.922726] CR2: 0000000000000010 CR3: 000000032f9ec000 CR4:
0000000000340ee0
[  569.922727] Hardware name: System manufacturer System Product Name/TUF
GAMING X570-PLUS, BIOS 1405 11/19/2019
[  569.922733] RIP: 0010:svm_refresh_apicv_exec_ctrl+0xf4/0x130 [kvm_amd]
[  569.922735] Code: 8b 83 f8 39 00 00 48 39 c5 74 31 48 8b 9b f8 39 00 00 48
39 dd 75 13 eb 23 e8 08 a0 90 f0 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b
10 45 85 e4 75 e6 e8 5e 9f 90 f0 85 c0 74 e6 5b 4c 89 ee
[  569.922737] RSP: 0018:ffffa7a74310fce8 EFLAGS: 00010082
[  569.922738] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffa38f42a78000
[  569.922740] RDX: 0000000000000001 RSI: ffffa38f3dc17700 RDI:
0000000000000000
[  569.922741] note: CPU 3/KVM[7336] exited with preempt_count 1
[  569.922742] RBP: ffffa38f3df739f8 R08: 0000000000000000 R09:
0000000000000bb8
[  569.922744] R10: 00000000000003fc R11: 0000000000001637 R12:
0000000000000000
[  569.922745] R13: 0000000000000202 R14: ffffa38f3df73a08 R15:
ffffa38f3df70000
[  569.922747] FS:  00007f6b58bff700(0000) GS:ffffa3905ea40000(0000)
knlGS:0000000000000000
[  569.922748] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  569.922749] CR2: 0000000000000010 CR3: 000000032f9ec000 CR4:
0000000000340ee0
[  569.922751] Call Trace:
[  569.922756]  svm_vcpu_unblocking+0x31/0x50 [kvm_amd]
[  569.922773]  kvm_vcpu_block+0xd1/0x340 [kvm]
[  569.922795]  kvm_arch_vcpu_ioctl_run+0x1234/0x1b20 [kvm]
[  569.922799]  ? __seccomp_filter+0xd2/0x6c0
[  569.922816]  kvm_vcpu_ioctl+0x266/0x630 [kvm]
[  569.922820]  ksys_ioctl+0x87/0xc0
[  569.922823]  __x64_sys_ioctl+0x16/0x20
[  569.922825]  do_syscall_64+0x4e/0x150
[  569.922828]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  569.922831] RIP: 0033:0x7f6b607452eb
[  569.922833] Code: 0f 1e fa 48 8b 05 a5 8b 0c 00 64 c7 00 26 00 00 00 48 c7
c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 75 8b 0c 00 f7 d8 64 89 01 48
[  569.922834] RSP: 002b:00007f6b58bfcea8 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  569.922836] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX:
00007f6b607452eb
[  569.922837] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
000000000000001e
[  569.922838] RBP: 00007f6b5e0da2c0 R08: 00005558b88eb110 R09:
0000000000000000
[  569.922839] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[  569.922840] R13: 00007ffd77fa257f R14: 00007f6b58bfd140 R15:
00007f6b58bff700
[  569.922843] Modules linked in: vhost_net vhost tap cpufreq_ondemand
ebtable_filter ebtables tun bridge stp llc uvcvideo videobuf2_vmalloc
videobuf2_memops videobuf2_v4l2 videobuf2_common snd_usb_audio videodev
snd_usbmidi_lib snd_rawmidi nvidia_drm(POE) snd_seq_device mc
nvidia_modeset(POE) nct6775 hwmon_vid nvidia(POE) amdgpu nls_iso8859_1
gpu_sched nls_cp437 vfat radeon fat fuse snd_hda_codec_realtek i2c_algo_bit
snd_hda_codec_generic ttm ledtrig_audio eeepc_wmi snd_hda_codec_hdmi asus_wmi
drm_kms_helper battery sparse_keymap rfkill wmi_bmof snd_hda_intel cec
edac_mce_amd snd_intel_dspcfg snd_hda_codec crct10dif_pclmul drm crc32_pclmul
snd_hda_core ghash_clmulni_intel snd_hwdep ipmi_devintf snd_pcm ipmi_msghandler
aesni_intel r8169 agpgart snd_timer crypto_simd syscopyarea sp5100_tco cryptd
sysfillrect realtek glue_helper joydev sysimgblt input_leds mousedev pcspkr
k10temp snd i2c_piix4 fb_sys_fops libphy soundcore wmi pinctrl_amd evdev
mac_hid acpi_cpufreq nf_log_ipv6 ip6t_REJECT
[  569.922867]  nf_reject_ipv6 xt_hl ip6t_rt nf_log_ipv4 nf_log_common
ipt_REJECT nf_reject_ipv4 xt_LOG xt_multiport xt_limit xt_addrtype xt_tcpudp
xt_conntrack ip6table_filter ip6_tables nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c iptable_filter sg ip_tables x_tables
ext4 crc32c_generic crc16 mbcache jbd2 sr_mod cdrom sd_mod hid_generic usbhid
hid ahci libahci crc32c_intel libata xhci_pci scsi_mod xhci_hcd vfio_pci
vfio_virqfd vfio_iommu_type1 vfio kvm_amd ccp rng_core kvm irqbypass
[  569.922884] CR2: 0000000000000010
[  569.922886] ---[ end trace c5c7ecbc97cc5c9f ]---
[  569.922887] BUG: kernel NULL pointer dereference, address: 0000000000000010
[  569.922889] #PF: supervisor read access in kernel mode
[  569.922890] #PF: error_code(0x0000) - not-present page
[  569.922891] PGD 0 P4D 0 
[  569.922897] RIP: 0010:svm_refresh_apicv_exec_ctrl+0xf4/0x130 [kvm_amd]
[  569.922900] Code: 8b 83 f8 39 00 00 48 39 c5 74 31 48 8b 9b f8 39 00 00 48
39 dd 75 13 eb 23 e8 08 a0 90 f0 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b
10 45 85 e4 75 e6 e8 5e 9f 90 f0 85 c0 74 e6 5b 4c 89 ee
[  569.922901] RSP: 0018:ffffa7a74084fce8 EFLAGS: 00010082
[  569.922904] Oops: 0000 [#7] PREEMPT SMP NOPTI
[  569.922906] CPU: 10 PID: 7339 Comm: CPU 6/KVM Tainted: P      D    OE    
5.6.0-rc2-1-mainline #1
[  569.922908] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffa38f715ce000
[  569.922909] RDX: 0000000000000001 RSI: ffffa38f3c9e1800 RDI:
0000000000000000
[  569.922910] RBP: ffffa38f3ca57408 R08: 0000000000000000 R09:
0000000000000bb8
[  569.922911] R10: 000000849ef65aa1 R11: 00000000000630c0 R12:
0000000000000000
[  569.922912] R13: 0000000000000202 R14: ffffa38f3ca57418 R15:
ffffa38f3ca53a10
[  569.922914] FS:  00007f6b58bff700(0000) GS:ffffa3905ea40000(0000)
knlGS:0000000000000000
[  569.922915] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  569.922916] CR2: 0000000000000010 CR3: 000000032f9ec000 CR4:
0000000000340ee0
[  569.922918] Hardware name: System manufacturer System Product Name/TUF
GAMING X570-PLUS, BIOS 1405 11/19/2019
[  569.922919] note: CPU 5/KVM[7338] exited with preempt_count 1
[  569.922924] RIP: 0010:svm_refresh_apicv_exec_ctrl+0xf4/0x130 [kvm_amd]
[  569.922926] Code: 8b 83 f8 39 00 00 48 39 c5 74 31 48 8b 9b f8 39 00 00 48
39 dd 75 13 eb 23 e8 08 a0 90 f0 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b
10 45 85 e4 75 e6 e8 5e 9f 90 f0 85 c0 74 e6 5b 4c 89 ee
[  569.922928] RSP: 0018:ffffa7a74319fce8 EFLAGS: 00010082
[  569.922930] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffa39054d68000
[  569.922931] RDX: 0000000000000001 RSI: ffffa38f3dc17300 RDI:
0000000000000000
[  569.922932] RBP: ffffa38f3df77408 R08: 0000000000000000 R09:
0000000000000bb8
[  569.922934] R10: 000000000000012c R11: 0000000000d24bee R12:
0000000000000000
[  569.922935] R13: 0000000000000202 R14: ffffa38f3df77418 R15:
ffffa38f3df73a10
[  569.922936] FS:  00007f6b57dff700(0000) GS:ffffa3905ea80000(0000)
knlGS:0000000000000000
[  569.922938] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  569.922939] CR2: 0000000000000010 CR3: 000000032f9ec000 CR4:
0000000000340ee0
[  569.922940] Call Trace:
[  569.922946]  svm_vcpu_unblocking+0x31/0x50 [kvm_amd]
[  569.922963]  kvm_vcpu_block+0xd1/0x340 [kvm]
[  569.922985]  kvm_arch_vcpu_ioctl_run+0x1234/0x1b20 [kvm]
[  569.922988]  ? __seccomp_filter+0xd2/0x6c0
[  569.923005]  kvm_vcpu_ioctl+0x266/0x630 [kvm]
[  569.923010]  ksys_ioctl+0x87/0xc0
[  569.923012]  __x64_sys_ioctl+0x16/0x20
[  569.923015]  do_syscall_64+0x4e/0x150
[  569.923017]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  569.923019] RIP: 0033:0x7f6b607452eb
[  569.923021] Code: 0f 1e fa 48 8b 05 a5 8b 0c 00 64 c7 00 26 00 00 00 48 c7
c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 75 8b 0c 00 f7 d8 64 89 01 48
[  569.923023] RSP: 002b:00007f6b57dfcea8 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  569.923024] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX:
00007f6b607452eb
[  569.923026] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
000000000000001f
[  569.923027] RBP: 00007f6b5e104600 R08: 00005558b88eb110 R09:
0000000000000000
[  569.923028] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[  569.923029] R13: 00007ffd77fa257f R14: 00007f6b57dfd140 R15:
00007f6b57dff700
[  569.923032] Modules linked in: vhost_net vhost tap cpufreq_ondemand
ebtable_filter ebtables tun bridge stp llc uvcvideo videobuf2_vmalloc
videobuf2_memops videobuf2_v4l2 videobuf2_common snd_usb_audio videodev
snd_usbmidi_lib snd_rawmidi nvidia_drm(POE) snd_seq_device mc
nvidia_modeset(POE) nct6775 hwmon_vid nvidia(POE) amdgpu nls_iso8859_1
gpu_sched nls_cp437 vfat radeon fat fuse snd_hda_codec_realtek i2c_algo_bit
snd_hda_codec_generic ttm ledtrig_audio eeepc_wmi snd_hda_codec_hdmi asus_wmi
drm_kms_helper battery sparse_keymap rfkill wmi_bmof snd_hda_intel cec
edac_mce_amd snd_intel_dspcfg snd_hda_codec crct10dif_pclmul drm crc32_pclmul
snd_hda_core ghash_clmulni_intel snd_hwdep ipmi_devintf snd_pcm ipmi_msghandler
aesni_intel r8169 agpgart snd_timer crypto_simd syscopyarea sp5100_tco cryptd
sysfillrect realtek glue_helper joydev sysimgblt input_leds mousedev pcspkr
k10temp snd i2c_piix4 fb_sys_fops libphy soundcore wmi pinctrl_amd evdev
mac_hid acpi_cpufreq nf_log_ipv6 ip6t_REJECT
[  569.923057]  nf_reject_ipv6 xt_hl ip6t_rt nf_log_ipv4 nf_log_common
ipt_REJECT nf_reject_ipv4 xt_LOG xt_multiport xt_limit xt_addrtype xt_tcpudp
xt_conntrack ip6table_filter ip6_tables nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c iptable_filter sg ip_tables x_tables
ext4 crc32c_generic crc16 mbcache jbd2 sr_mod cdrom sd_mod hid_generic usbhid
hid ahci libahci crc32c_intel libata xhci_pci scsi_mod xhci_hcd vfio_pci
vfio_virqfd vfio_iommu_type1 vfio kvm_amd ccp rng_core kvm irqbypass
[  569.923073] CR2: 0000000000000010
[  569.923075] ---[ end trace c5c7ecbc97cc5ca0 ]---
[  569.923079] RIP: 0010:svm_refresh_apicv_exec_ctrl+0xf4/0x130 [kvm_amd]
[  569.923081] Code: 8b 83 f8 39 00 00 48 39 c5 74 31 48 8b 9b f8 39 00 00 48
39 dd 75 13 eb 23 e8 08 a0 90 f0 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b
10 45 85 e4 75 e6 e8 5e 9f 90 f0 85 c0 74 e6 5b 4c 89 ee
[  569.923082] RSP: 0018:ffffa7a74084fce8 EFLAGS: 00010082
[  569.923084] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffa38f715ce000
[  569.923085] RDX: 0000000000000001 RSI: ffffa38f3c9e1800 RDI:
0000000000000000
[  569.923086] RBP: ffffa38f3ca57408 R08: 0000000000000000 R09:
0000000000000bb8
[  569.923087] R10: 000000849ef65aa1 R11: 00000000000630c0 R12:
0000000000000000
[  569.923089] R13: 0000000000000202 R14: ffffa38f3ca57418 R15:
ffffa38f3ca53a10
[  569.923090] FS:  00007f6b57dff700(0000) GS:ffffa3905ea80000(0000)
knlGS:0000000000000000
[  569.923092] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  569.923093] CR2: 0000000000000010 CR3: 000000032f9ec000 CR4:
0000000000340ee0
[  569.923095] note: CPU 6/KVM[7339] exited with preempt_count 1

_---------- End dmesg output ----------_

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
