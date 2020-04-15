Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF9A1AAF9E
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 19:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411005AbgDOR1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 13:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410992AbgDOR1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 13:27:36 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23006C061A0C
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 10:27:35 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id 19so2101914ioz.10
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 10:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4aWqk5/j/HVgM5+Uxpcn41+0bfk/7nkK2qOIYF53Lug=;
        b=um6fO4ICFHnTmDxpxj4g8omamITG4Or1AS4OSK5B4sRHUERm7W6RtMHovrOQY9NWO3
         s6Gvu6XKFJW1HXgXoIxxEHJGk8d64F6mmmfi7MCIEg1HD+XWJdTJu3Bg9t3CnBN+LJGH
         lt/aWp81rCdC4JtMEqxtZPoPRhMkRqqSYCqh8Wh2a3p6SxQ5m/nitQkYecD2QcSpzgaH
         U7xG1nJijRiotZhcZ3ZSJwY1Il/MhiqdfDeleZcV+5vaALmqnUalQH40IIvjzTG7WQgG
         xbQOFyBJpd4CVHVRGAPSmqO/Cu1D/EDVpmgX5wHZ9vnnoIKQ6CtV6l9WjlNmI2DaYcgY
         usfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4aWqk5/j/HVgM5+Uxpcn41+0bfk/7nkK2qOIYF53Lug=;
        b=PhTZmIcR+ybvEikR+feVXAQHoJAZ0W7Vk+4AS1Zx9q4UJw0KNA9hxg1tHCgYBIgM2z
         XGPCrik5LFa5VE0R44MzVhAsA+itCQTK74SXXk4x+rhZMJw7MvP+j8JK0dGp6o7R+m2m
         Gvftx3jtW3CnRxNZoQ7329f2FJoYk1l7FSAvOEI7cD9IiLaWOs/8uqobPafFyW9gQvEP
         +ovZNYanBbVdlCx3K0IglRL9/of2k4BZ4Le7PUdB74n3/47/huewekymP1/pJXgZvoJh
         CxCQ+tqscr0RW5/EyLj6bBixuHmK/AdVyUpa4KvVhj9YeYzc/F8l7AU5Gg9C5iwki5l3
         dbkA==
X-Gm-Message-State: AGi0Pua7k5kiF45wolRPjwJHhFFjHFhNs56oGeabJ7lfBcnMxwwKveFr
        KriNU1q5F6xrdZG0Cnuh97dxhXlaYzFldnEKgZQHjw==
X-Google-Smtp-Source: APiQypJFfAOIZLYxuanxeQwSwWbZbhF6g2d7/UWqFOVUVmkbVr4YQyfPCjXeu6IZ+UJGJnOHg/Ylh6hZ2M2icEmj0iU=
X-Received: by 2002:a6b:9346:: with SMTP id v67mr16861359iod.154.1586971654121;
 Wed, 15 Apr 2020 10:27:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200415012320.236065-1-jcargill@google.com> <20200415023726.GD12547@linux.intel.com>
 <20200415025105.GE12547@linux.intel.com>
In-Reply-To: <20200415025105.GE12547@linux.intel.com>
From:   Jon Cargille <jcargill@google.com>
Date:   Wed, 15 Apr 2020 10:27:21 -0700
Message-ID: <CANxmayggcRWE994FVVgHFxBk4pv0Zf6a7AWT7psyOJuFs0VaVg@mail.gmail.com>
Subject: Re: [PATCH 1/1] KVM: pass through CPUID(0x80000006)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Northup <digitaleric@gmail.com>,
        Eric Northup <digitaleric@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> I assume you want to say something like:

That's a much better commit message--thank you, Sean!

> Jim's tag is unnecessary, unless he was a middleman between Eric and Jon,

I appreciate the feedback; I was trying to capture that Jim "was in
the patch's delivery path."
(per submitting-patches.rst), but it sounds like that is intended for
a more explicit middle-man
relationship than I had understood. Jim reviewed it internally before
sending, which sounds
like it should be expressed as an "Acked-by" instead; is that accurate?

>> Only one of Eric's signoffs is needed (the one that matches the From: tag,
> Ah, Eric's @google.com mail bounced.  Maybe do:
>
>   Signed-off-by: Eric Northup (Google) <digitaleric@gmail.com>

Gotcha, thanks. Yes, when I conferred with Eric on submitting his
commits, he had wanted to
acknowledge that the work was done while he was at Google (e.g. his
old Google email addr),
and  I wanted to include current contact information for him as well.

Your suggestion to combine into a single Signed-off-by is a good one,
and I'll use that form
in the future.

Thanks much,

Jon

On Tue, Apr 14, 2020 at 7:51 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Apr 14, 2020 at 07:37:26PM -0700, Sean Christopherson wrote:
> > On Tue, Apr 14, 2020 at 06:23:20PM -0700, Jon Cargille wrote:
> > > From: Eric Northup <digitaleric@gmail.com>
> > >
> > > Return L2 cache and TLB information to guests.
> > > They could have been set before, but the defaults that KVM returns will be
> > > necessary for usermode that doesn't supply their own CPUID tables.
> >
> > I don't follow the changelog.  The code makes sense, but I don't understand
> > the justification.  This only affects KVM_GET_SUPPORTED_CPUID, i.e. what's
> > advertised to userspace, it doesn't directly change CPUID emulation in any
> > way.  The "They could have been set before" blurb is especially confusing.
> >
> > I assume you want to say something like:
> >
> >   Return the host's L2 cache and TLB information for CPUID.0x80000006
> >   instead of zeroing out the entry as part of KVM_GET_SUPPORTED_CPUID.
> >   This allows a userspace VMM to feed KVM_GET_SUPPORTED_CPUID's output
> >   directly into KVM_SET_CPUID2 (without breaking the guest).
> >
> > > Signed-off-by: Eric Northup <digitaleric@google.com>
> > > Signed-off-by: Eric Northup <digitaleric@gmail.com>
> > > Signed-off-by: Jon Cargille <jcargill@google.com>
> > > Signed-off-by: Jim Mattson <jmattson@google.com>
> >
> > Jim's tag is unnecessary, unless he was a middleman between Eric and Jon,
> > in which case Jim's tag should also come between Eric's and Jon's.
> >
> > Only one of Eric's signoffs is needed (the one that matches the From: tag,
> > i.e. is the official author).  I'm guessing Google would prefer the author
> > to be the @google.com address.
>
> Ah, Eric's @google.com mail bounced.  Maybe do:
>
>   Signed-off-by: Eric Northup (Google) <digitaleric@gmail.com>
>
> to clarify the work was done for Google without having a double signoff
> and/or a dead email.
