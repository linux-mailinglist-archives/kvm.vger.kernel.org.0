Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603946FFACE
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 21:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239353AbjEKTsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 15:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239336AbjEKTrk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 15:47:40 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866F51FE1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 12:46:47 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id af79cd13be357-7576ecfa4e7so594100085a.3
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 12:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683834368; x=1686426368;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zB5JTYTzbjxzfAcUGW7YtQ3w09yA53VmJwoy9w9h8Mk=;
        b=MSYO5oY101nXNgFFS5INBeg2REcRI+bKb25dJwtMCcKSB3EDAEemoJ2RsN/mt5/vp1
         XDxFf+aX8AYgEWlwhXjccCnosCqiGBVJ8BxykT5Q2LDiiX6CwItdMnjLwWH+n8jjD8bv
         SdFHVLaBMUdKsNEeFF436uQekPut9i21dLMCrLpbR8Jzs8mHk+x0Z3j9Zt7/bO+1WNNW
         vDf3laD/eLstGDdoy9XZ9dZfGnm/cPqR4dMLS5VwI/PjdDOTznc7dhfy7hPAtGy+Gjzc
         OIA+E//Ow0LYcHpjyvdF0t9UMzZQdsK88GfkViGJUPSBP4b0YAruoE9aCphuzmEc+Tc/
         D+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683834368; x=1686426368;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zB5JTYTzbjxzfAcUGW7YtQ3w09yA53VmJwoy9w9h8Mk=;
        b=CX2QkQxWN6XsUK5N3xcfHT+LKfacGDVzo8JJba5hZthiSHNrzfsd2vOzo8Am63wQkk
         wS8qDvKeHXiwHLDkrLqIufR9iepWyl+fQKEayD6kNUPBwadzNGT5YroRL9xG77VoRz24
         YbuFpIW9ErWW3Dm8b2FNUevz8Zy4jt7FeJbc/tMlx2Zzm2x/BzuZe8MHW6LOqiLiPvOJ
         3fLMpeOQbBc039MAaC1mQbb4IG9kyH+SGzuGuWyC7pEUN+IjJYATkh1xAbNJvOwLM9gt
         X4E5ouYcyk1mTNiLWZ2W4DSWJbpqSrZX1HQp1CAgRmq47kenLVneaciiKIXcdFwmJKap
         wtMw==
X-Gm-Message-State: AC+VfDxAFyNHqy/nXqfYCNHsAmGlugUIMNtE69YN2L/cwX6SK/21nxEO
        pjYnEvUI/4XvBuHEvXr6HtmJFL7Xyl/zejMDdfPuzA==
X-Google-Smtp-Source: ACHHUZ4192j+G1w1msXArHzmReLPzl2xDtf2sGnLdLch/KHNXXd/yT2Q/my6BF1ZMFaye4VbWvxXT2hCMleHgbz6G7k=
X-Received: by 2002:a05:6214:c8f:b0:621:451b:6e1b with SMTP id
 r15-20020a0562140c8f00b00621451b6e1bmr13275772qvr.10.1683834368475; Thu, 11
 May 2023 12:46:08 -0700 (PDT)
MIME-Version: 1.0
References: <ZFLRpEV09lrpJqua@x1n> <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n> <ZFQC5TZ9tVSvxFWt@x1n> <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
 <ZFhO9dlaFQRwaPFa@x1n> <CAF7b7mqPdfbzj6cOWPsg+Owysc-SOTF+6UUymd9f0Mctag=8DQ@mail.gmail.com>
 <ZFwRuCuYYMtuUFFA@x1n> <CALzav=e29rRw4TTRGpTkazgJpU1zPML3zQGoyeHj9Zbkq+yAdQ@mail.gmail.com>
 <CAJHvVci4VuQ_vdpRKczg4ic6x7eZRXE4+ZUvzO-xU_9VJ1Vqvg@mail.gmail.com> <ZF08Zg90emoDJJIp@google.com>
In-Reply-To: <ZF08Zg90emoDJJIp@google.com>
From:   Axel Rasmussen <axelrasmussen@google.com>
Date:   Thu, 11 May 2023 12:45:32 -0700
Message-ID: <CAJHvVciW4NZ6Jztq_ojsQD6vzD1duyXc7VG4iZyMR1-p=V_yzw@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To:     David Matlack <dmatlack@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Anish Moorthy <amoorthy@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
        bgardon@google.com, ricarkol@google.com, kvm <kvm@vger.kernel.org>,
        kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023 at 12:05=E2=80=AFPM David Matlack <dmatlack@google.com=
> wrote:
>
> On Thu, May 11, 2023 at 10:33:24AM -0700, Axel Rasmussen wrote:
> > On Thu, May 11, 2023 at 10:18=E2=80=AFAM David Matlack <dmatlack@google=
.com> wrote:
> > >
> > > On Wed, May 10, 2023 at 2:50=E2=80=AFPM Peter Xu <peterx@redhat.com> =
wrote:
> > > > On Tue, May 09, 2023 at 01:52:05PM -0700, Anish Moorthy wrote:
> > > > > On Sun, May 7, 2023 at 6:23=E2=80=AFPM Peter Xu <peterx@redhat.co=
m> wrote:
> > > >
> > > > What I wanted to do is to understand whether there's still chance t=
o
> > > > provide a generic solution.  I don't know why you have had a bunch =
of pmu
> > > > stack showing in the graph, perhaps you forgot to disable some of t=
he perf
> > > > events when doing the test?  Let me know if you figure out why it h=
appened
> > > > like that (so far I didn't see), but I feel guilty to keep overload=
ing you
> > > > with such questions.
> > > >
> > > > The major problem I had with this series is it's definitely not a c=
lean
> > > > approach.  Say, even if you'll all rely on userapp you'll still nee=
d to
> > > > rely on userfaultfd for kernel traps on corner cases or it just won=
't work.
> > > > IIUC that's also the concern from Nadav.
> > >
> > > This is a long thread, so apologies if the following has already been=
 discussed.
> > >
> > > Would per-tid userfaultfd support be a generic solution? i.e. Allow
> > > userspace to create a userfaultfd that is tied to a specific task. An=
y
> > > userfaults encountered by that task use that fd, rather than the
> > > process-wide fd. I'm making the assumption here that each of these fd=
s
> > > would have independent signaling mechanisms/queues and so this would
> > > solve the scaling problem.
> > >
> > > A VMM could use this to create 1 userfaultfd per vCPU and 1 thread pe=
r
> > > vCPU for handling userfault requests. This seems like it'd have
> > > roughly the same scalability characteristics as the KVM -EFAULT
> > > approach.
> >
> > I think this would work in principle, but it's significantly different
> > from what exists today.
> >
> > The splitting of userfaultfds Peter is describing is splitting up the
> > HVA address space, not splitting per-thread.
> >
> > I think for this design, we'd need to change UFFD registration so
> > multiple UFFDs can register the same VMA, but can be filtered so they
> > only receive fault events caused by some particular tid(s).
> >
> > This might also incur some (small?) overhead, because in the fault
> > path we now need to maintain some data structure so we can lookup
> > which UFFD to notify based on a combination of the address and our
> > tid. Today, since VMAs and UFFDs are 1:1 this lookup is trivial.
>
> I was (perhaps naively) assuming the lookup would be as simple as:
>
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index 44d1ee429eb0..e9856e2ba9ef 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -417,7 +417,10 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, un=
signed long reason)
>          */
>         mmap_assert_locked(mm);
>
> -       ctx =3D vma->vm_userfaultfd_ctx.ctx;
> +       if (current->userfaultfd_ctx)
> +               ctx =3D current->userfaultfd_ctx;
> +       else
> +               ctx =3D vma->vm_userfaultfd_ctx.ctx;
>         if (!ctx)
>                 goto out;

Hmm, perhaps. It might have to be more complicated if we want to allow
a single task to have both per-TID UFFDs for some addresses, and
"global" UFFDs for others.



Actually, while thinking about this, another wrinkle:

Imagine we have per-thread UFFDs. Thread X faults on some address, and
goes to sleep waiting for its paired resolver thread to resolve the
fault.

In the meantime, thread Y also faults on the same address, before the
resolution happens.

In the existing model, there is a single UFFD context per VMA, and
therefore a single wait queue for all threads to wait on. In the
per-TID-UFFD design, now each thread has its own context, and
ostensibly its own wait queue (since the wait queue locks are where
Anish saw the contention, I think this is exactly what we want to
split up). When we have this "multiple threads waiting on the same
address" situation, how do we ensure the fault is resolved exactly
once? And how do we wake up all of the sleeping threads when it is
resolved?

I'm sure it's solvable, but especially doing it without any locks /
contention seems like it could be a bit complicated.

>
> >
> > I think it's worth keeping in mind that a selling point of Anish's
> > approach is that it's a very small change. It's plausible we can come
> > up with some alternative way to scale, but it seems to me everything
> > suggested so far is likely to require a lot more code, complexity, and
> > effort vs. Anish's approach.
>
> Agreed.
>
> Mostly I think the per-thread UFFD approach would add complexity on the
> userspace side of things. With Anish's approach userspace is able to
> trivially re-use the vCPU thread (and it's associated pCPU if pinned) to
> handle the request. That gets more complicated when juggling the extra
> paired threads.
>
> The per-thread approach would requires a new userfault UAPI change which
> I think is a higher bar than the KVM UAPI change proposed here.
>
> The per-thread approach would require KVM call into slow GUP and take
> the mmap_lock before contacting userspace. I'm not 100% convinced that's
> a bad thing long term (e.g. it avoids the false-positive -EFAULT exits
> in Anish's proposal), but could have performance implications.
>
> Lastly, inter-thread communication is likely slower than returning to
> userspace from KVM_RUN. So the per-thread approach might increase the
> end-to-end latency of demand fetches.
