Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F3835E4E5
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 19:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347137AbhDMRVu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 13:21:50 -0400
Received: from mail-qk1-f174.google.com ([209.85.222.174]:42905 "EHLO
        mail-qk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345750AbhDMRVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 13:21:44 -0400
Received: by mail-qk1-f174.google.com with SMTP id d15so5652739qkc.9
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 10:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OxU0Eujrm9GQyvXdIjhuiVVTC0s99PIjeEwmRYVaK0M=;
        b=TvQ0AiMsfQyBkVrkMDo18tZSvp8ItDKLX9tIp24gJJi9NrydOSekkMLSPHzrYhWjkV
         kXfwlD8SA8kKV/fBmZHnkDl7WgoA2uz4kz0fJ7rWdXXQ69IkfLAnlDT/vm7Ptw/lexEa
         iDybKWcdRXGnOCWSfkGPqZ4dkCHaoRuNzrxQ3wkNmL7avVA1jv66QGIuJhTalp9yccWi
         NABnGz+dNplEJ3EybgzfEkASRU8pZxjuDuM6zwCBX4Yf/H0dXOQrFGg1UjfcT/g2x+fp
         Gr8+YicXBTWxLVD1DR4OjHi8EUuWZpJeAkBPbQKhcUAPTTHmILuIgSiCpcB9SfHGysPL
         ZPAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OxU0Eujrm9GQyvXdIjhuiVVTC0s99PIjeEwmRYVaK0M=;
        b=DrbWOrfvjailT2CcCZh2+259ifZse25OthFEaToQyN6areKMEPP+ZsL9pLMVxXSWR9
         yF1vKhq88GF2EerhwnAyMElkJtg1Ef4xFpecH1mw9P6AalEy+n5Cp3XZnR7OR4kuXacp
         dQsTPi4MrtdsXhNV4L/I7s8G82NdQzKFp6YtQt+23xqmY/jnc0UVbFLQtnAPkra8WcwH
         NJfmdPBcAxaTmYOnpb/7llbHnDkTPoQ6ia9LYEvPAAEXXR2zz9SYv1xMQijmywz1LVru
         7oe1fyXiVbugvE/s8SEjExRKakJ952ZCyVOP70uRprdjX/RI5z4TqvsPNeuAV+WspH2z
         uPZw==
X-Gm-Message-State: AOAM533bvSFKa9QbgdaHPUW75svxwXLWdA5Jsv7y/I503KLseiegOEfC
        smMbEPToW7+erZlG4+99SIQ1Bx08nCK5eP/3i/Zhhw==
X-Google-Smtp-Source: ABdhPJzZbF9SOsSr1JV8btp47Zzg36R3JvHSGAwCv47evxt2VeGK3yqlQo147eL5mHjg5iEX+jdnHlDqSzZOV8YjVsc=
X-Received: by 2002:a05:620a:243:: with SMTP id q3mr14170127qkn.501.1618334423663;
 Tue, 13 Apr 2021 10:20:23 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000ca9a6005bec29ebe@google.com> <2db3c803-6a94-9345-261a-a2bb74370c02@redhat.com>
 <20210331042922.GE2065@kadam> <20210401121933.GA2710221@ziepe.ca>
In-Reply-To: <20210401121933.GA2710221@ziepe.ca>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 13 Apr 2021 19:20:12 +0200
Message-ID: <CACT4Y+ZG9Dhv1UTvotsTimVrzaojPN91Lu1CsPqm4kd1j5yNkQ@mail.gmail.com>
Subject: Re: [syzbot] WARNING in unsafe_follow_pfn
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        syzbot <syzbot+015dd7cdbbbc2c180c65@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        daniel.vetter@intel.com, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        James Morris <jmorris@namei.org>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        m.szyprowski@samsung.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 1, 2021 at 2:19 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Wed, Mar 31, 2021 at 07:29:22AM +0300, Dan Carpenter wrote:
> > On Tue, Mar 30, 2021 at 07:04:30PM +0200, Paolo Bonzini wrote:
> > > On 30/03/21 17:26, syzbot wrote:
> > > > Hello,
> > > >
> > > > syzbot found the following issue on:
> > > >
> > > > HEAD commit:    93129492 Add linux-next specific files for 20210326
> > > > git tree:       linux-next
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=169ab21ad00000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=6f2f73285ea94c45
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=015dd7cdbbbc2c180c65
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119b8d06d00000
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112e978ad00000
> > > >
> > > > The issue was bisected to:
> > > >
> > > > commit d40b9fdee6dc819d8fc35f70c345cbe0394cde4c
> > > > Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > > Date:   Tue Mar 16 15:33:01 2021 +0000
> > > >
> > > >      mm: Add unsafe_follow_pfn
> > > >
> > > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=122d2016d00000
> > > > final oops:     https://syzkaller.appspot.com/x/report.txt?x=112d2016d00000
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=162d2016d00000
> > > >
> > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > Reported-by: syzbot+015dd7cdbbbc2c180c65@syzkaller.appspotmail.com
> > > > Fixes: d40b9fdee6dc ("mm: Add unsafe_follow_pfn")
> > >
> > > This is basically intentional because get_vaddr_frames is broken, isn't it?
> > > I think it needs to be ignored in syzkaller.
> >
> > What?
> >
> > The bisect is wrong (because it's blaming the commit which added the
> > warning instead of the commit which added the buggy caller) but the
> > warning is correct.
> >
> > Plus users are going to be seeing this as well.  According to the commit
> > message for 69bacee7f9ad ("mm: Add unsafe_follow_pfn") "Unfortunately
> > there's some users where this is not fixable (like v4l userptr of iomem
> > mappings)".  It sort of seems crazy to dump this giant splat and then
> > tell users to ignore it forever because it can't be fixed...  0_0
>
> I think the discussion conclusion was that this interface should not
> be used by userspace anymore, it is obsolete by some new interface?
>
> It should be protected by some kconfig and the kconfig should be
> turned off for syzkaller runs.

If this is not a kernel bug, then it must not use WARN_ON[_ONCE]. It
makes the kernel untestable for both automated systems and humans:

https://lwn.net/Articles/769365/

<quote>
Greg Kroah-Hartman raised the problem of core kernel API code that
will use WARN_ON_ONCE() to complain about bad usage; that will not
generate the desired result if WARN_ON_ONCE() is configured to crash
the machine. He was told that the code should just call pr_warn()
instead, and that the called function should return an error in such
situations. It was generally agreed that any WARN_ON() or
WARN_ON_ONCE() calls that can be triggered from user space need to be
fixed.
</quote>


https://lore.kernel.org/netdev/20210413085522.2caee809@gandalf.local.home/
From: Steven Rostedt
<quote>

I agree. WARN_ON(_ONCE) should be reserved for anomalies that should not
happen ever. Anything that the user could trigger, should not trigger a
WARN_ON.

A WARN_ON is perfectly fine for detecting an accounting error inside the
kernel. I have them scattered all over my code, but they should never be
hit, even if something in user space tries to hit it. (with an exception of
an interface I want to deprecate, where I want to know if it's still being
used ;-) Of course, that wouldn't help bots testing the code. And I haven't
done that in years)

Any anomaly that can be triggered by user space doing something it should
not be doing really needs a pr_warn().
</quote>

And if it's a kernel bug reachable from user-space, then I think this
code should be removed entirely, not just on all testing systems. Or
otherwise if we are not removing it for some reason, then it needs to
be fixed.
