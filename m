Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4CE61EDD63
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 08:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgFDGnu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 4 Jun 2020 02:43:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbgFDGnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 02:43:50 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 208047] New: KVM - random guest hangs if dual channel memory
 enabled. (probably A.G.E.S.A. bug)
Date:   Thu, 04 Jun 2020 06:43:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: itemcode@mail.ru
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-208047-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208047

            Bug ID: 208047
           Summary: KVM - random guest hangs if dual channel memory
                    enabled. (probably A.G.E.S.A. bug)
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.5.x (5.6.x)
          Hardware: Other
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: itemcode@mail.ru
        Regression: No

Hi. After my deep testing in various combinations of hardware, i can confirm
that there is a bug, when using the dual-channel memory mode, which leads to
guest (win10, win 8.1 in my case) freezes on systems with B350, B450 chipset.
Tested on Gigabyte A320M-S2H, Gigabyte B450i AORUS Pro Wifi, Asus B450 Strix I
Gaming with Ryzen 5 2400 (3400G) and Kingston, Corsair, Noname memory in
various combinations. This problem solved by installing different memory
modules of different sizes (8G+4G) and (or) modules with different timings
(this disables dual channel mode)

And now... Steps to reproduce: 

1. Check your memory worked in dual-channel mode.
2. Install Ubuntu(20.04), ArchLinux (kernel 5.6.15 in my case, with ACS patch),
Manjaro KDE (19.x), it does not matter...
3. Install libvirt, qemu, ovmf and other virtualization stuff.
4. Configure configs:

/etc/default/grub:
GRUB_CMDLINE_LINUX_DEFAULT="audit=0 loglevel=3 quiet amd_iommu=on amd_iommu=pt
pcie_acs_override=downstream,multifunction isolcpus=2,6,3,7
default_hugepagesz=1G hugepagesz=1G hugepages=8"

/etc/modprobe.d/avic.conf:
options kvm-amd nested=0 avic=1 npt=1

/etc/modprobe.d/kvm.conf:
options kvm halt_poll_ns=0
options kvm report_ignored_msrs=0
options kvm ignore_msrs=1
options vfio_iommu_type1 allow_unsafe_interrupts=1

/etc/modprobe.d/kvm.conf:
softdep amdgpu pre: vfio-pci
softdep snd_hda_intel pre: vfio-pci
options vfio-pci ids=1002:67ff,1002:aae0,1022:15e0,1022:15e1
options vfio-pci disable_vga=1

/etc/libvirt/qemu/win10.xml
<domain type='kvm'>
  <name>win10</name>
  <uuid>b33a0bec-cd23-4cfb-b4fe</uuid>
  <memory unit='KiB'>8388608</memory>
  <currentMemory unit='KiB'>8388608</currentMemory>
  <memoryBacking>
    <hugepages/>
    <nosharepages/>
    <locked/>
    <allocation mode='immediate'/>
    <discard/>
  </memoryBacking>
  <vcpu placement='static' cpuset='2,6,3,7'>4</vcpu>
  <cputune>
    <vcpupin vcpu='0' cpuset='2'/>
    <vcpupin vcpu='1' cpuset='6'/>
    <vcpupin vcpu='2' cpuset='3'/>
    <vcpupin vcpu='3' cpuset='7'/>
  </cputune>
  <os>
    <type arch='x86_64' machine='pc-q35-5.0'>hvm</type>
    <loader readonly='yes'
type='pflash'>/usr/share/ovmf/x64/OVMF_CODE-pure-efi.fd</loader>
    <nvram>/usr/share/ovmf/x64/OVMF_VARS-pure-efi-1280x1024.fd</nvram>
    <bootmenu enable='no'/>
    <smbios mode='host'/>
  </os>
  <features>
    <acpi/>
    <apic eoi="on"/>
    <hap state="on"/>
    <hyperv>
      <relaxed state="on"/>
      <vapic state="on"/>
      <vpindex state="on"/>
      <vendor_id state="on" value="err43fix"/>
    </hyperv>
    <kvm>
      <hidden state="on"/>
      <hint-dedicated state="on"/>
    </kvm>
    <ioapic driver="kvm"/>
  </features>
  <cpu mode="host-passthrough" check="none">
    <topology sockets="1" cores="2" threads="2"/>
    <cache mode="passthrough"/>
    <feature policy="require" name="invtsc"/>
    <feature policy="require" name="topoext"/>
    <feature policy="disable" name="monitor"/>
  </cpu>
  <clock offset="utc">
    <timer name="rtc" present="no" tickpolicy="catchup"/>
    <timer name="pit" present="no" tickpolicy="discard"/>
    <timer name="hpet" present="no"/>
    <timer name="tsc" present="yes" mode="native"/>
    <timer name="hypervclock" present="yes"/>
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
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <target dev='sdb' bus='sata'/>
      <readonly/>
      <address type='drive' controller='0' bus='0' target='0' unit='1'/>
    </disk>
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <target dev='sdd' bus='sata'/>
      <readonly/>
      <address type='drive' controller='0' bus='0' target='0' unit='3'/>
    </disk>
    <disk type='block' device='disk'>
      <driver name='qemu' type='raw' cache='none' io='native'/>
      <source
dev='/dev/disk/by-id/ata-INTEL_SSDSC2KW512G8_PHLA91930167512DGN'/>
      <target dev='sda' bus='scsi'/>
      <boot order='1'/>
      <address type='drive' controller='0' bus='0' target='0' unit='0'/>
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
    <controller type='pci' index='9' model='pcie-to-pci-bridge'>
      <model name='pcie-pci-bridge'/>
      <address type='pci' domain='0x0000' bus='0x07' slot='0x00'
function='0x0'/>
    </controller>
    <controller type='pci' index='10' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='10' port='0x18'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'
multifunction='on'/>
    </controller>
    <controller type='pci' index='11' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='11' port='0x19'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03'
function='0x1'/>
    </controller>
    <controller type='pci' index='12' model='pcie-root-port'>
      <model name='pcie-root-port'/>
      <target chassis='12' port='0x1a'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03'
function='0x2'/>
    </controller>
    <controller type='virtio-serial' index='0'>
      <address type='pci' domain='0x0000' bus='0x03' slot='0x00'
function='0x0'/>
    </controller>
    <controller type='scsi' index='0' model='virtio-scsi'>
      <address type='pci' domain='0x0000' bus='0x0a' slot='0x00'
function='0x0'/>
    </controller>
    <interface type='bridge'>
      <mac address='52:54:00:7e:27:af'/>
      <source bridge='virbr0'/>
      <model type='virtio'/>
      <address type='pci' domain='0x0000' bus='0x01' slot='0x00'
function='0x0'/>
    </interface>
    <channel type='spicevmc'>
      <target type='virtio' name='com.redhat.spice.0'/>
      <address type='virtio-serial' controller='0' bus='0' port='1'/>
    </channel>
    <channel type='unix'>
      <source mode='bind' path='/tmp/win10.agent'/>
      <target type='virtio' name='org.qemu.guest_agent.0'/>
      <address type='virtio-serial' controller='0' bus='0' port='2'/>
    </channel>
    <input type='mouse' bus='ps2'/>
    <input type='keyboard' bus='ps2'/>
    <graphics type='spice' port='5910' autoport='no' listen='127.0.0.1'>
      <listen type='address' address='127.0.0.1'/>
      <image compression='off'/>
    </graphics>
    <video>
      <model type='qxl' ram='65536' vram='65536' vgamem='16384' heads='1'
primary='yes'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x01'
function='0x0'/>
    </video>
    <hostdev mode='subsystem' type='pci' managed='yes'>
      <driver name='vfio'/>
      <source>
        <address domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
      </source>
      <rom bar='off'/>
      <address type='pci' domain='0x0000' bus='0x05' slot='0x00'
function='0x0'/>
    </hostdev>
    <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x08' slot='0x00' function='0x3'/>
      </source>
      <rom bar='off'/>
      <address type='pci' domain='0x0000' bus='0x06' slot='0x00'
function='0x0'/>
    </hostdev>
    <hostdev mode='subsystem' type='pci' managed='yes'>
      <source>
        <address domain='0x0000' bus='0x08' slot='0x00' function='0x4'/>
      </source>
      <rom bar='off'/>
      <address type='pci' domain='0x0000' bus='0x08' slot='0x00'
function='0x0'/>
    </hostdev>
    <memballoon model='virtio'>
      <address type='pci' domain='0x0000' bus='0x04' slot='0x00'
function='0x0'/>
    </memballoon>
    <shmem name='looking-glass'>
      <model type='ivshmem-plain'/>
      <size unit='M'>32</size>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x10'
function='0x0'/>
    </shmem>
  </devices>
</domain>

5. Install Windows 10 (17763 build due to low latency), windows 8.1..., it does
not matter...
6. Install Steam or other game stuff. it does not matter... Play. Your system
will certainly go to the black screen if you use AMD GPU (tested with RADEON
RX560 2GB) or your drivers has been crashed if you use Nvidia GPU (1050Ti 4Gb)
in my case.
7. Turn off your PC, remove one memory module and install other memory module,
with another timings, another capacity. This magic disables dual channel memory
support.
8. Turn on your PC, start yor Virtualized Game Machine and all worked without
problem days and nights without reboots...

I hope someone doesn't get past this problem. Thanks in advance.

P.S.: Dual channel worked fine without problem on bare metal hardware.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
