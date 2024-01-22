Return-Path: <kvm+bounces-6514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 83492835C77
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 09:21:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B6F71F22A5C
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 08:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386E42135D;
	Mon, 22 Jan 2024 08:20:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D11620DF3
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 08:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705911626; cv=none; b=aFlSNTqFpEXenU//dg+IfvIzXo9hf9QcOUQ/KfjBUgMaAt3vo5+z0WFCF01gMuVBFE0eIAsbPSkUKA0ZaKcOtnx2XqedXB2OioS042czuqWR5Wxll+GM8bGM5mqiuE9vYo0Gt5ay/pAeOZEhWT2vnUk7acyvmtTuuBJuZOMHV/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705911626; c=relaxed/simple;
	bh=dCDychL2QgdYfb9TQKM74zR/SBVGu+AY6yivpkgbRTE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=VeGMgDos9jy/RXqqL+zUa8ecZeUEA58IhvuQpojlPUQvqzWhu3NqUAB7ANIXZ5SvHgAwrWgpea2v/5iujqESmVkGgMIXVMgFUZkbbnaXiuNjsYnyWspcVFHaUvpG6/b8ajOm2kiJRsnKn25gVLhKaLM7PQ/zGVwzIWUHlQyBVbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-361b0f701c4so13631095ab.2
        for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 00:20:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705911624; x=1706516424;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r3idZW5TKojJjW79OKe2S/XHyZ2jC9PZZqQG/IMm0/M=;
        b=CxXFqOC7so4JkJylpKpihKLnbh0FIjV49bgIQ3bJ4Zmrg56KGxfR+34JaD7bzlIxBW
         oiaT+20nidChUQCLR4OlBwqowY9zx5xqE/F97vaFWiHBHnWABxJyeRLOeH+6eQuwgYEg
         Sqjpagn+IPRUyCNgPP8p/8KptkvUYykO5tsmAnQRthDrshkirGwMqg0kvgoELTULEiWB
         fkM2Ux7shLybzxVikKAiggZae7IM8LL3DvQ+lz/UnaySjvmck3sGIhOaU9ciyopVR81p
         bya0SA6J8zv7R/Ki4FY1JUltYFr7pBYe2LTPx8mlsj8NkPpgsQae+Kk6qz60YfC5M/79
         4f1A==
X-Gm-Message-State: AOJu0YwHt+r/B+fcT2ycEl6qiW127JGegkdo/TArivBbUBQHSXye5Xvz
	TMsKbz+X9qR2PAKdAFydTJPZVZ56xJHokbEquyXaLkF6QoWhTWjx/5Yx5tmzPvY2x1nLGHXsU7z
	m83GiDfDLHHqlV4tyWCYwjcXiXXWkzietjDovk5Yz0CGrlbikCjapTJ8=
X-Google-Smtp-Source: AGHT+IHm9pO/1KObgYeHysK3c8SNlB6aArrBtVOrXRhi21A/xS859gCHKy8uh7k6ZkAuIqAk9xtORxfGt4I8lyK/cZKHicMqxJN2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12e3:b0:360:7c34:ffa7 with SMTP id
 l3-20020a056e0212e300b003607c34ffa7mr479882iln.1.1705911624601; Mon, 22 Jan
 2024 00:20:24 -0800 (PST)
Date: Mon, 22 Jan 2024 00:20:24 -0800
In-Reply-To: <0000000000009c91ce060e87575b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000671a09060f84808b@google.com>
Subject: Re: [syzbot] [kvm?] KMSAN: uninit-value in em_ret_far
From: syzbot <syzbot+579eb95e588b48b4499c@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, glider@google.com, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, n.zhandarovich@fintech.ru, nogikh@google.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    9f8413c4a66f Merge tag 'cgroup-for-6.8' of git://git.kerne..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=174e24d7e80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=656820e61b758b15
dashboard link: https://syzkaller.appspot.com/bug?extid=579eb95e588b48b4499c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ffebbde80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=143dcfc7e80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/79d9f2f4b065/disk-9f8413c4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cbc68430d9c6/vmlinux-9f8413c4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9740ad9fc172/bzImage-9f8413c4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+579eb95e588b48b4499c@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in em_ret_far+0x332/0x340 arch/x86/kvm/emulate.c:2258
 em_ret_far+0x332/0x340 arch/x86/kvm/emulate.c:2258
 em_ret_far_imm+0x39/0x4f0 arch/x86/kvm/emulate.c:2270
 x86_emulate_insn+0x1d81/0x5800 arch/x86/kvm/emulate.c:5289
 x86_emulate_instruction+0x13c5/0x3090 arch/x86/kvm/x86.c:9101
 kvm_mmu_page_fault+0x100a/0x1120 arch/x86/kvm/mmu/mmu.c:5778
 handle_ept_violation+0x4ef/0x7e0 arch/x86/kvm/vmx/vmx.c:5788
 __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6567 [inline]
 vmx_handle_exit+0x1b01/0x2130 arch/x86/kvm/vmx/vmx.c:6584
 vcpu_enter_guest arch/x86/kvm/x86.c:10992 [inline]
 vcpu_run arch/x86/kvm/x86.c:11095 [inline]
 kvm_arch_vcpu_ioctl_run+0x9d4f/0xc680 arch/x86/kvm/x86.c:11321
 kvm_vcpu_ioctl+0xbfc/0x1770 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4155
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:871 [inline]
 __se_sys_ioctl+0x225/0x410 fs/ioctl.c:857
 __x64_sys_ioctl+0x96/0xe0 fs/ioctl.c:857
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x6d/0x140 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Local variable eip created at:
 em_ret_far+0x3a/0x340 arch/x86/kvm/emulate.c:2243
 em_ret_far_imm+0x39/0x4f0 arch/x86/kvm/emulate.c:2270

CPU: 0 PID: 5001 Comm: syz-executor428 Not tainted 6.7.0-syzkaller-00562-g9f8413c4a66f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/17/2023
=====================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

