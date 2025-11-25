Return-Path: <kvm+bounces-64574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 65C2FC876E1
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 00:10:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BB344353DA3
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 23:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B02B2ED87C;
	Tue, 25 Nov 2025 23:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iq14uqOh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79F71FAC34
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 23:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764112200; cv=none; b=eksIJv+CWVH9Vj8izQ9odpmt0RoQ0l7tQOrrTUlq2FyWNR3GT63EwGqoI6dQ/bth04L9/nsoMo4WDeL8oiI0BIWl0sX+4sbi7m0Ynb5gmDcTOaYoILdJySR/roFBB1ySe8+BucWGJhZ7G9P14U0Ee2IDWXXl2I0ILxPYv0LqLwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764112200; c=relaxed/simple;
	bh=MIaSGxRK58abxK8Pxlp571HQ953blVmml9b6oNgiNdg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XfLZ/COvjnxUuzf/6ueEk0uuBO8vN3n1JmdNAS4HY7ftdDaH5qlcg/FhSPKuF8s7t/OnRS0PbURMnwB81Sm04LGl91XV0OQN1lnG3luGTXfUfQAonU67JmmOL956/YPGhyBFkQoNyNbefCmny26aJKxNbWy+qj1CFQQVsLUjqak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iq14uqOh; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7be3d08f863so10082156b3a.2
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 15:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764112198; x=1764716998; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nng6joJmGy6+XeXJr3EKRMkSH2usu7bbKSFM443Ij1U=;
        b=iq14uqOhuf3Go8iGH713wzpH/5WYEjV13Z7OwjD48BImPEDqPyEiLqpylv5qH7nA7w
         dEJP6ATZk1bdIDImMjvE2dZFWqwNeDz9MVbb+Q1W4Trtx+jGNoLdxIp0uMnQwHIUEy3d
         66NFCaB02mWxIeBOVZIVmte4z1gDfbb7RPc2tFQNlsHzgkgk/35xYnUUoVxrU2QNq/+E
         7vl1D5pujkip3FnsnI0rStTvTx3e40l/SbxgWaY7LzHDzrQE916lnKKFW4Vtii/fLRru
         H2JjT1FHZD4jsqiVIz1Dt/0srb016UQsFiQfLEOQM3jFBVAzxNNSvvi+YhVm1wn96fh0
         D+Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764112198; x=1764716998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nng6joJmGy6+XeXJr3EKRMkSH2usu7bbKSFM443Ij1U=;
        b=P0EGnePvF+hlqG/Iz6zeGtWTjaJsJL/ug+gUoWAYHiKJ5za9IdoUksAb3V8HdiJbRu
         56xbyji0DlJ4ymBGXlGCKMkXWquakCG3/mfoa+PWHNdj9ltfqCPgSN6/0tNHe3WZ2MzG
         T2yVhixkDA1redY6bCsc0VMQ5dh7Jqhm0LNxsOz7hME0OaeHdCdF4Sm5D1e4F8ovjDO3
         7Z+3IrJEsfirWkORmGGFGWMYJxuMMZ2YCddYe7qG4AXG3FqDVekhIA3HzPWfp/c/Ttod
         W0faQLlgFYjceIMwLmbMAXsD6gWOBHm8ERMgDp6EmiJjXqlaRW0AMHo5N1qdRO7x67MA
         0igQ==
X-Forwarded-Encrypted: i=1; AJvYcCUylsiA6iOUdbNOA1+1r5c2YlL75jHObahKuRJngPDEAqUGJEJqZbL5l3MIvOnpnf/iVC8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxI5LCjIIaC1SJfBHlIO0of9JTibqy7tXir+3Pxkg43ZGRtwZCj
	474ttku8Uqy9vvgW2kvPh+GSFDmv3Il2oy3FWbgDvIRiZGrXyZThUzhzMzAazvo7WrNgzp4rABN
	0KqfGqg==
X-Google-Smtp-Source: AGHT+IFvtq30Qag8GD6C7aPOrI43v4M+DT7LD4s3GLqnqn/t9OpOdnuPOIKhgvzfvalZ3RZ7UvkJH6dXneI=
X-Received: from pgkh8.prod.google.com ([2002:a63:e148:0:b0:bd9:a349:94b2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:99a5:b0:35d:53dc:cb64
 with SMTP id adf61e73a8af0-3614ee0a109mr19007907637.54.1764112197909; Tue, 25
 Nov 2025 15:09:57 -0800 (PST)
Date: Tue, 25 Nov 2025 15:09:56 -0800
In-Reply-To: <692611ac.a70a0220.2ea503.0091.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6925da1b.a70a0220.d98e3.00b0.GAE@google.com> <692611ac.a70a0220.2ea503.0091.GAE@google.com>
Message-ID: <aSY3RJI6uvrbh92_@google.com>
Subject: Re: [syzbot] [kvm-x86?] WARNING in kvm_apic_accept_events (2)
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+59f2c3a3fc4f6c09b8cd@syzkaller.appspotmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 25, 2025, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    8a2bcda5e139 Merge tag 'for-6.18/dm-fixes' of git://git.ke..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1604f8b4580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a1db0fea040c2a9f
> dashboard link: https://syzkaller.appspot.com/bug?extid=59f2c3a3fc4f6c09b8cd
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ecf612580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d9cf42580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8a2bcda5.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/fc3f96645396/vmlinux-8a2bcda5.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/e20aa7be5d33/bzImage-8a2bcda5.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+59f2c3a3fc4f6c09b8cd@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 5495 at arch/x86/kvm/lapic.c:3483 kvm_apic_accept_events+0x341/0x490 arch/x86/kvm/lapic.c:3483
> Modules linked in:
> CPU: 0 UID: 0 PID: 5495 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:kvm_apic_accept_events+0x341/0x490 arch/x86/kvm/lapic.c:3483
> Code: eb 0c e8 32 da 71 00 eb 05 e8 2b da 71 00 45 31 ff 44 89 f8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 10 da 71 00 90 <0f> 0b 90 e9 ec fd ff ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 4f
> RSP: 0018:ffffc90002b2fbf0 EFLAGS: 00010293
> RAX: ffffffff814e3940 RBX: 0000000000000002 RCX: ffff88801f8ca480
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000002
> RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff814689b6
> R10: dffffc0000000000 R11: ffffed1002268008 R12: 0000000000000002
> R13: dffffc0000000000 R14: ffff888042c95c00 R15: ffff8880113402d8
> FS:  000055558ab60500(0000) GS:ffff88808d72f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000002000 CR3: 0000000058d0b000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  kvm_arch_vcpu_ioctl_get_mpstate+0x128/0x480 arch/x86/kvm/x86.c:12147
>  kvm_vcpu_ioctl+0x625/0xe90 virt/kvm/kvm_main.c:4539
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f918bd8f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc74a3c2a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f918bfe5fa0 RCX: 00007f918bd8f749
> RDX: 0000000000000000 RSI: 000000008004ae98 RDI: 0000000000000005
> RBP: 00007f918be13f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f918bfe5fa0 R14: 00007f918bfe5fa0 R15: 0000000000000003
>  </TASK>

Syzbot outsmarted me once again.  I thought I had made this impossible in commit
0fe3e8d804fd ("KVM: x86: Move INIT_RECEIVED vs. INIT/SIPI blocked check to KVM_RUN"),
but now syzkaller is triggering the WARN by swapping the order and stuffing VMXON
after INIT (ignore the EINVAL, KVM gets through enter_vmx_operation() before detecting
bad guest state).

  ioctl(5, KVM_SET_MP_STATE, 0x200000000000) = 0
  ioctl(5, KVM_SET_NESTED_STATE, 0x200000000a80) = -1 EINVAL (Invalid argument)
  ioctl(5, KVM_GET_MP_STATE, 0)           = -1 EFAULT (Bad address)

At this point, I'm leaning strongly towards dropping the WARN as it's not helping,
and userspace doing odd things is completely uninteresting.

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 7b1b8f450f4c..df2a69da11b7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3521,7 +3521,6 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
         * wait-for-SIPI (WFS).
         */
        if (!kvm_apic_init_sipi_allowed(vcpu)) {
-               WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED);
                clear_bit(KVM_APIC_SIPI, &apic->pending_events);
                return 0;
        }

