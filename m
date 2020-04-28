Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7251BCDBA
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 22:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgD1UzV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 28 Apr 2020 16:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726291AbgD1UzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 16:55:20 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207489] New: Kernel panic due to Lazy update IOAPIC EOI on an
 x86_64 *host*, when two (or more) PCI devices from different IOMMU groups are
 passed to Windows 10 guest, upon guest boot into Windows, with more than 4
 VCPUs
Date:   Tue, 28 Apr 2020 20:55:17 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: linux-kernel@polvanaubel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cc cf_regression attachments.created
Message-ID: <bug-207489-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207489

            Bug ID: 207489
           Summary: Kernel panic due to Lazy update IOAPIC EOI on an
                    x86_64 *host*, when two (or more) PCI devices from
                    different IOMMU groups are passed to Windows 10 guest,
                    upon guest boot into Windows, with more than 4 VCPUs
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.5.0-07987-gf458d039db7e
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: linux-kernel@polvanaubel.com
                CC: kvm@vger.kernel.org
        Regression: Yes

Created attachment 288795
  --> https://bugzilla.kernel.org/attachment.cgi?id=288795&action=edit
.config used to build the bugged kernel

### Summary
 Kernel panic due to Lazy update IOAPIC EOI on an x86_64 *host*, when two (or
more) PCI devices from different IOMMU groups are passed to Windows 10 guest,
upon guest boot into Windows, with more than 4 VCPUs.

Commit introducing problem: I've bisected this to commit
f458d039db7e8518041db4169d657407e3217008


### Full description
I run Windows 10 (64 bit Education edition) virtualized in KVM/Qemu/Libvirt,
with three PCI(e) devices passed through:
- One AMD RX590 graphics card (GPU & audio card together in one IOMMU group,
both passed through, no other devices in IOMMU group)
- One Intel C610/X99 chipset HD audio controller (mainboard on-board sound
device, alone in one IOMMU group)
- One ASMedia Technology ASM1142 USB 3.1 Host controller (PCIe USB3.1 card,
alone in one IOMMU group)

The host CPU is an Intel i7-5820k; 6 cores with hyperthreading enabled.
Mainboard is Asrock X99 Extreme6/3.1.

The guest gets 8 to 10 VCPUs, pinned to certain CPU cores, in a single-socket,
2-threads-per-core topology.
I want to emphasize that this setup has worked for years, this is confirmed to
work fine.

On kernel 5.6, my Windows 10 guest VMs (tested on two separate installations,
different VM configs) panic the host during guest boot.
It's a kernel panic where literally everything freezes. There is no crash of X
with a kernel panic visible afterwards. i3 showing the clock and CPU
utilization bars freezes completely.
Switching to another virtual console shows the kernel panic. It won't write it
out to log, because it detects a corrupted stack. I've therefore transcribed it
to the best of my ability, but the top of the panic will not show on my screens
and I don't have access to a serial console.

This happens consistently, every time slightly after the "spinning dots in a
circle" start that indicate the guest boot has moved from TianoCore to the
actual booting of Windows 10.
Further investigation reveals that the guests boot fine if I remove all USB and
PCI devices passed to the VM.
Re-adding each PCI device individually (with two devices for the AMD GPU &
soundcard in the same IOMMU group) does not cause the host to lock up.
Adding any combination of two PCI devices in separate IOMMU groups caused the
host to lock up on kernel 5.6.7, 5.6.2, and 5.6.
Kernels 5.4.35-lts, 5.5.5, and 5.5.13 all do not exhibit this problem.

I have bisected between 5.5.13 and 5.6 (which went through the common 5.5
ancestor) by creating a config known to lock up on bad kernels, with just the
HD audio controller and the ASM1142 USB controller passed through. If the VM
locks up the host, the revision is bad, if the VM boots without locking up the
host, the revision is good.

The commit introducing this behaviour is
f458d039db7e8518041db4169d657407e3217008 kvm: ioapic: Lazy update IOAPIC EOI

What I absolutely don't get is how this commit, which seems particular for AMD
chips(ets), somehow triggers a kernel panic on my *entirely Intel* stack.


Further testing on the kernel built from this commit also revealed that I can
only reproduce the issue if I enable more than 4 VCPUs (i.e. more than 2
hyperthreaded cores); the topology that starts triggering the panic is 1
socket, 3 cores, 2 threads per core. See the included libvirt XML for that
topology. However, the bug is also triggered with 4 and 5 cores, and with VCPU
pinning.


### Keywords
KVM, virtualization, kernel, lazy update IOAPIC EOI


### Kernel Information:
Kernel version from /proc/version:
Linux version 5.5.0-07987-gf458d039db7e (pol@victorinox) (gcc version 9.3.0
(Arch Linux 9.3.0-1)) #16 SMP PREEMPT Tue Apr 28 19:43:19 CEST 2020

Kernel .config:
See attached .config


### Most recent known good kernels & commit to blame
Kernels 5.4.35-lts, 5.5.5, and 5.5.13 all do not exhibit this problem.
Bisected the problem to f458d039db7e8518041db4169d657407e3217008, between v5.5
and v5.6
Bisect log: 
git bisect start
# good: [fe5ae687d01e74854ed33666c932a9c11e22139c] Linux 5.5.13
git bisect good fe5ae687d01e74854ed33666c932a9c11e22139c
# bad: [7111951b8d4973bda27ff663f2cf18b663d15b48] Linux 5.6
git bisect bad 7111951b8d4973bda27ff663f2cf18b663d15b48
# good: [d5226fa6dbae0569ee43ecfc08bdcd6770fc4755] Linux 5.5
git bisect good d5226fa6dbae0569ee43ecfc08bdcd6770fc4755
# good: [9f68e3655aae6d49d6ba05dd263f99f33c2567af] Merge tag
'drm-next-2020-01-30' of git://anongit.freedesktop.org/drm/drm
git bisect good 9f68e3655aae6d49d6ba05dd263f99f33c2567af
# bad: [469030d454bd1620c7b2651d9ec8cdcbaa74deb9] Merge tag 'armsoc-soc' of
git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
git bisect bad 469030d454bd1620c7b2651d9ec8cdcbaa74deb9
# good: [f4a6365ae88d38528b4eec717326dab877b515ea] Merge tag 'clk-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux
git bisect good f4a6365ae88d38528b4eec717326dab877b515ea
# good: [e310396bb8d7db977a0e10ef7b5040e98b89c34c] Merge tag 'trace-v5.6-2' of
git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
git bisect good e310396bb8d7db977a0e10ef7b5040e98b89c34c
# bad: [ed39ba0ec1156407040e7509cb19299b5dda3815] Merge tag 'acpi-5.6-rc1-3' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect bad ed39ba0ec1156407040e7509cb19299b5dda3815
# bad: [9b7fa2880fe716a30d2359d40d12ec4bc69ec7b5] Merge tag 'xtensa-20200206'
of git://github.com/jcmvbkbc/linux-xtensa
git bisect bad 9b7fa2880fe716a30d2359d40d12ec4bc69ec7b5
# good: [750ce8ccd8a875ed9410fab01a3f468dab692eb4] Merge tag
'sound-fix-5.6-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect good 750ce8ccd8a875ed9410fab01a3f468dab692eb4
# bad: [a83502314ce303c6341b249c41121759c7477ba1] x86/kvm/hyper-v: don't allow
to turn on unsupported VMX controls for nested guests
git bisect bad a83502314ce303c6341b249c41121759c7477ba1
# good: [1ec2405c7cbf3afa7598c6b7546c81aa0cac78dc] kvm: ioapic: Refactor
kvm_ioapic_update_eoi()
git bisect good 1ec2405c7cbf3afa7598c6b7546c81aa0cac78dc
# bad: [7df003c85218b5f5b10a7f6418208f31e813f38f] KVM: fix overflow of zero
page refcount with ksm running
git bisect bad 7df003c85218b5f5b10a7f6418208f31e813f38f
# bad: [33aabd029ffbafe314dad4763dadbc23d71296eb] KVM: nVMX: delete meaningless
nested_vmx_run() declaration
git bisect bad 33aabd029ffbafe314dad4763dadbc23d71296eb
# bad: [e8ef2a19a051b755b0b9973ef1b3f81e895e2bce] KVM: SVM: allow AVIC without
split irqchip
git bisect bad e8ef2a19a051b755b0b9973ef1b3f81e895e2bce
# bad: [f458d039db7e8518041db4169d657407e3217008] kvm: ioapic: Lazy update
IOAPIC EOI
git bisect bad f458d039db7e8518041db4169d657407e3217008
# first bad commit: [f458d039db7e8518041db4169d657407e3217008] kvm: ioapic:
Lazy update IOAPIC EOI



### Output of kernel panic:
--- The top is, unfortunately, impossible to see or reliably catch on camera,
and the panic is not written out ---
--- I have a single, potentially useful, camera frame from a recording,
attached as kernelpanictop.jpg ---
--- But that is rather shifted and unclear ---
--- part that was static on-screen from here ---
[  545.??????]  irqfd_resampler_ack+0x32/0x90 [kvm]
[  545.??????]  kvm_notify_acked_irq+0x61/0xf0 [kvm]
[  545.??????]  kvm_ioapic_update_eoi_one.isra.0+0x3b/0x150 [kvm]
[  545.??????]  ioapic_set_irq+0x1fc/0x220 [kvm]
[  545.??????]  kvm_ioapic_set_irq+0x62/0x90 [kvm]
[  545.??????]  kvm_set_irq+0xc8/0x180 [kvm]
[  545.??????]  ? kvm_hv_set_sint+0x20/0x20 [kvm]
[  545.??????]  ? kvm_set_ioapic_irq+0x20/0x20 [kvm]
[  545.??????]  irqfd_resampler_ack+0x32/0x90 [kvm]
[  545.??????]  kvm_notify_acked_irq+0x61/0xf0 [kvm]
[  545.??????]  kvm_ioapic_update_eoi_one.isra.0+0x3b/0x150 [kvm]
[  545.??????]  ioapic_set_irq+0x1fc/0x220 [kvm]
[  545.??????]  kvm_ioapic_set_irq+0x62/0x90 [kvm]
[  545.??????]  kvm_set_irq+0xc8/0x180 [kvm]
[  545.??????]  ? kvm_hv_set_sint+0x20/0x20 [kvm]
[  545.??????]  ? kvm_set_ioapic_irq+0x20/0x20 [kvm]
[  545.??????]  irqfd_resampler_ack+0x32/0x90 [kvm]
[  545.??????]  kvm_notify_acked_irq+0x61/0xf0 [kvm]
[  545.??????]  kvm_ioapic_update_eoi_one.isra.0+0x3b/0x150 [kvm]
[  545.??????]  ioapic_set_irq+0x1fc/0x220 [kvm]
[  545.??????]  kvm_ioapic_set_irq+0x62/0x90 [kvm]
[  545.??????]  kvm_set_irq+0xc8/0x180 [kvm]
[  545.??????]  ? kvm_hv_set_sint+0x20/0x20 [kvm]
[  545.??????]  ? kvm_set_ioapic_irq+0x20/0x20 [kvm]
[  545.??????]  irqfd_resampler_ack+0x32/0x90 [kvm]
[  545.??????]  kvm_notify_acked_irq+0x61/0xf0 [kvm]
[  545.??????]  kvm_ioapic_update_eoi_one.isra.0+0x3b/0x150 [kvm]
[  545.??????]  ioapic_set_irq+0x1fc/0x220 [kvm]
[  545.??????]  kvm_ioapic_set_irq+0x62/0x90 [kvm]
[  545.??????]  kvm_set_irq+0xc8/0x180 [kvm]
[  545.??????]  ? kvm_hv_set_sint+0x20/0x20 [kvm]
[  545.??????]  ? kvm_set_ioapic_irq+0x20/0x20 [kvm]
[  545.??????]  irqfd_resampler_ack+0x32/0x90 [kvm]
[  545.??????]  kvm_notify_acked_irq+0x61/0xf0 [kvm]
[  545.??????]  kvm_ioapic_update_eoi_one.isra.0+0x3b/0x150 [kvm]
[  545.??????]  ioapic_set_irq+0x1fc/0x220 [kvm]
[  545.??????]  kvm_ioapic_set_irq+0x62/0x90 [kvm]
[  545.??????]  kvm_set_irq+0xc8/0x180 [kvm]
[  545.??????]  ? kvm_hv_set_sint+0x20/0x20 [kvm]
[  545.??????]  ? kvm_set_ioapic_irq+0x20/0x20 [kvm]
[  545.??????]  irqfd_resampler_ack+0x32/0x90 [kvm]
[  545.??????]  kvm_notify_acked_irq+0x61/0xf0 [kvm]
[  545.??????]  kvm_ioapic_update_eoi_one.isra.0+0x3b/0x150 [kvm]
[  545.??????]  ioapic_set_irq+0x1fc/0x220 [kvm]
[  545.??????]  kvm_ioapic_set_irq+0x62/0x90 [kvm]
[  545.??????]  kvm_set_irq+0xc8/0x180 [kvm]
[  545.??????]  ? kvm_hv_set_sint+0x20/0x20 [kvm]
[  545.??????]  ? kvm_set_ioapic_irq+0x20/0x20 [kvm]
[  545.??????]  kvm_vm_ioctl_irq_line+0x23/0x30 [kvm]
[  545.??????]  kvm_vm_ioctl+0x28a/0xc10 [kvm]
[  545.??????]  ksys_ioctl+0x87/0xc0
[  545.??????]  __x64_sys_ioctl+0x16/0x20
[  545.??????]  do_syscall_64+0x4e/0x150
[  545.??????]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  545.??????] RIP: 0033:0x7f990c1642eb
[  545.??????] Code: 0f 1e fa 48 8b 05 a5 8b 0c 00 64 c7 00 26 00 00 00 48 c7
c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 75 8b 0c 00 f7 d8 64 89 01 48
[  545.??????] RSP: 002b:00007f9908979c08 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  545.??????] RAX: ffffffffffffffda RBX: 00000000c008ae67 RCX:
00007f990c1642eb
[  545.??????] RDX: 00007f9908979ca0 RSI: ffffffffc008ae67 RDI:
0000000000000011
[  545.??????] RBP: 00007f990a9fc800 R08: 0000000000000000 R09:
000000000000002c
[  545.??????] R10: 0000000000000001 R11: 0000000000000246 R12:
00007f9908979ca0
[  545.??????] R13: 00000000000000c8 R14: 0000000000000004 R15:
00007f9501850d40
[  545.??????] Modules linked in: macvtap tap macvlan wireguard(E)
ip6_udp_tunnel udp_tunnel ipt_REJECT nf_reject_ipv4 nct6775 xt_tcpudp msr
hwmon_vid iptable_filter nls_iso8859_1 nls_cp437 intel_rapl_msr iTCO_wdt
iTCO_vendor_support intel_rapl_common intel_wmi_thunderbolt mxm_wmi
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm intel_cstate
intel_uncore raid10 intel_rapl_perf pcskr snd_ctxfi alx i2c_i801 lpc_ich mdio
amdgpu uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2
videobuf2_common snd_usb_audio videodev snd_usbmidi_lib snd_hda_codec_realtek
snd_rawmidi snd_seq_device snd_hda_codec_generic mc md_mod ledtrig_audio
snd_hda_codec_hdmi joydev mousedev input_leds snd_hda_intel snd_intel_dspcfg
snd_hda_codec snd_hda_core snd_hwdep snd_pcm gpu_sched snd_timer snd mei_me
e1000e soundcore meiwmi evdev mac_hid ip_tables x_tables dm_crypt hid_lg_g15
hid_logitech ff_memless hid_steam hid_generic usbhid hid dm_mod
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
[  545.??????] aesni_intel crypto_simd cryptd glue_helper xhci_pci ehci_pci
ehci_hcd xhci_hcd radeon i2c_algo_bit drm_kms_helper syscopyarea sysfillrect
sysimgblt fb_sys-fops cec ttm drm agpgart vfio_pci irqbypass vfio_virqfd
vfio_iommu_type1 vfio ext4 crc32c_generic crc32c_intel crc16 mbcache jbd2 vfat
fat
[  545.??????] ---[ end trace 1e45c808e45db214 ]---
[  545.??????] RIP:0010:__srcu_read_lock+0x21/0x30
[  545.??????] Code: cc cc cc cc cc cc cc cc cc 0f 1f 44 00 00 8b 87 40 08 00
00 48 8b 97 68 08 00 00 41 89 c0 83 e0 01 64 48 ff 04 c2 <f0> 83 44 24 fc 00 44
89 c0 c3 0f 1f 44 00 00 0f 1f 44 00 00 f0 83
[  545.??????] RSP: 0018:ffffb061c119c000 EFLAGS: 00010206
[  545.??????] RAX: 0000000000000001 RBX: 0000000000000001 RCX:
0000000000000000
[  545.??????] RDX: 000038a6bf8281c0 RSI: 0000000000000002 RDI:
ffffb061c11970b8
[  545.??????] RBP: 0000000000000002 R08: 0000000000000001 R09:
ffff97baf7f72400
[  545.??????] R10: 0000000000000000 R11: 0000000000000000 R12:
ffffb061c118d000
[  545.??????] R13: ffff97baf347b1b0 R14: ffffb061c11970b8 R15:
000000000000000b
[  545.??????] FS:  00007f990897c700(0000) GS:ffff97baffa80000(0000)
knlGS:0000000000000000
[  545.??????] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  545.??????] CR2: ffffb061c119bff8 CR3: 0000000879578002 CR4:
00000000001626e0
[  545.??????] note: CPU 0/KVM[2479] exited with preempt_count 1
[  545.??????] Kernel panic - not syncing: corrupted stack end detected inside
scheduler
[  545.??????] Kernel Offset: 0x24c00000 from 0xffffffff81000000 (reloacation
range: 0xffffffff80000000-0xffffffffbfffffff)
[  545.??????] ---[ end Kernel panic - not syncing: corrupted stack end
detected inside scheduler ]---



### Reproduction
I cannot provide a reproduction environment that is not several GiBs of a
windows 10 installation and very specific hardware underlying it. I'd be happy
to provide additional information and test patches, however.

#### libvirt domain xml:
<domain type='kvm'>
  <name>lockuptest</name>
  <uuid>309ac794-298a-4e9b-a7a6-660dd50b96ba</uuid>
  <memory unit='KiB'>16777216</memory>
  <currentMemory unit='KiB'>16777216</currentMemory>
  <vcpu placement='static'>6</vcpu>
  <os>
    <type arch='x86_64' machine='pc-i440fx-2.4'>hvm</type>
    <loader readonly='yes'
type='pflash'>/usr/share/ovmf/x64/OVMF_CODE.fd</loader>
    <nvram>/var/lib/libvirt/qemu/nvram/wenger_VARS.fd</nvram>
    <boot dev='hd'/>
  </os>
  <features>
    <acpi/>
    <apic/>
    <pae/>
    <vmport state='off'/>
  </features>
  <cpu mode='custom' match='exact' check='none'>
    <model fallback='allow'>Haswell-noTSX</model>
    <topology sockets='1' cores='3' threads='2'/>
  </cpu>
  <clock offset='localtime'>
    <timer name='rtc' tickpolicy='catchup'/>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>restart</on_crash>
  <pm>
    <suspend-to-mem enabled='no'/>
    <suspend-to-disk enabled='no'/>
  </pm>
  <devices>
    <emulator>/usr/sbin/qemu-system-x86_64</emulator>
    <disk type='block' device='disk'>
      <driver name='qemu' type='raw' cache='none' io='native'/>
      <source dev='/dev/disk/by-id/ata-WDC_WD6400AAKS-00E4A0_WD-WCATR0509805'/>
      <target dev='sdc' bus='sata'/>
      <address type='drive' controller='0' bus='0' target='0' unit='2'/>
    </disk>
    <controller type='pci' index='0' model='pci-root'/>
    <controller type='sata' index='0'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x0a'
function='0x0'/>
    </controller>
    <controller type='usb' index='0' model='qemu-xhci' ports='15'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x06'
function='0x0'/>
    </controller>
    <interface type='direct'>
      <mac address='52:54:00:5b:6b:49'/>
      <source dev='enp6s0' mode='bridge'/>
      <model type='e1000'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x0c'
function='0x0'/>
    </interface>
    <input type='mouse' bus='ps2'/>
    <input type='keyboard' bus='ps2'/>
    <graphics type='spice' autoport='yes'>
      <listen type='address'/>
      <image compression='off'/>
      <gl enable='no' rendernode='/dev/dri/by-path/pci-0000:03:00.0-render'/>
    </graphics>
    <video>
      <model type='qxl' ram='65536' vram='65536' vgamem='16384' heads='1'
primary='yes'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02'
function='0x0'/>
    </video>
    <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x00' slot='0x1b' function='0x0'/>
      </source>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03'
function='0x0'/>
    </hostdev>
    <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x02' slot='0x00' function='0x0'/>
      </source>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x04'
function='0x0'/>
    </hostdev>
    <memballoon model='virtio'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x08'
function='0x0'/>
    </memballoon>
  </devices>
</domain>

#### Qemu command:
nobody     14999  117 51.2 17139692 16841976 ?   SLl  22:33   0:08
/usr/sbin/qemu-system-x86_64 -name guest=lockuptest,debug-threads=on -S -object
secret,id=masterKey0,format=raw,file=/var/lib/libvirt/qemu/domain-1-lockuptest/master-key.aes
-blockdev
{"driver":"file","filename":"/usr/share/ovmf/x64/OVMF_CODE.fd","node-name":"libvirt-pflash0-storage","auto-read-only":true,"discard":"unmap"}
-blockdev
{"node-name":"libvirt-pflash0-format","read-only":true,"driver":"raw","file":"libvirt-pflash0-storage"}
-blockdev
{"driver":"file","filename":"/var/lib/libvirt/qemu/nvram/wenger_VARS.fd","node-name":"libvirt-pflash1-storage","auto-read-only":true,"discard":"unmap"}
-blockdev
{"node-name":"libvirt-pflash1-format","read-only":false,"driver":"raw","file":"libvirt-pflash1-storage"}
-machine
pc-i440fx-2.4,accel=kvm,usb=off,vmport=off,dump-guest-core=off,pflash0=libvirt-pflash0-format,pflash1=libvirt-pflash1-format
-cpu Haswell-noTSX -m 16384 -overcommit mem-lock=off -smp
4,sockets=1,cores=2,threads=2 -uuid 309ac794-298a-4e9b-a7a6-660dd50b96ba
-no-user-config -nodefaults -chardev socket,id=charmonitor,fd=32,server,nowait
-mon chardev=charmonitor,id=monitor,mode=control -rtc
base=localtime,driftfix=slew -global kvm-pit.lost_tick_policy=delay -no-hpet
-no-shutdown -global PIIX4_PM.disable_s3=1 -global PIIX4_PM.disable_s4=1 -boot
strict=on -device qemu-xhci,p2=15,p3=15,id=usb,bus=pci.0,addr=0x6 -device
ahci,id=sata0,bus=pci.0,addr=0xa -blockdev
{"driver":"host_device","filename":"/dev/disk/by-id/ata-WDC_WD6400AAKS-00E4A0_WD-WCATR0509805","aio":"native","node-name":"libvirt-1-storage","cache":{"direct":true,"no-flush":false},"auto-read-only":true,"discard":"unmap"}
-blockdev
{"node-name":"libvirt-1-format","read-only":false,"cache":{"direct":true,"no-flush":false},"driver":"raw","file":"libvirt-1-storage"}
-device
ide-hd,bus=sata0.2,drive=libvirt-1-format,id=sata0-0-2,bootindex=1,write-cache=on
-netdev tap,fd=36,id=hostnet0 -device
e1000,netdev=hostnet0,id=net0,mac=52:54:00:5b:6b:49,bus=pci.0,addr=0xc -spice
port=5900,addr=127.0.0.1,disable-ticketing,image-compression=off,seamless-migration=on
-device
qxl-vga,id=video0,ram_size=67108864,vram_size=67108864,vram64_size_mb=0,vgamem_mb=16,max_outputs=1,bus=pci.0,addr=0x2
-device vfio-pci,host=0000:00:1b.0,id=hostdev0,bus=pci.0,addr=0x3 -device
vfio-pci,host=0000:02:00.0,id=hostdev1,bus=pci.0,addr=0x4 -device
virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x8 -sandbox
on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny -msg
timestamp=on

#### Kernel cmdline:
initrd=\intel-ucode.img initrd=\initramfs-linux.img fbcon=rotate:1
video=HDMI-A-1:1600x1200@60
rd.luks.name=6170c30a-2240-4e41-9b9e-326bc3fdf014=luks-root
rd.luks.name=b38ec31a-8d24-454d-a3a7-c6d7b9cadd72=luks-hibernate-swap
rd.luks.options=allow-discards root=UUID=78f6ef43-8cc0-4a16-a5e3-0ba77a956062
rw resume=UUID=687713a1-07ca-4832-bd88-f27b3b1e1631
init=/usr/lib/systemd/systemd intel_iommu=on systemd.unified_cgroup_hierarchy=1
irqaffinity=0 nohz_full=1-11 rcu_nocbs=1-11



### Environment:
#### Software:
ver_linux:
Linux victorinox 5.5.0-07987-gf458d039db7e #16 SMP PREEMPT Tue Apr 28 19:43:19
CEST 2020 x86_64 GNU/Linux

GNU C                   9.3.0
GNU Make                4.3
Binutils                2.34
Util-linux              2.35.1
Mount                   2.35.1
Module-init-tools       27
E2fsprogs               1.45.6
Jfsutils                1.1.15
Reiserfsprogs           3.6.27
Xfsprogs                5.6.0
Bison                   3.5.4
Flex                    2.6.4
Linux C Library         2.31
Dynamic linker (ldd)    2.31
Linux C++ Library       6.0.28
Procps                  3.3.16
Kbd                     2.2.0
Console-tools           2.2.0
Sh-utils                8.32
Udev                    245
Wireless-tools          30
Modules Loaded          aesni_intel agpgart alx amdgpu cec coretemp crc16
crc32c_generic crc32c_intel crc32_pclmul crct10dif_pclmul cryptd crypto_simd
dm_crypt dm_mod drm drm_kms_helper e1000e ehci_hcd ehci_pci evdev ext4 fat
fb_sys_fops ff_memless ghash_clmulni_intel glue_helper gpu_sched hid
hid_generic hid_lg_g15 hid_logitech hid_steam hwmon_vid i2c_algo_bit i2c_i801
input_leds intel_cstate intel_powerclamp intel_rapl_common intel_rapl_msr
intel_rapl_perf intel_uncore intel_wmi_thunderbolt ip6_udp_tunnel
iptable_filter ip_tables ipt_REJECT irqbypass iTCO_vendor_support iTCO_wdt jbd2
joydev kvm kvm_intel ledtrig_audio lpc_ich mac_hid macvlan mbcache mc mdio
md_mod mei mei_me mousedev msr mxm_wmi nct6775 nf_reject_ipv4 nls_cp437
nls_iso8859_1 pcspkr radeon raid10 snd snd_ctxfi snd_hda_codec
snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_core
snd_hda_intel snd_hwdep snd_intel_dspcfg snd_pcm snd_rawmidi snd_seq_device
snd_timer snd_usb_audio snd_usbmidi_lib soundcore syscopyarea sysfillrect
sysimgblt ttm udp_tunnel usbhid vfat vfio vfio_iommu_type1 vfio_pci vfio_virqfd
wireguard wmi x86_pkg_temp_thermal xhci_hcd xhci_pci x_tables xt_tcpudp

qemu: 4.2.0
libvirt: 5.10.0


#### Processor information:
Attached kernelpanic.cpuinfo. Inlined processor 0:
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 63
model name      : Intel(R) Core(TM) i7-5820K CPU @ 3.30GHz
stepping        : 2
microcode       : 0x43
cpu MHz         : 3637.456
cache size      : 15360 KB
physical id     : 0
siblings        : 12
core id         : 0
cpu cores       : 6
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 15
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm cpuid_fault epb
invpcid_single pti intel_ppin ssbd ibrs ibpb stibp tpr_shadow vnmi flexpriority
ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid cqm
xsaveopt cqm_llc cqm_occup_llc dtherm ida arat pln pts md_clear flush_l1d
vmx flags       : vnmi preemption_timer posted_intr invvpid ept_x_only ept_ad
ept_1gb flexpriority apicv tsc_offset vtpr mtf vapic ept vpid
unrestricted_guest vapic_reg vid ple
bugs            : cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf mds
swapgs itlb_multihit
bogomips        : 6600.84
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 48 bits virtual
power management:


#### Mainboard: ASRock X99 Extreme6/3.1 with UEFI version 3.50.


#### Module information: attached kernelpanic.modules

#### ioports & iomem: attached files ioports & iomem

#### lspci: Attached file lspci. Inlined the devices passed through.
00:1b.0 Audio device: Intel Corporation C610/X99 series chipset HD Audio
Controller (rev 05)
        Subsystem: ASRock Incorporation C610/X99 series chipset HD Audio
Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 59
        NUMA node: 0
        Region 0: Memory at f8830000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee00018  Data: 0000
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI
00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag- RBE- FLReset+
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- FLReset-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+
TransPend-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
                VC1:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable- ID=0 ArbSelect=Fixed TC/VC=00
                        Status: NegoPending- InProgress-
        Kernel driver in use: snd_hda_intel
        Kernel modules: snd_hda_intel

02:00.0 USB controller: ASMedia Technology Inc. ASM1142 USB 3.1 Host Controller
(prog-if 30 [XHCI])
        Subsystem: ASMedia Technology Inc. ASM1142 USB 3.1 Host Controller
        Physical Slot: 2-1
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 38
        NUMA node: 0
        Region 0: Memory at f8700000 (64-bit, non-prefetchable) [size=32K]
        Capabilities: [50] MSI: Enable- Count=1/8 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] MSI-X: Enable+ Count=8 Masked-
                Vector table: BAR=0 offset=00002000
                PBA: BAR=0 offset=00002080
        Capabilities: [78] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <64ns,
L1 <2us
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
SlotPowerLimit 0.000W
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 256 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ NonFatalErr- FatalErr- UnsupReq- AuxPwr+
TransPend-
                LnkCap: Port #1, Speed 5GT/s, Width x2, ASPM L0s L1, Exit
Latency L0s <2us, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 5GT/s (ok), Width x2 (ok)
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis-,
NROPrPrP-, LTR+
                         10BitTagComp-, 10BitTagReq-, OBFF Not Supported,
ExtFmt-, EETLPPrefix-
                         EmergencyPowerReduction Not Supported,
EmergencyPowerReductionInit-
                         FRS-, TPHComp-, ExtTPHComp-
                         AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-,
OBFF Disabled
                         AtomicOpsCtl: ReqEn-
                LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Capabilities: [200 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
AdvNonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
AdvNonFatalErr+
                AERCap: First Error Pointer: 00, ECRCGenCap- ECRCGenEn-
ECRCChkCap- ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
        Capabilities: [280 v1] Secondary PCI Express
                LnkCtl3: LnkEquIntrruptEn-, PerformEqu-
                LaneErrStat: 0
        Capabilities: [300 v1] Latency Tolerance Reporting
                Max snoop latency: 0ns
                Max no snoop latency: 0ns
        Kernel driver in use: xhci_hcd
        Kernel modules: xhci_pci


#### Additional info:
KVM module parameters:
/sys/module/kvm/parameters/enable_vmware_backdoor: N
/sys/module/kvm/parameters/force_emulation_prefix: N
/sys/module/kvm/parameters/halt_poll_ns: 200000
/sys/module/kvm/parameters/halt_poll_ns_grow: 2
/sys/module/kvm/parameters/halt_poll_ns_grow_start: 10000
/sys/module/kvm/parameters/halt_poll_ns_shrink: 0
/sys/module/kvm/parameters/ignore_msrs: Y
/sys/module/kvm/parameters/kvmclock_periodic_sync: Y
/sys/module/kvm/parameters/lapic_timer_advance_ns: -1
/sys/module/kvm/parameters/min_timer_period_us: 200
/sys/module/kvm/parameters/mmu_audit: N
/sys/module/kvm/parameters/nx_huge_pages: Y
/sys/module/kvm/parameters/nx_huge_pages_recovery_ratio: 60
/sys/module/kvm/parameters/pi_inject_timer: 0
/sys/module/kvm/parameters/report_ignored_msrs: N
/sys/module/kvm/parameters/tsc_tolerance_ppm: 250
/sys/module/kvm/parameters/vector_hashing: Y

-- 
You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.
