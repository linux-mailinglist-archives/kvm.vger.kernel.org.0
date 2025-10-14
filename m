Return-Path: <kvm+bounces-59995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CB0DABD78B8
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 08:13:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 221C618A549D
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 06:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F31230BB82;
	Tue, 14 Oct 2025 06:13:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8BA303CB6
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 06:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760422397; cv=none; b=kjtgb6LWkp1w2uNs6qSgXAJbIPtQyjkcjooIcqdO2y/EN+3oadR2Z8q/WmzEYu95b1I/vA8DL06ggfDTL4mk0Sc45/5E5N9X425dRNKhwXTu2G6ZAlacLv9bMedlXWIxz1XnVtgvsVhOc4I8exDrUma9xp+xz/W0dmCm3kS/x8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760422397; c=relaxed/simple;
	bh=g4W8XMYhMO9fpc8t4xoroKvujMgme/s8VyUlfFnXjx0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ff+MHYtGWiauzkvxPMhhX8qAItXj5Hm0hP0XllOUCWwuECnqWi8lsGk2id/xoyxVVJz/fGaMO5bhOlo+TCKVq/hK1DwDFPErC2bt+h2xlQ8ekG2IIUqKJRDL0eFya4kNgP3jvSyiM5dKEHlHBPfoly2WBiLRK8JO+I53ccVNpKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-42f8befcb06so110316475ab.3
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 23:13:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760422393; x=1761027193;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Mzww+jJw17MS7+VX/G10P5KXQeBF+5UbwFPdlQO6Zk=;
        b=oGjHUViCAi46aEBY4N3cg8ApuS2Fi+1OHH3r9BM84oyYx/IZMN2J1IfOnJbujKT4G6
         GAU7fDoByUGO0SDKyi+7Cl73H10wIp+PsMexgSZ57o4lEkbASKgQSZz5gmHmW6getv1G
         3P5zjvu7Eax7+y3NoOh9BO8T6VXFpXrPQAy1m/u0AIGU6WqBRV5xAhC+IAwaF1jIOl1C
         6ollgZ9w8WHvLMX9Lxhy/M4abvaXMDihhMX07Bfxey+sF4ho2/qbb6VDM/Re3h0vsuci
         9kdYXSiqXYlRpmp4hnM2v05KKVw2FWSiHvomYWVPDm9QladH9pKb4650n2Z1rICVfrWU
         Jg2w==
X-Forwarded-Encrypted: i=1; AJvYcCX2axeWLys4IBkodjUxmqhMI3PZ2HBNTfXXAtYkkoaQmQrogMu1WSdB9spw5achuGChYuw=@vger.kernel.org
X-Gm-Message-State: AOJu0YykhA6BB2hPfQjxTyeSL7Cp4/0zAlaILrixEFsVYVmW4qDQ4Bcz
	GKiEHONiKDSQn0kAY0GG2y92L0PtJdqYHtDNfHqKsYeBePzl9PQV2JVerhwh8zqxYtzvdg90S1S
	tOxEaZPHnVOCC1oYOM6eji+ax2iUmU1g6C/bU7Nk+ntCw0MYsCOpF25ydoOM=
X-Google-Smtp-Source: AGHT+IFaBL3s8pQ5zB38ATZETSq5SoKT4mYbnvlXznqzS/d+bwQj/IeNTbir68JdnXNVfHGMk+Idl3tEapiBH/zmuivO0cMS8rmm
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:178d:b0:42d:7d2e:2bff with SMTP id
 e9e14a558f8ab-42f873fd943mr203574325ab.22.1760422392890; Mon, 13 Oct 2025
 23:13:12 -0700 (PDT)
Date: Mon, 13 Oct 2025 23:13:12 -0700
In-Reply-To: <20251014010950.1568389-1-xin@zytor.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ede9f8.a70a0220.b3ac9.0023.GAE@google.com>
Subject: [syzbot ci] Re: Enable FRED with KVM VMX
From: syzbot ci <syzbot+ci098fa4ef739d887e@syzkaller.appspotmail.com>
To: andrew.cooper3@citrix.com, bp@alien8.de, chao.gao@intel.com, 
	corbet@lwn.net, dave.hansen@linux.intel.com, hch@infradead.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	luto@kernel.org, mingo@redhat.com, pbonzini@redhat.com, peterz@infradead.org, 
	seanjc@google.com, tglx@linutronix.de, x86@kernel.org, xin@zytor.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v8] Enable FRED with KVM VMX
https://lore.kernel.org/all/20251014010950.1568389-1-xin@zytor.com
* [PATCH v8 01/21] KVM: VMX: Add support for the secondary VM exit controls
* [PATCH v8 02/21] KVM: VMX: Initialize VM entry/exit FRED controls in vmcs_config
* [PATCH v8 03/21] KVM: VMX: Disable FRED if FRED consistency checks fail
* [PATCH v8 04/21] x86/cea: Prefix event stack names with ESTACK_
* [PATCH v8 05/21] x86/cea: Export API for per-CPU exception stacks for KVM
* [PATCH v8 06/21] KVM: VMX: Initialize VMCS FRED fields
* [PATCH v8 07/21] KVM: VMX: Set FRED MSR intercepts
* [PATCH v8 08/21] KVM: VMX: Save/restore guest FRED RSP0
* [PATCH v8 09/21] KVM: VMX: Add support for saving and restoring FRED MSRs
* [PATCH v8 10/21] KVM: x86: Add a helper to detect if FRED is enabled for a vCPU
* [PATCH v8 11/21] KVM: VMX: Virtualize FRED event_data
* [PATCH v8 12/21] KVM: VMX: Virtualize FRED nested exception tracking
* [PATCH v8 13/21] KVM: x86: Save/restore the nested flag of an exception
* [PATCH v8 14/21] KVM: x86: Mark CR4.FRED as not reserved
* [PATCH v8 15/21] KVM: VMX: Dump FRED context in dump_vmcs()
* [PATCH v8 16/21] KVM: x86: Advertise support for FRED
* [PATCH v8 17/21] KVM: nVMX: Add support for the secondary VM exit controls
* [PATCH v8 18/21] KVM: nVMX: Add FRED VMCS fields to nested VMX context handling
* [PATCH v8 19/21] KVM: nVMX: Add FRED-related VMCS field checks
* [PATCH v8 20/21] KVM: nVMX: Add prerequisites to SHADOW_FIELD_R[OW] macros
* [PATCH v8 21/21] KVM: nVMX: Allow VMX FRED controls

and found the following issue:
WARNING in vmread_error

Full report is available here:
https://ci.syzbot.org/series/706e7cbc-a7af-4357-af68-194e1c883968

***

WARNING in vmread_error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      0d97f2067c166eb495771fede9f7b73999c67f66
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/0033ed68-ef22-4ef4-a630-0d101fb2cb8e/config
C repro:   https://ci.syzbot.org/findings/a19ef524-0065-4a83-abb5-c42a195ec916/c_repro
syz repro: https://ci.syzbot.org/findings/a19ef524-0065-4a83-abb5-c42a195ec916/syz_repro

------------[ cut here ]------------
vmread failed: field=281a
WARNING: CPU: 0 PID: 5954 at arch/x86/kvm/vmx/vmx.c:425 vmread_error+0x7e/0x90 arch/x86/kvm/vmx/vmx.c:425
Modules linked in:
CPU: 0 UID: 0 PID: 5954 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:vmread_error+0x7e/0x90 arch/x86/kvm/vmx/vmx.c:425
Code: dc 63 8b 48 89 de 5b 5d e9 cf de cf ff e8 0a 62 68 00 c6 05 4c 67 30 0e 01 90 48 c7 c7 80 db 63 8b 48 89 de e8 03 7f 2b 00 90 <0f> 0b 90 90 eb 98 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90
RSP: 0018:ffffc90004d66f28 EFLAGS: 00010246
RAX: c305e84bb7041f00 RBX: 000000000000281a RCX: ffff888109e48000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
RBP: ffffc90004d674a8 R08: ffff888121024293 R09: 1ffff11024204852
R10: dffffc0000000000 R11: ffffed1024204853 R12: dffffc0000000000
R13: ffff8881152e0000 R14: ffff88811292a30f R15: ffff88811292a000
FS:  0000555576a3b500(0000) GS:ffff88818e70e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000001bda0c000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __vmcs_readl arch/x86/kvm/vmx/vmx_ops.h:111 [inline]
 vmcs_read64 arch/x86/kvm/vmx/vmx_ops.h:177 [inline]
 nested_vmx_enter_non_root_mode+0xa0ef/0xbb20 arch/x86/kvm/vmx/nested.c:3834
 nested_vmx_run+0x5f7/0xc40 arch/x86/kvm/vmx/nested.c:4053
 __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6821 [inline]
 vmx_handle_exit+0x10a4/0x18c0 arch/x86/kvm/vmx/vmx.c:6838
 vcpu_enter_guest arch/x86/kvm/x86.c:11575 [inline]
 vcpu_run+0x446f/0x6fb0 arch/x86/kvm/x86.c:11733
 kvm_arch_vcpu_ioctl_run+0xfc9/0x1940 arch/x86/kvm/x86.c:12072
 kvm_vcpu_ioctl+0x95c/0xe90 virt/kvm/kvm_main.c:4476
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f22ca18eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff1aacefa8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f22ca3e5fa0 RCX: 00007f22ca18eec9
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00007f22ca211f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f22ca3e5fa0 R14: 00007f22ca3e5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

