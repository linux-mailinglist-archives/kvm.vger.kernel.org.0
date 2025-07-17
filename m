Return-Path: <kvm+bounces-52742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B716BB08FEF
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 16:54:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E14D3AB81A
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 14:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30C7F2F85E5;
	Thu, 17 Jul 2025 14:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bzimnicN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7512F7CE3
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 14:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752764017; cv=none; b=qdV+3DAmidZuH9ykQYUfuaTc6daRk1szl6WJiDjsAx7tROvxQtnLnIKSNlMuqV7OuVqbZW9RWwxa5S3o7cQKmyQRz1cNCClShvubkwkc05rP8eVJxa6WO8nfBlG0MR9Z0ETzm+KggoyK+Rr7jka9JCDjPxRA++p40wkuxuUcyTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752764017; c=relaxed/simple;
	bh=3Mn1kK8tzmD1WS0Uc7HSvX+hJXq2rcddMFZmTCEf4yA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BCIC+Jt1akxQuyzwn7Qq7Ihk6NtlFGWNatNqeYl5e9Q8/olhMj1WEfFgP3dMw/eZEhv8pQ2skBS5/PnmABjH80E1x6EOcqoWVl69mM3UmnqDjGT0ugQ8ngvmoI07U+iLCjtPAsXnOOEdrUxMT0jlm7lmu3+o2Ma8JzkV6/AIKj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bzimnicN; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311ae2b6647so1144348a91.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 07:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752764015; x=1753368815; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J7wJP1NqWbg0/wW5WuIuZexwRRb7oyj5wBhc3Nu1g94=;
        b=bzimnicN5v+SA/eT5wbwINqcm13vkbKTDuJTEYSp7rPdUHbv/tc37Lg0QtZosQ8QFQ
         mqM/IQ8r2mNLHaKcdUiTSls33KeJ7jRjDlWJV9A+n6yOJTUvCZxc+Xm9HPPdxlhBKTmJ
         OF12K8JvntPbqJ69/neKVPrPTuLHv30qhUUPWYJ4CkJgEg5rOy7zref1gimJCV+q9aG6
         nOVOIPfCE5EIz1prkIFBhaASD3BjUpMEgDQwEWA3Kqo5rSA7kMmo6hhfHQon+0wYkjFb
         2n/wTtRWvPotM8srDAUFhijaJMqcaEU3VQ0g+LXN8b8HvUwjYZV8N4eKH8AcGHh+BqBL
         Xegw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752764015; x=1753368815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J7wJP1NqWbg0/wW5WuIuZexwRRb7oyj5wBhc3Nu1g94=;
        b=Ad8xHuGJCjRPP/IoSSrSXmXkqnaVEeZxXSPcXQnhMl9d2Xfn3iQTQHTGhie3p8NpXY
         Ybu2LR79xN9lsHOeJ16hxGh1XkLBTJWxLDpS3reuIHitEJENjA+2Co5So+/rYXnzp75/
         hhRjTdrOi6vTw00At8SW+OWV656kxua53v8XhZyV6/bLV0g5AxZOzJ6KCBu9lWKYg48Y
         I3RfCJd33/59odFrUcvYa1ghj4pa2DuDToCxhMXUKkif8uVTCOmXmYr2jxtDFF356Lrm
         YsCK/rPblhPqT8rwaeh6qH5bqeETorTKeIcJ4Ic4nRiMltKf39QAyO040zPW7X0DbRD5
         +WUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVahZ8KjrIZcd7rQ02+HWHSfy/HQtv9GakKKyjePf+fRoNvdySBrEkEg2XdzYvbIjINChg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb+WC9wovPE+9wwKBA2f10i2E+NJPa2NV5BEBbDOL61aNHycgf
	z06UVhDmLfv/ybTIoim27yEubHRqoYTwVCtfkcbxq2z0dN7H39AQ9UgaOXAgdpBzYBtMTHHw8S5
	w6wcduw==
X-Google-Smtp-Source: AGHT+IGKxEq/h6VGvllulb+B19zVX8xyn3ukqgkbd5wdwUs0a5DqFBozKOKBvbhqQGpTHmL6bvsTT7LiEXI=
X-Received: from pjbsn8.prod.google.com ([2002:a17:90b:2e88:b0:311:6040:2c7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5624:b0:312:e744:5b76
 with SMTP id 98e67ed59e1d1-31c9e78b84cmr12238484a91.33.1752764015209; Thu, 17
 Jul 2025 07:53:35 -0700 (PDT)
Date: Thu, 17 Jul 2025 07:53:33 -0700
In-Reply-To: <68790db4.a00a0220.3af5df.0020.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <68790db4.a00a0220.3af5df.0020.GAE@google.com>
Message-ID: <aHkObULA-4HV2uNo@google.com>
Subject: Re: [syzbot] [kvm-x86?] WARNING in kvm_arch_vcpu_ioctl_run (6)
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+cc2032ba16cc2018ca25@syzkaller.appspotmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 17, 2025, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    155a3c003e55 Merge tag 'for-6.16/dm-fixes-2' of git://git...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1413e58c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8d5ef2da1e1c848
> dashboard link: https://syzkaller.appspot.com/bug?extid=cc2032ba16cc2018ca25
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1213e58c580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a567d4580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-155a3c00.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/725a320dfe66/vmlinux-155a3c00.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/9f06899bb6f3/bzImage-155a3c00.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+cc2032ba16cc2018ca25@syzkaller.appspotmail.com
> 
> WARNING: CPU: 1 PID: 6108 at arch/x86/kvm/x86.c:11645 kvm_arch_vcpu_ioctl_run+0x13bc/0x18c0 arch/x86/kvm/x86.c:11645
> Modules linked in:
> CPU: 1 UID: 0 PID: 6108 Comm: syz.0.16 Not tainted 6.16.0-rc6-syzkaller-00002-g155a3c003e55 #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:kvm_arch_vcpu_ioctl_run+0x13bc/0x18c0 arch/x86/kvm/x86.c:11645
> Code: 0a 00 00 00 00 00 00 e8 25 88 be 1e 31 ff 89 c5 89 c6 e8 e7 68 7a 00 85 ed 0f 8f f4 f0 ff ff e9 f5 f1 ff ff e8 95 6d 7a 00 90 <0f> 0b 90 e9 9c f0 ff ff e8 87 6d 7a 00 90 0f 0b 90 e9 d3 f0 ff ff
> RSP: 0018:ffffc9000379fc38 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff888044358000 RCX: ffffffff81417587
> RDX: ffff88802327a440 RSI: ffffffff814184eb RDI: 0000000000000007
> RBP: 0000000000000001 R08: 0000000000000007 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000001 R12: ffff88804ff02000
> R13: ffff8880443580d8 R14: 0000000000000000 R15: ffff88804ff02120
> FS:  000055555f07c500(0000) GS:ffff8880d6813000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000005200000c CR3: 0000000033cb3000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  kvm_vcpu_ioctl+0x5eb/0x1690 virt/kvm/kvm_main.c:4464
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:907 [inline]
>  __se_sys_ioctl fs/ioctl.c:893 [inline]
>  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:893
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4f8b18e929
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdc1bf8098 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f4f8b3b5fa0 RCX: 00007f4f8b18e929
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
> RBP: 00007f4f8b210ca1 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f4f8b3b5fa0 R14: 00007f4f8b3b5fa0 R15: 0000000000000003
>  </TASK>

Ha!  syzbot finally found an upstream reproducer:

https://lore.kernel.org/all/20250715190638.1899116-1-seanjc@google.com

