Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1155AB14B
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 05:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404454AbfIFDli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 23:41:38 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45294 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388477AbfIFDlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 23:41:37 -0400
Received: by mail-oi1-f193.google.com with SMTP id v12so3792993oic.12;
        Thu, 05 Sep 2019 20:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/UWj5FYLQqxX8OK3sv5wN+QK4oOfih0NXrF9rNtYsag=;
        b=Jwso5vdA/lIl8N41TCTTc1ljotibPSixhzpLha9iSRNu+QyBOWBJ4/Et7LNSW0G7cZ
         +UfTt0OOYNLi88obnLjjcXPTaavTrdpi8bwR1Bqr33m/UD2YpKnxPe0t9I0tVfK58vRd
         DAitJHEtN3qkUTh4NyI6DmY0CWHgrQzf+dTiLzSeYFwLnW2CWm93fFe3sjRJBdk38Nu9
         8HCULpK/SLYYKQETess/USE8k3HoJ4nuAuUriZhMLzNNeqjE83pu5k1IW9MB41IwlmRP
         yHGvnnrRFvJpx0LJ9o9RbU5UXxIDLKxoR1GHv56DNKI+eQLhcG9YzlbvNfgzFSFgTe3R
         PyOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/UWj5FYLQqxX8OK3sv5wN+QK4oOfih0NXrF9rNtYsag=;
        b=i0NogMve4jq3cL6+FeWIuOquvf01KExfGI1QIDO6FeRwP/dvpkm2GG6XSJOnA1csag
         RCzpWTHrFR5t4fGX5w1Po0nX8fG00wtbPKzoGvMKpPb1boGOPgl/YwFllApeL6KRjKZI
         7OVqGvyeo8HrzdF0Q2o4L5eZgbFR5eh3rkg/qjUToNmkmA7yDszHrquu+1tin0kJ9p8f
         arU+l5kkm/F4XFdFvb1JS8NeFpiTy8x7Liypq1rNak9L/vfdgFdw1jFg0oo3SdgebSW5
         JjpXCnjxQQWlO89GPxAWOP2mDZZO6p+GLUTSEYvnj42oHqslMGAsOgyFkG8Jv/qDGCH8
         ZWBw==
X-Gm-Message-State: APjAAAXxWwV6ozyNZRUPJGvWSpYRTnoyZGvLpwIxZp872Pm52dx5WkfG
        3LHrgGRavhswB4dludQoz/z0DRN4tCxF7VAo8Dw=
X-Google-Smtp-Source: APXvYqymERoKyHwQliD27rahQ8CUHy8GwvwRRgkUWzWzRpIGHhyNOVA+Ajrg2UQ28xLhSQ4dtMlYAuV8JJL/TO5v3GE=
X-Received: by 2002:a54:4814:: with SMTP id j20mr5337898oij.33.1567741296954;
 Thu, 05 Sep 2019 20:41:36 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000e3072b0591ca1937@google.com> <CANRm+CxBdFjVrYzAe_Rs=v6BMSq9Gx+ngDrEitK6aez=kMq2XQ@mail.gmail.com>
 <87imq6khve.fsf@vitty.brq.redhat.com>
In-Reply-To: <87imq6khve.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 6 Sep 2019 11:41:24 +0800
Message-ID: <CANRm+CwCncK=ZUg9PwT2tgrg3-7MO40n+b0HnShhNwBp2PQH3A@mail.gmail.com>
Subject: Re: general protection fault in __apic_accept_irq
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     syzbot <syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>, devel@linuxdriverproject.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>, mikelley@microsoft.com,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        syzkaller-bugs@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 5 Sep 2019 at 21:11, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > On Thu, 5 Sep 2019 at 16:53, syzbot
> > <syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com> wrote:
> >>
> >> Hello,
> >>
> >> syzbot found the following crash on:
> >>
> >> HEAD commit:    3b47fd5c Merge tag 'nfs-for-5.3-4' of git://git.linux-nfs...
> >> git tree:       upstream
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=124af12a600000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=144488c6c6c6d2b6
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=dff25ee91f0c7d5c1695
> >> compiler:       clang version 9.0.0 (/home/glider/llvm/clang
> >> 80fee25776c2fb61e74c1ecb1a523375c2500b69)
> >> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10954676600000
> >> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1752fe0a600000
> >>
> >> The bug was bisected to:
> >>
> >> commit 0aa67255f54df192d29aec7ac6abb1249d45bda7
> >> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
> >> Date:   Mon Nov 26 15:47:29 2018 +0000
> >>
> >>      x86/hyper-v: move synic/stimer control structures definitions to
> >> hyperv-tlfs.h
> >>
> >> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=156128c1600000
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=136128c1600000
> >>
> >> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> >> Reported-by: syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com
> >> Fixes: 0aa67255f54d ("x86/hyper-v: move synic/stimer control structures
> >> definitions to hyperv-tlfs.h")
> >>
> >> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000004 data
> >> 0x94
> >> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000004 data
> >> 0x48c
> >> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000004 data
> >> 0x4ac
> >> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000005 data
> >> 0x1520
> >> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000006 data
> >> 0x15d4
> >> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000007 data
> >> 0x15c4
> >> kasan: CONFIG_KASAN_INLINE enabled
> >> kasan: GPF could be caused by NULL-ptr deref or user memory access
> >> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> >> CPU: 0 PID: 9347 Comm: syz-executor665 Not tainted 5.3.0-rc7+ #0
> >> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> >> Google 01/01/2011
> >> RIP: 0010:__apic_accept_irq+0x46/0x740 arch/x86/kvm/lapic.c:1029
> >
> > Thanks for the report, I found the root cause, will send a patch soon.
> >
>
> I'm really interested in how any issue can be caused by 0aa67255f54d as
> we just moved some definitions from a c file to a common header... (ok,
> we did more than that, some structures gained '__packed' but it all
> still seems legitimate to me and I can't recall any problems with
> genuine Hyper-V...)

Yes, the bisect is false positive, we can focus on fixing the bug.

         Wanpeng
