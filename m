Return-Path: <kvm+bounces-61082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 877B9C08619
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 02:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4B953AAAEB
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 00:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CFBF2BAF4;
	Sat, 25 Oct 2025 00:12:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F61714A8E
	for <kvm@vger.kernel.org>; Sat, 25 Oct 2025 00:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761351128; cv=none; b=jtGk8jERFWoOuLFBzB7ry35jdrst/Nn9eE9PkOgOrJWJ3OFoBWpn/yz/Xo3gTLZ0QhFWXd1YccT+br9eq5aerAAYrEzZExUCnmWkFbvhL2P7nTAEWACJ/sgym6b4rb5HpqREJF5Ctuml8JcKWswfzt+2vwQGkgyv58lZe8LZTsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761351128; c=relaxed/simple;
	bh=uXFxWnRStbW6yl1PETqMllx9eKBXQZv/kZfTucJJvpY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=GlVc6KA6kShtR08eZ1Td249r1LHp+zvkiY/a2MZ2o4nDrsdbfqtTZA09jnwCzWbmlH2/kmAIjD33xtUe2I1RjJnu6bERxBNtfEpiHQkzRnmutK6bXleUIOkAsNJudsshDlp5zlABiYbMxT+BOf45tlixFXR9JTskC8JtRXPSnSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-93e8092427aso278377339f.0
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 17:12:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761351125; x=1761955925;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oWBsQER8bu6bk9UdC/DRTjOmlM7UxYSXQZ2YLCPQhb4=;
        b=iLVLxxOZ5NSUceYEx4FIpTqAKG3r8tkGw8aWos/7saGVu8O/D/B1hdp+2uLrBwbV5S
         omulnPK5EwJY12Biuqg6LhdJ/GX2+R/EBnsA2GNNwzVEn0+THVawa9E6eQL0Dovuc8z8
         2sN+qW++BNppJmrI9BzJP2g9yorEXhBQyKQHnJA2cHQH1/x9Dr4/DIdYCEyBpNC04+2v
         hBr9tpCp4itbzNPSW56tEqYomqbfDOEoGBUeX/sZ2ZQGmDbt45OLycxaSJqtWQWllJti
         r6Fe6vpgx42wj7UTS8rJs2eI41VYOX5+ZEeIXwe6Yh25T942NO7p1x7CirdkrFqFHqiv
         AUjw==
X-Forwarded-Encrypted: i=1; AJvYcCVh83PfALeMKWLCgitxbRpHYQKTfGBm9kHwCCHae87KS/izkWDALbfpcq3tNXn62Q7Qj/8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu+i7OSLJBAGljF8HN6PwgLZFow/kL2pWTMqWosLM1xpkR4Yvo
	92Uf6KdQZpQj2RVH/QePWRH0ioIj4an5IFtJLqidmqlbOXRcETlKmbdxYF4V9gUmKhxzifQOW+l
	IIPAql0VusjW8qsWDRfuBftDS9CQPEWhDOqeRFnc/C8/wuaY21qFOjbnHsa4=
X-Google-Smtp-Source: AGHT+IEaRGEYjyCywez+oTEPoGNfra5j5OFMxHan25VIdcW2g+ZSHsJ02KS2mjLE2ANO/pE3HH/OGceZZHMDhI/qRfPkqSCODqyx
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:219d:b0:431:d093:758d with SMTP id
 e9e14a558f8ab-431ebed3700mr55271545ab.22.1761351125461; Fri, 24 Oct 2025
 17:12:05 -0700 (PDT)
Date: Fri, 24 Oct 2025 17:12:05 -0700
In-Reply-To: <20251024234353.8746-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fc15d5.050a0220.346f24.01a4.GAE@google.com>
Subject: Re: [syzbot] [kvm?] KASAN: slab-use-after-free Write in kvm_gmem_release
From: syzbot <syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com>
To: hdanton@sina.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	seanjc@google.com, syzkaller-bugs@googlegroups.com, tabba@google.com, 
	xiaoyao.li@intel.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in get_data

------------[ cut here ]------------
WARNING: kernel/printk/printk_ringbuffer.c:1278 at get_data+0x48a/0x840 kernel/printk/printk_ringbuffer.c:1278, CPU#1: udevd/5199
Modules linked in:
CPU: 1 UID: 0 PID: 5199 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:get_data+0x48a/0x840 kernel/printk/printk_ringbuffer.c:1278
Code: 83 c4 f8 48 b8 00 00 00 00 00 fc ff df 41 0f b6 04 07 84 c0 0f 85 ee 01 00 00 44 89 65 00 49 83 c5 08 eb 13 e8 57 cd 1e 00 90 <0f> 0b 90 eb 05 e8 4c cd 1e 00 45 31 ed 4c 89 e8 48 83 c4 28 5b 41
RSP: 0018:ffffc90000a08560 EFLAGS: 00010006
RAX: ffffffff81a16c59 RBX: 00003fffffffffff RCX: ffff88807e471e40
RDX: 0000000000010000 RSI: 00003fffffffffff RDI: 0000000000000000
RBP: 0000000000000012 R08: 0000000000001005 R09: 0000002047c57766
R10: 0000002047c57766 R11: 0000196a8200002e R12: 0000000000000012
R13: 0000000000000000 R14: ffffc90000a086a8 R15: 1ffffffff1bcaa96
FS:  00007fa682a1a880(0000) GS:ffff888126022000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30c63fff CR3: 000000007e4be000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 copy_data kernel/printk/printk_ringbuffer.c:1857 [inline]
 prb_read kernel/printk/printk_ringbuffer.c:1966 [inline]
 _prb_read_valid+0x672/0xa90 kernel/printk/printk_ringbuffer.c:2143
 prb_read_valid+0x3c/0x60 kernel/printk/printk_ringbuffer.c:2215
 printk_get_next_message+0x15c/0x7b0 kernel/printk/printk.c:2978
 console_emit_next_record kernel/printk/printk.c:3065 [inline]
 console_flush_one_record kernel/printk/printk.c:3197 [inline]
 console_flush_all+0x4cc/0xb10 kernel/printk/printk.c:3271
 __console_flush_and_unlock kernel/printk/printk.c:3301 [inline]
 console_unlock+0xbb/0x190 kernel/printk/printk.c:3341
 wake_up_klogd_work_func+0xa8/0x130 kernel/printk/printk.c:4550
 irq_work_single+0xe1/0x240 kernel/irq_work.c:221
 irq_work_run_list kernel/irq_work.c:252 [inline]
 irq_work_tick+0x2c2/0x360 kernel/irq_work.c:277
 update_process_times+0x264/0x2f0 kernel/time/timer.c:2476
 tick_sched_handle kernel/time/tick-sched.c:276 [inline]
 tick_nohz_handler+0x39a/0x520 kernel/time/tick-sched.c:297
 __run_hrtimer kernel/time/hrtimer.c:1777 [inline]
 __hrtimer_run_queues+0x4e0/0xc60 kernel/time/hrtimer.c:1841
 hrtimer_interrupt+0x45b/0xaa0 kernel/time/hrtimer.c:1903
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1041 [inline]
 __sysvec_apic_timer_interrupt+0x10b/0x410 arch/x86/kernel/apic/apic.c:1058
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1052
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:__sanitizer_cov_trace_cmp4+0x4/0x90 kernel/kcov.c:288
Code: 89 74 11 18 48 89 44 11 20 e9 48 ca 8b 09 cc 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa <48> 8b 04 24 65 48 8b 14 25 08 e0 6f 92 65 8b 0d a8 a4 af 10 81 e1
RSP: 0018:ffffc900030e7d00 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000040 RCX: 0000000000000000
RDX: ffff88807e471e40 RSI: 0000000000000040 RDI: 000000000000000c
RBP: 000000000000000c R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff5200061cf90 R12: ffff88807ea4d320
R13: dffffc0000000000 R14: ffff88807ea4d3c0 R15: 0000000000000000
 alloc_fd+0x2f3/0x6c0 fs/file.c:595
 do_sys_openat2+0xfc/0x1c0 fs/open.c:1435
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_openat fs/open.c:1468 [inline]
 __se_sys_openat fs/open.c:1463 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1463
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa6822a7407
Code: 48 89 fa 4c 89 df e8 38 aa 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
RSP: 002b:00007fffd29370d0 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007fa682a1a880 RCX: 00007fa6822a7407
RDX: 0000000000080000 RSI: 00007fffd2937250 RDI: ffffffffffffff9c
RBP: 0000000000000008 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 00005600f32347f5
R13: 00005600f32347f5 R14: 0000000000000001 R15: 0000000000000000
 </TASK>
----------------
Code disassembly (best guess):
   0:	89 74 11 18          	mov    %esi,0x18(%rcx,%rdx,1)
   4:	48 89 44 11 20       	mov    %rax,0x20(%rcx,%rdx,1)
   9:	e9 48 ca 8b 09       	jmp    0x98bca56
   e:	cc                   	int3
   f:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  16:	90                   	nop
  17:	90                   	nop
  18:	90                   	nop
  19:	90                   	nop
  1a:	90                   	nop
  1b:	90                   	nop
  1c:	90                   	nop
  1d:	90                   	nop
  1e:	90                   	nop
  1f:	90                   	nop
  20:	90                   	nop
  21:	90                   	nop
  22:	90                   	nop
  23:	90                   	nop
  24:	90                   	nop
  25:	90                   	nop
  26:	f3 0f 1e fa          	endbr64
* 2a:	48 8b 04 24          	mov    (%rsp),%rax <-- trapping instruction
  2e:	65 48 8b 14 25 08 e0 	mov    %gs:0xffffffff926fe008,%rdx
  35:	6f 92
  37:	65 8b 0d a8 a4 af 10 	mov    %gs:0x10afa4a8(%rip),%ecx        # 0x10afa4e6
  3e:	81                   	.byte 0x81
  3f:	e1                   	.byte 0xe1


Tested on:

commit:         72fb0170 Add linux-next specific files for 20251024
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14b2e3cd980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bcaf4aad77308158
dashboard link: https://syzkaller.appspot.com/bug?extid=2479e53d0db9b32ae2aa
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13d98be2580000


