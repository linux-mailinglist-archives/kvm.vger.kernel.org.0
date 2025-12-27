Return-Path: <kvm+bounces-66717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 445A4CDF3B1
	for <lists+kvm@lfdr.de>; Sat, 27 Dec 2025 04:34:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 705D130047AE
	for <lists+kvm@lfdr.de>; Sat, 27 Dec 2025 03:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E5AF1FA15E;
	Sat, 27 Dec 2025 03:34:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB583149C7B
	for <kvm@vger.kernel.org>; Sat, 27 Dec 2025 03:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766806461; cv=none; b=ur/KkhLjovIvZzfatxvvLqN9k0b5Ju8Fw7VimpOTZFJ2TXfzwFBmnu51yIcLZjfR5CHI7DYApR7Ze9p/fNgyJ51W32pBrmBxmLJjwXIKgZubht3La2LO+abNgulWW7NNCJsdP4x+UR+TBQdlnS4SAjPuRy83RbnVxalaSL8S+AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766806461; c=relaxed/simple;
	bh=zOUZ1c2nus2HYLnprfZfqbhd51NzwznzDB/uYBdbdrU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KYysBqAPehjCDriiG4NYCAMdiQHB89zY9LxUz54GBsW1A9A4A3YsbPnqhzHU8NrntDRYUYJT7ZRNhMqyGIZm6ayH8L62y4yLHJZFcL9XJM9h72+SxUJo1idZzEwRwpIOTjvHcW3Y+t6fQFB3WvuBiJiR0jyvG1aki6YWHVd2X2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-65744e10b91so7182377eaf.0
        for <kvm@vger.kernel.org>; Fri, 26 Dec 2025 19:34:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766806458; x=1767411258;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qV4uIuAuq6+00Zqi/Epd/WOigX7Wyk+d7MDr4lMw3yw=;
        b=jzmRXhGxL5Qlue//9BqQquX2FWReAfSMmuCArv6Qsfo5puTywhU3s60bPZbl4IuHJE
         gc+O/KJJJarl95TQBtnZDAlofPOU5cH0cY5xkwlZmCGkVoWZhR77hTrTnx1FdSWSyAZO
         nGa4v6yABXjn1WHTkhjGPHI/mPCEAXRs+eFo/5MCG4GViqgZngldh7mWxhwEqKYLbxtP
         gPfURLgb4jyGJRrY/uNeh5GfLHEF40VEzqcLiuHN9ZGS1KwmA/wrms+wr1tgnY8oJumd
         HBgEKJuDQqPFDFzriajuyFUzFnbmRw87OtUZ6AM5gy6ZwISNn5dDOLrad4aYqnDyQtX1
         5Feg==
X-Forwarded-Encrypted: i=1; AJvYcCU723/mKeMMKI/mBiM+/UCqlm2ykslHl5vgjrafxWLlHrpv7bWaG4PA3kav0BjhfTxJjAQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxacVhbNnUwVViymSqEK3h/dyhaCVQLNzbViuKwFMcz3kb7SvZ6
	mnTAt1LvgQfiNj4AYUNI+UY1Tlii8NVQyRS2xwu0p8DyA3eLU53QW/wwJn6Tv6yl9GpNFiyq5xi
	HZ5lJCANF3sgvqXQVVp2Wj0UcS7WrKEbqRjKUumAzvU9oTJGL4J54oyiIZkk=
X-Google-Smtp-Source: AGHT+IFvyb7lLiE+aj953uPrDHTsTysuMXseW+3acCuIbHcwRRHfGUed2WFuEvZHNS+kZ2CDzsXAh++53+4KGRGzfbVECTstnLHm
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:b147:0:b0:659:9a49:90bb with SMTP id
 006d021491bc7-65d0ea9ee61mr7280665eaf.58.1766806458672; Fri, 26 Dec 2025
 19:34:18 -0800 (PST)
Date: Fri, 26 Dec 2025 19:34:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694f53ba.050a0220.35954c.0084.GAE@google.com>
Subject: [syzbot] [kvm?] [kvm-x86?] INFO: rcu detected stall in kvm_vcpu_ioctl (4)
From: syzbot <syzbot+3d5461510f8dc4adfe30@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, vkuznets@redhat.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cc3aa43b44bd Add linux-next specific files for 20251219
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1252109a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f7a09bf3b9133d9d
dashboard link: https://syzkaller.appspot.com/bug?extid=3d5461510f8dc4adfe30
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14eb1022580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13cc18fc580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b1b23d9783ee/disk-cc3aa43b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/07451939cf74/vmlinux-cc3aa43b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e5ddf385746f/bzImage-cc3aa43b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3d5461510f8dc4adfe30@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	(detected by 1, t=10502 jiffies, g=14269, q=1142 ncpus=2)
rcu: All QSes seen, last rcu_preempt kthread activity 10500 (4294965239-4294954739), jiffies_till_next_fqs=1, root ->qsmask 0x0
rcu: rcu_preempt kthread starved for 10500 jiffies! g14269 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27128 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5258 [inline]
 __schedule+0x150e/0x5070 kernel/sched/core.c:6866
 __schedule_loop kernel/sched/core.c:6948 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6963
 schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 6253 Comm: syz.1.63 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:_raw_spin_unlock_irqrestore+0x4b/0x110 kernel/locking/spinlock.c:193
Code: fb 60 5a 07 48 89 44 24 48 48 c7 04 24 b3 8a b5 41 48 c7 44 24 08 96 3d b2 8d 48 c7 44 24 10 00 df 69 8b 49 89 e7 49 c1 ef 03 <48> b8 f1 f1 f1 f1 00 f3 f3 f3 49 bc 00 00 00 00 00 fc ff df 4b 89
RSP: 0018:ffffc90000007ca0 EFLAGS: 00000802
RAX: 5de15cb931505900 RBX: 0000000000000806 RCX: ffff88802eff1e80
RDX: 0000000000010000 RSI: 0000000000000806 RDI: ffff8880b8628240
RBP: ffffc90000007d30 R08: ffffffff8fc3d077 R09: 1ffffffff1f87a0e
R10: dffffc0000000000 R11: fffffbfff1f87a0f R12: ffff888078156180
R13: dffffc0000000000 R14: ffff8880b8628240 R15: 1ffff92000000f94
FS:  00007f635365c6c0(0000) GS:ffff8881259dc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b31363fff CR3: 000000004c992000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 __run_hrtimer kernel/time/hrtimer.c:1773 [inline]
 __hrtimer_run_queues+0x408/0xc30 kernel/time/hrtimer.c:1841
 hrtimer_interrupt+0x45b/0xaa0 kernel/time/hrtimer.c:1903
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1045 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x3e0 arch/x86/kernel/apic/apic.c:1062
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1056
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0xa8/0x110 kernel/locking/spinlock.c:194
Code: 74 05 e8 0b f4 5f f6 48 c7 44 24 20 00 00 00 00 9c 8f 44 24 20 f6 44 24 21 02 75 4f f7 c3 00 02 00 00 74 01 fb bf 01 00 00 00 <e8> 23 6b 27 f6 65 8b 05 7c 60 5a 07 85 c0 74 40 48 c7 04 24 0e 36
RSP: 0018:ffffc900040a7320 EFLAGS: 00000206
RAX: 5de15cb931505900 RBX: 0000000000000a06 RCX: 5de15cb931505900
RDX: 0000000000000007 RSI: ffffffff8daa9dc3 RDI: 0000000000000001
RBP: ffffc900040a73b0 R08: ffffffff8fc3d077 R09: 1ffffffff1f87a0e
R10: dffffc0000000000 R11: fffffbfff1f87a0f R12: dffffc0000000000
R13: 0000000000000000 R14: ffff8880b8628240 R15: 1ffff92000814e64
 hrtimer_start include/linux/hrtimer.h:259 [inline]
 stimer_start arch/x86/kvm/hyperv.c:682 [inline]
 kvm_hv_process_stimers+0xd0a/0x16a0 arch/x86/kvm/hyperv.c:893
 vcpu_enter_guest arch/x86/kvm/x86.c:11193 [inline]
 vcpu_run+0x2240/0x76b0 arch/x86/kvm/x86.c:11639
 kvm_arch_vcpu_ioctl_run+0x1148/0x1c90 arch/x86/kvm/x86.c:11984
 kvm_vcpu_ioctl+0x99a/0xed0 virt/kvm/kvm_main.c:4492
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f635278f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f635365c038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f63529e5fa0 RCX: 00007f635278f749
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00007f6352813f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f63529e6038 R14: 00007f63529e5fa0 R15: 00007ffd5b219358
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

