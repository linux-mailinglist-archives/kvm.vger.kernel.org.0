Return-Path: <kvm+bounces-64431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1075EC82679
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 21:20:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 68ED14E24D4
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 20:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6455724679F;
	Mon, 24 Nov 2025 20:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xi9NCko6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D04E571
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 20:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764015635; cv=none; b=bYO3BQyGYaE5knQY3WjlKqsXhInjEbursDXmpjVAZSeePXxU2XqqPUdmNWOp2tjI8V7sbDv7Bsi6SOJCXIXODu8SYKoV1qUc1vISJaPeNCrhEBtOZf8DiY0bF+1KUZERMDWzWdhRIv4EGGmB8i0Qj5o5+6v0mnSWFOhYzgLALyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764015635; c=relaxed/simple;
	bh=mgH+6eiOwvbF2RDm2+RRzEYylDRBCtDVXD8tzPnx/+o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kSRiXPfqzH1AhHJ751PdjQjMiH7vhDDhRacsxJ60Qqjq7pP1z1+MZEE37VyGmmAGYbvdBW+m207tayQUx6b3sgsCEO6iDyYxB9PlMBxgv/vI20te5G3+WyT26ZYm1WMEOCxii4K3DTF3nZMCnZNak+k6jiQUCSQqvhwGoQ8or4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xi9NCko6; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29806c42760so188482535ad.2
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 12:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764015633; x=1764620433; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fyAhdIMVAvtumPL8k0goN1w0/JSalQ4lH/7gNKk2MQo=;
        b=Xi9NCko6GA6uS78icl1zrPPfNvieb7xhUMY3sCIQ3spFWszPNyEz00/5wXXK6gfmPN
         OORwAc42X3N4yXgFUMcacgsAzDMB8mI+d6ZmdHLgEsGAC4DHm29vO08jw3PpbXUfEWUn
         43WC6tYG7uNphx1CB7cFISVPMc3fVy4gHAKX0Ghh2eH+q+J6VfLkqwKevDPaBsvll2It
         rOVlbhIh1T1+ApWvxaKs+xcbxBScF8mofBeEsCAuFYC0FdLyl1C/xVWZyRwoX9a64Uct
         GoPYQaXLLqs0sYJBAo82oY5HNVNlwVh90i6cQ12J2ewaHohnvsLwoGQKYCq4RPtdpGzg
         2lMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764015633; x=1764620433;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fyAhdIMVAvtumPL8k0goN1w0/JSalQ4lH/7gNKk2MQo=;
        b=V39i7SdHf1e4fCpXXJZ87xpc/6ak5GVc4Xkh0g63nS0NLmbzE1gHrSxQfqXyz4Xznh
         AfspDVsrpO2LyIqSR/Y5RGR50oldxF5Q0qt802WNHrcYlYVIaY1LTFmZr1An3djeJ3Cd
         pf5KhdaMM0q+myERW7tyg8uXu+nz+XK/rX9yA65G3SxXZBNC0/1n0EabDUSqYVfRtwwg
         7jC08Wvp+1N3H+j5K2N20UjnSZDjVm4EdT85x5ve4uCbExgOea29rTbIZxOYHOsd8hD4
         LdBWVMwMz6C111j/U8SUO+aZhs8IlCGK+iUsT5uI3H4KRkKDc48hk2Qu1dHG0fBvAGXG
         i8OA==
X-Forwarded-Encrypted: i=1; AJvYcCUaNRJuQ2HZX2rtym9yy9BmuAXGwDUCl/zsjEMyOm/vnc2rQSOHeJrqjsuEd3cWdpjhZvc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtCUy3Tvob/2yE/lPDk1wexB47P5Cq0GkE0NpguWMkh45vZWI7
	jYgmlz3yh1nR1t5nHbCia7sYF/LksUqOaKWp7RXeqnJcDirDcp5eHCj7DDhLaviO/19DYIRkq7V
	t/pqBJA==
X-Google-Smtp-Source: AGHT+IHdluuhzFRNzQRwLnMsd+MaLAA/xkP6Drak1QRCGWjs3fCIYrKNAJUc3uFjNzrfDbmRmmGSUAzfig4=
X-Received: from plvv11.prod.google.com ([2002:a17:902:d08b:b0:269:80e0:d704])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3884:b0:295:50f5:c0e1
 with SMTP id d9443c01a7336-29baaf75c90mr1449925ad.15.1764015633341; Mon, 24
 Nov 2025 12:20:33 -0800 (PST)
Date: Mon, 24 Nov 2025 12:20:32 -0800
In-Reply-To: <69246e60.a70a0220.d98e3.008e.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <69246e60.a70a0220.d98e3.008e.GAE@google.com>
Message-ID: <aSS-EO_QigXzRDCy@google.com>
Subject: Re: [syzbot] [kvm-x86?] WARNING in x86_emulate_insn (2)
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+fa52a184ebce1b30ad49@syzkaller.appspotmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 24, 2025, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d724c6f85e80 Add linux-next specific files for 20251121
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=11513612580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=763fb984aa266726
> dashboard link: https://syzkaller.appspot.com/bug?extid=fa52a184ebce1b30ad49
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165638b4580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c00e58580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/b2f349c65e3c/disk-d724c6f8.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/aba40ae987ce/vmlinux-d724c6f8.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/0b98fbfe576f/bzImage-d724c6f8.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+fa52a184ebce1b30ad49@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: arch/x86/kvm/emulate.c:5560 at x86_emulate_insn+0x2909/0x41a0 arch/x86/kvm/emulate.c:5560, CPU#1: syz.1.2382/16268
> Modules linked in:
> CPU: 1 UID: 0 PID: 16268 Comm: syz.1.2382 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
> RIP: 0010:x86_emulate_insn+0x2909/0x41a0 arch/x86/kvm/emulate.c:5560
> Code: 36 31 ff 44 89 f6 e8 66 99 77 00 45 85 f6 0f 84 05 02 00 00 e8 18 95 77 00 41 bf 01 00 00 00 e9 ef e0 ff ff e8 08 95 77 00 90 <0f> 0b 90 48 8b 44 24 50 42 80 3c 20 00 48 8b 5c 24 48 74 08 48 89
> RSP: 0018:ffffc9000d6ff6c0 EFLAGS: 00010293
> RAX: ffffffff814a8468 RBX: 000304000010220a RCX: ffff88807d930000
> RDX: 0000000000000000 RSI: 00000000000000ff RDI: 000000000000001f
> RBP: ffffc9000d6ff7d0 R08: ffff88807d930000 R09: 0000000000000002
> R10: 0000000000000006 R11: 0000000000000000 R12: dffffc0000000000
> R13: 1ffff92001adfee8 R14: 00000000000000ff R15: ffff888060266780
> FS:  00007f90f1e156c0(0000) GS:ffff888125b6f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 00000000745ec000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  x86_emulate_instruction+0xea7/0x20b0 arch/x86/kvm/x86.c:9521
>  kvm_arch_vcpu_ioctl_run+0x1404/0x1cd0 arch/x86/kvm/x86.c:11960
>  kvm_vcpu_ioctl+0x99a/0xed0 virt/kvm/kvm_main.c:4477
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f90f0f8f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f90f1e15038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f90f11e6090 RCX: 00007f90f0f8f749
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
> RBP: 00007f90f1013f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f90f11e6128 R14: 00007f90f11e6090 R15: 00007ffc7b4d1758
>  </TASK>

Given the timing, I assume the just-added AVX emulation support broke something,
but for the life of me I can't repro the splat, and I've spent several hours
going over the code and can't find a smoking gun.  Based on the limited stack
trace and context, AFAICT exception.vector is left at '-1' from init_emulate_ctxt(),
and re-emulating an already-decoded INS after a userspace exit triggers the WARN.

The only path I see that has any possibility of generating X86EMUL_PROPAGATE_FAULT
without setting the exception info is if KVM managed to pass gva=-1ull to
nonpaging_gva_to_gpa(), in which case KVM would regurgitate the gva as the gpa,
which would result in a false positive on INVALID_GPA.  But nonpaging_gva_to_gpa()
should be unreachable given how the guest is configured.

So, to try rule out the AVX changes, linux-next with the AVX changes reverted:

#syz test: https://github.com/sean-jc/linux.git x86/emulator_no_avx

