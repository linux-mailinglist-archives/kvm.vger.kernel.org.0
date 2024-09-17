Return-Path: <kvm+bounces-27042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B892697AFBE
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 13:35:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 35ADE1F24393
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 11:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77ACC16D332;
	Tue, 17 Sep 2024 11:35:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D160291E
	for <kvm@vger.kernel.org>; Tue, 17 Sep 2024 11:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726572925; cv=none; b=SyBZ4/DtrEz0eHHm40XMR4gFyd187U4hpUa2RKUiEcR6jreEBBQo8V0igFaOh2qmQTtw4P7CQkIA4b+4Wi/Or+9Vf2nC6Gyz6J/AqhbFNNB+ZSbZ/Me9I7VYZmckdw2ahkc71MGD/M7fQd+A5u+CltB1q5VKbOaM7KPe2u6rzW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726572925; c=relaxed/simple;
	bh=UI3GdVf/nuU+X++Nux6qrFODU6Wg+Bu8YYz2116wATQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Idvfu+nFYoyh9dFkaf61SeytzeOSvP2teU+yMvAZ88gcqI95CFnTzTLxjYHYNgMVD6UnP+vDoVbCYtrlgJCdCqovuhw8MuHUPghThSK9E0j6jkRDkmKseGxAfB6f1xurkoUYsQp28TFeoHgQx39vpNZxb66zYoYzizZyCRmaB5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a0a2c95e81so18951195ab.0
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2024 04:35:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726572922; x=1727177722;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SzNEFOkwKTRRCubcdErJpo02u95pu5bJoNvb21H3/Cg=;
        b=eUMSAd6bpJtx+2EqNUlK/2vVvoopD+G5uLKkLI3073OIv907gYL5wsqfPV14gUyTQc
         8RXYAe4ICMjjawOfc90LsG2cl+eEuX3vgoMgStYxIYUiZ1flwMbEAb+L4uzw14MxYDUW
         YYimpLDba50z/Evvc6ZP+HLZxBc+a95XsUxRXp8VKwyYwubqZdMtAl2tPFnZXtmZQh4n
         xzE/w+BXwKJm+CuWnYhdIjMTOmcAc1E2gXbPEB115Qh0Ey1gZTRvB1LQbKD4/9wS8Cwu
         px1VrR9ENkwAzqeidBOx3c3PUiwSOECgrqC3Y2LS5C67YuN/NWq5c+1q/9dV04gZEq7O
         MtQw==
X-Forwarded-Encrypted: i=1; AJvYcCUqhkNqDZXnJ2eTRaqWpxZ8ZldiVd9CtPoAGr65+qSZd4Bq/a6H72ncIXA7ds7pOKlgCOo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeXTxkB0FFGkjvVz7CfkalNcKqweAf0vjDhDYzraIY/qJMLHV0
	LRcE3/wYzfv1h/PfwQdGAmGhzrudRNOtdDRJ4m6MJCWfXxt/J9thWyfvFYQBFe5Mw/UoSXfUN0O
	o6atGZ/Ed/wKYPtCokj0SFskj/s/SiUNY0rCRfQM/745xbOGsCTD8WII=
X-Google-Smtp-Source: AGHT+IHS++gqkOoTkEjWkqIehIfIt9V+h/1Ceq67kFyZ9Vwzx9LkDxLLtGxGfagBfDgu41gNoIX0xOL0HHrHEYccUKocJQQQ0KgA
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d11:b0:3a0:9c2d:f441 with SMTP id
 e9e14a558f8ab-3a09c2dfb33mr70460615ab.24.1726572922030; Tue, 17 Sep 2024
 04:35:22 -0700 (PDT)
Date: Tue, 17 Sep 2024 04:35:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66e96979.050a0220.252d9a.000a.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in sys_execve (6)
From: syzbot <syzbot+8bb3e2bee8a429cc76dd@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, bp@alien8.de, 
	davem@davemloft.net, hpa@zytor.com, jhs@mojatatu.com, jiri@resnulli.us, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, mingo@redhat.com, netdev@vger.kernel.org, 
	pbonzini@redhat.com, rkrcmar@redhat.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, vbabka@suse.cz, vinicius.gomes@intel.com, x86@kernel.org, 
	xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    46ae4d0a4897 Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=106a549f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3e10d80c64e440c0
dashboard link: https://syzkaller.appspot.com/bug?extid=8bb3e2bee8a429cc76dd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144e27c7980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c16ef5753326/disk-46ae4d0a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4a3a038d0ccf/vmlinux-46ae4d0a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/244ada956332/bzImage-46ae4d0a.xz

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

rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { 0-...D } 2685 jiffies s: 3289 root: 0x1/.
rcu: blocking rcu_node structures (internal RCU debug):
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 5444 Comm: syz-executor Not tainted 6.11.0-rc7-syzkaller-01396-g46ae4d0a4897 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
RIP: 0010:taprio_set_budgets+0x116/0x370 net/sched/sch_taprio.c:666
Code: 44 24 10 4c 89 74 24 18 4d 89 f5 45 31 ff 48 89 5c 24 08 bf 10 00 00 00 4c 89 fe e8 74 8f d2 f7 49 83 ff 0f 0f 87 63 01 00 00 <4c> 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df 80 3c 08 00 74
RSP: 0018:ffffc90000007c30 EFLAGS: 00000093
RAX: 0000000000010000 RBX: ffff888028fdb130 RCX: ffff888030aada00
RDX: 0000000000010000 RSI: 0000000000000001 RDI: 0000000000000010
RBP: 0000000000000000 R08: ffffffff89c1021c R09: 1ffff110051cea10
R10: dffffc0000000000 R11: ffffed10051cea11 R12: 0000000000000004
R13: ffff888028e75008 R14: ffff888028e75000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b8800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb58963cff8 CR3: 00000000311f6000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <IRQ>
 advance_sched+0x98d/0xca0 net/sched/sch_taprio.c:977
 __run_hrtimer kernel/time/hrtimer.c:1689 [inline]
 __hrtimer_run_queues+0x59b/0xd50 kernel/time/hrtimer.c:1753
 hrtimer_interrupt+0x396/0x990 kernel/time/hrtimer.c:1815
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1032 [inline]
 __sysvec_apic_timer_interrupt+0x110/0x3f0 arch/x86/kernel/apic/apic.c:1049
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1043 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1043
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:unwind_next_frame+0x9/0x2a00 arch/x86/kernel/unwind_orc.c:469
Code: 4c 89 f7 e8 69 ad b9 00 e9 53 ff ff ff 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 55 41 57 41 56 <41> 55 41 54 53 48 81 ec a0 00 00 00 48 89 fd 49 bd 00 00 00 00 00
RSP: 0018:ffffc9000422f120 EFLAGS: 00000202
RAX: 0000000000000001 RBX: ffffffff820edaf2 RCX: ffff888030aada00
RDX: dffffc0000000000 RSI: ffffffff820edaf2 RDI: ffffc9000422f140
RBP: ffffc9000422f1d0 R08: 000000000000000a R09: ffffc9000422f230
R10: 0000000000000003 R11: ffffffff817f2f80 R12: ffff888030aada00
R13: ffffffff817f2f80 R14: ffffc9000422f220 R15: ffffc9000422f140
 arch_stack_walk+0x151/0x1b0 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x118/0x1d0 kernel/stacktrace.c:122
 kasan_save_stack+0x3f/0x60 mm/kasan/common.c:47
 __kasan_record_aux_stack+0xac/0xc0 mm/kasan/generic.c:541
 __call_rcu_common kernel/rcu/tree.c:3106 [inline]
 call_rcu+0x167/0xa70 kernel/rcu/tree.c:3210
 remove_vma mm/mmap.c:189 [inline]
 remove_mt mm/mmap.c:2415 [inline]
 do_vmi_align_munmap+0x155c/0x18c0 mm/mmap.c:2758
 do_vmi_munmap+0x261/0x2f0 mm/mmap.c:2830
 __vm_munmap+0x1fc/0x400 mm/mmap.c:3109
 elf_map fs/binfmt_elf.c:383 [inline]
 elf_load+0x2d8/0x6f0 fs/binfmt_elf.c:408
 load_elf_binary+0xeba/0x2680 fs/binfmt_elf.c:1141
 search_binary_handler fs/exec.c:1827 [inline]
 exec_binprm fs/exec.c:1869 [inline]
 bprm_execve+0xaf8/0x1770 fs/exec.c:1920
 do_execveat_common+0x55f/0x6f0 fs/exec.c:2027
 do_execve fs/exec.c:2101 [inline]
 __do_sys_execve fs/exec.c:2177 [inline]
 __se_sys_execve fs/exec.c:2172 [inline]
 __x64_sys_execve+0x92/0xb0 fs/exec.c:2172
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb5887b0df7
Code: Unable to access opcode bytes at 0x7fb5887b0dcd.
RSP: 002b:00007fb58963ce78 EFLAGS: 00000246 ORIG_RAX: 000000000000003b
RAX: ffffffffffffffda RBX: 00007fb588815ef0 RCX: 00007fb5887b0df7
RDX: 00007ffedbc5b9b0 RSI: 00007ffedbc5bbf0 RDI: 00007ffedbc5cef5
RBP: 00007ffedbc5ba20 R08: 00007fb58963cf20 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 000055558020fa80
R13: 0000000000000100 R14: 00007ffedbc5b9d0 R15: 00007ffedbc5b780
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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

