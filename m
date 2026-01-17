Return-Path: <kvm+bounces-68438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 90967D3919B
	for <lists+kvm@lfdr.de>; Sun, 18 Jan 2026 00:18:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D2EE63024896
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 23:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0786D2EDD69;
	Sat, 17 Jan 2026 23:18:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12B0500941
	for <kvm@vger.kernel.org>; Sat, 17 Jan 2026 23:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768691904; cv=none; b=RAv7jOD/tS3s9bAHO5Dl6vm/NwR9bLXN1j/TFUvamX0jfAuUB6fvOssR1oU/jtWM00lyP181n34mVS7cKhh+K5HiLn3X2I6WRCrM4jInKrPYt1wV2bS9KtvJZLtahm+Htcf1BjfxNCwDub9peGe+7ndEBhNWSBS0jN0MiHdN2cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768691904; c=relaxed/simple;
	bh=7Xgg4ELCQKIpuOqeMv0IlD4iOkwbFRzMXpH+Awtulok=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=C39pO/XvRG3IMrDYus5Y5h+Q23YdVtBdMC29iimFZzw4GFImXdKONzyxSGwzgaSRPGBCM4lx1mVmp6KUmyA39FcWSAXNk0H3Uf0295426autQUmNX0uEDiQThQ/Dguro0M+7fEpYjYkl1+W1eoGTXZCvrb5ZLXrV9PzO7OiWaTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-66108d1cd11so9518647eaf.2
        for <kvm@vger.kernel.org>; Sat, 17 Jan 2026 15:18:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768691901; x=1769296701;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qi5i7Rwzamkmas2rrjeqvonnq94KruIOaOyrA6w7fS4=;
        b=K5/okne0rXYUPCv6TWijkE3NSGHTu3p69b77J29m7Ign8vDj5bfvFGR1MePEo442AH
         RM+ziz0/FyJFsRrP1Yvi9EIbro/BBv2BNb8fAk42DTuqh7VEz9ZCDVLKIn2OuqsP685Y
         pZGzLQqLyZiHDNic8LqNURHrO6nspFefpdN1jE5tKt6vZfrdzYfxbX5u86e5hztlWheR
         GeDOwTs2VN0Z13Ey2V7IY7ejaLjxzgQFAEtzi5I12ZOXGkYtiKGssvv9ko1shpCwiXmR
         vhiBWjEvxivxLZl2bAOS1ZYL9e1+9VDE4JJiGltMikgt/IMc7M353yd6QP/VWC8BnF8l
         Q0uw==
X-Forwarded-Encrypted: i=1; AJvYcCUCdtXAv5WI9xagAyf2HBsTiE0ejQMDaIubaQd02FnI/n7lg5er2gTgeehBEwWf9/mKAlk=@vger.kernel.org
X-Gm-Message-State: AOJu0YylMb3g5k0tOodpj+ju1Spl2OZqbJNYcw5KZcTzP9/rOgKWCcFk
	ZGDp/nosHwzMC5WRLo8PCHg1/DsVziXL7uWLu7mMY7hywx6s4mCdGBGtxTCfdo5X1Y/2CZKlyjF
	RyK/LMUG9ZUAkrG2bPLIKOuGMFCvzXRRKSMbfCBZ7GBw6LeHay8RCwdV5dx4=
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:60e:b0:65f:6bcd:e40 with SMTP id
 006d021491bc7-66117a15b7amr2777345eaf.74.1768691901672; Sat, 17 Jan 2026
 15:18:21 -0800 (PST)
Date: Sat, 17 Jan 2026 15:18:21 -0800
In-Reply-To: <66e96979.050a0220.252d9a.000a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696c18bd.050a0220.3390f1.0011.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in sys_execve (6)
From: syzbot <syzbot+8bb3e2bee8a429cc76dd@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, bp@alien8.de, 
	davem@davemloft.net, hpa@zytor.com, jannh@google.com, jhs@mojatatu.com, 
	jiri@resnulli.us, kvm@vger.kernel.org, liam.howlett@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mingo@redhat.com, netdev@vger.kernel.org, pbonzini@redhat.com, 
	pfalcato@suse.de, rkrcmar@redhat.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, vbabka@suse.cz, vinicius.gomes@intel.com, x86@kernel.org, 
	xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    a74c7a58ca2c net: freescale: ucc_geth: Return early when T..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16fdf39a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=323fe5bdde2384a5
dashboard link: https://syzkaller.appspot.com/bug?extid=8bb3e2bee8a429cc76dd
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13d8639a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=154863fa580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/50a3e60a3908/disk-a74c7a58.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ee6a6a2a52e4/vmlinux-a74c7a58.xz
kernel image: https://storage.googleapis.com/syzbot-assets/033a07d12b3e/bzImage-a74c7a58.xz

The issue was bisected to:

commit 5a781ccbd19e4664babcbe4b4ead7aa2b9283d22
Author: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date:   Sat Sep 29 00:59:43 2018 +0000

    tc: Add support for configuring the taprio scheduler

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10311900580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12311900580000
console output: https://syzkaller.appspot.com/x/log.txt?x=14311900580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8bb3e2bee8a429cc76dd@syzkaller.appspotmail.com
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	1-...!: (1 GPs behind) idle=b674/1/0x4000000000000000 softirq=16193/16205 fqs=2
rcu: 	(detected by 0, t=10502 jiffies, g=13757, q=3905 ncpus=2)
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 6128 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:rcu_is_watching_curr_cpu include/linux/context_tracking.h:128 [inline]
RIP: 0010:rcu_is_watching+0x3a/0xb0 kernel/rcu/tree.c:751
Code: e8 bb 0d b3 09 89 c3 83 f8 08 73 65 49 bf 00 00 00 00 00 fc ff df 4c 8d 34 dd d0 0d 9b 8d 4c 89 f0 48 c1 e8 03 42 80 3c 38 00 <74> 08 4c 89 f7 e8 8c 1d 80 00 48 c7 c3 d8 56 81 92 49 03 1e 48 89
RSP: 0018:ffffc90000a08c70 EFLAGS: 00000046
RAX: 1ffffffff1b361bb RBX: 0000000000000001 RCX: 0000000000010002
RDX: 0000000000000000 RSI: ffffffff8bc086c0 RDI: ffffffff8bc08680
RBP: ffffffff81ae6da2 R08: 0000000000000001 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff1f045cf R12: 0000000000000000
R13: ffff8880b8728258 R14: ffffffff8d9b0dd8 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff888125f1e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9426807ff8 CR3: 0000000077a18000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 trace_lock_acquire include/trace/events/lock.h:24 [inline]
 lock_acquire+0x5f/0x340 kernel/locking/lockdep.c:5831
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
 _raw_spin_lock_irq+0x3d/0x50 kernel/locking/spinlock.c:170
 __run_hrtimer kernel/time/hrtimer.c:1781 [inline]
 __hrtimer_run_queues+0x5e2/0xc30 kernel/time/hrtimer.c:1841
 hrtimer_interrupt+0x45b/0xaa0 kernel/time/hrtimer.c:1903
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1045 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x3e0 arch/x86/kernel/apic/apic.c:1062
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1056
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:deref_stack_reg+0x3/0x230 arch/x86/kernel/unwind_orc.c:418
Code: e8 12 f8 b2 00 48 8b 4c 24 18 e9 f2 fe ff ff 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 41 57 <41> 56 41 55 41 54 53 48 83 ec 20 48 89 54 24 18 49 89 f0 49 89 ff
RSP: 0018:ffffc90002f16e00 EFLAGS: 00000283
RAX: fffffffffffffff0 RBX: ffffffff9025420e RCX: 0000000000000000
RDX: ffffc90002f16f28 RSI: ffffc90002f17ad0 RDI: ffffc90002f16ee8
RBP: dffffc0000000000 R08: ffffc90002f16f47 R09: 0000000000000000
R10: ffffc90002f16f38 R11: fffff520005e2de9 R12: ffffc90002f16f38
R13: 1ffff920005e2ddf R14: ffffc90002f16ee8 R15: 1ffffffff204a842
 unwind_next_frame+0x18cc/0x23d0 arch/x86/kernel/unwind_orc.c:-1
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4953 [inline]
 slab_alloc_node mm/slub.c:5263 [inline]
 kmem_cache_alloc_noprof+0x37d/0x710 mm/slub.c:5270
 mt_alloc_one lib/maple_tree.c:174 [inline]
 mas_alloc_nodes+0x291/0x350 lib/maple_tree.c:1110
 mas_preallocate+0x2e0/0x670 lib/maple_tree.c:5194
 vma_iter_prealloc mm/vma.h:502 [inline]
 vma_shrink+0x18d/0x510 mm/vma.c:1200
 relocate_vma_down+0x4d4/0x4f0 mm/vma_exec.c:91
 setup_arg_pages+0x5cf/0xa90 fs/exec.c:690
 load_elf_binary+0xba4/0x2740 fs/binfmt_elf.c:1028
 search_binary_handler fs/exec.c:1669 [inline]
 exec_binprm fs/exec.c:1701 [inline]
 bprm_execve+0x92e/0x1400 fs/exec.c:1753
 do_execveat_common+0x510/0x6a0 fs/exec.c:1859
 do_execve fs/exec.c:1933 [inline]
 __do_sys_execve fs/exec.c:2009 [inline]
 __se_sys_execve fs/exec.c:2004 [inline]
 __x64_sys_execve+0x94/0xb0 fs/exec.c:2004
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f94259c2e17
Code: Unable to access opcode bytes at 0x7f94259c2ded.
RSP: 002b:00007f9426807df8 EFLAGS: 00000206 ORIG_RAX: 000000000000003b
RAX: ffffffffffffffda RBX: 00007ffd48e33ef5 RCX: 00007f94259c2e17
RDX: 00007ffd48e32ba0 RSI: 00007ffd48e32de0 RDI: 00007ffd48e33ef5
RBP: 00007f9426807e70 R08: 00007f9426807f20 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000206 R12: 00007ffd48e32de0
R13: 00007ffd48e32ba0 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
rcu: rcu_preempt kthread starved for 10495 jiffies! g13757 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27480 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x149b/0x4fd0 kernel/sched/core.c:6863
 __schedule_loop kernel/sched/core.c:6945 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6960
 schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x510/0xa50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 0 UID: 0 PID: 5203 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:csd_lock_wait kernel/smp.c:342 [inline]
RIP: 0010:smp_call_function_many_cond+0xcc5/0x1260 kernel/smp.c:877
Code: 45 8b 2c 24 44 89 ee 83 e6 01 31 ff e8 d4 97 0b 00 41 83 e5 01 49 bd 00 00 00 00 00 fc ff df 75 07 e8 7f 93 0b 00 eb 38 f3 90 <42> 0f b6 04 2b 84 c0 75 11 41 f7 04 24 01 00 00 00 74 1e e8 63 93
RSP: 0000:ffffc90003057820 EFLAGS: 00000293
RAX: ffffffff81b5654d RBX: 1ffff110170e8129 RCX: ffff88807d153d00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc90003057950 R08: ffffffff8f822e77 R09: 1ffffffff1f045ce
R10: dffffc0000000000 R11: fffffbfff1f045cf R12: ffff8880b8740948
R13: dffffc0000000000 R14: ffff8880b863bb00 R15: 0000000000000001
FS:  00007f6e0f393880(0000) GS:ffff888125e1e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055ec54628550 CR3: 000000007d7b8000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 on_each_cpu_cond_mask+0x3f/0x80 kernel/smp.c:1043
 __flush_tlb_multi arch/x86/include/asm/paravirt.h:91 [inline]
 flush_tlb_multi arch/x86/mm/tlb.c:1382 [inline]
 flush_tlb_mm_range+0x60a/0x1170 arch/x86/mm/tlb.c:1472
 flush_tlb_page arch/x86/include/asm/tlbflush.h:324 [inline]
 ptep_clear_flush+0x120/0x170 mm/pgtable-generic.c:103
 wp_page_copy mm/memory.c:3785 [inline]
 do_wp_page+0x1bb1/0x5810 mm/memory.c:4180
 handle_pte_fault mm/memory.c:6289 [inline]
 __handle_mm_fault mm/memory.c:6411 [inline]
 handle_mm_fault+0x14c5/0x32b0 mm/memory.c:6580
 do_user_addr_fault+0xa7c/0x1380 arch/x86/mm/fault.c:1336
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x71/0xd0 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7f6e0ecb5dfe
Code: 00 00 66 0f ef c0 41 0f 11 44 24 20 49 89 54 24 10 49 89 74 24 18 4c 89 66 10 4c 89 62 18 48 89 c2 48 83 ca 01 49 89 54 24 08 <49> 89 04 04 48 83 c4 10 5b 41 5c 41 5d c3 0f 1f 40 00 48 89 cf 48
RSP: 002b:00007fff1a84f050 EFLAGS: 00010206
RAX: 0000000000002a20 RBX: 0000000000000740 RCX: 000055ec54627e10
RDX: 0000000000002a21 RSI: 00007f6e0edf1b20 RDI: 000055ec54627e10
RBP: 00007f6e0edf1ac0 R08: 0000000000000740 R09: 0000000000000010
R10: 000055ec24e255e0 R11: 0000000000000004 R12: 000055ec54625b30
R13: 00007f6e0edf1ac0 R14: 0000000000000740 R15: 00007f6e0edf1ac0
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

