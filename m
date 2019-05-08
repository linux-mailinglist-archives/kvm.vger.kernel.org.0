Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D137176B3
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 13:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfEHLX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 07:23:58 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33513 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfEHLX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 07:23:58 -0400
Received: by mail-io1-f65.google.com with SMTP id z4so10127536iol.0
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 04:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d644zZtPZpj+iL/O+tRuouNZQQ4CHCP7vp/WgV362Xc=;
        b=I9dBQ1b9fZElQqTaOP/mLPnw/WHMH+3+vU3bKIBkdC5z+XDjpa5XW4+pqXDH2Yirdh
         lVHzKExZIKY1Ce90rffFlZEQOt7jMAWQDbUiDjF5HE0wViOga6ncr88kIutVR58iaZfI
         uBxquUEK9MRuMZHslVRyiLW4gSD0PFci7RYj/GjHSR2fEsT0p6KUYmpHs9nEJm4GOPee
         P5n38Gxn2qoo8db7HRhafcb3w8Ond4eCsOz5YITIB4/LcaolMrlLzcOTxkK8B/BauI/8
         tDXgrbveQcxNc+yCfGXlJcZyA3yJOhjkjI+gGv2K2W3q5+YO2mflV0dVTUXcBuviIMnU
         7K6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d644zZtPZpj+iL/O+tRuouNZQQ4CHCP7vp/WgV362Xc=;
        b=W8YgCRlDvFkLWCnanRkn7KIu9tK6eVOUhG/WU8lZ0qB0klaHNUtIgwl73THdPwS1e/
         NfjeG/ds27JRiaTIX3GkTtuCXLbkA4mROMScKuw2CGWZZGvDRfhvrOhxx09scNgX21Cw
         P0SyNlcIxUN3J/Ayw/R1qM/lC4i9qGG20xiQv+evqgHg0ViX2IoOfPT4tezoOU0ysM0H
         wnfHG0iOAip8jQsiOFpgKKOVFoWwafgdz2LEUy8ALZTw6SnMgamqr1pfgm0LPpXUEAzP
         E2WPB70cmBLcFk2xyQyQ9s93WPjD84QUoEd/KWpCSs/cUNP5c7n9yiJYWF5PMj+AJG2n
         3dsw==
X-Gm-Message-State: APjAAAXwMykoalWT+5pd1Yy2rsTBCJiLu/I0uD89jVjI2FtNqsxCXsh1
        gBzRCS35X4UYjMQsROfG/EytdtEoSnzBeRDrqVR1KQ==
X-Google-Smtp-Source: APXvYqwg7I6hW8AKf3IWv5UtmdgFgvMUcDZ+7raMWEIqgiSPe/rVBGmNOr28sn4pxVkFKWiOMyzK697YC3urwpXbK9E=
X-Received: by 2002:a6b:f305:: with SMTP id m5mr17786558ioh.271.1557314637068;
 Wed, 08 May 2019 04:23:57 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000fb78720587d46fe9@google.com> <20190502023426.GA804@sol.localdomain>
 <20190501231051.50eeccd6@oasis.local.home>
In-Reply-To: <20190501231051.50eeccd6@oasis.local.home>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 8 May 2019 13:23:45 +0200
Message-ID: <CACT4Y+a=yA56CgQqGGSSQRqF9z8y-et=t-uwrjCDYiG8p-BCzQ@mail.gmail.com>
Subject: Re: BUG: soft lockup in kvm_vm_ioctl
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        syzbot <syzbot+8d9bb6157e7b379f740e@syzkaller.appspotmail.com>,
        KVM list <kvm@vger.kernel.org>, adrian.hunter@intel.com,
        David Miller <davem@davemloft.net>,
        Artem Bityutskiy <dedekind1@gmail.com>, jbaron@redhat.com,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Rik van Riel <riel@surriel.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Thu, May 2, 2019 at 5:10 AM
To: Eric Biggers
Cc: syzbot, Dmitry Vyukov, <kvm@vger.kernel.org>,
<adrian.hunter@intel.com>, <davem@davemloft.net>,
<dedekind1@gmail.com>, <jbaron@redhat.com>, <jpoimboe@redhat.com>,
<linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
<luto@kernel.org>, <mingo@kernel.org>, <peterz@infradead.org>,
<richard@nod.at>, <riel@surriel.com>,
<syzkaller-bugs@googlegroups.com>, <tglx@linutronix.de>

> On Wed, 1 May 2019 19:34:27 -0700
> Eric Biggers <ebiggers@kernel.org> wrote:
>
> > > Call Trace:
> > >  smp_call_function_many+0x750/0x8c0 kernel/smp.c:434
> > >  smp_call_function+0x42/0x90 kernel/smp.c:492
> > >  on_each_cpu+0x31/0x200 kernel/smp.c:602
> > >  text_poke_bp+0x107/0x19b arch/x86/kernel/alternative.c:821
> > >  __jump_label_transform+0x263/0x330 arch/x86/kernel/jump_label.c:91
> > >  arch_jump_label_transform+0x2b/0x40 arch/x86/kernel/jump_label.c:99
> > >  __jump_label_update+0x16a/0x210 kernel/jump_label.c:389
> > >  jump_label_update kernel/jump_label.c:752 [inline]
> > >  jump_label_update+0x1ce/0x3d0 kernel/jump_label.c:731
> > >  static_key_slow_inc_cpuslocked+0x1c1/0x250 kernel/jump_label.c:129
> > >  static_key_slow_inc+0x1b/0x30 kernel/jump_label.c:144
> > >  kvm_arch_vcpu_init+0x6b7/0x870 arch/x86/kvm/x86.c:9068
> > >  kvm_vcpu_init+0x272/0x370 arch/x86/kvm/../../../virt/kvm/kvm_main.c:320
> > >  vmx_create_vcpu+0x191/0x2540 arch/x86/kvm/vmx/vmx.c:6577
> > >  kvm_arch_vcpu_create+0x80/0x120 arch/x86/kvm/x86.c:8755
> > >  kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:2569
> > > [inline]
> > >  kvm_vm_ioctl+0x5ce/0x19c0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3105
> > >  vfs_ioctl fs/ioctl.c:46 [inline]
> > >  file_ioctl fs/ioctl.c:509 [inline]
> > >  do_vfs_ioctl+0xd6e/0x1390 fs/ioctl.c:696
> > >  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
> > >  __do_sys_ioctl fs/ioctl.c:720 [inline]
> > >  __se_sys_ioctl fs/ioctl.c:718 [inline]
> > >  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
> > >  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
> > >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> >
> > I'm also curious how syzbot found the list of people to send this to, as it
> > seems very random.  This should obviously have gone to the kvm mailing list, but
> > it wasn't sent there; I had to manually add it.
>
> My guess is that it went down the call stack, and picked those that
> deal with the functions that are listed at the deepest part of the
> stack. kvm doesn't appear for 12 functions up from the crash. It
> probably stopped its search before that.

Hi,

What we do now is the following. We take all filenames in the report
starting from top to bottom, and then apply a blacklist to filter out
utility functions and bug detection facilities:
https://github.com/google/syzkaller/blob/master/pkg/report/linux.go#L59-L89
The first file name that is not blacklisted is used with get_maintainers.pl.
