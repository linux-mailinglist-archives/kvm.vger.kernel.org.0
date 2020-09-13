Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C6D2680C7
	for <lists+kvm@lfdr.de>; Sun, 13 Sep 2020 20:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgIMSjI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 13 Sep 2020 14:39:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbgIMSjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Sep 2020 14:39:06 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209253] New: Loss of connectivity on guest after important host
 <-> guest traffic
Date:   Sun, 13 Sep 2020 18:39:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aubincleme@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-209253-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209253

            Bug ID: 209253
           Summary: Loss of connectivity on guest after important host <->
                    guest traffic
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.8.0-1-amd64
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: aubincleme@gmail.com
        Regression: No

Created attachment 292501
  --> https://bugzilla.kernel.org/attachment.cgi?id=292501&action=edit
Packet capture

I have an hypervisor running one guest VM. This guest VM has one virtual
network card, configured to use a NATed network with the host.

Upon guest startup, the guest can ping both the host and a server on the
internet. However, when starting heavy traffic between the guest and the host,
the host kernel issues the following trace, and the VM looses its network
connectivity unpon its next restart. I'm also adding to this issue a pcap file
showing the traffic on the host virtual nic, which slowly degrades, starting
form frames 21 to 23.

Information about the host :
Linux 5.8.0-1-amd64 #1 SMP Debian 5.8.7-1 (2020-09-05) x86_64 GNU/Linux
QEMU emulator version 5.1.0 (Debian 1:5.1+dfsg-4)

Information about the guest VM :
Linux 4.19.0-10-amd64 #1 SMP Debian 4.19.132-1 (2020-07-24) x86_64 GNU/Linux

Network configuration for the guest :
<interface type="network">
  <mac address="52:54:00:f2:29:56"/>
  <source network="bridge-vm"/>
  <model type="virtio"/>
  <link state="up"/>
  <address type="pci" domain="0x0000" bus="0x01" slot="0x00" function="0x0"/>
</interface>
<network>
  <name>bridge-vm</name>
  <uuid>159f7f26-391c-44f7-8e6e-dc1b213837a6</uuid>
  <forward mode="nat">
    <nat>
      <port start="1024" end="65535"/>
    </nat>
  </forward>
  <bridge name="virbr0" stp="on" delay="0"/>
  <mac address="52:54:00:45:68:56"/>
  <ip address="192.168.122.1" netmask="255.255.255.0">
    <dhcp>
      <range start="192.168.122.2" end="192.168.122.254"/>
    </dhcp>
  </ip>
</network>

Kernel trace on the host :
[ 1492.533631] ------------[ cut here ]------------
[ 1492.533637] WARNING: CPU: 2 PID: 3835 at fs/eventfd.c:74
eventfd_signal+0x88/0xa0
[ 1492.533638] Modules linked in: nfnetlink_queue nfnetlink_log bluetooth
jitterentropy_rng drbg ansi_cprng ecdh_generic ecc cfg80211 macvtap macvlan
vhost_net vhost tap vhost_iotlb nf_conntrack_netlink xfrm_user xfrm_algo
xt_addrtype br_netfilter xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT
nf_reject_ipv4 xt_tcpudp nft_compat nft_counter nft_chain_nat nf_nat
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c nf_tables nfnetlink bridge
stp llc tun overlay binfmt_misc intel_rapl_msr intel_rapl_common
x86_pkg_temp_thermal intel_powerclamp coretemp joydev kvm_intel
snd_hda_codec_hdmi kvm snd_hda_codec_realtek snd_hda_codec_generic
ledtrig_audio snd_hda_intel snd_intel_dspcfg rapl snd_hda_codec eeepc_wmi
intel_cstate snd_hda_core intel_uncore snd_hwdep asus_wmi snd_pcm pcspkr
battery snd_timer iTCO_wdt sparse_keymap intel_pmc_bxt rfkill xpad snd
serio_raw iTCO_vendor_support ff_memless mei_me intel_wmi_thunderbolt wmi_bmof
soundcore sg watchdog mei acpi_pad evdev parport_pc ppdev lp
[ 1492.533657]  parport nfsd vfio_pci vfio_virqfd vfio_iommu_type1 vfio
auth_rpcgss irqbypass nfs_acl lockd grace sunrpc ip_tables x_tables autofs4
ext4 crc16 mbcache jbd2 crc32c_generic dm_crypt dm_mod sd_mod t10_pi crc_t10dif
crct10dif_generic hid_generic usbhid hid i915 crct10dif_pclmul crct10dif_common
crc32_pclmul crc32c_intel ghash_clmulni_intel i2c_algo_bit drm_kms_helper ahci
libahci e1000e aesni_intel mxm_wmi psmouse libaes crypto_simd cryptd
glue_helper libata cec xhci_pci ptp xhci_hcd pps_core drm i2c_i801 i2c_smbus
usbcore scsi_mod usb_common wmi video button
[ 1492.533674] CPU: 2 PID: 3835 Comm: vhost-3826 Not tainted 5.8.0-1-amd64 #1
Debian 5.8.7-1
[ 1492.533674] Hardware name: System manufacturer System Product Name/Z170-A,
BIOS 3802 03/15/2018
[ 1492.533676] RIP: 0010:eventfd_signal+0x88/0xa0
[ 1492.533677] Code: 03 00 00 00 4c 89 f7 e8 e6 a8 dc ff 65 ff 0d 0f 20 92 6a
4c 89 ee 4c 89 f7 e8 34 6a 52 00 4c 89 e0 5b 5d 41 5c 41 5d 41 5e c3 <0f> 0b 45
31 e4 5b 5d 4c 89 e0 41 5c 41 5d 41 5e c3 0f 1f 80 00 00
[ 1492.533678] RSP: 0018:ffffb27ac06afd40 EFLAGS: 00010202
[ 1492.533679] RAX: 0000000000000001 RBX: ffff94c12c87f000 RCX:
0000000000000000
[ 1492.533680] RDX: 000000000000ad5c RSI: 0000000000000001 RDI:
ffff94c0dd9e81c0
[ 1492.533680] RBP: 0000000000000000 R08: 0000006e000000a8 R09:
ffff94c12c87f348
[ 1492.533681] R10: 0000000000000000 R11: 0000000000000020 R12:
ffff94c10d3f01d0
[ 1492.533681] R13: ffff94c10d3f0000 R14: ffff94c10d3f00c8 R15:
ffffb27ac06afe18
[ 1492.533682] FS:  0000000000000000(0000) GS:ffff94c14ed00000(0000)
knlGS:0000000000000000
[ 1492.533683] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1492.533683] CR2: 0000000000000000 CR3: 0000000bc2300003 CR4:
00000000003626e0
[ 1492.533684] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 1492.533685] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[ 1492.533685] Call Trace:
[ 1492.533691]  handle_rx+0xbe/0x9f0 [vhost_net]
[ 1492.533694]  vhost_worker+0x88/0xd0 [vhost]
[ 1492.533696]  ? vhost_exceeds_weight+0x50/0x50 [vhost]
[ 1492.533698]  kthread+0x119/0x140
[ 1492.533699]  ? __kthread_bind_mask+0x60/0x60
[ 1492.533701]  ret_from_fork+0x22/0x30
[ 1492.533703] ---[ end trace a62bb924e0497bb1 ]---

Thanks in advance for your time!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
