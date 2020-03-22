Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 960B918E749
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 08:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgCVHDc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 03:03:32 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36698 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgCVHDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 03:03:31 -0400
Received: by mail-qt1-f194.google.com with SMTP id m33so8951847qtb.3
        for <kvm@vger.kernel.org>; Sun, 22 Mar 2020 00:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uCqt57idHmjJkKnDV2pTVzQGXYCvhK7v2Ozv+3+3YEg=;
        b=Tn415uxJNNTQG79PfTWRWpdm6R8uAj2JDlwOw4uQ8u9fefXMwDv6/buYtnLAGVYr+E
         AK951bj/IOQaMLWg9fP5VGnmwePhOXejkT1vNXUF2zViSW/8rHuPSr+h4jSqEPqXe+ax
         LLShs6pJSklfF3RK+7oba0McfXq+/YGTMK/+7+licgA1FmkwSvwospmu8GQIdzg2cPbx
         JjsoUyDes6+BLQURibtp0YAvVCH5J9dvd6ACSlKeAhsE0qqlSQcMDfLPaSdpG01XuYbY
         fQqiuO+BwvZjN8JU0sOxKuRaW1dnxQ0bpt2GFvmoynTxwzScaNk1p8C5CgLfaJ7PWktv
         jjpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uCqt57idHmjJkKnDV2pTVzQGXYCvhK7v2Ozv+3+3YEg=;
        b=nbRkihDYoCTBPA3zZzqiyH+UC+/7biIqlgMIcWLUV5jPnrXMeO4zkSCvEfXQJbcp59
         RevpAUi63eF3QE3tlpwyAvtmZwRN4gi4s9HmR4OTEvvJPgo3MvgM/anYumCzCwsOj2xm
         iNVoyT6vRhfEabD/zD3lDki0Zo7fHWnlyVHpaKUqC6RUTNYtMyQYpJtcbScj/KRPqhBf
         sv7mcSKsGzoP1AGqIrRZjJvwJySFFvmpxI8jFga1LTwMw4aBfUHsR+JL2Jph/KQY7IiI
         gDILByGEKQlO1PC5ca0p+hBLIqUzUMKlo/+kB+BoeO3jteUckWIAbds0FKfvXEk/VH2u
         cOOw==
X-Gm-Message-State: ANhLgQ28KQZEzeevAHxKQ2YkK0UhwxWoD8PZfXW3/XuXmJ72DYFi/anM
        W85wpCyh6dRDDEMV0O6JUd6Z0O3vv0dKolJCbRS7OA==
X-Google-Smtp-Source: ADFU+vvdAkqi6cZjPmLyQu1GA6EVwai8Wq264eWSqCEk45vpbm0AnJf/bANXXDZt8OWjDFIPsyMjm8XoFN9APbpyDm0=
X-Received: by 2002:aed:2591:: with SMTP id x17mr16170685qtc.380.1584860608200;
 Sun, 22 Mar 2020 00:03:28 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000277a0405a16bd5c9@google.com> <CACT4Y+b1WFT87pWQaXD3CWjyjoQaP1jcycHdHF+rtxoR5xW1ww@mail.gmail.com>
In-Reply-To: <CACT4Y+b1WFT87pWQaXD3CWjyjoQaP1jcycHdHF+rtxoR5xW1ww@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sun, 22 Mar 2020 08:03:17 +0100
Message-ID: <CACT4Y+Zs5YCRgpsu6v781HvEUU6EZEuz=zj=D2VXQxrO3_L4aA@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in handle_external_interrupt_irqoff
To:     syzbot <syzbot+3f29ca2efb056a761e38@syzkaller.appspotmail.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Cc:     Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, wanpengli@tencent.com,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 22, 2020 at 7:59 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Sun, Mar 22, 2020 at 7:43 AM syzbot
> <syzbot+3f29ca2efb056a761e38@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    b74b991f Merge tag 'block-5.6-20200320' of git://git.kerne..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16403223e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=6dfa02302d6db985
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3f29ca2efb056a761e38
> > compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+3f29ca2efb056a761e38@syzkaller.appspotmail.com
>
> +clang-built-linux
>
> This only happens on the instance that uses clang. So potentially this
> is related to clang. The instance also uses smack lsm, but it's less
> likely to be involved I think.
> This actually started happening around Mar 6, but the ORC unwinder
> somehow fails to unwind stack and prints only questionable frames, so
> the reports were classified as "corrupted" and all thrown in the
> "corrupted reports" bucket:
> https://syzkaller.appspot.com/bug?id=d5bc3e0c66d200d72216ab343a67c4327e4a3452
>
> There is already some discussion about this on the clang-built-linux list:
> https://groups.google.com/d/msg/clang-built-linux/Cm3VojRK69I/cfDGxIlTAwAJ
>
> The handle_external_interrupt_irqoff has some inline asm and the
> special STACK_FRAME_NON_STANDARD. So it has some potential for bad
> interaction with compilers...
>
> The commit range is presumably
> fb279f4e238617417b132a550f24c1e86d922558..63849c8f410717eb2e6662f3953ff674727303e7
> But I don't see anything that says "it's me". The only commit that
> does non-trivial changes to x86/vmx seems to be "KVM: VMX: check
> descriptor table exits on instruction emulation":
>
> $ git log --oneline
> fb279f4e238617417b132a550f24c1e86d922558..63849c8f410717eb2e6662f3953ff674727303e7
> virt/kvm/ arch/x86/kvm/
> 86f7e90ce840a KVM: VMX: check descriptor table exits on instruction emulation
> e951445f4d3b5 Merge tag 'kvmarm-fixes-5.6-1' of
> git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
> ef935c25fd648 kvm: x86: Limit the number of "kvm: disabled by bios" messages
> aaec7c03de92c KVM: x86: avoid useless copy of cpufreq policy
> 4f337faf1c55e KVM: allow disabling -Werror
> 575b255c1663c KVM: x86: allow compiling as non-module with W=1
> 7943f4acea3ca KVM: SVM: allocate AVIC data structures based on kvm_amd
> module parameter
> b3f15ec3d809c kvm: arm/arm64: Fold VHE entry/exit work into kvm_vcpu_run_vhe()
> 51b2569402a38 KVM: arm/arm64: Fix up includes for trace.h


And the problem with this crash is that it happens all the time,
basically the only crash that now happens on the instance. So
effectively all kernel testing of all subsystems has stalled due to
this.


> > BUG: kernel NULL pointer dereference, address: 0000000000000086
> > #PF: supervisor instruction fetch in kernel mode
> > #PF: error_code(0x0010) - not-present page
> > PGD a63a4067 P4D a63a4067 PUD a7627067 PMD 0
> > Oops: 0010 [#1] PREEMPT SMP KASAN
> > CPU: 0 PID: 9785 Comm: syz-executor.2 Not tainted 5.6.0-rc6-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > RIP: 0010:0x86
> > Code: Bad RIP value.
> > RSP: 0018:ffffc90001ac7998 EFLAGS: 00010086
> > RAX: ffffc90001ac79c8 RBX: fffffe0000000000 RCX: 0000000000040000
> > RDX: ffffc9000e20f000 RSI: 000000000000b452 RDI: 000000000000b453
> > RBP: 0000000000000ec0 R08: ffffffff83987523 R09: ffffffff811c7eca
> > R10: ffff8880a4e94200 R11: 0000000000000002 R12: dffffc0000000000
> > R13: fffffe0000000ec8 R14: ffffffff880016f0 R15: fffffe0000000ecb
> > FS:  00007fb50e370700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000000000000005c CR3: 0000000092fc7000 CR4: 00000000001426f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  handle_external_interrupt_irqoff+0x154/0x280 arch/x86/kvm/vmx/vmx.c:6274
> >  kvm_before_interrupt arch/x86/kvm/x86.h:343 [inline]
> >  handle_external_interrupt_irqoff+0x132/0x280 arch/x86/kvm/vmx/vmx.c:6272
> >  __irqentry_text_start+0x8/0x8
> >  vcpu_enter_guest+0x6c77/0x9290 arch/x86/kvm/x86.c:8405
> >  save_stack mm/kasan/common.c:72 [inline]
> >  set_track mm/kasan/common.c:80 [inline]
> >  kasan_set_free_info mm/kasan/common.c:337 [inline]
> >  __kasan_slab_free+0x12e/0x1e0 mm/kasan/common.c:476
> >  __cache_free mm/slab.c:3426 [inline]
> >  kfree+0x10a/0x220 mm/slab.c:3757
> >  tomoyo_path_number_perm+0x525/0x690 security/tomoyo/file.c:736
> >  security_file_ioctl+0x55/0xb0 security/security.c:1441
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >  __lock_acquire+0xc5a/0x1bc0 kernel/locking/lockdep.c:3954
> >  test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
> >  hlock_class kernel/locking/lockdep.c:163 [inline]
> >  mark_lock+0x107/0x1650 kernel/locking/lockdep.c:3642
> >  lock_acquire+0x154/0x250 kernel/locking/lockdep.c:4484
> >  rcu_lock_acquire+0x9/0x30 include/linux/rcupdate.h:208
> >  kvm_check_async_pf_completion+0x34e/0x360 arch/x86/kvm/../../../virt/kvm/async_pf.c:137
> >  vcpu_run+0x3a3/0xd50 arch/x86/kvm/x86.c:8513
> >  kvm_arch_vcpu_ioctl_run+0x419/0x880 arch/x86/kvm/x86.c:8735
> >  kvm_vcpu_ioctl+0x67c/0xa80 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2932
> >  kvm_vm_release+0x50/0x50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:858
> >  vfs_ioctl fs/ioctl.c:47 [inline]
> >  ksys_ioctl fs/ioctl.c:763 [inline]
> >  __do_sys_ioctl fs/ioctl.c:772 [inline]
> >  __se_sys_ioctl+0xf9/0x160 fs/ioctl.c:770
> >  do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:294
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > Modules linked in:
> > CR2: 0000000000000086
> > ---[ end trace 4da75c292cd7e3e8 ]---
> > RIP: 0010:0x86
> > Code: Bad RIP value.
> > RSP: 0018:ffffc90001ac7998 EFLAGS: 00010086
> > RAX: ffffc90001ac79c8 RBX: fffffe0000000000 RCX: 0000000000040000
> > RDX: ffffc9000e20f000 RSI: 000000000000b452 RDI: 000000000000b453
> > RBP: 0000000000000ec0 R08: ffffffff83987523 R09: ffffffff811c7eca
> > R10: ffff8880a4e94200 R11: 0000000000000002 R12: dffffc0000000000
> > R13: fffffe0000000ec8 R14: ffffffff880016f0 R15: fffffe0000000ecb
> > FS:  00007fb50e370700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000000000000005c CR3: 0000000092fc7000 CR4: 00000000001426f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >
> >
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > --
> > You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000277a0405a16bd5c9%40google.com.
