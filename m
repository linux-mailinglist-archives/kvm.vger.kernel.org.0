Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4A735E659
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 20:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347689AbhDMS2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 14:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbhDMS23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 14:28:29 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62744C06175F
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:28:09 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id o2so75563qtr.4
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 11:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1b6fQegDXTfOo9rLlJ7IRs6r0r44VGP2mf4s/0ecvo0=;
        b=nf9++JWyG/M6Mmfdw5aeK45629inqMZeSjVLq5Ax0L9ElgAvhJZyuCM9Te+I9Kyl5a
         iXyhLLioBiFdGm7rk1wd5p84idU10jAUn8b+WEJAOOAesMCAwY++HYwWDMkblxXty/qX
         Ed8EmAVdam5KmBxMK8BG7jFPcx6+XSHqoAG6Ao0wVBnAwMfCQjqeDHUhGnI416sQOYgQ
         SaUoVtqjcAljnkfNMcToorCa9O4pwLNuYDdDZxKLS2QV2l558WY4qtkdRQw7HV+0ZRox
         dxWme/SMSCjUQFohabSt/7h7D5jN5eiJ0FeGYwd8F8+0u68cr+0EjWl7GULyn7ETPtjr
         uE+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1b6fQegDXTfOo9rLlJ7IRs6r0r44VGP2mf4s/0ecvo0=;
        b=Xq9A+xZBWnsTeQmo8s07nWrNyYhoeDdXBHp7r0OjUgwUIc4nv5Yb0yiJGIwJQRG4fM
         2Yb9V7kOFybC8JDsTlfo5K/qjH7SIRrxi5W8i3re7NX69vjnkNSixwvc2gKK4LN6bFWN
         z+80Y5Gh4cA4WcfUXnOUBIKI+FCLRSZLAavSwJMuPXn+raAlTEALnhjRSicZHIwQU+eI
         ITqhRth76zoGkRur43hagJ3VNM8Jrda6gQQvjFtwU86mydGnQb5c8t2EifUpwpo0XIo1
         0ZBBFKdDv82LsnMQ3++wLXfWT8/v+xjN68D5797H+Os9c8MxwG1yvgl5YyPl0B4aBhWy
         X6Ag==
X-Gm-Message-State: AOAM532/aoP/HF4wepFEotE/y/JRun8pCHJom9TQASwZzsO0e4ec1Q9l
        C2obfWLZcz6GXyjqt+R253McE9rHlrtZR/K370NH/Q==
X-Google-Smtp-Source: ABdhPJxIagpZ+FC7TxENC+uaVUmYn5r8p72aV/oNArktcR8GkH9VEMvn884xJFc/l2Hc4gUHyEgqUhbHsQ4t1fMdy18=
X-Received: by 2002:ac8:110d:: with SMTP id c13mr31240232qtj.337.1618338488423;
 Tue, 13 Apr 2021 11:28:08 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000ca9a6005bec29ebe@google.com> <2db3c803-6a94-9345-261a-a2bb74370c02@redhat.com>
 <20210331042922.GE2065@kadam> <20210401121933.GA2710221@ziepe.ca>
 <CACT4Y+ZG9Dhv1UTvotsTimVrzaojPN91Lu1CsPqm4kd1j5yNkQ@mail.gmail.com> <20210413181145.GK227011@ziepe.ca>
In-Reply-To: <20210413181145.GK227011@ziepe.ca>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 13 Apr 2021 20:27:57 +0200
Message-ID: <CACT4Y+b6g7DNQTRo0VSFgPzAZF2vMJOcnijuLWeLxUtOWL1nrA@mail.gmail.com>
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

On Tue, Apr 13, 2021 at 8:11 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Tue, Apr 13, 2021 at 07:20:12PM +0200, Dmitry Vyukov wrote:
> > > > Plus users are going to be seeing this as well.  According to the commit
> > > > message for 69bacee7f9ad ("mm: Add unsafe_follow_pfn") "Unfortunately
> > > > there's some users where this is not fixable (like v4l userptr of iomem
> > > > mappings)".  It sort of seems crazy to dump this giant splat and then
> > > > tell users to ignore it forever because it can't be fixed...  0_0
> > >
> > > I think the discussion conclusion was that this interface should not
> > > be used by userspace anymore, it is obsolete by some new interface?
> > >
> > > It should be protected by some kconfig and the kconfig should be
> > > turned off for syzkaller runs.
> >
> > If this is not a kernel bug, then it must not use WARN_ON[_ONCE]. It
> > makes the kernel untestable for both automated systems and humans:
>
> It is a kernel security bug triggerable by userspace.
>
> > And if it's a kernel bug reachable from user-space, then I think this
> > code should be removed entirely, not just on all testing systems. Or
> > otherwise if we are not removing it for some reason, then it needs to
> > be fixed.
>
> Legacy embedded systems apparently require it.
>
> It should be blocked by a kconfig. Distributions and syzkaller runs
> should not enable that kconfig. What else can we do for insane uapi?

I see. Adding a config gives at least some path forward, so if there
are no better options, that's do that. If we default it to 'n' and add
a bold warning in the description, it may work.
