Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D479410ED93
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 17:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbfLBQ4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 11:56:34 -0500
Received: from mga05.intel.com ([192.55.52.43]:14696 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727493AbfLBQ4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 11:56:33 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 08:56:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,268,1571727600"; 
   d="scan'208";a="200674119"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 02 Dec 2019 08:56:32 -0800
Date:   Mon, 2 Dec 2019 08:56:32 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzkaller <syzkaller@googlegroups.com>,
        syzbot <syzbot+7e2ab84953e4084a638d@syzkaller.appspotmail.com>,
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
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: general protection fault in __schedule (2)
Message-ID: <20191202165632.GA4063@linux.intel.com>
References: <000000000000e67a05057314ddf6@google.com>
 <0000000000005eb1070597ea3a1f@google.com>
 <20191122205453.GE31235@linux.intel.com>
 <CACT4Y+b9FD8GTHc0baY-kUkuNFo-gdXCJ-uk5JtJSyjsyt8jTg@mail.gmail.com>
 <20191125175417.GD12178@linux.intel.com>
 <CACT4Y+Yu2LxcpQmNMjVTzc4bWojda0+qWJmrdRSc-XTyN8C20A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Yu2LxcpQmNMjVTzc4bWojda0+qWJmrdRSc-XTyN8C20A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 28, 2019 at 10:53:10AM +0100, Dmitry Vyukov wrote:
> On Mon, Nov 25, 2019 at 6:54 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > I have no objection to explicit status tracking or getting pinged on old
> > open bugs.  I suppose I don't even mind the belated bisection, I'd probably
> > whine if syzbot didn't do the bisection :-).
> >
> > What's annoying is the report doesn't provide any information about when it
> > originally occured or on what kernel it originally failed.  It didn't occur
> > to me that the original bug might be a year old and I only realized it was
> > from an old kernel when I saw "4.19.0-rc4+" in the dashboard's sample crash
> > log.  Knowing that the original crash was a year old would have saved me
> > 5-10 minutes of getting myself oriented.
> >
> > Could syzbot provide the date and reported kernel version (assuming the
> > kernel version won't be misleading) of the original failure in its reports?
> 
> +syzkaller mailing list for syzbot discussion
> 
> We tried to provide some aggregate info in email reports long time ago
> (like trees where it occurred, number of crashes). The problem was
> that any such info captured in emails become stale very quickly. E.g.
> later somebody looks at the report and thinking "oh, linux-next only"
> or "it happened only once", but maybe it's not for a long time. E.g.
> if we say "it last happened 3 months" ago, maybe it's just happened
> again once we send it... While this "emails always provide latest
> updates" works for kernel in other context b/c updates provided by
> humans and there is no other source of truth; it does not play well
> with automated systems, or syzbot will need to send several emails per
> second, because it's really the rate at which things change.
> 
> If we add some info, which one should it be? The original crash, the
> one used for bisection, or the latest one? All these are different...
> syzbot does not know "4.19.0-rc4+" strings for commits, it generally
> identifies commits by hashes. There are dates, but then again which
> one? Author or commit? Author is what generally shown, but I remember
> a number of patches where Author date is 1.5 years old for just merged
> commits :)
> 
> There is another problem: if we stuff too many info into emails,
> people still stop reading them. This is very serious and real concern.
> If you have 1000-page manual, it's well documented, but it's
> equivalent to no docs at all, nobody is reading 1000 pages to find 1
> bit of info. Especially if you don't know that there is an important
> bit that you need to find in the first place...
> 
> What would be undoubtedly positive is presenting information on the
> dashboard better (If we find a way).
> Currently the page says near the top:
> 
> First crash: 478d, last: 430d
> 
> The idea was that "last: 430d" is supposed to communicate the bit of
> info that confused you. Is it what you were looking for? Is there a
> better way to present it?

Ah, yes, that's what I was looking for.  Tweaking the presention of the
dashboard and/or email reports, e.g. to encourage readers to go to the
dashboard in the first place, would definitely help.  A few ideas:

  - Display the first/last crash dates in yyyy/mm/dd format rather than
    showing the number of days since failure.  I didn't even realize 478d
    and 430d were relative dates until your email, though that's probably
    more my failing than syzbot's :-)

  - On the dashboard page, separate the basic crash info from the bisection
    details, e.g. display the basic crash info using the same table format
    as "Duplicate of" and "similar bugs", and/or move the bisection details
    below the aforementioned tables.  The basic info stands out fairly well
    when there aren't bisection details, but for bugs with bisection info
    the combined info becomes a wall of text that my eyes tend to skip over.

  - Don't rely on the recipients of bisection reports having the original
    crash report, e.g. use the dashboard link to reference the crash and
    always display it at the top, maybe isolated via whitespace.  The other
    auto-generated reports could use a similar format to teach folks that
    the dashboard link is the canonical reference.

    For example, on bisection show:

      syzbot has bisected crash:

        https://syzkaller.appspot.com/bug?extid=7e2ab84953e4084a638d

      first bad commit:
 
        commit 8fcc4b5923af5de58b80b53a069453b135693304
        Author: Jim Mattson <jmattson@google.com>
        Date:   Tue Jul 10 09:27:20 2018 +0000
      
             kvm: nVMX: Introduce KVM_CAP_NESTED_STATE

      bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=124cdbace00000
      start commit:   234b69e3 ocfs2: fix ocfs2 read block panic
      git tree:       upstream
      final crash:    https://syzkaller.appspot.com/x/report.txt?x=114cdbace00000
      console output: https://syzkaller.appspot.com/x/log.txt?x=164cdbace00000
      kernel config:  https://syzkaller.appspot.com/x/.config?x=5fa12be50bca08d8
      syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150f0a4e400000
      C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17f67111400000

    vs.

      syzbot has bisected this bug to:

      commit 8fcc4b5923af5de58b80b53a069453b135693304
      Author: Jim Mattson <jmattson@google.com>
      Date:   Tue Jul 10 09:27:20 2018 +0000

          kvm: nVMX: Introduce KVM_CAP_NESTED_STATE

      bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=124cdbace00000
      start commit:   234b69e3 ocfs2: fix ocfs2 read block panic
      git tree:       upstream
      final crash:    https://syzkaller.appspot.com/x/report.txt?x=114cdbace00000
      console output: https://syzkaller.appspot.com/x/log.txt?x=164cdbace00000
      kernel config:  https://syzkaller.appspot.com/x/.config?x=5fa12be50bca08d8
      dashboard link: https://syzkaller.appspot.com/bug?extid=7e2ab84953e4084a638d
      syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150f0a4e400000
      C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17f67111400000


  And a similar format for the initial crash report:

      syzbot found the following crash:

        https://syzkaller.appspot.com/bug?extid=00be5da1d75f1cc95f6b

      HEAD commit:    ad062195 Merge tag 'platform-drivers-x86-v5.4-1' of git://..
      git tree:       upstream
      console output: https://syzkaller.appspot.com/x/log.txt?x=154910ad600000
      kernel config:  https://syzkaller.appspot.com/x/.config?x=f9fc16a6374d5fd0
      compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

      Unfortunately, I don't have any reproducer for this crash yet.

  vs.

      syzbot found the following crash on:

      HEAD commit:    ad062195 Merge tag 'platform-drivers-x86-v5.4-1' of git://..
      git tree:       upstream
      console output: https://syzkaller.appspot.com/x/log.txt?x=154910ad600000
      kernel config:  https://syzkaller.appspot.com/x/.config?x=f9fc16a6374d5fd0
      dashboard link: https://syzkaller.appspot.com/bug?extid=00be5da1d75f1cc95f6b
      compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

      Unfortunately, I don't have any reproducer for this crash yet.
