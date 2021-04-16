Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C904362097
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 15:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243468AbhDPNN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 09:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235252AbhDPNN2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 09:13:28 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D52D61107;
        Fri, 16 Apr 2021 13:13:02 +0000 (UTC)
Date:   Fri, 16 Apr 2021 09:13:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzkaller <syzkaller@googlegroups.com>,
        syzbot <syzbot+61e04e51b7ac86930589@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, masahiroy@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        rafael.j.wysocki@intel.com,
        Sean Christopherson <seanjc@google.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Subject: Re: Bisections with different bug manifestations
Message-ID: <20210416091300.0758c62a@gandalf.local.home>
In-Reply-To: <CACT4Y+YipDUHQiqJ=gtEeBQGz2AjqT6e_fje5DHsm0a5e+-GRQ@mail.gmail.com>
References: <000000000000ae236f05bfde0678@google.com>
        <20210413134147.54556d9d@gandalf.local.home>
        <20210413134314.16068eeb@gandalf.local.home>
        <CACT4Y+ZrkE=ZKKncTOJRJgOTNfU8PGz=k+8V+0602ftTCHkc6Q@mail.gmail.com>
        <20210413144009.6ed2feb8@gandalf.local.home>
        <20210413144335.4ff14cf2@gandalf.local.home>
        <CACT4Y+YipDUHQiqJ=gtEeBQGz2AjqT6e_fje5DHsm0a5e+-GRQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 16 Apr 2021 09:51:45 +0200
Dmitry Vyukov <dvyukov@google.com> wrote:
> 
> If you look at substantial base of bisection logs, you will find lots
> of cases where bug types, functions don't match. Kernel crashes
> differently even on the same revision. And obviously things change if
> you change revisions. Also if you see presumably a different bug, what
> does it say regarding the original bug.

Yes, but there are also several types of cases where the issue will be the
same. Namely lockdep. I agree that use after free warnings can have a side
effect, and may be more difficult. But there's many other bugs that remain
consistent across kernels. And if you stumble on one of them, look for it
only.

And if you hit another bug, and if it doesn't crash, then ignore it (of
course this could be an issue if you have panic on warning set). But
otherwise, just skip it.

> 
> I would very much like to improve automatic bisection quality, but it
> does not look trivial at all.
> 
> Some random examples where, say, your hypothesis of WARN-to-WARN,
> BUG-to-BUG does not hold even on the same kernel revision (add to this

At least lockdep to lockdep, as when I do manual bisects, that's exactly
what I look for, and ignore all other warnings. And that has found the
problem commit pretty much every time.

> different revisions and the fact that a different bug does not give
> info regarding the original bug):
> 

Can you tell me that all these examples bisected to the commit that caused
the bug? Because if it did not, then you may have just proved my point ;-)

> run #0: crashed: KASAN: use-after-free Read in fuse_dev_do_read
> run #1: crashed: WARNING in request_end
> run #2: crashed: KASAN: use-after-free Read in fuse_dev_do_read
> run #3: OK
> run #4: OK
> 

[..]

-- Steve
