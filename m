Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E635E6ED15C
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 17:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbjDXPaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 11:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbjDXPaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 11:30:07 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FAE7D83
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 08:29:57 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54faf2edb18so86362827b3.0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 08:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682350197; x=1684942197;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gCgpe6n+jmUxcEJH0eL6xCNrEIEiHzHCJcnHIrPBLxc=;
        b=G7/E08havS32LLcjGJNwV3zdv/V5VR800w4qAVStO3+3tIfgUVcB6KxYQGQtSi4WxI
         4ErYbClZWhmokdmkJsrjH5kb5HOU1ZxVpBEpRhqRk2MWG3KZ7txdL2o0K2HS2al/anqA
         Y2KPb9ipTim4mLpv5gUC1uAuXiDakF0XzeIfRIr+DXu7m2UtkAgqW2GOJvBFoKIIxOIr
         Z+ke4Fd9SJY1SpjzpXkq4UkZT1Y6SLpEZgpeiCeeRgZqeBsQ7WJ3rO0ygkP85sAwcMna
         vnsbx4fJwNKg03OxbLet/+UK234+NonnH8MmZlqUkkIpHn7FZjba8DkG9YV2gi1sWvmn
         IPEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682350197; x=1684942197;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gCgpe6n+jmUxcEJH0eL6xCNrEIEiHzHCJcnHIrPBLxc=;
        b=d+PSwI6LC2+twoOsoNiFENLTM/4yGjD/MuyVb+Ctln2I0Qp/8loErOE7lYzABWmrD8
         /KF4vPBy2X+EKl9HHC/8SxBAt2jkayIdG8RLVUu7T+UV0UTSfbAwstbhujbASFzUiowt
         e8Op/ldZbQMpmH54O2/dgEDEVvWa7yUw3INtQYGFxhqcBRqFedXIF5GrLN6Vay4G6FeL
         he0qsKAjPu4vRkgvJ9NlslbaCoxI9IS+O/iatc/1Vsu46TqwQjHjzZTOQgakJUrr8AmF
         mbPUAbveddkb5gyU0QPcTDsL10fBZQvtGD5GWHF+LWK9F3Bwd19PexKEZQXQnUEofJrS
         Ba3w==
X-Gm-Message-State: AAQBX9cJUIxEFehYMxvwx6HZuZGS+YITzxxzyMdC2uKW3fJVDeWVZjdK
        zl2YRSeEpjBJnuYk8yfiRe8SICxLPqM=
X-Google-Smtp-Source: AKy350bhQU7OcFUeFKVJtBkNM/PQxjoo0m+R/8S1X+/tHzwa23HbaHcUDw953Xii31aMUVkSQoRTzfKWBnM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4516:0:b0:552:e3fa:6756 with SMTP id
 s22-20020a814516000000b00552e3fa6756mr6003733ywa.2.1682350197003; Mon, 24 Apr
 2023 08:29:57 -0700 (PDT)
Date:   Mon, 24 Apr 2023 08:29:55 -0700
In-Reply-To: <000000000000eca0b905fa0f7756@google.com>
Mime-Version: 1.0
References: <000000000000eca0b905fa0f7756@google.com>
Message-ID: <ZEagczhTT5+dVDzE@google.com>
Subject: Re: [syzbot] [kvm?] KASAN: slab-use-after-free Read in kvm_tdp_mmu_invalidate_all_roots
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+864ac0b626794668b732@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 23, 2023, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d3e1ee0e67e7 Add linux-next specific files for 20230421
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=118a0520280000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=53c789efbcc06cf6
> dashboard link: https://syzkaller.appspot.com/bug?extid=864ac0b626794668b732
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/c558a9e1fe6a/disk-d3e1ee0e.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/2ec100a34c4c/vmlinux-d3e1ee0e.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/1afcd9936dc1/bzImage-d3e1ee0e.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+864ac0b626794668b732@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: slab-use-after-free in kvm_tdp_mmu_invalidate_all_roots+0x2e3/0x370 arch/x86/kvm/mmu/tdp_mmu.c:945
> Read of size 8 at addr ffff88807c27d528 by task syz-executor.2/5817
> 
> CPU: 0 PID: 5817 Comm: syz-executor.2 Not tainted 6.3.0-rc7-next-20230421-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
>  print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
>  print_report mm/kasan/report.c:462 [inline]
>  kasan_report+0x11c/0x130 mm/kasan/report.c:572
>  kvm_tdp_mmu_invalidate_all_roots+0x2e3/0x370 arch/x86/kvm/mmu/tdp_mmu.c:945
>  kvm_mmu_uninit_tdp_mmu+0x16/0x100 arch/x86/kvm/mmu/tdp_mmu.c:48
>  kvm_mmu_uninit_vm+0x6a/0x70 arch/x86/kvm/mmu/mmu.c:6239
>  kvm_arch_destroy_vm+0x369/0x490 arch/x86/kvm/x86.c:12465
>  kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1313 [inline]
>  kvm_put_kvm+0x4da/0xae0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1347
>  kvm_vcpu_release+0x51/0x70 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3846
>  __fput+0x27c/0xa90 fs/file_table.c:321
>  task_work_run+0x16f/0x270 kernel/task_work.c:179
>  resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>  exit_to_user_mode_prepare+0x210/0x240 kernel/entry/common.c:204
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
>  syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
>  do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f426b83e01b
> Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
> RSP: 002b:00007ffe38a35070 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 0000000000000008 RCX: 00007f426b83e01b
> RDX: 0000000000000000 RSI: 0000001b32b3a7d4 RDI: 0000000000000007
> RBP: 00007f426b9ad980 R08: 0000000000000000 R09: 0000000075ee794b
> R10: 0000000000000000 R11: 0000000000000293 R12: 000000000003d553
> R13: 00007ffe38a35170 R14: 00007ffe38a35190 R15: 0000000000000032
>  </TASK>

#syz fix: KVM: x86: Preserve TDP MMU roots until they are explicitly invalidated
