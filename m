Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BADDD18B9F
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 16:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfEIOXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 10:23:10 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:51957 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfEIOXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 10:23:10 -0400
Received: by mail-it1-f193.google.com with SMTP id s3so3861742itk.1
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 07:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CJAJWMSbDRtZTT/lyH5+TR+lDyhkoQaqVk/vcm0z2Ao=;
        b=Eh/JkVUpHB0z8bi9m3gkPcO82KpSIWF8E64gJiNt7GJbvEsn28SE6m7w1Al7JQ1PoV
         VenQwAENtE7CyAHXvIK0JNFTnA7wp7FVEh2ihJSwLC4jhWMv95qLlsMziISprMSiOk6C
         V8O/bD0lfn2AcmxtZNufi8B+skOcjemCRrFQ5In63YPA2op4xEUxm3n/DIP71xUilWg8
         Nc+lz/lSy04aFkf9W078jbaarYlPWXx+vpKbNRbANDPjHd/dnrIzmwUwGozs9W3JHW6U
         qy9EgmbVDCf7a2tRHcgDzNeIRzV+fAYyimV+8eMeKgk2FnGoE9kELfZw/86gONFRXIuQ
         KuwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CJAJWMSbDRtZTT/lyH5+TR+lDyhkoQaqVk/vcm0z2Ao=;
        b=BfVY7ICEFz0+EdHtBcU90FyRnGuv7O+OhlZu0AgBWtYVcBxWfc7bwAmtaO7o07f9Cz
         ieiOJf1w21YZFmg7OOIO0YL1iBRGAGlO+pylsHjDFcgEgpAe0nz/sYhmlXc7x5ZQGKjN
         EKjWMN5JyIH+QX1JINb+c+ULQaJThW7h9q21AaN9CFrt16FXmfkH5OXqNPisxoN/keHJ
         zSK05DvpSeZjL2JJys/jO9Nznse3nNPqaTAoTpQipqiuX1eIrqmtb9WFACmcBpvZRUxw
         Gf/qyPxR8qrLoFvZzv9fRFxyxvoI+g4CqPnVH2uYToTjwL53sEcx6odZAgyaHCO6nGB6
         MS3Q==
X-Gm-Message-State: APjAAAVYtRRI+OvMndnd2isscj5+lr2xK82eQ5uth+fYaMWtE1ZcX3Uu
        dYXd4ketYVp27nMFfhxs1j8C2Gbb18z61yb45aI2jw==
X-Google-Smtp-Source: APXvYqxA41KpQLDZwMiuRZvoLLjanStXSNAuvVQvtDhC5A8eLBEix9KyEuJYsIQQW75bJz2uPEpO1bcu3xil346SB+g=
X-Received: by 2002:a02:b88b:: with SMTP id p11mr3324967jam.82.1557411788929;
 Thu, 09 May 2019 07:23:08 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000fb78720587d46fe9@google.com> <20190502023426.GA804@sol.localdomain>
 <CACT4Y+YHFH8GAhDaNdNNTVFFx6YfKSL19cLPx2vpP-YngzS6kQ@mail.gmail.com>
 <CACT4Y+biO9GEN16Rak_1F+UdvhTe3fUwVf_VWRup2xrgvr9WKA@mail.gmail.com> <20190509031849.GC693@sol.localdomain>
In-Reply-To: <20190509031849.GC693@sol.localdomain>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 9 May 2019 16:22:56 +0200
Message-ID: <CACT4Y+bz-aFJ2PbqJKL7veWavZkLw5nq+RFnnTveXMowRMVY4Q@mail.gmail.com>
Subject: Re: BUG: soft lockup in kvm_vm_ioctl
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     syzbot <syzbot+8d9bb6157e7b379f740e@syzkaller.appspotmail.com>,
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
        Steven Rostedt <rostedt@goodmis.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > > Can the KVM maintainers take a look at this?  This doesn't have anything to do
> > > > with my commit that syzbot bisected it to.
> > > >
> > > > +Dmitry, statistics lession: if a crash occurs only 1 in 10 times, as was the
> > > > case here, then often it will happen 0 in 10 times by chance.  syzbot needs to
> > > > run the reproducer more times if it isn't working reliably.  Otherwise it ends
> > > > up blaming some random commit.
> > >
> > > Added a note to https://github.com/google/syzkaller/issues/1051
> > > Thanks
> >
> > As we increase number of instances, we increase chances of hitting
> > unrelated bugs. E.g. take a look at the bisection log for:
> > https://syzkaller.appspot.com/bug?extid=f14868630901fc6151d3
> > What is the optimum number of tests is a good question. I suspect that
> > the current 10 instances is close to optimum. If we use significantly
> > more we may break every other bisection on unrelated bugs...
> >
>
> Only because syzbot is being super dumb in how it does the bisection.  AFAICS,
> in the example you linked to, buggy kernels reliably crashed 10 out of 10 times
> with the original crash signature, "WARNING in cgroup_exit".  Then at some point
> it tested some kernel without the bug and got a different crash just 1 in 10
> times, "WARNING: ODEBUG bug in netdev_freemem".
>
> The facts that the crash frequency was very different, and the crash signature
> was different, should be taken as a very strong signal that it's not the bug
> being bisected for.  And this is something easily checked for in code.
>
> BTW, I hope you're treating fixing this as a high priority, given that syzbot is
> now sending bug reports to kernel developers literally selected at random.  This
> is a great way to teach people to ignore syzbot reports.  (When I suggested
> bisection originally, I had assumed you'd implement some basic sanity checks so
> that only bisection results likely to be reliable would be mailed out.)



While I believe we can get some quality improvement by shuffling
numbers. I don't think we can get significant improvement overall and
definitely not eliminate wrong bisection results entirely. It's easy
to take a single wrong bisection and design a system around this
scenario, but it's very hard to design a system that will handle all
of them in all generality. For example, look at these bisection logs
for cases where reproduction frequency varies from 1 to all, but
that's still the same bug:
https://syzkaller.appspot.com/x/bisect.txt?x=12df1ba3200000
https://syzkaller.appspot.com/x/bisect.txt?x=10daff1b200000
https://syzkaller.appspot.com/x/bisect.txt?x=1592b037200000
https://syzkaller.appspot.com/x/bisect.txt?x=11c610a7200000
https://syzkaller.appspot.com/x/bisect.txt?x=17affd1b200000
You also refer to "a different crash". But that's not a predicate we
can have. And definitely not something that is "easily checked for in
code". Consider, a function rename anywhere in the range will lead to
as if a different crash. If you look at all bisection logs you find
lots of amusing cases where something that a program may consider a
different bugs is actually the same bug, or the other way around. So
if we increase number of tests and we don't have a way to distinguish
crashes (which we don't), we will necessary increase incorrect results
due to unrelated bugs.

Bisection is a subtle process and the predicate, whatever logic it
does internally, in the end need to produce a single yes/no. And a
single wrong answer in the chain leads to a completely incorrect
result. There are some fundamental reasons for wrong results:
 - hard to reproduce bugs (not fixable)
 - unrelated bugs/broken builds (fixable)
While tuning numbers can pepper over these to some degree (maybe),
these reasons will stay and will lead to incorrect results. Also I
don't this tuning as something that is trivially to do as you suggest.
For example, how exactly do you assess a crash as reliably happening
vs episodically? How exactly do you choose number of tests for each
case? Choosing too few tests will lead to incorrect results, choosing
too many will lead to incorrect results. How exactly do you assess
that something that was happening reliably now does not happen
reliably? How do you assess that a crash is very different? Each of
the choices have chances of producing more bad results, so one would
need to rerun hundreds of bisections with old/new version, and then
manually mark results and then estimate quality change (which most
likely will be flaky or inconclusive in lots of cases). Tuning quality
of heuristics-based algorithms is very time consuming, especially if
each experiment takes weeks.

There is another down-side for not "super dumb" algorithms. Which is
explaining results. Consider that syzbot now mails a bisection where
the crash happened and a developer sees that it's the same crash, but
syzbot says "nope. did not crash". That will cause reasonable
questions and somebody (who would that be?) will need to come and
explain what happens and why, and how that counter-intuitive local
result was shown to improve quality overall. Simpler algorithms are
much easier to explain.

I consider bisection as high priority, but unfortunately only among
other high priority and very high priority work.
Besides work on the fuzzer itself and bug detection tools, we now test
15 kernels across 6 different OSes. Operational work can't be
deprioritized because then nothing will work at all. Change reviews
can't be deprioritized. Overseeing bug flow can't be deprioritized.
Updating crash parsing in response to new kernel output can't be
deprioritized. Answering all human emails can't be deprioritized.
