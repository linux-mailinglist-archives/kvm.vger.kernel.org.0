Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF64AA3EA
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 15:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733090AbfIENLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 09:11:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730785AbfIENLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 09:11:37 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C55B0C0578F4
        for <kvm@vger.kernel.org>; Thu,  5 Sep 2019 13:11:36 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id b15so965990wrp.21
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2019 06:11:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9ANyZ4dBkBOltXnKi+WoWQpmuFWiDil0u88wFq4AYQY=;
        b=P71rV5iNbOrqmqExcdHZkFocv+c9TOtGiH8v5mhg6/Hp/BhoDLm3dERO/lAEgogvIM
         DGx8px5SU2UDA/NxrbOHHUCiHbqCwzhD/IzxqasvJ0kvCIcdGIMnjZewT0zFEPzkghOK
         4hTt7OqBSlEKzegIZXmU4eIYXjSDjYxnEsJ9KVDoBjIH2gF3vzJP3b+yuGdO1Vt9JLK1
         JmSIwkZpP70FqFo7lDHExkx3b8IYxY3GOcI2tGuBMVyGtMX+Q6HaXvcCyR3lA5iECxka
         T2Fl0Oq6v3b7UfNYnCY6Pih/YG8+O5Utqpy4JM8Qcwz5k223pKTrtOfkq8Sw83bMmpBn
         bl7A==
X-Gm-Message-State: APjAAAU93E4YNC5eJuqrgl6ff4hC0S+MjsQeRDS2LPVEVWYx7DBcGC41
        3t1E97lzQ2c4GLPAq7Iq31NuZD7pzLGRJyk1RNHIb+W0npkmPtNee4U042L8pN7G5+Cz44xLZPg
        OpknMwWCun/FL
X-Received: by 2002:a1c:80ca:: with SMTP id b193mr2630525wmd.171.1567689095193;
        Thu, 05 Sep 2019 06:11:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyKbK6O+n/cVqLS49y3v2z3Wc3ajQWQx/waHdOI+hpMRHK7GNQBFj0JYwrQL53NYvHAotP2eA==
X-Received: by 2002:a1c:80ca:: with SMTP id b193mr2630501wmd.171.1567689094909;
        Thu, 05 Sep 2019 06:11:34 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x5sm3093960wrg.69.2019.09.05.06.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 06:11:34 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>,
        syzbot <syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com>
Cc:     Borislav Petkov <bp@alien8.de>, devel@linuxdriverproject.org,
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
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: general protection fault in __apic_accept_irq
In-Reply-To: <CANRm+CxBdFjVrYzAe_Rs=v6BMSq9Gx+ngDrEitK6aez=kMq2XQ@mail.gmail.com>
References: <000000000000e3072b0591ca1937@google.com> <CANRm+CxBdFjVrYzAe_Rs=v6BMSq9Gx+ngDrEitK6aez=kMq2XQ@mail.gmail.com>
Date:   Thu, 05 Sep 2019 15:11:33 +0200
Message-ID: <87imq6khve.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> On Thu, 5 Sep 2019 at 16:53, syzbot
> <syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    3b47fd5c Merge tag 'nfs-for-5.3-4' of git://git.linux-nfs...
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=124af12a600000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=144488c6c6c6d2b6
>> dashboard link: https://syzkaller.appspot.com/bug?extid=dff25ee91f0c7d5c1695
>> compiler:       clang version 9.0.0 (/home/glider/llvm/clang
>> 80fee25776c2fb61e74c1ecb1a523375c2500b69)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10954676600000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1752fe0a600000
>>
>> The bug was bisected to:
>>
>> commit 0aa67255f54df192d29aec7ac6abb1249d45bda7
>> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Date:   Mon Nov 26 15:47:29 2018 +0000
>>
>>      x86/hyper-v: move synic/stimer control structures definitions to
>> hyperv-tlfs.h
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=156128c1600000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=136128c1600000
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com
>> Fixes: 0aa67255f54d ("x86/hyper-v: move synic/stimer control structures
>> definitions to hyperv-tlfs.h")
>>
>> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000004 data
>> 0x94
>> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000004 data
>> 0x48c
>> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000004 data
>> 0x4ac
>> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000005 data
>> 0x1520
>> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000006 data
>> 0x15d4
>> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000007 data
>> 0x15c4
>> kasan: CONFIG_KASAN_INLINE enabled
>> kasan: GPF could be caused by NULL-ptr deref or user memory access
>> general protection fault: 0000 [#1] PREEMPT SMP KASAN
>> CPU: 0 PID: 9347 Comm: syz-executor665 Not tainted 5.3.0-rc7+ #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> Google 01/01/2011
>> RIP: 0010:__apic_accept_irq+0x46/0x740 arch/x86/kvm/lapic.c:1029
>
> Thanks for the report, I found the root cause, will send a patch soon.
>

I'm really interested in how any issue can be caused by 0aa67255f54d as
we just moved some definitions from a c file to a common header... (ok,
we did more than that, some structures gained '__packed' but it all
still seems legitimate to me and I can't recall any problems with
genuine Hyper-V...)

-- 
Vitaly
