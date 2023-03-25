Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BD26C8EB4
	for <lists+kvm@lfdr.de>; Sat, 25 Mar 2023 14:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjCYN63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Mar 2023 09:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCYN62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Mar 2023 09:58:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BAB30F8
        for <kvm@vger.kernel.org>; Sat, 25 Mar 2023 06:58:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C77560C5F
        for <kvm@vger.kernel.org>; Sat, 25 Mar 2023 13:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9A3BDC4339C
        for <kvm@vger.kernel.org>; Sat, 25 Mar 2023 13:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679752705;
        bh=h2gqWreBJbcOsrJUIfqRGo7OoiOsgb5u/LW8a5DQvM0=;
        h=From:To:Subject:Date:From;
        b=B6Gm+EEI6/d9ZjlBo40v8uP/YKTIOmIQaYZQ9bdRIpjKa6xJicIBdKy7Q5VPBrfWG
         J7q/Y+zdo5PtwQ4cPdeDFC2qj+ZJb30QCbWilTecQHP0fOLfdnBGJcKEKxgY5DD+MY
         S70j0T61NiB8FCKpCjAvIK+M2LYIWGHlgefHPhXr1KGS9zNjIC5aEPlieNf2UDKNOT
         DbH53wFAwY200WJCkXjqC+AxYzuca3ZSgm3z4ir1pRRol2PeBPriM79hKPK6LTc2jB
         RDAr/lQE5oG90vUOYxTk8e5sHkiVPAULADJpuSX+ji5BAw6MxDqX6DLCX8AYls1hbQ
         yXJ0SoKy3bwwQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 72575C43144; Sat, 25 Mar 2023 13:58:25 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217247] New: BUG: kernel NULL pointer dereference, address:
 000000000000000c / speculation_ctrl_update
Date:   Sat, 25 Mar 2023 13:58:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hvtaifwkbgefbaei@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-217247-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217247

            Bug ID: 217247
           Summary: BUG: kernel NULL pointer dereference, address:
                    000000000000000c / speculation_ctrl_update
           Product: Virtualization
           Version: unspecified
    Kernel Version: 6.1.20
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: hvtaifwkbgefbaei@gmail.com
        Regression: No

Created attachment 304023
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D304023&action=3Dedit
kernel config

This is 6.1.20 with only ZFS 2.1.9 module added.
I booted kernel with acpi=3Doff because this old Ryzen 1600X system is gett=
ing
unreliable (so only one CPU is online with acpi=3Doff, and it has been reli=
able
before this splat).

2023-03-25T13:28:40,794781+02:00 BUG: kernel NULL pointer dereference, addr=
ess:
000000000000000c
2023-03-25T13:28:40,794786+02:00 #PF: supervisor read access in kernel mode
2023-03-25T13:28:40,794788+02:00 #PF: error_code(0x0000) - not-present page
2023-03-25T13:28:40,794790+02:00 PGD 0 P4D 0=20
2023-03-25T13:28:40,794793+02:00 Oops: 0000 [#1] PREEMPT SMP NOPTI
2023-03-25T13:28:40,794795+02:00 CPU: 0 PID: 917598 Comm: qemu-kvm Tainted:=
 P=20=20
     W  O       6.1.20+ #12
2023-03-25T13:28:40,794798+02:00 Hardware name: To Be Filled By O.E.M. To Be
Filled By O.E.M./X370 Taichi, BIOS P6.20 01/03/2020
2023-03-25T13:28:40,794800+02:00 RIP: 0010:do_raw_spin_lock+0x6/0xb0
2023-03-25T13:28:40,794805+02:00 Code: 05 00 00 48 8d 88 60 07 00 00 48 c7 =
c7
18 66 af 9e e8 49 a9 28 01 e9 4c 8d 32 01 66 0f 1f 84 00 00 00 00 00 0f 1f =
44
00 00 53 <8b> 47 04 48 89 fb 3d ad 4e ad de 75 60 48 8b 53 10 65 48 8b 04 25
2023-03-25T13:28:40,794807+02:00 RSP: 0018:ffffa9110f3cbc58 EFLAGS: 00010046
2023-03-25T13:28:40,794809+02:00 RAX: 0000000000000000 RBX: 0000000000000020
RCX: 0000000000000000
2023-03-25T13:28:40,794810+02:00 RDX: 0000000000000000 RSI: 0000000000000000
RDI: 0000000000000008
2023-03-25T13:28:40,794812+02:00 RBP: 0000000000000000 R08: 0000000000000000
R09: 0000000000000000
2023-03-25T13:28:40,794813+02:00 R10: 0000000000000000 R11: 0000000000000000
R12: 0000000000000002
2023-03-25T13:28:40,794814+02:00 R13: 0206800000000010 R14: ffff9ceffe81fba0
R15: 0000000000000400
2023-03-25T13:28:40,794816+02:00 FS:  000074963adfd6c0(0000)
GS:ffff9ceffe800000(0000) knlGS:0000000000000000
2023-03-25T13:28:40,794818+02:00 CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
2023-03-25T13:28:40,794819+02:00 CR2: 000000000000000c CR3: 00000005227da000
CR4: 00000000003506f0
2023-03-25T13:28:40,794821+02:00 Call Trace:
2023-03-25T13:28:40,794823+02:00  <TASK>
2023-03-25T13:28:40,794826+02:00  speculation_ctrl_update+0xe2/0x1e0
2023-03-25T13:28:40,794830+02:00  svm_vcpu_run+0x4db/0x790 [kvm_amd]
2023-03-25T13:28:40,794838+02:00  kvm_arch_vcpu_ioctl_run+0x8f0/0x1730 [kvm]
2023-03-25T13:28:40,794876+02:00  ? kvm_vm_ioctl+0x386/0x1260 [kvm]
2023-03-25T13:28:40,794907+02:00  kvm_vcpu_ioctl+0x22b/0x670 [kvm]
2023-03-25T13:28:40,794937+02:00  ? kvm_vm_ioctl_irq_line+0x23/0x50 [kvm]
2023-03-25T13:28:40,794971+02:00  ? _copy_to_user+0x21/0x40
2023-03-25T13:28:40,794974+02:00  ? kvm_vm_ioctl+0x386/0x1260 [kvm]
2023-03-25T13:28:40,795004+02:00  ? do_iter_readv_writev+0xdf/0x150
2023-03-25T13:28:40,795008+02:00  __x64_sys_ioctl+0x1b3/0x930
2023-03-25T13:28:40,795012+02:00  ? exit_to_user_mode_prepare+0x1e/0x110
2023-03-25T13:28:40,795015+02:00  do_syscall_64+0x5b/0x90
2023-03-25T13:28:40,795019+02:00  ? exit_to_user_mode_prepare+0x1e/0x110
2023-03-25T13:28:40,795021+02:00  ? syscall_exit_to_user_mode+0x25/0x50
2023-03-25T13:28:40,795023+02:00  ? do_syscall_64+0x67/0x90
2023-03-25T13:28:40,795025+02:00  ? do_syscall_64+0x67/0x90
2023-03-25T13:28:40,795027+02:00  ? exit_to_user_mode_prepare+0x101/0x110
2023-03-25T13:28:40,795029+02:00  ? syscall_exit_to_user_mode+0x25/0x50
2023-03-25T13:28:40,795031+02:00  ? do_syscall_64+0x67/0x90
2023-03-25T13:28:40,795033+02:00  entry_SYSCALL_64_after_hwframe+0x63/0xcd
2023-03-25T13:28:40,795036+02:00 RIP: 0033:0x749742611d6f
2023-03-25T13:28:40,795038+02:00 Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 =
60
c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 =
00
00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
2023-03-25T13:28:40,795040+02:00 RSP: 002b:000074963adfc5c0 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
2023-03-25T13:28:40,795042+02:00 RAX: ffffffffffffffda RBX: 00005739a22dd230
RCX: 0000749742611d6f
2023-03-25T13:28:40,795043+02:00 RDX: 0000000000000000 RSI: 000000000000ae80
RDI: 000000000000000f
2023-03-25T13:28:40,795045+02:00 RBP: 00007497438dd000 R08: 00005739a00dfde8
R09: 00000000000000ff
2023-03-25T13:28:40,795046+02:00 R10: 000074961c016ee0 R11: 0000000000000246
R12: 0000000000000001
2023-03-25T13:28:40,795047+02:00 R13: 0000000000000001 R14: 00000000000003f9
R15: 0000000000000000
2023-03-25T13:28:40,795050+02:00  </TASK>
2023-03-25T13:28:40,795051+02:00 Modules linked in: algif_hash pcspkr
xt_addrtype nft_ct nft_fib_ipv4 nft_fib act_skbedit cls_fw nf_conntrack_net=
link
nfnetlink_acct ip6table_mangle ip6t_REJECT nf_reject_ipv6 ip6t_rt
ip6table_filter iptable_nat nf_nat iptable_raw xt_connmark iptable_mangle
xt_LOG nf_log_syslog xt_hashlimit xt_length xt_limit xt_hl xt_multiport xt_=
mark
snd_seq_dummy ipt_REJECT snd_hrtimer nf_reject_ipv4 xt_owner xt_set
xt_conntrack iptable_filter nf_tables ip_set_bitmap_port ip_set_hash_mac
ip_set_hash_net ip_set nfnetlink hwmon_vid binfmt_misc kvm_amd snd_usb_audio
snd_hda_codec_hdmi snd_hda_intel kvm snd_intel_dspcfg snd_hda_codec
snd_usbmidi_lib snd_hwdep snd_hda_core snd_rawmidi mc snd_seq snd_seq_device
snd_pcm snd_timer snd irqbypass rtc_cmos k10temp i2c_piix4 soundcore
nls_iso8859_1 nls_cp437 vfat fat pktcdvd algif_aead exfat wireguard
libchacha20poly1305 sch_cake tcp_cubic tcp_westwood br_netfilter bridge stp=
 llc
loop configfs dm_crypt trusted asn1_encoder tpm
2023-03-25T13:28:40,795095+02:00  algif_skcipher af_alg usbhid zfs(PO)
zunicode(PO) zzstd(O) zlua(O) zavl(PO) icp(PO) xhci_pci xhci_hcd zcommon(PO)
znvpair(PO) spl(O) igb usbcore ccp sp5100_tco ptp usb_common btrfs sunrpc
iscsi_tcp libiscsi_tcp scsi_dh_rdac libiscsi scsi_dh_emc scsi_dh_alua
scsi_transport_iscsi ip6_tables ip_tables tun xt_tcpudp x_tables tcp_bbr
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 sch_fq_codel sch_htb sch_pie ana=
log
gameport joydev i2c_dev fuse ecryptfs autofs4 [last unloaded: pcspkr]
2023-03-25T13:28:40,795124+02:00 CR2: 000000000000000c
2023-03-25T13:28:40,795125+02:00 ---[ end trace 0000000000000000 ]---
2023-03-25T13:28:40,795127+02:00 RIP: 0010:do_raw_spin_lock+0x6/0xb0
2023-03-25T13:28:40,795129+02:00 Code: 05 00 00 48 8d 88 60 07 00 00 48 c7 =
c7
18 66 af 9e e8 49 a9 28 01 e9 4c 8d 32 01 66 0f 1f 84 00 00 00 00 00 0f 1f =
44
00 00 53 <8b> 47 04 48 89 fb 3d ad 4e ad de 75 60 48 8b 53 10 65 48 8b 04 25
2023-03-25T13:28:40,795131+02:00 RSP: 0018:ffffa9110f3cbc58 EFLAGS: 00010046
2023-03-25T13:28:40,795133+02:00 RAX: 0000000000000000 RBX: 0000000000000020
RCX: 0000000000000000
2023-03-25T13:28:40,795134+02:00 RDX: 0000000000000000 RSI: 0000000000000000
RDI: 0000000000000008
2023-03-25T13:28:40,795135+02:00 RBP: 0000000000000000 R08: 0000000000000000
R09: 0000000000000000
2023-03-25T13:28:40,795136+02:00 R10: 0000000000000000 R11: 0000000000000000
R12: 0000000000000002
2023-03-25T13:28:40,795137+02:00 R13: 0206800000000010 R14: ffff9ceffe81fba0
R15: 0000000000000400
2023-03-25T13:28:40,795138+02:00 FS:  000074963adfd6c0(0000)
GS:ffff9ceffe800000(0000) knlGS:0000000000000000
2023-03-25T13:28:40,795140+02:00 CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
2023-03-25T13:28:40,795141+02:00 CR2: 000000000000000c CR3: 00000005227da000
CR4: 00000000003506f0
2023-03-25T13:28:40,795143+02:00 note: qemu-kvm[917598] exited with irqs
disabled
2023-03-25T13:28:40,795144+02:00 note: qemu-kvm[917598] exited with
preempt_count 2

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
