Return-Path: <kvm+bounces-62550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 84E48C4885C
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:23:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BAAF91886FDB
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 576F832AAAF;
	Mon, 10 Nov 2025 18:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EixBAtBQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F84328622
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 18:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799028; cv=none; b=j5nyBNwbXzTIt7QXGwcayIYnoHDX8gjaRGu6oaDyKh7bHmRusTYn6WkNmnWxqHT71hmVj52wrIam62FlqGKJmrZDnZAuJxllgDnzcnTF5OuA4E5KuzrRenkL2Q8A201CHHVZIg8I7bUMVSoVzkNmmzosXtf59V96ixMMsiJ0zcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799028; c=relaxed/simple;
	bh=0B5t6DWhDiwMV6cYZ+zAwswI7QSnPE13XKjJKivILI8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SGACNMq0EPTjYBCZPBu92vWYA5nh7vKAmwESPjR42mhZRUM0aFRfLEhH2l1tf49koJVb+nb7inLvUjSgowY27GGIB/T2rFp9o9OXCY9FuQtfjGGMOcKXgEPW1mydEYdQj7XQinaaV7geXW0VOJENUNHadVidkRUoDf4dim9Xc+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EixBAtBQ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2958c80fcabso91476185ad.0
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 10:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762799026; x=1763403826; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4/RtuixS6ivHaJzMt+cypZgpKYgDJDNLyz12fZKnsp0=;
        b=EixBAtBQcHIbxnbECgTVfCMhh0Q8b1aqZW6pSgKUZ+tIoKLnyg1izjOhbDQ7gmFLwN
         8ujkOCVEiUu70iju58EeQj4kMpDPskMwYgEitGyTZMat5qn3nF+Mv+J3scEroxB5Hgtj
         2QbY+gUKRGtDGuesOZbRAxcLxN+vSiM6nXQrFrP6Jji5Siz1FrP/xP5nIqJnbOvZwhmI
         qDyjhPVpWo+P3UP7CF31c2p3hSHTCxgq1uyEJ4cDy6u0L9KQwNuE4Jcyx8S/2Kk/oqYd
         u8x/0IJQqZH/lkxSjte3dYVIZk1hfKmnW093mJyJjtzC3eYD4HoX7EIYtG9AuV58FdwS
         UNdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762799026; x=1763403826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4/RtuixS6ivHaJzMt+cypZgpKYgDJDNLyz12fZKnsp0=;
        b=DvmAVsGnvtleFh09E1SeTKaN7wul/L+sU40BO6E2n4xXF8HhX3hFARt/iO9y0h6T5C
         ha5uqormKk2Bf5tb9GmCuCH6DFfKDMcO15/ipCUjcttKNFv5jkFr0LUVaDh/4+jBHwmu
         /dTjXBIQGApcf7W1ANJOyDQurm76mPfzIARIB+d7IfVH8AvrVusVEM2bEjonTz8uMONi
         eQuJhm5AKx25/0n2aVpXkAS2nFCp8PKPdNhFnY2u+Qf1TVQDwoBNNrI9ZiMiEOMvk8gh
         gCQApRpSL7u4RVQg0ebABaSIl51R1wpbM/SRN2GFw6yBddQZnembclhlEw7iyGKsWcfc
         hhhA==
X-Forwarded-Encrypted: i=1; AJvYcCUDCG8Xcsp8a5rMnGOHQ6UBCXQRHUzQ++t2tfAj9GKlcwjt8PXLmdTw4s1/6HEZY/K6oeQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5z8AYbFyfZWU6ElpI2j+dXxmgjZ0dWKTwBi4xsvGHwbjS/8YU
	LNs5zuCHMjuPx9xW+78DSxz7AcHOlhBEAqlVTJVXBtCruaJpm6sznXNm/RIE+CuVnMbGgwNxg06
	Ec3z++Q==
X-Google-Smtp-Source: AGHT+IHLjhF/B9JRNWlfF4xQjImNcP66JBbSmi5nz2WQmt8Y80nCa0FnJnmx6rkg3zEfysgHKy0W5hbcKSg=
X-Received: from plpn7.prod.google.com ([2002:a17:902:9687:b0:296:18d:ea16])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a0c:b0:297:f8dd:4d8e
 with SMTP id d9443c01a7336-297f8dd5382mr86324925ad.30.1762799026327; Mon, 10
 Nov 2025 10:23:46 -0800 (PST)
Date: Mon, 10 Nov 2025 10:23:44 -0800
In-Reply-To: <690e0be4.a70a0220.22f260.0050.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <690e0be4.a70a0220.22f260.0050.GAE@google.com>
Message-ID: <aRItsJNnsja0Wj2W@google.com>
Subject: Re: [syzbot] [kvm-x86?] WARNING in kvm_arch_can_dequeue_async_page_present
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+6bea72f0c8acbde47c55@syzkaller.appspotmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 07, 2025, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9c0826a5d9aa Add linux-next specific files for 20251107
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=13a67012580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4f8fcc6438a785e7
> dashboard link: https://syzkaller.appspot.com/bug?extid=6bea72f0c8acbde47c55
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e110b4580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ab1114580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/6b76dc0ec17f/disk-9c0826a5.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/522b6d2a1d1d/vmlinux-9c0826a5.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/4a58225d70f3/bzImage-9c0826a5.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+6bea72f0c8acbde47c55@syzkaller.appspotmail.com
> 
> kvm_intel: L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
> ------------[ cut here ]------------
> WARNING: arch/x86/kvm/x86.c:13965 at kvm_arch_can_dequeue_async_page_present+0x1a9/0x2f0 arch/x86/kvm/x86.c:13965, CPU#0: syz.0.17/5998
> Modules linked in:
> CPU: 0 UID: 0 PID: 5998 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
> RIP: 0010:kvm_arch_can_dequeue_async_page_present+0x1a9/0x2f0 arch/x86/kvm/x86.c:13965
> Code: 00 65 48 8b 0d 58 81 72 11 48 3b 4c 24 40 75 21 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d e9 3e af 20 0a cc e8 48 e1 79 00 90 <0f> 0b 90 b0 01 eb c0 e8 4b c1 1d 0a f3 0f 1e fa 4c 8d b3 f8 02 00
> RSP: 0018:ffffc90003167460 EFLAGS: 00010293
> RAX: ffffffff8147eee8 RBX: ffff888030280000 RCX: ffff88807fda1e80
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000009
> RBP: ffffc900031674e8 R08: ffff88803028003f R09: 1ffff11006050007
> R10: dffffc0000000000 R11: ffffed1006050008 R12: 1ffff9200062ce8c
> R13: dffffc0000000000 R14: 0000000000000000 R15: dffffc0000000000
> FS:  000055556a8c3500(0000) GS:ffff888125a79000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000072cc2000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  kvm_check_async_pf_completion+0x102/0x3c0 virt/kvm/async_pf.c:158
>  vcpu_enter_guest arch/x86/kvm/x86.c:11209 [inline]
>  vcpu_run+0x26be/0x7760 arch/x86/kvm/x86.c:11650
>  kvm_arch_vcpu_ioctl_run+0x116c/0x1cb0 arch/x86/kvm/x86.c:11995
>  kvm_vcpu_ioctl+0x99a/0xed0 virt/kvm/kvm_main.c:4477
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f1588b8f6c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdfcd816a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f1588de5fa0 RCX: 00007f1588b8f6c9
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000006
> RBP: 00007f1588c11f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f1588de5fa0 R14: 00007f1588de5fa0 R15: 0000000000000003
>  </TASK>
> 
> 
> ---

Now that the buggy patch is gone from linux-next...

#syz invalid

