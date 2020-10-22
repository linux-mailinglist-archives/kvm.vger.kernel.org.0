Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41B729626E
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 18:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901482AbgJVQOY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 22 Oct 2020 12:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896380AbgJVQOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 12:14:24 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209253] Loss of connectivity on guest after important host <->
 guest traffic
Date:   Thu, 22 Oct 2020 16:14:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: justin.gatzen@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-209253-28872-DnO2YScdBt@https.bugzilla.kernel.org/>
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

Justin Gatzen (justin.gatzen@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |justin.gatzen@gmail.com

--- Comment #4 from Justin Gatzen (justin.gatzen@gmail.com) ---
Seeing the same issue here on 5.9.1 and 5.8.14. I did not notice any trouble on
5.8.2 for about two weeks of usage, but that is just an anecdote. I have not
attempted to bisect this because the bug takes quite a while to trigger.


Stack trace from a VFIO enabled VM with SRIOV nic, NVME passthrough, GPU
passthrough, Windows guest:

[83372.203651] ------------[ cut here ]------------
[83372.203659] WARNING: CPU: 16 PID: 0 at fs/eventfd.c:74
eventfd_signal+0x89/0xa0
[83372.203661] Modules linked in: vhost_net vhost tap vhost_iotlb tun vfio_pci
vfio_virqfd vfio_iommu_type1 vfio ebtable_filter ebtables ip6table_filter
ip6_tables iptable_filter ip_tables nft_reject_inet nf_reject_ipv4
nf_reject_ipv6 nft_reject nft_ct nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
nft_counter uinput nft_meta_bridge nf_tables nfnetlink xpad hid_microsoft
ff_memless mlx5_ib ib_uverbs nouveau ib_core edac_mce_amd mlx5_core iwlmvm
kvm_amd mac80211 kvm snd_hda_codec_realtek irqbypass sp5100_tco
snd_hda_codec_generic pcspkr rapl k10temp wmi_bmof i2c_piix4 mlxfw
ledtrig_audio snd_hda_codec_hdmi joydev pci_hyperv_intf snd_hda_intel bridge
snd_intel_dspcfg libarc4 snd_hda_codec btusb btrtl iwlwifi snd_hda_core btbcm
mxm_wmi stp btintel llc video snd_hwdep bluetooth snd_pcm ttm snd_timer
cfg80211 drm_kms_helper veth igb snd ecdh_generic ecc cec i2c_algo_bit
soundcore r8169 rfkill dca acpi_cpufreq vfat fat drm essiv authenc dm_crypt xfs
crct10dif_pclmul ccp crc32_pclmul crc32c_intel nvme
[83372.203687]  ghash_clmulni_intel nvme_core wmi pinctrl_amd
[83372.203702] CPU: 16 PID: 0 Comm: swapper/16 Not tainted 5.9.1-dirty #49
[83372.203704] Hardware name: Gigabyte Technology Co., Ltd. X570 AORUS
MASTER/X570 AORUS MASTER, BIOS F30 09/07/2020
[83372.203707] RIP: 0010:eventfd_signal+0x89/0xa0
[83372.203709] Code: 03 00 00 00 4c 89 f7 e8 b5 3c db ff 65 ff 0d 3e 26 cb 52
4c 89 ee 4c 89 f7 e8 b3 65 7e 00 4c 89 e0 5b 5d 41 5c 41 5d 41 5e c3 <0f> 0b 45
31 e4 5b 5d 4c 89 e0 41 5c 41 5d 41 5e c3 66 0f 1f 44 00
[83372.203712] RSP: 0018:ffffa2cdc0554f28 EFLAGS: 00010002
[83372.203714] RAX: 0000000000000001 RBX: ffff8ceaec0d4880 RCX:
000000000000001f
[83372.203716] RDX: ffff8ceaed3b7200 RSI: 0000000000000001 RDI:
ffff8ce6eaa58340
[83372.203717] RBP: ffff8ceaed3b7200 R08: 00004bd39a951b00 R09:
0000000000000000
[83372.203719] R10: 0000000000000000 R11: 0000000000000000 R12:
00000000000000d9
[83372.203720] R13: 0000000000000000 R14: ffffa2cdc0554fa4 R15:
0000000000000000
[83372.203722] FS:  0000000000000000(0000) GS:ffff8cf5bee00000(0000)
knlGS:0000000000000000
[83372.203724] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[83372.203726] CR2: 00005562c8109c68 CR3: 00000001694fc000 CR4:
0000000000350ee0
[83372.203727] Call Trace:
[83372.203729]  <IRQ>
[83372.203734]  vfio_msihandler+0x12/0x20 [vfio_pci]
[83372.203738]  __handle_irq_event_percpu+0x42/0x180
[83372.203740]  handle_irq_event_percpu+0x21/0x60
[83372.203742]  handle_irq_event+0x36/0x53
[83372.203744]  handle_edge_irq+0x83/0x190
[83372.203747]  asm_call_irq_on_stack+0x12/0x20
[83372.203749]  </IRQ>
[83372.203751]  common_interrupt+0xb5/0x130
[83372.203753]  asm_common_interrupt+0x1e/0x40
[83372.203756] RIP: 0010:cpuidle_enter_state+0xdf/0x390
[83372.203758] Code: e8 76 49 7d ff 80 7c 24 0f 00 74 17 9c 58 0f 1f 44 00 00
f6 c4 02 0f 85 8f 02 00 00 31 ff e8 28 b3 83 ff fb 66 0f 1f 44 00 00 <45> 85 f6
0f 88 20 01 00 00 49 63 d6 4c 2b 24 24 48 8d 04 52 48 8d
[83372.203761] RSP: 0018:ffffa2cdc01c7e88 EFLAGS: 00000246
[83372.203762] RAX: ffff8cf5bee2a300 RBX: ffff8cf3b21d9400 RCX:
000000000000001f
[83372.203764] RDX: 0000000000000000 RSI: 000000002491bed3 RDI:
0000000000000000
[83372.203765] RBP: ffffffffaeb7f180 R08: 00004bd39a95195c R09:
0000000000001206
[83372.203767] R10: 0000000000004852 R11: ffff8cf5bee29124 R12:
00004bd39a95195c
[83372.203768] R13: ffffffffaeb7f268 R14: 0000000000000002 R15:
ffff8cf3b21d9400
[83372.203772]  ? cpuidle_enter_state+0xba/0x390
[83372.203774]  cpuidle_enter+0x29/0x40
[83372.203776]  do_idle+0x1b8/0x240
[83372.203778]  cpu_startup_entry+0x19/0x20
[83372.203780]  start_secondary+0x103/0x130
[83372.203783]  secondary_startup_64+0xb6/0xc0
[83372.203785] ---[ end trace a1dd3ff1b3977640 ]---


And from a non-VFIO run of the mill linux guest:

[37342.189129] ------------[ cut here ]------------
[37342.189137] WARNING: CPU: 21 PID: 1137 at fs/eventfd.c:74
eventfd_signal+0x89/0xa0
[37342.189139] Modules linked in: vfio_pci vfio_virqfd vfio_iommu_type1 vfio
vhost_net vhost tap vhost_iotlb tun nouveau ebtable_filter ebtables
ip6table_filter ip6_tables iptable_filter ip_tables nft_reject_inet
nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 mlx5_ib nft_counter nft_meta_bridge nf_tables ib_uverbs uinput
nfnetlink ib_core iwlmvm xpad hid_microsoft ff_memless mac80211 mlx5_core
snd_hda_codec_realtek joydev libarc4 snd_hda_codec_generic snd_hda_codec_hdmi
ledtrig_audio iwlwifi edac_mce_amd snd_hda_intel snd_intel_dspcfg snd_hda_codec
kvm_amd bridge btusb snd_hda_core btrtl kvm btbcm video btintel snd_hwdep
bluetooth ttm cfg80211 snd_pcm drm_kms_helper igb stp llc snd_timer irqbypass
veth rapl snd mlxfw pcspkr wmi_bmof mxm_wmi sp5100_tco k10temp i2c_piix4
i2c_algo_bit pci_hyperv_intf ecdh_generic cec r8169 dca soundcore ecc rfkill
drm acpi_cpufreq vfat fat essiv authenc dm_crypt xfs nvme nvme_core
crct10dif_pclmul ccp crc32_pclmul
[37342.189162]  crc32c_intel ghash_clmulni_intel wmi pinctrl_amd
[37342.189174] CPU: 21 PID: 1137 Comm: vhost-1125 Not tainted 5.9.1-dirty #50
[37342.189175] Hardware name: Gigabyte Technology Co., Ltd. X570 AORUS
MASTER/X570 AORUS MASTER, BIOS F30 09/07/2020
[37342.189178] RIP: 0010:eventfd_signal+0x89/0xa0
[37342.189180] Code: 03 00 00 00 4c 89 f7 e8 b5 3c db ff 65 ff 0d 3e 26 cb 79
4c 89 ee 4c 89 f7 e8 b3 65 7e 00 4c 89 e0 5b 5d 41 5c 41 5d 41 5e c3 <0f> 0b 45
31 e4 5b 5d 4c 89 e0 41 5c 41 5d 41 5e c3 66 0f 1f 44 00
[37342.189182] RSP: 0018:ffffadbcc1233d60 EFLAGS: 00010202
[37342.189183] RAX: 0000000000000001 RBX: ffff986bb47746b8 RCX:
00000000c3160001
[37342.189185] RDX: 0000000000000000 RSI: 0000000000000001 RDI:
ffff986948f6c9c0
[37342.189186] RBP: ffff986bb4770000 R08: 0000000000000001 R09:
0000000000000101
[37342.189187] R10: 000000002b30008a R11: 0000000022308000 R12:
0000000000000001
[37342.189189] R13: ffffadbcc1233e18 R14: ffff98630de8f300 R15:
ffff986bb47746b8
[37342.189190] FS:  0000000000000000(0000) GS:ffff986bbef40000(0000)
knlGS:0000000000000000
[37342.189192] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37342.189193] CR2: 00007f77c69ee890 CR3: 0000001029214000 CR4:
0000000000350ee0
[37342.189194] Call Trace:
[37342.189199]  vhost_tx_batch.isra.0+0x7d/0xc0 [vhost_net]
[37342.189202]  handle_tx_copy+0x15c/0x550 [vhost_net]
[37342.189204]  handle_tx+0xa5/0xe0 [vhost_net]
[37342.189207]  vhost_worker+0x8d/0xd0 [vhost]
[37342.189209]  ? vhost_vring_call_reset+0x40/0x40 [vhost]
[37342.189212]  kthread+0xfe/0x140
[37342.189214]  ? kthread_park+0x90/0x90
[37342.189216]  ret_from_fork+0x22/0x30
[37342.189218] ---[ end trace ae48714189db9592 ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
