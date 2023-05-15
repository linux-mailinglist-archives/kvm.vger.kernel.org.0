Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF5470314F
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 17:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242262AbjEOPRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 11:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242208AbjEOPRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 11:17:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8328E
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 08:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684163818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YCwcJkHP2VwXTHNzCgrgxgRUW6C/jeHxPk/Gqy5woUA=;
        b=CgpraR36VMiI9bErk5eAvoptiy6lUCB5v7EGyujrjw8Mwd1hWEjOgb6NY53oZGd5cnL7LX
        43jhy3LIysEVcwsohjfwm+L6f7XkkPqSX/4qcaW36ib4mJHMJwcbAE7EGLWTyqEe4+rGKJ
        765CXAVk+vt2FCho0waIPkVDcJCY8dY=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-dlTNkTFsOY2hwVwBI7itLQ-1; Mon, 15 May 2023 11:16:57 -0400
X-MC-Unique: dlTNkTFsOY2hwVwBI7itLQ-1
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-434817c57d9so201208137.1
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 08:16:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684163816; x=1686755816;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YCwcJkHP2VwXTHNzCgrgxgRUW6C/jeHxPk/Gqy5woUA=;
        b=j6MNey5+KTt0pIM7ZmyrJjhNsTRgzAPB3+GfqwXizsKIIizHUD7BZ8jixjznr8s+UN
         M2o15niSTH49RkBkzIcIKr689H1xuQAav98hTUxop2hDRiErBOJj4KZd197A9tfnYiYK
         W02Z9FZdVhNp6cT7/8LAg6k6+Imbab0A5PV7cz+fxnmH4xXBmOTphivH/3+Og/y94ijD
         ic7117QEFkJgep/B8i4m9SFSbmBABel6kQc23CjAbZHZNX06SW6aACk4ENKWcy0+6WAA
         pvjQWDsWQEDkDuoT+M3CHdmgyNfrgNfF/eaDA6eRIZT8eiSllUYoqZIj59SvIqfEae/L
         L4bQ==
X-Gm-Message-State: AC+VfDw8y4rvTyU5xcs3YSYBdoqSU6AQoNpDvQ5G1qgtZkBkqsnavevc
        +rPphXP+TENltEfBr6XuQ9FCNy1CfrOncsFw3v4DA6S2bkEx+YBGDQUx1i0a03/FRlo4muzetEo
        Rn9kbCyeU59YA
X-Received: by 2002:a05:6122:997:b0:443:dbd9:793d with SMTP id g23-20020a056122099700b00443dbd9793dmr11025076vkd.1.1684163816083;
        Mon, 15 May 2023 08:16:56 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5RIGq8qt/SN5aLMHlhA9iOpqU1rzwegJvYxfrc19MpJdS/SVpEbjz0oEsG3xDWVXWwnongjg==
X-Received: by 2002:a05:6122:997:b0:443:dbd9:793d with SMTP id g23-20020a056122099700b00443dbd9793dmr11025046vkd.1.1684163815688;
        Mon, 15 May 2023 08:16:55 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-62-70-24-86-62.dsl.bell.ca. [70.24.86.62])
        by smtp.gmail.com with ESMTPSA id o7-20020a05620a130700b0074df5d787f2sm443qkj.89.2023.05.15.08.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 08:16:54 -0700 (PDT)
Date:   Mon, 15 May 2023 11:16:53 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Axel Rasmussen <axelrasmussen@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
        bgardon@google.com, ricarkol@google.com, kvm <kvm@vger.kernel.org>,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZGJM5VfMT8iQJa0r@x1n>
References: <ZFLyGDoXHQrN1CCD@x1n>
 <ZFQC5TZ9tVSvxFWt@x1n>
 <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
 <ZFhO9dlaFQRwaPFa@x1n>
 <CAF7b7mqPdfbzj6cOWPsg+Owysc-SOTF+6UUymd9f0Mctag=8DQ@mail.gmail.com>
 <ZFwRuCuYYMtuUFFA@x1n>
 <CALzav=e29rRw4TTRGpTkazgJpU1zPML3zQGoyeHj9Zbkq+yAdQ@mail.gmail.com>
 <CAJHvVci4VuQ_vdpRKczg4ic6x7eZRXE4+ZUvzO-xU_9VJ1Vqvg@mail.gmail.com>
 <ZF08Zg90emoDJJIp@google.com>
 <CAJHvVciW4NZ6Jztq_ojsQD6vzD1duyXc7VG4iZyMR1-p=V_yzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHvVciW4NZ6Jztq_ojsQD6vzD1duyXc7VG4iZyMR1-p=V_yzw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023 at 12:45:32PM -0700, Axel Rasmussen wrote:
> On Thu, May 11, 2023 at 12:05 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Thu, May 11, 2023 at 10:33:24AM -0700, Axel Rasmussen wrote:
> > > On Thu, May 11, 2023 at 10:18 AM David Matlack <dmatlack@google.com> wrote:
> > > >
> > > > On Wed, May 10, 2023 at 2:50 PM Peter Xu <peterx@redhat.com> wrote:
> > > > > On Tue, May 09, 2023 at 01:52:05PM -0700, Anish Moorthy wrote:
> > > > > > On Sun, May 7, 2023 at 6:23 PM Peter Xu <peterx@redhat.com> wrote:
> > > > >
> > > > > What I wanted to do is to understand whether there's still chance to
> > > > > provide a generic solution.  I don't know why you have had a bunch of pmu
> > > > > stack showing in the graph, perhaps you forgot to disable some of the perf
> > > > > events when doing the test?  Let me know if you figure out why it happened
> > > > > like that (so far I didn't see), but I feel guilty to keep overloading you
> > > > > with such questions.
> > > > >
> > > > > The major problem I had with this series is it's definitely not a clean
> > > > > approach.  Say, even if you'll all rely on userapp you'll still need to
> > > > > rely on userfaultfd for kernel traps on corner cases or it just won't work.
> > > > > IIUC that's also the concern from Nadav.
> > > >
> > > > This is a long thread, so apologies if the following has already been discussed.
> > > >
> > > > Would per-tid userfaultfd support be a generic solution? i.e. Allow
> > > > userspace to create a userfaultfd that is tied to a specific task. Any
> > > > userfaults encountered by that task use that fd, rather than the
> > > > process-wide fd. I'm making the assumption here that each of these fds
> > > > would have independent signaling mechanisms/queues and so this would
> > > > solve the scaling problem.
> > > >
> > > > A VMM could use this to create 1 userfaultfd per vCPU and 1 thread per
> > > > vCPU for handling userfault requests. This seems like it'd have
> > > > roughly the same scalability characteristics as the KVM -EFAULT
> > > > approach.
> > >
> > > I think this would work in principle, but it's significantly different
> > > from what exists today.
> > >
> > > The splitting of userfaultfds Peter is describing is splitting up the
> > > HVA address space, not splitting per-thread.
> > >
> > > I think for this design, we'd need to change UFFD registration so
> > > multiple UFFDs can register the same VMA, but can be filtered so they
> > > only receive fault events caused by some particular tid(s).
> > >
> > > This might also incur some (small?) overhead, because in the fault
> > > path we now need to maintain some data structure so we can lookup
> > > which UFFD to notify based on a combination of the address and our
> > > tid. Today, since VMAs and UFFDs are 1:1 this lookup is trivial.
> >
> > I was (perhaps naively) assuming the lookup would be as simple as:
> >
> > diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> > index 44d1ee429eb0..e9856e2ba9ef 100644
> > --- a/fs/userfaultfd.c
> > +++ b/fs/userfaultfd.c
> > @@ -417,7 +417,10 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
> >          */
> >         mmap_assert_locked(mm);
> >
> > -       ctx = vma->vm_userfaultfd_ctx.ctx;
> > +       if (current->userfaultfd_ctx)
> > +               ctx = current->userfaultfd_ctx;
> > +       else
> > +               ctx = vma->vm_userfaultfd_ctx.ctx;
> >         if (!ctx)
> >                 goto out;

This is an interesting idea, but I'll just double check before I grow
task_struct and see whether that's the only solution. :)

I'd start with hash(tid) or even hash(pcpu) to choose queue.  In a pinned
use case hash(pcpu) should probably reach a similar goal here (and I'd
guess hash(tid) too if vcpus are mostly always created in one shot, just
slightly trickier).

> 
> Hmm, perhaps. It might have to be more complicated if we want to allow
> a single task to have both per-TID UFFDs for some addresses, and
> "global" UFFDs for others.
> 
> 
> 
> Actually, while thinking about this, another wrinkle:
> 
> Imagine we have per-thread UFFDs. Thread X faults on some address, and
> goes to sleep waiting for its paired resolver thread to resolve the
> fault.
> 
> In the meantime, thread Y also faults on the same address, before the
> resolution happens.
> 
> In the existing model, there is a single UFFD context per VMA, and
> therefore a single wait queue for all threads to wait on. In the
> per-TID-UFFD design, now each thread has its own context, and
> ostensibly its own wait queue (since the wait queue locks are where
> Anish saw the contention, I think this is exactly what we want to
> split up). When we have this "multiple threads waiting on the same
> address" situation, how do we ensure the fault is resolved exactly
> once? And how do we wake up all of the sleeping threads when it is
> resolved?

We probably need to wake them one by one in that case.  The 2nd-Nth
UFFDIO_COPY/CONTINUE will fail with -EEXIST anyway, then the userapp will
need a UFFDIO_WAKE I assume.

> 
> I'm sure it's solvable, but especially doing it without any locks /
> contention seems like it could be a bit complicated.

IMHO no complicated locking is needed.  Here the "complicated locking" is
done with pgtable lock and it should be reflected by -EEXISTs to userapp.

> 
> >
> > >
> > > I think it's worth keeping in mind that a selling point of Anish's
> > > approach is that it's a very small change. It's plausible we can come
> > > up with some alternative way to scale, but it seems to me everything
> > > suggested so far is likely to require a lot more code, complexity, and
> > > effort vs. Anish's approach.
> >
> > Agreed.
> >
> > Mostly I think the per-thread UFFD approach would add complexity on the
> > userspace side of things. With Anish's approach userspace is able to
> > trivially re-use the vCPU thread (and it's associated pCPU if pinned) to
> > handle the request. That gets more complicated when juggling the extra
> > paired threads.
> >
> > The per-thread approach would requires a new userfault UAPI change which
> > I think is a higher bar than the KVM UAPI change proposed here.
> >
> > The per-thread approach would require KVM call into slow GUP and take
> > the mmap_lock before contacting userspace. I'm not 100% convinced that's
> > a bad thing long term (e.g. it avoids the false-positive -EFAULT exits
> > in Anish's proposal), but could have performance implications.
> >
> > Lastly, inter-thread communication is likely slower than returning to
> > userspace from KVM_RUN. So the per-thread approach might increase the
> > end-to-end latency of demand fetches.

Right.  The overhead here is (IMHO):

  - KVM solution: vcpu exit -> enter again, whatever happens in the
    procedure of exit/enter will count.

  - mm solution: at least schedule overhead, meanwhile let's hope we can
    scale first elsewhere (and I'm not sure if there'll be other issues,
    e.g., even if we can split the uffd queues, hopefully totally nowhere I
    overlooked that still need the shared uffd context)

I'm not sure which one will be higher or maybe it depends (e.g., some
specific cases where vcpu KVM_RUN can have higher overhead when loading?).

Thanks,

-- 
Peter Xu

