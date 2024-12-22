Return-Path: <kvm+bounces-34323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D9379FA8A0
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 00:10:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 340AE7A1F36
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 23:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF3DB193067;
	Sun, 22 Dec 2024 23:10:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B1618F2CF
	for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 23:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734909028; cv=none; b=d1uIkHJ9eDXK7OtFh7rLu3AO+HMDT39O7ot9Mviy6jxI54dUEndtnNhPK+VoPi0E2hcXMwXoUJEnXgr7vwRcd6SOtmgued4HXvoyqjKKX6kBo7FYUiK+Ab0BKZDNxj2dQcw1rB4DO7Rt5YAvQxiH0nKQyokYICqbkMCGdGAh/vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734909028; c=relaxed/simple;
	bh=RVm7jNBUUrHNTFNgINUmEkqp1qzYNHhAXPW+cKo6nLU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=mwaqlzomriKR11e3QHh5rsaf/oJAiKflBLLUKC6KZyDUb08y0ZQrq1xm6R0kp/wjQtYVc4BGAFuMhe4eLIO7nn3zNU6Iz10Sv7lysk0Ryeb5u4AyFolM23Vyes5X7vEPVlVTNBY/kCL7f/3r3AHuVjdjSkHy+N5bhuvcE2AB4q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3a819a4e83dso37619445ab.1
        for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 15:10:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734909026; x=1735513826;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=71tl5pK598wl7Ium1IiibAaoLnjGY1ZCnhcKpC8zXtU=;
        b=VBrIxcHQkcXeLiYC8782kurkcwIEC30Z3VkxIKW/p14xiOdzkwreoL3GLz7ZCwGuKH
         X5fDer9iP3niSMQL705ZfiuORHI0r2OUPx8Z99WtlMS8hFjgL+aVuO+dLx1NwuUMpj9K
         49evpcFxv2hjDDCBoKIeAG8WKMPgp+k990pdgZb1kmEnQn4kAZFWEZSDu34uRd8+1zxA
         kroaJTnCI41LbhV51G8gPltE1cFy2eguO1f1qFrjT7ReLxwtgqfAoYXuR+QhHELFOrsD
         o00rHFZcIXVDxv8LOdHZOti0eIusIGcGv3gwjWXpoVuUhy+RMTrAEfC/3ljoFOg1LpjY
         MX6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWf95/wd+6Tp5Ie9qNd5cndeZrsNcgvFlBEotw9FtXzRHO+R6inV3hSnwDC7OVq5pfEpx8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWURk2EQIDh4gA3KvhwKp+Tq53gz1SvQmLGAHeNjVuhiSMqZ+l
	vryBaOxgUJRQRgFzL28oRzRFaWc8tWig6VwmEP/B4ha+t/9QM/0CgGrnILhH1szT6UiWq0qc7rB
	ZSntj+WMmuVjCpLfFQbOBv3PA0MxjE945LPAH+tRSqryQY8A2wVnxCKs=
X-Google-Smtp-Source: AGHT+IERGq8zgv2rLFTEUytthEd2WLJ8gT9yzeFGaVtm2/jiGfdeP6y4I2po56TjkU90idpzX/FhCE1EcA2eDX/3kP8pQouSoWBA
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2384:b0:3a7:fe8c:b014 with SMTP id
 e9e14a558f8ab-3c2d5917533mr98929775ab.21.1734909026190; Sun, 22 Dec 2024
 15:10:26 -0800 (PST)
Date: Sun, 22 Dec 2024 15:10:26 -0800
In-Reply-To: <67598fb9.050a0220.17f54a.003b.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67689c62.050a0220.2f3838.000d.GAE@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in vmx_handle_exit (2)
From: syzbot <syzbot+ac0bc3a70282b4d586cc@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    bcde95ce32b6 Merge tag 'devicetree-fixes-for-6.13-1' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10635fe8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4f1586bab1323870
dashboard link: https://syzkaller.appspot.com/bug?extid=ac0bc3a70282b4d586cc
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=129c58c4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134e5f30580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-bcde95ce.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d1b2e8d294e3/vmlinux-bcde95ce.xz
kernel image: https://storage.googleapis.com/syzbot-assets/593ff4631acc/bzImage-bcde95ce.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ac0bc3a70282b4d586cc@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 6008 at arch/x86/kvm/vmx/vmx.c:6480 __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6480 [inline]
WARNING: CPU: 1 PID: 6008 at arch/x86/kvm/vmx/vmx.c:6480 vmx_handle_exit+0x40f/0x1f70 arch/x86/kvm/vmx/vmx.c:6637
Modules linked in:
CPU: 1 UID: 0 PID: 6008 Comm: syz-executor324 Not tainted 6.13.0-rc3-syzkaller-00301-gbcde95ce32b6 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6480 [inline]
RIP: 0010:vmx_handle_exit+0x40f/0x1f70 arch/x86/kvm/vmx/vmx.c:6637
Code: 07 38 d0 7f 08 84 c0 0f 85 b1 11 00 00 44 0f b6 a5 49 99 00 00 31 ff 44 89 e6 e8 4c 86 68 00 45 84 e4 75 52 e8 62 84 68 00 90 <0f> 0b 90 48 8d bd 4a 99 00 00 c6 85 49 99 00 00 01 48 b8 00 00 00
RSP: 0018:ffffc90003d17a58 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888031ba0000 RCX: ffffffff81319144
RDX: ffff8880230ea440 RSI: ffffffff8131914e RDI: 0000000000000001
RBP: ffffc9000428c000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000080000021 R14: ffff888031ba02d8 R15: dffffc0000000000
FS:  00007f4811d6b6c0(0000) GS:ffff88806a700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4811d4ad58 CR3: 0000000030878000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 vcpu_enter_guest arch/x86/kvm/x86.c:11081 [inline]
 vcpu_run+0x3047/0x4f50 arch/x86/kvm/x86.c:11242
 kvm_arch_vcpu_ioctl_run+0x44a/0x1740 arch/x86/kvm/x86.c:11560
 kvm_vcpu_ioctl+0x6ce/0x1520 virt/kvm/kvm_main.c:4340
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl fs/ioctl.c:892 [inline]
 __x64_sys_ioctl+0x190/0x200 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4811dbb649
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 1c 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4811d6b168 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f4811e3d348 RCX: 00007f4811dbb649
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000007
RBP: 00007f4811e3d340 R08: 00007f4811d6b6c0 R09: 0000000000000000
R10: 00007f4811d6b6c0 R11: 0000000000000246 R12: 00007f4811e3d34c
R13: 0000000000000000 R14: 00007ffea79b5e30 R15: 00007ffea79b5f18
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

