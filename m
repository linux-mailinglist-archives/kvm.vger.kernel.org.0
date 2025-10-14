Return-Path: <kvm+bounces-59996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C7EFBD78C4
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 08:13:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2C2014E64DC
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 06:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16DC6305050;
	Tue, 14 Oct 2025 06:13:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153872BD024
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 06:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760422425; cv=none; b=DOQ4Nez8eYgXygtwsbR8qfAtFLvlSzali2kfbFCPcGYrnldLUGa6YlzMy7hPcr5hCAwBsNfLL2pcm8sAQ6+rWzp0uAEQ0ha2/pT1M9zFvFD5gN3eOeKyw7UHM2XB/dYtZ318TNXSNVxBAC83DXXhZKAYrdCeSdADG3L5OJWhmKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760422425; c=relaxed/simple;
	bh=YSW3cVmJTLq0P9Z69cpcttKtEg1Y9/htUjbx6+Wc3rg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ZfMRT4JOVXO4tZtqEDfBw/0Q5zYVaM1ffmn6dK8gnPP0lcP7AiqP8wR2o4+YkOdHgcRftbXMHgvuYtKevgXzgsdiiipNnPFs2uGcwMXD75yTVjC8aWEkZqZpJciRDdBnhIEHPAV0COlR2HOqgpgEcWlmuNsn+qkCnmxaL6gzB2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-937e5f9ea74so1147223439f.1
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 23:13:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760422423; x=1761027223;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZubFNhWcbuzmyn2fCiien/rQoEi8wwx6tXeFV3OPrlg=;
        b=i6ApAKrYTQZY0sS6jaC7BfzgLJ4iqS/U9sC6I0qRHZWdoF/NGA3TKpOn9yjbrYrimj
         NerGALlN9SP+cGMcTHynQDghaDG/JF52tP8jBMc2XIYhLv8sOm58IjvdYHNNRqj6M6T0
         N1+HX+R4oUxX0kDjd6jfQkBIcD7OoVPUR8EmkPd9StY20rtVmstJc1fovXnsfU4d9QF7
         VB2z2/NUXidWm3RSo6j1Qgo+OBAamo1lzVaTxV2ieZeudFZp5DFFn0JIyslnzveT3V6e
         Gy+STyiKKhMjGYYp1uZE6c2znPLizTb+NM9KFL7olGFvL7EXhhpbcBvXQz8V1zV9VczB
         FWWw==
X-Forwarded-Encrypted: i=1; AJvYcCXdc5hgu88KwbsJ9xX3yOyaya+PcagDQVTADZd3lUMV4QRL+I0aZawGRuJJG6v/XQj0KNU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTZv3oYm1Q4dwRMrL+zgQhG7CJMdk6NAvB7ZWsZ6pZaPU+WGn0
	AgtD7SVu6g8Qo9WiBFhGYeH995dD9xd9bhu41TXBCurVDIFv+ROQSCCnv8pSuyC3eoD/rD8wU8f
	A6ftjCNH0a0YZcePZZxbMO/zMHdwwmurUTWtJkHvot296PV9QZClGqBrsets=
X-Google-Smtp-Source: AGHT+IH77SyfJDzBSRXva3BYzxiwYFsXqUsNi6yOgAlgjQrJbB1r0/usBzxeXB/c8QMzHnqpZonGzF3CBzrda2KDHIxO3UwCfKF5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:378e:b0:42d:89d8:20b7 with SMTP id
 e9e14a558f8ab-42f874261f4mr233253785ab.31.1760422423241; Mon, 13 Oct 2025
 23:13:43 -0700 (PDT)
Date: Mon, 13 Oct 2025 23:13:43 -0700
In-Reply-To: <20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68edea17.050a0220.91a22.01fd.GAE@google.com>
Subject: [syzbot ci] Re: KVM: x86: Unify L1TF flushing under per-CPU variable
From: syzbot ci <syzbot+ci693402a94575bcb2@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	jackmanb@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, 
	x86@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] KVM: x86: Unify L1TF flushing under per-CPU variable
https://lore.kernel.org/all/20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@google.com
* [PATCH] KVM: x86: Unify L1TF flushing under per-CPU variable

and found the following issue:
BUG: using __this_cpu_write() in preemptible code in x86_emulate_instruction

Full report is available here:
https://ci.syzbot.org/series/c0a39c51-4121-4883-a21f-4277f63b3118

***

BUG: using __this_cpu_write() in preemptible code in x86_emulate_instruction

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      6b36119b94d0b2bb8cea9d512017efafd461d6ac
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/a964957a-128c-43dd-b6df-7758575a9993/config
C repro:   https://ci.syzbot.org/findings/c0c645e8-abe2-437f-aa29-1adf339cb732/c_repro
syz repro: https://ci.syzbot.org/findings/c0c645e8-abe2-437f-aa29-1adf339cb732/syz_repro

BUG: using __this_cpu_write() in preemptible [00000000] code: syz.0.17/5962
caller is kvm_set_cpu_l1tf_flush_l1d arch/x86/include/asm/kvm_host.h:2486 [inline]
caller is x86_emulate_instruction+0x1a4/0x1f70 arch/x86/kvm/x86.c:9405
CPU: 1 UID: 0 PID: 5962 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 check_preemption_disabled+0x10a/0x120 lib/smp_processor_id.c:47
 kvm_set_cpu_l1tf_flush_l1d arch/x86/include/asm/kvm_host.h:2486 [inline]
 x86_emulate_instruction+0x1a4/0x1f70 arch/x86/kvm/x86.c:9405
 kvm_mmu_page_fault+0x91a/0xb70 arch/x86/kvm/mmu/mmu.c:6385
 __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6624 [inline]
 vmx_handle_exit+0x10a4/0x18c0 arch/x86/kvm/vmx/vmx.c:6641
 vcpu_enter_guest arch/x86/kvm/x86.c:11461 [inline]
 vcpu_run+0x4359/0x6fc0 arch/x86/kvm/x86.c:11619
 kvm_arch_vcpu_ioctl_run+0xfc9/0x1940 arch/x86/kvm/x86.c:11958
 kvm_vcpu_ioctl+0x95c/0xe90 virt/kvm/kvm_main.c:4476
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:598 [inline]
 __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:584
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0f9698eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff7c8600c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f0f96be5fa0 RCX: 00007f0f9698eec9
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00007f0f96a11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0f96be5fa0 R14: 00007f0f96be5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

