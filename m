Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385F174E11D
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 00:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjGJWbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 18:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjGJWbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 18:31:02 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96317197
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 15:30:57 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-577323ba3d5so87459427b3.0
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 15:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689028257; x=1691620257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jrFjrK5MWxllCEyWLwQALYzED0ScrRsviwL5/1Q7jDs=;
        b=4MMjLb464Pb5VZEX1b8fj9jAnvfPpt8zq+yBzPWJAVy4E2mlu9B8AcWgnZmCPNmb/1
         BmrnPtBYzpTZO1Z8MbEivQNKg2gZCbl2CsU3nf5S5aU8w9RpQ+4uzAX90JuHBHq2B83p
         +ketJXUbkQ3q03+14CL2uRTeSd/juQksX0NKkNh4tvuBAVKJLherxhOZ/vcUhPCNsn4c
         aOm5mz6MGe2qdt0p3XHUcOdqWJN58QqHjHk9j/8lx4jGTy/gjKYKwXvSWmxwtxI9LlhC
         KuGx+2g9GpZ40rFVO3ulYofhVr8ZzrFZSTqbDQtQFYqr05FZYTqw74JH3HBR4gjWPNQI
         1Wfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689028257; x=1691620257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jrFjrK5MWxllCEyWLwQALYzED0ScrRsviwL5/1Q7jDs=;
        b=AcAI2gwZYHxwm0nacXnbLYljax34Lekizu1kfjnurWdjyn3KkyVWEgqK2iN6ZUnqM3
         oBWLkm8PSTJIPHgeNuMQXWgNWUnPzomlGkzTNEtBgLkvWNoexGTZ9mp646a8LCsYKpf+
         RzVwjYaLIdo7xXibmMLA8x+j4qDGQaH0wsci+nE1UpLDFWCNb6zkjiID9frs0/ZoGOsa
         vkRv2a57B09LbWJXBGxBm9lPiFXSuXabP/lJA+65qJsvnJfQGVjSuU4gfP6quy8UWDLG
         aWa1sZxBUueZMkVvHZhH4B1nIpJ1Pfe8tgc2a8SiPboWggOnAkRZLiHq0cygSoL0h7iv
         ffHQ==
X-Gm-Message-State: ABy/qLZqYJkUpMdvcByhy64MydDAOIkP4fyKyETcUckeWBxBrSjqhBa3
        S+rRZ7jMwKolUu3RCP7oxpazC7KM85c=
X-Google-Smtp-Source: APBJJlFUSokVx7EwS5XHoKGdMsaWyqcDvburopZlrDTYNL9HvQ/enmKw8Urv4Kq9cHYV5/vscLNh8hk1nb8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2d08:b0:57a:6019:62aa with SMTP id
 eq8-20020a05690c2d0800b0057a601962aamr109283ywb.5.1689028256906; Mon, 10 Jul
 2023 15:30:56 -0700 (PDT)
Date:   Mon, 10 Jul 2023 15:30:55 -0700
In-Reply-To: <0000000000007ff56205ba985b60@google.com>
Mime-Version: 1.0
References: <0000000000007ff56205ba985b60@google.com>
Message-ID: <ZKyGn5UsJaAx7Ghy@google.com>
Subject: Re: general protection fault in vmx_vcpu_run (2)
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+42a71c84ef04577f1aef@syzkaller.appspotmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    aa2b8820 Add linux-next specific files for 20210205
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=13d27b54d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=15c41e44a64aa1a5
> dashboard link: https://syzkaller.appspot.com/bug?extid=42a71c84ef04577f1aef
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+42a71c84ef04577f1aef@syzkaller.appspotmail.com
> 
> general protection fault, probably for non-canonical address 0xdffffc0000001e26: 0000 [#1] PREEMPT SMP KASAN
> KASAN: probably user-memory-access in range [0x000000000000f130-0x000000000000f137]
> CPU: 0 PID: 18290 Comm: syz-executor.0 Not tainted 5.11.0-rc6-next-20210205-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:atomic_switch_perf_msrs arch/x86/kvm/vmx/vmx.c:6527 [inline]
> RIP: 0010:vmx_vcpu_run+0x538/0x2740 arch/x86/kvm/vmx/vmx.c:6698
> Code: 8a 55 00 39 eb 0f 8d fd 00 00 00 e8 42 85 55 00 48 8b 0c 24 48 63 c3 48 8d 04 40 48 8d 2c c1 48 8d 7d 08 48 89 f8 48 c1 e8 03 <42> 80 3c 38 00 0f 85 05 1d 00 00 48 8d 7d 10 4c 8b 6d 08 48 89 f8
> RSP: 0018:ffffc9000238fb00 EFLAGS: 00010003
> RAX: 0000000000001e26 RBX: 0000000000000000 RCX: 000000000000f12e
> RDX: 0000000000040000 RSI: ffffffff811d679e RDI: 000000000000f136
> RBP: 000000000000f12e R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff811d675e R11: 0000000000000000 R12: ffff88806d8ba4d0
> R13: ffff88806d8ba520 R14: ffff88806d8b8000 R15: dffffc0000000000
> FS:  00007f1a30eaf700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1a30ece6b8 CR3: 000000001c387000 CR4: 00000000001526f0
> Call Trace:
>  vcpu_enter_guest+0x103d/0x3f90 arch/x86/kvm/x86.c:9015
>  vcpu_run arch/x86/kvm/x86.c:9155 [inline]
>  kvm_arch_vcpu_ioctl_run+0x440/0x1980 arch/x86/kvm/x86.c:9382
>  kvm_vcpu_ioctl+0x467/0xd90 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3283
>  vfs_ioctl fs/ioctl.c:48 [inline]
>  __do_sys_ioctl fs/ioctl.c:753 [inline]
>  __se_sys_ioctl fs/ioctl.c:739 [inline]
>  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x465b09

I haven't been able to reproduce this, and based on the super simple reproducer
and the fact that AFAICT this hasn't been hit in 2+ years, I suspect whatever
was broken has long since been fixed.

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
