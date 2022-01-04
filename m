Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D57484255
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 14:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbiADNZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 08:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiADNZD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 08:25:03 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FA9C061761;
        Tue,  4 Jan 2022 05:25:03 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id v22-20020a9d4e96000000b005799790cf0bso47208885otk.5;
        Tue, 04 Jan 2022 05:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AZWJL+gXmk9nQBeyFLHDpAekZAv6FMjG6sXlfZgRTFM=;
        b=QqwVDX4CcHzfd8gVVfUzvrjEPSM8kf3TC8a/0CLvsnk7bvRgnpdZ0P6rlhH4hYZX+o
         wtn1TMk1arYpk+x+Ujrj5ry9JJzlPJyQuef3b+zOQE/OCP2YDOfqjs5tnafmDJbmLVQX
         7PGXik4cyWM+uOm/FpQZcUoWzM6Tyn651d2tiMw+Uqhn7mEKvBufZUoc7cdz0yOADF0l
         T49I/vgcWLgQnE9gfAdFuRx7OxEjmv6rk9HUkXOh+KYlnJbE2pqykJPPRsS+U1ADv+i1
         YqEbmSiaUmNNKI0DhN42NbhUqWfNELekZverXOZuWkB3v6vkbj6USZT7JywubSjpjPpD
         3wJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AZWJL+gXmk9nQBeyFLHDpAekZAv6FMjG6sXlfZgRTFM=;
        b=6W+5oVgRzQR27XgoSr/ifjCuIYE3bJ+m+/ztAk7g2gQksFe3Xp8In3F4Fqk+XPCt36
         SRsgxyeg6p9HgrnbOAcpbctR8R6KusM7+R8vgYFw9aItlbVH71Lm95fA7925CFoWvnJo
         9aN87AySCcI0XAHkwukdLC65sF5xH1wJEzo4mOD5SMyfeY9XuwuEMK+5sC9vPQ/gzABO
         4PwJiIqOV1nlSFE9lg6RZ2Ecz3lX8x4RLMz7waXx2XlCTlTff7Cpyug4KGHqxw1C79CF
         XTY1SMGDzCf2B0N1y2ZmM1OvihxkjwdH5hfpXRuQAo+T1JnhZG7LxXdjTNtmVqr9+XWI
         wMuw==
X-Gm-Message-State: AOAM530+0smU5iawSdjVJn7xtqQ5gDIdPGYAsGbLVpxCiwdVZ1ihSXxz
        trs7VciMfJdYmxDEufvOBNL5BODQSCueAN7DEko=
X-Google-Smtp-Source: ABdhPJyG6Xy2yNlKmC/eifcIKXY8WzbwmhG0iqlYA6LUbahA6zSxu7E/QDfkgM6o0I9ljLdqr+W3sTMNafdrIVCeauI=
X-Received: by 2002:a05:6830:4d1:: with SMTP id s17mr35692233otd.246.1641302702663;
 Tue, 04 Jan 2022 05:25:02 -0800 (PST)
MIME-Version: 1.0
References: <CAFkrUsirdW1j_nhFK23x99itQ7=eXqAWFK5xYo7Mjmg+8zPmLw@mail.gmail.com>
In-Reply-To: <CAFkrUsirdW1j_nhFK23x99itQ7=eXqAWFK5xYo7Mjmg+8zPmLw@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 4 Jan 2022 21:24:51 +0800
Message-ID: <CANRm+CwHxxge61DGA=pmQfyY7F0iEdDMmTRWBOd5R_+m1XCFkA@mail.gmail.com>
Subject: Re: possible deadlock in svm_vm_copy_asid_from
To:     kvartet <xyru1999@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com, sunhao.th@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Jan 2022 at 19:01, kvartet <xyru1999@gmail.com> wrote:
>
> Hello,
>
> When using Syzkaller to fuzz the latest Linux kernel, the following
> crash was triggered.
>
> HEAD commit: a7904a538933 Linux 5.16-rc6
> git tree: upstream
> console output: https://paste.ubuntu.com/p/GCRXrYQmMN/plain/
> kernel config: https://paste.ubuntu.com/p/FDDNHDxtwz/plain/
> C reproducer: https://paste.ubuntu.com/p/gD2D5wthDK/plain/
> Syzlang reproducer: https://paste.ubuntu.com/p/hTnbvmsW8r/plain/
>
> ============================================
> WARNING: possible recursive locking detected
> 5.16.0-rc6 #9 Not tainted
> --------------------------------------------
> syz-executor.6/4919 is trying to acquire lock:
> ffffc9000afbb250 (&kvm->lock){+.+.}-{3:3}, at: sev_lock_two_vms
> arch/x86/kvm/svm/sev.c:1568 [inline]
> ffffc9000afbb250 (&kvm->lock){+.+.}-{3:3}, at:
> svm_vm_copy_asid_from+0x1bd/0x380 arch/x86/kvm/svm/sev.c:1988
>
> but task is already holding lock:
> ffffc9000a703250 (&kvm->lock){+.+.}-{3:3}, at: sev_lock_two_vms
> arch/x86/kvm/svm/sev.c:1566 [inline]
> ffffc9000a703250 (&kvm->lock){+.+.}-{3:3}, at:
> svm_vm_copy_asid_from+0x188/0x380 arch/x86/kvm/svm/sev.c:1988
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(&kvm->lock);
>   lock(&kvm->lock);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 1 lock held by syz-executor.6/4919:
>  #0: ffffc9000a703250 (&kvm->lock){+.+.}-{3:3}, at: sev_lock_two_vms
> arch/x86/kvm/svm/sev.c:1566 [inline]
>  #0: ffffc9000a703250 (&kvm->lock){+.+.}-{3:3}, at:
> svm_vm_copy_asid_from+0x188/0x380 arch/x86/kvm/svm/sev.c:1988
>
> stack backtrace:
> CPU: 1 PID: 4919 Comm: syz-executor.6 Not tainted 5.16.0-rc6 #9
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_deadlock_bug kernel/locking/lockdep.c:2956 [inline]
>  check_deadlock kernel/locking/lockdep.c:2999 [inline]
>  validate_chain kernel/locking/lockdep.c:3788 [inline]
>  __lock_acquire.cold+0x168/0x3c3 kernel/locking/lockdep.c:5027
>  lock_acquire kernel/locking/lockdep.c:5637 [inline]
>  lock_acquire+0x1ab/0x520 kernel/locking/lockdep.c:5602
>  __mutex_lock_common kernel/locking/mutex.c:607 [inline]
>  __mutex_lock+0x151/0x1610 kernel/locking/mutex.c:740
>  sev_lock_two_vms arch/x86/kvm/svm/sev.c:1568 [inline]
>  svm_vm_copy_asid_from+0x1bd/0x380 arch/x86/kvm/svm/sev.c:1988
>  kvm_vm_ioctl_enable_cap+0xf8/0xc40 arch/x86/kvm/x86.c:5829
>  kvm_vm_ioctl_enable_cap_generic
> arch/x86/kvm/../../../virt/kvm/kvm_main.c:4241 [inline]
>  kvm_vm_ioctl+0x3dd/0x23a0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4300
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:874 [inline]
>  __se_sys_ioctl fs/ioctl.c:860 [inline]
>  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fc4241dc89d
> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fc422b4dc28 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007fc4242fbf60 RCX: 00007fc4241dc89d
> RDX: 0000000020000080 RSI: 000000004068aea3 RDI: 0000000000000004
> RBP: 00007fc42424900d R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffc9816f67f R14: 00007fc4242fbf60 R15: 00007fc422b4ddc0
>  </TASK>

Maybe mutex_lock_killable_nested(), I will have a try.

    Wanpeng
