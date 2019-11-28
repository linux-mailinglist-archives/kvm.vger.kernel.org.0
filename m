Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B4E10C631
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 10:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfK1JxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 04:53:24 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:34948 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfK1JxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 04:53:24 -0500
Received: by mail-qv1-f65.google.com with SMTP id y18so10103611qve.2
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 01:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=idVy1nzezWTkm1R/1G5BVNFaJvGirW1RbJcNW1zc+1w=;
        b=trqMBsySiXIV0sj3AbB8YO5bHj7bVJVOE2Stpp4CdbkrJK7n9ZoLf5yVP+0HiCMqst
         DRxfcE/2J3L8xgwFL4n7R+OLLHrc/Au8p60XxmCM8YP0FtNcFNEvMiRnvC6qMOOvxh7G
         OABL+AQPX3J0XyZ+JVc7fU+kkJW9NaM3PtVPckXw4bAgiGnld4BrdfbYnMrwnSpOPrf8
         +/OKPJtrmdVxbDJvKFDz85OHhIwc1kNscS1XmweAxKfp/gzmAcNS38A5iA+RfaRx9q/s
         WGVqFDXcfQytWw2TeuE9w1mF5uq4EGRq0O5snFDIHwIrrUn1YFwXWyzMJaCRW/hdvsNp
         SYqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=idVy1nzezWTkm1R/1G5BVNFaJvGirW1RbJcNW1zc+1w=;
        b=EY3eSntfHsM6KGF3NORfR5alVvLIRpAxCy5aBTt4aZnOxgHO1To6Zc7BmETG8aMZz3
         wsypbOSXO2QtYygUv0QlZc285CKLX1XEeb/zrlpdwU0fQzj0tDYw4V9O1rYZSs7JPwES
         tMrd7AUDSgL8dffDYrryPF67FJTobq6JNtBXTE2RvKu+EptKhY38jpabkU6pIqQOrZTR
         KuYjQgLS3rNU+WU+Cl2UjdFy9P5zT0+WvIJ3ENKK3jPfAychwq1wfYMq1ZZaofdffY6t
         YYhCANCRKj0z1HA8wqZDJhQFJdmT7tdZK5I6ZXK32TcVBUO1zM8jLWjeiO4QxaZo+zP1
         HL0g==
X-Gm-Message-State: APjAAAWt2qG/Kqhl/tcnm7mMCrGeWt0/iW6lQyt+nX+8+cNHrDFyGYOb
        P7orePss59l71QthEJkoam7FfOb7JyF6UKKO6+wZ4g==
X-Google-Smtp-Source: APXvYqzKOHlkd2Jw/sJCN6hng19dePkMrosAYDQmltCA6Z/ehub1ahXkdmPit/WKFhLMzQsJsAAWVIV6o9QGHyUgLZg=
X-Received: by 2002:a05:6214:8ee:: with SMTP id dr14mr10061695qvb.122.1574934802319;
 Thu, 28 Nov 2019 01:53:22 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e67a05057314ddf6@google.com> <0000000000005eb1070597ea3a1f@google.com>
 <20191122205453.GE31235@linux.intel.com> <CACT4Y+b9FD8GTHc0baY-kUkuNFo-gdXCJ-uk5JtJSyjsyt8jTg@mail.gmail.com>
 <20191125175417.GD12178@linux.intel.com>
In-Reply-To: <20191125175417.GD12178@linux.intel.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 28 Nov 2019 10:53:10 +0100
Message-ID: <CACT4Y+Yu2LxcpQmNMjVTzc4bWojda0+qWJmrdRSc-XTyN8C20A@mail.gmail.com>
Subject: Re: general protection fault in __schedule (2)
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        syzkaller <syzkaller@googlegroups.com>
Cc:     syzbot <syzbot+7e2ab84953e4084a638d@syzkaller.appspotmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        James Morris <jmorris@namei.org>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Pavel Tatashin <pasha.tatashin@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 25, 2019 at 6:54 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Sat, Nov 23, 2019 at 06:15:15AM +0100, Dmitry Vyukov wrote:
> > On Fri, Nov 22, 2019 at 9:54 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Thu, Nov 21, 2019 at 11:19:00PM -0800, syzbot wrote:
> > > > syzbot has bisected this bug to:
> > > >
> > > > commit 8fcc4b5923af5de58b80b53a069453b135693304
> > > > Author: Jim Mattson <jmattson@google.com>
> > > > Date:   Tue Jul 10 09:27:20 2018 +0000
> > > >
> > > >     kvm: nVMX: Introduce KVM_CAP_NESTED_STATE
> > > >
> > > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=124cdbace00000
> > > > start commit:   234b69e3 ocfs2: fix ocfs2 read block panic
> > > > git tree:       upstream
> > > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=114cdbace00000
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=164cdbace00000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=5fa12be50bca08d8
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=7e2ab84953e4084a638d
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150f0a4e400000
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17f67111400000
> > > >
> > > > Reported-by: syzbot+7e2ab84953e4084a638d@syzkaller.appspotmail.com
> > > > Fixes: 8fcc4b5923af ("kvm: nVMX: Introduce KVM_CAP_NESTED_STATE")
> > > >
> > > > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> > >
> > > Is there a way to have syzbot stop processing/bisecting these things
> > > after a reasonable amount of time?  The original crash is from August of
> > > last year...
> > >
> > > Note, the original crash is actually due to KVM's put_kvm() fd race, but
> > > whatever we want to blame, it's a duplicate.
> > >
> > > #syz dup: general protection fault in kvm_lapic_hv_timer_in_use
> >
> > Hi Sean,
> >
> > syzbot only sends bisection results to open bugs with no known fixes.
> > So what you did (marking the bug as invalid/dup, or attaching a fix)
> > would stop it from doing/sending bisection.
> >
> > "Original crash happened a long time ago" is not necessary a good
> > signal. On the syzbot dashboard
> > (https://syzkaller.appspot.com/upstream), you can see bugs with the
> > original crash 2+ years ago, but they are still pretty much relevant.
> > The default kernel development process strategy for invalidating bug
> > reports by burying them in oblivion has advantages, but also
> > downsides. FWIW syzbot prefers explicit status tracking.
>
> I have no objection to explicit status tracking or getting pinged on old
> open bugs.  I suppose I don't even mind the belated bisection, I'd probably
> whine if syzbot didn't do the bisection :-).
>
> What's annoying is the report doesn't provide any information about when it
> originally occured or on what kernel it originally failed.  It didn't occur
> to me that the original bug might be a year old and I only realized it was
> from an old kernel when I saw "4.19.0-rc4+" in the dashboard's sample crash
> log.  Knowing that the original crash was a year old would have saved me
> 5-10 minutes of getting myself oriented.
>
> Could syzbot provide the date and reported kernel version (assuming the
> kernel version won't be misleading) of the original failure in its reports?

+syzkaller mailing list for syzbot discussion

We tried to provide some aggregate info in email reports long time ago
(like trees where it occurred, number of crashes). The problem was
that any such info captured in emails become stale very quickly. E.g.
later somebody looks at the report and thinking "oh, linux-next only"
or "it happened only once", but maybe it's not for a long time. E.g.
if we say "it last happened 3 months" ago, maybe it's just happened
again once we send it... While this "emails always provide latest
updates" works for kernel in other context b/c updates provided by
humans and there is no other source of truth; it does not play well
with automated systems, or syzbot will need to send several emails per
second, because it's really the rate at which things change.

If we add some info, which one should it be? The original crash, the
one used for bisection, or the latest one? All these are different...
syzbot does not know "4.19.0-rc4+" strings for commits, it generally
identifies commits by hashes. There are dates, but then again which
one? Author or commit? Author is what generally shown, but I remember
a number of patches where Author date is 1.5 years old for just merged
commits :)

There is another problem: if we stuff too many info into emails,
people still stop reading them. This is very serious and real concern.
If you have 1000-page manual, it's well documented, but it's
equivalent to no docs at all, nobody is reading 1000 pages to find 1
bit of info. Especially if you don't know that there is an important
bit that you need to find in the first place...

What would be undoubtedly positive is presenting information on the
dashboard better (If we find a way).
Currently the page says near the top:

First crash: 478d, last: 430d

The idea was that "last: 430d" is supposed to communicate the bit of
info that confused you. Is it what you were looking for? Is there a
better way to present it?

Unfortunately most of such problems are much harder if extended beyond
1 concrete case...
