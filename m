Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F54549DAE
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 21:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349243AbiFMT3w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 15:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351702AbiFMT3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 15:29:38 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC8C5B3C2
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 10:54:07 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 31so4553140pgv.11
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 10:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EpkxShZgsyvOC558FK0jGzBMP0ZDetJPHuYDFcyKyHc=;
        b=eG1Pt6SNmAWAbkQk0PJbYFEvmFih5RDAoAG3SGj9P+NC9N4y2TBh/8isp3VZBGLNND
         yDB1cZ+gI8hf7X/1TgWUueDSwHZUKcPPgJ8cvQxWYoqNtqMYspH5vxuMOlOSjlodhHgo
         NCF/c7tLgHjo6IkzT/GNDMo7q8CeO9mlRyslgemmXeCc883bzaJZfz0iTITTCdAieJX1
         edRMTkN+sI6nqjdHKTnzFJFXwTllkMb7mraT8WCdDi9rXA1U7aFLKpDBTa0k3OproqJ8
         9eps/zayaB+UUjZYpaXGOrKephUjO/9VYF+pKzdVEs0hQ1YTJ/FL/r85EY3lAxNctwzO
         /0vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EpkxShZgsyvOC558FK0jGzBMP0ZDetJPHuYDFcyKyHc=;
        b=pJekw8kqvmr104iVkG6ykeA0NaWZQMjJuvfIgDIkuT4ToiWQDAV+DZJC3trc+ItHre
         lh+MWc/pbWviuwEhGJIkvHY18juvj4FxDZjfAjmLrScuz1AH2Vt4aR6Q5eezgFM2y1hC
         S68PxlMozoP7ZtXDWAuRGdWrK5mavIOGB4kbyl8nbz6iRQy4XVPpJT6XkFgyYgVYNIoy
         LuVJ/8H4CuThLfXgrbgnwGXI8AUuvLZjEf0tfKfJ8c/tOQ8kYIx2Y73lXsBElIBzMKPW
         VVVxT1Jek+saBcLjaB8TQuPOtdcd7pEfSNX2M/7Vyf/wzz4Y8+cuHxwMBPYOqJ3Ut/NY
         /m3A==
X-Gm-Message-State: AOAM532NmLJ+B10+LkAVbDlUCFO3hTX+oQR5Qdz01Zg5avi3GZtE1tlu
        NZELYNh9ueGvp26GgjQ0HN972w==
X-Google-Smtp-Source: ABdhPJwmaLN1NSMSGFo0uwnuNY059nYyRtqZVSuz1JztPm/dzXwvfwgkAcmuxoNDA0S+IlGMwxsw4A==
X-Received: by 2002:a63:f25:0:b0:401:d066:2727 with SMTP id e37-20020a630f25000000b00401d0662727mr700401pgl.386.1655142846731;
        Mon, 13 Jun 2022 10:54:06 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f20-20020a17090a639400b001ea75a02805sm7735594pjj.52.2022.06.13.10.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 10:54:06 -0700 (PDT)
Date:   Mon, 13 Jun 2022 17:54:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+4688c50a9c8e68e7aaa1@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Subject: Re: [syzbot] WARNING in handle_exception_nmi (2)
Message-ID: <Yqd5upAHNOxD0wrQ@google.com>
References: <0000000000000a5eae05d8947adb@google.com>
 <0000000000003719fc05e13b37e3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000003719fc05e13b37e3@google.com>
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 12, 2022, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    7a68065eb9cd Merge tag 'gpio-fixes-for-v5.19-rc2' of git:/..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=177df408080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=20ac3e0ebf0db3bd
> dashboard link: https://syzkaller.appspot.com/bug?extid=4688c50a9c8e68e7aaa1
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12087173f00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16529343f00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+4688c50a9c8e68e7aaa1@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 3609 at arch/x86/kvm/vmx/vmx.c:4896 handle_exception_nmi+0xfdc/0x1190 arch/x86/kvm/vmx/vmx.c:4896
> Modules linked in:
> CPU: 0 PID: 3609 Comm: syz-executor169 Not tainted 5.19.0-rc1-syzkaller-00303-g7a68065eb9cd #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

I'm pretty sure this is a bug in GCE's L0 KVM.  Per syzbot's bisection, the WARN
repros all the way back to v5.11 on GCE.  The test is doing VMWRITE from its L1
(effective L2) with a memory operand that takes a #PF.  The #PF ends up in L1,
which triggers the splat as KVM (real L1) isn't intercepting #PFs.

I've repro'd this on a GCE host running a GCE kernel, and verified the same host
running a v5.18 kernel does _not_ trigger the splat.

I'll route this to someone internally.

> RIP: 0010:handle_exception_nmi+0xfdc/0x1190 arch/x86/kvm/vmx/vmx.c:4896
> Code: 0f 84 c8 f3 ff ff e8 33 5c 58 00 48 89 ef c7 85 84 0d 00 00 00 00 00 00 e8 21 35 ec ff 41 89 c4 e9 af f3 ff ff e8 14 5c 58 00 <0f> 0b e9 69 f6 ff ff e8 08 5c 58 00 be f5 ff ff ff bf 01 00 00 00
> RSP: 0018:ffffc9000309faf8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88801ba1d880 RSI: ffffffff8122171c RDI: 0000000000000001
> RBP: ffff88807cd88000 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000001 R12: 00000000a0000975
> R13: ffff88807cd88248 R14: 0000000000000000 R15: 0000000080000300
> FS:  0000555556c8d300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 00000000229ca000 CR4: 00000000003526e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 00000000b8fecd19 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6174 [inline]
>  vmx_handle_exit+0x498/0x1950 arch/x86/kvm/vmx/vmx.c:6191
>  vcpu_enter_guest arch/x86/kvm/x86.c:10361 [inline]
>  vcpu_run arch/x86/kvm/x86.c:10450 [inline]
>  kvm_arch_vcpu_ioctl_run+0x4208/0x66f0 arch/x86/kvm/x86.c:10654
>  kvm_vcpu_ioctl+0x570/0xf30 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3944
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:870 [inline]
>  __se_sys_ioctl fs/ioctl.c:856 [inline]
>  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> RIP: 0033:0x7f56efaee199
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc37353158 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f56efaee199
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
> RBP: 00007f56efab1bf0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f56efab1c80
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> 
