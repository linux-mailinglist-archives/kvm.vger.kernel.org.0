Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA6EBC670
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 13:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408290AbfIXLOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 07:14:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40938 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408255AbfIXLOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 07:14:39 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 535BAC057F88
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 11:14:38 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id k184so793575wmk.1
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 04:14:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZdoM44ufwDkWEhL4uEThga8TobA9sHKPa7iHd5/kxt0=;
        b=RT8OZr1wRWTn3BkRLfw1/Ql54A1mZtItjoLlR0giKbhHrRkO6aqYyVrs5utce7n9Nf
         /etjia4scJbhO0kSPcaAqT/0N0GXm0mPrEoWQsL8tBFOAfUNQDZ9fbgvjDVo+1lt/p8E
         A3pSHWLYIIsWIyu9WqF0sQCXStweJp9FEgvlNlA9A/5OHod8pcfYpwDM91Sg6ZPktXWP
         t37TzlhYIRNoYe+tHn4284G5k26n977hV8X1Csc5UT+ORkOJhZUk9OHhCJD5iFHHfZ8C
         VFh+SQn5vKUWMN4c5zzVTu1eFBMq0FXLx6CmqwNwJYCOuvWmo7dnLKUPleTUD770maBu
         EFLw==
X-Gm-Message-State: APjAAAVa4aSrBtq2/PTFunGxCNFqE+9NpqdzUO2H2oAvN4HLtOYSpTsT
        C8xpxfMHxfImDb4XsrHvO/PpV+6LTwtGaibX1EhZzwN/uHqpUp8xF0lM1amIWfpSkDVthCxSC9Z
        1tTwNxYsZjqWd
X-Received: by 2002:adf:8444:: with SMTP id 62mr1828109wrf.202.1569323676841;
        Tue, 24 Sep 2019 04:14:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwJh41RD/VBo8haBgTH86yUTbGiVKEXV1JDna/o+beXlpMs9ip/EXIL9i2ajRjTs5I33Y5p/g==
X-Received: by 2002:adf:8444:: with SMTP id 62mr1828095wrf.202.1569323676581;
        Tue, 24 Sep 2019 04:14:36 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id s9sm1073218wme.36.2019.09.24.04.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 04:14:35 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Suleiman Souhlal <suleiman@google.com>
Cc:     John Stultz <john.stultz@linaro.org>, sboyd@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        rkrcmar@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
        Tomasz Figa <tfiga@google.com>
Subject: Re: [RFC 2/2] x86/kvmclock: Use host timekeeping.
In-Reply-To: <CABCjUKDPa1wrvp5zrjCa0tAQUO5UuFNgc00Z5kt_7rgakjApDw@mail.gmail.com>
References: <20190920062713.78503-1-suleiman@google.com> <20190920062713.78503-3-suleiman@google.com> <87woe38538.fsf@vitty.brq.redhat.com> <CABCjUKDPa1wrvp5zrjCa0tAQUO5UuFNgc00Z5kt_7rgakjApDw@mail.gmail.com>
Date:   Tue, 24 Sep 2019 13:14:35 +0200
Message-ID: <87ftkm7xpg.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Suleiman Souhlal <suleiman@google.com> writes:

> On Fri, Sep 20, 2019 at 10:33 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> Suleiman Souhlal <suleiman@google.com> writes:
>>
>> > When CONFIG_KVMCLOCK_HOST_TIMEKEEPING is enabled, and the host
>> > supports it, update our timekeeping parameters to be the same as
>> > the host. This lets us have our time synchronized with the host's,
>> > even in the presence of host NTP or suspend.
>> >
>> > When enabled, kvmclock uses raw tsc instead of pvclock.
>> >
>> > When enabled, syscalls that can change time, such as settimeofday(2)
>> > or adj_timex(2) are disabled in the guest.
>> >
>> > Signed-off-by: Suleiman Souhlal <suleiman@google.com>
>> > ---
>> >  arch/x86/Kconfig                |   9 +++
>> >  arch/x86/include/asm/kvmclock.h |   2 +
>> >  arch/x86/kernel/kvmclock.c      | 127 +++++++++++++++++++++++++++++++-
>> >  kernel/time/timekeeping.c       |  21 ++++++
>> >  4 files changed, 155 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> > index 4195f44c6a09..37299377d9d7 100644
>> > --- a/arch/x86/Kconfig
>> > +++ b/arch/x86/Kconfig
>> > @@ -837,6 +837,15 @@ config PARAVIRT_TIME_ACCOUNTING
>> >  config PARAVIRT_CLOCK
>> >       bool
>> >
>> > +config KVMCLOCK_HOST_TIMEKEEPING
>> > +     bool "kvmclock uses host timekeeping"
>> > +     depends on KVM_GUEST
>> > +     ---help---
>> > +       Select this option to make the guest use the same timekeeping
>> > +       parameters as the host. This means that time will be almost
>> > +       exactly the same between the two. Only works if the host uses "tsc"
>> > +       clocksource.
>> > +
>>
>> I'd also like to speak up against this config, it is confusing. In case
>> the goal is to come up with a TSC-based clock for guests which will
>> return the same as clock_gettime() on the host (or, is the goal to just
>> have the same reading for all guests on the host?) I'd suggest we create
>> a separate (from KVMCLOCK) clocksource (mirroring host timekeeper) and
>> guests will be free to pick the one they like.
>
> Fair enough. I'll do that in the next version of the patch.
>
> The goal is to have a guest clock that gives the same
> clock_gettime(CLOCK_MONOTONIC) as the host.
>

KVMCLOCK has lots of legacy derived from times when TSC synchronization
was not a given (I heard that this is still sometimes problematic with
multi-socket systems but oh well). If I was to design a new clock I'd
probably mirror Hyper-V's TSC page clocksource invalidating the page
when host timekeeper values are updated (and making guest spin).

The tricky part with this approach is probably tsc scaling/tsc
offsetting which is still going to be controlled by kvmclock (so the
guest has no option to read 'pure TSC'). As an alternative, you can make
kvmclock un-pluggable so when it's not enabled TSC frequency/offset can
remain intact. You can, of course, try to update timekeeper values to
match the new frequency/offset every time they change but rounding
errors may bite.

-- 
Vitaly
