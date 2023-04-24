Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37746EC6AA
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 09:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbjDXHBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 03:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbjDXHBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 03:01:39 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F78AE5E
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 00:01:37 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4edc63e066fso10505e87.1
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 00:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682319695; x=1684911695;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oFvdNJ5wNm8bAPrnAB1ppnXwBJiUYz1wk9PgIHRrg6A=;
        b=pAWnwcZUzVEvGD8U5XoERz4DLnhy4gn3LtztEZ3VL06RgIBG61MWxdbxUk4sb9gvu0
         Tjf3DMxSJv1PycRT41IDycW6QaDs87WQA/IiM5l67+p8KnxU/iKoTVtXRtQRIAlN4Jbj
         qcFCNGu8W+URpqD4VrGmt1ttNuebJz0JmJVEkRWG+xlluGMaF1meyWF+BrSs4nzYBndq
         oG6yMGsUdRrebpM+0xJEzp8HCRgN7GK5kM4dMAw587lHQJNCbsg03tzki7u/e4XlhgBk
         jNbQ3L9ZEmqpsAAhos2DkIDQlOzf+86OrvHFEWxAHmsG2OwkXORDe3XUnMX2Bsuye3Xu
         Er+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682319695; x=1684911695;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oFvdNJ5wNm8bAPrnAB1ppnXwBJiUYz1wk9PgIHRrg6A=;
        b=BYQQyaDQ3qNqezuCugafXq+3PPKqQM3MFz+4GQkZkkAj0bsBu02oSNRM8LcckhBSb2
         7Q1gbOELt1in4JmDJ3s5Io4MJbEf5itYIUjnVo1Nb3Iy0+uAeaw3fzM/Vn7E08lToKfr
         6Qj8uH85O5K/yUNtNJzZRLV1gIx9i4EOehdgtkvnFD0Y6zzK83f/HDbSuNh+ufIZtBjm
         ClhydKIk/gZaRt0q7C0+o9C/lsWdYIHFm85NVNpopYa0FKQDLYt5R1EsnMYtaFmZUdsm
         pcG8sz+dZ3DkZKb3DR2i5q+8NFHwZPS38ZO4wsw5CpY8/cn3TSHDE2JoIkTJhWtHghS5
         Bl5g==
X-Gm-Message-State: AAQBX9cXoXY+Mo0BoEWS8Ci/Tc28xEtOzHL9H4cnK/elkW9mf0ZHCiQc
        Bq8yRpUhC25HcMtnbylz187EfYR/Wf7zEiCZ/MKdtNGrl5ouFIIugAcf7g==
X-Google-Smtp-Source: AKy350aJHm/Q0fOJW1kbhhAhbI3UOl65UI81G9owszShxfnRp44JjyTSsrj+CJa0nHfza3zEVvcIRnxniexN1lu756E=
X-Received: by 2002:a05:6512:3ca2:b0:4ed:b0bd:a96c with SMTP id
 h34-20020a0565123ca200b004edb0bda96cmr213958lfv.6.1682319695161; Mon, 24 Apr
 2023 00:01:35 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a0bc2b05f9dd7fab@google.com> <ZEMFpqxvOHd2kZiu@google.com>
In-Reply-To: <ZEMFpqxvOHd2kZiu@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 24 Apr 2023 09:01:22 +0200
Message-ID: <CACT4Y+Ytpc8zqcyV7xnOJsdz5qoT0mpOE1yZrPZ53D5ZwUrMwA@mail.gmail.com>
Subject: Re: [syzbot] [kvm?] WARNING in kvm_tdp_mmu_invalidate_all_roots
To:     Sean Christopherson <seanjc@google.com>
Cc:     syzbot <syzbot+094a74444165dbcd3a54@syzkaller.appspotmail.com>,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Apr 2023 at 23:52, 'Sean Christopherson' via syzkaller-bugs
<syzkaller-bugs@googlegroups.com> wrote:
>
> On Fri, Apr 21, 2023, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    d3e1ee0e67e7 Add linux-next specific files for 20230421
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16ac3de0280000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=53c789efbcc06cf6
> > dashboard link: https://syzkaller.appspot.com/bug?extid=094a74444165dbcd3a54
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/c558a9e1fe6a/disk-d3e1ee0e.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/2ec100a34c4c/vmlinux-d3e1ee0e.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/1afcd9936dc1/bzImage-d3e1ee0e.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+094a74444165dbcd3a54@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 12623 at arch/x86/kvm/mmu/tdp_mmu.c:943 kvm_tdp_mmu_invalidate_all_roots+0x2bd/0x370 arch/x86/kvm/mmu/tdp_mmu.c:943
> > Modules linked in:
> > CPU: 0 PID: 12623 Comm: syz-executor.3 Not tainted 6.3.0-rc7-next-20230421-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/30/2023
> > RIP: 0010:kvm_tdp_mmu_invalidate_all_roots+0x2bd/0x370 arch/x86/kvm/mmu/tdp_mmu.c:943
> > Call Trace:
> >  <TASK>
> >  kvm_mmu_uninit_tdp_mmu+0x16/0x100 arch/x86/kvm/mmu/tdp_mmu.c:48
> >  kvm_mmu_uninit_vm+0x6a/0x70 arch/x86/kvm/mmu/mmu.c:6239
> >  kvm_arch_destroy_vm+0x369/0x490 arch/x86/kvm/x86.c:12465
> >  kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1245 [inline]
> >  kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:5017 [inline]
> >  kvm_dev_ioctl+0x11be/0x1bb0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:5059
> >  vfs_ioctl fs/ioctl.c:51 [inline]
> >  __do_sys_ioctl fs/ioctl.c:870 [inline]
> >  __se_sys_ioctl fs/ioctl.c:856 [inline]
> >  __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Gah, kvm->users_count is elevated when the VM is destroyed if creation fails,
> but mmu_lock isn't held in that case, and lockdep yells.  This particular bug is
> effectively a false positive, nothing else holds a reference to the VM.
>
> However, syzbot found another bug that _is_ a real problem (hasn't been reported
> upstream yet for whatever reason).

It was staged in the moderation queue for manual moderation:
https://github.com/google/syzkaller/blob/master/docs/syzbot.md#moderation-queue

here:
https://groups.google.com/g/syzkaller-upstream-moderation/c/pTGA87FeSIE

I've pushed it upstream since you say it's worth fixing.



>  Not holding mmu_lock during "real" VM destruction
> is problematic because walking the list can race with the asynchronous worker
> deleting and freeing from the list.
>
> Posted a fixed version[*] that should resolve both issues by protecting the walk
> with RCU.
>
> [*] https://lore.kernel.org/all/20230421214946.2571580-1-seanjc@google.com
>
> ==================================================================
> BUG: KASAN: slab-use-after-free in kvm_tdp_mmu_invalidate_all_roots+0x2e3/0x370 arch/x86/kvm/mmu/tdp_mmu.c:945
> Read of size 8 at addr ffff88801c8cf948 by task syz-executor.1/17012
>
> CPU: 0 PID: 17012 Comm: syz-executor.1 Not tainted 6.3.0-rc7-next-20230421-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/30/2023
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:88 [inline]
> dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
> print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
> print_report mm/kasan/report.c:462 [inline]
> kasan_report+0x11c/0x130 mm/kasan/report.c:572
> kvm_tdp_mmu_invalidate_all_roots+0x2e3/0x370 arch/x86/kvm/mmu/tdp_mmu.c:945
> kvm_mmu_uninit_tdp_mmu+0x16/0x100 arch/x86/kvm/mmu/tdp_mmu.c:48
> kvm_mmu_uninit_vm+0x6a/0x70 arch/x86/kvm/mmu/mmu.c:6239
> kvm_arch_destroy_vm+0x369/0x490 arch/x86/kvm/x86.c:12465
> kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1313 [inline]
> kvm_put_kvm+0x4da/0xae0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1347
> kvm_vcpu_release+0x51/0x70 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3846
> __fput+0x27c/0xa90 fs/file_table.c:321
> task_work_run+0x16f/0x270 kernel/task_work.c:179
> resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
> exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
> exit_to_user_mode_prepare+0x210/0x240 kernel/entry/common.c:204
> __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
> syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
> do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fd7a583e01b
> Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
> RSP: 002b:00007ffc821a2fb0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 000000000000000a RCX: 00007fd7a583e01b
> RDX: 0000000000000000 RSI: 00007fd7a5400000 RDI: 0000000000000009
> RBP: 00007fd7a59ad980 R08: 0000000000000000 R09: 0000000071612a4e
> R10: 0000000000000000 R11: 0000000000000293 R12: 000000000014ffb4
> R13: 00007ffc821a30b0 R14: 00007fd7a59ac050 R15: 0000000000000032
> </TASK>
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/ZEMFpqxvOHd2kZiu%40google.com.
