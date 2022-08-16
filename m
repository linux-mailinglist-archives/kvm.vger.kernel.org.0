Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619CC59585F
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 12:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbiHPKdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 06:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234704AbiHPKcf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 06:32:35 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16296754B8
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 01:46:26 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id u5-20020a6b4905000000b00681e48dbd92so5654160iob.21
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 01:46:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=ahmrjH0a3Qkxw5mdXLJa7NXy27rr3wSWL9HtgfgRopE=;
        b=W+1houKvHEiAu/jjpTkerTIZcK0vkUjsu0LsTn2FLSUflWh2LzkCENBUd8G0tCxmbi
         Jjmf9yTKRjnMRN7aOO+Slt3qyWWtHTpbNDKrR6jp2tR/RECtLnHNEt35GbsHwDAWVaDa
         ANBiye9ISRDlSnhsRJQ12W/Cei/KmDWN3qYiIYWXNA/DvqDHFfsJR6zGAw5kKb0l1Dpu
         uE0iD1icKE4loYCzM6VolAoJyv+SGhQCSllMk02BoA61FMsQi2ymXxIKFkpJBgKQbngg
         NXq+cYAXxJjBirFeIztVByINM9M+3I7Typt7WCtqMxcB+klPnRwRRDN6mg+0dDzmlhnD
         RatQ==
X-Gm-Message-State: ACgBeo2/7RpJiAqkeYpWtX03fv/FYSAb9VtVJgOP9hVNGLuaTSQPAeoZ
        9naM/9fIpkdPVwtX9RYFbAgVBejohg2SUXS/xUIukcI/XN95
X-Google-Smtp-Source: AA6agR4acJ4apit9JKg5rRK8ILwimd0MgxU3eXNXYOdjDSkUqczW0DbRVp9bfUsRpHitcWwTa31XD7BxUqSoiVigG5luxR99Nn0Q
MIME-Version: 1.0
X-Received: by 2002:a02:6023:0:b0:346:ac9c:5ded with SMTP id
 i35-20020a026023000000b00346ac9c5dedmr945099jac.245.1660639585434; Tue, 16
 Aug 2022 01:46:25 -0700 (PDT)
Date:   Tue, 16 Aug 2022 01:46:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009700a805e657c8fa@google.com>
Subject: [syzbot] BUG: unable to handle kernel paging request in kvm_arch_hardware_enable
From:   syzbot <syzbot+4f6eb69074ff62a1a33b@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7ebfc85e2cd7 Merge tag 'net-6.0-rc1' of git://git.kernel.o..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13d10985080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20bc0b329895d963
dashboard link: https://syzkaller.appspot.com/bug?extid=4f6eb69074ff62a1a33b
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1538e0b5080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112756f3080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4f6eb69074ff62a1a33b@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: ffffc900039aa330
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 12000067 
P4D 12000067 
PUD 121c9067 
PMD 1d46a067 
PTE 0

Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 3620 Comm: syz-executor254 Not tainted 5.19.0-syzkaller-13930-g7ebfc85e2cd7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
RIP: 0010:arch_atomic_read arch/x86/include/asm/atomic.h:29 [inline]
RIP: 0010:atomic_read include/linux/atomic/atomic-instrumented.h:28 [inline]
RIP: 0010:kvm_arch_hardware_enable+0x1d1/0x6d0 arch/x86/kvm/x86.c:11847
Code: 89 5c 24 38 4c 8d 73 f0 4c 89 f7 be 04 00 00 00 e8 a4 44 cc 00 4d 89 f5 49 c1 ed 03 43 0f b6 44 3d 00 84 c0 0f 85 08 02 00 00 <41> 8b 06 ff c8 48 63 d0 4c 89 64 24 10 4c 89 e7 48 8d 74 24 60 b9
RSP: 0018:ffffc900038dfaa0 EFLAGS: 00010082

RAX: 0000000000000000 RBX: ffffc900039aa340 RCX: ffffffff8110f0c2
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffc900039aa330
RBP: ffffc900038dfb80 R08: dffffc0000000000 R09: fffff52000735466
R10: fffff52000735467 R11: 1ffff92000735466 R12: ffffc900039aa240
R13: 1ffff92000735466 R14: ffffc900039aa330 R15: dffffc0000000000
FS:  0000555555610300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc900039aa330 CR3: 0000000076051000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 hardware_enable_nolock+0xa1/0x140 arch/x86/kvm/../../../virt/kvm/kvm_main.c:5007
 smp_call_function_many_cond+0xebc/0x16f0 kernel/smp.c:979
 on_each_cpu_cond_mask+0x3b/0x80 kernel/smp.c:1154
 on_each_cpu include/linux/smp.h:71 [inline]
 hardware_enable_all+0x77/0x120 arch/x86/kvm/../../../virt/kvm/kvm_main.c:5069
 kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1202 [inline]
 kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4910 [inline]
 kvm_dev_ioctl+0x1076/0x17e0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4957
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fd926d9c049
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffce6c2e948 EFLAGS: 00000246
 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fd926d9c049
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000003
RBP: 00007ffce6c2e960 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
CR2: ffffc900039aa330
---[ end trace 0000000000000000 ]---
RIP: 0010:arch_atomic_read arch/x86/include/asm/atomic.h:29 [inline]
RIP: 0010:atomic_read include/linux/atomic/atomic-instrumented.h:28 [inline]
RIP: 0010:kvm_arch_hardware_enable+0x1d1/0x6d0 arch/x86/kvm/x86.c:11847
Code: 89 5c 24 38 4c 8d 73 f0 4c 89 f7 be 04 00 00 00 e8 a4 44 cc 00 4d 89 f5 49 c1 ed 03 43 0f b6 44 3d 00 84 c0 0f 85 08 02 00 00 <41> 8b 06 ff c8 48 63 d0 4c 89 64 24 10 4c 89 e7 48 8d 74 24 60 b9
RSP: 0018:ffffc900038dfaa0 EFLAGS: 00010082

RAX: 0000000000000000 RBX: ffffc900039aa340 RCX: ffffffff8110f0c2
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffc900039aa330
RBP: ffffc900038dfb80 R08: dffffc0000000000 R09: fffff52000735466
R10: fffff52000735467 R11: 1ffff92000735466 R12: ffffc900039aa240
R13: 1ffff92000735466 R14: ffffc900039aa330 R15: dffffc0000000000
FS:  0000555555610300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc900039aa330 CR3: 0000000076051000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	89 5c 24 38          	mov    %ebx,0x38(%rsp)
   4:	4c 8d 73 f0          	lea    -0x10(%rbx),%r14
   8:	4c 89 f7             	mov    %r14,%rdi
   b:	be 04 00 00 00       	mov    $0x4,%esi
  10:	e8 a4 44 cc 00       	callq  0xcc44b9
  15:	4d 89 f5             	mov    %r14,%r13
  18:	49 c1 ed 03          	shr    $0x3,%r13
  1c:	43 0f b6 44 3d 00    	movzbl 0x0(%r13,%r15,1),%eax
  22:	84 c0                	test   %al,%al
  24:	0f 85 08 02 00 00    	jne    0x232
* 2a:	41 8b 06             	mov    (%r14),%eax <-- trapping instruction
  2d:	ff c8                	dec    %eax
  2f:	48 63 d0             	movslq %eax,%rdx
  32:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  37:	4c 89 e7             	mov    %r12,%rdi
  3a:	48 8d 74 24 60       	lea    0x60(%rsp),%rsi
  3f:	b9                   	.byte 0xb9


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
