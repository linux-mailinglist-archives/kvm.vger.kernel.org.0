Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABA4109326
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 18:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbfKYRyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 12:54:19 -0500
Received: from mga12.intel.com ([192.55.52.136]:14985 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729220AbfKYRyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 12:54:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Nov 2019 09:54:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,242,1571727600"; 
   d="scan'208";a="216979269"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 25 Nov 2019 09:54:17 -0800
Date:   Mon, 25 Nov 2019 09:54:17 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dmitry Vyukov <dvyukov@google.com>
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
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: general protection fault in __schedule (2)
Message-ID: <20191125175417.GD12178@linux.intel.com>
References: <000000000000e67a05057314ddf6@google.com>
 <0000000000005eb1070597ea3a1f@google.com>
 <20191122205453.GE31235@linux.intel.com>
 <CACT4Y+b9FD8GTHc0baY-kUkuNFo-gdXCJ-uk5JtJSyjsyt8jTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+b9FD8GTHc0baY-kUkuNFo-gdXCJ-uk5JtJSyjsyt8jTg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 23, 2019 at 06:15:15AM +0100, Dmitry Vyukov wrote:
> On Fri, Nov 22, 2019 at 9:54 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Thu, Nov 21, 2019 at 11:19:00PM -0800, syzbot wrote:
> > > syzbot has bisected this bug to:
> > >
> > > commit 8fcc4b5923af5de58b80b53a069453b135693304
> > > Author: Jim Mattson <jmattson@google.com>
> > > Date:   Tue Jul 10 09:27:20 2018 +0000
> > >
> > >     kvm: nVMX: Introduce KVM_CAP_NESTED_STATE
> > >
> > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=124cdbace00000
> > > start commit:   234b69e3 ocfs2: fix ocfs2 read block panic
> > > git tree:       upstream
> > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=114cdbace00000
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=164cdbace00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=5fa12be50bca08d8
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=7e2ab84953e4084a638d
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150f0a4e400000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17f67111400000
> > >
> > > Reported-by: syzbot+7e2ab84953e4084a638d@syzkaller.appspotmail.com
> > > Fixes: 8fcc4b5923af ("kvm: nVMX: Introduce KVM_CAP_NESTED_STATE")
> > >
> > > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> >
> > Is there a way to have syzbot stop processing/bisecting these things
> > after a reasonable amount of time?  The original crash is from August of
> > last year...
> >
> > Note, the original crash is actually due to KVM's put_kvm() fd race, but
> > whatever we want to blame, it's a duplicate.
> >
> > #syz dup: general protection fault in kvm_lapic_hv_timer_in_use
> 
> Hi Sean,
> 
> syzbot only sends bisection results to open bugs with no known fixes.
> So what you did (marking the bug as invalid/dup, or attaching a fix)
> would stop it from doing/sending bisection.
> 
> "Original crash happened a long time ago" is not necessary a good
> signal. On the syzbot dashboard
> (https://syzkaller.appspot.com/upstream), you can see bugs with the
> original crash 2+ years ago, but they are still pretty much relevant.
> The default kernel development process strategy for invalidating bug
> reports by burying them in oblivion has advantages, but also
> downsides. FWIW syzbot prefers explicit status tracking.

I have no objection to explicit status tracking or getting pinged on old
open bugs.  I suppose I don't even mind the belated bisection, I'd probably
whine if syzbot didn't do the bisection :-).

What's annoying is the report doesn't provide any information about when it
originally occured or on what kernel it originally failed.  It didn't occur
to me that the original bug might be a year old and I only realized it was
from an old kernel when I saw "4.19.0-rc4+" in the dashboard's sample crash
log.  Knowing that the original crash was a year old would have saved me
5-10 minutes of getting myself oriented.

Could syzbot provide the date and reported kernel version (assuming the
kernel version won't be misleading) of the original failure in its reports?
