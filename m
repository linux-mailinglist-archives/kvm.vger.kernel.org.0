Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E79D46922D
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 10:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240302AbhLFJUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 04:20:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240232AbhLFJUG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Dec 2021 04:20:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638782197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=omnvk4amirR6snS+3OVKaK4TSRh28kc5RrA2CTCtYNY=;
        b=ifalrbVMN4HBiBLjF1BJBEj0mnmejkIGRnt8jAO93/k3XpPNwOhS1ZzZND/FZ59aifsu+Z
        JJePzXA9xn/QTFbZVrUVRABy0EuoWyAZB4KEGGGaAk2caHOp6ZQOWKxb35GODEY60kanlp
        JQovguIBL/ZzlJcGoXO6wk1LSBWUQ4c=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-107-pO5L6I65Op6kE0iGrwS-lw-1; Mon, 06 Dec 2021 04:16:36 -0500
X-MC-Unique: pO5L6I65Op6kE0iGrwS-lw-1
Received: by mail-ed1-f69.google.com with SMTP id i19-20020a05640242d300b003e7d13ebeedso7802738edc.7
        for <kvm@vger.kernel.org>; Mon, 06 Dec 2021 01:16:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=omnvk4amirR6snS+3OVKaK4TSRh28kc5RrA2CTCtYNY=;
        b=e9WJu5pceUR1A7UQ6pMWBZyUUjHCgBD+t4o4+bsLKYrIflQNWl/vfXyxxJv3yVXvhP
         WPtW1ZfQuM9xueUtjUhiNqVA5OiKBZSzKuDDsZlo+/PihKwO4Y/2ElWU6UO6IP1/u34I
         1IL/u5QephdmN8mX22qDa1CvV/UXCw2Ca9qayulsXnEp6w3n9qDBnUWWpzY57vgJSpcg
         ogG21kxBbF4pExsZV3AfF6jA3rR9Fu3ng+Qg51KHa8YJXdAm3i46iN237iexU02qpLQr
         /PxlFypvxVS61yyEUaxINZfk88dR1Nsecsz7OkXwkYHYpTAAPg408ttYw7dvH3Xlx+lN
         cAnQ==
X-Gm-Message-State: AOAM533szRJ+57QavMEU3xUls24N9//EkWvGH+BTBYcvX1BKjoAYiJIy
        O5aW6CP5JI2sfedWC3wZ5+2rry1flSig+Ia29ONJ4WrjjrSFF5u1wJj+CkkjXIN8hgMTx/2PSUj
        wwzTyROkTojYX
X-Received: by 2002:a17:906:1396:: with SMTP id f22mr44691650ejc.228.1638782195215;
        Mon, 06 Dec 2021 01:16:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxpkbkgxEjWZu6PwmrAlS8vVtpyagyJw6++aX+jC3O0MpSgxXbB2soaoIOYF1YVg4TCkhz9nQ==
X-Received: by 2002:a17:906:1396:: with SMTP id f22mr44691626ejc.228.1638782195019;
        Mon, 06 Dec 2021 01:16:35 -0800 (PST)
Received: from fedora (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id hq37sm6625546ejc.116.2021.12.06.01.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 01:16:34 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, jmattson@google.com,
        Sean Christopherson <seanjc@google.com>
Cc:     syzbot <syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com>,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        wanpengli@tencent.com, x86@kernel.org
Subject: Re: [syzbot] WARNING in nested_vmx_vmexit
In-Reply-To: <00000000000051f90e05d2664f1d@google.com>
References: <00000000000051f90e05d2664f1d@google.com>
Date:   Mon, 06 Dec 2021 10:16:33 +0100
Message-ID: <87bl1u6qku.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot <syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com> writes:

> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    5f58da2befa5 Merge tag 'drm-fixes-2021-12-03-1' of git://a..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14927309b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e9ea28d2c3c2c389
> dashboard link: https://syzkaller.appspot.com/bug?extid=f1d2136db9c80d4733e8
> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 21158 at arch/x86/kvm/vmx/nested.c:4548 nested_vmx_vmexit+0x16bd/0x17e0 arch/x86/kvm/vmx/nested.c:4547
> Modules linked in:
> CPU: 0 PID: 21158 Comm: syz-executor.1 Not tainted 5.16.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:nested_vmx_vmexit+0x16bd/0x17e0 arch/x86/kvm/vmx/nested.c:4547

The comment above this WARN_ON_ONCE() says:

4541)              /*
4542)               * The only expected VM-instruction error is "VM entry with
4543)               * invalid control field(s)." Anything else indicates a
4544)               * problem with L0.  And we should never get here with a
4545)               * VMFail of any type if early consistency checks are enabled.
4546)               */
4547)              WARN_ON_ONCE(vmcs_read32(VM_INSTRUCTION_ERROR) !=
4548)                           VMXERR_ENTRY_INVALID_CONTROL_FIELD);

which I think should still be valid and so the problem needs to be
looked at L0 (GCE infrastructure). Sean, Jim, your call :-)

> Code: df e8 17 88 a9 00 e9 b1 f7 ff ff 89 d9 80 e1 07 38 c1 0f 8c 51 eb ff ff 48 89 df e8 4d 87 a9 00 e9 44 eb ff ff e8 63 b3 5d 00 <0f> 0b e9 2e f8 ff ff e8 57 b3 5d 00 0f 0b e9 00 f1 ff ff 89 e9 80
> RSP: 0018:ffffc9000439f6e8 EFLAGS: 00010293
> RAX: ffffffff8126d4cd RBX: 0000000000000000 RCX: ffff888032290000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000007
> RBP: 0000000000000001 R08: ffffffff8126ccf0 R09: ffffed1003cd9808
> R10: ffffed1003cd9808 R11: 0000000000000000 R12: ffff88801e6cc000
> R13: ffff88802f96e000 R14: dffffc0000000000 R15: 1ffff11005f2dc5d
> FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb73aecedd8 CR3: 00000000143a4000 CR4: 00000000003526e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  vmx_leave_nested arch/x86/kvm/vmx/nested.c:6220 [inline]
>  nested_vmx_free_vcpu+0x83/0xc0 arch/x86/kvm/vmx/nested.c:330
>  vmx_free_vcpu+0x11f/0x2a0 arch/x86/kvm/vmx/vmx.c:6799
>  kvm_arch_vcpu_destroy+0x6b/0x240 arch/x86/kvm/x86.c:10989
>  kvm_vcpu_destroy+0x29/0x90 arch/x86/kvm/../../../virt/kvm/kvm_main.c:441
>  kvm_free_vcpus arch/x86/kvm/x86.c:11426 [inline]
>  kvm_arch_destroy_vm+0x3ef/0x6b0 arch/x86/kvm/x86.c:11545
>  kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1189 [inline]
>  kvm_put_kvm+0x751/0xe40 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1220
>  kvm_vcpu_release+0x53/0x60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3489
>  __fput+0x3fc/0x870 fs/file_table.c:280
>  task_work_run+0x146/0x1c0 kernel/task_work.c:164
>  exit_task_work include/linux/task_work.h:32 [inline]
>  do_exit+0x705/0x24f0 kernel/exit.c:832
>  do_group_exit+0x168/0x2d0 kernel/exit.c:929
>  get_signal+0x1740/0x2120 kernel/signal.c:2852
>  arch_do_signal_or_restart+0x9c/0x730 arch/x86/kernel/signal.c:868
>  handle_signal_work kernel/entry/common.c:148 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>  exit_to_user_mode_prepare+0x191/0x220 kernel/entry/common.c:207
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>  syscall_exit_to_user_mode+0x2e/0x70 kernel/entry/common.c:300
>  do_syscall_64+0x53/0xd0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f3388806b19
> Code: Unable to access opcode bytes at RIP 0x7f3388806aef.
> RSP: 002b:00007f338773a218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffe00 RBX: 00007f338891a0e8 RCX: 00007f3388806b19
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f338891a0e8
> RBP: 00007f338891a0e0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f338891a0ec
> R13: 00007fffbe0e838f R14: 00007f338773a300 R15: 0000000000022000
>  </TASK>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>

-- 
Vitaly

