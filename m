Return-Path: <kvm+bounces-34150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6E729F7C6A
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 14:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02566171B5E
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 13:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C18F22576E;
	Thu, 19 Dec 2024 13:30:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598A72253E3
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 13:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734615026; cv=none; b=hJ13NAjUd0EY7m5y72n31cLHPUbU+T6nOcMFjJpg+0qRCNvOqVYN8XqVdlIdhd5i3gq7KuVcx5Kntl2Rb6Kjy2CWfdpFWvTa+5876XQEg3drzyeXXohOon48e+9tS4EtcGLDS0oHq8UmjTyICGckETuRR315pemdHls8zlEmvEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734615026; c=relaxed/simple;
	bh=ScMxMJ+guD/AlXNqo0SWrVtaRrRG3SND+X0aNE6n1+A=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=R6rHNaahK+rh901fsyQoYUUQTVUjOC8ltDd8Bb0pMgx/BEgeY/udv+VtoVN6Qo7fnsDmAb2goBwnQWlu9FVx44GwBUB4WN280DUPCjKNHZkD8774IvkVc62JAvgw77tQd7zE/YDEnpixd5qeFaQn3IK1IPlELbyKujry/jXldiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a9cc5c246bso6599565ab.2
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 05:30:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734615023; x=1735219823;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vo1cocR0B0oWJ6jBsl9zcws/oI8GgwxFYRDuU0YUrks=;
        b=EenB1XaQzsKTflqGJwK4eYFYghd97jADH96lsjwPT3Wn+zEboH+9JNhJAqPcFqrtXZ
         lEL2kso/4qRbrIexBOp1IjeQ5tudc48KNgDSVlPyiKSXx4/mHaDCSvHXGPAgABh1tTk5
         h7t3uTELnmXyLNQvbTCb2SNXL5n2x2V3HMwaWHFXPz+P0+NB2tPrqmqKPNojyUWC0zjo
         avK1t8LByvNCE8YmAZOd3qegmrdNKmizAFZq56sTv8993yl0wq5gs0iBPEvHA9WX907C
         EAjnn2Qg+aME3VONnjtKYG8tTauTQoL6lTFbtqiQQwH0baGQDe80wFU013fo4uOp5Qlu
         vKRg==
X-Forwarded-Encrypted: i=1; AJvYcCVK5rrQWlXZybjx6vGhcqpYOkp7vk7AdSeMRlw8w9d3b4SAj/3XqUXCMYAoUDbcZhFsc6k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5qUhJaIISE/iztVup6MPc9X4MTAh4V7KtOoFswNWRyslh3fjo
	euX3IVEyI26dxtsyLnQi2g4Z2ur4dan+4tzTWzVa+uRuyuL8gDu/DhTWkvGZVeWCuO/AFQxdUbs
	RfESHq+Y4MgmGdDinOSfe/3kXayQAigjCYv4mwAVSCFFP0kyLlzgOhpQ=
X-Google-Smtp-Source: AGHT+IGdGE1tFCwJrZ6o6UeQa2EGKbGCwQCP3KgVCGUHlkn5uhdtJ2XJHLLvy5F1Hj6TF0iWaSo71zsRTZcG5JsqLIVGojwMPPjL
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a8e:b0:3a7:c2ea:1095 with SMTP id
 e9e14a558f8ab-3bdc031d9d0mr56998945ab.1.1734615023371; Thu, 19 Dec 2024
 05:30:23 -0800 (PST)
Date: Thu, 19 Dec 2024 05:30:23 -0800
In-Reply-To: <6759ca87.050a0220.1ac542.000e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67641fef.050a0220.3157ee.0019.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in __srcu_check_read_flavor
From: syzbot <syzbot+4a606091891fbc6811cf@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, kvm@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pbonzini@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    eabcdba3ad40 Merge tag 'for-6.13-rc3-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12552e0f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1234f097ee657d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=4a606091891fbc6811cf
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13bd77e8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7a4dff87674a/disk-eabcdba3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/266bc2b7ced3/vmlinux-eabcdba3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ee4bcd9be832/bzImage-eabcdba3.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/5d8d9c438eb4/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4a606091891fbc6811cf@syzkaller.appspotmail.com

bcachefs (loop0): dropping and reconstructing all alloc info
------------[ cut here ]------------
CPU 0 old state 7 new state 1
WARNING: CPU: 0 PID: 11600 at kernel/rcu/srcutree.c:734 __srcu_check_read_flavor+0x107/0x150 kernel/rcu/srcutree.c:734
Modules linked in:
CPU: 0 UID: 0 PID: 11600 Comm: syz.0.588 Not tainted 6.13.0-rc3-syzkaller-00073-geabcdba3ad40 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
RIP: 0010:__srcu_check_read_flavor+0x107/0x150 kernel/rcu/srcutree.c:734
Code: c6 c8 01 00 00 4c 89 f0 48 c1 e8 03 42 0f b6 04 20 84 c0 75 38 41 8b 36 48 c7 c7 80 d1 0b 8c 89 ea 44 89 f9 e8 9a 7f db ff 90 <0f> 0b 90 90 eb a2 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 64 ff ff ff
RSP: 0018:ffffc90003c37310 EFLAGS: 00010246
RAX: ccec42c23dd3cf00 RBX: ffffe8ffffc330a0 RCX: ffff88802fceda00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000007 R08: ffffffff81601962 R09: 1ffffffff2030a26
R10: dffffc0000000000 R11: fffffbfff2030a27 R12: dffffc0000000000
R13: 0000607f47633080 R14: ffffe8ffffc33248 R15: 0000000000000001
FS:  00007f51f1dfe6c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9d34769160 CR3: 000000005dcee000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 srcu_check_read_flavor include/linux/srcutree.h:269 [inline]
 srcu_read_lock include/linux/srcu.h:247 [inline]
 __bch2_trans_get+0x7c9/0xd30 fs/bcachefs/btree_iter.c:3228
 bch2_btree_root_read+0xb9/0x7a0 fs/bcachefs/btree_io.c:1771
 read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:523
 bch2_fs_recovery+0x2585/0x39d0 fs/bcachefs/recovery.c:853
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f51f2b874ca
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f51f1dfde68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f51f1dfdef0 RCX: 00007f51f2b874ca
RDX: 00000000200000c0 RSI: 0000000020000000 RDI: 00007f51f1dfdeb0
RBP: 00000000200000c0 R08: 00007f51f1dfdef0 R09: 0000000000808040
R10: 0000000000808040 R11: 0000000000000246 R12: 0000000020000000
R13: 00007f51f1dfdeb0 R14: 0000000000005911 R15: 0000000020000200
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

