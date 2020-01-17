Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69DB6141441
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 23:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgAQWnx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 17 Jan 2020 17:43:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:47524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726975AbgAQWnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 17:43:53 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206215] QEMU guest crash due to random 'general protection
 fault' since kernel 5.2.5 on i7-3517UE
Date:   Fri, 17 Jan 2020 22:43:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: kernel@najdan.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206215-28872-rggY2FFmiM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206215-28872@https.bugzilla.kernel.org/>
References: <bug-206215-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206215

--- Comment #9 from kernel@najdan.com ---
Sean,

for the record ...

I did:

   git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
@f5ae2ea6347a308cfe91f53b53682ce635497d0d

   git revert e751732486eb3f159089a64d1901992b1357e7cc

Then I built and installed kernel:
5.5.0-rc6-revert-e751732486eb3f159089a64d1901992b1357e7cc+ #1 SMP Thu Jan 16
13:02:23 EST 2020 x86_64 x86_64 x86_64 GNU/Linux

Guest is stable; no more "general protection fault".

Here is the stack trace with your patch
'0001-thread_info-Add-a-debug-hook-to-detect-FPU-changes-w.patch'

[  122.323347] ------------[ cut here ]------------
[  122.323355] WARNING: CPU: 1 PID: 1132 at include/linux/thread_info.h:55
kernel_fpu_begin+0x6b/0xc0
[  122.323356] Modules linked in: vhost_net vhost tap tun xfrm4_tunnel tunnel4
ipcomp xfrm_ipcomp esp4 ah4 af_key ebtable_filter ebtables ip6table_filter
ip6_tables bridge stp llc rfkill xt_TCPMSS xt_tcpmss xt_nat iptable_nat nf_nat
xt_DSCP iptable_mangle iptable_raw iptable_security nf_log_ipv4 nf_log_common
xt_policy xt_LOG xt_multiport ipt_REJECT nf_reject_ipv4 xt_state xt_conntrack
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_filter intel_rapl_msr
intel_rapl_common snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp
snd_hda_codec_realtek snd_hda_codec_generic coretemp ledtrig_audio kvm_intel
snd_hda_intel sunrpc snd_intel_dspcfg kvm snd_hda_codec snd_hda_core irqbypass
mei_wdt mei_hdcp snd_hwdep vfat crct10dif_pclmul snd_seq fat crc32_pclmul
snd_seq_device ghash_clmulni_intel iTCO_wdt snd_pcm iTCO_vendor_support
intel_cstate snd_timer intel_uncore snd pcspkr intel_rapl_perf mei_me soundcore
i2c_i801 lpc_ich mei ata_generic pata_acpi tcp_bbr sch_fq ip_tables xfs
libcrc32c i915
[  122.323384]  i2c_algo_bit drm_kms_helper crc32c_intel e1000e drm r8169
serio_raw video
[  122.323389] CPU: 1 PID: 1132 Comm: CPU 2/KVM Not tainted
5.5.0-rc6-thread_info-Add-a-debug-hook-to-detect-FPU-changes-w+ #1
[  122.323390] Hardware name: CompuLab 0000000-00000/Intense-PC, BIOS
IPC_2.2.400.5 X64 03/15/2018
[  122.323392] RIP: 0010:kernel_fpu_begin+0x6b/0xc0
[  122.323394] Code: f6 40 26 20 75 08 48 8b 10 80 e6 40 74 16 65 48 c7 05 d5
2b fe 48 00 00 00 00 c3 65 8a 05 c5 2b fe 48 eb c4 80 78 0c 00 74 02 <0f> 0b 48
83 c0 01 f0 80 08 40 65 48 8b 0c 25 c0 8b 01 00 0f 1f 44
[  122.323395] RSP: 0018:ffffa69b80108308 EFLAGS: 00010202
[  122.323396] RAX: ffff8992513ecd00 RBX: 0000000000000088 RCX:
ffffdd96904487c0
[  122.323397] RDX: 0000000000000000 RSI: ffff89925fa99b00 RDI:
ffff89925fa99b00
[  122.323397] RBP: ffffa69b801085b0 R08: ffffa69b801085c0 R09:
ffffa69b80108370
[  122.323398] R10: 0000000000000000 R11: 0000000000000bbe R12:
0000000000000bce
[  122.323399] R13: ffffa69b80108370 R14: 0000000000000000 R15:
ffff89925121fbbe
[  122.323400] FS:  00007ff235b52700(0000) GS:ffff89927e240000(0000)
knlGS:0000000000000000
[  122.323401] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  122.323401] CR2: 00000000ffffffff CR3: 000000040b55e002 CR4:
00000000001626e0
[  122.323402] Call Trace:
[  122.323404]  <IRQ>
[  122.323409]  gcmaes_crypt_by_sg.constprop.0+0x276/0x6c0
[  122.323415]  ? skb_clone_tx_timestamp+0x3c/0xa0
[  122.323419]  ? sch_direct_xmit+0x8b/0x310
[  122.323423]  ? esp4_err+0x120/0x120 [esp4]
[  122.323425]  ? helper_rfc4106_encrypt+0x7c/0xa0
[  122.323428]  ? crypto_aead_encrypt+0x3c/0x60
[  122.323429]  ? crypto_aead_encrypt+0x3c/0x60
[  122.323431]  ? seqiv_aead_encrypt+0x13a/0x1d0
[  122.323434]  ? fib4_rule_action+0x61/0x70
[  122.323436]  ? fib4_rule_action+0x70/0x70
[  122.323438]  ? fib_rules_lookup+0x143/0x1a0
[  122.323440]  ? __fib_lookup+0x6b/0xb0
[  122.323442]  ? ip_route_output_key_hash_rcu+0x562/0x890
[  122.323444]  ? ip_route_output_key_hash+0x5e/0x80
[  122.323445]  ? __xfrm4_dst_lookup.isra.0+0x88/0x90
[  122.323446]  ? xfrm4_dst_lookup+0x2f/0x50
[  122.323447]  ? rt_add_uncached_list+0x4b/0x80
[  122.323449]  ? xfrm4_fill_dst+0xae/0xf0
[  122.323450]  ? crypto_aead_encrypt+0x3c/0x60
[  122.323452]  ? esp_output_tail+0x1e5/0x580 [esp4]
[  122.323454]  ? esp_output+0x116/0x190 [esp4]
[  122.323457]  ? xfrm_output_resume+0x431/0x4f0
[  122.323464]  ? nf_confirm+0xcb/0xf0 [nf_conntrack]
[  122.323466]  ? __xfrm4_output+0x3f/0x70
[  122.323467]  ? xfrm4_output+0x3b/0xd0
[  122.323468]  ? xfrm4_udp_encap_rcv+0x190/0x190
[  122.323470]  ? ip_forward+0x36c/0x470
[  122.323472]  ? ip_defrag.cold+0x37/0x37
[  122.323473]  ? ip_rcv+0xbc/0xd0
[  122.323475]  ? ip_rcv_finish_core.isra.0+0x410/0x410
[  122.323476]  ? __netif_receive_skb_one_core+0x80/0x90
[  122.323478]  ? netif_receive_skb_internal+0x41/0xb0
[  122.323479]  ? nf_hook_slow+0x40/0xb0
[  122.323480]  ? netif_receive_skb+0x18/0xb0
[  122.323486]  ? br_pass_frame_up+0x133/0x150 [bridge]
[  122.323491]  ? br_port_flags_change+0x40/0x40 [bridge]
[  122.323495]  ? br_handle_frame_finish+0x16f/0x430 [bridge]
[  122.323497]  ? enqueue_entity+0x10e/0x650
[  122.323501]  ? br_handle_frame_finish+0x430/0x430 [bridge]
[  122.323505]  ? br_handle_frame+0x247/0x370 [bridge]
[  122.323506]  ? enqueue_task_fair+0x8c/0x4e0
[  122.323508]  ? update_group_capacity+0x25/0x1e0
[  122.323512]  ? br_handle_frame_finish+0x430/0x430 [bridge]
[  122.323513]  ? __netif_receive_skb_core+0x2db/0xf70
[  122.323515]  ? __netif_receive_skb_list_core+0x138/0x2e0
[  122.323517]  ? netif_receive_skb_list_internal+0x1cc/0x300
[  122.323518]  ? enqueue_task_fair+0x8c/0x4e0
[  122.323520]  ? kmem_cache_alloc+0x165/0x220
[  122.323521]  ? gro_normal_list.part.0+0x19/0x40
[  122.323522]  ? napi_complete_done+0x92/0x130
[  122.323526]  ? rtl8169_poll+0x5a9/0x640 [r8169]
[  122.323527]  ? net_rx_action+0x148/0x3c0
[  122.323530]  ? rtl8169_interrupt+0xfd/0x1e0 [r8169]
[  122.323532]  ? __do_softirq+0xee/0x2ff
[  122.323535]  ? irq_exit+0xe9/0xf0
[  122.323536]  ? do_IRQ+0x55/0xe0
[  122.323538]  ? common_interrupt+0xf/0xf
[  122.323539]  </IRQ>
[  122.323541]  ? irq_entries_start+0x30/0x660
[  122.323546]  ? handle_external_interrupt_irqoff+0x7a/0x100 [kvm_intel]
[  122.323568]  ? kvm_arch_vcpu_ioctl_run+0x995/0x1a60 [kvm]
[  122.323570]  ? futex_wake+0x90/0x170
[  122.323581]  ? kvm_vcpu_ioctl+0x218/0x5c0 [kvm]
[  122.323584]  ? __seccomp_filter+0x7b/0x670
[  122.323585]  ? signal_setup_done+0x82/0xa0
[  122.323586]  ? __fpu__restore_sig+0x436/0x500
[  122.323588]  ? do_vfs_ioctl+0x461/0x6d0
[  122.323590]  ? ksys_ioctl+0x5e/0x90
[  122.323591]  ? __x64_sys_ioctl+0x16/0x20
[  122.323593]  ? do_syscall_64+0x5b/0x1c0
[  122.323595]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  122.323597] ---[ end trace fffe8684d1d1c2f4 ]---
[  122.323626] ------------[ cut here ]------------
[  122.323644] WARNING: CPU: 1 PID: 1132 at arch/x86/kvm/x86.c:8206
kvm_arch_vcpu_ioctl_run+0x163e/0x1a60 [kvm]
[  122.323644] Modules linked in: vhost_net vhost tap tun xfrm4_tunnel tunnel4
ipcomp xfrm_ipcomp esp4 ah4 af_key ebtable_filter ebtables ip6table_filter
ip6_tables bridge stp llc rfkill xt_TCPMSS xt_tcpmss xt_nat iptable_nat nf_nat
xt_DSCP iptable_mangle iptable_raw iptable_security nf_log_ipv4 nf_log_common
xt_policy xt_LOG xt_multiport ipt_REJECT nf_reject_ipv4 xt_state xt_conntrack
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_filter intel_rapl_msr
intel_rapl_common snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp
snd_hda_codec_realtek snd_hda_codec_generic coretemp ledtrig_audio kvm_intel
snd_hda_intel sunrpc snd_intel_dspcfg kvm snd_hda_codec snd_hda_core irqbypass
mei_wdt mei_hdcp snd_hwdep vfat crct10dif_pclmul snd_seq fat crc32_pclmul
snd_seq_device ghash_clmulni_intel iTCO_wdt snd_pcm iTCO_vendor_support
intel_cstate snd_timer intel_uncore snd pcspkr intel_rapl_perf mei_me soundcore
i2c_i801 lpc_ich mei ata_generic pata_acpi tcp_bbr sch_fq ip_tables xfs
libcrc32c i915
[  122.323664]  i2c_algo_bit drm_kms_helper crc32c_intel e1000e drm r8169
serio_raw video
[  122.323669] CPU: 1 PID: 1132 Comm: CPU 2/KVM Tainted: G        W        
5.5.0-rc6-thread_info-Add-a-debug-hook-to-detect-FPU-changes-w+ #1
[  122.323669] Hardware name: CompuLab 0000000-00000/Intense-PC, BIOS
IPC_2.2.400.5 X64 03/15/2018
[  122.323683] RIP: 0010:kvm_arch_vcpu_ioctl_run+0x163e/0x1a60 [kvm]
[  122.323685] Code: a8 f3 fe ff 41 f6 44 24 42 02 75 08 4c 89 e7 e8 e8 f3 fe
ff 4c 89 e7 e8 20 7d fe ff 41 83 a4 24 60 26 00 00 fb e9 cb f2 ff ff <0f> 0b e9
8e f2 ff ff 31 db bf 07 00 00 00 48 89 de e8 cc 11 65 f6
[  122.323685] RSP: 0018:ffffa69b80fcbd40 EFLAGS: 00010002
[  122.323686] RAX: 0000000080004b00 RBX: 0000000000000000 RCX:
ffff8992513ecd00
[  122.323687] RDX: 0000000000000000 RSI: 0000000000000001 RDI:
0000000000000000
[  122.323688] RBP: ffffa69b80fcbde0 R08: 0000000000000001 R09:
0000000000000000
[  122.323688] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff899250a28000
[  122.323689] R13: 0000000000000000 R14: ffff899250a28038 R15:
ffffa69b81042320
[  122.323690] FS:  00007ff235b52700(0000) GS:ffff89927e240000(0000)
knlGS:0000000000000000
[  122.323691] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  122.323691] CR2: 00000000ffffffff CR3: 000000040b55e002 CR4:
00000000001626e0
[  122.323692] Call Trace:
[  122.323695]  ? futex_wake+0x90/0x170
[  122.323707]  kvm_vcpu_ioctl+0x218/0x5c0 [kvm]
[  122.323709]  ? __seccomp_filter+0x7b/0x670
[  122.323710]  ? signal_setup_done+0x82/0xa0
[  122.323711]  ? __fpu__restore_sig+0x436/0x500
[  122.323713]  do_vfs_ioctl+0x461/0x6d0
[  122.323715]  ksys_ioctl+0x5e/0x90
[  122.323716]  __x64_sys_ioctl+0x16/0x20
[  122.323718]  do_syscall_64+0x5b/0x1c0
[  122.323720]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  122.323722] RIP: 0033:0x7ff2399bf34b
[  122.323723] Code: 0f 1e fa 48 8b 05 3d 9b 0c 00 64 c7 00 26 00 00 00 48 c7
c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 0d 9b 0c 00 f7 d8 64 89 01 48
[  122.323724] RSP: 002b:00007ff235b51698 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  122.323725] RAX: ffffffffffffffda RBX: 000056321fab4f50 RCX:
00007ff2399bf34b
[  122.323726] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
000000000000001b
[  122.323726] RBP: 00007ff23534f000 R08: 000056321d5ac390 R09:
000056321da50d40
[  122.323727] R10: 000056321f960760 R11: 0000000000000246 R12:
000056321fad7770
[  122.323727] R13: 000056321fab4f50 R14: 00007ffdb09a9730 R15:
000056321da2de80
[  122.323729] ---[ end trace fffe8684d1d1c2f5 ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
