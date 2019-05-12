Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A12FD1ABF5
	for <lists+kvm@lfdr.de>; Sun, 12 May 2019 14:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfELMKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 May 2019 08:10:07 -0400
Received: from torres.zugschlus.de ([85.214.131.164]:44502 "EHLO
        torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfELMKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 May 2019 08:10:07 -0400
X-Greylist: delayed 1023 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 May 2019 08:10:06 EDT
Received: from mh by torres.zugschlus.de with local (Exim 4.92)
        (envelope-from <mh+linux-kernel@zugschlus.de>)
        id 1hPn2M-0000Yf-Tc; Sun, 12 May 2019 13:53:02 +0200
Date:   Sun, 12 May 2019 13:53:02 +0200
From:   Marc Haber <mh+linux-kernel@zugschlus.de>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Linux in KVM guest segfaults when hosts runs Linux 5.1
Message-ID: <20190512115302.GM3835@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

since updating my home desktop machine to kernel 5.1.1, KVM guests
started on that machine segfault after booting:
general protection fault: 0000 [#1] PREEMPT SMP NOPTI
CPU: 0 PID: 13 Comm: kworker/0:1 Not tainted 5.0.13-zgsrv20080 #5.0.13.20190505.0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
Workqueue: events once_deferred
RIP: 0010:native_read_pmc+0x2/0x10
Code: e2 20 89 3e 48 09 d0 c3 89 f9 89 f0 0f 30 c3 66 0f 1f 84 00 00 00 00 00 89 f0 89 f9 0f 30 31 c0 c3 0f 1f 80 00 00 00 00 89 f9 <0f> 33 48 c1 e2 20 48 09 d0 c3 0f 1f 40 00 0f 20 c0 c3 66 66 2e 0f
RSP: 0018:ffff8881b9a03e50 EFLAGS: 00010083
RAX: 0000000000000001 RBX: ffff800000000001 RCX: 0000000000000000
RDX: 000000000000002f RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff8881b590e400 R08: ffff8881b590e400 R09: 0000000000000003
R10: ffffe8ffffc05440 R11: 0000000000000000 R12: ffff8881b590e5d8
R13: 0000000000000010 R14: ffff8881b590e420 R15: ffffe8ffffc05400
FS:  0000000000000000(0000) GS:ffff8881b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9bcc5c61f8 CR3: 00000001b6a24000 CR4: 00000000000006f0
Call Trace:
 <IRQ>
 x86_perf_event_update+0x3b/0x80
 x86_pmu_stop+0x84/0xa0
 x86_pmu_del+0x52/0x160
 event_sched_out.isra.59+0x95/0x190
 group_sched_out.part.61+0x51/0xc0
 ctx_sched_out+0xf2/0x220
 ctx_resched+0xb8/0xc0
 __perf_install_in_context+0x175/0x1f0
 remote_function+0x3e/0x50
 flush_smp_call_function_queue+0x30/0xe0
 smp_call_function_interrupt+0x2f/0x40
 call_function_single_interrupt+0xf/0x20
 </IRQ>
RIP: 0010:smp_call_function_many+0x1ca/0x230
Code: ee 89 c7 e8 e8 f5 51 00 3b 05 a6 23 db 00 0f 83 b2 fe ff ff 48 63 d0 48 8b 0b 48 03 0c d5 20 28 db 81 8b 51 18 83 e2 01 74 0a <f3> 90 8b 51 18 83 e2 01 75 f6 eb c8 48 c7 c2 60 17 e9 81 48 89 ee
RSP: 0018:ffffc90000cc3d48 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff04
RAX: 0000000000000001 RBX: ffff8881b9a21e00 RCX: ffff8881b9a647c0
RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8881b9a21e08
RBP: ffff8881b9a21e08 R08: 000000000000003e R09: 0000000000000000
R10: ffffffff81c04584 R11: 0000000000000000 R12: ffffffff81027af0
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000008
 ? arch_unregister_cpu+0x20/0x20
 ? smp_call_function_many+0x1a8/0x230
 ? inet_ehashfn+0x29/0x100
 ? arch_unregister_cpu+0x20/0x20
 ? inet_ehashfn+0x2a/0x100
 smp_call_function+0x20/0x40
 on_each_cpu+0x18/0x70
 ? inet_ehashfn+0x29/0x100
 ? inet_ehashfn+0x2a/0x100
 text_poke_bp+0x8d/0xda
 __jump_label_transform+0x10d/0x120
 arch_jump_label_transform+0x21/0x30
 __jump_label_update+0x70/0xe0
 static_key_disable_cpuslocked+0x54/0x80
 static_key_disable+0x11/0x20
 once_deferred+0x1a/0x30
 process_one_work+0x171/0x300
 worker_thread+0x2b/0x370
 ? process_one_work+0x300/0x300
 kthread+0x108/0x120
 ? kthread_park+0x80/0x80
 ret_from_fork+0x22/0x40
Modules linked in: input_leds sg led_class virtio_balloon virtio_console qemu_fw_cfg dm_mod virtio_rng ip_tables x_tables autofs4 ext4 mbcache jbd2 fscrypto sr_mod cdrom ata_generic virtio_net net_failover failover virtio_blk virtio_pci i2c_piix4 virtio_ring ata_piix virtio libata i2c_core floppy
---[ end trace 60c8d1a075894c8d ]---
RIP: 0010:native_read_pmc+0x2/0x10
Code: e2 20 89 3e 48 09 d0 c3 89 f9 89 f0 0f 30 c3 66 0f 1f 84 00 00 00 00 00 89 f0 89 f9 0f 30 31 c0 c3 0f 1f 80 00 00 00 00 89 f9 <0f> 33 48 c1 e2 20 48 09 d0 c3 0f 1f 40 00 0f 20 c0 c3 66 66 2e 0f
RSP: 0018:ffff8881b9a03e50 EFLAGS: 00010083
RAX: 0000000000000001 RBX: ffff800000000001 RCX: 0000000000000000
RDX: 000000000000002f RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff8881b590e400 R08: ffff8881b590e400 R09: 0000000000000003
R10: ffffe8ffffc05440 R11: 0000000000000000 R12: ffff8881b590e5d8
R13: 0000000000000010 R14: ffff8881b590e420 R15: ffffe8ffffc05400
FS:  0000000000000000(0000) GS:ffff8881b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9bcc5c61f8 CR3: 00000001b6a24000 CR4: 00000000000006f0
Kernel panic - not syncing: Fatal exception in interrupt
Kernel Offset: disabled
---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

The host seems to be running fine, the KVM guest crash is reproducible.
Both host and guest are running Debian unstable with a locally built
kernel; the host runs 5.1.1, the guest 5.0.13. The crash also happens
when the host is running 5.1.0; going back to 5.0.13 with the host
allows the guest to finish bootup and run fine.

Please note that my kernel 5.1.1 image is not fully broken in KVM, I
have update my APU machine which runs firewall and other infrastructure
services and the guests run fine there.

The machine in question is an older box with an AMD Phenom(tm) II X6
1090T Processor. I guess that the issue is related to the Phenom CPU.

Any idea short of bisecting?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
