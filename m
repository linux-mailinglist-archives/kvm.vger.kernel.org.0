Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B2A44DF59
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 01:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbhKLAzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 19:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234519AbhKLAzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 19:55:05 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FFBC061766
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 16:52:15 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id e7so738066ljq.12
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 16:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WrlBdyULknRIKwIm3EIvAheCMwIk+3VqMQRUIZGkFS4=;
        b=Qq4ew42BXjP0Lt7BFuh9h5Gxyqk2IiVFP2rmnbLz794HFjhsCMb0jOkhaTY832BFH+
         qVb9E2aOaD/hSVz5gIj0uMr0O0sNL03r0rXQ9F9/h8duOup01Fo73B4W6IIYKrj9rgdj
         Z8wxdEUJoyKPbL6uVQaAomETW+ql7ZW0BhcGkFNnqOOotzoS5S1FR/AwYik7Lq8kztsk
         N4/hNjfkHaWEP/T1kKUjvRlR399sdDK016jppAv0Ma22PbzIs0kPgSfiLOyetPj3Q+AP
         3CGImudR5iAbS8wibS7O2eg3NRq5nGayX76oDF6wAKB4kw2gwFtNoZ8oyXe57Q8gAEVY
         z8dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WrlBdyULknRIKwIm3EIvAheCMwIk+3VqMQRUIZGkFS4=;
        b=YVhJVhBcNYPiRi0a+akhF/z3EJ1A2ukPgHxzlkrI/4GkIx+dW77PrJb87HVJAmF7zb
         3geLh15JlkQUzugVvyJ8FEarprL9z/h02POns+nBk7DVTugBXCslEakoLHaPXv2GlDAH
         MLhsoFAOuSu6E9wb+wxhfdA4wlcA65iFT6gAkQCSnYc/MgEX0cEfvjuA0MD0hOUxla8O
         H1kYGw3yEGxck60uIBk9ahBbPbpDYtyhmViFUBPFSBNRSxYqhKdTJExK6R4rKQwKV28Q
         L6Lv/zDdg5hTxSW+OhJh1vYHO8ZwHuaL8vb7UkaFY4LTFmRFzRhiO8DyQjrvK+I0P2eS
         C3qA==
X-Gm-Message-State: AOAM533LVYqwRDi0x67GEge1FIpDkjC8yMsNC2vaFwjDm8lBXyvI5O5F
        bMdecdlhA0ITBqcWViiTXj0b4shdkE8oNhihgEy9pA==
X-Google-Smtp-Source: ABdhPJxIvCe8xMy055XVewCYPrE4zQnCcgj2mGakbJ1eDefxvLWAWiELgqxod3x8P9ryc49+2XEM8263HxZZIa6beP8=
X-Received: by 2002:a2e:a22a:: with SMTP id i10mr11274500ljm.16.1636678333529;
 Thu, 11 Nov 2021 16:52:13 -0800 (PST)
MIME-Version: 1.0
References: <20211111001257.1446428-1-dmatlack@google.com> <20211111001257.1446428-4-dmatlack@google.com>
 <CANgfPd-Gzjvhs0HxCZZtJqmG31rNJ71XFo_SXD9Bbpa3S2E-gg@mail.gmail.com>
In-Reply-To: <CANgfPd-Gzjvhs0HxCZZtJqmG31rNJ71XFo_SXD9Bbpa3S2E-gg@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 11 Nov 2021 16:51:47 -0800
Message-ID: <CALzav=e3hjSf_RDM3WUuv=n0gnL_6XGrqBcP99BtAQ_mHZOpdw@mail.gmail.com>
Subject: Re: [PATCH 3/4] KVM: selftests: Wait for all vCPU to be created
 before entering guest mode
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 11, 2021 at 10:17 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Wed, Nov 10, 2021 at 4:13 PM David Matlack <dmatlack@google.com> wrote:
> >
> > Thread creation requires taking the mmap_sem in write mode, which causes
> > vCPU threads running in guest mode to block while they are populating
> > memory. Fix this by waiting for all vCPU threads to be created and start
> > running before entering guest mode on any one vCPU thread.
> >
> > This substantially improves the "Populate memory time" when using 1GiB
> > pages since it allows all vCPUs to zero pages in parallel rather than
> > blocking because a writer is waiting (which is waiting for another vCPU
> > that is busy zeroing a 1GiB page).
> >
> > Before:
> >
> >   $ ./dirty_log_perf_test -v256 -s anonymous_hugetlb_1gb
> >   ...
> >   Populate memory time: 52.811184013s
> >
> > After:
> >
> >   $ ./dirty_log_perf_test -v256 -s anonymous_hugetlb_1gb
> >   ...
> >   Populate memory time: 10.204573342s
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  .../selftests/kvm/lib/perf_test_util.c        | 26 +++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > index d646477ed16a..722df3a28791 100644
> > --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> > +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > @@ -22,6 +22,9 @@ struct vcpu_thread {
> >
> >         /* The pthread backing the vCPU. */
> >         pthread_t thread;
> > +
> > +       /* Set to true once the vCPU thread is up and running. */
> > +       bool running;
> >  };
> >
> >  /* The vCPU threads involved in this test. */
> > @@ -30,6 +33,9 @@ static struct vcpu_thread vcpu_threads[KVM_MAX_VCPUS];
> >  /* The function run by each vCPU thread, as provided by the test. */
> >  static void (*vcpu_thread_fn)(struct perf_test_vcpu_args *);
> >
> > +/* Set to true once all vCPU threads are up and running. */
> > +static bool all_vcpu_threads_running;
> > +
> >  /*
> >   * Continuously write to the first 8 bytes of each page in the
> >   * specified region.
> > @@ -196,6 +202,17 @@ static void *vcpu_thread_main(void *data)
> >  {
> >         struct vcpu_thread *vcpu = data;
> >
> > +       WRITE_ONCE(vcpu->running, true);
> > +
> > +       /*
> > +        * Wait for all vCPU threads to be up and running before calling the test-
> > +        * provided vCPU thread function. This prevents thread creation (which
> > +        * requires taking the mmap_sem in write mode) from interfering with the
> > +        * guest faulting in its memory.
> > +        */
> > +       while (!READ_ONCE(all_vcpu_threads_running))
> > +               ;
> > +
>
> I can never remember the rules on this so I could be wrong, but you
> may want a cpu_relax() in that loop to prevent it from being optimized
> out. Maybe the READ_ONCE is sufficient though.

READ_ONCE is sufficient to prevent the loop from being optimized out
but cpu_relax() is nice to have to play nice with our hyperthread
buddy.

On that note there are a lot of spin waits in the KVM selftests and
none of the ones I've seen use cpu_relax().

I'll take a look at adding cpu_relax() throughout the selftests in v2.

>
> >         vcpu_thread_fn(&perf_test_args.vcpu_args[vcpu->vcpu_id]);
> >
> >         return NULL;
> > @@ -206,14 +223,23 @@ void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vc
> >         int vcpu_id;
> >
> >         vcpu_thread_fn = vcpu_fn;
> > +       WRITE_ONCE(all_vcpu_threads_running, false);
> >
> >         for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
> >                 struct vcpu_thread *vcpu = &vcpu_threads[vcpu_id];
> >
> >                 vcpu->vcpu_id = vcpu_id;
> > +               WRITE_ONCE(vcpu->running, false);
>
> Do these need to be WRITE_ONCE? I don't think WRITE_ONCE provides any
> extra memory ordering guarantees and I don't know why the compiler
> would optimize these out. If they do need to be WRITE_ONCE, they
> probably merit comments.

To be completely honest I'm not sure. I included WRITE_ONCE out of
caution to ensure the compiler does not reorder the writes with
respect to the READ_ONCE. I'll need to do a bit more research to
confirm if it's really necessary.

>
> >
> >                 pthread_create(&vcpu->thread, NULL, vcpu_thread_main, vcpu);
> >         }
> > +
> > +       for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
> > +               while (!READ_ONCE(vcpu_threads[vcpu_id].running))
> > +                       ;
> > +       }
> > +
> > +       WRITE_ONCE(all_vcpu_threads_running, true);
> >  }
> >
> >  void perf_test_join_vcpu_threads(int vcpus)
> > --
> > 2.34.0.rc1.387.gb447b232ab-goog
> >
