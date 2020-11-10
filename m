Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDEBC2ACFBA
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 07:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbgKJGbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 01:31:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24925 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbgKJGbo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Nov 2020 01:31:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604989901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kEh9IwUsZje85DZAgVd597ieMKZP+Lv9ngWN0yGU1Rg=;
        b=AZ5YcswUY2/4pkkNHDUVJhfcmFdKyipcd6GPpAJdmLGTkJhBlwai7wH7pRwCKWPppY38zz
        YVqQmuNvGFxg/WHhjgwR/D42zN7rVkncvqy5ySTgkzxfi+ouTFVoq0tBN35jX2OUbDPL9b
        hTBlYAak4APHskC0I16yiW1DCy5ot3w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-JKwa6kE7MwC-uMmAYvrMww-1; Tue, 10 Nov 2020 01:31:35 -0500
X-MC-Unique: JKwa6kE7MwC-uMmAYvrMww-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71AFD809DD4;
        Tue, 10 Nov 2020 06:31:32 +0000 (UTC)
Received: from ovpn-66-145.rdu2.redhat.com (unknown [10.10.67.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63A1460BFA;
        Tue, 10 Nov 2020 06:31:30 +0000 (UTC)
Message-ID: <085029af45f045dcf5b7fb2173d560421b00b44d.camel@redhat.com>
Subject: Re: [PATCH v3 19/35] x86/io_apic: Cleanup trigger/polarity helpers
From:   Qian Cai <cai@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Date:   Tue, 10 Nov 2020 01:31:29 -0500
In-Reply-To: <20201024213535.443185-20-dwmw2@infradead.org>
References: <e6601ff691afb3266e365a91e8b221179daf22c2.camel@infradead.org>
         <20201024213535.443185-1-dwmw2@infradead.org>
         <20201024213535.443185-20-dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2020-10-24 at 22:35 +0100, David Woodhouse wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> 'trigger' and 'polarity' are used throughout the I/O-APIC code for handling
> the trigger type (edge/level) and the active low/high configuration. While
> there are defines for initializing these variables and struct members, they
> are not used consequently and the meaning of 'trigger' and 'polarity' is
> opaque and confusing at best.
> 
> Rename them to 'is_level' and 'active_low' and make them boolean in various
> structs so it's entirely clear what the meaning is.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/x86/include/asm/hw_irq.h       |   6 +-
>  arch/x86/kernel/apic/io_apic.c      | 244 +++++++++++++---------------
>  arch/x86/pci/intel_mid_pci.c        |   8 +-
>  drivers/iommu/amd/iommu.c           |  10 +-
>  drivers/iommu/intel/irq_remapping.c |   9 +-
>  5 files changed, 130 insertions(+), 147 deletions(-)

Reverting the rest of patchset up to this commit on next-20201109 fixed an
endless soft-lockups issue booting an AMD server below. I noticed that the
failed boots always has this IOMMU IO_PAGE_FAULT before those soft-lockups:

[ 3404.093354][    T1] AMD-Vi: Interrupt remapping enabled
[ 3404.098593][    T1] AMD-Vi: Virtual APIC enabled
[ 3404.107783][  T340] pci 0000:00:14.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000 address=0xfffffffdf8020200 flags=0x0008]
[ 3404.120644][    T1] AMD-Vi: Lazy IO/TLB flushing enabled
[ 3404.126011][    T1] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[ 3404.133173][    T1] software IO TLB: mapped [mem 0x0000000068dcf000-0x000000006cdcf000] (64MB)

.config (if ever matters):
https://cailca.coding.net/public/linux/mm/git/files/master/x86.config

good boot dmesg (with the commits reverted):
http://people.redhat.com/qcai/dmesg.txt

== system info ==
Dell Poweredge R6415
AMD EPYC 7401P 24-Core Processor
24576 MB memory, 239 GB disk space

[  OK  ] Started Flush Journal to Persistent Storage.
[  OK  ] Started udev Kernel Device Manager.
[  OK  ] Started udev Coldplug all Devices.
[  OK  ] Started Monitoring of LVM2 mirrors,…sing dmeventd or progress polling.
[  OK  ] Reached target Local File Systems (Pre).
         Mounting /boot...
[  OK  ] Created slice system-lvm2\x2dpvscan.slice.
[ 3740.376500][ T1058] XFS (sda1): Mounting V5 Filesystem
[ 3740.438474][ T1058] XFS (sda1): Ending clean mount
[ 3765.159433][    C0] watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [systemd:1]
[ 3765.166929][    C0] Modules linked in: acpi_cpufreq(+) ip_tables x_tables sd_mod ahci libahci tg3 bnxt_en megaraid_sas libata firmware_class libphy dm_mirror dm_region_hash dm_log dm_mod
[ 3765.183576][    C0] irq event stamp: 26230104
[ 3765.187954][    C0] hardirqs last  enabled at (26230103): [<ffffffff82800b9e>] asm_common_interrupt+0x1e/0x40
[ 3765.197873][    C0] hardirqs last disabled at (26230104): [<ffffffff8277e45a>] sysvec_apic_timer_interrupt+0xa/0xa0
[ 3765.208303][    C0] softirqs last  enabled at (26202664): [<ffffffff82a0061b>] __do_softirq+0x61b/0x95d
[ 3765.217699][    C0] softirqs last disabled at (26202591): [<ffffffff82800ec2>] asm_call_irq_on_stack+0x12/0x20
[ 3765.227702][    C0] CPU: 0 PID: 1 Comm: systemd Not tainted 5.10.0-rc2-next-20201109+ #2
[ 3765.235793][    C0] Hardware name: Dell Inc. PowerEdge R6415/07YXFK, BIOS 1.9.3 06/25/2019
[ 3765.244065][    C0] RIP: 0010:lock_acquire+0x1f4/0x820
lock_acquire at kernel/locking/lockdep.c:5404
[ 3765.249211][    C0] Code: ff ff ff 48 83 c4 20 65 0f c1 05 a7 ba 9e 7e 83 f8 01 4c 8b 54 24 08 0f 85 60 04 00 00 41 52 9d 48 b8 00 00 00 00 00 fc ff df <48> 01 c3 c7 03 00 00 00 00 c7 43 08 00 00 00 00 48 8b0
[ 3765.268657][    C0] RSP: 0018:ffffc9000006f9f8 EFLAGS: 00000246
[ 3765.274587][    C0] RAX: dffffc0000000000 RBX: 1ffff9200000df42 RCX: 1ffff9200000df28
[ 3765.282420][    C0] RDX: 1ffff11020645769 RSI: 00000000ffffffff RDI: 0000000000000001
[ 3765.290256][    C0] RBP: 0000000000000001 R08: fffffbfff164cb10 R09: fffffbfff164cb10
[ 3765.298090][    C0] R10: 0000000000000246 R11: fffffbfff164cb0f R12: ffff88812be555b0
[ 3765.305922][    C0] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 3765.313750][    C0] FS:  00007f12bb8c59c0(0000) GS:ffff8881b7000000(0000) knlGS:0000000000000000
[ 3765.322537][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3765.328985][    C0] CR2: 00007f0c2d828fd0 CR3: 000000011868a000 CR4: 00000000003506f0
[ 3765.336820][    C0] Call Trace:
[ 3765.339979][    C0]  ? rcu_read_unlock+0x40/0x40
[ 3765.344609][    C0]  __d_move+0x2a2/0x16f0
__seqprop_spinlock_assert at include/linux/seqlock.h:277
(inlined by) __d_move at fs/dcache.c:2861
[ 3765.348711][    C0]  ? d_move+0x47/0x70
[ 3765.352560][    C0]  ? _raw_spin_unlock+0x1a/0x30
[ 3765.357275][    C0]  d_move+0x47/0x70
write_seqcount_t_end at include/linux/seqlock.h:560
(inlined by) write_sequnlock at include/linux/seqlock.h:901
(inlined by) d_move at fs/dcache.c:2916
[ 3765.360951][    C0]  ? vfs_rename+0x9ac/0x1270
[ 3765.365402][    C0]  vfs_rename+0x9ac/0x1270
vfs_rename at fs/namei.c:4330
[ 3765.369687][    C0]  ? vfs_link+0x830/0x830
[ 3765.373878][    C0]  ? do_renameat2+0x58c/0x930
[ 3765.378419][    C0]  do_renameat2+0x58c/0x930
do_renameat2 at fs/namei.c:4455
[ 3765.382790][    C0]  ? __ia32_sys_link+0x80/0x80
[ 3765.387418][    C0]  ? rcu_read_lock_bh_held+0xb0/0xb0
[ 3765.392563][    C0]  ? rcu_read_lock_sched_held+0x9c/0xd0
[ 3765.397965][    C0]  ? rcu_read_lock_bh_held+0xb0/0xb0
[ 3765.403112][    C0]  ? lockdep_hardirqs_on_prepare+0x27c/0x3d0
[ 3765.408955][    C0]  ? trace_hardirqs_on+0x1c/0x150
[ 3765.413841][    C0]  ? asm_common_interrupt+0x1e/0x40
[ 3765.418905][    C0]  ? strncpy_from_user+0x14c/0x330
[ 3765.423878][    C0]  ? strncpy_from_user+0x6b/0x330
[ 3765.428764][    C0]  ? getname_flags+0x88/0x3e0
[ 3765.433307][    C0]  __x64_sys_rename+0x75/0x90
__x64_sys_rename at fs/namei.c:4504
[ 3765.437848][    C0]  do_syscall_64+0x33/0x40
[ 3765.442129][    C0]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3765.447882][    C0] RIP: 0033:0x7f12b9b759eb
[ 3765.452166][    C0] Code: e8 5a 0a 08 00 85 c0 0f 95 c0 0f b6 c0 f7 d8 5b c3 66 0f 1f 44 00 00 b8 ff ff ff ff 5b c3 90 f3 0f 1e fa b8 52 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 69 e48
[ 3765.471611][    C0] RSP: 002b:00007fff76252538 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
[ 3765.479880][    C0] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f12b9b759eb
[ 3765.487715][    C0] RDX: 000055ea2997f400 RSI: 00007fff76252570 RDI: 000055ea2997f450
[ 3765.495548][    C0] RBP: 00007fff76252570 R08: 0000000000000000 R09: 0000000065732e32
[ 3765.503374][    C0] R10: 0000000000000003 R11: 0000000000000246 R12: 000055ea2996fcf8
[ 3765.511201][    C0] R13: 000055ea2996fcf8 R14: 000055ea277097f0 R15: 0000000000000000
[ 3765.939428][   C14] watchdog: BUG: soft lockup - CPU#14 stuck for 23s! [systemd-udevd:976]
[ 3765.947707][   C14] Modules linked in: acpi_cpufreq(+) ip_tables x_tables sd_mod ahci libahci tg3 bnxt_en megaraid_sas libata firmware_class libphy dm_mirror dm_region_hash dm_log dm_mod
[ 3765.964357][   C14] irq event stamp: 535074
[ 3765.968564][   C14] hardirqs last  enabled at (535073): [<ffffffff82800c42>] asm_sysvec_apic_timer_interrupt+0x12/0x20
[ 3765.979266][   C14] hardirqs last disabled at (535074): [<ffffffff8277e45a>] sysvec_apic_timer_interrupt+0xa/0xa0
[ 3765.989532][   C14] softirqs last  enabled at (535072): [<ffffffff82a0061b>] __do_softirq+0x61b/0x95d
[ 3765.998761][   C14] softirqs last disabled at (535067): [<ffffffff82800ec2>] asm_call_irq_on_stack+0x12/0x20
[ 3766.008590][   C14] CPU: 14 PID: 976 Comm: systemd-udevd Tainted: G             L    5.10.0-rc2-next-20201109+ #2
[ 3766.018851][   C14] Hardware name: Dell Inc. PowerEdge R6415/07YXFK, BIOS 1.9.3 06/25/2019
[ 3766.027130][   C14] RIP: 0010:path_init+0x1dd/0x1380
__seqprop_spinlock_sequence at include/linux/seqlock.h:277
(inlined by) path_init at fs/namei.c:2219
[ 3766.032112][   C14] Code: 03 0f 8e 79 11 00 00 44 8b 3d 5f f0 6e 01 41 f6 c7 01 74 2e 48 b8 00 00 00 00 00 fc ff df 48 89 d1 48 c1 e9 03 48 01 c1 f3 90 <0f> b6 01 84 c0 74 08 3c 03 0f 8e 9a 0d 00 00 44 8b 3a1
[ 3766.051565][   C14] RSP: 0018:ffffc90006bdfa78 EFLAGS: 00000202
[ 3766.057493][   C14] RAX: 0000000000000000 RBX: ffffc90006bdfcc0 RCX: fffffbfff06426b0
[ 3766.065330][   C14] RDX: ffffffff83213580 RSI: 00000000d93ef353 RDI: ffffc90006bdfd00
[ 3766.073163][   C14] RBP: ffffc90006bdfb08 R08: fffffbfff164cb0d R09: fffffbfff164cb0d
[ 3766.080997][   C14] R10: 0000000000000246 R11: fffffbfff164cb0c R12: ffff8881159d0060
[ 3766.088831][   C14] R13: ffffc90006bdfcf8 R14: 0000000000000041 R15: 000000000000039d
[ 3766.096665][   C14] FS:  00007f0c2ec45980(0000) GS:ffff88866dec0000(0000) knlGS:0000000000000000
[ 3766.105454][   C14] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3766.111900][   C14] CR2: 00007f79350ceb84 CR3: 0000000160a84000 CR4: 00000000003506e0
[ 3766.119737][   C14] Call Trace:
[ 3766.122899][   C14]  ? debug_mutex_init+0x31/0x60
[ 3766.127614][   C14]  path_openat+0x154/0x1b00
path_openat at fs/namei.c:3364
[ 3766.131988][   C14]  ? rcu_read_lock_held+0xb0/0xb0
[ 3766.136881][   C14]  ? __lock_acquire+0x1dad/0x3890
[ 3766.141767][   C14]  ? path_parentat.isra.62+0x190/0x190
[ 3766.147090][   C14]  ? rcu_read_lock_sched_held+0x9c/0xd0
[ 3766.152496][   C14]  ? rcu_read_lock_bh_held+0xb0/0xb0
[ 3766.157646][   C14]  do_filp_open+0x171/0x240
[ 3766.162017][   C14]  ? may_open_dev+0xc0/0xc0
[ 3766.166388][   C14]  ? lock_downgrade+0x700/0x700
[ 3766.171104][   C14]  ? rcu_read_unlock+0x40/0x40
[ 3766.175735][   C14]  ? rwlock_bug.part.1+0x90/0x90
[ 3766.180543][   C14]  ? __check_object_size+0x454/0x670
[ 3766.185692][   C14]  ? do_raw_spin_unlock+0x4f/0x250
[ 3766.190668][   C14]  ? __alloc_fd+0x184/0x500
[ 3766.195031][   C14]  do_sys_openat2+0x2db/0x5b0
[ 3766.199576][   C14]  ? memset+0x1f/0x40
[ 3766.203422][   C14]  ? file_open_root+0x200/0x200
[ 3766.208136][   C14]  do_sys_open+0x85/0xd0
[ 3766.212245][   C14]  ? filp_open+0x50/0x50
[ 3766.216353][   C14]  ? syscall_trace_enter.isra.21+0x54/0x1f0
[ 3766.222107][   C14]  do_syscall_64+0x33/0x40
[ 3766.226389][   C14]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3766.232145][   C14] RIP: 0033:0x7f0c2d828552
[ 3766.236426][   C14] Code: 25 00 00 41 00 3d 00 00 41 00 74 4c 48 8d 05 15 50 2d 00 8b 00 85 c0 75 6d 89 f2 b8 01 01 00 00 48 89 fe bf 9c ff ff ff 0f 05 <48> 3d 00 f0 ff ff 0f 87 a2 00 00 00 48 8b 4c 24 28 645
[ 3766.255873][   C14] RSP: 002b:00007ffc65d36000 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
[ 3766.264147][   C14] RAX: ffffffffffffffda RBX: 0000564d81e50770 RCX: 00007f0c2d828552
[ 3766.271982][   C14] RDX: 0000000000080000 RSI: 00007ffc65d36150 RDI: 00000000ffffff9c
[ 3766.279817][   C14] RBP: 0000000000000008 R08: 0000000000000008 R09: 0000000000000001
[ 3766.287651][   C14] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f0c2e733347
[ 3766.295486][   C14] R13: 00007f0c2e733347 R14: 0000000000000001 R15: 0000564d81e2d1b8
[ 3766.469430][   C28] watchdog: BUG: soft lockup - CPU#28 stuck for 22s! [mount:1058]
[ 3766.477105][   C28] Modules linked in: acpi_cpufreq(+) ip_tables x_tables sd_mod ahci libahci tg3 bnxt_en megaraid_sas libata firmware_class libphy dm_mirror dm_region_hash dm_log dm_mod
[ 3766.493753][   C28] irq event stamp: 88756
[ 3766.497868][   C28] hardirqs last  enabled at (88755): [<ffffffff82800c42>] asm_sysvec_apic_timer_interrupt+0x12/0x20
[ 3766.508481][   C28] hardirqs last disabled at (88756): [<ffffffff8277e45a>] sysvec_apic_timer_interrupt+0xa/0xa0
[ 3766.518665][   C28] softirqs last  enabled at (88748): [<ffffffff82a0061b>] __do_softirq+0x61b/0x95d
[ 3766.527805][   C28] softirqs last disabled at (88743): [<ffffffff82800ec2>] asm_call_irq_on_stack+0x12/0x20
[ 3766.537550][   C28] CPU: 28 PID: 1058 Comm: mount Tainted: G             L    5.10.0-rc2-next-20201109+ #2
[ 3766.547210][   C28] Hardware name: Dell Inc. PowerEdge R6415/07YXFK, BIOS 1.9.3 06/25/2019
[ 3766.555482][   C28] RIP: 0010:prepend_path.isra.6+0x349/0xdb0
__seqprop_spinlock_sequence at include/linux/seqlock.h:277
(inlined by) read_seqbegin at include/linux/seqlock.h:838
(inlined by) read_seqbegin_or_lock at include/linux/seqlock.h:1142
(inlined by) read_seqbegin_or_lock at include/linux/seqlock.h:1139
(inlined by) prepend_path at fs/d_path.c:99
[ 3766.561241][   C28] Code: 95 f0 fe ff ff 5a 41 54 9d 41 0f b6 55 00 84 d2 74 09 80 fa 03 0f 8e 75 09 00 00 45 8b 26 41 f6 c4 01 0f 84 5b 05 00 00 f3 90 <41> 0f b6 55 00 84 d2 74 e8 80 fa 03 7f e3 4c 89 f7 4ce
[ 3766.580687][   C28] RSP: 0018:ffffc9000670fa18 EFLAGS: 00000202
[ 3766.586618][   C28] RAX: ffff88812bd7d070 RBX: dffffc0000000000 RCX: 1ffff1102a164dc8
[ 3766.594449][   C28] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81bafabb
[ 3766.602287][   C28] RBP: ffffc9000670fb68 R08: 0000000000000001 R09: ffffffff81bb033d
[ 3766.610118][   C28] R10: ffff8881517d8340 R11: fffffbfff14b86e4 R12: 000000000000039d
[ 3766.617956][   C28] R13: fffffbfff06426b0 R14: ffffffff83213580 R15: ffffc9000670fbc0
[ 3766.625789][   C28] FS:  00007f96bb7a6080(0000) GS:ffff8881b71c0000(0000) knlGS:0000000000000000
[ 3766.634579][   C28] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3766.641026][   C28] CR2: 00007f96ba7343f0 CR3: 0000000146c76000 CR4: 00000000003506e0
[ 3766.648859][   C28] Call Trace:
[ 3766.652016][   C28]  ? dentry_path_raw+0x10/0x10
[ 3766.656645][   C28]  ? rcu_read_unlock+0x40/0x40
[ 3766.661276][   C28]  ? memcpy+0x38/0x60
[ 3766.665128][   C28]  d_path+0x3fd/0x660
[ 3766.668976][   C28]  ? prepend_path.isra.6+0xdb0/0xdb0
[ 3766.674129][   C28]  ? __alloc_pages_nodemask+0x650/0x760
[ 3766.679543][   C28]  ? __alloc_pages_slowpath.constprop.112+0x2120/0x2120
[ 3766.686345][   C28]  mnt_warn_timestamp_expiry+0x25a/0x270
mnt_warn_timestamp_expiry at fs/namespace.c:2555 (discriminator 1)
[ 3766.691839][   C28]  ? get_mountpoint+0x370/0x370
[ 3766.696554][   C28]  ? do_raw_spin_unlock+0x4f/0x250
[ 3766.701536][   C28]  ? _raw_spin_unlock+0x1a/0x30
[ 3766.706253][   C28]  ? vfs_create_mount+0x371/0x4a0
[ 3766.711150][   C28]  path_mount+0xe6b/0x1720
do_new_mount_fc at fs/namespace.c:2839
(inlined by) do_new_mount at fs/namespace.c:2898
(inlined by) path_mount at fs/namespace.c:3227
[ 3766.715438][   C28]  ? finish_automount+0x750/0x750
[ 3766.720328][   C28]  ? getname_flags+0x88/0x3e0
[ 3766.724877][   C28]  do_mount+0xc6/0xe0
[ 3766.728726][   C28]  ? path_mount+0x1720/0x1720
[ 3766.733275][   C28]  ? _copy_from_user+0xab/0xf0
[ 3766.737906][   C28]  ? memdup_user+0x4f/0x80
[ 3766.742193][   C28]  __x64_sys_mount+0x15d/0x1b0
[ 3766.746828][   C28]  do_syscall_64+0x33/0x40
[ 3766.751111][   C28]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3914.819439][   C36] watchdog: BUG: soft lockup - CPU#36 stuck for 22s! [systemd-journal:902]
[ 3914.827884][   C36] Modules linked in: acpi_cpufreq(+) ip_tables x_tables sd_mod ahci libahci tg3 bnxt_en megaraid_sas libata firmware_class libphy dm_mirror dm_region_hash dm_log dm_mod
[ 3914.844543][   C36] irq event stamp: 196688
[ 3914.848748][   C36] hardirqs last  enabled at (196687): [<ffffffff82800c42>] asm_sysvec_apic_timer_interrupt+0x12/0x20
[ 3914.859450][   C36] hardirqs last disabled at (196688): [<ffffffff8277e45a>] sysvec_apic_timer_interrupt+0xa/0xa0
[ 3914.869709][   C36] softirqs last  enabled at (196684): [<ffffffff82a0061b>] __do_softirq+0x61b/0x95d
[ 3914.878930][   C36] softirqs last disabled at (196679): [<ffffffff82800ec2>] asm_call_irq_on_stack+0x12/0x20
[ 3914.888759][   C36] CPU: 36 PID: 902 Comm: systemd-journal Tainted: G             L    5.10.0-rc2-next-20201109+ #2
[ 3914.899195][   C36] Hardware name: Dell Inc. PowerEdge R6415/07YXFK, BIOS 1.9.3 06/25/2019
[ 3914.907471][   C36] RIP: 0010:path_init+0x1f3/0x1380
[ 3914.912448][   C36] Code: 00 00 00 00 00 fc ff df 48 89 d1 48 c1 e9 03 48 01 c1 f3 90 0f b6 01 84 c0 74 08 3c 03 0f 8e 9a 0d 00 00 44 8b 3a 41 f6 c7 01 <75> e6 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 44 48 89a
[ 3914.931901][   C36] RSP: 0018:ffffc900065dfc08 EFLAGS: 00000202
[ 3914.937837][   C36] RAX: 0000000000000000 RBX: ffffc900065dfd40 RCX: fffffbfff06426b0
[ 3914.945675][   C36] RDX: ffffffff83213580 RSI: 00000000d93ef353 RDI: ffffc900065dfd80
[ 3914.953514][   C36] RBP: ffffc900065dfc98 R08: fffffbfff164cb0d R09: fffffbfff164cb0d
[ 3914.961349][   C36] R10: 0000000000000246 R11: fffffbfff164cb0c R12: ffff8881159d5920
[ 3914.969186][   C36] R13: ffffc900065dfd78 R14: 0000000000000041 R15: 000000000000039d
[ 3914.977028][   C36] FS:  00007fc5f95f9980(0000) GS:ffff8881b7240000(0000) knlGS:0000000000000000
[ 3914.985814][   C36] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3914.992262][   C36] CR2: 000055ea2994ba42 CR3: 000000013702a000 CR4: 00000000003506e0
[ 3915.000097][   C36] Call Trace:
[ 3915.003257][   C36]  path_lookupat.isra.61+0x20/0x440
[ 3915.008323][   C36]  ? find_held_lock+0x33/0x1c0
[ 3915.012954][   C36]  filename_lookup.part.73+0x15c/0x290
[ 3915.018283][   C36]  ? __might_fault+0xb5/0x160
[ 3915.022831][   C36]  ? do_symlinkat+0x190/0x190
[ 3915.027375][   C36]  ? strncpy_from_user+0x6b/0x330
[ 3915.032268][   C36]  ? getname_flags+0x88/0x3e0
[ 3915.036809][   C36]  ? kmem_cache_alloc+0x244/0x270
[ 3915.041701][   C36]  do_faccessat+0xc0/0x5a0
[ 3915.045987][   C36]  ? stream_open+0x60/0x60
[ 3915.050269][   C36]  do_syscall_64+0x33/0x40
[ 3915.054552][   C36]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3915.060306][   C36] RIP: 0033:0x7fc5f862697b
[ 3915.064590][   C36] Code: 77 05 c3 0f 1f 40 00 48 8b 15 09 f5 2c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff c3 0f 1f 40 00 f3 0f 1e fa b8 15 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 d9 f48
[ 3915.084044][   C36] RSP: 002b:00007ffdefba1198 EFLAGS: 00000246 ORIG_RAX: 0000000000000015
[ 3915.092322][   C36] RAX: ffffffffffffffda RBX: 00007ffdefba3cf0 RCX: 00007fc5f862697b
[ 3915.100163][   C36] RDX: 00007fc5f91032e8 RSI: 0000000000000000 RDI: 0000556a2401c0d0
[ 3915.107996][   C36] RBP: 00007ffdefba11e0 R08: 0000000000000000 R09: 0000000000000000
[ 3915.115832][   C36] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[ 3915.123667][   C36] R13: 0000000000000000 R14: 0000000000000009 R15: 0000556a254de950
[ 3917.159439][    C0] watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [systemd:1]
[ 3917.166926][    C0] Modules linked in: acpi_cpufreq(+) ip_tables x_tables sd_mod ahci libahci tg3 bnxt_en megaraid_sas libata firmware_class libphy dm_mirror dm_region_hash dm_log dm_mod
[ 3917.183572][    C0] irq event stamp: 94238206
[ 3917.187944][    C0] hardirqs last  enabled at (94238205): [<ffffffff82800b9e>] asm_common_interrupt+0x1e/0x40
[ 3917.197857][    C0] hardirqs last disabled at (94238206): [<ffffffff8277e45a>] sysvec_apic_timer_interrupt+0xa/0xa0
[ 3917.208289][    C0] softirqs last  enabled at (94219940): [<ffffffff82a0061b>] __do_softirq+0x61b/0x95d
[ 3917.217685][    C0] softirqs last disabled at (94219881): [<ffffffff82800ec2>] asm_call_irq_on_stack+0x12/0x20
[ 3917.227688][    C0] CPU: 0 PID: 1 Comm: systemd Tainted: G             L    5.10.0-rc2-next-20201109+ #2
[ 3917.237167][    C0] Hardware name: Dell Inc. PowerEdge R6415/07YXFK, BIOS 1.9.3 06/25/2019
[ 3917.245437][    C0] RIP: 0010:lock_acquire+0x21b/0x820
[ 3917.250585][    C0] Code: fc ff df 48 01 c3 c7 03 00 00 00 00 c7 43 08 00 00 00 00 48 8b 84 24 90 00 00 00 65 48 33 04 25 28 00 00 00 0f 85 1a 05 00 00 <48> 81 c4 98 00 00 00 5b 5d 41 5c 41 5d 41 5e 41 5f c3c
[ 3917.270033][    C0] RSP: 0018:ffffc9000006f9f8 EFLAGS: 00000246
[ 3917.275959][    C0] RAX: 0000000000000000 RBX: fffff5200000df42 RCX: 1ffff9200000df28
[ 3917.283795][    C0] RDX: 1ffff11020645769 RSI: 00000000ffffffff RDI: 0000000000000001
[ 3917.291627][    C0] RBP: 0000000000000001 R08: fffffbfff164cb10 R09: fffffbfff164cb10
[ 3917.299463][    C0] R10: 0000000000000246 R11: fffffbfff164cb0f R12: ffff88812be555b0
[ 3917.307297][    C0] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 3917.315133][    C0] FS:  00007f12bb8c59c0(0000) GS:ffff8881b7000000(0000) knlGS:0000000000000000
[ 3917.323921][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3917.330368][    C0] CR2: 00007f0c2d828fd0 CR3: 000000011868a000 CR4: 00000000003506f0
[ 3917.338202][    C0] Call Trace:
[ 3917.341360][    C0]  ? rcu_read_unlock+0x40/0x40
[ 3917.345987][    C0]  __d_move+0x2a2/0x16f0
[ 3917.350096][    C0]  ? d_move+0x47/0x70
[ 3917.353944][    C0]  ? _raw_spin_unlock+0x1a/0x30
[ 3917.358656][    C0]  d_move+0x47/0x70
[ 3917.362330][    C0]  ? vfs_rename+0x9ac/0x1270
[ 3917.366786][    C0]  vfs_rename+0x9ac/0x1270
[ 3917.371068][    C0]  ? vfs_link+0x830/0x830
[ 3917.375261][    C0]  ? do_renameat2+0x58c/0x930
[ 3917.379804][    C0]  do_renameat2+0x58c/0x930
[ 3917.384173][    C0]  ? __ia32_sys_link+0x80/0x80
[ 3917.388800][    C0]  ? rcu_read_lock_bh_held+0xb0/0xb0
[ 3917.393948][    C0]  ? rcu_read_lock_sched_held+0x9c/0xd0
[ 3917.399354][    C0]  ? rcu_read_lock_bh_held+0xb0/0xb0
[ 3917.404503][    C0]  ? lockdep_hardirqs_on_prepare+0x27c/0x3d0
[ 3917.410346][    C0]  ? trace_hardirqs_on+0x1c/0x150
[ 3917.415234][    C0]  ? asm_common_interrupt+0x1e/0x40
[ 3917.420294][    C0]  ? strncpy_from_user+0x14c/0x330
[ 3917.425269][    C0]  ? strncpy_from_user+0x6b/0x330
[ 3917.430158][    C0]  ? getname_flags+0x88/0x3e0
[ 3917.434699][    C0]  __x64_sys_rename+0x75/0x90
[ 3917.439239][    C0]  do_syscall_64+0x33/0x40
[ 3917.443520][    C0]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 3917.449274][    C0] RIP: 0033:0x7f12b9b759eb
[ 3917.453557][    C0] Code: e8 5a 0a 08 00 85 c0 0f 95 c0 0f b6 c0 f7 d8 5b c3 66 0f 1f 44 00 00 b8 ff ff ff ff 5b c3 90 f3 0f 1e fa b8 52 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 69 e48
[ 3917.473003][    C0] RSP: 002b:00007fff76252538 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
[ 3917.481272][    C0] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f12b9b759eb
[ 3917.489107][    C0] RDX: 000055ea2997f400 RSI: 00007fff76252570 RDI: 000055ea2997f450
[ 3917.496942][    C0] RBP: 00007fff76252570 R08: 0000000000000000 R09: 0000000065732e32
[ 3917.504776][    C0] R10: 0000000000000003 R11: 0000000000000246 R12: 000055ea2996fcf8
[ 3917.512610][    C0] R13: 000055ea2996fcf8 R14: 000055ea277097f0 R15: 0000000000000000


[ 3634.443982][   C37] NMI backtrace for cpu 37
[ 3634.443984][   C37] CPU: 37 PID: 906 Comm: udevadm Tainted: G             L    5.10.0-rc2-next-20201109+ #3
[ 3634.443986][   C37] Hardware name: Dell Inc. PowerEdge R6415/07YXFK, BIOS 1.9.3 06/25/2019
[ 3634.443987][   C37] RIP: 0010:io_serial_in+0x5c/0x90
[ 3634.443989][   C37] Code: 48 8d 7b 40 0f b6 8b f1 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 d3 e6 80 3c 02 00 75 1e 03 73 40 89 f2 ec <48> 83 c4 08 0f b6 c0 5b c3 89 74 24 04 e8 d2 90 81 ff4
[ 3634.443991][   C37] RSP: 0018:ffffc90004a38780 EFLAGS: 00000002
[ 3634.443993][   C37] RAX: dffffc0000000000 RBX: ffffffffa0b1c988 RCX: 0000000000000000
[ 3634.443995][   C37] RDX: 00000000000002fd RSI: 00000000000002fd RDI: ffffffffa0b1c9c8
[ 3634.443996][   C37] RBP: 0000000000000020 R08: 0000000000000004 R09: fffff520009470f3
[ 3634.443998][   C37] R10: 0000000000000003 R11: fffff520009470f3 R12: fffffbfff4163984
[ 3634.443999][   C37] R13: fffffbfff416393b R14: ffffffffa0b1c9d8 R15: ffffffffa0b1c988
[ 3634.444001][   C37] FS:  00007f6947084980(0000) GS:ffff88866e440000(0000) knlGS:0000000000000000
[ 3634.444002][   C37] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3634.444004][   C37] CR2: 00007fd220b94816 CR3: 000000015371e000 CR4: 00000000003506e0
[ 3634.444005][   C37] Call Trace:
[ 3634.444006][   C37]  <IRQ>
[ 3634.444007][   C37]  wait_for_xmitr+0x7c/0x1b0
[ 3634.444008][   C37]  ? wait_for_xmitr+0x1b0/0x1b0
[ 3634.444010][   C37]  serial8250_console_putchar+0x11/0x50
[ 3634.444011][   C37]  uart_console_write+0x39/0xc0
[ 3634.444012][   C37]  serial8250_console_write+0x74c/0x8a0
[ 3634.444013][   C37]  ? serial8250_start_tx+0x810/0x810
[ 3634.444015][   C37]  ? rcu_read_unlock+0x40/0x40
[ 3634.444016][   C37]  ? do_raw_spin_lock+0x121/0x290
[ 3634.444017][   C37]  ? rwlock_bug.part.1+0x90/0x90
[ 3634.444018][   C37]  ? prb_read_valid+0x61/0x90
[ 3634.444020][   C37]  ? prb_final_commit+0x10/0x10
[ 3634.444021][   C37]  console_unlock+0x721/0xa20
[ 3634.444022][   C37]  ? do_syslog.part.22+0x5d0/0x5d0
[ 3634.444023][   C37]  ? lock_acquire+0x1c8/0x820
[ 3634.444024][   C37]  ? lock_downgrade+0x700/0x700
[ 3634.444026][   C37]  vprintk_emit+0x201/0x2c0
[ 3634.444027][   C37]  printk+0x9a/0xc0
[ 3634.444028][   C37]  ? record_print_text.cold.38+0x11/0x11
[ 3634.444029][   C37]  ? __module_text_address+0xe/0x140
[ 3634.444031][   C37]  ? nmi_cpu_backtrace.cold.10+0x18/0xc5
[ 3634.444032][   C37]  show_trace_log_lvl+0x228/0x2bb
[ 3634.444033][   C37]  ? nmi_cpu_backtrace.cold.10+0x18/0xc5
[ 3634.444035][   C37]  ? nmi_cpu_backtrace.cold.10+0x18/0xc5
[ 3634.444036][   C37]  ? lapic_can_unplug_cpu+0x11/0x70
[ 3634.444037][   C37]  dump_stack+0x99/0xcb
[ 3634.444038][   C37]  nmi_cpu_backtrace.cold.10+0x18/0xc5
[ 3634.444040][   C37]  ? lapic_can_unplug_cpu+0x70/0x70
[ 3634.444041][   C37]  nmi_trigger_cpumask_backtrace+0x232/0x2a0
[ 3634.444042][   C37]  rcu_dump_cpu_stacks+0x1ad/0x1f9
[ 3634.444043][   C37]  rcu_sched_clock_irq.cold.90+0x4f7/0x968
[ 3634.444045][   C37]  ? tick_sched_do_timer+0x140/0x140
[ 3634.444046][   C37]  update_process_times+0x75/0xb0
[ 3634.444047][   C37]  tick_sched_timer+0xc8/0xf0
[ 3634.444048][   C37]  __hrtimer_run_queues+0x529/0xbb0
[ 3634.444050][   C37]  ? enqueue_hrtimer+0x330/0x330
[ 3634.444051][   C37]  ? ktime_get_update_offsets_now+0xd6/0x2b0
[ 3634.444052][   C37]  hrtimer_interrupt+0x2c2/0x750
[ 3634.444054][   C37]  __sysvec_apic_timer_interrupt+0x13c/0x520
[ 3634.444055][   C37]  asm_call_irq_on_stack+0x12/0x20
[ 3634.444056][   C37]  </IRQ>
[ 3634.444057][   C37]  sysvec_apic_timer_interrupt+0x85/0xa0
[ 3634.444059][   C37]  asm_sysvec_apic_timer_interrupt+0x12/0x20


