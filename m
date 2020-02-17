Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA62161988
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 19:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbgBQSRP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 17 Feb 2020 13:17:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728857AbgBQSRO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 13:17:14 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] New: KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Mon, 17 Feb 2020 18:17:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
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
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-206579-28872@https.bugzilla.kernel.org/>
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

            Bug ID: 206579
           Summary: KVM with passthrough generates "BUG: kernel NULL
                    pointer dereference" and crashes
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.6 rc2
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: rmuncrief@humanavance.com
        Regression: No

###Summary
I'm running the latest Arch with all updates and have a Windows 10 VM with GPU,
USB, and SATA passthrough that runs fantastically with all kernels previous to
5.6 rc1, back to 4.19.x. However the VM dies with a NULL pointer dereference
bug with kernels 5.6 rc1 and rc2, and the physical machine has to be rebooted
because KVM will no longer run.

###System Specifications
Motherboard: ASUS TUF Gaming X570-Plus motherboard with the latest BIOS v1405
CPU: R7 3700x
DRAM: 16GB (8GB x 2) of Corsair CMK16GX4M2Z3200C16 DDR4
GPU1: Sapphire Nitro R9 390 in the primary PCIE x16 slot
GPU2: GT 710 in the secondary PCIE x4 slot

###VM Configuration
The VM runs Windows 10 and passes through the R9 390 GPU, a USB card, and a
SATA port. I have run it successfully on kernels from 4.19.x to 5.5.4. However
before this bug report I did a simple test with GPU passthrough only, but the
dmesg output was the same. Here is the full VM XML:

--------------- Start VM XML ---------------
<!--
WARNING: THIS IS AN AUTO-GENERATED FILE. CHANGES TO IT ARE LIKELY TO BE
OVERWRITTEN AND LOST. Changes to this xml configuration should be made using:
  virsh edit Win10-1_UEFI
or other application using the libvirt API.
-->

<domain type='kvm'>
  <name>Win10-1_UEFI</name>
  <uuid>b83c2a85-b248-4093-bded-dae2bc2ccf05</uuid>
  <metadata>
    <libosinfo:libosinfo
xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
      <libosinfo:os id="http://microsoft.com/win/10"/>
    </libosinfo:libosinfo>
  </metadata>
  <memory unit='KiB'>8388608</memory>
  <currentMemory unit='KiB'>8388608</currentMemory>
  <vcpu placement='static' current='8'>16</vcpu>
  <os>
    <type arch='x86_64' machine='pc-q35-4.1'>hvm</type>
    <loader readonly='yes'
type='pflash'>/usr/share/ovmf/x64/OVMF_CODE.fd</loader>
    <nvram>/var/lib/libvirt/qemu/nvram/Win10-1_UEFI_VARS.fd</nvram>
  </os>
  <features>
    <acpi/>
    <apic/>
    <hyperv>
      <relaxed state='on'/>
      <vapic state='on'/>
      <spinlocks state='on' retries='8191'/>
    </hyperv>
    <vmport state='off'/>
  </features>
  <cpu mode='host-passthrough' check='partial'>
    <topology sockets='1' cores='8' threads='2'/>
  </cpu>
  <clock offset='localtime'>
    <timer name='rtc' tickpolicy='catchup'/>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
    <timer name='hypervclock' present='yes'/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <pm>
    <suspend-to-mem enabled='no'/>
    <suspend-to-disk enabled='no'/>
  </pm>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='raw'/>
      <source file='/mnt/data1/VM/KVM/Win10-1_UEFI.img'/>
      <target dev='vda' bus='virtio'/>
      <boot order='1'/>
      <address type='pci' domain='0x0000' bus='0x0a' slot='0x00'
function='0x0'/>
    </disk>
    <disk type='file' device='disk'>
      <driver name='qemu' type='raw'/>
      <source file='/mnt/data4/VM/KVM/Win10-1_Data.img'/>
      <target dev='vdb' bus='virtio'/>
      <address type='pci' domain='0x0000' bus='0x0c' slot='0x00'
function='0x0'/>
    </disk>
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='/usr/share/virtio/virtio-win.iso'/>
      <target dev='sdc' bus='sata'/>
      <readonly/>
      <boot order='2'/>
      <address type='drive' controller='0' bus='0' target='0' unit='2'/>
    </disk>
    <controller type='usb' index='0' model='qemu-xhci' ports='15'>
      <address type='pci' domain='0x0000' bus='0x02' slot='0x00'
function='0x0'/>
    </controller>
    <controller type='sata' index='0'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x1f'
function='0x2'/>
    </controller>
    <controller type='pci' index='0' model='pcie-root'/>
    <controller type='pci' index='1' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='1' port='0x10'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0'
multifunction='on'/>
    </controller>
    <controller type='pci' index='2' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='2' port='0x11'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02'
function='0x1'/>
    </controller>
    <controller type='pci' index='3' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='3' port='0x12'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02'
function='0x2'/>
    </controller>
    <controller type='pci' index='4' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='4' port='0x13'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02'
function='0x3'/>
    </controller>
    <controller type='pci' index='5' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='5' port='0x14'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02'
function='0x4'/>
    </controller>
    <controller type='pci' index='6' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='6' port='0x15'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02'
function='0x5'/>
    </controller>
    <controller type='pci' index='7' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='7' port='0x16'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02'
function='0x6'/>
    </controller>
    <controller type='pci' index='8' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='8' port='0x17'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02'
function='0x7'/>
    </controller>
    <controller type='pci' index='9' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='9' port='0x18'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'
multifunction='on'/>
    </controller>
    <controller type='pci' index='10' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='10' port='0x19'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03'
function='0x1'/>
    </controller>
    <controller type='pci' index='11' model='pcie-to-pci-bridge'>
      <model name='pcie-pci-bridge'/>
      <address type='pci' domain='0x0000' bus='0x08' slot='0x00'
function='0x0'/>
    </controller>
    <controller type='pci' index='12' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='12' port='0x1a'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03'
function='0x2'/>
    </controller>
    <controller type='pci' index='13' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='13' port='0x1b'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03'
function='0x3'/>
    </controller>
    <controller type='virtio-serial' index='0'>
      <address type='pci' domain='0x0000' bus='0x03' slot='0x00'
function='0x0'/>
    </controller>
    <interface type='bridge'>
      <mac address='52:54:00:6d:6f:68'/>
      <source bridge='vm_bridge0'/>
      <model type='virtio'/>
      <address type='pci' domain='0x0000' bus='0x01' slot='0x00'
function='0x0'/>
    </interface>
    <serial type='pty'>
      <target type='isa-serial' port='0'>
        <model name='isa-serial'/>
      </target>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>
    <channel type='spicevmc'>
      <target type='virtio' name='com.redhat.spice.0'/>
      <address type='virtio-serial' controller='0' bus='0' port='1'/>
    </channel>
    <input type='mouse' bus='ps2'/>
    <input type='keyboard' bus='ps2'/>
    <input type='tablet' bus='virtio'>
      <address type='pci' domain='0x0000' bus='0x0d' slot='0x00'
function='0x0'/>
    </input>
    <graphics type='spice' autoport='yes'>
      <listen type='address'/>
    </graphics>
    <sound model='ich9'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x1b'
function='0x0'/>
    </sound>
    <video>
      <model type='qxl' ram='65536' vram='65536' vgamem='16384' heads='1'
primary='yes'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x01'
function='0x0'/>
    </video>
    <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x05' slot='0x00' function='0x0'/>
      </source>
      <address type='pci' domain='0x0000' bus='0x04' slot='0x00'
function='0x0'/>
    </hostdev>
    <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x08' slot='0x00' function='0x0'/>
      </source>
      <address type='pci' domain='0x0000' bus='0x06' slot='0x00'
function='0x0'/>
    </hostdev>
    <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x0a' slot='0x00' function='0x0'/>
      </source>
      <address type='pci' domain='0x0000' bus='0x07' slot='0x00'
function='0x0'/>
    </hostdev>
    <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x0a' slot='0x00' function='0x1'/>
      </source>
      <address type='pci' domain='0x0000' bus='0x09' slot='0x00'
function='0x0'/>
    </hostdev>
    <redirdev bus='usb' type='spicevmc'>
      <address type='usb' bus='0' port='2'/>
    </redirdev>
    <redirdev bus='usb' type='spicevmc'>
      <address type='usb' bus='0' port='3'/>
    </redirdev>
    <memballoon model='virtio'>
      <address type='pci' domain='0x0000' bus='0x05' slot='0x00'
function='0x0'/>
    </memballoon>
  </devices>
</domain>

--------------- End VM XML ---------------

###Error Output
-------------- Start dmesg Output -------------

[  104.053227] vm_bridge0: port 2(vnet0) entered blocking state
[  104.053229] vm_bridge0: port 2(vnet0) entered disabled state
[  104.053284] device vnet0 entered promiscuous mode
[  104.053407] vm_bridge0: port 2(vnet0) entered blocking state
[  104.053409] vm_bridge0: port 2(vnet0) entered listening state
[  105.209759] vfio-pci 0000:0a:00.0: enabling device (0002 -> 0003)
[  105.210049] vfio-pci 0000:0a:00.0: vfio_ecap_init: hiding ecap 0x19@0x270
[  105.210056] vfio-pci 0000:0a:00.0: vfio_ecap_init: hiding ecap 0x1b@0x2d0
[  105.229765] vfio-pci 0000:0a:00.1: enabling device (0000 -> 0002)
[  106.549861] BUG: kernel NULL pointer dereference, address: 0000000000000010
[  106.549865] #PF: supervisor read access in kernel mode
[  106.549867] #PF: error_code(0x0000) - not-present page
[  106.549869] PGD 0 P4D 0 
[  106.549872] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  106.549876] CPU: 12 PID: 5762 Comm: CPU 0/KVM Tainted: P           OE    
5.6.0-rc2-1-mainline #1
[  106.549878] Hardware name: System manufacturer System Product Name/TUF
GAMING X570-PLUS, BIOS 1405 11/19/2019
[  106.549885] RIP: 0010:svm_refresh_apicv_exec_ctrl+0xe4/0x110 [kvm_amd]
[  106.549888] Code: 8b 83 f8 39 00 00 48 39 c5 74 31 48 8b 9b f8 39 00 00 48
39 dd 75 13 eb 23 e8 18 70 cc d3 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b
10 45 85 e4 75 e6 e8 6e 6f cc d3 85 c0 74 e6 5b 4c 89 ee
[  106.549890] RSP: 0018:ffffaef000d5bd50 EFLAGS: 00010082
[  106.549892] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffff93353937d000
[  106.549894] RDX: 0000000000000001 RSI: ffff9334aa6afc00 RDI:
0000000000000000
[  106.549896] RBP: ffff9334aa6c7408 R08: 0000000000000000 R09:
ffff9334aa6afc00
[  106.549897] R10: 00000018d0a785db R11: 0000000000000000 R12:
0000000000000000
[  106.549898] R13: 0000000000000202 R14: ffff9334aa6c7418 R15:
ffffaef00149a7a0
[  106.549900] FS:  00007f80d89ff700(0000) GS:ffff93359eb00000(0000)
knlGS:0000000000000000
[  106.549901] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.549903] CR2: 0000000000000010 CR3: 000000032a5b2000 CR4:
0000000000340ee0
[  106.549904] Call Trace:
[  106.549929]  kvm_arch_vcpu_ioctl_run+0x33d/0x1b20 [kvm]
[  106.549949]  kvm_vcpu_ioctl+0x266/0x630 [kvm]
[  106.549954]  ksys_ioctl+0x87/0xc0
[  106.549957]  __x64_sys_ioctl+0x16/0x20
[  106.549961]  do_syscall_64+0x4e/0x150
[  106.549964]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  106.549967] RIP: 0033:0x7f80dbed42eb
[  106.549969] Code: 0f 1e fa 48 8b 05 a5 8b 0c 00 64 c7 00 26 00 00 00 48 c7
c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 75 8b 0c 00 f7 d8 64 89 01 48
[  106.549970] RSP: 002b:00007f80d89fcea8 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  106.549972] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX:
00007f80dbed42eb
[  106.549973] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
000000000000001a
[  106.549974] RBP: 00007f80d97d8880 R08: 000055c551c01110 R09:
0000000000000000
[  106.549975] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[  106.549976] R13: 00007ffeb948a03f R14: 00007f80d89fd140 R15:
00007f80d89ff700
[  106.549980] Modules linked in: vhost_net vhost tap cpufreq_ondemand
ebtable_filter ebtables uvcvideo videobuf2_vmalloc videobuf2_memops
videobuf2_v4l2 videobuf2_common tun videodev snd_usb_audio snd_usbmidi_lib
snd_rawmidi snd_seq_device mc bridge stp llc nvidia_drm(POE)
nvidia_modeset(POE) nct6775 nvidia(POE) hwmon_vid amdgpu gpu_sched
nls_iso8859_1 nls_cp437 vfat radeon fat fuse i2c_algo_bit ttm
snd_hda_codec_realtek snd_hda_codec_generic drm_kms_helper ledtrig_audio
eeepc_wmi snd_hda_codec_hdmi asus_wmi battery sparse_keymap rfkill cec
snd_hda_intel wmi_bmof edac_mce_amd snd_intel_dspcfg drm snd_hda_codec
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_hda_core snd_hwdep
snd_pcm aesni_intel ipmi_devintf r8169 ipmi_msghandler agpgart snd_timer
crypto_simd pcspkr sp5100_tco k10temp syscopyarea cryptd realtek sysfillrect
glue_helper mousedev i2c_piix4 snd joydev input_leds sysimgblt libphy
fb_sys_fops soundcore wmi pinctrl_amd evdev mac_hid acpi_cpufreq nf_log_ipv6
ip6t_REJECT
[  106.550017]  nf_reject_ipv6 xt_hl ip6t_rt nf_log_ipv4 nf_log_common
ipt_REJECT nf_reject_ipv4 xt_LOG xt_multiport xt_limit xt_addrtype xt_tcpudp
xt_conntrack ip6table_filter ip6_tables nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c iptable_filter sg ip_tables x_tables
ext4 crc32c_generic crc16 mbcache jbd2 sd_mod sr_mod cdrom hid_generic usbhid
hid ahci libahci libata crc32c_intel xhci_pci scsi_mod xhci_hcd vfio_pci
vfio_virqfd vfio_iommu_type1 vfio kvm_amd ccp rng_core kvm irqbypass
[  106.550039] CR2: 0000000000000010
[  106.550041] ---[ end trace 393523eed3771272 ]---
[  106.550045] RIP: 0010:svm_refresh_apicv_exec_ctrl+0xe4/0x110 [kvm_amd]
[  106.550047] Code: 8b 83 f8 39 00 00 48 39 c5 74 31 48 8b 9b f8 39 00 00 48
39 dd 75 13 eb 23 e8 18 70 cc d3 85 c0 75 1a 48 8b 1b 48 39 dd 74 12 <48> 8b 7b
10 45 85 e4 75 e6 e8 6e 6f cc d3 85 c0 74 e6 5b 4c 89 ee
[  106.550048] RSP: 0018:ffffaef000d5bd50 EFLAGS: 00010082
[  106.550050] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffff93353937d000
[  106.550051] RDX: 0000000000000001 RSI: ffff9334aa6afc00 RDI:
0000000000000000
[  106.550052] RBP: ffff9334aa6c7408 R08: 0000000000000000 R09:
ffff9334aa6afc00
[  106.550053] R10: 00000018d0a785db R11: 0000000000000000 R12:
0000000000000000
[  106.550054] R13: 0000000000000202 R14: ffff9334aa6c7418 R15:
ffffaef00149a7a0
[  106.550055] FS:  00007f80d89ff700(0000) GS:ffff93359eb00000(0000)
knlGS:0000000000000000
[  106.550057] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.550058] CR2: 0000000000000010 CR3: 000000032a5b2000 CR4:
0000000000340ee0
[  106.550060] note: CPU 0/KVM[5762] exited with preempt_count 1
[  120.675828] vm_bridge0: port 2(vnet0) entered learning state

-------------- End dmesg Output -------------

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
