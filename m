Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DAB34048F
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 12:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhCRLZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 07:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbhCRLZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 07:25:42 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC85C06174A
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 04:25:42 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id j17so2925213qvo.13
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 04:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+5kieSfZQHikZy+t0u45guWK4qjVzWojLIx1bMsN08Y=;
        b=QiPZsnDonKwKx6lgREj/jideyR5nGudaG/tO1CUs+TYtHjZ5K0ZfZwHX9ZUa4wG9Fu
         OFKBCelxUSPTFEX8U2h/7bfcJCg9oMTpqqm60AfiBjluMXAZFwpTnn22nipcYpjrAk7Z
         o9/lbnB0irptmRWqNtuIY7u1xUCoDjxIJUDyhkeeuv8eD6wxpUakHUW/VCzfozw1XVGF
         hbjcM8B1YDpn3Dx+aamZ2S5LxXA3EGVh+O0nWLrw+bCBV0b09VJVnxV2PoeZi6lmY4do
         RWjJ7cjGTT7rPGh5SPVWmwTKVqb2nOLpuPBEeTTq4nTBRgXsmV0N8nD1NJf68K9ptA3D
         QA2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+5kieSfZQHikZy+t0u45guWK4qjVzWojLIx1bMsN08Y=;
        b=oMRgL4rNEjZ/dpy+35j6Sciojucsxf7oDHOf5sU9DM/G5CbCMGyjPRgP7G3rXUXLti
         Hr2WYe994FaHXVCPGs7OHzYKr0MSUmYXqpsj/tt7A1V9n8JeH2lLlHIMAbhx9Lzvxd3F
         ET02XUNhlPL71KUaWxlRruZNINgs/KnG0jfXJGJ9igdxj6JHbVCyry94ThaL4af0DI7P
         LgIrOekWvbTIehIkDL4/R3SjaRZuX6ulIuzwVL0LtrUMOSuR7M7wl/15iFdt6DYWv3bB
         hnTsOOsJIilL6eaBrWZdLqJr5r3LUlyd3lGqGtZsxzbb0u7P1VkF7vUchcZfFAe2EjCH
         iQ5w==
X-Gm-Message-State: AOAM5305hD6xpYFoktjgT5XUn21tOara9bnOP5EkvgZ8xydo5UK5wQYV
        P5Ehfym5HQHHX/cq4bgAlwoIvgDIRm3u+j8MobjMrmvjclKFpQ==
X-Google-Smtp-Source: ABdhPJz81aMMf71OyvUF5HpAq4h7RVGY8sZhVA/SGagF79zwo8tc37OW8MOIjR3qzSztewp9Fi/VNFbQa9Qdv7LRJgY=
X-Received: by 2002:a05:6214:326:: with SMTP id j6mr3782748qvu.13.1616066741037;
 Thu, 18 Mar 2021 04:25:41 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000062c2f60582b90e7d@google.com> <20190225200937.GD23678@linux.intel.com>
 <b1d7d77f-0bd4-45d3-847a-40e7445dd2bbn@googlegroups.com>
In-Reply-To: <b1d7d77f-0bd4-45d3-847a-40e7445dd2bbn@googlegroups.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 18 Mar 2021 12:25:29 +0100
Message-ID: <CACT4Y+YXGFaxqKkMmy-bCSibqu1D6en-j1t--0VcRsd0ys2euA@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in __kvm_mmu_prepare_zap_page
To:     syzbot <syzbot+222746e0104bbb617d51@syzkaller.appspotmail.com>
Cc:     Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Sean Christopherson wrote:
> On Mon, Feb 25, 2019 at 06:50:05AM -0800, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit: 94a47529a645 Add linux-next specific files for 20190222
> > git tree: linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13c1c692c00000
> > kernel config: https://syzkaller.appspot.com/x/.config?x=51cd1c8c39e8a207
> > dashboard link: https://syzkaller.appspot.com/bug?extid=222746e0104bbb617d51
> > compiler: gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro: https://syzkaller.appspot.com/x/repro.syz?x=11fcba7cc00000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+222746...@syzkaller.appspotmail.com
> >
> > BUG: unable to handle kernel paging request at ffff88809c0e1000
> > #PF error: [PROT] [WRITE] [RSVD]
> > PGD b201067 P4D b201067 PUD 21ffff067 PMD 800000009c0001e3
> > Oops: 000b [#1] PREEMPT SMP KASAN
> > CPU: 1 PID: 7863 Comm: syz-executor.2 Not tainted 5.0.0-rc7-next-20190222
> > #41
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > RIP: 0010:__write_once_size include/linux/compiler.h:224 [inline]
> > RIP: 0010:__update_clear_spte_fast arch/x86/kvm/mmu.c:558 [inline]
> > RIP: 0010:mmu_spte_clear_no_track arch/x86/kvm/mmu.c:859 [inline]
> > RIP: 0010:drop_parent_pte arch/x86/kvm/mmu.c:2051 [inline]
> > RIP: 0010:kvm_mmu_unlink_parents arch/x86/kvm/mmu.c:2645 [inline]
> > RIP: 0010:__kvm_mmu_prepare_zap_page+0x1ee/0x11a0 arch/x86/kvm/mmu.c:2683
> > Code: f8 30 60 00 48 89 de 4c 89 e7 e8 bd ad fe ff 4c 89 e0 48 b9 00 00 00
> > 00 00 fc ff df 48 c1 e8 03 80 3c 08 00 0f 85 a5 0d 00 00 <49> c7 04 24 00 00
> > 00 00 e8 c5 30 60 00 4c 89 ea 4c 89 fe 48 89 df
> > RSP: 0018:ffff88809e96faf0 EFLAGS: 00010246
> > RAX: 1ffff1101381c200 RBX: ffff888098149820 RCX: dffffc0000000000
> > RDX: 0000000000000000 RSI: ffffffff810ed2f4 RDI: 0000000000000007
> > RBP: ffff88809e96fbd0 R08: ffff888094052700 R09: ffffed100e339d92
> > R10: ffffed100e339d91 R11: ffff8880719cec8b R12: ffff88809c0e1000
> > R13: ffff88809e96fb70 R14: ffffc90006a39000 R15: ffff88809e96fb68
> > FS: 000000000239b940(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> > CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: ffff88809c0e1000 CR3: 00000000a143a000 CR4: 00000000001426e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> > __kvm_mmu_zap_all+0x1f6/0x350 arch/x86/kvm/mmu.c:5856
>
> This strongly suggests the recent MMU zapping changes[1] are to blame,
> but I haven't had any luck reproducing the bug.
>
> Paolo, were you able to make any headway on the kvm-unit-test issues
> that are potentially due to the MMU changes?
>
> [1] https://patchwork.kernel.org/cover/10798425/

Something has fixed this, let's consider it's this (I did not find any
better candidate):

#syz fix:
KVM: x86: fix handling of role.cr4_pae and rename it to 'gpte_size'


> > kvm_mmu_zap_all+0x18/0x20 arch/x86/kvm/mmu.c:5870
> > kvm_arch_flush_shadow_all+0x16/0x20 arch/x86/kvm/x86.c:9473
> > kvm_mmu_notifier_release+0x63/0xb0
> > arch/x86/kvm/../../../virt/kvm/kvm_main.c:499
> > mmu_notifier_unregister+0x137/0x440 mm/mmu_notifier.c:356
> > kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:745 [inline]
> > kvm_put_kvm+0x553/0xc70 arch/x86/kvm/../../../virt/kvm/kvm_main.c:770
> > kvm_vcpu_release+0x7b/0xa0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2500
> > __fput+0x2e5/0x8d0 fs/file_table.c:278
> > ____fput+0x16/0x20 fs/file_table.c:309
> > task_work_run+0x14a/0x1c0 kernel/task_work.c:113
> > tracehook_notify_resume include/linux/tracehook.h:188 [inline]
> > exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:166
> > prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
> > syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
> > do_syscall_64+0x52d/0x610 arch/x86/entry/common.c:293
> > entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > RIP: 0033:0x411d31
> > Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 94 19 00 00 c3 48
> > 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89
> > c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
> > RSP: 002b:00007ffe9da10de0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> > RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000000411d31
> > RDX: 0000000000000000 RSI: 0000000000740528 RDI: 0000000000000005
> > RBP: 0000000000000000 R08: 0000000000740520 R09: 000000000000dec8
> > R10: 00007ffe9da10d00 R11: 0000000000000293 R12: 0000000000000000
> > R13: 0000000000000001 R14: 0000000000000007 R15: 0000000000000002
> > Modules linked in:
> > CR2: ffff88809c0e1000
> > ---[ end trace 4b53a3c1b491aa63 ]---
> > RIP: 0010:__write_once_size include/linux/compiler.h:224 [inline]
> > RIP: 0010:__update_clear_spte_fast arch/x86/kvm/mmu.c:558 [inline]
> > RIP: 0010:mmu_spte_clear_no_track arch/x86/kvm/mmu.c:859 [inline]
> > RIP: 0010:drop_parent_pte arch/x86/kvm/mmu.c:2051 [inline]
> > RIP: 0010:kvm_mmu_unlink_parents arch/x86/kvm/mmu.c:2645 [inline]
> > RIP: 0010:__kvm_mmu_prepare_zap_page+0x1ee/0x11a0 arch/x86/kvm/mmu.c:2683
> > Code: f8 30 60 00 48 89 de 4c 89 e7 e8 bd ad fe ff 4c 89 e0 48 b9 00 00 00
> > 00 00 fc ff df 48 c1 e8 03 80 3c 08 00 0f 85 a5 0d 00 00 <49> c7 04 24 00 00
> > 00 00 e8 c5 30 60 00 4c 89 ea 4c 89 fe 48 89 df
> > RSP: 0018:ffff88809e96faf0 EFLAGS: 00010246
> > RAX: 1ffff1101381c200 RBX: ffff888098149820 RCX: dffffc0000000000
> > RDX: 0000000000000000 RSI: ffffffff810ed2f4 RDI: 0000000000000007
> > RBP: ffff88809e96fbd0 R08: ffff888094052700 R09: ffffed100e339d92
> > R10: ffffed100e339d91 R11: ffff8880719cec8b R12: ffff88809c0e1000
> > R13: ffff88809e96fb70 R14: ffffc90006a39000 R15: ffff88809e96fb68
> > FS: 000000000239b940(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> > CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: ffff88809c0e1000 CR3: 00000000a143a000 CR4: 00000000001426e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >
> >
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzk...@googlegroups.com.
> >
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with
> > syzbot.
> > syzbot can test patches for this bug, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
