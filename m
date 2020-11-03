Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7462A59F1
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 23:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730329AbgKCWSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 17:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730690AbgKCWSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 17:18:05 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719ACC061A04
        for <kvm@vger.kernel.org>; Tue,  3 Nov 2020 14:18:05 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id t13so9644159ilp.2
        for <kvm@vger.kernel.org>; Tue, 03 Nov 2020 14:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XZBVHEAp42vxJEHeSAw1s/YHSsTHQeeek5BWzllP8aQ=;
        b=rSkFjBdWdIlFlQRrNHk7MpZkgFdczISK78VfgOozleCL8IdGJymEn7kd7sKGjVGNNH
         qkUMp0b47wMWsBpR47TvNZ9+8GaOW158XJalFeKxeYmpB73qSRCWASoHFO7qfrxFkY2q
         44itgvvuKqtnfsVQiMiJlCa+vQIT+Hnxlq8eVVnKR4VzED5DIzZJYdlIpNlt/e+WFNkd
         Qbztp8Es7pEu4jnZsI8geHGm7Pc4W/fwAuq54TVvGG2YdMmlOmKu0vhyiOoCIZ4wPCPa
         mZfRehoHQPQ2GriBIXKKWuqMQgKGUANEYhm+88U7wB9NaehtuVOnP1Yk4zKp0bvgFXwk
         lnBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XZBVHEAp42vxJEHeSAw1s/YHSsTHQeeek5BWzllP8aQ=;
        b=grN1sAg8zt2vxWP7C4UhwxUAkpeV7L3ZjTVK6cSSmlyN037IZ2LVQo9RHvLC9HXYSc
         HQ7gR27tTei0wZgi884LHGEtEdHQ2HSelyySnId0kMNtMLsXxsAnY2qOZD+7NRrFOYig
         cmElXsTNe6EBb7d3GQxzZ1yVOjkkvOiUl0GAt/gOkiQ/0J37WykAQkGg8uKBna45ZKSo
         pUIT5oGgtXQ6btHfZf5IQcn0Z9vH9zcOt1VJnpK3zKN1epqoGpxnTtpDkLj/J4P5jB+i
         wTmBlZYclN+Rk0wUGQWC7REoOOTIcS4TMD4WqyjuhyQ5mx5Em1TBb0VS1x4mZUJwdrf2
         oa0A==
X-Gm-Message-State: AOAM533wA2e4914ytVRYguw0SG8XhWNowREfN5GgzDSkQGQoGMiHRhzX
        i0L/zORV8FsEaBBIQnRKl8JZOW4Q4OZfvuSYb6CJqg==
X-Google-Smtp-Source: ABdhPJzzuVDiPpQRe0mk0ZUT5mZva6NDqMcKGlC7H5HU6E1AIT8y6Dq4gNSgNY/iZwgJXomANne/4FN3oJbi6drx1CE=
X-Received: by 2002:a05:6e02:bcb:: with SMTP id c11mr15874080ilu.285.1604441884548;
 Tue, 03 Nov 2020 14:18:04 -0800 (PST)
MIME-Version: 1.0
References: <20201027233733.1484855-1-bgardon@google.com> <20201027233733.1484855-6-bgardon@google.com>
 <20201102222102.GE20600@xz-x1> <CANgfPd_sLtqFb3sdpBpd6FWLV4MWKHXH8TSzDbPthzVSQPMJ+A@mail.gmail.com>
 <20201103011205.GG20600@xz-x1>
In-Reply-To: <20201103011205.GG20600@xz-x1>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 3 Nov 2020 14:17:53 -0800
Message-ID: <CANgfPd-cWpZviQJj6p5qUDex8rve7N9kFK0Ym_Qt3DBU7QwqJQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] KVM: selftests: Introduce the dirty log perf test
To:     Peter Xu <peterx@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Peter Feiner <pfeiner@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 2, 2020 at 5:12 PM Peter Xu <peterx@redhat.com> wrote:
>
> On Mon, Nov 02, 2020 at 03:56:05PM -0800, Ben Gardon wrote:
> > On Mon, Nov 2, 2020 at 2:21 PM Peter Xu <peterx@redhat.com> wrote:
> > >
> > > On Tue, Oct 27, 2020 at 04:37:33PM -0700, Ben Gardon wrote:
> > > > The dirty log perf test will time verious dirty logging operations
> > > > (enabling dirty logging, dirtying memory, getting the dirty log,
> > > > clearing the dirty log, and disabling dirty logging) in order to
> > > > quantify dirty logging performance. This test can be used to inform
> > > > future performance improvements to KVM's dirty logging infrastructure.
> > >
> > > One thing to mention is that there're a few patches in the kvm dirty ring
> > > series that reworked the dirty log test quite a bit (to add similar test for
> > > dirty ring).  For example:
> > >
> > >   https://lore.kernel.org/kvm/20201023183358.50607-11-peterx@redhat.com/
> > >
> > > Just a FYI if we're going to use separate test programs.  Merging this tests
> > > should benefit in many ways, of course (e.g., dirty ring may directly runnable
> > > with the perf tests too; so we can manually enable this "perf mode" as a new
> > > parameter in dirty_log_test, if possible?), however I don't know how hard -
> > > maybe there's some good reason to keep them separate...
> >
> > Absolutely, we definitely need a performance test for both modes. I'll
> > take a look at the patch you linked and see what it would take to
> > support dirty ring in this test.
>
> That would be highly appreciated.
>
> > Do you think that should be done in this series, or would it make
> > sense to add as a follow up?
>
> To me I slightly lean toward working upon those patches, since we should
> potentially share quite some code there (e.g., the clear dirty log cleanup
> seems necessary, or not easy to add the dirty ring tests anyway).  But current
> one is still ok to me at least as initial version - we should always be more
> tolerant for test cases, aren't we? :)
>
> So maybe we can wait for a 3rd opinion before you change the direction.

I took a look at your patches for dirty ring and dirty logging modes
and thought about this some more.
I think your patch to merge the get and clear dirty log tests is
great, and I can try to include it and build on it in my series as
well if desired. I don't think it would be hard to use the same mode
approach in the dirty log perf test. That said, I think it would be
easier to keep the functional test (dirty_log_test,
clear_dirty_log_test) separate from the performance test because the
dirty log validation is extra time and complexity not needed in the
dirty log perf test. I did try building them in the same test
initially, but it was really ugly. Perhaps a future refactoring could
merge them better.

>
> >
> > >
> > > [...]
> > >
> > > > +static void run_test(enum vm_guest_mode mode, unsigned long iterations,
> > > > +                  uint64_t phys_offset, int vcpus,
> > > > +                  uint64_t vcpu_memory_bytes, int wr_fract)
> > > > +{
> > >
> > > [...]
> > >
> > > > +     /* Start the iterations */
> > > > +     iteration = 0;
> > > > +     host_quit = false;
> > > > +
> > > > +     clock_gettime(CLOCK_MONOTONIC, &start);
> > > > +     for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
> > > > +             pthread_create(&vcpu_threads[vcpu_id], NULL, vcpu_worker,
> > > > +                            &perf_test_args.vcpu_args[vcpu_id]);
> > > > +     }
> > > > +
> > > > +     /* Allow the vCPU to populate memory */
> > > > +     pr_debug("Starting iteration %lu - Populating\n", iteration);
> > > > +     while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id]) != iteration)
> > > > +             pr_debug("Waiting for vcpu_last_completed_iteration == %lu\n",
> > > > +                     iteration);
> > >
> > > Isn't array vcpu_last_completed_iteration[] initialized to all zeros?  If so, I
> > > feel like this "while" won't run as expected to wait for populating mem.
> >
> > I think you are totally right. The array should be initialized to -1,
> > which I realize isn't a uint and unsigned integer overflow is bad, so
> > the array should be converted to ints too.
> > I suppose I didn't catch this because it would just make the
> > populating pass 0 look really short and pass 1 really long. I remember
> > seeing that behavior but not realizing that it was caused by a test
> > bug. I will correct this, thank you for pointing that out.
> >
> > >
> > > The flooding pr_debug() seems a bit scary too if the mem size is huge..  How
> > > about a pr_debug() after the loop (so if we don't see that it means it hanged)?
> >
> > I don't think the number of messages on pr_debug will be proportional
> > to the size of memory, but rather the product of iterations and vCPUs.
> > That said, that's still a lot of messages.
>
> The guest code dirties all pages, and that process is proportional to the size
> of memory, no?
>
> Btw since you mentioned vcpus - I also feel like above chunk should be put into
> the for loop above...

Ooof I misread my code. You're totally right. I'll fix that by
removing the print there.

>
> > My assumption was that if you've gone to the trouble to turn on debug
> > logging, it's easier to comment log lines out than add them, but I'm
> > also happy to just move this to a single message after the loop.
>
> Yah that's subjective too - feel free to keep whatever you prefer.  In all
> cases, hopefully I won't even need to enable pr_debug at all. :)
>
> --
> Peter Xu
>
