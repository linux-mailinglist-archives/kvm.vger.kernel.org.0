Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23C4338398
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 03:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbhCLCaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 21:30:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhCLC36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 21:29:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57B2464FA8
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 02:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615516198;
        bh=m2Aghm5fqSPN9M2JO26nIBzTybbJBTXfb09C9MoWK58=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZUNPcJgNe3dM8BoEY8nYHjDN2l44rpKCa4OAUY/3fImvIDcCuSsSXJ45ntzVQOswW
         Ysha8EyV4WAuQiunBmVGnLihuehOe72PAUSCY6IeoQCmH+JG8ciJ58hKWUJSR5FZ5p
         niW1gNUcWK7rTmepXgG2kTBVjk16pKi+nytOWXsVRcIwoxJkig4FVlV1ks/iMgNpA9
         +iXnOss0RYOmUmzkCTcdRInABs43LXA2HwI2hM+jb+dopkFGRZyH5BJda5kyYFp3an
         jS8b/QI85Esk00sPQfjGCDFsYbbdKrsQqFoAvGCkUz6DcAEG5JCTyPZhNeauEeFpoa
         WEAbknQ8qRRVA==
Received: by mail-ej1-f46.google.com with SMTP id p7so39151906eju.6
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 18:29:58 -0800 (PST)
X-Gm-Message-State: AOAM531bCqSLkDr6gF0wJ94+PdAphdnyqL2CFOmYW5miW5bbNscsrZbt
        ToEZwjNfHxd1Aoa61qKlNbz6WqC1LeTafJnwN5yFug==
X-Google-Smtp-Source: ABdhPJznNgj61KVG68+CajgVJpKb6QJLCcHsSOSC4gjYsUH1kE6KKkw/sZty2tNlc7Rs89xjyk6tDIvClRcxoxCQQ9U=
X-Received: by 2002:a17:906:1494:: with SMTP id x20mr6055860ejc.101.1615516196697;
 Thu, 11 Mar 2021 18:29:56 -0800 (PST)
MIME-Version: 1.0
References: <000000000000d356ca05bd4c1974@google.com>
In-Reply-To: <000000000000d356ca05bd4c1974@google.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 11 Mar 2021 18:29:45 -0800
X-Gmail-Original-Message-ID: <CALCETrXUJOHj8PynvZVWgG7jBe6ZtqKpvjhbUM8perbbydRw5Q@mail.gmail.com>
Message-ID: <CALCETrXUJOHj8PynvZVWgG7jBe6ZtqKpvjhbUM8perbbydRw5Q@mail.gmail.com>
Subject: Re: [syzbot] WARNING in handle_mm_fault
To:     syzbot <syzbot+7d7013084f0a806f3786@syzkaller.appspotmail.com>
Cc:     Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Your warning is odd, but I see the bug.  It's in KVM.

On Thu, Mar 11, 2021 at 4:37 PM syzbot
<syzbot+7d7013084f0a806f3786@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    05a59d79 Merge git://git.kernel.org:/pub/scm/linux/kernel/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16f493ead00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=750735fdbc630971
> dashboard link: https://syzkaller.appspot.com/bug?extid=7d7013084f0a806f3786
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+7d7013084f0a806f3786@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> raw_local_irq_restore() called with IRQs enabled
> WARNING: CPU: 0 PID: 8412 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
> Modules linked in:
> CPU: 0 PID: 8412 Comm: syz-fuzzer Not tainted 5.12.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10

The above makes sense, but WTH is the below:

> Code: be ff cc cc cc cc cc cc cc cc cc cc cc 80 3d 11 d1 ad 04 00 74 01 c3 48 c7 c7 20 79 6b 89 c6 05 00 d1 ad 04 01 e8 75 5b be ff <0f> 0b c3 48 39 77 10 0f 84 97 00 00 00 66 f7 47 22 f0 ff 74 4b 48
> RSP: 0000:ffffc9000185fac8 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff8880194268a0 RCX: 0000000000000000
> RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000000
> R13: ffffed1003284d14 R14: 0000000000000001 R15: ffff8880b9c36000
> FS:  000000c00002ec90(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> Call Trace:
>  handle_mm_fault+0x1bc/0x7e0 mm/memory.c:4549
> Code: 48 8d 05 97 25 3e 00 48 89 44 24 08 e8 6d 54 ea ff 90 e8 07 a1 ed ff eb a5 cc cc cc cc cc 8b 44 24 10 48 8b 4c 24 08 89 41 24 <c3> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 48 8b
> RAX: 00000000000047f6 RBX: 00000000000047f6 RCX: 0000000000d60000
> RDX: 0000000000004c00 RSI: 0000000000d60000 RDI: 000000000181cad0
> RBP: 000000c000301890 R08: 00000000000047f5 R09: 000000000059c5a0
> R10: 000000c0004e2000 R11: 0000000000000020 R12: 00000000000000fa
> R13: 00aaaaaaaaaaaaaa R14: 000000000093f064 R15: 0000000000000038
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 8412 Comm: syz-fuzzer Not tainted 5.12.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:

Now we start reading here:

>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  panic+0x306/0x73d kernel/panic.c:231
>  __warn.cold+0x35/0x44 kernel/panic.c:605
>  report_bug+0x1bd/0x210 lib/bug.c:195
>  handle_bug+0x3c/0x60 arch/x86/kernel/traps.c:239
>  exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:259
>  asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:575
> RIP: 0010:warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
> Code: be ff cc cc cc cc cc cc cc cc cc cc cc 80 3d 11 d1 ad 04 00 74 01 c3 48 c7 c7 20 79 6b 89 c6 05 00 d1 ad 04 01 e8 75 5b be ff <0f> 0b c3 48 39 77 10 0f 84 97 00 00 00 66 f7 47 22 f0 ff 74 4b 48
> RSP: 0000:ffffc9000185fac8 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff8880194268a0 RCX: 0000000000000000
> RDX: ffff88802f7b2400 RSI: ffffffff815b4435 RDI: fffff5200030bf4b
> RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815ad19e R11: 0000000000000000 R12: 0000000000000003
> R13: ffffed1003284d14 R14: 0000000000000001 R15: ffff8880b9c36000
>  kvm_wait arch/x86/kernel/kvm.c:860 [inline]

and there's the bug:

        /*
         * halt until it's our turn and kicked. Note that we do safe halt
         * for irq enabled case to avoid hang when lock info is overwritten
         * in irq spinlock slowpath and no spurious interrupt occur to save us.
         */
        if (arch_irqs_disabled_flags(flags))
                halt();
        else
                safe_halt();

out:
        local_irq_restore(flags);
}

The safe_halt path is bogus.  It should just return instead of
restoring the IRQ flags.

--Andy
