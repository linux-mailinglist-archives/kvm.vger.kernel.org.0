Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74FC1107CE9
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2019 06:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbfKWFP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Nov 2019 00:15:29 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41198 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfKWFP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Nov 2019 00:15:28 -0500
Received: by mail-qk1-f195.google.com with SMTP id m125so8214419qkd.8
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 21:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=td3lSd+1Hj7wjzQBUneLylwj0bvqJWNQn19AnBKU34U=;
        b=DEkirAPa3hKaEvR/UKdspuRqYFHBT1jF37FtLNsKCmchp7VypiLHeHqDW+5adpCK/V
         RNoZfLT1IXHjkVfFVLyEyDXDnrPGtZCoillGOZMwsRgwpw31hEJH3J9ZDMzzdWwKdg8d
         QQBWlVz9Y4uxwPXw6bsyDA44CEeDDpdPO8+XemZLhlaWEJZmTVZ4rm1UqxwNP6wTL8wg
         pmQhemgcuxd2P5NxDzsvWZvHPFnrLPT6LLmPw6jsUo2XscunaJCWKrmsBdrBt9BlXaRK
         9+6k7cwBq/8vblXnw3rPNMh2oVnLBh7hdKqv36Cw/LSRhX2CM9CrBXPXCxjz38IVWEjj
         h/tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=td3lSd+1Hj7wjzQBUneLylwj0bvqJWNQn19AnBKU34U=;
        b=J4mcznkjrq5cdCOgM72UY4iOzWzmUFo9xPAApWypizi0j+JAFOSgC4atQAJbWRRLIf
         /Sn7pmt+b1KfkXx/VD3gxH/fkagnNjeiSchX6dzzUVBywjkkTk8T6A/9Mqca48tvDp0n
         Fx8NS3bYC/Z83lzYG8Oxc6PiNNLJOzo3SSK8PWK7ORdXaNo0TeSMvM2e27ucUsoIgRlc
         qilSmZ4EpZ8fjPby0HmmCDvVFnVEgHMnx7UNKkMR8iLgtaJXZQqvQ5Bb17J8Z4iV0RLk
         Ml7zFCjDqbhwidjqRN8/SM0HI6MpsvUrYhPvXohO/PsSkxo4FQ/Ht9Q4t/3A/mwZbkWn
         ZpiA==
X-Gm-Message-State: APjAAAWSRolEmVjEbciY4daXUZxTDWF/a5xUqG6E7GkFdkowf8g5GL6F
        siWVe5Z9VRE/X1nqMsJtqudSSvwWzERmhUbV0syBJg==
X-Google-Smtp-Source: APXvYqyHJN3R+Gedk5zmMZL4Ag9vnAn1KF1/f1a5+Ok3FkQLi1DBlZ5Ga+QgOWLFLf9l9N5He2B15Hoqj/eF4OH73jg=
X-Received: by 2002:a37:de12:: with SMTP id h18mr1108022qkj.256.1574486127183;
 Fri, 22 Nov 2019 21:15:27 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e67a05057314ddf6@google.com> <0000000000005eb1070597ea3a1f@google.com>
 <20191122205453.GE31235@linux.intel.com>
In-Reply-To: <20191122205453.GE31235@linux.intel.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 23 Nov 2019 06:15:15 +0100
Message-ID: <CACT4Y+b9FD8GTHc0baY-kUkuNFo-gdXCJ-uk5JtJSyjsyt8jTg@mail.gmail.com>
Subject: Re: general protection fault in __schedule (2)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
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

On Fri, Nov 22, 2019 at 9:54 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Nov 21, 2019 at 11:19:00PM -0800, syzbot wrote:
> > syzbot has bisected this bug to:
> >
> > commit 8fcc4b5923af5de58b80b53a069453b135693304
> > Author: Jim Mattson <jmattson@google.com>
> > Date:   Tue Jul 10 09:27:20 2018 +0000
> >
> >     kvm: nVMX: Introduce KVM_CAP_NESTED_STATE
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=124cdbace00000
> > start commit:   234b69e3 ocfs2: fix ocfs2 read block panic
> > git tree:       upstream
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=114cdbace00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=164cdbace00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=5fa12be50bca08d8
> > dashboard link: https://syzkaller.appspot.com/bug?extid=7e2ab84953e4084a638d
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150f0a4e400000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17f67111400000
> >
> > Reported-by: syzbot+7e2ab84953e4084a638d@syzkaller.appspotmail.com
> > Fixes: 8fcc4b5923af ("kvm: nVMX: Introduce KVM_CAP_NESTED_STATE")
> >
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>
> Is there a way to have syzbot stop processing/bisecting these things
> after a reasonable amount of time?  The original crash is from August of
> last year...
>
> Note, the original crash is actually due to KVM's put_kvm() fd race, but
> whatever we want to blame, it's a duplicate.
>
> #syz dup: general protection fault in kvm_lapic_hv_timer_in_use

Hi Sean,

syzbot only sends bisection results to open bugs with no known fixes.
So what you did (marking the bug as invalid/dup, or attaching a fix)
would stop it from doing/sending bisection.

"Original crash happened a long time ago" is not necessary a good
signal. On the syzbot dashboard
(https://syzkaller.appspot.com/upstream), you can see bugs with the
original crash 2+ years ago, but they are still pretty much relevant.
The default kernel development process strategy for invalidating bug
reports by burying them in oblivion has advantages, but also
downsides. FWIW syzbot prefers explicit status tracking.

Besides implications on the mainline development, consider the
following. We regularly discover the same bugs (missed backports) on
LTS kernels:
https://syzkaller.appspot.com/linux-4.14
https://syzkaller.appspot.com/linux-4.19
The dashboard also shows similar crash signatures in other tested
kernels. So say you see a crash in your product kernel, and you notice
that a similar crash happened on mainline some time ago, but
presumably it was fixed, but then you look at the bug report thread
and there is no info whatsoever as to what happened.
Now this bug report:
https://syzkaller.appspot.com/bug?extid=7e2ab84953e4084a638d
is linked to "general protection fault in kvm_lapic_hv_timer_in_use":
https://syzkaller.appspot.com/bug?id=0c330c4e475223a40d95f1d94c761357dd0f011f
which has a recorded fix "KVM: nVMX: Fix bad cleanup on error of
get/set nested state IOCTLs":
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=26b471c7e2f7befd0f59c35b257749ca57e0ed70
