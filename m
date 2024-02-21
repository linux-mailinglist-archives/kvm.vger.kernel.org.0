Return-Path: <kvm+bounces-9308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B822A85DCEE
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 15:00:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E76B1F22753
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 14:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D437E582;
	Wed, 21 Feb 2024 13:59:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD6376037
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 13:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523962; cv=none; b=cotQY4ODRBG0JV1NQVJDu0xJJgvX/Vr0R0GEPaKqM1wYB9e2vmM4A+SqlVPFFeJ6rfb3hTRfndgiorrI3PQdSwHDWlFHG2vitDRAiXGBVz5GNnT+G/nghVcNw+1KD0xzxqY0+5ACWkINpHy7n9H4wtk6YNVV/OynijNH1Gh1UI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523962; c=relaxed/simple;
	bh=bgNYNGgBU3vKVD3hJeRfH6WNTKsC0XsOvq3Gyh63Rcs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=uWk4yItIQRozUNstv/TK4UqRlWDpFZVnuNO3//YbefalzfEoLTiL5AwxX0q+h/VTbBVIxdGryXfYCaiEKjmm7tbDPHMOzYK+r25zB0fGg97HQsxoc+bsi5efHPNpQ65DvXAi7osp/Sd6XiyXPPIfh7/Lki/mmIPdkukb8kE1cRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-363c88eff5aso55279095ab.1
        for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 05:59:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708523960; x=1709128760;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ad+ua+BVfwbD9f80Z4OzvkTux8hoWET6X36f44Mygqs=;
        b=RSPfzad9F6mO2ntSJn1AjRHjpa9noXYUQxpGIqWy9yCvYztRBqKNLhaxDKZ+OKyvy0
         UfVE4Skd9W6wVHJw7AVyH0LlU3q/ZgvDFJG0yYNcK047N1RdlRu/lOZ+9TgJvMrgqCVT
         +eC4FdtnB5OLFWjU0v0TmbMd0fSoFKGqzIHkIUqsKePgYX2QKafSRHBmAsRjgIWilrqa
         t/Dmh/KYNNW1hy1h1hix5y6lmt/LM60zj/cAMw4yIrnA+AyjDvUG5m1EFmkxlh6d0DO/
         pUCD6Z4sRlCxU/4zIwVdGC5f/g+48dHgVbwe2e882fOsdE7Sx5pCip6xjLG6uUmqQMUY
         N0zg==
X-Forwarded-Encrypted: i=1; AJvYcCUw3/sIQwSv8zIhnRnpm/kLnp4FS0QMq0fXIjZQN0tFTToAlNTrCO6CtC+rNTBV1n0iS2ev/v7Q7D+lfHjjcctAdPDX
X-Gm-Message-State: AOJu0YwrCTAK0W16POI+1AOizANs5/CQ5cfBP5qvPH9WFB8iKDXrGEaa
	U5wAiza7pz+1ERksbCDFhBveVUlzQ4zStHXRdlUgcPqxyjMPbOgqhsWIoJX+scWuSdK+k/rbfWL
	nNs5qWj+iUA/NxURrkjXIOM5fhI+LqkzuHHWmKZwuTewfuhK/55revhg=
X-Google-Smtp-Source: AGHT+IEUE5+GIp8gEbbnSmpCYapMUxkAQcWuKpRlehfmIELt6hwbMmEeiO6394TLvTBUqd9Dtx1/MZKZWKo2oqyoekgX2Tpaeujs
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d92:b0:365:21f4:7005 with SMTP id
 h18-20020a056e021d9200b0036521f47005mr944769ila.4.1708523960168; Wed, 21 Feb
 2024 05:59:20 -0800 (PST)
Date: Wed, 21 Feb 2024 05:59:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bc78610611e4bba1@google.com>
Subject: [syzbot] [kvm?] KMSAN: uninit-value in em_ret
From: syzbot <syzbot+ee5eb98a07d2c1fb30df@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b401b621758e Linux 6.8-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15cd41c2180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1b015d567058472
dashboard link: https://syzkaller.appspot.com/bug?extid=ee5eb98a07d2c1fb30df
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c32ff3cbe7ed/disk-b401b621.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/17621a870a21/vmlinux-b401b621.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b06ad3ca55ee/bzImage-b401b621.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ee5eb98a07d2c1fb30df@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in assign_eip_near arch/x86/kvm/emulate.c:829 [inline]
BUG: KMSAN: uninit-value in em_ret+0x124/0x130 arch/x86/kvm/emulate.c:2238
 assign_eip_near arch/x86/kvm/emulate.c:829 [inline]
 em_ret+0x124/0x130 arch/x86/kvm/emulate.c:2238
 x86_emulate_insn+0x1d87/0x5880 arch/x86/kvm/emulate.c:5292
 x86_emulate_instruction+0x13c9/0x30a0 arch/x86/kvm/x86.c:9171
 kvm_emulate_instruction arch/x86/kvm/x86.c:9251 [inline]
 complete_emulated_io arch/x86/kvm/x86.c:11208 [inline]
 complete_emulated_mmio+0x70b/0x8b0 arch/x86/kvm/x86.c:11268
 kvm_arch_vcpu_ioctl_run+0x1837/0xb890 arch/x86/kvm/x86.c:11380
 kvm_vcpu_ioctl+0xbfc/0x1770 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4441
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:871 [inline]
 __se_sys_ioctl+0x225/0x410 fs/ioctl.c:857
 __x64_sys_ioctl+0x96/0xe0 fs/ioctl.c:857
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Local variable eip created at:
 em_ret+0x37/0x130 arch/x86/kvm/emulate.c:2234
 x86_emulate_insn+0x1d87/0x5880 arch/x86/kvm/emulate.c:5292

CPU: 0 PID: 5793 Comm: syz-executor.0 Not tainted 6.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/25/2024
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

