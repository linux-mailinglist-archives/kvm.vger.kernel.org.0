Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A766444EB67
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 17:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhKLQfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 11:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhKLQe7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 11:34:59 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F8EC061766
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 08:32:08 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so7463960pju.3
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 08:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AOGD3KRHTD+DVsnVQDWLy4b40DVugq6sLN1c4JOanrY=;
        b=Ku52ls4HytULudGDqs9o7vDtqD/tXWsFJCBNsTmQK2ruYPvlTmxUNpOGz0L+Pn3DfG
         r+qkz/c9To9HClV0qJxm1k6qqQd4bKEMdvrMxWlOKM1+p67CAZR4fHj5MuTCBAv7oINz
         o6Xp85sfnz9PBVqOVip7Xi81Gcpn3NZp0TesaxNh0pyIWLMzf1SGQbou+2Eq5KDaVLJO
         RfDD2MFFZ8+2WkZ8GdIUgR8LENafV4LCgPcdUqjzph/Y5Xfd/C1rph0RdgLg5giIO78e
         gHISHjiKCgEy89cPOs1hMOk7a7P5E3YaeynaL5+Gt5LgXAzDAel//9Yaqc9XHrzPl24T
         pBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AOGD3KRHTD+DVsnVQDWLy4b40DVugq6sLN1c4JOanrY=;
        b=KIXt3Dq1B8L2yCFId7/TMZy8V29kPxSJIlAvObDi65MQy46rEa2qGfH2e9BPc3CcMK
         MlnZEWyL1Zwe9jsRJMJM95OXGwlT/MvXyQcrEOmDrV+xrFKAtUSvqgMapeihQVm2DmCv
         qtN3o5FjPcheHVk936rkAMtSKV+THbCwvn7sIVXFTNLT4TuL2MhgOD9KXtOjwQSQKGvx
         W37tmSeTw6GltZ0rXMY41/A7e3d1wIa9gceCRbTBhAZGg+ft2IqIqIDYfCBE0oiXUWFh
         PiD3BZ1MbACukhww2hpUiSLQxWVIkl+ACMD/mjVvgPcsy8gyLo19tOeyqZUX+4eiw/PH
         urNw==
X-Gm-Message-State: AOAM532joR927a9gbyb/NJdXcYCAUdK6QmIWrcSYd3n3FDtu/RgSv3jC
        uUX2pOtYKEOA6dc71whEJQg3IQ==
X-Google-Smtp-Source: ABdhPJzlZ2m+LsuM/R8t85T3syLLyAKU7QFbF6vpT9iXKqSA7OFbYJdPH6aNGDA984MxxZ45iDSATw==
X-Received: by 2002:a17:90a:49:: with SMTP id 9mr37635775pjb.80.1636734727989;
        Fri, 12 Nov 2021 08:32:07 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v2sm6364648pfg.115.2021.11.12.08.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 08:32:07 -0800 (PST)
Date:   Fri, 12 Nov 2021 16:32:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH 3/4] KVM: selftests: Wait for all vCPU to be created
 before entering guest mode
Message-ID: <YY6XA4U1hRcbaG32@google.com>
References: <20211111001257.1446428-1-dmatlack@google.com>
 <20211111001257.1446428-4-dmatlack@google.com>
 <CANgfPd-Gzjvhs0HxCZZtJqmG31rNJ71XFo_SXD9Bbpa3S2E-gg@mail.gmail.com>
 <CALzav=e3hjSf_RDM3WUuv=n0gnL_6XGrqBcP99BtAQ_mHZOpdw@mail.gmail.com>
 <CALzav=fxuU9_jP7q3=qm5LYXbVkR-qUORR=EeiiOqa_GneZVdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=fxuU9_jP7q3=qm5LYXbVkR-qUORR=EeiiOqa_GneZVdQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 11, 2021, David Matlack wrote:
> On Thu, Nov 11, 2021 at 4:51 PM David Matlack <dmatlack@google.com> wrote:
> > > > @@ -196,6 +202,17 @@ static void *vcpu_thread_main(void *data)
> > > >  {
> > > >         struct vcpu_thread *vcpu = data;
> > > >
> > > > +       WRITE_ONCE(vcpu->running, true);
> > > > +
> > > > +       /*
> > > > +        * Wait for all vCPU threads to be up and running before calling the test-
> > > > +        * provided vCPU thread function. This prevents thread creation (which
> > > > +        * requires taking the mmap_sem in write mode) from interfering with the
> > > > +        * guest faulting in its memory.
> > > > +        */
> > > > +       while (!READ_ONCE(all_vcpu_threads_running))

This is way more convoluted than it needs to be:

	atomic_inc(&perf_test_args.nr_running_vcpus);

	while (atomic_read(&perf_test_args.nr_running_vcpus) < perf_test_args.nr_vcpus)
		cpu_relax();

diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index df9f1a3a3ffb..ce9039ec8c18 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -30,6 +30,8 @@ struct perf_test_args {
        uint64_t host_page_size;
        uint64_t guest_page_size;
        int wr_fract;
+       int nr_vcpus;
+       atomic_t nr_running_vcpus;
 
        struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
 };


Alternatively it could be a countdown to zero so that only the atomic_t is needed.


> > > I can never remember the rules on this so I could be wrong, but you
> > > may want a cpu_relax() in that loop to prevent it from being optimized
> > > out. Maybe the READ_ONCE is sufficient though.
> >
> > READ_ONCE is sufficient to prevent the loop from being optimized out
> > but cpu_relax() is nice to have to play nice with our hyperthread
> > buddy.
> >
> > On that note there are a lot of spin waits in the KVM selftests and
> > none of the ones I've seen use cpu_relax().
> >
> > I'll take a look at adding cpu_relax() throughout the selftests in v2.
> >
> > >
> > > >         vcpu_thread_fn(&perf_test_args.vcpu_args[vcpu->vcpu_id]);
> > > >
> > > >         return NULL;
> > > > @@ -206,14 +223,23 @@ void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vc
> > > >         int vcpu_id;
> > > >
> > > >         vcpu_thread_fn = vcpu_fn;
> > > > +       WRITE_ONCE(all_vcpu_threads_running, false);
> > > >
> > > >         for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
> > > >                 struct vcpu_thread *vcpu = &vcpu_threads[vcpu_id];
> > > >
> > > >                 vcpu->vcpu_id = vcpu_id;
> > > > +               WRITE_ONCE(vcpu->running, false);
> > >
> > > Do these need to be WRITE_ONCE? I don't think WRITE_ONCE provides any
> > > extra memory ordering guarantees and I don't know why the compiler
> > > would optimize these out. If they do need to be WRITE_ONCE, they
> > > probably merit comments.
> >
> > To be completely honest I'm not sure. I included WRITE_ONCE out of
> > caution to ensure the compiler does not reorder the writes with
> > respect to the READ_ONCE. I'll need to do a bit more research to
> > confirm if it's really necessary.
> 
> FWIW removing WRITE_ONCE and bumping the optimization level up to O3
> did not cause any problems. But this is no proof of course.
> 
> This quote from memory-barries.txt makes me think it'd be prudent to
> keep the WRITE_ONCE:
> 
>      You should assume that the compiler can move READ_ONCE() and
>      WRITE_ONCE() past code not containing READ_ONCE(), WRITE_ONCE(),
>      barrier(), or similar primitives.
> 
> So, for example, the compiler could potentially re-order READ_ONCE
> loop below after the write to all_vcpu_threads_running if we did not
> include WRITE_ONCE?

Practically speaking, no.  pthread_create() undoubtedly has barriers galore, so
unless @vcpus==0, all_vcpu_threads_running won't get re-ordered.

As noted above, READ_ONCE/WRITE_ONCE do provide _some_ guarantees about memory
ordering with respect to the _compiler_.  Notably, the compiler is allowed to
reorder non-ONCE loads/stores around {READ,WRITE}_ONCE.  And emphasis on "compiler".
On x86, that's effectively the same as memory ordering in hardware, because ignoring
WC memory, x86 is strongy ordered.  But arm64 and others are weakly ordered, in
which case {READ,WRITE}_ONCE do not provide any guarantees about how loads/stores
will complete when run on the CPU.

This is a bad example because there's not really a race to be had, e.g. aside from
pthread_create(), there's also the fact that all_vcpu_threads_running=false is a
likely nop since it's zero initialized.  

Here's a contrived example:

static void *vcpu_thread_main(void *data)
{
	while (!READ_ONCE(test_stage))
		cpu_relax();

	READ_ONCE(test_fn)();
}


int main(...)
{
	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++)
		pthread_create(&vcpu->thread, NULL, vcpu_thread_main, vcpu);

	test_fn = do_work;

	WRITE_ONCE(test_stage, 1);
}

On any architecture, the thread could observe a NULL test_fn because it's allowed
to reorder the store to test_fn around the store to test_stage.  Making it

	WRITE_ONCE(test_fn, do_work);
	WRITE_ONCE(test_stage, 1);

would solve the problem on x86 as it would effectively force the compiler to emit:

	test_stage = 0
	barrier() // because of pthread_create()
	test_fn    = do_work
	test_stage = 1

but on arm64 and others, hardware can complete the second store to test_stage
_before_ the store to test_fn, and so the threads could observe a NULL test_fn
even though the compiler was forced to generate a specific order of operations.

To ensure something like the above works on weakly-ordered architctures, the code
would should instead be something like:

static void *vcpu_thread_main(void *data)
{
        while (!READ_ONCE(test_stage))
                cpu_relax();

	smp_rmb();
        test_fn();
}

int main(...)
{
        for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++)
                pthread_create(&vcpu->thread, NULL, vcpu_thread_main, vcpu);

        test_fn = do_work;
	smp_wmb();
        test_stage = 1;
}

Final note, the READ_ONCE() in the while loop is still necessary because without
that the compiler would be allowed to assume that test_stage can't be changed
in that loop, e.g. on x86 could generate the following hang the task:

	mov [test_stage], %rax
1:	test %rax, %rax
	jnz 2f
	pause
	jmp 1b
2:
