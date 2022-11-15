Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7190562A1D9
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 20:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiKOT1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 14:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiKOT1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 14:27:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E022F655;
        Tue, 15 Nov 2022 11:27:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2192D6198A;
        Tue, 15 Nov 2022 19:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0A8C433C1;
        Tue, 15 Nov 2022 19:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668540450;
        bh=kSyx/KDI/lGG04xAJ2u37OzD4kOJzFK0dVwK5O19In0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tNmfWvZm01XM2EqNasmoorUKI0N7BH0Ir1nRMEDiryF0wELZgubd0XvbaQd7WKWgB
         PI3UJGBraTgi5gwpupBt1gIqwedphy4pOKqlDnAKSv8eqIUpY13XydXFk3amGSDKy8
         FdiNcjctXWJeusZL8bmk10MQOptP97s0K8KfSLAE=
Date:   Tue, 15 Nov 2022 11:27:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     syzbot <syzbot+644848628d5e12d5438c@syzkaller.appspotmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        syzkaller-bugs@googlegroups.com, kvm@vger.kernel.org
Subject: Re: [syzbot] kernel BUG in workingset_activation (2)
Message-Id: <20221115112729.1c82988047557e45765cc42d@linux-foundation.org>
In-Reply-To: <000000000000a2c79f05ed84c7f9@google.com>
References: <000000000000a2c79f05ed84c7f9@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Nov 2022 08:23:44 -0800 syzbot <syzbot+644848628d5e12d5438c@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:

Thanks.

> HEAD commit:    f4bc5bbb5fef Merge tag 'nfsd-5.17-2' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16c683d8700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5707221760c00a20
> dashboard link: https://syzkaller.appspot.com/bug?extid=644848628d5e12d5438c
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1691d2c2700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16cde752700000
> 
> Bisection is inconclusive: the issue happens on the oldest tested release.
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=174c8174700000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=14cc8174700000
> console output: https://syzkaller.appspot.com/x/log.txt?x=10cc8174700000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+644848628d5e12d5438c@syzkaller.appspotmail.com
> 
>  do_one_initcall+0x103/0x650 init/main.c:1300
>  do_initcall_level init/main.c:1373 [inline]
>  do_initcalls init/main.c:1389 [inline]
>  do_basic_setup init/main.c:1408 [inline]
>  kernel_init_freeable+0x6b1/0x73a init/main.c:1613
>  kernel_init+0x1a/0x1d0 init/main.c:1502
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> ------------[ cut here ]------------
> kernel BUG at include/linux/memcontrol.h:470!

That's

	VM_BUG_ON_FOLIO(folio_test_slab(folio), folio);

in folio_memcg_rcu().

I'll cc the KVM list.

> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 3678 Comm: syz-executor106 Not tainted 5.17.0-rc3-syzkaller-00043-gf4bc5bbb5fef #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:folio_memcg_rcu include/linux/memcontrol.h:470 [inline]
> RIP: 0010:workingset_activation+0x4f2/0x5d0 mm/workingset.c:412
> Code: 48 89 ef e8 50 01 00 00 c6 05 da cf d3 0b 01 0f 0b e9 0e fd ff ff e8 6d 90 cc ff 48 c7 c6 c0 0c b7 89 48 89 ef e8 2e 01 00 00 <0f> 0b e8 57 90 cc ff 0f 0b e9 e6 fb ff ff e8 4b 90 cc ff 48 c7 c6
> RSP: 0018:ffffc90002ac7490 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
> RDX: ffff8880729940c0 RSI: ffffffff81ab1de2 RDI: 0000000000000003
> RBP: ffffea0001aa0000 R08: 0000000000000018 R09: 00000000ffffffff
> R10: ffffffff8908d53c R11: 00000000ffffffff R12: 0000000000000000
> R13: ffff8880b9c34da8 R14: dffffc0000000000 R15: 0000000000000003
> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fa33152f1f0 CR3: 000000001b7f5000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  folio_mark_accessed+0x596/0xdd0 mm/swap.c:442
>  kvm_set_pfn_accessed arch/x86/kvm/../../../virt/kvm/kvm_main.c:2821 [inline]
>  kvm_set_pfn_accessed+0x1d8/0x220 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2818
>  handle_changed_spte_acc_track arch/x86/kvm/mmu/tdp_mmu.c:233 [inline]
>  handle_changed_spte_acc_track+0x1bc/0x290 arch/x86/kvm/mmu/tdp_mmu.c:225
>  handle_changed_spte arch/x86/kvm/mmu/tdp_mmu.c:485 [inline]
>  handle_removed_tdp_mmu_page arch/x86/kvm/mmu/tdp_mmu.c:370 [inline]
>  __handle_changed_spte+0xb93/0x13e0 arch/x86/kvm/mmu/tdp_mmu.c:475
>  handle_changed_spte arch/x86/kvm/mmu/tdp_mmu.c:483 [inline]
>  handle_removed_tdp_mmu_page arch/x86/kvm/mmu/tdp_mmu.c:370 [inline]
>  __handle_changed_spte+0xb84/0x13e0 arch/x86/kvm/mmu/tdp_mmu.c:475
>  handle_changed_spte arch/x86/kvm/mmu/tdp_mmu.c:483 [inline]
>  handle_removed_tdp_mmu_page arch/x86/kvm/mmu/tdp_mmu.c:370 [inline]
>  __handle_changed_spte+0xb84/0x13e0 arch/x86/kvm/mmu/tdp_mmu.c:475
>  __tdp_mmu_set_spte+0x227/0xa70 arch/x86/kvm/mmu/tdp_mmu.c:595
>  tdp_mmu_set_spte arch/x86/kvm/mmu/tdp_mmu.c:609 [inline]
>  zap_gfn_range+0xd4c/0xe00 arch/x86/kvm/mmu/tdp_mmu.c:751
>  __kvm_tdp_mmu_zap_gfn_range+0xdc/0x110 arch/x86/kvm/mmu/tdp_mmu.c:779
>  kvm_tdp_mmu_zap_gfn_range arch/x86/kvm/mmu/tdp_mmu.h:27 [inline]
>  kvm_tdp_mmu_zap_all+0x26/0x70 arch/x86/kvm/mmu/tdp_mmu.c:791
>  kvm_mmu_zap_all+0x27c/0x2c0 arch/x86/kvm/mmu/mmu.c:5983
>  kvm_mmu_notifier_release+0x5f/0xa0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:819
>  mn_hlist_release mm/mmu_notifier.c:319 [inline]
>  __mmu_notifier_release+0x1a9/0x600 mm/mmu_notifier.c:357
>  mmu_notifier_release include/linux/mmu_notifier.h:415 [inline]
>  exit_mmap+0x543/0x670 mm/mmap.c:3136
>  __mmput+0x122/0x4b0 kernel/fork.c:1114
>  mmput+0x56/0x60 kernel/fork.c:1135
>  exit_mm kernel/exit.c:507 [inline]
>  do_exit+0xa3c/0x2a30 kernel/exit.c:793
>  do_group_exit+0xd2/0x2f0 kernel/exit.c:935
>  __do_sys_exit_group kernel/exit.c:946 [inline]
>  __se_sys_exit_group kernel/exit.c:944 [inline]
>  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:944
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fa3314b91f9
> Code: Unable to access opcode bytes at RIP 0x7fa3314b91cf.
> RSP: 002b:00007fffac3303d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00007fa33152e350 RCX: 00007fa3314b91f9
> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000000
> R10: 0000000000000006 R11: 0000000000000246 R12: 00007fa33152e350
> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:folio_memcg_rcu include/linux/memcontrol.h:470 [inline]
> RIP: 0010:workingset_activation+0x4f2/0x5d0 mm/workingset.c:412
> Code: 48 89 ef e8 50 01 00 00 c6 05 da cf d3 0b 01 0f 0b e9 0e fd ff ff e8 6d 90 cc ff 48 c7 c6 c0 0c b7 89 48 89 ef e8 2e 01 00 00 <0f> 0b e8 57 90 cc ff 0f 0b e9 e6 fb ff ff e8 4b 90 cc ff 48 c7 c6
> RSP: 0018:ffffc90002ac7490 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
> RDX: ffff8880729940c0 RSI: ffffffff81ab1de2 RDI: 0000000000000003
> RBP: ffffea0001aa0000 R08: 0000000000000018 R09: 00000000ffffffff
> R10: ffffffff8908d53c R11: 00000000ffffffff R12: 0000000000000000
> R13: ffff8880b9c34da8 R14: dffffc0000000000 R15: 0000000000000003
> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fa33152f1f0 CR3: 000000001b7f5000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
